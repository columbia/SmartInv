1 pragma solidity ^0.4.24;
2 /*
3  * -PlayerBook - v0.3.14
4     
5  */
6 
7 interface H4DPlayerBook {
8     function deposit() external payable;
9 }
10 
11 interface PlayerBookReceiverInterface {
12     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
13     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
14 }
15 
16 interface TeamJustInterface {
17     function requiredSignatures() external view returns(uint256);
18     function requiredDevSignatures() external view returns(uint256);
19     function adminCount() external view returns(uint256);
20     function devCount() external view returns(uint256);
21     function adminName(address _who) external view returns(bytes32);
22     function isAdmin(address _who) external view returns(bool);
23     function isDev(address _who) external view returns(bool);
24 }
25 
26 contract PlayerBook {
27     using NameFilter for string;
28     using SafeMath for uint256;
29     // CHANGEME
30     // this is now the HoDL4D Playerbook
31     address constant private Jekyll_Island_Inc = address(0xfc256291687150b9dB4502e721a9e6e98fd1FE93);
32     //TeamJustInterface constant private TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
33     
34 
35 
36 
37 //==============================================================================
38 //     _| _ _|_ _    _ _ _|_    _   .
39 //    (_|(_| | (_|  _\(/_ | |_||_)  .
40 //=============================|================================================    
41     uint256 public registrationFee_ = 10 finney;            // price to register a name
42     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
43     mapping(address => bytes32) public gameNames_;          // lookup a games name
44     mapping(address => uint256) public gameIDs_;            // lokup a games ID
45     uint256 public gID_;        // total number of games
46     uint256 public pID_;        // total number of players
47     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
48     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
49     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
50     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
51     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
52     
53     mapping(address => bool) devs;
54 
55     struct Player {
56         address addr;
57         bytes32 name;
58         uint256 laff;
59         uint256 names;
60     }
61 //==============================================================================
62 //     _ _  _  __|_ _    __|_ _  _  .
63 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
64 //==============================================================================    
65     constructor()
66         public
67     {
68         devs[msg.sender] = true;
69     }
70 //==============================================================================
71 //     _ _  _  _|. |`. _  _ _  .
72 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
73 //==============================================================================    
74     /**
75      * @dev prevents contracts from interacting with fomo3d 
76      */
77     modifier isHuman() {
78         require(msg.sender==tx.origin);
79         _;
80     }
81     
82     modifier onlyDevs() 
83     {
84         require(devs[msg.sender]); //require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
85         _;
86     }
87     
88     modifier isRegisteredGame()
89     {
90         //require(gameIDs_[msg.sender] != 0);
91         _;
92     }
93 //==============================================================================
94 //     _    _  _ _|_ _  .
95 //    (/_\/(/_| | | _\  .
96 //==============================================================================    
97     // fired whenever a player registers a name
98     event onNewName
99     (
100         uint256 indexed playerID,
101         address indexed playerAddress,
102         bytes32 indexed playerName,
103         bool isNewPlayer,
104         uint256 affiliateID,
105         address affiliateAddress,
106         bytes32 affiliateName,
107         uint256 amountPaid,
108         uint256 timeStamp
109     );
110 //==============================================================================
111 //     _  _ _|__|_ _  _ _  .
112 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
113 //=====_|=======================================================================
114     function checkIfNameValid(string _nameStr)
115         public
116         view
117         returns(bool)
118     {
119         bytes32 _name = _nameStr.nameFilter();
120         if (pIDxName_[_name] == 0)
121             return (true);
122         else 
123             return (false);
124     }
125 //==============================================================================
126 //     _    |_ |. _   |`    _  __|_. _  _  _  .
127 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
128 //====|=========================================================================    
129     /**
130      * @dev registers a name.  UI will always display the last name you registered.
131      * but you will still own all previously registered names to use as affiliate 
132      * links.
133      * - must pay a registration fee.
134      * - name must be unique
135      * - names will be converted to lowercase
136      * - name cannot start or end with a space 
137      * - cannot have more than 1 space in a row
138      * - cannot be only numbers
139      * - cannot start with 0x 
140      * - name must be at least 1 char
141      * - max length of 32 characters long
142      * - allowed characters: a-z, 0-9, and space
143      * -functionhash- 0x921dec21 (using ID for affiliate)
144      * -functionhash- 0x3ddd4698 (using address for affiliate)
145      * -functionhash- 0x685ffd83 (using name for affiliate)
146      * @param _nameString players desired name
147      * @param _affCode affiliate ID, address, or name of who refered you
148      * @param _all set to true if you want this to push your info to all games 
149      * (this might cost a lot of gas)
150      */
151     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
152         isHuman()
153         public
154         payable 
155     {
156         // make sure name fees paid
157         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
158         
159         // filter name + condition checks
160         bytes32 _name = NameFilter.nameFilter(_nameString);
161         
162         // set up address 
163         address _addr = msg.sender;
164         
165         // set up our tx event data and determine if player is new or not
166         bool _isNewPlayer = determinePID(_addr);
167         
168         // fetch player id
169         uint256 _pID = pIDxAddr_[_addr];
170         
171         // manage affiliate residuals
172         // if no affiliate code was given, no new affiliate code was given, or the 
173         // player tried to use their own pID as an affiliate code, lolz
174         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
175         {
176             // update last affiliate 
177             plyr_[_pID].laff = _affCode;
178         } else if (_affCode == _pID) {
179             _affCode = 0;
180         }
181         
182         // register name 
183         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
184     }
185     
186     function registerNameXaddr(string _nameString, address _affCode, bool _all)
187         isHuman()
188         public
189         payable 
190     {
191         // make sure name fees paid
192         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
193         
194         // filter name + condition checks
195         bytes32 _name = NameFilter.nameFilter(_nameString);
196         
197         // set up address 
198         address _addr = msg.sender;
199         
200         // set up our tx event data and determine if player is new or not
201         bool _isNewPlayer = determinePID(_addr);
202         
203         // fetch player id
204         uint256 _pID = pIDxAddr_[_addr];
205         
206         // manage affiliate residuals
207         // if no affiliate code was given or player tried to use their own, lolz
208         uint256 _affID;
209         if (_affCode != address(0) && _affCode != _addr)
210         {
211             // get affiliate ID from aff Code 
212             _affID = pIDxAddr_[_affCode];
213             
214             // if affID is not the same as previously stored 
215             if (_affID != plyr_[_pID].laff)
216             {
217                 // update last affiliate
218                 plyr_[_pID].laff = _affID;
219             }
220         }
221         
222         // register name 
223         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
224     }
225     
226     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
227         isHuman()
228         public
229         payable 
230     {
231         // make sure name fees paid
232         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
233         
234         // filter name + condition checks
235         bytes32 _name = NameFilter.nameFilter(_nameString);
236         
237         // set up address 
238         address _addr = msg.sender;
239         
240         // set up our tx event data and determine if player is new or not
241         bool _isNewPlayer = determinePID(_addr);
242         
243         // fetch player id
244         uint256 _pID = pIDxAddr_[_addr];
245         
246         // manage affiliate residuals
247         // if no affiliate code was given or player tried to use their own, lolz
248         uint256 _affID;
249         if (_affCode != "" && _affCode != _name)
250         {
251             // get affiliate ID from aff Code 
252             _affID = pIDxName_[_affCode];
253             
254             // if affID is not the same as previously stored 
255             if (_affID != plyr_[_pID].laff)
256             {
257                 // update last affiliate
258                 plyr_[_pID].laff = _affID;
259             }
260         }
261         
262         // register name 
263         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
264     }
265     
266     /**
267      * @dev players, if you registered a profile, before a game was released, or
268      * set the all bool to false when you registered, use this function to push
269      * your profile to a single game.  also, if you've  updated your name, you
270      * can use this to push your name to games of your choosing.
271      * -functionhash- 0x81c5b206
272      * @param _gameID game id 
273      */
274     function addMeToGame(uint256 _gameID)
275         isHuman()
276         public
277     {
278         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
279         address _addr = msg.sender;
280         uint256 _pID = pIDxAddr_[_addr];
281         require(_pID != 0, "hey there buddy, you dont even have an account");
282         uint256 _totalNames = plyr_[_pID].names;
283         
284         // add players profile and most recent name
285         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
286         
287         // add list of all names
288         if (_totalNames > 1)
289             for (uint256 ii = 1; ii <= _totalNames; ii++)
290                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
291     }
292     
293     /**
294      * @dev players, use this to push your player profile to all registered games.
295      * -functionhash- 0x0c6940ea
296      */
297     function addMeToAllGames()
298         isHuman()
299         public
300     {
301         address _addr = msg.sender;
302         uint256 _pID = pIDxAddr_[_addr];
303         require(_pID != 0, "hey there buddy, you dont even have an account");
304         uint256 _laff = plyr_[_pID].laff;
305         uint256 _totalNames = plyr_[_pID].names;
306         bytes32 _name = plyr_[_pID].name;
307         
308         for (uint256 i = 1; i <= gID_; i++)
309         {
310             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
311             if (_totalNames > 1)
312                 for (uint256 ii = 1; ii <= _totalNames; ii++)
313                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
314         }
315                 
316     }
317     
318     /**
319      * @dev players use this to change back to one of your old names.  tip, you'll
320      * still need to push that info to existing games.
321      * -functionhash- 0xb9291296
322      * @param _nameString the name you want to use 
323      */
324     function useMyOldName(string _nameString)
325         isHuman()
326         public 
327     {
328         // filter name, and get pID
329         bytes32 _name = _nameString.nameFilter();
330         uint256 _pID = pIDxAddr_[msg.sender];
331         
332         // make sure they own the name 
333         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
334         
335         // update their current name 
336         plyr_[_pID].name = _name;
337     }
338     
339 //==============================================================================
340 //     _ _  _ _   | _  _ . _  .
341 //    (_(_)| (/_  |(_)(_||(_  . 
342 //=====================_|=======================================================    
343     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
344         private
345     {
346         // if names already has been used, require that current msg sender owns the name
347         if (pIDxName_[_name] != 0)
348             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
349         
350         // add name to player profile, registry, and name book
351         plyr_[_pID].name = _name;
352         pIDxName_[_name] = _pID;
353         if (plyrNames_[_pID][_name] == false)
354         {
355             plyrNames_[_pID][_name] = true;
356             plyr_[_pID].names++;
357             plyrNameList_[_pID][plyr_[_pID].names] = _name;
358         }
359         
360         // registration fee goes directly to community rewards
361         Jekyll_Island_Inc.transfer(address(this).balance);
362         
363         // push player info to games
364         if (_all == true)
365             for (uint256 i = 1; i <= gID_; i++)
366                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
367         
368         // fire event
369         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
370     }
371 //==============================================================================
372 //    _|_ _  _ | _  .
373 //     | (_)(_)|_\  .
374 //==============================================================================    
375     function determinePID(address _addr)
376         private
377         returns (bool)
378     {
379         if (pIDxAddr_[_addr] == 0)
380         {
381             pID_++;
382             pIDxAddr_[_addr] = pID_;
383             plyr_[pID_].addr = _addr;
384             
385             // set the new player bool to true
386             return (true);
387         } else {
388             return (false);
389         }
390     }
391 //==============================================================================
392 //   _   _|_ _  _ _  _ |   _ _ || _  .
393 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
394 //==============================================================================
395     function getPlayerID(address _addr)
396         isRegisteredGame()
397         external
398         returns (uint256)
399     {
400         determinePID(_addr);
401         return (pIDxAddr_[_addr]);
402     }
403     function getPlayerName(uint256 _pID)
404         external
405         view
406         returns (bytes32)
407     {
408         return (plyr_[_pID].name);
409     }
410     function getPlayerLAff(uint256 _pID)
411         external
412         view
413         returns (uint256)
414     {
415         return (plyr_[_pID].laff);
416     }
417     function getPlayerAddr(uint256 _pID)
418         external
419         view
420         returns (address)
421     {
422         return (plyr_[_pID].addr);
423     }
424     function getNameFee()
425         external
426         view
427         returns (uint256)
428     {
429         return(registrationFee_);
430     }
431     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
432         isRegisteredGame()
433         external
434         payable
435         returns(bool, uint256)
436     {
437         // make sure name fees paid
438         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
439         
440         // set up our tx event data and determine if player is new or not
441         bool _isNewPlayer = determinePID(_addr);
442         
443         // fetch player id
444         uint256 _pID = pIDxAddr_[_addr];
445         
446         // manage affiliate residuals
447         // if no affiliate code was given, no new affiliate code was given, or the 
448         // player tried to use their own pID as an affiliate code, lolz
449         uint256 _affID = _affCode;
450         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
451         {
452             // update last affiliate 
453             plyr_[_pID].laff = _affID;
454         } else if (_affID == _pID) {
455             _affID = 0;
456         }
457         
458         // register name 
459         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
460         
461         return(_isNewPlayer, _affID);
462     }
463     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
464         isRegisteredGame()
465         external
466         payable
467         returns(bool, uint256)
468     {
469         // make sure name fees paid
470         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
471         
472         // set up our tx event data and determine if player is new or not
473         bool _isNewPlayer = determinePID(_addr);
474         
475         // fetch player id
476         uint256 _pID = pIDxAddr_[_addr];
477         
478         // manage affiliate residuals
479         // if no affiliate code was given or player tried to use their own, lolz
480         uint256 _affID;
481         if (_affCode != address(0) && _affCode != _addr)
482         {
483             // get affiliate ID from aff Code 
484             _affID = pIDxAddr_[_affCode];
485             
486             // if affID is not the same as previously stored 
487             if (_affID != plyr_[_pID].laff)
488             {
489                 // update last affiliate
490                 plyr_[_pID].laff = _affID;
491             }
492         }
493         
494         // register name 
495         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
496         
497         return(_isNewPlayer, _affID);
498     }
499     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
500         isRegisteredGame()
501         external
502         payable
503         returns(bool, uint256)
504     {
505         // make sure name fees paid
506         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
507         
508         // set up our tx event data and determine if player is new or not
509         bool _isNewPlayer = determinePID(_addr);
510         
511         // fetch player id
512         uint256 _pID = pIDxAddr_[_addr];
513         
514         // manage affiliate residuals
515         // if no affiliate code was given or player tried to use their own, lolz
516         uint256 _affID;
517         if (_affCode != "" && _affCode != _name)
518         {
519             // get affiliate ID from aff Code 
520             _affID = pIDxName_[_affCode];
521             
522             // if affID is not the same as previously stored 
523             if (_affID != plyr_[_pID].laff)
524             {
525                 // update last affiliate
526                 plyr_[_pID].laff = _affID;
527             }
528         }
529         
530         // register name 
531         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
532         
533         return(_isNewPlayer, _affID);
534     }
535     
536 //==============================================================================
537 //   _ _ _|_    _   .
538 //  _\(/_ | |_||_)  .
539 //=============|================================================================
540     function addGame(address _gameAddress, string _gameNameStr)
541         onlyDevs()
542         public
543     {
544         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
545         
546 
547             gID_++;
548             bytes32 _name = _gameNameStr.nameFilter();
549             gameIDs_[_gameAddress] = gID_;
550             gameNames_[_gameAddress] = _name;
551             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
552         
553             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
554             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
555             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
556             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
557         
558     }
559     
560     function setRegistrationFee(uint256 _fee)
561         onlyDevs()
562         public
563     {
564 
565             registrationFee_ = _fee;
566         
567     }
568         
569 } 
570 
571 /**
572 * @title -Name Filter- v0.1.9
573 *
574 */
575 library NameFilter {
576     
577     /**
578      * @dev filters name strings
579      * -converts uppercase to lower case.  
580      * -makes sure it does not start/end with a space
581      * -makes sure it does not contain multiple spaces in a row
582      * -cannot be only numbers
583      * -cannot start with 0x 
584      * -restricts characters to A-Z, a-z, 0-9, and space.
585      * @return reprocessed string in bytes32 format
586      */
587     function nameFilter(string _input)
588         internal
589         pure
590         returns(bytes32)
591     {
592         bytes memory _temp = bytes(_input);
593         uint256 _length = _temp.length;
594         
595         //sorry limited to 32 characters
596         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
597         // make sure it doesnt start with or end with space
598         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
599         // make sure first two characters are not 0x
600         if (_temp[0] == 0x30)
601         {
602             require(_temp[1] != 0x78, "string cannot start with 0x");
603             require(_temp[1] != 0x58, "string cannot start with 0X");
604         }
605         
606         // create a bool to track if we have a non number character
607         bool _hasNonNumber;
608         
609         // convert & check
610         for (uint256 i = 0; i < _length; i++)
611         {
612             // if its uppercase A-Z
613             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
614             {
615                 // convert to lower case a-z
616                 _temp[i] = byte(uint(_temp[i]) + 32);
617                 
618                 // we have a non number
619                 if (_hasNonNumber == false)
620                     _hasNonNumber = true;
621             } else {
622                 require
623                 (
624                     // require character is a space
625                     _temp[i] == 0x20 || 
626                     // OR lowercase a-z
627                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
628                     // or 0-9
629                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
630                     "string contains invalid characters"
631                 );
632                 // make sure theres not 2x spaces in a row
633                 if (_temp[i] == 0x20)
634                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
635                 
636                 // see if we have a character other than a number
637                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
638                     _hasNonNumber = true;    
639             }
640         }
641         
642         require(_hasNonNumber == true, "string cannot be only numbers");
643         
644         bytes32 _ret;
645         assembly {
646             _ret := mload(add(_temp, 32))
647         }
648         return (_ret);
649     }
650 }
651 
652 /**
653  * @title SafeMath v0.1.9
654  * @dev Math operations with safety checks that throw on error
655  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
656  * - added sqrt
657  * - added sq
658  * - added pwr 
659  * - changed asserts to requires with error log outputs
660  * - removed div, its useless
661  */
662 library SafeMath {
663     
664     /**
665     * @dev Multiplies two numbers, throws on overflow.
666     */
667     function mul(uint256 a, uint256 b) 
668         internal 
669         pure 
670         returns (uint256 c) 
671     {
672         if (a == 0) {
673             return 0;
674         }
675         c = a * b;
676         require(c / a == b, "SafeMath mul failed");
677         return c;
678     }
679 
680     /**
681     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
682     */
683     function sub(uint256 a, uint256 b)
684         internal
685         pure
686         returns (uint256) 
687     {
688         require(b <= a, "SafeMath sub failed");
689         return a - b;
690     }
691 
692     /**
693     * @dev Adds two numbers, throws on overflow.
694     */
695     function add(uint256 a, uint256 b)
696         internal
697         pure
698         returns (uint256 c) 
699     {
700         c = a + b;
701         require(c >= a, "SafeMath add failed");
702         return c;
703     }
704     
705     /**
706      * @dev gives square root of given x.
707      */
708     function sqrt(uint256 x)
709         internal
710         pure
711         returns (uint256 y) 
712     {
713         uint256 z = ((add(x,1)) / 2);
714         y = x;
715         while (z < y) 
716         {
717             y = z;
718             z = ((add((x / z),z)) / 2);
719         }
720     }
721     
722     /**
723      * @dev gives square. multiplies x by x
724      */
725     function sq(uint256 x)
726         internal
727         pure
728         returns (uint256)
729     {
730         return (mul(x,x));
731     }
732     
733     /**
734      * @dev x to the power of y 
735      */
736     function pwr(uint256 x, uint256 y)
737         internal 
738         pure 
739         returns (uint256)
740     {
741         if (x==0)
742             return (0);
743         else if (y==0)
744             return (1);
745         else 
746         {
747             uint256 z = x;
748             for (uint256 i=1; i < y; i++)
749                 z = mul(z,x);
750             return (z);
751         }
752     }
753 }