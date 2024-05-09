1 pragma solidity ^0.4.24;
2 
3 /*
4 *   __/\\\\\\\\\\\__/\\\\____________/\\\\__/\\\________/\\\_____/\\\\\\\\\\\\_
5 *    _\/////\\\///__\/\\\\\\________/\\\\\\_\/\\\_____/\\\//____/\\\//////////__
6 *     _____\/\\\_____\/\\\//\\\____/\\\//\\\_\/\\\__/\\\//______/\\\_____________
7 *      _____\/\\\_____\/\\\\///\\\/\\\/_\/\\\_\/\\\\\\//\\\_____\/\\\____/\\\\\\\_
8 *       _____\/\\\_____\/\\\__\///\\\/___\/\\\_\/\\\//_\//\\\____\/\\\___\/////\\\_
9 *        _____\/\\\_____\/\\\____\///_____\/\\\_\/\\\____\//\\\___\/\\\_______\/\\\_
10 *         _____\/\\\_____\/\\\_____________\/\\\_\/\\\_____\//\\\__\/\\\_______\/\\\_
11 *          __/\\\\\\\\\\\_\/\\\_____________\/\\\_\/\\\______\//\\\_\//\\\\\\\\\\\\/__
12 *           _\///////////__\///______________\///__\///________\///___\////////////____
13 */
14 
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b)
21         internal
22         pure
23         returns (uint256 c)
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256)
40     {
41         require(b <= a, "SafeMath sub failed");
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b)
49         internal
50         pure
51         returns (uint256 c)
52     {
53         c = a + b;
54         require(c >= a, "SafeMath add failed");
55         return c;
56     }
57 
58     /**
59      * @dev gives square root of given x.
60      */
61     function sqrt(uint256 x)
62         internal
63         pure
64         returns (uint256 y)
65     {
66         uint256 z = ((add(x,1)) / 2);
67         y = x;
68         while (z < y)
69         {
70             y = z;
71             z = ((add((x / z),z)) / 2);
72         }
73     }
74 
75     /**
76      * @dev gives square. multiplies x by x
77      */
78     function sq(uint256 x)
79         internal
80         pure
81         returns (uint256)
82     {
83         return (mul(x,x));
84     }
85 
86     /**
87      * @dev x to the power of y
88      */
89     function pwr(uint256 x, uint256 y)
90         internal
91         pure
92         returns (uint256)
93     {
94         if (x==0)
95             return (0);
96         else if (y==0)
97             return (1);
98         else
99         {
100             uint256 z = x;
101             for (uint256 i=1; i < y; i++)
102                 z = mul(z,x);
103             return (z);
104         }
105     }
106 }
107 
108 library NameFilter {
109     /**
110      * @dev filters name strings
111      * -converts uppercase to lower case.
112      * -makes sure it does not start/end with a space
113      * -makes sure it does not contain multiple spaces in a row
114      * -cannot be only numbers
115      * -cannot start with 0x
116      * -restricts characters to A-Z, a-z, 0-9, and space.
117      * @return reprocessed string in bytes32 format
118      */
119     function nameFilter(string _input)
120         internal
121         pure
122         returns(bytes32)
123     {
124         bytes memory _temp = bytes(_input);
125         uint256 _length = _temp.length;
126 
127         //sorry limited to 32 characters
128         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
129         // make sure it doesnt start with or end with space
130         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
131         // make sure first two characters are not 0x
132         if (_temp[0] == 0x30)
133         {
134             require(_temp[1] != 0x78, "string cannot start with 0x");
135             require(_temp[1] != 0x58, "string cannot start with 0X");
136         }
137 
138         // create a bool to track if we have a non number character
139         bool _hasNonNumber;
140 
141         // convert & check
142         for (uint256 i = 0; i < _length; i++)
143         {
144             // if its uppercase A-Z
145             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
146             {
147                 // convert to lower case a-z
148                 _temp[i] = byte(uint(_temp[i]) + 32);
149 
150                 // we have a non number
151                 if (_hasNonNumber == false)
152                     _hasNonNumber = true;
153             } else {
154                 require
155                 (
156                     // require character is a space
157                     _temp[i] == 0x20 ||
158                     // OR lowercase a-z
159                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
160                     // or 0-9
161                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
162                     "string contains invalid characters"
163                 );
164                 // make sure theres not 2x spaces in a row
165                 if (_temp[i] == 0x20)
166                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
167 
168                 // see if we have a character other than a number
169                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
170                     _hasNonNumber = true;
171             }
172         }
173 
174         require(_hasNonNumber == true, "string cannot be only numbers");
175 
176         bytes32 _ret;
177         assembly {
178             _ret := mload(add(_temp, 32))
179         }
180         return (_ret);
181     }
182 }
183 
184 library ImkgKeysCalc {
185     using SafeMath for *;
186 
187     // calculate X eth can buy how many keys above current eth.
188     function keysRec(uint256 _curEth, uint256 _newEth)
189         internal
190         pure
191         returns (uint256)
192     {
193         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
194     }
195 
196     // calculate X keys can value how much eth above current keys.
197     function ethRec(uint256 _curKeys, uint256 _sellKeys)
198         internal
199         pure
200         returns (uint256)
201     {
202         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
203     }
204 
205     // calculate X eth corresponding how many keys in curre pots.
206     function keys(uint256 _eth)
207         internal
208         pure
209         returns(uint256)
210     {
211         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000000);
212     }
213 
214     // calculate X keys corresponding how much eth in curre pots.
215     function eth(uint256 _keys)
216         internal
217         pure
218         returns(uint256)
219     {
220         return ((78125000000000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000000))) / (2))) / ((1000000000000000000).sq());
221     }
222 }
223 
224 contract Imkg {
225     using SafeMath for *;
226     using NameFilter for string;
227     using ImkgKeysCalc for uint256;
228 
229     //**************
230     // EVENTS
231     //**************
232 
233     // fired player registers a new name
234     event onNewNameEvent
235     (
236         uint256 indexed playerID,
237         address indexed playerAddress,
238         bytes32 indexed playerName,
239         bool isNewPlayer,
240         uint256 amountPaid,
241         uint256 timeStamp
242     );
243 
244     // fired leader sets a new team name
245     event onNewTeamNameEvent
246     (
247         uint256 indexed teamID,
248         bytes32 indexed teamName,
249         uint256 indexed playerID,
250         bytes32 playerName,
251         uint256 amountPaid,
252         uint256 timeStamp
253     );
254 
255     // fired when buy the bomb
256     event onTxEvent
257     (
258         uint256 indexed playerID,
259         address playerAddress,
260         bytes32 playerName,
261         uint256 teamID,
262         bytes32 teamName,
263         uint256 ethIn,
264         uint256 keysBought
265     );
266 
267     // fired a bonus to invitor when a invited pays
268     event onAffPayoutEvent
269     (
270         uint256 indexed affID,
271         address affAddress,
272         bytes32 affName,
273         uint256 indexed roundID,
274         uint256 indexed buyerID,
275         uint256 amount,
276         uint256 timeStamp
277     );
278 
279     // fired an out event
280     event onOutEvent
281     (
282         uint256 deadCount,
283         uint256 liveCount,
284         uint256 deadKeys
285     );
286 
287     // fired end event when game is over
288     event onEndRoundEvent
289     (
290         uint256 winnerTID,  // winner
291         bytes32 winnerTName,
292         uint256 playersCount,
293         uint256 eth    // eth in pot
294     );
295 
296     // fired when withdraw
297     event onWithdrawEvent
298     (
299         uint256 indexed playerID,
300         address playerAddress,
301         bytes32 playerName,
302         uint256 ethOut,
303         uint256 timeStamp
304     );
305 
306     // fired out initial event
307     event onOutInitialEvent
308     (
309         uint256 outTime
310     );
311 
312     //**************
313     // DATA
314     //**************
315 
316     // player info
317     struct Player {
318         address addr;   //  player address
319         bytes32 name;
320         uint256 gen;    // balance
321         uint256 aff;    // balance for invite
322         uint256 laff;   // the latest invitor. ID
323     }
324 
325     // player info in every round
326     struct PlayerRounds {
327         uint256 eth;    // all eths in current round
328         mapping (uint256 => uint256) plyrTmKeys;    // teamid => keys
329         bool withdrawn;     // if earnings are withdrawn in current round
330     }
331 
332     // team info
333     struct Team {
334         uint256 id;     // team id
335         bytes32 name;    // team name
336         uint256 keys;   // key s in the team
337         uint256 eth;   // eth from the team
338         uint256 price;    // price of the last key (only for view)
339         uint256 playersCount;   // how many team members
340         uint256 leaderID;   // leader pID (leader is always the top 1 player in the team)
341         address leaderAddr;  // leader address
342         bool dead;  // if team is out
343     }
344 
345     // round info
346     struct Round {
347         uint256 start;  // start time
348         uint256 state;  // 0:inactive,1:prepare,2:out,3:end
349         uint256 eth;    // all eths
350         uint256 pot;    // amount of this pot
351         uint256 keys;   // all keys
352         uint256 team;   // first team ID
353         uint256 ethPerKey;  // how many eth per key in Winner Team. (must after the game)
354         uint256 lastOutTime;   // the last out emit time
355         uint256 deadRate;   // current dead rate (first team all keys * rate = dead line)
356         uint256 deadKeys;   // next dead line
357         uint256 liveTeams;  // alive teams
358         uint256 tID_;    // how many teams in this Round
359     }
360 
361     //****************
362     // GAME SETTINGS
363     //****************
364     string constant public name = "I AM The King of God";
365     string constant public symbol = "IMKG";
366     address public owner;
367     address public cooperator;
368     uint256 public minTms_ = 3;    //minimum team number for active limit
369     uint256 public maxTms_ = 12;    // maximum team number
370     uint256 public roundGap_ = 120;    // round gap: 2 mins
371     uint256 public OutGap_ = 43200;   // out gap: 12 hours
372     uint256 constant private registrationFee_ = 10 finney;    // fee for register a new name
373 
374     //****************
375     // PLAYER DATA
376     //****************
377     uint256 public pID_;    // all players
378     mapping (address => uint256) public pIDxAddr_;  // (addr => pID) returns player id by address
379     mapping (bytes32 => uint256) public pIDxName_;  // (name => pID) returns player id by name
380     mapping (uint256 => Player) public plyr_;   // (pID => data) player data
381 
382     //****************
383     // ROUND DATA
384     //****************
385     uint256 public rID_;    // current round ID
386     mapping (uint256 => Round) public round_;   // round ID => round data
387 
388     // Player Rounds
389     mapping (uint256 => mapping (uint256 => PlayerRounds)) public plyrRnds_;  // player ID => round ID => player info
390 
391     //****************
392     // TEAM DATA
393     //****************
394     mapping (uint256 => mapping (uint256 => Team)) public rndTms_;  // round ID => team ID => team info
395     mapping (uint256 => mapping (bytes32 => uint256)) public rndTIDxName_;  // (rID => team name => tID) returns team id by name
396 
397     // =============
398     // CONSTRUCTOR
399     // =============
400 
401     constructor() public {
402         owner = msg.sender;
403         cooperator = address(0xF10898c3D10c8D1a16E697062b764fb510c3baD8);
404     }
405 
406     // =============
407     // MODIFIERS
408     // =============
409 
410     // only developer
411     modifier onlyOwner() {
412         require(msg.sender == owner);
413         _;
414     }
415 
416     /**
417      * @dev used to make sure no one can interact with contract until it has
418      * been activated.
419      */
420     modifier isActivated() {
421         require(activated_ == true, "its not ready yet.");
422         _;
423     }
424 
425     /**
426      * @dev prevents contracts from interacting with imkg
427      */
428     modifier isHuman() {
429         require(tx.origin == msg.sender, "sorry humans only");
430         _;
431     }
432 
433     /**
434      * @dev sets boundaries for incoming tx
435      */
436     modifier isWithinLimits(uint256 _eth) {
437         require(_eth >= 1000000000, "no less than 1 Gwei");
438         require(_eth <= 100000000000000000000000, "no more than 100000 ether");
439         _;
440     }
441 
442     // **************=======
443     // PUBLIC INTERACTION
444     // **************=======
445 
446     /**
447      * @dev emergency buy uses last stored affiliate ID and the first team
448      */
449     function()
450         public
451         payable
452         isActivated()
453         isHuman()
454         isWithinLimits(msg.value)
455     {
456         buy(round_[rID_].team, "imkg");
457     }
458 
459     /**
460      * @dev buy function
461      * @param _affCode the ID/address/name of the player who gets the affiliate fee
462      * @param _team what team is the player playing for
463      */
464     function buy(uint256 _team, bytes32 _affCode)
465         public
466         payable
467         isActivated()
468         isHuman()
469         isWithinLimits(msg.value)
470     {
471         // ensure game has not ended
472         require(round_[rID_].state < 3, "This round has ended.");
473 
474         // ensure game is in right state
475         if (round_[rID_].state == 0){
476             require(now >= round_[rID_].start, "This round hasn't started yet.");
477             round_[rID_].state = 1;
478         }
479 
480         // get player ID if not exists ,create new player
481         determinePID(msg.sender);
482         uint256 _pID = pIDxAddr_[msg.sender];
483         uint256 _tID;
484 
485         // manage affiliate residuals
486         // _affCode should be player name.
487         uint256 _affID;
488         if (_affCode == "" || _affCode == plyr_[_pID].name){
489             // use last stored affiliate code
490             _affID = plyr_[_pID].laff;
491         } else {
492             // get affiliate ID from aff Code
493             _affID = pIDxName_[_affCode];
494 
495             // if affID is not the same as previously stored
496             if (_affID != plyr_[_pID].laff){
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501 
502         // buy info
503         if (round_[rID_].state == 1){
504             // Check team id
505             _tID = determinTID(_team, _pID);
506 
507             // Buy
508             buyCore(_pID, _affID, _tID, msg.value);
509 
510             // if team number is more than minimum team number, then go the out state（state: 2）
511             if (round_[rID_].tID_ >= minTms_){
512                 // go the out state
513                 round_[rID_].state = 2;
514 
515                 // out initial
516                 startOut();
517             }
518 
519         } else if (round_[rID_].state == 2){
520             // if only 1 alive team, go end
521             if (round_[rID_].liveTeams == 1){
522                 endRound();
523 
524                 // pay back
525                 refund(_pID, msg.value);
526 
527                 return;
528             }
529 
530             // Check team id
531             _tID = determinTID(_team, _pID);
532 
533             // Buy
534             buyCore(_pID, _affID, _tID, msg.value);
535 
536             // Out if needed
537             if (now > round_[rID_].lastOutTime.add(OutGap_)) {
538                 out();
539             }
540         }
541     }
542 
543     /**
544      * @dev withdraws all of your earnings.
545      */
546     function withdraw()
547         public
548         isActivated()
549         isHuman()
550     {
551         // fetch player ID
552         uint256 _pID = pIDxAddr_[msg.sender];
553 
554         // ensure player is effective
555         require(_pID != 0, "Please join the game first!");
556 
557         // setup temp var for player eth
558         uint256 _eth;
559 
560         // calculate the remain amount that has not withdrawn
561         if (rID_ > 1){
562             for (uint256 i = 1; i < rID_; i++) {
563                 // if has not withdrawn, then withdraw
564                 if (plyrRnds_[_pID][i].withdrawn == false){
565                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
566                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
567                     }
568                     plyrRnds_[_pID][i].withdrawn = true;
569                 }
570             }
571         }
572 
573         _eth = _eth.add(plyr_[_pID].gen).add(plyr_[_pID].aff);
574 
575         // transfer the balance
576         if (_eth > 0) {
577             plyr_[_pID].addr.transfer(_eth);
578         }
579 
580         // clear
581         plyr_[_pID].gen = 0;
582         plyr_[_pID].aff = 0;
583 
584         // Event
585         emit onWithdrawEvent(_pID, plyr_[_pID].addr, plyr_[_pID].name, _eth, now);
586     }
587 
588     /**
589      * @dev use these to register names. UI will always display the last name you registered.
590      * but you will still own all previously registered names to use as affiliate links.
591      * - must pay a registration fee.
592      * - name must be unique
593      * - name cannot start or end with a space
594      * - cannot have more than 1 space in a row
595      * - cannot be only numbers
596      * - cannot start with 0x
597      * - name must be at least 1 char
598      * - max length of 32 characters long
599      * - allowed characters: a-z, 0-9, and space
600      * @param _nameString players desired name
601      */
602     function registerNameXID(string _nameString)
603         public
604         payable
605         isHuman()
606     {
607         // make sure name fees paid
608         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
609 
610         // filter name + condition checks
611         bytes32 _name = NameFilter.nameFilter(_nameString);
612 
613         // set up address
614         address _addr = msg.sender;
615 
616         // set up our tx event data and determine if player is new or not
617         // bool _isNewPlayer = determinePID(_addr);
618         bool _isNewPlayer = determinePID(_addr);
619 
620         // fetch player id
621         uint256 _pID = pIDxAddr_[_addr];
622 
623         // ensure the name is not used
624         require(pIDxName_[_name] == 0, "sorry that names already taken");
625 
626         // add name to player profile, registry, and name book
627         plyr_[_pID].name = _name;
628         pIDxName_[_name] = _pID;
629 
630         // deposit registration fee
631         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
632 
633         // Event
634         emit onNewNameEvent(_pID, _addr, _name, _isNewPlayer, msg.value, now);
635     }
636 
637     /**
638      * @dev use these to register a team names. UI will always display the last name you registered.
639      * - only team leader can call this func.
640      * - must pay a registration fee.
641      * - name must be unique
642      * - name cannot start or end with a space
643      * - cannot have more than 1 space in a row
644      * - cannot be only numbers
645      * - cannot start with 0x
646      * - name must be at least 1 char
647      * - max length of 32 characters long
648      * - allowed characters: a-z, 0-9, and space
649      */
650     function setTeamName(uint256 _tID, string _nameString)
651         public
652         payable
653         isHuman()
654     {
655         // team should be effective
656         require(_tID <= round_[rID_].tID_ && _tID != 0, "There's no this team.");
657 
658         // fetch player ID
659         uint256 _pID = pIDxAddr_[msg.sender];
660 
661         // must be team leader
662         require(_pID == rndTms_[rID_][_tID].leaderID, "Only team leader can change team name. You can invest more money to be the team leader.");
663 
664         // need register fee
665         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
666 
667         // filter name + condition checks
668         bytes32 _name = NameFilter.nameFilter(_nameString);
669 
670         require(rndTIDxName_[rID_][_name] == 0, "sorry that names already taken");
671 
672         // add name to team
673         rndTms_[rID_][_tID].name = _name;
674         rndTIDxName_[rID_][_name] = _tID;
675 
676         // deposit registration fee
677         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
678 
679         // event
680         emit onNewTeamNameEvent(_tID, _name, _pID, plyr_[_pID].name, msg.value, now);
681     }
682 
683     // deposit in the game
684     function deposit()
685         public
686         payable
687         isActivated()
688         isHuman()
689         isWithinLimits(msg.value)
690     {
691         determinePID(msg.sender);
692         uint256 _pID = pIDxAddr_[msg.sender];
693 
694         plyr_[_pID].gen = (msg.value).add(plyr_[_pID].gen);
695     }
696 
697     //**************
698     // GETTERS
699     //**************
700 
701     // check the name
702     function checkIfNameValid(string _nameStr)
703         public
704         view
705         returns (bool)
706     {
707         bytes32 _name = _nameStr.nameFilter();
708         if (pIDxName_[_name] == 0)
709             return (true);
710         else
711             return (false);
712     }
713 
714     /**
715      * @dev returns next out time
716      * @return next out time
717      */
718     function getNextOutAfter()
719         public
720         view
721         returns (uint256)
722     {
723         require(round_[rID_].state == 2, "Not in Out period.");
724 
725         uint256 _tNext = round_[rID_].lastOutTime.add(OutGap_);
726         uint256 _t = _tNext > now ? _tNext.sub(now) : 0;
727 
728         return _t;
729     }
730 
731     /**
732      * @dev returns player info based on address.  if no address is given, it will
733      * use msg.sender
734      * @param _addr address of the player you want to lookup
735      * @return player ID
736      * @return player name
737      * @return keys owned (current round)
738      * @return winnings vault
739      * @return general vault
740      * @return affiliate vault
741 	 * @return player round eth
742      */
743     function getPlayerInfoByAddress(address _addr)
744         public
745         view
746         returns(uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
747     {
748         if (_addr == address(0))
749         {
750             _addr == msg.sender;
751         }
752         uint256 _pID = pIDxAddr_[_addr];
753 
754         return (
755             _pID,
756             _addr,
757             plyr_[_pID].name,
758             plyr_[_pID].gen,
759             plyr_[_pID].aff,
760             plyrRnds_[_pID][rID_].eth,
761             getProfit(_pID),
762             getPreviousProfit(_pID)
763         );
764     }
765 
766     /**
767      * @dev returns _pID player for _tID team at _roundID round all keys
768      * - _roundID = 0 then _roundID = current round
769      * @return keys
770      */
771     function getPlayerRoundTeamBought(uint256 _pID, uint256 _roundID, uint256 _tID)
772         public
773         view
774         returns (uint256)
775     {
776         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
777         return plyrRnds_[_pID][_rID].plyrTmKeys[_tID];
778     }
779 
780     /**
781      * @dev returns _pID player at _roundID round all keys
782      * - _roundID = 0 then _roundID = current round
783      * @return array keysList
784      * - keysList[i] :team[i+1] for _pID
785      */
786     function getPlayerRoundBought(uint256 _pID, uint256 _roundID)
787         public
788         view
789         returns (uint256[])
790     {
791         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
792 
793         // team count
794         uint256 _tCount = round_[_rID].tID_;
795 
796         // keys for player in every team
797         uint256[] memory keysList = new uint256[](_tCount);
798 
799         for (uint i = 0; i < _tCount; i++) {
800             keysList[i] = plyrRnds_[_pID][_rID].plyrTmKeys[i+1];
801         }
802 
803         return keysList;
804     }
805 
806     /**
807      * @dev returns _pID player at every round all eths and winnings
808      * @return array {ethList, winList}
809      */
810     function getPlayerRounds(uint256 _pID)
811         public
812         view
813         returns (uint256[], uint256[])
814     {
815         uint256[] memory _ethList = new uint256[](rID_);
816         uint256[] memory _winList = new uint256[](rID_);
817         for (uint i=0; i < rID_; i++){
818             _ethList[i] = plyrRnds_[_pID][i+1].eth;
819             _winList[i] = plyrRnds_[_pID][i+1].plyrTmKeys[round_[i+1].team].mul(round_[i+1].ethPerKey) / 1000000000000000000;
820         }
821 
822         return (
823             _ethList,
824             _winList
825         );
826     }
827 
828     /**
829      * @dev returns last round info
830      * @return round ID
831      * @return round state
832      * @return round pots
833      * @return win team ID
834      * @return team name
835      * @return team player count
836      * @return team number
837      */
838     function getLastRoundInfo()
839         public
840         view
841         returns (uint256, uint256, uint256, uint256, bytes32, uint256, uint256)
842     {
843         // last round id
844         uint256 _rID = rID_.sub(1);
845 
846         // last winner
847         uint256 _tID = round_[_rID].team;
848 
849         return (
850             _rID,
851             round_[_rID].state,
852             round_[_rID].pot,
853             _tID,
854             rndTms_[_rID][_tID].name,
855             rndTms_[_rID][_tID].playersCount,
856             round_[_rID].tID_
857         );
858     }
859 
860     /**
861      * @dev returns all current round info needed for front end
862      * @return round id
863      * @return round state
864      * @return current eths
865      * @return current pot
866      * @return leader team ID
867      * @return current price per key
868      * @return the last out time
869      * @return time out gap
870      * @return current dead rate
871      * @return current dead keys
872      * @return alive teams
873      * @return team count
874      * @return time round started
875      */
876     function getCurrentRoundInfo()
877         public
878         view
879         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
880     {
881         return (
882             rID_,
883             round_[rID_].state,
884             round_[rID_].eth,
885             round_[rID_].pot,
886             round_[rID_].keys,
887             round_[rID_].team,
888             round_[rID_].ethPerKey,
889             round_[rID_].lastOutTime,
890             OutGap_,
891             round_[rID_].deadRate,
892             round_[rID_].deadKeys,
893             round_[rID_].liveTeams,
894             round_[rID_].tID_,
895             round_[rID_].start
896         );
897     }
898 
899     /**
900      * @dev returns _tID team info
901      * @return team id
902      * @return team name
903      * @return team all keys
904      * @return team all eths
905      * @return current price per key for this team
906      * @return leader player ID
907      * @return if team is out
908      */
909     function getTeamInfoByID(uint256 _tID)
910         public
911         view
912         returns (uint256, bytes32, uint256, uint256, uint256, uint256, bool)
913     {
914         require(_tID <= round_[rID_].tID_, "There's no this team.");
915 
916         return (
917             rndTms_[rID_][_tID].id,
918             rndTms_[rID_][_tID].name,
919             rndTms_[rID_][_tID].keys,
920             rndTms_[rID_][_tID].eth,
921             rndTms_[rID_][_tID].price,
922             rndTms_[rID_][_tID].leaderID,
923             rndTms_[rID_][_tID].dead
924         );
925     }
926 
927     /**
928      * @dev returns all team info
929      * @return array team ids
930      * @return array team names
931      * @return array team all keys
932      * @return array team all eths
933      * @return array current price per key for this team
934      * @return array team members
935      * @return array if team is out
936      */
937     function getTeamsInfo()
938         public
939         view
940         returns (uint256[], bytes32[], uint256[], uint256[], uint256[], uint256[], bool[])
941     {
942         uint256 _tID = round_[rID_].tID_;
943 
944         // Lists of Team Info
945         uint256[] memory _idList = new uint256[](_tID);
946         bytes32[] memory _nameList = new bytes32[](_tID);
947         uint256[] memory _keysList = new uint256[](_tID);
948         uint256[] memory _ethList = new uint256[](_tID);
949         uint256[] memory _priceList = new uint256[](_tID);
950         uint256[] memory _membersList = new uint256[](_tID);
951         bool[] memory _deadList = new bool[](_tID);
952 
953         // Data
954         for (uint i = 0; i < _tID; i++) {
955             _idList[i] = rndTms_[rID_][i+1].id;
956             _nameList[i] = rndTms_[rID_][i+1].name;
957             _keysList[i] = rndTms_[rID_][i+1].keys;
958             _ethList[i] = rndTms_[rID_][i+1].eth;
959             _priceList[i] = rndTms_[rID_][i+1].price;
960             _membersList[i] = rndTms_[rID_][i+1].playersCount;
961             _deadList[i] = rndTms_[rID_][i+1].dead;
962         }
963 
964         return (
965             _idList,
966             _nameList,
967             _keysList,
968             _ethList,
969             _priceList,
970             _membersList,
971             _deadList
972         );
973     }
974 
975     /**
976      * @dev returns all team leaders info
977      * @return array team ids
978      * @return array team leader ids
979      * @return array team leader names
980      * @return array team leader address
981      */
982     function getTeamLeaders()
983         public
984         view
985         returns (uint256[], uint256[], bytes32[], address[])
986     {
987         uint256 _tID = round_[rID_].tID_;
988 
989         // Teams' leaders info
990         uint256[] memory _idList = new uint256[](_tID);
991         uint256[] memory _leaderIDList = new uint256[](_tID);
992         bytes32[] memory _leaderNameList = new bytes32[](_tID);
993         address[] memory _leaderAddrList = new address[](_tID);
994 
995         // Data
996         for (uint i = 0; i < _tID; i++) {
997             _idList[i] = rndTms_[rID_][i+1].id;
998             _leaderIDList[i] = rndTms_[rID_][i+1].leaderID;
999             _leaderNameList[i] = plyr_[_leaderIDList[i]].name;
1000             _leaderAddrList[i] = rndTms_[rID_][i+1].leaderAddr;
1001         }
1002 
1003         return (
1004             _idList,
1005             _leaderIDList,
1006             _leaderNameList,
1007             _leaderAddrList
1008         );
1009     }
1010 
1011     /**
1012      * @dev returns predict the profit for the leader team
1013      * @return eth
1014      */
1015     function getProfit(uint256 _pID)
1016         public
1017         view
1018         returns (uint256)
1019     {
1020         // leader team ID
1021         uint256 _tID = round_[rID_].team;
1022 
1023         // if player not in the leader team
1024         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
1025             return 0;
1026         }
1027 
1028         // player's keys in the leader team
1029         uint256 _keys = plyrRnds_[_pID][rID_].plyrTmKeys[_tID];
1030 
1031         // calculate eth per key
1032         uint256 _ethPerKey = round_[rID_].pot.mul(1000000000000000000) / rndTms_[rID_][_tID].keys;
1033 
1034         // calculate the win value
1035         uint256 _value = _keys.mul(_ethPerKey) / 1000000000000000000;
1036 
1037         return _value;
1038     }
1039 
1040     /**
1041      * @dev returns the eths that has not withdrawn before current round
1042      * @return eth
1043      */
1044     function getPreviousProfit(uint256 _pID)
1045         public
1046         view
1047         returns (uint256)
1048     {
1049         uint256 _eth;
1050 
1051         if (rID_ > 1){
1052             // calculate the eth that has not withdrawn for the ended round
1053             for (uint256 i = 1; i < rID_; i++) {
1054                 if (plyrRnds_[_pID][i].withdrawn == false){
1055                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
1056                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
1057                     }
1058                 }
1059             }
1060         } else {
1061             // if there is not ended round
1062             _eth = 0;
1063         }
1064 
1065         return _eth;
1066     }
1067 
1068     /**
1069      * @dev returns the next key price for _tID team
1070      * @return eth
1071      */
1072     function getNextKeyPrice(uint256 _tID)
1073         public
1074         view
1075         returns(uint256)
1076     {
1077         require(_tID <= round_[rID_].tID_ && _tID != 0, "No this team.");
1078 
1079         return ( (rndTms_[rID_][_tID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1080     }
1081 
1082     /**
1083      * @dev returns the eth for buying _keys keys at _tID team
1084      * @return eth
1085      */
1086     function getEthFromKeys(uint256 _tID, uint256 _keys)
1087         public
1088         view
1089         returns(uint256)
1090     {
1091         if (_tID <= round_[rID_].tID_ && _tID != 0){
1092             // if team is exists
1093             return ((rndTms_[rID_][_tID].keys.add(_keys)).ethRec(_keys));
1094         } else {
1095             // if team is not exists
1096             return ((uint256(0).add(_keys)).ethRec(_keys));
1097         }
1098     }
1099 
1100     /**
1101      * @dev returns the keys for buying _eth eths at _tID team
1102      * @return keys
1103      */
1104     function getKeysFromEth(uint256 _tID, uint256 _eth)
1105         public
1106         view
1107         returns (uint256)
1108     {
1109         if (_tID <= round_[rID_].tID_ && _tID != 0){
1110             // if team is exists
1111             return (rndTms_[rID_][_tID].eth).keysRec(_eth);
1112         } else {
1113             // if team is not exists
1114             return (uint256(0).keysRec(_eth));
1115         }
1116     }
1117 
1118     // **************============
1119     //   PRIVATE: CORE GAME LOGIC
1120     // **************============
1121 
1122     /**
1123      * @dev logic runs whenever a buy order is executed.  determines how to handle
1124      * incoming eth depending on if we are in an active round or not
1125      */
1126     function buyCore(uint256 _pID, uint256 _affID, uint256 _tID, uint256 _eth)
1127         private
1128     {
1129         uint256 _keys = (rndTms_[rID_][_tID].eth).keysRec(_eth);
1130 
1131         // player
1132         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
1133             rndTms_[rID_][_tID].playersCount++;
1134         }
1135         plyrRnds_[_pID][rID_].plyrTmKeys[_tID] = _keys.add(plyrRnds_[_pID][rID_].plyrTmKeys[_tID]);
1136         plyrRnds_[_pID][rID_].eth = _eth.add(plyrRnds_[_pID][rID_].eth);
1137 
1138         // Team
1139         rndTms_[rID_][_tID].keys = _keys.add(rndTms_[rID_][_tID].keys);
1140         rndTms_[rID_][_tID].eth = _eth.add(rndTms_[rID_][_tID].eth);
1141         rndTms_[rID_][_tID].price = _eth.mul(1000000000000000000) / _keys;
1142         uint256 _teamLeaderID = rndTms_[rID_][_tID].leaderID;
1143         // refresh team leader
1144         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] > plyrRnds_[_teamLeaderID][rID_].plyrTmKeys[_tID]){
1145             rndTms_[rID_][_tID].leaderID = _pID;
1146             rndTms_[rID_][_tID].leaderAddr = msg.sender;
1147         }
1148 
1149         // Round
1150         round_[rID_].keys = _keys.add(round_[rID_].keys);
1151         round_[rID_].eth = _eth.add(round_[rID_].eth);
1152         // refresh round leader
1153         if (rndTms_[rID_][_tID].keys > rndTms_[rID_][round_[rID_].team].keys){
1154             round_[rID_].team = _tID;
1155         }
1156 
1157         distribute(rID_, _pID, _eth, _affID);
1158 
1159         // Event
1160         emit onTxEvent(_pID, msg.sender, plyr_[_pID].name, _tID, rndTms_[rID_][_tID].name, _eth, _keys);
1161     }
1162 
1163     // distribute eth
1164     function distribute(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1165         private
1166     {
1167         // [1] com - 3%
1168         uint256 _com = (_eth.mul(3)) / 100;
1169 
1170         // pay community reward
1171         plyr_[1].gen = _com.add(plyr_[1].gen);
1172 
1173         // [2] aff - 10%
1174         uint256 _aff = _eth / 10;
1175 
1176         if (_affID != _pID && plyr_[_affID].name != "") {
1177             // pay aff
1178             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1179 
1180             // Event bonus for invite
1181             emit onAffPayoutEvent(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1182         } else {
1183             // if not affiliate, this amount of eth add to the pot
1184             _aff = 0;
1185         }
1186 
1187         // [3] pot - 87%
1188         uint256 _pot = _eth.sub(_aff).sub(_com);
1189 
1190         // update current pot
1191         round_[_rID].pot = _pot.add(round_[_rID].pot);
1192     }
1193 
1194     /**
1195      * @dev ends the round. manages paying out winner/splitting up pot
1196      */
1197     function endRound()
1198         private
1199     {
1200         require(round_[rID_].state < 3, "Round only end once.");
1201 
1202         // set round state
1203         round_[rID_].state = 3;
1204 
1205         // all pot
1206         uint256 _pot = round_[rID_].pot;
1207 
1208         // Devide Round Pot
1209         // [1] winner 85%
1210         uint256 _win = (_pot.mul(85))/100;
1211 
1212         // [2] com 5%
1213         uint256 _com = (_pot.mul(5))/100;
1214 
1215         // [3] next round 10%
1216         uint256 _res = (_pot.sub(_win)).sub(_com);
1217 
1218         // win team
1219         uint256 _tID = round_[rID_].team;
1220         // ethPerKey (A Full Key = 10**18 keys)
1221         uint256 _epk = (_win.mul(1000000000000000000)) / (rndTms_[rID_][_tID].keys);
1222 
1223         // if dust
1224         uint256 _dust = _win.sub((_epk.mul(rndTms_[rID_][_tID].keys)) / 1000000000000000000);
1225         if (_dust > 0) {
1226             _win = _win.sub(_dust);
1227             _res = _res.add(_dust);
1228         }
1229 
1230         // pay winner team
1231         round_[rID_].ethPerKey = _epk;
1232 
1233         // pay community reward
1234         plyr_[1].gen = _com.add(plyr_[1].gen);
1235 
1236         // Event
1237         emit onEndRoundEvent(_tID, rndTms_[rID_][_tID].name, rndTms_[rID_][_tID].playersCount, _pot);
1238 
1239         // next round
1240         rID_++;
1241         round_[rID_].pot = _res;
1242         round_[rID_].start = now + roundGap_;
1243     }
1244 
1245     // refund
1246     function refund(uint256 _pID, uint256 _value)
1247         private
1248     {
1249         plyr_[_pID].gen = _value.add(plyr_[_pID].gen);
1250     }
1251 
1252     /**
1253      * @dev create a new team
1254      * @return team ID
1255      */
1256     function createTeam(uint256 _pID, uint256 _eth)
1257         private
1258         returns (uint256)
1259     {
1260         // maximum team number limit
1261         require(round_[rID_].tID_ < maxTms_, "The number of teams has reached the maximum limit.");
1262 
1263         // payable should more than 1eth
1264         require(_eth >= 1000000000000000000, "You need at least 1 eth to create a team, though creating a new team is free.");
1265 
1266         // update data
1267         round_[rID_].tID_++;
1268         round_[rID_].liveTeams++;
1269 
1270         // new team ID
1271         uint256 _tID = round_[rID_].tID_;
1272 
1273         // new team data
1274         rndTms_[rID_][_tID].id = _tID;
1275         rndTms_[rID_][_tID].leaderID = _pID;
1276         rndTms_[rID_][_tID].leaderAddr = plyr_[_pID].addr;
1277         rndTms_[rID_][_tID].dead = false;
1278 
1279         return _tID;
1280     }
1281 
1282     // initial the out state
1283     function startOut()
1284         private
1285     {
1286         round_[rID_].lastOutTime = now;
1287         round_[rID_].deadRate = 10;     // used by deadRate / 100
1288         round_[rID_].deadKeys = (rndTms_[rID_][round_[rID_].team].keys.mul(round_[rID_].deadRate)) / 100;
1289         emit onOutInitialEvent(round_[rID_].lastOutTime);
1290     }
1291 
1292     // emit out
1293     function out()
1294         private
1295     {
1296         // current state dead number of the teams
1297         uint256 _dead = 0;
1298 
1299         // if less than deadKeys ,sorry, your team is out
1300         for (uint256 i = 1; i <= round_[rID_].tID_; i++) {
1301             if (rndTms_[rID_][i].keys < round_[rID_].deadKeys && rndTms_[rID_][i].dead == false){
1302                 rndTms_[rID_][i].dead = true;
1303                 round_[rID_].liveTeams--;
1304                 _dead++;
1305             }
1306         }
1307 
1308         round_[rID_].lastOutTime = now;
1309 
1310         // if there just 1 alive team
1311         if (round_[rID_].liveTeams == 1 && round_[rID_].state == 2) {
1312             endRound();
1313             return;
1314         }
1315 
1316         // update the deadRate
1317         if (round_[rID_].deadRate < 90) {
1318             round_[rID_].deadRate = round_[rID_].deadRate + 10;
1319         }
1320 
1321         // update deadKeys
1322         round_[rID_].deadKeys = ((rndTms_[rID_][round_[rID_].team].keys).mul(round_[rID_].deadRate)) / 100;
1323 
1324         // event
1325         emit onOutInitialEvent(round_[rID_].lastOutTime);
1326         emit onOutEvent(_dead, round_[rID_].liveTeams, round_[rID_].deadKeys);
1327     }
1328 
1329     /**
1330      * @dev gets existing or registers new pID.  use this when a player may be new
1331      * @return bool if a new player
1332      */
1333     function determinePID(address _addr)
1334         private
1335         returns (bool)
1336     {
1337         if (pIDxAddr_[_addr] == 0)
1338         {
1339             pID_++;
1340             pIDxAddr_[_addr] = pID_;
1341             plyr_[pID_].addr = _addr;
1342 
1343             return (true);  // new
1344         } else {
1345             return (false);
1346         }
1347     }
1348 
1349     /**
1350      * @dev gets existing a team.  if not, create a new team
1351      * @return team ID
1352      */
1353     function determinTID(uint256 _team, uint256 _pID)
1354         private
1355         returns (uint256)
1356     {
1357         // ensure the team is alive
1358         require(rndTms_[rID_][_team].dead == false, "You can not buy a dead team!");
1359 
1360         if (_team <= round_[rID_].tID_ && _team > 0) {
1361             // if team is existing
1362             return _team;
1363         } else {
1364             // if team is not existing
1365             return createTeam(_pID, msg.value);
1366         }
1367     }
1368 
1369     //**************
1370     // SECURITY
1371     //**************
1372 
1373     // active the game
1374     bool public activated_ = false;
1375     function activate()
1376         public
1377         onlyOwner()
1378     {
1379         // can only be ran once
1380         require(activated_ == false, "it is already activated");
1381 
1382         // activate the contract
1383         activated_ = true;
1384 
1385         // the first player
1386         plyr_[1].addr = cooperator;
1387         plyr_[1].name = "imkg";
1388         pIDxAddr_[cooperator] = 1;
1389         pIDxName_["imkg"] = 1;
1390         pID_ = 1;
1391 
1392         // activate the first game
1393         rID_ = 1;
1394         round_[1].start = now;
1395         round_[1].state = 1;
1396     }
1397 
1398     //****************************
1399     // SETTINGS (Only owner)
1400     //****************************
1401 
1402     /*
1403       * @dev if timing is up,then msg.sender go this func to end or out this game.
1404       */
1405       function timeCountdown()
1406           public
1407           isActivated()
1408           isHuman()
1409           onlyOwner()
1410       {
1411           //state == 2  out state
1412           if (round_[rID_].state == 2){
1413               // if alive team = 1, go endRound().
1414               if (round_[rID_].liveTeams == 1){
1415 
1416                   endRound();
1417                   return;
1418               }
1419 
1420               // Out if needed
1421               if (now > round_[rID_].lastOutTime.add(OutGap_)) {
1422                   out();
1423               }
1424           }
1425       }
1426 
1427 
1428     // set the minimum team number
1429     function setMinTms(uint256 _tms)
1430         public
1431         onlyOwner()
1432     {
1433         minTms_ = _tms;
1434     }
1435 
1436     // set the maximum team number
1437     function setMaxTms(uint256 _tms)
1438         public
1439         onlyOwner()
1440     {
1441         maxTms_ = _tms;
1442     }
1443 
1444     // set the round gap
1445     function setRoundGap(uint256 _gap)
1446         public
1447         onlyOwner()
1448     {
1449         roundGap_ = _gap;
1450     }
1451 
1452     // set the out gap
1453     function setOutGap(uint256 _gap)
1454         public
1455         onlyOwner()
1456     {
1457         OutGap_ = _gap;
1458     }
1459 
1460 }   // main contract ends here