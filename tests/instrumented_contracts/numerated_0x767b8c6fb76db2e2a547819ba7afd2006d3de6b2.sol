1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ProfitLineInc contract
26 contract ProfitLineInc  {
27     using SafeMath for uint;
28     // set CEO and board of directors ownables
29     mapping(uint256 => address)public management;// 0 CEO 1-5 Directors
30     mapping(uint256 => uint256)public manVault;// Eth balance
31     //mapping(uint256 => uint256)public spendableShares; // unused allocation
32     mapping(uint256 => uint256)public price; // takeover price
33     uint256 public totalSupplyShares; // in use totalsupply shares
34     uint256 public ethPendingManagement;
35     
36     // Player setup
37     mapping(address => uint256)public  bondsOutstanding; // redeemablebonds
38     uint256 public totalSupplyBonds; //totalsupply of bonds outstanding
39     mapping(address => uint256)public  playerVault; // in contract eth balance
40     mapping(address => uint256)public  pendingFills; //eth to fill bonds
41     mapping(address => uint256)public  playerId; 
42     mapping(uint256 => address)public  IdToAdress; 
43     uint256 public nextPlayerID;
44     
45     // autoReinvest
46     mapping(address => bool) public allowAutoInvest;
47     mapping(address => uint256) public percentageToReinvest;
48     
49     // Game vars
50     uint256 ethPendingDistribution; // eth pending distribution
51     
52     // proffit line vars
53     uint256 ethPendingLines; // eth ending distributionacross lines
54     
55         // line 1 -  proof of cheating the line
56         mapping(uint256 => address) public cheatLine;
57         mapping(address => bool) public isInLine;
58         mapping(address => uint256) public lineNumber;
59         uint256 public cheatLinePot;
60         uint256 public nextInLine;
61         uint256 public lastInLine;
62         // line 2 -  proof of cheating the line Whale
63         mapping(uint256 => address) public cheatLineWhale;
64         mapping(address => bool) public isInLineWhale;
65         mapping(address => uint256) public lineNumberWhale;
66         uint256 public cheatLinePotWhale;
67         uint256 public nextInLineWhale;
68         uint256 public lastInLineWhale;
69         // line 3 -  proof of arbitrage opportunity
70         uint256 public arbitragePot;
71         // line 4 - proof of risky arbitrage opportunity
72         uint256 public arbitragePotRisky;
73         // line 5 - proof of increasing odds
74         mapping(address => uint256) public odds;
75         uint256 public poioPot; 
76         // line 6 - proof of increasing odds Whale
77         mapping(address => uint256) public oddsWhale;
78         uint256 public poioPotWhale;
79         // line 7 - proof of increasing odds everybody
80         uint256 public oddsAll;
81         uint256 public poioPotAll;
82         // line 8 - proof of decreasing odds everybody
83         uint256 public decreasingOddsAll;
84         uint256 public podoPotAll;
85         // line 9 -  proof of distributing by random
86         uint256 public randomPot;
87         mapping(uint256 => address) public randomDistr;
88         uint256 public randomNext;
89         uint256 public lastdraw;
90         // line 10 - proof of distributing by random whale
91         uint256 public randomPotWhale;
92         mapping(uint256 => address) public randomDistrWhale;
93         uint256 public randomNextWhale;
94         uint256 public lastdrawWhale;
95         // line 11 - proof of distributing by everlasting random
96         uint256 public randomPotAlways;
97         mapping(uint256 => address) public randomDistrAlways;
98         uint256 public randomNextAlways;
99         uint256 public lastdrawAlways;
100         // line 12 - Proof of eth rolls
101         uint256 public dicerollpot;
102         // line 13 - Proof of ridiculously bad odds
103         uint256 public amountPlayed;
104         uint256 public badOddsPot;
105         
106         // line 14 - Proof of playing Snip3d
107         uint256 public Snip3dPot;
108 
109         // line 16 - Proof of playing Slaughter3d
110         uint256 public Slaughter3dPot;
111         
112         // line 17 - Proof of eth rolls feeding bank
113         uint256 public ethRollBank;
114         // line 18 - Proof of eth stuck on PLinc
115         uint256 public ethStuckOnPLinc;
116         address public currentHelper;
117         bool public canGetPaidForHelping;
118         mapping(address => bool) public hassEthstuck;
119         // line 19 - Proof of giving of eth
120         uint256 public PLincGiverOfEth;
121         // 
122         
123         // vaults
124         uint256 public vaultSmall;
125         uint256 public timeSmall;
126         uint256 public vaultMedium;
127         uint256 public timeMedium;
128         uint256 public vaultLarge;
129         uint256 public timeLarge;
130         uint256 public vaultDrip; // delayed bonds maturing
131         uint256 public timeDrip;
132     
133     // interfaces
134     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);//0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
135     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
136     Snip3DBridgeInterface constant snip3dBridge = Snip3DBridgeInterface(0x99352D1edfa7f124eC618dfb51014f6D54bAc4aE);//snip3d bridge
137     Slaughter3DBridgeInterface constant slaughter3dbridge = Slaughter3DBridgeInterface(0x3E752fFD5eff7b7f2715eF43D8339ecABd0e65b9);//slaughter3dbridge
138     
139     // bonds div setup
140     uint256 public pointMultiplier = 10e18;
141     struct Account {
142         uint256 balance;
143         uint256 lastDividendPoints;
144         }
145     mapping(address=>Account) accounts;
146     
147    
148     uint256 public totalDividendPoints;
149     uint256 public unclaimedDividends;
150 
151     function dividendsOwing(address account) public view returns(uint256) {
152         uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
153         return (bondsOutstanding[account] * newDividendPoints) / pointMultiplier;
154     }
155     function fetchdivs(address toupdate) public updateAccount(toupdate){}
156     
157     modifier updateAccount(address account) {
158         uint256 owing = dividendsOwing(account);
159         if(owing > 0) {
160             
161             unclaimedDividends = unclaimedDividends.sub(owing);
162             pendingFills[account] = pendingFills[account].add(owing);
163         }
164         accounts[account].lastDividendPoints = totalDividendPoints;
165         _;
166         }
167     function () external payable{} // needs for divs
168     function vaultToWallet(address toPay) public {
169         require(playerVault[toPay] > 0);
170         uint256 value = playerVault[toPay];
171         playerVault[toPay] = 0;
172         toPay.transfer(value);
173         emit cashout(msg.sender,value);
174     }
175     // view functions
176     function harvestabledivs()
177         view
178         public
179         returns(uint256)
180     {
181         return ( P3Dcontract_.myDividends(true))  ;
182     }
183     
184     function fetchDataMain()
185         public
186         view
187         returns(uint256 _ethPendingDistribution, uint256 _ethPendingManagement, uint256 _ethPendingLines)
188     {
189         _ethPendingDistribution = ethPendingDistribution;
190         _ethPendingManagement = ethPendingManagement;
191         _ethPendingLines = ethPendingLines;
192     }
193     function fetchCheatLine()
194         public
195         view
196         returns(address _1stInLine, address _2ndInLine, address _3rdInLine, uint256 _sizeOfPot)
197     {
198         _1stInLine = cheatLine[nextInLine-1];
199         _2ndInLine = cheatLine[nextInLine-2];
200         _3rdInLine = cheatLine[nextInLine-3];
201         _sizeOfPot = cheatLinePot;
202     }
203     function fetchCheatLineWhale()
204         public
205         view
206         returns(address _1stInLine2, address _2ndInLine2, address _3rdInLine2, uint256 _sizeOfPot2)
207     {
208         _1stInLine2 = cheatLineWhale[nextInLineWhale-1];
209         _2ndInLine2 = cheatLineWhale[nextInLineWhale-2];
210         _3rdInLine2 = cheatLineWhale[nextInLineWhale-3];
211         _sizeOfPot2 = cheatLinePotWhale;
212     }
213 
214     // management hot potato functions
215     function buyCEO() public payable{
216         uint256 value = msg.value;
217         require(value >= price[0]);// 
218         playerVault[management[0]] += (manVault[0] .add(value.div(2)));
219         manVault[0] = 0;
220         emit CEOsold(management[0],msg.sender,value);
221         management[0] = msg.sender;
222         ethPendingDistribution = ethPendingDistribution.add(value.div(2));
223         price[0] = price[0].mul(21).div(10);
224     }
225     function buyDirector(uint256 spot) public payable{
226         uint256 value = msg.value;
227         require(spot >0 && spot < 6);
228         require(value >= price[spot]);
229         playerVault[management[spot]] += (manVault[spot].add(value.div(2)));
230         manVault[spot] = 0;
231         emit Directorsold(management[spot],msg.sender,value, spot);
232         management[spot] = msg.sender;
233         ethPendingDistribution = ethPendingDistribution.add(value.div(4));
234         playerVault[management[0]] = playerVault[management[0]].add(value.div(4));
235         price[spot] = price[spot].mul(21).div(10);
236     }
237     function managementWithdraw(uint256 who) public{
238         uint256 cash = manVault[who];
239         require(who <6);
240         require(cash>0);
241         manVault[who] = 0; 
242         management[who].transfer(cash);
243         emit cashout(management[who],cash);
244     }
245     // eth distribution cogs main
246     function ethPropagate() public{
247         require(ethPendingDistribution>0 );
248         uint256 base = ethPendingDistribution.div(50);
249         ethPendingDistribution = 0;
250         //2% to SPASM
251         SPASM_.disburse.value(base)();
252         //2% to management
253         ethPendingManagement = ethPendingManagement.add(base);
254         //10% to bonds maturity
255         uint256 amount = base.mul(5);
256         totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(totalSupplyBonds));
257         unclaimedDividends = unclaimedDividends.add(amount);
258         emit bondsMatured(amount);
259         //rest split across lines
260         ethPendingLines = ethPendingLines.add(base.mul(43));
261     }
262     //buybonds function
263     function buyBonds(address masternode, address referral)updateAccount(msg.sender) updateAccount(referral) payable public {
264         // update bonds first
265         uint256 value = msg.value;
266         address sender = msg.sender;
267         require(msg.value > 0 && referral != 0);
268         uint256 base = value.div(100);
269         // buy P3D 5%
270         P3Dcontract_.buy.value(base.mul(5))(masternode);
271         // add bonds to sender
272         uint256 amount =  value.mul(11).div(10);
273         bondsOutstanding[sender] = bondsOutstanding[sender].add(amount);
274         emit bondsBought(msg.sender,amount);
275         // reward referal in bonds
276         bondsOutstanding[referral] = bondsOutstanding[referral].add(value.mul(2).div(100));
277         // edit totalsupply
278         totalSupplyBonds = totalSupplyBonds.add(amount.add(value.mul(2).div(100)));
279         // set rest to eth pending
280         ethPendingDistribution = ethPendingDistribution.add(base.mul(95));
281         // update playerbook
282         if(playerId[sender] == 0){
283            playerId[sender] = nextPlayerID;
284            IdToAdress[nextPlayerID] = sender;
285            nextPlayerID++;
286         }
287     }
288     // management distribution eth function
289     function ethManagementPropagate() public {
290         require(ethPendingManagement > 0);
291         uint256 base = ethPendingManagement.div(20);
292         ethPendingManagement = 0;
293         manVault[0] += base.mul(5);//CEO
294         manVault[1] += base.mul(5);//first Director
295         manVault[2] += base.mul(4);
296         manVault[3] += base.mul(3);
297         manVault[4] += base.mul(2);
298         manVault[5] += base.mul(1);// fifth
299     }
300     // cash mature bonds to playervault
301     function fillBonds (address bondsOwner)updateAccount(msg.sender) updateAccount(bondsOwner) public {
302         uint256 pendingz = pendingFills[bondsOwner];
303         require(bondsOutstanding[bondsOwner] > 1000 && pendingz > 1000);
304         require(msg.sender == tx.origin);
305         require(pendingz <= bondsOutstanding[bondsOwner]);
306         // empty the pendings
307         pendingFills[bondsOwner] = 0;
308         // decrease bonds outstanding
309         bondsOutstanding[bondsOwner] = bondsOutstanding[bondsOwner].sub(pendingz);
310         // reward freelancer
311         bondsOutstanding[msg.sender]= bondsOutstanding[msg.sender].add(pendingz.div(1000));
312         // adjust totalSupplyBonds
313         totalSupplyBonds = totalSupplyBonds.sub(pendingz).add(pendingz.div(1000));
314         // add cash to playerVault
315         playerVault[bondsOwner] = playerVault[bondsOwner].add(pendingz);
316         emit bondsFilled(bondsOwner,pendingz);
317     }
318     //force bonds because overstock pendingFills
319     function forceBonds (address bondsOwner,  address masternode)updateAccount(msg.sender) updateAccount(bondsOwner) public {
320         require(bondsOutstanding[bondsOwner] > 1000 && pendingFills[bondsOwner] > 1000);
321         require(pendingFills[bondsOwner] > bondsOutstanding[bondsOwner]);
322         // update bonds first
323         uint256 value = pendingFills[bondsOwner].sub(bondsOutstanding[bondsOwner]);
324         
325         pendingFills[bondsOwner] = pendingFills[bondsOwner].sub(bondsOutstanding[bondsOwner]);
326         uint256 base = value.div(100);
327         // buy P3D 5%
328         P3Dcontract_.buy.value(base.mul(5))(masternode);
329         // add bonds to sender
330         uint256 amount =  value.mul(11).div(10);
331         bondsOutstanding[bondsOwner] += amount;
332         // reward referal in bonds
333         bondsOutstanding[msg.sender] += value.mul(2).div(100);
334         // edit totalsupply
335         totalSupplyBonds += amount.add(value.mul(2).div(100));
336         // set rest to eth pending
337         ethPendingDistribution += base.mul(95);
338         emit bondsBought(bondsOwner, amount);
339     }
340     //autoReinvest functions
341     function setAuto (uint256 percentage) public {
342         allowAutoInvest[msg.sender] = true;
343         require(percentage <=100 && percentage > 0);
344         percentageToReinvest[msg.sender] = percentage;
345     }
346     function disableAuto () public {
347         allowAutoInvest[msg.sender] = false;
348     }
349     function freelanceReinvest(address stackOwner, address masternode)updateAccount(msg.sender) updateAccount(stackOwner) public{
350         address sender = msg.sender;
351         require(allowAutoInvest[stackOwner] == true && playerVault[stackOwner] > 100000);
352         require(sender == tx.origin);
353         // update vault first
354         uint256 value = playerVault[stackOwner];
355         //emit autoReinvested(stackOwner, value, percentageToReinvest[stackOwner]);
356         playerVault[stackOwner]=0;
357         uint256 base = value.div(100000).mul(percentageToReinvest[stackOwner]);
358         // buy P3D 5%
359         P3Dcontract_.buy.value(base.mul(50))(masternode);
360         // update bonds first
361         // add bonds to sender
362         uint256 precalc = base.mul(950);//.mul(percentageToReinvest[stackOwner]); 
363         uint256 amount =  precalc.mul(109).div(100);
364         bondsOutstanding[stackOwner] = bondsOutstanding[stackOwner].add(amount);
365         // reward referal in bonds
366         bondsOutstanding[sender] = bondsOutstanding[sender].add(base);
367         // edit totalsupply
368         totalSupplyBonds = totalSupplyBonds.add(amount.add(base));
369         // set to eth pending
370         ethPendingDistribution = ethPendingDistribution.add(precalc);
371         if(percentageToReinvest[stackOwner] < 100)
372         {
373             precalc = value.sub(precalc.add(base.mul(50)));//base.mul(100-percentageToReinvest[stackOwner]);
374             stackOwner.transfer(precalc);
375             
376         }
377         emit bondsBought(stackOwner, amount);
378         
379     }
380     function PendinglinesToLines () public {
381         require(ethPendingLines > 1000);
382         
383         uint256 base = ethPendingLines.div(25);
384         ethPendingLines = 0;
385         // line 1
386         cheatLinePot = cheatLinePot.add(base);
387         // line 2
388         cheatLinePotWhale = cheatLinePotWhale.add(base);
389         // line 3
390         arbitragePot = arbitragePot.add(base);
391         // line 4
392         arbitragePotRisky = arbitragePotRisky.add(base);
393         // line 5
394         poioPot = poioPot.add(base);
395         // line 6
396         poioPotWhale = poioPotWhale.add(base);
397         // line 7
398         poioPotAll = poioPotAll.add(base);
399         // line 8
400         podoPotAll = podoPotAll.add(base);
401         // line 9
402         randomPot = randomPot.add(base);
403         // line 10
404         randomPotWhale = randomPotWhale.add(base);
405         // line 11
406         randomPotAlways = randomPotAlways.add(base);
407         // line 12
408         dicerollpot = dicerollpot.add(base);
409         // line 13
410         badOddsPot = badOddsPot.add(base);
411         
412         // line 14
413         Snip3dPot = Snip3dPot.add(base);
414 
415         // line 16
416         Slaughter3dPot = Slaughter3dPot.add(base);
417         
418         // line 17
419         ethRollBank = ethRollBank.add(base);
420         // line 18
421         ethStuckOnPLinc = ethStuckOnPLinc.add(base);
422         // line 19
423         PLincGiverOfEth = PLincGiverOfEth.add(base);
424         
425         //vaultSmall
426         vaultSmall = vaultSmall.add(base);
427         //vaultMedium
428         vaultMedium = vaultMedium.add(base);
429         //vaultLarge 
430         vaultLarge = vaultLarge.add(base);
431         //vaultdrip 
432         vaultDrip = vaultDrip.add(base.mul(4));
433         
434     }
435     function fetchP3Ddivs() public{
436         //allocate p3d dividends to contract 
437             uint256 dividends =  harvestabledivs();
438             require(dividends > 0);
439             P3Dcontract_.withdraw();
440             ethPendingDistribution = ethPendingDistribution.add(dividends);
441     }
442     
443     //Profit lines
444     function cheatTheLine () public payable updateAccount(msg.sender){
445         address sender = msg.sender;
446         uint256 value = msg.value;
447         require(value >= 0.01 ether);
448         require(msg.sender == tx.origin);
449         if(isInLine[sender] == true)
450         {
451             // overwrite previous spot
452             cheatLine[lineNumber[sender]] = cheatLine[lastInLine];
453             // get first in line
454             cheatLine[nextInLine] = sender;
455             // adjust pointers
456             nextInLine++;
457             lastInLine++;
458         }
459         if(isInLine[sender] == false)
460         {
461             // get first in line
462             cheatLine[nextInLine] = sender;
463             // set where in line
464             lineNumber[sender] = nextInLine;
465             // adjust pointer
466             nextInLine++;
467             // adjust isinline
468             isInLine[sender] = true;
469         }
470 
471         //give bonds for eth payment    
472         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
473         // edit totalsupply
474         totalSupplyBonds = totalSupplyBonds.add(value);
475         // set paid eth to eth pending
476         ethPendingDistribution = ethPendingDistribution.add(value);
477         emit bondsBought(sender, value);
478         
479     }
480     function payoutCheatLine () public {
481         // needs someone in line and pot have honey
482         require(cheatLinePot >= 0.1 ether && nextInLine > 0);
483         require(msg.sender == tx.origin);
484         // set winner
485         uint256 winner = nextInLine.sub(1);
486         // change index
487         nextInLine--;
488         // deduct from pot
489         cheatLinePot = cheatLinePot.sub(0.1 ether);
490         // add to winers pendingFills
491         pendingFills[cheatLine[winner]] = pendingFills[cheatLine[winner]].add(0.1 ether);
492         // kicked from line because of win
493         isInLine[cheatLine[winner]] = false;
494         // 
495         //emit newMaturedBonds(cheatLine[winner], 0.1 ether);
496         emit won(cheatLine[winner], true, 0.1 ether, 1);
497     }
498     function cheatTheLineWhale () public payable updateAccount(msg.sender){
499         address sender = msg.sender;
500         uint256 value = msg.value;
501         require(value >= 1 ether);
502         require(sender == tx.origin);
503         if(isInLineWhale[sender] == true)
504         {
505             // overwrite previous spot
506             cheatLineWhale[lineNumberWhale[sender]] = cheatLineWhale[lastInLineWhale];
507             // get first in line
508             cheatLineWhale[nextInLineWhale] = sender;
509             // adjust pointers
510             nextInLineWhale++;
511             lastInLineWhale++;
512         }
513         if(isInLineWhale[sender] == false)
514         {
515             // get first in line
516             cheatLineWhale[nextInLineWhale] = sender;
517             // set where in line
518             lineNumberWhale[sender] = nextInLineWhale;
519             // adjust pointer
520             nextInLineWhale++;
521             // adjust isinline
522             isInLineWhale[sender] = true;
523         }
524         
525         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
526         // edit totalsupply
527         totalSupplyBonds = totalSupplyBonds.add(value);
528         // set paid eth to eth pending
529         ethPendingDistribution = ethPendingDistribution.add(value);
530         //emit bondsBought(sender, value);
531     }
532     function payoutCheatLineWhale () public {
533         // needs someone in line and pot have honey
534         require(cheatLinePotWhale >= 10 ether && nextInLineWhale > 0);
535         require(msg.sender == tx.origin);
536         // set winner
537         uint256 winner = nextInLineWhale.sub(1);
538         // change index
539         nextInLineWhale--;
540         // deduct from pot
541         cheatLinePotWhale = cheatLinePotWhale.sub(10 ether);
542         // add to winers pendingFills
543         pendingFills[cheatLineWhale[winner]] = pendingFills[cheatLineWhale[winner]].add(10 ether);
544         // kicked from line because of win
545         isInLineWhale[cheatLineWhale[winner]] = false;
546         // 
547         //emit newMaturedBonds(cheatLineWhale[winner], 10 ether);
548         emit won(cheatLineWhale[winner], true, 10 ether,2);
549     }
550     function takeArbitrageOpportunity () public payable updateAccount(msg.sender){
551         uint256 opportunityCost = arbitragePot.div(100);
552         require(msg.value > opportunityCost && opportunityCost > 1000);
553         
554         uint256 payout = opportunityCost.mul(101).div(100);
555         arbitragePot = arbitragePot.sub(payout);
556         //
557         uint256 value = msg.value;
558         address sender = msg.sender;
559         require(sender == tx.origin);
560         // add to winers pendingFills
561         pendingFills[sender] = pendingFills[sender].add(payout);
562         // add bonds to sender
563         
564         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
565         // edit totalsupply
566         totalSupplyBonds = totalSupplyBonds.add(value);
567         // set paid eth to eth pending
568         ethPendingDistribution = ethPendingDistribution.add(value);
569         
570         emit won(sender, true, payout,3);
571     }
572     function takeArbitrageOpportunityRisky () public payable updateAccount(msg.sender){
573         uint256 opportunityCost = arbitragePotRisky.div(5);
574         require(msg.value > opportunityCost && opportunityCost > 1000);
575         
576         uint256 payout = opportunityCost.mul(101).div(100);
577         arbitragePotRisky = arbitragePotRisky.sub(payout);
578         //
579         uint256 value = msg.value;
580         address sender = msg.sender;
581         require(sender == tx.origin);
582         // add to winers pendingFills
583         pendingFills[sender] = pendingFills[sender].add(payout);
584         // add bonds to sender
585         
586         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
587         // edit totalsupply
588         totalSupplyBonds = totalSupplyBonds.add(value);
589         // set paid eth to eth pending
590         ethPendingDistribution = ethPendingDistribution.add(value);
591         //emit bondsBought(sender, value);
592         //emit newMaturedBonds(sender, payout);
593         emit won(sender, true, payout,4);
594     }
595     function playProofOfIncreasingOdds (uint256 plays) public payable updateAccount(msg.sender){
596         //possible mm gas problem upon win?
597         
598         address sender  = msg.sender;
599         uint256 value = msg.value;
600         uint256 oddz = odds[sender];
601         uint256 oddzactual;
602         require(sender == tx.origin);
603         require(value >= plays.mul(0.1 ether));
604         require(plays > 0);
605         bool hasWon;
606         // fix this
607         for(uint i=0; i< plays; i++)
608         {
609             
610             if(1000- oddz - i > 2){oddzactual = 1000- oddz - i;}
611             if(1000- oddz - i <= 2){oddzactual =  2;}
612             uint256 outcome = uint256(blockhash(block.number-1)) % (oddzactual);
613             emit RNGgenerated(outcome);
614             if(outcome == 1){
615                 // only 1 win per tx
616                 i = plays;
617                 // change pot
618                 poioPot = poioPot.div(2);
619                 // add to winers pendingFills
620                 pendingFills[sender] = pendingFills[sender].add(poioPot);
621                 // reset odds
622                 odds[sender] = 0;
623                 //emit newMaturedBonds(sender, poioPot);
624                 hasWon = true;
625                 uint256 amount = poioPot;
626             }
627         }
628         odds[sender] += i;
629         // add bonds to sender
630         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
631         // edit totalsupply
632         totalSupplyBonds = totalSupplyBonds.add(value);
633         // set paid eth to eth pending
634         ethPendingDistribution = ethPendingDistribution.add(value);
635         //
636         //emit bondsBought(sender, value);
637         emit won(sender, hasWon, amount,5);
638         
639     }
640     function playProofOfIncreasingOddsWhale (uint256 plays) public payable updateAccount(msg.sender){
641         //possible mm gas problem upon win?
642 
643         address sender  = msg.sender;
644         uint256 value = msg.value;
645         uint256 oddz = oddsWhale[sender];
646         uint256 oddzactual;
647         require(sender == tx.origin);
648         require(value >= plays.mul(10 ether));
649         require(plays > 0);
650         bool hasWon;
651         // fix this
652         for(uint i=0; i< plays; i++)
653         {
654             
655             if(1000- oddz - i > 2){oddzactual = 1000- oddz - i;}
656             if(1000- oddz - i <= 2){oddzactual =  2;}
657             uint256 outcome = uint256(blockhash(block.number-1)) % (oddzactual);
658             emit RNGgenerated(outcome);
659             if(outcome == 1){
660                 // only 1 win per tx
661                 i = plays;
662                 // change pot
663                 poioPotWhale = poioPotWhale.div(2);
664                 // add to winers pendingFills
665                 pendingFills[sender] = pendingFills[sender].add(poioPotWhale);
666                 // reset odds
667                 oddsWhale[sender] = 0;
668                 //emit newMaturedBonds(sender, poioPotWhale);
669                 hasWon = true;
670                 uint256 amount = poioPotWhale;
671             }
672         }
673         oddsWhale[sender] += i;
674         // add bonds to sender
675         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
676         // edit totalsupply
677         totalSupplyBonds = totalSupplyBonds.add(value);
678         // set paid eth to eth pending
679         ethPendingDistribution = ethPendingDistribution.add(value);
680         //
681         //emit bondsBought(sender, value);
682         emit won(sender, hasWon, amount,6);
683     }
684     function playProofOfIncreasingOddsALL (uint256 plays) public payable updateAccount(msg.sender){
685         //possible mm gas problem upon win?
686 
687         address sender  = msg.sender;
688         uint256 value = msg.value;
689         uint256 oddz = oddsAll;
690         uint256 oddzactual;
691         require(sender == tx.origin);
692         require(value >= plays.mul(0.1 ether));
693         require(plays > 0);
694         bool hasWon;
695         // fix this
696         for(uint i=0; i< plays; i++)
697         {
698             
699             if(1000- oddz - i > 2){oddzactual = 1000- oddz - i;}
700             if(1000- oddz - i <= 2){oddzactual =  2;}
701             uint256 outcome = uint256(blockhash(block.number-1)) % (oddzactual);
702             emit RNGgenerated(outcome);
703             if(outcome == 1){
704                 // only 1 win per tx
705                 i = plays;
706                 // change pot
707                 poioPotAll = poioPotAll.div(2);
708                 // add to winers pendingFills
709                 pendingFills[sender] = pendingFills[sender].add(poioPotAll);
710                 // reset odds
711                 odds[sender] = 0;
712                 //emit newMaturedBonds(sender, poioPotAll);
713                 hasWon = true;
714                 uint256 amount = poioPotAll;
715             }
716         }
717         oddsAll += i;
718         // add bonds to sender
719         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
720         // edit totalsupply
721         totalSupplyBonds = totalSupplyBonds.add(value);
722         // set paid eth to eth pending
723         ethPendingDistribution = ethPendingDistribution.add(value);
724         //emit bondsBought(sender, value);
725         emit won(sender, hasWon, amount,7);
726     }
727     function playProofOfDecreasingOddsALL (uint256 plays) public payable updateAccount(msg.sender){
728         //possible mm gas problem upon win?
729 
730         address sender  = msg.sender;
731         uint256 value = msg.value;
732         uint256 oddz = decreasingOddsAll;
733         uint256 oddzactual;
734         require(sender == tx.origin);
735         require(value >= plays.mul(0.1 ether));
736         require(plays > 0);
737         bool hasWon;
738         // fix this
739         for(uint i=0; i< plays; i++)
740         {
741             
742             oddzactual = oddz + i;
743             uint256 outcome = uint256(blockhash(block.number-1)).add(now) % (oddzactual);
744             emit RNGgenerated(outcome);
745             if(outcome == 1){
746                 // only 1 win per tx
747                 i = plays;
748                 // change pot
749                 podoPotAll = podoPotAll.div(2);
750                 // add to winers pendingFills
751                 pendingFills[sender] = pendingFills[sender].add(podoPotAll);
752                 // reset odds
753                 decreasingOddsAll = 10;
754                 //emit newMaturedBonds(sender, podoPotAll);
755                 hasWon = true;
756                 uint256 amount = podoPotAll;
757             }
758         }
759         decreasingOddsAll += i;
760         // add bonds to sender
761         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
762         // edit totalsupply
763         totalSupplyBonds = totalSupplyBonds.add(value);
764         // set paid eth to eth pending
765         ethPendingDistribution = ethPendingDistribution.add(value);
766         //emit bondsBought(sender, value);
767         emit won(sender, hasWon, amount,8);
768     }
769     function playRandomDistribution (uint256 plays) public payable updateAccount(msg.sender){
770         address sender = msg.sender;
771         uint256 value = msg.value;
772         require(value >= plays.mul(0.01 ether));
773         require(plays > 0);
774         uint256 spot;
775          for(uint i=0; i< plays; i++)
776         {
777             // get first in line
778             spot = randomNext + i;
779             randomDistr[spot] = sender;
780         }
781         // adjust pointer
782         randomNext = randomNext + i;
783         
784         
785         //give bonds for eth payment    
786         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
787         // edit totalsupply
788         totalSupplyBonds = totalSupplyBonds.add(value);
789         // set paid eth to eth pending
790         ethPendingDistribution = ethPendingDistribution.add(value);
791         //emit bondsBought(sender, value);
792        
793     }
794     function payoutRandomDistr () public {
795         // needs someone in line and pot have honey
796         address sender = msg.sender;
797         require(randomPot >= 0.1 ether && randomNext > 0 && lastdraw != block.number);
798         require(sender == tx.origin);
799         // set winner
800         uint256 outcome = uint256(blockhash(block.number-1)).add(now) % (randomNext);
801         emit RNGgenerated(outcome);
802         // deduct from pot
803         randomPot = randomPot.sub(0.1 ether);
804         // add to winers pendingFills
805         pendingFills[randomDistr[outcome]] = pendingFills[randomDistr[outcome]].add(0.1 ether);
806         //emit newMaturedBonds(randomDistr[outcome], 0.1 ether);
807         // kicked from line because of win
808         randomDistr[outcome] = randomDistr[randomNext-1];
809         // reduce one the line
810         randomNext--;
811         // adjust lastdraw
812         lastdraw = block.number;
813         // 
814         emit won(randomDistr[outcome], true, 0.1 ether,9);
815     }
816     function playRandomDistributionWhale (uint256 plays) public payable updateAccount(msg.sender){
817         address sender = msg.sender;
818         uint256 value = msg.value;
819         require(value >= plays.mul(1 ether));
820         require(plays > 0);
821         uint256 spot;
822          for(uint i=0; i< plays; i++)
823         {
824             // get first in line
825             spot = randomNextWhale + i;
826             randomDistrWhale[spot] = sender;
827         }
828         // adjust pointer
829         randomNextWhale = randomNextWhale + i;
830         
831         
832         //give bonds for eth payment    
833         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
834         // edit totalsupply
835         totalSupplyBonds = totalSupplyBonds.add(value);
836         // set paid eth to eth pending
837         ethPendingDistribution = ethPendingDistribution.add(value);
838         //emit bondsBought(sender, value);
839         
840     }
841     function payoutRandomDistrWhale () public {
842         // needs someone in line and pot have honey
843         require(randomPotWhale >= 10 ether && randomNextWhale > 0 && lastdrawWhale != block.number);
844         require(msg.sender == tx.origin);
845         // set winner
846         uint256 outcome = uint256(blockhash(block.number-1)).add(now) % (randomNextWhale);
847         emit RNGgenerated(outcome);
848         // deduct from pot
849         randomPotWhale = randomPotWhale.sub(10 ether);
850         //emit newMaturedBonds(randomDistrWhale[outcome], 10 ether);
851         // add to winers pendingFills
852         pendingFills[randomDistrWhale[outcome]] = pendingFills[randomDistrWhale[outcome]].add(10 ether);
853         // kicked from line because of win
854         randomDistrWhale[outcome] = randomDistrWhale[randomNext-1];
855         // reduce one the line
856         randomNextWhale--;
857         // adjust lastdraw
858         lastdrawWhale = block.number;
859         // 
860         emit won(randomDistrWhale[outcome], true, 10 ether,10);
861     }
862     function playRandomDistributionAlways (uint256 plays) public payable updateAccount(msg.sender){
863         address sender = msg.sender;
864         uint256 value = msg.value;
865         require(value >= plays.mul(0.1 ether));
866         require(plays > 0);
867         uint256 spot;
868          for(uint i=0; i< plays; i++)
869         {
870             // get first in line
871             spot = randomNextAlways + i;
872             randomDistrAlways[spot] = sender;
873         }
874         // adjust pointer
875         randomNextAlways = randomNextAlways + i;
876         
877         
878         //give bonds for eth payment    
879         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
880         // edit totalsupply
881         totalSupplyBonds = totalSupplyBonds.add(value);
882         // set paid eth to eth pending
883         ethPendingDistribution = ethPendingDistribution.add(value);
884         //emit bondsBought(sender, value);
885     }
886     function payoutRandomDistrAlways () public {
887         // needs someone in line and pot have honey
888         require(msg.sender == tx.origin);
889         require(randomPotAlways >= 1 ether && randomNextAlways > 0 && lastdrawAlways != block.number);
890         // set winner
891         uint256 outcome = uint256(blockhash(block.number-1)).add(now) % (randomNextAlways);
892         emit RNGgenerated(outcome);
893         // deduct from pot
894         randomPotAlways = randomPotAlways.sub(1 ether);
895         //emit newMaturedBonds(randomDistrAlways[outcome], 1 ether);
896         // add to winers pendingFills
897         pendingFills[randomDistrAlways[outcome]] = pendingFills[randomDistrAlways[outcome]].add(1 ether);
898         // adjust lastdraw
899         lastdraw = block.number;
900         // 
901         emit won(randomDistrAlways[outcome], true, 1 ether,11);
902     }
903     function playProofOfRediculousBadOdds (uint256 plays) public payable updateAccount(msg.sender){
904         //possible mm gas problem upon win?
905 
906         address sender  = msg.sender;
907         uint256 value = msg.value;
908         uint256 oddz = amountPlayed;
909         uint256 oddzactual;
910         require(sender == tx.origin);
911         require(value >= plays.mul(0.0001 ether));
912         require(plays > 0);
913         bool hasWon;
914         // fix this
915         for(uint i=0; i< plays; i++)
916         {
917             oddzactual =  oddz.add(1000000).add(i);
918             uint256 outcome = uint256(blockhash(block.number-1)).add(now) % (oddzactual);
919             emit RNGgenerated(outcome);
920             if(outcome == 1){
921                 // only 1 win per tx
922                 i = plays;
923                 // change pot
924                 badOddsPot = badOddsPot.div(2);
925                 // add to winers pendingFills
926                 pendingFills[sender] = pendingFills[sender].add(badOddsPot);
927                 //emit newMaturedBonds(randomDistrAlways[outcome], badOddsPot);
928                  hasWon = true;
929                 uint256 amount = badOddsPot;
930             }
931         }
932         amountPlayed += i;
933         // add bonds to sender
934         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
935         // edit totalsupply
936         totalSupplyBonds = totalSupplyBonds.add(value);
937         // set paid eth to eth pending
938         ethPendingDistribution = ethPendingDistribution.add(value);
939         //emit bondsBought(sender, value);
940         emit won(sender, hasWon, amount,12);
941     }
942     function playProofOfDiceRolls (uint256 oddsTaken) public payable updateAccount(msg.sender){
943         //possible mm gas problem upon win?
944 
945         address sender  = msg.sender;
946         uint256 value = msg.value;
947         uint256 oddz = amountPlayed;
948         uint256 possiblewin = value.mul(100).div(oddsTaken);
949         require(sender == tx.origin);
950         require(dicerollpot >= possiblewin);
951         require(oddsTaken > 0 && oddsTaken < 100);
952         bool hasWon;
953         // fix this
954        
955             uint256 outcome = uint256(blockhash(block.number-1)).add(now).add(oddz) % (100);
956             emit RNGgenerated(outcome);
957             if(outcome < oddsTaken){
958                 // win
959                 dicerollpot = dicerollpot.sub(possiblewin);
960                pendingFills[sender] = pendingFills[sender].add(possiblewin);
961                 //emit newMaturedBonds(sender, possiblewin);
962                 hasWon = true;
963                 uint256 amount = possiblewin;
964             }
965         
966         amountPlayed ++;
967         // add bonds to sender
968         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
969         // edit totalsupply
970         totalSupplyBonds = totalSupplyBonds.add(value);
971         // set paid eth to eth pending
972         ethPendingDistribution = ethPendingDistribution.add(value);
973         //emit bondsBought(sender, value);
974         emit won(sender, hasWon, amount,13);
975     }
976     function playProofOfEthRolls (uint256 oddsTaken) public payable updateAccount(msg.sender){
977         //possible mm gas problem upon win?
978 
979         address sender  = msg.sender;
980         uint256 value = msg.value;
981         uint256 oddz = amountPlayed;
982         uint256 possiblewin = value.mul(100).div(oddsTaken);
983         require(sender == tx.origin);
984         require(ethRollBank >= possiblewin);
985         require(oddsTaken > 0 && oddsTaken < 100);
986         bool hasWon;
987         // fix this
988        
989             uint256 outcome = uint256(blockhash(block.number-1)).add(now).add(oddz) % (100);
990             emit RNGgenerated(outcome);
991             if(outcome < oddsTaken){
992                 // win
993                 ethRollBank = ethRollBank.sub(possiblewin);
994                pendingFills[sender] = pendingFills[sender].add(possiblewin);
995                //emit newMaturedBonds(sender, possiblewin);
996                 hasWon = true;
997                 uint256 amount = possiblewin;
998             }
999         
1000         amountPlayed ++;
1001         // add bonds to sender
1002         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
1003         // edit totalsupply
1004         totalSupplyBonds = totalSupplyBonds.add(value);
1005         // set paid eth to eth pending
1006         ethPendingDistribution = ethPendingDistribution.add(value.div(100));
1007         // most eth to bank instead
1008         ethRollBank = ethRollBank.add(value.div(100).mul(99));
1009         
1010         emit won(sender, hasWon, amount,14);
1011     }
1012     function helpUnstuckEth()public payable updateAccount(msg.sender){
1013         uint256 value = msg.value;
1014         address sender  = msg.sender;
1015         require(sender == tx.origin);
1016         require(value >= 2 finney);
1017         hassEthstuck[currentHelper] = true;
1018         canGetPaidForHelping = true;
1019         currentHelper = msg.sender;
1020         hassEthstuck[currentHelper] = false;
1021         // add bonds to sender
1022         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
1023         // edit totalsupply
1024         totalSupplyBonds = totalSupplyBonds.add(value);
1025         // set paid eth to eth pending
1026         ethPendingDistribution = ethPendingDistribution.add(value);
1027         
1028     }
1029     function transferEthToHelper()public{
1030         
1031         address sender  = msg.sender;
1032         require(sender == tx.origin);
1033         require(hassEthstuck[sender] == true && canGetPaidForHelping == true);
1034         require(ethStuckOnPLinc > 4 finney);
1035         hassEthstuck[sender] = false;
1036         canGetPaidForHelping = false;
1037         ethStuckOnPLinc = ethStuckOnPLinc.sub(4 finney);
1038         pendingFills[currentHelper] = pendingFills[currentHelper].add(4 finney) ;
1039         //emit newMaturedBonds(currentHelper, 4 finney);
1040         emit won(currentHelper, true, 4 finney,15);
1041     }
1042     function begForFreeEth () public payable updateAccount(msg.sender){
1043          address sender  = msg.sender;
1044          uint256 value = msg.value;
1045         require(sender == tx.origin);
1046         
1047         require(value >= 0.1 ether );
1048         bool hasWon;
1049         if(PLincGiverOfEth >= 0.101 ether)
1050         {
1051             PLincGiverOfEth = PLincGiverOfEth.sub(0.1 ether);
1052             pendingFills[sender] = pendingFills[sender].add( 0.101 ether) ;
1053             //emit newMaturedBonds(sender, 0.101 ether);
1054             hasWon = true;
1055         }
1056         // add bonds to sender
1057         bondsOutstanding[sender] = bondsOutstanding[sender].add(value);
1058         // edit totalsupply
1059         totalSupplyBonds = totalSupplyBonds.add(value);
1060         // set paid eth to eth pending
1061         ethPendingDistribution = ethPendingDistribution.add(value);
1062         //emit bondsBought(sender, value);
1063         emit won(sender, hasWon, 0.101 ether,16);
1064     }
1065     function releaseVaultSmall () public {
1066         // needs time or amount reached
1067         uint256 vaultSize = vaultSmall;
1068         require(timeSmall + 24 hours < now || vaultSize > 10 ether);
1069         // reset time
1070         timeSmall = now;
1071         // empty vault
1072         vaultSmall = 0;
1073         // add to ethPendingDistribution
1074         ethPendingDistribution = ethPendingDistribution.add(vaultSize);
1075     }
1076     function releaseVaultMedium () public {
1077         // needs time or amount reached
1078         uint256 vaultSize = vaultMedium;
1079         require(timeMedium + 168 hours < now || vaultSize > 100 ether);
1080         // reset time
1081         timeMedium = now;
1082         // empty vault
1083         vaultMedium = 0;
1084         // add to ethPendingDistribution
1085         ethPendingDistribution = ethPendingDistribution.add(vaultSize);
1086     }
1087     function releaseVaultLarge () public {
1088         // needs time or amount reached
1089         uint256 vaultSize = vaultLarge;
1090         require(timeLarge + 720 hours < now || vaultSize > 1000 ether);
1091         // reset time
1092         timeLarge = now;
1093         // empty vault
1094         vaultLarge = 0;
1095         // add to ethPendingDistribution
1096         ethPendingDistribution = ethPendingDistribution.add(vaultSize);
1097     }
1098     function releaseDrip () public {
1099         // needs time or amount reached
1100         uint256 vaultSize = vaultDrip;
1101         require(timeDrip + 24 hours < now);
1102         // reset time
1103         timeDrip = now;
1104         uint256 value = vaultSize.div(100);
1105         // empty vault
1106         vaultDrip = vaultDrip.sub(value);
1107         // update divs params
1108         totalDividendPoints = totalDividendPoints.add(value);
1109         unclaimedDividends = unclaimedDividends.add(value);
1110         emit bondsMatured(value);
1111     }
1112 
1113     constructor()
1114         public
1115     {
1116         management[0] = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
1117         management[1] = 0x58E90F6e19563CE82C4A0010CEcE699B3e1a6723;
1118         management[2] = 0xf1A7b8b3d6A69C30883b2a3fB023593d9bB4C81E;
1119         management[3] = 0x2615A4447515D97640E43ccbbF47E003F55eB18C;
1120         management[4] = 0xD74B96994Ef8a35Fc2dA61c5687C217ab527e8bE;
1121         management[5] = 0x2F145AA0a439Fa15e02415e035aaF9fDbDeCaBD5;
1122         price[0] = 100 ether;
1123         price[1] = 25 ether;
1124         price[2] = 20 ether;
1125         price[3] = 15 ether;
1126         price[4] = 10 ether;
1127         price[5] = 5 ether;
1128         
1129         bondsOutstanding[0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220]= 100 finney;
1130         totalSupplyBonds = 100 finney;
1131         decreasingOddsAll = 10;
1132         
1133         timeSmall = now;
1134         timeMedium = now;
1135         timeLarge = now;
1136         timeDrip = now;
1137     }
1138     
1139     // snip3d handlers
1140     function soldierBuy () public {
1141         require(Snip3dPot > 0.1 ether);
1142         uint256 temp = Snip3dPot;
1143         Snip3dPot = 0;
1144         snip3dBridge.sacUp.value(temp)();
1145     }
1146     function snip3dVaultToPLinc() public {// from bridge to PLinc
1147         uint256 incoming = snip3dBridge.harvestableBalance();
1148         snip3dBridge.fetchBalance();
1149         ethPendingDistribution = ethPendingDistribution.add(incoming);
1150     }
1151     // slaughter3d handlers
1152     
1153     function sendButcher() public{
1154         require(Slaughter3dPot > 0.1 ether);
1155         uint256 temp = Slaughter3dPot;
1156         Slaughter3dPot = 0;
1157         slaughter3dbridge.sacUp.value(temp)();
1158     }
1159     function slaughter3dbridgeToPLinc() public {
1160         uint256 incoming = slaughter3dbridge.harvestableBalance();
1161         slaughter3dbridge.fetchBalance();
1162         ethPendingDistribution = ethPendingDistribution.add(incoming);
1163     }
1164  
1165 // events
1166     event bondsBought(address indexed player, uint256 indexed bonds);
1167     event bondsFilled(address indexed player, uint256 indexed bonds);
1168     event CEOsold(address indexed previousOwner, address indexed newOwner, uint256 indexed price);
1169     event Directorsold(address indexed previousOwner, address indexed newOwner, uint256 indexed price, uint256 spot);
1170     event cashout(address indexed player , uint256 indexed ethAmount);
1171     event bondsMatured(uint256 indexed amount);
1172     event RNGgenerated(uint256 indexed number);
1173     event won(address player, bool haswon, uint256 amount ,uint256 line);
1174 
1175 }
1176 interface HourglassInterface  {
1177     function () payable external;
1178     function buy(address _playerAddress) payable external returns(uint256);
1179     function withdraw() external;
1180     function myDividends(bool _includeReferralBonus) external view returns(uint256);
1181 
1182 }
1183 interface SPASMInterface  {
1184     function() payable external;
1185     function disburse() external  payable;
1186 }
1187 
1188 interface Snip3DBridgeInterface  {
1189     function harvestableBalance()
1190         view
1191         external
1192         returns(uint256)
1193     ;
1194     function sacUp () external payable ;
1195     function fetchBalance ()  external ;
1196     
1197 }
1198 interface Slaughter3DBridgeInterface{
1199     function harvestableBalance()
1200         view
1201         external
1202         returns(uint256)
1203     ;
1204     function sacUp () external payable ;
1205     function fetchBalance ()  external ;
1206 }