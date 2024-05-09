1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 contract PlayerBook {
9     using NameFilter for string;
10     using SafeMath for uint256;
11 
12     address private adminAddress = 0xFAdb9139a33a4F2FE67D340B6AAef0d04E9D5681;
13 
14     MSFun.Data private msData;
15     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
16     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
17     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
18     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
19     //==============================================================================
20     //     _| _ _|_ _    _ _ _|_    _   .
21     //    (_|(_| | (_|  _\(/_ | |_||_)  .
22     //=============================|================================================
23     uint256 public registrationFee_ = 10 finney;            // price to register a name
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
40     //==============================================================================
41     //     _ _  _  __|_ _    __|_ _  _  .
42     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
43     //==============================================================================
44     constructor()
45     public
46     {
47         // premine the dev names (sorry not sorry)
48         // No keys are purchased with this method, it's simply locking our addresses,
49         // PID's and names for referral codes.
50         plyr_[1].addr = adminAddress;
51         plyr_[1].name = "inventor";
52         plyr_[1].names = 1;
53         pIDxAddr_[adminAddress] = 1;
54         pIDxName_["inventor"] = 1;
55         plyrNames_[1]["inventor"] = true;
56         plyrNameList_[1][1] = "inventor";
57 
58         pID_ = 1;
59     }
60     //==============================================================================
61     //     _ _  _  _|. |`. _  _ _  .
62     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
63     //==============================================================================
64     /**
65      * @dev prevents contracts from interacting with fomo3d
66      */
67     modifier isHuman() {
68         address _addr = msg.sender;
69         uint256 _codeLength;
70 
71         assembly {_codeLength := extcodesize(_addr)}
72         require(_codeLength == 0, "sorry humans only");
73         _;
74     }
75 
76     modifier onlyDevs()
77     {
78         require(msg.sender == adminAddress, "msg sender is not a dev");
79         _;
80     }
81 
82     modifier isRegisteredGame()
83     {
84         require(gameIDs_[msg.sender] != 0);
85         _;
86     }
87     //==============================================================================
88     //     _    _  _ _|_ _  .
89     //    (/_\/(/_| | | _\  .
90     //==============================================================================
91     // fired whenever a player registers a name
92     event onNewName
93     (
94         uint256 indexed playerID,
95         address indexed playerAddress,
96         bytes32 indexed playerName,
97         bool isNewPlayer,
98         uint256 affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 amountPaid,
102         uint256 timeStamp
103     );
104     //==============================================================================
105     //     _  _ _|__|_ _  _ _  .
106     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
107     //=====_|=======================================================================
108     function checkIfNameValid(string _nameStr)
109     public
110     view
111     returns(bool)
112     {
113         bytes32 _name = _nameStr.nameFilter();
114         if (pIDxName_[_name] == 0)
115             return (true);
116         else
117             return (false);
118     }
119     //==============================================================================
120     //     _    |_ |. _   |`    _  __|_. _  _  _  .
121     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
122     //====|=========================================================================
123     /**
124      * @dev registers a name.  UI will always display the last name you registered.
125      * but you will still own all previously registered names to use as affiliate
126      * links.
127      * - must pay a registration fee.
128      * - name must be unique
129      * - names will be converted to lowercase
130      * - name cannot start or end with a space
131      * - cannot have more than 1 space in a row
132      * - cannot be only numbers
133      * - cannot start with 0x
134      * - name must be at least 1 char
135      * - max length of 32 characters long
136      * - allowed characters: a-z, 0-9, and space
137      * -functionhash- 0x921dec21 (using ID for affiliate)
138      * -functionhash- 0x3ddd4698 (using address for affiliate)
139      * -functionhash- 0x685ffd83 (using name for affiliate)
140      * @param _nameString players desired name
141      * @param _affCode affiliate ID, address, or name of who refered you
142      * @param _all set to true if you want this to push your info to all games
143      * (this might cost a lot of gas)
144      */
145     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
146     isHuman()
147     public
148     payable
149     {
150         // make sure name fees paid
151         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
152 
153         // filter name + condition checks
154         bytes32 _name = NameFilter.nameFilter(_nameString);
155 
156         // set up address
157         address _addr = msg.sender;
158 
159         // set up our tx event data and determine if player is new or not
160         bool _isNewPlayer = determinePID(_addr);
161 
162         // fetch player id
163         uint256 _pID = pIDxAddr_[_addr];
164 
165         // manage affiliate residuals
166         // if no affiliate code was given, no new affiliate code was given, or the
167         // player tried to use their own pID as an affiliate code, lolz
168         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
169         {
170             // update last affiliate
171             plyr_[_pID].laff = _affCode;
172         } else if (_affCode == _pID) {
173             _affCode = 0;
174         }
175 
176         // register name
177         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
178     }
179 
180     function registerNameXaddr(string _nameString, address _affCode, bool _all)
181     isHuman()
182     public
183     payable
184     {
185         // make sure name fees paid
186         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
187 
188         // filter name + condition checks
189         bytes32 _name = NameFilter.nameFilter(_nameString);
190 
191         // set up address
192         address _addr = msg.sender;
193 
194         // set up our tx event data and determine if player is new or not
195         bool _isNewPlayer = determinePID(_addr);
196 
197         // fetch player id
198         uint256 _pID = pIDxAddr_[_addr];
199 
200         // manage affiliate residuals
201         // if no affiliate code was given or player tried to use their own, lolz
202         uint256 _affID;
203         if (_affCode != address(0) && _affCode != _addr)
204         {
205             // get affiliate ID from aff Code
206             _affID = pIDxAddr_[_affCode];
207 
208             // if affID is not the same as previously stored
209             if (_affID != plyr_[_pID].laff)
210             {
211                 // update last affiliate
212                 plyr_[_pID].laff = _affID;
213             }
214         }
215 
216         // register name
217         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
218     }
219 
220     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
221     isHuman()
222     public
223     payable
224     {
225         // make sure name fees paid
226         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
227 
228         // filter name + condition checks
229         bytes32 _name = NameFilter.nameFilter(_nameString);
230 
231         // set up address
232         address _addr = msg.sender;
233 
234         // set up our tx event data and determine if player is new or not
235         bool _isNewPlayer = determinePID(_addr);
236 
237         // fetch player id
238         uint256 _pID = pIDxAddr_[_addr];
239 
240         // manage affiliate residuals
241         // if no affiliate code was given or player tried to use their own, lolz
242         uint256 _affID;
243         if (_affCode != "" && _affCode != _name)
244         {
245             // get affiliate ID from aff Code
246             _affID = pIDxName_[_affCode];
247 
248             // if affID is not the same as previously stored
249             if (_affID != plyr_[_pID].laff)
250             {
251                 // update last affiliate
252                 plyr_[_pID].laff = _affID;
253             }
254         }
255 
256         // register name
257         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
258     }
259 
260     /**
261      * @dev players, if you registered a profile, before a game was released, or
262      * set the all bool to false when you registered, use this function to push
263      * your profile to a single game.  also, if you've  updated your name, you
264      * can use this to push your name to games of your choosing.
265      * -functionhash- 0x81c5b206
266      * @param _gameID game id
267      */
268     function addMeToGame(uint256 _gameID)
269     isHuman()
270     public
271     {
272         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
273         address _addr = msg.sender;
274         uint256 _pID = pIDxAddr_[_addr];
275         require(_pID != 0, "hey there buddy, you dont even have an account");
276         uint256 _totalNames = plyr_[_pID].names;
277 
278         // add players profile and most recent name
279         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
280 
281         // add list of all names
282         if (_totalNames > 1)
283             for (uint256 ii = 1; ii <= _totalNames; ii++)
284                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
285     }
286 
287     /**
288      * @dev players, use this to push your player profile to all registered games.
289      * -functionhash- 0x0c6940ea
290      */
291     function addMeToAllGames()
292     isHuman()
293     public
294     {
295         address _addr = msg.sender;
296         uint256 _pID = pIDxAddr_[_addr];
297         require(_pID != 0, "hey there buddy, you dont even have an account");
298         uint256 _laff = plyr_[_pID].laff;
299         uint256 _totalNames = plyr_[_pID].names;
300         bytes32 _name = plyr_[_pID].name;
301 
302         for (uint256 i = 1; i <= gID_; i++)
303         {
304             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
305             if (_totalNames > 1)
306                 for (uint256 ii = 1; ii <= _totalNames; ii++)
307                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
308         }
309 
310     }
311 
312     /**
313      * @dev players use this to change back to one of your old names.  tip, you'll
314      * still need to push that info to existing games.
315      * -functionhash- 0xb9291296
316      * @param _nameString the name you want to use
317      */
318     function useMyOldName(string _nameString)
319     isHuman()
320     public
321     {
322         // filter name, and get pID
323         bytes32 _name = _nameString.nameFilter();
324         uint256 _pID = pIDxAddr_[msg.sender];
325 
326         // make sure they own the name
327         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
328 
329         // update their current name
330         plyr_[_pID].name = _name;
331     }
332 
333     //==============================================================================
334     //     _ _  _ _   | _  _ . _  .
335     //    (_(_)| (/_  |(_)(_||(_  .
336     //=====================_|=======================================================
337     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
338     private
339     {
340         // if names already has been used, require that current msg sender owns the name
341         if (pIDxName_[_name] != 0)
342             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
343 
344         // add name to player profile, registry, and name book
345         plyr_[_pID].name = _name;
346         pIDxName_[_name] = _pID;
347         if (plyrNames_[_pID][_name] == false)
348         {
349             plyrNames_[_pID][_name] = true;
350             plyr_[_pID].names++;
351             plyrNameList_[_pID][plyr_[_pID].names] = _name;
352         }
353 
354         // push player info to games
355         if (_all == true)
356             for (uint256 i = 1; i <= gID_; i++)
357                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
358 
359         // fire event
360         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
361     }
362     //==============================================================================
363     //    _|_ _  _ | _  .
364     //     | (_)(_)|_\  .
365     //==============================================================================
366     function determinePID(address _addr)
367     private
368     returns (bool)
369     {
370         if (pIDxAddr_[_addr] == 0)
371         {
372             pID_++;
373             pIDxAddr_[_addr] = pID_;
374             plyr_[pID_].addr = _addr;
375 
376             // set the new player bool to true
377             return (true);
378         } else {
379             return (false);
380         }
381     }
382     //==============================================================================
383     //   _   _|_ _  _ _  _ |   _ _ || _  .
384     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
385     //==============================================================================
386     function getPlayerID(address _addr)
387     isRegisteredGame()
388     external
389     returns (uint256)
390     {
391         determinePID(_addr);
392         return (pIDxAddr_[_addr]);
393     }
394     function getPlayerName(uint256 _pID)
395     external
396     view
397     returns (bytes32)
398     {
399         return (plyr_[_pID].name);
400     }
401     function getPlayerLAff(uint256 _pID)
402     external
403     view
404     returns (uint256)
405     {
406         return (plyr_[_pID].laff);
407     }
408     function getPlayerAddr(uint256 _pID)
409     external
410     view
411     returns (address)
412     {
413         return (plyr_[_pID].addr);
414     }
415     function getNameFee()
416     external
417     view
418     returns (uint256)
419     {
420         return(registrationFee_);
421     }
422     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
423     isRegisteredGame()
424     external
425     payable
426     returns(bool, uint256)
427     {
428         // make sure name fees paid
429         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
430 
431         // set up our tx event data and determine if player is new or not
432         bool _isNewPlayer = determinePID(_addr);
433 
434         // fetch player id
435         uint256 _pID = pIDxAddr_[_addr];
436 
437         // manage affiliate residuals
438         // if no affiliate code was given, no new affiliate code was given, or the
439         // player tried to use their own pID as an affiliate code, lolz
440         uint256 _affID = _affCode;
441         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
442         {
443             // update last affiliate
444             plyr_[_pID].laff = _affID;
445         } else if (_affID == _pID) {
446             _affID = 0;
447         }
448 
449         // register name
450         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
451 
452         return(_isNewPlayer, _affID);
453     }
454     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
455     isRegisteredGame()
456     external
457     payable
458     returns(bool, uint256)
459     {
460         // make sure name fees paid
461         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
462 
463         // set up our tx event data and determine if player is new or not
464         bool _isNewPlayer = determinePID(_addr);
465 
466         // fetch player id
467         uint256 _pID = pIDxAddr_[_addr];
468 
469         // manage affiliate residuals
470         // if no affiliate code was given or player tried to use their own, lolz
471         uint256 _affID;
472         if (_affCode != address(0) && _affCode != _addr)
473         {
474             // get affiliate ID from aff Code
475             _affID = pIDxAddr_[_affCode];
476 
477             // if affID is not the same as previously stored
478             if (_affID != plyr_[_pID].laff)
479             {
480                 // update last affiliate
481                 plyr_[_pID].laff = _affID;
482             }
483         }
484 
485         // register name
486         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
487 
488         return(_isNewPlayer, _affID);
489     }
490     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
491     isRegisteredGame()
492     external
493     payable
494     returns(bool, uint256)
495     {
496         // make sure name fees paid
497         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
498 
499         // set up our tx event data and determine if player is new or not
500         bool _isNewPlayer = determinePID(_addr);
501 
502         // fetch player id
503         uint256 _pID = pIDxAddr_[_addr];
504 
505         // manage affiliate residuals
506         // if no affiliate code was given or player tried to use their own, lolz
507         uint256 _affID;
508         if (_affCode != "" && _affCode != _name)
509         {
510             // get affiliate ID from aff Code
511             _affID = pIDxName_[_affCode];
512 
513             // if affID is not the same as previously stored
514             if (_affID != plyr_[_pID].laff)
515             {
516                 // update last affiliate
517                 plyr_[_pID].laff = _affID;
518             }
519         }
520 
521         // register name
522         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
523 
524         return(_isNewPlayer, _affID);
525     }
526 
527     function addGame(address _gameAddress, string _gameNameStr)
528     onlyDevs()
529     public
530     {
531         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
532 
533         gID_++;
534         bytes32 _name = _gameNameStr.nameFilter();
535         gameIDs_[_gameAddress] = gID_;
536         gameNames_[_gameAddress] = _name;
537         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
538 
539         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
540     }
541 }
542 
543 /**
544 * @title -Name Filter- v0.1.9
545 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
546 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
547 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
548 *                                  _____                      _____
549 *                                 (, /     /)       /) /)    (, /      /)          /)
550 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
551 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
552 *          ┴ ┴                /   /          .-/ _____   (__ /
553 *                            (__ /          (_/ (, /                                      /)™
554 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
555 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
556 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
557 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
558 *              _       __    _      ____      ____  _   _    _____  ____  ___
559 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
560 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
561 *
562 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
563 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
564 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
565 */
566 library NameFilter {
567 
568     /**
569      * @dev filters name strings
570      * -converts uppercase to lower case.
571      * -makes sure it does not start/end with a space
572      * -makes sure it does not contain multiple spaces in a row
573      * -cannot be only numbers
574      * -cannot start with 0x
575      * -restricts characters to A-Z, a-z, 0-9, and space.
576      * @return reprocessed string in bytes32 format
577      */
578     function nameFilter(string _input)
579     internal
580     pure
581     returns(bytes32)
582     {
583         bytes memory _temp = bytes(_input);
584         uint256 _length = _temp.length;
585 
586         //sorry limited to 32 characters
587         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
588         // make sure it doesnt start with or end with space
589         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
590         // make sure first two characters are not 0x
591         if (_temp[0] == 0x30)
592         {
593             require(_temp[1] != 0x78, "string cannot start with 0x");
594             require(_temp[1] != 0x58, "string cannot start with 0X");
595         }
596 
597         // create a bool to track if we have a non number character
598         bool _hasNonNumber;
599 
600         // convert & check
601         for (uint256 i = 0; i < _length; i++)
602         {
603             // if its uppercase A-Z
604             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
605             {
606                 // convert to lower case a-z
607                 _temp[i] = byte(uint(_temp[i]) + 32);
608 
609                 // we have a non number
610                 if (_hasNonNumber == false)
611                     _hasNonNumber = true;
612             } else {
613                 require
614                 (
615                 // require character is a space
616                     _temp[i] == 0x20 ||
617                 // OR lowercase a-z
618                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
619                 // or 0-9
620                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
621                     "string contains invalid characters"
622                 );
623                 // make sure theres not 2x spaces in a row
624                 if (_temp[i] == 0x20)
625                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
626 
627                 // see if we have a character other than a number
628                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
629                     _hasNonNumber = true;
630             }
631         }
632 
633         require(_hasNonNumber == true, "string cannot be only numbers");
634 
635         bytes32 _ret;
636         assembly {
637             _ret := mload(add(_temp, 32))
638         }
639         return (_ret);
640     }
641 }
642 
643 /**
644  * @title SafeMath v0.1.9
645  * @dev Math operations with safety checks that throw on error
646  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
647  * - added sqrt
648  * - added sq
649  * - added pwr
650  * - changed asserts to requires with error log outputs
651  * - removed div, its useless
652  */
653 library SafeMath {
654 
655     /**
656     * @dev Multiplies two numbers, throws on overflow.
657     */
658     function mul(uint256 a, uint256 b)
659     internal
660     pure
661     returns (uint256 c)
662     {
663         if (a == 0) {
664             return 0;
665         }
666         c = a * b;
667         require(c / a == b, "SafeMath mul failed");
668         return c;
669     }
670 
671     /**
672     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
673     */
674     function sub(uint256 a, uint256 b)
675     internal
676     pure
677     returns (uint256)
678     {
679         require(b <= a, "SafeMath sub failed");
680         return a - b;
681     }
682 
683     /**
684     * @dev Adds two numbers, throws on overflow.
685     */
686     function add(uint256 a, uint256 b)
687     internal
688     pure
689     returns (uint256 c)
690     {
691         c = a + b;
692         require(c >= a, "SafeMath add failed");
693         return c;
694     }
695 
696     /**
697      * @dev gives square root of given x.
698      */
699     function sqrt(uint256 x)
700     internal
701     pure
702     returns (uint256 y)
703     {
704         uint256 z = ((add(x,1)) / 2);
705         y = x;
706         while (z < y)
707         {
708             y = z;
709             z = ((add((x / z),z)) / 2);
710         }
711     }
712 
713     /**
714      * @dev gives square. multiplies x by x
715      */
716     function sq(uint256 x)
717     internal
718     pure
719     returns (uint256)
720     {
721         return (mul(x,x));
722     }
723 
724     /**
725      * @dev x to the power of y
726      */
727     function pwr(uint256 x, uint256 y)
728     internal
729     pure
730     returns (uint256)
731     {
732         if (x==0)
733             return (0);
734         else if (y==0)
735             return (1);
736         else
737         {
738             uint256 z = x;
739             for (uint256 i=1; i < y; i++)
740                 z = mul(z,x);
741             return (z);
742         }
743     }
744 }
745 
746 /** @title -MSFun- v0.2.4
747  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
748  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
749  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
750  *                                  _____                      _____
751  *                                 (, /     /)       /) /)    (, /      /)          /)
752  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
753  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
754  *          ┴ ┴                /   /          .-/ _____   (__ /
755  *                            (__ /          (_/ (, /                                      /)™
756  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
757  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
758  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
759  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
760  *  _           _             _  _  _  _             _  _  _  _  _
761  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
762  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _
763  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_
764  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)
765  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _
766  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
767  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
768  *
769  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
770  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
771  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
772  *
773  *         ┌──────────────────────────────────────────────────────────────────────┐
774  *         │ MSFun, is an importable library that gives your contract the ability │
775  *         │ add multiSig requirement to functions.                               │
776  *         └──────────────────────────────────────────────────────────────────────┘
777  *                                ┌────────────────────┐
778  *                                │ Setup Instructions │
779  *                                └────────────────────┘
780  * (Step 1) import the library into your contract
781  *
782  *    import "./MSFun.sol";
783  *
784  * (Step 2) set up the signature data for msFun
785  *
786  *     MSFun.Data private msData;
787  *                                ┌────────────────────┐
788  *                                │ Usage Instructions │
789  *                                └────────────────────┘
790  * at the beginning of a function
791  *
792  *     function functionName()
793  *     {
794  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
795  *         {
796  *             MSFun.deleteProposal(msData, "functionName");
797  *
798  *             // put function body here
799  *         }
800  *     }
801  *                           ┌────────────────────────────────┐
802  *                           │ Optional Wrappers For TeamJust │
803  *                           └────────────────────────────────┘
804  * multiSig wrapper function (cuts down on inputs, improves readability)
805  * this wrapper is HIGHLY recommended
806  *
807  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
808  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
809  *
810  * wrapper for delete proposal (makes code cleaner)
811  *
812  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
813  *                             ┌────────────────────────────┐
814  *                             │ Utility & Vanity Functions │
815  *                             └────────────────────────────┘
816  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
817  * function, with argument inputs that the other admins do not agree upon, the function
818  * can never be executed until the undesirable arguments are approved.
819  *
820  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
821  *
822  * for viewing who has signed a proposal & proposal data
823  *
824  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
825  *
826  * lets you check address of up to 3 signers (address)
827  *
828  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
829  *
830  * same as above but will return names in string format.
831  *
832  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
833  *                             ┌──────────────────────────┐
834  *                             │ Functions In Depth Guide │
835  *                             └──────────────────────────┘
836  * In the following examples, the Data is the proposal set for this library.  And
837  * the bytes32 is the name of the function.
838  *
839  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig
840  *      proposal for the function being called.  The uint256 is the required
841  *      number of signatures needed before the multiSig will return true.
842  *      Upon first call, multiSig will create a proposal and store the arguments
843  *      passed with the function call as msgData.  Any admins trying to sign the
844  *      function call will need to send the same argument values. Once required
845  *      number of signatures is reached this will return a bool of true.
846  *
847  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
848  *      you will want to delete the proposal data.  This does that.
849  *
850  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal
851  *
852  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
853  *      the proposal
854  *
855  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
856  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
857  */
858 
859 library MSFun {
860     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
861     // DATA SETS
862     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
863     // contact data setup
864     struct Data
865     {
866         mapping (bytes32 => ProposalData) proposal_;
867     }
868     struct ProposalData
869     {
870         // a hash of msg.data
871         bytes32 msgData;
872         // number of signers
873         uint256 count;
874         // tracking of wither admins have signed
875         mapping (address => bool) admin;
876         // list of admins who have signed
877         mapping (uint256 => address) log;
878     }
879 
880     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
881     // MULTI SIG FUNCTIONS
882     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
883     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
884     internal
885     returns(bool)
886     {
887         // our proposal key will be a hash of our function name + our contracts address
888         // by adding our contracts address to this, we prevent anyone trying to circumvent
889         // the proposal's security via external calls.
890         bytes32 _whatProposal = whatProposal(_whatFunction);
891 
892         // this is just done to make the code more readable.  grabs the signature count
893         uint256 _currentCount = self.proposal_[_whatProposal].count;
894 
895         // store the address of the person sending the function call.  we use msg.sender
896         // here as a layer of security.  in case someone imports our contract and tries to
897         // circumvent function arguments.  still though, our contract that imports this
898         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
899         // calls the function will be a signer.
900         address _whichAdmin = msg.sender;
901 
902         // prepare our msg data.  by storing this we are able to verify that all admins
903         // are approving the same argument input to be executed for the function.  we hash
904         // it and store in bytes32 so its size is known and comparable
905         bytes32 _msgData = keccak256(msg.data);
906 
907         // check to see if this is a new execution of this proposal or not
908         if (_currentCount == 0)
909         {
910             // if it is, lets record the original signers data
911             self.proposal_[_whatProposal].msgData = _msgData;
912 
913             // record original senders signature
914             self.proposal_[_whatProposal].admin[_whichAdmin] = true;
915 
916             // update log (used to delete records later, and easy way to view signers)
917             // also useful if the calling function wants to give something to a
918             // specific signer.
919             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;
920 
921             // track number of signatures
922             self.proposal_[_whatProposal].count += 1;
923 
924             // if we now have enough signatures to execute the function, lets
925             // return a bool of true.  we put this here in case the required signatures
926             // is set to 1.
927             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
928                 return(true);
929             }
930             // if its not the first execution, lets make sure the msgData matches
931         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
932             // msgData is a match
933             // make sure admin hasnt already signed
934             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false)
935             {
936                 // record their signature
937                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;
938 
939                 // update log (used to delete records later, and easy way to view signers)
940                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;
941 
942                 // track number of signatures
943                 self.proposal_[_whatProposal].count += 1;
944             }
945 
946             // if we now have enough signatures to execute the function, lets
947             // return a bool of true.
948             // we put this here for a few reasons.  (1) in normal operation, if
949             // that last recorded signature got us to our required signatures.  we
950             // need to return bool of true.  (2) if we have a situation where the
951             // required number of signatures was adjusted to at or lower than our current
952             // signature count, by putting this here, an admin who has already signed,
953             // can call the function again to make it return a true bool.  but only if
954             // they submit the correct msg data
955             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
956                 return(true);
957             }
958         }
959     }
960 
961 
962     // deletes proposal signature data after successfully executing a multiSig function
963     function deleteProposal(Data storage self, bytes32 _whatFunction)
964     internal
965     {
966         //done for readability sake
967         bytes32 _whatProposal = whatProposal(_whatFunction);
968         address _whichAdmin;
969 
970         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this
971         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
972         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
973             _whichAdmin = self.proposal_[_whatProposal].log[i];
974             delete self.proposal_[_whatProposal].admin[_whichAdmin];
975             delete self.proposal_[_whatProposal].log[i];
976         }
977         //delete the rest of the data in the record
978         delete self.proposal_[_whatProposal];
979     }
980 
981     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
982     // HELPER FUNCTIONS
983     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
984 
985     function whatProposal(bytes32 _whatFunction)
986     private
987     view
988     returns(bytes32)
989     {
990         return(keccak256(abi.encodePacked(_whatFunction,this)));
991     }
992 
993     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
994     // VANITY FUNCTIONS
995     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
996     // returns a hashed version of msg.data sent by original signer for any given function
997     function checkMsgData (Data storage self, bytes32 _whatFunction)
998     internal
999     view
1000     returns (bytes32 msg_data)
1001     {
1002         bytes32 _whatProposal = whatProposal(_whatFunction);
1003         return (self.proposal_[_whatProposal].msgData);
1004     }
1005 
1006     // returns number of signers for any given function
1007     function checkCount (Data storage self, bytes32 _whatFunction)
1008     internal
1009     view
1010     returns (uint256 signature_count)
1011     {
1012         bytes32 _whatProposal = whatProposal(_whatFunction);
1013         return (self.proposal_[_whatProposal].count);
1014     }
1015 
1016     // returns address of an admin who signed for any given function
1017     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1018     internal
1019     view
1020     returns (address signer)
1021     {
1022         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1023         bytes32 _whatProposal = whatProposal(_whatFunction);
1024         return (self.proposal_[_whatProposal].log[_signer - 1]);
1025     }
1026 }