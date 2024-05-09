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
14     address constant private god = 0xe1B35fEBaB9Ff6da5b29C3A7A44eef06cD86B0f9;
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
40     constructor()
41         public
42     {
43         // premine the dev names (sorry not sorry)
44             // No keys are purchased with this method, it's simply locking our addresses,
45             // PID's and names for referral codes.
46         
47         // pID_ = 4;
48 
49         plyr_[1].addr = god;
50         plyr_[1].name = "god";
51         plyr_[1].names = 1;
52         pIDxAddr_[god] = 1;
53         pIDxName_["god"] = 1;
54         plyrNames_[1]["god"] = true;
55         plyrNameList_[1][1] = "god";
56         
57         pID_ = 1;
58     }
59 //==============================================================================
60 //     _ _  _  _|. |`. _  _ _  .
61 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
62 //==============================================================================    
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
81 //==============================================================================
82 //     _    _  _ _|_ _  .
83 //    (/_\/(/_| | | _\  .
84 //==============================================================================    
85     // fired whenever a player registers a name
86     event onNewName
87     (
88         uint256 indexed playerID,
89         address indexed playerAddress,
90         bytes32 indexed playerName,
91         bool isNewPlayer,
92         uint256 affiliateID,
93         address affiliateAddress,
94         bytes32 affiliateName,
95         uint256 amountPaid,
96         uint256 timeStamp
97     );
98 //==============================================================================
99 //     _  _ _|__|_ _  _ _  .
100 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
101 //=====_|=======================================================================
102     function checkIfNameValid(string _nameStr)
103         public
104         view
105         returns(bool)
106     {
107         bytes32 _name = _nameStr.nameFilter();
108         if (pIDxName_[_name] == 0)
109             return (true);
110         else 
111             return (false);
112     }
113 //==============================================================================
114 //     _    |_ |. _   |`    _  __|_. _  _  _  .
115 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
116 //====|=========================================================================    
117     /**
118      * @dev registers a name.  UI will always display the last name you registered.
119      * but you will still own all previously registered names to use as affiliate 
120      * links.
121      * - must pay a registration fee.
122      * - name must be unique
123      * - names will be converted to lowercase
124      * - name cannot start or end with a space 
125      * - cannot have more than 1 space in a row
126      * - cannot be only numbers
127      * - cannot start with 0x 
128      * - name must be at least 1 char
129      * - max length of 32 characters long
130      * - allowed characters: a-z, 0-9, and space
131      * -functionhash- 0x921dec21 (using ID for affiliate)
132      * -functionhash- 0x3ddd4698 (using address for affiliate)
133      * -functionhash- 0x685ffd83 (using name for affiliate)
134      * @param _nameString players desired name
135      * @param _affCode affiliate ID, address, or name of who refered you
136      * @param _all set to true if you want this to push your info to all games 
137      * (this might cost a lot of gas)
138      */
139     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
140         isHuman()
141         public
142         payable 
143     {
144         // make sure name fees paid
145         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
146         
147         // filter name + condition checks
148         bytes32 _name = NameFilter.nameFilter(_nameString);
149         
150         // set up address 
151         address _addr = msg.sender;
152         
153         // set up our tx event data and determine if player is new or not
154         bool _isNewPlayer = determinePID(_addr);
155         
156         // fetch player id
157         uint256 _pID = pIDxAddr_[_addr];
158         
159         // manage affiliate residuals
160         // if no affiliate code was given, no new affiliate code was given, or the 
161         // player tried to use their own pID as an affiliate code, lolz
162         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
163         {
164             // update last affiliate 
165             plyr_[_pID].laff = _affCode;
166         } else if (_affCode == _pID) {
167             _affCode = 0;
168         }
169         
170         // register name 
171         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
172     }
173     
174     function registerNameXaddr(string _nameString, address _affCode, bool _all)
175         isHuman()
176         public
177         payable 
178     {
179         // make sure name fees paid
180         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
181         
182         // filter name + condition checks
183         bytes32 _name = NameFilter.nameFilter(_nameString);
184         
185         // set up address 
186         address _addr = msg.sender;
187         
188         // set up our tx event data and determine if player is new or not
189         bool _isNewPlayer = determinePID(_addr);
190         
191         // fetch player id
192         uint256 _pID = pIDxAddr_[_addr];
193         
194         // manage affiliate residuals
195         // if no affiliate code was given or player tried to use their own, lolz
196         uint256 _affID;
197         if (_affCode != address(0) && _affCode != _addr)
198         {
199             // get affiliate ID from aff Code 
200             _affID = pIDxAddr_[_affCode];
201             
202             // if affID is not the same as previously stored 
203             if (_affID != plyr_[_pID].laff)
204             {
205                 // update last affiliate
206                 plyr_[_pID].laff = _affID;
207             }
208         }
209         
210         // register name 
211         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
212     }
213     
214     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
215         isHuman()
216         public
217         payable 
218     {
219         // make sure name fees paid
220         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
221         
222         // filter name + condition checks
223         bytes32 _name = NameFilter.nameFilter(_nameString);
224         
225         // set up address 
226         address _addr = msg.sender;
227         
228         // set up our tx event data and determine if player is new or not
229         bool _isNewPlayer = determinePID(_addr);
230         
231         // fetch player id
232         uint256 _pID = pIDxAddr_[_addr];
233         
234         // manage affiliate residuals
235         // if no affiliate code was given or player tried to use their own, lolz
236         uint256 _affID;
237         if (_affCode != "" && _affCode != _name)
238         {
239             // get affiliate ID from aff Code 
240             _affID = pIDxName_[_affCode];
241             
242             // if affID is not the same as previously stored 
243             if (_affID != plyr_[_pID].laff)
244             {
245                 // update last affiliate
246                 plyr_[_pID].laff = _affID;
247             }
248         }
249         
250         // register name 
251         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
252     }
253     
254     /**
255      * @dev players, if you registered a profile, before a game was released, or
256      * set the all bool to false when you registered, use this function to push
257      * your profile to a single game.  also, if you've  updated your name, you
258      * can use this to push your name to games of your choosing.
259      * -functionhash- 0x81c5b206
260      * @param _gameID game id 
261      */
262     function addMeToGame(uint256 _gameID)
263         isHuman()
264         public
265     {
266         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
267         address _addr = msg.sender;
268         uint256 _pID = pIDxAddr_[_addr];
269         require(_pID != 0, "hey there buddy, you dont even have an account");
270         uint256 _totalNames = plyr_[_pID].names;
271         
272         // add players profile and most recent name
273         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
274         
275         // add list of all names
276         if (_totalNames > 1)
277             for (uint256 ii = 1; ii <= _totalNames; ii++)
278                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
279     }
280     
281     /**
282      * @dev players, use this to push your player profile to all registered games.
283      * -functionhash- 0x0c6940ea
284      */
285     function addMeToAllGames()
286         isHuman()
287         public
288     {
289         address _addr = msg.sender;
290         uint256 _pID = pIDxAddr_[_addr];
291         require(_pID != 0, "hey there buddy, you dont even have an account");
292         uint256 _laff = plyr_[_pID].laff;
293         uint256 _totalNames = plyr_[_pID].names;
294         bytes32 _name = plyr_[_pID].name;
295         
296         for (uint256 i = 1; i <= gID_; i++)
297         {
298             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
299             if (_totalNames > 1)
300                 for (uint256 ii = 1; ii <= _totalNames; ii++)
301                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
302         }
303                 
304     }
305     
306     /**
307      * @dev players use this to change back to one of your old names.  tip, you'll
308      * still need to push that info to existing games.
309      * -functionhash- 0xb9291296
310      * @param _nameString the name you want to use 
311      */
312     function useMyOldName(string _nameString)
313         isHuman()
314         public 
315     {
316         // filter name, and get pID
317         bytes32 _name = _nameString.nameFilter();
318         uint256 _pID = pIDxAddr_[msg.sender];
319         
320         // make sure they own the name 
321         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
322         
323         // update their current name 
324         plyr_[_pID].name = _name;
325     }
326     
327 //==============================================================================
328 //     _ _  _ _   | _  _ . _  .
329 //    (_(_)| (/_  |(_)(_||(_  . 
330 //=====================_|=======================================================    
331     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
332         private
333     {
334         // if names already has been used, require that current msg sender owns the name
335         if (pIDxName_[_name] != 0)
336             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
337         
338         // add name to player profile, registry, and name book
339         plyr_[_pID].name = _name;
340         pIDxName_[_name] = _pID;
341         if (plyrNames_[_pID][_name] == false)
342         {
343             plyrNames_[_pID][_name] = true;
344             plyr_[_pID].names++;
345             plyrNameList_[_pID][plyr_[_pID].names] = _name;
346         }
347         
348         // registration fee goes directly to community rewards
349         god.transfer(address(this).balance);
350         
351         // push player info to games
352         if (_all == true)
353             for (uint256 i = 1; i <= gID_; i++)
354                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
355         
356         // fire event
357         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
358     }
359 //==============================================================================
360 //    _|_ _  _ | _  .
361 //     | (_)(_)|_\  .
362 //==============================================================================    
363     function determinePID(address _addr)
364         private
365         returns (bool)
366     {
367         if (pIDxAddr_[_addr] == 0)
368         {
369             pID_++;
370             pIDxAddr_[_addr] = pID_;
371             plyr_[pID_].addr = _addr;
372             
373             // set the new player bool to true
374             return (true);
375         } else {
376             return (false);
377         }
378     }
379 //==============================================================================
380 //   _   _|_ _  _ _  _ |   _ _ || _  .
381 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
382 //==============================================================================
383     function getPlayerID(address _addr)
384         isRegisteredGame()
385         external
386         returns (uint256)
387     {
388         determinePID(_addr);
389         return (pIDxAddr_[_addr]);
390     }
391     function getPlayerName(uint256 _pID)
392         external
393         view
394         returns (bytes32)
395     {
396         return (plyr_[_pID].name);
397     }
398     function getPlayerLAff(uint256 _pID)
399         external
400         view
401         returns (uint256)
402     {
403         return (plyr_[_pID].laff);
404     }
405     function getPlayerAddr(uint256 _pID)
406         external
407         view
408         returns (address)
409     {
410         return (plyr_[_pID].addr);
411     }
412     function getNameFee()
413         external
414         view
415         returns (uint256)
416     {
417         return(registrationFee_);
418     }
419     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
420         isRegisteredGame()
421         external
422         payable
423         returns(bool, uint256)
424     {
425         // make sure name fees paid
426         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
427         
428         // set up our tx event data and determine if player is new or not
429         bool _isNewPlayer = determinePID(_addr);
430         
431         // fetch player id
432         uint256 _pID = pIDxAddr_[_addr];
433         
434         // manage affiliate residuals
435         // if no affiliate code was given, no new affiliate code was given, or the 
436         // player tried to use their own pID as an affiliate code, lolz
437         uint256 _affID = _affCode;
438         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
439         {
440             // update last affiliate 
441             plyr_[_pID].laff = _affID;
442         } else if (_affID == _pID) {
443             _affID = 0;
444         }
445         
446         // register name 
447         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
448         
449         return(_isNewPlayer, _affID);
450     }
451     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
452         isRegisteredGame()
453         external
454         payable
455         returns(bool, uint256)
456     {
457         // make sure name fees paid
458         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
459         
460         // set up our tx event data and determine if player is new or not
461         bool _isNewPlayer = determinePID(_addr);
462         
463         // fetch player id
464         uint256 _pID = pIDxAddr_[_addr];
465         
466         // manage affiliate residuals
467         // if no affiliate code was given or player tried to use their own, lolz
468         uint256 _affID;
469         if (_affCode != address(0) && _affCode != _addr)
470         {
471             // get affiliate ID from aff Code 
472             _affID = pIDxAddr_[_affCode];
473             
474             // if affID is not the same as previously stored 
475             if (_affID != plyr_[_pID].laff)
476             {
477                 // update last affiliate
478                 plyr_[_pID].laff = _affID;
479             }
480         }
481         
482         // register name 
483         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
484         
485         return(_isNewPlayer, _affID);
486     }
487     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
488         isRegisteredGame()
489         external
490         payable
491         returns(bool, uint256)
492     {
493         // make sure name fees paid
494         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
495         
496         // set up our tx event data and determine if player is new or not
497         bool _isNewPlayer = determinePID(_addr);
498         
499         // fetch player id
500         uint256 _pID = pIDxAddr_[_addr];
501         
502         // manage affiliate residuals
503         // if no affiliate code was given or player tried to use their own, lolz
504         uint256 _affID;
505         if (_affCode != "" && _affCode != _name)
506         {
507             // get affiliate ID from aff Code 
508             _affID = pIDxName_[_affCode];
509             
510             // if affID is not the same as previously stored 
511             if (_affID != plyr_[_pID].laff)
512             {
513                 // update last affiliate
514                 plyr_[_pID].laff = _affID;
515             }
516         }
517         
518         // register name 
519         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
520         
521         return(_isNewPlayer, _affID);
522     }
523     
524 //==============================================================================
525 //   _ _ _|_    _   .
526 //  _\(/_ | |_||_)  .
527 //=============|================================================================
528     function addGame(address _gameAddress, string _gameNameStr)
529         public
530     {
531         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
532             gID_++;
533             bytes32 _name = _gameNameStr.nameFilter();
534             gameIDs_[_gameAddress] = gID_;
535             gameNames_[_gameAddress] = _name;
536             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
537         
538             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
539             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
540             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
541             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
542     }
543     
544     function setRegistrationFee(uint256 _fee)
545         public
546     {
547       registrationFee_ = _fee;
548     }
549         
550 } 
551 
552 /**
553 * @title -Name Filter- v0.1.9
554 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
555 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
556 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
557 *                                  _____                      _____
558 *                                 (, /     /)       /) /)    (, /      /)          /)
559 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
560 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
561 *          ┴ ┴                /   /          .-/ _____   (__ /                               
562 *                            (__ /          (_/ (, /                                      /)™ 
563 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
564 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
565 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
566 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
567 *              _       __    _      ____      ____  _   _    _____  ____  ___  
568 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
569 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
570 *
571 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
572 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
573 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
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