1 pragma solidity ^0.4.18;
2 
3 // Project: High Reward Coin
4 // v4, 2017-12-31
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same ICO platform? www.cryptob2b.io
9 
10 
11 // (A1)
12 // The main contract for the sale and management of rounds.
13 contract CrowdsaleBL{
14     using SafeMath for uint256;
15 
16     enum ICOType {round1, round2}
17     enum Roles {beneficiary, accountant, manager, observer, bounty, team, company}
18 
19     Token public token;
20 
21     bool public isFinalized;
22     bool public isInitialized;
23     bool public isPausedCrowdsale;
24 
25     mapping (uint8 => address) public wallets;
26    
27 
28     uint256 public startTime = 1516435200;    // 20.01.2018 08:00:00
29     uint256 public endTime = 1519171199;      // 20.02.2018 23:59:59
30 
31     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
32     // **THOUSANDS** 10^3 for human, 1*10**3 for Solidity, 1e3 for MyEtherWallet (MEW).
33     // Example: if 1ETH = 40.5 Token ==> use 40500
34     uint256 public rate = 400000; // Tokens
35 
36     // If the round does not attain this value before the closing date, the round is recognized as a
37     // failure and investors take the money back (the founders will not interfere in any way).
38     // **QUINTILLIONS** 10^18 / 1*10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
39     uint256 public softCap = 1240000*10**18; // 1,24M Tokens (~ $1 000 000)
40 
41     // The maximum possible amount of income
42     // **QUINTILLIONS** 10^18 / 1*10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
43     uint256 public hardCap = 9240000*10**18; // 9,24M Tokens (~ $12 700 00)
44 
45     // If the last payment is slightly higher than the hardcap, then the usual contracts do
46     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
47     // last payment, very slightly raising the hardcap. The value indicates by how many Token emitted the
48     // last payment can exceed the hardcap to allow it to be paid. Immediately after this buy, the
49     // round closes. The funders should write here a small number, not more than 1% of the CAP.
50     // Can be equal to zero, to cancel.
51     // **QUINTILLIONS** 10^18 / 1*10**18 / 1e18
52     uint256 public overLimit = 20000*10**18; // Tokens (~$20000)
53 
54     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
55     // **QUINTILLIONS** 10^18 / 1*10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
56     uint256 public minPay = 36*10**15; // 0,036 ETH (~$25)
57 
58     uint256 public ethWeiRaised;
59     uint256 public nonEthWeiRaised;
60     uint256 weiRound1;
61     uint256 public tokenReserved;
62 
63     RefundVault public vault;
64     SVTAllocation public lockedAllocation;
65     
66     
67     struct BonusBlock {uint256 amount; uint256 procent;}
68     BonusBlock[] public bonusPattern;
69 
70     ICOType ICO = ICOType.round2; // only ICO round #2 (no pre-ICO)
71 
72     uint256 allToken;
73 
74     bool public bounty;
75     bool public team;
76     bool public company;
77     bool public partners;
78 
79     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
80 
81     event Finalized();
82     event Initialized();
83 
84     function CrowdsaleBL(Token _token, uint256 firstMint) public
85     {
86         // Initially, all next 7 roles/wallets are given to the Manager. The Manager is an employee of the company
87         // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
88         // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
89         // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
90         // this via method changeWallet. In the finalization methods it is written which wallet and
91         // what percentage of tokens are received.
92 
93         // Receives all the money (when finalizing pre-ICO & ICO)
94         wallets[uint8(Roles.beneficiary)] = 0xe06bD713B2e33C218FDD56295Af74d45cE8c9D98; //msg.sender;
95 
96         // Receives all the tokens for non-ETH investors (when finalizing pre-ICO & ICO)
97         wallets[uint8(Roles.accountant)] = 0xddC98d7d9CdD82172daD7467c8E341cfBEb077DD; //msg.sender;
98 
99         // All rights except the rights to receive tokens or money. Has the right to change any other
100         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
101         // round is initialized, the Manager has lost all rights to change the wallets.
102         // If the ICO is conducted by one person, then nothing needs to be changed. Permit all 7 roles
103         // point to a single wallet.
104         wallets[uint8(Roles.manager)] = msg.sender;
105 
106         // Has only the right to call paymentsInOtherCurrency (please read the document)
107         wallets[uint8(Roles.observer)] = 0x76d737F21296cd1ED6938DbCA217615681b06336; //msg.sender;
108 
109 
110         wallets[uint8(Roles.bounty)] = 0x4918fc7974d7Ee6F266f9256DfcA610FD735Bf27; //msg.sender;
111 
112         // When the round is finalized, all team tokens are transferred to a special freezing
113         // contract. As soon as defrosting is over, only the Team wallet will be able to
114         // collect all the tokens. It does not store the address of the freezing contract,
115         // but the final wallet of the project team.
116         wallets[uint8(Roles.team)] = 0xc59403026685F553f8a6937C53452b9d1DE4c707; // msg.sender;
117 
118         // startTime, endDiscountTime, endTime (then you can change it in the setup)
119         //changePeriod(now + 5 minutes, now + 5 + 10 minutes, now + 5 + 12 minutes);
120 
121         wallets[uint8(Roles.company)] = 0xc59403026685F553f8a6937C53452b9d1DE4c707; //msg.sender;
122         
123         token = _token;
124         token.setOwner();
125 
126         token.pause(); // block exchange tokens
127 
128         token.addUnpausedWallet(msg.sender);
129         token.addUnpausedWallet(wallets[uint8(Roles.company)]);
130         token.addUnpausedWallet(wallets[uint8(Roles.bounty)]);
131         token.addUnpausedWallet(wallets[uint8(Roles.accountant)]);
132 
133         if (firstMint > 0){
134             token.mint(msg.sender,firstMint);
135         }
136 
137     }
138 
139     // Returns the name of the current round in plain text. Constant.
140     function ICOSaleType()  public constant returns(string){
141         return (ICO == ICOType.round1)?'round1':'round2';
142     }
143 
144     // Transfers the funds of the investor to the contract of return of funds. Internal.
145     function forwardFunds() internal {
146         vault.deposit.value(msg.value)(msg.sender);
147     }
148 
149     // Check for the possibility of buying tokens. Inside. Constant.
150     function validPurchase() internal constant returns (bool) {
151 
152         // The round started and did not end
153         bool withinPeriod = (now > startTime && now < endTime);
154 
155         // Rate is greater than or equal to the minimum
156         bool nonZeroPurchase = msg.value >= minPay;
157 
158         // round is initialized and no "Pause of trading" is set
159         return withinPeriod && nonZeroPurchase && isInitialized && !isPausedCrowdsale;
160     }
161 
162     // Check for the ability to finalize the round. Constant.
163     function hasEnded() public constant returns (bool) {
164 
165         bool timeReached = now > endTime;
166 
167         bool capReached = token.totalSupply().add(tokenReserved) >= hardCap;
168 
169         return (timeReached || capReached) && isInitialized;
170     }
171     
172     function finalizeAll() external {
173         finalize();
174         finalize1();
175         finalize2();
176         finalize3();
177         finalize4();
178     }
179 
180     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
181     // anyone can call the finalization to unlock the return of funds to investors
182     // You must call a function to finalize each round (after the pre-ICO & after the ICO)
183     function finalize() public {
184 
185         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender|| !goalReached());
186         require(!isFinalized);
187         require(hasEnded());
188 
189         isFinalized = true;
190         finalization();
191         Finalized();
192     }
193 
194     // The logic of finalization. Internal
195     function finalization() internal {
196 
197         // If the goal of the achievement
198         if (goalReached()) {
199 
200             // Send ether to Beneficiary
201             vault.close(wallets[uint8(Roles.beneficiary)]);
202 
203             // if there is anything to give
204             if (tokenReserved > 0) {
205 
206                 // Issue tokens of non-eth investors to Accountant account
207                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
208 
209                 // Reset the counter
210                 tokenReserved = 0;
211             }
212 
213             // If the finalization is Round 1 pre-ICO
214             if (ICO == ICOType.round1) {
215 
216                 // Reset settings
217                 isInitialized = false;
218                 isFinalized = false;
219 
220                 // Switch to the second round (to ICO)
221                 ICO = ICOType.round2;
222 
223                 // Reset the collection counter
224                 weiRound1 = weiRaised();
225                 ethWeiRaised = 0;
226                 nonEthWeiRaised = 0;
227 
228             }
229             else // If the second round is finalized
230             {
231 
232                 // Record how many tokens we have issued
233                 allToken = token.totalSupply();
234 
235                 // Permission to collect tokens to those who can pick them up
236                 bounty = true;
237                 team = true;
238                 company = true;
239                 partners = true;
240 
241             }
242 
243         }
244         else // If they failed round
245         {
246             // Allow investors to withdraw their funds
247             vault.enableRefunds();
248         }
249     }
250 
251     // The Manager freezes the tokens for the Team.
252     // You must call a function to finalize Round 2 (only after the ICO)
253     function finalize1() public {
254         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
255         require(team);
256         team = false;
257         lockedAllocation = new SVTAllocation(token, wallets[uint8(Roles.team)]);
258         token.addUnpausedWallet(lockedAllocation);
259         // 6% - tokens to Team wallet after freeze (77% for investors)
260         // *** CHECK THESE NUMBERS ***
261         token.mint(lockedAllocation, allToken.mul(6).div(77));
262     }
263 
264     function finalize2() public {
265         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
266         require(bounty);
267         bounty = false;
268         // 2% - tokens to bounty wallet (77% for investors)
269         // *** CHECK THESE NUMBERS ***
270         token.mint(wallets[uint8(Roles.bounty)], allToken.mul(2).div(77));
271     }
272 
273     function finalize3() public {
274         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
275         require(company);
276         company = false;
277         // 2% - tokens to company wallet (77% for investors)
278         // *** CHECK THESE NUMBERS ***
279         token.mint(wallets[uint8(Roles.company)],allToken.mul(2).div(77));
280     }
281 
282     function finalize4()  public {
283         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
284         require(partners);
285         partners = false;
286         // 13% - tokens to partners+referral wallet (77% for investors)
287         // *** CHECK THESE NUMBERS ***
288         token.mint(wallets[uint8(Roles.accountant)],allToken.mul(13).div(77));
289     }
290 
291 
292     // Initializing the round. Available to the manager. After calling the function,
293     // the Manager loses all rights: Manager can not change the settings (setup), change
294     // wallets, prevent the beginning of the round, etc. You must call a function after setup
295     // for the initial round (before the Pre-ICO and before the ICO)
296     function initialize() public{
297 
298         // Only the Manager
299         require(wallets[uint8(Roles.manager)] == msg.sender);
300 
301         // If not yet initialized
302         require(!isInitialized);
303 
304         // And the specified start time has not yet come
305         // If initialization return an error, check the start date!
306         require(now <= startTime);
307 
308         initialization();
309 
310         Initialized();
311 
312         isInitialized = true;
313     }
314 
315     function initialization() internal {
316 	    vault = new RefundVault();
317     }
318 
319     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
320     function claimRefund() public{
321         vault.refund(msg.sender);
322     }
323 
324     // We check whether we collected the necessary minimum funds. Constant.
325     function goalReached() public constant returns (bool) {
326         return token.totalSupply().add(tokenReserved) >= softCap;
327     }
328 
329     // Customize. The arguments are described in the constructor above.
330     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap, uint256 _rate, uint256 _overLimit, uint256 _minPay, uint256[] _amount, uint256[] _procent) public{
331             changePeriod(_startTime, _endTime);
332             changeRate(_rate, _minPay);
333             changeCap(_softCap, _hardCap, _overLimit);
334             if(_amount.length > 0)
335                 setBonusPattern(_amount,_procent);
336     }
337 
338 	// Change the date and time: the beginning of the round, the end of the bonus, the end of the round. Available to Manager
339     // Description in the Crowdsale constructor
340     function changePeriod(uint256 _startTime, uint256 _endTime) public{
341 
342         require(wallets[uint8(Roles.manager)] == msg.sender);
343 
344         require(!isInitialized);
345 
346         // Date and time are correct
347         require(now <= _startTime);
348         require(_startTime < _endTime);
349 
350         startTime = _startTime;
351         endTime = _endTime;
352     }
353     
354 
355     // Change the price (the number of tokens per 1 eth), the maximum hardCap for the last bet,
356     // the minimum bet. Available to the Manager.
357     // Description in the Crowdsale constructor
358     function changeRate(uint256 _rate, uint256 _minPay) public {
359 
360          require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.observer)] == msg.sender);
361 
362          require(_rate > 0);
363 
364          rate = _rate;
365          minPay = _minPay;
366     }
367     
368     function changeCap(uint256 _softCap, uint256 _hardCap, uint256 _overLimit) public {
369         require(wallets[uint8(Roles.manager)] == msg.sender);
370         require(!isInitialized);
371         require(_hardCap > _softCap);
372         softCap = _softCap;
373         hardCap = _hardCap;
374         overLimit = _overLimit;
375     }
376     
377     function setBonusPattern(uint256[] _amount, uint256[] _procent) public {
378         require(wallets[uint8(Roles.manager)] == msg.sender);
379         require(!isInitialized);
380         require(_amount.length == _procent.length);
381         bonusPattern.length = _amount.length;
382         for(uint256 i = 0; i < _amount.length; i++){
383             bonusPattern[i] = BonusBlock(_amount[i],_procent[i]);
384         }
385     }
386 
387     // Collected funds for the current round. Constant.
388     function weiRaised() public constant returns(uint256){
389         return ethWeiRaised.add(nonEthWeiRaised);
390     }
391 
392     // Returns the amount of fees for both phases. Constant.
393     function weiTotalRaised() public constant returns(uint256){
394         return weiRound1.add(weiRaised());
395     }
396 
397 
398     // The ability to quickly check pre-ICO (only for Round 1, only 1 time). Completes the pre-ICO by
399     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
400     // Use only if this is provided by the script and white paper. In the normal scenario, it
401     // does not call and the funds are raised normally. We recommend that you delete this
402     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
403     // ** QUINTILIONS **  10^18 / 1*10**18 / 1e18
404 //    function fastICO(uint256 _totalSupply) public {
405 //      require(wallets[uint8(Roles.manager)] == msg.sender);
406 //      require(ICO == ICOType.round1 && !isInitialized);
407 //      token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
408 //      ICO = ICOType.round2;
409 //    }
410 
411     // Remove the "Pause of exchange". Available to the manager at any time. If the
412     // manager refuses to remove the pause, then 30 days after the successful
413     // completion of the ICO, anyone can remove a pause and allow the exchange to continue.
414     // The manager does not interfere and will not be able to delay the term.
415     // He can only cancel the pause before the appointed time.
416     function tokenUnpause() public {
417         require(wallets[uint8(Roles.manager)] == msg.sender
418         	|| (now > endTime + 30 days && ICO == ICOType.round2 && isFinalized && goalReached()));
419         token.unpause();
420     }
421 
422     // Enable the "Pause of exchange". Available to the manager until the ICO is completed.
423     // The manager cannot turn on the pause, for example, 3 years after the end of the ICO.
424     function tokenPause() public {
425         require(wallets[uint8(Roles.manager)] == msg.sender && !isFinalized);
426         token.pause();
427     }
428 
429     // Pause of sale. Available to the manager.
430     function crowdsalePause() public {
431         require(wallets[uint8(Roles.manager)] == msg.sender);
432         require(isPausedCrowdsale == false);
433         isPausedCrowdsale = true;
434     }
435 
436     // Withdrawal from the pause of sale. Available to the manager.
437     function crowdsaleUnpause() public {
438         require(wallets[uint8(Roles.manager)] == msg.sender);
439         require(isPausedCrowdsale == true);
440         isPausedCrowdsale = false;
441     }
442 
443     // Checking whether the rights to address ignore the "Pause of exchange". If the
444     // wallet is included in this list, it can translate tokens, ignoring the pause. By default,
445     // only the following wallets are included:
446     //    - Accountant wallet (he should immediately transfer tokens, but not to non-ETH investors)
447     //    - Contract for freezing the tokens for the Team (but Team wallet not included)
448     // Inside. Constant.
449     function unpausedWallet(address _wallet) internal constant returns(bool) {
450         bool _accountant = wallets[uint8(Roles.accountant)] == _wallet;
451         bool _manager = wallets[uint8(Roles.manager)] == _wallet;
452         bool _bounty = wallets[uint8(Roles.bounty)] == _wallet;
453         bool _company = wallets[uint8(Roles.company)] == _wallet;
454         return _accountant || _manager || _bounty || _company;
455     }
456 
457     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
458     // (company + investors) that it would be more profitable for everyone to switch to another smart
459     // contract responsible for tokens. The company then prepares a new token, investors
460     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
461 	//      - to burn the tokens of the previous contract
462 	//      - generate new tokens for a new contract
463 	// It is understood that after a general solution through this function all investors
464 	// will collectively (and voluntarily) move to a new token.
465     function moveTokens(address _migrationAgent) public {
466         require(wallets[uint8(Roles.manager)] == msg.sender);
467         token.setMigrationAgent(_migrationAgent);
468     }
469 
470 	// Change the address for the specified role.
471 	// Available to any wallet owner except the observer.
472 	// Available to the manager until the round is initialized.
473 	// The Observer's wallet or his own manager can change at any time.
474     function changeWallet(Roles _role, address _wallet) public
475     {
476         require(
477         		(msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
478       		||
479       			(msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer))
480       	);
481         address oldWallet = wallets[uint8(_role)];
482         wallets[uint8(_role)] = _wallet;
483         if(!unpausedWallet(oldWallet))
484             token.delUnpausedWallet(oldWallet);
485         if(unpausedWallet(_wallet))
486             token.addUnpausedWallet(_wallet);
487     }
488 
489     // If a little more than a year has elapsed (ICO start date + 400 days), a smart contract
490     // will allow you to send all the money to the Beneficiary, if any money is present. This is
491     // possible if you mistakenly launch the ICO for 30 years (not 30 days), investors will transfer
492     // money there and you will not be able to pick them up within a reasonable time. It is also
493     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
494     // finalization. Without finalization, money cannot be returned. This is a rescue option to
495     // get around this problem, but available only after a year (400 days).
496 
497 	// Another reason - the ICO was a failure, but not all ETH investors took their money during the year after.
498 	// Some investors may have lost a wallet key, for example.
499 
500 	// The method works equally with the pre-ICO and ICO. When the pre-ICO starts, the time for unlocking
501 	// the distructVault begins. If the ICO is then started, then the term starts anew from the first day of the ICO.
502 
503 	// Next, act independently, in accordance with obligations to investors.
504 
505 	// Within 400 days of the start of the Round, if it fails only investors can take money. After
506 	// the deadline this can also include the company as well as investors, depending on who is the first to use the method.
507     function distructVault() public {
508         require(wallets[uint8(Roles.beneficiary)] == msg.sender);
509         require(now > startTime + 400 days);
510         vault.del(wallets[uint8(Roles.beneficiary)]);
511     }
512     
513     
514     
515     function getBonus(uint256 _tokenValue) public constant returns (uint256 value) {
516         uint256 totalToken = tokenReserved.add(token.totalSupply());
517         uint256 tokenValue = _tokenValue;
518         uint256 currentBonus;
519         uint256 calculateBonus = 0;
520         uint16 i;
521         for (i = 0; i < bonusPattern.length; i++){
522             if(totalToken >= bonusPattern[i].amount)
523                 continue;
524             currentBonus = tokenValue.mul(bonusPattern[i].procent.add(100000)).div(100000);
525             if(totalToken.add(calculateBonus).add(currentBonus) < bonusPattern[i].amount) {
526                 calculateBonus = calculateBonus.add(currentBonus);
527                 tokenValue = 0;
528                 break;
529             }
530             currentBonus = bonusPattern[i].amount.sub(totalToken.add(calculateBonus));
531             tokenValue = tokenValue.sub(currentBonus.mul(100000).div(bonusPattern[i].procent.add(100000)));
532             calculateBonus = calculateBonus + currentBonus;
533         }
534         return calculateBonus.add(tokenValue);
535     }
536 
537 
538 	// We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
539 	// Perhaps other types of cryptocurrency - see the original terms in the white paper and on the ICO website.
540 
541 	// We release tokens on Ethereum. During the pre-ICO and ICO with a smart contract, you directly transfer
542 	// the tokens there and immediately, with the same transaction, receive tokens in your wallet.
543 
544 	// When paying in any other currency, for example in BTC, we accept your money via one common wallet.
545 	// Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
546     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
547     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
548     // monitors softcap and hardcap, so as not to go beyond this framework.
549 
550 	// In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
551 	// transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
552 	// In this case, we will refund all the amounts above, in order not to exceed the hardcap.
553 
554 	// Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
555 	// everywhere (in a white paper, on the ICO website, on Telegram, on Bitcointalk, in this code, etc.)
556 	// Anyone interested can check that the administrator of the smart contract writes down exactly the amount
557 	// in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
558 	// BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
559 	// paymentsInOtherCurrency however, this threat is leveled.
560 
561 	// Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
562 	// (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
563 	// on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the ICO,
564 	// simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
565 	// and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
566 
567 	// The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
568 	// cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
569 	// brakes on the Ethereum network, this operation may be difficult. You should only worry if the
570 	// administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
571 	// receives significant amounts.
572 
573 	// This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
574 
575     // Common BTC wallet: 12sEoiXPs8a6sJbC2qkbZDjmHsSBv7cGwC
576 
577     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
578     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
579         require(wallets[uint8(Roles.observer)] == msg.sender);
580         bool withinPeriod = (now >= startTime && now <= endTime);
581 
582         bool withinCap = token.totalSupply().add(_token) <= hardCap.add(overLimit);
583         require(withinPeriod && withinCap && isInitialized);
584 
585         nonEthWeiRaised = _value;
586         tokenReserved = _token;
587 
588     }
589 
590 
591     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
592     // transferred to the buyer, taking into account the current bonus.
593     function buyTokens(address beneficiary) public payable {
594         require(beneficiary != 0x0);
595         require(validPurchase());
596 
597         uint256 weiAmount = msg.value;
598 
599         // calculate token amount to be created
600         uint256 tokens = getBonus(weiAmount*rate/1000);
601         
602         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
603         bool withinCap = tokens <= hardCap.sub(token.totalSupply().add(tokenReserved)).add(overLimit);
604         
605         require(withinCap);
606 
607         // update state
608         ethWeiRaised = ethWeiRaised.add(weiAmount);
609 
610         token.mint(beneficiary, tokens);
611         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
612 
613         forwardFunds();
614     }
615 
616     // buyTokens alias
617     function () public payable {
618         buyTokens(msg.sender);
619     }
620 
621 }
622 
623 // (B)
624 // The contract for freezing tokens for the team..
625 contract SVTAllocation {
626     using SafeMath for uint256;
627 
628     Token public token;
629 
630 	address public owner;
631 
632     uint256 public unlockedAt;
633 
634     uint256 tokensCreated = 0;
635 
636     // The contract takes the ERC20 coin address from which this contract will work and from the
637     // owner (Team wallet) who owns the funds.
638     function SVTAllocation(Token _token, address _owner) public{
639 
640     	// How many days to freeze from the moment of finalizing ICO
641         unlockedAt = now + 1 years;
642         token = _token;
643         owner = _owner;
644     }
645 
646     // If the time of freezing expired will return the funds to the owner.
647     function unlock() public{
648         require(now >= unlockedAt);
649         require(token.transfer(owner,token.balanceOf(this)));
650     }
651 }
652 
653 
654 
655 /**
656  * @title SafeMath
657  * @dev Math operations with safety checks that throw on error
658  */
659 library SafeMath {
660     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
661     	uint256 c = a * b;
662     	assert(a == 0 || c / a == b);
663     	return c;
664 	}
665 
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         // assert(b > 0); // Solidity automatically throws when dividing by 0
668         uint256 c = a / b;
669         // assert(a == b * c + a % b); // There is no case in which this does not hold
670         return c;
671     }
672 
673     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
674         assert(b <= a);
675         return a - b;
676     }
677 
678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
679         uint256 c = a + b;
680         assert(c >= a);
681 		return c;
682     }
683 }
684 
685 
686 
687 /**
688  * @title Ownable
689  * @dev The Ownable contract has an owner address, and provides basic authorization control
690  * functions, this simplifies the implementation of "user permissions".
691  */
692 contract Ownable {
693     address public owner;
694 
695     /**
696      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
697      * account.
698      */
699     function Ownable() public {
700         owner = msg.sender;
701     }
702 
703     /**
704      * @dev Throws if called by any account other than the owner.
705      */
706     modifier onlyOwner() {
707         require(msg.sender == owner);
708         _;
709     }
710 
711     /**
712      * @dev Allows the current owner to transfer control of the contract to a newOwner.
713      * @param newOwner The address to transfer ownership to.
714      */
715     function transferOwnership(address newOwner) onlyOwner public{
716         require(newOwner != address(0));
717         owner = newOwner;
718     }
719 
720 }
721 
722 /**
723  * @title Pausable
724  * @dev Base contract which allows children to implement an emergency stop mechanism.
725  */
726 contract Pausable is Ownable {
727     event Pause();
728     event Unpause();
729 
730     bool _paused = false;
731 
732     function paused() public constant returns(bool)
733     {
734         return _paused;
735     }
736 
737     /**
738      * @dev modifier to allow actions only when the contract IS paused
739      */
740     modifier whenNotPaused() {
741         require(!paused());
742         _;
743     }
744 
745     /**
746      * @dev called by the owner to pause, triggers stopped state
747      */
748     function pause() onlyOwner public {
749         require(!_paused);
750         _paused = true;
751         Pause();
752     }
753 
754     /**
755      * @dev called by the owner to unpause, returns to normal state
756      */
757     function unpause() onlyOwner public {
758         require(_paused);
759         _paused = false;
760         Unpause();
761     }
762 }
763 
764 
765 // Contract interface for transferring current tokens to another
766 contract MigrationAgent
767 {
768     function migrateFrom(address _from, uint256 _value) public;
769 }
770 
771 
772 
773 // (A2)
774 // Contract token
775 contract Token is Pausable{
776     using SafeMath for uint256;
777 
778     string public constant name = "High Reward Coin";
779     string public constant symbol = "HRC";
780     uint8 public constant decimals = 18;
781 
782     uint256 public totalSupply;
783 
784     mapping(address => uint256) balances;
785     mapping (address => mapping (address => uint256)) allowed;
786 
787     mapping (address => bool) public unpausedWallet;
788 
789     bool public mintingFinished = false;
790 
791     uint256 public totalMigrated;
792     address public migrationAgent;
793 
794     event Transfer(address indexed from, address indexed to, uint256 value);
795     event Approval(address indexed owner, address indexed spender, uint256 value);
796 
797     event Mint(address indexed to, uint256 amount);
798     event MintFinished();
799 
800     event Migrate(address indexed _from, address indexed _to, uint256 _value);
801 
802     modifier canMint() {
803         require(!mintingFinished);
804         _;
805     }
806 
807      function Token() public {
808          owner = 0x0;
809      }
810 
811      function setOwner() public{
812          require(owner == 0x0);
813          owner = msg.sender;
814      }
815 
816     // Balance of the specified address
817     function balanceOf(address _owner) public constant returns (uint256 balance) {
818         return balances[_owner];
819     }
820 
821     // Transfer of tokens from one account to another
822     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
823         require (_value > 0);
824         balances[msg.sender] = balances[msg.sender].sub(_value);
825         balances[_to] = balances[_to].add(_value);
826         Transfer(msg.sender, _to, _value);
827         return true;
828     }
829 
830     // Returns the number of tokens that _owner trusted to spend from his account _spender
831     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
832         return allowed[_owner][_spender];
833     }
834 
835     // Trust _sender and spend _value tokens from your account
836     function approve(address _spender, uint256 _value) public returns (bool) {
837 
838         // To change the approve amount you first have to reduce the addresses
839         //  allowance to zero by calling `approve(_spender, 0)` if it is not
840         //  already 0 to mitigate the race condition described here:
841         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
842         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
843 
844         allowed[msg.sender][_spender] = _value;
845         Approval(msg.sender, _spender, _value);
846         return true;
847     }
848 
849     // Transfer of tokens from the trusted address _from to the address _to in the number _value
850     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
851         var _allowance = allowed[_from][msg.sender];
852 
853         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
854         // require (_value <= _allowance);
855 
856         require (_value > 0);
857 
858         balances[_from] = balances[_from].sub(_value);
859         balances[_to] = balances[_to].add(_value);
860         allowed[_from][msg.sender] = _allowance.sub(_value);
861         Transfer(_from, _to, _value);
862         return true;
863     }
864 
865     // Issue new tokens to the address _to in the amount _amount. Available to the owner of the contract (contract Crowdsale)
866     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
867         totalSupply = totalSupply.add(_amount);
868         balances[_to] = balances[_to].add(_amount);
869         Mint(_to, _amount);
870         Transfer(0x0, _to, _amount);
871         return true;
872     }
873 
874     // Stop the release of tokens. This is not possible to cancel. Available to the owner of the contract.
875 //    function finishMinting() public onlyOwner returns (bool) {
876 //        mintingFinished = true;
877 //        MintFinished();
878 //        return true;
879 //    }
880 
881     // Redefinition of the method of the returning status of the "Exchange pause".
882     // Never for the owner of an unpaused wallet.
883     function paused() public constant returns(bool) {
884         return super.paused() && !unpausedWallet[msg.sender];
885     }
886 
887 
888     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
889     function addUnpausedWallet(address _wallet) public onlyOwner {
890         unpausedWallet[_wallet] = true;
891     }
892 
893     // Remove the wallet ignoring the "Exchange pause". Available to the owner of the contract.
894     function delUnpausedWallet(address _wallet) public onlyOwner {
895          unpausedWallet[_wallet] = false;
896     }
897 
898     // Enable the transfer of current tokens to others. Only 1 time. Disabling this is not possible.
899     // Available to the owner of the contract.
900     function setMigrationAgent(address _migrationAgent) public onlyOwner {
901         require(migrationAgent == 0x0);
902         migrationAgent = _migrationAgent;
903     }
904 
905     // Reissue your tokens.
906     function migrate() public
907     {
908         uint256 value = balances[msg.sender];
909         require(value > 0);
910 
911         totalSupply = totalSupply.sub(value);
912         totalMigrated = totalMigrated.add(value);
913         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
914         Migrate(msg.sender,migrationAgent,value);
915         balances[msg.sender] = 0;
916     }
917 }
918 
919 // (A3)
920 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the
921 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the
922 // money (namely, the beneficiary, not the manager's wallet).
923 contract RefundVault is Ownable {
924     using SafeMath for uint256;
925 
926     enum State { Active, Refunding, Closed }
927 
928     mapping (address => uint256) public deposited;
929     State public state;
930 
931     event Closed();
932     event RefundsEnabled();
933     event Refunded(address indexed beneficiary, uint256 weiAmount);
934     event Deposited(address indexed beneficiary, uint256 weiAmount);
935 
936     function RefundVault() public {
937         state = State.Active;
938     }
939 
940     // Depositing funds on behalf of an ICO investor. Available to the owner of the contract (Crowdsale Contract).
941     function deposit(address investor) onlyOwner public payable {
942         require(state == State.Active);
943         deposited[investor] = deposited[investor].add(msg.value);
944         Deposited(investor,msg.value);
945     }
946 
947     // Move the collected funds to a specified address. Available to the owner of the contract.
948     function close(address _wallet) onlyOwner public {
949         require(state == State.Active);
950         require(_wallet != 0x0);
951         state = State.Closed;
952         Closed();
953         _wallet.transfer(this.balance);
954     }
955 
956     // Allow refund to investors. Available to the owner of the contract.
957     function enableRefunds() onlyOwner public {
958         require(state == State.Active);
959         state = State.Refunding;
960         RefundsEnabled();
961     }
962 
963     // Return the funds to a specified investor. In case of failure of the round, the investor
964     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale
965     // contract. This function should be called either by the investor himself, or the company
966     // (or anyone) can call this function in the loop to return funds to all investors en masse.
967     function refund(address investor) public {
968         require(state == State.Refunding);
969         require(deposited[investor] > 0);
970         uint256 depositedValue = deposited[investor];
971         deposited[investor] = 0;
972         investor.transfer(depositedValue);
973         Refunded(investor, depositedValue);
974     }
975 
976     // Destruction of the contract with return of funds to the specified address. Available to
977     // the owner of the contract.
978     function del(address _wallet) external onlyOwner {
979         selfdestruct(_wallet);
980     }
981 }