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
54         plyr_[1].addr = 0x9b7a49ba1B7a77568fC44c2db0d6e4BD958D9fe7;
55         plyr_[1].name = "kelvin";
56         plyr_[1].names = 1;
57         pIDxAddr_[0x9b7a49ba1B7a77568fC44c2db0d6e4BD958D9fe7] = 1;
58         pIDxName_["kelvin"] = 1;
59         plyrNames_[1]["kelvin"] = true;
60         plyrNameList_[1][1] = "kelvin";
61         
62         plyr_[2].addr = 0xFEd2968DE2407b0B5366Cd33A70aD7Bd29Bbb6A5;
63         plyr_[2].name = "leopard";
64         plyr_[2].names = 1;
65         pIDxAddr_[0xFEd2968DE2407b0B5366Cd33A70aD7Bd29Bbb6A5] = 2;
66         pIDxName_["leopard"] = 2;
67         plyrNames_[2]["leopard"] = true;
68         plyrNameList_[2][1] = "leopard";
69         
70         plyr_[3].addr = 0x7c476C8c8754b7bF7C72F3dcf37E67cE097D09e4;
71         plyr_[3].name = "eric";
72         plyr_[3].names = 1;
73         pIDxAddr_[0x7c476C8c8754b7bF7C72F3dcf37E67cE097D09e4] = 3;
74         pIDxName_["eric"] = 3;
75         plyrNames_[3]["eric"] = true;
76         plyrNameList_[3][1] = "eric";
77         
78         plyr_[4].addr = 0x2f38fba98218A3E85f56467Ca12B1525988b1892;
79         plyr_[4].name = "steven";
80         plyr_[4].names = 1;
81         pIDxAddr_[0x2f38fba98218A3E85f56467Ca12B1525988b1892] = 4;
82         pIDxName_["steven"] = 4;
83         plyrNames_[4]["steven"] = true;
84         plyrNameList_[4][1] = "steven";
85         
86         pID_ = 4;
87     }
88 //==============================================================================
89 //     _ _  _  _|. |`. _  _ _  .
90 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
91 //==============================================================================    
92     /**
93      * @dev prevents contracts from interacting with fomo3d 
94      */
95     modifier isHuman() {
96         address _addr = msg.sender;
97         uint256 _codeLength;
98         
99         assembly {_codeLength := extcodesize(_addr)}
100         require(_codeLength == 0, "sorry humans only");
101         _;
102     }
103 
104     modifier onlyDevs() 
105     {
106         require(admin == msg.sender, "msg sender is not a dev");
107         _;
108     }
109     
110     modifier isRegisteredGame()
111     {
112         require(gameIDs_[msg.sender] != 0);
113         _;
114     }
115 //==============================================================================
116 //     _    _  _ _|_ _  .
117 //    (/_\/(/_| | | _\  .
118 //==============================================================================    
119     // fired whenever a player registers a name
120     event onNewName
121     (
122         uint256 indexed playerID,
123         address indexed playerAddress,
124         bytes32 indexed playerName,
125         bool isNewPlayer,
126         uint256 affiliateID,
127         address affiliateAddress,
128         bytes32 affiliateName,
129         uint256 amountPaid,
130         uint256 timeStamp
131     );
132 //==============================================================================
133 //     _  _ _|__|_ _  _ _  .
134 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
135 //=====_|=======================================================================
136     function checkIfNameValid(string _nameStr)
137         public
138         view
139         returns(bool)
140     {
141         bytes32 _name = _nameStr.nameFilter();
142         if (pIDxName_[_name] == 0)
143             return (true);
144         else 
145             return (false);
146     }
147 //==============================================================================
148 //     _    |_ |. _   |`    _  __|_. _  _  _  .
149 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
150 //====|=========================================================================    
151     /**
152      * @dev registers a name.  UI will always display the last name you registered.
153      * but you will still own all previously registered names to use as affiliate 
154      * links.
155      * - must pay a registration fee.
156      * - name must be unique
157      * - names will be converted to lowercase
158      * - name cannot start or end with a space 
159      * - cannot have more than 1 space in a row
160      * - cannot be only numbers
161      * - cannot start with 0x 
162      * - name must be at least 1 char
163      * - max length of 32 characters long
164      * - allowed characters: a-z, 0-9, and space
165      * -functionhash- 0x921dec21 (using ID for affiliate)
166      * -functionhash- 0x3ddd4698 (using address for affiliate)
167      * -functionhash- 0x685ffd83 (using name for affiliate)
168      * @param _nameString players desired name
169      * @param _affCode affiliate ID, address, or name of who refered you
170      * @param _all set to true if you want this to push your info to all games 
171      * (this might cost a lot of gas)
172      */
173     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
174         isHuman()
175         public
176         payable 
177     {
178         // make sure name fees paid
179         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
180         
181         // filter name + condition checks
182         bytes32 _name = NameFilter.nameFilter(_nameString);
183         
184         // set up address 
185         address _addr = msg.sender;
186         
187         // set up our tx event data and determine if player is new or not
188         bool _isNewPlayer = determinePID(_addr);
189         
190         // fetch player id
191         uint256 _pID = pIDxAddr_[_addr];
192         
193         // manage affiliate residuals
194         // if no affiliate code was given, no new affiliate code was given, or the 
195         // player tried to use their own pID as an affiliate code, lolz
196         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
197         {
198             // update last affiliate 
199             plyr_[_pID].laff = _affCode;
200         } else if (_affCode == _pID) {
201             _affCode = 0;
202         }
203         
204         // register name 
205         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
206     }
207     
208     function registerNameXaddr(string _nameString, address _affCode, bool _all)
209         isHuman()
210         public
211         payable 
212     {
213         // make sure name fees paid
214         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
215         
216         // filter name + condition checks
217         bytes32 _name = NameFilter.nameFilter(_nameString);
218         
219         // set up address 
220         address _addr = msg.sender;
221         
222         // set up our tx event data and determine if player is new or not
223         bool _isNewPlayer = determinePID(_addr);
224         
225         // fetch player id
226         uint256 _pID = pIDxAddr_[_addr];
227         
228         // manage affiliate residuals
229         // if no affiliate code was given or player tried to use their own, lolz
230         uint256 _affID;
231         if (_affCode != address(0) && _affCode != _addr)
232         {
233             // get affiliate ID from aff Code 
234             _affID = pIDxAddr_[_affCode];
235             
236             // if affID is not the same as previously stored 
237             if (_affID != plyr_[_pID].laff)
238             {
239                 // update last affiliate
240                 plyr_[_pID].laff = _affID;
241             }
242         }
243         
244         // register name 
245         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
246     }
247     
248     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
249         isHuman()
250         public
251         payable 
252     {
253         // make sure name fees paid
254         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
255         
256         // filter name + condition checks
257         bytes32 _name = NameFilter.nameFilter(_nameString);
258         
259         // set up address 
260         address _addr = msg.sender;
261         
262         // set up our tx event data and determine if player is new or not
263         bool _isNewPlayer = determinePID(_addr);
264         
265         // fetch player id
266         uint256 _pID = pIDxAddr_[_addr];
267         
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         uint256 _affID;
271         if (_affCode != "" && _affCode != _name)
272         {
273             // get affiliate ID from aff Code 
274             _affID = pIDxName_[_affCode];
275             
276             // if affID is not the same as previously stored 
277             if (_affID != plyr_[_pID].laff)
278             {
279                 // update last affiliate
280                 plyr_[_pID].laff = _affID;
281             }
282         }
283         
284         // register name 
285         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
286     }
287     
288     /**
289      * @dev players, if you registered a profile, before a game was released, or
290      * set the all bool to false when you registered, use this function to push
291      * your profile to a single game.  also, if you've  updated your name, you
292      * can use this to push your name to games of your choosing.
293      * -functionhash- 0x81c5b206
294      * @param _gameID game id 
295      */
296     function addMeToGame(uint256 _gameID)
297         isHuman()
298         public
299     {
300         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
301         address _addr = msg.sender;
302         uint256 _pID = pIDxAddr_[_addr];
303         require(_pID != 0, "hey there buddy, you dont even have an account");
304         uint256 _totalNames = plyr_[_pID].names;
305         
306         // add players profile and most recent name
307         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
308         
309         // add list of all names
310         if (_totalNames > 1)
311             for (uint256 ii = 1; ii <= _totalNames; ii++)
312                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
313     }
314     
315     /**
316      * @dev players, use this to push your player profile to all registered games.
317      * -functionhash- 0x0c6940ea
318      */
319     function addMeToAllGames()
320         isHuman()
321         public
322     {
323         address _addr = msg.sender;
324         uint256 _pID = pIDxAddr_[_addr];
325         require(_pID != 0, "hey there buddy, you dont even have an account");
326         uint256 _laff = plyr_[_pID].laff;
327         uint256 _totalNames = plyr_[_pID].names;
328         bytes32 _name = plyr_[_pID].name;
329         
330         for (uint256 i = 1; i <= gID_; i++)
331         {
332             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
333             if (_totalNames > 1)
334                 for (uint256 ii = 1; ii <= _totalNames; ii++)
335                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
336         }
337                 
338     }
339     
340     /**
341      * @dev players use this to change back to one of your old names.  tip, you'll
342      * still need to push that info to existing games.
343      * -functionhash- 0xb9291296
344      * @param _nameString the name you want to use 
345      */
346     function useMyOldName(string _nameString)
347         isHuman()
348         public 
349     {
350         // filter name, and get pID
351         bytes32 _name = _nameString.nameFilter();
352         uint256 _pID = pIDxAddr_[msg.sender];
353         
354         // make sure they own the name 
355         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
356         
357         // update their current name 
358         plyr_[_pID].name = _name;
359     }
360     
361 //==============================================================================
362 //     _ _  _ _   | _  _ . _  .
363 //    (_(_)| (/_  |(_)(_||(_  . 
364 //=====================_|=======================================================    
365     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
366         private
367     {
368         // if names already has been used, require that current msg sender owns the name
369         if (pIDxName_[_name] != 0)
370             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
371         
372         // add name to player profile, registry, and name book
373         plyr_[_pID].name = _name;
374         pIDxName_[_name] = _pID;
375         if (plyrNames_[_pID][_name] == false)
376         {
377             plyrNames_[_pID][_name] = true;
378             plyr_[_pID].names++;
379             plyrNameList_[_pID][plyr_[_pID].names] = _name;
380         }
381         
382         // registration fee goes directly to community rewards
383         admin.transfer(address(this).balance);
384         
385         // push player info to games
386         if (_all == true)
387             for (uint256 i = 1; i <= gID_; i++)
388                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
389         
390         // fire event
391         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
392     }
393 //==============================================================================
394 //    _|_ _  _ | _  .
395 //     | (_)(_)|_\  .
396 //==============================================================================    
397     function determinePID(address _addr)
398         private
399         returns (bool)
400     {
401         if (pIDxAddr_[_addr] == 0)
402         {
403             pID_++;
404             pIDxAddr_[_addr] = pID_;
405             plyr_[pID_].addr = _addr;
406             
407             // set the new player bool to true
408             return (true);
409         } else {
410             return (false);
411         }
412     }
413 //==============================================================================
414 //   _   _|_ _  _ _  _ |   _ _ || _  .
415 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
416 //==============================================================================
417     function getPlayerID(address _addr)
418         isRegisteredGame()
419         external
420         returns (uint256)
421     {
422         determinePID(_addr);
423         return (pIDxAddr_[_addr]);
424     }
425     function getPlayerName(uint256 _pID)
426         external
427         view
428         returns (bytes32)
429     {
430         return (plyr_[_pID].name);
431     }
432     function getPlayerLAff(uint256 _pID)
433         external
434         view
435         returns (uint256)
436     {
437         return (plyr_[_pID].laff);
438     }
439     function getPlayerAddr(uint256 _pID)
440         external
441         view
442         returns (address)
443     {
444         return (plyr_[_pID].addr);
445     }
446     function getNameFee()
447         external
448         view
449         returns (uint256)
450     {
451         return(registrationFee_);
452     }
453     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
454         isRegisteredGame()
455         external
456         payable
457         returns(bool, uint256)
458     {
459         // make sure name fees paid
460         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
461         
462         // set up our tx event data and determine if player is new or not
463         bool _isNewPlayer = determinePID(_addr);
464         
465         // fetch player id
466         uint256 _pID = pIDxAddr_[_addr];
467         
468         // manage affiliate residuals
469         // if no affiliate code was given, no new affiliate code was given, or the 
470         // player tried to use their own pID as an affiliate code, lolz
471         uint256 _affID = _affCode;
472         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
473         {
474             // update last affiliate 
475             plyr_[_pID].laff = _affID;
476         } else if (_affID == _pID) {
477             _affID = 0;
478         }
479         
480         // register name 
481         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
482         
483         return(_isNewPlayer, _affID);
484     }
485     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
486         isRegisteredGame()
487         external
488         payable
489         returns(bool, uint256)
490     {
491         // make sure name fees paid
492         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
493         
494         // set up our tx event data and determine if player is new or not
495         bool _isNewPlayer = determinePID(_addr);
496         
497         // fetch player id
498         uint256 _pID = pIDxAddr_[_addr];
499         
500         // manage affiliate residuals
501         // if no affiliate code was given or player tried to use their own, lolz
502         uint256 _affID;
503         if (_affCode != address(0) && _affCode != _addr)
504         {
505             // get affiliate ID from aff Code 
506             _affID = pIDxAddr_[_affCode];
507             
508             // if affID is not the same as previously stored 
509             if (_affID != plyr_[_pID].laff)
510             {
511                 // update last affiliate
512                 plyr_[_pID].laff = _affID;
513             }
514         }
515         
516         // register name 
517         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
518         
519         return(_isNewPlayer, _affID);
520     }
521     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
522         isRegisteredGame()
523         external
524         payable
525         returns(bool, uint256)
526     {
527         // make sure name fees paid
528         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
529         
530         // set up our tx event data and determine if player is new or not
531         bool _isNewPlayer = determinePID(_addr);
532         
533         // fetch player id
534         uint256 _pID = pIDxAddr_[_addr];
535         
536         // manage affiliate residuals
537         // if no affiliate code was given or player tried to use their own, lolz
538         uint256 _affID;
539         if (_affCode != "" && _affCode != _name)
540         {
541             // get affiliate ID from aff Code 
542             _affID = pIDxName_[_affCode];
543             
544             // if affID is not the same as previously stored 
545             if (_affID != plyr_[_pID].laff)
546             {
547                 // update last affiliate
548                 plyr_[_pID].laff = _affID;
549             }
550         }
551         
552         // register name 
553         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
554         
555         return(_isNewPlayer, _affID);
556     }
557     
558 //==============================================================================
559 //   _ _ _|_    _   .
560 //  _\(/_ | |_||_)  .
561 //=============|================================================================
562     function addGame(address _gameAddress, string _gameNameStr)
563         onlyDevs()
564         public
565     {
566         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
567             gID_++;
568             bytes32 _name = _gameNameStr.nameFilter();
569             gameIDs_[_gameAddress] = gID_;
570             gameNames_[_gameAddress] = _name;
571             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
572         
573             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
574             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
575             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
576             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
577     }
578     
579     function setRegistrationFee(uint256 _fee)
580         onlyDevs()
581         public
582     {
583       registrationFee_ = _fee;
584     }
585         
586 } 
587 
588 /**
589 * @title -Name Filter- v0.1.9
590 */
591 library NameFilter {
592     
593     /**
594      * @dev filters name strings
595      * -converts uppercase to lower case.  
596      * -makes sure it does not start/end with a space
597      * -makes sure it does not contain multiple spaces in a row
598      * -cannot be only numbers
599      * -cannot start with 0x 
600      * -restricts characters to A-Z, a-z, 0-9, and space.
601      * @return reprocessed string in bytes32 format
602      */
603     function nameFilter(string _input)
604         internal
605         pure
606         returns(bytes32)
607     {
608         bytes memory _temp = bytes(_input);
609         uint256 _length = _temp.length;
610         
611         //sorry limited to 32 characters
612         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
613         // make sure it doesnt start with or end with space
614         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
615         // make sure first two characters are not 0x
616         if (_temp[0] == 0x30)
617         {
618             require(_temp[1] != 0x78, "string cannot start with 0x");
619             require(_temp[1] != 0x58, "string cannot start with 0X");
620         }
621         
622         // create a bool to track if we have a non number character
623         bool _hasNonNumber;
624         
625         // convert & check
626         for (uint256 i = 0; i < _length; i++)
627         {
628             // if its uppercase A-Z
629             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
630             {
631                 // convert to lower case a-z
632                 _temp[i] = byte(uint(_temp[i]) + 32);
633                 
634                 // we have a non number
635                 if (_hasNonNumber == false)
636                     _hasNonNumber = true;
637             } else {
638                 require
639                 (
640                     // require character is a space
641                     _temp[i] == 0x20 || 
642                     // OR lowercase a-z
643                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
644                     // or 0-9
645                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
646                     "string contains invalid characters"
647                 );
648                 // make sure theres not 2x spaces in a row
649                 if (_temp[i] == 0x20)
650                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
651                 
652                 // see if we have a character other than a number
653                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
654                     _hasNonNumber = true;    
655             }
656         }
657         
658         require(_hasNonNumber == true, "string cannot be only numbers");
659         
660         bytes32 _ret;
661         assembly {
662             _ret := mload(add(_temp, 32))
663         }
664         return (_ret);
665     }
666 }
667 
668 /**
669  * @title SafeMath v0.1.9
670  * @dev Math operations with safety checks that throw on error
671  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
672  * - added sqrt
673  * - added sq
674  * - added pwr 
675  * - changed asserts to requires with error log outputs
676  * - removed div, its useless
677  */
678 library SafeMath {
679     
680     /**
681     * @dev Multiplies two numbers, throws on overflow.
682     */
683     function mul(uint256 a, uint256 b) 
684         internal 
685         pure 
686         returns (uint256 c) 
687     {
688         if (a == 0) {
689             return 0;
690         }
691         c = a * b;
692         require(c / a == b, "SafeMath mul failed");
693         return c;
694     }
695 
696     /**
697     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
698     */
699     function sub(uint256 a, uint256 b)
700         internal
701         pure
702         returns (uint256) 
703     {
704         require(b <= a, "SafeMath sub failed");
705         return a - b;
706     }
707 
708     /**
709     * @dev Adds two numbers, throws on overflow.
710     */
711     function add(uint256 a, uint256 b)
712         internal
713         pure
714         returns (uint256 c) 
715     {
716         c = a + b;
717         require(c >= a, "SafeMath add failed");
718         return c;
719     }
720     
721     /**
722      * @dev gives square root of given x.
723      */
724     function sqrt(uint256 x)
725         internal
726         pure
727         returns (uint256 y) 
728     {
729         uint256 z = ((add(x,1)) / 2);
730         y = x;
731         while (z < y) 
732         {
733             y = z;
734             z = ((add((x / z),z)) / 2);
735         }
736     }
737     
738     /**
739      * @dev gives square. multiplies x by x
740      */
741     function sq(uint256 x)
742         internal
743         pure
744         returns (uint256)
745     {
746         return (mul(x,x));
747     }
748     
749     /**
750      * @dev x to the power of y 
751      */
752     function pwr(uint256 x, uint256 y)
753         internal 
754         pure 
755         returns (uint256)
756     {
757         if (x==0)
758             return (0);
759         else if (y==0)
760             return (1);
761         else 
762         {
763             uint256 z = x;
764             for (uint256 i=1; i < y; i++)
765                 z = mul(z,x);
766             return (z);
767         }
768     }
769 }