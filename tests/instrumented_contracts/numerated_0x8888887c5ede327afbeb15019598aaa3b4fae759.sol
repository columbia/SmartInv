1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 interface WhitelistInterface {
10     function joinNetwork(address[6] _contract) public;
11     function isLimited(address _address, uint256 _invested) public view returns(bool);
12 }
13 
14 interface NewTokenInterface {
15     function swapToken(uint256 _amount, address _invester) public payable;
16 }
17 
18 interface BankInterface {
19     function joinNetwork(address[6] _contract) public;
20     // Core functions
21     function pushToBank(address _player) public payable;
22 }
23 
24 
25 interface DevTeamInterface {
26     function setF2mAddress(address _address) public;
27     function setLotteryAddress(address _address) public;
28     function setCitizenAddress(address _address) public;
29     function setBankAddress(address _address) public;
30     function setRewardAddress(address _address) public;
31     function setWhitelistAddress(address _address) public;
32 
33     function setupNetwork() public;
34 }
35 
36 interface LotteryInterface {
37     function joinNetwork(address[6] _contract) public;
38     // call one time
39     function activeFirstRound() public;
40     // Core Functions
41     function pushToPot() public payable;
42     function finalizeable() public view returns(bool);
43     // bounty
44     function finalize() public;
45     function buy(string _sSalt) public payable;
46     function buyFor(string _sSalt, address _sender) public payable;
47     //function withdraw() public;
48     function withdrawFor(address _sender) public returns(uint256);
49 
50     function getRewardBalance(address _buyer) public view returns(uint256);
51     function getTotalPot() public view returns(uint256);
52     // EarlyIncome
53     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
54     // included claimed amount
55     // function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
56     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
57     // function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
58     function getCurRoundId() public view returns(uint256);
59     // set endRound, prepare to upgrade new version
60     function setLastRound(uint256 _lastRoundId) public;
61     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
62     function cashoutable(address _address) public view returns(bool);
63     function isLastRound() public view returns(bool);
64 }
65 interface CitizenInterface {
66  
67     function joinNetwork(address[6] _contract) public;
68     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
69     function devTeamWithdraw() public;
70 
71     /*----------  WRITE FUNCTIONS  ----------*/
72     function updateUsername(string _sNewUsername) public;
73     //Sources: Token contract, DApps
74     function pushRefIncome(address _sender) public payable;
75     function withdrawFor(address _sender) public payable returns(uint256);
76     function devTeamReinvest() public returns(uint256);
77 
78     /*----------  READ FUNCTIONS  ----------*/
79     function getRefWallet(address _address) public view returns(uint256);
80 }
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     int256 constant private INT256_MIN = -2**255;
87 
88     /**
89     * @dev Multiplies two unsigned integers, reverts on overflow.
90     */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b);
101 
102         return c;
103     }
104 
105     /**
106     * @dev Multiplies two signed integers, reverts on overflow.
107     */
108     function mul(int256 a, int256 b) internal pure returns (int256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
117 
118         int256 c = a * b;
119         require(c / a == b);
120 
121         return c;
122     }
123 
124     /**
125     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
126     */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Solidity only automatically asserts when dividing by 0
129         require(b > 0);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
138     */
139     function div(int256 a, int256 b) internal pure returns (int256) {
140         require(b != 0); // Solidity only automatically asserts when dividing by 0
141         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
142 
143         int256 c = a / b;
144 
145         return c;
146     }
147 
148     /**
149     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
150     */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b <= a);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159     * @dev Subtracts two signed integers, reverts on overflow.
160     */
161     function sub(int256 a, int256 b) internal pure returns (int256) {
162         int256 c = a - b;
163         require((b >= 0 && c <= a) || (b < 0 && c > a));
164 
165         return c;
166     }
167 
168     /**
169     * @dev Adds two unsigned integers, reverts on overflow.
170     */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a);
174 
175         return c;
176     }
177 
178     /**
179     * @dev Adds two signed integers, reverts on overflow.
180     */
181     function add(int256 a, int256 b) internal pure returns (int256) {
182         int256 c = a + b;
183         require((b >= 0 && c >= a) || (b < 0 && c < a));
184 
185         return c;
186     }
187 
188     /**
189     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
190     * reverts when dividing by zero.
191     */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b != 0);
194         return a % b;
195     }
196 }
197 contract F2m{
198     using SafeMath for *;
199 
200     // only token holder
201 
202     modifier onlyTokenHolders() {
203         require(balances[msg.sender] > 0, "not own any token");
204         _;
205     }
206     
207     modifier onlyAdmin(){
208         require(msg.sender == devTeam, "admin required");
209         _;
210     }
211 
212     modifier withdrawRight(){
213         require((msg.sender == address(bankContract)), "Bank Only");
214         _;
215     }
216 
217     modifier swapNotActived() {
218         require(swapActived == false, "swap actived, stop minting new tokens");
219         _;
220     }
221 
222     modifier buyable() {
223         require(buyActived == true, "token sale not ready");
224         _;
225     }
226     
227     /*==============================
228     =            EVENTS            =
229     ==============================*/  
230     // ERC20
231     event Transfer(address indexed from, address indexed to, uint tokens);
232     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
233     
234     /*=====================================
235     =                 ERC20               =
236     =====================================*/
237     uint256 public totalSupply;  
238     string public name;  
239     string public symbol;  
240     uint32 public decimals;
241     uint256 public unitRate;
242     // Balances for each account
243     mapping(address => uint256) balances;
244  
245     // Owner of account approves the transfer of an amount to another account
246     mapping(address => mapping (address => uint256)) allowed;
247     
248    /*================================
249     =            DATASETS            =
250     ================================*/
251     CitizenInterface public citizenContract;
252     LotteryInterface public lotteryContract;
253     BankInterface public bankContract;
254     NewTokenInterface public newTokenContract;
255     WhitelistInterface public whitelistContract;
256 
257     uint256 constant public ONE_HOUR= 3600;
258     uint256 constant public ONE_DAY = 24 * ONE_HOUR; // seconds
259     uint256 constant public FIRST_POT_MAXIMUM = 360 ether; // 800 * 45%
260     uint256 constant public ROUND0_MIN_DURATION = ONE_DAY; // minimum
261     uint256 constant public SWAP_DURATION = 30 * ONE_DAY;
262     uint256 constant public BEFORE_SLEEP_DURAION = 7 * ONE_DAY;
263 
264     uint256 public HARD_TOTAL_SUPPLY = 8000000;
265 
266     uint256 constant public refPercent = 15;
267     uint256 constant public divPercent = 10;
268     uint256 constant public fundPercent = 2;
269 
270     //Start Price
271     uint256 constant public startPrice = 0.002 ether;
272     //Most Tolerable Break-Even Period (MTBEP)
273     uint256 constant public BEP = 30;
274 
275     uint256 public potPercent = 45; // set to 0 in func disableRound0()
276 
277     // amount of shares for each address (scaled number)
278     mapping(address => int256) public credit;
279     mapping(address => uint256) public withdrawnAmount;
280     mapping(address => uint256) public fromSellingAmount;
281 
282     mapping(address => uint256) public lastActiveDay;
283     mapping(address => int256) public todayCredit;
284 
285     mapping(address => uint256) public pInvestedSum;
286 
287     uint256 public investedAmount;
288     uint256 public totalBuyVolume;
289     uint256 public totalSellVolume;
290     uint256 public totalDividends;
291     mapping(uint256 => uint256) public totalDividendsByRound;
292 
293     //Profit Per Share 
294     uint256 public pps = 0;
295 
296     //log by round
297     mapping(uint256 => uint256) rPps;
298     mapping(address => mapping (uint256 => int256)) rCredit; 
299 
300     uint256 public deployedTime;
301     uint256 public deployedDay;
302 
303     // on/off auto buy Token
304     bool public autoBuy;
305 
306     bool public round0 = true; //raise for first round
307 
308     //pps added in day
309     mapping(uint256 => uint256) public ppsInDay; //Avarage pps in a day
310     mapping(uint256 => uint256) public divInDay;
311     mapping(uint256 => uint256) public totalBuyVolumeInDay;
312     mapping(uint256 => uint256) public totalSellVolumeInDay;
313 
314     address public devTeam; //Smart contract address
315 
316     uint256 public swapTime;
317     bool public swapActived = false;
318     bool public buyActived = false;
319 
320     /*=======================================
321     =            PUBLIC FUNCTIONS            =
322     =======================================*/
323     constructor (address _devTeam)
324         public
325     {
326         symbol = "F2M";  
327         name = "Fomo2Moon";  
328         decimals = 10;
329         unitRate = 10**uint256(decimals);
330         HARD_TOTAL_SUPPLY = HARD_TOTAL_SUPPLY * unitRate;
331         totalSupply = 0; 
332         //deployedTime = block.timestamp;
333         DevTeamInterface(_devTeam).setF2mAddress(address(this));
334         devTeam = _devTeam;
335         autoBuy = true;
336     }
337 
338     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
339     function joinNetwork(address[6] _contract)
340         public
341     {
342         require(address(citizenContract) == 0x0, "already setup");
343         bankContract = BankInterface(_contract[1]);
344         citizenContract = CitizenInterface(_contract[2]);
345         lotteryContract = LotteryInterface(_contract[3]);
346         whitelistContract = WhitelistInterface(_contract[5]);
347     }
348  
349     function()
350         public
351         payable
352     {
353         // Thanks for Donation
354     }
355 
356     // one time called, manuell called in case not reached 360ETH for totalPot
357     function disableRound0() 
358         public 
359         onlyAdmin() 
360     {
361         require(buyActived && block.timestamp > ROUND0_MIN_DURATION.add(deployedTime), "too early to disable Round0");
362         round0 = false;
363         potPercent = 0;
364     }
365 
366     function activeBuy()
367         public
368         onlyAdmin()
369     {
370         require(buyActived == false, "already actived");
371         buyActived = true;
372         deployedTime = block.timestamp;
373         deployedDay = getToday();
374     }
375 
376     // Dividends from all sources (DApps, Donate ...)
377     function pushDividends() 
378         public 
379         payable 
380     {
381         // shared to fund and dividends only
382         uint256 ethAmount = msg.value;
383         uint256 dividends = ethAmount * divPercent / (divPercent + fundPercent);
384         uint256 fund = ethAmount.sub(dividends);
385         uint256 _buyPrice = getBuyPrice();
386         distributeTax(fund, dividends, 0, 0);
387         if (autoBuy) devTeamAutoBuy(0, _buyPrice);
388     }
389 
390     function addFund(uint256 _fund)
391         private
392     {
393         credit[devTeam] = credit[devTeam].sub(int256(_fund));
394     }
395 
396     function addDividends(uint256 _dividends)
397         private
398     {
399         if (_dividends == 0) return;
400         totalDividends += _dividends;
401         uint256 today = getToday();
402         divInDay[today] = _dividends.add(divInDay[today]);
403 
404         if (totalSupply == 0) {
405             addFund(_dividends);
406         } else {
407             // increased profit with each token
408             // gib mir n bier
409             addFund(_dividends % totalSupply);
410             uint256 deltaShare = _dividends / totalSupply;
411             pps = pps.add(deltaShare);
412 
413             // logs
414             uint256 curRoundId = getCurRoundId();
415             rPps[curRoundId] += deltaShare;
416             totalDividendsByRound[curRoundId] += _dividends;
417             ppsInDay[today] = deltaShare + ppsInDay[today];
418         }
419     }
420 
421     function addToRef(uint256 _toRef)
422         private
423     {
424         if (_toRef == 0) return;
425         address sender = msg.sender;
426         citizenContract.pushRefIncome.value(_toRef)(sender);
427     }
428 
429     function addToPot(uint256 _toPot)
430         private
431     {
432         if (_toPot == 0) return;
433         lotteryContract.pushToPot.value(_toPot)();
434         uint256 _totalPot = lotteryContract.getTotalPot();
435 
436         // auto disable Round0 if reached 360ETH for first round
437         if (_totalPot >= FIRST_POT_MAXIMUM) {
438             round0 = false;
439             potPercent = 0;
440         }
441     }
442 
443     function distributeTax(
444         uint256 _fund,
445         uint256 _dividends,
446         uint256 _toRef,
447         uint256 _toPot)
448         private
449     {
450         addFund(_fund);
451         addDividends(_dividends);
452         addToRef(_toRef);
453         addToPot(_toPot);
454     }
455 
456     function updateCredit(address _owner, uint256 _currentEthAmount, uint256 _rDividends, uint256 _todayDividends) 
457         private 
458     {
459         // basicly to keep ethBalance not changed, after token balances changed (minted or burned)
460         // ethBalance = pps * tokens -credit
461         uint256 curRoundId = getCurRoundId();
462         credit[_owner] = int256(pps.mul(balances[_owner])).sub(int256(_currentEthAmount));
463         // logs
464         rCredit[_owner][curRoundId] = int256(rPps[curRoundId] * balances[_owner]) - int256(_rDividends);
465         todayCredit[_owner] = int256(ppsInDay[getToday()] * balances[_owner]) - int256(_todayDividends);
466     }
467 
468     function mintToken(address _buyer, uint256 _taxedAmount, uint256 _buyPrice) 
469         private 
470         swapNotActived()
471         buyable()
472         returns(uint256) 
473     {
474         uint256 revTokens = ethToToken(_taxedAmount, _buyPrice);
475         investedAmount = investedAmount.add(_taxedAmount);
476         // lottery ticket buy could be blocked without this
477         // the 1% from ticket buy will increases tokenSellPrice when totalSupply capped
478         if (revTokens + totalSupply > HARD_TOTAL_SUPPLY) 
479             revTokens = HARD_TOTAL_SUPPLY.sub(totalSupply);
480         balances[_buyer] = balances[_buyer].add(revTokens);
481         totalSupply = totalSupply.add(revTokens);
482         return revTokens;
483     }
484 
485     function burnToken(address _seller, uint256 _tokenAmount) 
486         private 
487         returns (uint256) 
488     {
489         require(balances[_seller] >= _tokenAmount, "not enough to burn");
490         uint256 revEthAmount = tokenToEth(_tokenAmount);
491         investedAmount = investedAmount.sub(revEthAmount);
492         balances[_seller] = balances[_seller].sub(_tokenAmount);
493         totalSupply = totalSupply.sub(_tokenAmount);
494         return revEthAmount;
495     }
496 
497     function devTeamAutoBuy(uint256 _reserved, uint256 _buyPrice)
498         private
499     {
500         uint256 _refClaim = citizenContract.devTeamReinvest();
501         credit[devTeam] -= int256(_refClaim);
502         uint256 _ethAmount = ethBalance(devTeam);
503         if ((_ethAmount + _reserved) / _buyPrice + totalSupply > HARD_TOTAL_SUPPLY) return;
504 
505         uint256 _rDividends = getRDividends(devTeam);
506         uint256 _todayDividends = getTodayDividendsByAddress(devTeam);
507         mintToken(devTeam, _ethAmount, _buyPrice);
508         updateCredit(devTeam, 0, _rDividends, _todayDividends);
509     }
510 
511     function buy()
512         public
513         payable
514     {
515         address _buyer = msg.sender;
516         buyFor(_buyer);
517     }
518 
519     function checkLimit(address _buyer)
520         private
521         view
522     {
523         require(!round0 || !whitelistContract.isLimited(_buyer, pInvestedSum[_buyer]), "Limited");
524     }
525 
526     function buyFor(address _buyer) 
527         public 
528         payable
529     {
530         //ADD Round0 WHITE LIST
531         // tax = fund + dividends + toRef + toPot;
532         updateLastActive(_buyer);
533         uint256 _buyPrice = getBuyPrice();
534         uint256 ethAmount = msg.value;
535         pInvestedSum[_buyer] += ethAmount;
536         checkLimit(_buyer);
537         uint256 onePercent = ethAmount / 100;
538         uint256 fund = onePercent.mul(fundPercent);
539         uint256 dividends = onePercent.mul(divPercent);
540         uint256 toRef = onePercent.mul(refPercent);
541         uint256 toPot = onePercent.mul(potPercent);
542         uint256 tax = fund + dividends + toRef + toPot;
543         uint256 taxedAmount = ethAmount.sub(tax);
544         
545         totalBuyVolume = totalBuyVolume + ethAmount;
546         totalBuyVolumeInDay[getToday()] += ethAmount;
547 
548         distributeTax(fund, dividends, toRef, toPot);
549         if (autoBuy) devTeamAutoBuy(taxedAmount, _buyPrice);
550 
551         uint256 curEthBalance = ethBalance(_buyer);
552         uint256 _rDividends = getRDividends(_buyer);
553         uint256 _todayDividends = getTodayDividendsByAddress(_buyer);
554 
555         mintToken(_buyer, taxedAmount, _buyPrice);
556         updateCredit(_buyer, curEthBalance, _rDividends, _todayDividends);
557     }
558 
559     function sell(uint256 _tokenAmount)
560         public
561         onlyTokenHolders()
562     {
563         // tax = fund only
564         updateLastActive(msg.sender);
565         address seller = msg.sender;
566         uint256 curEthBalance = ethBalance(seller);
567         uint256 _rDividends = getRDividends(seller);
568         uint256 _todayDividends = getTodayDividendsByAddress(seller);
569 
570         uint256 ethAmount = burnToken(seller, _tokenAmount);
571         uint256 fund = ethAmount.mul(fundPercent) / 100;
572         //uint256 tax = fund;
573         uint256 taxedAmount = ethAmount.sub(fund);
574 
575         totalSellVolume = totalSellVolume + ethAmount;
576         totalSellVolumeInDay[getToday()] += ethAmount;
577         curEthBalance = curEthBalance.add(taxedAmount);
578         fromSellingAmount[seller] += taxedAmount;
579         
580         updateCredit(seller, curEthBalance, _rDividends, _todayDividends);
581         distributeTax(fund, 0, 0, 0);
582     }
583 
584     function devTeamWithdraw()
585         public
586         returns(uint256)
587     {
588         address sender = msg.sender;
589         require(sender == devTeam, "dev. Team only");
590         uint256 amount = ethBalance(sender);
591         if (amount == 0) return 0;
592         credit[sender] += int256(amount);
593         withdrawnAmount[sender] = amount.add(withdrawnAmount[sender]);
594         devTeam.transfer(amount);
595         return amount;
596     }
597 
598     function withdrawFor(address sender)
599         public
600         withdrawRight()
601         returns(uint256)
602     {
603         uint256 amount = ethBalance(sender);
604         if (amount == 0) return 0;
605         credit[sender] = credit[sender].add(int256(amount));
606         withdrawnAmount[sender] = amount.add(withdrawnAmount[sender]);
607         bankContract.pushToBank.value(amount)(sender);
608         return amount;
609     }
610 
611     function updateAllowed(address _from, address _to, uint256 _tokenAmount)
612         private
613     {
614         require(balances[_from] >= _tokenAmount, "not enough to transfer");
615         if (_from != msg.sender)
616         allowed[_from][_to] = allowed[_from][_to].sub(_tokenAmount);
617     }
618     
619     function transferFrom(address _from, address _to, uint256 _tokenAmount)
620         public
621         returns(bool)
622     {   
623         updateAllowed(_from, _to, _tokenAmount);
624         updateLastActive(_from);
625         updateLastActive(_to);
626         // tax = 0
627 
628         uint256 curEthBalance_from = ethBalance(_from);
629         uint256 _rDividends_from = getRDividends(_from);
630         uint256 _todayDividends_from = getTodayDividendsByAddress(_from);
631 
632         uint256 curEthBalance_to = ethBalance(_to);
633         uint256 _rDividends_to = getRDividends(_to);
634         uint256 _todayDividends_to = getTodayDividendsByAddress(_to);
635 
636         uint256 taxedTokenAmount = _tokenAmount;
637         balances[_from] -= taxedTokenAmount;
638         balances[_to] += taxedTokenAmount;
639         updateCredit(_from, curEthBalance_from, _rDividends_from, _todayDividends_from);
640         updateCredit(_to, curEthBalance_to, _rDividends_to, _todayDividends_to);
641         // distributeTax(tax, 0, 0, 0);
642         // fire event
643         emit Transfer(_from, _to, taxedTokenAmount);
644         
645         return true;
646     }
647 
648     function transfer(address _to, uint256 _tokenAmount)
649         public 
650         returns (bool) 
651     {
652         transferFrom(msg.sender, _to, _tokenAmount);
653         return true;
654     }
655 
656     function approve(address spender, uint tokens) 
657         public 
658         returns (bool success) 
659     {
660         allowed[msg.sender][spender] = tokens;
661         emit Approval(msg.sender, spender, tokens);
662         return true;
663     }
664 
665     function updateLastActive(address _sender) 
666         private
667     {
668         if (lastActiveDay[_sender] != getToday()) {
669             lastActiveDay[_sender] = getToday();
670             todayCredit[_sender] = 0;
671         }
672     }
673     
674     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
675 
676     function setAutoBuy() 
677         public
678         onlyAdmin()
679     {
680         //require(buyActived && block.timestamp > ROUND0_MIN_DURATION.add(deployedTime), "too early to disable autoBuy");
681         autoBuy = !autoBuy;
682     }
683 
684     /*----------  HELPERS AND CALCULATORS  ----------*/
685     function totalEthBalance()
686         public
687         view
688         returns(uint256)
689     {
690         return address(this).balance;
691     }
692     
693     function ethBalance(address _address)
694         public
695         view
696         returns(uint256)
697     {
698         return (uint256) ((int256)(pps.mul(balances[_address])).sub(credit[_address]));
699     }
700 
701     function getTotalDividendsByAddress(address _invester)
702         public
703         view
704         returns(uint256)
705     {
706 
707         return (ethBalance(_invester)) + (withdrawnAmount[_invester]) - (fromSellingAmount[_invester]);
708     }
709 
710     function getTodayDividendsByAddress(address _invester)
711         public
712         view
713         returns(uint256)
714     {
715         int256 _todayCredit = (getToday() == lastActiveDay[_invester]) ? todayCredit[_invester] : 0;
716         return (uint256) ((int256)(ppsInDay[getToday()] * balances[_invester]) - _todayCredit);
717     }
718     
719     /*==========================================
720     =            public FUNCTIONS            =
721     ==========================================*/
722 
723     /**
724      * Return the sell price of 1 individual token.
725      */
726     function getSellPrice() 
727         public 
728         view 
729         returns(uint256)
730     {
731         if (totalSupply == 0) {
732             return 0;
733         } else {
734             return investedAmount / totalSupply;
735         }
736     }
737 
738     function getSellPriceAfterTax() 
739         public 
740         view 
741         returns(uint256)
742     {
743         uint256 _sellPrice = getSellPrice();
744         uint256 taxPercent = fundPercent;
745         return _sellPrice * (100 - taxPercent) / 100;
746     }
747     
748     /**
749      * Return the buy price of 1 individual token.
750      * Start Price + (7-day Average Dividend Payout) x BEP x HARD_TOTAL_SUPPLY / (Total No. of Circulating Tokens) / (HARD_TOTAL_SUPPLY - Total No. of Circulating Tokens + 1)
751      */
752     function getBuyPrice() 
753         public 
754         view 
755         returns(uint256)
756     {
757         // average profit per share of a day in week
758         uint256 taxPercent = fundPercent + potPercent + divPercent + refPercent;
759         if (round0) return startPrice * (100 - taxPercent) / 100 / unitRate;
760         uint256 avgPps = getAvgPps();
761         uint256 _sellPrice = getSellPrice();
762         uint256 _buyPrice = (startPrice / unitRate + avgPps * BEP * HARD_TOTAL_SUPPLY / (HARD_TOTAL_SUPPLY + unitRate - totalSupply)) * (100 - taxPercent) / 100;
763         if (_buyPrice < _sellPrice) return _sellPrice;
764         return _buyPrice;
765     }
766 
767     function getBuyPriceAfterTax()
768         public 
769         view 
770         returns(uint256)
771     {
772         // average profit per share of a day in week
773         uint256 _buyPrice = getBuyPrice();
774         uint256 taxPercent = fundPercent + potPercent + divPercent + refPercent;
775         return _buyPrice * 100 / (100 - taxPercent);
776     }
777 
778     function ethToToken(uint256 _ethAmount, uint256 _buyPrice)
779         public
780         pure
781         returns(uint256)
782     {
783         return _ethAmount / _buyPrice;
784     }
785 
786 /*     function ethToTokenRest(uint256 _ethAmount, uint256 _buyPrice)
787         public
788         pure
789         returns(uint256)
790     {
791         return _ethAmount % _buyPrice;
792     } */
793     
794     function tokenToEth(uint256 _tokenAmount)
795         public
796         view
797         returns(uint256)
798     {
799         uint256 sellPrice = getSellPrice();
800         return _tokenAmount.mul(sellPrice);
801     }
802     
803     function getToday() 
804         public 
805         view 
806         returns (uint256) 
807     {
808         return (block.timestamp / ONE_DAY);
809     }
810 
811     //Avarage Profit per Share in last 7 Days
812     function getAvgPps() 
813         public 
814         view 
815         returns (uint256) 
816     {
817         uint256 divSum = 0;
818         uint256 _today = getToday();
819         uint256 _fromDay = _today - 6;
820         if (_fromDay < deployedDay) _fromDay = deployedDay;
821         for (uint256 i = _fromDay; i <= _today; i++) {
822             divSum = divSum.add(divInDay[i]);
823         }
824         if (totalSupply == 0) return 0;
825         return divSum / (_today + 1 - _fromDay) / totalSupply;
826     }
827 
828     function getTotalVolume() 
829         public
830         view
831         returns(uint256)
832     {
833         return totalBuyVolume + totalSellVolume;
834     }
835 
836     function getWeeklyBuyVolume() 
837         public
838         view
839         returns(uint256)
840     {
841         uint256 _total = 0;
842         uint256 _today = getToday();
843         for (uint256 i = _today; i + 7 > _today; i--) {
844             _total = _total + totalBuyVolumeInDay[i];
845         }
846         return _total;
847     }
848 
849     function getWeeklySellVolume() 
850         public
851         view
852         returns(uint256)
853     {
854         uint256 _total = 0;
855         uint256 _today = getToday();
856         for (uint256 i = _today; i + 7 > _today; i--) {
857             _total = _total + totalSellVolumeInDay[i];
858         }
859         return _total;
860     }
861 
862     function getWeeklyVolume()
863         public
864         view
865         returns(uint256)
866     {
867         return getWeeklyBuyVolume() + getWeeklySellVolume();
868     }
869 
870     function getTotalDividends()
871         public
872         view
873         returns(uint256)
874     {
875         return totalDividends;
876     }
877 
878     function getRDividends(address _invester)
879         public
880         view
881         returns(uint256)
882     {
883         uint256 curRoundId = getCurRoundId();
884         return uint256(int256(rPps[curRoundId] * balances[_invester]) - rCredit[_invester][curRoundId]);
885     }
886 
887     function getWeeklyDividends()
888         public
889         view
890         returns(uint256)
891     {
892         uint256 divSum = 0;
893         uint256 _today = getToday();
894         uint256 _fromDay = _today - 6;
895         if (_fromDay < deployedDay) _fromDay = deployedDay;
896         for (uint256 i = _fromDay; i <= _today; i++) {
897             divSum = divSum.add(divInDay[i]);
898         }
899         
900         return divSum;
901     }
902 
903     function getMarketCap()
904         public
905         view
906         returns(uint256)
907     {
908         return totalSupply.mul(getBuyPriceAfterTax());
909     }
910 
911     function totalSupply()
912         public
913         view
914         returns(uint)
915     {
916         return totalSupply;
917     }
918 
919     function balanceOf(address tokenOwner)
920         public
921         view
922         returns(uint256)
923     {
924         return balances[tokenOwner];
925     }
926 
927     function myBalance() 
928         public 
929         view 
930         returns(uint256)
931     {
932         return balances[msg.sender];
933     }
934 
935     function myEthBalance() 
936         public 
937         view 
938         returns(uint256) 
939     {
940         return ethBalance(msg.sender);
941     }
942 
943     function myCredit() 
944         public 
945         view 
946         returns(int256) 
947     {
948         return credit[msg.sender];
949     }
950 
951     function getRound0MinDuration()
952         public
953         view
954         returns(uint256)
955     {
956         if (!round0) return 0;
957         if (block.timestamp > ROUND0_MIN_DURATION.add(deployedTime)) return 0;
958         return ROUND0_MIN_DURATION + deployedTime - block.timestamp;
959     }
960 
961     // Lottery
962 
963     function getCurRoundId()
964         public
965         view
966         returns(uint256)
967     {
968         return lotteryContract.getCurRoundId();
969     }
970 
971     //SWAP TOKEN, PUBLIC SWAP_DURAION SECONDS BEFORE
972     function swapToken()
973         public
974         onlyTokenHolders()
975     {
976         require(swapActived, "swap not actived");
977         address _invester = msg.sender;
978         uint256 _tokenAmount = balances[_invester];
979         // burn all token
980         uint256 _ethAmount = burnToken(_invester, _tokenAmount);
981         // swapToken function in new contract accepts only sender = this old contract
982         newTokenContract.swapToken.value(_ethAmount)(_tokenAmount, _invester);
983     }
984 
985     // start swapping, disable buy
986     function setNewToken(address _newTokenAddress)
987         public
988         onlyAdmin()
989     {
990         bool _isLastRound = lotteryContract.isLastRound();
991         require(_isLastRound, "too early");
992         require(swapActived == false, "already set");
993         swapTime = block.timestamp;
994         swapActived = true;
995         newTokenContract = NewTokenInterface(_newTokenAddress);
996         autoBuy = false;
997     }
998 
999     // after 90 days from swapTime, devteam withdraw whole eth.
1000     function sleep()
1001         public
1002     {
1003         require(swapActived, "swap not actived");
1004         require(swapTime + BEFORE_SLEEP_DURAION < block.timestamp, "too early");
1005         uint256 _ethAmount = address(this).balance;
1006         devTeam.transfer(_ethAmount);
1007         //ICE
1008     }
1009 
1010 }