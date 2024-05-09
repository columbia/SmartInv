1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 
10 contract PlayerBook {
11     using NameFilter for string;
12     using SafeMath for uint256;
13 
14     address private admin;
15 //==============================================================================
16 //     _| _ _|_ _    _ _ _|_    _   .
17 //    (_|(_| | (_|  _\(/_ | |_||_)  .
18 //=============================|================================================
19     uint256 public registrationFee_ = 10 finney;            // price to register a name
20     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
21     mapping(address => bytes32) public gameNames_;          // lookup a games name
22     mapping(address => uint256) public gameIDs_;            // lokup a games ID
23     uint256 public gID_;        // total number of games
24     uint256 public pID_;        // total number of players
25     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
26     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
27     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
28     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
29     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
30      struct Player {
31         address addr;
32         bytes32 name;
33         uint256 laff;
34         uint256 names;
35     }
36 //==============================================================================
37 //     _ _  _  __|_ _    __|_ _  _  .
38 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
39 //==============================================================================    
40     constructor()
41         public
42     {
43         pID_ = 1;
44         admin = msg.sender;
45     }
46 //==============================================================================
47 //     _ _  _  _|. |`. _  _ _  .
48 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
49 //==============================================================================    
50     /**
51      * @dev prevents contracts from interacting with fomo3d 
52      */
53     modifier isHuman() {
54         address _addr = msg.sender;
55         uint256 _codeLength;
56 
57         assembly {_codeLength := extcodesize(_addr)}
58         require(_codeLength == 0, "sorry humans only");
59         _;
60     }
61 
62 
63     modifier isRegisteredGame()
64     {
65         require(gameIDs_[msg.sender] != 0);
66         _;
67     }
68 //==============================================================================
69 //     _    _  _ _|_ _  .
70 //    (/_\/(/_| | | _\  .
71 //==============================================================================
72     // fired whenever a player registers a name
73     event onNewName
74     (
75         uint256 indexed playerID,
76         address indexed playerAddress,
77         bytes32 indexed playerName,
78         bool isNewPlayer,
79         uint256 affiliateID,
80         address affiliateAddress,
81         bytes32 affiliateName,
82         uint256 amountPaid,
83         uint256 timeStamp
84     );
85 //==============================================================================
86 //     _  _ _|__|_ _  _ _  .
87 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
88 //=====_|=======================================================================
89     function checkIfNameValid(string _nameStr)
90         public
91         view
92         returns(bool)
93     {
94         bytes32 _name = _nameStr.nameFilter();
95         if (pIDxName_[_name] == 0)
96             return (true);
97         else
98             return (false);
99     }
100 //==============================================================================
101 //     _    |_ |. _   |`    _  __|_. _  _  _  .
102 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
103 //====|=========================================================================    
104     /**
105      * @dev registers a name.  UI will always display the last name you registered.
106      * but you will still own all previously registered names to use as affiliate 
107      * links.
108      * - must pay a registration fee.
109      * - name must be unique
110      * - names will be converted to lowercase
111      * - name cannot start or end with a space 
112      * - cannot have more than 1 space in a row
113      * - cannot be only numbers
114      * - cannot start with 0x 
115      * - name must be at least 1 char
116      * - max length of 32 characters long
117      * - allowed characters: a-z, 0-9, and space
118      * -functionhash- 0x921dec21 (using ID for affiliate)
119      * -functionhash- 0x3ddd4698 (using address for affiliate)
120      * -functionhash- 0x685ffd83 (using name for affiliate)
121      * @param _nameString players desired name
122      * @param _affCode affiliate ID, address, or name of who refered you
123      * @param _all set to true if you want this to push your info to all games 
124      * (this might cost a lot of gas)
125      */
126     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
127         isHuman()
128         public
129         payable
130     {
131         // make sure name fees paid
132         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
133         
134         // filter name + condition checks
135         bytes32 _name = NameFilter.nameFilter(_nameString);
136         
137         // set up address 
138         address _addr = msg.sender;
139         
140         // set up our tx event data and determine if player is new or not
141         bool _isNewPlayer = determinePID(_addr);
142         
143         // fetch player id
144         uint256 _pID = pIDxAddr_[_addr];
145         
146         // manage affiliate residuals
147         // if no affiliate code was given, no new affiliate code was given, or the 
148         // player tried to use their own pID as an affiliate code, lolz
149         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
150         {
151             // update last affiliate 
152             plyr_[_pID].laff = _affCode;
153         } else if (_affCode == _pID) {
154             _affCode = 0;
155         }
156         
157         // register name 
158         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
159     }
160 
161     function registerNameXaddr(string _nameString, address _affCode, bool _all)
162         isHuman()
163         public
164         payable
165     {
166         // make sure name fees paid
167         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
168         
169         // filter name + condition checks
170         bytes32 _name = NameFilter.nameFilter(_nameString);
171         
172         // set up address 
173         address _addr = msg.sender;
174         
175         // set up our tx event data and determine if player is new or not
176         bool _isNewPlayer = determinePID(_addr);
177         
178         // fetch player id
179         uint256 _pID = pIDxAddr_[_addr];
180         
181         // manage affiliate residuals
182         // if no affiliate code was given or player tried to use their own, lolz
183         uint256 _affID;
184         if (_affCode != address(0) && _affCode != _addr)
185         {
186             // get affiliate ID from aff Code 
187             _affID = pIDxAddr_[_affCode];
188             
189             // if affID is not the same as previously stored 
190             if (_affID != plyr_[_pID].laff)
191             {
192                 // update last affiliate
193                 plyr_[_pID].laff = _affID;
194             }
195         }
196         
197         // register name 
198         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
199     }
200 
201     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
202         isHuman()
203         public
204         payable
205     {
206         // make sure name fees paid
207         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
208         
209         // filter name + condition checks
210         bytes32 _name = NameFilter.nameFilter(_nameString);
211         
212         // set up address 
213         address _addr = msg.sender;
214         
215         // set up our tx event data and determine if player is new or not
216         bool _isNewPlayer = determinePID(_addr);
217         
218         // fetch player id
219         uint256 _pID = pIDxAddr_[_addr];
220         
221         // manage affiliate residuals
222         // if no affiliate code was given or player tried to use their own, lolz
223         uint256 _affID;
224         if (_affCode != "" && _affCode != _name)
225         {
226             // get affiliate ID from aff Code 
227             _affID = pIDxName_[_affCode];
228             
229             // if affID is not the same as previously stored 
230             if (_affID != plyr_[_pID].laff)
231             {
232                 // update last affiliate
233                 plyr_[_pID].laff = _affID;
234             }
235         }
236         
237         // register name 
238         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
239     }
240 
241     /**
242      * @dev players, if you registered a profile, before a game was released, or
243      * set the all bool to false when you registered, use this function to push
244      * your profile to a single game.  also, if you've  updated your name, you
245      * can use this to push your name to games of your choosing.
246      * -functionhash- 0x81c5b206
247      * @param _gameID game id 
248      */
249     function addMeToGame(uint256 _gameID)
250         isHuman()
251         public
252     {
253         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
254         address _addr = msg.sender;
255         uint256 _pID = pIDxAddr_[_addr];
256         require(_pID != 0, "hey there buddy, you dont even have an account");
257         uint256 _totalNames = plyr_[_pID].names;
258 
259         // add players profile and most recent name
260         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
261         
262         // add list of all names
263         if (_totalNames > 1)
264             for (uint256 ii = 1; ii <= _totalNames; ii++)
265                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
266     }
267 
268     /**
269      * @dev players, use this to push your player profile to all registered games.
270      * -functionhash- 0x0c6940ea
271      */
272     function addMeToAllGames()
273         isHuman()
274         public
275     {
276         address _addr = msg.sender;
277         uint256 _pID = pIDxAddr_[_addr];
278         require(_pID != 0, "hey there buddy, you dont even have an account");
279         uint256 _laff = plyr_[_pID].laff;
280         uint256 _totalNames = plyr_[_pID].names;
281         bytes32 _name = plyr_[_pID].name;
282 
283         for (uint256 i = 1; i <= gID_; i++)
284         {
285             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
286             if (_totalNames > 1)
287                 for (uint256 ii = 1; ii <= _totalNames; ii++)
288                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
289         }
290 
291     }
292 
293     /**
294      * @dev players use this to change back to one of your old names.  tip, you'll
295      * still need to push that info to existing games.
296      * -functionhash- 0xb9291296
297      * @param _nameString the name you want to use 
298      */
299     function useMyOldName(string _nameString)
300         isHuman()
301         public 
302     {
303         // filter name, and get pID
304         bytes32 _name = _nameString.nameFilter();
305         uint256 _pID = pIDxAddr_[msg.sender];
306         
307         // make sure they own the name 
308         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
309         
310         // update their current name 
311         plyr_[_pID].name = _name;
312     }
313 
314 //==============================================================================
315 //     _ _  _ _   | _  _ . _  .
316 //    (_(_)| (/_  |(_)(_||(_  .
317 //=====================_|=======================================================
318     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
319         private
320     {
321         // if names already has been used, require that current msg sender owns the name
322         if (pIDxName_[_name] != 0)
323             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
324 
325         // add name to player profile, registry, and name book
326         plyr_[_pID].name = _name;
327         pIDxName_[_name] = _pID;
328         if (plyrNames_[_pID][_name] == false)
329         {
330             plyrNames_[_pID][_name] = true;
331             plyr_[_pID].names++;
332             plyrNameList_[_pID][plyr_[_pID].names] = _name;
333         }
334 
335         // registration fee goes directly to community rewards
336         admin.transfer(address(this).balance);
337 
338         // push player info to games
339         if (_all == true)
340             for (uint256 i = 1; i <= gID_; i++)
341                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
342 
343         // fire event
344         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
345     }
346 //==============================================================================
347 //    _|_ _  _ | _  .
348 //     | (_)(_)|_\  .
349 //==============================================================================
350     function determinePID(address _addr)
351         private
352         returns (bool)
353     {
354         if (pIDxAddr_[_addr] == 0)
355         {
356             pID_++;
357             pIDxAddr_[_addr] = pID_;
358             plyr_[pID_].addr = _addr;
359 
360             // set the new player bool to true
361             return (true);
362         } else {
363             return (false);
364         }
365     }
366 //==============================================================================
367 //   _   _|_ _  _ _  _ |   _ _ || _  .
368 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
369 //==============================================================================
370     function getPlayerID(address _addr)
371         isRegisteredGame()
372         external
373         returns (uint256)
374     {
375         determinePID(_addr);
376         return (pIDxAddr_[_addr]);
377     }
378     function getPlayerName(uint256 _pID)
379         external
380         view
381         returns (bytes32)
382     {
383         return (plyr_[_pID].name);
384     }
385     function getPlayerLAff(uint256 _pID)
386         external
387         view
388         returns (uint256)
389     {
390         return (plyr_[_pID].laff);
391     }
392     function getPlayerAddr(uint256 _pID)
393         external
394         view
395         returns (address)
396     {
397         return (plyr_[_pID].addr);
398     }
399     function getNameFee()
400         external
401         view
402         returns (uint256)
403     {
404         return(registrationFee_);
405     }
406     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
407         isRegisteredGame()
408         external
409         payable
410         returns(bool, uint256)
411     {
412         // make sure name fees paid
413         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
414         
415         // set up our tx event data and determine if player is new or not
416         bool _isNewPlayer = determinePID(_addr);
417         
418         // fetch player id
419         uint256 _pID = pIDxAddr_[_addr];
420         
421         // manage affiliate residuals
422         // if no affiliate code was given, no new affiliate code was given, or the 
423         // player tried to use their own pID as an affiliate code, lolz
424         uint256 _affID = _affCode;
425         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
426         {
427             // update last affiliate 
428             plyr_[_pID].laff = _affID;
429         } else if (_affID == _pID) {
430             _affID = 0;
431         }
432 
433         // register name 
434         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
435 
436         return(_isNewPlayer, _affID);
437     }
438     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
439         isRegisteredGame()
440         external
441         payable
442         returns(bool, uint256)
443     {
444         // make sure name fees paid
445         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
446         
447         // set up our tx event data and determine if player is new or not
448         bool _isNewPlayer = determinePID(_addr);
449         
450         // fetch player id
451         uint256 _pID = pIDxAddr_[_addr];
452         
453         // manage affiliate residuals
454         // if no affiliate code was given or player tried to use their own, lolz
455         uint256 _affID;
456         if (_affCode != address(0) && _affCode != _addr)
457         {
458             // get affiliate ID from aff Code 
459             _affID = pIDxAddr_[_affCode];
460             
461             // if affID is not the same as previously stored 
462             if (_affID != plyr_[_pID].laff)
463             {
464                 // update last affiliate
465                 plyr_[_pID].laff = _affID;
466             }
467         }
468         
469         // register name 
470         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
471 
472         return(_isNewPlayer, _affID);
473     }
474     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
475         isRegisteredGame()
476         external
477         payable
478         returns(bool, uint256)
479     {
480         // make sure name fees paid
481         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
482         
483         // set up our tx event data and determine if player is new or not
484         bool _isNewPlayer = determinePID(_addr);
485         
486         // fetch player id
487         uint256 _pID = pIDxAddr_[_addr];
488         
489         // manage affiliate residuals
490         // if no affiliate code was given or player tried to use their own, lolz
491         uint256 _affID;
492         if (_affCode != "" && _affCode != _name)
493         {
494             // get affiliate ID from aff Code 
495             _affID = pIDxName_[_affCode];
496             
497             // if affID is not the same as previously stored 
498             if (_affID != plyr_[_pID].laff)
499             {
500                 // update last affiliate
501                 plyr_[_pID].laff = _affID;
502             }
503         }
504         
505         // register name 
506         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
507 
508         return(_isNewPlayer, _affID);
509     }
510 
511 //==============================================================================
512 //   _ _ _|_    _   .
513 //  _\(/_ | |_||_)  .
514 //=============|================================================================
515     function addGame(address _gameAddress, string _gameNameStr)
516         public
517     {
518         require(admin == msg.sender,"Oops, only admin can add the games");
519         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
520             gID_++;
521             bytes32 _name = _gameNameStr.nameFilter();
522             gameIDs_[_gameAddress] = gID_;
523             gameNames_[_gameAddress] = _name;
524             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
525 
526             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
527             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
528             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
529             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
530     }
531 
532     function setRegistrationFee(uint256 _fee)
533         public
534     {
535       require(admin == msg.sender,"Oops, only admin can change the fees");
536       registrationFee_ = _fee;
537     }
538 
539 }
540 
541 
542 library NameFilter {
543 
544     /**
545      * @dev filters name strings
546      * -converts uppercase to lower case.  
547      * -makes sure it does not start/end with a space
548      * -makes sure it does not contain multiple spaces in a row
549      * -cannot be only numbers
550      * -cannot start with 0x 
551      * -restricts characters to A-Z, a-z, 0-9, and space.
552      * @return reprocessed string in bytes32 format
553      */
554     function nameFilter(string _input)
555         internal
556         pure
557         returns(bytes32)
558     {
559         bytes memory _temp = bytes(_input);
560         uint256 _length = _temp.length;
561 
562         //sorry limited to 32 characters
563         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
564         // make sure it doesnt start with or end with space
565         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
566         // make sure first two characters are not 0x
567         if (_temp[0] == 0x30)
568         {
569             require(_temp[1] != 0x78, "string cannot start with 0x");
570             require(_temp[1] != 0x58, "string cannot start with 0X");
571         }
572         
573         // create a bool to track if we have a non number character
574         bool _hasNonNumber;
575         
576         // convert & check
577         for (uint256 i = 0; i < _length; i++)
578         {
579             // if its uppercase A-Z
580             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
581             {
582                 // convert to lower case a-z
583                 _temp[i] = byte(uint(_temp[i]) + 32);
584                 
585                 // we have a non number
586                 if (_hasNonNumber == false)
587                     _hasNonNumber = true;
588             } else {
589                 require
590                 (
591                     // require character is a space
592                     _temp[i] == 0x20 || 
593                     // OR lowercase a-z
594                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
595                     // or 0-9
596                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
597                     "string contains invalid characters"
598                 );
599                 // make sure theres not 2x spaces in a row
600                 if (_temp[i] == 0x20)
601                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
602                 
603                 // see if we have a character other than a number
604                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
605                     _hasNonNumber = true;
606             }
607         }
608 
609         require(_hasNonNumber == true, "string cannot be only numbers");
610 
611         bytes32 _ret;
612         assembly {
613             _ret := mload(add(_temp, 32))
614         }
615         return (_ret);
616     }
617 }
618 
619 /**
620  * @title SafeMath v0.1.9
621  * @dev Math operations with safety checks that throw on error
622  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
623  * - added sqrt
624  * - added sq
625  * - added pwr 
626  * - changed asserts to requires with error log outputs
627  * - removed div, its useless
628  */
629 library SafeMath {
630     
631     /**
632     * @dev Multiplies two numbers, throws on overflow.
633     */
634     function mul(uint256 a, uint256 b) 
635         internal 
636         pure 
637         returns (uint256 c) 
638     {
639         if (a == 0) {
640             return 0;
641         }
642         c = a * b;
643         require(c / a == b, "SafeMath mul failed");
644         return c;
645     }
646 
647     /**
648     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
649     */
650     function sub(uint256 a, uint256 b)
651         internal
652         pure
653         returns (uint256) 
654     {
655         require(b <= a, "SafeMath sub failed");
656         return a - b;
657     }
658 
659     /**
660     * @dev Adds two numbers, throws on overflow.
661     */
662     function add(uint256 a, uint256 b)
663         internal
664         pure
665         returns (uint256 c) 
666     {
667         c = a + b;
668         require(c >= a, "SafeMath add failed");
669         return c;
670     }
671     
672     /**
673      * @dev gives square root of given x.
674      */
675     function sqrt(uint256 x)
676         internal
677         pure
678         returns (uint256 y) 
679     {
680         uint256 z = ((add(x,1)) / 2);
681         y = x;
682         while (z < y) 
683         {
684             y = z;
685             z = ((add((x / z),z)) / 2);
686         }
687     }
688     
689     /**
690      * @dev gives square. multiplies x by x
691      */
692     function sq(uint256 x)
693         internal
694         pure
695         returns (uint256)
696     {
697         return (mul(x,x));
698     }
699     
700     /**
701      * @dev x to the power of y 
702      */
703     function pwr(uint256 x, uint256 y)
704         internal
705         pure
706         returns (uint256)
707     {
708         if (x==0)
709             return (0);
710         else if (y==0)
711             return (1);
712         else
713         {
714             uint256 z = x;
715             for (uint256 i=1; i < y; i++)
716                 z = mul(z,x);
717             return (z);
718         }
719     }
720 }