1 pragma solidity ^0.4.24;
2 
3 /*--------------------------------------------------------------
4    ____  _                         ____              _    
5   |  _ \| | __ _ _   _  ___ _ __  | __ )  ___   ___ | | __
6   | |_) | |/ _` | | | |/ _ \ '__| |  _ \ / _ \ / _ \| |/ /
7   |  __/| | (_| | |_| |  __/ |    | |_) | (_) | (_) |   < 
8   |_|   |_|\__,_|\__, |\___|_|    |____/ \___/ \___/|_|\_\
9                  |___/                                    
10                                                    2018-08-08
11 --------------------------------------------------------------*/
12 
13 interface PlayerBookReceiverInterface {
14     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
15     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
16 }
17 
18 contract PlayerBook {
19     using NameFilter for string;
20     using SafeMath for uint256;
21     
22     address private admin = msg.sender;
23 //==============================================================================
24 //     _| _ _|_ _    _ _ _|_    _   .
25 //    (_|(_| | (_|  _\(/_ | |_||_)  .
26 //=============================|================================================    
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
38     struct Player {
39         address addr;
40         bytes32 name;
41         uint256 laff;
42         uint256 names;
43     }
44 //==============================================================================
45 //     _ _  _  __|_ _    __|_ _  _  .
46 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
47 //==============================================================================    
48     constructor()
49         public
50     {
51         // premine the dev names (sorry not sorry)
52             // No keys are purchased with this method, it's simply locking our addresses,
53             // PID's and names for referral codes.
54         plyr_[1].addr = 0x512D75B898fcB04f7E2496Fa746D94B10836282e;
55         plyr_[1].name = "Justo";
56         plyr_[1].names = 1;
57         pIDxAddr_[0x512D75B898fcB04f7E2496Fa746D94B10836282e] = 1;
58         pIDxName_["Justo"] = 1;
59         plyrNames_[1]["Justo"] = true;
60         plyrNameList_[1][1] = "Justo";
61         
62         
63         
64         
65         
66         
67         pID_ = 4;
68     }
69 //==============================================================================
70 //     _ _  _  _|. |`. _  _ _  .
71 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
72 //==============================================================================    
73     /**
74      * @dev prevents contracts from interacting with fomo3d 
75      */
76     modifier isHuman() {
77         address _addr = msg.sender;
78         uint256 _codeLength;
79         
80         assembly {_codeLength := extcodesize(_addr)}
81         require(_codeLength == 0, "sorry humans only");
82         _;
83     }
84 
85     modifier onlyDevs() 
86     {
87         require(admin == msg.sender, "msg sender is not a dev");
88         _;
89     }
90     
91     modifier isRegisteredGame()
92     {
93         require(gameIDs_[msg.sender] != 0);
94         _;
95     }
96 //==============================================================================
97 //     _    _  _ _|_ _  .
98 //    (/_\/(/_| | | _\  .
99 //==============================================================================    
100     // fired whenever a player registers a name
101     event onNewName
102     (
103         uint256 indexed playerID,
104         address indexed playerAddress,
105         bytes32 indexed playerName,
106         bool isNewPlayer,
107         uint256 affiliateID,
108         address affiliateAddress,
109         bytes32 affiliateName,
110         uint256 amountPaid,
111         uint256 timeStamp
112     );
113 //==============================================================================
114 //     _  _ _|__|_ _  _ _  .
115 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
116 //=====_|=======================================================================
117     function checkIfNameValid(string _nameStr)
118         public
119         view
120         returns(bool)
121     {
122         bytes32 _name = _nameStr.nameFilter();
123         if (pIDxName_[_name] == 0)
124             return (true);
125         else 
126             return (false);
127     }
128 //==============================================================================
129 //     _    |_ |. _   |`    _  __|_. _  _  _  .
130 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
131 //====|=========================================================================    
132     /**
133      * @dev registers a name.  UI will always display the last name you registered.
134      * but you will still own all previously registered names to use as affiliate 
135      * links.
136      * - must pay a registration fee.
137      * - name must be unique
138      * - names will be converted to lowercase
139      * - name cannot start or end with a space 
140      * - cannot have more than 1 space in a row
141      * - cannot be only numbers
142      * - cannot start with 0x 
143      * - name must be at least 1 char
144      * - max length of 32 characters long
145      * - allowed characters: a-z, 0-9, and space
146      * -functionhash- 0x921dec21 (using ID for affiliate)
147      * -functionhash- 0x3ddd4698 (using address for affiliate)
148      * -functionhash- 0x685ffd83 (using name for affiliate)
149      * @param _nameString players desired name
150      * @param _affCode affiliate ID, address, or name of who refered you
151      * @param _all set to true if you want this to push your info to all games 
152      * (this might cost a lot of gas)
153      */
154     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
155         isHuman()
156         public
157         payable 
158     {
159         // make sure name fees paid
160         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
161         
162         // filter name + condition checks
163         bytes32 _name = NameFilter.nameFilter(_nameString);
164         
165         // set up address 
166         address _addr = msg.sender;
167         
168         // set up our tx event data and determine if player is new or not
169         bool _isNewPlayer = determinePID(_addr);
170         
171         // fetch player id
172         uint256 _pID = pIDxAddr_[_addr];
173         
174         // manage affiliate residuals
175         // if no affiliate code was given, no new affiliate code was given, or the 
176         // player tried to use their own pID as an affiliate code, lolz
177         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
178         {
179             // update last affiliate 
180             plyr_[_pID].laff = _affCode;
181         } else if (_affCode == _pID) {
182             _affCode = 0;
183         }
184         
185         // register name 
186         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
187     }
188     
189     function registerNameXaddr(string _nameString, address _affCode, bool _all)
190         isHuman()
191         public
192         payable 
193     {
194         // make sure name fees paid
195         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
196         
197         // filter name + condition checks
198         bytes32 _name = NameFilter.nameFilter(_nameString);
199         
200         // set up address 
201         address _addr = msg.sender;
202         
203         // set up our tx event data and determine if player is new or not
204         bool _isNewPlayer = determinePID(_addr);
205         
206         // fetch player id
207         uint256 _pID = pIDxAddr_[_addr];
208         
209         // manage affiliate residuals
210         // if no affiliate code was given or player tried to use their own, lolz
211         uint256 _affID;
212         if (_affCode != address(0) && _affCode != _addr)
213         {
214             // get affiliate ID from aff Code 
215             _affID = pIDxAddr_[_affCode];
216             
217             // if affID is not the same as previously stored 
218             if (_affID != plyr_[_pID].laff)
219             {
220                 // update last affiliate
221                 plyr_[_pID].laff = _affID;
222             }
223         }
224         
225         // register name 
226         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
227     }
228     
229     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
230         isHuman()
231         public
232         payable 
233     {
234         // make sure name fees paid
235         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
236         
237         // filter name + condition checks
238         bytes32 _name = NameFilter.nameFilter(_nameString);
239         
240         // set up address 
241         address _addr = msg.sender;
242         
243         // set up our tx event data and determine if player is new or not
244         bool _isNewPlayer = determinePID(_addr);
245         
246         // fetch player id
247         uint256 _pID = pIDxAddr_[_addr];
248         
249         // manage affiliate residuals
250         // if no affiliate code was given or player tried to use their own, lolz
251         uint256 _affID;
252         if (_affCode != "" && _affCode != _name)
253         {
254             // get affiliate ID from aff Code 
255             _affID = pIDxName_[_affCode];
256             
257             // if affID is not the same as previously stored 
258             if (_affID != plyr_[_pID].laff)
259             {
260                 // update last affiliate
261                 plyr_[_pID].laff = _affID;
262             }
263         }
264         
265         // register name 
266         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
267     }
268     
269     /**
270      * @dev players, if you registered a profile, before a game was released, or
271      * set the all bool to false when you registered, use this function to push
272      * your profile to a single game.  also, if you've  updated your name, you
273      * can use this to push your name to games of your choosing.
274      * -functionhash- 0x81c5b206
275      * @param _gameID game id 
276      */
277     function addMeToGame(uint256 _gameID)
278         isHuman()
279         public
280     {
281         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
282         address _addr = msg.sender;
283         uint256 _pID = pIDxAddr_[_addr];
284         require(_pID != 0, "hey there buddy, you dont even have an account");
285         uint256 _totalNames = plyr_[_pID].names;
286         
287         // add players profile and most recent name
288         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
289         
290         // add list of all names
291         if (_totalNames > 1)
292             for (uint256 ii = 1; ii <= _totalNames; ii++)
293                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
294     }
295     
296     /**
297      * @dev players, use this to push your player profile to all registered games.
298      * -functionhash- 0x0c6940ea
299      */
300     function addMeToAllGames()
301         isHuman()
302         public
303     {
304         address _addr = msg.sender;
305         uint256 _pID = pIDxAddr_[_addr];
306         require(_pID != 0, "hey there buddy, you dont even have an account");
307         uint256 _laff = plyr_[_pID].laff;
308         uint256 _totalNames = plyr_[_pID].names;
309         bytes32 _name = plyr_[_pID].name;
310         
311         for (uint256 i = 1; i <= gID_; i++)
312         {
313             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
314             if (_totalNames > 1)
315                 for (uint256 ii = 1; ii <= _totalNames; ii++)
316                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
317         }
318                 
319     }
320     
321     /**
322      * @dev players use this to change back to one of your old names.  tip, you'll
323      * still need to push that info to existing games.
324      * -functionhash- 0xb9291296
325      * @param _nameString the name you want to use 
326      */
327     function useMyOldName(string _nameString)
328         isHuman()
329         public 
330     {
331         // filter name, and get pID
332         bytes32 _name = _nameString.nameFilter();
333         uint256 _pID = pIDxAddr_[msg.sender];
334         
335         // make sure they own the name 
336         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
337         
338         // update their current name 
339         plyr_[_pID].name = _name;
340     }
341     
342 //==============================================================================
343 //     _ _  _ _   | _  _ . _  .
344 //    (_(_)| (/_  |(_)(_||(_  . 
345 //=====================_|=======================================================    
346     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
347         private
348     {
349         // if names already has been used, require that current msg sender owns the name
350         if (pIDxName_[_name] != 0)
351             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
352         
353         // add name to player profile, registry, and name book
354         plyr_[_pID].name = _name;
355         pIDxName_[_name] = _pID;
356         if (plyrNames_[_pID][_name] == false)
357         {
358             plyrNames_[_pID][_name] = true;
359             plyr_[_pID].names++;
360             plyrNameList_[_pID][plyr_[_pID].names] = _name;
361         }
362         
363         // registration fee goes directly to community rewards
364         admin.transfer(address(this).balance);
365         
366         // push player info to games
367         if (_all == true)
368             for (uint256 i = 1; i <= gID_; i++)
369                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
370         
371         // fire event
372         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
373     }
374 //==============================================================================
375 //    _|_ _  _ | _  .
376 //     | (_)(_)|_\  .
377 //==============================================================================    
378     function determinePID(address _addr)
379         private
380         returns (bool)
381     {
382         if (pIDxAddr_[_addr] == 0)
383         {
384             pID_++;
385             pIDxAddr_[_addr] = pID_;
386             plyr_[pID_].addr = _addr;
387             
388             // set the new player bool to true
389             return (true);
390         } else {
391             return (false);
392         }
393     }
394 //==============================================================================
395 //   _   _|_ _  _ _  _ |   _ _ || _  .
396 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
397 //==============================================================================
398     function getPlayerID(address _addr)
399         isRegisteredGame()
400         external
401         returns (uint256)
402     {
403         determinePID(_addr);
404         return (pIDxAddr_[_addr]);
405     }
406     function getPlayerName(uint256 _pID)
407         external
408         view
409         returns (bytes32)
410     {
411         return (plyr_[_pID].name);
412     }
413     function getPlayerLAff(uint256 _pID)
414         external
415         view
416         returns (uint256)
417     {
418         return (plyr_[_pID].laff);
419     }
420     function getPlayerAddr(uint256 _pID)
421         external
422         view
423         returns (address)
424     {
425         return (plyr_[_pID].addr);
426     }
427     function getNameFee()
428         external
429         view
430         returns (uint256)
431     {
432         return(registrationFee_);
433     }
434     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
435         isRegisteredGame()
436         external
437         payable
438         returns(bool, uint256)
439     {
440         // make sure name fees paid
441         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
442         
443         // set up our tx event data and determine if player is new or not
444         bool _isNewPlayer = determinePID(_addr);
445         
446         // fetch player id
447         uint256 _pID = pIDxAddr_[_addr];
448         
449         // manage affiliate residuals
450         // if no affiliate code was given, no new affiliate code was given, or the 
451         // player tried to use their own pID as an affiliate code, lolz
452         uint256 _affID = _affCode;
453         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
454         {
455             // update last affiliate 
456             plyr_[_pID].laff = _affID;
457         } else if (_affID == _pID) {
458             _affID = 0;
459         }
460         
461         // register name 
462         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
463         
464         return(_isNewPlayer, _affID);
465     }
466     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
467         isRegisteredGame()
468         external
469         payable
470         returns(bool, uint256)
471     {
472         // make sure name fees paid
473         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
474         
475         // set up our tx event data and determine if player is new or not
476         bool _isNewPlayer = determinePID(_addr);
477         
478         // fetch player id
479         uint256 _pID = pIDxAddr_[_addr];
480         
481         // manage affiliate residuals
482         // if no affiliate code was given or player tried to use their own, lolz
483         uint256 _affID;
484         if (_affCode != address(0) && _affCode != _addr)
485         {
486             // get affiliate ID from aff Code 
487             _affID = pIDxAddr_[_affCode];
488             
489             // if affID is not the same as previously stored 
490             if (_affID != plyr_[_pID].laff)
491             {
492                 // update last affiliate
493                 plyr_[_pID].laff = _affID;
494             }
495         }
496         
497         // register name 
498         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
499         
500         return(_isNewPlayer, _affID);
501     }
502     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
503         isRegisteredGame()
504         external
505         payable
506         returns(bool, uint256)
507     {
508         // make sure name fees paid
509         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
510         
511         // set up our tx event data and determine if player is new or not
512         bool _isNewPlayer = determinePID(_addr);
513         
514         // fetch player id
515         uint256 _pID = pIDxAddr_[_addr];
516         
517         // manage affiliate residuals
518         // if no affiliate code was given or player tried to use their own, lolz
519         uint256 _affID;
520         if (_affCode != "" && _affCode != _name)
521         {
522             // get affiliate ID from aff Code 
523             _affID = pIDxName_[_affCode];
524             
525             // if affID is not the same as previously stored 
526             if (_affID != plyr_[_pID].laff)
527             {
528                 // update last affiliate
529                 plyr_[_pID].laff = _affID;
530             }
531         }
532         
533         // register name 
534         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
535         
536         return(_isNewPlayer, _affID);
537     }
538     
539 //==============================================================================
540 //   _ _ _|_    _   .
541 //  _\(/_ | |_||_)  .
542 //=============|================================================================
543     function addGame(address _gameAddress, string _gameNameStr)
544         onlyDevs()
545         public
546     {
547         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
548             gID_++;
549             bytes32 _name = _gameNameStr.nameFilter();
550             gameIDs_[_gameAddress] = gID_;
551             gameNames_[_gameAddress] = _name;
552             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
553         
554             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
555             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
556             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
557             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
558     }
559     
560     function setRegistrationFee(uint256 _fee)
561         onlyDevs()
562         public
563     {
564       registrationFee_ = _fee;
565     }
566         
567 } 
568 
569 /**
570 * @title -Name Filter- v0.1.9
571 */
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
585         internal
586         pure
587         returns(bytes32)
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
621                     // require character is a space
622                     _temp[i] == 0x20 || 
623                     // OR lowercase a-z
624                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
625                     // or 0-9
626                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
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
665         internal 
666         pure 
667         returns (uint256 c) 
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
681         internal
682         pure
683         returns (uint256) 
684     {
685         require(b <= a, "SafeMath sub failed");
686         return a - b;
687     }
688 
689     /**
690     * @dev Adds two numbers, throws on overflow.
691     */
692     function add(uint256 a, uint256 b)
693         internal
694         pure
695         returns (uint256 c) 
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
706         internal
707         pure
708         returns (uint256 y) 
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
723         internal
724         pure
725         returns (uint256)
726     {
727         return (mul(x,x));
728     }
729     
730     /**
731      * @dev x to the power of y 
732      */
733     function pwr(uint256 x, uint256 y)
734         internal 
735         pure 
736         returns (uint256)
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