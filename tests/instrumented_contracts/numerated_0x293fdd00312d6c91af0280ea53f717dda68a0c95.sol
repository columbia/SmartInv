1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) 
9         internal 
10         pure 
11         returns (uint256 c) 
12     {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b, "SafeMath mul failed");
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b)
22         internal
23         pure
24         returns (uint256) 
25     {
26         require(b <= a, "SafeMath sub failed");
27         return a - b;
28     }
29     
30     function add(uint256 a, uint256 b)
31         internal
32         pure
33         returns (uint256 c) 
34     {
35         c = a + b;
36         require(c >= a, "SafeMath add failed");
37         return c;
38     }
39     
40     function sqrt(uint256 x)
41         internal
42         pure
43         returns (uint256 y) 
44     {
45         uint256 z = ((add(x,1)) / 2);
46         y = x;
47         while (z < y) 
48         {
49             y = z;
50             z = ((add((x / z),z)) / 2);
51         }
52     }
53     
54     function sq(uint256 x)
55         internal
56         pure
57         returns (uint256)
58     {
59         return (mul(x,x));
60     }
61     
62     function pwr(uint256 x, uint256 y)
63         internal 
64         pure 
65         returns (uint256)
66     {
67         if (x==0)
68             return (0);
69         else if (y==0)
70             return (1);
71         else 
72         {
73             uint256 z = x;
74             for (uint256 i=1; i < y; i++)
75                 z = mul(z,x);
76             return (z);
77         }
78     }
79 }
80 
81 contract PlagueEvents {
82 	
83 	//infective person
84     event onInfectiveStage
85     (
86         address indexed player,
87         uint256 indexed rndNo,
88         uint256 keys,
89         uint256 eth,
90         uint256 timeStamp,
91 		address indexed inveter
92     );
93 
94     // become leader during second stage
95     event onDevelopmentStage
96     (
97         address indexed player,
98         uint256 indexed rndNo,
99         uint256 eth,
100         uint256 timeStamp,
101 		address indexed inveter
102     );
103 
104     // award
105     event onAward
106     (
107         address indexed player,
108         uint256 indexed rndNo,
109         uint256 eth,
110         uint256 timeStamp
111     );
112 }
113 
114 contract Plague is PlagueEvents{
115     using SafeMath for *;
116     using KeysCalc for uint256;
117 
118     struct Round {
119         uint256 eth;                // total eth
120         uint256 keys;               // total keys
121         uint256 startTime;          // end time
122         uint256 endTime;            // end time
123         uint256 infectiveEndTime;   // infective end time
124         address leader;             // leader
125         address infectLastPlayer;   // the player will award 10% eth
126         address [11] lastInfective;  // the lastest 11 infective
127         address [4] loseInfective;  // the lose infective
128         bool [11] infectiveAward_m; //
129         uint256 totalInfective;     // the count of this round
130         uint256 inveterAmount;      // remain inveter amount of this round
131         uint256 lastRoundReward;    // last round remain eth 10% + eth 4% - inveterAmount + last remain award
132         uint256 exAward;            // development award
133     }
134 
135     struct PlayerRound {
136         uint256 eth;        // eth player has added to round
137         uint256 keys;       // keys
138         uint256 withdraw;   // how many eth has been withdraw
139         uint256 getInveterAmount; // inverter amount
140         uint256 hasGetAwardAmount;  // player has get award amount
141     }
142 
143     uint256 public rndNo = 1;                                   // current round number
144     uint256 public totalEth = 0;                                // total eth in all round
145 
146     uint256 constant private rndInfectiveStage_ = 10 minutes;          // round timer at iinfective stage12 hours;
147     uint256 constant private rndInfectiveReadyTime_ = 1 minutes;      // round timer at infective stage ready time
148     uint256 constant private rndDevelopmentStage_ = 3 minutes;       // round timer at development stage 30 minutes; 
149     uint256 constant private rndDevelopmentReadyTime_ = 1 minutes;       // round timer at development stage ready time 1 hours;
150     uint256 constant private allKeys_ = 100 * (10 ** 18);   // all keys count
151     uint256 constant private allEths_ = 7500773437500000; // all eths count
152     uint256 constant private rndIncreaseTime_ = 3 minutes;       // increase time 3 hours
153     uint256 constant private developmentAwardPercent = 1;   // 0.1% reduction every 3 hours
154 
155     mapping (uint256 => Round) public round_m;                  // (rndNo => Round)
156     mapping (uint256 => mapping (address => PlayerRound)) public playerRound_m;   // (rndNo => addr => PlayerRound)
157 
158     address public owner;               // owner address
159     address public receiver = address(0);            // receive eth address
160     uint256 public ownerWithdraw = 0;   // how many eth has been withdraw by owner
161     bool public isStartGame = false;    // start game flag
162 
163     constructor()
164         public
165     {
166         owner = msg.sender;
167     }
168 
169     /**
170      * @dev prevents contracts from interacting
171      */
172     modifier onlyHuman() 
173     {
174         address _addr = msg.sender;
175         uint256 _codeLength;
176         
177         assembly {_codeLength := extcodesize(_addr)}
178         require(_codeLength == 0, "sorry humans only");
179         _;
180     }
181     
182     /**
183      * @dev sets boundaries for incoming tx 
184      */
185     modifier isWithinLimits(uint256 _eth) 
186     {
187         require(_eth >= 1000000000, "pocket lint: not a valid currency");
188         require(_eth <= 100000000000000000000000, "no vitalik, no");
189         _;    
190     }
191 
192     /**
193      * @dev only owner
194      */
195     modifier onlyOwner() 
196     {
197         require(owner == msg.sender, "only owner can do it");
198         _;    
199     }
200     
201     /**
202      * @dev It must be human beings to call the function.
203      */
204     function isHuman(address _addr) private view returns (bool)
205     {
206         uint256 _codeLength;
207         
208         assembly {_codeLength := extcodesize(_addr)}
209         return _codeLength == 0;
210     }
211    
212    /**
213 	 * @dev player infect a person at current round
214 	 * 
215 	 */
216     function buyKeys(address _inveter) private
217     {
218         uint256 _eth = msg.value;
219         uint256 _now = now;
220         uint256 _rndNo = rndNo;
221         uint256 _ethUse = msg.value;
222 
223         // start next round?
224         if (_now > round_m[_rndNo].endTime)
225         {
226             require(round_m[_rndNo].endTime + rndDevelopmentReadyTime_ < _now, "we should wait some times");
227             
228             uint256 lastAwardEth = (round_m[_rndNo].eth.mul(14) / 100).sub(round_m[_rndNo].inveterAmount);
229             
230             if(round_m[_rndNo].totalInfective < round_m[_rndNo].lastInfective.length.sub(1))
231             {
232                 uint256 nextPlayersAward = round_m[_rndNo].lastInfective.length.sub(1).sub(round_m[_rndNo].totalInfective);
233                 uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
234                 _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
235                 if(round_m[_rndNo].infectLastPlayer != address(0))
236                 {
237                     lastAwardEth = lastAwardEth.add(nextPlayersAward.mul(_totalAward.mul(3)/100));
238                 }
239                 else
240                 {
241                     lastAwardEth = lastAwardEth.add(nextPlayersAward.mul(_totalAward.mul(4)/100));
242                 }
243             }
244             
245             _rndNo = _rndNo.add(1);
246             rndNo = _rndNo;
247             round_m[_rndNo].startTime = _now;
248             round_m[_rndNo].endTime = _now + rndInfectiveStage_;
249             round_m[_rndNo].totalInfective = 0;
250             round_m[_rndNo].lastRoundReward = lastAwardEth;
251         }
252 
253         // infective or second stage
254         if (round_m[_rndNo].keys < allKeys_)
255         {
256             // infection stage
257             uint256 _keys = (round_m[_rndNo].eth).keysRec(_eth);
258             
259             if (_keys.add(round_m[_rndNo].keys) >= allKeys_)
260             {
261                 _keys = allKeys_.sub(round_m[_rndNo].keys);
262 
263                 if (round_m[_rndNo].eth >= allEths_)
264                 {
265                     _ethUse = 0;
266                 } 
267                 else {
268                     _ethUse = (allEths_).sub(round_m[_rndNo].eth);
269                 }
270 
271                 if (_eth > _ethUse)
272                 {
273                     // refund
274                     msg.sender.transfer(_eth.sub(_ethUse));
275                 } 
276                 else {
277                     // fix
278                     _ethUse = _eth;
279                 }
280                 // first stage is over, record current time
281                 round_m[_rndNo].infectiveEndTime = _now.add(rndInfectiveReadyTime_);
282                 round_m[_rndNo].endTime = _now.add(rndDevelopmentStage_).add(rndInfectiveReadyTime_);
283                 round_m[_rndNo].infectLastPlayer = msg.sender;
284             }
285             else
286             {
287                 require (_keys >= 1 * 10 ** 19, "at least 10 thound people");
288                 round_m[_rndNo].endTime = _now + rndInfectiveStage_;
289             }
290             
291             round_m[_rndNo].leader = msg.sender;
292 
293             // update playerRound
294             playerRound_m[_rndNo][msg.sender].keys = _keys.add(playerRound_m[_rndNo][msg.sender].keys);
295             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
296 
297             // update round
298             round_m[_rndNo].keys = _keys.add(round_m[_rndNo].keys);
299             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
300 
301             // update global variable
302             totalEth = _ethUse.add(totalEth);
303 
304             // event
305             emit PlagueEvents.onInfectiveStage
306             (
307                 msg.sender,
308                 _rndNo,
309                 _keys,
310                 _ethUse,
311                 _now,
312 				_inveter
313             );
314         } else {
315             // second stage
316             require(round_m[_rndNo].infectiveEndTime < _now, "The virus is being prepared...");
317             
318             // increase 0.05 Ether every 3 hours
319             _ethUse = (((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(5 * 10 ** 16)).add((5 * 10 ** 16));
320             
321             require(_eth >= _ethUse, "Ether amount is wrong");
322             
323             if(_eth > _ethUse)
324             {
325                 msg.sender.transfer(_eth.sub(_ethUse));
326             }
327 
328             round_m[_rndNo].endTime = _now + rndDevelopmentStage_;
329             round_m[_rndNo].leader = msg.sender;
330 
331             // update playerRound
332             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
333 
334             // update round
335             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
336 
337             // update global variable
338             totalEth = _ethUse.add(totalEth);
339             
340             // update development award
341             uint256 _exAwardPercent = ((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(developmentAwardPercent).add(developmentAwardPercent);
342             if(_exAwardPercent >= 410)
343             {
344                 _exAwardPercent = 410;
345             }
346             round_m[_rndNo].exAward = (_exAwardPercent.mul(_ethUse) / 1000).add(round_m[_rndNo].exAward);
347 
348             // event
349             emit PlagueEvents.onDevelopmentStage
350             (
351                 msg.sender,
352                 _rndNo,
353                 _ethUse,
354                 _now,
355 				_inveter
356             );
357         }
358         
359         // caculate share inveter amount
360         if(_inveter != address(0) && isHuman(_inveter)) 
361         {
362             playerRound_m[_rndNo][_inveter].getInveterAmount = playerRound_m[_rndNo][_inveter].getInveterAmount.add(_ethUse.mul(10) / 100);
363             round_m[_rndNo].inveterAmount = round_m[_rndNo].inveterAmount.add(_ethUse.mul(10) / 100);
364         }
365         
366         round_m[_rndNo].loseInfective[round_m[_rndNo].totalInfective % 4] = round_m[_rndNo].lastInfective[round_m[_rndNo].totalInfective % 11];
367         round_m[_rndNo].lastInfective[round_m[_rndNo].totalInfective % 11] = msg.sender;
368         
369         round_m[_rndNo].totalInfective = round_m[_rndNo].totalInfective.add(1);
370     }
371     
372 	/**
373 	 * @dev recommend a player
374 	 */
375     function buyKeyByAddr(address _inveter)
376         onlyHuman()
377         isWithinLimits(msg.value)
378         public
379         payable
380     {
381         require(isStartGame == true, "The game hasn't started yet.");
382         buyKeys(_inveter);
383     }
384 
385     /**
386      * @dev play
387      */
388     function()
389         onlyHuman()
390         isWithinLimits(msg.value)
391         public
392         payable
393     {
394         require(isStartGame == true, "The game hasn't started yet.");
395         buyKeys(address(0));
396     }
397     
398     /**
399      * @dev Award by rndNo.
400      * 0x80ec35ff
401      * 0x80ec35ff0000000000000000000000000000000000000000000000000000000000000001
402      */
403     function awardByRndNo(uint256 _rndNo)
404         onlyHuman()
405         public
406     {
407         require(isStartGame == true, "The game hasn't started yet.");
408         require(_rndNo <= rndNo, "You're running too fast");
409         
410         uint256 _ethOut = 0;
411         uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
412         _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
413         _totalAward = _totalAward.add(round_m[_rndNo].exAward);
414         uint256 _getAward = 0;
415         
416         //withdraw award
417         uint256 _totalWithdraw = round_m[_rndNo].eth.mul(51) / 100;
418         _totalWithdraw = _totalWithdraw.sub(round_m[_rndNo].exAward);
419         _totalWithdraw = (_totalWithdraw.mul(playerRound_m[_rndNo][msg.sender].keys));
420         _totalWithdraw = _totalWithdraw / round_m[_rndNo].keys;
421         
422         uint256 _inveterAmount = playerRound_m[_rndNo][msg.sender].getInveterAmount;
423         _totalWithdraw = _totalWithdraw.add(_inveterAmount);
424         uint256 _withdrawed = playerRound_m[_rndNo][msg.sender].withdraw;
425         if(_totalWithdraw > _withdrawed)
426         {
427             _ethOut = _ethOut.add(_totalWithdraw.sub(_withdrawed));
428             playerRound_m[_rndNo][msg.sender].withdraw = _totalWithdraw;
429         }
430         
431          //lastest infect player
432         if(msg.sender == round_m[_rndNo].infectLastPlayer && round_m[_rndNo].infectLastPlayer != address(0) && round_m[_rndNo].infectiveEndTime != 0)
433         {
434             _getAward = _getAward.add(_totalAward.mul(10)/100);
435         }
436         
437         if(now > round_m[_rndNo].endTime)
438         {
439             // finally award
440             if(round_m[_rndNo].leader == msg.sender)
441             {
442                 _getAward = _getAward.add(_totalAward.mul(60)/100);
443             }
444             
445             //finally ten person award
446             for(uint256 i = 0;i < round_m[_rndNo].lastInfective.length; i = i.add(1))
447             {
448                 if(round_m[_rndNo].lastInfective[i] == msg.sender && (round_m[_rndNo].totalInfective.sub(1) % 11) != i){
449                     if(round_m[_rndNo].infectiveAward_m[i])
450                         continue;
451                     if(round_m[_rndNo].infectLastPlayer != address(0))
452                     {
453                         _getAward = _getAward.add(_totalAward.mul(3)/100);
454                     }
455                     else{
456                         _getAward = _getAward.add(_totalAward.mul(4)/100);
457                     }
458                         
459                     round_m[_rndNo].infectiveAward_m[i] = true;
460                 }
461             }
462         }
463         _ethOut = _ethOut.add(_getAward.sub(playerRound_m[_rndNo][msg.sender].hasGetAwardAmount));
464         playerRound_m[_rndNo][msg.sender].hasGetAwardAmount = _getAward;
465         
466         if(_ethOut != 0)
467         {
468             msg.sender.transfer(_ethOut); 
469         }
470         
471         // event
472         emit PlagueEvents.onAward
473         (
474             msg.sender,
475             _rndNo,
476             _ethOut,
477             now
478         );
479     }
480     
481     /**
482      * @dev Get player bonus data
483      * 0xd982466d
484      * 0xd982466d0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000028f211f6c07d3b79e0aab886d56333e4027d4f59
485      * @return player's award
486      * @return player's can withdraw amount
487      * @return player's inveter amount
488      * @return player's has been withdraw
489      */
490     function getPlayerAwardByRndNo(uint256 _rndNo, address _playAddr)
491         view
492         public
493         returns (uint256, uint256, uint256, uint256)
494     {
495         require(isStartGame == true, "The game hasn't started yet.");
496         require(_rndNo <= rndNo, "You're running too fast");
497         
498         uint256 _ethPlayerAward = 0;
499         
500         //withdraw award
501         uint256 _totalWithdraw = round_m[_rndNo].eth.mul(51) / 100;
502         _totalWithdraw = _totalWithdraw.sub(round_m[_rndNo].exAward);
503         _totalWithdraw = (_totalWithdraw.mul(playerRound_m[_rndNo][_playAddr].keys));
504         _totalWithdraw = _totalWithdraw / round_m[_rndNo].keys;
505         
506         uint256 _totalAward = round_m[_rndNo].eth.mul(30) / 100;
507         _totalAward = _totalAward.add(round_m[_rndNo].lastRoundReward);
508         _totalAward = _totalAward.add(round_m[_rndNo].exAward);
509         
510         //lastest infect player
511         if(_playAddr == round_m[_rndNo].infectLastPlayer && round_m[_rndNo].infectLastPlayer != address(0) && round_m[_rndNo].infectiveEndTime != 0)
512         {
513             _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(10)/100);
514         }
515         
516         if(now > round_m[_rndNo].endTime)
517         {
518             // finally award
519             if(round_m[_rndNo].leader == _playAddr)
520             {
521                 _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(60)/100);
522             }
523             
524             //finally ten person award
525             for(uint256 i = 0;i < round_m[_rndNo].lastInfective.length; i = i.add(1))
526             {
527                 if(round_m[_rndNo].lastInfective[i] == _playAddr && (round_m[_rndNo].totalInfective.sub(1) % 11) != i)
528                 {
529                     if(round_m[_rndNo].infectLastPlayer != address(0))
530                     {
531                         _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(3)/100);
532                     }
533                     else{
534                         _ethPlayerAward = _ethPlayerAward.add(_totalAward.mul(4)/100);
535                     }
536                 }
537             }
538         }
539         
540         
541         return
542         (
543             _ethPlayerAward,
544             _totalWithdraw,
545             playerRound_m[_rndNo][_playAddr].getInveterAmount,
546             playerRound_m[_rndNo][_playAddr].hasGetAwardAmount + playerRound_m[_rndNo][_playAddr].withdraw
547         );
548     }
549     
550     /**
551      * @dev fee withdraw to receiver, everyone can do it.
552      * 0x6561e6ba
553      */
554     function feeWithdraw()
555         onlyHuman()
556         public 
557     {
558         require(isStartGame == true, "The game hasn't started yet.");
559         require(receiver != address(0), "The receiver address has not been initialized.");
560         
561         uint256 _total = (totalEth.mul(5) / (100));
562         uint256 _withdrawed = ownerWithdraw;
563         require(_total > _withdrawed, "No need to withdraw");
564         ownerWithdraw = _total;
565         receiver.transfer(_total.sub(_withdrawed));
566     }
567     
568     /**
569      * @dev start game
570      */
571     function startGame()
572         onlyOwner()
573         public
574     {
575         round_m[1].startTime = now;
576         round_m[1].endTime = now + rndInfectiveStage_;
577         round_m[1].lastRoundReward = 0;
578         isStartGame = true;
579     }
580 
581     /**
582      * @dev change owner.
583      */
584     function changeReceiver(address newReceiver)
585         onlyOwner()
586         public
587     {
588         receiver = newReceiver;
589     }
590 
591     /**
592      * @dev returns all current round info needed for front end
593      * 0x747dff42
594      */
595     function getCurrentRoundInfo()
596         public 
597         view 
598         returns(uint256, uint256[2], uint256[3], address[2], uint256[6], address[11],address[4])
599     {
600         require(isStartGame == true, "The game hasn't started yet.");
601         uint256 _rndNo = rndNo;
602         uint256 _totalAwardAtRound = round_m[_rndNo].lastRoundReward.add(round_m[_rndNo].exAward).add(round_m[_rndNo].eth.mul(30) / 100);
603         
604         return (
605             _rndNo,
606             [round_m[_rndNo].eth, round_m[_rndNo].keys],
607             [round_m[_rndNo].startTime, round_m[_rndNo].endTime, round_m[_rndNo].infectiveEndTime],
608             [round_m[_rndNo].leader, round_m[_rndNo].infectLastPlayer],
609             [getBuyPrice(), round_m[_rndNo].lastRoundReward, _totalAwardAtRound, round_m[_rndNo].inveterAmount, round_m[_rndNo].totalInfective % 11, round_m[_rndNo].exAward],
610             round_m[_rndNo].lastInfective,
611             round_m[_rndNo].loseInfective
612         );
613     }
614 
615     /**
616      * @dev return the price buyer will pay for next 1 individual key during first stage.
617      * 0x018a25e8
618      * @return price for next key bought (in wei format)
619      */
620     function getBuyPrice()
621         public 
622         view 
623         returns(uint256)
624     {
625         require(isStartGame == true, "The game hasn't started yet.");
626         uint256 _rndNo = rndNo;
627         uint256 _now = now;
628         
629         // start next round?
630         if (_now > round_m[_rndNo].endTime)
631         {
632             return (750007031250000);
633         }
634         if (round_m[_rndNo].keys < allKeys_)
635         {
636             return ((round_m[_rndNo].keys.add(10000000000000000000)).ethRec(10000000000000000000));
637         }
638         if(round_m[_rndNo].keys >= allKeys_ && 
639             round_m[_rndNo].infectiveEndTime != 0 && 
640             round_m[_rndNo].infectLastPlayer != address(0) &&
641             _now < round_m[_rndNo].infectiveEndTime)
642         {
643             return 5 * 10 ** 16;
644         }
645         if(round_m[_rndNo].keys >= allKeys_ && _now > round_m[_rndNo].infectiveEndTime)
646         {
647             // increase 0.05 Ether every 3 hours
648             uint256 currentPrice = (((_now.sub(round_m[_rndNo].infectiveEndTime)) / rndIncreaseTime_).mul(5 * 10 ** 16)).add((5 * 10 ** 16));
649             return currentPrice;
650         }
651         //second stage
652         return (0);
653     }
654 }
655 
656 library KeysCalc {
657     using SafeMath for *;
658     /**
659      * @dev calculates number of keys received given X eth 
660      * @param _curEth current amount of eth in contract 
661      * @param _newEth eth being spent
662      * @return amount of ticket purchased
663      */
664     function keysRec(uint256 _curEth, uint256 _newEth)
665         internal
666         pure
667         returns (uint256)
668     {
669         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
670     }
671     
672     /**
673      * @dev calculates amount of eth received if you sold X keys 
674      * @param _curKeys current amount of keys that exist 
675      * @param _sellKeys amount of keys you wish to sell
676      * @return amount of eth received
677      */
678     function ethRec(uint256 _curKeys, uint256 _sellKeys)
679         internal
680         pure
681         returns (uint256)
682     {
683         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
684     }
685 
686     /**
687      * @dev calculates how many keys would exist with given an amount of eth
688      * @param _eth eth "in contract"
689      * @return number of keys that would exist
690      */
691     function keys(uint256 _eth) 
692         internal
693         pure
694         returns(uint256)
695     {
696         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
697     }
698     
699     /**
700      * @dev calculates how much eth would be in contract given a number of keys
701      * @param _keys number of keys "in contract" 
702      * @return eth that would exists
703      */
704     function eth(uint256 _keys) 
705         internal
706         pure
707         returns(uint256)  
708     {
709         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
710     }
711 }