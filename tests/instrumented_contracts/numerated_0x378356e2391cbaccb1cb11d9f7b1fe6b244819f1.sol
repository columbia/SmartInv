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