1 pragma solidity ^0.4.23;
2 
3 /**
4 *
5 * complied with .4.25+commit.59dbf8f1.Emscripten.clang
6 * 2018-09-07
7 * With Optimization disabled
8 *
9 * Contacts: support (at) bankofeth.app
10 *           https://twitter.com/bankofeth
11 *           https://discord.gg/d5c7pfn
12 *           http://t.me/bankofeth
13 *           http://reddit.com/r/bankofeth
14 *
15 * PLAY NOW: https:://bankofeth.app
16 *  
17 * --- BANK OF ETH --------------------------------------------------------------
18 *
19 * Provably fair Banking Game -> Invest your $ETH and gain daily returns on all 
20 * profits made!
21 *
22 * -- No false promises like many other (Unmentioned!!) dApps...
23 * -- Real, sustainable returns because we know business, we know banking, we 
24 *    know gaming!
25 * -- Returns based on INPUTS into the contract - not false promises or false 
26 *    gaurantees
27 * -- Gain a return when people play the game, not a false gauranteed endless 
28 *    profit with an exitscam at the end!
29 * -- Contract verified and open from day 1 so you know we can't "exitscam" you!
30 * -- Set to become the BIGGEST home of $ETH gaming where you can take OWNERSHIP 
31 *    and PROFIT
32 *
33 * --- GAMEPLAY -----------------------------------------------------------------
34 *
35 *   Every day 5% of ALL profits are put into the "Investor Pot":
36 *
37 *          profitDays[currentProfitDay].dailyProfit
38 *
39 *   This pot is then split up amongst EVERY investor in the game, proportional to the amount 
40 *   they have invested.  
41 *
42 *   EXAMPLE:
43 *
44 *   Daily Investments: 20 $ETH
45 *   Current Players  : 50 - All even investors with 1 $ETH in the pot
46 *
47 *   So the dailyProfit for the day would be 5% of 20 $ETH = 1 $ETH 
48 *   Split evenly in this case amongst the 50 players = 
49 *   1000000000000000000 wei / 50 = 0.02 $ETH profit for that day each!
50 *
51 *   EXAMPLE 2:
52 *
53 *   A more realistic example is a bigger profit per day and different 
54 *   distribtion of the pot, e.g.
55 *
56 *   Daily Investments: 100 $ETH
57 *   Current Players  : 200 - But our example player has 10% of the total amount 
58 *   invested
59 *
60 *   dailyProfit for this day is 5% of the 100 $ETH = 5 $ETH 
61 *   (5000000000000000000 wei)
62 * 
63 *   And our example player would receive 10% of that = 0.5 $ETH for the day
64 *   Not a bad return for having your $ETH just sitting there!
65 *
66 *   Remember you get a return EVERY DAY that people play any of our games 
67 *   or invest!
68 *
69 * -- INVESTMENT RULES --
70 *
71 *   The investment rules are simple:
72 *
73 *   When you invest into the game there is a minimum investment of 0.01 $ETH
74 *
75 *   Of that it is split as follows:
76 *
77 *      80% Goes directly into your personal investment fund
78 *      5%  Goes into the daily profit fund for that day
79 *      15% Goes into the marketing, development and admin fund
80 *
81 *   Simple as that!
82 *
83 *   By sitcking to these simple rules the games becomes self-sufficient!
84 *
85 *   The fees enable regular daily payments to all players.
86 *
87 *   When you choose to withdraw your investment the same fees apply (80/5/15) 
88 *   - this is again to ensure that the game is self-sufficient and sustainable!
89 * 
90 * 
91 * --- REFERRALS ----------------------------------------------------------------
92 *                                                                                        
93 *   Referrals allow you to earn a bonus 3% on every person you refer to 
94 *   BankOfEth!
95 *
96 * - All future games launched will feed into the Profit Share Mechanism 
97 *   (See receiveProfits() method)
98 *
99 * - PLAY NOW: https://BankOfEth.app
100 *
101 *
102 * --- COPYRIGHT ----------------------------------------------------------------
103 * 
104 *   This source code is provided for verification and audit purposes only and 
105 *   no license of re-use is granted.
106 *   
107 *   (C) Copyright 2018 BankOfEth.app
108 *   
109 *   
110 *   Sub-license, white-label, solidity or Ethereum development enquiries please 
111 *   contact support (at) bankofeth.app
112 *   
113 *   
114 * PLAY NOW: https:://bankofeth.app
115 * 
116 */
117 
118 
119 
120 library SafeMath {
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a * b;
123         assert(a == 0 || c / a == b);
124         return c;
125     }
126 
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         // assert(b > 0); // Solidity automatically throws when dividing by 0
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131         return c;
132     }
133 
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         assert(b <= a);
136         return a - b;
137     }
138 
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         assert(c >= a);
142         return c;
143     }
144 }
145 
146 library Zero {
147   function requireNotZero(uint a) internal pure {
148     require(a != 0, "require not zero");
149   }
150 
151   function requireNotZero(address addr) internal pure {
152     require(addr != address(0), "require not zero address");
153   }
154 
155   function notZero(address addr) internal pure returns(bool) {
156     return !(addr == address(0));
157   }
158 
159   function isZero(address addr) internal pure returns(bool) {
160     return addr == address(0);
161   }
162 }
163 
164 library Percent {
165 
166   struct percent {
167     uint num;
168     uint den;
169   }
170   function mul(percent storage p, uint a) internal view returns (uint) {
171     if (a == 0) {
172       return 0;
173     }
174     return a*p.num/p.den;
175   }
176 
177   function div(percent storage p, uint a) internal view returns (uint) {
178     return a/p.num*p.den;
179   }
180 
181   function sub(percent storage p, uint a) internal view returns (uint) {
182     uint b = mul(p, a);
183     if (b >= a) return 0;
184     return a - b;
185   }
186 
187   function add(percent storage p, uint a) internal view returns (uint) {
188     return a + mul(p, a);
189   }
190 }
191 
192 library ToAddress {
193   function toAddr(uint source) internal pure returns(address) {
194     return address(source);
195   }
196 
197   function toAddr(bytes source) internal pure returns(address addr) {
198     assembly { addr := mload(add(source,0x14)) }
199     return addr;
200   }
201 }
202 
203 contract BankOfEth {
204     
205     using SafeMath for uint256;
206     using Percent for Percent.percent;
207     using Zero for *;
208     using ToAddress for *;
209 
210     // Events    
211     event LogPayDividendsOutOfFunds(address sender, uint256 total_value, uint256 total_refBonus, uint256 timestamp);
212     event LogPayDividendsSuccess(address sender, uint256 total_value, uint256 total_refBonus, uint256 timestamp);
213     event LogInvestmentWithdrawn(address sender, uint256 total_value, uint256 timestamp);
214     event LogReceiveExternalProfits(address sender, uint256 total_value, uint256 timestamp);
215     event LogInsertInvestor(address sender, uint256 keyIndex, uint256 init_value, uint256 timestamp);
216     event LogInvestment(address sender, uint256 total_value, uint256 value_after, uint16 profitDay, address referer, uint256 timestamp);
217     event LogPayDividendsReInvested(address sender, uint256 total_value, uint256 total_refBonus, uint256 timestamp);
218     
219     
220     address owner;
221     address devAddress;
222     
223     // settings
224     Percent.percent private m_devPercent = Percent.percent(15, 100); // 15/100*100% = 15%
225     Percent.percent private m_investorFundPercent = Percent.percent(5, 100); // 5/100*100% = 5%
226     Percent.percent private m_refPercent = Percent.percent(3, 100); // 3/100*100% = 3%
227     Percent.percent private m_devPercent_out = Percent.percent(15, 100); // 15/100*100% = 15%
228     Percent.percent private m_investorFundPercent_out = Percent.percent(5, 100); // 5/100*100% = 5%
229     
230     uint256 public minInvestment = 10 finney; // 0.1 eth
231     uint256 public maxInvestment = 2000 ether; 
232     uint256 public gameDuration = (24 hours);
233     bool public gamePaused = false;
234     
235     // Investor details
236     struct investor {
237         uint256 keyIndex;
238         uint256 value;
239         uint256 refBonus;
240         uint16 startDay;
241         uint16 lastDividendDay;
242         uint16 investmentsMade;
243     }
244     struct iteratorMap {
245         mapping(address => investor) data;
246         address[] keys;
247     }
248     iteratorMap private investorMapping;
249     
250     mapping(address => bool) private m_referrals; // we only pay out on the first set of referrals
251     
252     // profit days
253     struct profitDay {
254         uint256 dailyProfit;
255         uint256 dailyInvestments; // number of investments
256         uint256 dayStartTs;
257         uint16 day;
258     }
259     
260     // Game vars
261     profitDay[] public profitDays;
262     uint16 public currentProfitDay;
263 
264     uint256 public dailyInvestments;
265     uint256 public totalInvestments;
266     uint256 public totalInvestmentFund;
267     uint256 public totalProfits;
268     uint256 public latestKeyIndex;
269     
270     // modifiers
271     modifier onlyOwner() {
272         require(msg.sender == owner);
273         _;
274     }
275     
276     modifier notOnPause() {
277         require(gamePaused == false, "Game Paused");
278         _;
279     }
280     
281     modifier checkDayRollover() {
282         
283         if(now.sub(profitDays[currentProfitDay].dayStartTs).div(gameDuration) > 0) {
284             currentProfitDay++;
285             dailyInvestments = 0;
286             profitDays.push(profitDay(0,0,now,currentProfitDay));
287         }
288         _;
289     }
290 
291     
292     constructor() public {
293 
294         owner = msg.sender;
295         devAddress = msg.sender;
296         investorMapping.keys.length++;
297         profitDays.push(profitDay(0,0,now,0));
298         currentProfitDay = 0;
299         dailyInvestments = 0;
300         totalInvestments = 0;
301         totalInvestmentFund = 0;
302         totalProfits = 0;
303         latestKeyIndex = 1;
304     }
305     
306     function() public payable {
307 
308         if (msg.value == 0)
309             withdrawDividends();
310         else 
311         {
312             address a = msg.data.toAddr();
313             address refs;
314             if (a.notZero()) {
315                 refs = a;
316                 invest(refs); 
317             } else {
318                 invest(refs);
319             }
320         }
321     }
322     
323     function reinvestDividends() public {
324         require(investor_contains(msg.sender));
325 
326         uint total_value;
327         uint total_refBonus;
328         
329         (total_value, total_refBonus) = getDividends(false, msg.sender);
330         
331         require(total_value+total_refBonus > 0, "No Dividends available yet!");
332         
333         investorMapping.data[msg.sender].value = investorMapping.data[msg.sender].value.add(total_value + total_refBonus);
334         
335         
336         
337         investorMapping.data[msg.sender].lastDividendDay = currentProfitDay;
338         investor_clearRefBonus(msg.sender);
339         emit LogPayDividendsReInvested(msg.sender, total_value, total_refBonus, now);
340         
341     }
342     
343     
344     function withdrawDividends() public {
345         require(investor_contains(msg.sender));
346 
347         uint total_value;
348         uint total_refBonus;
349         
350         (total_value, total_refBonus) = getDividends(false, msg.sender);
351         
352         require(total_value+total_refBonus > 0, "No Dividends available yet!");
353         
354         uint16 _origLastDividendDay = investorMapping.data[msg.sender].lastDividendDay;
355         
356         investorMapping.data[msg.sender].lastDividendDay = currentProfitDay;
357         investor_clearRefBonus(msg.sender);
358         
359         if(total_refBonus > 0) {
360             investorMapping.data[msg.sender].refBonus = 0;
361             if (msg.sender.send(total_value+total_refBonus)) {
362                 emit LogPayDividendsSuccess(msg.sender, total_value, total_refBonus, now);
363             } else {
364                 investorMapping.data[msg.sender].lastDividendDay = _origLastDividendDay;
365                 investor_addRefBonus(msg.sender, total_refBonus);
366             }
367         } else {
368             if (msg.sender.send(total_value)) {
369                 emit LogPayDividendsSuccess(msg.sender, total_value, 0, now);
370             } else {
371                 investorMapping.data[msg.sender].lastDividendDay = _origLastDividendDay;
372                 investor_addRefBonus(msg.sender, total_refBonus);
373             }
374         }
375     }
376     
377     function showLiveDividends() public view returns(uint256 total_value, uint256 total_refBonus) {
378         require(investor_contains(msg.sender));
379         return getDividends(true, msg.sender);
380     }
381     
382     function showDividendsAvailable() public view returns(uint256 total_value, uint256 total_refBonus) {
383         require(investor_contains(msg.sender));
384         return getDividends(false, msg.sender);
385     }
386 
387 
388     function invest(address _referer) public payable notOnPause checkDayRollover {
389         require(msg.value >= minInvestment);
390         require(msg.value <= maxInvestment);
391         
392         uint256 devAmount = m_devPercent.mul(msg.value);
393         
394         
395         // calc referalBonus....
396         // We pay any referal bonuses out of our devAmount = marketing spend
397         // Could result in us not having much dev fund for heavy referrals
398 
399         // only pay referrals for the first investment of each player
400         if(!m_referrals[msg.sender]) {
401             if(notZeroAndNotSender(_referer) && investor_contains(_referer)) {
402                 // this user was directly refered by _referer
403                 // pay _referer commission...
404                 uint256 _reward = m_refPercent.mul(msg.value);
405                 devAmount.sub(_reward);
406                 assert(investor_addRefBonus(_referer, _reward));
407                 m_referrals[msg.sender] = true;
408 
409                 
410             }
411         }
412         
413         // end referalBonus
414         
415         devAddress.transfer(devAmount);
416         uint256 _profit = m_investorFundPercent.mul(msg.value);
417         profitDays[currentProfitDay].dailyProfit = profitDays[currentProfitDay].dailyProfit.add(_profit);
418         
419         totalProfits = totalProfits.add(_profit);
420 
421         uint256 _investorVal = msg.value;
422         _investorVal = _investorVal.sub(m_devPercent.mul(msg.value));
423         _investorVal = _investorVal.sub(m_investorFundPercent.mul(msg.value));
424         
425         if(investor_contains(msg.sender)) {
426             investorMapping.data[msg.sender].value += _investorVal;
427             investorMapping.data[msg.sender].investmentsMade ++;
428         } else {
429             assert(investor_insert(msg.sender, _investorVal));
430         }
431         totalInvestmentFund = totalInvestmentFund.add(_investorVal);
432         profitDays[currentProfitDay].dailyInvestments = profitDays[currentProfitDay].dailyInvestments.add(_investorVal);
433         
434         dailyInvestments++;
435         totalInvestments++;
436         
437         emit LogInvestment(msg.sender, msg.value, _investorVal, currentProfitDay, _referer, now);
438         
439     }
440     
441     // tested - needs confirming send completed
442     function withdrawInvestment() public {
443         require(investor_contains(msg.sender));
444         require(investorMapping.data[msg.sender].value > 0);
445         
446         uint256 _origValue = investorMapping.data[msg.sender].value;
447         investorMapping.data[msg.sender].value = 0;
448         
449         // There is a tax on the way out too...
450         uint256 _amountToSend = _origValue.sub(m_devPercent_out.mul(_origValue));
451         uint256 _profit = m_investorFundPercent_out.mul(_origValue);
452         _amountToSend = _amountToSend.sub(m_investorFundPercent_out.mul(_profit));
453         
454         
455         totalInvestmentFund = totalInvestmentFund.sub(_origValue);
456         
457         if(!msg.sender.send(_amountToSend)) {
458             investorMapping.data[msg.sender].value = _origValue;
459             totalInvestmentFund = totalInvestmentFund.add(_origValue);
460         } else {
461             
462             devAddress.transfer(m_devPercent_out.mul(_origValue));
463             profitDays[currentProfitDay].dailyProfit = profitDays[currentProfitDay].dailyProfit.add(_profit);
464             totalProfits = totalProfits.add(_profit);
465             
466             emit LogInvestmentWithdrawn(msg.sender, _origValue, now);
467         }
468     }
469     
470     
471     // receive % of profits from other games
472     function receiveExternalProfits() public payable checkDayRollover {
473         // No checks on who is sending... if someone wants to send us free ETH let them!
474         
475         profitDays[currentProfitDay].dailyProfit = profitDays[currentProfitDay].dailyProfit.add(msg.value);
476         profitDays[currentProfitDay].dailyInvestments = profitDays[currentProfitDay].dailyInvestments.add(msg.value);
477         emit LogReceiveExternalProfits(msg.sender, msg.value, now);
478     }
479     
480     
481 
482     // investor management
483     
484     function investor_insert(address addr, uint value) internal returns (bool) {
485         uint keyIndex = investorMapping.data[addr].keyIndex;
486         if (keyIndex != 0) return false; // already exists
487         investorMapping.data[addr].value = value;
488         keyIndex = investorMapping.keys.length++;
489         investorMapping.data[addr].keyIndex = keyIndex;
490         investorMapping.data[addr].startDay = currentProfitDay;
491         investorMapping.data[addr].lastDividendDay = currentProfitDay;
492         investorMapping.data[addr].investmentsMade = 1;
493         investorMapping.keys[keyIndex] = addr;
494         emit LogInsertInvestor(addr, keyIndex, value, now);
495         return true;
496     }
497     function investor_addRefBonus(address addr, uint refBonus) internal returns (bool) {
498         if (investorMapping.data[addr].keyIndex == 0) return false;
499         investorMapping.data[addr].refBonus += refBonus;
500         return true;
501     }
502     function investor_clearRefBonus(address addr) internal returns (bool) {
503         if (investorMapping.data[addr].keyIndex == 0) return false;
504         investorMapping.data[addr].refBonus = 0;
505         return true;
506     }
507     function investor_contains(address addr) public view returns (bool) {
508         return investorMapping.data[addr].keyIndex > 0;
509     }
510     function investor_getShortInfo(address addr) public view returns(uint, uint) {
511         return (
512           investorMapping.data[addr].value,
513           investorMapping.data[addr].refBonus
514         );
515     }
516     function investor_getMediumInfo(address addr) public view returns(uint, uint, uint16) {
517         return (
518           investorMapping.data[addr].value,
519           investorMapping.data[addr].refBonus,
520           investorMapping.data[addr].investmentsMade
521         );
522     }
523     
524     // Owner only functions    
525     
526 
527     
528 
529     function p_setOwner(address _owner) public onlyOwner {
530         owner = _owner;
531     }
532     function p_setDevAddress(address _devAddress) public onlyOwner {
533         devAddress = _devAddress;
534     }
535     function p_setDevPercent(uint num, uint dem) public onlyOwner {
536         m_devPercent = Percent.percent(num, dem);
537     }
538     function p_setInvestorFundPercent(uint num, uint dem) public onlyOwner {
539         m_investorFundPercent = Percent.percent(num, dem);
540     }
541     function p_setDevPercent_out(uint num, uint dem) public onlyOwner {
542         m_devPercent_out = Percent.percent(num, dem);
543     }
544     function p_setInvestorFundPercent_out(uint num, uint dem) public onlyOwner {
545         m_investorFundPercent_out = Percent.percent(num, dem);
546     }
547     function p_setRefPercent(uint num, uint dem) public onlyOwner {
548         m_refPercent = Percent.percent(num, dem);
549     }
550     function p_setMinInvestment(uint _minInvestment) public onlyOwner {
551         minInvestment = _minInvestment;
552     }
553     function p_setMaxInvestment(uint _maxInvestment) public onlyOwner {
554         maxInvestment = _maxInvestment;
555     }
556     function p_setGamePaused(bool _gamePaused) public onlyOwner {
557         gamePaused = _gamePaused;
558     }
559     function p_setGameDuration(uint256 _gameDuration) public onlyOwner {
560         gameDuration = _gameDuration;
561     }
562 
563     // Util functions
564     function notZeroAndNotSender(address addr) internal view returns(bool) {
565         return addr.notZero() && addr != msg.sender;
566     }
567     
568     
569     function getDividends(bool _includeCurrentDay, address _investor) internal view returns(uint256, uint256) {
570         require(investor_contains(_investor));
571         uint16 i = investorMapping.data[_investor].lastDividendDay;
572         uint total_value;
573         uint total_refBonus;
574         total_value = 0;
575         total_refBonus = 0;
576         
577         uint16 _option = 0;
578         if(_includeCurrentDay)
579             _option++;
580 
581         uint _value;
582         (_value, total_refBonus) = investor_getShortInfo(_investor);
583 
584         uint256 _profitPercentageEminus7Multi = (_value*10000000 / totalInvestmentFund * 10000000) / 10000000;
585 
586         for(i; i< currentProfitDay+_option; i++) {
587 
588             if(profitDays[i].dailyProfit > 0){
589                 total_value = total_value.add(
590                         (profitDays[i].dailyProfit / 10000000 * _profitPercentageEminus7Multi)
591                     );
592             }
593         
594         }
595             
596         return (total_value, total_refBonus);
597     }
598     uint256 a=0;
599     function gameOp() public {
600         a++;
601     }
602 
603 }