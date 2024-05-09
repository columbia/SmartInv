1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
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
21     /**
22     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23     */
24     function sub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256)
28     {
29         require(b <= a, "SafeMath sub failed");
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256 c)
40     {
41         c = a + b;
42         require(c >= a, "SafeMath add failed");
43         return c;
44     }
45 
46     /**
47      * @dev gives square root of given x.
48      */
49     function sqrt(uint256 x)
50         internal
51         pure
52         returns (uint256 y)
53     {
54         uint256 z = ((add(x,1)) / 2);
55         y = x;
56         while (z < y)
57         {
58             y = z;
59             z = ((add((x / z),z)) / 2);
60         }
61     }
62 
63     /**
64      * @dev gives square. multiplies x by x
65      */
66     function sq(uint256 x)
67         internal
68         pure
69         returns (uint256)
70     {
71         return (mul(x,x));
72     }
73 
74     /**
75      * @dev x to the power of y
76      */
77     function pwr(uint256 x, uint256 y)
78         internal
79         pure
80         returns (uint256)
81     {
82         if (x==0)
83             return (0);
84         else if (y==0)
85             return (1);
86         else
87         {
88             uint256 z = x;
89             for (uint256 i=1; i < y; i++)
90                 z = mul(z,x);
91             return (z);
92         }
93     }
94 }
95 
96 library NameFilter {
97     /**
98      * @dev filters name strings
99      * -converts uppercase to lower case.
100      * -makes sure it does not start/end with a space
101      * -makes sure it does not contain multiple spaces in a row
102      * -cannot be only numbers
103      * -cannot start with 0x
104      * -restricts characters to A-Z, a-z, 0-9, and space.
105      * @return reprocessed string in bytes32 format
106      */
107     function nameFilter(string _input)
108         internal
109         pure
110         returns(bytes32)
111     {
112         bytes memory _temp = bytes(_input);
113         uint256 _length = _temp.length;
114 
115         //sorry limited to 32 characters
116         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
117         // make sure it doesnt start with or end with space
118         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
119         // make sure first two characters are not 0x
120         if (_temp[0] == 0x30)
121         {
122             require(_temp[1] != 0x78, "string cannot start with 0x");
123             require(_temp[1] != 0x58, "string cannot start with 0X");
124         }
125 
126         // create a bool to track if we have a non number character
127         bool _hasNonNumber;
128 
129         // convert & check
130         for (uint256 i = 0; i < _length; i++)
131         {
132             // if its uppercase A-Z
133             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
134             {
135                 // convert to lower case a-z
136                 _temp[i] = byte(uint(_temp[i]) + 32);
137 
138                 // we have a non number
139                 if (_hasNonNumber == false)
140                     _hasNonNumber = true;
141             } else {
142                 require
143                 (
144                     // require character is a space
145                     _temp[i] == 0x20 ||
146                     // OR lowercase a-z
147                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
148                     // or 0-9
149                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
150                     "string contains invalid characters"
151                 );
152                 // make sure theres not 2x spaces in a row
153                 if (_temp[i] == 0x20)
154                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
155 
156                 // see if we have a character other than a number
157                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
158                     _hasNonNumber = true;
159             }
160         }
161 
162         require(_hasNonNumber == true, "string cannot be only numbers");
163 
164         bytes32 _ret;
165         assembly {
166             _ret := mload(add(_temp, 32))
167         }
168         return (_ret);
169     }
170 }
171 
172 /**
173  * @title SafeMath v0.1.9
174  * @dev Math operations with safety checks that throw on error
175  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
176  * - added sqrt
177  * - added sq
178  * - added pwr
179  * - changed asserts to requires with error log outputs
180  * - removed div, its useless
181  */
182 
183 
184 interface PlayerBookReceiverInterface {
185     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
186     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
187 }
188 
189 
190 contract PlayerBook {
191     using NameFilter for string;
192     using SafeMath for uint256;
193 
194     address private admin = msg.sender;
195 //==============================================================================
196 //     _| _ _|_ _    _ _ _|_    _   .
197 //    (_|(_| | (_|  _\(/_ | |_||_)  .
198 //=============================|================================================
199     uint256 public registrationFee_ = 10 finney;            // price to register a name
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
226         plyr_[1].addr = 0x119F627123936B0a456cf3Ec5AA172186c915A36;
227         plyr_[1].name = "justo";
228         plyr_[1].names = 1;
229         pIDxAddr_[0x119F627123936B0a456cf3Ec5AA172186c915A36] = 1;
230         pIDxName_["justo"] = 1;
231         plyrNames_[1]["justo"] = true;
232         plyrNameList_[1][1] = "justo";
233 
234         plyr_[2].addr = 0x119F627123936B0a456cf3Ec5AA172186c915A36;
235         plyr_[2].name = "mantso";
236         plyr_[2].names = 1;
237         pIDxAddr_[0x119F627123936B0a456cf3Ec5AA172186c915A36] = 2;
238         pIDxName_["mantso"] = 2;
239         plyrNames_[2]["mantso"] = true;
240         plyrNameList_[2][1] = "mantso";
241 
242         plyr_[3].addr = 0x119F627123936B0a456cf3Ec5AA172186c915A36;
243         plyr_[3].name = "sumpunk";
244         plyr_[3].names = 1;
245         pIDxAddr_[0x119F627123936B0a456cf3Ec5AA172186c915A36] = 3;
246         pIDxName_["sumpunk"] = 3;
247         plyrNames_[3]["sumpunk"] = true;
248         plyrNameList_[3][1] = "sumpunk";
249 
250         plyr_[4].addr = 0x119F627123936B0a456cf3Ec5AA172186c915A36;
251         plyr_[4].name = "inventor";
252         plyr_[4].names = 1;
253         pIDxAddr_[0x119F627123936B0a456cf3Ec5AA172186c915A36] = 4;
254         pIDxName_["inventor"] = 4;
255         plyrNames_[4]["inventor"] = true;
256         plyrNameList_[4][1] = "inventor";
257 
258         pID_ = 4;
259     }
260 //==============================================================================
261 //     _ _  _  _|. |`. _  _ _  .
262 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
263 //==============================================================================
264     /**
265      * @dev prevents contracts from interacting with fomo3d
266      */
267     modifier isHuman() {
268         address _addr = msg.sender;
269         uint256 _codeLength;
270 
271         assembly {_codeLength := extcodesize(_addr)}
272         require(_codeLength == 0, "sorry humans only");
273         _;
274     }
275 
276 
277     modifier isRegisteredGame()
278     {
279         require(gameIDs_[msg.sender] != 0);
280         _;
281     }
282 //==============================================================================
283 //     _    _  _ _|_ _  .
284 //    (/_\/(/_| | | _\  .
285 //==============================================================================
286     // fired whenever a player registers a name
287     event onNewName
288     (
289         uint256 indexed playerID,
290         address indexed playerAddress,
291         bytes32 indexed playerName,
292         bool isNewPlayer,
293         uint256 affiliateID,
294         address affiliateAddress,
295         bytes32 affiliateName,
296         uint256 amountPaid,
297         uint256 timeStamp
298     );
299 //==============================================================================
300 //     _  _ _|__|_ _  _ _  .
301 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
302 //=====_|=======================================================================
303     function checkIfNameValid(string _nameStr)
304         public
305         view
306         returns(bool)
307     {
308         bytes32 _name = _nameStr.nameFilter();
309         if (pIDxName_[_name] == 0)
310             return (true);
311         else
312             return (false);
313     }
314 //==============================================================================
315 //     _    |_ |. _   |`    _  __|_. _  _  _  .
316 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
317 //====|=========================================================================
318     /**
319      * @dev registers a name.  UI will always display the last name you registered.
320      * but you will still own all previously registered names to use as affiliate
321      * links.
322      * - must pay a registration fee.
323      * - name must be unique
324      * - names will be converted to lowercase
325      * - name cannot start or end with a space
326      * - cannot have more than 1 space in a row
327      * - cannot be only numbers
328      * - cannot start with 0x
329      * - name must be at least 1 char
330      * - max length of 32 characters long
331      * - allowed characters: a-z, 0-9, and space
332      * -functionhash- 0x921dec21 (using ID for affiliate)
333      * -functionhash- 0x3ddd4698 (using address for affiliate)
334      * -functionhash- 0x685ffd83 (using name for affiliate)
335      * @param _nameString players desired name
336      * @param _affCode affiliate ID, address, or name of who refered you
337      * @param _all set to true if you want this to push your info to all games
338      * (this might cost a lot of gas)
339      */
340     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
341         isHuman()
342         public
343         payable
344     {
345         // make sure name fees paid
346         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
347 
348         // filter name + condition checks
349         bytes32 _name = NameFilter.nameFilter(_nameString);
350 
351         // set up address
352         address _addr = msg.sender;
353 
354         // set up our tx event data and determine if player is new or not
355         bool _isNewPlayer = determinePID(_addr);
356 
357         // fetch player id
358         uint256 _pID = pIDxAddr_[_addr];
359 
360         // manage affiliate residuals
361         // if no affiliate code was given, no new affiliate code was given, or the
362         // player tried to use their own pID as an affiliate code, lolz
363         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
364         {
365             // update last affiliate
366             plyr_[_pID].laff = _affCode;
367         } else if (_affCode == _pID) {
368             _affCode = 0;
369         }
370 
371         // register name
372         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
373     }
374 
375     function registerNameXaddr(string _nameString, address _affCode, bool _all)
376         isHuman()
377         public
378         payable
379     {
380         // make sure name fees paid
381         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
382 
383         // filter name + condition checks
384         bytes32 _name = NameFilter.nameFilter(_nameString);
385 
386         // set up address
387         address _addr = msg.sender;
388 
389         // set up our tx event data and determine if player is new or not
390         bool _isNewPlayer = determinePID(_addr);
391 
392         // fetch player id
393         uint256 _pID = pIDxAddr_[_addr];
394 
395         // manage affiliate residuals
396         // if no affiliate code was given or player tried to use their own, lolz
397         uint256 _affID;
398         if (_affCode != address(0) && _affCode != _addr)
399         {
400             // get affiliate ID from aff Code
401             _affID = pIDxAddr_[_affCode];
402 
403             // if affID is not the same as previously stored
404             if (_affID != plyr_[_pID].laff)
405             {
406                 // update last affiliate
407                 plyr_[_pID].laff = _affID;
408             }
409         }
410 
411         // register name
412         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
413     }
414 
415     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
416         isHuman()
417         public
418         payable
419     {
420         // make sure name fees paid
421         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
422 
423         // filter name + condition checks
424         bytes32 _name = NameFilter.nameFilter(_nameString);
425 
426         // set up address
427         address _addr = msg.sender;
428 
429         // set up our tx event data and determine if player is new or not
430         bool _isNewPlayer = determinePID(_addr);
431 
432         // fetch player id
433         uint256 _pID = pIDxAddr_[_addr];
434 
435         // manage affiliate residuals
436         // if no affiliate code was given or player tried to use their own, lolz
437         uint256 _affID;
438         if (_affCode != "" && _affCode != _name)
439         {
440             // get affiliate ID from aff Code
441             _affID = pIDxName_[_affCode];
442 
443             // if affID is not the same as previously stored
444             if (_affID != plyr_[_pID].laff)
445             {
446                 // update last affiliate
447                 plyr_[_pID].laff = _affID;
448             }
449         }
450 
451         // register name
452         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
453     }
454 
455     /**
456      * @dev players, if you registered a profile, before a game was released, or
457      * set the all bool to false when you registered, use this function to push
458      * your profile to a single game.  also, if you've  updated your name, you
459      * can use this to push your name to games of your choosing.
460      * -functionhash- 0x81c5b206
461      * @param _gameID game id
462      */
463     function addMeToGame(uint256 _gameID)
464         isHuman()
465         public
466     {
467         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
468         address _addr = msg.sender;
469         uint256 _pID = pIDxAddr_[_addr];
470         require(_pID != 0, "hey there buddy, you dont even have an account");
471         uint256 _totalNames = plyr_[_pID].names;
472 
473         // add players profile and most recent name
474         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
475 
476         // add list of all names
477         if (_totalNames > 1)
478             for (uint256 ii = 1; ii <= _totalNames; ii++)
479                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
480     }
481 
482     /**
483      * @dev players, use this to push your player profile to all registered games.
484      * -functionhash- 0x0c6940ea
485      */
486     function addMeToAllGames()
487         isHuman()
488         public
489     {
490         address _addr = msg.sender;
491         uint256 _pID = pIDxAddr_[_addr];
492         require(_pID != 0, "hey there buddy, you dont even have an account");
493         uint256 _laff = plyr_[_pID].laff;
494         uint256 _totalNames = plyr_[_pID].names;
495         bytes32 _name = plyr_[_pID].name;
496 
497         for (uint256 i = 1; i <= gID_; i++)
498         {
499             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
500             if (_totalNames > 1)
501                 for (uint256 ii = 1; ii <= _totalNames; ii++)
502                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
503         }
504 
505     }
506 
507     /**
508      * @dev players use this to change back to one of your old names.  tip, you'll
509      * still need to push that info to existing games.
510      * -functionhash- 0xb9291296
511      * @param _nameString the name you want to use
512      */
513     function useMyOldName(string _nameString)
514         isHuman()
515         public
516     {
517         // filter name, and get pID
518         bytes32 _name = _nameString.nameFilter();
519         uint256 _pID = pIDxAddr_[msg.sender];
520 
521         // make sure they own the name
522         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
523 
524         // update their current name
525         plyr_[_pID].name = _name;
526     }
527 
528 //==============================================================================
529 //     _ _  _ _   | _  _ . _  .
530 //    (_(_)| (/_  |(_)(_||(_  .
531 //=====================_|=======================================================
532     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
533         private
534     {
535         // if names already has been used, require that current msg sender owns the name
536         if (pIDxName_[_name] != 0)
537             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
538 
539         // add name to player profile, registry, and name book
540         plyr_[_pID].name = _name;
541         pIDxName_[_name] = _pID;
542         if (plyrNames_[_pID][_name] == false)
543         {
544             plyrNames_[_pID][_name] = true;
545             plyr_[_pID].names++;
546             plyrNameList_[_pID][plyr_[_pID].names] = _name;
547         }
548 
549         // registration fee goes directly to community rewards
550         admin.transfer(address(this).balance);
551 
552         // push player info to games
553         if (_all == true)
554             for (uint256 i = 1; i <= gID_; i++)
555                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
556 
557         // fire event
558         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
559     }
560 //==============================================================================
561 //    _|_ _  _ | _  .
562 //     | (_)(_)|_\  .
563 //==============================================================================
564     function determinePID(address _addr)
565         private
566         returns (bool)
567     {
568         if (pIDxAddr_[_addr] == 0)
569         {
570             pID_++;
571             pIDxAddr_[_addr] = pID_;
572             plyr_[pID_].addr = _addr;
573 
574             // set the new player bool to true
575             return (true);
576         } else {
577             return (false);
578         }
579     }
580 //==============================================================================
581 //   _   _|_ _  _ _  _ |   _ _ || _  .
582 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
583 //==============================================================================
584     function getPlayerID(address _addr)
585         isRegisteredGame()
586         external
587         returns (uint256)
588     {
589         determinePID(_addr);
590         return (pIDxAddr_[_addr]);
591     }
592     function getPlayerName(uint256 _pID)
593         external
594         view
595         returns (bytes32)
596     {
597         return (plyr_[_pID].name);
598     }
599     function getPlayerLAff(uint256 _pID)
600         external
601         view
602         returns (uint256)
603     {
604         return (plyr_[_pID].laff);
605     }
606     function getPlayerAddr(uint256 _pID)
607         external
608         view
609         returns (address)
610     {
611         return (plyr_[_pID].addr);
612     }
613     function getNameFee()
614         external
615         view
616         returns (uint256)
617     {
618         return(registrationFee_);
619     }
620     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
621         isRegisteredGame()
622         external
623         payable
624         returns(bool, uint256)
625     {
626         // make sure name fees paid
627         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
628 
629         // set up our tx event data and determine if player is new or not
630         bool _isNewPlayer = determinePID(_addr);
631 
632         // fetch player id
633         uint256 _pID = pIDxAddr_[_addr];
634 
635         // manage affiliate residuals
636         // if no affiliate code was given, no new affiliate code was given, or the
637         // player tried to use their own pID as an affiliate code, lolz
638         uint256 _affID = _affCode;
639         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
640         {
641             // update last affiliate
642             plyr_[_pID].laff = _affID;
643         } else if (_affID == _pID) {
644             _affID = 0;
645         }
646 
647         // register name
648         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
649 
650         return(_isNewPlayer, _affID);
651     }
652     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
653         isRegisteredGame()
654         external
655         payable
656         returns(bool, uint256)
657     {
658         // make sure name fees paid
659         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
660 
661         // set up our tx event data and determine if player is new or not
662         bool _isNewPlayer = determinePID(_addr);
663 
664         // fetch player id
665         uint256 _pID = pIDxAddr_[_addr];
666 
667         // manage affiliate residuals
668         // if no affiliate code was given or player tried to use their own, lolz
669         uint256 _affID;
670         if (_affCode != address(0) && _affCode != _addr)
671         {
672             // get affiliate ID from aff Code
673             _affID = pIDxAddr_[_affCode];
674 
675             // if affID is not the same as previously stored
676             if (_affID != plyr_[_pID].laff)
677             {
678                 // update last affiliate
679                 plyr_[_pID].laff = _affID;
680             }
681         }
682 
683         // register name
684         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
685 
686         return(_isNewPlayer, _affID);
687     }
688     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
689         isRegisteredGame()
690         external
691         payable
692         returns(bool, uint256)
693     {
694         // make sure name fees paid
695         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
696 
697         // set up our tx event data and determine if player is new or not
698         bool _isNewPlayer = determinePID(_addr);
699 
700         // fetch player id
701         uint256 _pID = pIDxAddr_[_addr];
702 
703         // manage affiliate residuals
704         // if no affiliate code was given or player tried to use their own, lolz
705         uint256 _affID;
706         if (_affCode != "" && _affCode != _name)
707         {
708             // get affiliate ID from aff Code
709             _affID = pIDxName_[_affCode];
710 
711             // if affID is not the same as previously stored
712             if (_affID != plyr_[_pID].laff)
713             {
714                 // update last affiliate
715                 plyr_[_pID].laff = _affID;
716             }
717         }
718 
719         // register name
720         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
721 
722         return(_isNewPlayer, _affID);
723     }
724 
725 //==============================================================================
726 //   _ _ _|_    _   .
727 //  _\(/_ | |_||_)  .
728 //=============|================================================================
729     function addGame(address _gameAddress, string _gameNameStr)
730         public
731     {
732         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
733             gID_++;
734             bytes32 _name = _gameNameStr.nameFilter();
735             gameIDs_[_gameAddress] = gID_;
736             gameNames_[_gameAddress] = _name;
737             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
738 
739             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
740             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
741             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
742             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
743     }
744 
745     function setRegistrationFee(uint256 _fee)
746         public
747     {
748       registrationFee_ = _fee;
749     }
750 
751 }