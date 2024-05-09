1 pragma solidity ^0.4.18;
2 
3 //Interfaces
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     event Transfer(address indexed _from, address indexed _to, uint _value);
8     event Approval(address indexed _owner, address indexed _spender, uint _value);
9 
10     function totalSupply() public constant returns (uint);
11     function balanceOf(address _owner) public constant returns (uint balance);
12     function transfer(address _to, uint _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
14     function approve(address _spender, uint _value) public returns (bool success);
15     function allowance(address _owner, address _spender) public constant returns (uint remaining);
16 }
17 
18 contract UnilotToken is ERC20 {
19     struct TokenStage {
20         string name;
21         uint numCoinsStart;
22         uint coinsAvailable;
23         uint bonus;
24         uint startsAt;
25         uint endsAt;
26         uint balance; //Amount of ether sent during this stage
27     }
28 
29     //Token symbol
30     string public constant symbol = "UNIT";
31     //Token name
32     string public constant name = "Unilot token";
33     //It can be reeeealy small
34     uint8 public constant decimals = 18;
35 
36     //This one duplicates the above but will have to use it because of
37     //solidity bug with power operation
38     uint public constant accuracy = 1000000000000000000;
39 
40     //500 mln tokens
41     uint256 internal _totalSupply = 500 * (10**6) * accuracy;
42 
43     //Public investor can buy tokens for 30 ether at maximum
44     uint256 public constant singleInvestorCap = 30 ether; //30 ether
45 
46     //Distribution units
47     uint public constant DST_ICO     = 62; //62%
48     uint public constant DST_RESERVE = 10; //10%
49     uint public constant DST_BOUNTY  = 3;  //3%
50     //Referral and Bonus Program
51     uint public constant DST_R_N_B_PROGRAM = 10; //10%
52     uint public constant DST_ADVISERS      = 5;  //5%
53     uint public constant DST_TEAM          = 10; //10%
54 
55     //Referral Bonuses
56     uint public constant REFERRAL_BONUS_LEVEL1 = 5; //5%
57     uint public constant REFERRAL_BONUS_LEVEL2 = 4; //4%
58     uint public constant REFERRAL_BONUS_LEVEL3 = 3; //3%
59     uint public constant REFERRAL_BONUS_LEVEL4 = 2; //2%
60     uint public constant REFERRAL_BONUS_LEVEL5 = 1; //1%
61 
62     //Token amount
63     //25 mln tokens
64     uint public constant TOKEN_AMOUNT_PRE_ICO = 25 * (10**6) * accuracy;
65     //5 mln tokens
66     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1 = 5 * (10**6) * accuracy;
67     //5 mln tokens
68     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2 = 5 * (10**6) * accuracy;
69     //5 mln tokens
70     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3 = 5 * (10**6) * accuracy;
71     //5 mln tokens
72     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4 = 5 * (10**6) * accuracy;
73     //122.5 mln tokens
74     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5 = 1225 * (10**5) * accuracy;
75     //265 mln tokens
76     uint public constant TOKEN_AMOUNT_ICO_STAGE2 = 1425 * (10**5) * accuracy;
77 
78     uint public constant BONUS_PRE_ICO = 40; //40%
79     uint public constant BONUS_ICO_STAGE1_PRE_SALE1 = 35; //35%
80     uint public constant BONUS_ICO_STAGE1_PRE_SALE2 = 30; //30%
81     uint public constant BONUS_ICO_STAGE1_PRE_SALE3 = 25; //25%
82     uint public constant BONUS_ICO_STAGE1_PRE_SALE4 = 20; //20%
83     uint public constant BONUS_ICO_STAGE1_PRE_SALE5 = 0; //0%
84     uint public constant BONUS_ICO_STAGE2 = 0; //No bonus
85 
86     //Token Price on Coin Offer
87     uint256 public constant price = 79 szabo; //0.000079 ETH
88 
89     address public constant ADVISORS_WALLET = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
90     address public constant RESERVE_WALLET = 0x731B47847352fA2cFf83D5251FD6a5266f90878d;
91     address public constant BOUNTY_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
92     address public constant R_N_D_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
93     address public constant STORAGE_WALLET = 0xE2A8F147fc808738Cab152b01C7245F386fD8d89;
94 
95     // Owner of this contract
96     address public administrator;
97 
98     // Balances for each account
99     mapping(address => uint256) balances;
100 
101     // Owner of account approves the transfer of an amount to another account
102     mapping(address => mapping (address => uint256)) allowed;
103 
104     //Mostly needed for internal use
105     uint256 internal totalCoinsAvailable;
106 
107     //All token stages. Total 6 stages
108     TokenStage[7] stages;
109 
110     //Index of current stage in stage array
111     uint currentStage;
112 
113     //Enables or disables debug mode. Debug mode is set only in constructor.
114     bool isDebug = false;
115 
116     event StageUpdated(string from, string to);
117 
118     // Functions with this modifier can only be executed by the owner
119     modifier onlyAdministrator() {
120         require(msg.sender == administrator);
121         _;
122     }
123 
124     modifier notAdministrator() {
125         require(msg.sender != administrator);
126         _;
127     }
128 
129     modifier onlyDuringICO() {
130         require(currentStage < stages.length);
131         _;
132     }
133 
134     modifier onlyAfterICO(){
135         require(currentStage >= stages.length);
136         _;
137     }
138 
139     modifier meetTheCap() {
140         require(msg.value >= price); // At least one token
141         _;
142     }
143 
144     modifier isFreezedReserve(address _address) {
145         require( ( _address == RESERVE_WALLET ) && now > (stages[ (stages.length - 1) ].endsAt + 182 days));
146         _;
147     }
148 
149     // Constructor
150     function UnilotToken()
151         public
152     {
153         administrator = msg.sender;
154         totalCoinsAvailable = _totalSupply;
155         //Was as fn parameter for debugging
156         isDebug = false;
157 
158         _setupStages();
159         _proceedStage();
160     }
161 
162     function prealocateCoins()
163         public
164         onlyAdministrator
165     {
166         totalCoinsAvailable -= balances[ADVISORS_WALLET] += ( ( _totalSupply * DST_ADVISERS ) / 100 );
167         totalCoinsAvailable -= balances[RESERVE_WALLET] += ( ( _totalSupply * DST_RESERVE ) / 100 );
168 
169         address[7] memory teamWallets = getTeamWallets();
170         uint teamSupply = ( ( _totalSupply * DST_TEAM ) / 100 );
171         uint memberAmount = teamSupply / teamWallets.length;
172 
173         for(uint i = 0; i < teamWallets.length; i++) {
174             if ( i == ( teamWallets.length - 1 ) ) {
175                 memberAmount = teamSupply;
176             }
177 
178             balances[teamWallets[i]] += memberAmount;
179             teamSupply -= memberAmount;
180             totalCoinsAvailable -= memberAmount;
181         }
182     }
183 
184     function getTeamWallets()
185         public
186         pure
187         returns (address[7] memory result)
188     {
189         result[0] = 0x40e3D8fFc46d73Ab5DF878C751D813a4cB7B388D;
190         result[1] = 0x5E065a80f6635B6a46323e3383057cE6051aAcA0;
191         result[2] = 0x0cF3585FbAB2a1299F8347a9B87CF7B4fcdCE599;
192         result[3] = 0x5fDd3BA5B6Ff349d31eB0a72A953E454C99494aC;
193         result[4] = 0xC9be9818eE1B2cCf2E4f669d24eB0798390Ffb54;
194         result[5] = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
195         result[6] = 0xd13289203889bD898d49e31a1500388441C03663;
196     }
197 
198     function _setupStages()
199         internal
200     {
201         //Presale stage
202         stages[0].name = 'Presale stage';
203         stages[0].numCoinsStart = totalCoinsAvailable;
204         stages[0].coinsAvailable = TOKEN_AMOUNT_PRE_ICO;
205         stages[0].bonus = BONUS_PRE_ICO;
206 
207         if (isDebug) {
208             stages[0].startsAt = now;
209             stages[0].endsAt = stages[0].startsAt + 30 seconds;
210         } else {
211             stages[0].startsAt = 1515610800; //10th of January 2018 at 19:00UTC
212             stages[0].endsAt = 1518894000; //17th of February 2018 at 19:00UTC
213         }
214 
215         //ICO Stage 1 pre-sale 1
216         stages[1].name = 'ICO Stage 1 pre-sale 1';
217         stages[1].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1;
218         stages[1].bonus = BONUS_ICO_STAGE1_PRE_SALE1;
219 
220         if (isDebug) {
221             stages[1].startsAt = stages[0].endsAt;
222             stages[1].endsAt = stages[1].startsAt + 30 seconds;
223         } else {
224             stages[1].startsAt = 1519326000; //22th of February 2018 at 19:00UTC
225             stages[1].endsAt = 1521745200; //22th of March 2018 at 19:00UTC
226         }
227 
228         //ICO Stage 1 pre-sale 2
229         stages[2].name = 'ICO Stage 1 pre-sale 2';
230         stages[2].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2;
231         stages[2].bonus = BONUS_ICO_STAGE1_PRE_SALE2;
232 
233         stages[2].startsAt = stages[1].startsAt;
234         stages[2].endsAt = stages[1].endsAt;
235 
236         //ICO Stage 1 pre-sale 3
237         stages[3].name = 'ICO Stage 1 pre-sale 3';
238         stages[3].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3;
239         stages[3].bonus = BONUS_ICO_STAGE1_PRE_SALE3;
240 
241         stages[3].startsAt = stages[1].startsAt;
242         stages[3].endsAt = stages[1].endsAt;
243 
244         //ICO Stage 1 pre-sale 4
245         stages[4].name = 'ICO Stage 1 pre-sale 4';
246         stages[4].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4;
247         stages[4].bonus = BONUS_ICO_STAGE1_PRE_SALE4;
248 
249         stages[4].startsAt = stages[1].startsAt;
250         stages[4].endsAt = stages[1].endsAt;
251 
252         //ICO Stage 1 pre-sale 5
253         stages[5].name = 'ICO Stage 1 pre-sale 5';
254         stages[5].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5;
255         stages[5].bonus = BONUS_ICO_STAGE1_PRE_SALE5;
256 
257         stages[5].startsAt = stages[1].startsAt;
258         stages[5].endsAt = stages[1].endsAt;
259 
260         //ICO Stage 2
261         stages[6].name = 'ICO Stage 2';
262         stages[6].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE2;
263         stages[6].bonus = BONUS_ICO_STAGE2;
264 
265         if (isDebug) {
266             stages[6].startsAt = stages[5].endsAt;
267             stages[6].endsAt = stages[6].startsAt + 30 seconds;
268         } else {
269             stages[6].startsAt = 1524250800; //20th of April 2018 at 19:00UTC
270             stages[6].endsAt = 1526842800; //20th of May 2018 at 19:00UTC
271         }
272     }
273 
274     function _proceedStage()
275         internal
276     {
277         while (true) {
278             if ( currentStage < stages.length
279             && (now >= stages[currentStage].endsAt || getAvailableCoinsForCurrentStage() == 0) ) {
280                 currentStage++;
281                 uint totalTokensForSale = TOKEN_AMOUNT_PRE_ICO
282                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1
283                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2
284                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3
285                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4
286                                     + TOKEN_AMOUNT_ICO_STAGE2;
287 
288                 if (currentStage >= stages.length) {
289                     //Burning all unsold tokens and proportionally other for deligation
290                     _totalSupply -= ( ( ( stages[(stages.length - 1)].coinsAvailable * DST_BOUNTY ) / 100 )
291                                     + ( ( stages[(stages.length - 1)].coinsAvailable * DST_R_N_B_PROGRAM ) / 100 ) );
292 
293                     balances[BOUNTY_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_BOUNTY)/100);
294                     balances[R_N_D_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_R_N_B_PROGRAM)/100);
295 
296                     totalCoinsAvailable = 0;
297                     break; //ICO ended
298                 }
299 
300                 stages[currentStage].numCoinsStart = totalCoinsAvailable;
301 
302                 if ( currentStage > 0 ) {
303                     //Move all left tokens to last stage
304                     stages[(stages.length - 1)].coinsAvailable += stages[ (currentStage - 1 ) ].coinsAvailable;
305                     StageUpdated(stages[currentStage - 1].name, stages[currentStage].name);
306                 }
307             } else {
308                 break;
309             }
310         }
311     }
312 
313     function getTotalCoinsAvailable()
314         public
315         view
316         returns(uint)
317     {
318         return totalCoinsAvailable;
319     }
320 
321     function getAvailableCoinsForCurrentStage()
322         public
323         view
324         returns(uint)
325     {
326         TokenStage memory stage = stages[currentStage];
327 
328         return stage.coinsAvailable;
329     }
330 
331     //------------- ERC20 methods -------------//
332     function totalSupply()
333         public
334         constant
335         returns (uint256)
336     {
337         return _totalSupply;
338     }
339 
340 
341     // What is the balance of a particular account?
342     function balanceOf(address _owner)
343         public
344         constant
345         returns (uint256 balance)
346     {
347         return balances[_owner];
348     }
349 
350 
351     // Transfer the balance from owner's account to another account
352     function transfer(address _to, uint256 _amount)
353         public
354         onlyAfterICO
355         isFreezedReserve(_to)
356         returns (bool success)
357     {
358         if (balances[msg.sender] >= _amount
359             && _amount > 0
360             && balances[_to] + _amount > balances[_to]) {
361             balances[msg.sender] -= _amount;
362             balances[_to] += _amount;
363             Transfer(msg.sender, _to, _amount);
364 
365             return true;
366         } else {
367             return false;
368         }
369     }
370 
371 
372     // Send _value amount of tokens from address _from to address _to
373     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
374     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
375     // fees in sub-currencies; the command should fail unless the _from account has
376     // deliberately authorized the sender of the message via some mechanism; we propose
377     // these standardized APIs for approval:
378     function transferFrom(
379         address _from,
380         address _to,
381         uint256 _amount
382     )
383         public
384         onlyAfterICO
385         isFreezedReserve(_from)
386         isFreezedReserve(_to)
387         returns (bool success)
388     {
389         if (balances[_from] >= _amount
390             && allowed[_from][msg.sender] >= _amount
391             && _amount > 0
392             && balances[_to] + _amount > balances[_to]) {
393             balances[_from] -= _amount;
394             allowed[_from][msg.sender] -= _amount;
395             balances[_to] += _amount;
396             Transfer(_from, _to, _amount);
397             return true;
398         } else {
399             return false;
400         }
401     }
402 
403 
404     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
405     // If this function is called again it overwrites the current allowance with _value.
406     function approve(address _spender, uint256 _amount)
407         public
408         onlyAfterICO
409         isFreezedReserve(_spender)
410         returns (bool success)
411     {
412         allowed[msg.sender][_spender] = _amount;
413         Approval(msg.sender, _spender, _amount);
414         return true;
415     }
416 
417 
418     function allowance(address _owner, address _spender)
419         public
420         constant
421         returns (uint256 remaining)
422     {
423         return allowed[_owner][_spender];
424     }
425     //------------- ERC20 Methods END -------------//
426 
427     //Returns bonus for certain level of reference
428     function calculateReferralBonus(uint amount, uint level)
429         public
430         pure
431         returns (uint bonus)
432     {
433         bonus = 0;
434 
435         if ( level == 1 ) {
436             bonus = ( ( amount * REFERRAL_BONUS_LEVEL1 ) / 100 );
437         } else if (level == 2) {
438             bonus = ( ( amount * REFERRAL_BONUS_LEVEL2 ) / 100 );
439         } else if (level == 3) {
440             bonus = ( ( amount * REFERRAL_BONUS_LEVEL3 ) / 100 );
441         } else if (level == 4) {
442             bonus = ( ( amount * REFERRAL_BONUS_LEVEL4 ) / 100 );
443         } else if (level == 5) {
444             bonus = ( ( amount * REFERRAL_BONUS_LEVEL5 ) / 100 );
445         }
446     }
447 
448     function calculateBonus(uint amountOfTokens)
449         public
450         view
451         returns (uint)
452     {
453         return ( ( stages[currentStage].bonus * amountOfTokens ) / 100 );
454     }
455 
456     event TokenPurchased(string stage, uint valueSubmitted, uint valueRefunded, uint tokensPurchased);
457 
458     function ()
459         public
460         payable
461         notAdministrator
462         onlyDuringICO
463         meetTheCap
464     {
465         _proceedStage();
466         require(currentStage < stages.length);
467         require(stages[currentStage].startsAt <= now && now < stages[currentStage].endsAt);
468         require(getAvailableCoinsForCurrentStage() > 0);
469 
470         uint requestedAmountOfTokens = ( ( msg.value * accuracy ) / price );
471         uint amountToBuy = requestedAmountOfTokens;
472         uint refund = 0;
473 
474         if ( amountToBuy > getAvailableCoinsForCurrentStage() ) {
475             amountToBuy = getAvailableCoinsForCurrentStage();
476             refund = ( ( (requestedAmountOfTokens - amountToBuy) / accuracy ) * price );
477 
478             // Returning ETH
479             msg.sender.transfer( refund );
480         }
481 
482         TokenPurchased(stages[currentStage].name, msg.value, refund, amountToBuy);
483         stages[currentStage].coinsAvailable -= amountToBuy;
484         stages[currentStage].balance += (msg.value - refund);
485 
486         uint amountDelivered = amountToBuy + calculateBonus(amountToBuy);
487 
488         balances[msg.sender] += amountDelivered;
489         totalCoinsAvailable -= amountDelivered;
490 
491         if ( getAvailableCoinsForCurrentStage() == 0 ) {
492             _proceedStage();
493         }
494 
495         STORAGE_WALLET.transfer(this.balance);
496     }
497 
498     //It doesn't really close the stage
499     //It just needed to push transaction to update stage and update block.now
500     function closeStage()
501         public
502         onlyAdministrator
503     {
504         _proceedStage();
505     }
506 }
507 
508 contract ERC20Contract is ERC20 {
509     //Token symbol
510     string public constant symbol = "UNIT";
511 
512     //Token name
513     string public constant name = "Unilot token";
514 
515     //It can be reeeealy small
516     uint8 public constant decimals = 18;
517 
518     // Balances for each account
519     mapping(address => uint96) public balances;
520 
521     // Owner of account approves the transfer of an amount to another account
522     mapping(address => mapping (address => uint96)) allowed;
523 
524     function totalSupply()
525         public
526         constant
527         returns (uint);
528 
529 
530     // What is the balance of a particular account?
531     function balanceOf(address _owner)
532         public
533         constant
534         returns (uint balance)
535     {
536         return uint(balances[_owner]);
537     }
538 
539 
540     // Transfer the balance from owner's account to another account
541     function transfer(address _to, uint _amount)
542         public
543         returns (bool success)
544     {
545         if (balances[msg.sender] >= _amount
546             && _amount > 0
547             && balances[_to] + _amount > balances[_to]) {
548             balances[msg.sender] -= uint96(_amount);
549             balances[_to] += uint96(_amount);
550             Transfer(msg.sender, _to, _amount);
551 
552             return true;
553         } else {
554             return false;
555         }
556     }
557 
558 
559     // Send _value amount of tokens from address _from to address _to
560     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
561     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
562     // fees in sub-currencies; the command should fail unless the _from account has
563     // deliberately authorized the sender of the message via some mechanism; we propose
564     // these standardized APIs for approval:
565     function transferFrom(
566         address _from,
567         address _to,
568         uint256 _amount
569     )
570         public
571         returns (bool success)
572     {
573         if (balances[_from] >= _amount
574             && allowed[_from][msg.sender] >= _amount
575             && _amount > 0
576             && balances[_to] + _amount > balances[_to]) {
577             balances[_from] -= uint96(_amount);
578             allowed[_from][msg.sender] -= uint96(_amount);
579             balances[_to] += uint96(_amount);
580             Transfer(_from, _to, _amount);
581             return true;
582         } else {
583             return false;
584         }
585     }
586 
587 
588     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
589     // If this function is called again it overwrites the current allowance with _value.
590     function approve(address _spender, uint _amount)
591         public
592         returns (bool success)
593     {
594         allowed[msg.sender][_spender] = uint96(_amount);
595         Approval(msg.sender, _spender, _amount);
596         return true;
597     }
598 
599 
600     function allowance(address _owner, address _spender)
601         public
602         constant
603         returns (uint remaining)
604     {
605         return allowed[_owner][_spender];
606     }
607 }
608 
609 interface TokenStagesManager {
610     function isDebug() public constant returns(bool);
611     function setToken(address tokenAddress) public;
612     function getPool() public constant returns (uint96);
613     function getBonus() public constant returns (uint8);
614     function isFreezeTimeout() public constant returns (bool);
615     function isTimeout() public constant returns (bool);
616     function isICO() public view returns(bool);
617     function isCanList() public view returns (bool);
618     function calculateBonus(uint96 amount) public view returns (uint88);
619     function delegateFromPool(uint96 amount) public;
620     function delegateFromBonus(uint88 amount) public;
621     function delegateFromReferral(uint88 amount) public;
622 
623     function getBonusPool() public constant returns(uint88);
624     function getReferralPool() public constant returns(uint88);
625 }
626 
627 interface Whitelist {
628     function add(address _wlAddress) public;
629     function addBulk(address[] _wlAddresses) public;
630     function remove(address _wlAddresses) public;
631     function removeBulk(address[] _wlAddresses) public;
632     function getAll() public constant returns(address[]);
633     function isInList(address _checkAddress) public constant returns(bool);
634 }
635 
636 contract Administrated {
637     address public administrator;
638 
639     modifier onlyAdministrator() {
640         require(administrator == tx.origin);
641         _;
642     }
643 
644     modifier notAdministrator() {
645         require(administrator != tx.origin);
646         _;
647     }
648 
649     function setAdministrator(address _administrator)
650         internal
651     {
652         administrator = _administrator;
653     }
654 }
655 
656 contract UNITv2 is ERC20Contract,Administrated {
657     //Token symbol
658     string public constant symbol = "UNIT";
659     //Token name
660     string public constant name = "Unilot token";
661     //It can be reeeealy small
662     uint8 public constant decimals = 18;
663 
664     //Total supply 500mln in the start
665     uint96 public _totalSupply = uint96(500000000 * (10**18));
666 
667     UnilotToken public sourceToken;
668 
669     Whitelist public transferWhiteList;
670 
671     Whitelist public paymentGateways;
672 
673     TokenStagesManager public stagesManager;
674 
675     bool public unlocked = false;
676 
677     bool public burned = false;
678 
679     //tokenImport[tokenHolder][sourceToken] = true/false;
680     mapping ( address => mapping ( address => bool ) ) public tokenImport;
681 
682     event TokensImported(address indexed tokenHolder, uint96 amount, address indexed source);
683     event TokensDelegated(address indexed tokenHolder, uint96 amount, address indexed source);
684     event Unlocked();
685     event Burned(uint96 amount);
686 
687     modifier isLocked() {
688         require(unlocked == false);
689         _;
690     }
691 
692     modifier isNotBurned() {
693         require(burned == false);
694         _;
695     }
696 
697     modifier isTransferAllowed(address _from, address _to) {
698         if ( sourceToken.RESERVE_WALLET() == _from ) {
699             require( stagesManager.isFreezeTimeout() );
700         }
701         require(unlocked
702                 || ( stagesManager != address(0) && stagesManager.isCanList() )
703                 || ( transferWhiteList != address(0) && ( transferWhiteList.isInList(_from) || transferWhiteList.isInList(_to) ) )
704         );
705         _;
706     }
707 
708     function UNITv2(address _sourceToken)
709         public
710     {
711         setAdministrator(tx.origin);
712         sourceToken = UnilotToken(_sourceToken);
713 
714         /*Transactions:
715         0x99c28675adbd0d0cb7bd783ae197492078d4063f40c11139dd07c015a543ffcc
716         0x86038d11ee8da46703309d2fb45d150f1dc4e2bba6d0a8fee158016111104ff1
717         0x0340a8a2fb89513c0086a345973470b7bc33424e818ca6a32dcf9ad66bf9d75c
718         */
719         balances[0xd13289203889bD898d49e31a1500388441C03663] += 1400000000000000000 * 3;
720         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xd13289203889bD898d49e31a1500388441C03663);
721 
722         //Tx: 0xec9b7b4c0f1435282e2e98a66efbd7610de7eacce3b2448cd5f503d70a64a895
723         balances[0xE33305B2EFbcB302DA513C38671D01646651a868] += 1400000000000000000;
724         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0xE33305B2EFbcB302DA513C38671D01646651a868);
725 
726         //Assigning bounty
727         balances[0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb] += uint96(
728             ( uint(_totalSupply) * uint8( sourceToken.DST_BOUNTY() ) ) / 100
729         );
730 
731         //Don't import bounty and R&B tokens
732         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
733         markAsImported(sourceToken, 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb);
734 
735         markAsImported(0xdBF98dF5DAd9077f457e1dcf85Aa9420BcA8B761, 0x91D740D87A8AeED1fc3EA3C346843173c529D63e);
736     }
737 
738     function setTransferWhitelist(address whiteListAddress)
739         public
740         onlyAdministrator
741         isNotBurned
742     {
743         transferWhiteList = Whitelist(whiteListAddress);
744     }
745 
746     function disableTransferWhitelist()
747         public
748         onlyAdministrator
749         isNotBurned
750     {
751         transferWhiteList = Whitelist(address(0));
752     }
753 
754     function setStagesManager(address stagesManagerContract)
755         public
756         onlyAdministrator
757         isNotBurned
758     {
759         stagesManager = TokenStagesManager(stagesManagerContract);
760     }
761 
762     function setPaymentGatewayList(address paymentGatewayListContract)
763         public
764         onlyAdministrator
765         isNotBurned
766     {
767         paymentGateways = Whitelist(paymentGatewayListContract);
768     }
769 
770     //START Import related methods
771     function isImported(address _sourceToken, address _tokenHolder)
772         internal
773         constant
774         returns (bool)
775     {
776         return tokenImport[_tokenHolder][_sourceToken];
777     }
778 
779     function markAsImported(address _sourceToken, address _tokenHolder)
780         internal
781     {
782         tokenImport[_tokenHolder][_sourceToken] = true;
783     }
784 
785     function importFromSource(ERC20 _sourceToken, address _tokenHolder)
786         internal
787     {
788         if ( !isImported(_sourceToken, _tokenHolder) ) {
789             uint96 oldBalance = uint96(_sourceToken.balanceOf(_tokenHolder));
790             balances[_tokenHolder] += oldBalance;
791             markAsImported(_sourceToken, _tokenHolder);
792 
793             TokensImported(_tokenHolder, oldBalance, _sourceToken);
794         }
795     }
796 
797     //Imports from source token
798     function importTokensFromSourceToken(address _tokenHolder)
799         internal
800     {
801         importFromSource(ERC20(sourceToken), _tokenHolder);
802     }
803 
804     function importFromExternal(ERC20 _sourceToken, address _tokenHolder)
805         public
806         onlyAdministrator
807         isNotBurned
808     {
809         return importFromSource(_sourceToken, _tokenHolder);
810     }
811 
812     //Imports from provided token
813     function importTokensSourceBulk(ERC20 _sourceToken, address[] _tokenHolders)
814         public
815         onlyAdministrator
816         isNotBurned
817     {
818         require(_tokenHolders.length <= 256);
819 
820         for (uint8 i = 0; i < _tokenHolders.length; i++) {
821             importFromSource(_sourceToken, _tokenHolders[i]);
822         }
823     }
824     //END Import related methods
825 
826     //START ERC20
827     function totalSupply()
828         public
829         constant
830         returns (uint)
831     {
832         return uint(_totalSupply);
833     }
834 
835     function balanceOf(address _owner)
836         public
837         constant
838         returns (uint balance)
839     {
840         balance = super.balanceOf(_owner);
841 
842         if (!isImported(sourceToken, _owner)) {
843             balance += sourceToken.balanceOf(_owner);
844         }
845     }
846 
847     function transfer(address _to, uint _amount)
848         public
849         isTransferAllowed(msg.sender, _to)
850         returns (bool success)
851     {
852         return super.transfer(_to, _amount);
853     }
854 
855     function transferFrom(
856         address _from,
857         address _to,
858         uint256 _amount
859     )
860         public
861         isTransferAllowed(_from, _to)
862         returns (bool success)
863     {
864         return super.transferFrom(_from, _to, _amount);
865     }
866 
867     function approve(address _spender, uint _amount)
868         public
869         isTransferAllowed(msg.sender, _spender)
870         returns (bool success)
871     {
872         return super.approve(_spender, _amount);
873     }
874     //END ERC20
875 
876     function delegateTokens(address tokenHolder, uint96 amount)
877         public
878         isNotBurned
879     {
880         require(paymentGateways.isInList(msg.sender));
881         require(stagesManager.isICO());
882         require(stagesManager.getPool() >= amount);
883 
884         uint88 bonus = stagesManager.calculateBonus(amount);
885         stagesManager.delegateFromPool(amount);
886 
887         balances[tokenHolder] += amount + uint96(bonus);
888 
889         TokensDelegated(tokenHolder, amount, msg.sender);
890     }
891 
892     function delegateBonusTokens(address tokenHolder, uint88 amount)
893         public
894         isNotBurned
895     {
896         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
897         require(stagesManager.getBonusPool() >= amount);
898 
899         stagesManager.delegateFromBonus(amount);
900 
901         balances[tokenHolder] += amount;
902 
903         TokensDelegated(tokenHolder, uint96(amount), msg.sender);
904     }
905 
906     function delegateReferalTokens(address tokenHolder, uint88 amount)
907         public
908         isNotBurned
909     {
910         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
911         require(stagesManager.getReferralPool() >= amount);
912 
913         stagesManager.delegateFromReferral(amount);
914 
915         balances[tokenHolder] += amount;
916 
917         TokensDelegated(tokenHolder, amount, msg.sender);
918     }
919 
920     function delegateReferralTokensBulk(address[] tokenHolders, uint88[] amounts)
921         public
922         isNotBurned
923     {
924         require(paymentGateways.isInList(msg.sender) || tx.origin == administrator);
925         require(tokenHolders.length <= 256);
926         require(tokenHolders.length == amounts.length);
927 
928         for ( uint8 i = 0; i < tokenHolders.length; i++ ) {
929             delegateReferalTokens(tokenHolders[i], amounts[i]);
930         }
931     }
932 
933     function unlock()
934         public
935         isLocked
936         onlyAdministrator
937     {
938         unlocked = true;
939         Unlocked();
940     }
941 
942     function burn()
943         public
944         onlyAdministrator
945     {
946         require(!stagesManager.isICO());
947 
948         uint96 burnAmount = stagesManager.getPool()
949                         + stagesManager.getBonusPool()
950                         + stagesManager.getReferralPool();
951 
952         _totalSupply -= burnAmount;
953         burned = true;
954         Burned(burnAmount);
955     }
956 }
957 
958 contract UNITSimplePaymentGateway is Administrated {
959     UNITv2 public token;
960 
961     bool public locked = false;
962 
963     uint48 public constant PRICE = 79 szabo;
964 
965     address public storageAddress = 0x1b5DE6153c86F92a63A680896e9F088943c0Ead8;
966 
967     event Payment(address indexed payer, uint amount, uint refund, uint96 numTokens);
968 
969     function UNITSimplePaymentGateway(address _token)
970         public
971     {
972         token = UNITv2(_token);
973         setAdministrator(tx.origin);
974     }
975 
976     function setToken(address _token)
977         public
978         onlyAdministrator
979     {
980         token = UNITv2(_token);
981     }
982 
983     function ()
984         public
985         payable
986     {
987         require(locked == false);
988 
989         TokenStagesManager stagesManager = token.stagesManager();
990 
991         uint maxAmount = uint( ( uint(stagesManager.getPool()) * PRICE ) / (10**18) );
992         uint refund = 0;
993 
994         if ( maxAmount < msg.value ) {
995             refund = msg.value - maxAmount;
996         }
997 
998         uint96 numTokens = uint96( ( ( msg.value - refund ) * (10**18) ) / PRICE );
999 
1000         Payment(msg.sender, msg.value, refund, numTokens);
1001 
1002         token.delegateTokens(msg.sender, numTokens);
1003 
1004         msg.sender.transfer(refund);
1005         storageAddress.transfer(this.balance);
1006     }
1007 
1008     function lock()
1009         public
1010         onlyAdministrator
1011     {
1012         locked = true;
1013     }
1014 
1015     function unlock()
1016         public
1017         onlyAdministrator
1018     {
1019         locked = false;
1020     }
1021 }