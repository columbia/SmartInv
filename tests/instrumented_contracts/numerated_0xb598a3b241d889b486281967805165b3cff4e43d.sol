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
13     address private communityAddr = 0xf38ce89f0e7c0057fce8dc1e8dcbb36a2366e8c5;
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
40     public
41     {
42         // premine the dev names (sorry not sorry)
43         // No keys are purchased with this method, it's simply locking our addresses,
44         // PID's and names for referral codes.
45         plyr_[1].addr = 0xde38b17d669a1ca474f9adb4ca3c816e79275567;
46         plyr_[1].name = "plyr1";
47         plyr_[1].names = 1;
48         pIDxAddr_[0xde38b17d669a1ca474f9adb4ca3c816e79275567] = 1;
49         pIDxName_["plyr1"] = 1;
50         plyrNames_[1]["plyr1"] = true;
51         plyrNameList_[1][1] = "plyr1";
52 
53         plyr_[2].addr = 0x0fa923b59b06b757f37ddd36d6862ebb37733faa;
54         plyr_[2].name = "plyr2";
55         plyr_[2].names = 1;
56         pIDxAddr_[0x0fa923b59b06b757f37ddd36d6862ebb37733faa] = 2;
57         pIDxName_["plyr2"] = 2;
58         plyrNames_[2]["plyr2"] = true;
59         plyrNameList_[2][1] = "plyr2";
60 
61         pID_ = 2;
62     }
63 //==============================================================================
64 //     _ _  _  _|. |`. _  _ _  .
65 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
66 //==============================================================================    
67     /**
68      * @dev prevents contracts from interacting with fomo3d
69      */
70     modifier isHuman() {
71         address _addr = msg.sender;
72         uint256 _codeLength;
73 
74         assembly {_codeLength := extcodesize(_addr)}
75         require(_codeLength == 0, "sorry humans only");
76         _;
77     }
78 
79     modifier onlyCommunity()
80     {
81         require(msg.sender == communityAddr, "msg sender is not the community");
82         _;
83     }
84 
85     modifier isRegisteredGame()
86     {
87         require(gameIDs_[msg.sender] != 0);
88         _;
89     }
90 //==============================================================================
91 //     _    _  _ _|_ _  .
92 //    (/_\/(/_| | | _\  .
93 //==============================================================================    
94     // fired whenever a player registers a name
95     event onNewName
96     (
97         uint256 indexed playerID,
98         address indexed playerAddress,
99         bytes32 indexed playerName,
100         bool isNewPlayer,
101         uint256 affiliateID,
102         address affiliateAddress,
103         bytes32 affiliateName,
104         uint256 amountPaid,
105         uint256 timeStamp
106 );
107 //==============================================================================
108 //     _  _ _|__|_ _  _ _  .
109 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
110 //=====_|=======================================================================
111     function checkIfNameValid(string _nameStr)
112     public
113     view
114     returns(bool)
115     {
116         bytes32 _name = _nameStr.nameFilter();
117         if (pIDxName_[_name] == 0)
118             return (true);
119         else
120             return (false);
121     }
122 //==============================================================================
123 //     _    |_ |. _   |`    _  __|_. _  _  _  .
124 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
125 //====|=========================================================================    
126     /**
127      * @dev registers a name.  UI will always display the last name you registered.
128      * but you will still own all previously registered names to use as affiliate
129      * links.
130      * - must pay a registration fee.
131      * - name must be unique
132      * - names will be converted to lowercase
133      * - name cannot start or end with a space
134      * - cannot have more than 1 space in a row
135      * - cannot be only numbers
136      * - cannot start with 0x
137      * - name must be at least 1 char
138      * - max length of 32 characters long
139      * - allowed characters: a-z, 0-9, and space
140      * -functionhash- 0x921dec21 (using ID for affiliate)
141      * -functionhash- 0x3ddd4698 (using address for affiliate)
142      * -functionhash- 0x685ffd83 (using name for affiliate)
143      * @param _nameString players desired name
144      * @param _affCode affiliate ID, address, or name of who refered you
145      * @param _all set to true if you want this to push your info to all games
146      * (this might cost a lot of gas)
147      */
148     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
149     isHuman()
150     public
151     payable
152     {
153         // make sure name fees paid
154         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
155 
156         // filter name + condition checks
157         bytes32 _name = NameFilter.nameFilter(_nameString);
158 
159         // set up address 
160         address _addr = msg.sender;
161 
162         // set up our tx event data and determine if player is new or not
163         bool _isNewPlayer = determinePID(_addr);
164 
165         // fetch player id
166         uint256 _pID = pIDxAddr_[_addr];
167 
168         // manage affiliate residuals
169         // if no affiliate code was given, no new affiliate code was given, or the 
170         // player tried to use their own pID as an affiliate code, lolz
171         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
172         {
173             // update last affiliate 
174             plyr_[_pID].laff = _affCode;
175         } else if (_affCode == _pID) {
176             _affCode = 0;
177         }
178 
179         // register name 
180         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
181     }
182 
183     function registerNameXaddr(string _nameString, address _affCode, bool _all)
184     isHuman()
185     public
186     payable
187     {
188         // make sure name fees paid
189         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
190 
191         // filter name + condition checks
192         bytes32 _name = NameFilter.nameFilter(_nameString);
193 
194         // set up address 
195         address _addr = msg.sender;
196 
197         // set up our tx event data and determine if player is new or not
198         bool _isNewPlayer = determinePID(_addr);
199 
200         // fetch player id
201         uint256 _pID = pIDxAddr_[_addr];
202 
203         // manage affiliate residuals
204         // if no affiliate code was given or player tried to use their own, lolz
205         uint256 _affID;
206         if (_affCode != address(0) && _affCode != _addr)
207         {
208             // get affiliate ID from aff Code 
209             _affID = pIDxAddr_[_affCode];
210 
211             // if affID is not the same as previously stored 
212             if (_affID != plyr_[_pID].laff)
213             {
214                 // update last affiliate
215                 plyr_[_pID].laff = _affID;
216             }
217         }
218 
219         // register name 
220         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
221     }
222 
223     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
224     isHuman()
225     public
226     payable
227     {
228         // make sure name fees paid
229         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
230 
231         // filter name + condition checks
232         bytes32 _name = NameFilter.nameFilter(_nameString);
233 
234         // set up address 
235         address _addr = msg.sender;
236 
237         // set up our tx event data and determine if player is new or not
238         bool _isNewPlayer = determinePID(_addr);
239 
240         // fetch player id
241         uint256 _pID = pIDxAddr_[_addr];
242 
243         // manage affiliate residuals
244         // if no affiliate code was given or player tried to use their own, lolz
245         uint256 _affID;
246         if (_affCode != "" && _affCode != _name)
247         {
248             // get affiliate ID from aff Code 
249             _affID = pIDxName_[_affCode];
250 
251             // if affID is not the same as previously stored 
252             if (_affID != plyr_[_pID].laff)
253             {
254                 // update last affiliate
255                 plyr_[_pID].laff = _affID;
256             }
257         }
258 
259         // register name 
260         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
261     }
262 
263     /**
264      * @dev players, if you registered a profile, before a game was released, or
265      * set the all bool to false when you registered, use this function to push
266      * your profile to a single game.  also, if you've  updated your name, you
267      * can use this to push your name to games of your choosing.
268      * -functionhash- 0x81c5b206
269      * @param _gameID game id
270      */
271     function addMeToGame(uint256 _gameID)
272     isHuman()
273     public
274     {
275         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
276         address _addr = msg.sender;
277         uint256 _pID = pIDxAddr_[_addr];
278         require(_pID != 0, "hey there buddy, you dont even have an account");
279         uint256 _totalNames = plyr_[_pID].names;
280 
281         // add players profile and most recent name
282         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
283 
284         // add list of all names
285         if (_totalNames > 1)
286             for (uint256 ii = 1; ii <= _totalNames; ii++)
287         games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
288     }
289 
290     /**
291      * @dev players, use this to push your player profile to all registered games.
292      * -functionhash- 0x0c6940ea
293      */
294     function addMeToAllGames()
295     isHuman()
296     public
297     {
298         address _addr = msg.sender;
299         uint256 _pID = pIDxAddr_[_addr];
300         require(_pID != 0, "hey there buddy, you dont even have an account");
301         uint256 _laff = plyr_[_pID].laff;
302         uint256 _totalNames = plyr_[_pID].names;
303         bytes32 _name = plyr_[_pID].name;
304 
305         for (uint256 i = 1; i <= gID_; i++)
306         {
307             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
308             if (_totalNames > 1)
309                 for (uint256 ii = 1; ii <= _totalNames; ii++)
310             games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
311         }
312 
313     }
314 
315     /**
316      * @dev players use this to change back to one of your old names.  tip, you'll
317      * still need to push that info to existing games.
318      * -functionhash- 0xb9291296
319      * @param _nameString the name you want to use
320      */
321     function useMyOldName(string _nameString)
322     isHuman()
323     public
324     {
325         // filter name, and get pID
326         bytes32 _name = _nameString.nameFilter();
327         uint256 _pID = pIDxAddr_[msg.sender];
328 
329         // make sure they own the name 
330         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
331 
332         // update their current name 
333         plyr_[_pID].name = _name;
334     }
335 
336 //==============================================================================
337 //     _ _  _ _   | _  _ . _  .
338 //    (_(_)| (/_  |(_)(_||(_  . 
339 //=====================_|=======================================================    
340     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
341     private
342     {
343         // if names already has been used, require that current msg sender owns the name
344         if (pIDxName_[_name] != 0)
345             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
346 
347         // add name to player profile, registry, and name book
348         plyr_[_pID].name = _name;
349         pIDxName_[_name] = _pID;
350         if (plyrNames_[_pID][_name] == false)
351         {
352             plyrNames_[_pID][_name] = true;
353             plyr_[_pID].names++;
354             plyrNameList_[_pID][plyr_[_pID].names] = _name;
355         }
356 
357         // registration fee goes directly to community rewards
358         communityAddr.transfer(address(this).balance);
359 
360         // push player info to games
361         if (_all == true)
362             for (uint256 i = 1; i <= gID_; i++)
363         games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
364 
365         // fire event
366         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
367     }
368 //==============================================================================
369 //    _|_ _  _ | _  .
370 //     | (_)(_)|_\  .
371 //==============================================================================    
372     function determinePID(address _addr)
373     private
374     returns (bool)
375     {
376         if (pIDxAddr_[_addr] == 0)
377         {
378             pID_++;
379             pIDxAddr_[_addr] = pID_;
380             plyr_[pID_].addr = _addr;
381 
382             // set the new player bool to true
383             return (true);
384         } else {
385             return (false);
386         }
387     }
388 //==============================================================================
389 //   _   _|_ _  _ _  _ |   _ _ || _  .
390 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
391 //==============================================================================
392     function getPlayerID(address _addr)
393     isRegisteredGame()
394     external
395     returns (uint256)
396     {
397         determinePID(_addr);
398         return (pIDxAddr_[_addr]);
399     }
400     function getPlayerName(uint256 _pID)
401     external
402     view
403     returns (bytes32)
404     {
405         return (plyr_[_pID].name);
406     }
407     function getPlayerLAff(uint256 _pID)
408     external
409     view
410     returns (uint256)
411     {
412         return (plyr_[_pID].laff);
413     }
414     function getPlayerAddr(uint256 _pID)
415     external
416     view
417     returns (address)
418     {
419         return (plyr_[_pID].addr);
420     }
421     function getNameFee()
422     external
423     view
424     returns (uint256)
425     {
426         return(registrationFee_);
427     }
428     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
429     isRegisteredGame()
430     external
431     payable
432     returns(bool, uint256)
433     {
434         // make sure name fees paid
435         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
436 
437         // set up our tx event data and determine if player is new or not
438         bool _isNewPlayer = determinePID(_addr);
439 
440         // fetch player id
441         uint256 _pID = pIDxAddr_[_addr];
442 
443         // manage affiliate residuals
444         // if no affiliate code was given, no new affiliate code was given, or the 
445         // player tried to use their own pID as an affiliate code, lolz
446         uint256 _affID = _affCode;
447         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
448         {
449             // update last affiliate 
450             plyr_[_pID].laff = _affID;
451         } else if (_affID == _pID) {
452             _affID = 0;
453         }
454 
455         // register name 
456         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
457 
458         return(_isNewPlayer, _affID);
459     }
460     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
461     isRegisteredGame()
462     external
463     payable
464     returns(bool, uint256)
465     {
466         // make sure name fees paid
467         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
468 
469         // set up our tx event data and determine if player is new or not
470         bool _isNewPlayer = determinePID(_addr);
471 
472         // fetch player id
473         uint256 _pID = pIDxAddr_[_addr];
474 
475         // manage affiliate residuals
476         // if no affiliate code was given or player tried to use their own, lolz
477         uint256 _affID;
478         if (_affCode != address(0) && _affCode != _addr)
479         {
480             // get affiliate ID from aff Code 
481             _affID = pIDxAddr_[_affCode];
482 
483             // if affID is not the same as previously stored 
484             if (_affID != plyr_[_pID].laff)
485             {
486                 // update last affiliate
487                 plyr_[_pID].laff = _affID;
488             }
489         }
490 
491         // register name 
492         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
493 
494         return(_isNewPlayer, _affID);
495     }
496     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
497     isRegisteredGame()
498     external
499     payable
500     returns(bool, uint256)
501     {
502         // make sure name fees paid
503         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
504 
505         // set up our tx event data and determine if player is new or not
506         bool _isNewPlayer = determinePID(_addr);
507 
508         // fetch player id
509         uint256 _pID = pIDxAddr_[_addr];
510 
511         // manage affiliate residuals
512         // if no affiliate code was given or player tried to use their own, lolz
513         uint256 _affID;
514         if (_affCode != "" && _affCode != _name)
515         {
516             // get affiliate ID from aff Code 
517             _affID = pIDxName_[_affCode];
518 
519             // if affID is not the same as previously stored 
520             if (_affID != plyr_[_pID].laff)
521             {
522                 // update last affiliate
523                 plyr_[_pID].laff = _affID;
524             }
525         }
526 
527         // register name 
528         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
529 
530         return(_isNewPlayer, _affID);
531     }
532 
533 //==============================================================================
534 //   _ _ _|_    _   .
535 //  _\(/_ | |_||_)  .
536 //=============|================================================================
537     function addGame(address _gameAddress, string _gameNameStr)
538     onlyCommunity()
539     public
540     {
541         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
542 
543         gID_++;
544         bytes32 _name = _gameNameStr.nameFilter();
545         gameIDs_[_gameAddress] = gID_;
546         gameNames_[_gameAddress] = _name;
547         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
548 
549         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
550         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
551         games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
552         games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
553     }
554 
555     function setRegistrationFee(uint256 _fee)
556     onlyCommunity()
557     public
558     {
559         registrationFee_ = _fee;
560     }
561 
562 }
563 
564 /**
565  * @title -Name Filter- v0.1.9
566  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
567  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
568  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
569  *                                  _____                      _____
570  *                                 (, /     /)       /) /)    (, /      /)          /)
571  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
572  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
573  *          ┴ ┴                /   /          .-/ _____   (__ /
574  *                            (__ /          (_/ (, /                                      /)™
575  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
576  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
577  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
578  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
579  *              _       __    _      ____      ____  _   _    _____  ____  ___
580  *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
581  *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
582  *
583  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
584  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dddos │
585  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
586  */
587 library NameFilter {
588 
589     /**
590      * @dev filters name strings
591      * -converts uppercase to lower case.
592      * -makes sure it does not start/end with a space
593      * -makes sure it does not contain multiple spaces in a row
594      * -cannot be only numbers
595      * -cannot start with 0x
596      * -restricts characters to A-Z, a-z, 0-9, and space.
597      * @return reprocessed string in bytes32 format
598      */
599     function nameFilter(string _input)
600     internal
601     pure
602     returns(bytes32)
603     {
604         bytes memory _temp = bytes(_input);
605         uint256 _length = _temp.length;
606 
607         //sorry limited to 32 characters
608         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
609         // make sure it doesnt start with or end with space
610         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
611         // make sure first two characters are not 0x
612         if (_temp[0] == 0x30)
613         {
614             require(_temp[1] != 0x78, "string cannot start with 0x");
615             require(_temp[1] != 0x58, "string cannot start with 0X");
616         }
617 
618         // create a bool to track if we have a non number character
619         bool _hasNonNumber;
620 
621         // convert & check
622         for (uint256 i = 0; i < _length; i++)
623         {
624             // if its uppercase A-Z
625             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
626             {
627                 // convert to lower case a-z
628                 _temp[i] = byte(uint(_temp[i]) + 32);
629 
630                 // we have a non number
631                 if (_hasNonNumber == false)
632                     _hasNonNumber = true;
633             } else {
634                 require
635                 (
636                     // require character is a space
637                     _temp[i] == 0x20 ||
638                     // OR lowercase a-z
639                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
640                     // or 0-9
641                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
642                     "string contains invalid characters"
643                 );
644                 // make sure theres not 2x spaces in a row
645                 if (_temp[i] == 0x20)
646                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
647 
648                 // see if we have a character other than a number
649                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
650                     _hasNonNumber = true;
651             }
652         }
653 
654         require(_hasNonNumber == true, "string cannot be only numbers");
655 
656         bytes32 _ret;
657         assembly {
658         _ret := mload(add(_temp, 32))
659     }
660         return (_ret);
661     }
662 }
663 
664 /**
665  * @title SafeMath v0.1.9
666  * @dev Math operations with safety checks that throw on error
667  * change notes:  original SafeMath library from OpenZeppelin modified by dddos
668  * - added sqrt
669  * - added sq
670  * - added pwr
671  * - changed asserts to requires with error log outputs
672  * - removed div, its useless
673  */
674 library SafeMath {
675 
676     /**
677      * @dev Multiplies two numbers, throws on overflow.
678      */
679     function mul(uint256 a, uint256 b)
680     internal
681     pure
682     returns (uint256 c)
683     {
684         if (a == 0) {
685             return 0;
686         }
687         c = a * b;
688         require(c / a == b, "SafeMath mul failed");
689         return c;
690     }
691 
692     /**
693      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
694      */
695     function sub(uint256 a, uint256 b)
696     internal
697     pure
698     returns (uint256)
699     {
700         require(b <= a, "SafeMath sub failed");
701         return a - b;
702     }
703 
704     /**
705      * @dev Adds two numbers, throws on overflow.
706      */
707     function add(uint256 a, uint256 b)
708     internal
709     pure
710     returns (uint256 c)
711     {
712         c = a + b;
713         require(c >= a, "SafeMath add failed");
714         return c;
715     }
716 
717     /**
718      * @dev gives square root of given x.
719      */
720     function sqrt(uint256 x)
721     internal
722     pure
723     returns (uint256 y)
724     {
725         uint256 z = ((add(x,1)) / 2);
726         y = x;
727         while (z < y)
728         {
729             y = z;
730             z = ((add((x / z),z)) / 2);
731         }
732     }
733 
734     /**
735      * @dev gives square. multiplies x by x
736      */
737     function sq(uint256 x)
738     internal
739     pure
740     returns (uint256)
741     {
742         return (mul(x,x));
743     }
744 
745     /**
746      * @dev x to the power of y
747      */
748     function pwr(uint256 x, uint256 y)
749     internal
750     pure
751     returns (uint256)
752     {
753         if (x==0)
754             return (0);
755         else if (y==0)
756             return (1);
757         else
758         {
759             uint256 z = x;
760             for (uint256 i=1; i < y; i++)
761             z = mul(z,x);
762             return (z);
763         }
764     }
765 }