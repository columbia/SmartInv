1 pragma solidity ^0.4.24;
2 
3 /**
4  * @dev winner events
5  */
6 contract WinnerEvents {
7 
8     event onBuy
9     (
10         address paddr,
11         uint256 ethIn,
12         string  reff,
13         uint256 timeStamp
14     );
15 
16     event onBuyUseBalance
17     (
18         address paddr,
19         uint256 keys,
20         uint256 timeStamp
21     );
22 
23     event onBuyName
24     (
25         address paddr,
26         bytes32 pname,
27         uint256 ethIn,
28         uint256 timeStamp
29     );
30 
31     event onWithdraw
32     (
33         address paddr,
34         uint256 ethOut,
35         uint256 timeStamp
36     );
37 
38     event onUpRoundID
39     (
40         uint256 roundID
41     );
42 
43     event onUpPlayer
44     (
45         address addr,
46         bytes32 pname,
47         uint256 balance,
48         uint256 interest,
49         uint256 win,
50         uint256 reff
51     );
52 
53     event onAddPlayerOrder
54     (
55         address addr,
56         uint256 keys,
57         uint256 eth,
58         uint256 otype
59     );
60 
61     event onUpPlayerRound
62     (
63         address addr,
64         uint256 roundID,
65         uint256 eth,
66         uint256 keys,
67         uint256 interest,
68         uint256 win,
69         uint256 reff
70     );
71 
72 
73     event onUpRound
74     (
75         uint256 roundID,
76         address leader,
77         uint256 start,
78         uint256 end,
79         bool ended,
80         uint256 keys,
81         uint256 eth,
82         uint256 pool,
83         uint256 interest,
84         uint256 win,
85         uint256 reff
86     );
87 
88 
89 }
90 
91 /*
92  *  @dev winner contract
93  */
94 contract Winner is WinnerEvents {
95     using SafeMath for *;
96     using NameFilter for string;
97 
98 //==============================================================================
99 // game settings
100 //==============================================================================
101 
102     string constant public name = "Im Winner Game";
103     string constant public symbol = "IMW";
104 
105 
106 //==============================================================================
107 // public state variables
108 //==============================================================================
109 
110     // activated flag
111     bool public activated_ = false;
112 
113     // round id
114     uint256 public roundID_;
115 
116     // *************
117     // player data
118     // *************
119 
120     uint256 private pIDCount_;
121 
122     // return pid by address
123     mapping(address => uint256) public address2PID_;
124 
125     // return player data by pid (pid => player)
126     mapping(uint256 => WinnerDatasets.Player) public pID2Player_;
127 
128     // return player round data (pid => rid => player round data)
129     mapping(uint256 => mapping(uint256 => WinnerDatasets.PlayerRound)) public pID2Round_;
130 
131     // return player order data (pid => rid => player order data)
132     mapping(uint256 => mapping(uint256 => WinnerDatasets.PlayerOrder[])) public pID2Order_;
133 
134     // *************
135     // round data
136     // *************
137 
138     // return the round data by rid (rid => round)
139     mapping(uint256 => WinnerDatasets.Round) public rID2Round_;
140 
141 
142     constructor()
143         public
144     {
145         pIDCount_ = 0;
146     }
147 
148 
149 //==============================================================================
150 // function modifiers
151 //==============================================================================
152 
153 
154     /*
155      * @dev check if the contract is activated
156      */
157      modifier isActivated() {
158         require(activated_ == true, "the contract is not ready yet");
159         _;
160      }
161 
162      /**
163      * @dev check if the msg sender is human account
164      */
165     modifier isHuman() {
166         address _addr = msg.sender;
167         uint256 _codeLength;
168         
169         assembly {_codeLength := extcodesize(_addr)}
170         require(_codeLength == 0, "sorry humans only");
171         _;
172     }
173 
174      /*
175       * @dev check if admin or not 
176       */
177     modifier isAdmin() {
178         require( msg.sender == 0x74B25afBbd16Ef94d6a32c311d5c184a736850D3, "sorry admins only");
179         _;
180     }
181 
182     /**
183      * @dev sets boundaries for incoming tx 
184      */
185     modifier isWithinLimits(uint256 _eth) {
186         require(_eth >= 10000000000, "eth too small");
187         require(_eth <= 100000000000000000000000, "eth too huge");
188         _;    
189     }
190 
191 //==============================================================================
192 // public functions
193 //==============================================================================
194 
195     /*
196      *  @dev send eth to contract
197      */
198     function ()
199     isActivated()
200     isHuman()
201     isWithinLimits(msg.value)
202     public
203     payable {
204         buyCore(msg.sender, msg.value, "");
205     }
206 
207     /*
208      *  @dev send eth to contract
209      */
210     function buyKey()
211     isActivated()
212     isHuman()
213     isWithinLimits(msg.value)
214     public
215     payable {
216         buyCore(msg.sender, msg.value, "");
217     }
218 
219     /*
220      *  @dev send eth to contract
221      */
222     function buyKeyWithReff(string reff)
223     isActivated()
224     isHuman()
225     isWithinLimits(msg.value)
226     public
227     payable {
228         buyCore(msg.sender, msg.value, reff);
229     }
230 
231     /*
232      *  @dev buy key use balance
233      */
234 
235     function buyKeyUseBalance(uint256 keys) 
236     isActivated()
237     isHuman()
238     public {
239 
240         uint256 pID = address2PID_[msg.sender];
241         require(pID > 0, "cannot find player");
242 
243         // fire buy  event 
244         emit WinnerEvents.onBuyUseBalance
245         (
246             msg.sender, 
247             keys, 
248             now
249         );
250     }
251 
252 
253     /*
254      *  @dev buy name
255      */
256     function buyName(string pname)
257     isActivated()
258     isHuman()
259     isWithinLimits(msg.value)
260     public
261     payable {
262 
263         uint256 pID = address2PID_[msg.sender];
264 
265         // new player
266         if( pID == 0 ) {
267             pIDCount_++;
268 
269             pID = pIDCount_;
270             WinnerDatasets.Player memory player = WinnerDatasets.Player(pID, msg.sender, 0, 0, 0, 0, 0);
271             WinnerDatasets.PlayerRound memory playerRound = WinnerDatasets.PlayerRound(0, 0, 0, 0, 0);
272 
273             pID2Player_[pID] = player;
274             pID2Round_[pID][roundID_] = playerRound;
275 
276             address2PID_[msg.sender] = pID;
277         }
278 
279         pID2Player_[pID].pname = pname.nameFilter();
280 
281         // fire buy  event 
282         emit WinnerEvents.onBuyName
283         (
284             msg.sender, 
285             pID2Player_[pID].pname, 
286             msg.value, 
287             now
288         );
289         
290     }
291 
292 //==============================================================================
293 // private functions
294 //==============================================================================    
295 
296     function buyCore(address addr, uint256 eth, string reff) 
297     private {
298         uint256 pID = address2PID_[addr];
299 
300         // new player
301         if( pID == 0 ) {
302             pIDCount_++;
303 
304             pID = pIDCount_;
305             WinnerDatasets.Player memory player = WinnerDatasets.Player(pID, addr, 0, 0, 0, 0, 0);
306             WinnerDatasets.PlayerRound memory playerRound = WinnerDatasets.PlayerRound(0, 0, 0, 0, 0);
307 
308             pID2Player_[pID] = player;
309             pID2Round_[pID][roundID_] = playerRound;
310 
311             address2PID_[addr] = pID;
312         }
313 
314         // fire buy  event 
315         emit WinnerEvents.onBuy
316         (
317             addr, 
318             eth, 
319             reff,
320             now
321         );
322     }
323 
324     
325 //==============================================================================
326 // admin functions
327 //==============================================================================    
328 
329     /*
330      * @dev activate the contract
331      */
332     function activate() 
333     isAdmin()
334     public {
335 
336         require( activated_ == false, "contract is activated");
337 
338         activated_ = true;
339 
340         // start the first round
341         roundID_ = 1;
342     }
343 
344     /**
345      *  @dev inactivate the contract
346      */
347     function inactivate()
348     isAdmin()
349     isActivated()
350     public {
351 
352         activated_ = false;
353     }
354 
355     /*
356      *  @dev user withdraw
357      */
358     function withdraw(address addr, uint256 eth)
359     isActivated() 
360     isAdmin() 
361     isWithinLimits(eth) 
362     public {
363 
364         uint pID = address2PID_[addr];
365         require(pID > 0, "user not exist");
366 
367         addr.transfer(eth);
368 
369         // fire the withdraw event
370         emit WinnerEvents.onWithdraw
371         (
372             msg.sender, 
373             eth, 
374             now
375         );
376     }
377 
378     /*
379      *  @dev update round id
380      */
381     function upRoundID(uint256 roundID) 
382     isAdmin()
383     isActivated()
384     public {
385 
386         require(roundID_ != roundID, "same to the current roundID");
387 
388         roundID_ = roundID;
389 
390         // fire the withdraw event
391         emit WinnerEvents.onUpRoundID
392         (
393             roundID
394         );
395     }
396 
397     /*
398      * @dev upPlayer
399      */
400     function upPlayer(address addr, bytes32 pname, uint256 balance, uint256 interest, uint256 win, uint256 reff)
401     isAdmin()
402     isActivated()
403     public {
404 
405         uint256 pID = address2PID_[addr];
406 
407         require( pID != 0, "cannot find the player");
408         require( balance >= 0, "balance invalid");
409         require( interest >= 0, "interest invalid");
410         require( win >= 0, "win invalid");
411         require( reff >= 0, "reff invalid");
412 
413         pID2Player_[pID].pname = pname;
414         pID2Player_[pID].balance = balance;
415         pID2Player_[pID].interest = interest;
416         pID2Player_[pID].win = win;
417         pID2Player_[pID].reff = reff;
418 
419         // fire the event
420         emit WinnerEvents.onUpPlayer
421         (
422             addr,
423             pname,
424             balance,
425             interest,
426             win,
427             reff
428         );
429     }
430 
431 
432     function upPlayerRound(address addr, uint256 roundID, uint256 eth, uint256 keys, uint256 interest, uint256 win, uint256 reff)
433     isAdmin()
434     isActivated() 
435     public {
436         
437         uint256 pID = address2PID_[addr];
438 
439         require( pID != 0, "cannot find the player");
440         require( roundID == roundID_, "not current round");
441         require( eth >= 0, "eth invalid");
442         require( keys >= 0, "keys invalid");
443         require( interest >= 0, "interest invalid");
444         require( win >= 0, "win invalid");
445         require( reff >= 0, "reff invalid");
446 
447         pID2Round_[pID][roundID_].eth = eth;
448         pID2Round_[pID][roundID_].keys = keys;
449         pID2Round_[pID][roundID_].interest = interest;
450         pID2Round_[pID][roundID_].win = win;
451         pID2Round_[pID][roundID_].reff = reff;
452 
453         // fire the event
454         emit WinnerEvents.onUpPlayerRound
455         (
456             addr,
457             roundID,
458             eth,
459             keys,
460             interest,
461             win,
462             reff
463         );
464     }
465 
466     /*
467      *  @dev add player order
468      */
469     function addPlayerOrder(address addr, uint256 roundID, uint256 keys, uint256 eth, uint256 otype, uint256 keysAvailable, uint256 keysEth) 
470     isAdmin()
471     isActivated()
472     public {
473 
474         uint256 pID = address2PID_[addr];
475 
476         require( pID != 0, "cannot find the player");
477         require( roundID == roundID_, "not current round");
478         require( keys >= 0, "keys invalid");
479         require( eth >= 0, "eth invalid");
480         require( otype >= 0, "type invalid");
481         require( keysAvailable >= 0, "keysAvailable invalid");
482 
483         pID2Round_[pID][roundID_].eth = keysEth;
484         pID2Round_[pID][roundID_].keys = keysAvailable;
485 
486         WinnerDatasets.PlayerOrder memory playerOrder = WinnerDatasets.PlayerOrder(keys, eth, otype);
487         pID2Order_[pID][roundID_].push(playerOrder);
488 
489         emit WinnerEvents.onAddPlayerOrder
490         (
491             addr,
492             keys,
493             eth,
494             otype
495         );
496     }
497 
498 
499     /*
500      * @dev upRound
501      */
502     function upRound(uint256 roundID, address leader, uint256 start, uint256 end, bool ended, uint256 keys, uint256 eth, uint256 pool, uint256 interest, uint256 win, uint256 reff)
503     isAdmin()
504     isActivated()
505     public {
506 
507         require( roundID == roundID_, "not current round");
508 
509         uint256 pID = address2PID_[leader];
510         require( pID != 0, "cannot find the leader");
511         require( end >= start, "start end invalid");
512         require( keys >= 0, "keys invalid");
513         require( eth >= 0, "eth invalid");
514         require( pool >= 0, "pool invalid");
515         require( interest >= 0, "interest invalid");
516         require( win >= 0, "win invalid");
517         require( reff >= 0, "reff invalid");
518 
519         rID2Round_[roundID_].leader = leader;
520         rID2Round_[roundID_].start = start;
521         rID2Round_[roundID_].end = end;
522         rID2Round_[roundID_].ended = ended;
523         rID2Round_[roundID_].keys = keys;
524         rID2Round_[roundID_].eth = eth;
525         rID2Round_[roundID_].pool = pool;
526         rID2Round_[roundID_].interest = interest;
527         rID2Round_[roundID_].win = win;
528         rID2Round_[roundID_].reff = reff;
529 
530         // fire the event
531         emit WinnerEvents.onUpRound
532         (
533             roundID,
534             leader,
535             start,
536             end,
537             ended,
538             keys,
539             eth,
540             pool,
541             interest,
542             win,
543             reff
544         );
545     }
546 }
547 
548 
549 //==============================================================================
550 // interfaces
551 //==============================================================================
552 
553 
554 //==============================================================================
555 // structs
556 //==============================================================================
557 
558 library WinnerDatasets {
559 
560     struct Player {
561         uint256 pId;        // player id
562         address addr;       // player address
563         bytes32 pname;      // player name
564         uint256 balance;    // eth balance
565         uint256 interest;   // interest total
566         uint256 win;        // win total
567         uint256 reff;       // reff total
568     }
569 
570     struct PlayerRound {
571         uint256 eth;        // keys eth value
572         uint256 keys;       // keys
573         uint256 interest;   // interest total
574         uint256 win;        // win total
575         uint256 reff;       // reff total
576     }
577 
578     struct PlayerOrder {
579         uint256 keys;       // keys buy
580         uint256 eth;        // eth
581         uint256 otype;       // buy or sell       
582     }
583 
584     struct Round {
585         address leader;     // pID of player in lead
586         uint256 start;      // time start
587         uint256 end;        // time ends/ended
588         bool ended;         // has round end function been ran
589         uint256 keys;       // keys
590         uint256 eth;        // total eth in
591         uint256 pool;       // pool eth
592         uint256 interest;   // interest total
593         uint256 win;        // win total
594         uint256 reff;       // reff total
595     }
596 }
597 
598 //==============================================================================
599 // libraries
600 //==============================================================================
601 
602 library NameFilter {
603 
604     function nameFilter(string _input)
605         internal
606         pure
607         returns(bytes32)
608     {
609         bytes memory _temp = bytes(_input);
610         uint256 _length = _temp.length;
611         
612         //sorry limited to 32 characters
613         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
614         // make sure it doesnt start with or end with space
615         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
616         // make sure first two characters are not 0x
617         if (_temp[0] == 0x30)
618         {
619             require(_temp[1] != 0x78, "string cannot start with 0x");
620             require(_temp[1] != 0x58, "string cannot start with 0X");
621         }
622         
623         // create a bool to track if we have a non number character
624         bool _hasNonNumber;
625         
626         // convert & check
627         for (uint256 i = 0; i < _length; i++)
628         {
629             // if its uppercase A-Z
630             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
631             {
632                 // convert to lower case a-z
633                 _temp[i] = byte(uint(_temp[i]) + 32);
634                 
635                 // we have a non number
636                 if (_hasNonNumber == false)
637                     _hasNonNumber = true;
638             } else {
639                require
640                 (
641                     // require character is a space
642                     _temp[i] == 0x20 || 
643                     // OR lowercase a-z
644                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
645                     // or 0-9
646                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
647                     "string contains invalid characters"
648                 );
649                 // make sure theres not 2x spaces in a row
650                 if (_temp[i] == 0x20)
651                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
652                 
653                 // see if we have a character other than a number
654                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
655                     _hasNonNumber = true;    
656             }
657         }
658         
659         require(_hasNonNumber == true, "string cannot be only numbers");
660         
661         bytes32 _ret;
662         assembly {
663             _ret := mload(add(_temp, 32))
664         }
665         return (_ret);
666     }
667 }
668 
669 
670 /*
671  * @dev safe math
672  */
673 library SafeMath {
674     
675     /**
676     * @dev Multiplies two numbers, throws on overflow.
677     */
678     function mul(uint256 a, uint256 b) 
679         internal 
680         pure 
681         returns (uint256 c) 
682     {
683         if (a == 0) {
684             return 0;
685         }
686         c = a * b;
687         require(c / a == b, "SafeMath mul failed");
688         return c;
689     }
690 
691     /**
692     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
693     */
694     function sub(uint256 a, uint256 b)
695         internal
696         pure
697         returns (uint256) 
698     {
699         require(b <= a, "SafeMath sub failed");
700         return a - b;
701     }
702 
703     /**
704     * @dev Adds two numbers, throws on overflow.
705     */
706     function add(uint256 a, uint256 b)
707         internal
708         pure
709         returns (uint256 c) 
710     {
711         c = a + b;
712         require(c >= a, "SafeMath add failed");
713         return c;
714     }
715     
716     /**
717      * @dev gives square root of given x.
718      */
719     function sqrt(uint256 x)
720         internal
721         pure
722         returns (uint256 y) 
723     {
724         uint256 z = ((add(x,1)) / 2);
725         y = x;
726         while (z < y) 
727         {
728             y = z;
729             z = ((add((x / z),z)) / 2);
730         }
731     }
732     
733     /**
734      * @dev gives square. multiplies x by x
735      */
736     function sq(uint256 x)
737         internal
738         pure
739         returns (uint256)
740     {
741         return (mul(x,x));
742     }
743     
744     /**
745      * @dev x to the power of y 
746      */
747     function pwr(uint256 x, uint256 y)
748         internal 
749         pure 
750         returns (uint256)
751     {
752         if (x==0)
753             return (0);
754         else if (y==0)
755             return (1);
756         else 
757         {
758             uint256 z = x;
759             for (uint256 i=1; i < y; i++)
760                 z = mul(z,x);
761             return (z);
762         }
763     }
764 }