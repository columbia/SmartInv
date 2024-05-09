1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract DNNTDE {
11 
12     using SafeMath for uint256;
13 
14     /////////////////////////
15     // DNN Token Contract  //
16     /////////////////////////
17     DNNToken public dnnToken;
18 
19     //////////////////////////////////////////
20     // Addresses of the co-founders of DNN. //
21     //////////////////////////////////////////
22     address public cofounderA;
23     address public cofounderB;
24 
25     ///////////////////////////
26     // DNN Holding Multisig //
27     //////////////////////////
28     address public dnnHoldingMultisig;
29 
30     ///////////////////////////
31     // Start date of the TDE //
32     ///////////////////////////
33     uint256 public TDEStartDate;  // Epoch
34 
35     /////////////////////////
36     // End date of the TDE //
37     /////////////////////////
38     uint256 public TDEEndDate;  // Epoch
39 
40     /////////////////////////////////
41     // Amount of atto-DNN per wei //
42     /////////////////////////////////
43     uint256 public tokenExchangeRateBase = 3000; // 1 Wei = 3000 atto-DNN
44 
45     /////////////////////////////////////////////////
46     // Number of tokens distributed (in atto-DNN) //
47     /////////////////////////////////////////////////
48     uint256 public tokensDistributed = 0;
49 
50     ///////////////////////////////////////////////
51     // Minumum Contributions for pre-TDE and TDE //
52     ///////////////////////////////////////////////
53     uint256 public minimumTDEContributionInWei = 0.001 ether;
54     uint256 public minimumPRETDEContributionInWei = 5 ether;
55 
56     //////////////////////
57     // Funding Hard cap //
58     //////////////////////
59     uint256 public maximumFundingGoalInETH;
60 
61     //////////////////
62     // Funds Raised //
63     //////////////////
64     uint256 public fundsRaisedInWei = 0;
65     uint256 public presaleFundsRaisedInWei = 0;
66 
67     ////////////////////////////////////////////
68     // Keep track of Wei contributed per user //
69     ////////////////////////////////////////////
70     mapping(address => uint256) ETHContributions;
71 
72 
73     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
74     // Keeps track of pre-tde contributors and how many tokens they are entitled to get based on their contribution //
75     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
76     mapping(address => uint256) PRETDEContributorTokensPendingRelease;
77     uint256 PRETDEContributorsTokensPendingCount = 0; // keep track of contributors waiting for tokens
78     uint256 TokensPurchasedDuringPRETDE = 0; // keep track of how many tokens need to be issued to presale contributors
79 
80     ///////////////////////////////////////////////////////////////////
81     // Checks if all pre-tde contributors have received their tokens //
82     ///////////////////////////////////////////////////////////////////
83     modifier NoPRETDEContributorsAwaitingTokens() {
84 
85         // Determine if all pre-tde contributors have received tokens
86         require(PRETDEContributorsTokensPendingCount == 0);
87 
88         _;
89     }
90 
91     ///////////////////////////////////////////////////////////////////////////////////////
92     // Checks if there are any pre-tde contributors that have not recieved their tokens  //
93     ///////////////////////////////////////////////////////////////////////////////////////
94     modifier PRETDEContributorsAwaitingTokens() {
95 
96         // Determine if there pre-tde contributors that have not received tokens
97         require(PRETDEContributorsTokensPendingCount > 0);
98 
99         _;
100     }
101 
102     ////////////////////////////////////////////////////
103     // Checks if CoFounders are performing the action //
104     ////////////////////////////////////////////////////
105     modifier onlyCofounders() {
106         require (msg.sender == cofounderA || msg.sender == cofounderB);
107         _;
108     }
109 
110     ////////////////////////////////////////////////////
111     // Checks if CoFounder A is performing the action //
112     ////////////////////////////////////////////////////
113     modifier onlyCofounderA() {
114         require (msg.sender == cofounderA);
115         _;
116     }
117 
118     ////////////////////////////////////////////////////
119     // Checks if CoFounder B is performing the action //
120     ////////////////////////////////////////////////////
121     modifier onlyCofounderB() {
122         require (msg.sender == cofounderB);
123         _;
124     }
125 
126     //////////////////////////////////////
127     // Check if the pre-tde is going on //
128     //////////////////////////////////////
129     modifier PRETDEHasNotEnded() {
130        require (now < TDEStartDate);
131        _;
132     }
133 
134     ////////////////////////////////s
135     // Check if the tde has ended //
136     ////////////////////////////////
137     modifier TDEHasEnded() {
138        require (now >= TDEEndDate || fundsRaisedInWei >= maximumFundingGoalInETH);
139        _;
140     }
141 
142     //////////////////////////////////////////////////////////////////////////////
143     // Checksto see if the contribution is at least the minimum allowed for tde //
144     //////////////////////////////////////////////////////////////////////////////
145     modifier ContributionIsAtLeastMinimum() {
146         require (msg.value >= minimumTDEContributionInWei);
147         _;
148     }
149 
150     ///////////////////////////////////////////////////////////////
151     // Make sure max cap is not exceeded with added contribution //
152     ///////////////////////////////////////////////////////////////
153     modifier ContributionDoesNotCauseGoalExceedance() {
154        uint256 newFundsRaised = msg.value+fundsRaisedInWei;
155        require (newFundsRaised <= maximumFundingGoalInETH);
156        _;
157     }
158 
159     /////////////////////////////////////////////////////////////////
160     // Check if the specified beneficiary has sent us funds before //
161     /////////////////////////////////////////////////////////////////
162     modifier HasPendingPRETDETokens(address _contributor) {
163         require (PRETDEContributorTokensPendingRelease[_contributor] !=  0);
164         _;
165     }
166 
167     /////////////////////////////////////////////////////////////
168     // Check if pre-tde contributors is not waiting for tokens //
169     /////////////////////////////////////////////////////////////
170     modifier IsNotAwaitingPRETDETokens(address _contributor) {
171         require (PRETDEContributorTokensPendingRelease[_contributor] ==  0);
172         _;
173     }
174 
175     ///////////////////////////////////////////////////////
176     //  @des Function to change founder A address.       //
177     //  @param newAddress Address of new founder A.      //
178     ///////////////////////////////////////////////////////
179     function changeCofounderA(address newAddress)
180         onlyCofounderA
181     {
182         cofounderA = newAddress;
183     }
184 
185     //////////////////////////////////////////////////////
186     //  @des Function to change founder B address.      //
187     //  @param newAddress Address of new founder B.     //
188     //////////////////////////////////////////////////////
189     function changeCofounderB(address newAddress)
190         onlyCofounderB
191     {
192         cofounderB = newAddress;
193     }
194 
195     ////////////////////////////////////////
196     //  @des Function to extend pre-tde   //
197     //  @param new crowdsale start date   //
198     ////////////////////////////////////////
199     function extendPRETDE(uint256 startDate)
200         onlyCofounders
201         PRETDEHasNotEnded
202         returns (bool)
203     {
204         // Make sure that the new date is past the existing date and
205         // is not in the past.
206         if (startDate > now && startDate > TDEStartDate) {
207             TDEEndDate = TDEEndDate + (startDate-TDEStartDate); // Move end date the same amount of days as start date
208             TDEStartDate = startDate; // set new start date
209             return true;
210         }
211 
212         return false;
213     }
214 
215     //////////////////////////////////////////////////////
216     //  @des Function to change multisig address.       //
217     //  @param newAddress Address of new multisig.      //
218     //////////////////////////////////////////////////////
219     function changeDNNHoldingMultisig(address newAddress)
220         onlyCofounders
221     {
222         dnnHoldingMultisig = newAddress;
223     }
224 
225     //////////////////////////////////////////
226     // @des ETH balance of each contributor //
227     //////////////////////////////////////////
228     function contributorETHBalance(address _owner)
229       constant
230       returns (uint256 balance)
231     {
232         return ETHContributions[_owner];
233     }
234 
235     ////////////////////////////////////////////////////////////
236     // @des Determines if an address is a pre-TDE contributor //
237     ////////////////////////////////////////////////////////////
238     function isAwaitingPRETDETokens(address _contributorAddress)
239        internal
240        returns (bool)
241     {
242         return PRETDEContributorTokensPendingRelease[_contributorAddress] > 0;
243     }
244 
245     /////////////////////////////////////////////////////////////
246     // @des Returns pending presale tokens for a given address //
247     /////////////////////////////////////////////////////////////
248     function getPendingPresaleTokens(address _contributor)
249         constant
250         returns (uint256)
251     {
252         return PRETDEContributorTokensPendingRelease[_contributor];
253     }
254 
255     ////////////////////////////////
256     // @des Returns current bonus //
257     ////////////////////////////////
258     function getCurrentTDEBonus()
259         constant
260         returns (uint256)
261     {
262         return getTDETokenExchangeRate(now);
263     }
264 
265 
266     ////////////////////////////////
267     // @des Returns current bonus //
268     ////////////////////////////////
269     function getCurrentPRETDEBonus()
270         constant
271         returns (uint256)
272     {
273         return getPRETDETokenExchangeRate(now);
274     }
275 
276     ///////////////////////////////////////////////////////////////////////
277     // @des Returns bonus (in atto-DNN) per wei for the specific moment //
278     // @param timestamp Time of purchase (in seconds)                    //
279     ///////////////////////////////////////////////////////////////////////
280     function getTDETokenExchangeRate(uint256 timestamp)
281         constant
282         returns (uint256)
283     {
284         // No bonus - TDE ended
285         if (timestamp > TDEEndDate) {
286             return uint256(0);
287         }
288 
289         // No bonus - TDE has not started
290         if (TDEStartDate > timestamp) {
291             return uint256(0);
292         }
293 
294         // 1 ETH = 3600 DNN (0 - 20% of funding goal) - 20% Bonus
295         if (fundsRaisedInWei <= maximumFundingGoalInETH.mul(20).div(100)) {
296             return tokenExchangeRateBase.mul(120).div(100);
297 
298         // 1 ETH = 3450 DNN (>20% to 60% of funding goal) - 15% Bonus
299         } else if (fundsRaisedInWei > maximumFundingGoalInETH.mul(20).div(100) && fundsRaisedInWei <= maximumFundingGoalInETH.mul(60).div(100)) {
300             return tokenExchangeRateBase.mul(115).div(100);
301 
302         // 1 ETH = 3300 DNN (>60% to Funding Goal) - 10% Bonus
303         } else if (fundsRaisedInWei > maximumFundingGoalInETH.mul(60).div(100) && fundsRaisedInWei <= maximumFundingGoalInETH) {
304             return tokenExchangeRateBase.mul(110).div(100);
305 
306         // Default: 1 ETH = 3000 DNN
307         } else {
308             return tokenExchangeRateBase;
309         }
310     }
311 
312     ////////////////////////////////////////////////////////////////////////////////////
313     // @des Returns bonus (in atto-DNN) per wei for the specific contribution amount //
314     // @param weiamount The amount of wei being contributed                           //
315     ////////////////////////////////////////////////////////////////////////////////////
316     function getPRETDETokenExchangeRate(uint256 weiamount)
317         constant
318         returns (uint256)
319     {
320         // Presale will only accept contributions above minimum
321         if (weiamount < minimumPRETDEContributionInWei) {
322             return uint256(0);
323         }
324 
325         // Minimum Contribution - 199 ETH (25% Bonus)
326         if (weiamount >= minimumPRETDEContributionInWei && weiamount <= 199 ether) {
327             return tokenExchangeRateBase + tokenExchangeRateBase.mul(25).div(100);
328 
329         // 200 ETH - 300 ETH Bonus (30% Bonus)
330         } else if (weiamount >= 200 ether && weiamount <= 300 ether) {
331             return tokenExchangeRateBase + tokenExchangeRateBase.mul(30).div(100);
332 
333         // 301 ETH - 2665 ETH Bonus (35% Bonus)
334         } else if (weiamount >= 301 ether && weiamount <= 2665 ether) {
335             return tokenExchangeRateBase + tokenExchangeRateBase.mul(35).div(100);
336 
337         // 2666+ ETH Bonus (50% Bonus)
338         } else {
339             return tokenExchangeRateBase + tokenExchangeRateBase.mul(50).div(100);
340         }
341     }
342 
343     //////////////////////////////////////////////////////////////////////////////////////////
344     // @des Computes how many tokens a buyer is entitled to based on contribution and time. //
345     //////////////////////////////////////////////////////////////////////////////////////////
346     function calculateTokens(uint256 weiamount, uint256 timestamp)
347         constant
348         returns (uint256)
349     {
350 
351         // Compute how many atto-DNN user is entitled to.
352         uint256 computedTokensForPurchase = weiamount.mul(timestamp >= TDEStartDate ? getTDETokenExchangeRate(timestamp) : getPRETDETokenExchangeRate(weiamount));
353 
354         // Amount of atto-DNN to issue
355         return computedTokensForPurchase;
356      }
357 
358 
359     ///////////////////////////////////////////////////////////////
360     // @des Issues tokens for users who made purchase with ETH   //
361     // @param beneficiary Address the tokens will be issued to.  //
362     // @param weiamount ETH amount (in Wei)                      //
363     // @param timestamp Time of purchase (in seconds)            //
364     ///////////////////////////////////////////////////////////////
365     function buyTokens()
366         internal
367         ContributionIsAtLeastMinimum
368         ContributionDoesNotCauseGoalExceedance
369         returns (bool)
370     {
371 
372         // Determine how many tokens should be issued
373         uint256 tokenCount = calculateTokens(msg.value, now);
374 
375         // Update total amount of tokens distributed (in atto-DNN)
376         tokensDistributed = tokensDistributed.add(tokenCount);
377 
378         // Keep track of contributions (in Wei)
379         ETHContributions[msg.sender] = ETHContributions[msg.sender].add(msg.value);
380 
381         // Increase total funds raised by contribution
382         fundsRaisedInWei = fundsRaisedInWei.add(msg.value);
383 
384         // Determine which token allocation we should be deducting from
385         DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.TDESupplyAllocation;
386 
387         // Attempt to issue tokens to contributor
388         if (!dnnToken.issueTokens(msg.sender, tokenCount, allocationType)) {
389             revert();
390         }
391 
392         // Transfer funds to multisig
393         dnnHoldingMultisig.transfer(msg.value);
394 
395         return true;
396     }
397 
398     ////////////////////////////////////////////////////////////////////////////////////////
399     // @des Issues tokens for users who made purchase without using ETH during presale.   //
400     // @param beneficiary Address the tokens will be issued to.                           //
401     // @param weiamount ETH amount (in Wei)                                               //
402     ////////////////////////////////////////////////////////////////////////////////////////
403     function buyPRETDETokensWithoutETH(address beneficiary, uint256 weiamount, uint256 tokenCount)
404         onlyCofounders
405         PRETDEHasNotEnded
406         IsNotAwaitingPRETDETokens(beneficiary)
407         returns (bool)
408     {
409           // Keep track of contributions (in Wei)
410           ETHContributions[beneficiary] = ETHContributions[beneficiary].add(weiamount);
411 
412           // Increase total funds raised by contribution
413           fundsRaisedInWei = fundsRaisedInWei.add(weiamount);
414 
415           // Keep track of presale funds in addition, separately
416           presaleFundsRaisedInWei = presaleFundsRaisedInWei.add(weiamount);
417 
418           // Add these tokens to the total amount of tokens this contributor is entitled to
419           PRETDEContributorTokensPendingRelease[beneficiary] = PRETDEContributorTokensPendingRelease[beneficiary].add(tokenCount);
420 
421           // Incrment number of pre-tde contributors waiting for tokens
422           PRETDEContributorsTokensPendingCount += 1;
423 
424           // Send tokens to contibutor
425           return issuePRETDETokens(beneficiary);
426       }
427 
428     ///////////////////////////////////////////////////////////////
429     // @des Issues pending tokens to pre-tde contributor         //
430     // @param beneficiary Address the tokens will be issued to.  //
431     ///////////////////////////////////////////////////////////////
432     function issuePRETDETokens(address beneficiary)
433         onlyCofounders
434         PRETDEContributorsAwaitingTokens
435         HasPendingPRETDETokens(beneficiary)
436         returns (bool)
437     {
438 
439         // Amount of tokens to credit pre-tde contributor
440         uint256 tokenCount = PRETDEContributorTokensPendingRelease[beneficiary];
441 
442         // Update total amount of tokens distributed (in atto-DNN)
443         tokensDistributed = tokensDistributed.add(tokenCount);
444 
445         // Allocation type will be PRETDESupplyAllocation
446         DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.PRETDESupplyAllocation;
447 
448         // Attempt to issue tokens
449         if (!dnnToken.issueTokens(beneficiary, tokenCount, allocationType)) {
450             revert();
451         }
452 
453         // Reduce number of pre-tde contributors waiting for tokens
454         PRETDEContributorsTokensPendingCount -= 1;
455 
456         // Denote that tokens have been issued for this pre-tde contributor
457         PRETDEContributorTokensPendingRelease[beneficiary] = 0;
458 
459         return true;
460     }
461 
462 
463     /////////////////////////////////
464     // @des Marks TDE as completed //
465     /////////////////////////////////
466     function finalizeTDE()
467        onlyCofounders
468        TDEHasEnded
469     {
470         // Check if the tokens are locked and all pre-sale tokens have been
471         // transferred to the TDE Supply before unlocking tokens.
472         require(dnnToken.tokensLocked() == true && dnnToken.PRETDESupplyRemaining() == 0);
473 
474         // Unlock tokens
475         dnnToken.unlockTokens();
476 
477         // Update tokens distributed
478         tokensDistributed += dnnToken.TDESupplyRemaining();
479 
480         // Transfer unsold TDE tokens to platform
481         dnnToken.sendUnsoldTDETokensToPlatform();
482     }
483 
484 
485     ////////////////////////////////////////////////////////////////////////////////
486     // @des Marks pre-TDE as completed by moving remaining tokens into TDE supply //
487     ////////////////////////////////////////////////////////////////////////////////
488     function finalizePRETDE()
489        onlyCofounders
490        NoPRETDEContributorsAwaitingTokens
491     {
492         // Check if we have tokens to transfer to TDE
493         require(dnnToken.PRETDESupplyRemaining() > 0);
494 
495         // Transfer unsold TDE tokens to platform
496         dnnToken.sendUnsoldPRETDETokensToTDE();
497     }
498 
499 
500     ///////////////////////////////
501     // @des Contract constructor //
502     ///////////////////////////////
503     function DNNTDE(address tokenAddress, address founderA, address founderB, address dnnHolding, uint256 hardCap, uint256 startDate, uint256 endDate)
504     {
505 
506         // Set token address
507         dnnToken = DNNToken(tokenAddress);
508 
509         // Set cofounder addresses
510         cofounderA = founderA;
511         cofounderB = founderB;
512 
513         // Set DNN holding address
514         dnnHoldingMultisig = dnnHolding;
515 
516         // Set Hard Cap
517         maximumFundingGoalInETH = hardCap * 1 ether;
518 
519         // Set Start Date
520         TDEStartDate = startDate >= now ? startDate : now;
521 
522         // Set End date (Make sure the end date is at least 30 days from start date)
523         // Will default to a date that is exactly 30 days from start date.
524         TDEEndDate = endDate > TDEStartDate && (endDate-TDEStartDate) >= 30 days ? endDate : (TDEStartDate + 30 days);
525     }
526 
527     /////////////////////////////////////////////////////////
528     // @des Handle's ETH sent directly to contract address //
529     /////////////////////////////////////////////////////////
530     function () payable {
531 
532         // Handle pre-sale contribution (tokens held, until tx confirmation from contributor)
533         // Makes sure the user sends minimum PRE-TDE contribution, and that  pre-tde contributors
534         // are unable to send subsequent ETH contributors before being issued tokens.
535         if (now < TDEStartDate && msg.value >= minimumPRETDEContributionInWei && PRETDEContributorTokensPendingRelease[msg.sender] == 0) {
536 
537             // Keep track of contributions (in Wei)
538             ETHContributions[msg.sender] = ETHContributions[msg.sender].add(msg.value);
539 
540             // Increase total funds raised by contribution
541             fundsRaisedInWei = fundsRaisedInWei.add(msg.value);
542 
543             // Keep track of presale funds in addition, separately
544             presaleFundsRaisedInWei = presaleFundsRaisedInWei.add(msg.value);
545 
546             /// Make a note of how many tokens this user should get for their contribution to the presale
547             PRETDEContributorTokensPendingRelease[msg.sender] = PRETDEContributorTokensPendingRelease[msg.sender].add(calculateTokens(msg.value, now));
548 
549             // Keep track of pending tokens
550             TokensPurchasedDuringPRETDE += calculateTokens(msg.value, now);
551 
552             // Increment number of pre-tde contributors waiting for tokens
553             PRETDEContributorsTokensPendingCount += 1;
554 
555             // Prevent contributions that will cause us to have a shortage of tokens during the pre-sale
556             if (TokensPurchasedDuringPRETDE > dnnToken.TDESupplyRemaining()+dnnToken.PRETDESupplyRemaining()) {
557                 revert();
558             }
559 
560             // Transfer contribution directly to multisig
561             dnnHoldingMultisig.transfer(msg.value);
562         }
563 
564         // Handle public-sale contribution (tokens issued immediately)
565         else if (now >= TDEStartDate && now < TDEEndDate) buyTokens();
566 
567         // Otherwise, reject the contribution
568         else revert();
569     }
570 }
571 
572 contract ERC20 is ERC20Basic {
573   function allowance(address owner, address spender) constant returns (uint256);
574   function transferFrom(address from, address to, uint256 value) returns (bool);
575   function approve(address spender, uint256 value) returns (bool);
576   event Approval(address indexed owner, address indexed spender, uint256 value);
577 }
578 
579 library SafeMath {
580   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
581     uint256 c = a * b;
582     assert(a == 0 || c / a == b);
583     return c;
584   }
585 
586   function div(uint256 a, uint256 b) internal constant returns (uint256) {
587     // assert(b > 0); // Solidity automatically throws when dividing by 0
588     uint256 c = a / b;
589     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
590     return c;
591   }
592 
593   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
594     assert(b <= a);
595     return a - b;
596   }
597 
598   function add(uint256 a, uint256 b) internal constant returns (uint256) {
599     uint256 c = a + b;
600     assert(c >= a);
601     return c;
602   }
603 }
604 
605 contract BasicToken is ERC20Basic {
606   using SafeMath for uint256;
607 
608   mapping(address => uint256) balances;
609 
610   /**
611   * @dev transfer token for a specified address
612   * @param _to The address to transfer to.
613   * @param _value The amount to be transferred.
614   */
615   function transfer(address _to, uint256 _value) returns (bool) {
616     require(_to != address(0));
617 
618     // SafeMath.sub will throw if there is not enough balance.
619     balances[msg.sender] = balances[msg.sender].sub(_value);
620     balances[_to] = balances[_to].add(_value);
621     Transfer(msg.sender, _to, _value);
622     return true;
623   }
624 
625   /**
626   * @dev Gets the balance of the specified address.
627   * @param _owner The address to query the the balance of.
628   * @return An uint256 representing the amount owned by the passed address.
629   */
630   function balanceOf(address _owner) constant returns (uint256 balance) {
631     return balances[_owner];
632   }
633 }
634 
635 contract StandardToken is ERC20, BasicToken {
636 
637   mapping (address => mapping (address => uint256)) allowed;
638 
639 
640   /**
641    * @dev Transfer tokens from one address to another
642    * @param _from address The address which you want to send tokens from
643    * @param _to address The address which you want to transfer to
644    * @param _value uint256 the amount of tokens to be transferred
645    */
646   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
647     require(_to != address(0));
648 
649     var _allowance = allowed[_from][msg.sender];
650 
651     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
652     // require (_value <= _allowance);
653 
654     balances[_from] = balances[_from].sub(_value);
655     balances[_to] = balances[_to].add(_value);
656     allowed[_from][msg.sender] = _allowance.sub(_value);
657     Transfer(_from, _to, _value);
658     return true;
659   }
660 
661   /**
662    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
663    * @param _spender The address which will spend the funds.
664    * @param _value The amount of tokens to be spent.
665    */
666   function approve(address _spender, uint256 _value) returns (bool) {
667 
668     // To change the approve amount you first have to reduce the addresses`
669     //  allowance to zero by calling `approve(_spender, 0)` if it is not
670     //  already 0 to mitigate the race condition described here:
671     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
672     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
673 
674     allowed[msg.sender][_spender] = _value;
675     Approval(msg.sender, _spender, _value);
676     return true;
677   }
678 
679   /**
680    * @dev Function to check the amount of tokens that an owner allowed to a spender.
681    * @param _owner address The address which owns the funds.
682    * @param _spender address The address which will spend the funds.
683    * @return A uint256 specifying the amount of tokens still available for the spender.
684    */
685   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
686     return allowed[_owner][_spender];
687   }
688 
689   /**
690    * approve should be called when allowed[_spender] == 0. To increment
691    * allowed value is better to use this function to avoid 2 calls (and wait until
692    * the first transaction is mined)
693    * From MonolithDAO Token.sol
694    */
695   function increaseApproval (address _spender, uint _addedValue)
696     returns (bool success) {
697     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
698     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
699     return true;
700   }
701 
702   function decreaseApproval (address _spender, uint _subtractedValue)
703     returns (bool success) {
704     uint oldValue = allowed[msg.sender][_spender];
705     if (_subtractedValue > oldValue) {
706       allowed[msg.sender][_spender] = 0;
707     } else {
708       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
709     }
710     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
711     return true;
712   }
713 }
714 
715 contract DNNToken is StandardToken {
716 
717     using SafeMath for uint256;
718 
719     ////////////////////////////////////////////////////////////
720     // Used to indicate which allocation we issue tokens from //
721     ////////////////////////////////////////////////////////////
722     enum DNNSupplyAllocations {
723         EarlyBackerSupplyAllocation,
724         PRETDESupplyAllocation,
725         TDESupplyAllocation,
726         BountySupplyAllocation,
727         WriterAccountSupplyAllocation,
728         AdvisorySupplyAllocation,
729         PlatformSupplyAllocation
730     }
731 
732     /////////////////////////////////////////////////////////////////////
733     // Smart-Contract with permission to allocate tokens from supplies //
734     /////////////////////////////////////////////////////////////////////
735     address public allocatorAddress;
736     address public crowdfundContract;
737 
738     /////////////////////
739     // Token Meta Data //
740     /////////////////////
741     string constant public name = "DNN";
742     string constant public symbol = "DNN";
743     uint8 constant public decimals = 18; // 1 DNN = 1 * 10^18 atto-DNN
744 
745     /////////////////////////////////////////
746     // Addresses of the co-founders of DNN //
747     /////////////////////////////////////////
748     address public cofounderA;
749     address public cofounderB;
750 
751     /////////////////////////
752     // Address of Platform //
753     /////////////////////////
754     address public platform;
755 
756     /////////////////////////////////////////////
757     // Token Distributions (% of total supply) //
758     /////////////////////////////////////////////
759     uint256 public earlyBackerSupply; // 10%
760     uint256 public PRETDESupply; // 10%
761     uint256 public TDESupply; // 40%
762     uint256 public bountySupply; // 1%
763     uint256 public writerAccountSupply; // 4%
764     uint256 public advisorySupply; // 14%
765     uint256 public cofoundersSupply; // 10%
766     uint256 public platformSupply; // 11%
767 
768     uint256 public earlyBackerSupplyRemaining; // 10%
769     uint256 public PRETDESupplyRemaining; // 10%
770     uint256 public TDESupplyRemaining; // 40%
771     uint256 public bountySupplyRemaining; // 1%
772     uint256 public writerAccountSupplyRemaining; // 4%
773     uint256 public advisorySupplyRemaining; // 14%
774     uint256 public cofoundersSupplyRemaining; // 10%
775     uint256 public platformSupplyRemaining; // 11%
776 
777     ////////////////////////////////////////////////////////////////////////////////////
778     // Amount of CoFounder Supply that has been distributed based on vesting schedule //
779     ////////////////////////////////////////////////////////////////////////////////////
780     uint256 public cofoundersSupplyVestingTranches = 10;
781     uint256 public cofoundersSupplyVestingTranchesIssued = 0;
782     uint256 public cofoundersSupplyVestingStartDate; // Epoch
783     uint256 public cofoundersSupplyDistributed = 0;  // # of atto-DNN distributed to founders
784 
785     //////////////////////////////////////////////
786     // Prevents tokens from being transferrable //
787     //////////////////////////////////////////////
788     bool public tokensLocked = true;
789 
790     /////////////////////////////////////////////////////////////////////////////
791     // Event triggered when tokens are transferred from one address to another //
792     /////////////////////////////////////////////////////////////////////////////
793     event Transfer(address indexed from, address indexed to, uint256 value);
794 
795     ////////////////////////////////////////////////////////////
796     // Checks if tokens can be issued to founder at this time //
797     ////////////////////////////////////////////////////////////
798     modifier CofoundersTokensVested()
799     {
800         // Make sure that a starting vesting date has been set and 4 weeks have passed since vesting date
801         require (cofoundersSupplyVestingStartDate != 0 && (now-cofoundersSupplyVestingStartDate) >= 4 weeks);
802 
803         // Get current tranche based on the amount of time that has passed since vesting start date
804         uint256 currentTranche = now.sub(cofoundersSupplyVestingStartDate) / 4 weeks;
805 
806         // Amount of tranches that have been issued so far
807         uint256 issuedTranches = cofoundersSupplyVestingTranchesIssued;
808 
809         // Amount of tranches that cofounders are entitled to
810         uint256 maxTranches = cofoundersSupplyVestingTranches;
811 
812         // Make sure that we still have unvested tokens and that
813         // the tokens for the current tranche have not been issued.
814         require (issuedTranches != maxTranches && currentTranche > issuedTranches);
815 
816         _;
817     }
818 
819     ///////////////////////////////////
820     // Checks if tokens are unlocked //
821     ///////////////////////////////////
822     modifier TokensUnlocked()
823     {
824         require (tokensLocked == false);
825         _;
826     }
827 
828     /////////////////////////////////
829     // Checks if tokens are locked //
830     /////////////////////////////////
831     modifier TokensLocked()
832     {
833        require (tokensLocked == true);
834        _;
835     }
836 
837     ////////////////////////////////////////////////////
838     // Checks if CoFounders are performing the action //
839     ////////////////////////////////////////////////////
840     modifier onlyCofounders()
841     {
842         require (msg.sender == cofounderA || msg.sender == cofounderB);
843         _;
844     }
845 
846     ////////////////////////////////////////////////////
847     // Checks if CoFounder A is performing the action //
848     ////////////////////////////////////////////////////
849     modifier onlyCofounderA()
850     {
851         require (msg.sender == cofounderA);
852         _;
853     }
854 
855     ////////////////////////////////////////////////////
856     // Checks if CoFounder B is performing the action //
857     ////////////////////////////////////////////////////
858     modifier onlyCofounderB()
859     {
860         require (msg.sender == cofounderB);
861         _;
862     }
863 
864     /////////////////////////////////////////////////////////////////////
865     // Checks to see if we are allowed to change the allocator address //
866     /////////////////////////////////////////////////////////////////////
867     modifier CanSetAllocator()
868     {
869        require (allocatorAddress == address(0x0) || tokensLocked == false);
870        _;
871     }
872 
873     //////////////////////////////////////////////////////////////////////
874     // Checks to see if we are allowed to change the crowdfund contract //
875     //////////////////////////////////////////////////////////////////////
876     modifier CanSetCrowdfundContract()
877     {
878        require (crowdfundContract == address(0x0));
879        _;
880     }
881 
882     //////////////////////////////////////////////////
883     // Checks if Allocator is performing the action //
884     //////////////////////////////////////////////////
885     modifier onlyAllocator()
886     {
887         require (msg.sender == allocatorAddress && tokensLocked == false);
888         _;
889     }
890 
891     ///////////////////////////////////////////////////////////
892     // Checks if Crowdfund Contract is performing the action //
893     ///////////////////////////////////////////////////////////
894     modifier onlyCrowdfundContract()
895     {
896         require (msg.sender == crowdfundContract);
897         _;
898     }
899 
900     ///////////////////////////////////////////////////////////////////////////////////
901     // Checks if Crowdfund Contract, Platform, or Allocator is performing the action //
902     ///////////////////////////////////////////////////////////////////////////////////
903     modifier onlyAllocatorOrCrowdfundContractOrPlatform()
904     {
905         require (msg.sender == allocatorAddress || msg.sender == crowdfundContract || msg.sender == platform);
906         _;
907     }
908 
909     ///////////////////////////////////////////////////////////////////////
910     //  @des Function to change address that is manage platform holding  //
911     //  @param newAddress Address of new issuance contract.              //
912     ///////////////////////////////////////////////////////////////////////
913     function changePlatform(address newAddress)
914         onlyCofounders
915     {
916         platform = newAddress;
917     }
918 
919     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
920     //  @des Function to change address that is allowed to do token issuance. Crowdfund contract can only be set once.   //
921     //  @param newAddress Address of new issuance contract.                                                              //
922     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
923     function changeCrowdfundContract(address newAddress)
924         onlyCofounders
925         CanSetCrowdfundContract
926     {
927         crowdfundContract = newAddress;
928     }
929 
930     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
931     //  @des Function to change address that is allowed to do token issuance. Allocator can only be set once.  //
932     //  @param newAddress Address of new issuance contract.                                                    //
933     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
934     function changeAllocator(address newAddress)
935         onlyCofounders
936         CanSetAllocator
937     {
938         allocatorAddress = newAddress;
939     }
940 
941     ///////////////////////////////////////////////////////
942     //  @des Function to change founder A address.       //
943     //  @param newAddress Address of new founder A.      //
944     ///////////////////////////////////////////////////////
945     function changeCofounderA(address newAddress)
946         onlyCofounderA
947     {
948         cofounderA = newAddress;
949     }
950 
951     //////////////////////////////////////////////////////
952     //  @des Function to change founder B address.      //
953     //  @param newAddress Address of new founder B.     //
954     //////////////////////////////////////////////////////
955     function changeCofounderB(address newAddress)
956         onlyCofounderB
957     {
958         cofounderB = newAddress;
959     }
960 
961 
962     //////////////////////////////////////////////////////////////
963     // Transfers tokens from senders address to another address //
964     //////////////////////////////////////////////////////////////
965     function transfer(address _to, uint256 _value)
966       TokensUnlocked
967       returns (bool)
968     {
969           Transfer(msg.sender, _to, _value);
970           return BasicToken.transfer(_to, _value);
971     }
972 
973     //////////////////////////////////////////////////////////
974     // Transfers tokens from one address to another address //
975     //////////////////////////////////////////////////////////
976     function transferFrom(address _from, address _to, uint256 _value)
977       TokensUnlocked
978       returns (bool)
979     {
980           Transfer(_from, _to, _value);
981           return StandardToken.transferFrom(_from, _to, _value);
982     }
983 
984 
985     ///////////////////////////////////////////////////////////////////////////////////////////////
986     //  @des Cofounders issue tokens to themsleves if within vesting period. Returns success.    //
987     //  @param beneficiary Address of receiver.                                                  //
988     //  @param tokenCount Number of tokens to issue.                                             //
989     ///////////////////////////////////////////////////////////////////////////////////////////////
990     function issueCofoundersTokensIfPossible()
991         onlyCofounders
992         CofoundersTokensVested
993         returns (bool)
994     {
995         // Compute total amount of vested tokens to issue
996         uint256 tokenCount = cofoundersSupply.div(cofoundersSupplyVestingTranches);
997 
998         // Make sure that there are cofounder tokens left
999         if (tokenCount > cofoundersSupplyRemaining) {
1000            return false;
1001         }
1002 
1003         // Decrease cofounders supply
1004         cofoundersSupplyRemaining = cofoundersSupplyRemaining.sub(tokenCount);
1005 
1006         // Update how many tokens have been distributed to cofounders
1007         cofoundersSupplyDistributed = cofoundersSupplyDistributed.add(tokenCount);
1008 
1009         // Split tokens between both founders
1010         balances[cofounderA] = balances[cofounderA].add(tokenCount.div(2));
1011         balances[cofounderB] = balances[cofounderB].add(tokenCount.div(2));
1012 
1013         // Update that a tranche has been issued
1014         cofoundersSupplyVestingTranchesIssued += 1;
1015 
1016         return true;
1017     }
1018 
1019 
1020     //////////////////
1021     // Issue tokens //
1022     //////////////////
1023     function issueTokens(address beneficiary, uint256 tokenCount, DNNSupplyAllocations allocationType)
1024       onlyAllocatorOrCrowdfundContractOrPlatform
1025       returns (bool)
1026     {
1027         // We'll use the following to determine whether the allocator, platform,
1028         // or the crowdfunding contract can allocate specified supply
1029         bool canAllocatorPerform = msg.sender == allocatorAddress && tokensLocked == false;
1030         bool canCrowdfundContractPerform = msg.sender == crowdfundContract;
1031         bool canPlatformPerform = msg.sender == platform && tokensLocked == false;
1032 
1033         // Early Backers
1034         if (canAllocatorPerform && allocationType == DNNSupplyAllocations.EarlyBackerSupplyAllocation && tokenCount <= earlyBackerSupplyRemaining) {
1035             earlyBackerSupplyRemaining = earlyBackerSupplyRemaining.sub(tokenCount);
1036         }
1037 
1038         // PRE-TDE
1039         else if (canCrowdfundContractPerform && msg.sender == crowdfundContract && allocationType == DNNSupplyAllocations.PRETDESupplyAllocation) {
1040 
1041               // Check to see if we have enough tokens to satisfy this purchase
1042               // using just the pre-tde.
1043               if (PRETDESupplyRemaining >= tokenCount) {
1044 
1045                     // Decrease pre-tde supply
1046                     PRETDESupplyRemaining = PRETDESupplyRemaining.sub(tokenCount);
1047               }
1048 
1049               // Check to see if we can satisfy this using pre-tde and tde supply combined
1050               else if (PRETDESupplyRemaining+TDESupplyRemaining >= tokenCount) {
1051 
1052                     // Decrease tde supply
1053                     TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount-PRETDESupplyRemaining);
1054 
1055                     // Decrease pre-tde supply by its' remaining tokens
1056                     PRETDESupplyRemaining = 0;
1057               }
1058 
1059               // Otherwise, we can't satisfy this sale because we don't have enough tokens.
1060               else {
1061                   return false;
1062               }
1063         }
1064 
1065         // TDE
1066         else if (canCrowdfundContractPerform && allocationType == DNNSupplyAllocations.TDESupplyAllocation && tokenCount <= TDESupplyRemaining) {
1067             TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount);
1068         }
1069 
1070         // Bounty
1071         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.BountySupplyAllocation && tokenCount <= bountySupplyRemaining) {
1072             bountySupplyRemaining = bountySupplyRemaining.sub(tokenCount);
1073         }
1074 
1075         // Writer Accounts
1076         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.WriterAccountSupplyAllocation && tokenCount <= writerAccountSupplyRemaining) {
1077             writerAccountSupplyRemaining = writerAccountSupplyRemaining.sub(tokenCount);
1078         }
1079 
1080         // Advisory
1081         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.AdvisorySupplyAllocation && tokenCount <= advisorySupplyRemaining) {
1082             advisorySupplyRemaining = advisorySupplyRemaining.sub(tokenCount);
1083         }
1084 
1085         // Platform (Also makes sure that the beneficiary is the platform address specified in this contract)
1086         else if (canPlatformPerform && allocationType == DNNSupplyAllocations.PlatformSupplyAllocation && tokenCount <= platformSupplyRemaining) {
1087             platformSupplyRemaining = platformSupplyRemaining.sub(tokenCount);
1088         }
1089 
1090         else {
1091             return false;
1092         }
1093 
1094         // Credit tokens to the address specified
1095         balances[beneficiary] = balances[beneficiary].add(tokenCount);
1096 
1097         return true;
1098     }
1099 
1100     /////////////////////////////////////////////////
1101     // Transfer Unsold tokens from TDE to Platform //
1102     /////////////////////////////////////////////////
1103     function sendUnsoldTDETokensToPlatform()
1104       external
1105       onlyCrowdfundContract
1106     {
1107         // Make sure we have tokens to send from TDE
1108         if (TDESupplyRemaining > 0) {
1109 
1110             // Add remaining tde tokens to platform remaining tokens
1111             platformSupplyRemaining = platformSupplyRemaining.add(TDESupplyRemaining);
1112 
1113             // Clear remaining tde token count
1114             TDESupplyRemaining = 0;
1115         }
1116     }
1117 
1118     /////////////////////////////////////////////////////
1119     // Transfer Unsold tokens from pre-TDE to Platform //
1120     /////////////////////////////////////////////////////
1121     function sendUnsoldPRETDETokensToTDE()
1122       external
1123       onlyCrowdfundContract
1124     {
1125           // Make sure we have tokens to send from pre-TDE
1126           if (PRETDESupplyRemaining > 0) {
1127 
1128               // Add remaining pre-tde tokens to tde remaining tokens
1129               TDESupplyRemaining = TDESupplyRemaining.add(PRETDESupplyRemaining);
1130 
1131               // Clear remaining pre-tde token count
1132               PRETDESupplyRemaining = 0;
1133         }
1134     }
1135 
1136     ////////////////////////////////////////////////////////////////
1137     // @des Allows tokens to be transferrable. Returns lock state //
1138     ////////////////////////////////////////////////////////////////
1139     function unlockTokens()
1140         external
1141         onlyCrowdfundContract
1142     {
1143         // Make sure tokens are currently locked before proceeding to unlock them
1144         require(tokensLocked == true);
1145 
1146         tokensLocked = false;
1147     }
1148 
1149     ///////////////////////////////////////////////////////////////////////
1150     //  @des Contract constructor function sets initial token balances.  //
1151     ///////////////////////////////////////////////////////////////////////
1152     function DNNToken(address founderA, address founderB, address platformAddress, uint256 vestingStartDate)
1153     {
1154           // Set cofounder addresses
1155           cofounderA = founderA;
1156           cofounderB = founderB;
1157 
1158           // Sets platform address
1159           platform = platformAddress;
1160 
1161           // Set total supply - 1 Billion DNN Tokens = (1,000,000,000 * 10^18) atto-DNN
1162           // 1 DNN = 10^18 atto-DNN
1163           totalSupply = uint256(1000000000).mul(uint256(10)**decimals);
1164 
1165           // Set Token Distributions (% of total supply)
1166           earlyBackerSupply = totalSupply.mul(10).div(100); // 10%
1167           PRETDESupply = totalSupply.mul(10).div(100); // 10%
1168           TDESupply = totalSupply.mul(40).div(100); // 40%
1169           bountySupply = totalSupply.mul(1).div(100); // 1%
1170           writerAccountSupply = totalSupply.mul(4).div(100); // 4%
1171           advisorySupply = totalSupply.mul(14).div(100); // 14%
1172           cofoundersSupply = totalSupply.mul(10).div(100); // 10%
1173           platformSupply = totalSupply.mul(11).div(100); // 11%
1174 
1175           // Set each remaining token count equal to its' respective supply
1176           earlyBackerSupplyRemaining = earlyBackerSupply;
1177           PRETDESupplyRemaining = PRETDESupply;
1178           TDESupplyRemaining = TDESupply;
1179           bountySupplyRemaining = bountySupply;
1180           writerAccountSupplyRemaining = writerAccountSupply;
1181           advisorySupplyRemaining = advisorySupply;
1182           cofoundersSupplyRemaining = cofoundersSupply;
1183           platformSupplyRemaining = platformSupply;
1184 
1185           // Sets cofounder vesting start date (Ensures that it is a date in the future, otherwise it will default to now)
1186           cofoundersSupplyVestingStartDate = vestingStartDate >= now ? vestingStartDate : now;
1187     }
1188 }