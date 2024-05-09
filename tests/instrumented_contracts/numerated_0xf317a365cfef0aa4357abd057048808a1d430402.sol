1 pragma solidity ^0.4.24;
2 //================================================================================
3 //                            Plague Inc. <Grand prize>
4 // WARNING!!! WARNING!!! WARNING!!! WARNING!!! WARNING!!! WARNING!!! WARNING!!!
5 //                     This game is easy for you to get rich.
6 //                           Please prepare enough ETH.
7 //                 If you have HEART DISEASE, PLEASE DON'T PLAY.
8 //       If you are Chinese or American, please don't play. YOU ARE TOO RICH.
9 // 
10 // Plague Inc. , which is abbreviated as PIC by players.
11 // is developed by a well-known games company who put a lot of effort into R&D.
12 // One evening, our producer had a hands-on experience on FOMO3D.
13 // and he was really annoyed by the "unreasonable" numerical settings in FOMO3D.
14 // He said: "We can make a better one!"
15 // So we made a better one. ^v^
16 // 
17 // # It takes less time for investors to get back their capital, while making more
18 //   profit (51% for investor dividends).
19 // # Introducers can get a high return of 10% (effective in the long term).
20 // # A lot of investors suffered losses in FOMO3D Quick, which is solved perfectly
21 //   by Plague Inc.
22 // # A total of 11 players will share the grand prize, you don’t have to be the
23 //   last one.
24 // # Better numerical and time setup, no worries about being in trouble.
25 // 
26 //                     ©2030 Plague Inc. All Rights Reserved.
27 //                                www.plagueinc.io
28 //                Memorial Bittorrent, eDonkey, eMule. Embrace IPFS
29 //                        Blockchain will change the world.
30 //================================================================================
31 library SafeMath {
32     function mul(uint256 a, uint256 b) 
33         internal 
34         pure 
35         returns (uint256 c) 
36     {
37         if (a == 0) {
38             return 0;
39         }
40         c = a * b;
41         require(c / a == b, "SafeMath mul failed");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b)
46         internal
47         pure
48         returns (uint256) 
49     {
50         require(b <= a, "SafeMath sub failed");
51         return a - b;
52     }
53     
54     function add(uint256 a, uint256 b)
55         internal
56         pure
57         returns (uint256 c) 
58     {
59         c = a + b;
60         require(c >= a, "SafeMath add failed");
61         return c;
62     }
63     
64     function sqrt(uint256 x)
65         internal
66         pure
67         returns (uint256 y) 
68     {
69         uint256 z = ((add(x,1)) / 2);
70         y = x;
71         while (z < y) 
72         {
73             y = z;
74             z = ((add((x / z),z)) / 2);
75         }
76     }
77     
78     function sq(uint256 x)
79         internal
80         pure
81         returns (uint256)
82     {
83         return (mul(x,x));
84     }
85     
86     function pwr(uint256 x, uint256 y)
87         internal 
88         pure 
89         returns (uint256)
90     {
91         if (x==0)
92             return (0);
93         else if (y==0)
94             return (1);
95         else 
96         {
97             uint256 z = x;
98             for (uint256 i=1; i < y; i++)
99                 z = mul(z,x);
100             return (z);
101         }
102     }
103 }
104 
105 contract PlagueEvents {
106 	
107 	//infective person
108     event onInfectiveStage
109     (
110         address indexed player,
111         uint256 indexed rndNo,
112         uint256 keys,
113         uint256 eth,
114         uint256 timeStamp,
115 		address indexed inveter
116     );
117 
118     // become leader during second stage
119     event onDevelopmentStage
120     (
121         address indexed player,
122         uint256 indexed rndNo,
123         uint256 eth,
124         uint256 timeStamp,
125 		address indexed inveter
126     );
127 
128     // award
129     event onAward
130     (
131         address indexed player,
132         uint256 indexed rndNo,
133         uint256 eth,
134         uint256 timeStamp
135     );
136 }
137 
138 contract Plague is PlagueEvents{
139     using SafeMath for *;
140     using KeysCalc for uint256;
141 
142     struct Round {
143         uint256 eth;                // total eth
144         uint256 keys;               // total keys
145         uint256 startTime;          // start time
146         uint256 endTime;            // end time
147         uint256 infectiveEndTime;   // infective end time
148         address leader;             // leader
149         address infectLastPlayer;   // the player will award 10% eth
150         address [11] lastInfective;  // the lastest 11 infective
151         address [4] loseInfective;  // the lose infective
152         bool [11] infectiveAward_m; //
153         uint256 totalInfective;     // the count of this round
154         uint256 inveterAmount;      // remain inveter amount of this round
155         uint256 lastRoundReward;    // last round remain eth 10% + eth 4% - inveterAmount + last remain award
156         uint256 exAward;            // development award
157     }
158 
159     struct PlayerRound {
160         uint256 eth;        // eth player has added to round
161         uint256 keys;       // keys
162         uint256 withdraw;   // how many eth has been withdraw
163         uint256 getInveterAmount; // inverter amount
164         uint256 hasGetAwardAmount;  // player has get award amount
165     }
166 
167     uint256 public rndNo = 1;                                   // current round number
168     uint256 public totalEth = 0;                                // total eth in all round
169 
170     uint256 constant private rndInfectiveStage_ = 12 hours;          // round timer at infective stage 12 hours;
171     uint256 constant private rndInfectiveReadyTime_ = 30 minutes;      // round timer at infective stage ready time
172     uint256 constant private rndDevelopmentStage_ = 15 minutes;       // round timer at development stage 30 minutes; 
173     uint256 constant private rndDevelopmentReadyTime_ = 12 hours;       // round timer at development stage ready time 1 hours;
174     uint256 constant private allKeys_ = 15000000 * (10 ** 18);   // all keys count
175     uint256 constant private allEths_ = 18703123828125000000000; // all eths count
176     uint256 constant private rndIncreaseTime_ = 3 hours;       // increase time 3 hours
177     uint256 constant private developmentAwardPercent = 1;   // 0.1% reduction every 3 hours
178 
179     mapping (uint256 => Round) public round_m;                  // (rndNo => Round)
180     mapping (uint256 => mapping (address => PlayerRound)) public playerRound_m;   // (rndNo => addr => PlayerRound)
181 
182     address public owner;               // owner address
183     address public receiver = address(0);            // receive eth address
184     uint256 public ownerWithdraw = 0;   // how many eth has been withdraw by owner
185     bool public isStartGame = false;    // start game flag
186 
187     constructor()
188         public
189     {
190         owner = msg.sender;
191     }
192 
193     /**
194      * @dev prevents contracts from interacting
195      */
196     modifier onlyHuman() 
197     {
198         address _addr = msg.sender;
199         uint256 _codeLength;
200         
201         assembly {_codeLength := extcodesize(_addr)}
202         require(_codeLength == 0, "sorry humans only");
203         _;
204     }
205     
206     /**
207      * @dev sets boundaries for incoming tx 
208      */
209     modifier isWithinLimits(uint256 _eth) 
210     {
211         require(_eth >= 1000000000, "pocket lint: not a valid currency");
212         require(_eth <= 100000000000000000000000, "no vitalik, no");
213         _;    
214     }
215 
216     /**
217      * @dev only owner
218      */
219     modifier onlyOwner() 
220     {
221         require(owner == msg.sender, "only owner can do it");
222         _;    
223     }
224     
225     /**
226      * @dev It must be human beings to call the function.
227      */
228     function isHuman(address _addr) private view returns (bool)
229     {
230         uint256 _codeLength;
231         
232         assembly {_codeLength := extcodesize(_addr)}
233         return _codeLength == 0;
234     }
235    
236    /**
237 	 * @dev player infect a person at current round
238 	 * 
239 	 */
240     function buyKeys(address _inveter) private
241     {
242         uint256 _eth = msg.value;
243         uint256 _now = now;
244         uint256 _rndNo = rndNo;
245         uint256 _ethUse = msg.value;
246 
247         if (_now > round_m[_rndNo].endTime)
248         {
249             require(round_m[_rndNo].endTime + rndDevelopmentReadyTime_ < _now, "we should wait some time");
250             
251             uint256 lastAwardEth = (round_m[_rndNo].eth.mul(14) / 100).sub(round_m[_rndNo].inveterAmount);
252             
253             if(round_m[_rndNo].totalInfective < round_m[_rndNo].lastInfective.length)
254             {
255                 uint256 nextPlayersAward = round_m[_rndNo].lastInfective.length.sub(round_m[_rndNo].totalInfective);
256                 uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
257                 _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
258                 if(round_m[_rndNo].infectLastPlayer != address(0))
259                 {
260                     lastAwardEth = lastAwardEth.add(nextPlayersAward.mul(_totalAward.mul(3)/100));
261                 }
262                 else
263                 {
264                     lastAwardEth = lastAwardEth.add(nextPlayersAward.mul(_totalAward.mul(4)/100));
265                 }
266             }
267             
268             _rndNo = _rndNo.add(1);
269             rndNo = _rndNo;
270             round_m[_rndNo].startTime = _now;
271             round_m[_rndNo].endTime = _now + rndInfectiveStage_;
272             round_m[_rndNo].totalInfective = 0;
273             round_m[_rndNo].lastRoundReward = lastAwardEth;
274         }
275 
276         // infective or second stage
277         if (round_m[_rndNo].keys < allKeys_)
278         {
279             // infection stage
280             uint256 _keys = (round_m[_rndNo].eth).keysRec(_eth);
281             
282             if (_keys.add(round_m[_rndNo].keys) >= allKeys_)
283             {
284                 _keys = allKeys_.sub(round_m[_rndNo].keys);
285 
286                 if (round_m[_rndNo].eth >= allEths_)
287                 {
288                     _ethUse = 0;
289                 } 
290                 else {
291                     _ethUse = (allEths_).sub(round_m[_rndNo].eth);
292                 }
293 
294                 if (_eth > _ethUse)
295                 {
296                     // refund
297                     msg.sender.transfer(_eth.sub(_ethUse));
298                 } 
299                 else {
300                     // fix
301                     _ethUse = _eth;
302                 }
303                 // first stage is over, record current time
304                 round_m[_rndNo].infectiveEndTime = _now.add(rndInfectiveReadyTime_);
305                 round_m[_rndNo].endTime = _now.add(rndDevelopmentStage_).add(rndInfectiveReadyTime_);
306                 round_m[_rndNo].infectLastPlayer = msg.sender;
307             }
308             else
309             {
310                 require (_keys >= 1 * 10 ** 19, "at least 10 thound people");
311                 round_m[_rndNo].endTime = _now + rndInfectiveStage_;
312             }
313             
314             round_m[_rndNo].leader = msg.sender;
315 
316             // update playerRound
317             playerRound_m[_rndNo][msg.sender].keys = _keys.add(playerRound_m[_rndNo][msg.sender].keys);
318             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
319 
320             // update round
321             round_m[_rndNo].keys = _keys.add(round_m[_rndNo].keys);
322             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
323 
324             // update global variable
325             totalEth = _ethUse.add(totalEth);
326 
327             // event
328             emit PlagueEvents.onInfectiveStage
329             (
330                 msg.sender,
331                 _rndNo,
332                 _keys,
333                 _ethUse,
334                 _now,
335 				_inveter
336             );
337         } else {
338             // second stage
339             require(round_m[_rndNo].infectiveEndTime < _now, "The virus is being prepared...");
340             
341             // increase 0.05 Ether every 3 hours
342             _ethUse = (((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(5 * 10 ** 16)).add((5 * 10 ** 16));
343             
344             require(_eth >= _ethUse, "Ether amount is wrong");
345             
346             if(_eth > _ethUse)
347             {
348                 msg.sender.transfer(_eth.sub(_ethUse));
349             }
350 
351             round_m[_rndNo].endTime = _now + rndDevelopmentStage_;
352             round_m[_rndNo].leader = msg.sender;
353 
354             // update playerRound
355             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
356 
357             // update round
358             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
359 
360             // update global variable
361             totalEth = _ethUse.add(totalEth);
362             
363             // update development award
364             uint256 _exAwardPercent = ((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(developmentAwardPercent).add(developmentAwardPercent);
365             if(_exAwardPercent >= 410)
366             {
367                 _exAwardPercent = 410;
368             }
369             round_m[_rndNo].exAward = (_exAwardPercent.mul(_ethUse) / 1000).add(round_m[_rndNo].exAward);
370 
371             // event
372             emit PlagueEvents.onDevelopmentStage
373             (
374                 msg.sender,
375                 _rndNo,
376                 _ethUse,
377                 _now,
378 				_inveter
379             );
380         }
381         
382         // caculate share inveter amount
383         if(_inveter != address(0) && isHuman(_inveter)) 
384         {
385             playerRound_m[_rndNo][_inveter].getInveterAmount = playerRound_m[_rndNo][_inveter].getInveterAmount.add(_ethUse.mul(10) / 100);
386             round_m[_rndNo].inveterAmount = round_m[_rndNo].inveterAmount.add(_ethUse.mul(10) / 100);
387         }
388         
389         round_m[_rndNo].loseInfective[round_m[_rndNo].totalInfective % 4] = round_m[_rndNo].lastInfective[round_m[_rndNo].totalInfective % 11];
390         round_m[_rndNo].lastInfective[round_m[_rndNo].totalInfective % 11] = msg.sender;
391         
392         round_m[_rndNo].totalInfective = round_m[_rndNo].totalInfective.add(1);
393     }
394     
395 	/**
396 	 * @dev recommend a player
397 	 */
398     function buyKeyByAddr(address _inveter)
399         onlyHuman()
400         isWithinLimits(msg.value)
401         public
402         payable
403     {
404         require(isStartGame == true, "The game hasn't started yet.");
405         buyKeys(_inveter);
406     }
407 
408     /**
409      * @dev play
410      */
411     function()
412         onlyHuman()
413         isWithinLimits(msg.value)
414         public
415         payable
416     {
417         require(isStartGame == true, "The game hasn't started yet.");
418         buyKeys(address(0));
419     }
420     
421     /**
422      * @dev Award by rndNo.
423      * 0x80ec35ff
424      * 0x80ec35ff0000000000000000000000000000000000000000000000000000000000000001
425      */
426     function awardByRndNo(uint256 _rndNo)
427         onlyHuman()
428         public
429     {
430         require(isStartGame == true, "The game hasn't started yet.");
431         require(_rndNo <= rndNo, "You're running too fast");
432         
433         uint256 _ethOut = 0;
434         uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
435         _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
436         _totalAward = _totalAward.add(round_m[_rndNo].exAward);
437         uint256 _getAward = 0;
438         
439         //withdraw award
440         uint256 _totalWithdraw = round_m[_rndNo].eth.mul(51) / 100;
441         _totalWithdraw = _totalWithdraw.sub(round_m[_rndNo].exAward);
442         _totalWithdraw = (_totalWithdraw.mul(playerRound_m[_rndNo][msg.sender].keys));
443         _totalWithdraw = _totalWithdraw / round_m[_rndNo].keys;
444         
445         uint256 _inveterAmount = playerRound_m[_rndNo][msg.sender].getInveterAmount;
446         _totalWithdraw = _totalWithdraw.add(_inveterAmount);
447         uint256 _withdrawed = playerRound_m[_rndNo][msg.sender].withdraw;
448         if(_totalWithdraw > _withdrawed)
449         {
450             _ethOut = _ethOut.add(_totalWithdraw.sub(_withdrawed));
451             playerRound_m[_rndNo][msg.sender].withdraw = _totalWithdraw;
452         }
453         
454          //lastest infect player
455         if(msg.sender == round_m[_rndNo].infectLastPlayer && round_m[_rndNo].infectLastPlayer != address(0) && round_m[_rndNo].infectiveEndTime != 0)
456         {
457             _getAward = _getAward.add(_totalAward.mul(10)/100);
458         }
459         
460         if(now > round_m[_rndNo].endTime)
461         {
462             // finally award
463             if(round_m[_rndNo].leader == msg.sender)
464             {
465                 _getAward = _getAward.add(_totalAward.mul(60)/100);
466             }
467             
468             //finally ten person award
469             for(uint256 i = 0;i < round_m[_rndNo].lastInfective.length; i = i.add(1))
470             {
471                 if(round_m[_rndNo].lastInfective[i] == msg.sender && (round_m[_rndNo].totalInfective.sub(1) % 11) != i){
472                     if(round_m[_rndNo].infectiveAward_m[i])
473                         continue;
474                     if(round_m[_rndNo].infectLastPlayer != address(0))
475                     {
476                         _getAward = _getAward.add(_totalAward.mul(3)/100);
477                     }
478                     else{
479                         _getAward = _getAward.add(_totalAward.mul(4)/100);
480                     }
481                         
482                     round_m[_rndNo].infectiveAward_m[i] = true;
483                 }
484             }
485         }
486         _ethOut = _ethOut.add(_getAward.sub(playerRound_m[_rndNo][msg.sender].hasGetAwardAmount));
487         playerRound_m[_rndNo][msg.sender].hasGetAwardAmount = _getAward;
488         
489         if(_ethOut != 0)
490         {
491             msg.sender.transfer(_ethOut); 
492         }
493         
494         // event
495         emit PlagueEvents.onAward
496         (
497             msg.sender,
498             _rndNo,
499             _ethOut,
500             now
501         );
502     }
503     
504     /**
505      * @dev Get player bonus data
506      * 0xd982466d
507      * 0xd982466d0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000028f211f6c07d3b79e0aab886d56333e4027d4f59
508      * @return player's award
509      * @return player's can withdraw amount
510      * @return player's inveter amount
511      * @return player's has been withdraw
512      */
513     function getPlayerAwardByRndNo(uint256 _rndNo, address _playAddr)
514         view
515         public
516         returns (uint256, uint256, uint256, uint256)
517     {
518         uint256 _ethPlayerAward = 0;
519         
520         //withdraw award
521         uint256 _totalWithdraw = round_m[_rndNo].eth.mul(51) / 100;
522         _totalWithdraw = _totalWithdraw.sub(round_m[_rndNo].exAward);
523         _totalWithdraw = (_totalWithdraw.mul(playerRound_m[_rndNo][_playAddr].keys));
524         _totalWithdraw = _totalWithdraw / round_m[_rndNo].keys;
525         
526         uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
527         _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
528         _totalAward = _totalAward.add(round_m[_rndNo].exAward);
529         
530         //lastest infect player
531         if(_playAddr == round_m[_rndNo].infectLastPlayer && round_m[_rndNo].infectLastPlayer != address(0) && round_m[_rndNo].infectiveEndTime != 0)
532         {
533             _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(10)/100);
534         }
535         
536         if(now > round_m[_rndNo].endTime)
537         {
538             // finally award
539             if(round_m[_rndNo].leader == _playAddr)
540             {
541                 _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(60)/100);
542             }
543             
544             //finally ten person award
545             for(uint256 i = 0;i < round_m[_rndNo].lastInfective.length; i = i.add(1))
546             {
547                 if(round_m[_rndNo].lastInfective[i] == _playAddr && (round_m[_rndNo].totalInfective.sub(1) % 11) != i)
548                 {
549                     if(round_m[_rndNo].infectLastPlayer != address(0))
550                     {
551                         _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(3)/100);
552                     }
553                     else{
554                         _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(4)/100);
555                     }
556                 }
557             }
558         }
559         
560         
561         return
562         (
563             _ethPlayerAward,
564             _totalWithdraw,
565             playerRound_m[_rndNo][_playAddr].getInveterAmount,
566             playerRound_m[_rndNo][_playAddr].hasGetAwardAmount + playerRound_m[_rndNo][_playAddr].withdraw
567         );
568     }
569     
570     /**
571      * @dev fee withdraw to receiver, everyone can do it.
572      * 0x6561e6ba
573      */
574     function feeWithdraw()
575         onlyHuman()
576         public 
577     {
578         require(isStartGame == true, "The game hasn't started yet.");
579         require(receiver != address(0), "The receiver address has not been initialized.");
580         
581         uint256 _total = (totalEth.mul(5) / (100));
582         uint256 _withdrawed = ownerWithdraw;
583         require(_total > _withdrawed, "No need to withdraw");
584         ownerWithdraw = _total;
585         receiver.transfer(_total.sub(_withdrawed));
586     }
587     
588     /**
589      * @dev start game
590      * 0xd65ab5f2
591      */
592     function startGame()
593         onlyOwner()
594         public
595     {
596         require(isStartGame == false, "The game has already started!");
597         
598         round_m[1].startTime = now;
599         round_m[1].endTime = now + rndInfectiveStage_;
600         round_m[1].lastRoundReward = 0;
601         isStartGame = true;
602     }
603 
604     /**
605      * @dev change owner.
606      * 0x547e3f06000000000000000000000000695c7a3c1a27de4bb32cd812a8c2677e25f0b9d5
607      */
608     function changeReceiver(address newReceiver)
609         onlyOwner()
610         public
611     {
612         receiver = newReceiver;
613     }
614 
615     /**
616      * @dev returns all current round info needed for front end
617      * 0x747dff42
618      */
619     function getCurrentRoundInfo()
620         public 
621         view 
622         returns(uint256, uint256[2], uint256[3], address[2], uint256[6], address[11], address[4])
623     {
624         uint256 _rndNo = rndNo;
625         uint256 _totalAwardAtRound = round_m[_rndNo].lastRoundReward.add(round_m[_rndNo].exAward).add(round_m[_rndNo].eth.mul(30) / 100);
626         
627         return (
628             _rndNo,
629             [round_m[_rndNo].eth, round_m[_rndNo].keys],
630             [round_m[_rndNo].startTime, round_m[_rndNo].endTime, round_m[_rndNo].infectiveEndTime],
631             [round_m[_rndNo].leader, round_m[_rndNo].infectLastPlayer],
632             [getBuyPrice(), round_m[_rndNo].lastRoundReward, _totalAwardAtRound, round_m[_rndNo].inveterAmount, round_m[_rndNo].totalInfective % 11, round_m[_rndNo].exAward],
633             round_m[_rndNo].lastInfective,
634             round_m[_rndNo].loseInfective
635         );
636     }
637 
638     /**
639      * @dev return the price buyer will pay for next 1 individual key during first stage.
640      * 0x018a25e8
641      * @return price for next key bought (in wei format)
642      */
643     function getBuyPrice()
644         public 
645         view 
646         returns(uint256)
647     {
648         uint256 _rndNo = rndNo;
649         uint256 _now = now;
650         
651         // start next round?
652         if (_now > round_m[_rndNo].endTime)
653         {
654             return (750007031250000);
655         }
656         if (round_m[_rndNo].keys < allKeys_)
657         {
658             return ((round_m[_rndNo].keys.add(10000000000000000000)).ethRec(10000000000000000000));
659         }
660         if(round_m[_rndNo].keys >= allKeys_ && 
661             round_m[_rndNo].infectiveEndTime != 0 && 
662             round_m[_rndNo].infectLastPlayer != address(0) &&
663             _now < round_m[_rndNo].infectiveEndTime)
664         {
665             return 5 * 10 ** 16;
666         }
667         if(round_m[_rndNo].keys >= allKeys_ && _now > round_m[_rndNo].infectiveEndTime)
668         {
669             // increase 0.05 Ether every 3 hours
670             uint256 currentPrice = (((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(5 * 10 ** 16)).add((5 * 10 ** 16));
671             return currentPrice;
672         }
673         //second stage
674         return (0);
675     }
676     
677 }
678 
679 library KeysCalc {
680     using SafeMath for *;
681     /**
682      * @dev calculates number of keys received given X eth 
683      * @param _curEth current amount of eth in contract 
684      * @param _newEth eth being spent
685      * @return amount of ticket purchased
686      */
687     function keysRec(uint256 _curEth, uint256 _newEth)
688         internal
689         pure
690         returns (uint256)
691     {
692         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
693     }
694     
695     /**
696      * @dev calculates amount of eth received if you sold X keys 
697      * @param _curKeys current amount of keys that exist 
698      * @param _sellKeys amount of keys you wish to sell
699      * @return amount of eth received
700      */
701     function ethRec(uint256 _curKeys, uint256 _sellKeys)
702         internal
703         pure
704         returns (uint256)
705     {
706         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
707     }
708 
709     /**
710      * @dev calculates how many keys would exist with given an amount of eth
711      * @param _eth eth "in contract"
712      * @return number of keys that would exist
713      */
714     function keys(uint256 _eth) 
715         internal
716         pure
717         returns(uint256)
718     {
719         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
720     }
721     
722     /**
723      * @dev calculates how much eth would be in contract given a number of keys
724      * @param _keys number of keys "in contract" 
725      * @return eth that would exists
726      */
727     function eth(uint256 _keys) 
728         internal
729         pure
730         returns(uint256)  
731     {
732         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
733     }
734 }