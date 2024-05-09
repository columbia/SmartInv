1 pragma solidity ^0.4.18;
2 
3 
4 //Interfaces
5 
6 // https://github.com/ethereum/EIPs/issues/20
7 interface ERC20 {
8     event Transfer(address indexed _from, address indexed _to, uint _value);
9     event Approval(address indexed _owner, address indexed _spender, uint _value);
10 
11     function totalSupply() public constant returns (uint);
12     function balanceOf(address _owner) public constant returns (uint balance);
13     function transfer(address _to, uint _value) public returns (bool success);
14     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
15     function approve(address _spender, uint _value) public returns (bool success);
16     function allowance(address _owner, address _spender) public constant returns (uint remaining);
17 }
18 
19 contract UnilotToken is ERC20 {
20     struct TokenStage {
21         string name;
22         uint numCoinsStart;
23         uint coinsAvailable;
24         uint bonus;
25         uint startsAt;
26         uint endsAt;
27         uint balance; //Amount of ether sent during this stage
28     }
29 
30     //Token symbol
31     string public constant symbol = "UNIT";
32     //Token name
33     string public constant name = "Unilot token";
34     //It can be reeeealy small
35     uint8 public constant decimals = 18;
36 
37     //This one duplicates the above but will have to use it because of
38     //solidity bug with power operation
39     uint public constant accuracy = 1000000000000000000;
40 
41     //500 mln tokens
42     uint256 internal _totalSupply = 500 * (10**6) * accuracy;
43 
44     //Public investor can buy tokens for 30 ether at maximum
45     uint256 public constant singleInvestorCap = 30 ether; //30 ether
46 
47     //Distribution units
48     uint public constant DST_ICO     = 62; //62%
49     uint public constant DST_RESERVE = 10; //10%
50     uint public constant DST_BOUNTY  = 3;  //3%
51     //Referral and Bonus Program
52     uint public constant DST_R_N_B_PROGRAM = 10; //10%
53     uint public constant DST_ADVISERS      = 5;  //5%
54     uint public constant DST_TEAM          = 10; //10%
55 
56     //Referral Bonuses
57     uint public constant REFERRAL_BONUS_LEVEL1 = 5; //5%
58     uint public constant REFERRAL_BONUS_LEVEL2 = 4; //4%
59     uint public constant REFERRAL_BONUS_LEVEL3 = 3; //3%
60     uint public constant REFERRAL_BONUS_LEVEL4 = 2; //2%
61     uint public constant REFERRAL_BONUS_LEVEL5 = 1; //1%
62 
63     //Token amount
64     //25 mln tokens
65     uint public constant TOKEN_AMOUNT_PRE_ICO = 25 * (10**6) * accuracy;
66     //5 mln tokens
67     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1 = 5 * (10**6) * accuracy;
68     //5 mln tokens
69     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2 = 5 * (10**6) * accuracy;
70     //5 mln tokens
71     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3 = 5 * (10**6) * accuracy;
72     //5 mln tokens
73     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4 = 5 * (10**6) * accuracy;
74     //122.5 mln tokens
75     uint public constant TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5 = 1225 * (10**5) * accuracy;
76     //265 mln tokens
77     uint public constant TOKEN_AMOUNT_ICO_STAGE2 = 1425 * (10**5) * accuracy;
78 
79     uint public constant BONUS_PRE_ICO = 40; //40%
80     uint public constant BONUS_ICO_STAGE1_PRE_SALE1 = 35; //35%
81     uint public constant BONUS_ICO_STAGE1_PRE_SALE2 = 30; //30%
82     uint public constant BONUS_ICO_STAGE1_PRE_SALE3 = 25; //25%
83     uint public constant BONUS_ICO_STAGE1_PRE_SALE4 = 20; //20%
84     uint public constant BONUS_ICO_STAGE1_PRE_SALE5 = 0; //0%
85     uint public constant BONUS_ICO_STAGE2 = 0; //No bonus
86 
87     //Token Price on Coin Offer
88     uint256 public constant price = 79 szabo; //0.000079 ETH
89 
90     address public constant ADVISORS_WALLET = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
91     address public constant RESERVE_WALLET = 0x731B47847352fA2cFf83D5251FD6a5266f90878d;
92     address public constant BOUNTY_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
93     address public constant R_N_D_WALLET = 0x794EF9c680bDD0bEf48Bef46bA68471e449D67Fb;
94     address public constant STORAGE_WALLET = 0xE2A8F147fc808738Cab152b01C7245F386fD8d89;
95 
96     // Owner of this contract
97     address public administrator;
98 
99     // Balances for each account
100     mapping(address => uint256) balances;
101 
102     // Owner of account approves the transfer of an amount to another account
103     mapping(address => mapping (address => uint256)) allowed;
104 
105     //Mostly needed for internal use
106     uint256 internal totalCoinsAvailable;
107 
108     //All token stages. Total 6 stages
109     TokenStage[7] stages;
110 
111     //Index of current stage in stage array
112     uint currentStage;
113 
114     //Enables or disables debug mode. Debug mode is set only in constructor.
115     bool isDebug = false;
116 
117     event StageUpdated(string from, string to);
118 
119     // Functions with this modifier can only be executed by the owner
120     modifier onlyAdministrator() {
121         require(msg.sender == administrator);
122         _;
123     }
124 
125     modifier notAdministrator() {
126         require(msg.sender != administrator);
127         _;
128     }
129 
130     modifier onlyDuringICO() {
131         require(currentStage < stages.length);
132         _;
133     }
134 
135     modifier onlyAfterICO(){
136         require(currentStage >= stages.length);
137         _;
138     }
139 
140     modifier meetTheCap() {
141         require(msg.value >= price); // At least one token
142         _;
143     }
144 
145     modifier isFreezedReserve(address _address) {
146         require( ( _address == RESERVE_WALLET ) && now > (stages[ (stages.length - 1) ].endsAt + 182 days));
147         _;
148     }
149 
150     // Constructor
151     function UnilotToken()
152         public
153     {
154         administrator = msg.sender;
155         totalCoinsAvailable = _totalSupply;
156         //Was as fn parameter for debugging
157         isDebug = false;
158 
159         _setupStages();
160         _proceedStage();
161     }
162 
163     function prealocateCoins()
164         public
165         onlyAdministrator
166     {
167         totalCoinsAvailable -= balances[ADVISORS_WALLET] += ( ( _totalSupply * DST_ADVISERS ) / 100 );
168         totalCoinsAvailable -= balances[RESERVE_WALLET] += ( ( _totalSupply * DST_RESERVE ) / 100 );
169 
170         address[7] memory teamWallets = getTeamWallets();
171         uint teamSupply = ( ( _totalSupply * DST_TEAM ) / 100 );
172         uint memberAmount = teamSupply / teamWallets.length;
173 
174         for(uint i = 0; i < teamWallets.length; i++) {
175             if ( i == ( teamWallets.length - 1 ) ) {
176                 memberAmount = teamSupply;
177             }
178 
179             balances[teamWallets[i]] += memberAmount;
180             teamSupply -= memberAmount;
181             totalCoinsAvailable -= memberAmount;
182         }
183     }
184 
185     function getTeamWallets()
186         public
187         pure
188         returns (address[7] memory result)
189     {
190         result[0] = 0x40e3D8fFc46d73Ab5DF878C751D813a4cB7B388D;
191         result[1] = 0x5E065a80f6635B6a46323e3383057cE6051aAcA0;
192         result[2] = 0x0cF3585FbAB2a1299F8347a9B87CF7B4fcdCE599;
193         result[3] = 0x5fDd3BA5B6Ff349d31eB0a72A953E454C99494aC;
194         result[4] = 0xC9be9818eE1B2cCf2E4f669d24eB0798390Ffb54;
195         result[5] = 0x77660795BD361Cd43c3627eAdad44dDc2026aD17;
196         result[6] = 0xd13289203889bD898d49e31a1500388441C03663;
197     }
198 
199     function _setupStages()
200         internal
201     {
202         //Presale stage
203         stages[0].name = 'Presale stage';
204         stages[0].numCoinsStart = totalCoinsAvailable;
205         stages[0].coinsAvailable = TOKEN_AMOUNT_PRE_ICO;
206         stages[0].bonus = BONUS_PRE_ICO;
207 
208         if (isDebug) {
209             stages[0].startsAt = now;
210             stages[0].endsAt = stages[0].startsAt + 30 seconds;
211         } else {
212             stages[0].startsAt = 1515610800; //10th of January 2018 at 19:00UTC
213             stages[0].endsAt = 1518894000; //17th of February 2018 at 19:00UTC
214         }
215 
216         //ICO Stage 1 pre-sale 1
217         stages[1].name = 'ICO Stage 1 pre-sale 1';
218         stages[1].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1;
219         stages[1].bonus = BONUS_ICO_STAGE1_PRE_SALE1;
220 
221         if (isDebug) {
222             stages[1].startsAt = stages[0].endsAt;
223             stages[1].endsAt = stages[1].startsAt + 30 seconds;
224         } else {
225             stages[1].startsAt = 1519326000; //22th of February 2018 at 19:00UTC
226             stages[1].endsAt = 1521745200; //22th of March 2018 at 19:00UTC
227         }
228 
229         //ICO Stage 1 pre-sale 2
230         stages[2].name = 'ICO Stage 1 pre-sale 2';
231         stages[2].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2;
232         stages[2].bonus = BONUS_ICO_STAGE1_PRE_SALE2;
233 
234         stages[2].startsAt = stages[1].startsAt;
235         stages[2].endsAt = stages[1].endsAt;
236 
237         //ICO Stage 1 pre-sale 3
238         stages[3].name = 'ICO Stage 1 pre-sale 3';
239         stages[3].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3;
240         stages[3].bonus = BONUS_ICO_STAGE1_PRE_SALE3;
241 
242         stages[3].startsAt = stages[1].startsAt;
243         stages[3].endsAt = stages[1].endsAt;
244 
245         //ICO Stage 1 pre-sale 4
246         stages[4].name = 'ICO Stage 1 pre-sale 4';
247         stages[4].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4;
248         stages[4].bonus = BONUS_ICO_STAGE1_PRE_SALE4;
249 
250         stages[4].startsAt = stages[1].startsAt;
251         stages[4].endsAt = stages[1].endsAt;
252 
253         //ICO Stage 1 pre-sale 5
254         stages[5].name = 'ICO Stage 1 pre-sale 5';
255         stages[5].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE5;
256         stages[5].bonus = BONUS_ICO_STAGE1_PRE_SALE5;
257 
258         stages[5].startsAt = stages[1].startsAt;
259         stages[5].endsAt = stages[1].endsAt;
260 
261         //ICO Stage 2
262         stages[6].name = 'ICO Stage 2';
263         stages[6].coinsAvailable = TOKEN_AMOUNT_ICO_STAGE2;
264         stages[6].bonus = BONUS_ICO_STAGE2;
265 
266         if (isDebug) {
267             stages[6].startsAt = stages[5].endsAt;
268             stages[6].endsAt = stages[6].startsAt + 30 seconds;
269         } else {
270             stages[6].startsAt = 1524250800; //20th of April 2018 at 19:00UTC
271             stages[6].endsAt = 1526842800; //20th of May 2018 at 19:00UTC
272         }
273     }
274 
275     function _proceedStage()
276         internal
277     {
278         while (true) {
279             if ( currentStage < stages.length
280             && (now >= stages[currentStage].endsAt || getAvailableCoinsForCurrentStage() == 0) ) {
281                 currentStage++;
282                 uint totalTokensForSale = TOKEN_AMOUNT_PRE_ICO
283                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE1
284                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE2
285                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE3
286                                     + TOKEN_AMOUNT_ICO_STAGE1_PRE_SALE4
287                                     + TOKEN_AMOUNT_ICO_STAGE2;
288 
289                 if (currentStage >= stages.length) {
290                     //Burning all unsold tokens and proportionally other for deligation
291                     _totalSupply -= ( ( ( stages[(stages.length - 1)].coinsAvailable * DST_BOUNTY ) / 100 )
292                                     + ( ( stages[(stages.length - 1)].coinsAvailable * DST_R_N_B_PROGRAM ) / 100 ) );
293 
294                     balances[BOUNTY_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_BOUNTY)/100);
295                     balances[R_N_D_WALLET] = (((totalTokensForSale - stages[(stages.length - 1)].coinsAvailable) * DST_R_N_B_PROGRAM)/100);
296 
297                     totalCoinsAvailable = 0;
298                     break; //ICO ended
299                 }
300 
301                 stages[currentStage].numCoinsStart = totalCoinsAvailable;
302 
303                 if ( currentStage > 0 ) {
304                     //Move all left tokens to last stage
305                     stages[(stages.length - 1)].coinsAvailable += stages[ (currentStage - 1 ) ].coinsAvailable;
306                     StageUpdated(stages[currentStage - 1].name, stages[currentStage].name);
307                 }
308             } else {
309                 break;
310             }
311         }
312     }
313 
314     function getTotalCoinsAvailable()
315         public
316         view
317         returns(uint)
318     {
319         return totalCoinsAvailable;
320     }
321 
322     function getAvailableCoinsForCurrentStage()
323         public
324         view
325         returns(uint)
326     {
327         TokenStage memory stage = stages[currentStage];
328 
329         return stage.coinsAvailable;
330     }
331 
332     //------------- ERC20 methods -------------//
333     function totalSupply()
334         public
335         constant
336         returns (uint256)
337     {
338         return _totalSupply;
339     }
340 
341 
342     // What is the balance of a particular account?
343     function balanceOf(address _owner)
344         public
345         constant
346         returns (uint256 balance)
347     {
348         return balances[_owner];
349     }
350 
351 
352     // Transfer the balance from owner's account to another account
353     function transfer(address _to, uint256 _amount)
354         public
355         onlyAfterICO
356         isFreezedReserve(_to)
357         returns (bool success)
358     {
359         if (balances[msg.sender] >= _amount
360             && _amount > 0
361             && balances[_to] + _amount > balances[_to]) {
362             balances[msg.sender] -= _amount;
363             balances[_to] += _amount;
364             Transfer(msg.sender, _to, _amount);
365 
366             return true;
367         } else {
368             return false;
369         }
370     }
371 
372 
373     // Send _value amount of tokens from address _from to address _to
374     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
375     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
376     // fees in sub-currencies; the command should fail unless the _from account has
377     // deliberately authorized the sender of the message via some mechanism; we propose
378     // these standardized APIs for approval:
379     function transferFrom(
380         address _from,
381         address _to,
382         uint256 _amount
383     )
384         public
385         onlyAfterICO
386         isFreezedReserve(_from)
387         isFreezedReserve(_to)
388         returns (bool success)
389     {
390         if (balances[_from] >= _amount
391             && allowed[_from][msg.sender] >= _amount
392             && _amount > 0
393             && balances[_to] + _amount > balances[_to]) {
394             balances[_from] -= _amount;
395             allowed[_from][msg.sender] -= _amount;
396             balances[_to] += _amount;
397             Transfer(_from, _to, _amount);
398             return true;
399         } else {
400             return false;
401         }
402     }
403 
404 
405     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
406     // If this function is called again it overwrites the current allowance with _value.
407     function approve(address _spender, uint256 _amount)
408         public
409         onlyAfterICO
410         isFreezedReserve(_spender)
411         returns (bool success)
412     {
413         allowed[msg.sender][_spender] = _amount;
414         Approval(msg.sender, _spender, _amount);
415         return true;
416     }
417 
418 
419     function allowance(address _owner, address _spender)
420         public
421         constant
422         returns (uint256 remaining)
423     {
424         return allowed[_owner][_spender];
425     }
426     //------------- ERC20 Methods END -------------//
427 
428     //Returns bonus for certain level of reference
429     function calculateReferralBonus(uint amount, uint level)
430         public
431         pure
432         returns (uint bonus)
433     {
434         bonus = 0;
435 
436         if ( level == 1 ) {
437             bonus = ( ( amount * REFERRAL_BONUS_LEVEL1 ) / 100 );
438         } else if (level == 2) {
439             bonus = ( ( amount * REFERRAL_BONUS_LEVEL2 ) / 100 );
440         } else if (level == 3) {
441             bonus = ( ( amount * REFERRAL_BONUS_LEVEL3 ) / 100 );
442         } else if (level == 4) {
443             bonus = ( ( amount * REFERRAL_BONUS_LEVEL4 ) / 100 );
444         } else if (level == 5) {
445             bonus = ( ( amount * REFERRAL_BONUS_LEVEL5 ) / 100 );
446         }
447     }
448 
449     function calculateBonus(uint amountOfTokens)
450         public
451         view
452         returns (uint)
453     {
454         return ( ( stages[currentStage].bonus * amountOfTokens ) / 100 );
455     }
456 
457     event TokenPurchased(string stage, uint valueSubmitted, uint valueRefunded, uint tokensPurchased);
458 
459     function ()
460         public
461         payable
462         notAdministrator
463         onlyDuringICO
464         meetTheCap
465     {
466         _proceedStage();
467         require(currentStage < stages.length);
468         require(stages[currentStage].startsAt <= now && now < stages[currentStage].endsAt);
469         require(getAvailableCoinsForCurrentStage() > 0);
470 
471         uint requestedAmountOfTokens = ( ( msg.value * accuracy ) / price );
472         uint amountToBuy = requestedAmountOfTokens;
473         uint refund = 0;
474 
475         if ( amountToBuy > getAvailableCoinsForCurrentStage() ) {
476             amountToBuy = getAvailableCoinsForCurrentStage();
477             refund = ( ( (requestedAmountOfTokens - amountToBuy) / accuracy ) * price );
478 
479             // Returning ETH
480             msg.sender.transfer( refund );
481         }
482 
483         TokenPurchased(stages[currentStage].name, msg.value, refund, amountToBuy);
484         stages[currentStage].coinsAvailable -= amountToBuy;
485         stages[currentStage].balance += (msg.value - refund);
486 
487         uint amountDelivered = amountToBuy + calculateBonus(amountToBuy);
488 
489         balances[msg.sender] += amountDelivered;
490         totalCoinsAvailable -= amountDelivered;
491 
492         if ( getAvailableCoinsForCurrentStage() == 0 ) {
493             _proceedStage();
494         }
495 
496         STORAGE_WALLET.transfer(this.balance);
497     }
498 
499     //It doesn't really close the stage
500     //It just needed to push transaction to update stage and update block.now
501     function closeStage()
502         public
503         onlyAdministrator
504     {
505         _proceedStage();
506     }
507 }
508 
509 contract ERC20Contract is ERC20 {
510     //Token symbol
511     string public constant symbol = "UNIT";
512 
513     //Token name
514     string public constant name = "Unilot token";
515 
516     //It can be reeeealy small
517     uint8 public constant decimals = 18;
518 
519     // Balances for each account
520     mapping(address => uint96) balances;
521 
522     // Owner of account approves the transfer of an amount to another account
523     mapping(address => mapping (address => uint96)) allowed;
524 
525     function totalSupply()
526         public
527         constant
528         returns (uint);
529 
530 
531     // What is the balance of a particular account?
532     function balanceOf(address _owner)
533         public
534         constant
535         returns (uint balance)
536     {
537         return balances[_owner];
538     }
539 
540 
541     // Transfer the balance from owner's account to another account
542     function transfer(address _to, uint _amount)
543         public
544         returns (bool success)
545     {
546         if (balances[msg.sender] >= _amount
547             && _amount > 0
548             && balances[_to] + _amount > balances[_to]) {
549             balances[msg.sender] -= uint96(_amount);
550             balances[_to] += uint96(_amount);
551             Transfer(msg.sender, _to, _amount);
552 
553             return true;
554         } else {
555             return false;
556         }
557     }
558 
559 
560     // Send _value amount of tokens from address _from to address _to
561     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
562     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
563     // fees in sub-currencies; the command should fail unless the _from account has
564     // deliberately authorized the sender of the message via some mechanism; we propose
565     // these standardized APIs for approval:
566     function transferFrom(
567         address _from,
568         address _to,
569         uint256 _amount
570     )
571         public
572         returns (bool success)
573     {
574         if (balances[_from] >= _amount
575             && allowed[_from][msg.sender] >= _amount
576             && _amount > 0
577             && balances[_to] + _amount > balances[_to]) {
578             balances[_from] -= uint96(_amount);
579             allowed[_from][msg.sender] -= uint96(_amount);
580             balances[_to] += uint96(_amount);
581             Transfer(_from, _to, _amount);
582             return true;
583         } else {
584             return false;
585         }
586     }
587 
588 
589     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
590     // If this function is called again it overwrites the current allowance with _value.
591     function approve(address _spender, uint _amount)
592         public
593         returns (bool success)
594     {
595         allowed[msg.sender][_spender] = uint96(_amount);
596         Approval(msg.sender, _spender, _amount);
597         return true;
598     }
599 
600 
601     function allowance(address _owner, address _spender)
602         public
603         constant
604         returns (uint remaining)
605     {
606         return allowed[_owner][_spender];
607     }
608 }
609 
610 contract ExternalCurrencyPrice {
611     struct CurrencyValue {
612         uint64 value;
613         uint8 decimals;
614     }
615 
616     struct Transaction {
617         string currency;
618         uint64 value;
619         string transactionId;
620         uint64 price;
621         uint8  decimals;
622     }
623 
624     struct RefundTransaction {
625         uint sourceTransaction;
626         uint88 refundAmount;
627     }
628 
629     mapping(string => CurrencyValue) prices;
630 
631     Transaction[] public transactions;
632     RefundTransaction[] public refundTransactions;
633 
634     address owner;
635 
636     event NewTransaction(string currency, uint64 value, string transactionId,
637                                                             uint64 price, uint8 decimals);
638     event NewRefundTransaction(uint sourceTransaction, uint88 refundAmount);
639     event PriceSet(string currency, uint64 value, uint8 decimals);
640 
641     modifier onlyAdministrator() {
642         require(tx.origin == owner);
643         _;
644     }
645 
646     function ExternalCurrencyPrice()
647         public
648     {
649         owner = tx.origin;
650     }
651 
652     //Example: 0.00007115 BTC will be setPrice("BTC", 7115, 8)
653     function setPrice(string currency, uint64 value, uint8 decimals)
654         public
655         onlyAdministrator
656     {
657         prices[currency].value = value;
658         prices[currency].decimals = decimals;
659         PriceSet(currency, value, decimals);
660     }
661 
662     function getPrice(string currency)
663         public
664         view
665         returns(uint64 value, uint8 decimals)
666     {
667         value = prices[currency].value;
668         decimals = prices[currency].decimals;
669     }
670 
671     //Value is returned with accuracy of 18 decimals (same as token)
672     //Example: to calculate value of 1 BTC call
673     // should look like calculateAmount("BTC", 100000000)
674     // See setPrice example (8 decimals)
675     function calculateAmount(string currency, uint64 value)
676         public
677         view
678         returns (uint88 amount)
679     {
680         require(prices[currency].value > 0);
681         require(value >= prices[currency].value);
682 
683         amount = uint88( ( uint(value) * ( 10**18 ) ) / prices[currency].value );
684     }
685 
686     function calculatePrice(string currency, uint88 amount)
687         public
688         view
689         returns (uint64 price)
690     {
691         require(prices[currency].value > 0);
692 
693         price = uint64( amount * prices[currency].value );
694     }
695 
696     function addTransaction(string currency, uint64 value, string transactionId)
697         public
698         onlyAdministrator
699         returns (uint newTransactionId)
700     {
701         require(prices[currency].value > 0);
702 
703         newTransactionId = transactions.length;
704 
705         Transaction memory transaction;
706 
707         transaction.currency = currency;
708         transaction.value = value;
709         transaction.decimals = prices[currency].decimals;
710         transaction.price = prices[currency].value;
711         transaction.transactionId = transactionId;
712 
713         transactions.push(transaction);
714 
715         NewTransaction(transaction.currency, transaction.value, transaction.transactionId,
716             transaction.price, transaction.decimals);
717     }
718 
719     function getNumTransactions()
720         public
721         constant
722         returns(uint length)
723     {
724         length = transactions.length;
725     }
726 
727     function addRefundTransaction(uint sourceTransaction, uint88 refundAmount)
728         public
729         onlyAdministrator
730         returns (uint newTransactionId)
731     {
732         require(sourceTransaction < transactions.length);
733 
734         newTransactionId = refundTransactions.length;
735 
736         RefundTransaction memory transaction;
737 
738         transaction.sourceTransaction = sourceTransaction;
739         transaction.refundAmount = refundAmount;
740 
741         refundTransactions.push(transaction);
742 
743         NewRefundTransaction(transaction.sourceTransaction, transaction.refundAmount);
744     }
745 
746     function getNumRefundTransactions()
747         public
748         constant
749         returns(uint length)
750     {
751         length = refundTransactions.length;
752     }
753 }
754 
755 contract PreSaleUNIT is ERC20Contract {
756     ERC20[3] internal tokens;
757 
758     ExternalCurrencyPrice externalCurrencyProcessor;
759 
760     uint88 pool = 24000000000000000000000000; //24 mln tokens
761 
762     uint32 internal endDate = 1519326000;  //22 February 2018 19:00 UTC
763 
764     uint8 internal discount = 40;          //40%
765 
766     address internal owner;
767 
768     event AddToken(address NewToken, uint8 index);
769     event BuyTokensDirect(address buyer, uint72 eth_amount, uint88 paid_amount, uint88 bonus_amount);
770     event BuyTokensExternal(address buyer, string currency, uint72 amount, uint88 paid_amount, uint88 bonus_amount);
771     event ChangeDate(uint32 new_date);
772     event ChangeDiscount(uint8 new_discount);
773     event ChangePool(uint88 new_pool);
774 
775     modifier onlyAdministrator() {
776         require(tx.origin == owner);
777         _;
778     }
779 
780     modifier notAdministrator() {
781         require(tx.origin != owner);
782         _;
783     }
784 
785     modifier poolIsNotEmpty() {
786         require(pool > 0);
787         _;
788     }
789 
790     modifier didntRanOutOfTime() {
791         require(uint32(now) <= endDate);
792         _;
793     }
794 
795     function PreSaleUNIT(ERC20 _token)
796         public
797     {
798         tokens[0] = _token;
799         owner = tx.origin;
800     }
801 
802     function getOwner()
803         public
804         constant
805         returns (address)
806     {
807         return owner;
808     }
809 
810     function getTokens()
811         public
812         constant
813         returns(ERC20[3])
814     {
815         return tokens;
816     }
817 
818     function getPool()
819         public
820         constant
821         returns(uint88)
822     {
823         return pool;
824     }
825 
826     function getBaseToken()
827         public
828         constant
829         returns(UnilotToken _token)
830     {
831         _token = UnilotToken(tokens[0]);
832     }
833 
834     function getExternalCurrencyProcessor()
835         public
836         onlyAdministrator
837         returns(ExternalCurrencyPrice)
838     {
839         return externalCurrencyProcessor;
840     }
841 
842     //Admin fns
843     function addToken(ERC20 _token)
844         public
845         onlyAdministrator
846     {
847         require(_token != address(0));
848 
849         for(uint8 i = 0; i < tokens.length; i++) {
850             if (tokens[i] == _token) {
851                 break;
852             } else if (tokens[i] == address(0)) {
853                 tokens[i] = _token;
854                 AddToken(_token, i);
855                 break;
856             }
857         }
858     }
859 
860     function changeEndDate(uint32 _endDate)
861         public
862         onlyAdministrator
863     {
864         endDate = _endDate;
865         ChangeDate(endDate);
866     }
867 
868     function changeDiscount(uint8 _discount)
869         public
870         onlyAdministrator
871     {
872         discount = _discount;
873         ChangeDiscount(discount);
874     }
875 
876     function changePool(uint88 _pool)
877         public
878         onlyAdministrator
879     {
880         pool = _pool;
881         ChangePool(pool);
882     }
883 
884     function setExternalCurrencyProcessor(ExternalCurrencyPrice processor)
885         public
886         onlyAdministrator
887     {
888         externalCurrencyProcessor = processor;
889     }
890 
891     function paymentWithCurrency(address buyer, string currency, uint64 value, string transactionId)
892         public
893         onlyAdministrator
894         poolIsNotEmpty
895         didntRanOutOfTime
896     {
897         require(buyer != owner);
898 
899         ExternalCurrencyPrice processor = getExternalCurrencyProcessor();
900         uint88 paid_tokens = processor.calculateAmount(currency, value);
901         uint88 bonus_tokens = uint88((paid_tokens * discount) / 100);
902         uint88 refund_amount = 0;
903 
904         if((paid_tokens + bonus_tokens) > pool) {
905             paid_tokens = uint88( pool / ( ( 100 + discount ) / 100 ) );
906             bonus_tokens = uint88( pool - paid_tokens );
907             refund_amount = ( value - processor.calculatePrice(currency, paid_tokens) );
908         }
909 
910         balances[buyer] += uint96(paid_tokens + bonus_tokens);
911 
912         BuyTokensExternal(buyer, currency, value, paid_tokens, bonus_tokens);
913 
914         uint processorTransactionId = processor.addTransaction(currency, value, transactionId);
915 
916         if ( refund_amount > 0 ) {
917             processor.addRefundTransaction(processorTransactionId, refund_amount);
918         }
919     }
920     //END Admin fns
921 
922     //ERC20
923     function totalSupply()
924         public
925         constant
926         returns (uint)
927     {
928         return uint(tokens[0].totalSupply());
929     }
930 
931     function balanceOf(address _owner)
932         public
933         constant
934         returns (uint balance)
935     {
936         balance = super.balanceOf(_owner);
937 
938         for ( uint8 i = 0; i < tokens.length; i++ ) {
939             if (tokens[i] == address(0)) {
940                 break;
941             }
942 
943             balance += uint96(tokens[i].balanceOf(_owner));
944         }
945     }
946 
947     function transfer(address _to, uint _amount)
948         public
949         returns (bool success)
950     {
951         success = false;
952     }
953 
954     function transferFrom(
955         address _from,
956         address _to,
957         uint256 _amount
958     )
959         public
960         returns (bool success)
961     {
962         success = false;
963     }
964 
965     function approve(address _spender, uint _amount)
966         public
967         returns (bool success)
968     {
969         success = false;
970     }
971 
972     function allowance(address _owner, address _spender)
973         public
974         constant
975         returns (uint remaining)
976     {
977         remaining = 0;
978     }
979     //END ERC20
980 
981     function()
982         public
983         payable
984         notAdministrator
985         poolIsNotEmpty
986         didntRanOutOfTime
987     {
988         UnilotToken baseToken = getBaseToken();
989 
990         address storageWallet = baseToken.STORAGE_WALLET();
991         uint48 price = uint48(baseToken.price());
992         uint72 eth_amount = uint72(msg.value);
993         uint64 accuracy = uint64( baseToken.accuracy() );
994         uint88 paid_tokens = uint88( ( uint(eth_amount) * accuracy / price ) );
995         uint88 bonus_tokens = uint88((paid_tokens * discount) / 100);
996 
997         if((paid_tokens + bonus_tokens) > pool) {
998             paid_tokens = uint88( pool / ( ( 100 + discount ) / 100 ) );
999             bonus_tokens = uint88( pool - paid_tokens );
1000             eth_amount = uint72( (paid_tokens / accuracy) * price );
1001             msg.sender.transfer( msg.value - eth_amount );
1002         }
1003 
1004         BuyTokensDirect(msg.sender, eth_amount, paid_tokens, bonus_tokens);
1005 
1006         balances[msg.sender] += uint96(paid_tokens + bonus_tokens);
1007 
1008         storageWallet.transfer(this.balance);
1009     }
1010 }