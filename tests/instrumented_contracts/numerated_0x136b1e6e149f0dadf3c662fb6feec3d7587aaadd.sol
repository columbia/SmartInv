1 pragma solidity ^0.4.18;
2 
3 interface PaymentGateway {
4 
5 }
6 
7 contract Administrated {
8     address public administrator;
9 
10     modifier onlyAdministrator() {
11         require(administrator == tx.origin);
12         _;
13     }
14 
15     modifier notAdministrator() {
16         require(administrator != tx.origin);
17         _;
18     }
19 
20     function setAdministrator(address _administrator)
21         internal
22     {
23         administrator = _administrator;
24     }
25 }
26 
27 interface ERC20 {
28     event Transfer(address indexed _from, address indexed _to, uint _value);
29     event Approval(address indexed _owner, address indexed _spender, uint _value);
30 
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address _owner) public constant returns (uint balance);
33     function transfer(address _to, uint _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
35     function approve(address _spender, uint _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint remaining);
37 }
38 
39 contract UnilotToken is ERC20 {
40     struct TokenStage {
41         string name;
42         uint numCoinsStart;
43         uint coinsAvailable;
44         uint bonus;
45         uint startsAt;
46         uint endsAt;
47         uint balance; //Amount of ether sent during this stage
48     }
49 
50     //Token symbol
51     string public constant symbol = "UNIT";
52     //Token name
53     string public constant name = "Unilot token";
54     //It can be reeeealy small
55     uint8 public constant decimals = 18;
56 
57     //This one duplicates the above but will have to use it because of
58     //solidity bug with power operation
59     uint public constant accuracy = 1000000000000000000;
60 
61     //500 mln tokens
62     uint256 internal _totalSupply = 500 * (10**6) * accuracy;
63 
64     //Public investor can buy tokens for 30 ether at maximum
65     uint256 public constant singleInvestorCap = 30 ether; //30 ether
66 
67     //Distribution units
68     uint public constant DST_ICO     = 62; //62%
69     uint public constant DST_RESERVE = 10; //10%
70     uint public constant DST_BOUNTY  = 3;  //3%
71     //Referral and Bonus Program
72     uint public constant DST_R_N_B_PROGRAM = 10; //10%
73     uint public constant DST_ADVISERS      = 5;  //5%
74     uint public constant DST_TEAM          = 10; //10%
75 
76     //Referral Bonuses
77     uint public constant REFERRAL_BONUS_LEVEL1 = 5; //5%
78     uint public constant REFERRAL_BONUS_LEVEL2 = 4; //4%
79     uint public constant REFERRAL_BONUS_LEVEL3 = 3; //3%
80     uint public constant REFERRAL_BONUS_LEVEL4 = 2; //2%
81     uint public constant REFERRAL_BONUS_LEVEL5 = 1; //1%
82 
83     //Token amount
84     //25 mln tokens
85     uint public constant TOKEN_AMOUNT_PRE_ICO = 25 * (10**6) * accuracy;
86     //5 mln tokens
87     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1 = 5 * (10**6) * accuracy;
88     //5 mln tokens
89     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2 = 5 * (10**6) * accuracy;
90     //5 mln tokens
91     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3 = 5 * (10**6) * accuracy;
92     //5 mln tokens
93     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4 = 5 * (10**6) * accuracy;
94     //122.5 mln tokens
95     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5 = 1225 * (10**5) * accuracy;
96     //265 mln tokens
97     uint public constant TOKEN_AMOUNT_ICO_STAGE2 = 1425 * (10**5) * accuracy;
98 
99     uint public constant BONUS_PRE_ICO = 40; //40%
100     uint public constant BONUS_ICO_STAGE1_PRE_SALE1 = 35; //35%
101     uint public constant BONUS_ICO_STAGE1_PRE_SALE2 = 30; //30%
102     uint public constant BONUS_ICO_STAGE1_PRE_SALE3 = 25; //25%
103     uint public constant BONUS_ICO_STAGE1_PRE_SALE4 = 20; //20%
104     uint public constant BONUS_ICO_STAGE1_PRE_SALE5 = 0; //0%
105     uint public constant BONUS_ICO_STAGE2 = 0; //No bonus
106 
107     //Token Price on Coin Offer
108     uint256 public constant price = 79 szabo; //0.000079 ETH
109 
110     address public constant ADVISORS_WALLET = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
111     address public constant RESERVE_WALLET = 0x731B47847352fA2cFf83D5251FD6a5266f90878d;
112     address public constant BOUNTY_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
113     address public constant R_N_D_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
114     address public constant STORAGE_WALLET = 0xE2A8F147fc808738Cab152b01C7245F386fD8d89;
115 
116     // Owner of this contract
117     address public administrator;
118 
119     // Balances for each account
120     mapping(address => uint256) balances;
121 
122     // Owner of account approves the transfer of an amount to another account
123     mapping(address => mapping (address => uint256)) allowed;
124 
125     //Mostly needed for internal use
126     uint256 internal totalCoinsAvailable;
127 
128     //All token stages. Total 6 stages
129     TokenStage[7] stages;
130 
131     //Index of current stage in stage array
132     uint currentStage;
133 
134     //Enables or disables debug mode. Debug mode is set only in constructor.
135     bool isDebug = false;
136 
137     event StageUpdated(string from, string to);
138 
139     // Functions with this modifier can only be executed by the owner
140     modifier onlyAdministrator() {
141         require(msg.sender == administrator);
142         _;
143     }
144 
145     modifier notAdministrator() {
146         require(msg.sender != administrator);
147         _;
148     }
149 
150     modifier onlyDuringICO() {
151         require(currentStage < stages.length);
152         _;
153     }
154 
155     modifier onlyAfterICO(){
156         require(currentStage >= stages.length);
157         _;
158     }
159 
160     modifier meetTheCap() {
161         require(msg.value >= price); // At least one token
162         _;
163     }
164 
165     modifier isFreezedReserve(address _address) {
166         require( ( _address == RESERVE_WALLET ) && now > (stages[ (stages.length - 1) ].endsAt + 182 days));
167         _;
168     }
169 
170     // Constructor
171     function UnilotToken()
172         public
173     {
174         administrator = msg.sender;
175         totalCoinsAvailable = _totalSupply;
176         //Was as fn parameter for debugging
177         isDebug = false;
178 
179         _setupStages();
180         _proceedStage();
181     }
182 
183     function prealocateCoins()
184         public
185         onlyAdministrator
186     {
187         totalCoinsAvailable -= balances[ADVISORS_WALLET] += ( ( _totalSupply * DST_ADVISERS ) / 100 );
188         totalCoinsAvailable -= balances[RESERVE_WALLET] += ( ( _totalSupply * DST_RESERVE ) / 100 );
189 
190         address[7] memory teamWallets = getTeamWallets();
191         uint teamSupply = ( ( _totalSupply * DST_TEAM ) / 100 );
192         uint memberAmount = teamSupply / teamWallets.length;
193 
194         for(uint i = 0; i < teamWallets.length; i++) {
195             if ( i == ( teamWallets.length - 1 ) ) {
196                 memberAmount = teamSupply;
197             }
198 
199             balances[teamWallets[i]] += memberAmount;
200             teamSupply -= memberAmount;
201             totalCoinsAvailable -= memberAmount;
202         }
203     }
204 
205     function getTeamWallets()
206         public
207         pure
208         returns (address[7] memory result)
209     {
210         result[0] = 0x40e3D8fFc46d73Ab5DF878C751D813a4cB7B388D;
211         result[1] = 0x5E065a80f6635B6a46323e3383057cE6051aAcA0;
212         result[2] = 0x0cF3585FbAB2a1299F8347a9B87CF7B4fcdCE599;
213         result[3] = 0x5fDd3BA5B6Ff349d31eB0a72A953E454C99494aC;
214         result[4] = 0xC9be9818eE1B2cCf2E4f669d24eB0798390Ffb54;
215         result[5] = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
216         result[6] = 0xd13289203889bD898d49e31a1500388441C03663;
217     }
218 
219     function _setupStages()
220         internal
221     {
222         //Presale stage
223         stages[0].name = 'Presale stage';
224         stages[0].numCoinsStart = totalCoinsAvailable;
225         stages[0].coinsAvailable = TOKEN_AMOUNT_PRE_ICO;
226         stages[0].bonus = BONUS_PRE_ICO;
227 
228         if (isDebug) {
229             stages[0].startsAt = now;
230             stages[0].endsAt = stages[0].startsAt + 30 seconds;
231         } else {
232             stages[0].startsAt = 1515610800; //10th of January 2018 at 19:00UTC
233             stages[0].endsAt = 1518894000; //17th of February 2018 at 19:00UTC
234         }
235 
236         //ICO Stage 1 pre-sale 1
237         stages[1].name = 'ICO Stage 1 pre-sale 1';
238         stages[1].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1;
239         stages[1].bonus = BONUS_ICO_STAGE1_PRE_SALE1;
240 
241         if (isDebug) {
242             stages[1].startsAt = stages[0].endsAt;
243             stages[1].endsAt = stages[1].startsAt + 30 seconds;
244         } else {
245             stages[1].startsAt = 1519326000; //22th of February 2018 at 19:00UTC
246             stages[1].endsAt = 1521745200; //22th of March 2018 at 19:00UTC
247         }
248 
249         //ICO Stage 1 pre-sale 2
250         stages[2].name = 'ICO Stage 1 pre-sale 2';
251         stages[2].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2;
252         stages[2].bonus = BONUS_ICO_STAGE1_PRE_SALE2;
253 
254         stages[2].startsAt = stages[1].startsAt;
255         stages[2].endsAt = stages[1].endsAt;
256 
257         //ICO Stage 1 pre-sale 3
258         stages[3].name = 'ICO Stage 1 pre-sale 3';
259         stages[3].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3;
260         stages[3].bonus = BONUS_ICO_STAGE1_PRE_SALE3;
261 
262         stages[3].startsAt = stages[1].startsAt;
263         stages[3].endsAt = stages[1].endsAt;
264 
265         //ICO Stage 1 pre-sale 4
266         stages[4].name = 'ICO Stage 1 pre-sale 4';
267         stages[4].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4;
268         stages[4].bonus = BONUS_ICO_STAGE1_PRE_SALE4;
269 
270         stages[4].startsAt = stages[1].startsAt;
271         stages[4].endsAt = stages[1].endsAt;
272 
273         //ICO Stage 1 pre-sale 5
274         stages[5].name = 'ICO Stage 1 pre-sale 5';
275         stages[5].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5;
276         stages[5].bonus = BONUS_ICO_STAGE1_PRE_SALE5;
277 
278         stages[5].startsAt = stages[1].startsAt;
279         stages[5].endsAt = stages[1].endsAt;
280 
281         //ICO Stage 2
282         stages[6].name = 'ICO Stage 2';
283         stages[6].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE2;
284         stages[6].bonus = BONUS_ICO_STAGE2;
285 
286         if (isDebug) {
287             stages[6].startsAt = stages[5].endsAt;
288             stages[6].endsAt = stages[6].startsAt + 30 seconds;
289         } else {
290             stages[6].startsAt = 1524250800; //20th of April 2018 at 19:00UTC
291             stages[6].endsAt = 1526842800; //20th of May 2018 at 19:00UTC
292         }
293     }
294 
295     function _proceedStage()
296         internal
297     {
298         while (true) {
299             if ( currentStage < stages.length
300             && (now >= stages[currentStage].endsAt || getAvailableCoinsForCurrentStage() == 0) ) {
301                 currentStage++;
302                 uint totalTokensForSale = TOKEN_AMOUNT_PRE_ICO
303                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1
304                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2
305                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3
306                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4
307                                     + TOKEN_AMOUNT_ICO_STAGE2;
308 
309                 if (currentStage >= stages.length) {
310                     //Burning all unsold tokens and proportionally other for deligation
311                     _totalSupply -= ( ( ( stages[(stages.length - 1)].coinsAvailable * DST_BOUNTY ) / 100 )
312                                     + ( ( stages[(stages.length - 1)].coinsAvailable * DST_R_N_B_PROGRAM ) / 100 ) );
313 
314                     balances[BOUNTY_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_BOUNTY)/100);
315                     balances[R_N_D_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_R_N_B_PROGRAM)/100);
316 
317                     totalCoinsAvailable = 0;
318                     break; //ICO ended
319                 }
320 
321                 stages[currentStage].numCoinsStart = totalCoinsAvailable;
322 
323                 if ( currentStage > 0 ) {
324                     //Move all left tokens to last stage
325                     stages[(stages.length - 1)].coinsAvailable += stages[ (currentStage - 1 ) ].coinsAvailable;
326                     StageUpdated(stages[currentStage - 1].name, stages[currentStage].name);
327                 }
328             } else {
329                 break;
330             }
331         }
332     }
333 
334     function getTotalCoinsAvailable()
335         public
336         view
337         returns(uint)
338     {
339         return totalCoinsAvailable;
340     }
341 
342     function getAvailableCoinsForCurrentStage()
343         public
344         view
345         returns(uint)
346     {
347         TokenStage memory stage = stages[currentStage];
348 
349         return stage.coinsAvailable;
350     }
351 
352     //------------- ERC20 methods -------------//
353     function totalSupply()
354         public
355         constant
356         returns (uint256)
357     {
358         return _totalSupply;
359     }
360 
361 
362     // What is the balance of a particular account?
363     function balanceOf(address _owner)
364         public
365         constant
366         returns (uint256 balance)
367     {
368         return balances[_owner];
369     }
370 
371 
372     // Transfer the balance from owner's account to another account
373     function transfer(address _to, uint256 _amount)
374         public
375         onlyAfterICO
376         isFreezedReserve(_to)
377         returns (bool success)
378     {
379         if (balances[msg.sender] >= _amount
380             && _amount > 0
381             && balances[_to] + _amount > balances[_to]) {
382             balances[msg.sender] -= _amount;
383             balances[_to] += _amount;
384             Transfer(msg.sender, _to, _amount);
385 
386             return true;
387         } else {
388             return false;
389         }
390     }
391 
392 
393     // Send _value amount of tokens from address _from to address _to
394     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
395     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
396     // fees in sub-currencies; the command should fail unless the _from account has
397     // deliberately authorized the sender of the message via some mechanism; we propose
398     // these standardized APIs for approval:
399     function transferFrom(
400         address _from,
401         address _to,
402         uint256 _amount
403     )
404         public
405         onlyAfterICO
406         isFreezedReserve(_from)
407         isFreezedReserve(_to)
408         returns (bool success)
409     {
410         if (balances[_from] >= _amount
411             && allowed[_from][msg.sender] >= _amount
412             && _amount > 0
413             && balances[_to] + _amount > balances[_to]) {
414             balances[_from] -= _amount;
415             allowed[_from][msg.sender] -= _amount;
416             balances[_to] += _amount;
417             Transfer(_from, _to, _amount);
418             return true;
419         } else {
420             return false;
421         }
422     }
423 
424 
425     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
426     // If this function is called again it overwrites the current allowance with _value.
427     function approve(address _spender, uint256 _amount)
428         public
429         onlyAfterICO
430         isFreezedReserve(_spender)
431         returns (bool success)
432     {
433         allowed[msg.sender][_spender] = _amount;
434         Approval(msg.sender, _spender, _amount);
435         return true;
436     }
437 
438 
439     function allowance(address _owner, address _spender)
440         public
441         constant
442         returns (uint256 remaining)
443     {
444         return allowed[_owner][_spender];
445     }
446     //------------- ERC20 Methods END -------------//
447 
448     //Returns bonus for certain level of reference
449     function calculateReferralBonus(uint amount, uint level)
450         public
451         pure
452         returns (uint bonus)
453     {
454         bonus = 0;
455 
456         if ( level == 1 ) {
457             bonus = ( ( amount * REFERRAL_BONUS_LEVEL1 ) / 100 );
458         } else if (level == 2) {
459             bonus = ( ( amount * REFERRAL_BONUS_LEVEL2 ) / 100 );
460         } else if (level == 3) {
461             bonus = ( ( amount * REFERRAL_BONUS_LEVEL3 ) / 100 );
462         } else if (level == 4) {
463             bonus = ( ( amount * REFERRAL_BONUS_LEVEL4 ) / 100 );
464         } else if (level == 5) {
465             bonus = ( ( amount * REFERRAL_BONUS_LEVEL5 ) / 100 );
466         }
467     }
468 
469     function calculateBonus(uint amountOfTokens)
470         public
471         view
472         returns (uint)
473     {
474         return ( ( stages[currentStage].bonus * amountOfTokens ) / 100 );
475     }
476 
477     event TokenPurchased(string stage, uint valueSubmitted, uint valueRefunded, uint tokensPurchased);
478 
479     function ()
480         public
481         payable
482         notAdministrator
483         onlyDuringICO
484         meetTheCap
485     {
486         _proceedStage();
487         require(currentStage < stages.length);
488         require(stages[currentStage].startsAt <= now && now < stages[currentStage].endsAt);
489         require(getAvailableCoinsForCurrentStage() > 0);
490 
491         uint requestedAmountOfTokens = ( ( msg.value * accuracy ) / price );
492         uint amountToBuy = requestedAmountOfTokens;
493         uint refund = 0;
494 
495         if ( amountToBuy > getAvailableCoinsForCurrentStage() ) {
496             amountToBuy = getAvailableCoinsForCurrentStage();
497             refund = ( ( (requestedAmountOfTokens - amountToBuy) / accuracy ) * price );
498 
499             // Returning ETH
500             msg.sender.transfer( refund );
501         }
502 
503         TokenPurchased(stages[currentStage].name, msg.value, refund, amountToBuy);
504         stages[currentStage].coinsAvailable -= amountToBuy;
505         stages[currentStage].balance += (msg.value - refund);
506 
507         uint amountDelivered = amountToBuy + calculateBonus(amountToBuy);
508 
509         balances[msg.sender] += amountDelivered;
510         totalCoinsAvailable -= amountDelivered;
511 
512         if ( getAvailableCoinsForCurrentStage() == 0 ) {
513             _proceedStage();
514         }
515 
516         STORAGE_WALLET.transfer(this.balance);
517     }
518 
519     //It doesn't really close the stage
520     //It just needed to push transaction to update stage and update block.now
521     function closeStage()
522         public
523         onlyAdministrator
524     {
525         _proceedStage();
526     }
527 }
528 
529 contract ERC20Contract is ERC20 {
530     //Token symbol
531     string public constant symbol = "UNIT";
532 
533     //Token name
534     string public constant name = "Unilot token";
535 
536     //It can be reeeealy small
537     uint8 public constant decimals = 18;
538 
539     // Balances for each account
540     mapping(address => uint96) public balances;
541 
542     // Owner of account approves the transfer of an amount to another account
543     mapping(address => mapping (address => uint96)) allowed;
544 
545     function totalSupply()
546         public
547         constant
548         returns (uint);
549 
550 
551     // What is the balance of a particular account?
552     function balanceOf(address _owner)
553         public
554         constant
555         returns (uint balance)
556     {
557         return uint(balances[_owner]);
558     }
559 
560 
561     // Transfer the balance from owner's account to another account
562     function transfer(address _to, uint _amount)
563         public
564         returns (bool success)
565     {
566         if (balances[msg.sender] >= _amount
567             && _amount > 0
568             && balances[_to] + _amount > balances[_to]) {
569             balances[msg.sender] -= uint96(_amount);
570             balances[_to] += uint96(_amount);
571             Transfer(msg.sender, _to, _amount);
572 
573             return true;
574         } else {
575             return false;
576         }
577     }
578 
579 
580     // Send _value amount of tokens from address _from to address _to
581     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
582     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
583     // fees in sub-currencies; the command should fail unless the _from account has
584     // deliberately authorized the sender of the message via some mechanism; we propose
585     // these standardized APIs for approval:
586     function transferFrom(
587         address _from,
588         address _to,
589         uint256 _amount
590     )
591         public
592         returns (bool success)
593     {
594         if (balances[_from] >= _amount
595             && allowed[_from][msg.sender] >= _amount
596             && _amount > 0
597             && balances[_to] + _amount > balances[_to]) {
598             balances[_from] -= uint96(_amount);
599             allowed[_from][msg.sender] -= uint96(_amount);
600             balances[_to] += uint96(_amount);
601             Transfer(_from, _to, _amount);
602             return true;
603         } else {
604             return false;
605         }
606     }
607 
608 
609     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
610     // If this function is called again it overwrites the current allowance with _value.
611     function approve(address _spender, uint _amount)
612         public
613         returns (bool success)
614     {
615         allowed[msg.sender][_spender] = uint96(_amount);
616         Approval(msg.sender, _spender, _amount);
617         return true;
618     }
619 
620 
621     function allowance(address _owner, address _spender)
622         public
623         constant
624         returns (uint remaining)
625     {
626         return allowed[_owner][_spender];
627     }
628 }
629 
630 interface TokenStagesManager {
631     function isDebug() public constant returns(bool);
632     function setToken(address tokenAddress) public;
633     function getPool() public constant returns (uint96);
634     function getBonus() public constant returns (uint8);
635     function isFreezeTimeout() public constant returns (bool);
636     function isTimeout() public constant returns (bool);
637     function isICO() public view returns(bool);
638     function isCanList() public view returns (bool);
639     function calculateBonus(uint96 amount) public view returns (uint88);
640     function delegateFromPool(uint96 amount) public;
641     function delegateFromBonus(uint88 amount) public;
642     function delegateFromReferral(uint88 amount) public;
643 
644     function getBonusPool() public constant returns(uint88);
645     function getReferralPool() public constant returns(uint88);
646 }
647 
648 interface Whitelist {
649     function add(address _wlAddress) public;
650     function addBulk(address[] _wlAddresses) public;
651     function remove(address _wlAddresses) public;
652     function removeBulk(address[] _wlAddresses) public;
653     function getAll() public constant returns(address[]);
654     function isInList(address _checkAddress) public constant returns(bool);
655 }
656 
657 contract UNITv2 is ERC20Contract,Administrated {
658     //Token symbol
659     string public constant symbol = "UNIT";
660     //Token name
661     string public constant name = "Unilot token";
662     //It can be reeeealy small
663     uint8 public constant decimals = 18;
664 
665     //Total supply 500mln in the start
666     uint96 public _totalSupply = uint96(500000000 * (10**18));
667 
668     UnilotToken public sourceToken;
669 
670     Whitelist public transferWhiteList;
671 
672     Whitelist public paymentGateways;
673 
674     TokenStagesManager public stagesManager;
675 
676     bool public unlocked = false;
677 
678     bool public burned = false;
679 
680     //tokenImport[tokenHolder][sourceToken] = true/false;
681     mapping ( address => mapping ( address => bool ) ) public tokenImport;
682 
683     event TokensImported(address indexed tokenHolder, uint96 amount, address indexed source);
684     event TokensDelegated(address indexed tokenHolder, uint96 amount, address indexed source);
685     event Unlocked();
686     event Burned(uint96 amount);
687 
688     modifier isLocked() {
689         require(unlocked == false);
690         _;
691     }
692 
693     modifier isNotBurned() {
694         require(burned == false);
695         _;
696     }
697 
698     modifier isTransferAllowed(address _from, address _to) {
699         if ( sourceToken.RESERVE_WALLET() == _from ) {
700             require( stagesManager.isFreezeTimeout() );
701         }
702         require(unlocked
703                 || ( stagesManager != address(0) && stagesManager.isCanList() )
704                 || ( transferWhiteList != address(0) && ( transferWhiteList.isInList(_from) || transferWhiteList.isInList(_to) ) )
705         );
706         _;
707     }
708 
709     function UNITv2(address _sourceToken)
710         public
711     {
712         setAdministrator(tx.origin);
713         sourceToken = UnilotToken(_sourceToken);
714 
715         /*Transactions:
716         0x99c28675adbd0d0cb7bd783ae197492078d4063f40c11139dd07c015a543ffcc
717         0x86038d11ee8da46703309d2fb45d150f1dc4e2bba6d0a8fee158016111104ff1
718         0x0340a8a2fb89513c0086a345973470b7bc33424e818ca6a32dcf9ad66bf9d75c
719         */
720         balances[0xd13289203889bD898d49e31a1500388441C03663] += 1400000000000000000 * 3;
721         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xd13289203889bD898d49e31a1500388441C03663);
722 
723         //Tx: 0xec9b7b4c0f1435282e2e98a66efbd7610de7eacce3b2448cd5f503d70a64a895
724         balances[0xE33305B2EFbcB302DA513C38671D01646651a868] += 1400000000000000000;
725         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xE33305B2EFbcB302DA513C38671D01646651a868);
726 
727         //Assigning bounty
728         balances[0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb] += uint96(
729             ( uint(_totalSupply) * uint8( sourceToken.DST_BOUNTY() ) ) / 100
730         );
731 
732         //Don't import bounty and R&B tokens
733         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
734         markAsImported(sourceToken, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
735 
736         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x91D740D87A8AeED1fc3EA3C346843173c529D63e);
737     }
738 
739     function setTransferWhitelist(address whiteListAddress)
740         public
741         onlyAdministrator
742         isNotBurned
743     {
744         transferWhiteList = Whitelist(whiteListAddress);
745     }
746 
747     function disableTransferWhitelist()
748         public
749         onlyAdministrator
750         isNotBurned
751     {
752         transferWhiteList = Whitelist(address(0));
753     }
754 
755     function setStagesManager(address stagesManagerContract)
756         public
757         onlyAdministrator
758         isNotBurned
759     {
760         stagesManager = TokenStagesManager(stagesManagerContract);
761     }
762 
763     function setPaymentGatewayList(address paymentGatewayListContract)
764         public
765         onlyAdministrator
766         isNotBurned
767     {
768         paymentGateways = Whitelist(paymentGatewayListContract);
769     }
770 
771     //START Import related methods
772     function isImported(address _sourceToken, address _tokenHolder)
773         internal
774         constant
775         returns (bool)
776     {
777         return tokenImport[_tokenHolder][_sourceToken];
778     }
779 
780     function markAsImported(address _sourceToken, address _tokenHolder)
781         internal
782     {
783         tokenImport[_tokenHolder][_sourceToken] = true;
784     }
785 
786     function importFromSource(ERC20 _sourceToken, address _tokenHolder)
787         internal
788     {
789         if ( !isImported(_sourceToken, _tokenHolder) ) {
790             uint96 oldBalance = uint96(_sourceToken.balanceOf(_tokenHolder));
791             balances[_tokenHolder] += oldBalance;
792             markAsImported(_sourceToken, _tokenHolder);
793 
794             TokensImported(_tokenHolder, oldBalance, _sourceToken);
795         }
796     }
797 
798     //Imports from source token
799     function importTokensFromSourceToken(address _tokenHolder)
800         internal
801     {
802         importFromSource(ERC20(sourceToken), _tokenHolder);
803     }
804 
805     function importFromExternal(ERC20 _sourceToken, address _tokenHolder)
806         public
807         onlyAdministrator
808         isNotBurned
809     {
810         return importFromSource(_sourceToken, _tokenHolder);
811     }
812 
813     //Imports from provided token
814     function importTokensSourceBulk(ERC20 _sourceToken, address[] _tokenHolders)
815         public
816         onlyAdministrator
817         isNotBurned
818     {
819         require(_tokenHolders.length <= 256);
820 
821         for (uint8 i = 0; i < _tokenHolders.length; i++) {
822             importFromSource(_sourceToken, _tokenHolders[i]);
823         }
824     }
825     //END Import related methods
826 
827     //START ERC20
828     function totalSupply()
829         public
830         constant
831         returns (uint)
832     {
833         return uint(_totalSupply);
834     }
835 
836     function balanceOf(address _owner)
837         public
838         constant
839         returns (uint balance)
840     {
841         balance = super.balanceOf(_owner);
842 
843         if (!isImported(sourceToken, _owner)) {
844             balance += sourceToken.balanceOf(_owner);
845         }
846     }
847 
848     function transfer(address _to, uint _amount)
849         public
850         isTransferAllowed(msg.sender, _to)
851         returns (bool success)
852     {
853         return super.transfer(_to, _amount);
854     }
855 
856     function transferFrom(
857         address _from,
858         address _to,
859         uint256 _amount
860     )
861         public
862         isTransferAllowed(_from, _to)
863         returns (bool success)
864     {
865         return super.transferFrom(_from, _to, _amount);
866     }
867 
868     function approve(address _spender, uint _amount)
869         public
870         isTransferAllowed(msg.sender, _spender)
871         returns (bool success)
872     {
873         return super.approve(_spender, _amount);
874     }
875     //END ERC20
876 
877     function delegateTokens(address tokenHolder, uint96 amount)
878         public
879         isNotBurned
880     {
881         require(paymentGateways.isInList(msg.sender));
882         require(stagesManager.isICO());
883         require(stagesManager.getPool() >= amount);
884 
885         uint88 bonus = stagesManager.calculateBonus(amount);
886         stagesManager.delegateFromPool(amount);
887 
888         balances[tokenHolder] += amount + uint96(bonus);
889 
890         TokensDelegated(tokenHolder, amount, msg.sender);
891     }
892 
893     function delegateBonusTokens(address tokenHolder, uint88 amount)
894         public
895         isNotBurned
896     {
897         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
898         require(stagesManager.getBonusPool() >= amount);
899 
900         stagesManager.delegateFromBonus(amount);
901 
902         balances[tokenHolder] += amount;
903 
904         TokensDelegated(tokenHolder, uint96(amount), msg.sender);
905     }
906 
907     function delegateReferalTokens(address tokenHolder, uint88 amount)
908         public
909         isNotBurned
910     {
911         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
912         require(stagesManager.getReferralPool() >= amount);
913 
914         stagesManager.delegateFromReferral(amount);
915 
916         balances[tokenHolder] += amount;
917 
918         TokensDelegated(tokenHolder, amount, msg.sender);
919     }
920 
921     function delegateReferralTokensBulk(address[] tokenHolders, uint88[] amounts)
922         public
923         isNotBurned
924     {
925         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
926         require(tokenHolders.length <= 256);
927         require(tokenHolders.length == amounts.length);
928 
929         for ( uint8 i = 0; i < tokenHolders.length; i++ ) {
930             delegateReferalTokens(tokenHolders[i], amounts[i]);
931         }
932     }
933 
934     function unlock()
935         public
936         isLocked
937         onlyAdministrator
938     {
939         unlocked = true;
940         Unlocked();
941     }
942 
943     function burn()
944         public
945         onlyAdministrator
946     {
947         require(!stagesManager.isICO());
948 
949         uint96 burnAmount = stagesManager.getPool()
950                         + stagesManager.getBonusPool()
951                         + stagesManager.getReferralPool();
952 
953         _totalSupply -= burnAmount;
954         burned = true;
955         Burned(burnAmount);
956     }
957 }
958 
959 contract UNITDummyPaymentGateway is Administrated {
960     UNITv2 public token;
961 
962     bool public locked = false;
963 
964     uint48 public constant PRICE = 79 szabo;
965 
966     address public storageAddress = 0x1b5DE6153c86F92a63A680896e9F088943c0Ead8;
967 
968     event Payment(address indexed payer, uint amount, uint refund, uint96 numTokens);
969 
970     function UNITDummyPaymentGateway(address _token)
971         public
972     {
973         token = UNITv2(_token);
974         setAdministrator(tx.origin);
975     }
976 
977     function setToken(address _token)
978         public
979         onlyAdministrator
980     {
981         token = UNITv2(_token);
982     }
983 
984     function delegateTokens(address tokenHolder, uint96 numTokens)
985         public
986         onlyAdministrator
987     {
988         require(locked == false);
989 
990         Payment(tokenHolder, 0, 0, numTokens);
991 
992         token.delegateTokens(tokenHolder, numTokens);
993 
994         storageAddress.transfer(this.balance);
995     }
996 
997     function lock()
998         public
999         onlyAdministrator
1000     {
1001         locked = true;
1002     }
1003 
1004     function unlock()
1005         public
1006         onlyAdministrator
1007     {
1008         locked = false;
1009     }
1010 }