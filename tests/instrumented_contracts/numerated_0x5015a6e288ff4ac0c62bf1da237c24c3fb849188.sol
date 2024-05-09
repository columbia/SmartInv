1 pragma solidity ^0.4.24;
2 /*
3  * -PlayerBook - v0.3.14
4  */
5 interface PlayerBookReceiverInterface {
6     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
7     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
8 }
9 
10 
11 contract PlayerBook {
12     using NameFilter for string;
13     using SafeMath for uint256;
14 
15     address private admin = msg.sender;
16 //==============================================================================
17 //     _| _ _|_ _    _ _ _|_    _   .
18 //    (_|(_| | (_|  _\(/_ | |_||_)  .
19 //=============================|================================================
20     uint256 public registrationFee_ = 10 finney;            // price to register a name
21     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
22     mapping(address => bytes32) public gameNames_;          // lookup a games name
23     mapping(address => uint256) public gameIDs_;            // lokup a games ID
24     uint256 public gID_;        // total number of games
25     uint256 public pID_;        // total number of players
26     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
27     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
28     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
29     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
30     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
31     struct Player {
32         address addr;
33         bytes32 name;
34         uint256 laff;
35         uint256 names;
36     }
37 //==============================================================================
38 //     _ _  _  __|_ _    __|_ _  _  .
39 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
40 //==============================================================================
41     constructor()
42         public
43     {
44         // premine the dev names (sorry not sorry)
45         // No keys are purchased with this method, it's simply locking our addresses,
46         // PID's and names for referral codes.
47         plyr_[1].addr = 0x10719b75B0EBe216575FFcE40A1E47aeBf0b5Fb8;
48         plyr_[1].name = "zhangsan";
49         plyr_[1].names = 1;
50         plyr_[1].laff = 0;
51         pIDxAddr_[0x10719b75B0EBe216575FFcE40A1E47aeBf0b5Fb8] = 1;
52         pIDxName_["zhangsan"] = 1;
53         plyrNames_[1]["zhangsan"] = true;
54         plyrNameList_[1][1] = "zhangsan";
55 
56         plyr_[2].addr = 0x6B6D054b9235b2e1c20DdC324Da36A0e9E0f36d3;
57         plyr_[2].name = "lisi";
58         plyr_[2].names = 1;
59         plyr_[2].laff = 0;
60         pIDxAddr_[0x6B6D054b9235b2e1c20DdC324Da36A0e9E0f36d3] = 2;
61         pIDxName_["lisi"] = 2;
62         plyrNames_[2]["lisi"] = true;
63         plyrNameList_[2][1] = "lisi";
64 
65         plyr_[3].addr = 0x3d53B536f883c3E6660244F78341F64330345Fa4;
66         plyr_[3].name = "wanger";
67         plyr_[3].names = 1;
68         plyr_[3].laff = 2;
69         pIDxAddr_[0x3d53B536f883c3E6660244F78341F64330345Fa4] = 3;
70         pIDxName_["wanger"] = 3;
71         plyrNames_[3]["wanger"] = true;
72         plyrNameList_[3][1] = "wanger";
73 
74         plyr_[4].addr = 0x812f76D5337307990c14A4A78cb5faEa561FE713;
75         plyr_[4].name = "maliu";
76         plyr_[4].names = 1;
77         plyr_[4].laff = 3;
78         pIDxAddr_[0x812f76D5337307990c14A4A78cb5faEa561FE713] = 4;
79         pIDxName_["maliu"] = 4;
80         plyrNames_[4]["maliu"] = true;
81         plyrNameList_[4][1] = "maliu";
82 
83         pID_ = 4;
84     }
85 //==============================================================================
86 //     _ _  _  _|. |`. _  _ _  .
87 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
88 //==============================================================================
89     /**
90      * @dev prevents contracts from interacting with fomo3d
91      */
92     modifier isHuman() {
93         address _addr = msg.sender;
94         uint256 _codeLength;
95 
96         assembly {_codeLength := extcodesize(_addr)}
97         require(_codeLength == 0, "sorry humans only");
98         _;
99     }
100 
101     modifier onlyDevs()
102     {
103         require(admin == msg.sender, "msg sender is not a dev");
104         _;
105     }
106 
107     modifier isRegisteredGame()
108     {
109         require(gameIDs_[msg.sender] != 0);
110         _;
111     }
112 //==============================================================================
113 //     _    _  _ _|_ _  .
114 //    (/_\/(/_| | | _\  .
115 //==============================================================================
116     // fired whenever a player registers a name
117     event onNewName
118     (
119         uint256 indexed playerID,
120         address indexed playerAddress,
121         bytes32 indexed playerName,
122         bool isNewPlayer,
123         uint256 affiliateID,
124         address affiliateAddress,
125         bytes32 affiliateName,
126         uint256 amountPaid,
127         uint256 timeStamp
128     );
129 //==============================================================================
130 //     _  _ _|__|_ _  _ _  .
131 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
132 //=====_|=======================================================================
133     function checkIfNameValid(string _nameStr)
134         public
135         view
136         returns(bool)
137     {
138         bytes32 _name = _nameStr.nameFilter();
139         if (pIDxName_[_name] == 0)
140             return (true);
141         else
142             return (false);
143     }
144 //==============================================================================
145 //     _    |_ |. _   |`    _  __|_. _  _  _  .
146 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
147 //====|=========================================================================
148     /**
149      * @dev registers a name.  UI will always display the last name you registered.
150      * but you will still own all previously registered names to use as affiliate
151      * links.
152      * - must pay a registration fee.
153      * - name must be unique
154      * - names will be converted to lowercase
155      * - name cannot start or end with a space
156      * - cannot have more than 1 space in a row
157      * - cannot be only numbers
158      * - cannot start with 0x
159      * - name must be at least 1 char
160      * - max length of 32 characters long
161      * - allowed characters: a-z, 0-9, and space
162      * -functionhash- 0x921dec21 (using ID for affiliate)
163      * -functionhash- 0x3ddd4698 (using address for affiliate)
164      * -functionhash- 0x685ffd83 (using name for affiliate)
165      * @param _nameString players desired name
166      * @param _affCode affiliate ID, address, or name of who refered you
167      * @param _all set to true if you want this to push your info to all games
168      * (this might cost a lot of gas)
169      */
170     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
171         isHuman()
172         public
173         payable
174     {
175         // make sure name fees paid
176         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
177 
178         // filter name + condition checks
179         bytes32 _name = NameFilter.nameFilter(_nameString);
180 
181         // set up address
182         address _addr = msg.sender;
183 
184         // set up our tx event data and determine if player is new or not
185         bool _isNewPlayer = determinePID(_addr);
186 
187         // fetch player id
188         uint256 _pID = pIDxAddr_[_addr];
189 
190         // manage affiliate residuals
191         // if no affiliate code was given, no new affiliate code was given, or the
192         // player tried to use their own pID as an affiliate code, lolz
193         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
194         {
195             // update last affiliate
196             plyr_[_pID].laff = _affCode;
197         } else if (_affCode == _pID) {
198             _affCode = 0;
199         }
200 
201         // register name
202         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
203     }
204 
205     function registerNameXaddr(string _nameString, address _affCode, bool _all)
206         isHuman()
207         public
208         payable
209     {
210         // make sure name fees paid
211         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
212 
213         // filter name + condition checks
214         bytes32 _name = NameFilter.nameFilter(_nameString);
215 
216         // set up address
217         address _addr = msg.sender;
218 
219         // set up our tx event data and determine if player is new or not
220         bool _isNewPlayer = determinePID(_addr);
221 
222         // fetch player id
223         uint256 _pID = pIDxAddr_[_addr];
224 
225         // manage affiliate residuals
226         // if no affiliate code was given or player tried to use their own, lolz
227         uint256 _affID;
228         if (_affCode != address(0) && _affCode != _addr)
229         {
230             // get affiliate ID from aff Code
231             _affID = pIDxAddr_[_affCode];
232 
233             // if affID is not the same as previously stored
234             if (_affID != plyr_[_pID].laff)
235             {
236                 // update last affiliate
237                 plyr_[_pID].laff = _affID;
238             }
239         }
240 
241         // register name
242         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
243     }
244 
245     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
246         isHuman()
247         public
248         payable
249     {
250         // make sure name fees paid
251         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
252 
253         // filter name + condition checks
254         bytes32 _name = NameFilter.nameFilter(_nameString);
255 
256         // set up address
257         address _addr = msg.sender;
258 
259         // set up our tx event data and determine if player is new or not
260         bool _isNewPlayer = determinePID(_addr);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[_addr];
264 
265         // manage affiliate residuals
266         // if no affiliate code was given or player tried to use their own, lolz
267         uint256 _affID;
268         if (_affCode != "" && _affCode != _name)
269         {
270             // get affiliate ID from aff Code
271             _affID = pIDxName_[_affCode];
272 
273             // if affID is not the same as previously stored
274             if (_affID != plyr_[_pID].laff)
275             {
276                 // update last affiliate
277                 plyr_[_pID].laff = _affID;
278             }
279         }
280 
281         // register name
282         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
283     }
284 
285     /**
286      * @dev players, if you registered a profile, before a game was released, or
287      * set the all bool to false when you registered, use this function to push
288      * your profile to a single game.  also, if you've  updated your name, you
289      * can use this to push your name to games of your choosing.
290      * -functionhash- 0x81c5b206
291      * @param _gameID game id
292      */
293     function addMeToGame(uint256 _gameID)
294         isHuman()
295         public
296     {
297         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
298         address _addr = msg.sender;
299         uint256 _pID = pIDxAddr_[_addr];
300         require(_pID != 0, "hey there buddy, you dont even have an account");
301         uint256 _totalNames = plyr_[_pID].names;
302 
303         // add players profile and most recent name
304         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
305 
306         // add list of all names
307         if (_totalNames > 1)
308             for (uint256 ii = 1; ii <= _totalNames; ii++)
309                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
310     }
311 
312     /**
313      * @dev players, use this to push your player profile to all registered games.
314      * -functionhash- 0x0c6940ea
315      */
316     function addMeToAllGames()
317         isHuman()
318         public
319     {
320         address _addr = msg.sender;
321         uint256 _pID = pIDxAddr_[_addr];
322         require(_pID != 0, "hey there buddy, you dont even have an account");
323         uint256 _laff = plyr_[_pID].laff;
324         uint256 _totalNames = plyr_[_pID].names;
325         bytes32 _name = plyr_[_pID].name;
326 
327         for (uint256 i = 1; i <= gID_; i++)
328         {
329             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
330             if (_totalNames > 1)
331                 for (uint256 ii = 1; ii <= _totalNames; ii++)
332                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
333         }
334 
335     }
336 
337     /**
338      * @dev players use this to change back to one of your old names.  tip, you'll
339      * still need to push that info to existing games.
340      * -functionhash- 0xb9291296
341      * @param _nameString the name you want to use
342      */
343     function useMyOldName(string _nameString)
344         isHuman()
345         public
346     {
347         // filter name, and get pID
348         bytes32 _name = _nameString.nameFilter();
349         uint256 _pID = pIDxAddr_[msg.sender];
350 
351         // make sure they own the name
352         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
353 
354         // update their current name
355         plyr_[_pID].name = _name;
356     }
357 
358 //==============================================================================
359 //     _ _  _ _   | _  _ . _  .
360 //    (_(_)| (/_  |(_)(_||(_  .
361 //=====================_|=======================================================
362     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
363         private
364     {
365         // if names already has been used, require that current msg sender owns the name
366         if (pIDxName_[_name] != 0)
367             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
368 
369         // add name to player profile, registry, and name book
370         plyr_[_pID].name = _name;
371         pIDxName_[_name] = _pID;
372         if (plyrNames_[_pID][_name] == false)
373         {
374             plyrNames_[_pID][_name] = true;
375             plyr_[_pID].names++;
376             plyrNameList_[_pID][plyr_[_pID].names] = _name;
377         }
378 
379         // registration fee goes directly to community rewards
380         admin.transfer(address(this).balance);
381 
382         // push player info to games
383         if (_all == true)
384             for (uint256 i = 1; i <= gID_; i++)
385                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
386 
387         // fire event
388         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
389     }
390 //==============================================================================
391 //    _|_ _  _ | _  .
392 //     | (_)(_)|_\  .
393 //==============================================================================
394     function determinePID(address _addr)
395         private
396         returns (bool)
397     {
398         if (pIDxAddr_[_addr] == 0)
399         {
400             pID_++;
401             pIDxAddr_[_addr] = pID_;
402             plyr_[pID_].addr = _addr;
403 
404             // set the new player bool to true
405             return (true);
406         } else {
407             return (false);
408         }
409     }
410 //==============================================================================
411 //   _   _|_ _  _ _  _ |   _ _ || _  .
412 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
413 //==============================================================================
414     function getPlayerID(address _addr)
415         isRegisteredGame()
416         external
417         returns (uint256)
418     {
419         determinePID(_addr);
420         return (pIDxAddr_[_addr]);
421     }
422     function getPlayerName(uint256 _pID)
423         external
424         view
425         returns (bytes32)
426     {
427         return (plyr_[_pID].name);
428     }
429     function getPlayerLAff(uint256 _pID)
430         external
431         view
432         returns (uint256)
433     {
434         return (plyr_[_pID].laff);
435     }
436     function getPlayerAddr(uint256 _pID)
437         external
438         view
439         returns (address)
440     {
441         return (plyr_[_pID].addr);
442     }
443     function getNameFee()
444         external
445         view
446         returns (uint256)
447     {
448         return(registrationFee_);
449     }
450     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
451         isRegisteredGame()
452         external
453         payable
454         returns(bool, uint256)
455     {
456         // make sure name fees paid
457         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
458 
459         // set up our tx event data and determine if player is new or not
460         bool _isNewPlayer = determinePID(_addr);
461 
462         // fetch player id
463         uint256 _pID = pIDxAddr_[_addr];
464 
465         // manage affiliate residuals
466         // if no affiliate code was given, no new affiliate code was given, or the
467         // player tried to use their own pID as an affiliate code, lolz
468         uint256 _affID = _affCode;
469         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
470         {
471             // update last affiliate
472             plyr_[_pID].laff = _affID;
473         } else if (_affID == _pID) {
474             _affID = 0;
475         }
476 
477         // register name
478         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
479 
480         return(_isNewPlayer, _affID);
481     }
482     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
483         isRegisteredGame()
484         external
485         payable
486         returns(bool, uint256)
487     {
488         // make sure name fees paid
489         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
490 
491         // set up our tx event data and determine if player is new or not
492         bool _isNewPlayer = determinePID(_addr);
493 
494         // fetch player id
495         uint256 _pID = pIDxAddr_[_addr];
496 
497         // manage affiliate residuals
498         // if no affiliate code was given or player tried to use their own, lolz
499         uint256 _affID;
500         if (_affCode != address(0) && _affCode != _addr)
501         {
502             // get affiliate ID from aff Code
503             _affID = pIDxAddr_[_affCode];
504 
505             // if affID is not the same as previously stored
506             if (_affID != plyr_[_pID].laff)
507             {
508                 // update last affiliate
509                 plyr_[_pID].laff = _affID;
510             }
511         }
512 
513         // register name
514         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
515 
516         return(_isNewPlayer, _affID);
517     }
518     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
519         isRegisteredGame()
520         external
521         payable
522         returns(bool, uint256)
523     {
524         // make sure name fees paid
525         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
526 
527         // set up our tx event data and determine if player is new or not
528         bool _isNewPlayer = determinePID(_addr);
529 
530         // fetch player id
531         uint256 _pID = pIDxAddr_[_addr];
532 
533         // manage affiliate residuals
534         // if no affiliate code was given or player tried to use their own, lolz
535         uint256 _affID;
536         if (_affCode != "" && _affCode != _name)
537         {
538             // get affiliate ID from aff Code
539             _affID = pIDxName_[_affCode];
540 
541             // if affID is not the same as previously stored
542             if (_affID != plyr_[_pID].laff)
543             {
544                 // update last affiliate
545                 plyr_[_pID].laff = _affID;
546             }
547         }
548 
549         // register name
550         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
551 
552         return(_isNewPlayer, _affID);
553     }
554 
555 //==============================================================================
556 //   _ _ _|_    _   .
557 //  _\(/_ | |_||_)  .
558 //=============|================================================================
559     function addGame(address _gameAddress, string _gameNameStr)
560         onlyDevs()
561         public
562     {
563         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
564             gID_++;
565             bytes32 _name = _gameNameStr.nameFilter();
566             gameIDs_[_gameAddress] = gID_;
567             gameNames_[_gameAddress] = _name;
568             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
569 
570             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
571             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
572             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
573             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
574     }
575 
576     function setRegistrationFee(uint256 _fee)
577         onlyDevs()
578         public
579     {
580       registrationFee_ = _fee;
581     }
582 
583 }
584 
585 /**
586 * @title -Name Filter- v0.1.9
587 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
588 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
589 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
590 *                                  _____                      _____
591 *                                 (, /     /)       /) /)    (, /      /)          /)
592 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
593 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
594 *          ┴ ┴                /   /          .-/ _____   (__ /
595 *                            (__ /          (_/ (, /                                      /)™
596 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
597 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
598 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
599 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
600 *              _       __    _      ____      ____  _   _    _____  ____  ___
601 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
602 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
603 *
604 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
605 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
606 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
607 */
608 library NameFilter {
609 
610     /**
611      * @dev filters name strings
612      * -converts uppercase to lower case.
613      * -makes sure it does not start/end with a space
614      * -makes sure it does not contain multiple spaces in a row
615      * -cannot be only numbers
616      * -cannot start with 0x
617      * -restricts characters to A-Z, a-z, 0-9, and space.
618      * @return reprocessed string in bytes32 format
619      */
620     function nameFilter(string _input)
621         internal
622         pure
623         returns(bytes32)
624     {
625         bytes memory _temp = bytes(_input);
626         uint256 _length = _temp.length;
627 
628         //sorry limited to 32 characters
629         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
630         // make sure it doesnt start with or end with space
631         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
632         // make sure first two characters are not 0x
633         if (_temp[0] == 0x30)
634         {
635             require(_temp[1] != 0x78, "string cannot start with 0x");
636             require(_temp[1] != 0x58, "string cannot start with 0X");
637         }
638 
639         // create a bool to track if we have a non number character
640         bool _hasNonNumber;
641 
642         // convert & check
643         for (uint256 i = 0; i < _length; i++)
644         {
645             // if its uppercase A-Z
646             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
647             {
648                 // convert to lower case a-z
649                 _temp[i] = byte(uint(_temp[i]) + 32);
650 
651                 // we have a non number
652                 if (_hasNonNumber == false)
653                     _hasNonNumber = true;
654             } else {
655                 require
656                 (
657                     // require character is a space
658                     _temp[i] == 0x20 ||
659                     // OR lowercase a-z
660                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
661                     // or 0-9
662                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
663                     "string contains invalid characters"
664                 );
665                 // make sure theres not 2x spaces in a row
666                 if (_temp[i] == 0x20)
667                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
668 
669                 // see if we have a character other than a number
670                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
671                     _hasNonNumber = true;
672             }
673         }
674 
675         require(_hasNonNumber == true, "string cannot be only numbers");
676 
677         bytes32 _ret;
678         assembly {
679             _ret := mload(add(_temp, 32))
680         }
681         return (_ret);
682     }
683 }
684 
685 /**
686  * @title SafeMath v0.1.9
687  * @dev Math operations with safety checks that throw on error
688  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
689  * - added sqrt
690  * - added sq
691  * - added pwr
692  * - changed asserts to requires with error log outputs
693  * - removed div, its useless
694  */
695 library SafeMath {
696 
697     /**
698     * @dev Multiplies two numbers, throws on overflow.
699     */
700     function mul(uint256 a, uint256 b)
701         internal
702         pure
703         returns (uint256 c)
704     {
705         if (a == 0) {
706             return 0;
707         }
708         c = a * b;
709         require(c / a == b, "SafeMath mul failed");
710         return c;
711     }
712 
713     /**
714     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
715     */
716     function sub(uint256 a, uint256 b)
717         internal
718         pure
719         returns (uint256)
720     {
721         require(b <= a, "SafeMath sub failed");
722         return a - b;
723     }
724 
725     /**
726     * @dev Adds two numbers, throws on overflow.
727     */
728     function add(uint256 a, uint256 b)
729         internal
730         pure
731         returns (uint256 c)
732     {
733         c = a + b;
734         require(c >= a, "SafeMath add failed");
735         return c;
736     }
737 
738     /**
739      * @dev gives square root of given x.
740      */
741     function sqrt(uint256 x)
742         internal
743         pure
744         returns (uint256 y)
745     {
746         uint256 z = ((add(x,1)) / 2);
747         y = x;
748         while (z < y)
749         {
750             y = z;
751             z = ((add((x / z),z)) / 2);
752         }
753     }
754 
755     /**
756      * @dev gives square. multiplies x by x
757      */
758     function sq(uint256 x)
759         internal
760         pure
761         returns (uint256)
762     {
763         return (mul(x,x));
764     }
765 
766     /**
767      * @dev x to the power of y
768      */
769     function pwr(uint256 x, uint256 y)
770         internal
771         pure
772         returns (uint256)
773     {
774         if (x==0)
775             return (0);
776         else if (y==0)
777             return (1);
778         else
779         {
780             uint256 z = x;
781             for (uint256 i=1; i < y; i++)
782                 z = mul(z,x);
783             return (z);
784         }
785     }
786 }