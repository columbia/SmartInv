1 pragma solidity ^0.4.24;
2 
3 contract OneEther {
4 
5     event onOpenNewBet(
6         uint256 indexed bID,
7         address owner,
8         uint256 check,
9         uint256 unit,
10         uint256 recordTime
11     );
12     event onEditBet(
13         uint256 indexed bID,
14         address owner,
15         uint256 check,
16         uint256 unit,
17         uint256 recordTime
18     );
19     event onOpenNewRound(
20         uint256 indexed bID,
21         uint256 indexed rID,
22         uint256 total,
23         uint256 current,
24         uint256 ethAmount,
25         uint256 recordTime
26     );
27     event RoundMask(
28         uint256 rID,
29         bytes32 hashmask
30     );
31     event onReveal(
32         uint256 indexed rID,
33         address winner,
34         uint256 reward,
35         uint256 teamFee,
36         uint256 scretNumber,
37         uint256 randomNumber,
38         uint256 recordTime
39     );
40     event onBuyBet(
41         uint256 indexed bID,
42         uint256 indexed rID,
43         address playerAddress,
44         uint256 amount,
45         uint256 key,
46         uint256 playerCode,
47         uint256 invator,
48         uint256 recordTime
49     );
50 
51     event onRoundUpdate(
52         uint256 indexed bID,
53         uint256 indexed rID,
54         uint256 totalKey,
55         uint256 currentKey,
56         uint256 lastUpdate
57     );
58     event onRoundEnd(
59         uint256 indexed bID,
60         uint256 indexed rID,
61         uint256 lastUpdate
62     );
63     event onWithdraw
64     (
65         uint256 indexed playerID,
66         address indexed playerAddress,
67         uint256 ethOut,
68         uint256 recordTime
69     );
70     event onRegistLink
71     (
72         uint256 indexed playerID,
73         address indexed playerAddress,
74         uint256 recordTime
75     );
76     event onBuyFailed
77     (
78         uint256 indexed playerID,
79         uint256 indexed rID,
80         uint256 ethIn,
81         uint256 recordTime
82     );
83     using SafeMath for *;
84 
85     address private owner = msg.sender;
86     address private admin = msg.sender;
87     bytes32 constant public name = "OneEther";
88     bytes32 constant public symbol = "OneEther";
89     uint256 constant  MIN_BUY = 0.001 ether;
90     uint256 constant  MAX_BUY = 30000 ether;
91     uint256 public linkPrice_ = 0.01 ether;
92     bool public activated_ = false;
93     uint256 private teamFee_ = 0; //team Fee Pot
94 
95     uint256 public bID = 10;
96     uint256 public pID = 100;
97     uint256 public rID = 1000;
98 
99     mapping (address => uint256) public pIDAddr_;//(addr => pID) returns player id by address
100     mapping(uint256 => OneEtherDatasets.BetInfo) public bIDBet_;
101     mapping(uint256 => OneEtherDatasets.stake[]) public betList_;
102     mapping(uint256 => OneEtherDatasets.BetState) public rIDBet_;
103     mapping(uint256 => OneEtherDatasets.Player) public pIDPlayer_;
104     mapping (uint256 => uint256) public bIDrID_;
105     uint256[] public bIDList_;
106 
107 //===============================================================
108 //   construct
109 //==============================================================
110     constructor()payable public{
111     }
112 //===============================================================
113 //   The following are safety checks
114 //==============================================================
115     //isActivated
116     modifier isbetActivated(uint256 _bID){require(bIDBet_[_bID].bID != 0 && bIDBet_[_bID].isActivated == true,"cant find this bet");_;}
117     modifier isActivated() {require(activated_ == true,"its not ready yet. ");_;}
118     //isAdmin
119     modifier isAdmin(){require(msg.sender == admin,"its can only be call by admin");_;}
120     //limits
121     modifier isWithinLimits(uint256 _eth){require(_eth >= MIN_BUY,"too small");require(_eth <= MAX_BUY,"too big"); _;}
122     //activate game
123     function activate()isAdmin()public{require(activated_ == false,"the game is running");activated_ = true;}
124     //close game  dangerous!
125     function close() isAdmin() isActivated() public{activated_ = false;}
126 
127 //===============================================================
128 //   Functions call by admin
129 //==============================================================
130 
131     //set new admin
132     function setNewAdmin(address _addr)
133     public
134     {
135         require(msg.sender == owner);
136         admin = _addr;
137     }
138 
139     function openNewBet(address _owner,uint256 _check,uint256 _unit)
140     isAdmin()
141     isActivated()
142     public
143     {
144         require((_check >= MIN_BUY) && (_check <= MAX_BUY),"out of range");
145         require((_unit * 2) <= _check,"unit of payment dennied");
146         bID++;
147         bIDBet_[bID].bID = bID;
148         uint256 _now = now;
149         if(_owner == address(0))
150         {
151             bIDBet_[bID].owner = admin;
152         }
153         else
154         {
155             bIDBet_[bID].owner = _owner;
156         }
157         bIDBet_[bID].check = _check;
158         bIDBet_[bID].unit = _unit;
159         bIDBet_[bID].isActivated = true;
160         bIDList_.push(bID);
161         //emit
162         emit onOpenNewBet(bID,bIDBet_[bID].owner,_check,_unit,_now);
163     }
164 
165     function openFirstRound(uint256 _bID,bytes32 _maskHash)
166     public
167     isbetActivated(_bID)
168     {
169         address addr = msg.sender;
170         require(bIDBet_[bID].bID != 0,"cant find this bet");
171         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin,"Permission denied");
172         require(bIDrID_[_bID] == 0,"One Bet can only open one round");
173         newRound(_bID,_maskHash);
174     }
175 
176     function closeBet(uint256 _bID)
177     public
178     {
179         address addr = msg.sender;
180         require(bIDBet_[bID].bID != 0,"cant find this bet");
181         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin,"Permission denied");
182         // this means it cant be generated next round. current round would continue to end.
183         bIDBet_[_bID].isActivated = false;
184         //emit
185     }
186 
187     function openBet(uint256 _bID)
188     public
189     {
190         address addr = msg.sender;
191         require(bIDBet_[bID].bID != 0,"cant find this bet");
192         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin,"Permission denied");
193         require(bIDBet_[_bID].isActivated = false,"This bet is opening");
194         bIDBet_[_bID].isActivated = true;
195     }
196 
197     function editBet(uint256 _bID,uint256 _check,uint256 _unit)
198     public
199     {
200         require((_check >= MIN_BUY) && (_check <= MAX_BUY),"out of range");
201         address addr = msg.sender;
202         require(bIDBet_[_bID].bID != 0,"cant find this bet");
203         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin,"Permission denied");
204 
205         bIDBet_[_bID].check = _check;
206         bIDBet_[_bID].unit = _unit;
207         emit onEditBet(bID,bIDBet_[bID].owner,_check,_unit,now);
208 
209     }
210 
211     function withdrawFee()
212     isAdmin()
213     public
214     {
215         uint256 temp = teamFee_;
216         teamFee_ = 0;
217         msg.sender.transfer(temp);
218     }
219 
220 
221 //===============================================================
222 //   functions call by gameplayer
223 //==============================================================
224     function buySome(uint256 _rID,uint256 _key,uint256 _playerCode,uint256 _linkPID)
225     public
226     payable
227     {
228         require(rIDBet_[_rID].rID != 0,"cant find this round");
229         uint256 _bID = rIDBet_[_rID].bID;
230         require(bIDBet_[_bID].bID != 0,"cant find this bet");
231         require(_key <= rIDBet_[_rID].total,"key must not beyond limit");
232         require(msg.value >= bIDBet_[_bID].unit,"too small for this bet");
233         require(bIDBet_[_bID].unit * _key == msg.value,"not enough payment");
234         require(_playerCode < 100000000000000,"your random number is too big");
235         uint256 _pID = managePID(_linkPID);
236 
237         if(rIDBet_[_rID].current + _key <= rIDBet_[_rID].total)
238         {
239             uint256 _value = manageLink(_pID,msg.value);
240             manageKey(_pID,_rID,_key);
241             rIDBet_[_rID].current = rIDBet_[_rID].current.add(_key);
242             rIDBet_[_rID].ethAmount = rIDBet_[_rID].ethAmount.add(_value);
243             rIDBet_[_rID].playerCode = rIDBet_[_rID].playerCode.add(_playerCode);
244             emit onBuyBet(_bID,_rID,pIDPlayer_[_pID].addr,_value,_key,_playerCode,pIDPlayer_[_pID].invator,now);
245 
246             if(rIDBet_[_rID].current >= rIDBet_[_rID].total)
247             {
248                 emit onRoundEnd(_bID,_rID,now);
249             }
250         }
251         else{
252             // failed to pay a bet,the value will be stored in player's balance
253             pIDPlayer_[_pID].balance = pIDPlayer_[_pID].balance.add(msg.value);
254             emit onBuyFailed(_pID,_rID,msg.value,now);
255 
256         }
257 
258 
259     }
260 
261     function buyWithBalance(uint256 _rID,uint256 _key,uint256 _playerCode)
262     public
263     payable
264     {
265         uint256 _pID = pIDAddr_[msg.sender];
266         require(_pID != 0,"player not founded in contract ");
267         require(rIDBet_[_rID].rID != 0,"cant find this round");
268         uint256 _bID = rIDBet_[_rID].bID;
269         require(bIDBet_[_bID].bID != 0,"cant find this bet");
270 
271         uint256 _balance = pIDPlayer_[_pID].balance;
272         require(_key <= rIDBet_[_rID].total,"key must not beyond limit");
273         require(_balance >= bIDBet_[_bID].unit,"too small for this bet");
274         require(bIDBet_[_bID].unit * _key <= _balance,"not enough balance");
275         require(_playerCode < 100000000000000,"your random number is too big");
276 
277         require(rIDBet_[_rID].current + _key <= rIDBet_[_rID].total,"you beyond key");
278         pIDPlayer_[_pID].balance = pIDPlayer_[_pID].balance.sub(bIDBet_[_bID].unit * _key);
279         uint256 _value = manageLink(_pID,bIDBet_[_bID].unit * _key);
280         manageKey(_pID,_rID,_key);
281         rIDBet_[_rID].current = rIDBet_[_rID].current.add(_key);
282         rIDBet_[_rID].ethAmount = rIDBet_[_rID].ethAmount.add(_value);
283         rIDBet_[_rID].playerCode = rIDBet_[_rID].playerCode.add(_playerCode);
284 
285         emit onBuyBet(_bID,_rID,pIDPlayer_[_pID].addr,_value,_key,_playerCode,pIDPlayer_[_pID].invator,now);
286 
287         if(rIDBet_[_rID].current == rIDBet_[_rID].total)
288         {
289             emit onRoundEnd(_bID,_rID,now);
290         }
291     }
292 
293     function buyLink()
294     public
295     payable
296     {
297         require(msg.value >= linkPrice_,"not enough payment to buy link");
298         uint256 _pID = managePID(0);
299         pIDPlayer_[_pID].VIP = true;
300         teamFee_ = teamFee_.add(msg.value);
301 
302         //emit
303         emit onRegistLink(_pID,pIDPlayer_[_pID].addr,now);
304 
305     }
306 
307     function reveal(uint256 _rID,uint256 _scretKey,bytes32 _maskHash)
308     public
309     {
310         require(rIDBet_[_rID].rID != 0,"cant find this round");
311         uint256 _bID = rIDBet_[_rID].bID;
312         require(bIDBet_[_bID].bID != 0,"cant find this bet");
313         require((bIDBet_[_bID].owner == msg.sender) || admin == msg.sender,"can only be revealed by admin or owner");
314         bytes32 check = keccak256(abi.encodePacked(_scretKey));
315         require(check == rIDBet_[_rID].maskHash,"scretKey is not match maskHash");
316 
317         uint256 modulo = rIDBet_[_rID].total;
318 
319          //get random , use secretnumber,playerCode,blockinfo
320         bytes32 random = keccak256(abi.encodePacked(check,rIDBet_[_rID].playerCode,(block.number + now)));
321         uint result = (uint(random) % modulo) + 1;
322         uint256 _winPID = 0;
323 
324         for(uint i = 0;i < betList_[_rID].length;i++)
325         {
326             if(result >= betList_[_rID][i].start && result <= betList_[_rID][i].end)
327             {
328                 _winPID = betList_[_rID][i].pID;
329                 break;
330             }
331         }
332         // pay the reward
333         uint256 reward = rIDBet_[_rID].ethAmount;
334         uint256 teamFee = (bIDBet_[_bID].check.mul(3))/100;
335         pIDPlayer_[_winPID].balance = pIDPlayer_[_winPID].balance.add(reward);
336         //emit
337         emit onReveal(_rID,pIDPlayer_[_winPID].addr,reward,teamFee,_scretKey,result,now);
338 
339         // delete thie round;
340         delete rIDBet_[_rID];
341         delete betList_[_rID];
342         bIDrID_[_bID] = 0;
343 
344         // start to reset round
345         newRound(_bID,_maskHash);
346     }
347 
348     function getPlayerByAddr(address _addr)
349     public
350     view
351     returns(uint256,uint256,bool)
352     {
353         uint256 _pID = pIDAddr_[_addr];
354         return (_pID,pIDPlayer_[_pID].balance,pIDPlayer_[_pID].VIP);
355     }
356 
357     function getRoundInfoByID(uint256 _rID)
358     public
359     view
360     returns(uint256,uint256,uint256,uint256,uint256,bytes32,uint256)
361     {
362         return
363         (
364             rIDBet_[_rID].rID,               //0
365             rIDBet_[_rID].bID,               //1
366             rIDBet_[_rID].total,             //2
367             rIDBet_[_rID].current,           //3
368             rIDBet_[_rID].ethAmount,         //4
369             rIDBet_[_rID].maskHash,          //5
370             rIDBet_[_rID].playerCode     //6
371             );
372     }
373 
374     function getBetInfoByID(uint256 _bID)
375     public
376     view
377     returns(uint256,uint256,address,uint256,uint256,bool)
378     {
379         return
380         (
381             bIDrID_[_bID], //get current rID
382             bIDBet_[_bID].bID,
383             bIDBet_[_bID].owner,
384             bIDBet_[_bID].check,
385             bIDBet_[_bID].unit,
386             bIDBet_[_bID].isActivated
387             );
388     }
389 
390     function getBIDList()
391     public
392     view
393     returns(uint256[])
394     {return(bIDList_);}
395 
396 
397     function withdraw()
398     isActivated()
399     public
400     {
401         uint256 _now = now;
402         uint256 _pID = pIDAddr_[msg.sender];
403         uint256 _eth;
404 
405         if(_pID != 0)
406         {
407             _eth = withdrawEarnings(_pID);
408             require(_eth > 0,"no any balance left");
409             pIDPlayer_[_pID].addr.transfer(_eth);
410 
411             emit onWithdraw(_pID,msg.sender,_eth,_now);
412         }
413     }
414 
415 
416 
417 //===============================================================
418 //   internal call
419 //==============================================================
420 
421 
422     function manageKey(uint256 _pID,uint256 _rID,uint256 _key)
423     private
424     {
425         uint256 _current = rIDBet_[_rID].current;
426 
427         OneEtherDatasets.stake memory _playerstake = OneEtherDatasets.stake(0,0,0);
428         _playerstake.start = _current + 1;
429         _playerstake.end = _current + _key;
430         _playerstake.pID = _pID;
431 
432         betList_[_rID].push(_playerstake);
433 
434     }
435 
436     function manageLink(uint256 _pID,uint256 _value)
437     private
438     returns(uint256)
439     {
440         uint256 cut = (_value.mul(3))/100;//3% for teamFee
441         uint256 _value2 = _value.sub(cut);
442 
443         uint256 _invator = pIDPlayer_[_pID].invator;
444         if(_invator != 0)
445         {
446             uint256 cut2 = (cut.mul(60))/100; //2% for the invator
447             cut = cut.sub(cut2);
448             pIDPlayer_[_invator].balance = pIDPlayer_[_invator].balance.add(cut2);
449         }
450 
451         teamFee_ = teamFee_.add(cut);
452         return _value2;
453     }
454 
455     function managePID(uint256 _linkPID)
456     private
457     returns (uint256)
458     {
459         uint256 _pID = pIDAddr_[msg.sender];
460 
461         if(_pID == 0)
462         {
463             // regist a new player
464             pID++;
465             pIDAddr_[msg.sender] = pID;
466 
467 
468             // set new player struct
469             pIDPlayer_[pID].addr = msg.sender;
470             pIDPlayer_[pID].balance = 0;
471             pIDPlayer_[pID].VIP = false;
472 
473             if(pIDPlayer_[_linkPID].addr != address(0) && pIDPlayer_[_linkPID].VIP == true)
474             {
475                 pIDPlayer_[pID].invator = _linkPID;
476             }
477 
478             return (pID);
479         }
480 
481         else{
482             return (_pID);
483         }
484 
485     }
486 
487 
488 
489     function newRound(uint256 _bID,bytes32 _maskHash)
490     private
491     {
492         uint256 _total = bIDBet_[_bID].check / bIDBet_[_bID].unit;
493         if(bIDBet_[_bID].isActivated == true)
494         {
495             rID++;
496             rIDBet_[rID].rID = rID;
497             rIDBet_[rID].bID = _bID;
498             rIDBet_[rID].total = _total;
499             rIDBet_[rID].current = 0;
500             rIDBet_[rID].ethAmount = 0;
501             rIDBet_[rID].maskHash = _maskHash;
502             rIDBet_[rID].playerCode = 0;
503 
504             bIDrID_[_bID] = rID;
505             emit onOpenNewRound(_bID,rID,rIDBet_[rID].total,rIDBet_[rID].current,rIDBet_[rID].ethAmount,now);
506             emit RoundMask(rID,_maskHash);
507         }
508         else
509         {
510             bIDrID_[_bID] = 0;
511         }
512 
513     }
514 
515     function withdrawEarnings(uint256 _pID)
516         private
517         returns(uint256)
518     {
519         uint256 _earnings = pIDPlayer_[_pID].balance;
520         if (_earnings > 0)
521         {
522             pIDPlayer_[_pID].balance = 0;
523         }
524 
525         return(_earnings);
526     }
527 }
528 
529 library OneEtherDatasets {
530 
531     struct BetInfo {
532         uint256 bID;
533         address owner;
534         uint256 check;
535         uint256 unit;
536         bool isActivated;
537     }
538 
539     struct BetState{
540         uint256 rID;
541         uint256 bID;
542         uint256 total;
543         uint256 current;
544         uint256 ethAmount;
545         bytes32 maskHash;
546         uint256 playerCode;
547     }
548 
549     struct Player{
550         address addr;
551         uint256 balance;
552         uint256 invator;
553         bool VIP;
554     }
555 
556     struct stake{
557         uint256 start;
558         uint256 end;
559         uint256 pID;
560     }
561 }
562 
563 
564 library SafeMath {
565 
566     /**
567     * @dev Multiplies two numbers, throws on overflow.
568     */
569     function mul(uint256 a, uint256 b)
570         internal
571         pure
572         returns (uint256 c)
573     {
574         if (a == 0) {
575             return 0;
576         }
577         c = a * b;
578         require(c / a == b, "SafeMath mul failed");
579         return c;
580     }
581 
582     /**
583     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
584     */
585     function sub(uint256 a, uint256 b)
586         internal
587         pure
588         returns (uint256)
589     {
590         require(b <= a, "SafeMath sub failed");
591         return a - b;
592     }
593 
594     /**
595     * @dev Adds two numbers, throws on overflow.
596     */
597     function add(uint256 a, uint256 b)
598         internal
599         pure
600         returns (uint256 c)
601     {
602         c = a + b;
603         require(c >= a, "SafeMath add failed");
604         return c;
605     }
606 
607     /**
608      * @dev gives square root of given x.
609      */
610     function sqrt(uint256 x)
611         internal
612         pure
613         returns (uint256 y)
614     {
615         uint256 z = ((add(x,1)) / 2);
616         y = x;
617         while (z < y)
618         {
619             y = z;
620             z = ((add((x / z),z)) / 2);
621         }
622     }
623 
624     /**
625      * @dev gives square. multiplies x by x
626      */
627     function sq(uint256 x)
628         internal
629         pure
630         returns (uint256)
631     {
632         return (mul(x,x));
633     }
634 
635     /**
636      * @dev x to the power of y
637      */
638     function pwr(uint256 x, uint256 y)
639         internal
640         pure
641         returns (uint256)
642     {
643         if (x==0)
644             return (0);
645         else if (y==0)
646             return (1);
647         else
648         {
649             uint256 z = x;
650             for (uint256 i = 1;i < y;i++)
651                 z = mul(z,x);
652             return (z);
653         }
654     }
655 }