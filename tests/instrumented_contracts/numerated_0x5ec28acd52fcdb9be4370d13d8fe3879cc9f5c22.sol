1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath v0.1.9
5  * @dev Math operations with safety checks that throw on error
6  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
7  * - added sqrt
8  * - added sq
9  * - added pwr 
10  * - changed asserts to requires with error log outputs
11  * - removed div, its useless
12  */
13 library SafeMath {
14     
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) 
19         internal 
20         pure 
21         returns (uint256 c) 
22     {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         require(c / a == b, "SafeMath mul failed");
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40     
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b)
45         internal
46         pure
47         returns (uint256) 
48     {
49         require(b <= a, "SafeMath sub failed");
50         return a - b;
51     }
52 
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     function add(uint256 a, uint256 b)
57         internal
58         pure
59         returns (uint256 c) 
60     {
61         c = a + b;
62         require(c >= a, "SafeMath add failed");
63         return c;
64     }
65     
66     /**
67      * @dev gives square root of given x.
68      */
69     function sqrt(uint256 x)
70         internal
71         pure
72         returns (uint256 y) 
73     {
74         uint256 z = ((add(x,1)) / 2);
75         y = x;
76         while (z < y) 
77         {
78             y = z;
79             z = ((add((x / z),z)) / 2);
80         }
81     }
82     
83     /**
84      * @dev gives square. multiplies x by x
85      */
86     function sq(uint256 x)
87         internal
88         pure
89         returns (uint256)
90     {
91         return (mul(x,x));
92     }
93     
94     /**
95      * @dev x to the power of y 
96      */
97     function pwr(uint256 x, uint256 y)
98         internal 
99         pure 
100         returns (uint256)
101     {
102         if (x==0)
103             return (0);
104         else if (y==0)
105             return (1);
106         else 
107         {
108             uint256 z = x;
109             for (uint256 i=1; i < y; i++)
110                 z = mul(z,x);
111             return (z);
112         }
113     }
114 }
115 
116 contract Draw {
117     using SafeMath for *;
118 
119     event JoinRet(bool ret, uint256 inviteCode, address addr);
120     event InviteEvent(address origin, address player);
121     event Result(uint256 roundId, uint256 ts, uint256 amount, address winnerPid, uint256 winnerValue, address mostInvitePid, 
122     uint256 mostInviteValue, address laffPid, uint256 laffValue);
123     event RoundStop(uint256 roundId);
124 
125     struct Player {
126         address addr;   // player address
127         uint256 vault;    // vault
128         uint256 totalVault;
129         uint256 laff;   // affiliate pid 
130         uint256 joinTime; //join time 
131         uint256 drawCount; // draw timtes
132         uint256 remainInviteCount; 
133         uint256 inviteDraw;  // invite draw Count
134         bool selfDraw; // self draw
135         uint256 inviteCode; 
136         uint256 inviteCount; // invite count
137         uint256 newInviteCount; // new round invite count 
138         uint256 inviteTs; // last invite time 
139         //uint256 totalDrawCount; 
140     }
141     
142     mapping (address => uint256) public pIDxAddr_; //玩家地址-ID映射
143     mapping (uint256 => uint256) public pIDxCount_; //玩家ID-抽奖次数映射
144 
145     uint256 public totalPot_ = 0;
146     uint256 public beginTime_ = 0;
147     uint256 public endTime_ = 0;
148     uint256 public pIdIter_ = 0;  //pid自增器
149     uint256 public fund_  = 0;  //总奖池基金
150 
151     // draw times
152     uint64 public times_ = 0;   
153     uint256 public drawNum_ = 0; //抽奖人次
154 
155     mapping (uint256 => uint256) pInvitexID_;  //(inviteID => ID) 
156     
157     mapping (bytes32 => address) pNamexAddr_;  //(name => addr) 
158     mapping (uint256 => Player) public plyr_;  
159     
160     mapping (address => uint256) pAddrxFund_;  
161 
162     uint256[3] public winners_;  //抽奖一二三等奖的玩家ID
163 
164     uint256 public dayLimit_; //每日限额
165 
166     uint256[] public joinPlys_;
167 
168     uint256 public inviteIter_; //邀请计数
169 
170     uint256 public roundId_ = 0; 
171 
172     //uint256 public constant gapTime_ = 24 hours;
173     uint256 public constant gapTime_ = 24 hours;
174 
175     address private owner_;
176     
177     constructor () public {
178         beginTime_ = now;
179         endTime_ = beginTime_ + gapTime_;
180         roundId_ = 1;
181         owner_ = msg.sender;
182     }
183 
184     /**
185      * @dev prevents contracts from interacting with fomo3d 
186      */
187     modifier isHuman() {
188         address _addr = msg.sender;
189         uint256 _codeLength;
190         
191         assembly {_codeLength := extcodesize(_addr)}
192         require(_codeLength == 0, "sorry humans only");
193         _;
194     }
195 
196     uint256 public newMostInviter_ = 0;
197     uint256 public newMostInviteTimes_ = 0;
198     function determineNewRoundMostInviter (uint256 pid, uint256 times) 
199         private
200     {
201         if (times > newMostInviteTimes_) {
202             newMostInviter_ = pid;
203             newMostInviteTimes_ = times;
204         }
205     }
206 
207     function joinDraw(uint256 _affCode) 
208         public
209         isHuman() 
210     {
211         uint256 _pID = determinePID();
212         Player storage player = plyr_[_pID];
213 
214          //邀请一个新玩家，抽奖次数加1
215         if (_affCode != 0 && _affCode != plyr_[_pID].inviteCode && player.joinTime == 0) {
216             uint256 _affPID = pInvitexID_[_affCode];
217             if (_affPID != 0) {
218                 Player storage laffPlayer = plyr_[_affPID];
219                 laffPlayer.inviteCount = laffPlayer.inviteCount + 1;
220                 laffPlayer.remainInviteCount = laffPlayer.remainInviteCount + 1;
221 
222                 if (laffPlayer.inviteTs < beginTime_) {
223                     laffPlayer.newInviteCount = 0;
224                 }
225                 laffPlayer.newInviteCount += 1;
226                 laffPlayer.inviteTs = now;
227                 player.laff = _affCode;
228                 determineNewRoundMostInviter(_affPID, laffPlayer.newInviteCount);
229 
230                 emit InviteEvent(laffPlayer.addr, player.addr);
231             }
232         }
233 
234         if (player.joinTime <= beginTime_) {
235             player.drawCount = 0;
236             player.selfDraw = false;
237         } 
238 
239         bool joinRet = false;
240         if (player.drawCount < 5) {
241             //if (player.selfDraw == true && player.remainInviteCount == 0) {
242             require((player.selfDraw == false || player.remainInviteCount > 0), "have no chance times");
243             //}
244 
245             uint256 remainCount = 5 - player.drawCount;
246             //if (remainCount <= 0) {
247             require(remainCount > 0, "have no chance times 2");
248             //;}
249 
250             uint256 times = 0;
251             if (player.selfDraw == true) {
252                 if (player.remainInviteCount >= remainCount) {
253                     player.remainInviteCount = player.remainInviteCount - remainCount;
254                     times = remainCount;
255                     player.inviteDraw = player.inviteDraw + remainCount;
256                 } else {
257                     times = player.remainInviteCount;
258                     player.remainInviteCount = 0;
259                     player.inviteDraw = player.inviteDraw + player.remainInviteCount;
260                 }
261             } else {
262                 if (player.remainInviteCount + 1 >= remainCount) {
263                     player.remainInviteCount = player.remainInviteCount - remainCount + 1;
264                     times = remainCount;
265                     player.selfDraw = true;
266                     player.inviteDraw = player.inviteDraw + remainCount - 1;
267                 } else {
268                     times = 1 + player.remainInviteCount;
269                     player.remainInviteCount = 0;
270                     player.selfDraw = true;
271                     player.inviteDraw = player.inviteDraw + player.remainInviteCount;
272                 }
273             }
274 
275             joinRet = true;
276             player.joinTime = now;
277 
278             player.drawCount += times;
279             times = times > 5 ? 5 : times;
280             while(times > 0) {
281                 joinPlys_.push(_pID);
282                 times--;
283             } 
284             emit JoinRet(true, player.inviteCode, player.addr);
285         } else {
286             emit JoinRet(false, player.inviteCode, player.addr);
287         }
288         //require (joinRet == true, "joinDraw not success");
289     }
290 
291     function roundEnd() private {
292         emit RoundStop(roundId_);
293     }
294 
295     function charge()
296         public
297         isHuman() 
298         payable
299     {
300         uint256 _eth = msg.value;
301         fund_ = fund_.add(_eth);
302     }
303 
304     function setParam(uint256 dayLimit) public {
305         //admin
306         require (
307             msg.sender == 0xf8636155ab3bda8035b02fc92b334f3758b5e1f3 ||
308             msg.sender == 0x0421b755b2c7813df34f8d9b81065f81b5a28d80 || 
309             msg.sender == 0xf6eac1c72616c4fd2d389a8836af4c3345d79d92,
310             "only amdin can do this"
311         );
312 
313         dayLimit_ = dayLimit;
314     }
315 
316     modifier havePlay() {
317         require (joinPlys_.length > 0, "must have at least 1 player");
318         _;
319     } 
320 
321     function random() 
322         private
323         havePlay()
324         view
325         returns(uint256)
326     {
327         uint256 _seed = uint256(keccak256(abi.encodePacked(
328             (block.timestamp).add
329             (block.difficulty).add
330             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
331             (block.gaslimit).add
332             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
333             (block.number)
334             
335         )));
336 
337         require(joinPlys_.length != 0, "no one join draw");
338 
339         uint256 _rand = _seed % joinPlys_.length;
340         return _rand;
341     }
342 
343     function joinCount() 
344         public 
345         view 
346         returns (uint256)
347     {
348         return joinPlys_.length;
349     }
350 
351     modifier haveFund() {
352         require (fund_ > 0, "fund must more than 0");
353         _;
354     }
355     
356     //开奖
357     function onDraw() 
358         public
359         haveFund() 
360     {
361         //admin
362         require (
363             msg.sender == 0xf8636155ab3bda8035b02fc92b334f3758b5e1f3 ||
364             msg.sender == 0x0421b755b2c7813df34f8d9b81065f81b5a28d80 || 
365             msg.sender == 0xf6eac1c72616c4fd2d389a8836af4c3345d79d92,
366             "only amdin can do this"
367         );
368 
369         require(joinPlys_.length > 0, "no one join draw");
370         require (fund_ > 0, "fund must more than zero");
371 
372         if (dayLimit_ == 0) {
373             dayLimit_ = 0.1 ether;
374         }
375         
376         winners_[0] = 0;
377         winners_[1] = 0;
378         winners_[2] = 0;
379 
380         uint256 _rand = random();
381         uint256 _winner =  joinPlys_[_rand];
382 
383         winners_[0] = _winner;
384         winners_[1] = newMostInviter_;
385         winners_[2] = plyr_[_winner].laff;
386 
387         uint256 _tempValue = 0;
388         uint256 _winnerValue = 0;
389         uint256 _mostInviteValue = 0;
390         uint256 _laffValue = 0;
391         uint256 _amount = 0;
392         address _winAddr;
393         address _mostAddr;
394         address _laffAddr;
395         //if (true) {
396         if (fund_ >= dayLimit_) {
397             _amount = dayLimit_;
398             fund_ = fund_.sub(dayLimit_);
399             _winnerValue = dayLimit_.mul(7).div(10);
400             _mostInviteValue = dayLimit_.mul(2).div(10);
401             _laffValue = dayLimit_.div(10);
402             plyr_[winners_[0]].vault = plyr_[winners_[0]].vault.add(_winnerValue);
403             plyr_[winners_[0]].totalVault = plyr_[winners_[0]].totalVault.add(_winnerValue);
404             _winAddr = plyr_[winners_[0]].addr;
405             if (winners_[1] == 0) {
406                 _mostInviteValue = 0;
407             } else {
408                 _mostAddr = plyr_[winners_[1]].addr;
409                 plyr_[winners_[1]].vault = plyr_[winners_[1]].vault.add(_mostInviteValue);
410                 plyr_[winners_[1]].totalVault = plyr_[winners_[1]].totalVault.add(_mostInviteValue);
411             }
412             if (winners_[2] == 0) { 
413                 _laffValue = 0;
414             } else {
415                 _laffAddr = plyr_[winners_[2]].addr;
416                 plyr_[winners_[2]].vault = plyr_[winners_[2]].vault.add(_laffValue);
417                 plyr_[winners_[2]].totalVault = plyr_[winners_[2]].totalVault.add(_laffValue);
418             
419             }
420         } else {
421             _amount = fund_;
422             _tempValue = fund_;
423             fund_ = 0;
424             _winnerValue = _tempValue.mul(7).div(10);
425             _mostInviteValue = _tempValue.mul(2).div(10);
426             _laffValue = _tempValue.div(10);
427             plyr_[winners_[0]].vault = plyr_[winners_[0]].vault.add(_winnerValue);
428             plyr_[winners_[0]].totalVault = plyr_[winners_[0]].totalVault.add(_winnerValue);
429             _winAddr = plyr_[winners_[0]].addr;
430             if (winners_[1] == 0) {
431                 _mostInviteValue = 0;
432             } else {
433                 _mostAddr = plyr_[winners_[1]].addr;
434                 plyr_[winners_[1]].vault = plyr_[winners_[1]].vault.add(_mostInviteValue);
435                 plyr_[winners_[1]].totalVault = plyr_[winners_[1]].totalVault.add(_mostInviteValue);
436            
437             }
438             if (winners_[2] == 0) {
439                 _laffValue = 0;
440             } else {
441                 plyr_[winners_[2]].vault = plyr_[winners_[2]].vault.add(_laffValue);
442                 plyr_[winners_[2]].totalVault = plyr_[winners_[2]].totalVault.add(_laffValue);
443                 _laffAddr = plyr_[winners_[2]].addr;
444             }
445         }
446 
447         emit Result(roundId_, endTime_, _amount, _winAddr, _winnerValue, _mostAddr, _mostInviteValue, _laffAddr, _laffValue);
448 
449         nextRound();
450     }
451 
452     function nextRound() 
453         private 
454     {
455         beginTime_ = now;
456         endTime_ = now + gapTime_;
457 
458         delete joinPlys_;
459         
460         newMostInviteTimes_ = 0;
461         newMostInviter_ = 0;
462 
463         roundId_++;
464         beginTime_ = now;
465         endTime_ = beginTime_ + gapTime_;
466     }
467 
468     function withDraw()
469         public 
470         isHuman()
471         returns(bool) 
472     {
473         uint256 _now = now;
474         uint256 _pID = determinePID();
475         
476         if (_pID == 0) {
477             return;
478         }
479         
480         if (endTime_ > _now && fund_ > 0) {
481             roundEnd();
482         }
483 
484         if (plyr_[_pID].vault != 0) {
485             uint256 vault = plyr_[_pID].vault;
486             plyr_[_pID].vault = 0;
487             msg.sender.transfer(vault);
488         }
489 
490         return true;
491     }
492 
493     function getRemainCount(address addr) 
494         public
495         view
496         returns(uint256)  
497     {
498         uint256 pID = pIDxAddr_[addr];
499         if (pID == 0) {
500             return 1;
501         }
502         
503         uint256 remainCount = 0;
504 
505         if (plyr_[pID].joinTime <= beginTime_) {
506             remainCount = plyr_[pID].remainInviteCount < 4 ? plyr_[pID].remainInviteCount + 1 : 5;
507         } else {
508             if (plyr_[pID].remainInviteCount == 0) {
509                 remainCount = (plyr_[pID].drawCount == 0 ? 1 : 0);
510             } else {
511                 if (plyr_[pID].drawCount >= 5) {
512                     remainCount = 0;
513                 } else {
514                     uint256 temp = (5 - plyr_[pID].drawCount);
515                     remainCount = (plyr_[pID].remainInviteCount > temp ? temp :  plyr_[pID].remainInviteCount);
516                 }
517             }  
518         } 
519 
520         return remainCount;
521     }
522 
523      /**
524      * @dev gets existing or registers new pID.  use this when a player may be new
525      * @return pID 
526      */
527     function determinePID()
528         private
529         returns(uint256)
530     {
531         uint256 _pID = pIDxAddr_[msg.sender];
532 
533         if (_pID == 0) {
534             pIdIter_ = pIdIter_ + 1;
535             _pID = pIdIter_;
536             pIDxAddr_[msg.sender] = _pID;
537             plyr_[_pID].addr = msg.sender;
538             inviteIter_ = inviteIter_.add(1);
539             plyr_[_pID].inviteCode = inviteIter_;
540             pInvitexID_[inviteIter_] = _pID;
541         }
542 
543         return _pID;
544     }
545 }