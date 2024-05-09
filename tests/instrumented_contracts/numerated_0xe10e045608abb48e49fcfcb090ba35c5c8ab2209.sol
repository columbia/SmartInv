1 pragma solidity ^0.4.24;
2 /*
3  * -PlayerBook - v0.3.14
4  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
5  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
6  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
7  *                                  _____                      _____
8  *                                 (, /     /)       /) /)    (, /      /)          /)
9  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
10  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
11  *          ┴ ┴                /   /          .-/ _____   (__ /
12  *                            (__ /          (_/ (, /                                      /)™
13  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
14  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
15  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
16  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
17  *     ______   _                                 ______                 _
18  *====(_____ \=| |===============================(____  \===============| |=============*
19  *     _____) )| |  _____  _   _  _____   ____    ____)  )  ___    ___  | |  _
20  *    |  ____/ | | (____ || | | || ___ | / ___)  |  __  (  / _ \  / _ \ | |_/ )
21  *    | |      | | / ___ || |_| || ____|| |      | |__)  )| |_| || |_| ||  _ (
22  *====|_|=======\_)\_____|=\__  ||_____)|_|======|______/==\___/==\___/=|_|=\_)=========*
23  *                        (____/
24  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
25  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
26  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
27  */
28 
29 
30 interface PlayerBookReceiverInterface {
31     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
32     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
33 }
34 
35 
36 contract PlayerBook {
37     using NameFilter for string;
38     using SafeMath for uint256;
39 
40     address private admin = msg.sender;
41 //==============================================================================
42 //     _| _ _|_ _    _ _ _|_    _   .
43 //    (_|(_| | (_|  _\(/_ | |_||_)  .
44 //=============================|================================================
45     uint256 public registrationFee_ = 10 finney;            // price to register a name
46     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
47     mapping(address => bytes32) public gameNames_;          // lookup a games name
48     mapping(address => uint256) public gameIDs_;            // lokup a games ID
49     uint256 public gID_;        // total number of games
50     uint256 public pID_;        // total number of players
51     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
52     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
53     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
54     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
55     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
56     struct Player {
57         address addr;
58         bytes32 name;
59         uint256 laff;
60         uint256 names;
61     }
62 //==============================================================================
63 //     _ _  _  __|_ _    __|_ _  _  .
64 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
65 //==============================================================================
66     constructor()
67         public
68     {
69         // premine the dev names (sorry not sorry)
70             // No keys are purchased with this method, it's simply locking our addresses,
71             // PID's and names for referral codes.
72         plyr_[1].addr = 0xC3980287Dc4548e9b4D5083BE591DFb491279115;
73         plyr_[1].name = "justo";
74         plyr_[1].names = 1;
75         pIDxAddr_[0xC3980287Dc4548e9b4D5083BE591DFb491279115] = 1;
76         pIDxName_["justo"] = 1;
77         plyrNames_[1]["justo"] = true;
78         plyrNameList_[1][1] = "justo";
79 
80         plyr_[2].addr = 0xD97F774764cc95357804b0e18cEC855c8c80Dd61;
81         plyr_[2].name = "mantso";
82         plyr_[2].names = 1;
83         pIDxAddr_[0xD97F774764cc95357804b0e18cEC855c8c80Dd61] = 2;
84         pIDxName_["mantso"] = 2;
85         plyrNames_[2]["mantso"] = true;
86         plyrNameList_[2][1] = "mantso";
87 
88         plyr_[3].addr = 0xEaf90e017B5a8F3E3fc9B6427dA0729F7947ddD5;
89         plyr_[3].name = "sumpunk";
90         plyr_[3].names = 1;
91         pIDxAddr_[0xEaf90e017B5a8F3E3fc9B6427dA0729F7947ddD5] = 3;
92         pIDxName_["sumpunk"] = 3;
93         plyrNames_[3]["sumpunk"] = true;
94         plyrNameList_[3][1] = "sumpunk";
95 
96         plyr_[4].addr = 0xe663F5a9a076968E93A59461e2d82279f09127E8;
97         plyr_[4].name = "inventor";
98         plyr_[4].names = 1;
99         pIDxAddr_[0xe663F5a9a076968E93A59461e2d82279f09127E8] = 4;
100         pIDxName_["inventor"] = 4;
101         plyrNames_[4]["inventor"] = true;
102         plyrNameList_[4][1] = "inventor";
103 
104         pID_ = 4;
105     }
106 //==============================================================================
107 //     _ _  _  _|. |`. _  _ _  .
108 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
109 //==============================================================================
110     /**
111      * @dev prevents contracts from interacting with fomo3d
112      */
113     modifier isHuman() {
114         address _addr = msg.sender;
115         uint256 _codeLength;
116 
117         assembly {_codeLength := extcodesize(_addr)}
118         require(_codeLength == 0, "sorry humans only");
119         _;
120     }
121 
122     modifier onlyDevs()
123     {
124         require(admin == msg.sender, "msg sender is not a dev");
125         _;
126     }
127 
128     modifier isRegisteredGame()
129     {
130         require(gameIDs_[msg.sender] != 0);
131         _;
132     }
133 //==============================================================================
134 //     _    _  _ _|_ _  .
135 //    (/_\/(/_| | | _\  .
136 //==============================================================================
137     // fired whenever a player registers a name
138     event onNewName
139     (
140         uint256 indexed playerID,
141         address indexed playerAddress,
142         bytes32 indexed playerName,
143         bool isNewPlayer,
144         uint256 affiliateID,
145         address affiliateAddress,
146         bytes32 affiliateName,
147         uint256 amountPaid,
148         uint256 timeStamp
149     );
150 //==============================================================================
151 //     _  _ _|__|_ _  _ _  .
152 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
153 //=====_|=======================================================================
154     function checkIfNameValid(string _nameStr)
155         public
156         view
157         returns(bool)
158     {
159         bytes32 _name = _nameStr.nameFilter();
160         if (pIDxName_[_name] == 0)
161             return (true);
162         else
163             return (false);
164     }
165 //==============================================================================
166 //     _    |_ |. _   |`    _  __|_. _  _  _  .
167 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
168 //====|=========================================================================
169     /**
170      * @dev registers a name.  UI will always display the last name you registered.
171      * but you will still own all previously registered names to use as affiliate
172      * links.
173      * - must pay a registration fee.
174      * - name must be unique
175      * - names will be converted to lowercase
176      * - name cannot start or end with a space
177      * - cannot have more than 1 space in a row
178      * - cannot be only numbers
179      * - cannot start with 0x
180      * - name must be at least 1 char
181      * - max length of 32 characters long
182      * - allowed characters: a-z, 0-9, and space
183      * -functionhash- 0x921dec21 (using ID for affiliate)
184      * -functionhash- 0x3ddd4698 (using address for affiliate)
185      * -functionhash- 0x685ffd83 (using name for affiliate)
186      * @param _nameString players desired name
187      * @param _affCode affiliate ID, address, or name of who refered you
188      * @param _all set to true if you want this to push your info to all games
189      * (this might cost a lot of gas)
190      */
191     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
192         isHuman()
193         public
194         payable
195     {
196         // make sure name fees paid
197         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
198 
199         // filter name + condition checks
200         bytes32 _name = NameFilter.nameFilter(_nameString);
201 
202         // set up address
203         address _addr = msg.sender;
204 
205         // set up our tx event data and determine if player is new or not
206         bool _isNewPlayer = determinePID(_addr);
207 
208         // fetch player id
209         uint256 _pID = pIDxAddr_[_addr];
210 
211         // manage affiliate residuals
212         // if no affiliate code was given, no new affiliate code was given, or the
213         // player tried to use their own pID as an affiliate code, lolz
214         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
215         {
216             // update last affiliate
217             plyr_[_pID].laff = _affCode;
218         } else if (_affCode == _pID) {
219             _affCode = 0;
220         }
221 
222         // register name
223         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
224     }
225 
226     function registerNameXaddr(string _nameString, address _affCode, bool _all)
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
249         if (_affCode != address(0) && _affCode != _addr)
250         {
251             // get affiliate ID from aff Code
252             _affID = pIDxAddr_[_affCode];
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
266     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
267         isHuman()
268         public
269         payable
270     {
271         // make sure name fees paid
272         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
273 
274         // filter name + condition checks
275         bytes32 _name = NameFilter.nameFilter(_nameString);
276 
277         // set up address
278         address _addr = msg.sender;
279 
280         // set up our tx event data and determine if player is new or not
281         bool _isNewPlayer = determinePID(_addr);
282 
283         // fetch player id
284         uint256 _pID = pIDxAddr_[_addr];
285 
286         // manage affiliate residuals
287         // if no affiliate code was given or player tried to use their own, lolz
288         uint256 _affID;
289         if (_affCode != "" && _affCode != _name)
290         {
291             // get affiliate ID from aff Code
292             _affID = pIDxName_[_affCode];
293 
294             // if affID is not the same as previously stored
295             if (_affID != plyr_[_pID].laff)
296             {
297                 // update last affiliate
298                 plyr_[_pID].laff = _affID;
299             }
300         }
301 
302         // register name
303         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
304     }
305 
306     /**
307      * @dev players, if you registered a profile, before a game was released, or
308      * set the all bool to false when you registered, use this function to push
309      * your profile to a single game.  also, if you've  updated your name, you
310      * can use this to push your name to games of your choosing.
311      * -functionhash- 0x81c5b206
312      * @param _gameID game id
313      */
314     function addMeToGame(uint256 _gameID)
315         isHuman()
316         public
317     {
318         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
319         address _addr = msg.sender;
320         uint256 _pID = pIDxAddr_[_addr];
321         require(_pID != 0, "hey there buddy, you dont even have an account");
322         uint256 _totalNames = plyr_[_pID].names;
323 
324         // add players profile and most recent name
325         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
326 
327         // add list of all names
328         if (_totalNames > 1)
329             for (uint256 ii = 1; ii <= _totalNames; ii++)
330                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
331     }
332 
333     /**
334      * @dev players, use this to push your player profile to all registered games.
335      * -functionhash- 0x0c6940ea
336      */
337     function addMeToAllGames()
338         isHuman()
339         public
340     {
341         address _addr = msg.sender;
342         uint256 _pID = pIDxAddr_[_addr];
343         require(_pID != 0, "hey there buddy, you dont even have an account");
344         uint256 _laff = plyr_[_pID].laff;
345         uint256 _totalNames = plyr_[_pID].names;
346         bytes32 _name = plyr_[_pID].name;
347 
348         for (uint256 i = 1; i <= gID_; i++)
349         {
350             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
351             if (_totalNames > 1)
352                 for (uint256 ii = 1; ii <= _totalNames; ii++)
353                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
354         }
355 
356     }
357 
358     /**
359      * @dev players use this to change back to one of your old names.  tip, you'll
360      * still need to push that info to existing games.
361      * -functionhash- 0xb9291296
362      * @param _nameString the name you want to use
363      */
364     function useMyOldName(string _nameString)
365         isHuman()
366         public
367     {
368         // filter name, and get pID
369         bytes32 _name = _nameString.nameFilter();
370         uint256 _pID = pIDxAddr_[msg.sender];
371 
372         // make sure they own the name
373         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
374 
375         // update their current name
376         plyr_[_pID].name = _name;
377     }
378 
379 //==============================================================================
380 //     _ _  _ _   | _  _ . _  .
381 //    (_(_)| (/_  |(_)(_||(_  .
382 //=====================_|=======================================================
383     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
384         private
385     {
386         // if names already has been used, require that current msg sender owns the name
387         if (pIDxName_[_name] != 0)
388             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
389 
390         // add name to player profile, registry, and name book
391         plyr_[_pID].name = _name;
392         pIDxName_[_name] = _pID;
393         if (plyrNames_[_pID][_name] == false)
394         {
395             plyrNames_[_pID][_name] = true;
396             plyr_[_pID].names++;
397             plyrNameList_[_pID][plyr_[_pID].names] = _name;
398         }
399 
400         // registration fee goes directly to community rewards
401         admin.transfer(address(this).balance);
402 
403         // push player info to games
404         if (_all == true)
405             for (uint256 i = 1; i <= gID_; i++)
406                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
407 
408         // fire event
409         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
410     }
411 //==============================================================================
412 //    _|_ _  _ | _  .
413 //     | (_)(_)|_\  .
414 //==============================================================================
415     function determinePID(address _addr)
416         private
417         returns (bool)
418     {
419         if (pIDxAddr_[_addr] == 0)
420         {
421             pID_++;
422             pIDxAddr_[_addr] = pID_;
423             plyr_[pID_].addr = _addr;
424 
425             // set the new player bool to true
426             return (true);
427         } else {
428             return (false);
429         }
430     }
431 //==============================================================================
432 //   _   _|_ _  _ _  _ |   _ _ || _  .
433 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
434 //==============================================================================
435     function getPlayerID(address _addr)
436         isRegisteredGame()
437         external
438         returns (uint256)
439     {
440         determinePID(_addr);
441         return (pIDxAddr_[_addr]);
442     }
443     function getPlayerName(uint256 _pID)
444         external
445         view
446         returns (bytes32)
447     {
448         return (plyr_[_pID].name);
449     }
450     function getPlayerLAff(uint256 _pID)
451         external
452         view
453         returns (uint256)
454     {
455         return (plyr_[_pID].laff);
456     }
457     function getPlayerAddr(uint256 _pID)
458         external
459         view
460         returns (address)
461     {
462         return (plyr_[_pID].addr);
463     }
464     function getNameFee()
465         external
466         view
467         returns (uint256)
468     {
469         return(registrationFee_);
470     }
471     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
472         isRegisteredGame()
473         external
474         payable
475         returns(bool, uint256)
476     {
477         // make sure name fees paid
478         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
479 
480         // set up our tx event data and determine if player is new or not
481         bool _isNewPlayer = determinePID(_addr);
482 
483         // fetch player id
484         uint256 _pID = pIDxAddr_[_addr];
485 
486         // manage affiliate residuals
487         // if no affiliate code was given, no new affiliate code was given, or the
488         // player tried to use their own pID as an affiliate code, lolz
489         uint256 _affID = _affCode;
490         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
491         {
492             // update last affiliate
493             plyr_[_pID].laff = _affID;
494         } else if (_affID == _pID) {
495             _affID = 0;
496         }
497 
498         // register name
499         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
500 
501         return(_isNewPlayer, _affID);
502     }
503     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
504         isRegisteredGame()
505         external
506         payable
507         returns(bool, uint256)
508     {
509         // make sure name fees paid
510         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
511 
512         // set up our tx event data and determine if player is new or not
513         bool _isNewPlayer = determinePID(_addr);
514 
515         // fetch player id
516         uint256 _pID = pIDxAddr_[_addr];
517 
518         // manage affiliate residuals
519         // if no affiliate code was given or player tried to use their own, lolz
520         uint256 _affID;
521         if (_affCode != address(0) && _affCode != _addr)
522         {
523             // get affiliate ID from aff Code
524             _affID = pIDxAddr_[_affCode];
525 
526             // if affID is not the same as previously stored
527             if (_affID != plyr_[_pID].laff)
528             {
529                 // update last affiliate
530                 plyr_[_pID].laff = _affID;
531             }
532         }
533 
534         // register name
535         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
536 
537         return(_isNewPlayer, _affID);
538     }
539     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
540         isRegisteredGame()
541         external
542         payable
543         returns(bool, uint256)
544     {
545         // make sure name fees paid
546         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
547 
548         // set up our tx event data and determine if player is new or not
549         bool _isNewPlayer = determinePID(_addr);
550 
551         // fetch player id
552         uint256 _pID = pIDxAddr_[_addr];
553 
554         // manage affiliate residuals
555         // if no affiliate code was given or player tried to use their own, lolz
556         uint256 _affID;
557         if (_affCode != "" && _affCode != _name)
558         {
559             // get affiliate ID from aff Code
560             _affID = pIDxName_[_affCode];
561 
562             // if affID is not the same as previously stored
563             if (_affID != plyr_[_pID].laff)
564             {
565                 // update last affiliate
566                 plyr_[_pID].laff = _affID;
567             }
568         }
569 
570         // register name
571         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
572 
573         return(_isNewPlayer, _affID);
574     }
575 
576 //==============================================================================
577 //   _ _ _|_    _   .
578 //  _\(/_ | |_||_)  .
579 //=============|================================================================
580     function addGame(address _gameAddress, string _gameNameStr)
581         onlyDevs()
582         public
583     {
584         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
585             gID_++;
586             bytes32 _name = _gameNameStr.nameFilter();
587             gameIDs_[_gameAddress] = gID_;
588             gameNames_[_gameAddress] = _name;
589             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
590 
591             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
592             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
593             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
594             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
595     }
596 
597     function setRegistrationFee(uint256 _fee)
598         onlyDevs()
599         public
600     {
601       registrationFee_ = _fee;
602     }
603 
604 }
605 
606 /**
607 * @title -Name Filter- v0.1.9
608 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
609 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
610 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
611 *                                  _____                      _____
612 *                                 (, /     /)       /) /)    (, /      /)          /)
613 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
614 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
615 *          ┴ ┴                /   /          .-/ _____   (__ /
616 *                            (__ /          (_/ (, /                                      /)™
617 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
618 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
619 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
620 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
621 *              _       __    _      ____      ____  _   _    _____  ____  ___
622 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
623 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
624 *
625 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
626 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
627 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
628 */
629 library NameFilter {
630 
631     /**
632      * @dev filters name strings
633      * -converts uppercase to lower case.
634      * -makes sure it does not start/end with a space
635      * -makes sure it does not contain multiple spaces in a row
636      * -cannot be only numbers
637      * -cannot start with 0x
638      * -restricts characters to A-Z, a-z, 0-9, and space.
639      * @return reprocessed string in bytes32 format
640      */
641     function nameFilter(string _input)
642         internal
643         pure
644         returns(bytes32)
645     {
646         bytes memory _temp = bytes(_input);
647         uint256 _length = _temp.length;
648 
649         //sorry limited to 32 characters
650         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
651         // make sure it doesnt start with or end with space
652         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
653         // make sure first two characters are not 0x
654         if (_temp[0] == 0x30)
655         {
656             require(_temp[1] != 0x78, "string cannot start with 0x");
657             require(_temp[1] != 0x58, "string cannot start with 0X");
658         }
659 
660         // create a bool to track if we have a non number character
661         bool _hasNonNumber;
662 
663         // convert & check
664         for (uint256 i = 0; i < _length; i++)
665         {
666             // if its uppercase A-Z
667             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
668             {
669                 // convert to lower case a-z
670                 _temp[i] = byte(uint(_temp[i]) + 32);
671 
672                 // we have a non number
673                 if (_hasNonNumber == false)
674                     _hasNonNumber = true;
675             } else {
676                 require
677                 (
678                     // require character is a space
679                     _temp[i] == 0x20 ||
680                     // OR lowercase a-z
681                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
682                     // or 0-9
683                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
684                     "string contains invalid characters"
685                 );
686                 // make sure theres not 2x spaces in a row
687                 if (_temp[i] == 0x20)
688                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
689 
690                 // see if we have a character other than a number
691                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
692                     _hasNonNumber = true;
693             }
694         }
695 
696         require(_hasNonNumber == true, "string cannot be only numbers");
697 
698         bytes32 _ret;
699         assembly {
700             _ret := mload(add(_temp, 32))
701         }
702         return (_ret);
703     }
704 }
705 
706 /**
707  * @title SafeMath v0.1.9
708  * @dev Math operations with safety checks that throw on error
709  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
710  * - added sqrt
711  * - added sq
712  * - added pwr
713  * - changed asserts to requires with error log outputs
714  * - removed div, its useless
715  */
716 library SafeMath {
717 
718     /**
719     * @dev Multiplies two numbers, throws on overflow.
720     */
721     function mul(uint256 a, uint256 b)
722         internal
723         pure
724         returns (uint256 c)
725     {
726         if (a == 0) {
727             return 0;
728         }
729         c = a * b;
730         require(c / a == b, "SafeMath mul failed");
731         return c;
732     }
733 
734     /**
735     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
736     */
737     function sub(uint256 a, uint256 b)
738         internal
739         pure
740         returns (uint256)
741     {
742         require(b <= a, "SafeMath sub failed");
743         return a - b;
744     }
745 
746     /**
747     * @dev Adds two numbers, throws on overflow.
748     */
749     function add(uint256 a, uint256 b)
750         internal
751         pure
752         returns (uint256 c)
753     {
754         c = a + b;
755         require(c >= a, "SafeMath add failed");
756         return c;
757     }
758 
759     /**
760      * @dev gives square root of given x.
761      */
762     function sqrt(uint256 x)
763         internal
764         pure
765         returns (uint256 y)
766     {
767         uint256 z = ((add(x,1)) / 2);
768         y = x;
769         while (z < y)
770         {
771             y = z;
772             z = ((add((x / z),z)) / 2);
773         }
774     }
775 
776     /**
777      * @dev gives square. multiplies x by x
778      */
779     function sq(uint256 x)
780         internal
781         pure
782         returns (uint256)
783     {
784         return (mul(x,x));
785     }
786 
787     /**
788      * @dev x to the power of y
789      */
790     function pwr(uint256 x, uint256 y)
791         internal
792         pure
793         returns (uint256)
794     {
795         if (x==0)
796             return (0);
797         else if (y==0)
798             return (1);
799         else
800         {
801             uint256 z = x;
802             for (uint256 i=1; i < y; i++)
803                 z = mul(z,x);
804             return (z);
805         }
806     }
807 }