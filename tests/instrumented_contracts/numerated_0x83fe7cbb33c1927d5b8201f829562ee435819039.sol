1 pragma solidity ^0.4.24;
2 /*
3  * FOMO Fast-PlayerBook - v0.3.14
4  */
5 
6 
7 interface PlayerBookReceiverInterface {
8     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
9     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
10 }
11 
12 
13 contract PlayerBook {
14     using NameFilter for string;
15     using SafeMath for uint256;
16 
17     address private admin = msg.sender;
18 //==============================================================================
19 //     _| _ _|_ _    _ _ _|_    _   .
20 //    (_|(_| | (_|  _\(/_ | |_||_)  .
21 //=============================|================================================
22     // price to register a name 解读: 10  finney = 0.01 ETH, 1 ether == 1000 finney
23     uint256 public registrationFee_ = 10 finney;
24     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
25     mapping(address => bytes32) public gameNames_;          // lookup a games name
26     mapping(address => uint256) public gameIDs_;            // lokup a games ID
27     uint256 public gID_;        // total number of games
28     uint256 public pID_;        // total number of players
29     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
30     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
31     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
32     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
33     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
34     struct Player {
35         address addr;
36         bytes32 name;
37         uint256 laff;
38         uint256 names;
39     }
40 //==============================================================================
41 //     _ _  _  __|_ _    __|_ _  _  .
42 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
43 //==============================================================================
44     constructor()
45         public
46     {
47         // premine the dev names (sorry not sorry)
48             // No keys are purchased with this method, it's simply locking our addresses,
49             // PID's and names for referral codes.
50         plyr_[1].addr = 0xc9D1A85262dBDDEe5FE154502f290e813f14dc0b;
51         plyr_[1].name = "RunningTeam";
52         plyr_[1].names = 1;
53         pIDxAddr_[0xc9D1A85262dBDDEe5FE154502f290e813f14dc0b] = 1;
54         pIDxName_["RunningTeam"] = 1;
55         plyrNames_[1]["RunningTeam"] = true;
56         plyrNameList_[1][1] = "RunningTeam";
57 
58         //Total number of players
59         pID_ = 1;
60     }
61 //==============================================================================
62 //     _ _  _  _|. |`. _  _ _  .
63 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
64 //==============================================================================
65     /**
66      * @dev prevents contracts from interacting with fomo3d 解读: 判断是否是合约
67      */
68     modifier isHuman() {
69         address _addr = msg.sender;
70         uint256 _codeLength;
71 
72         assembly {_codeLength := extcodesize(_addr)}
73         require(_codeLength == 0, "sorry humans only");
74         _;
75     }
76 
77 
78     modifier isRegisteredGame()
79     {
80         require(gameIDs_[msg.sender] != 0);
81         _;
82     }
83 //==============================================================================
84 //     _    _  _ _|_ _  .
85 //    (/_\/(/_| | | _\  .
86 //==============================================================================
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
100 //==============================================================================
101 //     _  _ _|__|_ _  _ _  .
102 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
103 //=====_|=======================================================================
104     function checkIfNameValid(string _nameStr)
105         public
106         view
107         returns(bool)
108     {
109         bytes32 _name = _nameStr.nameFilter();
110         if (pIDxName_[_name] == 0)
111             return (true);
112         else
113             return (false);
114     }
115 //==============================================================================
116 //     _    |_ |. _   |`    _  __|_. _  _  _  .
117 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
118 //====|=========================================================================
119     /**
120      * @dev registers a name.  UI will always display the last name you registered.
121      * but you will still own all previously registered names to use as affiliate
122      * links.
123      * - must pay a registration fee.
124      * - name must be unique
125      * - names will be converted to lowercase
126      * - name cannot start or end with a space
127      * - cannot have more than 1 space in a row
128      * - cannot be only numbers
129      * - cannot start with 0x
130      * - name must be at least 1 char
131      * - max length of 32 characters long
132      * - allowed characters: a-z, 0-9, and space
133      * -functionhash- 0x921dec21 (using ID for affiliate)
134      * -functionhash- 0x3ddd4698 (using address for affiliate)
135      * -functionhash- 0x685ffd83 (using name for affiliate)
136      * @param _nameString players desired name
137      * @param _affCode affiliate ID, address, or name of who refered you
138      * @param _all set to true if you want this to push your info to all games
139      * (this might cost a lot of gas)
140      */
141     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
142         isHuman()
143         public
144         payable
145     {
146         // make sure name fees paid
147         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
148 
149         // filter name + condition checks
150         bytes32 _name = NameFilter.nameFilter(_nameString);
151 
152         // set up address
153         address _addr = msg.sender;
154 
155         // set up our tx event data and determine if player is new or not
156         bool _isNewPlayer = determinePID(_addr);
157 
158         // fetch player id
159         uint256 _pID = pIDxAddr_[_addr];
160 
161         // manage affiliate residuals
162         // if no affiliate code was given, no new affiliate code was given, or the
163         // player tried to use their own pID as an affiliate code, lolz
164         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
165         {
166             // update last affiliate
167             plyr_[_pID].laff = _affCode;
168         } else if (_affCode == _pID) {
169             _affCode = 0;
170         }
171 
172         // register name
173         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
174     }
175 
176     function registerNameXaddr(string _nameString, address _affCode, bool _all)
177         isHuman()
178         public
179         payable
180     {
181         // make sure name fees paid
182         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
183 
184         // filter name + condition checks
185         bytes32 _name = NameFilter.nameFilter(_nameString);
186 
187         // set up address
188         address _addr = msg.sender;
189 
190         // set up our tx event data and determine if player is new or not
191         bool _isNewPlayer = determinePID(_addr);
192 
193         // fetch player id
194         uint256 _pID = pIDxAddr_[_addr];
195 
196         // manage affiliate residuals
197         // if no affiliate code was given or player tried to use their own, lolz
198         uint256 _affID;
199         if (_affCode != address(0) && _affCode != _addr)
200         {
201             // get affiliate ID from aff Code
202             _affID = pIDxAddr_[_affCode];
203 
204             // if affID is not the same as previously stored
205             if (_affID != plyr_[_pID].laff)
206             {
207                 // update last affiliate
208                 plyr_[_pID].laff = _affID;
209             }
210         }
211 
212         // register name
213         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
214     }
215 
216     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
217         isHuman()
218         public
219         payable
220     {
221         // make sure name fees paid
222         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
223 
224         // filter name + condition checks
225         bytes32 _name = NameFilter.nameFilter(_nameString);
226 
227         // set up address
228         address _addr = msg.sender;
229 
230         // set up our tx event data and determine if player is new or not
231         bool _isNewPlayer = determinePID(_addr);
232 
233         // fetch player id
234         uint256 _pID = pIDxAddr_[_addr];
235 
236         // manage affiliate residuals
237         // if no affiliate code was given or player tried to use their own, lolz
238         uint256 _affID;
239         if (_affCode != "" && _affCode != _name)
240         {
241             // get affiliate ID from aff Code
242             _affID = pIDxName_[_affCode];
243 
244             // if affID is not the same as previously stored
245             if (_affID != plyr_[_pID].laff)
246             {
247                 // update last affiliate
248                 plyr_[_pID].laff = _affID;
249             }
250         }
251 
252         // register name
253         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
254     }
255 
256     /**
257      * @dev players, if you registered a profile, before a game was released, or
258      * set the all bool to false when you registered, use this function to push
259      * your profile to a single game.  also, if you've  updated your name, you
260      * can use this to push your name to games of your choosing.
261      * -functionhash- 0x81c5b206
262      * @param _gameID game id
263      */
264     function addMeToGame(uint256 _gameID)
265         isHuman()
266         public
267     {
268         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
269         address _addr = msg.sender;
270         uint256 _pID = pIDxAddr_[_addr];
271         require(_pID != 0, "hey there buddy, you dont even have an account");
272         uint256 _totalNames = plyr_[_pID].names;
273 
274         // add players profile and most recent name
275         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
276 
277         // add list of all names
278         if (_totalNames > 1)
279             for (uint256 ii = 1; ii <= _totalNames; ii++)
280                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
281     }
282 
283     /**
284      * @dev players, use this to push your player profile to all registered games.
285      * -functionhash- 0x0c6940ea
286      */
287     function addMeToAllGames()
288         isHuman()
289         public
290     {
291         address _addr = msg.sender;
292         uint256 _pID = pIDxAddr_[_addr];
293         require(_pID != 0, "hey there buddy, you dont even have an account");
294         uint256 _laff = plyr_[_pID].laff;
295         uint256 _totalNames = plyr_[_pID].names;
296         bytes32 _name = plyr_[_pID].name;
297 
298         for (uint256 i = 1; i <= gID_; i++)
299         {
300             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
301             if (_totalNames > 1)
302                 for (uint256 ii = 1; ii <= _totalNames; ii++)
303                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
304         }
305 
306     }
307 
308     /**
309      * @dev players use this to change back to one of your old names.  tip, you'll
310      * still need to push that info to existing games.
311      * -functionhash- 0xb9291296
312      * @param _nameString the name you want to use
313      */
314     function useMyOldName(string _nameString)
315         isHuman()
316         public
317     {
318         // filter name, and get pID
319         bytes32 _name = _nameString.nameFilter();
320         uint256 _pID = pIDxAddr_[msg.sender];
321 
322         // make sure they own the name
323         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
324 
325         // update their current name
326         plyr_[_pID].name = _name;
327     }
328 
329 //==============================================================================
330 //     _ _  _ _   | _  _ . _  .
331 //    (_(_)| (/_  |(_)(_||(_  .
332 //=====================_|=======================================================
333     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
334         private
335     {
336         // if names already has been used, require that current msg sender owns the name
337         if (pIDxName_[_name] != 0)
338             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
339 
340         // add name to player profile, registry, and name book
341         plyr_[_pID].name = _name;
342         pIDxName_[_name] = _pID;
343         if (plyrNames_[_pID][_name] == false)
344         {
345             plyrNames_[_pID][_name] = true;
346             plyr_[_pID].names++;
347             plyrNameList_[_pID][plyr_[_pID].names] = _name;
348         }
349 
350         // registration fee goes directly to community rewards
351         admin.transfer(address(this).balance);
352 
353         // push player info to games
354         if (_all == true)
355             for (uint256 i = 1; i <= gID_; i++)
356                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
357 
358         // fire event
359         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
360     }
361 //==============================================================================
362 //    _|_ _  _ | _  .
363 //     | (_)(_)|_\  .
364 //==============================================================================
365     function determinePID(address _addr)
366         private
367         returns (bool)
368     {
369         if (pIDxAddr_[_addr] == 0)
370         {
371             pID_++;
372             pIDxAddr_[_addr] = pID_;
373             plyr_[pID_].addr = _addr;
374 
375             // set the new player bool to true
376             return (true);
377         } else {
378             return (false);
379         }
380     }
381 //==============================================================================
382 //   _   _|_ _  _ _  _ |   _ _ || _  .
383 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
384 //==============================================================================
385     function getPlayerID(address _addr)
386         isRegisteredGame()
387         external
388         returns (uint256)
389     {
390         determinePID(_addr);
391         return (pIDxAddr_[_addr]);
392     }
393     function getPlayerName(uint256 _pID)
394         external
395         view
396         returns (bytes32)
397     {
398         return (plyr_[_pID].name);
399     }
400     function getPlayerLAff(uint256 _pID)
401         external
402         view
403         returns (uint256)
404     {
405         return (plyr_[_pID].laff);
406     }
407     function getPlayerAddr(uint256 _pID)
408         external
409         view
410         returns (address)
411     {
412         return (plyr_[_pID].addr);
413     }
414     function getNameFee()
415         external
416         view
417         returns (uint256)
418     {
419         return(registrationFee_);
420     }
421     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
422         isRegisteredGame()
423         external
424         payable
425         returns(bool, uint256)
426     {
427         // make sure name fees paid
428         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
429 
430         // set up our tx event data and determine if player is new or not
431         bool _isNewPlayer = determinePID(_addr);
432 
433         // fetch player id
434         uint256 _pID = pIDxAddr_[_addr];
435 
436         // manage affiliate residuals
437         // if no affiliate code was given, no new affiliate code was given, or the
438         // player tried to use their own pID as an affiliate code, lolz
439         uint256 _affID = _affCode;
440         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
441         {
442             // update last affiliate
443             plyr_[_pID].laff = _affID;
444         } else if (_affID == _pID) {
445             _affID = 0;
446         }
447 
448         // register name
449         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
450 
451         return(_isNewPlayer, _affID);
452     }
453     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
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
469         // if no affiliate code was given or player tried to use their own, lolz
470         uint256 _affID;
471         if (_affCode != address(0) && _affCode != _addr)
472         {
473             // get affiliate ID from aff Code
474             _affID = pIDxAddr_[_affCode];
475 
476             // if affID is not the same as previously stored
477             if (_affID != plyr_[_pID].laff)
478             {
479                 // update last affiliate
480                 plyr_[_pID].laff = _affID;
481             }
482         }
483 
484         // register name
485         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
486 
487         return(_isNewPlayer, _affID);
488     }
489     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
490         isRegisteredGame()
491         external
492         payable
493         returns(bool, uint256)
494     {
495         // make sure name fees paid
496         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
497 
498         // set up our tx event data and determine if player is new or not
499         bool _isNewPlayer = determinePID(_addr);
500 
501         // fetch player id
502         uint256 _pID = pIDxAddr_[_addr];
503 
504         // manage affiliate residuals
505         // if no affiliate code was given or player tried to use their own, lolz
506         uint256 _affID;
507         if (_affCode != "" && _affCode != _name)
508         {
509             // get affiliate ID from aff Code
510             _affID = pIDxName_[_affCode];
511 
512             // if affID is not the same as previously stored
513             if (_affID != plyr_[_pID].laff)
514             {
515                 // update last affiliate
516                 plyr_[_pID].laff = _affID;
517             }
518         }
519 
520         // register name
521         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
522 
523         return(_isNewPlayer, _affID);
524     }
525 
526 //==============================================================================
527 //   _ _ _|_    _   .
528 //  _\(/_ | |_||_)  .
529 //=============|================================================================
530     function addGame(address _gameAddress, string _gameNameStr)
531         public
532     {
533         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
534             gID_++;
535             bytes32 _name = _gameNameStr.nameFilter();
536             gameIDs_[_gameAddress] = gID_;
537             gameNames_[_gameAddress] = _name;
538             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
539 
540             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
541             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
542             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
543             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
544     }
545 
546     function setRegistrationFee(uint256 _fee)
547         public
548     {
549       registrationFee_ = _fee;
550     }
551 
552 }
553 
554 /**
555 * @title -Name Filter- v0.1.9
556 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
557 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
558 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
559 *                                  _____                      _____
560 *                                 (, /     /)       /) /)    (, /      /)          /)
561 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
562 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
563 *          ┴ ┴                /   /          .-/ _____   (__ /
564 *                            (__ /          (_/ (, /                                      /)™
565 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
566 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
567 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
568 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
569 *              _       __    _      ____      ____  _   _    _____  ____  ___
570 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
571 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
572 *
573 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
574 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
575 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
576 */
577 library NameFilter {
578 
579     /**
580      * @dev filters name strings
581      * -converts uppercase to lower case.
582      * -makes sure it does not start/end with a space
583      * -makes sure it does not contain multiple spaces in a row
584      * -cannot be only numbers
585      * -cannot start with 0x
586      * -restricts characters to A-Z, a-z, 0-9, and space.
587      * @return reprocessed string in bytes32 format
588      */
589     function nameFilter(string _input)
590         internal
591         pure
592         returns(bytes32)
593     {
594         bytes memory _temp = bytes(_input);
595         uint256 _length = _temp.length;
596 
597         //sorry limited to 32 characters
598         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
599         // make sure it doesnt start with or end with space
600         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
601         // make sure first two characters are not 0x
602         if (_temp[0] == 0x30)
603         {
604             require(_temp[1] != 0x78, "string cannot start with 0x");
605             require(_temp[1] != 0x58, "string cannot start with 0X");
606         }
607 
608         // create a bool to track if we have a non number character
609         bool _hasNonNumber;
610 
611         // convert & check
612         for (uint256 i = 0; i < _length; i++)
613         {
614             // if its uppercase A-Z
615             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
616             {
617                 // convert to lower case a-z
618                 _temp[i] = byte(uint(_temp[i]) + 32);
619 
620                 // we have a non number
621                 if (_hasNonNumber == false)
622                     _hasNonNumber = true;
623             } else {
624                 require
625                 (
626                     // require character is a space
627                     _temp[i] == 0x20 ||
628                     // OR lowercase a-z
629                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
630                     // or 0-9
631                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
632                     "string contains invalid characters"
633                 );
634                 // make sure theres not 2x spaces in a row
635                 if (_temp[i] == 0x20)
636                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
637 
638                 // see if we have a character other than a number
639                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
640                     _hasNonNumber = true;
641             }
642         }
643 
644         require(_hasNonNumber == true, "string cannot be only numbers");
645 
646         bytes32 _ret;
647         assembly {
648             _ret := mload(add(_temp, 32))
649         }
650         return (_ret);
651     }
652 }
653 
654 /**
655  * @title SafeMath v0.1.9
656  * @dev Math operations with safety checks that throw on error
657  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
658  * - added sqrt
659  * - added sq
660  * - added pwr
661  * - changed asserts to requires with error log outputs
662  * - removed div, its useless
663  */
664 library SafeMath {
665 
666     /**
667     * @dev Multiplies two numbers, throws on overflow.
668     */
669     function mul(uint256 a, uint256 b)
670         internal
671         pure
672         returns (uint256 c)
673     {
674         if (a == 0) {
675             return 0;
676         }
677         c = a * b;
678         require(c / a == b, "SafeMath mul failed");
679         return c;
680     }
681 
682     /**
683     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
684     */
685     function sub(uint256 a, uint256 b)
686         internal
687         pure
688         returns (uint256)
689     {
690         require(b <= a, "SafeMath sub failed");
691         return a - b;
692     }
693 
694     /**
695     * @dev Adds two numbers, throws on overflow.
696     */
697     function add(uint256 a, uint256 b)
698         internal
699         pure
700         returns (uint256 c)
701     {
702         c = a + b;
703         require(c >= a, "SafeMath add failed");
704         return c;
705     }
706 
707     /**
708      * @dev gives square root of given x.
709      */
710     function sqrt(uint256 x)
711         internal
712         pure
713         returns (uint256 y)
714     {
715         uint256 z = ((add(x,1)) / 2);
716         y = x;
717         while (z < y)
718         {
719             y = z;
720             z = ((add((x / z),z)) / 2);
721         }
722     }
723 
724     /**
725      * @dev gives square. multiplies x by x
726      */
727     function sq(uint256 x)
728         internal
729         pure
730         returns (uint256)
731     {
732         return (mul(x,x));
733     }
734 
735     /**
736      * @dev x to the power of y
737      */
738     function pwr(uint256 x, uint256 y)
739         internal
740         pure
741         returns (uint256)
742     {
743         if (x==0)
744             return (0);
745         else if (y==0)
746             return (1);
747         else
748         {
749             uint256 z = x;
750             for (uint256 i=1; i < y; i++)
751                 z = mul(z,x);
752             return (z);
753         }
754     }
755 }