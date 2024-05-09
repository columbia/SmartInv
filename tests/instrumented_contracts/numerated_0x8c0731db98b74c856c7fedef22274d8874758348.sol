1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-05
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 interface PlayerBookReceiverInterface {
9     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
10     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
11 }
12 
13 
14 contract PlayerBook {
15     using NameFilter for string;
16     using SafeMath for uint256;
17 
18     address private admin;
19 
20 
21 /****************************************************************************************************************************
22                                                         DATA SETUP 
23 ****************************************************************************************************************************/
24 
25 
26 
27     uint256 public registrationFee_ = 10 finney;            // price to register a name
28     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
29     mapping(address => bytes32) public gameNames_;          // lookup a games name
30     mapping(address => uint256) public gameIDs_;            // lokup a games ID
31     uint256 public gID_;        // total number of games
32     uint256 public pID_;        // total number of players
33     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
34     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
35     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
36     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
37     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
38      struct Player {
39         address addr;
40         bytes32 name;
41         uint256 laff;
42         uint256 names;
43     }
44 
45 /****************************************************************************************************************************
46                                                         CONSTRUCTOR 
47 ****************************************************************************************************************************/
48 
49 
50     constructor()
51         public
52     {
53         pID_ = 1;
54         admin = msg.sender;
55     }
56 
57 
58 /****************************************************************************************************************************
59                                                         MODIFIERS 
60 ****************************************************************************************************************************/
61 
62  
63     /**
64      * @dev prevents contracts from interacting with fomo3d 
65      */
66     modifier isHuman() {
67         address _addr = msg.sender;
68         uint256 _codeLength;
69 
70         assembly {_codeLength := extcodesize(_addr)}
71         require(_codeLength == 0, "sorry humans only");
72         _;
73     }
74 
75 
76     modifier isRegisteredGame()
77     {
78         require(gameIDs_[msg.sender] != 0);
79         _;
80     }
81 
82 /****************************************************************************************************************************
83                                                         EVENTS 
84 ****************************************************************************************************************************/
85 
86 
87     // fired whenever a player registers a name
88     event onNewName
89     (
90         uint256 indexed playerID,
91         address indexed playerAddress,
92         bytes32 indexed playerName,
93         bool isNewPlayer,
94         uint256 affiliateID,
95         address affiliateAddress,
96         bytes32 affiliateName,
97         uint256 amountPaid,
98         uint256 timeStamp
99     );
100 
101 
102 /****************************************************************************************************************************
103                                                         GETTERS 
104 ****************************************************************************************************************************/
105 
106 
107     function checkIfNameValid(string _nameStr)
108         public
109         view
110         returns(bool)
111     {
112         bytes32 _name = _nameStr.nameFilter();
113         if (pIDxName_[_name] == 0)
114             return (true);
115         else
116             return (false);
117     }
118 
119 
120 /****************************************************************************************************************************
121                                                     PUBLIC FUNCTIONS 
122 ****************************************************************************************************************************/
123 
124 
125     /**
126      * @dev registers a name.  UI will always display the last name you registered.
127      * but you will still own all previously registered names to use as affiliate 
128      * links.
129      * - must pay a registration fee.
130      * - name must be unique
131      * - names will be converted to lowercase
132      * - name cannot start or end with a space 
133      * - cannot have more than 1 space in a row
134      * - cannot be only numbers
135      * - cannot start with 0x 
136      * - name must be at least 1 char
137      * - max length of 32 characters long
138      * - allowed characters: a-z, 0-9, and space
139      * -functionhash- 0x921dec21 (using ID for affiliate)
140      * -functionhash- 0x3ddd4698 (using address for affiliate)
141      * -functionhash- 0x685ffd83 (using name for affiliate)
142      * @param _nameString players desired name
143      * @param _affCode affiliate ID, address, or name of who refered you
144      * @param _all set to true if you want this to push your info to all games 
145      * (this might cost a lot of gas)
146      */
147     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
148         isHuman()
149         public
150         payable
151     {
152         // make sure name fees paid
153         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
154         
155         // filter name + condition checks
156         bytes32 _name = NameFilter.nameFilter(_nameString);
157         
158         // set up address 
159         address _addr = msg.sender;
160         
161         // set up our tx event data and determine if player is new or not
162         bool _isNewPlayer = determinePID(_addr);
163         
164         // fetch player id
165         uint256 _pID = pIDxAddr_[_addr];
166         
167         // manage affiliate residuals
168         // if no affiliate code was given, no new affiliate code was given, or the 
169         // player tried to use their own pID as an affiliate code, lolz
170         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
171         {
172             // update last affiliate 
173             plyr_[_pID].laff = _affCode;
174         } else if (_affCode == _pID) {
175             _affCode = 0;
176         }
177         
178         // register name 
179         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
180     }
181 
182     function registerNameXaddr(string _nameString, address _affCode, bool _all)
183         isHuman()
184         public
185         payable
186     {
187         // make sure name fees paid
188         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
189         
190         // filter name + condition checks
191         bytes32 _name = NameFilter.nameFilter(_nameString);
192         
193         // set up address 
194         address _addr = msg.sender;
195         
196         // set up our tx event data and determine if player is new or not
197         bool _isNewPlayer = determinePID(_addr);
198         
199         // fetch player id
200         uint256 _pID = pIDxAddr_[_addr];
201         
202         // manage affiliate residuals
203         // if no affiliate code was given or player tried to use their own, lolz
204         uint256 _affID;
205         if (_affCode != address(0) && _affCode != _addr)
206         {
207             // get affiliate ID from aff Code 
208             _affID = pIDxAddr_[_affCode];
209             
210             // if affID is not the same as previously stored 
211             if (_affID != plyr_[_pID].laff)
212             {
213                 // update last affiliate
214                 plyr_[_pID].laff = _affID;
215             }
216         }
217         
218         // register name 
219         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
220     }
221 
222     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
223         isHuman()
224         public
225         payable
226     {
227         // make sure name fees paid
228         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
229         
230         // filter name + condition checks
231         bytes32 _name = NameFilter.nameFilter(_nameString);
232         
233         // set up address 
234         address _addr = msg.sender;
235         
236         // set up our tx event data and determine if player is new or not
237         bool _isNewPlayer = determinePID(_addr);
238         
239         // fetch player id
240         uint256 _pID = pIDxAddr_[_addr];
241         
242         // manage affiliate residuals
243         // if no affiliate code was given or player tried to use their own, lolz
244         uint256 _affID;
245         if (_affCode != "" && _affCode != _name)
246         {
247             // get affiliate ID from aff Code 
248             _affID = pIDxName_[_affCode];
249             
250             // if affID is not the same as previously stored 
251             if (_affID != plyr_[_pID].laff)
252             {
253                 // update last affiliate
254                 plyr_[_pID].laff = _affID;
255             }
256         }
257         
258         // register name 
259         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
260     }
261 
262     /**
263      * @dev players, if you registered a profile, before a game was released, or
264      * set the all bool to false when you registered, use this function to push
265      * your profile to a single game.  also, if you've  updated your name, you
266      * can use this to push your name to games of your choosing.
267      * -functionhash- 0x81c5b206
268      * @param _gameID game id 
269      */
270     function addMeToGame(uint256 _gameID)
271         isHuman()
272         public
273     {
274         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
275         address _addr = msg.sender;
276         uint256 _pID = pIDxAddr_[_addr];
277         require(_pID != 0, "hey there buddy, you dont even have an account");
278         uint256 _totalNames = plyr_[_pID].names;
279 
280         // add players profile and most recent name
281         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
282         
283         // add list of all names
284         if (_totalNames > 1)
285             for (uint256 ii = 1; ii <= _totalNames; ii++)
286                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
287     }
288 
289     /**
290      * @dev players, use this to push your player profile to all registered games.
291      * -functionhash- 0x0c6940ea
292      */
293     function addMeToAllGames()
294         isHuman()
295         public
296     {
297         address _addr = msg.sender;
298         uint256 _pID = pIDxAddr_[_addr];
299         require(_pID != 0, "hey there buddy, you dont even have an account");
300         uint256 _laff = plyr_[_pID].laff;
301         uint256 _totalNames = plyr_[_pID].names;
302         bytes32 _name = plyr_[_pID].name;
303 
304         for (uint256 i = 1; i <= gID_; i++)
305         {
306             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
307             if (_totalNames > 1)
308                 for (uint256 ii = 1; ii <= _totalNames; ii++)
309                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
310         }
311 
312     }
313 
314     /**
315      * @dev players use this to change back to one of your old names.  tip, you'll
316      * still need to push that info to existing games.
317      * -functionhash- 0xb9291296
318      * @param _nameString the name you want to use 
319      */
320     function useMyOldName(string _nameString)
321         isHuman()
322         public 
323     {
324         // filter name, and get pID
325         bytes32 _name = _nameString.nameFilter();
326         uint256 _pID = pIDxAddr_[msg.sender];
327         
328         // make sure they own the name 
329         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
330         
331         // update their current name 
332         plyr_[_pID].name = _name;
333     }
334 
335 
336 
337 /****************************************************************************************************************************
338                                                         CORE LOGIC 
339 ****************************************************************************************************************************/
340 
341 
342     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
343         private
344     {
345         // if names already has been used, require that current msg sender owns the name
346         if (pIDxName_[_name] != 0)
347             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
348 
349         // add name to player profile, registry, and name book
350         plyr_[_pID].name = _name;
351         pIDxName_[_name] = _pID;
352         if (plyrNames_[_pID][_name] == false)
353         {
354             plyrNames_[_pID][_name] = true;
355             plyr_[_pID].names++;
356             plyrNameList_[_pID][plyr_[_pID].names] = _name;
357         }
358 
359         // registration fee goes directly to community rewards
360         admin.transfer(address(this).balance);
361 
362         // push player info to games
363         if (_all == true)
364             for (uint256 i = 1; i <= gID_; i++)
365                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
366 
367         // fire event
368         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
369     }
370 
371 
372 /****************************************************************************************************************************
373                                                         TOOLS 
374 ****************************************************************************************************************************/
375 
376 
377     function determinePID(address _addr)
378         private
379         returns (bool)
380     {
381         if (pIDxAddr_[_addr] == 0)
382         {
383             pID_++;
384             pIDxAddr_[_addr] = pID_;
385             plyr_[pID_].addr = _addr;
386 
387             // set the new player bool to true
388             return (true);
389         } else {
390             return (false);
391         }
392     }
393 
394 
395 /****************************************************************************************************************************
396                                                         EXTERNAL CALLS 
397 ****************************************************************************************************************************/
398 
399 
400     function getPlayerID(address _addr)
401         isRegisteredGame()
402         external
403         returns (uint256)
404     {
405         determinePID(_addr);
406         return (pIDxAddr_[_addr]);
407     }
408     function getPlayerName(uint256 _pID)
409         external
410         view
411         returns (bytes32)
412     {
413         return (plyr_[_pID].name);
414     }
415     function getPlayerLAff(uint256 _pID)
416         external
417         view
418         returns (uint256)
419     {
420         return (plyr_[_pID].laff);
421     }
422     function getPlayerAddr(uint256 _pID)
423         external
424         view
425         returns (address)
426     {
427         return (plyr_[_pID].addr);
428     }
429     function getNameFee()
430         external
431         view
432         returns (uint256)
433     {
434         return(registrationFee_);
435     }
436     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
437         isRegisteredGame()
438         external
439         payable
440         returns(bool, uint256)
441     {
442         // make sure name fees paid
443         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
444         
445         // set up our tx event data and determine if player is new or not
446         bool _isNewPlayer = determinePID(_addr);
447         
448         // fetch player id
449         uint256 _pID = pIDxAddr_[_addr];
450         
451         // manage affiliate residuals
452         // if no affiliate code was given, no new affiliate code was given, or the 
453         // player tried to use their own pID as an affiliate code, lolz
454         uint256 _affID = _affCode;
455         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
456         {
457             // update last affiliate 
458             plyr_[_pID].laff = _affID;
459         } else if (_affID == _pID) {
460             _affID = 0;
461         }
462 
463         // register name 
464         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
465 
466         return(_isNewPlayer, _affID);
467     }
468     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
469         isRegisteredGame()
470         external
471         payable
472         returns(bool, uint256)
473     {
474         // make sure name fees paid
475         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
476         
477         // set up our tx event data and determine if player is new or not
478         bool _isNewPlayer = determinePID(_addr);
479         
480         // fetch player id
481         uint256 _pID = pIDxAddr_[_addr];
482         
483         // manage affiliate residuals
484         // if no affiliate code was given or player tried to use their own, lolz
485         uint256 _affID;
486         if (_affCode != address(0) && _affCode != _addr)
487         {
488             // get affiliate ID from aff Code 
489             _affID = pIDxAddr_[_affCode];
490             
491             // if affID is not the same as previously stored 
492             if (_affID != plyr_[_pID].laff)
493             {
494                 // update last affiliate
495                 plyr_[_pID].laff = _affID;
496             }
497         }
498         
499         // register name 
500         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
501 
502         return(_isNewPlayer, _affID);
503     }
504     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
505         isRegisteredGame()
506         external
507         payable
508         returns(bool, uint256)
509     {
510         // make sure name fees paid
511         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
512         
513         // set up our tx event data and determine if player is new or not
514         bool _isNewPlayer = determinePID(_addr);
515         
516         // fetch player id
517         uint256 _pID = pIDxAddr_[_addr];
518         
519         // manage affiliate residuals
520         // if no affiliate code was given or player tried to use their own, lolz
521         uint256 _affID;
522         if (_affCode != "" && _affCode != _name)
523         {
524             // get affiliate ID from aff Code 
525             _affID = pIDxName_[_affCode];
526             
527             // if affID is not the same as previously stored 
528             if (_affID != plyr_[_pID].laff)
529             {
530                 // update last affiliate
531                 plyr_[_pID].laff = _affID;
532             }
533         }
534         
535         // register name 
536         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
537 
538         return(_isNewPlayer, _affID);
539     }
540 
541 
542 /****************************************************************************************************************************
543                                                         SETUP 
544 ****************************************************************************************************************************/
545 
546 
547     function addGame(address _gameAddress, string _gameNameStr)
548         public
549     {
550         require(admin == msg.sender,"Oops, only admin can add the games");
551         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
552             gID_++;
553             bytes32 _name = _gameNameStr.nameFilter();
554             gameIDs_[_gameAddress] = gID_;
555             gameNames_[_gameAddress] = _name;
556             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
557 
558             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
559             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
560             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
561             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
562     }
563 
564     function setRegistrationFee(uint256 _fee)
565         public
566     {
567       require(admin == msg.sender,"Oops, only admin can change the fees");
568       registrationFee_ = _fee;
569     }
570 
571 }
572 
573 
574 library NameFilter {
575 
576     /**
577      * @dev filters name strings
578      * -converts uppercase to lower case.  
579      * -makes sure it does not start/end with a space
580      * -makes sure it does not contain multiple spaces in a row
581      * -cannot be only numbers
582      * -cannot start with 0x 
583      * -restricts characters to A-Z, a-z, 0-9, and space.
584      * @return reprocessed string in bytes32 format
585      */
586     function nameFilter(string _input)
587         internal
588         pure
589         returns(bytes32)
590     {
591         bytes memory _temp = bytes(_input);
592         uint256 _length = _temp.length;
593 
594         //sorry limited to 32 characters
595         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
596         // make sure it doesnt start with or end with space
597         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
598         // make sure first two characters are not 0x
599         if (_temp[0] == 0x30)
600         {
601             require(_temp[1] != 0x78, "string cannot start with 0x");
602             require(_temp[1] != 0x58, "string cannot start with 0X");
603         }
604         
605         // create a bool to track if we have a non number character
606         bool _hasNonNumber;
607         
608         // convert & check
609         for (uint256 i = 0; i < _length; i++)
610         {
611             // if its uppercase A-Z
612             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
613             {
614                 // convert to lower case a-z
615                 _temp[i] = byte(uint(_temp[i]) + 32);
616                 
617                 // we have a non number
618                 if (_hasNonNumber == false)
619                     _hasNonNumber = true;
620             } else {
621                 require
622                 (
623                     // require character is a space
624                     _temp[i] == 0x20 || 
625                     // OR lowercase a-z
626                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
627                     // or 0-9
628                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
629                     "string contains invalid characters"
630                 );
631                 // make sure theres not 2x spaces in a row
632                 if (_temp[i] == 0x20)
633                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
634                 
635                 // see if we have a character other than a number
636                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
637                     _hasNonNumber = true;
638             }
639         }
640 
641         require(_hasNonNumber == true, "string cannot be only numbers");
642 
643         bytes32 _ret;
644         assembly {
645             _ret := mload(add(_temp, 32))
646         }
647         return (_ret);
648     }
649 }
650 
651 /**
652  * @title SafeMath v0.1.9
653  * @dev Math operations with safety checks that throw on error
654  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
655  * - added sqrt
656  * - added sq
657  * - added pwr 
658  * - changed asserts to requires with error log outputs
659  * - removed div, its useless
660  */
661 library SafeMath {
662     
663     /**
664     * @dev Multiplies two numbers, throws on overflow.
665     */
666     function mul(uint256 a, uint256 b) 
667         internal 
668         pure 
669         returns (uint256 c) 
670     {
671         if (a == 0) {
672             return 0;
673         }
674         c = a * b;
675         require(c / a == b, "SafeMath mul failed");
676         return c;
677     }
678 
679     /**
680     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
681     */
682     function sub(uint256 a, uint256 b)
683         internal
684         pure
685         returns (uint256) 
686     {
687         require(b <= a, "SafeMath sub failed");
688         return a - b;
689     }
690 
691     /**
692     * @dev Adds two numbers, throws on overflow.
693     */
694     function add(uint256 a, uint256 b)
695         internal
696         pure
697         returns (uint256 c) 
698     {
699         c = a + b;
700         require(c >= a, "SafeMath add failed");
701         return c;
702     }
703     
704     /**
705      * @dev gives square root of given x.
706      */
707     function sqrt(uint256 x)
708         internal
709         pure
710         returns (uint256 y) 
711     {
712         uint256 z = ((add(x,1)) / 2);
713         y = x;
714         while (z < y) 
715         {
716             y = z;
717             z = ((add((x / z),z)) / 2);
718         }
719     }
720     
721     /**
722      * @dev gives square. multiplies x by x
723      */
724     function sq(uint256 x)
725         internal
726         pure
727         returns (uint256)
728     {
729         return (mul(x,x));
730     }
731     
732     /**
733      * @dev x to the power of y 
734      */
735     function pwr(uint256 x, uint256 y)
736         internal
737         pure
738         returns (uint256)
739     {
740         if (x==0)
741             return (0);
742         else if (y==0)
743             return (1);
744         else
745         {
746             uint256 z = x;
747             for (uint256 i=1; i < y; i++)
748                 z = mul(z,x);
749             return (z);
750         }
751     }
752 }