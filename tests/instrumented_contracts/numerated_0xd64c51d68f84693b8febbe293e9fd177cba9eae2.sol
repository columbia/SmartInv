1 pragma solidity ^0.4.24;
2 
3 library NameFilter {
4     /**
5      * @dev filters name strings
6      * -converts uppercase to lower case.
7      * -makes sure it does not start/end with a space
8      * -makes sure it does not contain multiple spaces in a row
9      * -cannot be only numbers
10      * -cannot start with 0x
11      * -restricts characters to A-Z, a-z, 0-9, and space.
12      * @return reprocessed string in bytes32 format
13      */
14     function nameFilter(string _input)
15         internal
16         pure
17         returns(bytes32)
18     {
19         bytes memory _temp = bytes(_input);
20         uint256 _length = _temp.length;
21 
22         //sorry limited to 32 characters
23         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
24         // make sure it doesnt start with or end with space
25         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
26         // make sure first two characters are not 0x
27         if (_temp[0] == 0x30)
28         {
29             require(_temp[1] != 0x78, "string cannot start with 0x");
30             require(_temp[1] != 0x58, "string cannot start with 0X");
31         }
32 
33         // create a bool to track if we have a non number character
34         bool _hasNonNumber;
35 
36         // convert & check
37         for (uint256 i = 0; i < _length; i++)
38         {
39             // if its uppercase A-Z
40             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
41             {
42                 // convert to lower case a-z
43                 _temp[i] = byte(uint(_temp[i]) + 32);
44 
45                 // we have a non number
46                 if (_hasNonNumber == false)
47                     _hasNonNumber = true;
48             } else {
49                 require
50                 (
51                     // require character is a space
52                     _temp[i] == 0x20 ||
53                     // OR lowercase a-z
54                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
55                     // or 0-9
56                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
57                     "string contains invalid characters"
58                 );
59                 // make sure theres not 2x spaces in a row
60                 if (_temp[i] == 0x20)
61                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
62 
63                 // see if we have a character other than a number
64                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
65                     _hasNonNumber = true;
66             }
67         }
68 
69         require(_hasNonNumber == true, "string cannot be only numbers");
70 
71         bytes32 _ret;
72         assembly {
73             _ret := mload(add(_temp, 32))
74         }
75         return (_ret);
76     }
77 }
78 
79 /**
80  * @title SafeMath v0.1.9
81  * @dev Math operations with safety checks that throw on error
82  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
83  * - added sqrt
84  * - added sq
85  * - added pwr
86  * - changed asserts to requires with error log outputs
87  * - removed div, its useless
88  */
89 library SafeMath {
90 
91     /**
92     * @dev Multiplies two numbers, throws on overflow.
93     */
94     function mul(uint256 a, uint256 b)
95         internal
96         pure
97         returns (uint256 c)
98     {
99         if (a == 0) {
100             return 0;
101         }
102         c = a * b;
103         require(c / a == b, "SafeMath mul failed");
104         return c;
105     }
106 
107     /**
108     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109     */
110     function sub(uint256 a, uint256 b)
111         internal
112         pure
113         returns (uint256)
114     {
115         require(b <= a, "SafeMath sub failed");
116         return a - b;
117     }
118 
119     /**
120     * @dev Adds two numbers, throws on overflow.
121     */
122     function add(uint256 a, uint256 b)
123         internal
124         pure
125         returns (uint256 c)
126     {
127         c = a + b;
128         require(c >= a, "SafeMath add failed");
129         return c;
130     }
131 
132     /**
133      * @dev gives square root of given x.
134      */
135     function sqrt(uint256 x)
136         internal
137         pure
138         returns (uint256 y)
139     {
140         uint256 z = ((add(x,1)) / 2);
141         y = x;
142         while (z < y)
143         {
144             y = z;
145             z = ((add((x / z),z)) / 2);
146         }
147     }
148 
149     /**
150      * @dev gives square. multiplies x by x
151      */
152     function sq(uint256 x)
153         internal
154         pure
155         returns (uint256)
156     {
157         return (mul(x,x));
158     }
159 
160     /**
161      * @dev x to the power of y
162      */
163     function pwr(uint256 x, uint256 y)
164         internal
165         pure
166         returns (uint256)
167     {
168         if (x==0)
169             return (0);
170         else if (y==0)
171             return (1);
172         else
173         {
174             uint256 z = x;
175             for (uint256 i=1; i < y; i++)
176                 z = mul(z,x);
177             return (z);
178         }
179     }
180 }
181 
182 
183 interface PlayerBookReceiverInterface {
184     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
185     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
186 }
187 
188 
189 contract PlayerBook {
190     using NameFilter for string;
191     using SafeMath for uint256;
192 
193     address private admin = msg.sender;
194 //==============================================================================
195 //     _| _ _|_ _    _ _ _|_    _   .
196 //    (_|(_| | (_|  _\(/_ | |_||_)  .
197 //=============================|================================================
198     // price to register a name 解读: 10  finney = 0.01 ETH, 1 ether == 1000 finney
199     uint256 public registrationFee_ = 10 finney;
200     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
201     mapping(address => bytes32) public gameNames_;          // lookup a games name
202     mapping(address => uint256) public gameIDs_;            // lokup a games ID
203     uint256 public gID_;        // total number of games
204     uint256 public pID_;        // total number of players
205     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
206     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
207     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
208     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
209     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
210     struct Player {
211         address addr;
212         bytes32 name;
213         uint256 laff;
214         uint256 names;
215     }
216 //==============================================================================
217 //     _ _  _  __|_ _    __|_ _  _  .
218 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
219 //==============================================================================
220     constructor()
221         public
222     {
223         // premine the dev names (sorry not sorry)
224             // No keys are purchased with this method, it's simply locking our addresses,
225             // PID's and names for referral codes.
226         plyr_[1].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
227         plyr_[1].name = "justo";
228         plyr_[1].names = 1;
229         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 1;
230         pIDxName_["justo"] = 1;
231         plyrNames_[1]["justo"] = true;
232         plyrNameList_[1][1] = "justo";
233 
234         plyr_[2].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
235         plyr_[2].name = "mantso";
236         plyr_[2].names = 1;
237         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 2;
238         pIDxName_["mantso"] = 2;
239         plyrNames_[2]["mantso"] = true;
240         plyrNameList_[2][1] = "mantso";
241 
242         plyr_[3].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
243         plyr_[3].name = "sumpunk";
244         plyr_[3].names = 1;
245         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 3;
246         pIDxName_["sumpunk"] = 3;
247         plyrNames_[3]["sumpunk"] = true;
248         plyrNameList_[3][1] = "sumpunk";
249 
250         plyr_[4].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
251         plyr_[4].name = "inventor";
252         plyr_[4].names = 1;
253         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 4;
254         pIDxName_["inventor"] = 4;
255         plyrNames_[4]["inventor"] = true;
256         plyrNameList_[4][1] = "inventor";
257 
258         //Total number of players
259         pID_ = 4;
260     }
261 //==============================================================================
262 //     _ _  _  _|. |`. _  _ _  .
263 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
264 //==============================================================================
265     /**
266      * @dev prevents contracts from interacting with fomo3d 解读: 判断是否是合约
267      */
268     modifier isHuman() {
269         address _addr = msg.sender;
270         uint256 _codeLength;
271 
272         assembly {_codeLength := extcodesize(_addr)}
273         require(_codeLength == 0, "sorry humans only");
274         _;
275     }
276 
277 
278     modifier isRegisteredGame()
279     {
280         require(gameIDs_[msg.sender] != 0);
281         _;
282     }
283 //==============================================================================
284 //     _    _  _ _|_ _  .
285 //    (/_\/(/_| | | _\  .
286 //==============================================================================
287     // fired whenever a player registers a name
288     event onNewName
289     (
290         uint256 indexed playerID,
291         address indexed playerAddress,
292         bytes32 indexed playerName,
293         bool isNewPlayer,
294         uint256 affiliateID,
295         address affiliateAddress,
296         bytes32 affiliateName,
297         uint256 amountPaid,
298         uint256 timeStamp
299     );
300 //==============================================================================
301 //     _  _ _|__|_ _  _ _  .
302 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
303 //=====_|=======================================================================
304     function checkIfNameValid(string _nameStr)
305         public
306         view
307         returns(bool)
308     {
309         bytes32 _name = _nameStr.nameFilter();
310         if (pIDxName_[_name] == 0)
311             return (true);
312         else
313             return (false);
314     }
315 //==============================================================================
316 //     _    |_ |. _   |`    _  __|_. _  _  _  .
317 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
318 //====|=========================================================================
319     /**
320      * @dev registers a name.  UI will always display the last name you registered.
321      * but you will still own all previously registered names to use as affiliate
322      * links.
323      * - must pay a registration fee.
324      * - name must be unique
325      * - names will be converted to lowercase
326      * - name cannot start or end with a space
327      * - cannot have more than 1 space in a row
328      * - cannot be only numbers
329      * - cannot start with 0x
330      * - name must be at least 1 char
331      * - max length of 32 characters long
332      * - allowed characters: a-z, 0-9, and space
333      * -functionhash- 0x921dec21 (using ID for affiliate)
334      * -functionhash- 0x3ddd4698 (using address for affiliate)
335      * -functionhash- 0x685ffd83 (using name for affiliate)
336      * @param _nameString players desired name
337      * @param _affCode affiliate ID, address, or name of who refered you
338      * @param _all set to true if you want this to push your info to all games
339      * (this might cost a lot of gas)
340      */
341     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
342         isHuman()
343         public
344         payable
345     {
346         // make sure name fees paid
347         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
348 
349         // filter name + condition checks
350         bytes32 _name = NameFilter.nameFilter(_nameString);
351 
352         // set up address
353         address _addr = msg.sender;
354 
355         // set up our tx event data and determine if player is new or not
356         bool _isNewPlayer = determinePID(_addr);
357 
358         // fetch player id
359         uint256 _pID = pIDxAddr_[_addr];
360 
361         // manage affiliate residuals
362         // if no affiliate code was given, no new affiliate code was given, or the
363         // player tried to use their own pID as an affiliate code, lolz
364         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
365         {
366             // update last affiliate
367             plyr_[_pID].laff = _affCode;
368         } else if (_affCode == _pID) {
369             _affCode = 0;
370         }
371 
372         // register name
373         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
374     }
375 
376     function registerNameXaddr(string _nameString, address _affCode, bool _all)
377         isHuman()
378         public
379         payable
380     {
381         // make sure name fees paid
382         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
383 
384         // filter name + condition checks
385         bytes32 _name = NameFilter.nameFilter(_nameString);
386 
387         // set up address
388         address _addr = msg.sender;
389 
390         // set up our tx event data and determine if player is new or not
391         bool _isNewPlayer = determinePID(_addr);
392 
393         // fetch player id
394         uint256 _pID = pIDxAddr_[_addr];
395 
396         // manage affiliate residuals
397         // if no affiliate code was given or player tried to use their own, lolz
398         uint256 _affID;
399         if (_affCode != address(0) && _affCode != _addr)
400         {
401             // get affiliate ID from aff Code
402             _affID = pIDxAddr_[_affCode];
403 
404             // if affID is not the same as previously stored
405             if (_affID != plyr_[_pID].laff)
406             {
407                 // update last affiliate
408                 plyr_[_pID].laff = _affID;
409             }
410         }
411 
412         // register name
413         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
414     }
415 
416     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
417         isHuman()
418         public
419         payable
420     {
421         // make sure name fees paid
422         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
423 
424         // filter name + condition checks
425         bytes32 _name = NameFilter.nameFilter(_nameString);
426 
427         // set up address
428         address _addr = msg.sender;
429 
430         // set up our tx event data and determine if player is new or not
431         bool _isNewPlayer = determinePID(_addr);
432 
433         // fetch player id
434         uint256 _pID = pIDxAddr_[_addr];
435 
436         // manage affiliate residuals
437         // if no affiliate code was given or player tried to use their own, lolz
438         uint256 _affID;
439         if (_affCode != "" && _affCode != _name)
440         {
441             // get affiliate ID from aff Code
442             _affID = pIDxName_[_affCode];
443 
444             // if affID is not the same as previously stored
445             if (_affID != plyr_[_pID].laff)
446             {
447                 // update last affiliate
448                 plyr_[_pID].laff = _affID;
449             }
450         }
451 
452         // register name
453         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
454     }
455 
456     /**
457      * @dev players, if you registered a profile, before a game was released, or
458      * set the all bool to false when you registered, use this function to push
459      * your profile to a single game.  also, if you've  updated your name, you
460      * can use this to push your name to games of your choosing.
461      * -functionhash- 0x81c5b206
462      * @param _gameID game id
463      */
464     function addMeToGame(uint256 _gameID)
465         isHuman()
466         public
467     {
468         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
469         address _addr = msg.sender;
470         uint256 _pID = pIDxAddr_[_addr];
471         require(_pID != 0, "hey there buddy, you dont even have an account");
472         uint256 _totalNames = plyr_[_pID].names;
473 
474         // add players profile and most recent name
475         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
476 
477         // add list of all names
478         if (_totalNames > 1)
479             for (uint256 ii = 1; ii <= _totalNames; ii++)
480                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
481     }
482 
483     /**
484      * @dev players, use this to push your player profile to all registered games.
485      * -functionhash- 0x0c6940ea
486      */
487     function addMeToAllGames()
488         isHuman()
489         public
490     {
491         address _addr = msg.sender;
492         uint256 _pID = pIDxAddr_[_addr];
493         require(_pID != 0, "hey there buddy, you dont even have an account");
494         uint256 _laff = plyr_[_pID].laff;
495         uint256 _totalNames = plyr_[_pID].names;
496         bytes32 _name = plyr_[_pID].name;
497 
498         for (uint256 i = 1; i <= gID_; i++)
499         {
500             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
501             if (_totalNames > 1)
502                 for (uint256 ii = 1; ii <= _totalNames; ii++)
503                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
504         }
505 
506     }
507 
508     /**
509      * @dev players use this to change back to one of your old names.  tip, you'll
510      * still need to push that info to existing games.
511      * -functionhash- 0xb9291296
512      * @param _nameString the name you want to use
513      */
514     function useMyOldName(string _nameString)
515         isHuman()
516         public
517     {
518         // filter name, and get pID
519         bytes32 _name = _nameString.nameFilter();
520         uint256 _pID = pIDxAddr_[msg.sender];
521 
522         // make sure they own the name
523         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
524 
525         // update their current name
526         plyr_[_pID].name = _name;
527     }
528 
529 //==============================================================================
530 //     _ _  _ _   | _  _ . _  .
531 //    (_(_)| (/_  |(_)(_||(_  .
532 //=====================_|=======================================================
533     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
534         private
535     {
536         // if names already has been used, require that current msg sender owns the name
537         if (pIDxName_[_name] != 0)
538             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
539 
540         // add name to player profile, registry, and name book
541         plyr_[_pID].name = _name;
542         pIDxName_[_name] = _pID;
543         if (plyrNames_[_pID][_name] == false)
544         {
545             plyrNames_[_pID][_name] = true;
546             plyr_[_pID].names++;
547             plyrNameList_[_pID][plyr_[_pID].names] = _name;
548         }
549 
550         // registration fee goes directly to community rewards
551         admin.transfer(address(this).balance);
552 
553         // push player info to games
554         if (_all == true)
555             for (uint256 i = 1; i <= gID_; i++)
556                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
557 
558         // fire event
559         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
560     }
561 //==============================================================================
562 //    _|_ _  _ | _  .
563 //     | (_)(_)|_\  .
564 //==============================================================================
565     function determinePID(address _addr)
566         private
567         returns (bool)
568     {
569         if (pIDxAddr_[_addr] == 0)
570         {
571             pID_++;
572             pIDxAddr_[_addr] = pID_;
573             plyr_[pID_].addr = _addr;
574 
575             // set the new player bool to true
576             return (true);
577         } else {
578             return (false);
579         }
580     }
581 //==============================================================================
582 //   _   _|_ _  _ _  _ |   _ _ || _  .
583 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
584 //==============================================================================
585     function getPlayerID(address _addr)
586         isRegisteredGame()
587         external
588         returns (uint256)
589     {
590         determinePID(_addr);
591         return (pIDxAddr_[_addr]);
592     }
593     function getPlayerName(uint256 _pID)
594         external
595         view
596         returns (bytes32)
597     {
598         return (plyr_[_pID].name);
599     }
600     function getPlayerLAff(uint256 _pID)
601         external
602         view
603         returns (uint256)
604     {
605         return (plyr_[_pID].laff);
606     }
607     function getPlayerAddr(uint256 _pID)
608         external
609         view
610         returns (address)
611     {
612         return (plyr_[_pID].addr);
613     }
614     function getNameFee()
615         external
616         view
617         returns (uint256)
618     {
619         return(registrationFee_);
620     }
621     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
622         isRegisteredGame()
623         external
624         payable
625         returns(bool, uint256)
626     {
627         // make sure name fees paid
628         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
629 
630         // set up our tx event data and determine if player is new or not
631         bool _isNewPlayer = determinePID(_addr);
632 
633         // fetch player id
634         uint256 _pID = pIDxAddr_[_addr];
635 
636         // manage affiliate residuals
637         // if no affiliate code was given, no new affiliate code was given, or the
638         // player tried to use their own pID as an affiliate code, lolz
639         uint256 _affID = _affCode;
640         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
641         {
642             // update last affiliate
643             plyr_[_pID].laff = _affID;
644         } else if (_affID == _pID) {
645             _affID = 0;
646         }
647 
648         // register name
649         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
650 
651         return(_isNewPlayer, _affID);
652     }
653     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
654         isRegisteredGame()
655         external
656         payable
657         returns(bool, uint256)
658     {
659         // make sure name fees paid
660         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
661 
662         // set up our tx event data and determine if player is new or not
663         bool _isNewPlayer = determinePID(_addr);
664 
665         // fetch player id
666         uint256 _pID = pIDxAddr_[_addr];
667 
668         // manage affiliate residuals
669         // if no affiliate code was given or player tried to use their own, lolz
670         uint256 _affID;
671         if (_affCode != address(0) && _affCode != _addr)
672         {
673             // get affiliate ID from aff Code
674             _affID = pIDxAddr_[_affCode];
675 
676             // if affID is not the same as previously stored
677             if (_affID != plyr_[_pID].laff)
678             {
679                 // update last affiliate
680                 plyr_[_pID].laff = _affID;
681             }
682         }
683 
684         // register name
685         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
686 
687         return(_isNewPlayer, _affID);
688     }
689     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
690         isRegisteredGame()
691         external
692         payable
693         returns(bool, uint256)
694     {
695         // make sure name fees paid
696         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
697 
698         // set up our tx event data and determine if player is new or not
699         bool _isNewPlayer = determinePID(_addr);
700 
701         // fetch player id
702         uint256 _pID = pIDxAddr_[_addr];
703 
704         // manage affiliate residuals
705         // if no affiliate code was given or player tried to use their own, lolz
706         uint256 _affID;
707         if (_affCode != "" && _affCode != _name)
708         {
709             // get affiliate ID from aff Code
710             _affID = pIDxName_[_affCode];
711 
712             // if affID is not the same as previously stored
713             if (_affID != plyr_[_pID].laff)
714             {
715                 // update last affiliate
716                 plyr_[_pID].laff = _affID;
717             }
718         }
719 
720         // register name
721         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
722 
723         return(_isNewPlayer, _affID);
724     }
725 
726 //==============================================================================
727 //   _ _ _|_    _   .
728 //  _\(/_ | |_||_)  .
729 //=============|================================================================
730     function addGame(address _gameAddress, string _gameNameStr)
731         public
732     {
733         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
734             gID_++;
735             bytes32 _name = _gameNameStr.nameFilter();
736             gameIDs_[_gameAddress] = gID_;
737             gameNames_[_gameAddress] = _name;
738             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
739 
740             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
741             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
742             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
743             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
744     }
745 
746     function setRegistrationFee(uint256 _fee)
747         public
748     {
749       registrationFee_ = _fee;
750     }
751 
752 }