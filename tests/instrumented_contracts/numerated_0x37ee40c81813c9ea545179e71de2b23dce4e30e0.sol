1 pragma solidity ^0.4.15;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) constant returns (uint256);
33   function transfer(address to, uint256 value) returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   /**
43   * @dev transfer token for a specified address
44   * @param _to The address to transfer to.
45   * @param _value The amount to be transferred.
46   */
47   function transfer(address _to, uint256 _value) returns (bool) {
48     require(_to != address(0));
49 
50     // SafeMath.sub will throw if there is not enough balance.
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   /**
58   * @dev Gets the balance of the specified address.
59   * @param _owner The address to query the the balance of.
60   * @return An uint256 representing the amount owned by the passed address.
61   */
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) returns (bool);
70   function approve(address spender, uint256 value) returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amount of tokens to be transferred
84    */
85   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
86     require(_to != address(0));
87 
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 
128   /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134   function increaseApproval (address _spender, uint _addedValue)
135     returns (bool success) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval (address _spender, uint _subtractedValue)
142     returns (bool success) {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145       allowed[msg.sender][_spender] = 0;
146     } else {
147       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 }
153 
154 /// @title Token contract - Implements Standard Token Interface with DNN features.
155 /// @author Dondrey Taylor - <dondrey@dnn.media>
156 contract DNNToken is StandardToken {
157 
158     using SafeMath for uint256;
159 
160     ////////////////////////////////////////////////////////////
161     // Used to indicate which allocation we issue tokens from //
162     ////////////////////////////////////////////////////////////
163     enum DNNSupplyAllocations {
164         EarlyBackerSupplyAllocation,
165         PRETDESupplyAllocation,
166         TDESupplyAllocation,
167         BountySupplyAllocation,
168         WriterAccountSupplyAllocation,
169         AdvisorySupplyAllocation,
170         PlatformSupplyAllocation
171     }
172 
173     /////////////////////////////////////////////////////////////////////
174     // Smart-Contract with permission to allocate tokens from supplies //
175     /////////////////////////////////////////////////////////////////////
176     address public allocatorAddress;
177     address public crowdfundContract;
178 
179     /////////////////////
180     // Token Meta Data //
181     /////////////////////
182     string constant public name = "DNN";
183     string constant public symbol = "DNN";
184     uint8 constant public decimals = 18; // 1 DNN = 1 * 10^18 atto-DNN
185 
186     /////////////////////////////////////////
187     // Addresses of the co-founders of DNN //
188     /////////////////////////////////////////
189     address public cofounderA;
190     address public cofounderB;
191 
192     /////////////////////////
193     // Address of Platform //
194     /////////////////////////
195     address public platform;
196 
197     /////////////////////////////////////////////
198     // Token Distributions (% of total supply) //
199     /////////////////////////////////////////////
200     uint256 public earlyBackerSupply; // 10%
201     uint256 public PRETDESupply; // 10%
202     uint256 public TDESupply; // 40%
203     uint256 public bountySupply; // 1%
204     uint256 public writerAccountSupply; // 4%
205     uint256 public advisorySupply; // 14%
206     uint256 public cofoundersSupply; // 10%
207     uint256 public platformSupply; // 11%
208 
209     uint256 public earlyBackerSupplyRemaining; // 10%
210     uint256 public PRETDESupplyRemaining; // 10%
211     uint256 public TDESupplyRemaining; // 40%
212     uint256 public bountySupplyRemaining; // 1%
213     uint256 public writerAccountSupplyRemaining; // 4%
214     uint256 public advisorySupplyRemaining; // 14%
215     uint256 public cofoundersSupplyRemaining; // 10%
216     uint256 public platformSupplyRemaining; // 11%
217 
218     ////////////////////////////////////////////////////////////////////////////////////
219     // Amount of CoFounder Supply that has been distributed based on vesting schedule //
220     ////////////////////////////////////////////////////////////////////////////////////
221     uint256 public cofoundersSupplyVestingTranches = 10;
222     uint256 public cofoundersSupplyVestingTranchesIssued = 0;
223     uint256 public cofoundersSupplyVestingStartDate; // Epoch
224     uint256 public cofoundersSupplyDistributed = 0;  // # of atto-DNN distributed to founders
225 
226     //////////////////////////////////////////////
227     // Prevents tokens from being transferrable //
228     //////////////////////////////////////////////
229     bool public tokensLocked = true;
230 
231     /////////////////////////////////////////////////////////////////////////////
232     // Event triggered when tokens are transferred from one address to another //
233     /////////////////////////////////////////////////////////////////////////////
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     ////////////////////////////////////////////////////////////
237     // Checks if tokens can be issued to founder at this time //
238     ////////////////////////////////////////////////////////////
239     modifier CofoundersTokensVested()
240     {
241         // Make sure that a starting vesting date has been set and 4 weeks have passed since vesting date
242         require (cofoundersSupplyVestingStartDate != 0 && (now-cofoundersSupplyVestingStartDate) >= 4 weeks);
243 
244         // Get current tranche based on the amount of time that has passed since vesting start date
245         uint256 currentTranche = now.sub(cofoundersSupplyVestingStartDate) / 4 weeks;
246 
247         // Amount of tranches that have been issued so far
248         uint256 issuedTranches = cofoundersSupplyVestingTranchesIssued;
249 
250         // Amount of tranches that cofounders are entitled to
251         uint256 maxTranches = cofoundersSupplyVestingTranches;
252 
253         // Make sure that we still have unvested tokens and that
254         // the tokens for the current tranche have not been issued.
255         require (issuedTranches != maxTranches && currentTranche > issuedTranches);
256 
257         _;
258     }
259 
260     ///////////////////////////////////
261     // Checks if tokens are unlocked //
262     ///////////////////////////////////
263     modifier TokensUnlocked()
264     {
265         require (tokensLocked == false);
266         _;
267     }
268 
269     /////////////////////////////////
270     // Checks if tokens are locked //
271     /////////////////////////////////
272     modifier TokensLocked()
273     {
274        require (tokensLocked == true);
275        _;
276     }
277 
278     ////////////////////////////////////////////////////
279     // Checks if CoFounders are performing the action //
280     ////////////////////////////////////////////////////
281     modifier onlyCofounders()
282     {
283         require (msg.sender == cofounderA || msg.sender == cofounderB);
284         _;
285     }
286 
287     ////////////////////////////////////////////////////
288     // Checks if CoFounder A is performing the action //
289     ////////////////////////////////////////////////////
290     modifier onlyCofounderA()
291     {
292         require (msg.sender == cofounderA);
293         _;
294     }
295 
296     ////////////////////////////////////////////////////
297     // Checks if CoFounder B is performing the action //
298     ////////////////////////////////////////////////////
299     modifier onlyCofounderB()
300     {
301         require (msg.sender == cofounderB);
302         _;
303     }
304 
305     //////////////////////////////////////////////////
306     // Checks if Allocator is performing the action //
307     //////////////////////////////////////////////////
308     modifier onlyAllocator()
309     {
310         require (msg.sender == allocatorAddress);
311         _;
312     }
313 
314     ///////////////////////////////////////////////////////////
315     // Checks if Crowdfund Contract is performing the action //
316     ///////////////////////////////////////////////////////////
317     modifier onlyCrowdfundContract()
318     {
319         require (msg.sender == crowdfundContract);
320         _;
321     }
322 
323     ///////////////////////////////////////////////////////////////////////////////////
324     // Checks if Crowdfund Contract, Platform, or Allocator is performing the action //
325     ///////////////////////////////////////////////////////////////////////////////////
326     modifier onlyAllocatorOrCrowdfundContractOrPlatform()
327     {
328         require (msg.sender == allocatorAddress || msg.sender == crowdfundContract || msg.sender == platform);
329         _;
330     }
331 
332     ///////////////////////////////////////////////////////////////////////
333     //  @des Function to change address that is manage platform holding  //
334     //  @param newAddress Address of new issuance contract.              //
335     ///////////////////////////////////////////////////////////////////////
336     function changePlatform(address newAddress)
337         onlyCofounders
338     {
339         platform = newAddress;
340     }
341 
342     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
343     //  @des Function to change address that is allowed to do token issuance. Crowdfund contract can only be set once.   //
344     //  @param newAddress Address of new issuance contract.                                                              //
345     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
346     function changeCrowdfundContract(address newAddress)
347         onlyCofounders
348     {
349         crowdfundContract = newAddress;
350     }
351 
352     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
353     //  @des Function to change address that is allowed to do token issuance. Allocator can only be set once.  //
354     //  @param newAddress Address of new issuance contract.                                                    //
355     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
356     function changeAllocator(address newAddress)
357         onlyCofounders
358     {
359         allocatorAddress = newAddress;
360     }
361 
362     ///////////////////////////////////////////////////////
363     //  @des Function to change founder A address.       //
364     //  @param newAddress Address of new founder A.      //
365     ///////////////////////////////////////////////////////
366     function changeCofounderA(address newAddress)
367         onlyCofounderA
368     {
369         cofounderA = newAddress;
370     }
371 
372     //////////////////////////////////////////////////////
373     //  @des Function to change founder B address.      //
374     //  @param newAddress Address of new founder B.     //
375     //////////////////////////////////////////////////////
376     function changeCofounderB(address newAddress)
377         onlyCofounderB
378     {
379         cofounderB = newAddress;
380     }
381 
382 
383     //////////////////////////////////////////////////////////////
384     // Transfers tokens from senders address to another address //
385     //////////////////////////////////////////////////////////////
386     function transfer(address _to, uint256 _value)
387       TokensUnlocked
388       returns (bool)
389     {
390           Transfer(msg.sender, _to, _value);
391           return BasicToken.transfer(_to, _value);
392     }
393 
394     //////////////////////////////////////////////////////////
395     // Transfers tokens from one address to another address //
396     //////////////////////////////////////////////////////////
397     function transferFrom(address _from, address _to, uint256 _value)
398       TokensUnlocked
399       returns (bool)
400     {
401           Transfer(_from, _to, _value);
402           return StandardToken.transferFrom(_from, _to, _value);
403     }
404 
405 
406     ///////////////////////////////////////////////////////////////////////////////////////////////
407     //  @des Cofounders issue tokens to themsleves if within vesting period. Returns success.    //
408     //  @param beneficiary Address of receiver.                                                  //
409     //  @param tokenCount Number of tokens to issue.                                             //
410     ///////////////////////////////////////////////////////////////////////////////////////////////
411     function issueCofoundersTokensIfPossible()
412         onlyCofounders
413         CofoundersTokensVested
414         returns (bool)
415     {
416         // Compute total amount of vested tokens to issue
417         uint256 tokenCount = cofoundersSupply.div(cofoundersSupplyVestingTranches);
418 
419         // Make sure that there are cofounder tokens left
420         if (tokenCount > cofoundersSupplyRemaining) {
421            return false;
422         }
423 
424         // Decrease cofounders supply
425         cofoundersSupplyRemaining = cofoundersSupplyRemaining.sub(tokenCount);
426 
427         // Update how many tokens have been distributed to cofounders
428         cofoundersSupplyDistributed = cofoundersSupplyDistributed.add(tokenCount);
429 
430         // Split tokens between both founders
431         balances[cofounderA] = balances[cofounderA].add(tokenCount.div(2));
432         balances[cofounderB] = balances[cofounderB].add(tokenCount.div(2));
433 
434         // Update that a tranche has been issued
435         cofoundersSupplyVestingTranchesIssued += 1;
436 
437         return true;
438     }
439 
440 
441     //////////////////
442     // Issue tokens //
443     //////////////////
444     function issueTokens(address beneficiary, uint256 tokenCount, DNNSupplyAllocations allocationType)
445       onlyAllocatorOrCrowdfundContractOrPlatform
446       returns (bool)
447     {
448         // We'll use the following to determine whether the allocator, platform,
449         // or the crowdfunding contract can allocate specified supply
450         bool canAllocatorPerform = msg.sender == allocatorAddress;
451         bool canCrowdfundContractPerform = msg.sender == crowdfundContract;
452         bool canPlatformPerform = msg.sender == platform;
453 
454         // Early Backers
455         if (canAllocatorPerform && allocationType == DNNSupplyAllocations.EarlyBackerSupplyAllocation && tokenCount <= earlyBackerSupplyRemaining) {
456             earlyBackerSupplyRemaining = earlyBackerSupplyRemaining.sub(tokenCount);
457         }
458 
459         // PRE-TDE
460         else if (canCrowdfundContractPerform && msg.sender == crowdfundContract && allocationType == DNNSupplyAllocations.PRETDESupplyAllocation) {
461 
462               // Check to see if we have enough tokens to satisfy this purchase
463               // using just the pre-tde.
464               if (PRETDESupplyRemaining >= tokenCount) {
465 
466                     // Decrease pre-tde supply
467                     PRETDESupplyRemaining = PRETDESupplyRemaining.sub(tokenCount);
468               }
469 
470               // Check to see if we can satisfy this using pre-tde and tde supply combined
471               else if (PRETDESupplyRemaining+TDESupplyRemaining >= tokenCount) {
472 
473                     // Decrease tde supply
474                     TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount-PRETDESupplyRemaining);
475 
476                     // Decrease pre-tde supply by its' remaining tokens
477                     PRETDESupplyRemaining = 0;
478               }
479 
480               // Otherwise, we can't satisfy this sale because we don't have enough tokens.
481               else {
482                   return false;
483               }
484         }
485 
486         // TDE
487         else if (canCrowdfundContractPerform && allocationType == DNNSupplyAllocations.TDESupplyAllocation && tokenCount <= TDESupplyRemaining) {
488             TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount);
489         }
490 
491         // Bounty
492         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.BountySupplyAllocation && tokenCount <= bountySupplyRemaining) {
493             bountySupplyRemaining = bountySupplyRemaining.sub(tokenCount);
494         }
495 
496         // Writer Accounts
497         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.WriterAccountSupplyAllocation && tokenCount <= writerAccountSupplyRemaining) {
498             writerAccountSupplyRemaining = writerAccountSupplyRemaining.sub(tokenCount);
499         }
500 
501         // Advisory
502         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.AdvisorySupplyAllocation && tokenCount <= advisorySupplyRemaining) {
503             advisorySupplyRemaining = advisorySupplyRemaining.sub(tokenCount);
504         }
505 
506         // Platform (Also makes sure that the beneficiary is the platform address specified in this contract)
507         else if (canPlatformPerform && allocationType == DNNSupplyAllocations.PlatformSupplyAllocation && tokenCount <= platformSupplyRemaining) {
508             platformSupplyRemaining = platformSupplyRemaining.sub(tokenCount);
509         }
510 
511         else {
512             return false;
513         }
514 
515         // Transfer tokens
516         Transfer(address(this), beneficiary, tokenCount);
517 
518         // Credit tokens to the address specified
519         balances[beneficiary] = balances[beneficiary].add(tokenCount);
520 
521         return true;
522     }
523 
524     /////////////////////////////////////////////////
525     // Transfer Unsold tokens from TDE to Platform //
526     /////////////////////////////////////////////////
527     function sendUnsoldTDETokensToPlatform()
528       external
529       onlyCrowdfundContract
530     {
531         // Make sure we have tokens to send from TDE
532         if (TDESupplyRemaining > 0) {
533 
534             // Add remaining tde tokens to platform remaining tokens
535             platformSupplyRemaining = platformSupplyRemaining.add(TDESupplyRemaining);
536 
537             // Clear remaining tde token count
538             TDESupplyRemaining = 0;
539         }
540     }
541 
542     /////////////////////////////////////////////////////
543     // Transfer Unsold tokens from pre-TDE to Platform //
544     /////////////////////////////////////////////////////
545     function sendUnsoldPRETDETokensToTDE()
546       external
547       onlyCrowdfundContract
548     {
549           // Make sure we have tokens to send from pre-TDE
550           if (PRETDESupplyRemaining > 0) {
551 
552               // Add remaining pre-tde tokens to tde remaining tokens
553               TDESupplyRemaining = TDESupplyRemaining.add(PRETDESupplyRemaining);
554 
555               // Clear remaining pre-tde token count
556               PRETDESupplyRemaining = 0;
557         }
558     }
559 
560     ////////////////////////////////////////////////////////////////
561     // @des Allows tokens to be transferrable. Returns lock state //
562     ////////////////////////////////////////////////////////////////
563     function unlockTokens()
564         external
565         onlyCrowdfundContract
566     {
567         // Make sure tokens are currently locked before proceeding to unlock them
568         require(tokensLocked == true);
569 
570         tokensLocked = false;
571     }
572 
573     ///////////////////////////////////////////////////////////////////////
574     //  @des Contract constructor function sets initial token balances.  //
575     ///////////////////////////////////////////////////////////////////////
576     function DNNToken()
577     {
578           // Start date
579           uint256 vestingStartDate = 1526072145;
580 
581           // Set cofounder addresses
582           cofounderA = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
583           cofounderB = 0x9FFE2aD5D76954C7C25be0cEE30795279c4Cab9f;
584 
585           // Sets platform address
586           platform = address(this);
587 
588           // Set total supply - 1 Billion DNN Tokens = (1,000,000,000 * 10^18) atto-DNN
589           // 1 DNN = 10^18 atto-DNN
590           totalSupply = uint256(1000000000).mul(uint256(10)**decimals);
591 
592           // Set Token Distributions (% of total supply)
593           earlyBackerSupply = totalSupply.mul(10).div(100); // 10%
594           PRETDESupply = totalSupply.mul(10).div(100); // 10%
595           TDESupply = totalSupply.mul(40).div(100); // 40%
596           bountySupply = totalSupply.mul(1).div(100); // 1%
597           writerAccountSupply = totalSupply.mul(4).div(100); // 4%
598           advisorySupply = totalSupply.mul(14).div(100); // 14%
599           cofoundersSupply = totalSupply.mul(10).div(100); // 10%
600           platformSupply = totalSupply.mul(11).div(100); // 11%
601 
602           // Set each remaining token count equal to its' respective supply
603           earlyBackerSupplyRemaining = earlyBackerSupply;
604           PRETDESupplyRemaining = PRETDESupply;
605           TDESupplyRemaining = TDESupply;
606           bountySupplyRemaining = bountySupply;
607           writerAccountSupplyRemaining = writerAccountSupply;
608           advisorySupplyRemaining = advisorySupply;
609           cofoundersSupplyRemaining = cofoundersSupply;
610           platformSupplyRemaining = platformSupply;
611 
612           // Sets cofounder vesting start date (Ensures that it is a date in the future, otherwise it will default to now)
613           cofoundersSupplyVestingStartDate = vestingStartDate >= now ? vestingStartDate : now;
614     }
615 }
616 
617 /// @title DNNTDE contract - Takes funds from users and issues tokens.
618 /// @author Dondrey Taylor - <dondrey@dnn.media>
619 contract DNNTDE {
620 
621     using SafeMath for uint256;
622 
623     /////////////////////////
624     // DNN Token Contract  //
625     /////////////////////////
626     DNNToken public dnnToken;
627 
628     //////////////////////////////////////////
629     // Addresses of the co-founders of DNN. //
630     //////////////////////////////////////////
631     address public cofounderA;
632     address public cofounderB;
633 
634     ///////////////////////////
635     // DNN Holding Multisig //
636     //////////////////////////
637     address public dnnHoldingMultisig;
638 
639     ///////////////////////////
640     // Start date of the TDE //
641     ///////////////////////////
642     uint256 public TDEStartDate;  // Epoch
643 
644     /////////////////////////
645     // End date of the TDE //
646     /////////////////////////
647     uint256 public TDEEndDate;  // Epoch
648 
649     /////////////////////////////////
650     // Amount of atto-DNN per wei //
651     /////////////////////////////////
652     uint256 public tokenExchangeRateBase = 3000; // 1 Wei = 3000 atto-DNN
653 
654     /////////////////////////////////////////////////
655     // Number of tokens distributed (in atto-DNN) //
656     /////////////////////////////////////////////////
657     uint256 public tokensDistributed = 0;
658 
659     ///////////////////////////////////////////////
660     // Minumum Contributions for pre-TDE and TDE //
661     ///////////////////////////////////////////////
662     uint256 public minimumTDEContributionInWei = 0.001 ether;
663     uint256 public minimumPRETDEContributionInWei = 5 ether;
664 
665     //////////////////////
666     // Funding Hard cap //
667     //////////////////////
668     uint256 public maximumFundingGoalInETH;
669 
670     //////////////////
671     // Funds Raised //
672     //////////////////
673     uint256 public fundsRaisedInWei = 0;
674     uint256 public presaleFundsRaisedInWei = 0;
675     uint256 public tdeFundsRaisedInWei = 0;
676 
677     ////////////////////////////////////////////
678     // Keep track of Wei contributed per user //
679     ////////////////////////////////////////////
680     mapping(address => uint256) ETHContributions;
681 
682     ////////////////////////////////////////////////
683     // Keeps track of tokens per eth contribution //
684     ////////////////////////////////////////////////
685     mapping(address => uint256) ETHContributorTokens;
686 
687 
688     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
689     // Keeps track of pre-tde contributors and how many tokens they are entitled to get based on their contribution //
690     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
691     mapping(address => uint256) PRETDEContributorTokensPendingRelease;
692     uint256 PRETDEContributorsTokensPendingCount = 0; // keep track of contributors waiting for tokens
693     uint256 TokensPurchasedDuringPRETDE = 0; // keep track of how many tokens need to be issued to presale contributors
694 
695 
696     //////////////////
697     // Bonus ranges //
698     //////////////////
699     bool public trickleDownBonusesReleased = false;
700     uint256 public rangeETHAmount = 0;
701     uint256 public bonusRangeCount = 4;
702 
703     uint256 public TDEContributorCount = 0;
704     mapping(uint256 => address) public TDEContributorAddresses;
705     mapping(address => uint256) public TDEContributorInitialBonusByAddress;
706 
707     uint256 public tokensIssuedForBonusRangeOne    = 0;
708     uint256 public tokensIssuedForBonusRangeTwo    = 0;
709     uint256 public tokensIssuedForBonusRangeThree  = 0;
710     uint256 public tokensIssuedForBonusRangeFour   = 0;
711 
712     //////////////////////////////////////////////////////
713     // Checks if trickle down bonuses not been released //
714     //////////////////////////////////////////////////////
715     modifier HasTrickleDownBonusesNotBeenReleased() {
716         require (trickleDownBonusesReleased == false);
717         _;
718     }
719 
720     ///////////////////////////////////////////////////////////////////
721     // Checks if all pre-tde contributors have received their tokens //
722     ///////////////////////////////////////////////////////////////////
723     modifier NoPRETDEContributorsAwaitingTokens() {
724         // Determine if all pre-tde contributors have received tokens
725         require(PRETDEContributorsTokensPendingCount == 0);
726         _;
727     }
728 
729     ///////////////////////////////////////////////////////////////////////////////////////
730     // Checks if there are any pre-tde contributors that have not recieved their tokens  //
731     ///////////////////////////////////////////////////////////////////////////////////////
732     modifier PRETDEContributorsAwaitingTokens() {
733 
734         // Determine if there pre-tde contributors that have not received tokens
735         require(PRETDEContributorsTokensPendingCount > 0);
736 
737         _;
738     }
739 
740     ////////////////////////////////////////////////////
741     // Checks if CoFounders are performing the action //
742     ////////////////////////////////////////////////////
743     modifier onlyCofounders() {
744         require (msg.sender == cofounderA || msg.sender == cofounderB);
745         _;
746     }
747 
748     ////////////////////////////////////////////////////
749     // Checks if CoFounder A is performing the action //
750     ////////////////////////////////////////////////////
751     modifier onlyCofounderA() {
752         require (msg.sender == cofounderA);
753         _;
754     }
755 
756     ////////////////////////////////////////////////////
757     // Checks if CoFounder B is performing the action //
758     ////////////////////////////////////////////////////
759     modifier onlyCofounderB() {
760         require (msg.sender == cofounderB);
761         _;
762     }
763 
764     ////////////////////////////////s
765     // Check if the tde has ended //
766     ////////////////////////////////
767     modifier TDEHasEnded() {
768        require (now >= TDEEndDate || fundsRaisedInWei >= maximumFundingGoalInETH);
769        _;
770     }
771 
772     //////////////////////////////////////////////////////////////////////////////
773     // Checksto see if the contribution is at least the minimum allowed for tde //
774     //////////////////////////////////////////////////////////////////////////////
775     modifier ContributionIsAtLeastMinimum() {
776         require (msg.value >= minimumTDEContributionInWei);
777         _;
778     }
779 
780     ///////////////////////////////////////////////////////////////
781     // Make sure max cap is not exceeded with added contribution //
782     ///////////////////////////////////////////////////////////////
783     modifier ContributionDoesNotCauseGoalExceedance() {
784        uint256 newFundsRaised = msg.value+fundsRaisedInWei;
785        require (newFundsRaised <= maximumFundingGoalInETH);
786        _;
787     }
788 
789     ///////////////////////////////////////////////////////////////
790     // Make sure max tokens is not exceeded with added contribution //
791     ///////////////////////////////////////////////////////////////
792     modifier TDEBonusesDoesNotCauseTokenExceedance() {
793        uint256 tokensDistributedPlusBonuses = getTokensDistributedPlusTrickleDownBonuses();
794        require (tokensDistributedPlusBonuses < dnnToken.TDESupplyRemaining());
795        _;
796     }
797 
798     /////////////////////////////////////////////////////////////////
799     // Check if the specified beneficiary has sent us funds before //
800     /////////////////////////////////////////////////////////////////
801     modifier HasPendingPRETDETokens(address _contributor) {
802         require (PRETDEContributorTokensPendingRelease[_contributor] !=  0);
803         _;
804     }
805 
806     /////////////////////////////////////////////////////////////
807     // Check if pre-tde contributors is not waiting for tokens //
808     /////////////////////////////////////////////////////////////
809     modifier IsNotAwaitingPRETDETokens(address _contributor) {
810         require (PRETDEContributorTokensPendingRelease[_contributor] ==  0);
811         _;
812     }
813 
814     ///////////////////////////////////////////////////////
815     //  @des Function to change founder A address.       //
816     //  @param newAddress Address of new founder A.      //
817     ///////////////////////////////////////////////////////
818     function changeCofounderA(address newAddress)
819         onlyCofounderA
820     {
821         cofounderA = newAddress;
822     }
823 
824     //////////////////////////////////////////////////////
825     //  @des Function to change founder B address.      //
826     //  @param newAddress Address of new founder B.     //
827     //////////////////////////////////////////////////////
828     function changeCofounderB(address newAddress)
829         onlyCofounderB
830     {
831         cofounderB = newAddress;
832     }
833 
834     /////////////////////////////////////////////////////////
835     //  @des Tokens distributed plus trickle down bonuses. //
836     /////////////////////////////////////////////////////////
837     function getTokensDistributedPlusTrickleDownBonuses()
838         constant
839         returns (uint256)
840     {
841         return tokensIssuedForBonusRangeOne.mul(220).div(100) + tokensIssuedForBonusRangeTwo.mul(190).div(100) + tokensIssuedForBonusRangeThree.mul(150).div(100) + tokensIssuedForBonusRangeFour.mul(100).div(100);
842     }
843 
844     ////////////////////////////////////////
845     //  @des Function to extend tde       //
846     //  @param new crowdsale start date   //
847     ////////////////////////////////////////
848     function extendTDE(uint256 endDate)
849         onlyCofounders
850         returns (bool)
851     {
852         // Make sure that the new date is past the existing date and
853         // is not in the past.
854         if (endDate > now && endDate > TDEEndDate) {
855             TDEEndDate = endDate;
856             return true;
857         }
858 
859         return false;
860     }
861 
862     ////////////////////////////////////////
863     //  @des Function to extend pre-tde   //
864     //  @param new crowdsale start date   //
865     ////////////////////////////////////////
866     function extendPRETDE(uint256 startDate)
867         onlyCofounders
868         returns (bool)
869     {
870         // Make sure that the new date is past the existing date and
871         // is not in the past.
872         if (startDate > now && startDate > TDEStartDate) {
873             TDEEndDate = TDEEndDate + (startDate-TDEStartDate); // Move end date the same amount of days as start date
874             TDEStartDate = startDate; // set new start date
875             return true;
876         }
877 
878         return false;
879     }
880 
881     //////////////////////////////////////////////////////
882     //  @des Function to change multisig address.       //
883     //  @param newAddress Address of new multisig.      //
884     //////////////////////////////////////////////////////
885     function changeDNNHoldingMultisig(address newAddress)
886         onlyCofounders
887     {
888         dnnHoldingMultisig = newAddress;
889     }
890 
891     //////////////////////////////////////////
892     // @des ETH balance of each contributor //
893     //////////////////////////////////////////
894     function contributorETHBalance(address _owner)
895       constant
896       returns (uint256 balance)
897     {
898         return ETHContributions[_owner];
899     }
900 
901     ////////////////////////////////////////////////////////////
902     // @des Determines if an address is a pre-TDE contributor //
903     ////////////////////////////////////////////////////////////
904     function isAwaitingPRETDETokens(address _contributorAddress)
905        internal
906        returns (bool)
907     {
908         return PRETDEContributorTokensPendingRelease[_contributorAddress] > 0;
909     }
910 
911     /////////////////////////////////////////////////////////////
912     // @des Returns pending presale tokens for a given address //
913     /////////////////////////////////////////////////////////////
914     function getPendingPresaleTokens(address _contributor)
915         constant
916         returns (uint256)
917     {
918         return PRETDEContributorTokensPendingRelease[_contributor];
919     }
920 
921     ////////////////////////////////
922     // @des Returns current bonus //
923     ////////////////////////////////
924     function getCurrentTDEBonus()
925         constant
926         returns (uint256)
927     {
928         return getTDETokenExchangeRate(now);
929     }
930 
931 
932     ////////////////////////////////
933     // @des Returns current bonus //
934     ////////////////////////////////
935     function getCurrentPRETDEBonus()
936         constant
937         returns (uint256)
938     {
939         return getPRETDETokenExchangeRate(now);
940     }
941 
942     ///////////////////////////////////////////////////////////////////////
943     // @des Returns bonus (in atto-DNN) per wei for the specific moment //
944     // @param timestamp Time of purchase (in seconds)                    //
945     ///////////////////////////////////////////////////////////////////////
946     function getTDETokenExchangeRate(uint256 timestamp)
947         constant
948         returns (uint256)
949     {
950         // No bonus - TDE ended
951         if (timestamp > TDEEndDate) {
952             return uint256(0);
953         }
954 
955         // No bonus - TDE has not started
956         if (TDEStartDate > timestamp) {
957             return uint256(0);
958         }
959 
960         // Bonus One --> 0 - 25% of raise
961         if (tdeFundsRaisedInWei <= rangeETHAmount) {
962             return tokenExchangeRateBase.mul(120).div(100);
963         }
964         // Bonus Two --> 25% - 50% of raise
965         else if (tdeFundsRaisedInWei > rangeETHAmount && tdeFundsRaisedInWei <= rangeETHAmount.mul(2)) {
966             return tokenExchangeRateBase.mul(130).div(100);
967         }
968         // Bonus Three --> 50% - 75% of raise
969         else if (tdeFundsRaisedInWei > rangeETHAmount.mul(2) && tdeFundsRaisedInWei <= rangeETHAmount.mul(3)) {
970             return tokenExchangeRateBase.mul(140).div(100);
971         }
972         // Bonus Four --> 75% - 100% of raise
973         else if (tdeFundsRaisedInWei > rangeETHAmount.mul(3) && tdeFundsRaisedInWei <= maximumFundingGoalInETH) {
974             return tokenExchangeRateBase.mul(150).div(100);
975         }
976         else {
977             return tokenExchangeRateBase;
978         }
979     }
980 
981     ////////////////////////////////////////////////////////////////////////////////////
982     // @des Returns bonus (in atto-DNN) per wei for the specific contribution amount //
983     // @param weiamount The amount of wei being contributed                           //
984     ////////////////////////////////////////////////////////////////////////////////////
985     function getPRETDETokenExchangeRate(uint256 weiamount)
986         constant
987         returns (uint256)
988     {
989         // Presale will only accept contributions above minimum
990         if (weiamount < minimumPRETDEContributionInWei) {
991             return uint256(0);
992         }
993 
994         // Minimum Contribution - 199 ETH (25% Bonus)
995         if (weiamount >= minimumPRETDEContributionInWei && weiamount <= 199 ether) {
996             return tokenExchangeRateBase + tokenExchangeRateBase.mul(25).div(100);
997 
998         // 200 ETH - 300 ETH Bonus (30% Bonus)
999         } else if (weiamount >= 200 ether && weiamount <= 300 ether) {
1000             return tokenExchangeRateBase + tokenExchangeRateBase.mul(30).div(100);
1001 
1002         // 301 ETH - 2665 ETH Bonus (35% Bonus)
1003         } else if (weiamount >= 301 ether && weiamount <= 2665 ether) {
1004             return tokenExchangeRateBase + tokenExchangeRateBase.mul(35).div(100);
1005 
1006         // 2666+ ETH Bonus (50% Bonus)
1007         } else {
1008             return tokenExchangeRateBase + tokenExchangeRateBase.mul(50).div(100);
1009         }
1010     }
1011 
1012     //////////////////////////////////////////////////////////////////////////////////////////
1013     // @des Computes how many tokens a buyer is entitled to based on contribution and time. //
1014     //////////////////////////////////////////////////////////////////////////////////////////
1015     function calculateTokens(uint256 weiamount, uint256 timestamp)
1016         constant
1017         returns (uint256)
1018     {
1019         // Compute how many atto-DNN user is entitled to.
1020         uint256 computedTokensForPurchase = weiamount.mul(timestamp >= TDEStartDate ? getTDETokenExchangeRate(timestamp) : getPRETDETokenExchangeRate(weiamount));
1021 
1022         // Amount of atto-DNN to issue
1023         return computedTokensForPurchase;
1024      }
1025 
1026 
1027     ///////////////////////////////////////////////////////////////
1028     // @des Issues tokens for users who made purchase with ETH   //
1029     // @param beneficiary Address the tokens will be issued to.  //
1030     // @param weiamount ETH amount (in Wei)                      //
1031     // @param timestamp Time of purchase (in seconds)            //
1032     ///////////////////////////////////////////////////////////////
1033     function buyTokens()
1034         internal
1035         ContributionIsAtLeastMinimum
1036         ContributionDoesNotCauseGoalExceedance
1037         TDEBonusesDoesNotCauseTokenExceedance
1038         returns (bool)
1039     {
1040         // Determine how many tokens should be issued
1041         uint256 tokenCount = calculateTokens(msg.value, now);
1042 
1043          // Bonus Four
1044         if (tdeFundsRaisedInWei > rangeETHAmount.mul(3) && tdeFundsRaisedInWei <= maximumFundingGoalInETH) {
1045             if (TDEContributorInitialBonusByAddress[msg.sender] == 0) {
1046                 TDEContributorInitialBonusByAddress[msg.sender] = tdeFundsRaisedInWei;
1047                 TDEContributorAddresses[TDEContributorCount] = msg.sender;
1048                 TDEContributorCount++;
1049             }
1050         }
1051         // Bonus Three
1052         else if (tdeFundsRaisedInWei > rangeETHAmount.mul(2) && tdeFundsRaisedInWei <= rangeETHAmount.mul(3)) {
1053             if (TDEContributorInitialBonusByAddress[msg.sender] == 0) {
1054                 TDEContributorInitialBonusByAddress[msg.sender] = rangeETHAmount.mul(3);
1055                 TDEContributorAddresses[TDEContributorCount] = msg.sender;
1056                 TDEContributorCount++;
1057             }
1058         }
1059         // Bonus Two
1060         else if (tdeFundsRaisedInWei > rangeETHAmount && tdeFundsRaisedInWei <= rangeETHAmount.mul(2)) {
1061             if (TDEContributorInitialBonusByAddress[msg.sender] == 0) {
1062                 TDEContributorInitialBonusByAddress[msg.sender] = rangeETHAmount.mul(2);
1063                 TDEContributorAddresses[TDEContributorCount] = msg.sender;
1064                 TDEContributorCount++;
1065             }
1066         }
1067         // Bonus One
1068         else if (tdeFundsRaisedInWei <= rangeETHAmount) {
1069             if (TDEContributorInitialBonusByAddress[msg.sender] == 0) {
1070                 TDEContributorInitialBonusByAddress[msg.sender] = rangeETHAmount;
1071                 TDEContributorAddresses[TDEContributorCount] = msg.sender;
1072                 TDEContributorCount++;
1073             }
1074         }
1075 
1076         // Keep track of tokens issued within each range
1077         // Bonus Four
1078         if (TDEContributorInitialBonusByAddress[msg.sender] == tdeFundsRaisedInWei) {
1079             tokensIssuedForBonusRangeFour = tokensIssuedForBonusRangeFour.add(tokenCount);
1080         }
1081         // Bonus Three
1082         else if (TDEContributorInitialBonusByAddress[msg.sender] == rangeETHAmount.mul(3)) {
1083             tokensIssuedForBonusRangeThree = tokensIssuedForBonusRangeThree.add(tokenCount);
1084         }
1085         // Bonus Two
1086         else if (TDEContributorInitialBonusByAddress[msg.sender] == rangeETHAmount.mul(2)) {
1087             tokensIssuedForBonusRangeTwo = tokensIssuedForBonusRangeTwo.add(tokenCount);
1088         }
1089         // Bonus One
1090         else if (TDEContributorInitialBonusByAddress[msg.sender] == rangeETHAmount) {
1091             tokensIssuedForBonusRangeOne = tokensIssuedForBonusRangeOne.add(tokenCount);
1092         }
1093 
1094         // Get total tokens distributed plus bonuses
1095         uint256 tokensDistributedPlusBonuses = getTokensDistributedPlusTrickleDownBonuses();
1096 
1097         // Make sure we have enough tokens to satisfy the transaction
1098         if (tokensDistributedPlusBonuses > dnnToken.TDESupplyRemaining()) {
1099             revert();
1100         }
1101 
1102         // Update total amount of tokens distributed (in atto-DNN)
1103         tokensDistributed = tokensDistributed.add(tokenCount);
1104 
1105         // Keep track of contributions (in Wei)
1106         ETHContributions[msg.sender] = ETHContributions[msg.sender].add(msg.value);
1107 
1108         // Keep track of how much tokens are issued to each contributor
1109         ETHContributorTokens[msg.sender] = ETHContributorTokens[msg.sender].add(tokenCount);
1110 
1111         // Increase total funds raised by contribution
1112         fundsRaisedInWei = fundsRaisedInWei.add(msg.value);
1113 
1114         // Increase tde total funds raised by contribution
1115         tdeFundsRaisedInWei = tdeFundsRaisedInWei.add(msg.value);
1116 
1117         // Determine which token allocation we should be deducting from
1118         DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.TDESupplyAllocation;
1119 
1120         // Attempt to issue tokens to contributor
1121         if (!dnnToken.issueTokens(msg.sender, tokenCount, allocationType)) {
1122             revert();
1123         }
1124 
1125         // Transfer funds to multisig
1126         dnnHoldingMultisig.transfer(msg.value);
1127 
1128         return true;
1129     }
1130 
1131     ////////////////////////////////////////////////////////////////////////////////////////
1132     // @des Issues tokens for users who made purchase without using ETH during presale.   //
1133     // @param beneficiary Address the tokens will be issued to.                           //
1134     // @param weiamount ETH amount (in Wei)                                               //
1135     ////////////////////////////////////////////////////////////////////////////////////////
1136     function buyPRETDETokensWithoutETH(address beneficiary, uint256 weiamount, uint256 tokenCount)
1137         onlyCofounders
1138         IsNotAwaitingPRETDETokens(beneficiary)
1139         returns (bool)
1140     {
1141 
1142           // Keep track of how much tokens are issued to each contributor
1143           ETHContributorTokens[beneficiary] = ETHContributorTokens[beneficiary].add(tokenCount);
1144 
1145           // Keep track of contributions (in Wei)
1146           ETHContributions[beneficiary] = ETHContributions[beneficiary].add(weiamount);
1147 
1148           // Increase total funds raised by contribution
1149           fundsRaisedInWei = fundsRaisedInWei.add(weiamount);
1150 
1151           // Keep track of presale funds in addition, separately
1152           presaleFundsRaisedInWei = presaleFundsRaisedInWei.add(weiamount);
1153 
1154           // Add these tokens to the total amount of tokens this contributor is entitled to
1155           PRETDEContributorTokensPendingRelease[beneficiary] = PRETDEContributorTokensPendingRelease[beneficiary].add(tokenCount);
1156 
1157           // Incrment number of pre-tde contributors waiting for tokens
1158           PRETDEContributorsTokensPendingCount += 1;
1159 
1160           // Send tokens to contibutor
1161           return issuePRETDETokens(beneficiary);
1162       }
1163 
1164       ////////////////////////////////////////////////////////////////////////////////////////////
1165       // @des Issues tokens for users who made purchase without using ETH during public sale.   //
1166       // @param beneficiary Address the tokens will be issued to.                               //
1167       // @param weiamount ETH amount (in Wei)                                                   //
1168       ////////////////////////////////////////////////////////////////////////////////////////////
1169       function buyTDETokensWithoutETH(address beneficiary, uint256 weiamount, uint256 tokenCount)
1170           onlyCofounders
1171           returns (bool)
1172       {
1173             // Get total tokens distributed plus bonuses
1174             uint256 tokensDistributedPlusBonuses = tokenCount.add(getTokensDistributedPlusTrickleDownBonuses());
1175 
1176             // Make sure we have enough tokens to satisfy the transaction
1177             if (tokensDistributedPlusBonuses > dnnToken.TDESupplyRemaining()) {
1178                 revert();
1179             }
1180 
1181             // Keep track of how much tokens are issued to each contributor
1182             ETHContributorTokens[beneficiary] = ETHContributorTokens[beneficiary].add(tokenCount);
1183 
1184             // Keep track of contributions (in Wei)
1185             ETHContributions[beneficiary] = ETHContributions[beneficiary].add(weiamount);
1186 
1187             // Increase total funds raised by contribution
1188             fundsRaisedInWei = fundsRaisedInWei.add(weiamount);
1189 
1190             // Keep track of tde funds in addition, separately
1191             tdeFundsRaisedInWei = tdeFundsRaisedInWei.add(weiamount);
1192 
1193             // Send tokens to contibutor
1194             return issueTDETokens(beneficiary, tokenCount);
1195         }
1196 
1197       ///////////////////////////////////////////////////////////////
1198       // @des Issues bulk token purchases                          //
1199       // @param beneficiary Address the tokens will be issued to.  //
1200       ///////////////////////////////////////////////////////////////
1201       function issueTDETokens(address beneficiary, uint256 tokenCount)
1202           internal
1203           returns (bool)
1204       {
1205 
1206           // Update total amount of tokens distributed (in atto-DNN)
1207           tokensDistributed = tokensDistributed.add(tokenCount);
1208 
1209           // Allocation type will be PRETDESupplyAllocation
1210           DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.TDESupplyAllocation;
1211 
1212           // Attempt to issue tokens
1213           if (!dnnToken.issueTokens(beneficiary, tokenCount, allocationType)) {
1214               revert();
1215           }
1216 
1217           return true;
1218       }
1219 
1220     ///////////////////////////////////////////////////////////////
1221     // @des Issues pending tokens to pre-tde contributor         //
1222     // @param beneficiary Address the tokens will be issued to.  //
1223     ///////////////////////////////////////////////////////////////
1224     function issuePRETDETokens(address beneficiary)
1225         onlyCofounders
1226         PRETDEContributorsAwaitingTokens
1227         HasPendingPRETDETokens(beneficiary)
1228         returns (bool)
1229     {
1230         // Amount of tokens to credit pre-tde contributor
1231         uint256 tokenCount = PRETDEContributorTokensPendingRelease[beneficiary];
1232 
1233         // Update total amount of tokens distributed (in atto-DNN)
1234         tokensDistributed = tokensDistributed.add(tokenCount);
1235 
1236         // Allocation type will be PRETDESupplyAllocation
1237         DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.PRETDESupplyAllocation;
1238 
1239         // Attempt to issue tokens
1240         if (!dnnToken.issueTokens(beneficiary, tokenCount, allocationType)) {
1241             revert();
1242         }
1243 
1244         // Reduce number of pre-tde contributors waiting for tokens
1245         PRETDEContributorsTokensPendingCount -= 1;
1246 
1247         // Denote that tokens have been issued for this pre-tde contributor
1248         PRETDEContributorTokensPendingRelease[beneficiary] = 0;
1249 
1250         return true;
1251     }
1252 
1253     /////////////////////////////////////
1254     // @des Issue trickle down bonuses //
1255     /////////////////////////////////////
1256     function releaseTrickleDownBonuses()
1257       onlyCofounders
1258     {
1259         // Issue trickle down bonuses if we have not already done so
1260         if (trickleDownBonusesReleased == false) {
1261 
1262             // Determine which token allocation we should be deducting from
1263             DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.TDESupplyAllocation;
1264 
1265             // Temporary reference to contribution
1266             address contributorAddress;
1267 
1268             // Temporary reference to contributor bonus tokens
1269             uint256 bonusTokens;
1270 
1271             // Iterate through contributors
1272             for (uint256 iteration=0; iteration < TDEContributorCount; iteration++) {
1273 
1274                 // No bonus tokens to issue until contribute range and funds raised
1275                 // are determined.
1276                 bonusTokens = 0;
1277 
1278                 // If we have at least reached the bonus 2 range, issue bonuses to everyone in bonus 1
1279                 if (tdeFundsRaisedInWei > rangeETHAmount && tdeFundsRaisedInWei <= rangeETHAmount.mul(2)) {
1280 
1281                     // Contributor address to send tokens to
1282                     contributorAddress = TDEContributorAddresses[iteration];
1283 
1284                     // Issue a range 2 bonus if the contributor was in range 1
1285                     if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount) {
1286                         bonusTokens = ETHContributorTokens[contributorAddress].mul(130).div(100).sub(ETHContributorTokens[contributorAddress]);
1287                     }
1288 
1289                     // Issue tokens to contributor address if bonus applies
1290                     if (bonusTokens > 0 && !dnnToken.issueTokens(contributorAddress, bonusTokens, allocationType)) {
1291                         revert();
1292                     }
1293                 }
1294 
1295                 // If we have at least reached the bonus 3 range, issue bonuses to everyone in bonus 1 & 2
1296                 else if (tdeFundsRaisedInWei > rangeETHAmount.mul(2) && tdeFundsRaisedInWei <= rangeETHAmount.mul(3)) {
1297 
1298                     // Contributor address to send tokens to
1299                     contributorAddress = TDEContributorAddresses[iteration];
1300 
1301                     // Issue a range 2 and range 3 bonus if the contributor was in range 1
1302                     if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount) {
1303                         bonusTokens = ETHContributorTokens[contributorAddress].mul(170).div(100).sub(ETHContributorTokens[contributorAddress]);
1304                     }
1305                     // Issue a range 3 bonus if the contributor was in range 2
1306                     else if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount.mul(2)) {
1307                         bonusTokens = ETHContributorTokens[contributorAddress].mul(140).div(100).sub(ETHContributorTokens[contributorAddress]);
1308                     }
1309 
1310                     // Issue tokens to contributor address if bonus applies
1311                     if (bonusTokens > 0 && !dnnToken.issueTokens(contributorAddress, bonusTokens, allocationType)) {
1312                         revert();
1313                     }
1314                 }
1315 
1316                 // If we have at least reached the bonus 4 range, issue bonuses to everyone in bonus 1, 2, & 3
1317                 else if (tdeFundsRaisedInWei > rangeETHAmount.mul(3)) {
1318 
1319                     // Contributor address to send tokens to
1320                     contributorAddress = TDEContributorAddresses[iteration];
1321 
1322                     // Issue a range 2 and range 3 bonus if the contributor was in range 1
1323                     if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount) {
1324                         bonusTokens = ETHContributorTokens[contributorAddress].mul(220).div(100).sub(ETHContributorTokens[contributorAddress]);
1325                     }
1326                     // Issue a range 3 bonus if the contributor was in range 2
1327                     else if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount.mul(2)) {
1328                         bonusTokens = ETHContributorTokens[contributorAddress].mul(190).div(100).sub(ETHContributorTokens[contributorAddress]);
1329                     }
1330                     // Issue a range 3 bonus if the contributor was in range 2
1331                     else if (TDEContributorInitialBonusByAddress[contributorAddress] == rangeETHAmount.mul(3)) {
1332                         bonusTokens = ETHContributorTokens[contributorAddress].mul(150).div(100).sub(ETHContributorTokens[contributorAddress]);
1333                     }
1334 
1335                     // Issue tokens to contributor address if bonus applies
1336                     if (bonusTokens > 0 && !dnnToken.issueTokens(contributorAddress, bonusTokens, allocationType)) {
1337                         revert();
1338                     }
1339                 }
1340             }
1341 
1342             // Mark down that bonuses have been released
1343             trickleDownBonusesReleased = true;
1344         }
1345     }
1346 
1347     /////////////////////////////////
1348     // @des Marks TDE as completed //
1349     /////////////////////////////////
1350     function finalizeTDE()
1351        onlyCofounders
1352        TDEHasEnded
1353     {
1354         // Check if the tokens are locked and all pre-sale tokens have been
1355         // transferred to the TDE Supply before unlocking tokens.
1356         require(dnnToken.tokensLocked() == true && dnnToken.PRETDESupplyRemaining() == 0);
1357 
1358         // Release Bonuses
1359         releaseTrickleDownBonuses();
1360 
1361         // Unlock tokens
1362         dnnToken.unlockTokens();
1363 
1364         // Update tokens distributed
1365         tokensDistributed += dnnToken.TDESupplyRemaining();
1366 
1367         // Transfer unsold TDE tokens to platform
1368         dnnToken.sendUnsoldTDETokensToPlatform();
1369     }
1370 
1371 
1372     ////////////////////////////////////////////////////////////////////////////////
1373     // @des Marks pre-TDE as completed by moving remaining tokens into TDE supply //
1374     ////////////////////////////////////////////////////////////////////////////////
1375     function finalizePRETDE()
1376        onlyCofounders
1377        NoPRETDEContributorsAwaitingTokens
1378     {
1379         // Check if we have tokens to transfer to TDE
1380         require(dnnToken.PRETDESupplyRemaining() > 0);
1381 
1382         // Transfer unsold TDE tokens to platform
1383         dnnToken.sendUnsoldPRETDETokensToTDE();
1384     }
1385 
1386 
1387     ///////////////////////////////
1388     // @des Contract constructor /xw/
1389     ///////////////////////////////
1390     function DNNTDE()
1391     {
1392         // Hard Cap
1393         uint256 hardCap = 35000;
1394 
1395         // Set token address
1396         dnnToken = DNNToken(0x9D9832d1beb29CC949d75D61415FD00279f84Dc2);
1397 
1398         // Set cofounder addresses
1399         cofounderA = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
1400         cofounderB = 0x9FFE2aD5D76954C7C25be0cEE30795279c4Cab9f;
1401 
1402         // Set DNN holding address
1403         dnnHoldingMultisig = 0x5980a47514a0Af79a8d2F6276f8673a006ec9929;
1404 
1405         // Set hard cap
1406         maximumFundingGoalInETH = hardCap * 1 ether;
1407 
1408         // Range ETH
1409         rangeETHAmount = hardCap.div(bonusRangeCount) * 1 ether;
1410 
1411         // Set Start Date
1412         TDEStartDate = 1529020801;
1413 
1414         // Set End date (Make sure the end date is at least 30 days from start date)
1415         // Will default to a date that is exactly 30 days from start date.
1416         TDEEndDate = (TDEStartDate + 35 days);
1417     }
1418 
1419     /////////////////////////////////////////////////////////
1420     // @des Handle's ETH sent directly to contract address //
1421     /////////////////////////////////////////////////////////
1422     function () payable {
1423 
1424         // Handle pre-sale contribution (tokens held, until tx confirmation from contributor)
1425         // Makes sure the user sends minimum PRE-TDE contribution, and that  pre-tde contributors
1426         // are unable to send subsequent ETH contributors before being issued tokens.
1427         if (now < TDEStartDate && msg.value >= minimumPRETDEContributionInWei && PRETDEContributorTokensPendingRelease[msg.sender] == 0) {
1428 
1429             // Keep track of contributions (in Wei)
1430             ETHContributions[msg.sender] = ETHContributions[msg.sender].add(msg.value);
1431 
1432             // Increase total funds raised by contribution
1433             fundsRaisedInWei = fundsRaisedInWei.add(msg.value);
1434 
1435             // Keep track of presale funds in addition, separately
1436             presaleFundsRaisedInWei = presaleFundsRaisedInWei.add(msg.value);
1437 
1438             /// Make a note of how many tokens this user should get for their contribution to the presale
1439             PRETDEContributorTokensPendingRelease[msg.sender] = PRETDEContributorTokensPendingRelease[msg.sender].add(calculateTokens(msg.value, now));
1440 
1441             // Keep track of pending tokens
1442             TokensPurchasedDuringPRETDE += calculateTokens(msg.value, now);
1443 
1444             // Increment number of pre-tde contributors waiting for tokens
1445             PRETDEContributorsTokensPendingCount += 1;
1446 
1447             // Prevent contributions that will cause us to have a shortage of tokens during the pre-sale
1448             if (TokensPurchasedDuringPRETDE > dnnToken.TDESupplyRemaining()+dnnToken.PRETDESupplyRemaining()) {
1449                 revert();
1450             }
1451 
1452             // Transfer contribution directly to multisig
1453             dnnHoldingMultisig.transfer(msg.value);
1454         }
1455 
1456         // Handle public-sale contribution (tokens issued immediately)
1457         else if (now >= TDEStartDate && now < TDEEndDate) buyTokens();
1458 
1459         // Otherwise, reject the contribution
1460         else revert();
1461     }
1462 }