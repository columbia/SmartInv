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
50         plyr_[1].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
51         plyr_[1].name = "justo";
52         plyr_[1].names = 1;
53         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 1;
54         pIDxName_["justo"] = 1;
55         plyrNames_[1]["justo"] = true;
56         plyrNameList_[1][1] = "justo";
57 
58         plyr_[2].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
59         plyr_[2].name = "mantso";
60         plyr_[2].names = 1;
61         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 2;
62         pIDxName_["mantso"] = 2;
63         plyrNames_[2]["mantso"] = true;
64         plyrNameList_[2][1] = "mantso";
65 
66         plyr_[3].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
67         plyr_[3].name = "sumpunk";
68         plyr_[3].names = 1;
69         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 3;
70         pIDxName_["sumpunk"] = 3;
71         plyrNames_[3]["sumpunk"] = true;
72         plyrNameList_[3][1] = "sumpunk";
73 
74         plyr_[4].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
75         plyr_[4].name = "inventor";
76         plyr_[4].names = 1;
77         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 4;
78         pIDxName_["inventor"] = 4;
79         plyrNames_[4]["inventor"] = true;
80         plyrNameList_[4][1] = "inventor";
81 
82         //Total number of players
83         pID_ = 4;
84     }
85 //==============================================================================
86 //     _ _  _  _|. |`. _  _ _  .
87 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
88 //==============================================================================
89     /**
90      * @dev prevents contracts from interacting with fomo3d 解读: 判断是否是合约
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
101 
102     modifier isRegisteredGame()
103     {
104         require(gameIDs_[msg.sender] != 0);
105         _;
106     }
107 //==============================================================================
108 //     _    _  _ _|_ _  .
109 //    (/_\/(/_| | | _\  .
110 //==============================================================================
111     // fired whenever a player registers a name
112     event onNewName
113     (
114         uint256 indexed playerID,
115         address indexed playerAddress,
116         bytes32 indexed playerName,
117         bool isNewPlayer,
118         uint256 affiliateID,
119         address affiliateAddress,
120         bytes32 affiliateName,
121         uint256 amountPaid,
122         uint256 timeStamp
123     );
124 //==============================================================================
125 //     _  _ _|__|_ _  _ _  .
126 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
127 //=====_|=======================================================================
128     function checkIfNameValid(string _nameStr)
129         public
130         view
131         returns(bool)
132     {
133         bytes32 _name = _nameStr.nameFilter();
134         if (pIDxName_[_name] == 0)
135             return (true);
136         else
137             return (false);
138     }
139 //==============================================================================
140 //     _    |_ |. _   |`    _  __|_. _  _  _  .
141 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
142 //====|=========================================================================
143     /**
144      * @dev registers a name.  UI will always display the last name you registered.
145      * but you will still own all previously registered names to use as affiliate
146      * links.
147      * - must pay a registration fee.
148      * - name must be unique
149      * - names will be converted to lowercase
150      * - name cannot start or end with a space
151      * - cannot have more than 1 space in a row
152      * - cannot be only numbers
153      * - cannot start with 0x
154      * - name must be at least 1 char
155      * - max length of 32 characters long
156      * - allowed characters: a-z, 0-9, and space
157      * -functionhash- 0x921dec21 (using ID for affiliate)
158      * -functionhash- 0x3ddd4698 (using address for affiliate)
159      * -functionhash- 0x685ffd83 (using name for affiliate)
160      * @param _nameString players desired name
161      * @param _affCode affiliate ID, address, or name of who refered you
162      * @param _all set to true if you want this to push your info to all games
163      * (this might cost a lot of gas)
164      */
165     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
166         isHuman()
167         public
168         payable
169     {
170         // make sure name fees paid
171         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
172 
173         // filter name + condition checks
174         bytes32 _name = NameFilter.nameFilter(_nameString);
175 
176         // set up address
177         address _addr = msg.sender;
178 
179         // set up our tx event data and determine if player is new or not
180         bool _isNewPlayer = determinePID(_addr);
181 
182         // fetch player id
183         uint256 _pID = pIDxAddr_[_addr];
184 
185         // manage affiliate residuals
186         // if no affiliate code was given, no new affiliate code was given, or the
187         // player tried to use their own pID as an affiliate code, lolz
188         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
189         {
190             // update last affiliate
191             plyr_[_pID].laff = _affCode;
192         } else if (_affCode == _pID) {
193             _affCode = 0;
194         }
195 
196         // register name
197         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
198     }
199 
200     function registerNameXaddr(string _nameString, address _affCode, bool _all)
201         isHuman()
202         public
203         payable
204     {
205         // make sure name fees paid
206         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
207 
208         // filter name + condition checks
209         bytes32 _name = NameFilter.nameFilter(_nameString);
210 
211         // set up address
212         address _addr = msg.sender;
213 
214         // set up our tx event data and determine if player is new or not
215         bool _isNewPlayer = determinePID(_addr);
216 
217         // fetch player id
218         uint256 _pID = pIDxAddr_[_addr];
219 
220         // manage affiliate residuals
221         // if no affiliate code was given or player tried to use their own, lolz
222         uint256 _affID;
223         if (_affCode != address(0) && _affCode != _addr)
224         {
225             // get affiliate ID from aff Code
226             _affID = pIDxAddr_[_affCode];
227 
228             // if affID is not the same as previously stored
229             if (_affID != plyr_[_pID].laff)
230             {
231                 // update last affiliate
232                 plyr_[_pID].laff = _affID;
233             }
234         }
235 
236         // register name
237         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
238     }
239 
240     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
241         isHuman()
242         public
243         payable
244     {
245         // make sure name fees paid
246         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
247 
248         // filter name + condition checks
249         bytes32 _name = NameFilter.nameFilter(_nameString);
250 
251         // set up address
252         address _addr = msg.sender;
253 
254         // set up our tx event data and determine if player is new or not
255         bool _isNewPlayer = determinePID(_addr);
256 
257         // fetch player id
258         uint256 _pID = pIDxAddr_[_addr];
259 
260         // manage affiliate residuals
261         // if no affiliate code was given or player tried to use their own, lolz
262         uint256 _affID;
263         if (_affCode != "" && _affCode != _name)
264         {
265             // get affiliate ID from aff Code
266             _affID = pIDxName_[_affCode];
267 
268             // if affID is not the same as previously stored
269             if (_affID != plyr_[_pID].laff)
270             {
271                 // update last affiliate
272                 plyr_[_pID].laff = _affID;
273             }
274         }
275 
276         // register name
277         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
278     }
279 
280     /**
281      * @dev players, if you registered a profile, before a game was released, or
282      * set the all bool to false when you registered, use this function to push
283      * your profile to a single game.  also, if you've  updated your name, you
284      * can use this to push your name to games of your choosing.
285      * -functionhash- 0x81c5b206
286      * @param _gameID game id
287      */
288     function addMeToGame(uint256 _gameID)
289         isHuman()
290         public
291     {
292         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
293         address _addr = msg.sender;
294         uint256 _pID = pIDxAddr_[_addr];
295         require(_pID != 0, "hey there buddy, you dont even have an account");
296         uint256 _totalNames = plyr_[_pID].names;
297 
298         // add players profile and most recent name
299         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
300 
301         // add list of all names
302         if (_totalNames > 1)
303             for (uint256 ii = 1; ii <= _totalNames; ii++)
304                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
305     }
306 
307     /**
308      * @dev players, use this to push your player profile to all registered games.
309      * -functionhash- 0x0c6940ea
310      */
311     function addMeToAllGames()
312         isHuman()
313         public
314     {
315         address _addr = msg.sender;
316         uint256 _pID = pIDxAddr_[_addr];
317         require(_pID != 0, "hey there buddy, you dont even have an account");
318         uint256 _laff = plyr_[_pID].laff;
319         uint256 _totalNames = plyr_[_pID].names;
320         bytes32 _name = plyr_[_pID].name;
321 
322         for (uint256 i = 1; i <= gID_; i++)
323         {
324             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
325             if (_totalNames > 1)
326                 for (uint256 ii = 1; ii <= _totalNames; ii++)
327                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
328         }
329 
330     }
331 
332     /**
333      * @dev players use this to change back to one of your old names.  tip, you'll
334      * still need to push that info to existing games.
335      * -functionhash- 0xb9291296
336      * @param _nameString the name you want to use
337      */
338     function useMyOldName(string _nameString)
339         isHuman()
340         public
341     {
342         // filter name, and get pID
343         bytes32 _name = _nameString.nameFilter();
344         uint256 _pID = pIDxAddr_[msg.sender];
345 
346         // make sure they own the name
347         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
348 
349         // update their current name
350         plyr_[_pID].name = _name;
351     }
352 
353 //==============================================================================
354 //     _ _  _ _   | _  _ . _  .
355 //    (_(_)| (/_  |(_)(_||(_  .
356 //=====================_|=======================================================
357     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
358         private
359     {
360         // if names already has been used, require that current msg sender owns the name
361         if (pIDxName_[_name] != 0)
362             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
363 
364         // add name to player profile, registry, and name book
365         plyr_[_pID].name = _name;
366         pIDxName_[_name] = _pID;
367         if (plyrNames_[_pID][_name] == false)
368         {
369             plyrNames_[_pID][_name] = true;
370             plyr_[_pID].names++;
371             plyrNameList_[_pID][plyr_[_pID].names] = _name;
372         }
373 
374         // registration fee goes directly to community rewards
375         admin.transfer(address(this).balance);
376 
377         // push player info to games
378         if (_all == true)
379             for (uint256 i = 1; i <= gID_; i++)
380                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
381 
382         // fire event
383         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
384     }
385 //==============================================================================
386 //    _|_ _  _ | _  .
387 //     | (_)(_)|_\  .
388 //==============================================================================
389     function determinePID(address _addr)
390         private
391         returns (bool)
392     {
393         if (pIDxAddr_[_addr] == 0)
394         {
395             pID_++;
396             pIDxAddr_[_addr] = pID_;
397             plyr_[pID_].addr = _addr;
398 
399             // set the new player bool to true
400             return (true);
401         } else {
402             return (false);
403         }
404     }
405 //==============================================================================
406 //   _   _|_ _  _ _  _ |   _ _ || _  .
407 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
408 //==============================================================================
409     function getPlayerID(address _addr)
410         isRegisteredGame()
411         external
412         returns (uint256)
413     {
414         determinePID(_addr);
415         return (pIDxAddr_[_addr]);
416     }
417     function getPlayerName(uint256 _pID)
418         external
419         view
420         returns (bytes32)
421     {
422         return (plyr_[_pID].name);
423     }
424     function getPlayerLAff(uint256 _pID)
425         external
426         view
427         returns (uint256)
428     {
429         return (plyr_[_pID].laff);
430     }
431     function getPlayerAddr(uint256 _pID)
432         external
433         view
434         returns (address)
435     {
436         return (plyr_[_pID].addr);
437     }
438     function getNameFee()
439         external
440         view
441         returns (uint256)
442     {
443         return(registrationFee_);
444     }
445     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
446         isRegisteredGame()
447         external
448         payable
449         returns(bool, uint256)
450     {
451         // make sure name fees paid
452         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
453 
454         // set up our tx event data and determine if player is new or not
455         bool _isNewPlayer = determinePID(_addr);
456 
457         // fetch player id
458         uint256 _pID = pIDxAddr_[_addr];
459 
460         // manage affiliate residuals
461         // if no affiliate code was given, no new affiliate code was given, or the
462         // player tried to use their own pID as an affiliate code, lolz
463         uint256 _affID = _affCode;
464         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
465         {
466             // update last affiliate
467             plyr_[_pID].laff = _affID;
468         } else if (_affID == _pID) {
469             _affID = 0;
470         }
471 
472         // register name
473         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
474 
475         return(_isNewPlayer, _affID);
476     }
477     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
478         isRegisteredGame()
479         external
480         payable
481         returns(bool, uint256)
482     {
483         // make sure name fees paid
484         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
485 
486         // set up our tx event data and determine if player is new or not
487         bool _isNewPlayer = determinePID(_addr);
488 
489         // fetch player id
490         uint256 _pID = pIDxAddr_[_addr];
491 
492         // manage affiliate residuals
493         // if no affiliate code was given or player tried to use their own, lolz
494         uint256 _affID;
495         if (_affCode != address(0) && _affCode != _addr)
496         {
497             // get affiliate ID from aff Code
498             _affID = pIDxAddr_[_affCode];
499 
500             // if affID is not the same as previously stored
501             if (_affID != plyr_[_pID].laff)
502             {
503                 // update last affiliate
504                 plyr_[_pID].laff = _affID;
505             }
506         }
507 
508         // register name
509         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
510 
511         return(_isNewPlayer, _affID);
512     }
513     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
514         isRegisteredGame()
515         external
516         payable
517         returns(bool, uint256)
518     {
519         // make sure name fees paid
520         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
521 
522         // set up our tx event data and determine if player is new or not
523         bool _isNewPlayer = determinePID(_addr);
524 
525         // fetch player id
526         uint256 _pID = pIDxAddr_[_addr];
527 
528         // manage affiliate residuals
529         // if no affiliate code was given or player tried to use their own, lolz
530         uint256 _affID;
531         if (_affCode != "" && _affCode != _name)
532         {
533             // get affiliate ID from aff Code
534             _affID = pIDxName_[_affCode];
535 
536             // if affID is not the same as previously stored
537             if (_affID != plyr_[_pID].laff)
538             {
539                 // update last affiliate
540                 plyr_[_pID].laff = _affID;
541             }
542         }
543 
544         // register name
545         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
546 
547         return(_isNewPlayer, _affID);
548     }
549 
550 //==============================================================================
551 //   _ _ _|_    _   .
552 //  _\(/_ | |_||_)  .
553 //=============|================================================================
554     function addGame(address _gameAddress, string _gameNameStr)
555         public
556     {
557         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
558             gID_++;
559             bytes32 _name = _gameNameStr.nameFilter();
560             gameIDs_[_gameAddress] = gID_;
561             gameNames_[_gameAddress] = _name;
562             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
563 
564             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
565             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
566             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
567             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
568     }
569 
570     function setRegistrationFee(uint256 _fee)
571         public
572     {
573       registrationFee_ = _fee;
574     }
575 
576 }
577 
578 /**
579 * @title -Name Filter- v0.1.9
580 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
581 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
582 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
583 *                                  _____                      _____
584 *                                 (, /     /)       /) /)    (, /      /)          /)
585 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
586 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
587 *          ┴ ┴                /   /          .-/ _____   (__ /
588 *                            (__ /          (_/ (, /                                      /)™
589 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
590 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
591 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
592 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
593 *              _       __    _      ____      ____  _   _    _____  ____  ___
594 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
595 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
596 *
597 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
598 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
599 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
600 */
601 library NameFilter {
602 
603     /**
604      * @dev filters name strings
605      * -converts uppercase to lower case.
606      * -makes sure it does not start/end with a space
607      * -makes sure it does not contain multiple spaces in a row
608      * -cannot be only numbers
609      * -cannot start with 0x
610      * -restricts characters to A-Z, a-z, 0-9, and space.
611      * @return reprocessed string in bytes32 format
612      */
613     function nameFilter(string _input)
614         internal
615         pure
616         returns(bytes32)
617     {
618         bytes memory _temp = bytes(_input);
619         uint256 _length = _temp.length;
620 
621         //sorry limited to 32 characters
622         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
623         // make sure it doesnt start with or end with space
624         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
625         // make sure first two characters are not 0x
626         if (_temp[0] == 0x30)
627         {
628             require(_temp[1] != 0x78, "string cannot start with 0x");
629             require(_temp[1] != 0x58, "string cannot start with 0X");
630         }
631 
632         // create a bool to track if we have a non number character
633         bool _hasNonNumber;
634 
635         // convert & check
636         for (uint256 i = 0; i < _length; i++)
637         {
638             // if its uppercase A-Z
639             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
640             {
641                 // convert to lower case a-z
642                 _temp[i] = byte(uint(_temp[i]) + 32);
643 
644                 // we have a non number
645                 if (_hasNonNumber == false)
646                     _hasNonNumber = true;
647             } else {
648                 require
649                 (
650                     // require character is a space
651                     _temp[i] == 0x20 ||
652                     // OR lowercase a-z
653                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
654                     // or 0-9
655                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
656                     "string contains invalid characters"
657                 );
658                 // make sure theres not 2x spaces in a row
659                 if (_temp[i] == 0x20)
660                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
661 
662                 // see if we have a character other than a number
663                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
664                     _hasNonNumber = true;
665             }
666         }
667 
668         require(_hasNonNumber == true, "string cannot be only numbers");
669 
670         bytes32 _ret;
671         assembly {
672             _ret := mload(add(_temp, 32))
673         }
674         return (_ret);
675     }
676 }
677 
678 /**
679  * @title SafeMath v0.1.9
680  * @dev Math operations with safety checks that throw on error
681  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
682  * - added sqrt
683  * - added sq
684  * - added pwr
685  * - changed asserts to requires with error log outputs
686  * - removed div, its useless
687  */
688 library SafeMath {
689 
690     /**
691     * @dev Multiplies two numbers, throws on overflow.
692     */
693     function mul(uint256 a, uint256 b)
694         internal
695         pure
696         returns (uint256 c)
697     {
698         if (a == 0) {
699             return 0;
700         }
701         c = a * b;
702         require(c / a == b, "SafeMath mul failed");
703         return c;
704     }
705 
706     /**
707     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
708     */
709     function sub(uint256 a, uint256 b)
710         internal
711         pure
712         returns (uint256)
713     {
714         require(b <= a, "SafeMath sub failed");
715         return a - b;
716     }
717 
718     /**
719     * @dev Adds two numbers, throws on overflow.
720     */
721     function add(uint256 a, uint256 b)
722         internal
723         pure
724         returns (uint256 c)
725     {
726         c = a + b;
727         require(c >= a, "SafeMath add failed");
728         return c;
729     }
730 
731     /**
732      * @dev gives square root of given x.
733      */
734     function sqrt(uint256 x)
735         internal
736         pure
737         returns (uint256 y)
738     {
739         uint256 z = ((add(x,1)) / 2);
740         y = x;
741         while (z < y)
742         {
743             y = z;
744             z = ((add((x / z),z)) / 2);
745         }
746     }
747 
748     /**
749      * @dev gives square. multiplies x by x
750      */
751     function sq(uint256 x)
752         internal
753         pure
754         returns (uint256)
755     {
756         return (mul(x,x));
757     }
758 
759     /**
760      * @dev x to the power of y
761      */
762     function pwr(uint256 x, uint256 y)
763         internal
764         pure
765         returns (uint256)
766     {
767         if (x==0)
768             return (0);
769         else if (y==0)
770             return (1);
771         else
772         {
773             uint256 z = x;
774             for (uint256 i=1; i < y; i++)
775                 z = mul(z,x);
776             return (z);
777         }
778     }
779 }