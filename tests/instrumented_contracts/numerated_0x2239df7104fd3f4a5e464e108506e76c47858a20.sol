1 pragma solidity^0.4.24;
2 
3 /**
4 *
5 *
6 * Contacts: support (at) bankofeth.app
7 *           https://twitter.com/bankofeth
8 *           https://discord.gg/d5c7pfn
9 *           https://t.me/bankofeth
10 *           https://reddit.com/r/bankofeth
11 *
12 * PLAY NOW: https://heist.bankofeth.app/heist.htm
13 *  
14 * --- BANK OF ETH - BANK HEIST! ------------------------------------------------
15 *
16 * Hold the final key to complete the bank heist and win the entire vault funds!
17 * 
18 * = Passive income while the vault time lock runs down - as others buy into the 
19 * game you earn $ETH! 
20 * 
21 * = Buy enough keys for a chance to open the safety bank deposit boxes for a 
22 * instant win! 
23 * 
24 * = Game designed with 4 dimensions of income for you, the players!
25 *   (See https://heist.bankofeth.app/heist.htm for details)
26 * 
27 * = Can you hold the last key to win the game!
28 * = Can you win the safety deposit box!
29 *
30 * = Play NOW: https://heist.bankofeth.app/heist.htm
31 *
32 * Keys priced as low as 0.001 $ETH!
33 *
34 * Also - invest min 0.1 ETH for a chance to open a safety deposit box and 
35 * instantly win a bonus prize!
36 * 
37 * The more keys you own in each round, the more distributed ETH you'll earn!
38 * 
39 * All profits from thi game feed back into the main BankOfEth contract where 
40 * you can also be an investor in and earn a return on!
41 *
42 *
43 * --- COPYRIGHT ----------------------------------------------------------------
44 * 
45 *   This source code is provided for verification and audit purposes only and 
46 *   no license of re-use is granted.
47 *   
48 *   (C) Copyright 2018 BankOfEth.app
49 *   
50 *   
51 *   Sub-license, white-label, solidity or Ethereum development enquiries please 
52 *   contact support (at) bankofeth.app
53 *   
54 *   
55 * PLAY NOW: https://heist.bankofeth.app/heist.htm
56 * 
57 */
58 
59 
60 
61 library SafeMath {
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a * b;
64         assert(a == 0 || c / a == b);
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         // assert(b > 0); // Solidity automatically throws when dividing by 0
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }
86 
87 library Zero {
88   function requireNotZero(uint a) internal pure {
89     require(a != 0, "require not zero");
90   }
91 
92   function requireNotZero(address addr) internal pure {
93     require(addr != address(0), "require not zero address");
94   }
95 
96   function notZero(address addr) internal pure returns(bool) {
97     return !(addr == address(0));
98   }
99 
100   function isZero(address addr) internal pure returns(bool) {
101     return addr == address(0);
102   }
103 }
104 
105 library Percent {
106 
107   struct percent {
108     uint num;
109     uint den;
110   }
111   function mul(percent storage p, uint a) internal view returns (uint) {
112     if (a == 0) {
113       return 0;
114     }
115     return a*p.num/p.den;
116   }
117 
118   function div(percent storage p, uint a) internal view returns (uint) {
119     return a/p.num*p.den;
120   }
121 
122   function sub(percent storage p, uint a) internal view returns (uint) {
123     uint b = mul(p, a);
124     if (b >= a) return 0;
125     return a - b;
126   }
127 
128   function add(percent storage p, uint a) internal view returns (uint) {
129     return a + mul(p, a);
130   }
131 }
132 
133 library ToAddress {
134   function toAddr(uint source) internal pure returns(address) {
135     return address(source);
136   }
137 
138   function toAddr(bytes source) internal pure returns(address addr) {
139     assembly { addr := mload(add(source,0x14)) }
140     return addr;
141   }
142 }
143 
144 interface BankOfEth {
145     function receiveExternalProfits() external payable;
146 }
147 
148 contract BankOfEthVaultBreaker {
149     
150     using SafeMath for uint256;
151     using Percent for Percent.percent;
152     using Zero for *;
153     using ToAddress for *;
154 
155     // Events    
156     event KeysIssued(address indexed to, uint keys, uint timestamp);
157     event EthDistributed(uint amount, uint timestamp);
158     event ReturnsWithdrawn(address indexed by, uint amount, uint timestamp);
159     event JackpotWon(address by, uint amount, uint timestamp);
160     event AirdropWon(address by, uint amount, uint timestamp);
161     event RoundStarted(uint indexed ID, uint hardDeadline, uint timestamp);
162     
163     address owner;
164     address devAddress;
165     address bankOfEthAddress = 0xd70c3f752Feb69Ecf8Eb31E48B20A97D979e8e5e;
166 
167     BankOfEth localBankOfEth;
168     
169 
170     // settings
171     uint public constant STARTING_KEY_PRICE = 1 finney; // 0.01 eth
172     uint public constant HARD_DEADLINE_DURATION = 30 days; // hard deadline is this much after the round start
173     
174     uint public constant TIME_PER_KEY = 5 minutes; // how much time is added to the soft deadline per key purchased
175     uint public constant PRICE_INCREASE_PERIOD = 1 hours; // how often the price doubles after the hard deadline
176     uint constant WAD = 10 ** 18;
177     uint constant RAY = 10 ** 27;
178     
179     Percent.percent private m_currentRoundJackpotPercent = Percent.percent(15, 100); // 15/100*100% = 15%
180     Percent.percent private m_investorsPercent = Percent.percent(65, 100); // 65/100*100% = 65%
181     Percent.percent private m_devPercent = Percent.percent(10, 100); // 15/100*100% = 15%
182     Percent.percent private m_nextRoundSeedPercent = Percent.percent(5, 100); // 15/100*100% = 15%
183     Percent.percent private m_airdropPercent = Percent.percent(2, 100); // 15/100*100% = 15%
184     Percent.percent private m_bankOfEthProfitPercent = Percent.percent(3, 100); // 15/100*100% = 15%
185     Percent.percent private m_refPercent = Percent.percent(3, 100); // 3/100*100% = 15%
186     
187     struct SafeBreaker {
188         //uint lastCumulativeReturnsPoints;
189         uint lastCumulativeReturnsPoints;
190         uint keys;
191     }
192     
193     struct GameRound {
194         uint totalInvested;        
195         uint jackpot;
196         uint airdropPot;
197         uint totalKeys;
198         uint cumulativeReturnsPoints; // this is to help calculate returns when the total number of keys changes
199         uint hardDeadline;
200         uint softDeadline;
201         uint price;
202         uint lastPriceIncreaseTime;
203         address lastInvestor;
204         bool finalized;
205         mapping (address => SafeBreaker) safeBreakers;
206     }
207     
208     struct Vault {
209         uint totalReturns; // Total balance = returns + referral returns + jackpots/airdrops 
210         uint refReturns; // how much of the total is from referrals
211     }
212 
213     mapping (address => Vault) vaults;
214 
215     uint public latestRoundID;// the first round has an ID of 0
216     GameRound[] rounds;
217     
218     
219     uint256 public minInvestment = 1 finney; // 0.01 eth
220     uint256 public maxInvestment = 2000 ether; 
221     uint256 public roundDuration = (24 hours);
222     uint public soft_deadline_duration = 1 days; // max soft deadline
223     bool public gamePaused = false;
224     bool public limitedReferralsMode = true;
225     
226     mapping(address => bool) private m_referrals; // we only pay out on the first set of referrals
227     
228     
229     // Game vars
230     uint public jackpotSeed;// Jackpot from previous rounds
231     
232     uint public unclaimedReturns;
233     uint public constant MULTIPLIER = RAY;
234     
235     // Main stats:
236     uint public totalJackpotsWon;
237     uint public totalKeysSold;
238     uint public totalEarningsGenerated;
239 
240     
241     // modifiers
242     modifier onlyOwner() {
243         require(msg.sender == owner);
244         _;
245     }
246     
247     modifier notOnPause() {
248         require(gamePaused == false, "Game Paused");
249         _;
250     }
251     
252     
253 
254     
255     constructor() public {
256 
257         owner = msg.sender;
258         devAddress = msg.sender;
259         localBankOfEth = BankOfEth(bankOfEthAddress);
260         
261         rounds.length++;
262         GameRound storage rnd = rounds[0];
263         latestRoundID = 0;
264 
265         rnd.lastInvestor = msg.sender;
266         rnd.price = STARTING_KEY_PRICE;
267         rnd.hardDeadline = now + HARD_DEADLINE_DURATION;
268         rnd.softDeadline = now + soft_deadline_duration;
269         jackpotSeed = 0; 
270         rnd.jackpot = jackpotSeed;
271         
272 
273         
274     }
275     
276     function () public payable {
277         buyKeys(address(0x0));
278     }
279     
280     function investorInfo(address investor, uint roundID) external view
281     returns(uint keys, uint totalReturns, uint referralReturns) 
282     {
283         GameRound storage rnd = rounds[roundID];
284         keys = rnd.safeBreakers[investor].keys;
285         (totalReturns, referralReturns) = estimateReturns(investor, roundID);
286     }
287     function estimateReturns(address investor, uint roundID) public view 
288     returns (uint totalReturns, uint refReturns) 
289     {
290         GameRound storage rnd = rounds[roundID];
291         uint outstanding;
292         if(rounds.length > 1) {
293             if(hasReturns(investor, roundID - 1)) {
294                 GameRound storage prevRnd = rounds[roundID - 1];
295                 outstanding = _outstandingReturns(investor, prevRnd);
296             }
297         }
298 
299         outstanding += _outstandingReturns(investor, rnd);
300         
301         totalReturns = vaults[investor].totalReturns + outstanding;
302         refReturns = vaults[investor].refReturns;
303     }
304     
305     function roundInfo(uint roundID) external view 
306     returns(
307         address leader, 
308         uint price,
309         uint jackpot, 
310         uint airdrop, 
311         uint keys, 
312         uint totalInvested,
313         uint distributedReturns,
314         uint _hardDeadline,
315         uint _softDeadline,
316         bool finalized
317         )
318     {
319         GameRound storage rnd = rounds[roundID];
320         leader = rnd.lastInvestor;
321         price = rnd.price;
322         jackpot = rnd.jackpot;
323         airdrop = rnd.airdropPot;
324         keys = rnd.totalKeys;
325         totalInvested = rnd.totalInvested;
326         distributedReturns = m_currentRoundJackpotPercent.mul(rnd.totalInvested);
327         //wmul(rnd.totalInvested, RETURNS_FRACTION);
328         _hardDeadline = rnd.hardDeadline;
329         _softDeadline = rnd.softDeadline;
330         finalized = rnd.finalized;
331     }
332     
333     function totalsInfo() external view 
334     returns(
335         uint totalReturns,
336         uint totalKeys,
337         uint totalJackpots
338     ) {
339         GameRound storage rnd = rounds[latestRoundID];
340         if(rnd.softDeadline > now) {
341             totalKeys = totalKeysSold + rnd.totalKeys;
342             totalReturns = totalEarningsGenerated + m_currentRoundJackpotPercent.mul(rnd.totalInvested); 
343             // wmul(rnd.totalInvested, RETURNS_FRACTION);
344         } else {
345             totalKeys = totalKeysSold;
346             totalReturns = totalEarningsGenerated;
347         }
348         totalJackpots = totalJackpotsWon;
349     }
350 
351     
352     function reinvestReturns(uint value) public {        
353         reinvestReturns(value, address(0x0));
354     }
355 
356     function reinvestReturns(uint value, address ref) public {        
357         GameRound storage rnd = rounds[latestRoundID];
358         _updateReturns(msg.sender, rnd);        
359         require(vaults[msg.sender].totalReturns >= value, "Can't spend what you don't have");        
360         vaults[msg.sender].totalReturns = vaults[msg.sender].totalReturns.sub(value);
361         vaults[msg.sender].refReturns = min(vaults[msg.sender].refReturns, vaults[msg.sender].totalReturns);
362         unclaimedReturns = unclaimedReturns.sub(value);
363         _purchase(rnd, value, ref);
364     }
365     function withdrawReturns() public {
366         GameRound storage rnd = rounds[latestRoundID];
367 
368         if(rounds.length > 1) {// check if they also have returns from before
369             if(hasReturns(msg.sender, latestRoundID - 1)) {
370                 GameRound storage prevRnd = rounds[latestRoundID - 1];
371                 _updateReturns(msg.sender, prevRnd);
372             }
373         }
374         _updateReturns(msg.sender, rnd);
375         uint amount = vaults[msg.sender].totalReturns;
376         require(amount > 0, "Nothing to withdraw!");
377         unclaimedReturns = unclaimedReturns.sub(amount);
378         vaults[msg.sender].totalReturns = 0;
379         vaults[msg.sender].refReturns = 0;
380         
381         rnd.safeBreakers[msg.sender].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
382         msg.sender.transfer(amount);
383 
384         emit ReturnsWithdrawn(msg.sender, amount, now);
385     }
386     function hasReturns(address investor, uint roundID) public view returns (bool) {
387         GameRound storage rnd = rounds[roundID];
388         return rnd.cumulativeReturnsPoints > rnd.safeBreakers[investor].lastCumulativeReturnsPoints;
389     }
390     function updateMyReturns(uint roundID) public {
391         GameRound storage rnd = rounds[roundID];
392         _updateReturns(msg.sender, rnd);
393     }
394     
395     function finalizeLastRound() public {
396         GameRound storage rnd = rounds[latestRoundID];
397         _finalizeRound(rnd);
398     }
399     function finalizeAndRestart() public payable {
400         finalizeLastRound();
401         startNewRound(address(0x0));
402     }
403     
404     function finalizeAndRestart(address _referer) public payable {
405         finalizeLastRound();
406         startNewRound(_referer);
407     }
408     
409     event debugLog(uint _num, string _string);
410     
411     function startNewRound(address _referer) public payable {
412         
413         require(rounds[latestRoundID].finalized, "Previous round not finalized");
414         require(rounds[latestRoundID].softDeadline < now, "Previous round still running");
415         
416         uint _rID = rounds.length++; // first round is 0
417         GameRound storage rnd = rounds[_rID];
418         latestRoundID = _rID;
419 
420         rnd.lastInvestor = msg.sender;
421         rnd.price = STARTING_KEY_PRICE;
422         rnd.hardDeadline = now + HARD_DEADLINE_DURATION;
423         rnd.softDeadline = now + soft_deadline_duration;
424         rnd.jackpot = jackpotSeed;
425         jackpotSeed = 0; 
426 
427         _purchase(rnd, msg.value, _referer);
428         emit RoundStarted(_rID, rnd.hardDeadline, now);
429     }
430     
431     
432     function buyKeys(address _referer) public payable notOnPause {
433         require(msg.value >= minInvestment);
434         if(rounds.length > 0) {
435             GameRound storage rnd = rounds[latestRoundID];   
436                
437             _purchase(rnd, msg.value, _referer);            
438         } else {
439             revert("Not yet started");
440         }
441         
442     }
443     
444     
445     function _purchase(GameRound storage rnd, uint value, address referer) internal {
446         require(rnd.softDeadline >= now, "After deadline!");
447         require(value >= rnd.price/10, "Not enough Ether!");
448         rnd.totalInvested = rnd.totalInvested.add(value);
449 
450         // Set the last investor (to win the jackpot after the deadline)
451         if(value >= rnd.price)
452             rnd.lastInvestor = msg.sender;
453         
454         
455         _airDrop(rnd, value);
456         
457 
458         _splitRevenue(rnd, value, referer);
459         
460         _updateReturns(msg.sender, rnd);
461         
462         uint newKeys = _issueKeys(rnd, msg.sender, value);
463 
464 
465         uint timeIncreases = newKeys/WAD;// since 1 key is represented by 1 * 10^18, divide by 10^18
466         // adjust soft deadline to new soft deadline
467         uint newDeadline = rnd.softDeadline.add( timeIncreases.mul(TIME_PER_KEY));
468         
469         rnd.softDeadline = min(newDeadline, now + soft_deadline_duration);
470         // If after hard deadline, double the price every price increase periods
471         if(now > rnd.hardDeadline) {
472             if(now > rnd.lastPriceIncreaseTime + PRICE_INCREASE_PERIOD) {
473                 rnd.price = rnd.price * 2;
474                 rnd.lastPriceIncreaseTime = now;
475             }
476         }
477     }
478     function _issueKeys(GameRound storage rnd, address _safeBreaker, uint value) internal returns(uint) {    
479         if(rnd.safeBreakers[_safeBreaker].lastCumulativeReturnsPoints == 0) {
480             rnd.safeBreakers[_safeBreaker].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
481         }    
482         
483         uint newKeys = wdiv(value, rnd.price);
484         
485         //bonuses:
486         if(value >= 100 ether) {
487             newKeys = newKeys.mul(2);//get double keys if you paid more than 100 ether
488         } else if(value >= 10 ether) {
489             newKeys = newKeys.add(newKeys/2);//50% bonus
490         } else if(value >= 1 ether) {
491             newKeys = newKeys.add(newKeys/3);//33% bonus
492         } else if(value >= 100 finney) {
493             newKeys = newKeys.add(newKeys/10);//10% bonus
494         }
495 
496         rnd.safeBreakers[_safeBreaker].keys = rnd.safeBreakers[_safeBreaker].keys.add(newKeys);
497         rnd.totalKeys = rnd.totalKeys.add(newKeys);
498         emit KeysIssued(_safeBreaker, newKeys, now);
499         return newKeys;
500     }    
501     function _updateReturns(address _safeBreaker, GameRound storage rnd) internal {
502         if(rnd.safeBreakers[_safeBreaker].keys == 0) {
503             return;
504         }
505         
506         uint outstanding = _outstandingReturns(_safeBreaker, rnd);
507 
508         // if there are any returns, transfer them to the investor's vaults
509         if (outstanding > 0) {
510             vaults[_safeBreaker].totalReturns = vaults[_safeBreaker].totalReturns.add(outstanding);
511         }
512 
513         rnd.safeBreakers[_safeBreaker].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
514     }
515     function _outstandingReturns(address _safeBreaker, GameRound storage rnd) internal view returns(uint) {
516         if(rnd.safeBreakers[_safeBreaker].keys == 0) {
517             return 0;
518         }
519         // check if there've been new returns
520         uint newReturns = rnd.cumulativeReturnsPoints.sub(
521             rnd.safeBreakers[_safeBreaker].lastCumulativeReturnsPoints
522             );
523 
524         uint outstanding = 0;
525         if(newReturns != 0) { 
526             // outstanding returns = (total new returns points * ivestor keys) / MULTIPLIER
527             // The MULTIPLIER is used also at the point of returns disbursment
528             outstanding = newReturns.mul(rnd.safeBreakers[_safeBreaker].keys) / MULTIPLIER;
529         }
530 
531         return outstanding;
532     }
533     function _splitRevenue(GameRound storage rnd, uint value, address ref) internal {
534         uint roundReturns; // how much to pay in dividends to round players
535         
536 
537         if(ref != address(0x0)) {
538 
539             // only pay referrals for the first investment of each player
540             if(
541                 (!m_referrals[msg.sender] && limitedReferralsMode == true)
542                 ||
543                 limitedReferralsMode == false
544                 ) {
545             
546             
547                 uint _referralEarning = m_refPercent.mul(value);
548                 unclaimedReturns = unclaimedReturns.add(_referralEarning);
549                 vaults[ref].totalReturns = vaults[ref].totalReturns.add(_referralEarning);
550                 vaults[ref].refReturns = vaults[ref].refReturns.add(_referralEarning);
551                 
552                 value = value.sub(_referralEarning);
553                 
554                 m_referrals[msg.sender] = true;
555                 
556             }
557         } else {
558         }
559         
560         roundReturns = m_investorsPercent.mul(value); // 65%
561         
562         uint airdrop_value = m_airdropPercent.mul(value);
563         
564         uint jackpot_value = m_currentRoundJackpotPercent.mul(value); //15%
565         
566         uint dev_value = m_devPercent.mul(value);
567         
568         uint bankOfEth_profit = m_bankOfEthProfitPercent.mul(value);
569         localBankOfEth.receiveExternalProfits.value(bankOfEth_profit)();
570         
571         // if this is the first purchase, roundReturns goes to jackpot (no one can claim these returns otherwise)
572         if(rnd.totalKeys == 0) {
573             rnd.jackpot = rnd.jackpot.add(roundReturns);
574         } else {
575             _disburseReturns(rnd, roundReturns);
576         }
577         
578         rnd.airdropPot = rnd.airdropPot.add(airdrop_value);
579         rnd.jackpot = rnd.jackpot.add(jackpot_value);
580         
581         devAddress.transfer(dev_value);
582         
583     }
584     function _disburseReturns(GameRound storage rnd, uint value) internal {
585         emit EthDistributed(value, now);
586         unclaimedReturns = unclaimedReturns.add(value);// keep track of unclaimed returns
587         // The returns points represent returns*MULTIPLIER/totalkeys (at the point of purchase)
588         // This allows us to keep outstanding balances of keyholders when the total supply changes in real time
589         if(rnd.totalKeys == 0) {
590             //rnd.cumulativeReturnsPoints = mul(value, MULTIPLIER) / wdiv(value, rnd.price);
591             rnd.cumulativeReturnsPoints = value.mul(MULTIPLIER) / wdiv(value, rnd.price);
592         } else {
593             rnd.cumulativeReturnsPoints = rnd.cumulativeReturnsPoints.add(
594                 value.mul(MULTIPLIER) / rnd.totalKeys
595             );
596         }
597     }
598     function _airDrop(GameRound storage rnd, uint value) internal {
599         require(msg.sender == tx.origin, "Only Humans Allowed! (or scripts that don't use smart contracts)!");
600         if(value > 100 finney) {
601             /**
602                 Creates a random number from the last block hash and current timestamp.
603                 One could add more seemingly random data like the msg.sender, etc, but that doesn't 
604                 make it harder for a miner to manipulate the result in their favor (if they intended to).
605              */
606             uint chance = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), now)));
607             if(chance % 200 == 0) {// once in 200 times
608                 uint prize = rnd.airdropPot / 2;// win half of the pot, regardless of how much you paid
609                 rnd.airdropPot = rnd.airdropPot / 2;
610                 vaults[msg.sender].totalReturns = vaults[msg.sender].totalReturns.add(prize);
611                 unclaimedReturns = unclaimedReturns.add(prize);
612                 totalJackpotsWon += prize;
613                 emit AirdropWon(msg.sender, prize, now);
614             }
615         }
616     }
617     
618     
619     function _finalizeRound(GameRound storage rnd) internal {
620         require(!rnd.finalized, "Already finalized!");
621         require(rnd.softDeadline < now, "Round still running!");
622 
623 
624         // Transfer jackpot to winner's vault
625         vaults[rnd.lastInvestor].totalReturns = vaults[rnd.lastInvestor].totalReturns.add(rnd.jackpot);
626         unclaimedReturns = unclaimedReturns.add(rnd.jackpot);
627         
628         emit JackpotWon(rnd.lastInvestor, rnd.jackpot, now);
629         totalJackpotsWon += rnd.jackpot;
630         // transfer the leftover to the next round's jackpot
631         jackpotSeed = jackpotSeed.add( m_nextRoundSeedPercent.mul(rnd.totalInvested));
632             
633         //Empty the AD pot if it has a balance.
634         jackpotSeed = jackpotSeed.add(rnd.airdropPot);
635         
636         //Send out dividends to token holders
637         //uint _div;
638         
639         //_div = wmul(rnd.totalInvested, DIVIDENDS_FRACTION);            
640         
641         //token.disburseDividends.value(_div)();
642         //totalDividendsPaid += _div;
643         totalKeysSold += rnd.totalKeys;
644         totalEarningsGenerated += m_currentRoundJackpotPercent.mul(rnd.totalInvested);
645 
646         rnd.finalized = true;
647     }
648     
649     // Owner only functions    
650     function p_setOwner(address _owner) public onlyOwner {
651         owner = _owner;
652     }
653     function p_setDevAddress(address _devAddress) public onlyOwner {
654         devAddress = _devAddress;
655     }
656     function p_setCurrentRoundJackpotPercent(uint num, uint dem) public onlyOwner {
657         m_currentRoundJackpotPercent = Percent.percent(num, dem);
658     }
659     function p_setInvestorsPercent(uint num, uint dem) public onlyOwner {
660         m_investorsPercent = Percent.percent(num, dem);
661     }
662     function p_setDevPercent(uint num, uint dem) public onlyOwner {
663         m_devPercent = Percent.percent(num, dem);
664     }
665     function p_setNextRoundSeedPercent(uint num, uint dem) public onlyOwner {
666         m_nextRoundSeedPercent = Percent.percent(num, dem);
667     }
668     function p_setAirdropPercent(uint num, uint dem) public onlyOwner {
669         m_airdropPercent = Percent.percent(num, dem);
670     }
671     function p_setBankOfEthProfitPercent(uint num, uint dem) public onlyOwner {
672         m_bankOfEthProfitPercent = Percent.percent(num, dem);
673     }
674     function p_setMinInvestment(uint _minInvestment) public onlyOwner {
675         minInvestment = _minInvestment;
676     }
677     function p_setMaxInvestment(uint _maxInvestment) public onlyOwner {
678         maxInvestment = _maxInvestment;
679     }
680     function p_setGamePaused(bool _gamePaused) public onlyOwner {
681         gamePaused = _gamePaused;
682     }
683     function p_setRoundDuration(uint256 _roundDuration) public onlyOwner {
684         roundDuration = _roundDuration;
685     }
686     function p_setBankOfEthAddress(address _bankOfEthAddress) public onlyOwner {
687         bankOfEthAddress = _bankOfEthAddress;
688         localBankOfEth = BankOfEth(bankOfEthAddress);
689     }
690     function p_setLimitedReferralsMode(bool _limitedReferralsMode) public onlyOwner {
691         limitedReferralsMode = _limitedReferralsMode;
692     }
693     function p_setSoft_deadline_duration(uint _soft_deadline_duration) public onlyOwner {
694         soft_deadline_duration = _soft_deadline_duration;
695     }
696     // Util functions
697     function notZeroAndNotSender(address addr) internal view returns(bool) {
698         return addr.notZero() && addr != msg.sender;
699     }
700     function min(uint x, uint y) internal pure returns (uint z) {
701         return x <= y ? x : y;
702     }
703     function max(uint x, uint y) internal pure returns (uint z) {
704         return x >= y ? x : y;
705     }
706     function wmul(uint x, uint y) internal pure returns (uint z) {
707         z = x.mul(y).add(WAD/2) / WAD;
708         //z = add(mul(x, y), WAD / 2) / WAD;
709     }
710     function rmul(uint x, uint y) internal pure returns (uint z) {
711         z = x.mul(y).add(RAY/2) / RAY;
712         //z = add(mul(x, y), RAY / 2) / RAY;
713     }
714     function wdiv(uint x, uint y) internal pure returns (uint z) {
715         z = x.mul(WAD).add(y/2)/y;
716         //z = add(mul(x, WAD), y / 2) / y;
717     }
718     function rdiv(uint x, uint y) internal pure returns (uint z) {
719         z = x.mul(RAY).add(y/2)/y;
720         //z = add(mul(x, RAY), y / 2) / y;
721     }
722     
723     uint op;
724     function gameOp() public {
725         op++;
726     }
727 
728 }