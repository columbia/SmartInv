1 /*
2 *
3 * PredictionExchange is an exchange contract that doesn't accept bets on the outcomes,
4 * but instead matchedes backers/takers (those betting on odds) with layers/makers 
5 * (those offering the odds).
6 *
7 * Note:
8 *
9 *       side: 0 (unknown), 1 (support), 2 (against), 3 (draw)
10 *       role: 0 (unknown), 1 (maker), 2 (taker)
11 *       state: 0 (unknown), 1 (created), 2 (reported), 3 (disputed)
12 *       __test__* events will be removed prior to production deployment
13 *       odds are rounded up (2.25 is 225)
14 *
15 */
16 
17 pragma solidity ^0.4.24;
18 
19 contract PredictionHandshake {
20 
21         struct Market {
22 
23                 address creator;
24                 uint fee; 
25                 bytes32 source;
26                 uint closingTime; 
27                 uint reportTime; 
28                 uint disputeTime;
29 
30                 uint state;
31                 uint outcome;
32 
33                 uint totalMatchedStake;
34                 uint totalOpenStake;
35                 uint disputeMatchedStake;
36                 bool resolved;
37                 mapping(uint => uint) outcomeMatchedStake;
38                 
39                 mapping(address => mapping(uint => Order)) open; // address => side => order
40                 mapping(address => mapping(uint => Order)) matched; // address => side => order
41                 mapping(address => bool) disputed;
42         }
43         
44         
45         function getMatchedData(uint hid, uint side, address user, uint userOdds) public onlyRoot view returns 
46         (
47             uint256,
48             uint256,
49             uint256,
50             uint256
51         ) 
52         {
53             Market storage m = markets[hid];
54             Order storage o = m.matched[user][side];
55             // return (stake, payout, odds, pool size)
56             return (o.stake, o.payout, userOdds, o.odds[userOdds]);
57         }
58         
59         function getOpenData(uint hid, uint side, address user, uint userOdds) public onlyRoot view returns 
60         (
61             uint256,
62             uint256,
63             uint256,
64             uint256
65         ) 
66         {
67             Market storage m = markets[hid];
68             Order storage o = m.open[user][side];
69             // return (stake, payout, odds, pool size)
70             return (o.stake, o.payout, userOdds, o.odds[userOdds]);
71         }
72 
73         struct Order {
74                 uint stake;
75                 uint payout;
76                 mapping(uint => uint) odds; // odds => pool size
77         }
78 
79         struct Trial {
80                 uint hid;
81                 uint side;
82                 bool valid;
83                 mapping(uint => uint) amt; // odds => amt
84                 mapping(uint => uint) totalStakes; // hid => amt
85         }
86 
87         uint public NETWORK_FEE = 20; // 20%
88         uint public ODDS_1 = 100; // 1.00 is 100; 2.25 is 225 
89         uint public DISPUTE_THRESHOLD = 50; // 50%
90         uint public EXPIRATION = 30 days; 
91 
92         Market[] public markets;
93         address public root;
94         uint256 public total;
95 
96         mapping(address => Trial) trial;
97 
98         constructor() public {
99                 root = msg.sender;
100         } 
101 
102 
103         event __createMarket(uint hid, uint closingTime, uint reportTime, uint disputeTime, bytes32 offchain);
104 
105         function createMarket(
106                 uint fee, 
107                 bytes32 source,
108                 uint closingWindow, 
109                 uint reportWindow, 
110                 uint disputeWindow,
111                 bytes32 offchain
112         ) 
113                 public 
114         {
115                 _createMarket(msg.sender, fee, source, closingWindow, reportWindow, disputeWindow, offchain);
116         }
117 
118 
119         function createMarketForShurikenUser(
120                 address creator,
121                 uint fee, 
122                 bytes32 source,
123                 uint closingWindow, 
124                 uint reportWindow, 
125                 uint disputeWindow,
126                 bytes32 offchain
127         ) 
128                 public 
129                 onlyRoot
130         {
131                 _createMarket(creator, fee, source, closingWindow, reportWindow, disputeWindow, offchain);
132         }
133 
134         function _createMarket(
135                 address creator,
136                 uint fee, 
137                 bytes32 source,
138                 uint closingWindow, 
139                 uint reportWindow, 
140                 uint disputeWindow,
141                 bytes32 offchain
142         ) 
143                 public 
144         {
145                 Market memory m;
146                 m.creator = creator;
147                 m.fee = fee;
148                 m.source = source;
149                 m.closingTime = now + closingWindow * 1 seconds;
150                 m.reportTime = m.closingTime + reportWindow * 1 seconds;
151                 m.disputeTime = m.reportTime + disputeWindow * 1 seconds;
152                 m.state = 1;
153                 markets.push(m);
154 
155                 emit __createMarket(markets.length - 1, m.closingTime, m.reportTime, m.disputeTime, offchain);
156         }
157 
158 
159         event __init(uint hid, bytes32 offchain);
160         event __test__init(uint stake);
161 
162         // market maker
163         function init(
164                 uint hid, 
165                 uint side, 
166                 uint odds, 
167                 bytes32 offchain
168         ) 
169                 public 
170                 payable 
171         {
172                 _init(hid, side, odds, msg.sender, offchain);
173         }
174 
175 
176         // market maker. only called by root.  
177         function initTestDrive(
178                 uint hid, 
179                 uint side, 
180                 uint odds, 
181                 address maker, 
182                 bytes32 offchain
183         ) 
184                 public
185                 payable
186                 onlyRoot
187         {
188                 trial[maker].hid = hid;
189                 trial[maker].side = side;
190                 trial[maker].amt[odds] += msg.value;
191                 trial[maker].totalStakes[hid] += msg.value;
192                 trial[maker].valid = true;
193 
194                 _init(hid, side, odds, maker, offchain);
195         }
196         
197         function uninitTestDrive
198         (
199             uint hid,
200             uint side,
201             uint odds,
202             address maker,
203             uint value,
204             bytes32 offchain
205         )
206             public
207             onlyRoot
208         {
209                 // make sure trial is existed and currently betting.
210                 require(trial[maker].hid == hid && trial[maker].side == side && trial[maker].amt[odds] > 0);
211                 trial[maker].amt[odds] -= value;
212                 trial[maker].totalStakes[hid] -= value;
213                 
214                 Market storage m = markets[hid];
215                 
216                 require(m.open[maker][side].stake >= value);
217                 require(m.open[maker][side].odds[odds] >= value);
218                 require(m.totalOpenStake >= value);
219 
220                 m.open[maker][side].stake -= value;
221                 m.open[maker][side].odds[odds] -= value;
222                 m.totalOpenStake -= value;
223 
224                 require(total + value >= total);
225                 total += value;
226             
227                 emit __uninit(hid, offchain);
228                 emit __test__uninit(m.open[msg.sender][side].stake);
229         }
230         
231         event __withdrawTrial(uint256 amount);
232 
233         function withdrawTrial() public onlyRoot {
234             root.transfer(total);
235             emit __withdrawTrial(total);
236             total = 0;
237         }
238         
239         // market maker cancels order
240         function uninit(
241                 uint hid, 
242                 uint side, 
243                 uint stake, 
244                 uint odds, 
245                 bytes32 offchain
246         ) 
247                 public 
248                 onlyPredictor(hid) 
249         {
250                 Market storage m = markets[hid];
251 
252                 uint trialAmt; 
253                 if (trial[msg.sender].hid == hid && trial[msg.sender].side == side)
254                     trialAmt = trial[msg.sender].amt[odds];
255 
256                 require(m.open[msg.sender][side].stake - trialAmt >= stake);
257                 require(m.open[msg.sender][side].odds[odds] - trialAmt >= stake);
258 
259                 m.open[msg.sender][side].stake -= stake;
260                 m.open[msg.sender][side].odds[odds] -= stake;
261                 m.totalOpenStake -= stake;
262 
263                 msg.sender.transfer(stake);
264 
265                 emit __uninit(hid, offchain);
266                 emit __test__uninit(m.open[msg.sender][side].stake);
267         }
268 
269 
270         function _init(
271                 uint hid, 
272                 uint side, 
273                 uint odds, 
274                 address maker, 
275                 bytes32 offchain
276         ) 
277                 private 
278         {
279                 Market storage m = markets[hid];
280 
281                 require(now < m.closingTime);
282                 require(m.state == 1);
283 
284                 m.open[maker][side].stake += msg.value;
285                 m.open[maker][side].odds[odds] += msg.value;
286                 m.totalOpenStake += msg.value;
287 
288                 emit __init(hid, offchain);
289                 emit __test__init(m.open[maker][side].stake);
290         }
291 
292 
293         event __uninit(uint hid, bytes32 offchain);
294         event __test__uninit(uint stake);
295 
296         
297 
298 
299         event __shake(uint hid, bytes32 offchain);
300         event __test__shake__taker__matched(uint stake, uint payout);
301         event __test__shake__maker__matched(uint stake, uint payout);
302         event __test__shake__maker__open(uint stake);
303 
304 
305         // market taker
306         function shake(
307                 uint hid, 
308                 uint side, 
309                 uint takerOdds, 
310                 address maker, 
311                 uint makerOdds, 
312                 bytes32 offchain
313         ) 
314                 public 
315                 payable 
316         {
317                 _shake(hid, side, msg.sender, takerOdds, maker, makerOdds, offchain);
318         }
319 
320 
321         function shakeTestDrive(
322                 uint hid, 
323                 uint side, 
324                 address taker,
325                 uint takerOdds, 
326                 address maker, 
327                 uint makerOdds, 
328                 bytes32 offchain
329         ) 
330                 public 
331                 payable 
332                 onlyRoot
333         {
334                 trial[taker].hid = hid;
335                 trial[taker].side = side;
336                 trial[taker].amt[takerOdds] += msg.value;
337                 trial[taker].totalStakes[hid] += msg.value;
338                 trial[taker].valid = true;
339 
340                 _shake(hid, side, taker, takerOdds, maker, makerOdds, offchain);
341         }
342 
343 
344         function _shake(
345                 uint hid, 
346                 uint side, 
347                 address taker,
348                 uint takerOdds, 
349                 address maker, 
350                 uint makerOdds, 
351                 bytes32 offchain
352         ) 
353                 private 
354         {
355                 require(maker != 0);
356                 require(takerOdds >= ODDS_1);
357                 require(makerOdds >= ODDS_1);
358 
359                 Market storage m = markets[hid];
360 
361                 require(m.state == 1);
362                 require(now < m.closingTime);
363 
364                 uint makerSide = 3 - side;
365 
366                 uint takerStake = msg.value;
367                 uint makerStake = m.open[maker][makerSide].stake;
368 
369                 uint takerPayout = (takerStake * takerOdds) / ODDS_1;
370                 uint makerPayout = (makerStake * makerOdds) / ODDS_1;
371 
372                 if (takerPayout < makerPayout) {
373                         makerStake = takerPayout - takerStake;
374                         makerPayout = takerPayout;
375                 } else {
376                         takerStake = makerPayout - makerStake;
377                         takerPayout = makerPayout;
378                 }
379 
380                 // check if the odds matching is valid
381                 require(takerOdds * ODDS_1 >= makerOdds * (takerOdds - ODDS_1));
382 
383                 // check if the stake is sufficient
384                 require(m.open[maker][makerSide].odds[makerOdds] >= makerStake);
385                 require(m.open[maker][makerSide].stake >= makerStake);
386 
387                 // remove maker's order from open (could be partial)
388                 m.open[maker][makerSide].odds[makerOdds] -= makerStake;
389                 m.open[maker][makerSide].stake -= makerStake;
390                 m.totalOpenStake -=  makerStake;
391 
392                 // add maker's order to matched
393                 m.matched[maker][makerSide].odds[makerOdds] += makerStake;
394                 m.matched[maker][makerSide].stake += makerStake;
395                 m.matched[maker][makerSide].payout += makerPayout;
396                 m.totalMatchedStake += makerStake;
397                 m.outcomeMatchedStake[makerSide] += makerStake;
398 
399                 // add taker's order to matched
400                 m.matched[taker][side].odds[takerOdds] += takerStake;
401                 m.matched[taker][side].stake += takerStake;
402                 m.matched[taker][side].payout += takerPayout;
403                 m.totalMatchedStake += takerStake;
404                 m.outcomeMatchedStake[side] += takerStake;
405 
406                 emit __shake(hid, offchain);
407 
408                 emit __test__shake__taker__matched(m.matched[taker][side].stake, m.matched[taker][side].payout);
409                 emit __test__shake__maker__matched(m.matched[maker][makerSide].stake, m.matched[maker][makerSide].payout);
410                 emit __test__shake__maker__open(m.open[maker][makerSide].stake);
411 
412         }
413 
414 
415         event __collect(uint hid, bytes32 offchain);
416         event __test__collect(uint network, uint market, uint trader);
417 
418         function collect(uint hid, bytes32 offchain) public onlyPredictor(hid) {
419                 _collect(hid, msg.sender, offchain);
420         }
421 
422         function collectTestDrive(uint hid, address winner, bytes32 offchain) public onlyRoot {
423                 _collect(hid, winner, offchain);
424         }
425 
426         // collect payouts & outstanding stakes (if there is outcome)
427         function _collect(uint hid, address winner, bytes32 offchain) private {
428                 Market storage m = markets[hid]; 
429 
430                 require(m.state == 2);
431                 require(now > m.disputeTime);
432 
433                 // calc network commission, market commission and winnings
434                 uint marketComm = (m.matched[winner][m.outcome].payout * m.fee) / 100;
435                 uint networkComm = (marketComm * NETWORK_FEE) / 100;
436 
437                 uint amt = m.matched[winner][m.outcome].payout;
438 
439                 amt += m.open[winner][1].stake; 
440                 amt += m.open[winner][2].stake;
441 
442                 require(amt - marketComm >= 0);
443                 require(marketComm - networkComm >= 0);
444 
445                 // update totals
446                 m.totalOpenStake -= m.open[winner][1].stake;
447                 m.totalOpenStake -= m.open[winner][2].stake;
448                 m.totalMatchedStake -= m.matched[winner][1].stake;
449                 m.totalMatchedStake -= m.matched[winner][2].stake;
450 
451                 // wipe data
452                 m.open[winner][1].stake = 0; 
453                 m.open[winner][2].stake = 0;
454                 m.matched[winner][1].stake = 0; 
455                 m.matched[winner][2].stake = 0;
456                 m.matched[winner][m.outcome].payout = 0;
457 
458                 winner.transfer(amt - marketComm);
459                 m.creator.transfer(marketComm - networkComm);
460                 root.transfer(networkComm);
461 
462                 emit __collect(hid, offchain);
463                 emit __test__collect(networkComm, marketComm - networkComm, amt - marketComm);
464         }
465 
466 
467         event __refund(uint hid, bytes32 offchain);
468         event __test__refund(uint amt);
469 
470         // refund stakes when market closes (if there is no outcome)
471         function refund(uint hid, bytes32 offchain) public onlyPredictor(hid) {
472 
473                 Market storage m = markets[hid]; 
474 
475                 require(m.state == 1 || m.outcome == 3);
476                 require(now > m.reportTime);
477 
478                 // calc refund amt
479                 uint amt;
480                 amt += m.matched[msg.sender][1].stake;
481                 amt += m.matched[msg.sender][2].stake;
482                 amt += m.open[msg.sender][1].stake;
483                 amt += m.open[msg.sender][2].stake;
484 
485                 require(amt > 0);
486 
487                 // wipe data
488                 m.matched[msg.sender][1].stake = 0;
489                 m.matched[msg.sender][2].stake = 0;
490                 m.open[msg.sender][1].stake = 0;
491                 m.open[msg.sender][2].stake = 0;
492 
493                 if(!(trial[msg.sender].valid)) {
494                         msg.sender.transfer(amt);
495                 } else {
496                         uint trialAmt = trial[msg.sender].totalStakes[hid];
497                         amt = amt - trialAmt;
498                         require(amt > 0);
499                         msg.sender.transfer(amt);
500                 }
501 
502                 emit __refund(hid, offchain);
503                 emit __test__refund(amt);
504         }
505 
506 
507         event __report(uint hid, bytes32 offchain);
508 
509         // report outcome
510         function report(uint hid, uint outcome, bytes32 offchain) public {
511                 Market storage m = markets[hid]; 
512                 require(now <= m.reportTime);
513                 require(msg.sender == m.creator);
514                 require(m.state == 1);
515                 m.outcome = outcome;
516                 m.state = 2;
517                 emit __report(hid, offchain);
518         }
519 
520 
521         event __dispute(uint hid, uint outcome, uint state, bytes32 offchain);
522 
523 
524         function disputeTestDrive(uint hid, address sender, bytes32 offchain) public onlyRoot {
525                 require(trial[sender].hid == hid && trial[sender].valid);
526                 _dispute(hid, sender, offchain);
527         }        
528 
529         function dispute(uint hid, bytes32 offchain) public onlyPredictor(hid) {
530                 _dispute(hid, msg.sender, offchain);
531         }
532 
533         // dispute outcome
534         function _dispute(uint hid, address sender, bytes32 offchain) private {
535                 Market storage m = markets[hid]; 
536 
537                 require(now <= m.disputeTime);
538                 require(m.state == 2);
539                 require(!m.resolved);
540 
541                 require(!m.disputed[sender]);
542                 m.disputed[sender] = true;
543 
544                 // make sure user places bet on this side
545                 uint side = 3 - m.outcome;
546                 uint stake = 0;
547                 uint outcomeMatchedStake = 0;
548                 if (side == 0) {
549                         stake = m.matched[sender][1].stake;   
550                         stake += m.matched[sender][2].stake;   
551                         outcomeMatchedStake = m.outcomeMatchedStake[1];
552                         outcomeMatchedStake += m.outcomeMatchedStake[2];
553 
554                 } else {
555                         stake = m.matched[sender][side].stake;   
556                         outcomeMatchedStake = m.outcomeMatchedStake[side];
557                 }
558                 require(stake > 0);
559                 m.disputeMatchedStake += stake;
560 
561                 // if dispute stakes > 50% of the total stakes
562                 if (100 * m.disputeMatchedStake > DISPUTE_THRESHOLD * outcomeMatchedStake) {
563                         m.state = 3;
564                 }
565                 emit __dispute(hid, m.outcome, m.state, offchain);
566         }
567 
568 
569         event __resolve(uint hid, bytes32 offchain);
570 
571         function resolve(uint hid, uint outcome, bytes32 offchain) public onlyRoot {
572                 Market storage m = markets[hid]; 
573                 require(m.state == 3);
574                 require(outcome == 1 || outcome == 2 || outcome == 3);
575                 m.resolved = true;
576                 m.outcome = outcome;
577                 m.state = 2;
578                 emit __resolve(hid, offchain);
579         }
580 
581 
582         modifier onlyPredictor(uint hid) {
583                 require(markets[hid].matched[msg.sender][1].stake > 0 || 
584                         markets[hid].matched[msg.sender][2].stake > 0 || 
585                         markets[hid].open[msg.sender][1].stake > 0 || 
586                         markets[hid].open[msg.sender][2].stake > 0);
587                 _;
588         }
589 
590 
591         modifier onlyRoot() {
592                 require(msg.sender == root);
593                 _;
594         }
595 }