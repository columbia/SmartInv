1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract SafeMath {
16     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
17         assert((z = x + y) >= x);
18     }
19 
20     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
21         assert((z = x - y) <= x);
22     }
23 
24     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
25         assert((z = x * y) >= x);
26     }
27 
28     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         z = x / y;
30     }
31 
32     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
33         return x <= y ? x : y;
34     }
35     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
36         return x >= y ? x : y;
37     }
38 }
39 
40 
41 /*
42     We deleted unused part.
43     To see full source code, refer below : 
44     https://github.com/pipermerriam/ethereum-datetime
45 
46     The MIT License (MIT)
47 
48     Copyright (c) 2015 Piper Merriam
49 
50     Permission is hereby granted, free of charge, to any person obtaining a copy
51     of this software and associated documentation files (the "Software"), to deal
52     in the Software without restriction, including without limitation the rights
53     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
54     copies of the Software, and to permit persons to whom the Software is
55     furnished to do so, subject to the following conditions:
56 
57     The above copyright notice and this permission notice shall be included in all
58     copies or substantial portions of the Software.
59 
60     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
61     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
62     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
63     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
64     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
65     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
66     SOFTWARE.
67 */
68 contract DateTime {
69         /*
70          *  Date and Time utilities for ethereum contracts
71          *
72          */
73         struct DateTime {
74                 uint16 year;
75                 uint8 month;
76                 uint8 day;
77                 uint8 hour;
78                 uint8 minute;
79                 uint8 second;
80                 uint8 weekday;
81         }
82 
83         uint constant DAY_IN_SECONDS = 86400;
84         uint constant YEAR_IN_SECONDS = 31536000;
85         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
86 
87         uint constant HOUR_IN_SECONDS = 3600;
88         uint constant MINUTE_IN_SECONDS = 60;
89 
90         uint16 constant ORIGIN_YEAR = 1970;
91 
92         function isLeapYear(uint16 year) constant returns (bool) {
93                 if (year % 4 != 0) {
94                         return false;
95                 }
96                 if (year % 100 != 0) {
97                         return true;
98                 }
99                 if (year % 400 != 0) {
100                         return false;
101                 }
102                 return true;
103         }
104 
105         function leapYearsBefore(uint year) constant returns (uint) {
106                 year -= 1;
107                 return year / 4 - year / 100 + year / 400;
108         }
109 
110         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
111                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
112                         return 31;
113                 }
114                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
115                         return 30;
116                 }
117                 else if (isLeapYear(year)) {
118                         return 29;
119                 }
120                 else {
121                         return 28;
122                 }
123         }
124 
125         function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
126                 uint secondsAccountedFor = 0;
127                 uint buf;
128                 uint8 i;
129 
130                 // Year
131                 dt.year = getYear(timestamp);
132                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
133 
134                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
135                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
136 
137                 // Month
138                 uint secondsInMonth;
139                 for (i = 1; i <= 12; i++) {
140                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
141                         if (secondsInMonth + secondsAccountedFor > timestamp) {
142                                 dt.month = i;
143                                 break;
144                         }
145                         secondsAccountedFor += secondsInMonth;
146                 }
147 
148                 // Day
149                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
150                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
151                                 dt.day = i;
152                                 break;
153                         }
154                         secondsAccountedFor += DAY_IN_SECONDS;
155                 }
156 
157                 // Hour
158                 dt.hour = getHour(timestamp);
159         }
160 
161         function getYear(uint timestamp) constant returns (uint16) {
162                 uint secondsAccountedFor = 0;
163                 uint16 year;
164                 uint numLeapYears;
165 
166                 // Year
167                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
168                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
169 
170                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
171                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
172 
173                 while (secondsAccountedFor > timestamp) {
174                         if (isLeapYear(uint16(year - 1))) {
175                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
176                         }
177                         else {
178                                 secondsAccountedFor -= YEAR_IN_SECONDS;
179                         }
180                         year -= 1;
181                 }
182                 return year;
183         }
184 
185         function getMonth(uint timestamp) constant returns (uint8) {
186                 return parseTimestamp(timestamp).month;
187         }
188 
189         function getDay(uint timestamp) constant returns (uint8) {
190                 return parseTimestamp(timestamp).day;
191         }
192 
193         function getHour(uint timestamp) constant returns (uint8) {
194                 return uint8((timestamp / 60 / 60) % 24);
195         }
196 }
197 
198 contract ITGTokenBase is ERC20, SafeMath {
199 
200   /* Actual balances of token holders */
201   mapping(address => uint) balances;
202 
203   /* approve() allowances */
204   mapping (address => mapping (address => uint)) allowed;
205 
206   
207   function balanceOf(address _owner) constant returns (uint balance) {
208     return balances[_owner];
209   }
210 
211   function approve(address _spender, uint _value) returns (bool success) {
212 
213     // To change the approve amount you first have to reduce the addresses`
214     //  allowance to zero by calling `approve(_spender, 0)` if it is not
215     //  already 0 to mitigate the race condition described here:
216     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
218 
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   function allowance(address _owner, address _spender) constant returns (uint remaining) {
225     return allowed[_owner][_spender];
226   }
227 
228 }
229 
230 contract Authable {
231     address public owner;
232     address public executor;
233 
234     modifier onlyOwner(){
235         require(msg.sender == owner);
236         _;
237     }
238    
239     modifier onlyAuth(){
240         require(msg.sender == owner || msg.sender == executor);
241         _;
242     }
243 
244     function setOwner(address _owner){
245         require(owner == 0x0 || owner == msg.sender);
246         owner = _owner;
247     }
248 
249     function setExecutor(address exec) {
250         require(executor == 0x0 || owner == msg.sender || executor == msg.sender);
251         executor = exec;
252     }
253 }
254 
255 contract CrowdSale is SafeMath, Authable {
256 
257     struct SaleAttr{
258         uint amountRaisedTotal;  // Total funding
259 
260         uint saleSupplyPre; // Supply for Pre crowdSale
261         uint saleSupply1; // Supply for 1st crowdSale
262         uint saleSupply2; // Supply for 2nd crowdSale
263         uint saleSupply3; // Supply for 3rd crowdSale
264         uint saleSupply4; // Supply for 4th crowdSale
265         
266         uint amountRaisedPre;   // Only count Pre crowdSale funding for distribute
267         uint amountRaised1;     // Only count 1st crowdSale funding for distribute
268         uint amountRaised2;     // Only count 2nd crowdSale funding for just record
269         uint amountRaised3;     // Only count 3rd crowdSale funding for distribute
270         uint amountRaised4;     // Only count 4th crowdSale funding for just record
271 
272         uint soldSupply2;
273         uint soldSupply4;
274     }
275     SaleAttr public s;
276     mapping(address => uint) public participantsForPreSale;    // Pre crowdSale participants
277     mapping(address => uint) public participantsFor1stSale;    // 1st crowdSale participants
278     mapping(address => uint) public participantsFor3rdSale;    // 3rd crowdSale participants
279 
280     event LogCustomSale(uint startTime, uint endTime, uint tokPerEth, uint supply);
281 
282     struct SaleTimeAttr{
283         uint pstart;
284         uint pdeadline;
285 
286         // 1st, 3rd sale is time based share
287         // 2nd, 4th sale is price sale
288         uint start;         // When 1st crowdSale starts
289         uint deadline1;     // When 1st crowdSale ends and 2nd crowdSale starts
290         uint deadline2;     // When 2nd crowdSale ends
291         uint deadline3;     // When 3rd crowdSale ends
292         uint deadline4;     // When 4th crowdSale ends
293     }
294     SaleTimeAttr public t;
295 
296     struct CustomSaleAttr{
297         uint start;
298         uint end;
299         uint tokenPerEth;   // 0 means period sale
300         uint saleSupply;
301         uint soldSupply;
302         uint amountRaised;
303     }
304     CustomSaleAttr public cs;
305     mapping(uint => mapping(address => uint)) public participantsForCustomSale;
306 
307     function setAttrs(uint supplyPre, uint supply1, uint supply2, uint supply3, uint supply4
308             , uint preStart, uint preEnd, uint start, uint end1, uint end2, uint end3, uint end4
309         ) onlyAuth {
310         s.saleSupplyPre = supplyPre; // totalSupply * 10 / 100
311         //start, deadline1~4 should be set before start
312         s.saleSupply1 = supply1;    //totalSupply * 10 / 100;     // 10% of totalSupply. Total 40% to CrowdSale, 5% to dev team, 55% will be used for game and vote
313         s.saleSupply2 = supply2;    //totalSupply *  5 / 100;
314         s.saleSupply3 = supply3;    //totalSupply * 10 / 100;
315         s.saleSupply4 = supply4;    //totalSupply *  5 / 100;
316 
317         t.pstart = preStart;
318         t.pdeadline = preEnd;
319         t.start = start;
320         t.deadline1 = end1;
321         t.deadline2 = end2;
322         t.deadline3 = end3;
323         t.deadline4 = end4;
324     }
325 
326     function setAttrCustom(uint startTime, uint endTime, uint tokPerEth, uint supply) onlyAuth {
327         cs.start = startTime;
328         cs.end = endTime;
329         cs.tokenPerEth = tokPerEth;
330         cs.saleSupply = supply;
331         cs.soldSupply = 0;
332         cs.amountRaised = 0;
333         LogCustomSale(startTime, endTime, tokPerEth, supply);
334     }
335 
336     function process(address sender, uint sendValue) onlyOwner returns (uint tokenAmount) {
337         if(now > t.pstart && now <= t.pdeadline){
338             participantsForPreSale[sender] = add(participantsForPreSale[sender],sendValue);
339             s.amountRaisedPre = add(s.amountRaisedPre, sendValue);
340         }else if(now > t.start && now <= t.deadline1){
341             participantsFor1stSale[sender] = add(participantsFor1stSale[sender],sendValue);
342             s.amountRaised1 = add(s.amountRaised1, sendValue);
343         }else if(now > t.deadline1 && now <= t.deadline2 && s.soldSupply2 < s.saleSupply2){
344             tokenAmount = sendValue / (s.amountRaised1 / s.saleSupply1 * 120 / 100);    //Token Price = s.amountRaised1 / s.saleSupply1. Price is going up 20%
345             s.soldSupply2 = add(s.soldSupply2, tokenAmount);
346             s.amountRaised2 = add(s.amountRaised2, sendValue);
347 
348             require(s.soldSupply2 < s.saleSupply2 * 105 / 100);   // A little bit more sale is granted for the price sale.
349         }else if(now > t.deadline2 && now <= t.deadline3){
350             participantsFor3rdSale[sender] = add(participantsFor3rdSale[sender],sendValue);
351             s.amountRaised3 = add(s.amountRaised3, sendValue);
352         }else if(now > t.deadline3 && now <= t.deadline4 && s.soldSupply4 < s.saleSupply4){
353             tokenAmount = sendValue / (s.amountRaised3 / s.saleSupply3 * 120 / 100);     //Token Price = s.amountRaised3 / s.saleSupply3. Price is going up 20%
354             s.soldSupply4 = add(s.soldSupply4, tokenAmount);
355             s.amountRaised4 = add(s.amountRaised4, sendValue);
356 
357             require(s.soldSupply4 < s.saleSupply4 * 105 / 100);   // A little bit more sale is granted for the price sale.
358         }else if(now > cs.start && now <= cs.end && cs.soldSupply < cs.saleSupply){
359             if(cs.tokenPerEth > 0){
360                 tokenAmount = sendValue * cs.tokenPerEth;
361                 cs.soldSupply = add(cs.soldSupply, tokenAmount);
362 
363                 require(cs.soldSupply < cs.saleSupply * 105 / 100); // A little bit more sale is granted for the price sale.
364             }else{
365                 participantsForCustomSale[cs.start][sender] = add(participantsForCustomSale[cs.start][sender],sendValue);
366                 cs.amountRaised = add(cs.amountRaised, sendValue);
367             }
368         }else{
369             throw;
370         }
371         s.amountRaisedTotal = add(s.amountRaisedTotal, sendValue);
372     }
373 
374     function getToken(address sender) onlyOwner returns (uint tokenAmount){
375         if(now > t.pdeadline && participantsForPreSale[sender] != 0){
376             tokenAmount = add(tokenAmount,participantsForPreSale[sender] * s.saleSupplyPre / s.amountRaisedPre);  //Token Amount Per Eth = s.saleSupplyPre / s.amountRaisedPre
377             participantsForPreSale[sender] = 0;
378         }
379         if(now > t.deadline1 && participantsFor1stSale[sender] != 0){
380             tokenAmount = add(tokenAmount,participantsFor1stSale[sender] * s.saleSupply1 / s.amountRaised1);  //Token Amount Per Eth = s.saleSupply1 / s.amountRaised1
381             participantsFor1stSale[sender] = 0;
382         }
383         if(now > t.deadline3 && participantsFor3rdSale[sender] != 0){
384             tokenAmount = add(tokenAmount,participantsFor3rdSale[sender] * s.saleSupply3 / s.amountRaised3);  //Token Amount Per Eth = s.saleSupply3 / s.amountRaised3
385             participantsFor3rdSale[sender] = 0;
386         }
387         if(now > cs.end && participantsForCustomSale[cs.start][sender] != 0){
388             tokenAmount = add(tokenAmount,participantsForCustomSale[cs.start][sender] * cs.saleSupply / cs.amountRaised);  //Token Amount Per Eth = cs.saleSupply / cs.amountRaised
389             participantsForCustomSale[cs.start][sender] = 0;
390         }
391     }
392 }
393 
394 contract Voting is SafeMath, Authable {
395     mapping(uint => uint) public voteRewardPerUnit; // If the voters vote, they will rewarded x% of tokens by their balances. 100 means 1%, 1000 means 10%
396     mapping(uint => uint) public voteWeightUnit;    // If 100 * 1 ether, each 100 * 1 ether token of holder will get vote weight 1. 
397     mapping(uint => uint) public voteStart;
398     mapping(uint => uint) public voteEnd;
399     mapping(uint => uint) public maxCandidateId;
400 
401     mapping(uint => mapping(address => bool)) public voted;
402     mapping(uint => mapping(uint => uint)) public results;
403 
404     event LogVoteInitiate(uint _voteId, uint _voteRewardPerUnit, uint _voteWeightUnit, uint _voteStart, uint _voteEnd, uint _maxCandidateId);
405     event LogVote(address voter, uint weight, uint voteId, uint candidateId, uint candidateValue);
406 
407     function voteInitiate(uint _voteId, uint _voteRewardPerUnit, uint _voteWeightUnit, uint _voteStart, uint _voteEnd, uint _maxCandidateId) onlyOwner {   
408         require(voteEnd[_voteId] == 0);  // Do not allow duplicate voteId
409         require(_voteEnd != 0);
410 
411         voteRewardPerUnit[_voteId] = _voteRewardPerUnit;
412         voteWeightUnit[_voteId] = _voteWeightUnit;
413         voteStart[_voteId] = _voteStart;
414         voteEnd[_voteId] = _voteEnd;
415         maxCandidateId[_voteId] = _maxCandidateId;
416 
417         LogVoteInitiate(_voteId, _voteRewardPerUnit, _voteWeightUnit, _voteStart, _voteEnd, _maxCandidateId);
418     }
419 
420      function vote(address sender, uint holding, uint voteId, uint candidateId) onlyOwner returns (uint tokenAmount, uint lockUntil){
421         require(now > voteStart[voteId] && now <= voteEnd[voteId]);
422         require(maxCandidateId[voteId] >= candidateId);
423         require(holding >= voteRewardPerUnit[voteId]);
424         require(!voted[voteId][sender]);
425 
426         uint weight = holding / voteWeightUnit[voteId];
427 
428         results[voteId][candidateId] = add(results[voteId][candidateId], weight);
429         voted[voteId][sender] = true;
430         tokenAmount = weight * voteWeightUnit[voteId] * voteRewardPerUnit[voteId] / 100 / 100;
431         lockUntil = voteEnd[voteId];
432 
433         LogVote(sender, weight, voteId, candidateId, results[voteId][candidateId]);
434     }
435 }
436 
437 contract Games is SafeMath, DateTime, Authable {
438     enum GameTime { Hour, Month, Year, OutOfTime }
439     enum GameType { Range, Point}
440 
441     struct Participant {
442         address sender;
443         uint value;
444         uint currency; // 1 : Eth, 2 : Tok
445     }
446 
447     struct DateAttr{
448         uint currentYear;
449         uint gameStart; //Only for Range Game
450         uint gameEnd;   //For both Range Game and point Game(=intime timestamp)
451         uint prevGameEnd; //Only for Point Game
452     }
453     DateAttr public d;
454 
455     struct CommonAttr{
456         GameTime currentGameTimeType;      // Current Game time type
457         GameType gameType;
458 
459         uint hourlyAmountEth;  // Funded Eth amount
460         uint monthlyAmountEth;
461         uint yearlyAmountEth;
462         uint charityAmountEth;
463 
464     }
465     CommonAttr public c;
466 
467     struct FundAmountStatusAttr{
468         uint hourlyStatusEth;  // Funded Eth amount in current game time
469         uint monthlyStatusEth;
470         uint yearlyStatusEth;
471 
472         uint hourlyStatusTok;  // Funded Token amount in current game time
473         uint monthlyStatusTok;
474     }
475     FundAmountStatusAttr public f;
476 
477     struct PriceAttr{
478         uint bonusPerEth;   // If you not won, xx token to 1 Eth will be rewarded
479 
480         uint inGameTokPricePerEth;   // Regard xx token to 1 Eth for token participants
481         uint inGameTokWinRatioMax;   // 100 means 100%. Disadventage against Eth. Change prize ratio like 25~50%
482         uint inGameTokWinRatioMin;
483         uint currentInGameTokWinRatio;  // Current token winners prize ratio
484 
485         uint hourlyMinParticipateRatio;     // If participants.length are less than 100, x100 would be min prize ratio
486         uint monthlyMinParticipateRatio;    // If participants.length are less than 300, x300 would be min prize ratio
487         uint yearlyMinParticipateRatio;     // If participants.length are less than 1000, x1000 would be min prize ratio
488 
489         uint boostPrizeEth;    // Boosts prize amount. Default is 100 and it means 100%
490     }
491     PriceAttr public p;
492 
493 
494     struct RangeGameAttr{
495         uint inTimeRange_H; // 10 means +-10 mins in time
496         uint inTimeRange_M;
497         uint inTimeRange_Y;
498     }
499     RangeGameAttr public r;
500     Participant[] public participants;  // RangeGame participants
501 
502     mapping(uint256 => mapping(address => uint256)) public winners; // Eth reward
503     mapping(uint256 => mapping(address => uint256)) public tokTakers; // Tok reward
504     mapping(uint256 => uint256) public winPrizes;
505     mapping(uint256 => uint256) public tokPrizes;
506 
507     event LogSelectWinner(uint rand, uint luckyNumber, address sender, uint reward, uint currency, uint amount);
508 
509     function setPriceAttr(
510             GameType _gameType, uint _bonusPerEth, uint _inGameTokPricePerEth
511             , uint _inGameTokWinRatioMax, uint _inGameTokWinRatioMin, uint _currentInGameTokWinRatio
512             , uint _hourlyMinParticipateRatio, uint _monthlyMinParticipateRatio, uint _yearlyMinParticipateRatio, uint _boostPrizeEth
513         ) onlyAuth {
514         c.gameType = _gameType;
515 
516         p.bonusPerEth = _bonusPerEth;   //300   // Depends on crowdSale average price. Vote needed, but we assume AVG/4 is reasonable.
517         p.inGameTokPricePerEth = _inGameTokPricePerEth; //300   // Regard xx token to 1 Eth for token participants. Depends on crowdSale, too.
518         p.inGameTokWinRatioMax = _inGameTokWinRatioMax; //50    // 100 means 100%. Disadventage against Eth. Change prize ratio like 25~50%
519         p.inGameTokWinRatioMin = _inGameTokWinRatioMin; //25
520         p.currentInGameTokWinRatio = _currentInGameTokWinRatio;    //50
521         p.hourlyMinParticipateRatio = _hourlyMinParticipateRatio;   //100   // If participants.length are less than 100, x100 would be min prize ratio
522         p.monthlyMinParticipateRatio = _monthlyMinParticipateRatio; //300
523         p.yearlyMinParticipateRatio = _yearlyMinParticipateRatio;   //1000
524         p.boostPrizeEth = _boostPrizeEth;   //100
525     }
526 
527     function setRangeGameAttr(uint _inTimeRange_H, uint _inTimeRange_M, uint _inTimeRange_Y) onlyAuth {
528         r.inTimeRange_H = _inTimeRange_H;   //10       // 10 mean +-10 mins in time
529         r.inTimeRange_M = _inTimeRange_M;   //190 = 3 * 60 + r.inTimeRange_H
530         r.inTimeRange_Y = _inTimeRange_Y;   //370 = 6 * 60 + r.inTimeRange_H
531     }
532      
533     // Calulate game time and gc amount record
534     modifier beforeRangeGame(){
535         require(now > d.gameStart && now <= d.gameEnd);
536         _;
537     }
538 
539     modifier beforePointGame(){
540         refreshGameTime();
541         _;
542     }
543 
544     function process(address sender, uint sendValue) onlyOwner {
545         if(c.gameType == GameType.Range){
546             RangeGameProcess(sender, sendValue);
547         }else if(c.gameType == GameType.Point){
548             PointGameProcess(sender, sendValue);
549         }
550     }
551 
552     function processWithITG(address sender, uint tokenAmountToGame) onlyOwner {
553         if(c.gameType == GameType.Range){
554             RangeGameWithITG(sender, tokenAmountToGame);
555         }else if(c.gameType == GameType.Point){
556             PointGameWithITG(sender, tokenAmountToGame);
557         }
558     }
559 
560     // Range Game
561     function RangeGameProcess(address sender, uint sendValue) private beforeRangeGame {
562         if(c.currentGameTimeType == GameTime.Year){
563             c.yearlyAmountEth = add(c.yearlyAmountEth, sendValue);
564             f.yearlyStatusEth = add(f.yearlyStatusEth, sendValue);
565         }else if(c.currentGameTimeType == GameTime.Month){
566             c.monthlyAmountEth = add(c.monthlyAmountEth, sendValue);
567             f.monthlyStatusEth = add(f.monthlyStatusEth, sendValue);
568         }else if(c.currentGameTimeType == GameTime.Hour){
569             c.hourlyAmountEth = add(c.hourlyAmountEth, sendValue);
570             f.hourlyStatusEth = add(f.hourlyStatusEth, sendValue);
571         }
572         participants.push(Participant(sender,sendValue,1));
573         if(p.bonusPerEth != 0){
574             tokTakers[d.currentYear][sender] = add(tokTakers[d.currentYear][sender], sendValue * p.bonusPerEth);
575             tokPrizes[d.currentYear] = add(tokPrizes[d.currentYear], sendValue * p.bonusPerEth);
576         }
577     }
578 
579     function RangeGameWithITG(address sender, uint tokenAmountToGame) private beforeRangeGame {
580         require(c.currentGameTimeType != GameTime.Year);
581 
582         if(c.currentGameTimeType == GameTime.Month){
583             f.monthlyStatusTok = add(f.monthlyStatusTok, tokenAmountToGame);
584         }else if(c.currentGameTimeType == GameTime.Hour){
585             f.hourlyStatusTok = add(f.hourlyStatusTok, tokenAmountToGame);
586         }
587         participants.push(Participant(sender,tokenAmountToGame,2));
588     }
589 
590     function getTimeRangeInfo() private returns (GameTime, uint, uint, uint) {
591         uint nextTimeStamp;
592         uint nextYear;
593         uint nextMonth;
594         uint basis;
595         if(c.gameType == GameType.Range){
596             nextTimeStamp = now + r.inTimeRange_Y * 1 minutes + 1 hours;
597             nextYear = getYear(nextTimeStamp);
598             if(getYear(now - r.inTimeRange_Y * 1 minutes + 1 hours) != nextYear){
599                 basis = nextTimeStamp - (nextTimeStamp % 1 days);    //Time range limit is less than 12 hours
600                 return (GameTime.Year, nextYear, basis - r.inTimeRange_Y * 1 minutes, basis + r.inTimeRange_Y * 1 minutes);
601             }
602             nextTimeStamp = now + r.inTimeRange_M * 1 minutes + 1 hours;
603             nextMonth = getMonth(nextTimeStamp);
604             if(getMonth(now - r.inTimeRange_M * 1 minutes + 1 hours) != nextMonth){
605                 basis = nextTimeStamp - (nextTimeStamp % 1 days); 
606                 return (GameTime.Month, nextYear, basis - r.inTimeRange_M * 1 minutes, basis + r.inTimeRange_M * 1 minutes);
607             }
608             nextTimeStamp = now + r.inTimeRange_H * 1 minutes + 1 hours;
609             basis = nextTimeStamp - (nextTimeStamp % 1 hours); 
610             return (GameTime.Hour, nextYear, basis - r.inTimeRange_H * 1 minutes, basis + r.inTimeRange_H * 1 minutes);
611         }else if(c.gameType == GameType.Point){
612             nextTimeStamp = now - (now % 1 hours) + 1 hours;
613             nextYear = getYear(nextTimeStamp);
614             if(getYear(now) != nextYear){
615                 return (GameTime.Year, nextYear, 0, nextTimeStamp);
616             }
617             nextMonth = getMonth(nextTimeStamp);
618             if(getMonth(now) != nextMonth){
619                 return (GameTime.Month, nextYear, 0, nextTimeStamp);
620             }
621             return (GameTime.Hour, nextYear, 0, nextTimeStamp);
622         }
623     }
624 
625     function refreshGameTime() private {
626         (c.currentGameTimeType, d.currentYear, d.gameStart, d.gameEnd) = getTimeRangeInfo();
627     }
628 
629     // Garbage Collect previous funded amount record and log the status
630     function gcFundAmount() private {
631         f.hourlyStatusEth = 0;
632         f.monthlyStatusEth = 0;
633         f.yearlyStatusEth = 0;
634 
635         f.hourlyStatusTok = 0;
636         f.monthlyStatusTok = 0;
637     }
638 
639     function selectWinner(uint rand) onlyOwner {
640         uint luckyNumber = participants.length * rand / 100000000;
641         uint rewardDiv100 = 0;
642 
643         uint participateRatio = participants.length;
644         if(participateRatio != 0){
645             if(c.currentGameTimeType == GameTime.Year){
646                 participateRatio = participateRatio > p.yearlyMinParticipateRatio?participateRatio:p.yearlyMinParticipateRatio;
647             }else if(c.currentGameTimeType == GameTime.Month){
648                 participateRatio = participateRatio > p.monthlyMinParticipateRatio?participateRatio:p.monthlyMinParticipateRatio;
649             }else if(c.currentGameTimeType == GameTime.Hour){
650                 participateRatio = participateRatio > p.hourlyMinParticipateRatio?participateRatio:p.hourlyMinParticipateRatio;
651             }
652 
653             if(participants[luckyNumber].currency == 1){
654                 rewardDiv100 = participants[luckyNumber].value * participateRatio * p.boostPrizeEth / 100 / 100;
655                 if(p.currentInGameTokWinRatio < p.inGameTokWinRatioMax){
656                     p.currentInGameTokWinRatio++;
657                 }
658             }else if(participants[luckyNumber].currency == 2){
659                 rewardDiv100 = (participants[luckyNumber].value / p.inGameTokPricePerEth * p.currentInGameTokWinRatio / 100) * participateRatio / 100;
660                 if(p.currentInGameTokWinRatio > p.inGameTokWinRatioMin){
661                     p.currentInGameTokWinRatio--;
662                 }
663             }
664 
665             if(c.currentGameTimeType == GameTime.Year){
666                 if(c.yearlyAmountEth >= rewardDiv100*104){  //1.04
667                     c.yearlyAmountEth = sub(c.yearlyAmountEth, rewardDiv100*104);
668                 }else{
669                     rewardDiv100 = c.yearlyAmountEth / 104;
670                     c.yearlyAmountEth = 0;
671                 }
672             }else if(c.currentGameTimeType == GameTime.Month){
673                 if(c.monthlyAmountEth >= rewardDiv100*107){    //1.07
674                     c.monthlyAmountEth = sub(c.monthlyAmountEth, rewardDiv100*107);
675                 }else{
676                     rewardDiv100 = c.monthlyAmountEth / 107;
677                     c.monthlyAmountEth = 0;
678                 }
679                 c.yearlyAmountEth = add(c.yearlyAmountEth,rewardDiv100 * 3); //0.03, 1.1
680             }else if(c.currentGameTimeType == GameTime.Hour){
681                 if(c.hourlyAmountEth >= rewardDiv100*110){
682                     c.hourlyAmountEth = sub(c.hourlyAmountEth, rewardDiv100*110);
683                 }else{
684                     rewardDiv100 = c.hourlyAmountEth / 110;
685                     c.hourlyAmountEth = 0;
686                 }
687                 c.monthlyAmountEth = add(c.monthlyAmountEth,rewardDiv100 * 3);
688                 c.yearlyAmountEth = add(c.yearlyAmountEth,rewardDiv100 * 3);
689             }
690             c.charityAmountEth = add(c.charityAmountEth,rewardDiv100 * 4);
691 
692             winners[d.currentYear][participants[luckyNumber].sender] = add(winners[d.currentYear][participants[luckyNumber].sender],rewardDiv100*100);
693             winPrizes[d.currentYear] = add(winPrizes[d.currentYear],rewardDiv100*100);
694         
695             LogSelectWinner(rand, luckyNumber, participants[luckyNumber].sender, rewardDiv100*100, participants[luckyNumber].currency, participants[luckyNumber].value);
696 
697             // Initialize participants
698             participants.length = 0;
699         }
700         if(c.gameType == GameType.Range){
701             refreshGameTime();
702         }
703         gcFundAmount();    
704     }
705 
706     //claimAll
707     function getPrize(address sender) onlyOwner returns (uint ethPrize, uint tokPrize) {
708         ethPrize = add(winners[d.currentYear][sender],winners[d.currentYear-1][sender]);
709         tokPrize = add(tokTakers[d.currentYear][sender],tokTakers[d.currentYear-1][sender]);
710 
711         winPrizes[d.currentYear] = sub(winPrizes[d.currentYear],winners[d.currentYear][sender]);
712         tokPrizes[d.currentYear] = sub(tokPrizes[d.currentYear],tokTakers[d.currentYear][sender]);
713         winners[d.currentYear][sender] = 0;
714         tokTakers[d.currentYear][sender] = 0;
715 
716         winPrizes[d.currentYear-1] = sub(winPrizes[d.currentYear-1],winners[d.currentYear-1][sender]);
717         tokPrizes[d.currentYear-1] = sub(tokPrizes[d.currentYear-1],tokTakers[d.currentYear-1][sender]);
718         winners[d.currentYear-1][sender] = 0;
719         tokTakers[d.currentYear-1][sender] = 0;
720     }
721 
722     // Point Game
723     function PointGameProcess(address sender, uint sendValue) private beforePointGame {
724         if(c.currentGameTimeType == GameTime.Year){
725             c.yearlyAmountEth = add(c.yearlyAmountEth, sendValue);
726             f.yearlyStatusEth = add(f.yearlyStatusEth, sendValue);
727         }else if(c.currentGameTimeType == GameTime.Month){
728             c.monthlyAmountEth = add(c.monthlyAmountEth, sendValue);
729             f.monthlyStatusEth = add(f.monthlyStatusEth, sendValue);
730         }else if(c.currentGameTimeType == GameTime.Hour){
731             c.hourlyAmountEth = add(c.hourlyAmountEth, sendValue);
732             f.hourlyStatusEth = add(f.hourlyStatusEth, sendValue);
733         }
734 
735         PointGameParticipate(sender, sendValue, 1);
736         
737         if(p.bonusPerEth != 0){
738             tokTakers[d.currentYear][sender] = add(tokTakers[d.currentYear][sender], sendValue * p.bonusPerEth);
739             tokPrizes[d.currentYear] = add(tokPrizes[d.currentYear], sendValue * p.bonusPerEth);
740         }
741     }
742 
743     function PointGameWithITG(address sender, uint tokenAmountToGame) private beforePointGame {
744         require(c.currentGameTimeType != GameTime.Year);
745 
746         if(c.currentGameTimeType == GameTime.Month){
747             f.monthlyStatusTok = add(f.monthlyStatusTok, tokenAmountToGame);
748         }else if(c.currentGameTimeType == GameTime.Hour){
749             f.hourlyStatusTok = add(f.hourlyStatusTok, tokenAmountToGame);
750         }
751 
752         PointGameParticipate(sender, tokenAmountToGame, 2);
753     }
754 
755     function PointGameParticipate(address sender, uint sendValue, uint currency) private {
756         if(d.prevGameEnd != d.gameEnd){
757             selectWinner(1);
758         }
759         participants.length = 0;
760         participants.push(Participant(sender,sendValue,currency));
761 
762         d.prevGameEnd = d.gameEnd;
763     }
764 
765     function lossToCharity(uint year) onlyOwner returns (uint amt) {
766         require(year < d.currentYear-1);
767         
768         amt = winPrizes[year];
769         tokPrizes[year] = 0;
770         winPrizes[year] = 0;
771     }
772 
773     function charityAmtToCharity() onlyOwner returns (uint amt) {
774         amt = c.charityAmountEth;
775         c.charityAmountEth = 0;
776     }
777 
778     function distributeTokenSale(uint hour, uint month, uint year, uint charity) onlyOwner{
779         c.hourlyAmountEth = add(c.hourlyAmountEth, hour);
780         c.monthlyAmountEth = add(c.monthlyAmountEth, month);
781         c.yearlyAmountEth = add(c.yearlyAmountEth, year);
782         c.charityAmountEth = add(c.charityAmountEth, charity);
783     }
784 }
785 
786 contract ITGToken is ITGTokenBase, Authable {
787     bytes32  public  symbol = "ITG";
788     uint256  public  decimals = 18;
789     bytes32   public  name = "ITG";
790 
791     enum Status { CrowdSale, Game, Pause }
792     Status public status;
793 
794     CrowdSale crowdSale;
795     Games games;
796     Voting voting;
797 
798     mapping(address => uint) public withdrawRestriction;
799 
800     uint public minEtherParticipate;
801     uint public minTokParticipate;
802 
803     event LogFundTransfer(address sender, address to, uint amount, uint8 currency);
804 
805     modifier beforeTransfer(){
806         require(withdrawRestriction[msg.sender] < now);
807         _;
808     }
809 
810     function transfer(address _to, uint _value) beforeTransfer returns (bool success) {
811         balances[msg.sender] = sub(balances[msg.sender], _value);
812         balances[_to] = add(balances[_to], _value);
813         Transfer(msg.sender, _to, _value);
814         return true;
815     }
816 
817     function transferFrom(address _from, address _to, uint _value) beforeTransfer returns (bool success) {
818         uint _allowance = allowed[_from][msg.sender];
819 
820         balances[_to] = add(balances[_to], _value);
821         balances[_from] = sub(balances[_from], _value);
822         allowed[_from][msg.sender] = sub(_allowance, _value);
823         Transfer(_from, _to, _value);
824         return true;
825     }
826 
827     /*  at initialization, setup the owner */
828     function ITGToken() {
829         owner = msg.sender;
830         totalSupply = 100000000 * 1 ether;
831         balances[msg.sender] = totalSupply;
832 
833         status = Status.Pause;
834     }
835     function () payable {
836        if(msg.value < minEtherParticipate){
837             throw;
838        }
839 
840        if(status == Status.CrowdSale){
841             LogFundTransfer(msg.sender, 0x0, msg.value, 1);
842             itgTokenTransfer(crowdSale.process(msg.sender,msg.value),true);
843        }else if(status == Status.Game){
844             LogFundTransfer(msg.sender, 0x0, msg.value, 1);
845             games.process(msg.sender, msg.value);
846        }else if(status == Status.Pause){
847             throw;
848        }
849     }
850 
851     function setAttrs(address csAddr, address gmAddr, address vtAddr, Status _status, uint amtEth, uint amtTok) onlyAuth {
852         crowdSale = CrowdSale(csAddr);
853         games = Games(gmAddr);
854         voting = Voting(vtAddr);
855         status = _status;
856         minEtherParticipate = amtEth;
857         minTokParticipate = amtTok;
858     }
859 
860     //getCrowdSaleToken
861     function USER_GET_CROWDSALE_TOKEN() {
862         itgTokenTransfer(crowdSale.getToken(msg.sender),true);
863     }
864 
865     //vote
866     function USER_VOTE(uint voteId, uint candidateId){
867         uint addedToken;
868         uint lockUntil;
869         (addedToken, lockUntil) = voting.vote(msg.sender,balances[msg.sender],voteId,candidateId);
870         itgTokenTransfer(addedToken,true);
871 
872         if(withdrawRestriction[msg.sender] < lockUntil){
873             withdrawRestriction[msg.sender] = lockUntil;
874         }
875     }
876 
877     function voteInitiate(uint voteId, uint voteRewardPerUnit, uint voteWeightUnit, uint voteStart, uint voteEnd, uint maxCandidateId) onlyAuth {
878         voting.voteInitiate(voteId, voteRewardPerUnit, voteWeightUnit, voteStart, voteEnd, maxCandidateId);
879     }
880 
881     function itgTokenTransfer(uint amt, bool fromOwner) private {
882         if(amt > 0){
883             if(fromOwner){
884                 balances[owner] = sub(balances[owner], amt);
885                 balances[msg.sender] = add(balances[msg.sender], amt);
886                 Transfer(owner, msg.sender, amt);
887                 LogFundTransfer(owner, msg.sender, amt, 2);
888             }else{
889                 balances[owner] = add(balances[owner], amt);
890                 balances[msg.sender] = sub(balances[msg.sender], amt);
891                 Transfer(msg.sender, owner, amt);
892                 LogFundTransfer(msg.sender, owner, amt, 2);
893             }
894         }
895     }
896 
897     function ethTransfer(address target, uint amt) private {
898         if(amt > 0){
899             target.transfer(amt);
900             LogFundTransfer(0x0, target, amt, 1);
901         }
902     }
903 
904     //gameWithToken
905     function USER_GAME_WITH_TOKEN(uint tokenAmountToGame) {
906         require(status == Status.Game);
907         require(balances[msg.sender] >= tokenAmountToGame * 1 ether);
908         require(tokenAmountToGame * 1 ether >= minTokParticipate);
909 
910         itgTokenTransfer(tokenAmountToGame * 1 ether,false);
911 
912         games.processWithITG(msg.sender, tokenAmountToGame * 1 ether);
913         
914     }
915 
916     //getPrize
917     function USER_GET_PRIZE() {
918         uint ethPrize;
919         uint tokPrize;
920         (ethPrize, tokPrize) = games.getPrize(msg.sender);
921         itgTokenTransfer(tokPrize,true);
922         ethTransfer(msg.sender, ethPrize);
923     }
924 
925     function selectWinner(uint rand) onlyAuth {
926         games.selectWinner(rand);
927     }
928 
929     function burn(uint amt) onlyOwner {
930         balances[msg.sender] = sub(balances[msg.sender], amt);
931         totalSupply = sub(totalSupply,amt);
932     }
933 
934     function mint(uint amt) onlyOwner {
935         balances[msg.sender] = add(balances[msg.sender], amt);
936         totalSupply = add(totalSupply,amt);
937     }
938 
939     // We do not want big difference with our contract's balance and actual prize pool.
940     // So the ethereum that the winners didn't get over at least 1 year will be used for our charity business.
941     // We strongly hope winners get their prize after the game.
942     function lossToCharity(uint year,address charityAccount) onlyAuth {
943         ethTransfer(charityAccount, games.lossToCharity(year));
944     }
945 
946     function charityAmtToCharity(address charityAccount) onlyOwner {
947         ethTransfer(charityAccount, games.charityAmtToCharity());
948     }
949 
950     function distributeTokenSale(uint hour, uint month, uint year, uint charity) onlyAuth{
951         games.distributeTokenSale(hour, month, year, charity);
952     }
953 
954 }