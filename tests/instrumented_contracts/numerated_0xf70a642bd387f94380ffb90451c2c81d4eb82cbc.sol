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
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
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
101   mapping (address => mapping (address => uint256)) allowed;
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
112 
113     uint256 _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval (address _spender, uint _addedValue)
158     returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue)
165     returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 contract AbstractStarbaseCrowdsale {
179     function startDate() constant returns (uint256) {}
180     function endedAt() constant returns (uint256) {}
181     function isEnded() constant returns (bool);
182     function totalRaisedAmountInCny() constant returns (uint256);
183     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
184     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
185 }
186 
187 contract AbstractStarbaseMarketingCampaign {}
188 
189 /// @title Token contract - ERC20 compatible Starbase token contract.
190 /// @author Starbase PTE. LTD. - <info@starbase.co>
191 contract StarbaseToken is StandardToken {
192     /*
193      *  Events
194      */
195     event PublicOfferingPlanDeclared(uint256 tokenCount, uint256 unlockCompanysTokensAt);
196     event MvpLaunched(uint256 launchedAt);
197     event LogNewFundraiser (address indexed fundraiserAddress, bool isBonaFide);
198     event LogUpdateFundraiser(address indexed fundraiserAddress, bool isBonaFide);
199 
200     /*
201      *  Types
202      */
203     struct PublicOfferingPlan {
204         uint256 tokenCount;
205         uint256 unlockCompanysTokensAt;
206         uint256 declaredAt;
207     }
208 
209     /*
210      *  External contracts
211      */
212     AbstractStarbaseCrowdsale public starbaseCrowdsale;
213     AbstractStarbaseMarketingCampaign public starbaseMarketingCampaign;
214 
215     /*
216      *  Storage
217      */
218     address public company;
219     PublicOfferingPlan[] public publicOfferingPlans;  // further crowdsales
220     mapping(address => uint256) public initialEcTokenAllocation;    // Initial token allocations for Early Contributors
221     uint256 public mvpLaunchedAt;  // 0 until a MVP of Starbase Platform launches
222     mapping(address => bool) private fundraisers; // Fundraisers are vetted addresses that are allowed to execute functions within the contract
223 
224     /*
225      *  Constants / Token meta data
226      */
227     string constant public name = "Starbase";  // Token name
228     string constant public symbol = "STAR";  // Token symbol
229     uint8 constant public decimals = 18;
230     uint256 constant public initialSupply = 1000000000e18; // 1B STAR tokens
231     uint256 constant public initialCompanysTokenAllocation = 750000000e18;  // 750M
232     uint256 constant public initialBalanceForCrowdsale = 175000000e18;  // CS(125M)+EP(50M)
233     uint256 constant public initialBalanceForMarketingCampaign = 12500000e18;   // 12.5M
234 
235     /*
236      *  Modifiers
237      */
238     modifier onlyCrowdsaleContract() {
239         assert(msg.sender == address(starbaseCrowdsale));
240         _;
241     }
242 
243     modifier onlyMarketingCampaignContract() {
244         assert(msg.sender == address(starbaseMarketingCampaign));
245         _;
246     }
247 
248     modifier onlyFundraiser() {
249         // Only rightful fundraiser is permitted.
250         assert(isFundraiser(msg.sender));
251         _;
252     }
253 
254     modifier onlyBeforeCrowdsale() {
255         require(starbaseCrowdsale.startDate() == 0);
256         _;
257     }
258 
259     modifier onlyAfterCrowdsale() {
260         require(starbaseCrowdsale.isEnded());
261         _;
262     }
263 
264     modifier onlyPayloadSize(uint size) {
265         assert(msg.data.length == size + 4);
266         _;
267     }
268 
269     /*
270      *  Contract functions
271      */
272 
273     /**
274      * @dev Contract constructor function
275      * @param starbaseCompanyAddr The address that will holds untransferrable tokens
276      * @param starbaseCrowdsaleAddr Address of the crowdsale contract
277      * @param starbaseMarketingCampaignAddr The address of the marketing campaign contract
278      */
279 
280     function StarbaseToken(
281         address starbaseCompanyAddr,
282         address starbaseCrowdsaleAddr,
283         address starbaseMarketingCampaignAddr
284     ) {
285         assert(
286             starbaseCompanyAddr != 0 &&
287             starbaseCrowdsaleAddr != 0 &&
288             starbaseMarketingCampaignAddr != 0);
289 
290         starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddr);
291         starbaseMarketingCampaign = AbstractStarbaseMarketingCampaign(starbaseMarketingCampaignAddr);
292         company = starbaseCompanyAddr;
293 
294         // msg.sender becomes first fundraiser
295         fundraisers[msg.sender] = true;
296         LogNewFundraiser(msg.sender, true);
297 
298         // Tokens for crowdsale and early purchasers
299         balances[address(starbaseCrowdsale)] = initialBalanceForCrowdsale;
300         Transfer(0, address(starbaseCrowdsale), initialBalanceForCrowdsale);
301 
302         // Tokens for marketing campaign supporters
303         balances[address(starbaseMarketingCampaign)] = initialBalanceForMarketingCampaign;
304         Transfer(0, address(starbaseMarketingCampaign), initialBalanceForMarketingCampaign);
305 
306         // Tokens for early contributors, should be allocated by function
307         balances[0] = 62500000e18; // 62.5M
308 
309         // Starbase company holds untransferrable tokens initially
310         balances[starbaseCompanyAddr] = initialCompanysTokenAllocation; // 750M
311         Transfer(0, starbaseCompanyAddr, initialCompanysTokenAllocation);
312 
313         totalSupply = initialSupply;    // 1B
314     }
315 
316     /**
317      * @dev Setup function sets external contracts' addresses
318      * @param starbaseCrowdsaleAddr Crowdsale contract address.
319      * @param starbaseMarketingCampaignAddr Marketing campaign contract address
320      */
321     function setup(address starbaseCrowdsaleAddr, address starbaseMarketingCampaignAddr)
322         external
323         onlyFundraiser
324         onlyBeforeCrowdsale
325         returns (bool)
326     {
327         require(starbaseCrowdsaleAddr != 0 && starbaseMarketingCampaignAddr != 0);
328         assert(balances[address(starbaseCrowdsale)] == initialBalanceForCrowdsale);
329         assert(balances[address(starbaseMarketingCampaign)] == initialBalanceForMarketingCampaign);
330 
331         // Move the balances to the new ones
332         balances[address(starbaseCrowdsale)] = 0;
333         balances[address(starbaseMarketingCampaign)] = 0;
334         balances[starbaseCrowdsaleAddr] = initialBalanceForCrowdsale;
335         balances[starbaseMarketingCampaignAddr] = initialBalanceForMarketingCampaign;
336 
337         // Update the references
338         starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddr);
339         starbaseMarketingCampaign = AbstractStarbaseMarketingCampaign(starbaseMarketingCampaignAddr);
340         return true;
341     }
342 
343     /*
344      *  External functions
345      */
346 
347     /**
348      * @dev Returns number of declared public offering plans
349      */
350     function numOfDeclaredPublicOfferingPlans()
351         external
352         constant
353         returns (uint256)
354     {
355         return publicOfferingPlans.length;
356     }
357 
358     /**
359      * @dev Declares a public offering plan to make company's tokens transferable
360      * @param tokenCount Number of tokens to transfer.
361      * @param unlockCompanysTokensAt Time of the tokens will be unlocked
362      */
363     function declarePublicOfferingPlan(uint256 tokenCount, uint256 unlockCompanysTokensAt)
364         external
365         onlyFundraiser
366         onlyAfterCrowdsale
367         returns (bool)
368     {
369         assert(tokenCount <= 100000000e18);    // shall not exceed 100M tokens
370         assert(SafeMath.sub(now, starbaseCrowdsale.endedAt()) >= 180 days);   // shall not be declared for 6 months after the crowdsale ended
371         assert(SafeMath.sub(unlockCompanysTokensAt, now) >= 60 days);   // tokens must be untransferable at least for 2 months
372 
373         // check if last declaration was more than 6 months ago
374         if (publicOfferingPlans.length > 0) {
375             uint256 lastDeclaredAt =
376                 publicOfferingPlans[publicOfferingPlans.length - 1].declaredAt;
377             assert(SafeMath.sub(now, lastDeclaredAt) >= 180 days);
378         }
379 
380         uint256 totalDeclaredTokenCount = tokenCount;
381         for (uint8 i; i < publicOfferingPlans.length; i++) {
382             totalDeclaredTokenCount = SafeMath.add(totalDeclaredTokenCount, publicOfferingPlans[i].tokenCount);
383         }
384         assert(totalDeclaredTokenCount <= initialCompanysTokenAllocation);   // shall not exceed the initial token allocation
385 
386         publicOfferingPlans.push(
387             PublicOfferingPlan(tokenCount, unlockCompanysTokensAt, now));
388 
389         PublicOfferingPlanDeclared(tokenCount, unlockCompanysTokensAt);
390     }
391 
392     /**
393      * @dev Allocate tokens to a marketing supporter from the marketing campaign share
394      * @param to Address to where tokens are allocated
395      * @param value Number of tokens to transfer
396      */
397     function allocateToMarketingSupporter(address to, uint256 value)
398         external
399         onlyMarketingCampaignContract
400         returns (bool)
401     {
402         require(to != address(0));
403         return allocateFrom(address(starbaseMarketingCampaign), to, value);
404     }
405 
406     /**
407      * @dev Allocate tokens to an early contributor from the early contributor share
408      * @param to Address to where tokens are allocated
409      * @param value Number of tokens to transfer
410      */
411     function allocateToEarlyContributor(address to, uint256 value)
412         external
413         onlyFundraiser
414         returns (bool)
415     {
416         require(to != address(0));
417         initialEcTokenAllocation[to] =
418             SafeMath.add(initialEcTokenAllocation[to], value);
419         return allocateFrom(0, to, value);
420     }
421 
422     /**
423      * @dev Issue new tokens according to the STAR token inflation limits
424      * @param _for Address to where tokens are allocated
425      * @param value Number of tokens to issue
426      */
427     function issueTokens(address _for, uint256 value)
428         external
429         onlyFundraiser
430         onlyAfterCrowdsale
431         returns (bool)
432     {
433         require(_for != address(0));
434         // check if the value under the limits
435         assert(value <= numOfInflatableTokens());
436 
437         totalSupply = SafeMath.add(totalSupply, value);
438         balances[_for] = SafeMath.add(balances[_for], value);
439         return true;
440     }
441 
442     /**
443      * @dev Declares Starbase MVP has been launched
444      * @param launchedAt When the MVP launched (timestamp)
445      */
446     function declareMvpLaunched(uint256 launchedAt)
447         external
448         onlyFundraiser
449         onlyAfterCrowdsale
450         returns (bool)
451     {
452         require(mvpLaunchedAt == 0); // overwriting the launch date is not permitted
453         require(launchedAt <= now);
454         require(starbaseCrowdsale.isEnded());
455 
456         mvpLaunchedAt = launchedAt;
457         MvpLaunched(launchedAt);
458         return true;
459     }
460 
461     /**
462      * @dev Allocate tokens to a crowdsale or early purchaser from the crowdsale share
463      * @param to Address to where tokens are allocated
464      * @param value Number of tokens to transfer
465      */
466     function allocateToCrowdsalePurchaser(address to, uint256 value)
467         external
468         onlyCrowdsaleContract
469         onlyAfterCrowdsale
470         returns (bool)
471     {
472         require(to != address(0));
473         return allocateFrom(address(starbaseCrowdsale), to, value);
474     }
475 
476     /*
477      *  Public functions
478      */
479 
480     /**
481      * @dev Transfers sender's tokens to a given address. Returns success.
482      * @param to Address of token receiver.
483      * @param value Number of tokens to transfer.
484      */
485     function transfer(address to, uint256 value) public onlyPayloadSize(2*32) returns (bool) {
486         assert(isTransferable(msg.sender, value));
487         return super.transfer(to, value);
488     }
489 
490     /**
491      * @dev Allows third party to transfer tokens from one address to another. Returns success.
492      * @param from Address from where tokens are withdrawn.
493      * @param to Address to where tokens are sent.
494      * @param value Number of tokens to transfer.
495      */
496     function transferFrom(address from, address to, uint256 value) public onlyPayloadSize(3*32) returns (bool) {
497         assert(isTransferable(from, value));
498         return super.transferFrom(from, to, value);
499     }
500 
501     /**
502      * @dev Adds fundraiser. Only called by another fundraiser.
503      * @param fundraiserAddress The address in check
504      */
505     function addFundraiser(address fundraiserAddress) public onlyFundraiser {
506         require(fundraiserAddress != address(0));
507         assert(!isFundraiser(fundraiserAddress));
508 
509         fundraisers[fundraiserAddress] = true;
510         LogNewFundraiser(fundraiserAddress, true);
511     }
512 
513     /**
514      * @dev Update fundraiser address rights.
515      * @param fundraiserAddress The address to update
516      * @param isBonaFide Boolean that denotes whether fundraiser is active or not.
517      */
518     function updateFundraiser(address fundraiserAddress, bool isBonaFide)
519        public
520        onlyFundraiser
521        returns(bool)
522     {
523         assert(isFundraiser(fundraiserAddress));
524 
525         fundraisers[fundraiserAddress] = isBonaFide;
526         LogUpdateFundraiser(fundraiserAddress, isBonaFide);
527         return true;
528     }
529 
530     /**
531      * @dev Returns whether fundraiser address has rights.
532      * @param fundraiserAddress The address in check
533      */
534     function isFundraiser(address fundraiserAddress) constant public returns(bool) {
535         return fundraisers[fundraiserAddress];
536     }
537 
538     /**
539      * @dev Returns whether the transferring of tokens is available fundraiser.
540      * @param from Address of token sender
541      * @param tokenCount Number of tokens to transfer.
542      */
543     function isTransferable(address from, uint256 tokenCount)
544         constant
545         public
546         returns (bool)
547     {
548         if (tokenCount == 0 || balances[from] < tokenCount) {
549             return false;
550         }
551 
552         // company's tokens may be locked up
553         if (from == company) {
554             if (tokenCount > numOfTransferableCompanysTokens()) {
555                 return false;
556             }
557         }
558 
559         uint256 untransferableTokenCount = 0;
560 
561         // early contributor's tokens may be locked up
562         if (initialEcTokenAllocation[from] > 0) {
563             untransferableTokenCount = SafeMath.add(
564                 untransferableTokenCount,
565                 numOfUntransferableEcTokens(from));
566         }
567 
568         // EP and CS purchasers' tokens should be untransferable initially
569         if (starbaseCrowdsale.isEnded()) {
570             uint256 passedDays =
571                 SafeMath.sub(now, starbaseCrowdsale.endedAt()) / 86400; // 1d = 86400s
572             if (passedDays < 7) {  // within a week
573                 // crowdsale purchasers cannot transfer their tokens for a week
574                 untransferableTokenCount = SafeMath.add(
575                     untransferableTokenCount,
576                     starbaseCrowdsale.numOfPurchasedTokensOnCsBy(from));
577             }
578             if (passedDays < 14) {  // within two weeks
579                 // early purchasers cannot transfer their tokens for two weeks
580                 untransferableTokenCount = SafeMath.add(
581                     untransferableTokenCount,
582                     starbaseCrowdsale.numOfPurchasedTokensOnEpBy(from));
583             }
584         }
585 
586         uint256 transferableTokenCount =
587             SafeMath.sub(balances[from], untransferableTokenCount);
588 
589         if (transferableTokenCount < tokenCount) {
590             return false;
591         } else {
592             return true;
593         }
594     }
595 
596     /**
597      * @dev Returns the number of transferable company's tokens
598      */
599     function numOfTransferableCompanysTokens() constant public returns (uint256) {
600         uint256 unlockedTokens = 0;
601         for (uint8 i; i < publicOfferingPlans.length; i++) {
602             PublicOfferingPlan memory plan = publicOfferingPlans[i];
603             if (plan.unlockCompanysTokensAt <= now) {
604                 unlockedTokens = SafeMath.add(unlockedTokens, plan.tokenCount);
605             }
606         }
607         return SafeMath.sub(
608             balances[company],
609             initialCompanysTokenAllocation - unlockedTokens);
610     }
611 
612     /**
613      * @dev Returns the number of untransferable tokens of the early contributor
614      * @param _for Address of early contributor to check
615      */
616     function numOfUntransferableEcTokens(address _for) constant public returns (uint256) {
617         uint256 initialCount = initialEcTokenAllocation[_for];
618         if (mvpLaunchedAt == 0) {
619             return initialCount;
620         }
621 
622         uint256 passedWeeks = SafeMath.sub(now, mvpLaunchedAt) / 7 days;
623         if (passedWeeks <= 52) {    // a year ≈ 52 weeks
624             // all tokens should be locked up for a year
625             return initialCount;
626         }
627 
628         // unlock 1/52 tokens every weeks after a year
629         uint256 transferableTokenCount = initialCount / 52 * (passedWeeks - 52);
630         if (transferableTokenCount >= initialCount) {
631             return 0;
632         } else {
633             return SafeMath.sub(initialCount, transferableTokenCount);
634         }
635     }
636 
637     /**
638      * @dev Returns number of tokens which can be issued according to the inflation rules
639      */
640     function numOfInflatableTokens() constant public returns (uint256) {
641         if (starbaseCrowdsale.endedAt() == 0) {
642             return 0;
643         }
644         uint256 passedDays = SafeMath.sub(now, starbaseCrowdsale.endedAt()) / 86400;  // 1d = 60s * 60m * 24h = 86400s
645         uint256 passedYears = passedDays * 100 / 36525;    // about 365.25 days in a year
646         uint256 inflatedSupply = initialSupply;
647         for (uint256 i; i < passedYears; i++) {
648             inflatedSupply = SafeMath.add(inflatedSupply, SafeMath.mul(inflatedSupply, 25) / 1000); // 2.5%/y = 0.025/y
649         }
650 
651         uint256 remainderedDays = passedDays * 100 % 36525 / 100;
652         if (remainderedDays > 0) {
653             uint256 inflatableTokensOfNextYear =
654                 SafeMath.mul(inflatedSupply, 25) / 1000;
655             inflatedSupply = SafeMath.add(inflatedSupply, SafeMath.mul(
656                 inflatableTokensOfNextYear, remainderedDays * 100) / 36525);
657         }
658 
659         return SafeMath.sub(inflatedSupply, totalSupply);
660     }
661 
662     /*
663      *  Internal functions
664      */
665 
666     /**
667      * @dev Allocate tokens value from an address to another one. This function is only called internally.
668      * @param from Address from where tokens come
669      * @param to Address to where tokens are allocated
670      * @param value Number of tokens to transfer
671      */
672     function allocateFrom(address from, address to, uint256 value) internal returns (bool) {
673         assert(value > 0 && balances[from] >= value);
674         balances[from] = SafeMath.sub(balances[from], value);
675         balances[to] = SafeMath.add(balances[to], value);
676         Transfer(from, to, value);
677         return true;
678     }
679 }