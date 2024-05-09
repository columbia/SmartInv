1 pragma solidity ^0.4.18;
2 
3 interface TokenStagesManager {
4     function isDebug() public constant returns(bool);
5     function setToken(address tokenAddress) public;
6     function getPool() public constant returns (uint96);
7     function getBonus() public constant returns (uint8);
8     function isFreezeTimeout() public constant returns (bool);
9     function isTimeout() public constant returns (bool);
10     function isICO() public view returns(bool);
11     function isCanList() public view returns (bool);
12     function calculateBonus(uint96 amount) public view returns (uint88);
13     function delegateFromPool(uint96 amount) public;
14     function delegateFromBonus(uint88 amount) public;
15     function delegateFromReferral(uint88 amount) public;
16 
17     function getBonusPool() public constant returns(uint88);
18     function getReferralPool() public constant returns(uint88);
19 }
20 
21 contract Administrated {
22     address public administrator;
23 
24     modifier onlyAdministrator() {
25         require(administrator == tx.origin);
26         _;
27     }
28 
29     modifier notAdministrator() {
30         require(administrator != tx.origin);
31         _;
32     }
33 
34     function setAdministrator(address _administrator)
35         internal
36     {
37         administrator = _administrator;
38     }
39 }
40 
41 //-------//
42 contract UNITStagesManager is TokenStagesManager, Administrated {
43     struct StageOffer {
44         uint96 pool;
45         uint8 bonus;
46     }
47 
48     struct Stage {
49         uint32 startsAt;
50         uint32 endsAt;
51         StageOffer[5] offers;
52     }
53 
54     uint88 public bonusPool = 14322013755263720000000000; //
55 
56     uint88 public referralPool = 34500000000000000000000000; //34.5mln
57 
58     Stage[3] public stages;
59 
60     uint8 public stage;
61     uint8 public offer = 0;
62 
63     UNITv2 public token;
64 
65     bool internal _isDebug;
66 
67     event StageUpdated(uint8 prevStage, uint8 prefOffer, uint8 newStage, uint8 newOffer);
68     event TokensDelegated(uint96 amount, uint88 bonus);
69     event ReferralTokensDelegated(uint96 amount);
70     event BonusTokensDelegated(uint96 amount);
71 
72     modifier tokenOrAdmin() {
73         require(tx.origin == administrator || (address(token) != address(0) && msg.sender == address(token)));
74         _;
75     }
76 
77     modifier onlyDebug() {
78         require(_isDebug);
79         _;
80     }
81 
82     modifier canDelegate() {
83         require(msg.sender == address(token) || (_isDebug && tx.origin == administrator));
84         _;
85     }
86 
87     function UNITStagesManager(bool isDebug, address _token)
88         public
89     {
90         setAdministrator(tx.origin);
91         token = UNITv2(_token);
92         _isDebug = isDebug;
93 
94         buildPreICOStage();
95         buildICOStageOne();
96         buildICOStageTwo();
97 
98         if (!_isDebug) {
99             switchStage();
100         }
101     }
102 
103     function isDebug()
104         public
105         constant
106         returns (bool)
107     {
108         return _isDebug;
109     }
110 
111     function buildPreICOStage()
112         internal
113     {
114         stages[0].startsAt = 1515610800; //10th of January 2018 at 19:00UTC
115         stages[0].endsAt = 1518894000; //17th of February 2018 at 19:00UTC
116 
117         stages[0].offers[0].pool = 24705503438815932384141049; //25 mln tokens
118         stages[0].offers[0].bonus = 40;
119     }
120 
121     function buildICOStageOne()
122         internal
123     {
124         stages[1].startsAt = 1519326000; //22th of February 2018 at 19:00UTC
125         stages[1].endsAt = 1521745200; //22th of March 2018 at 19:00UTC
126 
127         stages[1].offers[0].pool = 5000000 * ( 10**18 ); //5 mln tokens
128         stages[1].offers[0].bonus = 35; //35%
129 
130         stages[1].offers[1].pool = 5000000 * ( 10**18 ); //5 mln tokens
131         stages[1].offers[1].bonus = 30; //30%
132 
133         stages[1].offers[2].pool = 5000000 * ( 10**18 ); //5 mln tokens
134         stages[1].offers[2].bonus = 25; //25%
135 
136         stages[1].offers[3].pool = 5000000 * ( 10**18 ); //5 mln tokens
137         stages[1].offers[3].bonus = 20; //20%
138 
139         stages[1].offers[4].pool = 122500000 * ( 10**18 ); //122.5 mln tokens
140         stages[1].offers[4].bonus = 0; //0%
141     }
142 
143     function buildICOStageTwo()
144         internal
145     {
146         stages[2].startsAt = 1524250800; //20th of April 2018 at 19:00UTC
147         stages[2].endsAt = 1526842800; //20th of May 2018 at 19:00UTC
148 
149         stages[2].offers[0].pool = 142794496561184067615858951;
150         stages[2].offers[0].bonus = 0; //0%
151     }
152 
153     function switchStage()
154         public
155     {
156         uint8 _stage = stage;
157         uint8 _offer = 0;
158 
159         while( stages.length > _stage ) {
160             if (stages[_stage].endsAt <= uint32(now)) {
161                 _stage += 1;
162                 _offer = 0;
163                 continue;
164             }
165 
166             while ( stages[_stage].offers.length > _offer ) {
167                 if (stages[_stage].offers[_offer].pool == 0) {
168                     _offer += 1;
169                 } else {
170                     break;
171                 }
172             }
173 
174             if (stages[_stage].offers.length <= _offer) {
175                 _stage += 1;
176                 _offer = 0;
177                 continue;
178             }
179 
180             break;
181         }
182 
183         if (stage < _stage) {
184             migratePool();
185         }
186 
187         StageUpdated(stage, offer, _stage, _offer);
188 
189         stage = _stage;
190         offer = _offer;
191     }
192 
193     function migratePool()
194         internal
195     {
196         if ( stage < (stages.length - 1) ) {
197             for (uint8 i = 0; i < stages[stage].offers.length; i++) {
198                 stages[stages.length - 1].offers[0].pool += stages[stage].offers[i].pool;
199                 stages[stage].offers[offer].pool = 0;
200             }
201         }
202     }
203 
204     //START Debug methods
205     /*
206     WARNING! This methods are for debug purpose only during testing.
207     They will work only of isDebug option is set to true.
208     */
209     function dTimeoutCurrentStage()
210         public
211         onlyAdministrator
212         onlyDebug
213     {
214         stages[stage].endsAt = uint32(now) - 10;
215     }
216 
217     function dStartsNow()
218         public
219         onlyAdministrator
220         onlyDebug
221     {
222         uint32 timeDiff = stages[stage].endsAt - stages[stage].startsAt;
223         stages[stage].startsAt = uint32(now);
224         stages[stage].endsAt = stages[stage].startsAt + timeDiff;
225     }
226 
227     function dNextStage(uint32 startOffset)
228         public
229         onlyAdministrator
230         onlyDebug
231     {
232         if ( stage < stages.length ) {
233             dTimeoutCurrentStage();
234 
235             uint8 newStage = stage + 1;
236             uint32 timeDiff = stages[newStage].endsAt - stages[newStage].startsAt;
237 
238             stages[newStage].startsAt = uint32(now) + startOffset;
239             stages[newStage].endsAt = stages[newStage].startsAt + timeDiff;
240 
241             switchStage();
242         }
243     }
244 
245     function dNextOffer()
246         public
247         onlyAdministrator
248         onlyDebug
249     {
250         offer++;
251     }
252     
253     function dAlterPull(uint96 numTokens)
254         public
255         onlyAdministrator
256         onlyDebug
257     {
258         withdrawTokensFromPool(numTokens);
259     }
260 
261     function dGetPool(uint8 _stage, uint8 _offer)
262         public
263         onlyAdministrator
264         onlyDebug
265         view
266         returns (uint96)
267     {
268         return stages[_stage].offers[_offer].pool;
269     }
270     //END Debug methods
271 
272     function withdrawTokensFromPool(uint96 numTokens)
273         internal
274     {
275         require(numTokens <= stages[stage].offers[offer].pool);
276 
277         stages[stage].offers[offer].pool -= numTokens;
278     }
279 
280     function getCurrentStage()
281         public
282         view
283         returns (uint32 startsAt, uint32 endsAt, uint96 pool, uint8 bonus)
284     {
285         uint8 _stage = stage;
286         uint8 _offer = offer;
287 
288         if ( _stage >= stages.length ) {
289             _stage = uint8(stages.length - 1);
290             _offer = 0;
291         }
292             startsAt = stages[_stage].startsAt;
293             endsAt = stages[_stage].endsAt;
294             pool = stages[_stage].offers[_offer].pool;
295             bonus = stages[_stage].offers[_offer].bonus;
296     }
297 
298     function setToken(address tokenAddress)
299         public
300         onlyAdministrator
301     {
302         token = UNITv2(tokenAddress);
303     }
304 
305     function getPool()
306         public
307         constant
308         returns (uint96)
309     {
310         uint8 _stage = stage;
311         uint8 _offer = offer;
312 
313         if ( !isICO() ) {
314             _stage = uint8(stages.length - 1);
315             _offer = 0;
316         }
317 
318         return stages[_stage].offers[_offer].pool;
319     }
320 
321     function getBonus()
322         public
323         constant
324         returns (uint8)
325     {
326         uint8 _stage = stage;
327         uint8 _offer = offer;
328 
329         if ( !isICO() ) {
330             _stage = uint8(stages.length - 1);
331             _offer = 0;
332         }
333 
334         return stages[_stage].offers[_offer].bonus;
335     }
336 
337     function isTimeout()
338         public
339         constant
340         returns (bool)
341     {
342         uint8 _stage = stage;
343 
344         if ( !isICO() ) {
345             _stage = uint8(stages.length - 1);
346         }
347 
348         return now >= stages[_stage].endsAt;
349     }
350 
351     function isFreezeTimeout()
352         public
353         constant
354         returns (bool)
355     {
356         return now >= (stages[stages.length - 1].endsAt + 180 days);
357     }
358 
359     function isICO()
360         public
361         constant
362         returns(bool)
363     {
364         return stage < stages.length;
365     }
366 
367     function isCanList()
368         public
369         constant
370         returns (bool)
371     {
372         return !isICO();
373     }
374 
375     function getBonusPool()
376         public
377         constant
378         returns(uint88)
379     {
380         return bonusPool;
381     }
382 
383     function getReferralPool()
384         public
385         constant
386         returns(uint88)
387     {
388         return referralPool;
389     }
390 
391     function calculateBonus(uint96 amount)
392         public
393         view
394         returns (uint88 bonus)
395     {
396         bonus = uint88( ( amount * getBonus() ) / 100);
397 
398         if (bonus > bonusPool) {
399             bonus = bonusPool;
400         }
401     }
402 
403     function delegateFromPool(uint96 amount)
404         public
405         canDelegate()
406     {
407         require(amount <= getPool());
408         uint88 bonus = calculateBonus(amount);
409 
410         stages[stage].offers[offer].pool -= amount;
411         bonusPool -= bonus;
412 
413         TokensDelegated(amount, bonus);
414     }
415 
416     function delegateFromBonus(uint88 amount)
417         public
418         canDelegate()
419     {
420         require(amount <= getBonusPool());
421 
422         bonusPool -= amount;
423         BonusTokensDelegated(amount);
424     }
425 
426     function delegateFromReferral(uint88 amount)
427         public
428         canDelegate()
429     {
430         require(amount <= getReferralPool());
431 
432         referralPool -= amount;
433         ReferralTokensDelegated(amount);
434     }
435 }
436 //-------//
437 
438 interface Whitelist {
439     function add(address _wlAddress) public;
440     function addBulk(address[] _wlAddresses) public;
441     function remove(address _wlAddresses) public;
442     function removeBulk(address[] _wlAddresses) public;
443     function getAll() public constant returns(address[]);
444     function isInList(address _checkAddress) public constant returns(bool);
445 }
446 
447 interface ERC20 {
448     event Transfer(address indexed _from, address indexed _to, uint _value);
449     event Approval(address indexed _owner, address indexed _spender, uint _value);
450 
451     function totalSupply() public constant returns (uint);
452     function balanceOf(address _owner) public constant returns (uint balance);
453     function transfer(address _to, uint _value) public returns (bool success);
454     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
455     function approve(address _spender, uint _value) public returns (bool success);
456     function allowance(address _owner, address _spender) public constant returns (uint remaining);
457 }
458 
459 contract ERC20Contract is ERC20 {
460     //Token symbol
461     string public constant symbol = "UNIT";
462 
463     //Token name
464     string public constant name = "Unilot token";
465 
466     //It can be reeeealy small
467     uint8 public constant decimals = 18;
468 
469     // Balances for each account
470     mapping(address => uint96) public balances;
471 
472     // Owner of account approves the transfer of an amount to another account
473     mapping(address => mapping (address => uint96)) allowed;
474 
475     function totalSupply()
476         public
477         constant
478         returns (uint);
479 
480 
481     // What is the balance of a particular account?
482     function balanceOf(address _owner)
483         public
484         constant
485         returns (uint balance)
486     {
487         return uint(balances[_owner]);
488     }
489 
490 
491     // Transfer the balance from owner's account to another account
492     function transfer(address _to, uint _amount)
493         public
494         returns (bool success)
495     {
496         if (balances[msg.sender] >= _amount
497             && _amount > 0
498             && balances[_to] + _amount > balances[_to]) {
499             balances[msg.sender] -= uint96(_amount);
500             balances[_to] += uint96(_amount);
501             Transfer(msg.sender, _to, _amount);
502 
503             return true;
504         } else {
505             return false;
506         }
507     }
508 
509 
510     // Send _value amount of tokens from address _from to address _to
511     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
512     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
513     // fees in sub-currencies; the command should fail unless the _from account has
514     // deliberately authorized the sender of the message via some mechanism; we propose
515     // these standardized APIs for approval:
516     function transferFrom(
517         address _from,
518         address _to,
519         uint256 _amount
520     )
521         public
522         returns (bool success)
523     {
524         if (balances[_from] >= _amount
525             && allowed[_from][msg.sender] >= _amount
526             && _amount > 0
527             && balances[_to] + _amount > balances[_to]) {
528             balances[_from] -= uint96(_amount);
529             allowed[_from][msg.sender] -= uint96(_amount);
530             balances[_to] += uint96(_amount);
531             Transfer(_from, _to, _amount);
532             return true;
533         } else {
534             return false;
535         }
536     }
537 
538 
539     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
540     // If this function is called again it overwrites the current allowance with _value.
541     function approve(address _spender, uint _amount)
542         public
543         returns (bool success)
544     {
545         allowed[msg.sender][_spender] = uint96(_amount);
546         Approval(msg.sender, _spender, _amount);
547         return true;
548     }
549 
550 
551     function allowance(address _owner, address _spender)
552         public
553         constant
554         returns (uint remaining)
555     {
556         return allowed[_owner][_spender];
557     }
558 }
559 
560 contract UnilotToken is ERC20 {
561     struct TokenStage {
562         string name;
563         uint numCoinsStart;
564         uint coinsAvailable;
565         uint bonus;
566         uint startsAt;
567         uint endsAt;
568         uint balance; //Amount of ether sent during this stage
569     }
570 
571     //Token symbol
572     string public constant symbol = "UNIT";
573     //Token name
574     string public constant name = "Unilot token";
575     //It can be reeeealy small
576     uint8 public constant decimals = 18;
577 
578     //This one duplicates the above but will have to use it because of
579     //solidity bug with power operation
580     uint public constant accuracy = 1000000000000000000;
581 
582     //500 mln tokens
583     uint256 internal _totalSupply = 500 * (10**6) * accuracy;
584 
585     //Public investor can buy tokens for 30 ether at maximum
586     uint256 public constant singleInvestorCap = 30 ether; //30 ether
587 
588     //Distribution units
589     uint public constant DST_ICO     = 62; //62%
590     uint public constant DST_RESERVE = 10; //10%
591     uint public constant DST_BOUNTY  = 3;  //3%
592     //Referral and Bonus Program
593     uint public constant DST_R_N_B_PROGRAM = 10; //10%
594     uint public constant DST_ADVISERS      = 5;  //5%
595     uint public constant DST_TEAM          = 10; //10%
596 
597     //Referral Bonuses
598     uint public constant REFERRAL_BONUS_LEVEL1 = 5; //5%
599     uint public constant REFERRAL_BONUS_LEVEL2 = 4; //4%
600     uint public constant REFERRAL_BONUS_LEVEL3 = 3; //3%
601     uint public constant REFERRAL_BONUS_LEVEL4 = 2; //2%
602     uint public constant REFERRAL_BONUS_LEVEL5 = 1; //1%
603 
604     //Token amount
605     //25 mln tokens
606     uint public constant TOKEN_AMOUNT_PRE_ICO = 25 * (10**6) * accuracy;
607     //5 mln tokens
608     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1 = 5 * (10**6) * accuracy;
609     //5 mln tokens
610     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2 = 5 * (10**6) * accuracy;
611     //5 mln tokens
612     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3 = 5 * (10**6) * accuracy;
613     //5 mln tokens
614     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4 = 5 * (10**6) * accuracy;
615     //122.5 mln tokens
616     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5 = 1225 * (10**5) * accuracy;
617     //265 mln tokens
618     uint public constant TOKEN_AMOUNT_ICO_STAGE2 = 1425 * (10**5) * accuracy;
619 
620     uint public constant BONUS_PRE_ICO = 40; //40%
621     uint public constant BONUS_ICO_STAGE1_PRE_SALE1 = 35; //35%
622     uint public constant BONUS_ICO_STAGE1_PRE_SALE2 = 30; //30%
623     uint public constant BONUS_ICO_STAGE1_PRE_SALE3 = 25; //25%
624     uint public constant BONUS_ICO_STAGE1_PRE_SALE4 = 20; //20%
625     uint public constant BONUS_ICO_STAGE1_PRE_SALE5 = 0; //0%
626     uint public constant BONUS_ICO_STAGE2 = 0; //No bonus
627 
628     //Token Price on Coin Offer
629     uint256 public constant price = 79 szabo; //0.000079 ETH
630 
631     address public constant ADVISORS_WALLET = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
632     address public constant RESERVE_WALLET = 0x731B47847352fA2cFf83D5251FD6a5266f90878d;
633     address public constant BOUNTY_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
634     address public constant R_N_D_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
635     address public constant STORAGE_WALLET = 0xE2A8F147fc808738Cab152b01C7245F386fD8d89;
636 
637     // Owner of this contract
638     address public administrator;
639 
640     // Balances for each account
641     mapping(address => uint256) balances;
642 
643     // Owner of account approves the transfer of an amount to another account
644     mapping(address => mapping (address => uint256)) allowed;
645 
646     //Mostly needed for internal use
647     uint256 internal totalCoinsAvailable;
648 
649     //All token stages. Total 6 stages
650     TokenStage[7] stages;
651 
652     //Index of current stage in stage array
653     uint currentStage;
654 
655     //Enables or disables debug mode. Debug mode is set only in constructor.
656     bool isDebug = false;
657 
658     event StageUpdated(string from, string to);
659 
660     // Functions with this modifier can only be executed by the owner
661     modifier onlyAdministrator() {
662         require(msg.sender == administrator);
663         _;
664     }
665 
666     modifier notAdministrator() {
667         require(msg.sender != administrator);
668         _;
669     }
670 
671     modifier onlyDuringICO() {
672         require(currentStage < stages.length);
673         _;
674     }
675 
676     modifier onlyAfterICO(){
677         require(currentStage >= stages.length);
678         _;
679     }
680 
681     modifier meetTheCap() {
682         require(msg.value >= price); // At least one token
683         _;
684     }
685 
686     modifier isFreezedReserve(address _address) {
687         require( ( _address == RESERVE_WALLET ) && now > (stages[ (stages.length - 1) ].endsAt + 182 days));
688         _;
689     }
690 
691     // Constructor
692     function UnilotToken()
693         public
694     {
695         administrator = msg.sender;
696         totalCoinsAvailable = _totalSupply;
697         //Was as fn parameter for debugging
698         isDebug = true;
699 
700         _setupStages();
701         _proceedStage();
702     }
703 
704     function prealocateCoins()
705         public
706         onlyAdministrator
707     {
708         totalCoinsAvailable -= balances[ADVISORS_WALLET] += ( ( _totalSupply * DST_ADVISERS ) / 100 );
709         totalCoinsAvailable -= balances[RESERVE_WALLET] += ( ( _totalSupply * DST_RESERVE ) / 100 );
710 
711         address[7] memory teamWallets = getTeamWallets();
712         uint teamSupply = ( ( _totalSupply * DST_TEAM ) / 100 );
713         uint memberAmount = teamSupply / teamWallets.length;
714 
715         for(uint i = 0; i < teamWallets.length; i++) {
716             if ( i == ( teamWallets.length - 1 ) ) {
717                 memberAmount = teamSupply;
718             }
719 
720             balances[teamWallets[i]] += memberAmount;
721             teamSupply -= memberAmount;
722             totalCoinsAvailable -= memberAmount;
723         }
724     }
725 
726     function getTeamWallets()
727         public
728         pure
729         returns (address[7] memory result)
730     {
731         result[0] = 0x40e3D8fFc46d73Ab5DF878C751D813a4cB7B388D;
732         result[1] = 0x5E065a80f6635B6a46323e3383057cE6051aAcA0;
733         result[2] = 0x0cF3585FbAB2a1299F8347a9B87CF7B4fcdCE599;
734         result[3] = 0x5fDd3BA5B6Ff349d31eB0a72A953E454C99494aC;
735         result[4] = 0xC9be9818eE1B2cCf2E4f669d24eB0798390Ffb54;
736         result[5] = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
737         result[6] = 0xd13289203889bD898d49e31a1500388441C03663;
738     }
739 
740     function _setupStages()
741         internal
742     {
743         //Presale stage
744         stages[0].name = 'Presale stage';
745         stages[0].numCoinsStart = totalCoinsAvailable;
746         stages[0].coinsAvailable = TOKEN_AMOUNT_PRE_ICO;
747         stages[0].bonus = BONUS_PRE_ICO;
748 
749         if (isDebug) {
750             stages[0].startsAt = now;
751             stages[0].endsAt = stages[0].startsAt + 30 seconds;
752         } else {
753             stages[0].startsAt = 1515610800; //10th of January 2018 at 19:00UTC
754             stages[0].endsAt = 1518894000; //17th of February 2018 at 19:00UTC
755         }
756 
757         //ICO Stage 1 pre-sale 1
758         stages[1].name = 'ICO Stage 1 pre-sale 1';
759         stages[1].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1;
760         stages[1].bonus = BONUS_ICO_STAGE1_PRE_SALE1;
761 
762         if (isDebug) {
763             stages[1].startsAt = stages[0].endsAt;
764             stages[1].endsAt = stages[1].startsAt + 30 seconds;
765         } else {
766             stages[1].startsAt = 1519326000; //22th of February 2018 at 19:00UTC
767             stages[1].endsAt = 1521745200; //22th of March 2018 at 19:00UTC
768         }
769 
770         //ICO Stage 1 pre-sale 2
771         stages[2].name = 'ICO Stage 1 pre-sale 2';
772         stages[2].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2;
773         stages[2].bonus = BONUS_ICO_STAGE1_PRE_SALE2;
774 
775         stages[2].startsAt = stages[1].startsAt;
776         stages[2].endsAt = stages[1].endsAt;
777 
778         //ICO Stage 1 pre-sale 3
779         stages[3].name = 'ICO Stage 1 pre-sale 3';
780         stages[3].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3;
781         stages[3].bonus = BONUS_ICO_STAGE1_PRE_SALE3;
782 
783         stages[3].startsAt = stages[1].startsAt;
784         stages[3].endsAt = stages[1].endsAt;
785 
786         //ICO Stage 1 pre-sale 4
787         stages[4].name = 'ICO Stage 1 pre-sale 4';
788         stages[4].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4;
789         stages[4].bonus = BONUS_ICO_STAGE1_PRE_SALE4;
790 
791         stages[4].startsAt = stages[1].startsAt;
792         stages[4].endsAt = stages[1].endsAt;
793 
794         //ICO Stage 1 pre-sale 5
795         stages[5].name = 'ICO Stage 1 pre-sale 5';
796         stages[5].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5;
797         stages[5].bonus = BONUS_ICO_STAGE1_PRE_SALE5;
798 
799         stages[5].startsAt = stages[1].startsAt;
800         stages[5].endsAt = stages[1].endsAt;
801 
802         //ICO Stage 2
803         stages[6].name = 'ICO Stage 2';
804         stages[6].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE2;
805         stages[6].bonus = BONUS_ICO_STAGE2;
806 
807         if (isDebug) {
808             stages[6].startsAt = stages[5].endsAt;
809             stages[6].endsAt = stages[6].startsAt + 30 seconds;
810         } else {
811             stages[6].startsAt = 1524250800; //20th of April 2018 at 19:00UTC
812             stages[6].endsAt = 1526842800; //20th of May 2018 at 19:00UTC
813         }
814     }
815 
816     function _proceedStage()
817         internal
818     {
819         while (true) {
820             if ( currentStage < stages.length
821             && (now >= stages[currentStage].endsAt || getAvailableCoinsForCurrentStage() == 0) ) {
822                 currentStage++;
823                 uint totalTokensForSale = TOKEN_AMOUNT_PRE_ICO
824                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1
825                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2
826                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3
827                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4
828                                     + TOKEN_AMOUNT_ICO_STAGE2;
829 
830                 if (currentStage >= stages.length) {
831                     //Burning all unsold tokens and proportionally other for deligation
832                     _totalSupply -= ( ( ( stages[(stages.length - 1)].coinsAvailable * DST_BOUNTY ) / 100 )
833                                     + ( ( stages[(stages.length - 1)].coinsAvailable * DST_R_N_B_PROGRAM ) / 100 ) );
834 
835                     balances[BOUNTY_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_BOUNTY)/100);
836                     balances[R_N_D_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_R_N_B_PROGRAM)/100);
837 
838                     totalCoinsAvailable = 0;
839                     break; //ICO ended
840                 }
841 
842                 stages[currentStage].numCoinsStart = totalCoinsAvailable;
843 
844                 if ( currentStage > 0 ) {
845                     //Move all left tokens to last stage
846                     stages[(stages.length - 1)].coinsAvailable += stages[ (currentStage - 1 ) ].coinsAvailable;
847                     StageUpdated(stages[currentStage - 1].name, stages[currentStage].name);
848                 }
849             } else {
850                 break;
851             }
852         }
853     }
854 
855     function getTotalCoinsAvailable()
856         public
857         view
858         returns(uint)
859     {
860         return totalCoinsAvailable;
861     }
862 
863     function getAvailableCoinsForCurrentStage()
864         public
865         view
866         returns(uint)
867     {
868         TokenStage memory stage = stages[currentStage];
869 
870         return stage.coinsAvailable;
871     }
872 
873     //------------- ERC20 methods -------------//
874     function totalSupply()
875         public
876         constant
877         returns (uint256)
878     {
879         return _totalSupply;
880     }
881 
882 
883     // What is the balance of a particular account?
884     function balanceOf(address _owner)
885         public
886         constant
887         returns (uint256 balance)
888     {
889         return balances[_owner];
890     }
891 
892 
893     // Transfer the balance from owner's account to another account
894     function transfer(address _to, uint256 _amount)
895         public
896         onlyAfterICO
897         isFreezedReserve(_to)
898         returns (bool success)
899     {
900         if (balances[msg.sender] >= _amount
901             && _amount > 0
902             && balances[_to] + _amount > balances[_to]) {
903             balances[msg.sender] -= _amount;
904             balances[_to] += _amount;
905             Transfer(msg.sender, _to, _amount);
906 
907             return true;
908         } else {
909             return false;
910         }
911     }
912 
913 
914     // Send _value amount of tokens from address _from to address _to
915     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
916     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
917     // fees in sub-currencies; the command should fail unless the _from account has
918     // deliberately authorized the sender of the message via some mechanism; we propose
919     // these standardized APIs for approval:
920     function transferFrom(
921         address _from,
922         address _to,
923         uint256 _amount
924     )
925         public
926         onlyAfterICO
927         isFreezedReserve(_from)
928         isFreezedReserve(_to)
929         returns (bool success)
930     {
931         if (balances[_from] >= _amount
932             && allowed[_from][msg.sender] >= _amount
933             && _amount > 0
934             && balances[_to] + _amount > balances[_to]) {
935             balances[_from] -= _amount;
936             allowed[_from][msg.sender] -= _amount;
937             balances[_to] += _amount;
938             Transfer(_from, _to, _amount);
939             return true;
940         } else {
941             return false;
942         }
943     }
944 
945 
946     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
947     // If this function is called again it overwrites the current allowance with _value.
948     function approve(address _spender, uint256 _amount)
949         public
950         onlyAfterICO
951         isFreezedReserve(_spender)
952         returns (bool success)
953     {
954         allowed[msg.sender][_spender] = _amount;
955         Approval(msg.sender, _spender, _amount);
956         return true;
957     }
958 
959 
960     function allowance(address _owner, address _spender)
961         public
962         constant
963         returns (uint256 remaining)
964     {
965         return allowed[_owner][_spender];
966     }
967     //------------- ERC20 Methods END -------------//
968 
969     //Returns bonus for certain level of reference
970     function calculateReferralBonus(uint amount, uint level)
971         public
972         pure
973         returns (uint bonus)
974     {
975         bonus = 0;
976 
977         if ( level == 1 ) {
978             bonus = ( ( amount * REFERRAL_BONUS_LEVEL1 ) / 100 );
979         } else if (level == 2) {
980             bonus = ( ( amount * REFERRAL_BONUS_LEVEL2 ) / 100 );
981         } else if (level == 3) {
982             bonus = ( ( amount * REFERRAL_BONUS_LEVEL3 ) / 100 );
983         } else if (level == 4) {
984             bonus = ( ( amount * REFERRAL_BONUS_LEVEL4 ) / 100 );
985         } else if (level == 5) {
986             bonus = ( ( amount * REFERRAL_BONUS_LEVEL5 ) / 100 );
987         }
988     }
989 
990     function calculateBonus(uint amountOfTokens)
991         public
992         view
993         returns (uint)
994     {
995         return ( ( stages[currentStage].bonus * amountOfTokens ) / 100 );
996     }
997 
998     event TokenPurchased(string stage, uint valueSubmitted, uint valueRefunded, uint tokensPurchased);
999 
1000     function ()
1001         public
1002         payable
1003         notAdministrator
1004         onlyDuringICO
1005         meetTheCap
1006     {
1007         _proceedStage();
1008         require(currentStage < stages.length);
1009         require(stages[currentStage].startsAt <= now && now < stages[currentStage].endsAt);
1010         require(getAvailableCoinsForCurrentStage() > 0);
1011 
1012         uint requestedAmountOfTokens = ( ( msg.value * accuracy ) / price );
1013         uint amountToBuy = requestedAmountOfTokens;
1014         uint refund = 0;
1015 
1016         if ( amountToBuy > getAvailableCoinsForCurrentStage() ) {
1017             amountToBuy = getAvailableCoinsForCurrentStage();
1018             refund = ( ( (requestedAmountOfTokens - amountToBuy) / accuracy ) * price );
1019 
1020             // Returning ETH
1021             msg.sender.transfer( refund );
1022         }
1023 
1024         TokenPurchased(stages[currentStage].name, msg.value, refund, amountToBuy);
1025         stages[currentStage].coinsAvailable -= amountToBuy;
1026         stages[currentStage].balance += (msg.value - refund);
1027 
1028         uint amountDelivered = amountToBuy + calculateBonus(amountToBuy);
1029 
1030         balances[msg.sender] += amountDelivered;
1031         totalCoinsAvailable -= amountDelivered;
1032 
1033         if ( getAvailableCoinsForCurrentStage() == 0 ) {
1034             _proceedStage();
1035         }
1036 
1037         STORAGE_WALLET.transfer(this.balance);
1038     }
1039 
1040     //It doesn't really close the stage
1041     //It just needed to push transaction to update stage and update block.now
1042     function closeStage()
1043         public
1044         onlyAdministrator
1045     {
1046         _proceedStage();
1047     }
1048 }
1049 
1050 contract UNITv2 is ERC20Contract,Administrated {
1051     //Token symbol
1052     string public constant symbol = "UNIT";
1053     //Token name
1054     string public constant name = "Unilot token";
1055     //It can be reeeealy small
1056     uint8 public constant decimals = 18;
1057 
1058     //Total supply 500mln in the start
1059     uint96 public _totalSupply = uint96(500000000 * (10**18));
1060 
1061     UnilotToken public sourceToken;
1062 
1063     Whitelist public transferWhiteList;
1064 
1065     Whitelist public paymentGateways;
1066 
1067     TokenStagesManager public stagesManager;
1068 
1069     bool public unlocked = false;
1070 
1071     bool public burned = false;
1072 
1073     //tokenImport[tokenHolder][sourceToken] = true/false;
1074     mapping ( address => mapping ( address => bool ) ) public tokenImport;
1075 
1076     event TokensImported(address indexed tokenHolder, uint96 amount, address indexed source);
1077     event TokensDelegated(address indexed tokenHolder, uint96 amount, address indexed source);
1078     event Unlocked();
1079     event Burned(uint96 amount);
1080 
1081     modifier isLocked() {
1082         require(unlocked == false);
1083         _;
1084     }
1085 
1086     modifier isNotBurned() {
1087         require(burned == false);
1088         _;
1089     }
1090 
1091     modifier isTransferAllowed(address _from, address _to) {
1092         if ( sourceToken.RESERVE_WALLET() == _from ) {
1093             require( stagesManager.isFreezeTimeout() );
1094         }
1095         require(unlocked
1096                 || ( stagesManager != address(0) && stagesManager.isCanList() )
1097                 || ( transferWhiteList != address(0) && ( transferWhiteList.isInList(_from) || transferWhiteList.isInList(_to) ) )
1098         );
1099         _;
1100     }
1101 
1102     function UNITv2(address _sourceToken)
1103         public
1104     {
1105         setAdministrator(tx.origin);
1106         sourceToken = UnilotToken(_sourceToken);
1107 
1108         /*Transactions:
1109         0x99c28675adbd0d0cb7bd783ae197492078d4063f40c11139dd07c015a543ffcc
1110         0x86038d11ee8da46703309d2fb45d150f1dc4e2bba6d0a8fee158016111104ff1
1111         0x0340a8a2fb89513c0086a345973470b7bc33424e818ca6a32dcf9ad66bf9d75c
1112         */
1113         balances[0xd13289203889bD898d49e31a1500388441C03663] += 1400000000000000000 * 3;
1114         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xd13289203889bD898d49e31a1500388441C03663);
1115 
1116         //Tx: 0xec9b7b4c0f1435282e2e98a66efbd7610de7eacce3b2448cd5f503d70a64a895
1117         balances[0xE33305B2EFbcB302DA513C38671D01646651a868] += 1400000000000000000;
1118         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xE33305B2EFbcB302DA513C38671D01646651a868);
1119 
1120         //Assigning bounty
1121         balances[0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb] += uint96(
1122             ( uint(_totalSupply) * uint8( sourceToken.DST_BOUNTY() ) ) / 100
1123         );
1124 
1125         //Don't import bounty and R&B tokens
1126         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
1127         markAsImported(sourceToken, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
1128 
1129         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x91D740D87A8AeED1fc3EA3C346843173c529D63e);
1130     }
1131 
1132     function setTransferWhitelist(address whiteListAddress)
1133         public
1134         onlyAdministrator
1135         isNotBurned
1136     {
1137         transferWhiteList = Whitelist(whiteListAddress);
1138     }
1139 
1140     function disableTransferWhitelist()
1141         public
1142         onlyAdministrator
1143         isNotBurned
1144     {
1145         transferWhiteList = Whitelist(address(0));
1146     }
1147 
1148     function setStagesManager(address stagesManagerContract)
1149         public
1150         onlyAdministrator
1151         isNotBurned
1152     {
1153         stagesManager = TokenStagesManager(stagesManagerContract);
1154     }
1155 
1156     function setPaymentGatewayList(address paymentGatewayListContract)
1157         public
1158         onlyAdministrator
1159         isNotBurned
1160     {
1161         paymentGateways = Whitelist(paymentGatewayListContract);
1162     }
1163 
1164     //START Import related methods
1165     function isImported(address _sourceToken, address _tokenHolder)
1166         internal
1167         constant
1168         returns (bool)
1169     {
1170         return tokenImport[_tokenHolder][_sourceToken];
1171     }
1172 
1173     function markAsImported(address _sourceToken, address _tokenHolder)
1174         internal
1175     {
1176         tokenImport[_tokenHolder][_sourceToken] = true;
1177     }
1178 
1179     function importFromSource(ERC20 _sourceToken, address _tokenHolder)
1180         internal
1181     {
1182         if ( !isImported(_sourceToken, _tokenHolder) ) {
1183             uint96 oldBalance = uint96(_sourceToken.balanceOf(_tokenHolder));
1184             balances[_tokenHolder] += oldBalance;
1185             markAsImported(_sourceToken, _tokenHolder);
1186 
1187             TokensImported(_tokenHolder, oldBalance, _sourceToken);
1188         }
1189     }
1190 
1191     //Imports from source token
1192     function importTokensFromSourceToken(address _tokenHolder)
1193         internal
1194     {
1195         importFromSource(ERC20(sourceToken), _tokenHolder);
1196     }
1197 
1198     function importFromExternal(ERC20 _sourceToken, address _tokenHolder)
1199         public
1200         onlyAdministrator
1201         isNotBurned
1202     {
1203         return importFromSource(_sourceToken, _tokenHolder);
1204     }
1205 
1206     //Imports from provided token
1207     function importTokensSourceBulk(ERC20 _sourceToken, address[] _tokenHolders)
1208         public
1209         onlyAdministrator
1210         isNotBurned
1211     {
1212         require(_tokenHolders.length <= 256);
1213 
1214         for (uint8 i = 0; i < _tokenHolders.length; i++) {
1215             importFromSource(_sourceToken, _tokenHolders[i]);
1216         }
1217     }
1218     //END Import related methods
1219 
1220     //START ERC20
1221     function totalSupply()
1222         public
1223         constant
1224         returns (uint)
1225     {
1226         return uint(_totalSupply);
1227     }
1228 
1229     function balanceOf(address _owner)
1230         public
1231         constant
1232         returns (uint balance)
1233     {
1234         balance = super.balanceOf(_owner);
1235 
1236         if (!isImported(sourceToken, _owner)) {
1237             balance += sourceToken.balanceOf(_owner);
1238         }
1239     }
1240 
1241     function transfer(address _to, uint _amount)
1242         public
1243         isTransferAllowed(msg.sender, _to)
1244         returns (bool success)
1245     {
1246         return super.transfer(_to, _amount);
1247     }
1248 
1249     function transferFrom(
1250         address _from,
1251         address _to,
1252         uint256 _amount
1253     )
1254         public
1255         isTransferAllowed(_from, _to)
1256         returns (bool success)
1257     {
1258         return super.transferFrom(_from, _to, _amount);
1259     }
1260 
1261     function approve(address _spender, uint _amount)
1262         public
1263         isTransferAllowed(msg.sender, _spender)
1264         returns (bool success)
1265     {
1266         return super.approve(_spender, _amount);
1267     }
1268     //END ERC20
1269 
1270     function delegateTokens(address tokenHolder, uint96 amount)
1271         public
1272         isNotBurned
1273     {
1274         require(paymentGateways.isInList(msg.sender));
1275         require(stagesManager.isICO());
1276         require(stagesManager.getPool() >= amount);
1277 
1278         uint88 bonus = stagesManager.calculateBonus(amount);
1279         stagesManager.delegateFromPool(amount);
1280 
1281         balances[tokenHolder] += amount + uint96(bonus);
1282 
1283         TokensDelegated(tokenHolder, amount, msg.sender);
1284     }
1285 
1286     function delegateBonusTokens(address tokenHolder, uint88 amount)
1287         public
1288         isNotBurned
1289     {
1290         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
1291         require(stagesManager.getBonusPool() >= amount);
1292 
1293         stagesManager.delegateFromBonus(amount);
1294 
1295         balances[tokenHolder] += amount;
1296 
1297         TokensDelegated(tokenHolder, uint96(amount), msg.sender);
1298     }
1299 
1300     function delegateReferalTokens(address tokenHolder, uint88 amount)
1301         public
1302         isNotBurned
1303     {
1304         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
1305         require(stagesManager.getReferralPool() >= amount);
1306 
1307         stagesManager.delegateFromReferral(amount);
1308 
1309         balances[tokenHolder] += amount;
1310 
1311         TokensDelegated(tokenHolder, amount, msg.sender);
1312     }
1313 
1314     function delegateReferralTokensBulk(address[] tokenHolders, uint88[] amounts)
1315         public
1316         isNotBurned
1317     {
1318         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
1319         require(tokenHolders.length <= 256);
1320         require(tokenHolders.length == amounts.length);
1321 
1322         for ( uint8 i = 0; i < tokenHolders.length; i++ ) {
1323             delegateReferalTokens(tokenHolders[i], amounts[i]);
1324         }
1325     }
1326 
1327     function unlock()
1328         public
1329         isLocked
1330         onlyAdministrator
1331     {
1332         unlocked = true;
1333         Unlocked();
1334     }
1335 
1336     function burn()
1337         public
1338         onlyAdministrator
1339     {
1340         require(!stagesManager.isICO());
1341 
1342         uint96 burnAmount = stagesManager.getPool()
1343                         + stagesManager.getBonusPool()
1344                         + stagesManager.getReferralPool();
1345 
1346         _totalSupply -= burnAmount;
1347         burned = true;
1348         Burned(burnAmount);
1349     }
1350 }