1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116 
117     uint256 _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval (address _spender, uint _addedValue)
162     returns (bool success) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval (address _spender, uint _subtractedValue)
169     returns (bool success) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180 }
181 
182 contract AbstractStarbaseCrowdsale {
183     function startDate() constant returns (uint256) {}
184     function endedAt() constant returns (uint256) {}
185     function isEnded() constant returns (bool);
186     function totalRaisedAmountInCny() constant returns (uint256);
187     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
188     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
189 }
190 
191 contract AbstractStarbaseMarketingCampaign {}
192 
193 /// @title Token contract - ERC20 compatible Starbase token contract.
194 /// @author Starbase PTE. LTD. - <info@starbase.co>
195 contract StarbaseToken is StandardToken {
196     /*
197      *  Events
198      */
199     event PublicOfferingPlanDeclared(uint256 tokenCount, uint256 unlockCompanysTokensAt);
200     event MvpLaunched(uint256 launchedAt);
201     event LogNewFundraiser (address indexed fundraiserAddress, bool isBonaFide);
202     event LogUpdateFundraiser(address indexed fundraiserAddress, bool isBonaFide);
203 
204     /*
205      *  Types
206      */
207     struct PublicOfferingPlan {
208         uint256 tokenCount;
209         uint256 unlockCompanysTokensAt;
210         uint256 declaredAt;
211     }
212 
213     /*
214      *  External contracts
215      */
216     AbstractStarbaseCrowdsale public starbaseCrowdsale;
217     AbstractStarbaseMarketingCampaign public starbaseMarketingCampaign;
218 
219     /*
220      *  Storage
221      */
222     address public company;
223     PublicOfferingPlan[] public publicOfferingPlans;  // further crowdsales
224     mapping(address => uint256) public initialEcTokenAllocation;    // Initial token allocations for Early Contributors
225     uint256 public mvpLaunchedAt;  // 0 until a MVP of Starbase Platform launches
226     mapping(address => bool) private fundraisers; // Fundraisers are vetted addresses that are allowed to execute functions within the contract
227 
228     /*
229      *  Constants / Token meta data
230      */
231     string constant public name = "Starbase";  // Token name
232     string constant public symbol = "STAR";  // Token symbol
233     uint8 constant public decimals = 18;
234     uint256 constant public initialSupply = 1000000000e18; // 1B STAR tokens
235     uint256 constant public initialCompanysTokenAllocation = 750000000e18;  // 750M
236     uint256 constant public initialBalanceForCrowdsale = 175000000e18;  // CS(125M)+EP(50M)
237     uint256 constant public initialBalanceForMarketingCampaign = 12500000e18;   // 12.5M
238 
239     /*
240      *  Modifiers
241      */
242     modifier onlyCrowdsaleContract() {
243         assert(msg.sender == address(starbaseCrowdsale));
244         _;
245     }
246 
247     modifier onlyMarketingCampaignContract() {
248         assert(msg.sender == address(starbaseMarketingCampaign));
249         _;
250     }
251 
252     modifier onlyFundraiser() {
253         // Only rightful fundraiser is permitted.
254         assert(isFundraiser(msg.sender));
255         _;
256     }
257 
258     modifier onlyBeforeCrowdsale() {
259         require(starbaseCrowdsale.startDate() == 0);
260         _;
261     }
262 
263     modifier onlyAfterCrowdsale() {
264         require(starbaseCrowdsale.isEnded());
265         _;
266     }
267 
268     /*
269      *  Contract functions
270      */
271 
272     /**
273      * @dev Contract constructor function
274      * @param starbaseCompanyAddr The address that will holds untransferrable tokens
275      * @param starbaseCrowdsaleAddr Address of the crowdsale contract
276      * @param starbaseMarketingCampaignAddr The address of the marketing campaign contract
277      */
278 
279     function StarbaseToken(
280         address starbaseCompanyAddr,
281         address starbaseCrowdsaleAddr,
282         address starbaseMarketingCampaignAddr
283     ) {
284         assert(
285             starbaseCompanyAddr != 0 &&
286             starbaseCrowdsaleAddr != 0 &&
287             starbaseMarketingCampaignAddr != 0);
288 
289         starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddr);
290         starbaseMarketingCampaign = AbstractStarbaseMarketingCampaign(starbaseMarketingCampaignAddr);
291         company = starbaseCompanyAddr;
292 
293         // msg.sender becomes first fundraiser
294         fundraisers[msg.sender] = true;
295         LogNewFundraiser(msg.sender, true);
296 
297         // Tokens for crowdsale and early purchasers
298         balances[address(starbaseCrowdsale)] = initialBalanceForCrowdsale;
299 
300         // Tokens for marketing campaign supporters
301         balances[address(starbaseMarketingCampaign)] = initialBalanceForMarketingCampaign;
302 
303         // Tokens for early contributors, should be allocated by function
304         balances[0] = 62500000e18; // 62.5M
305 
306         // Starbase company holds untransferrable tokens initially
307         balances[starbaseCompanyAddr] = initialCompanysTokenAllocation; // 750M
308 
309         totalSupply = initialSupply;    // 1B
310     }
311 
312     /**
313      * @dev Setup function sets external contracts' addresses
314      * @param starbaseCrowdsaleAddr Crowdsale contract address.
315      * @param starbaseMarketingCampaignAddr Marketing campaign contract address
316      */
317     function setup(address starbaseCrowdsaleAddr, address starbaseMarketingCampaignAddr)
318         external
319         onlyFundraiser
320         onlyBeforeCrowdsale
321         returns (bool)
322     {
323         require(starbaseCrowdsaleAddr != 0 && starbaseMarketingCampaignAddr != 0);
324         assert(balances[address(starbaseCrowdsale)] == initialBalanceForCrowdsale);
325         assert(balances[address(starbaseMarketingCampaign)] == initialBalanceForMarketingCampaign);
326 
327         // Move the balances to the new ones
328         balances[address(starbaseCrowdsale)] = 0;
329         balances[address(starbaseMarketingCampaign)] = 0;
330         balances[starbaseCrowdsaleAddr] = initialBalanceForCrowdsale;
331         balances[starbaseMarketingCampaignAddr] = initialBalanceForMarketingCampaign;
332 
333         // Update the references
334         starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddr);
335         starbaseMarketingCampaign = AbstractStarbaseMarketingCampaign(starbaseMarketingCampaignAddr);
336         return true;
337     }
338 
339     /*
340      *  External functions
341      */
342 
343     /**
344      * @dev Returns number of declared public offering plans
345      */
346     function numOfDeclaredPublicOfferingPlans()
347         external
348         constant
349         returns (uint256)
350     {
351         return publicOfferingPlans.length;
352     }
353 
354     /**
355      * @dev Declares a public offering plan to make company's tokens transferable
356      * @param tokenCount Number of tokens to transfer.
357      * @param unlockCompanysTokensAt Time of the tokens will be unlocked
358      */
359     function declarePublicOfferingPlan(uint256 tokenCount, uint256 unlockCompanysTokensAt)
360         external
361         onlyFundraiser
362         onlyAfterCrowdsale
363         returns (bool)
364     {
365         assert(tokenCount <= 100000000e18);    // shall not exceed 100M tokens
366         assert(SafeMath.sub(now, starbaseCrowdsale.endedAt()) >= 180 days);   // shall not be declared for 6 months after the crowdsale ended
367         assert(SafeMath.sub(unlockCompanysTokensAt, now) >= 60 days);   // tokens must be untransferable at least for 2 months
368 
369         // check if last declaration was more than 6 months ago
370         if (publicOfferingPlans.length > 0) {
371             uint256 lastDeclaredAt =
372                 publicOfferingPlans[publicOfferingPlans.length - 1].declaredAt;
373             assert(SafeMath.sub(now, lastDeclaredAt) >= 180 days);
374         }
375 
376         uint256 totalDeclaredTokenCount = tokenCount;
377         for (uint8 i; i < publicOfferingPlans.length; i++) {
378             totalDeclaredTokenCount = SafeMath.add(totalDeclaredTokenCount, publicOfferingPlans[i].tokenCount);
379         }
380         assert(totalDeclaredTokenCount <= initialCompanysTokenAllocation);   // shall not exceed the initial token allocation
381 
382         publicOfferingPlans.push(
383             PublicOfferingPlan(tokenCount, unlockCompanysTokensAt, now));
384 
385         PublicOfferingPlanDeclared(tokenCount, unlockCompanysTokensAt);
386     }
387 
388     /**
389      * @dev Allocate tokens to a marketing supporter from the marketing campaign share
390      * @param to Address to where tokens are allocated
391      * @param value Number of tokens to transfer
392      */
393     function allocateToMarketingSupporter(address to, uint256 value)
394         external
395         onlyMarketingCampaignContract
396         returns (bool)
397     {
398         return allocateFrom(address(starbaseMarketingCampaign), to, value);
399     }
400 
401     /**
402      * @dev Allocate tokens to an early contributor from the early contributor share
403      * @param to Address to where tokens are allocated
404      * @param value Number of tokens to transfer
405      */
406     function allocateToEarlyContributor(address to, uint256 value)
407         external
408         onlyFundraiser
409         returns (bool)
410     {
411         initialEcTokenAllocation[to] =
412             SafeMath.add(initialEcTokenAllocation[to], value);
413         return allocateFrom(0, to, value);
414     }
415 
416     /**
417      * @dev Issue new tokens according to the STAR token inflation limits
418      * @param _for Address to where tokens are allocated
419      * @param value Number of tokens to issue
420      */
421     function issueTokens(address _for, uint256 value)
422         external
423         onlyFundraiser
424         onlyAfterCrowdsale
425         returns (bool)
426     {
427         // check if the value under the limits
428         assert(value <= numOfInflatableTokens());
429 
430         totalSupply = SafeMath.add(totalSupply, value);
431         balances[_for] = SafeMath.add(balances[_for], value);
432         return true;
433     }
434 
435     /**
436      * @dev Declares Starbase MVP has been launched
437      * @param launchedAt When the MVP launched (timestamp)
438      */
439     function declareMvpLaunched(uint256 launchedAt)
440         external
441         onlyFundraiser
442         onlyAfterCrowdsale
443         returns (bool)
444     {
445         require(mvpLaunchedAt == 0); // overwriting the launch date is not permitted
446         require(launchedAt <= now);
447         require(starbaseCrowdsale.isEnded());
448 
449         mvpLaunchedAt = launchedAt;
450         MvpLaunched(launchedAt);
451         return true;
452     }
453 
454     /**
455      * @dev Allocate tokens to a crowdsale or early purchaser from the crowdsale share
456      * @param to Address to where tokens are allocated
457      * @param value Number of tokens to transfer
458      */
459     function allocateToCrowdsalePurchaser(address to, uint256 value)
460         external
461         onlyCrowdsaleContract
462         onlyAfterCrowdsale
463         returns (bool)
464     {
465         return allocateFrom(address(starbaseCrowdsale), to, value);
466     }
467 
468     /*
469      *  Public functions
470      */
471 
472     /**
473      * @dev Transfers sender's tokens to a given address. Returns success.
474      * @param to Address of token receiver.
475      * @param value Number of tokens to transfer.
476      */
477     function transfer(address to, uint256 value) public returns (bool) {
478         assert(isTransferable(msg.sender, value));
479         return super.transfer(to, value);
480     }
481 
482     /**
483      * @dev Allows third party to transfer tokens from one address to another. Returns success.
484      * @param from Address from where tokens are withdrawn.
485      * @param to Address to where tokens are sent.
486      * @param value Number of tokens to transfer.
487      */
488     function transferFrom(address from, address to, uint256 value) public returns (bool) {
489         assert(isTransferable(from, value));
490         return super.transferFrom(from, to, value);
491     }
492 
493     /**
494      * @dev Adds fundraiser. Only called by another fundraiser.
495      * @param fundraiserAddress The address in check
496      */
497     function addFundraiser(address fundraiserAddress) public onlyFundraiser {
498         assert(!isFundraiser(fundraiserAddress));
499 
500         fundraisers[fundraiserAddress] = true;
501         LogNewFundraiser(fundraiserAddress, true);
502     }
503 
504     /**
505      * @dev Update fundraiser address rights.
506      * @param fundraiserAddress The address to update
507      * @param isBonaFide Boolean that denotes whether fundraiser is active or not.
508      */
509     function updateFundraiser(address fundraiserAddress, bool isBonaFide)
510        public
511        onlyFundraiser
512        returns(bool)
513     {
514         assert(isFundraiser(fundraiserAddress));
515 
516         fundraisers[fundraiserAddress] = isBonaFide;
517         LogUpdateFundraiser(fundraiserAddress, isBonaFide);
518         return true;
519     }
520 
521     /**
522      * @dev Returns whether fundraiser address has rights.
523      * @param fundraiserAddress The address in check
524      */
525     function isFundraiser(address fundraiserAddress) constant public returns(bool) {
526         return fundraisers[fundraiserAddress];
527     }
528 
529     /**
530      * @dev Returns whether the transferring of tokens is available fundraiser.
531      * @param from Address of token sender
532      * @param tokenCount Number of tokens to transfer.
533      */
534     function isTransferable(address from, uint256 tokenCount)
535         constant
536         public
537         returns (bool)
538     {
539         if (tokenCount == 0 || balances[from] < tokenCount) {
540             return false;
541         }
542 
543         // company's tokens may be locked up
544         if (from == company) {
545             if (tokenCount > numOfTransferableCompanysTokens()) {
546                 return false;
547             }
548         }
549 
550         uint256 untransferableTokenCount = 0;
551 
552         // early contributor's tokens may be locked up
553         if (initialEcTokenAllocation[from] > 0) {
554             untransferableTokenCount = SafeMath.add(
555                 untransferableTokenCount,
556                 numOfUntransferableEcTokens(from));
557         }
558 
559         // EP and CS purchasers' tokens should be untransferable initially
560         if (starbaseCrowdsale.isEnded()) {
561             uint256 passedDays =
562                 SafeMath.sub(now, starbaseCrowdsale.endedAt()) / 86400; // 1d = 86400s
563             if (passedDays < 7) {  // within a week
564                 // crowdsale purchasers cannot transfer their tokens for a week
565                 untransferableTokenCount = SafeMath.add(
566                     untransferableTokenCount,
567                     starbaseCrowdsale.numOfPurchasedTokensOnCsBy(from));
568             }
569             if (passedDays < 14) {  // within two weeks
570                 // early purchasers cannot transfer their tokens for two weeks
571                 untransferableTokenCount = SafeMath.add(
572                     untransferableTokenCount,
573                     starbaseCrowdsale.numOfPurchasedTokensOnEpBy(from));
574             }
575         }
576 
577         uint256 transferableTokenCount =
578             SafeMath.sub(balances[from], untransferableTokenCount);
579 
580         if (transferableTokenCount < tokenCount) {
581             return false;
582         } else {
583             return true;
584         }
585     }
586 
587     /**
588      * @dev Returns the number of transferable company's tokens
589      */
590     function numOfTransferableCompanysTokens() constant public returns (uint256) {
591         uint256 unlockedTokens = 0;
592         for (uint8 i; i < publicOfferingPlans.length; i++) {
593             PublicOfferingPlan memory plan = publicOfferingPlans[i];
594             if (plan.unlockCompanysTokensAt <= now) {
595                 unlockedTokens = SafeMath.add(unlockedTokens, plan.tokenCount);
596             }
597         }
598         return SafeMath.sub(
599             balances[company],
600             initialCompanysTokenAllocation - unlockedTokens);
601     }
602 
603     /**
604      * @dev Returns the number of untransferable tokens of the early contributor
605      * @param _for Address of early contributor to check
606      */
607     function numOfUntransferableEcTokens(address _for) constant public returns (uint256) {
608         uint256 initialCount = initialEcTokenAllocation[_for];
609         if (mvpLaunchedAt == 0) {
610             return initialCount;
611         }
612 
613         uint256 passedWeeks = SafeMath.sub(now, mvpLaunchedAt) / 7 days;
614         if (passedWeeks <= 52) {    // a year ≈ 52 weeks
615             // all tokens should be locked up for a year
616             return initialCount;
617         }
618 
619         // unlock 1/52 tokens every weeks after a year
620         uint256 transferableTokenCount = initialCount / 52 * (passedWeeks - 52);
621         if (transferableTokenCount >= initialCount) {
622             return 0;
623         } else {
624             return SafeMath.sub(initialCount, transferableTokenCount);
625         }
626     }
627 
628     /**
629      * @dev Returns number of tokens which can be issued according to the inflation rules
630      */
631     function numOfInflatableTokens() constant public returns (uint256) {
632         if (starbaseCrowdsale.endedAt() == 0) {
633             return 0;
634         }
635         uint256 passedDays = SafeMath.sub(now, starbaseCrowdsale.endedAt()) / 86400;  // 1d = 60s * 60m * 24h = 86400s
636         uint256 passedYears = passedDays * 100 / 36525;    // about 365.25 days in a year
637         uint256 inflatedSupply = initialSupply;
638         for (uint256 i; i < passedYears; i++) {
639             inflatedSupply = SafeMath.add(inflatedSupply, SafeMath.mul(inflatedSupply, 25) / 1000); // 2.5%/y = 0.025/y
640         }
641 
642         uint256 remainderedDays = passedDays * 100 % 36525 / 100;
643         if (remainderedDays > 0) {
644             uint256 inflatableTokensOfNextYear =
645                 SafeMath.mul(inflatedSupply, 25) / 1000;
646             inflatedSupply = SafeMath.add(inflatedSupply, SafeMath.mul(
647                 inflatableTokensOfNextYear, remainderedDays * 100) / 36525);
648         }
649 
650         return SafeMath.sub(inflatedSupply, totalSupply);
651     }
652 
653     /*
654      *  Internal functions
655      */
656 
657     /**
658      * @dev Allocate tokens value from an address to another one. This function is only called internally.
659      * @param from Address from where tokens come
660      * @param to Address to where tokens are allocated
661      * @param value Number of tokens to transfer
662      */
663     function allocateFrom(address from, address to, uint256 value) internal returns (bool) {
664         assert(value > 0 && balances[from] >= value);
665         balances[from] = SafeMath.sub(balances[from], value);
666         balances[to] = SafeMath.add(balances[to], value);
667         Transfer(from, to, value);
668         return true;
669     }
670 }