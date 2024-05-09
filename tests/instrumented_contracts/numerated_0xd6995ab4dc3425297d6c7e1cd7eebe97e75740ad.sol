1 // 0xRACER is a brand new team-based pot lottery game. 
2 // Users are grouped into teams based on the first byte of their address.
3 // Team One: 0x0..., 0x1..., 0x2..., 0x3..., 0x4..., 0x5..., 0x6..., 0x7...
4 // Team Two: 0x8..., 0x9..., 0xa..., 0xb..., 0xc..., 0xd..., 0xe..., 0x0...
5 
6 // DISCLAIMER: This is an experimental game in distributed psychology and distributed technology.
7 // DISCLAIMER: You can, and likely will, lose any ETH you send to this contract. Don't send more than you can afford to lose. Or any at all.
8 
9 // RULES:
10 
11 // 1. The team with the highest buy volume when the clock expires wins the pot.
12 // 2. The pot is divided among the winning team members, proportional to a weighted share of team volume. 
13 // 3. Each team has a different share price that increases at a rate of 102% per ETH of buy volume.
14 // 4. Every new buy adds time to the clock at the rate of 1 second/finney. The timer is capped at 24h.
15 // 5. You can also reduce the clock at the rate of 1 second/finney, but this does not count towards your share. The timer can't go below 5 minutes with this method.
16 // 6. Referrals and dividends are distributed by team. 50% of each new buy is proportionally split between that team's members.
17 // 7. New seeded rounds with new teams will begin on a semi-regular basis based on user interest. Each game will use a new contract.
18 // 8. In the unlikely event of a tie, the pot is distributed proportionally as weighted shares of total volume.
19 // 9. The minimum buy starts at 1 finney and increases with share price. No maximum.
20 // 10. There is no maximum buy, but large buys receive proportionally fewer shares. For example: 1 x 100 ETH buy (33,333 shares) vs. 100 x 1 ETH (55,265 shares).
21 // 10. No contracts allowed.
22 // 11. Users can withdraw earned dividends from referrals or pot wins at any time. Shares cannot be sold.
23 // 12. The round will automatically open based on a preset timer.
24 // 13. The contract will be closed no sooner than 100 days after the round ends. Any unclaimed user funds left past this time may be lost.
25 
26 // STRATEGY:
27 
28 // A. This game is designed to support multiple modes of play.
29 // B. Get in early and shill your team to collect divs.
30 // C. Manage risk by playing both sides of the fence.
31 // D. Flex your whale wallet by front running and reducing the timer.
32 // E. Piggy back on big players by making sure you're on the same team.
33 // F. Gain a larger share of divs by supporting the underdog.
34 // G. Buy smaller amounts to maximize your share count.
35 
36 // https://zeroxracer.surge.sh/
37 // https://discord.gg/6Q7kGpc
38 // by nightman
39 
40 pragma solidity ^0.4.24;
41 
42 contract ZEROxRACER {
43 
44     //VARIABLES AND CONSTANTS
45 
46     //global 
47     address public owner;
48     uint256 public devBalance;
49     uint256 public devFeeRate = 4; //4% of pot, not volume; effective dev fee, including premine, is ~2.5-3.5% depending on volume
50     uint256 public precisionFactor = 6; //shares precise to 0.0001%
51     address public addressThreshold = 0x7F00000000000000000000000000000000000000; //0x00-0x7f on Team One; 0x80-0xff on Team Two
52     uint256 public divRate = 50; //50% dividends for each buy, distributed proportionally to weighted team volume
53 
54     //team accounting
55     uint256 public teamOneId = 1; 
56     string public teamOnePrefix = "Team 0x1234567";
57     uint256 public teamOneVolume;
58     uint256 public teamOneShares;
59     uint256 public teamOneDivsTotal;
60     uint256 public teamOneDivsUnclaimed;
61     uint256 public teamOneSharePrice = 1000000000000000; //1 finney starting price; increases 102% per ETH bought
62 
63 
64     uint256 public teamTwoId = 2;
65     string public teamTwoPrefix = "Team 0x89abcdef";
66     uint256 public teamTwoVolume;
67     uint256 public teamTwoShares;
68     uint256 public teamTwoDivsTotal;
69     uint256 public teamTwoDivsUnclaimed;
70     uint256 public teamTwoSharePrice = 1000000000000000; //1 finney starting price; increases 102% per ETH bought
71 
72     //user accounting
73     address[] public teamOneMembers;
74     mapping (address => bool) public isTeamOneMember;
75     mapping (address => uint256) public userTeamOneStake;
76     mapping (address => uint256) public userTeamOneShares;
77     mapping (address => uint256) private userDivsTeamOneTotal;
78     mapping (address => uint256) private userDivsTeamOneClaimed;
79     mapping (address => uint256) private userDivsTeamOneUnclaimed;
80     mapping (address => uint256) private userDivRateTeamOne;
81     
82     address[] public teamTwoMembers;
83     mapping (address => bool) public isTeamTwoMember;
84     mapping (address => uint256) public userTeamTwoStake;
85     mapping (address => uint256) public userTeamTwoShares;
86     mapping (address => uint256) private userDivsTeamTwoTotal;
87     mapping (address => uint256) private userDivsTeamTwoClaimed;
88     mapping (address => uint256) private userDivsTeamTwoUnclaimed;
89     mapping (address => uint256) private userDivRateTeamTwo;
90 
91     //round accounting
92     uint256 public pot;
93     uint256 public timerStart;
94     uint256 public timerMax;
95     uint256 public roundStartTime;
96     uint256 public roundEndTime;
97     bool public roundOpen = false;
98     bool public roundSetUp = false;
99     bool public roundResolved = false;
100     
101 
102     //CONSTRUCTOR
103 
104     constructor() public {
105         owner = msg.sender;
106         emit contractLaunched(owner);
107     }
108     
109 
110     //MODIFIERS
111 
112     modifier onlyOwner() { 
113         require (msg.sender == owner, "you are not the owner"); 
114         _; 
115     }
116 
117     modifier gameOpen() {
118         require (roundResolved == false);
119         require (roundSetUp == true);
120         require (now < roundEndTime, "it is too late to play");
121         require (now >= roundStartTime, "it is too early to play");
122         _; 
123     }
124 
125     modifier onlyHumans() { 
126         require (msg.sender == tx.origin, "you cannot use a contract"); 
127         _; 
128     }
129     
130 
131     //EVENTS
132 
133     event potFunded(
134         address _funder, 
135         uint256 _amount,
136         string _message
137     );
138     
139     event teamBuy(
140         address _buyer, 
141         uint256 _amount, 
142         uint256 _teamID,
143         string _message
144     );
145     
146     event roundEnded(
147         uint256 _winningTeamId, 
148         string _winningTeamString, 
149         uint256 _pot,
150         string _message
151     );
152     
153     event newRoundStarted(
154         uint256 _timeStart, 
155         uint256 _timeMax,
156         uint256 _seed,
157         string _message
158     );
159 
160     event userWithdrew(
161         address _user,
162         uint256 _teamID,
163         uint256 _teamAmount,
164         string _message
165     );
166 
167     event devWithdrew(
168         address _owner,
169         uint256 _amount, 
170         string _message
171     );
172 
173     event contractClosed(
174         address _owner,
175         uint256 _amount,
176         string _message
177     );
178 
179     event contractLaunched(
180         address _owner
181     );
182 
183 
184     //DEV FUNCTIONS
185 
186     //start round
187     function openRound (uint _timerStart, uint _timerMax) public payable onlyOwner() {
188         require (roundOpen == false, "you can only start the game once");
189         require (roundResolved == false, "you cannot restart a finished game"); 
190         require (msg.value == 2 ether, "you must give a decent seed");
191 
192         //round set up
193         roundSetUp = true;
194         timerStart = _timerStart;
195         timerMax = _timerMax;
196         roundStartTime = 1535504400; //Tuesday, August 28, 2018 9:00:00 PM Eastern Time
197         roundEndTime = 1535504400 + timerStart;
198         pot += msg.value;
199 
200         //the seed is also a sneaky premine
201         //set up correct accounting for 1 ETH buy to each team without calling buy()
202         address devA = 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956;
203         address devB = 0x84ECB387395a1be65E133c75Ff9e5FCC6F756DB3;
204         teamOneVolume = 1 ether;
205         teamTwoVolume = 1 ether;
206         teamOneMembers.push(devA);
207         teamTwoMembers.push(devB);
208         isTeamOneMember[devA] = true;
209         isTeamOneMember[devB] = true;
210         userTeamOneStake[devA] = 1 ether;
211         userTeamTwoStake[devB] = 1 ether;
212         userTeamOneShares[devA] = 1000;
213         userTeamTwoShares[devB] = 1000;
214         teamOneShares = 1000;
215         teamTwoShares = 1000;
216 
217         emit newRoundStarted(timerStart, timerMax, msg.value, "a new game was just set up");
218     }
219 
220     //dev withdraw
221     function devWithdraw() public onlyOwner() {
222         require (devBalance > 0, "you must have an available balance");
223         require(devBalance <= address(this).balance, "you cannot print money");
224 
225         uint256 shareTemp = devBalance;
226         devBalance = 0;
227         owner.transfer(shareTemp);
228 
229         emit devWithdrew(owner, shareTemp, "the dev just withdrew");
230     }
231 
232     //close contract 
233     //this function allows the dev to collect any wei dust from rounding errors no sooner than 100 days after the game ends
234     //wei dust will be at most (teamOneVolume + teamTwoVolume) / 10 ** precisionFactor (ie, 0.0001% of the total buy volume)
235     //users must withdraw any earned divs before this date, or risk losing them
236     function zeroOut() public onlyOwner() { 
237         require (now >= roundEndTime + 100 days, "too early to exit scam"); 
238         require (roundResolved == true && roundOpen == false, "the game is not resolved");
239 
240         emit contractClosed(owner, address(this).balance, "the contract is now closed");
241 
242         selfdestruct(owner);
243     }
244 
245 
246     //PUBLIC FUNCTIONS
247 
248     function buy() public payable gameOpen() onlyHumans() { 
249 
250         //toggle roundOpen on first buy after roundStartTime
251         if (roundOpen == false && now >= roundStartTime && now < roundEndTime) {
252             roundOpen = true;
253         }
254         
255         //establish team affiliation 
256         uint256 _teamID;
257         if (checkAddressTeamOne(msg.sender) == true) {
258             _teamID = 1;
259         } else if (checkAddressTeamTwo(msg.sender) == true) {
260             _teamID = 2;
261         }
262 
263         //adjust pot and div balances
264         if (_teamID == 1 && teamOneMembers.length == 0 || _teamID == 2 && teamTwoMembers.length == 0) { 
265             //do not distribute divs on first buy from either team. prevents black-holed ether
266             //redundant if openRound() includes a premine
267             pot += msg.value;
268         } else {
269             uint256 divContribution = uint256(SafeMaths.div(SafeMaths.mul(msg.value, divRate), 100)); 
270             uint256 potContribution = msg.value - divContribution;
271             pot += potContribution; 
272             distributeDivs(divContribution, _teamID); 
273         }
274 
275         //adjust time 
276         timeAdjustPlus();
277 
278         //update team and player accounting 
279         if (_teamID == 1) {
280             require (msg.value >= teamOneSharePrice, "you must buy at least one Team One share");
281 
282             if (isTeamOneMember[msg.sender] == false) {
283                 isTeamOneMember[msg.sender] = true;
284                 teamOneMembers.push(msg.sender);
285             }
286 
287             userTeamOneStake[msg.sender] += msg.value;
288             teamOneVolume += msg.value;
289 
290             //adjust team one share price
291             uint256 shareIncreaseOne = SafeMaths.mul(SafeMaths.div(msg.value, 100000), 2); //increases 102% per ETH spent
292             teamOneSharePrice += shareIncreaseOne;
293 
294             uint256 newSharesOne = SafeMaths.div(msg.value, teamOneSharePrice);
295             userTeamOneShares[msg.sender] += newSharesOne;
296             teamOneShares += newSharesOne;
297 
298         } else if (_teamID == 2) {
299             require (msg.value >= teamTwoSharePrice, "you must buy at least one Team Two share");
300 
301             if (isTeamTwoMember[msg.sender] == false) {
302                 isTeamTwoMember[msg.sender] = true;
303                 teamTwoMembers.push(msg.sender);
304             }
305 
306             userTeamTwoStake[msg.sender] += msg.value;
307             teamTwoVolume += msg.value;
308 
309             //adjust team two share price
310             uint256 shareIncreaseTwo = SafeMaths.mul(SafeMaths.div(msg.value, 100000), 2); //increases 102% per ETH spent
311             teamTwoSharePrice += shareIncreaseTwo;
312 
313             uint256 newSharesTwo = SafeMaths.div(msg.value, teamTwoSharePrice);
314             userTeamTwoShares[msg.sender] += newSharesTwo;
315             teamTwoShares += newSharesTwo;
316         }
317     
318         emit teamBuy(msg.sender, msg.value, _teamID, "a new buy just happened");
319     }  
320 
321     function resolveRound() public onlyHumans() { 
322 
323         //can be called by anyone if the round has ended 
324         require (now > roundEndTime, "you can only call this if time has expired");
325         require (roundSetUp == true, "you cannot call this before the game starts");
326         require (roundResolved == false, "you can only call this once");
327 
328         //resolve round based on current winner 
329         if (teamOneVolume > teamTwoVolume) {
330             teamOneWin();
331         } else if (teamOneVolume < teamTwoVolume) {
332             teamTwoWin();
333         } else if (teamOneVolume == teamTwoVolume) {
334             tie();
335         }
336 
337         //ensure this function can only be called once
338         roundResolved = true; 
339         roundOpen = false;
340     }
341 
342     function userWithdraw() public onlyHumans() {
343 
344         //user divs calculated on withdraw to prevent runaway gas costs associated with looping balance updates in distributeDivs
345         if (userTeamOneShares[msg.sender] > 0) { 
346 
347             //first, calculate total earned user divs as a proportion of their shares vs. team shares
348             //second, determine whether the user has available divs 
349             //precise to 0.0001%
350             userDivRateTeamOne[msg.sender] = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamOneShares[msg.sender], 10 ** (precisionFactor + 1)), teamOneShares) + 5, 10);
351             userDivsTeamOneTotal[msg.sender] = uint256(SafeMaths.div(SafeMaths.mul(teamOneDivsTotal, userDivRateTeamOne[msg.sender]), 10 ** precisionFactor));
352             userDivsTeamOneUnclaimed[msg.sender] = SafeMaths.sub(userDivsTeamOneTotal[msg.sender], userDivsTeamOneClaimed[msg.sender]);
353 
354             if (userDivsTeamOneUnclaimed[msg.sender] > 0) {
355                 //sanity check
356                 assert(userDivsTeamOneUnclaimed[msg.sender] <= address(this).balance && userDivsTeamOneUnclaimed[msg.sender] <= teamOneDivsUnclaimed);
357 
358                 //update user accounting and transfer
359                 teamOneDivsUnclaimed -= userDivsTeamOneUnclaimed[msg.sender];
360                 userDivsTeamOneClaimed[msg.sender] = userDivsTeamOneTotal[msg.sender];
361                 uint256 shareTempTeamOne = userDivsTeamOneUnclaimed[msg.sender];
362                 userDivsTeamOneUnclaimed[msg.sender] = 0;
363                 msg.sender.transfer(shareTempTeamOne);
364 
365                 emit userWithdrew(msg.sender, 1, shareTempTeamOne, "a user just withdrew team one shares");
366             }
367 
368         }  else if (userTeamTwoShares[msg.sender] > 0) {
369 
370             //first, calculate total earned user divs as a proportion of their shares vs. team shares
371             //second, determine whether the user has available divs 
372             //precise to 0.0001%
373             userDivRateTeamTwo[msg.sender] = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamTwoShares[msg.sender], 10 ** (precisionFactor + 1)), teamTwoShares) + 5, 10);
374             userDivsTeamTwoTotal[msg.sender] = uint256(SafeMaths.div(SafeMaths.mul(teamTwoDivsTotal, userDivRateTeamTwo[msg.sender]), 10 ** precisionFactor));
375             userDivsTeamTwoUnclaimed[msg.sender] = SafeMaths.sub(userDivsTeamTwoTotal[msg.sender], userDivsTeamTwoClaimed[msg.sender]);
376 
377             if (userDivsTeamTwoUnclaimed[msg.sender] > 0) {
378                 //sanity check
379                 assert(userDivsTeamTwoUnclaimed[msg.sender] <= address(this).balance && userDivsTeamTwoUnclaimed[msg.sender] <= teamTwoDivsUnclaimed);
380 
381                 //update user accounting and transfer
382                 teamTwoDivsUnclaimed -= userDivsTeamTwoUnclaimed[msg.sender];
383                 userDivsTeamTwoClaimed[msg.sender] = userDivsTeamTwoTotal[msg.sender];
384                 uint256 shareTempTeamTwo = userDivsTeamTwoUnclaimed[msg.sender];
385                 userDivsTeamTwoUnclaimed[msg.sender] = 0;
386                 msg.sender.transfer(shareTempTeamTwo);
387 
388                 emit userWithdrew(msg.sender, 2, shareTempTeamTwo, "a user just withdrew team one shares");
389             }
390         }
391     }
392 
393     function fundPot() public payable onlyHumans() gameOpen() {
394         //ETH sent with this function is a benevolent gift. It does not count towards user shares or adjust the clock
395         pot += msg.value;
396         emit potFunded(msg.sender, msg.value, "a generous person funded the pot");
397     }
398 
399     function reduceTime() public payable onlyHumans() gameOpen() {
400         //ETH sent with this function does not count towards user shares 
401         timeAdjustNeg();
402         pot += msg.value;
403         emit potFunded(msg.sender, msg.value, "someone just reduced the clock");
404     }
405 
406 
407     //VIEW FUNCTIONS
408 
409     function calcUserDivsTotal(address _user) public view returns(uint256 _divs) {
410 
411         //calculated locally to avoid unnecessary state change
412         if (userTeamOneShares[_user] > 0) {
413 
414             uint256 userDivRateTeamOneView = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamOneShares[_user], 10 ** (precisionFactor + 1)), teamOneShares) + 5, 10);
415             uint256 userDivsTeamOneTotalView = uint256(SafeMaths.div(SafeMaths.mul(teamOneDivsTotal, userDivRateTeamOneView), 10 ** precisionFactor));
416 
417         } else if (userTeamTwoShares[_user] > 0) {
418 
419             uint256 userDivRateTeamTwoView = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamTwoShares[_user], 10 ** (precisionFactor + 1)), teamTwoShares) + 5, 10);
420             uint256 userDivsTeamTwoTotalView = uint256(SafeMaths.div(SafeMaths.mul(teamTwoDivsTotal, userDivRateTeamTwoView), 10 ** precisionFactor));
421 
422         }
423 
424         uint256 userDivsTotal = userDivsTeamOneTotalView + userDivsTeamTwoTotalView;
425         return userDivsTotal;
426     }
427 
428     function calcUserDivsAvailable(address _user) public view returns(uint256 _divs) {
429 
430         //calculated locally to avoid unnecessary state change
431         if (userTeamOneShares[_user] > 0) {
432 
433             uint256 userDivRateTeamOneView = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamOneShares[_user], 10 ** (precisionFactor + 1)), teamOneShares) + 5, 10);
434             uint256 userDivsTeamOneTotalView = uint256(SafeMaths.div(SafeMaths.mul(teamOneDivsTotal, userDivRateTeamOneView), 10 ** precisionFactor));
435             uint256 userDivsTeamOneUnclaimedView = SafeMaths.sub(userDivsTeamOneTotalView, userDivsTeamOneClaimed[_user]);
436 
437         } else if (userTeamTwoShares[_user] > 0) {
438 
439             uint256 userDivRateTeamTwoView = SafeMaths.div(SafeMaths.div(SafeMaths.mul(userTeamTwoShares[_user], 10 ** (precisionFactor + 1)), teamTwoShares) + 5, 10);
440             uint256 userDivsTeamTwoTotalView = uint256(SafeMaths.div(SafeMaths.mul(teamTwoDivsTotal, userDivRateTeamTwoView), 10 ** precisionFactor));
441             uint256 userDivsTeamTwoUnclaimedView = SafeMaths.sub(userDivsTeamTwoTotalView, userDivsTeamTwoClaimed[_user]);
442 
443         }
444 
445         uint256 userDivsUnclaimed = userDivsTeamOneUnclaimedView + userDivsTeamTwoUnclaimedView;
446         return userDivsUnclaimed;
447     }
448 
449     function currentRoundInfo() public view returns(
450         uint256 _pot, 
451         uint256 _teamOneVolume, 
452         uint256 _teamTwoVolume, 
453         uint256 _teamOnePlayerCount,
454         uint256 _teamTwoPlayerCount,
455         uint256 _totalPlayerCount,
456         uint256 _timerStart, 
457         uint256 _timerMax, 
458         uint256 _roundStartTime, 
459         uint256 _roundEndTime, 
460         uint256 _timeLeft,
461         string _currentWinner
462     ) {
463         return (
464             pot, 
465             teamOneVolume, 
466             teamTwoVolume, 
467             teamOneTotalPlayers(), 
468             teamTwoTotalPlayers(), 
469             totalPlayers(), 
470             timerStart, 
471             timerMax, 
472             roundStartTime, 
473             roundEndTime, 
474             getTimeLeft(),
475             currentWinner()
476         );
477     }
478 
479     function getTimeLeft() public view returns(uint256 _timeLeftSeconds) {
480         //game over: display zero
481         if (now >= roundEndTime) {
482             return 0;
483         //game not yet started: display countdown until roundStartTime
484         } else if (roundOpen == false && roundResolved == false && roundSetUp == false) {
485             return roundStartTime - now;
486         //game in progress: display time left 
487         } else {
488             return roundEndTime - now;
489         }
490     }
491     
492     function teamOneTotalPlayers() public view returns(uint256 _teamOnePlayerCount) {
493         return teamOneMembers.length;
494     }
495 
496     function teamTwoTotalPlayers() public view returns(uint256 _teamTwoPlayerCount) {
497         return teamTwoMembers.length;
498     }
499 
500     function totalPlayers() public view returns(uint256 _totalPlayerCount) {
501         return teamOneMembers.length + teamTwoMembers.length;
502     }
503 
504     function adjustedPotBalance() public view returns(uint256 _adjustedPotBalance) {
505         uint256 devFee = uint256(SafeMaths.div(SafeMaths.mul(pot, devFeeRate), 100));
506         return pot - devFee;
507     }
508 
509     function contractBalance() public view returns(uint256 _contractBalance) {
510         return address(this).balance;
511     }
512 
513     function currentTime() public view returns(uint256 _time) {
514         return now;
515     }
516 
517     function currentWinner() public view returns(string _winner) {
518         if (teamOneVolume > teamTwoVolume) {
519             return teamOnePrefix;
520         } else if (teamOneVolume < teamTwoVolume) {
521             return teamTwoPrefix;
522         } else if (teamOneVolume == teamTwoVolume) {
523             return "a tie? wtf";
524         }
525     }
526 
527 
528     //INTERNAL FUNCTIONS
529 
530     //time adjustments
531     function timeAdjustPlus() internal {
532         if (msg.value >= 1 finney) {
533             uint256 timeFactor = 1000000000000000; //one finney in wei
534             uint256 timeShares = uint256(SafeMaths.div(msg.value, timeFactor)); 
535 
536             if (timeShares + roundEndTime > now + timerMax) {
537                 roundEndTime = now + timerMax;
538             } else {
539                 roundEndTime += timeShares; //add one second per finney  
540             }
541         }
542     }
543 
544     function timeAdjustNeg() internal {
545         if (msg.value >= 1 finney) {
546             uint256 timeFactor = 1000000000000000; //one finney in wei
547             uint256 timeShares = uint256(SafeMaths.div(msg.value, timeFactor));
548 
549             // prevents extreme edge case underflow if someone sends more than 1.5 million ETH
550             require (timeShares < roundEndTime, "you sent an absurd amount! relax vitalik"); 
551 
552             if (roundEndTime - timeShares < now + 5 minutes) {
553                 roundEndTime = now + 5 minutes; //you can't win by buying up the clock, but you can come close
554             } else {
555                 roundEndTime -= timeShares; //subtract one second per finney  
556             }
557         }
558     }
559 
560     //divs 
561     function distributeDivs(uint256 _divContribution, uint256 _teamID) internal {
562         if (_teamID == 1) {
563             teamOneDivsTotal += _divContribution;
564             teamOneDivsUnclaimed += _divContribution;
565         } else if (_teamID == 2) {
566             teamTwoDivsTotal += _divContribution;
567             teamTwoDivsUnclaimed += _divContribution;
568         }
569     }
570 
571     //round payouts
572     function teamOneWin() internal {
573         uint256 devShare = uint256(SafeMaths.div(SafeMaths.mul(pot, devFeeRate), 100)); 
574         devBalance += devShare;
575         uint256 potAdjusted = pot - devShare;
576 
577         teamOneDivsTotal += potAdjusted;
578         teamOneDivsUnclaimed += potAdjusted;
579 
580         emit roundEnded(1, teamOnePrefix, potAdjusted, "team one won!");
581     }
582 
583     function teamTwoWin() internal {
584         uint256 devShare = uint256(SafeMaths.div(SafeMaths.mul(pot, devFeeRate), 100)); 
585         devBalance += devShare;
586         uint256 potAdjusted = pot - devShare;
587 
588         teamTwoDivsTotal += potAdjusted;
589         teamTwoDivsUnclaimed += potAdjusted;
590 
591         emit roundEnded(2, teamTwoPrefix, potAdjusted, "team two won!");        
592     }
593 
594     function tie() internal { //very unlikely this will happen, but just in case 
595         uint256 devShare = uint256(SafeMaths.div(SafeMaths.mul(pot, devFeeRate), 100)); 
596         devBalance += devShare;
597         uint256 potAdjusted = pot - devShare;
598 
599         teamOneDivsTotal += SafeMaths.div(potAdjusted, 2);
600         teamOneDivsUnclaimed += SafeMaths.div(potAdjusted, 2);
601         teamTwoDivsTotal += SafeMaths.div(potAdjusted, 2);
602         teamTwoDivsUnclaimed += SafeMaths.div(potAdjusted, 2);
603 
604         emit roundEnded(0, "Tied", potAdjusted, "a tie?! wtf");
605     }
606 
607 
608     //convert and address to bytes format
609     function toBytes(address a) internal pure returns (bytes b) {
610         assembly {
611             let m := mload(0x40)
612             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
613             mstore(0x40, add(m, 52))
614             b := m
615         }
616         return b;
617     }
618     
619     //take the first byte of a bytes argument and return bytes1
620     function toBytes1(bytes data) internal pure returns (bytes1) {
621         uint val;
622         for (uint i = 0; i < 1; i++)  {
623             val *= 256;
624             if (i < data.length)
625                 val |= uint8(data[i]);
626         }
627         return bytes1(val);
628     }
629     
630     //combine the above function
631     function addressToBytes1(address input) internal pure returns(bytes1) {
632         bytes1 output = toBytes1(toBytes(input));
633         return output;
634     }
635 
636     //address checks
637     function checkAddressTeamOne(address _input) internal view returns(bool) {
638         if (addressToBytes1(_input) <= addressToBytes1(addressThreshold)) {
639             return true;
640         } else {
641             return false;
642         }
643     }
644     
645     function checkAddressTeamTwo(address _input) internal view returns(bool) {
646         if (addressToBytes1(_input) > addressToBytes1(addressThreshold)) {
647             return true;
648         } else {
649             return false;
650         }
651     }
652 
653 }  
654 
655 //LIBRARIES
656 
657 library SafeMaths {
658 
659     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
660         if (a == 0) {
661           return 0;
662         }
663         uint256 c = a * b;
664         assert(c / a == b);
665         return c;
666     }
667 
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         uint256 c = a / b;
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
681         return c;
682     }
683 }