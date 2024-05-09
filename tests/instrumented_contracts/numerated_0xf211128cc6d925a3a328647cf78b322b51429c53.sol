1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier - Full Stack Blockchain Developer
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 /*
10     CHANGELOGS:
11     . Round 0: 10% bonus for old invester (with limit based on total dividends income in version 1) -- REMOVED by Seizo
12     . Round 0: start price 0.0014 ether, Min. duration 3 days, 30% to Pot, 70% hold for token selling -- REMOVED by Seizo
13     . Round 0: premine function, claim free tokens based on F2M v1 Dividends -- REMOVED by Seizo
14     . BEFORE_SLEEP_DURAION = 30 * ONE_DAY ( Last round must be greater than 28)
15 
16     BUGS FIXED:
17     . SwapToken function : update credit after tokens selling
18     . Referral by token reinvest
19     . Tokenholders tracking on etherscan (emit transfer in mint-, burn-token functions)
20 
21 */
22 
23 contract F2m{
24     using SafeMath for *;
25 
26     modifier onlyTokenHolders() {
27         require(balances[msg.sender] > 0, "not own any token");
28         _;
29     }
30     
31     modifier onlyAdmin(){
32         require(msg.sender == devTeam, "admin required");
33         _;
34     }
35 
36     modifier withdrawRight(){
37         require((msg.sender == address(bankContract)), "Bank Only");
38         _;
39     }
40 
41     modifier swapNotActived() {
42         require(swapActived == false, "swap actived, stop minting new tokens");
43         _;
44     }
45 
46     modifier buyable() {
47         require(buyActived == true, "token sale not ready");
48         _;
49     }
50 
51     // modifier premineable() {
52     //     require(buyActived == false && investedAmount == 0, "token sale already");
53     //     _;
54     // }
55     
56     /*==============================
57     =            EVENTS            =
58     ==============================*/  
59     // ERC20
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62     
63     /*=====================================
64     =                 ERC20               =
65     =====================================*/
66     uint256 public totalSupply;  
67     string public name;  
68     string public symbol;  
69     uint32 public decimals;
70     uint256 public unitRate;
71     // Balances for each account
72     mapping(address => uint256) balances;
73  
74     // Owner of account approves the transfer of an amount to another account
75     mapping(address => mapping (address => uint256)) allowed;
76     
77    /*================================
78     =            DATASETS            =
79     ================================*/
80     CitizenInterface public citizenContract;
81     LotteryInterface public lotteryContract;
82     BankInterface public bankContract;
83     NewTokenInterface public newTokenContract;
84     WhitelistInterface public whitelistContract;
85 
86     uint256 constant public ONE_HOUR= 3600;
87     uint256 constant public ONE_DAY = 24 * ONE_HOUR; // seconds
88     // uint256 constant public FIRST_POT_MAXIMUM = 200 ether;
89     // uint256 constant public ROUND0_MIN_DURATION = 3 * ONE_DAY; // minimum
90     uint256 constant public BEFORE_SLEEP_DURAION = 30 * ONE_DAY;
91 
92     uint256 public HARD_TOTAL_SUPPLY = 8000000;
93 
94     uint256 public refPercent = 15;
95     uint256 public divPercent = 10;
96     uint256 public fundPercent = 2;
97     // uint256 public potPercent = 30; // set to 0 in func disableRound0()
98 
99     //Start Price
100     uint256 public startPrice = 0.0014 ether;
101     //Most Tolerable Break-Even Period (MTBEP)
102     uint256 constant public BEP = 30;
103 
104     // amount of shares for each address (scaled number)
105     mapping(address => int256) public credit;
106     mapping(address => uint256) public withdrawnAmount;
107     mapping(address => uint256) public fromSellingAmount;
108 
109     mapping(address => uint256) public lastActiveDay;
110     mapping(address => int256) public todayCredit;
111 
112     mapping(address => uint256) public pInvestedSum;
113 
114     uint256 public investedAmount;
115     uint256 public totalBuyVolume;
116     uint256 public totalSellVolume;
117     uint256 public totalDividends;
118     mapping(uint256 => uint256) public totalDividendsByRound;
119 
120     //Profit Per Share 
121     uint256 public pps = 0;
122 
123     //log by round
124     mapping(uint256 => uint256) rPps;
125     mapping(address => mapping (uint256 => int256)) rCredit; 
126 
127     // uint256 public deployedTime;
128     uint256 public deployedDay;
129 
130     // on/off auto buy Token
131     bool public autoBuy = false;
132 
133     bool public round0 = false; //raise for first round
134 
135     //pps added in day
136     mapping(uint256 => uint256) public ppsInDay; //Avarage pps in a day
137     mapping(uint256 => uint256) public divInDay;
138     mapping(uint256 => uint256) public totalBuyVolumeInDay;
139     mapping(uint256 => uint256) public totalSellVolumeInDay;
140 
141     address public devTeam; //Smart contract address
142 
143     uint256 public swapTime;
144     bool public swapActived = false;
145     bool public buyActived = false;
146 
147     /*=======================================
148     =            PUBLIC FUNCTIONS            =
149     =======================================*/
150     constructor (address _devTeam)
151         public
152     {
153         symbol = "F2M2";  
154         name = "Fomo2Moon2";  
155         decimals = 10;
156         unitRate = 10**uint256(decimals);
157         HARD_TOTAL_SUPPLY = HARD_TOTAL_SUPPLY * unitRate;
158         DevTeamInterface(_devTeam).setF2mAddress(address(this));
159         devTeam = _devTeam;
160         // manuell airdrops to old investers
161         uint256 _amount = 500000 * unitRate;
162         totalSupply += _amount;
163         balances[devTeam] = _amount;
164         emit Transfer(0x0, devTeam, _amount);
165         deployedDay = getToday();
166     }
167 
168     // function premine() 
169     //     public
170     //     premineable()
171     // {
172     //     address _sender = msg.sender;
173     //     require(balances[_sender] == 0, "already claimed");
174     //     uint256 _amount = whitelistContract.getPremintAmount(_sender);
175     //     totalSupply += _amount;
176     //     balances[_sender] = _amount;
177     //     emit Transfer(0x0, _sender, _amount);
178     // }
179 
180     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
181     function joinNetwork(address[6] _contract)
182         public
183     {
184         require(address(citizenContract) == 0x0, "already setup");
185         bankContract = BankInterface(_contract[1]);
186         citizenContract = CitizenInterface(_contract[2]);
187         lotteryContract = LotteryInterface(_contract[3]);
188         whitelistContract = WhitelistInterface(_contract[5]);
189     }
190  
191     function()
192         public
193         payable
194     {
195         // Thanks for Donation
196     }
197 
198     // one time called, manuell called in case not reached 360ETH for totalPot
199 /*     function disableRound0() 
200         public 
201         onlyAdmin() 
202     {
203         require(buyActived && block.timestamp > ROUND0_MIN_DURATION.add(deployedTime), "too early to disable Round0");
204         firstRoundPrepare();
205     } */
206 
207     function activeBuy()
208         public
209         onlyAdmin()
210     {
211         require(buyActived == false, "already actived");
212         buyActived = true;
213         deployedDay = getToday();
214     }
215 
216     // Dividends from all sources (DApps, Donate ...)
217     function pushDividends() 
218         public 
219         payable 
220     {
221         // shared to fund and dividends only
222         uint256 ethAmount = msg.value;
223         uint256 dividends = ethAmount * divPercent / (divPercent + fundPercent);
224         uint256 fund = ethAmount.sub(dividends);
225         uint256 _buyPrice = getBuyPrice();
226         // distributeTax(msg.sender, fund, dividends, 0, 0);
227         distributeTax(msg.sender, fund, dividends, 0);
228         if (autoBuy) devTeamAutoBuy(0, _buyPrice);
229     }
230 
231     function addFund(uint256 _fund)
232         private
233     {
234         credit[devTeam] = credit[devTeam].sub(int256(_fund));
235     }
236 
237     function addDividends(uint256 _dividends)
238         private
239     {
240         if (_dividends == 0) return;
241         totalDividends += _dividends;
242         uint256 today = getToday();
243         divInDay[today] = _dividends.add(divInDay[today]);
244 
245         if (totalSupply == 0) {
246             addFund(_dividends);
247         } else {
248             // increased profit with each token
249             // gib mir n bier
250             addFund(_dividends % totalSupply);
251             uint256 deltaShare = _dividends / totalSupply;
252             pps = pps.add(deltaShare);
253 
254             // logs
255             uint256 curRoundId = getCurRoundId();
256             rPps[curRoundId] += deltaShare;
257             totalDividendsByRound[curRoundId] += _dividends;
258             ppsInDay[today] = deltaShare + ppsInDay[today];
259         }
260     }
261 
262     function addToRef(address _sender, uint256 _toRef)
263         private
264     {
265         if (_toRef == 0) return;
266         citizenContract.pushRefIncome.value(_toRef)(_sender);
267     }
268 
269 /*     function addToPot(uint256 _toPot)
270         private
271     {
272         if (_toPot == 0) return;
273         lotteryContract.pushToPot.value(_toPot)();
274         uint256 _totalPot = lotteryContract.getTotalPot();
275 
276         // auto disable Round0 if reached 360ETH for first round
277         if (_totalPot >= FIRST_POT_MAXIMUM) {
278             firstRoundPrepare();
279         }
280     } */
281 
282 /*     function firstRoundPrepare()
283         private
284     {
285         round0 = false;
286         potPercent = 0;
287         refPercent = 15;
288         divPercent = 10;
289         fundPercent = 2;
290         startPrice = 0.002;
291     } */
292 
293     function distributeTax(
294         address _sender,
295         uint256 _fund,
296         uint256 _dividends,
297         uint256 _toRef)
298         // uint256 _toPot)
299         private
300     {
301         addFund(_fund);
302         addDividends(_dividends);
303         addToRef(_sender, _toRef);
304         //addToPot(_toPot);
305     }
306 
307     function updateCredit(address _owner, uint256 _currentEthAmount, uint256 _rDividends, uint256 _todayDividends) 
308         private 
309     {
310         // basicly to keep ethBalance not changed, after token balances changed (minted or burned)
311         // ethBalance = pps * tokens -credit
312         uint256 curRoundId = getCurRoundId();
313         credit[_owner] = int256(pps.mul(balances[_owner])).sub(int256(_currentEthAmount));
314         // logs
315         rCredit[_owner][curRoundId] = int256(rPps[curRoundId] * balances[_owner]) - int256(_rDividends);
316         todayCredit[_owner] = int256(ppsInDay[getToday()] * balances[_owner]) - int256(_todayDividends);
317     }
318 
319     function mintToken(address _buyer, uint256 _taxedAmount, uint256 _buyPrice) 
320         private 
321         swapNotActived()
322         buyable()
323         returns(uint256) 
324     {
325         uint256 revTokens = ethToToken(_taxedAmount, _buyPrice);
326         investedAmount = investedAmount.add(_taxedAmount);
327         // lottery ticket buy could be blocked without this
328         // the 1% from ticket buy will increases tokenSellPrice when totalSupply capped
329         if (revTokens + totalSupply > HARD_TOTAL_SUPPLY) 
330             revTokens = HARD_TOTAL_SUPPLY.sub(totalSupply);
331         balances[_buyer] = balances[_buyer].add(revTokens);
332         totalSupply = totalSupply.add(revTokens);
333         emit Transfer(0x0, _buyer, revTokens);
334         return revTokens;
335     }
336 
337     function burnToken(address _seller, uint256 _tokenAmount) 
338         private 
339         returns (uint256) 
340     {
341         require(balances[_seller] >= _tokenAmount, "not enough to burn");
342         uint256 revEthAmount = tokenToEth(_tokenAmount);
343         investedAmount = investedAmount.sub(revEthAmount);
344         balances[_seller] = balances[_seller].sub(_tokenAmount);
345         totalSupply = totalSupply.sub(_tokenAmount);
346         emit Transfer(_seller, 0x0, _tokenAmount);
347         return revEthAmount;
348     }
349 
350     function devTeamAutoBuy(uint256 _reserved, uint256 _buyPrice)
351         private
352     {
353         uint256 _refClaim = citizenContract.devTeamReinvest();
354         credit[devTeam] -= int256(_refClaim);
355         uint256 _ethAmount = ethBalance(devTeam);
356         if ((_ethAmount + _reserved) / _buyPrice + totalSupply > HARD_TOTAL_SUPPLY) return;
357 
358         uint256 _rDividends = getRDividends(devTeam);
359         uint256 _todayDividends = getTodayDividendsByAddress(devTeam);
360         mintToken(devTeam, _ethAmount, _buyPrice);
361         updateCredit(devTeam, 0, _rDividends, _todayDividends);
362     }
363 
364     function buy()
365         public
366         payable
367     {
368         address _buyer = msg.sender;
369         buyFor(_buyer);
370     }
371 
372 /*     function checkLimit(address _buyer)
373         private
374         view
375     {
376         require(!round0 || !whitelistContract.isLimited(_buyer, pInvestedSum[_buyer]), "Limited");
377     } */
378 
379     function buyFor(address _buyer) 
380         public 
381         payable
382     {
383         //ADD Round0 WHITE LIST
384         // tax = fund + dividends + toRef + toPot;
385         updateLastActive(_buyer);
386         uint256 _buyPrice = getBuyPrice();
387         uint256 ethAmount = msg.value;
388         pInvestedSum[_buyer] += ethAmount;
389         // checkLimit(_buyer);
390         uint256 onePercent = ethAmount / 100;
391         uint256 fund = onePercent.mul(fundPercent);
392         uint256 dividends = onePercent.mul(divPercent);
393         uint256 toRef = onePercent.mul(refPercent);
394         // uint256 toPot = onePercent.mul(potPercent);
395         // uint256 tax = fund + dividends + toRef + toPot;
396         uint256 tax = fund + dividends + toRef;
397         uint256 taxedAmount = ethAmount.sub(tax);
398         
399         totalBuyVolume = totalBuyVolume + ethAmount;
400         totalBuyVolumeInDay[getToday()] += ethAmount;
401 
402         // distributeTax(_buyer, fund, dividends, toRef, toPot);
403         distributeTax(_buyer, fund, dividends, toRef);
404         if (autoBuy) devTeamAutoBuy(taxedAmount, _buyPrice);
405 
406         uint256 curEthBalance = ethBalance(_buyer);
407         uint256 _rDividends = getRDividends(_buyer);
408         uint256 _todayDividends = getTodayDividendsByAddress(_buyer);
409 
410         mintToken(_buyer, taxedAmount, _buyPrice);
411         updateCredit(_buyer, curEthBalance, _rDividends, _todayDividends);
412     }
413 
414     function sell(uint256 _tokenAmount)
415         public
416         onlyTokenHolders()
417     {
418         // tax = fund only
419         updateLastActive(msg.sender);
420         address seller = msg.sender;
421         uint256 curEthBalance = ethBalance(seller);
422         uint256 _rDividends = getRDividends(seller);
423         uint256 _todayDividends = getTodayDividendsByAddress(seller);
424 
425         uint256 ethAmount = burnToken(seller, _tokenAmount);
426         uint256 fund = ethAmount.mul(fundPercent) / 100;
427         uint256 taxedAmount = ethAmount.sub(fund);
428 
429         totalSellVolume = totalSellVolume + ethAmount;
430         totalSellVolumeInDay[getToday()] += ethAmount;
431         curEthBalance = curEthBalance.add(taxedAmount);
432         fromSellingAmount[seller] += taxedAmount;
433         
434         updateCredit(seller, curEthBalance, _rDividends, _todayDividends);
435         // distributeTax(msg.sender, fund, 0, 0, 0);
436         distributeTax(msg.sender, fund, 0, 0);
437     }
438 
439     function devTeamWithdraw()
440         public
441         returns(uint256)
442     {
443         address sender = msg.sender;
444         require(sender == devTeam, "dev. Team only");
445         uint256 amount = ethBalance(sender);
446         if (amount == 0) return 0;
447         credit[sender] += int256(amount);
448         withdrawnAmount[sender] = amount.add(withdrawnAmount[sender]);
449         devTeam.transfer(amount);
450         return amount;
451     }
452 
453     function withdrawFor(address sender)
454         public
455         withdrawRight()
456         returns(uint256)
457     {
458         uint256 amount = ethBalance(sender);
459         if (amount == 0) return 0;
460         credit[sender] = credit[sender].add(int256(amount));
461         withdrawnAmount[sender] = amount.add(withdrawnAmount[sender]);
462         bankContract.pushToBank.value(amount)(sender);
463         return amount;
464     }
465 
466     function updateAllowed(address _from, address _to, uint256 _tokenAmount)
467         private
468     {
469         require(balances[_from] >= _tokenAmount, "not enough to transfer");
470         if (_from != msg.sender)
471         allowed[_from][_to] = allowed[_from][_to].sub(_tokenAmount);
472     }
473     
474     function transferFrom(address _from, address _to, uint256 _tokenAmount)
475         public
476         returns(bool)
477     {   
478         updateAllowed(_from, _to, _tokenAmount);
479         updateLastActive(_from);
480         updateLastActive(_to);
481 
482         uint256 curEthBalance_from = ethBalance(_from);
483         uint256 _rDividends_from = getRDividends(_from);
484         uint256 _todayDividends_from = getTodayDividendsByAddress(_from);
485 
486         uint256 curEthBalance_to = ethBalance(_to);
487         uint256 _rDividends_to = getRDividends(_to);
488         uint256 _todayDividends_to = getTodayDividendsByAddress(_to);
489 
490         uint256 taxedTokenAmount = _tokenAmount;
491         balances[_from] -= taxedTokenAmount;
492         balances[_to] += taxedTokenAmount;
493         updateCredit(_from, curEthBalance_from, _rDividends_from, _todayDividends_from);
494         updateCredit(_to, curEthBalance_to, _rDividends_to, _todayDividends_to);
495         // fire event
496         emit Transfer(_from, _to, taxedTokenAmount);
497         
498         return true;
499     }
500 
501     function transfer(address _to, uint256 _tokenAmount)
502         public 
503         returns (bool) 
504     {
505         transferFrom(msg.sender, _to, _tokenAmount);
506         return true;
507     }
508 
509     function approve(address spender, uint tokens) 
510         public 
511         returns (bool success) 
512     {
513         allowed[msg.sender][spender] = tokens;
514         emit Approval(msg.sender, spender, tokens);
515         return true;
516     }
517 
518     function updateLastActive(address _sender) 
519         private
520     {
521         if (lastActiveDay[_sender] != getToday()) {
522             lastActiveDay[_sender] = getToday();
523             todayCredit[_sender] = 0;
524         }
525     }
526     
527     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
528 
529     function setAutoBuy() 
530         public
531         onlyAdmin()
532     {
533         autoBuy = !autoBuy;
534     }
535 
536     /*----------  HELPERS AND CALCULATORS  ----------*/
537     function totalEthBalance()
538         public
539         view
540         returns(uint256)
541     {
542         return address(this).balance;
543     }
544     
545     function ethBalance(address _address)
546         public
547         view
548         returns(uint256)
549     {
550         return (uint256) ((int256)(pps.mul(balances[_address])).sub(credit[_address]));
551     }
552 
553     function getTotalDividendsByAddress(address _invester)
554         public
555         view
556         returns(uint256)
557     {
558         return (ethBalance(_invester)) + (withdrawnAmount[_invester]) - (fromSellingAmount[_invester]);
559     }
560 
561     function getTodayDividendsByAddress(address _invester)
562         public
563         view
564         returns(uint256)
565     {
566         int256 _todayCredit = (getToday() == lastActiveDay[_invester]) ? todayCredit[_invester] : 0;
567         return (uint256) ((int256)(ppsInDay[getToday()] * balances[_invester]) - _todayCredit);
568     }
569     
570     /*==========================================
571     =            public FUNCTIONS            =
572     ==========================================*/
573 
574     /**
575      * Return the sell price of 1 individual token.
576      */
577     function getSellPrice() 
578         public 
579         view 
580         returns(uint256)
581     {
582         if (totalSupply == 0) {
583             return 0;
584         } else {
585             return investedAmount / totalSupply;
586         }
587     }
588 
589     function getSellPriceAfterTax() 
590         public 
591         view 
592         returns(uint256)
593     {
594         uint256 _sellPrice = getSellPrice();
595         uint256 taxPercent = fundPercent;
596         return _sellPrice * (100 - taxPercent) / 100;
597     }
598     
599     /**
600      * Return the buy price of 1 individual token.
601      * Start Price + (7-day Average Dividend Payout) x BEP x HARD_TOTAL_SUPPLY / (Total No. of Circulating Tokens) / (HARD_TOTAL_SUPPLY - Total No. of Circulating Tokens + 1)
602      */
603     function getBuyPrice() 
604         public 
605         view 
606         returns(uint256)
607     {
608         // average profit per share of a day in week
609         // uint256 taxPercent = fundPercent + potPercent + divPercent + refPercent;
610         uint256 taxPercent = fundPercent + divPercent + refPercent;
611         //if (round0) return startPrice * (100 - taxPercent) / 100 / unitRate;
612         uint256 avgPps = getAvgPps();
613         uint256 _sellPrice = getSellPrice();
614         uint256 _buyPrice = (startPrice / unitRate + avgPps * BEP * HARD_TOTAL_SUPPLY / (HARD_TOTAL_SUPPLY + unitRate - totalSupply)) * (100 - taxPercent) / 100;
615         uint256 _min = _sellPrice * 14 / 10;
616         if (_buyPrice < _min) return _min;
617         return _buyPrice;
618     }
619 
620     function getBuyPriceAfterTax()
621         public 
622         view 
623         returns(uint256)
624     {
625         // average profit per share of a day in week
626         uint256 _buyPrice = getBuyPrice();
627         // uint256 taxPercent = fundPercent + potPercent + divPercent + refPercent;
628         uint256 taxPercent = fundPercent + divPercent + refPercent;
629         return _buyPrice * 100 / (100 - taxPercent);
630     }
631 
632     function ethToToken(uint256 _ethAmount, uint256 _buyPrice)
633         public
634         view
635         returns(uint256)
636     {
637         // v1 limit _ethAmount > 1.001 * 0.7 = 0.7007 ether
638         // only v1 invester _ethAmount > 0.7007 (after tax), bonus 10% token
639         uint256 revToken = _ethAmount / _buyPrice;
640 /*         if ((round0) && (_ethAmount > 0.7007 ether)) {
641             revToken = revToken * 11 / 10;
642         } */
643         return revToken;
644     }
645     
646     function tokenToEth(uint256 _tokenAmount)
647         public
648         view
649         returns(uint256)
650     {
651         uint256 sellPrice = getSellPrice();
652         return _tokenAmount.mul(sellPrice);
653     }
654     
655     function getToday() 
656         public 
657         view 
658         returns (uint256) 
659     {
660         return (block.timestamp / ONE_DAY);
661     }
662 
663     //Avarage Profit per Share in last 7 Days
664     function getAvgPps() 
665         public 
666         view 
667         returns (uint256) 
668     {
669         uint256 divSum = 0;
670         uint256 _today = getToday();
671         uint256 _fromDay = _today - 6;
672         if (_fromDay < deployedDay) _fromDay = deployedDay;
673         for (uint256 i = _fromDay; i <= _today; i++) {
674             divSum = divSum.add(divInDay[i]);
675         }
676         if (totalSupply == 0) return 0;
677         return divSum / (_today + 1 - _fromDay) / totalSupply;
678     }
679 
680     function getTotalVolume() 
681         public
682         view
683         returns(uint256)
684     {
685         return totalBuyVolume + totalSellVolume;
686     }
687 
688     function getWeeklyBuyVolume() 
689         public
690         view
691         returns(uint256)
692     {
693         uint256 _total = 0;
694         uint256 _today = getToday();
695         for (uint256 i = _today; i + 7 > _today; i--) {
696             _total = _total + totalBuyVolumeInDay[i];
697         }
698         return _total;
699     }
700 
701     function getWeeklySellVolume() 
702         public
703         view
704         returns(uint256)
705     {
706         uint256 _total = 0;
707         uint256 _today = getToday();
708         for (uint256 i = _today; i + 7 > _today; i--) {
709             _total = _total + totalSellVolumeInDay[i];
710         }
711         return _total;
712     }
713 
714     function getWeeklyVolume()
715         public
716         view
717         returns(uint256)
718     {
719         return getWeeklyBuyVolume() + getWeeklySellVolume();
720     }
721 
722     function getTotalDividends()
723         public
724         view
725         returns(uint256)
726     {
727         return totalDividends;
728     }
729 
730     function getRDividends(address _invester)
731         public
732         view
733         returns(uint256)
734     {
735         uint256 curRoundId = getCurRoundId();
736         return uint256(int256(rPps[curRoundId] * balances[_invester]) - rCredit[_invester][curRoundId]);
737     }
738 
739     function getWeeklyDividends()
740         public
741         view
742         returns(uint256)
743     {
744         uint256 divSum = 0;
745         uint256 _today = getToday();
746         uint256 _fromDay = _today - 6;
747         if (_fromDay < deployedDay) _fromDay = deployedDay;
748         for (uint256 i = _fromDay; i <= _today; i++) {
749             divSum = divSum.add(divInDay[i]);
750         }
751         
752         return divSum;
753     }
754 
755     function getMarketCap()
756         public
757         view
758         returns(uint256)
759     {
760         return totalSupply.mul(getBuyPriceAfterTax());
761     }
762 
763     function totalSupply()
764         public
765         view
766         returns(uint)
767     {
768         return totalSupply;
769     }
770 
771     function balanceOf(address tokenOwner)
772         public
773         view
774         returns(uint256)
775     {
776         return balances[tokenOwner];
777     }
778 
779     function myBalance() 
780         public 
781         view 
782         returns(uint256)
783     {
784         return balances[msg.sender];
785     }
786 
787     function myEthBalance() 
788         public 
789         view 
790         returns(uint256) 
791     {
792         return ethBalance(msg.sender);
793     }
794 
795     function myCredit() 
796         public 
797         view 
798         returns(int256) 
799     {
800         return credit[msg.sender];
801     }
802 
803 /*     function getRound0MinDuration()
804         public
805         view
806         returns(uint256)
807     {
808         if (!round0) return 0;
809         if (block.timestamp > ROUND0_MIN_DURATION.add(deployedTime)) return 0;
810         return ROUND0_MIN_DURATION + deployedTime - block.timestamp;
811     }
812  */
813     // Lottery
814 
815     function getCurRoundId()
816         public
817         view
818         returns(uint256)
819     {
820         return lotteryContract.getCurRoundId();
821     }
822 
823     //SWAP TOKEN, PUBLIC SWAP_DURAION SECONDS BEFORE
824     function swapToken()
825         public
826         onlyTokenHolders()
827     {
828         require(swapActived, "swap not actived");
829         address _invester = msg.sender;
830         uint256 _tokenAmount = balances[_invester];
831         uint256 _ethAmount = ethBalance(_invester);
832         // burn all token
833         _ethAmount += burnToken(_invester, _tokenAmount);
834         updateCredit(_invester, 0, 0, 0);
835         // swapToken function in new contract accepts only sender = this old contract
836         newTokenContract.swapToken.value(_ethAmount)(_tokenAmount, _invester);
837     }
838 
839     // start swapping, disable buy
840     function setNewToken(address _newTokenAddress)
841         public
842         onlyAdmin()
843     {
844         bool _isLastRound = lotteryContract.isLastRound();
845         require(_isLastRound, "too early");
846         require(swapActived == false, "already set");
847         swapTime = block.timestamp;
848         swapActived = true;
849         newTokenContract = NewTokenInterface(_newTokenAddress);
850         autoBuy = false;
851     }
852 
853     // after 30 days from swapTime, devteam withdraw whole eth.
854     function sleep()
855         public
856     {
857         require(swapActived, "swap not actived");
858         require(swapTime + BEFORE_SLEEP_DURAION < block.timestamp, "too early");
859         uint256 _ethAmount = address(this).balance;
860         devTeam.transfer(_ethAmount);
861         //ICE
862     }
863 }
864 
865 /**
866  * @title SafeMath
867  * @dev Math operations with safety checks that revert on error
868  */
869 library SafeMath {
870     int256 constant private INT256_MIN = -2**255;
871 
872     /**
873     * @dev Multiplies two unsigned integers, reverts on overflow.
874     */
875     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
876         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
877         // benefit is lost if 'b' is also tested.
878         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
879         if (a == 0) {
880             return 0;
881         }
882 
883         uint256 c = a * b;
884         require(c / a == b);
885 
886         return c;
887     }
888 
889     /**
890     * @dev Multiplies two signed integers, reverts on overflow.
891     */
892     function mul(int256 a, int256 b) internal pure returns (int256) {
893         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
894         // benefit is lost if 'b' is also tested.
895         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
896         if (a == 0) {
897             return 0;
898         }
899 
900         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
901 
902         int256 c = a * b;
903         require(c / a == b);
904 
905         return c;
906     }
907 
908     /**
909     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
910     */
911     function div(uint256 a, uint256 b) internal pure returns (uint256) {
912         // Solidity only automatically asserts when dividing by 0
913         require(b > 0);
914         uint256 c = a / b;
915         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
916 
917         return c;
918     }
919 
920     /**
921     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
922     */
923     function div(int256 a, int256 b) internal pure returns (int256) {
924         require(b != 0); // Solidity only automatically asserts when dividing by 0
925         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
926 
927         int256 c = a / b;
928 
929         return c;
930     }
931 
932     /**
933     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
934     */
935     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
936         require(b <= a);
937         uint256 c = a - b;
938 
939         return c;
940     }
941 
942     /**
943     * @dev Subtracts two signed integers, reverts on overflow.
944     */
945     function sub(int256 a, int256 b) internal pure returns (int256) {
946         int256 c = a - b;
947         require((b >= 0 && c <= a) || (b < 0 && c > a));
948 
949         return c;
950     }
951 
952     /**
953     * @dev Adds two unsigned integers, reverts on overflow.
954     */
955     function add(uint256 a, uint256 b) internal pure returns (uint256) {
956         uint256 c = a + b;
957         require(c >= a);
958 
959         return c;
960     }
961 
962     /**
963     * @dev Adds two signed integers, reverts on overflow.
964     */
965     function add(int256 a, int256 b) internal pure returns (int256) {
966         int256 c = a + b;
967         require((b >= 0 && c >= a) || (b < 0 && c < a));
968 
969         return c;
970     }
971 
972     /**
973     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
974     * reverts when dividing by zero.
975     */
976     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
977         require(b != 0);
978         return a % b;
979     }
980 }
981 
982 interface CitizenInterface {
983  
984     function joinNetwork(address[6] _contract) public;
985     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
986     function devTeamWithdraw() public;
987 
988     /*----------  WRITE FUNCTIONS  ----------*/
989     function updateUsername(string _sNewUsername) public;
990     //Sources: Token contract, DApps
991     function pushRefIncome(address _sender) public payable;
992     function withdrawFor(address _sender) public payable returns(uint256);
993     function devTeamReinvest() public returns(uint256);
994 
995     /*----------  READ FUNCTIONS  ----------*/
996     function getRefWallet(address _address) public view returns(uint256);
997 }
998 
999 interface LotteryInterface {
1000     function joinNetwork(address[6] _contract) public;
1001     // call one time
1002     function activeFirstRound() public;
1003     // Core Functions
1004     function pushToPot() public payable;
1005     function finalizeable() public view returns(bool);
1006     // bounty
1007     function finalize() public;
1008     function buy(string _sSalt) public payable;
1009     function buyFor(string _sSalt, address _sender) public payable;
1010     //function withdraw() public;
1011     function withdrawFor(address _sender) public returns(uint256);
1012 
1013     function getRewardBalance(address _buyer) public view returns(uint256);
1014     function getTotalPot() public view returns(uint256);
1015     // EarlyIncome
1016     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
1017     // included claimed amount
1018     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
1019     function getCurRoundId() public view returns(uint256);
1020     // set endRound, prepare to upgrade new version
1021     function setLastRound(uint256 _lastRoundId) public;
1022     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
1023     function cashoutable(address _address) public view returns(bool);
1024     function isLastRound() public view returns(bool);
1025     function sBountyClaim(address _sBountyHunter) public returns(uint256);
1026 }
1027 
1028 interface DevTeamInterface {
1029     function setF2mAddress(address _address) public;
1030     function setLotteryAddress(address _address) public;
1031     function setCitizenAddress(address _address) public;
1032     function setBankAddress(address _address) public;
1033     function setRewardAddress(address _address) public;
1034     function setWhitelistAddress(address _address) public;
1035 
1036     function setupNetwork() public;
1037 }
1038 
1039 interface BankInterface {
1040     function joinNetwork(address[6] _contract) public;
1041     function pushToBank(address _player) public payable;
1042 }
1043 
1044 interface NewTokenInterface {
1045     function swapToken(uint256 _amount, address _invester) public payable;
1046 }
1047 
1048 interface WhitelistInterface {
1049     function joinNetwork(address[6] _contract) public;
1050     // function getPremintAmount(address _address) public view returns(uint256);
1051 }