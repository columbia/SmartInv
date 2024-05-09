1 pragma solidity ^0.4.8;
2 
3 /**
4 SMSCoin is a token implementation for Speed Mining Service (SMS) project.
5 We are aim to issue the SMS tokens to give the privilege to the closed group of investors,
6 as then they will be able to receive the devidends from our mining farm in Hokkaido and the other countries as well.
7 
8 Our cloudsale starts from 27 October 2017, 14:00 (JST) with the different bonus ratio based on the number of token and the sale period.
9 
10 SMS coin team,
11 https://smscoin.jp
12 https://github.com/Speed-Mining/SMSCoin
13 https://etherscan.io/address/0x39013f961c378f02c2b82a6e1d31e9812786fd9d
14  */
15 
16 library SMSLIB {
17     /**
18      * Divide with safety check
19      */
20     function safeDiv(uint a, uint b) pure internal returns(uint) {
21         //overflow check; b must not be 0
22         assert(b > 0);
23         uint c = a / b;
24         assert(a == b * c + a % b);
25         return c;
26     }
27 }
28 
29 contract ERC20 {
30     // Standard interface
31     function totalSupply() public constant returns(uint256 _totalSupply);
32     function balanceOf(address who) public constant returns(uint256 balance);
33     function transfer(address to, uint value) public returns(bool success);
34     function transferFrom(address from, address to, uint value) public returns(bool success);
35     function approve(address spender, uint value) public returns(bool success);
36     function allowance(address owner, address spender) public constant returns(uint remaining);
37     event Transfer(address indexed from, address indexed to, uint value);
38     event Approval(address indexed owner, address indexed spender, uint value);
39 }
40 
41 contract SMSCoin is ERC20 {
42     string public constant name = "Speed Mining Service";
43     string public constant symbol = "SMS";
44     uint256 public constant decimals = 3;
45 
46     uint256 public constant UNIT = 10 ** decimals;
47 
48     uint public totalSupply = 0; // (initial with 0), targeted 2.9 Million SMS
49 
50     uint tokenSaleLot1 = 150000 * UNIT;
51     uint reservedBonusLot1 = 45000 * UNIT; // 45,000 tokens are the maximum possible bonus from 30% of 150,000 tokens in the bonus phase
52     uint tokenSaleLot3X = 50000 * UNIT;
53 
54     struct BonusStruct {
55         uint8 ratio1;
56         uint8 ratio2;
57         uint8 ratio3;
58         uint8 ratio4;
59     }
60     BonusStruct bonusRatio;
61 
62     uint public saleCounterThisPhase = 0;
63 
64     uint public limitedSale = 0;
65 
66     uint public sentBonus = 0;
67 
68     uint public soldToken = 0;
69 
70     mapping(address => uint) balances;
71 
72     mapping(address => mapping(address => uint)) allowed;
73 
74     address[] addresses;
75     address[] investorAddresses;
76 
77     mapping(address => address) private userStructs;
78 
79     address owner;
80 
81     address mint = address(this);   // Contract address as a minter
82     
83     address genesis = 0x0;
84 
85     uint256 public tokenPrice = 0.8 ether;
86     uint256 public firstMembershipPurchase = 0.16 ether;   // White card membership
87 
88     event Log(uint e);
89 
90     event Message(string msg);
91 
92     event TOKEN(string e);
93 
94     bool icoOnSale = false;
95 
96     bool icoOnPaused = false;
97 
98     bool spPhase = false;
99 
100     uint256 startDate;
101 
102     uint256 endDate;
103 
104     uint currentPhase = 0;
105 
106     bool needToDrain = false;
107 
108     modifier onlyOwner() {
109         if (msg.sender != owner) {
110             revert();
111         }
112         _;
113     }
114 
115     function SMSCoin() public {
116         owner = msg.sender;
117     }
118 
119     function setBonus(uint8 ratio1, uint8 ratio2, uint8 ratio3, uint8 ratio4) private {
120         bonusRatio.ratio1 = ratio1;
121         bonusRatio.ratio2 = ratio2;
122         bonusRatio.ratio3 = ratio3;
123         bonusRatio.ratio4 = ratio4;
124     }
125 
126     function calcBonus(uint256 sendingSMSToken) view private returns(uint256) {
127         // Calculating bonus
128         if (sendingSMSToken < (10 * UNIT)) {            // 0-9
129             return (sendingSMSToken * bonusRatio.ratio1) / 100;
130         } else if (sendingSMSToken < (50 * UNIT)) {     // 10-49
131             return (sendingSMSToken * bonusRatio.ratio2) / 100;
132         } else if (sendingSMSToken < (100 * UNIT)) {    // 50-99
133             return (sendingSMSToken * bonusRatio.ratio3) / 100;
134         } else {                                        // 100+
135             return (sendingSMSToken * bonusRatio.ratio4) / 100;
136         }
137     }
138 
139     // Selling SMS token
140     function () public payable {
141         uint256 receivedETH = 0;
142         uint256 receivedETHUNIT = 0;
143         uint256 sendingSMSToken = 0;
144         uint256 sendingSMSBonus = 0;
145         Log(msg.value);
146 
147         // Only for selling to investors
148         if (icoOnSale && !icoOnPaused && msg.sender != owner) {
149             if (now <= endDate) {
150                 // All the phases
151                 Log(currentPhase);
152                 
153                 receivedETH = msg.value;
154                 // Check if the investor already joined and completed membership payment
155                 // If a new investor, check if the first purchase is at least equal to the membership price
156                 if ((checkAddress(msg.sender) && checkMinBalance(msg.sender)) || firstMembershipPurchase <= receivedETH) {
157                     // Calculating SMS
158                     receivedETHUNIT = receivedETH * UNIT;
159                     sendingSMSToken = SMSLIB.safeDiv(receivedETHUNIT, tokenPrice);
160                     Log(sendingSMSToken);
161 
162                     // Calculating Bonus
163                     if (currentPhase == 1 || currentPhase == 2 || currentPhase == 3) {
164                         // Phase 1-3 with Bonus 1
165                         sendingSMSBonus = calcBonus(sendingSMSToken);
166                         Log(sendingSMSBonus);
167                     }
168 
169                     // Giving SMS + Bonus (if any)
170                     Log(sendingSMSToken);
171                     if (!transferTokens(msg.sender, sendingSMSToken, sendingSMSBonus))
172                         revert();
173                 } else {
174                     // Revert if too few ETH for the first purchase
175                     revert();
176                 }
177             } else {
178                 // Revert for end phase
179                 revert();
180             }
181         } else {
182             // Revert for ICO Paused, Stopped
183             revert();
184         }
185     }
186 
187     // ======== Bonus Period 1 ========
188     // --- Bonus ---
189     // 0-9 SMS -> 5%
190     // 10-49 SMS -> 10%
191     // 50-99 SMS -> 20%
192     // 100~ SMS -> 30%
193     // --- Time --- (2 days 9 hours 59 minutes 59 seconds )
194     // From 27 Oct 2017, 14:00 PM JST (27 Oct 2017, 5:00 AM GMT)
195     // To   29 Oct 2017, 23:59 PM JST (29 Oct 2017, 14:59 PM GMT)
196     function start1BonusPeriod1() external onlyOwner {
197         // Supply setting (only once)
198         require(currentPhase == 0);
199 
200         balances[owner] = tokenSaleLot1; // Start balance for SpeedMining Co., Ltd.
201         balances[address(this)] = tokenSaleLot1;  // Start balance for SMSCoin (for investors)
202         totalSupply = balances[owner] + balances[address(this)];
203         saleCounterThisPhase = 0;
204         limitedSale = tokenSaleLot1;
205 
206         // Add owner address into the list as the first wallet who own token(s)
207         addAddress(owner);
208 
209         // Send owner account the initial tokens (rather than only a contract address)
210         Transfer(address(this), owner, balances[owner]);
211 
212         // Set draining is needed
213         needToDrain = true;
214 
215         // ICO stage init
216         icoOnSale = true;
217         icoOnPaused = false;
218         spPhase = false;
219         currentPhase = 1;
220         startDate = block.timestamp;
221         endDate = startDate + 2 days + 9 hours + 59 minutes + 59 seconds;
222 
223         // Bonus setting 
224         setBonus(5, 10, 20, 30);
225     }
226 
227     // ======== Bonus Period 2 ========
228     // --- Bonus ---
229     // 0-9 SMS -> 3%
230     // 10-49 SMS -> 5%
231     // 50-99 SMS -> 10%
232     // 100~ SMS -> 15%
233     // --- Time --- (11 days 9 hours 59 minutes 59 seconds)
234     // From 30 Oct 2017, 14:00 PM JST (30 Oct 2017, 5:00 AM GMT)
235     // To   10 Nov 2017, 23:59 PM JST (10 Nov 2017, 14:59 PM GMT)
236     function start2BonusPeriod2() external onlyOwner {
237         // ICO stage init
238         icoOnSale = true;
239         icoOnPaused = false;
240         spPhase = false;
241         currentPhase = 2;
242         startDate = block.timestamp;
243         endDate = startDate + 11 days + 9 hours + 59 minutes + 59 seconds;
244 
245         // Bonus setting 
246         setBonus(3, 5, 10, 15);
247     }
248 
249     // ======== Bonus Period 3 ========
250     // --- Bonus ---
251     // 0-9 SMS -> 1%
252     // 10-49 SMS -> 3%
253     // 50-99 SMS -> 5%
254     // 100~ SMS -> 8%
255     // --- Time --- (50 days, 5 hours, 14 minutes and 59 seconds)
256     // From 11 Nov 2017, 18:45 PM JST (11 Nov 2017, 09:45 AM GMT) (hardfork maintenance 00:00-18:45 JST)
257     // To   31 Dec 2017, 23:59 PM JST (31 Dec 2017, 14:59 PM GMT)
258     function start3BonusPeriod3() external onlyOwner {
259         // ICO stage init
260         icoOnSale = true;
261         icoOnPaused = false;
262         spPhase = false;
263         currentPhase = 3;
264         startDate = block.timestamp;
265         endDate = startDate + 50 days + 5 hours + 14 minutes + 59 seconds;
266 
267         // Bonus setting 
268         setBonus(1, 3, 5, 8);
269     }
270 
271     // ======== Normal Period 1 (2018) ========
272     // --- Time --- (31 days)
273     // From 1 Jan 2018, 00:00 AM JST (31 Dec 2017, 15:00 PM GMT)
274     // To   31 Jan 2018, 23:59 PM JST (31 Jan 2018, 14:59 PM GMT)
275     function start4NormalPeriod() external onlyOwner {
276         // ICO stage init
277         icoOnSale = true;
278         icoOnPaused = false;
279         spPhase = false;
280         currentPhase = 4;
281         startDate = block.timestamp;
282         endDate = startDate + 31 days;
283 
284         // Reset bonus
285         setBonus(0, 0, 0, 0);
286     }
287 
288     // ======== Normal Period 2 (2020) ========
289     // --- Bonus ---
290     // 3X
291     // --- Time --- (7 days)
292     // From 2 Jan 2020, 00:00 AM JST (1 Jan 2020, 15:00 PM GMT)
293     // To   8 Jan 2020, 23:59 PM JST (8 Oct 2020, 14:59 PM GMT)
294 
295     // ======== Normal Period 3 (2025) ========
296     // --- Bonus ---
297     // 3X
298     // --- Time --- (7 days)
299     // From 2 Jan 2025, 00:00 AM JST (1 Jan 2025, 15:00 PM GMT)
300     // To   8 Jan 2025, 23:59 PM JST (8 Oct 2025, 14:59 PM GMT)
301     function start3XPhase() external onlyOwner {
302         // Supply setting (only after phase 4 or 5)
303         require(currentPhase == 4 || currentPhase == 5);
304             
305         // Please drain SMS if it was not done yet
306         require(!needToDrain);
307             
308         balances[address(this)] = tokenSaleLot3X;
309         totalSupply = 3 * totalSupply;
310         totalSupply += balances[address(this)];
311         saleCounterThisPhase = 0;
312         limitedSale = tokenSaleLot3X;
313 
314         // Bonus
315         x3Token(); // 3X distributions to token holders
316 
317         // Mint new tokens
318         Transfer(mint, address(this), balances[address(this)]);
319         
320         // Set draining is needed
321         needToDrain = true;
322         
323         // ICO stage init
324         icoOnSale = true;
325         icoOnPaused = false;
326         spPhase = false;
327         currentPhase = 5;
328         startDate = block.timestamp;
329         endDate = startDate + 7 days;
330     }
331 
332     // Selling from the available tokens (on owner wallet) that we collected after each sale end
333     // Amount is including full digit
334     function startManualPeriod(uint _saleToken) external onlyOwner {
335         // Supply setting
336 
337         // Require enough token from owner to be sold on manual phase        
338         require(balances[owner] >= _saleToken);
339         
340         // Please drain SMS if it was not done yet
341         require(!needToDrain);
342 
343         // Transfer sale amount to SMS
344         balances[owner] -= _saleToken;
345         balances[address(this)] += _saleToken;
346         saleCounterThisPhase = 0;
347         limitedSale = _saleToken;
348         Transfer(owner, address(this), _saleToken);
349         
350         // Set draining is needed
351         needToDrain = true;
352         
353         // ICO stage init
354         icoOnSale = true;
355         icoOnPaused = false;
356         spPhase = true;
357         startDate = block.timestamp;
358         endDate = startDate + 7 days; // Default running manual mode for 7 days
359     }
360 
361     function x3Token() private {
362         // Multiply token by 3 to all the current addresses
363         for (uint i = 0; i < addresses.length; i++) {
364             uint curr1XBalance = balances[addresses[i]];
365             // In total 3X, then also calculate value to balances
366             balances[addresses[i]] = 3 * curr1XBalance;
367             // Transfer 2X from Mint to add with the existing 1X
368             Transfer(mint, addresses[i], 2 * curr1XBalance);
369             // To keep tracking bonus distribution
370             sentBonus += (2 * curr1XBalance);
371         }
372     }
373 
374     // Called by the owner, to end the current phase and mark as burnable		
375     function endPhase() external onlyOwner {
376         icoOnSale = false;
377         icoOnPaused = true;
378     }
379 
380     // Called by the owner, to emergency pause the current phase
381     function pausePhase() external onlyOwner {
382         icoOnPaused = true;
383     }
384 
385     // Called by the owner, to resumes the ended/paused phase
386     function resumePhase() external onlyOwner {
387         icoOnSale = true;
388         icoOnPaused = false;
389     }
390 
391     // Called by the owner, to extend deadline (usually for special phase mode)
392     function extend1Week() external onlyOwner {
393         endDate += 7 days;
394     }
395 
396     // Standard interface
397     function totalSupply() public constant returns(uint256 _totalSupply) {
398         return totalSupply;
399     }
400 
401     function balanceOf(address sender) public constant returns(uint256 balance) {
402         return balances[sender];
403     }
404 
405     function soldToken() public constant returns(uint256 _soldToken) {
406         return soldToken;
407     }
408 
409     function sentBonus() public constant returns(uint256 _sentBonus) {
410         return sentBonus;
411     }
412 
413     function saleCounterThisPhase() public constant returns(uint256 _saleCounter) {
414         return saleCounterThisPhase;
415     }
416 
417     // Price should be entered in multiple of 10000's
418     // E.g. for .0001 ether enter 1, for 5 ether price enter 50000
419     function setTokenPrice(uint ethRate) external onlyOwner {
420         tokenPrice = (ethRate * 10 ** 18) / 10000; // (Convert to ether unit then make 4 decimals for ETH)
421     }
422 
423     function setMembershipPrice(uint ethRate) external onlyOwner {
424         firstMembershipPurchase = (ethRate * 10 ** 18) / 10000; // (Convert to ether unit then make 4 decimals for ETH)
425     }
426 
427     // Transfer the SMS balance from caller's wallet address to target's wallet address
428     function transfer(address _to, uint256 _amount) public returns(bool success) {
429         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
430 
431             balances[msg.sender] -= _amount;
432             balances[_to] += _amount;
433             Transfer(msg.sender, _to, _amount);
434 
435             // Add destination wallet address to the list
436             addAddress(_to);
437 
438             return true;
439         } else {
440             return false;
441         }
442     }
443 
444     // Transfer the SMS balance from specific wallet address to target's wallet address
445     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success) {
446         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
447                 
448             balances[_from] -= _amount;
449             allowed[_from][msg.sender] -= _amount;
450             balances[_to] += _amount;
451             Transfer(_from, _to, _amount);
452             return true;
453         } else {
454             return false;
455         }
456     }
457 
458     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
459     // If this function is called again it overwrites the current allowance with _value.
460     function approve(address _spender, uint256 _amount) public returns(bool success) {
461         allowed[msg.sender][_spender] = _amount;
462         Approval(msg.sender, _spender, _amount);
463         return true;
464     }
465 
466     // Checking allowance
467     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
468         return allowed[_owner][_spender];
469     }
470 
471     // Transfer the SMS balance from SMS's contract address to an investor's wallet account
472     function transferTokens(address _to, uint256 _amount, uint256 _bonus) private returns(bool success) {
473         if (_amount > 0 && balances[address(this)] >= _amount && balances[address(this)] - _amount >= 0 && soldToken + _amount > soldToken && saleCounterThisPhase + _amount <= limitedSale && balances[_to] + _amount > balances[_to]) {
474             
475             // Transfer token from contract to target
476             balances[address(this)] -= _amount;
477             soldToken += _amount;
478             saleCounterThisPhase += _amount;
479             balances[_to] += _amount;
480             Transfer(address(this), _to, _amount);
481             
482             // Transfer bonus token from owner to target
483             if (currentPhase <= 3 && _bonus > 0 && balances[owner] - _bonus >= 0 && sentBonus + _bonus > sentBonus && sentBonus + _bonus <= reservedBonusLot1 && balances[_to] + _bonus > balances[_to]) {
484 
485                 // Transfer with bonus
486                 balances[owner] -= _bonus;
487                 sentBonus += _bonus;
488                 balances[_to] += _bonus;
489                 Transfer(owner, _to, _bonus);
490             }
491 
492             // Add investor wallet address to the list
493             addAddress(_to);
494 
495             return true;
496         } else {
497             return false;
498         }
499     }
500 
501     // Function to give token to investors
502     // Will be used to initialize the number of token and number of bonus after migration
503     // Also investor can buy token from thridparty channel then owner will run this function
504     // Amount and bonus both including full digit
505     function giveAways(address _to, uint256 _amount, uint256 _bonus) external onlyOwner {
506         // Calling internal transferTokens
507         if (!transferTokens(_to, _amount, _bonus))
508             revert();
509     }
510 
511     // Token bonus reward will be given to investor on each sale end
512     // This bonus part will be transferred from the company
513     // Bonus will be given to the one who has paid membership (0.16 ETH or holding minimum of 0.2 SMS)
514     // Amount is including full digit
515     function giveReward(uint256 _amount) external onlyOwner {
516         // Checking if amount is available and had sold some token
517         require(balances[owner] >= _amount);
518 
519         uint totalInvestorHand = 0;
520         // ------------ Sum up all investor token
521         for (uint idx = 0; idx < investorAddresses.length; idx++) {
522             if (checkMinBalance(investorAddresses[idx]))
523                 totalInvestorHand += balances[investorAddresses[idx]];
524         }
525         uint valuePerToken = _amount * UNIT / totalInvestorHand;
526 
527         // ------------ Giving Reward ------------
528         for (idx = 0; idx < investorAddresses.length; idx++) {
529             if (checkMinBalance(investorAddresses[idx])) {
530                 uint bonusForThisInvestor = balances[investorAddresses[idx]] * valuePerToken / UNIT;
531                 sentBonus += bonusForThisInvestor;
532                 balances[owner] -= bonusForThisInvestor;
533                 balances[investorAddresses[idx]] += bonusForThisInvestor;
534                 Transfer(owner, investorAddresses[idx], bonusForThisInvestor);
535             }
536         }
537     }
538 
539     // Check wallet address if exist
540     function checkAddress(address _addr) public constant returns(bool exist) {
541         return userStructs[_addr] == _addr;
542     }
543 
544     // Check if minBalance is enough
545     function checkMinBalance(address _addr) public constant returns(bool enough) {
546         return balances[_addr] >= (firstMembershipPurchase * 10000 / tokenPrice * UNIT / 10000);
547     }
548     
549     // Add wallet address with existing check
550     function addAddress(address _to) private {
551         if (addresses.length > 0) {
552             if (userStructs[_to] != _to) {
553                 userStructs[_to] = _to;
554                 // Adding all addresses
555                 addresses.push(_to);
556                 // Adding investor addresses
557                 if (_to != address(this) && _to != owner)
558                     investorAddresses.push(_to);
559             }
560         } else {
561             userStructs[_to] = _to;
562             // Adding all addresses
563             addresses.push(_to);
564             // Adding investor addresses
565             if (_to != address(this) && _to != owner)
566                 investorAddresses.push(_to);
567         }
568     }
569 
570     // Drain all the available ETH from the contract back to owner's wallet
571     function drainETH() external onlyOwner {
572         owner.transfer(this.balance);
573     }
574 
575     // Drain all the available SMS from the contract back to owner's wallet
576     // This will drain only the available token up to the current phase
577     function drainSMS() external onlyOwner {
578         // Only allowed to be executed after endPhase
579         require(!icoOnSale);
580 
581         // Allow to drain SMS and SMS Bonus back to owner only on Phase 4, 5, 6
582         if (currentPhase >= 4 || spPhase) {
583             // Drain all available SMS
584             // From SMS contract
585             if (balances[address(this)] > 0) {
586                 balances[owner] += balances[address(this)];
587                 Transfer(address(this), owner, balances[address(this)]);
588                 balances[address(this)] = 0;
589 
590                 // Clear draining status
591                 needToDrain = false;
592             }
593         }
594     }
595 
596     // Manual burning function
597     // Force to burn it in some situation
598     // Amount is including decimal points
599     function hardBurnSMS(address _from, uint _amount) external onlyOwner {
600         // Burning from source address
601         if (balances[_from] > 0) {
602             balances[_from] -= _amount;
603             totalSupply -= _amount;
604             Transfer(_from, genesis, _amount);
605         }
606     }
607 
608     // Function used in Reward contract to know address of token holder
609     function getAddress(uint i) public constant returns(address) {
610         return addresses[i];
611     }
612 
613     // Function used in Reward contract to get to know the address array length
614     function getAddressSize() public constant returns(uint) {
615         return addresses.length;
616     }
617 }