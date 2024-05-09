1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 contract PlayerBook {
10     using NameFilter for string;
11     using SafeMath for uint256;
12     
13     address private admin = msg.sender;
14     
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
30     struct Player {
31         address addr;
32         bytes32 name;
33         uint256 laff;
34         uint256 names;
35     }
36 //==============================================================================
37 //     _ _  _  __|_ _    __|_ _  _  .
38 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
39 //==============================================================================    
40     constructor() public {
41         // premine the dev names (sorry not sorry)
42             // No keys are purchased with this method, it's simply locking our addresses,
43             // PID's and names for referral codes.
44         
45         plyr_[1].addr = 0x5E3e2Fefd52Bc8a752D5b6D973315862B7b8b9c4;
46         plyr_[1].name = "g";
47         plyr_[1].names = 1;
48         pIDxAddr_[0x5E3e2Fefd52Bc8a752D5b6D973315862B7b8b9c4] = 1;
49         pIDxName_["g"] = 1;
50         plyrNames_[1]["g"] = true;
51         plyrNameList_[1][1] = "g";
52         
53         pID_ = 1;
54     }
55 //==============================================================================
56 //     _ _  _  _|. |`. _  _ _  .
57 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
58 //==============================================================================    
59     /**
60      * @dev prevents contracts from interacting with fomo3d 
61      */
62     modifier isHuman() {
63         require(msg.sender == tx.origin, "sorry humans only");
64         _;
65     }
66     
67     modifier onlyOwn() {
68         require(admin == msg.sender, "msg sender is not a dev");
69         _;
70     }
71     
72     modifier isRegisteredGame() {
73         // a game invoke
74         require(gameIDs_[msg.sender] != 0);
75         _;
76     }
77 //==============================================================================
78 //     _    _  _ _|_ _  .
79 //    (/_\/(/_| | | _\  .
80 //==============================================================================    
81     // fired whenever a player registers a name
82     event onNewName (
83         uint256 indexed playerID,
84         address indexed playerAddress,
85         bytes32 indexed playerName,
86         bool isNewPlayer,
87         uint256 affiliateID,
88         address affiliateAddress,
89         bytes32 affiliateName,
90         uint256 amountPaid,
91         uint256 timeStamp
92     );
93 //==============================================================================
94 //     _  _ _|__|_ _  _ _  .
95 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
96 //=====_|=======================================================================
97     function checkIfNameValid(string _nameStr)
98         public
99         view
100         returns(bool)
101     {
102         bytes32 _name = _nameStr.nameFilter();
103         if (pIDxName_[_name] == 0)
104             return (true);
105         else 
106             return (false);
107     }
108 //==============================================================================
109 //     _    |_ |. _   |`    _  __|_. _  _  _  .
110 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
111 //====|=========================================================================    
112     /**
113      * @dev registers a name.  UI will always display the last name you registered.
114      * but you will still own all previously registered names to use as affiliate 
115      * links.
116      * - must pay a registration fee.
117      * - name must be unique
118      * - names will be converted to lowercase
119      * - name cannot start or end with a space 
120      * - cannot have more than 1 space in a row
121      * - cannot be only numbers
122      * - cannot start with 0x 
123      * - name must be at least 1 char
124      * - max length of 32 characters long
125      * - allowed characters: a-z, 0-9, and space
126      * -functionhash- 0x921dec21 (using ID for affiliate)
127      * -functionhash- 0x3ddd4698 (using address for affiliate)
128      * -functionhash- 0x685ffd83 (using name for affiliate)
129      * @param _nameString players desired name
130      * @param _affCode affiliate ID, address, or name of who refered you
131      * @param _all set to true if you want this to push your info to all games 
132      * (this might cost a lot of gas)
133      */
134     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
135         isHuman()
136         public
137         payable 
138     {
139         // make sure name fees paid
140         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
141         
142         // filter name + condition checks
143         bytes32 _name = NameFilter.nameFilter(_nameString);
144         
145         // set up address 
146         address _addr = msg.sender;
147         
148         // set up our tx event data and determine if player is new or not
149         bool _isNewPlayer = determinePID(_addr);
150         
151         // fetch player id
152         uint256 _pID = pIDxAddr_[_addr];
153         
154         // manage affiliate residuals
155         // if no affiliate code was given, no new affiliate code was given, or the 
156         // player tried to use their own pID as an affiliate code, lolz
157         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
158         {
159             // update last affiliate 
160             plyr_[_pID].laff = _affCode;
161         } else if (_affCode == _pID) {
162             _affCode = 0;
163         }
164         
165         // register name 
166         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
167     }
168     
169     function registerNameXaddr(string _nameString, address _affCode, bool _all)
170         isHuman()
171         public
172         payable 
173     {
174         // make sure name fees paid
175         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
176         
177         // filter name + condition checks
178         bytes32 _name = NameFilter.nameFilter(_nameString);
179         
180         // set up address 
181         address _addr = msg.sender;
182         
183         // set up our tx event data and determine if player is new or not
184         bool _isNewPlayer = determinePID(_addr);
185         
186         // fetch player id
187         uint256 _pID = pIDxAddr_[_addr];
188         
189         // manage affiliate residuals
190         // if no affiliate code was given or player tried to use their own, lolz
191         uint256 _affID;
192         if (_affCode != address(0) && _affCode != _addr)
193         {
194             // get affiliate ID from aff Code 
195             _affID = pIDxAddr_[_affCode];
196             
197             // if affID is not the same as previously stored 
198             if (_affID != plyr_[_pID].laff)
199             {
200                 // update last affiliate
201                 plyr_[_pID].laff = _affID;
202             }
203         }
204         
205         // register name 
206         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
207     }
208     
209     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
210         isHuman()
211         public
212         payable 
213     {
214         // make sure name fees paid
215         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
216         
217         // filter name + condition checks
218         bytes32 _name = NameFilter.nameFilter(_nameString);
219         
220         // set up address 
221         address _addr = msg.sender;
222         
223         // set up our tx event data and determine if player is new or not
224         bool _isNewPlayer = determinePID(_addr);
225         
226         // fetch player id
227         uint256 _pID = pIDxAddr_[_addr];
228         
229         // manage affiliate residuals
230         // if no affiliate code was given or player tried to use their own, lolz
231         uint256 _affID;
232         if (_affCode != "" && _affCode != _name)
233         {
234             // get affiliate ID from aff Code 
235             _affID = pIDxName_[_affCode];
236             
237             // if affID is not the same as previously stored 
238             if (_affID != plyr_[_pID].laff)
239             {
240                 // update last affiliate
241                 plyr_[_pID].laff = _affID;
242             }
243         }
244         
245         // register name 
246         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
247     }
248     
249     /**
250      * @dev players, if you registered a profile, before a game was released, or
251      * set the all bool to false when you registered, use this function to push
252      * your profile to a single game.  also, if you've  updated your name, you
253      * can use this to push your name to games of your choosing.
254      * -functionhash- 0x81c5b206
255      * @param _gameID game id 
256      */
257     function addMeToGame(uint256 _gameID)
258         isHuman()
259         public
260     {
261         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
262         address _addr = msg.sender;
263         uint256 _pID = pIDxAddr_[_addr];
264         require(_pID != 0, "hey there buddy, you dont even have an account");
265         uint256 _totalNames = plyr_[_pID].names;
266         
267         // add players profile and most recent name
268         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
269         
270         // add list of all names
271         if (_totalNames > 1)
272             for (uint256 ii = 1; ii <= _totalNames; ii++)
273                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
274     }
275     
276     /**
277      * @dev players, use this to push your player profile to all registered games.
278      * -functionhash- 0x0c6940ea
279      */
280     function addMeToAllGames()
281         isHuman()
282         public
283     {
284         address _addr = msg.sender;
285         uint256 _pID = pIDxAddr_[_addr];
286         require(_pID != 0, "hey there buddy, you dont even have an account");
287         uint256 _laff = plyr_[_pID].laff;
288         uint256 _totalNames = plyr_[_pID].names;
289         bytes32 _name = plyr_[_pID].name;
290         
291         for (uint256 i = 1; i <= gID_; i++)
292         {
293             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
294             if (_totalNames > 1)
295                 for (uint256 ii = 1; ii <= _totalNames; ii++)
296                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
297         }
298                 
299     }
300     
301     /**
302      * @dev players use this to change back to one of your old names.  tip, you'll
303      * still need to push that info to existing games.
304      * -functionhash- 0xb9291296
305      * @param _nameString the name you want to use 
306      */
307     function useMyOldName(string _nameString)
308         isHuman()
309         public 
310     {
311         // filter name, and get pID
312         bytes32 _name = _nameString.nameFilter();
313         uint256 _pID = pIDxAddr_[msg.sender];
314         
315         // make sure they own the name 
316         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
317         
318         // update their current name 
319         plyr_[_pID].name = _name;
320     }
321     
322 //==============================================================================
323 //     _ _  _ _   | _  _ . _  .
324 //    (_(_)| (/_  |(_)(_||(_  . 
325 //=====================_|=======================================================    
326     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all) private {
327         // if names already has been used, require that current msg sender owns the name
328         if (pIDxName_[_name] != 0)
329             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
330         
331         // add name to player profile, registry, and name book
332         plyr_[_pID].name = _name;
333         pIDxName_[_name] = _pID;
334         if (plyrNames_[_pID][_name] == false)
335         {
336             plyrNames_[_pID][_name] = true;
337             plyr_[_pID].names++;
338             plyrNameList_[_pID][plyr_[_pID].names] = _name;
339         }
340         
341         // registration fee goes directly to community rewards
342         admin.transfer(address(this).balance);
343         
344         // push player info to games
345         if (_all == true)
346             for (uint256 i = 1; i <= gID_; i++)
347                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
348         
349         // fire event
350         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
351     }
352 //==============================================================================
353 //    _|_ _  _ | _  .
354 //     | (_)(_)|_\  .
355 //==============================================================================    
356     function determinePID(address _addr)
357         private
358         returns (bool) {
359         if (pIDxAddr_[_addr] == 0)
360         {
361             pID_++;
362             pIDxAddr_[_addr] = pID_;
363             plyr_[pID_].addr = _addr;
364             
365             // set the new player bool to true
366             return (true);
367         } else {
368             return (false);
369         }
370     }
371 //==============================================================================
372 //   _   _|_ _  _ _  _ |   _ _ || _  .
373 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
374 //==============================================================================
375     function getPlayerID(address _addr)
376         isRegisteredGame()
377         external
378         returns (uint256)
379     {
380         determinePID(_addr);
381         return (pIDxAddr_[_addr]);
382     }
383     function getPlayerName(uint256 _pID)
384         external
385         view
386         returns (bytes32)
387     {
388         return (plyr_[_pID].name);
389     }
390     function getPlayerLAff(uint256 _pID)
391         external
392         view
393         returns (uint256)
394     {
395         return (plyr_[_pID].laff);
396     }
397     function getPlayerAddr(uint256 _pID)
398         external
399         view
400         returns (address)
401     {
402         return (plyr_[_pID].addr);
403     }
404     function getNameFee()
405         external
406         view
407         returns (uint256)
408     {
409         return(registrationFee_);
410     }
411 
412     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) 
413         isRegisteredGame() external payable 
414         returns(bool, uint256) 
415     {
416         // make sure name fees paid
417         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
418         
419         // set up our tx event data and determine if player is new or not
420         bool _isNewPlayer = determinePID(_addr);
421         
422         // fetch player id
423         uint256 _pID = pIDxAddr_[_addr];
424         
425         // manage affiliate residuals
426         // if no affiliate code was given, no new affiliate code was given, or the 
427         // player tried to use their own pID as an affiliate code, lolz
428         uint256 _affID = _affCode;
429         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
430         {
431             // update last affiliate 
432             plyr_[_pID].laff = _affID;
433         } else if (_affID == _pID) {
434             _affID = 0;
435         }
436         
437         // register name 
438         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
439         
440         return(_isNewPlayer, _affID);
441     }
442     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
443         isRegisteredGame()
444         external
445         payable
446         returns(bool, uint256)
447     {
448         // make sure name fees paid
449         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
450         
451         // set up our tx event data and determine if player is new or not
452         bool _isNewPlayer = determinePID(_addr);
453         
454         // fetch player id
455         uint256 _pID = pIDxAddr_[_addr];
456         
457         // manage affiliate residuals
458         // if no affiliate code was given or player tried to use their own, lolz
459         uint256 _affID;
460         if (_affCode != address(0) && _affCode != _addr)
461         {
462             // get affiliate ID from aff Code 
463             _affID = pIDxAddr_[_affCode];
464             
465             // if affID is not the same as previously stored 
466             if (_affID != plyr_[_pID].laff)
467             {
468                 // update last affiliate
469                 plyr_[_pID].laff = _affID;
470             }
471         }
472         
473         // register name 
474         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
475         
476         return(_isNewPlayer, _affID);
477     }
478     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
479         isRegisteredGame()
480         external
481         payable
482         returns(bool, uint256)
483     {
484         // make sure name fees paid
485         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
486         
487         // set up our tx event data and determine if player is new or not
488         bool _isNewPlayer = determinePID(_addr);
489         
490         // fetch player id
491         uint256 _pID = pIDxAddr_[_addr];
492         
493         // manage affiliate residuals
494         // if no affiliate code was given or player tried to use their own, lolz
495         uint256 _affID;
496         if (_affCode != "" && _affCode != _name)
497         {
498             // get affiliate ID from aff Code 
499             _affID = pIDxName_[_affCode];
500             
501             // if affID is not the same as previously stored 
502             if (_affID != plyr_[_pID].laff)
503             {
504                 // update last affiliate
505                 plyr_[_pID].laff = _affID;
506             }
507         }
508         
509         // register name 
510         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
511         
512         return(_isNewPlayer, _affID);
513     }
514     
515 //==============================================================================
516 //   _ _ _|_    _   .
517 //  _\(/_ | |_||_)  .
518 //=============|================================================================
519     function addGame(address _gameAddress, string _gameNameStr)
520         onlyOwn()
521         public
522     {
523         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
524         
525         
526         gID_++;
527         bytes32 _name = _gameNameStr.nameFilter();
528         gameIDs_[_gameAddress] = gID_;
529         gameNames_[_gameAddress] = _name;
530         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
531         
532     }
533     
534     function setRegistrationFee(uint256 _fee)
535         onlyOwn()
536         public
537     {
538         
539         registrationFee_ = _fee;
540         
541     }
542         
543 } 
544 
545 /**
546 * @title -Name Filter- v0.1.9
547 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
548 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
549 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
550 *                                  _____                      _____
551 *                                 (, /     /)       /) /)    (, /      /)          /)
552 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
553 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
554 *          ┴ ┴                /   /          .-/ _____   (__ /                               
555 *                            (__ /          (_/ (, /                                      /)™ 
556 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
557 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
558 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
559 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
560 *              _       __    _      ____      ____  _   _    _____  ____  ___  
561 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
562 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
563 *
564 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
565 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
566 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
567 */
568 library NameFilter {
569     
570     /**
571      * @dev filters name strings
572      * -converts uppercase to lower case.  
573      * -makes sure it does not start/end with a space
574      * -makes sure it does not contain multiple spaces in a row
575      * -cannot be only numbers
576      * -cannot start with 0x 
577      * -restricts characters to A-Z, a-z, 0-9, and space.
578      * @return reprocessed string in bytes32 format
579      */
580     function nameFilter(string _input)
581         internal
582         pure
583         returns(bytes32)
584     {
585         bytes memory _temp = bytes(_input);
586         uint256 _length = _temp.length;
587         
588         //sorry limited to 32 characters
589         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
590         // make sure it doesnt start with or end with space
591         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
592         // make sure first two characters are not 0x
593         if (_temp[0] == 0x30)
594         {
595             require(_temp[1] != 0x78, "string cannot start with 0x");
596             require(_temp[1] != 0x58, "string cannot start with 0X");
597         }
598         
599         // create a bool to track if we have a non number character
600         bool _hasNonNumber;
601         
602         // convert & check
603         for (uint256 i = 0; i < _length; i++)
604         {
605             // if its uppercase A-Z
606             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
607             {
608                 // convert to lower case a-z
609                 _temp[i] = byte(uint(_temp[i]) + 32);
610                 
611                 // we have a non number
612                 if (_hasNonNumber == false)
613                     _hasNonNumber = true;
614             } else {
615                 require
616                 (
617                     // require character is a space
618                     _temp[i] == 0x20 || 
619                     // OR lowercase a-z
620                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
621                     // or 0-9
622                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
623                     "string contains invalid characters"
624                 );
625                 // make sure theres not 2x spaces in a row
626                 if (_temp[i] == 0x20)
627                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
628                 
629                 // see if we have a character other than a number
630                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
631                     _hasNonNumber = true;    
632             }
633         }
634         
635         require(_hasNonNumber == true, "string cannot be only numbers");
636         
637         bytes32 _ret;
638         assembly {
639             _ret := mload(add(_temp, 32))
640         }
641         return (_ret);
642     }
643 }
644 
645 /**
646  * @title SafeMath v0.1.9
647  * @dev Math operations with safety checks that throw on error
648  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
649  * - added sqrt
650  * - added sq
651  * - added pwr 
652  * - changed asserts to requires with error log outputs
653  * - removed div, its useless
654  */
655 library SafeMath {
656     
657     /**
658     * @dev Multiplies two numbers, throws on overflow.
659     */
660     function mul(uint256 a, uint256 b) 
661         internal 
662         pure 
663         returns (uint256 c) 
664     {
665         if (a == 0) {
666             return 0;
667         }
668         c = a * b;
669         require(c / a == b, "SafeMath mul failed");
670         return c;
671     }
672 
673     /**
674     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
675     */
676     function sub(uint256 a, uint256 b)
677         internal
678         pure
679         returns (uint256) 
680     {
681         require(b <= a, "SafeMath sub failed");
682         return a - b;
683     }
684 
685     /**
686     * @dev Adds two numbers, throws on overflow.
687     */
688     function add(uint256 a, uint256 b)
689         internal
690         pure
691         returns (uint256 c) 
692     {
693         c = a + b;
694         require(c >= a, "SafeMath add failed");
695         return c;
696     }
697     
698     /**
699      * @dev gives square root of given x.
700      */
701     function sqrt(uint256 x)
702         internal
703         pure
704         returns (uint256 y) 
705     {
706         uint256 z = ((add(x,1)) / 2);
707         y = x;
708         while (z < y) 
709         {
710             y = z;
711             z = ((add((x / z),z)) / 2);
712         }
713     }
714     
715     /**
716      * @dev gives square. multiplies x by x
717      */
718     function sq(uint256 x)
719         internal
720         pure
721         returns (uint256)
722     {
723         return (mul(x,x));
724     }
725     
726     /**
727      * @dev x to the power of y 
728      */
729     function pwr(uint256 x, uint256 y)
730         internal 
731         pure 
732         returns (uint256)
733     {
734         if (x==0)
735             return (0);
736         else if (y==0)
737             return (1);
738         else 
739         {
740             uint256 z = x;
741             for (uint256 i=1; i < y; i++)
742                 z = mul(z,x);
743             return (z);
744         }
745     }
746 }