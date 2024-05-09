1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 
9 contract PlayerBook {
10     using NameFilter for string;
11     using SafeMath for uint256;
12 
13     address private admin = msg.sender;
14     //==============================================================================
15     //     _| _ _|_ _    _ _ _|_    _   .
16     //    (_|(_| | (_|  _\(/_ | |_||_)  .
17     //=============================|================================================
18     uint256 public registrationFee_ = 10 finney;            // price to register a name
19     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
20     mapping(address => bytes32) public gameNames_;          // lookup a games name
21     mapping(address => uint256) public gameIDs_;            // lokup a games ID
22     uint256 public gID_;        // total number of games
23     uint256 public pID_;        // total number of players
24     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
25     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
26     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
27     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
28     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
29     struct Player {
30         address addr;
31         bytes32 name;
32         uint256 laff;
33         uint256 names;
34     }
35     //==============================================================================
36     //     _ _  _  __|_ _    __|_ _  _  .
37     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
38     //==============================================================================
39     constructor()
40     public
41     {
42         // premine the dev names (sorry not sorry)
43         // No keys are purchased with this method, it's simply locking our addresses,
44         // PID's and names for referral codes.
45         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
46         plyr_[1].name = "justo";
47         plyr_[1].names = 1;
48         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
49         pIDxName_["justo"] = 1;
50         plyrNames_[1]["justo"] = true;
51         plyrNameList_[1][1] = "justo";
52 
53         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
54         plyr_[2].name = "mantso";
55         plyr_[2].names = 1;
56         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
57         pIDxName_["mantso"] = 2;
58         plyrNames_[2]["mantso"] = true;
59         plyrNameList_[2][1] = "mantso";
60 
61         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
62         plyr_[3].name = "sumpunk";
63         plyr_[3].names = 1;
64         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
65         pIDxName_["sumpunk"] = 3;
66         plyrNames_[3]["sumpunk"] = true;
67         plyrNameList_[3][1] = "sumpunk";
68 
69         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
70         plyr_[4].name = "inventor";
71         plyr_[4].names = 1;
72         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
73         pIDxName_["inventor"] = 4;
74         plyrNames_[4]["inventor"] = true;
75         plyrNameList_[4][1] = "inventor";
76 
77         pID_ = 4;
78     }
79     //==============================================================================
80     //     _ _  _  _|. |`. _  _ _  .
81     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
82     //==============================================================================
83     /**
84      * @dev prevents contracts from interacting with fomo3d
85      */
86     modifier isHuman() {
87         address _addr = msg.sender;
88         uint256 _codeLength;
89 
90         assembly {_codeLength := extcodesize(_addr)}
91         require(_codeLength == 0, "sorry humans only");
92         _;
93     }
94 
95 
96     modifier isRegisteredGame()
97     {
98         require(gameIDs_[msg.sender] != 0);
99         _;
100     }
101     //==============================================================================
102     //     _    _  _ _|_ _  .
103     //    (/_\/(/_| | | _\  .
104     //==============================================================================
105     // fired whenever a player registers a name
106     event onNewName
107     (
108         uint256 indexed playerID,
109         address indexed playerAddress,
110         bytes32 indexed playerName,
111         bool isNewPlayer,
112         uint256 affiliateID,
113         address affiliateAddress,
114         bytes32 affiliateName,
115         uint256 amountPaid,
116         uint256 timeStamp
117     );
118     //==============================================================================
119     //     _  _ _|__|_ _  _ _  .
120     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
121     //=====_|=======================================================================
122     function checkIfNameValid(string _nameStr)
123     public
124     view
125     returns(bool)
126     {
127         bytes32 _name = _nameStr.nameFilter();
128         if (pIDxName_[_name] == 0)
129             return (true);
130         else
131             return (false);
132     }
133     //==============================================================================
134     //     _    |_ |. _   |`    _  __|_. _  _  _  .
135     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
136     //====|=========================================================================
137     /**
138      * @dev registers a name.  UI will always display the last name you registered.
139      * but you will still own all previously registered names to use as affiliate
140      * links.
141      * - must pay a registration fee.
142      * - name must be unique
143      * - names will be converted to lowercase
144      * - name cannot start or end with a space
145      * - cannot have more than 1 space in a row
146      * - cannot be only numbers
147      * - cannot start with 0x
148      * - name must be at least 1 char
149      * - max length of 32 characters long
150      * - allowed characters: a-z, 0-9, and space
151      * -functionhash- 0x921dec21 (using ID for affiliate)
152      * -functionhash- 0x3ddd4698 (using address for affiliate)
153      * -functionhash- 0x685ffd83 (using name for affiliate)
154      * @param _nameString players desired name
155      * @param _affCode affiliate ID, address, or name of who refered you
156      * @param _all set to true if you want this to push your info to all games
157      * (this might cost a lot of gas)
158      */
159     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
160     isHuman()
161     public
162     payable
163     {
164         // make sure name fees paid
165         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
166 
167         // filter name + condition checks
168         bytes32 _name = NameFilter.nameFilter(_nameString);
169 
170         // set up address
171         address _addr = msg.sender;
172 
173         // set up our tx event data and determine if player is new or not
174         bool _isNewPlayer = determinePID(_addr);
175 
176         // fetch player id
177         uint256 _pID = pIDxAddr_[_addr];
178 
179         // manage affiliate residuals
180         // if no affiliate code was given, no new affiliate code was given, or the
181         // player tried to use their own pID as an affiliate code, lolz
182         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
183         {
184             // update last affiliate
185             plyr_[_pID].laff = _affCode;
186         } else if (_affCode == _pID) {
187             _affCode = 0;
188         }
189 
190         // register name
191         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
192     }
193 
194     function registerNameXaddr(string _nameString, address _affCode, bool _all)
195     isHuman()
196     public
197     payable
198     {
199         // make sure name fees paid
200         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
201 
202         // filter name + condition checks
203         bytes32 _name = NameFilter.nameFilter(_nameString);
204 
205         // set up address
206         address _addr = msg.sender;
207 
208         // set up our tx event data and determine if player is new or not
209         bool _isNewPlayer = determinePID(_addr);
210 
211         // fetch player id
212         uint256 _pID = pIDxAddr_[_addr];
213 
214         // manage affiliate residuals
215         // if no affiliate code was given or player tried to use their own, lolz
216         uint256 _affID;
217         if (_affCode != address(0) && _affCode != _addr)
218         {
219             // get affiliate ID from aff Code
220             _affID = pIDxAddr_[_affCode];
221 
222             // if affID is not the same as previously stored
223             if (_affID != plyr_[_pID].laff)
224             {
225                 // update last affiliate
226                 plyr_[_pID].laff = _affID;
227             }
228         }
229 
230         // register name
231         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
232     }
233 
234     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
235     isHuman()
236     public
237     payable
238     {
239         // make sure name fees paid
240         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
241 
242         // filter name + condition checks
243         bytes32 _name = NameFilter.nameFilter(_nameString);
244 
245         // set up address
246         address _addr = msg.sender;
247 
248         // set up our tx event data and determine if player is new or not
249         bool _isNewPlayer = determinePID(_addr);
250 
251         // fetch player id
252         uint256 _pID = pIDxAddr_[_addr];
253 
254         // manage affiliate residuals
255         // if no affiliate code was given or player tried to use their own, lolz
256         uint256 _affID;
257         if (_affCode != "" && _affCode != _name)
258         {
259             // get affiliate ID from aff Code
260             _affID = pIDxName_[_affCode];
261 
262             // if affID is not the same as previously stored
263             if (_affID != plyr_[_pID].laff)
264             {
265                 // update last affiliate
266                 plyr_[_pID].laff = _affID;
267             }
268         }
269 
270         // register name
271         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
272     }
273 
274     /**
275      * @dev players, if you registered a profile, before a game was released, or
276      * set the all bool to false when you registered, use this function to push
277      * your profile to a single game.  also, if you've  updated your name, you
278      * can use this to push your name to games of your choosing.
279      * -functionhash- 0x81c5b206
280      * @param _gameID game id
281      */
282     function addMeToGame(uint256 _gameID)
283     isHuman()
284     public
285     {
286         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
287         address _addr = msg.sender;
288         uint256 _pID = pIDxAddr_[_addr];
289         require(_pID != 0, "hey there buddy, you dont even have an account");
290         uint256 _totalNames = plyr_[_pID].names;
291 
292         // add players profile and most recent name
293         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
294 
295         // add list of all names
296         if (_totalNames > 1)
297             for (uint256 ii = 1; ii <= _totalNames; ii++)
298                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
299     }
300 
301     /**
302      * @dev players, use this to push your player profile to all registered games.
303      * -functionhash- 0x0c6940ea
304      */
305     function addMeToAllGames()
306     isHuman()
307     public
308     {
309         address _addr = msg.sender;
310         uint256 _pID = pIDxAddr_[_addr];
311         require(_pID != 0, "hey there buddy, you dont even have an account");
312         uint256 _laff = plyr_[_pID].laff;
313         uint256 _totalNames = plyr_[_pID].names;
314         bytes32 _name = plyr_[_pID].name;
315 
316         for (uint256 i = 1; i <= gID_; i++)
317         {
318             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
319             if (_totalNames > 1)
320                 for (uint256 ii = 1; ii <= _totalNames; ii++)
321                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
322         }
323 
324     }
325 
326     /**
327      * @dev players use this to change back to one of your old names.  tip, you'll
328      * still need to push that info to existing games.
329      * -functionhash- 0xb9291296
330      * @param _nameString the name you want to use
331      */
332     function useMyOldName(string _nameString)
333     isHuman()
334     public
335     {
336         // filter name, and get pID
337         bytes32 _name = _nameString.nameFilter();
338         uint256 _pID = pIDxAddr_[msg.sender];
339 
340         // make sure they own the name
341         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
342 
343         // update their current name
344         plyr_[_pID].name = _name;
345     }
346 
347     //==============================================================================
348     //     _ _  _ _   | _  _ . _  .
349     //    (_(_)| (/_  |(_)(_||(_  .
350     //=====================_|=======================================================
351     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
352     private
353     {
354         // if names already has been used, require that current msg sender owns the name
355         if (pIDxName_[_name] != 0)
356             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
357 
358         // add name to player profile, registry, and name book
359         plyr_[_pID].name = _name;
360         pIDxName_[_name] = _pID;
361         if (plyrNames_[_pID][_name] == false)
362         {
363             plyrNames_[_pID][_name] = true;
364             plyr_[_pID].names++;
365             plyrNameList_[_pID][plyr_[_pID].names] = _name;
366         }
367 
368         // registration fee goes directly to community rewards
369         admin.transfer(address(this).balance);
370 
371         // push player info to games
372         if (_all == true)
373             for (uint256 i = 1; i <= gID_; i++)
374                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
375 
376         // fire event
377         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
378     }
379     //==============================================================================
380     //    _|_ _  _ | _  .
381     //     | (_)(_)|_\  .
382     //==============================================================================
383     function determinePID(address _addr)
384     private
385     returns (bool)
386     {
387         if (pIDxAddr_[_addr] == 0)
388         {
389             pID_++;
390             pIDxAddr_[_addr] = pID_;
391             plyr_[pID_].addr = _addr;
392 
393             // set the new player bool to true
394             return (true);
395         } else {
396             return (false);
397         }
398     }
399     //==============================================================================
400     //   _   _|_ _  _ _  _ |   _ _ || _  .
401     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
402     //==============================================================================
403     function getPlayerID(address _addr)
404     isRegisteredGame()
405     external
406     returns (uint256)
407     {
408         determinePID(_addr);
409         return (pIDxAddr_[_addr]);
410     }
411     function getPlayerName(uint256 _pID)
412     external
413     view
414     returns (bytes32)
415     {
416         return (plyr_[_pID].name);
417     }
418     function getPlayerLAff(uint256 _pID)
419     external
420     view
421     returns (uint256)
422     {
423         return (plyr_[_pID].laff);
424     }
425     function getPlayerAddr(uint256 _pID)
426     external
427     view
428     returns (address)
429     {
430         return (plyr_[_pID].addr);
431     }
432     function getNameFee()
433     external
434     view
435     returns (uint256)
436     {
437         return(registrationFee_);
438     }
439     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
440     isRegisteredGame()
441     external
442     payable
443     returns(bool, uint256)
444     {
445         // make sure name fees paid
446         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
447 
448         // set up our tx event data and determine if player is new or not
449         bool _isNewPlayer = determinePID(_addr);
450 
451         // fetch player id
452         uint256 _pID = pIDxAddr_[_addr];
453 
454         // manage affiliate residuals
455         // if no affiliate code was given, no new affiliate code was given, or the
456         // player tried to use their own pID as an affiliate code, lolz
457         uint256 _affID = _affCode;
458         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
459         {
460             // update last affiliate
461             plyr_[_pID].laff = _affID;
462         } else if (_affID == _pID) {
463             _affID = 0;
464         }
465 
466         // register name
467         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
468 
469         return(_isNewPlayer, _affID);
470     }
471     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
472     isRegisteredGame()
473     external
474     payable
475     returns(bool, uint256)
476     {
477         // make sure name fees paid
478         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
479 
480         // set up our tx event data and determine if player is new or not
481         bool _isNewPlayer = determinePID(_addr);
482 
483         // fetch player id
484         uint256 _pID = pIDxAddr_[_addr];
485 
486         // manage affiliate residuals
487         // if no affiliate code was given or player tried to use their own, lolz
488         uint256 _affID;
489         if (_affCode != address(0) && _affCode != _addr)
490         {
491             // get affiliate ID from aff Code
492             _affID = pIDxAddr_[_affCode];
493 
494             // if affID is not the same as previously stored
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501 
502         // register name
503         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
504 
505         return(_isNewPlayer, _affID);
506     }
507     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
508     isRegisteredGame()
509     external
510     payable
511     returns(bool, uint256)
512     {
513         // make sure name fees paid
514         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
515 
516         // set up our tx event data and determine if player is new or not
517         bool _isNewPlayer = determinePID(_addr);
518 
519         // fetch player id
520         uint256 _pID = pIDxAddr_[_addr];
521 
522         // manage affiliate residuals
523         // if no affiliate code was given or player tried to use their own, lolz
524         uint256 _affID;
525         if (_affCode != "" && _affCode != _name)
526         {
527             // get affiliate ID from aff Code
528             _affID = pIDxName_[_affCode];
529 
530             // if affID is not the same as previously stored
531             if (_affID != plyr_[_pID].laff)
532             {
533                 // update last affiliate
534                 plyr_[_pID].laff = _affID;
535             }
536         }
537 
538         // register name
539         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
540 
541         return(_isNewPlayer, _affID);
542     }
543 
544     //==============================================================================
545     //   _ _ _|_    _   .
546     //  _\(/_ | |_||_)  .
547     //=============|================================================================
548     function addGame(address _gameAddress, string _gameNameStr)
549     public
550     {
551         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
552         gID_++;
553         bytes32 _name = _gameNameStr.nameFilter();
554         gameIDs_[_gameAddress] = gID_;
555         gameNames_[_gameAddress] = _name;
556         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
557 
558         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
559         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
560         games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
561         games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
562     }
563 
564     function setRegistrationFee(uint256 _fee)
565     public
566     {
567         registrationFee_ = _fee;
568     }
569 
570 }
571 
572 library NameFilter {
573 
574     /**
575      * @dev filters name strings
576      * -converts uppercase to lower case.
577      * -makes sure it does not start/end with a space
578      * -makes sure it does not contain multiple spaces in a row
579      * -cannot be only numbers
580      * -cannot start with 0x
581      * -restricts characters to A-Z, a-z, 0-9, and space.
582      * @return reprocessed string in bytes32 format
583      */
584     function nameFilter(string _input)
585     internal
586     pure
587     returns(bytes32)
588     {
589         bytes memory _temp = bytes(_input);
590         uint256 _length = _temp.length;
591 
592         //sorry limited to 32 characters
593         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
594         // make sure it doesnt start with or end with space
595         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
596         // make sure first two characters are not 0x
597         if (_temp[0] == 0x30)
598         {
599             require(_temp[1] != 0x78, "string cannot start with 0x");
600             require(_temp[1] != 0x58, "string cannot start with 0X");
601         }
602 
603         // create a bool to track if we have a non number character
604         bool _hasNonNumber;
605 
606         // convert & check
607         for (uint256 i = 0; i < _length; i++)
608         {
609             // if its uppercase A-Z
610             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
611             {
612                 // convert to lower case a-z
613                 _temp[i] = byte(uint(_temp[i]) + 32);
614 
615                 // we have a non number
616                 if (_hasNonNumber == false)
617                     _hasNonNumber = true;
618             } else {
619                 require
620                 (
621                 // require character is a space
622                     _temp[i] == 0x20 ||
623                 // OR lowercase a-z
624                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
625                 // or 0-9
626                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
627                     "string contains invalid characters"
628                 );
629                 // make sure theres not 2x spaces in a row
630                 if (_temp[i] == 0x20)
631                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
632 
633                 // see if we have a character other than a number
634                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
635                     _hasNonNumber = true;
636             }
637         }
638 
639         require(_hasNonNumber == true, "string cannot be only numbers");
640 
641         bytes32 _ret;
642         assembly {
643             _ret := mload(add(_temp, 32))
644         }
645         return (_ret);
646     }
647 }
648 
649 /**
650  * @title SafeMath v0.1.9
651  * @dev Math operations with safety checks that throw on error
652  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
653  * - added sqrt
654  * - added sq
655  * - added pwr
656  * - changed asserts to requires with error log outputs
657  * - removed div, its useless
658  */
659 library SafeMath {
660 
661     /**
662     * @dev Multiplies two numbers, throws on overflow.
663     */
664     function mul(uint256 a, uint256 b)
665     internal
666     pure
667     returns (uint256 c)
668     {
669         if (a == 0) {
670             return 0;
671         }
672         c = a * b;
673         require(c / a == b, "SafeMath mul failed");
674         return c;
675     }
676 
677     /**
678     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
679     */
680     function sub(uint256 a, uint256 b)
681     internal
682     pure
683     returns (uint256)
684     {
685         require(b <= a, "SafeMath sub failed");
686         return a - b;
687     }
688 
689     /**
690     * @dev Adds two numbers, throws on overflow.
691     */
692     function add(uint256 a, uint256 b)
693     internal
694     pure
695     returns (uint256 c)
696     {
697         c = a + b;
698         require(c >= a, "SafeMath add failed");
699         return c;
700     }
701 
702     /**
703      * @dev gives square root of given x.
704      */
705     function sqrt(uint256 x)
706     internal
707     pure
708     returns (uint256 y)
709     {
710         uint256 z = ((add(x,1)) / 2);
711         y = x;
712         while (z < y)
713         {
714             y = z;
715             z = ((add((x / z),z)) / 2);
716         }
717     }
718 
719     /**
720      * @dev gives square. multiplies x by x
721      */
722     function sq(uint256 x)
723     internal
724     pure
725     returns (uint256)
726     {
727         return (mul(x,x));
728     }
729 
730     /**
731      * @dev x to the power of y
732      */
733     function pwr(uint256 x, uint256 y)
734     internal
735     pure
736     returns (uint256)
737     {
738         if (x==0)
739             return (0);
740         else if (y==0)
741             return (1);
742         else
743         {
744             uint256 z = x;
745             for (uint256 i=1; i < y; i++)
746                 z = mul(z,x);
747             return (z);
748         }
749     }
750 }