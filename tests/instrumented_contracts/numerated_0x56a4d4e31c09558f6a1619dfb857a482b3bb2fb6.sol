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
14 //==============================================================================
15 //     _| _ _|_ _    _ _ _|_    _   .
16 //    (_|(_| | (_|  _\(/_ | |_||_)  .
17 //=============================|================================================    
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
35 //==============================================================================
36 //     _ _  _  __|_ _    __|_ _  _  .
37 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
38 //==============================================================================    
39     constructor()
40         public
41     {}
42 //==============================================================================
43 //     _ _  _  _|. |`. _  _ _  .
44 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
45 //==============================================================================    
46     /**
47      * @dev prevents contracts from interacting with fomo3d 
48      */
49     modifier isHuman() {
50         address _addr = msg.sender;
51         uint256 _codeLength;
52         
53         assembly {_codeLength := extcodesize(_addr)}
54         require(_codeLength == 0, "sorry humans only");
55         _;
56     }
57 
58     modifier onlyAdmin()
59     {
60         require(msg.sender == admin);
61         _;
62     }   
63     
64     modifier isRegisteredGame()
65     {
66         require(gameIDs_[msg.sender] != 0);
67         _;
68     }
69 //==============================================================================
70 //     _    _  _ _|_ _  .
71 //    (/_\/(/_| | | _\  .
72 //==============================================================================    
73     // fired whenever a player registers a name
74     event onNewName
75     (
76         uint256 indexed playerID,
77         address indexed playerAddress,
78         bytes32 indexed playerName,
79         bool isNewPlayer,
80         uint256 affiliateID,
81         address affiliateAddress,
82         bytes32 affiliateName,
83         uint256 amountPaid,
84         uint256 timeStamp
85     );
86 //==============================================================================
87 //     _  _ _|__|_ _  _ _  .
88 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
89 //=====_|=======================================================================
90     function checkIfNameValid(string _nameStr)
91         public
92         view
93         returns(bool)
94     {
95         bytes32 _name = _nameStr.nameFilter();
96         if (pIDxName_[_name] == 0)
97             return (true);
98         else 
99             return (false);
100     }
101 //==============================================================================
102 //     _    |_ |. _   |`    _  __|_. _  _  _  .
103 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
104 //====|=========================================================================    
105     /**
106      * @dev registers a name.  UI will always display the last name you registered.
107      * but you will still own all previously registered names to use as affiliate 
108      * links.
109      * - must pay a registration fee.
110      * - name must be unique
111      * - names will be converted to lowercase
112      * - name cannot start or end with a space 
113      * - cannot have more than 1 space in a row
114      * - cannot be only numbers
115      * - cannot start with 0x 
116      * - name must be at least 1 char
117      * - max length of 32 characters long
118      * - allowed characters: a-z, 0-9, and space
119      * -functionhash- 0x921dec21 (using ID for affiliate)
120      * -functionhash- 0x3ddd4698 (using address for affiliate)
121      * -functionhash- 0x685ffd83 (using name for affiliate)
122      * @param _nameString players desired name
123      * @param _affCode affiliate ID, address, or name of who refered you
124      * @param _all set to true if you want this to push your info to all games 
125      * (this might cost a lot of gas)
126      */
127     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
128         isHuman()
129         public
130         payable 
131     {
132         // make sure name fees paid
133         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
134         
135         // filter name + condition checks
136         bytes32 _name = NameFilter.nameFilter(_nameString);
137         
138         // set up address 
139         address _addr = msg.sender;
140         
141         // set up our tx event data and determine if player is new or not
142         bool _isNewPlayer = determinePID(_addr);
143         
144         // fetch player id
145         uint256 _pID = pIDxAddr_[_addr];
146         
147         // manage affiliate residuals
148         // if no affiliate code was given, no new affiliate code was given, or the 
149         // player tried to use their own pID as an affiliate code, lolz
150         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
151         {
152             // update last affiliate 
153             plyr_[_pID].laff = _affCode;
154         } else if (_affCode == _pID) {
155             _affCode = 0;
156         }
157         
158         // register name 
159         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
160     }
161     
162     function registerNameXaddr(string _nameString, address _affCode, bool _all)
163         isHuman()
164         public
165         payable 
166     {
167         // make sure name fees paid
168         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
169         
170         // filter name + condition checks
171         bytes32 _name = NameFilter.nameFilter(_nameString);
172         
173         // set up address 
174         address _addr = msg.sender;
175         
176         // set up our tx event data and determine if player is new or not
177         bool _isNewPlayer = determinePID(_addr);
178         
179         // fetch player id
180         uint256 _pID = pIDxAddr_[_addr];
181         
182         // manage affiliate residuals
183         // if no affiliate code was given or player tried to use their own, lolz
184         uint256 _affID;
185         if (_affCode != address(0) && _affCode != _addr)
186         {
187             // get affiliate ID from aff Code 
188             _affID = pIDxAddr_[_affCode];
189             
190             // if affID is not the same as previously stored 
191             if (_affID != plyr_[_pID].laff)
192             {
193                 // update last affiliate
194                 plyr_[_pID].laff = _affID;
195             }
196         }
197         
198         // register name 
199         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
200     }
201     
202     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
203         isHuman()
204         public
205         payable 
206     {
207         // make sure name fees paid
208         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
209         
210         // filter name + condition checks
211         bytes32 _name = NameFilter.nameFilter(_nameString);
212         
213         // set up address 
214         address _addr = msg.sender;
215         
216         // set up our tx event data and determine if player is new or not
217         bool _isNewPlayer = determinePID(_addr);
218         
219         // fetch player id
220         uint256 _pID = pIDxAddr_[_addr];
221         
222         // manage affiliate residuals
223         // if no affiliate code was given or player tried to use their own, lolz
224         uint256 _affID;
225         if (_affCode != "" && _affCode != _name)
226         {
227             // get affiliate ID from aff Code 
228             _affID = pIDxName_[_affCode];
229             
230             // if affID is not the same as previously stored 
231             if (_affID != plyr_[_pID].laff)
232             {
233                 // update last affiliate
234                 plyr_[_pID].laff = _affID;
235             }
236         }
237         
238         // register name 
239         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
240     }
241     
242     /**
243      * @dev players, if you registered a profile, before a game was released, or
244      * set the all bool to false when you registered, use this function to push
245      * your profile to a single game.  also, if you've  updated your name, you
246      * can use this to push your name to games of your choosing.
247      * -functionhash- 0x81c5b206
248      * @param _gameID game id 
249      */
250     function addMeToGame(uint256 _gameID)
251         isHuman()
252         public
253     {
254         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
255         address _addr = msg.sender;
256         uint256 _pID = pIDxAddr_[_addr];
257         require(_pID != 0, "hey there buddy, you dont even have an account");
258         uint256 _totalNames = plyr_[_pID].names;
259         
260         // add players profile and most recent name
261         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
262         
263         // add list of all names
264         if (_totalNames > 1)
265             for (uint256 ii = 1; ii <= _totalNames; ii++)
266                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
267     }
268     
269     /**
270      * @dev players, use this to push your player profile to all registered games.
271      * -functionhash- 0x0c6940ea
272      */
273     function addMeToAllGames()
274         isHuman()
275         public
276     {
277         address _addr = msg.sender;
278         uint256 _pID = pIDxAddr_[_addr];
279         require(_pID != 0, "hey there buddy, you dont even have an account");
280         uint256 _laff = plyr_[_pID].laff;
281         uint256 _totalNames = plyr_[_pID].names;
282         bytes32 _name = plyr_[_pID].name;
283         
284         for (uint256 i = 1; i <= gID_; i++)
285         {
286             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
287             if (_totalNames > 1)
288                 for (uint256 ii = 1; ii <= _totalNames; ii++)
289                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
290         }
291                 
292     }
293     
294     /**
295      * @dev players use this to change back to one of your old names.  tip, you'll
296      * still need to push that info to existing games.
297      * -functionhash- 0xb9291296
298      * @param _nameString the name you want to use 
299      */
300     function useMyOldName(string _nameString)
301         isHuman()
302         public 
303     {
304         // filter name, and get pID
305         bytes32 _name = _nameString.nameFilter();
306         uint256 _pID = pIDxAddr_[msg.sender];
307         
308         // make sure they own the name 
309         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
310         
311         // update their current name 
312         plyr_[_pID].name = _name;
313     }
314     
315 //==============================================================================
316 //     _ _  _ _   | _  _ . _  .
317 //    (_(_)| (/_  |(_)(_||(_  . 
318 //=====================_|=======================================================    
319     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
320         private
321     {
322         // if names already has been used, require that current msg sender owns the name
323         if (pIDxName_[_name] != 0)
324             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
325         
326         // add name to player profile, registry, and name book
327         plyr_[_pID].name = _name;
328         pIDxName_[_name] = _pID;
329         if (plyrNames_[_pID][_name] == false)
330         {
331             plyrNames_[_pID][_name] = true;
332             plyr_[_pID].names++;
333             plyrNameList_[_pID][plyr_[_pID].names] = _name;
334         }
335         
336         // registration fee goes directly to community rewards
337         admin.transfer(address(this).balance);
338         
339         // push player info to games
340         if (_all == true)
341             for (uint256 i = 1; i <= gID_; i++)
342                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
343         
344         // fire event
345         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
346     }
347 //==============================================================================
348 //    _|_ _  _ | _  .
349 //     | (_)(_)|_\  .
350 //==============================================================================    
351     function determinePID(address _addr)
352         private
353         returns (bool)
354     {
355         if (pIDxAddr_[_addr] == 0)
356         {
357             pID_++;
358             pIDxAddr_[_addr] = pID_;
359             plyr_[pID_].addr = _addr;
360             
361             // set the new player bool to true
362             return (true);
363         } else {
364             return (false);
365         }
366     }
367 //==============================================================================
368 //   _   _|_ _  _ _  _ |   _ _ || _  .
369 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
370 //==============================================================================
371     function getPlayerID(address _addr)
372         isRegisteredGame()
373         external
374         returns (uint256)
375     {
376         determinePID(_addr);
377         return (pIDxAddr_[_addr]);
378     }
379     function getPlayerName(uint256 _pID)
380         external
381         view
382         returns (bytes32)
383     {
384         return (plyr_[_pID].name);
385     }
386     function getPlayerLAff(uint256 _pID)
387         external
388         view
389         returns (uint256)
390     {
391         return (plyr_[_pID].laff);
392     }
393     function getPlayerAddr(uint256 _pID)
394         external
395         view
396         returns (address)
397     {
398         return (plyr_[_pID].addr);
399     }
400     function getNameFee()
401         external
402         view
403         returns (uint256)
404     {
405         return(registrationFee_);
406     }
407     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
408         isRegisteredGame()
409         external
410         payable
411         returns(bool, uint256)
412     {
413         // make sure name fees paid
414         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
415         
416         // set up our tx event data and determine if player is new or not
417         bool _isNewPlayer = determinePID(_addr);
418         
419         // fetch player id
420         uint256 _pID = pIDxAddr_[_addr];
421         
422         // manage affiliate residuals
423         // if no affiliate code was given, no new affiliate code was given, or the 
424         // player tried to use their own pID as an affiliate code, lolz
425         uint256 _affID = _affCode;
426         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
427         {
428             // update last affiliate 
429             plyr_[_pID].laff = _affID;
430         } else if (_affID == _pID) {
431             _affID = 0;
432         }
433         
434         // register name 
435         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
436         
437         return(_isNewPlayer, _affID);
438     }
439     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
440         isRegisteredGame()
441         external
442         payable
443         returns(bool, uint256)
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
455         // if no affiliate code was given or player tried to use their own, lolz
456         uint256 _affID;
457         if (_affCode != address(0) && _affCode != _addr)
458         {
459             // get affiliate ID from aff Code 
460             _affID = pIDxAddr_[_affCode];
461             
462             // if affID is not the same as previously stored 
463             if (_affID != plyr_[_pID].laff)
464             {
465                 // update last affiliate
466                 plyr_[_pID].laff = _affID;
467             }
468         }
469         
470         // register name 
471         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
472         
473         return(_isNewPlayer, _affID);
474     }
475     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
476         isRegisteredGame()
477         external
478         payable
479         returns(bool, uint256)
480     {
481         // make sure name fees paid
482         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
483         
484         // set up our tx event data and determine if player is new or not
485         bool _isNewPlayer = determinePID(_addr);
486         
487         // fetch player id
488         uint256 _pID = pIDxAddr_[_addr];
489         
490         // manage affiliate residuals
491         // if no affiliate code was given or player tried to use their own, lolz
492         uint256 _affID;
493         if (_affCode != "" && _affCode != _name)
494         {
495             // get affiliate ID from aff Code 
496             _affID = pIDxName_[_affCode];
497             
498             // if affID is not the same as previously stored 
499             if (_affID != plyr_[_pID].laff)
500             {
501                 // update last affiliate
502                 plyr_[_pID].laff = _affID;
503             }
504         }
505         
506         // register name 
507         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
508         
509         return(_isNewPlayer, _affID);
510     }
511     
512 //==============================================================================
513 //   _ _ _|_    _   .
514 //  _\(/_ | |_||_)  .
515 //=============|================================================================
516     function addGame(address _gameAddress, string _gameNameStr)
517         onlyAdmin()
518         public
519     {
520         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
521             gID_++;
522             bytes32 _name = _gameNameStr.nameFilter();
523             gameIDs_[_gameAddress] = gID_;
524             gameNames_[_gameAddress] = _name;
525             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
526     }
527     
528     function setRegistrationFee(uint256 _fee)
529         onlyAdmin()
530         public
531     {
532       registrationFee_ = _fee;
533     }
534         
535 } 
536 
537 /**
538 * @title -Name Filter- v0.1.9
539 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
540 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
541 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
542 *                                  _____                      _____
543 *                                 (, /     /)       /) /)    (, /      /)          /)
544 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
545 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
546 *          ┴ ┴                /   /          .-/ _____   (__ /                               
547 *                            (__ /          (_/ (, /                                      /)™ 
548 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
549 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
550 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
551 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
552 *              _       __    _      ____      ____  _   _    _____  ____  ___  
553 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
554 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
555 *
556 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
557 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
558 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
559 */
560 library NameFilter {
561     
562     /**
563      * @dev filters name strings
564      * -converts uppercase to lower case.  
565      * -makes sure it does not start/end with a space
566      * -makes sure it does not contain multiple spaces in a row
567      * -cannot be only numbers
568      * -cannot start with 0x 
569      * -restricts characters to A-Z, a-z, 0-9, and space.
570      * @return reprocessed string in bytes32 format
571      */
572     function nameFilter(string _input)
573         internal
574         pure
575         returns(bytes32)
576     {
577         bytes memory _temp = bytes(_input);
578         uint256 _length = _temp.length;
579         
580         //sorry limited to 32 characters
581         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
582         // make sure it doesnt start with or end with space
583         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
584         // make sure first two characters are not 0x
585         if (_temp[0] == 0x30)
586         {
587             require(_temp[1] != 0x78, "string cannot start with 0x");
588             require(_temp[1] != 0x58, "string cannot start with 0X");
589         }
590         
591         // create a bool to track if we have a non number character
592         bool _hasNonNumber;
593         
594         // convert & check
595         for (uint256 i = 0; i < _length; i++)
596         {
597             // if its uppercase A-Z
598             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
599             {
600                 // convert to lower case a-z
601                 _temp[i] = byte(uint(_temp[i]) + 32);
602                 
603                 // we have a non number
604                 if (_hasNonNumber == false)
605                     _hasNonNumber = true;
606             } else {
607                 require
608                 (
609                     // require character is a space
610                     _temp[i] == 0x20 || 
611                     // OR lowercase a-z
612                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
613                     // or 0-9
614                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
615                     "string contains invalid characters"
616                 );
617                 // make sure theres not 2x spaces in a row
618                 if (_temp[i] == 0x20)
619                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
620                 
621                 // see if we have a character other than a number
622                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
623                     _hasNonNumber = true;    
624             }
625         }
626         
627         require(_hasNonNumber == true, "string cannot be only numbers");
628         
629         bytes32 _ret;
630         assembly {
631             _ret := mload(add(_temp, 32))
632         }
633         return (_ret);
634     }
635 }
636 
637 /**
638  * @title SafeMath v0.1.9
639  * @dev Math operations with safety checks that throw on error
640  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
641  * - added sqrt
642  * - added sq
643  * - added pwr 
644  * - changed asserts to requires with error log outputs
645  * - removed div, its useless
646  */
647 library SafeMath {
648     
649     /**
650     * @dev Multiplies two numbers, throws on overflow.
651     */
652     function mul(uint256 a, uint256 b) 
653         internal 
654         pure 
655         returns (uint256 c) 
656     {
657         if (a == 0) {
658             return 0;
659         }
660         c = a * b;
661         require(c / a == b, "SafeMath mul failed");
662         return c;
663     }
664 
665     /**
666     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
667     */
668     function sub(uint256 a, uint256 b)
669         internal
670         pure
671         returns (uint256) 
672     {
673         require(b <= a, "SafeMath sub failed");
674         return a - b;
675     }
676 
677     /**
678     * @dev Adds two numbers, throws on overflow.
679     */
680     function add(uint256 a, uint256 b)
681         internal
682         pure
683         returns (uint256 c) 
684     {
685         c = a + b;
686         require(c >= a, "SafeMath add failed");
687         return c;
688     }
689     
690     /**
691      * @dev gives square root of given x.
692      */
693     function sqrt(uint256 x)
694         internal
695         pure
696         returns (uint256 y) 
697     {
698         uint256 z = ((add(x,1)) / 2);
699         y = x;
700         while (z < y) 
701         {
702             y = z;
703             z = ((add((x / z),z)) / 2);
704         }
705     }
706     
707     /**
708      * @dev gives square. multiplies x by x
709      */
710     function sq(uint256 x)
711         internal
712         pure
713         returns (uint256)
714     {
715         return (mul(x,x));
716     }
717     
718     /**
719      * @dev x to the power of y 
720      */
721     function pwr(uint256 x, uint256 y)
722         internal 
723         pure 
724         returns (uint256)
725     {
726         if (x==0)
727             return (0);
728         else if (y==0)
729             return (1);
730         else 
731         {
732             uint256 z = x;
733             for (uint256 i=1; i < y; i++)
734                 z = mul(z,x);
735             return (z);
736         }
737     }
738 }