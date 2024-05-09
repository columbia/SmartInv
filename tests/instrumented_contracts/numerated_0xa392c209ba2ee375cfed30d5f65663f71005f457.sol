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
35 contract F3Devents {
36 	event onLTestStr
37 	(
38 		string log
39 	);
40 }
41 
42 contract modularShort is F3Devents {}
43 
44 contract PlayerBook is modularShort {
45     using NameFilter for string;
46     using SafeMath for uint256;
47 
48     address private admin = msg.sender;
49     //==============================================================================
50     //     _| _ _|_ _    _ _ _|_    _   .
51     //    (_|(_| | (_|  _\(/_ | |_||_)  .
52     //=============================|================================================
53     uint256 public registrationFee_ = 10 finney;            // price to register a name
54     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
55     mapping(address => bytes32) public gameNames_;          // lookup a games name
56     mapping(address => uint256) public gameIDs_;            // lokup a games ID
57     uint256 public gID_;        // total number of games
58     uint256 public pID_;        // total number of players
59     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
60     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
61     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
62     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
63     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
64     struct Player {
65         address addr;
66         bytes32 name;
67         uint256 laff;
68         uint256 names;
69     }
70     //==============================================================================
71     //     _ _  _  __|_ _    __|_ _  _  .
72     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
73     //==============================================================================
74     constructor()
75     public
76     {
77         // premine the dev names (sorry not sorry)
78         // No keys are purchased with this method, it's simply locking our addresses,
79         // PID's and names for referral codes.
80         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
81         plyr_[1].name = "justo";
82         plyr_[1].names = 1;
83         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
84         pIDxName_["justo"] = 1;
85         plyrNames_[1]["justo"] = true;
86         plyrNameList_[1][1] = "justo";
87 
88         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
89         plyr_[2].name = "mantso";
90         plyr_[2].names = 1;
91         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
92         pIDxName_["mantso"] = 2;
93         plyrNames_[2]["mantso"] = true;
94         plyrNameList_[2][1] = "mantso";
95 
96         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
97         plyr_[3].name = "sumpunk";
98         plyr_[3].names = 1;
99         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
100         pIDxName_["sumpunk"] = 3;
101         plyrNames_[3]["sumpunk"] = true;
102         plyrNameList_[3][1] = "sumpunk";
103 
104         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
105         plyr_[4].name = "inventor";
106         plyr_[4].names = 1;
107         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
108         pIDxName_["inventor"] = 4;
109         plyrNames_[4]["inventor"] = true;
110         plyrNameList_[4][1] = "inventor";
111 
112         pID_ = 4;
113     }
114     //==============================================================================
115     //     _ _  _  _|. |`. _  _ _  .
116     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
117     //==============================================================================
118     /**
119      * @dev prevents contracts from interacting with fomo3d
120      */
121     modifier isHuman() {
122         address _addr = msg.sender;
123         uint256 _codeLength;
124 
125         assembly {_codeLength := extcodesize(_addr)}
126         require(_codeLength == 0, "sorry humans only");
127         _;
128     }
129 
130 
131     modifier isRegisteredGame()
132     {
133         require(gameIDs_[msg.sender] != 0);
134         _;
135     }
136     //==============================================================================
137     //     _    _  _ _|_ _  .
138     //    (/_\/(/_| | | _\  .
139     //==============================================================================
140     // fired whenever a player registers a name
141     event onNewName
142     (
143         uint256 indexed playerID,
144         address indexed playerAddress,
145         bytes32 indexed playerName,
146         bool isNewPlayer,
147         uint256 affiliateID,
148         address affiliateAddress,
149         bytes32 affiliateName,
150         uint256 amountPaid,
151         uint256 timeStamp
152     );
153     //==============================================================================
154     //     _  _ _|__|_ _  _ _  .
155     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
156     //=====_|=======================================================================
157     function checkIfNameValid(string _nameStr)
158     public
159     view
160     returns(bool)
161     {
162         bytes32 _name = _nameStr.nameFilter();
163         if (pIDxName_[_name] == 0)
164             return (true);
165         else
166             return (false);
167     }
168     //==============================================================================
169     //     _    |_ |. _   |`    _  __|_. _  _  _  .
170     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
171     //====|=========================================================================
172     /**
173      * @dev registers a name.  UI will always display the last name you registered.
174      * but you will still own all previously registered names to use as affiliate
175      * links.
176      * - must pay a registration fee.
177      * - name must be unique
178      * - names will be converted to lowercase
179      * - name cannot start or end with a space
180      * - cannot have more than 1 space in a row
181      * - cannot be only numbers
182      * - cannot start with 0x
183      * - name must be at least 1 char
184      * - max length of 32 characters long
185      * - allowed characters: a-z, 0-9, and space
186      * -functionhash- 0x921dec21 (using ID for affiliate)
187      * -functionhash- 0x3ddd4698 (using address for affiliate)
188      * -functionhash- 0x685ffd83 (using name for affiliate)
189      * @param _nameString players desired name
190      * @param _affCode affiliate ID, address, or name of who refered you
191      * @param _all set to true if you want this to push your info to all games
192      * (this might cost a lot of gas)
193      */
194     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
195     isHuman()
196     public
197     payable
198     {
199         // make sure name fees paid
200         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
201 
202         // filter name + condition checks
203         bytes32 _name = NameFilter.nameFilter(_nameString);
204 
205         // set up address
206         address _addr = msg.sender;
207 
208         // set up our tx event data and determine if player is new or not
209         bool _isNewPlayer = determinePID(_addr);
210 
211         // fetch player id
212         uint256 _pID = pIDxAddr_[_addr];
213 
214         // manage affiliate residuals
215         // if no affiliate code was given, no new affiliate code was given, or the
216         // player tried to use their own pID as an affiliate code, lolz
217         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
218         {
219             // update last affiliate
220             plyr_[_pID].laff = _affCode;
221         } else if (_affCode == _pID) {
222             _affCode = 0;
223         }
224 
225         // register name
226         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
227     }
228 
229     function registerNameXaddr(string _nameString, address _affCode, bool _all)
230     isHuman()
231     public
232     payable
233     {
234         // make sure name fees paid
235         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
236 
237         // filter name + condition checks
238         bytes32 _name = NameFilter.nameFilter(_nameString);
239 
240         // set up address
241         address _addr = msg.sender;
242 
243         // set up our tx event data and determine if player is new or not
244         bool _isNewPlayer = determinePID(_addr);
245 
246         // fetch player id
247         uint256 _pID = pIDxAddr_[_addr];
248 
249         // manage affiliate residuals
250         // if no affiliate code was given or player tried to use their own, lolz
251         uint256 _affID;
252         if (_affCode != address(0) && _affCode != _addr)
253         {
254             // get affiliate ID from aff Code
255             _affID = pIDxAddr_[_affCode];
256 
257             // if affID is not the same as previously stored
258             if (_affID != plyr_[_pID].laff)
259             {
260                 // update last affiliate
261                 plyr_[_pID].laff = _affID;
262             }
263         }
264 
265         // register name
266         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
267     }
268 
269     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
270     isHuman()
271     public
272     payable
273     {
274         // make sure name fees paid
275         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
276 
277         // filter name + condition checks
278         bytes32 _name = NameFilter.nameFilter(_nameString);
279 
280         // set up address
281         address _addr = msg.sender;
282 
283         // set up our tx event data and determine if player is new or not
284         bool _isNewPlayer = determinePID(_addr);
285 
286         // fetch player id
287         uint256 _pID = pIDxAddr_[_addr];
288 
289         // manage affiliate residuals
290         // if no affiliate code was given or player tried to use their own, lolz
291         uint256 _affID;
292         if (_affCode != "" && _affCode != _name)
293         {
294             // get affiliate ID from aff Code
295             _affID = pIDxName_[_affCode];
296 
297             // if affID is not the same as previously stored
298             if (_affID != plyr_[_pID].laff)
299             {
300                 // update last affiliate
301                 plyr_[_pID].laff = _affID;
302             }
303         }
304 
305         // register name
306         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
307     }
308 
309     /**
310      * @dev players, if you registered a profile, before a game was released, or
311      * set the all bool to false when you registered, use this function to push
312      * your profile to a single game.  also, if you've  updated your name, you
313      * can use this to push your name to games of your choosing.
314      * -functionhash- 0x81c5b206
315      * @param _gameID game id
316      */
317     function addMeToGame(uint256 _gameID)
318     isHuman()
319     public
320     {
321         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
322         address _addr = msg.sender;
323         uint256 _pID = pIDxAddr_[_addr];
324         require(_pID != 0, "hey there buddy, you dont even have an account");
325         uint256 _totalNames = plyr_[_pID].names;
326 
327         // add players profile and most recent name
328         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
329 
330         // add list of all names
331         if (_totalNames > 1)
332             for (uint256 ii = 1; ii <= _totalNames; ii++)
333                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
334     }
335 
336     /**
337      * @dev players, use this to push your player profile to all registered games.
338      * -functionhash- 0x0c6940ea
339      */
340     function addMeToAllGames()
341     isHuman()
342     public
343     {
344         address _addr = msg.sender;
345         uint256 _pID = pIDxAddr_[_addr];
346         require(_pID != 0, "hey there buddy, you dont even have an account");
347         uint256 _laff = plyr_[_pID].laff;
348         uint256 _totalNames = plyr_[_pID].names;
349         bytes32 _name = plyr_[_pID].name;
350 
351         for (uint256 i = 1; i <= gID_; i++)
352         {
353             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
354             if (_totalNames > 1)
355                 for (uint256 ii = 1; ii <= _totalNames; ii++)
356                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
357         }
358 
359     }
360 
361     /**
362      * @dev players use this to change back to one of your old names.  tip, you'll
363      * still need to push that info to existing games.
364      * -functionhash- 0xb9291296
365      * @param _nameString the name you want to use
366      */
367     function useMyOldName(string _nameString)
368     isHuman()
369     public
370     {
371         // filter name, and get pID
372         bytes32 _name = _nameString.nameFilter();
373         uint256 _pID = pIDxAddr_[msg.sender];
374 
375         // make sure they own the name
376         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
377 
378         // update their current name
379         plyr_[_pID].name = _name;
380     }
381 
382     //==============================================================================
383     //     _ _  _ _   | _  _ . _  .
384     //    (_(_)| (/_  |(_)(_||(_  .
385     //=====================_|=======================================================
386     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
387     private
388     {
389         // if names already has been used, require that current msg sender owns the name
390         if (pIDxName_[_name] != 0)
391             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
392 
393         // add name to player profile, registry, and name book
394         plyr_[_pID].name = _name;
395         pIDxName_[_name] = _pID;
396         if (plyrNames_[_pID][_name] == false)
397         {
398             plyrNames_[_pID][_name] = true;
399             plyr_[_pID].names++;
400             plyrNameList_[_pID][plyr_[_pID].names] = _name;
401         }
402 
403         // registration fee goes directly to community rewards
404         admin.transfer(address(this).balance);
405 
406         // push player info to games
407         if (_all == true)
408             for (uint256 i = 1; i <= gID_; i++)
409                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
410 
411         // fire event
412         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
413     }
414     //==============================================================================
415     //    _|_ _  _ | _  .
416     //     | (_)(_)|_\  .
417     //==============================================================================
418     function determinePID(address _addr)
419     private
420     returns (bool)
421     {
422         if (pIDxAddr_[_addr] == 0)
423         {
424             pID_++;
425             pIDxAddr_[_addr] = pID_;
426             plyr_[pID_].addr = _addr;
427 
428             // set the new player bool to true
429             return (true);
430         } else {
431             return (false);
432         }
433     }
434     //==============================================================================
435     //   _   _|_ _  _ _  _ |   _ _ || _  .
436     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
437     //==============================================================================
438     function getPlayerID(address _addr)
439     isRegisteredGame()
440     external
441     returns (uint256)
442     {
443         determinePID(_addr);
444         return (pIDxAddr_[_addr]);
445     }
446     function getPlayerName(uint256 _pID)
447     external
448     view
449     returns (bytes32)
450     {
451         return (plyr_[_pID].name);
452     }
453     function getPlayerLAff(uint256 _pID)
454     external
455     view
456     returns (uint256)
457     {
458         return (plyr_[_pID].laff);
459     }
460     function getPlayerAddr(uint256 _pID)
461     external
462     view
463     returns (address)
464     {
465         return (plyr_[_pID].addr);
466     }
467     function getNameFee()
468     external
469     view
470     returns (uint256)
471     {
472         return(registrationFee_);
473     }
474     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
475     isRegisteredGame()
476     external
477     payable
478     returns(bool, uint256)
479     {
480         // make sure name fees paid
481         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
482 
483         // set up our tx event data and determine if player is new or not
484         bool _isNewPlayer = determinePID(_addr);
485 
486         // fetch player id
487         uint256 _pID = pIDxAddr_[_addr];
488 
489         // manage affiliate residuals
490         // if no affiliate code was given, no new affiliate code was given, or the
491         // player tried to use their own pID as an affiliate code, lolz
492         uint256 _affID = _affCode;
493         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
494         {
495             // update last affiliate
496             plyr_[_pID].laff = _affID;
497         } else if (_affID == _pID) {
498             _affID = 0;
499         }
500 
501         // register name
502         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
503 
504         return(_isNewPlayer, _affID);
505     }
506     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
507     isRegisteredGame()
508     external
509     payable
510     returns(bool, uint256)
511     {
512         // make sure name fees paid
513         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
514 
515         // set up our tx event data and determine if player is new or not
516         bool _isNewPlayer = determinePID(_addr);
517 
518         // fetch player id
519         uint256 _pID = pIDxAddr_[_addr];
520 
521         // manage affiliate residuals
522         // if no affiliate code was given or player tried to use their own, lolz
523         uint256 _affID;
524         if (_affCode != address(0) && _affCode != _addr)
525         {
526             // get affiliate ID from aff Code
527             _affID = pIDxAddr_[_affCode];
528 
529             // if affID is not the same as previously stored
530             if (_affID != plyr_[_pID].laff)
531             {
532                 // update last affiliate
533                 plyr_[_pID].laff = _affID;
534             }
535         }
536 
537         // register name
538         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
539 
540         return(_isNewPlayer, _affID);
541     }
542     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
543     isRegisteredGame()
544     external
545     payable
546     returns(bool, uint256)
547     {
548         // make sure name fees paid
549         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
550 
551         // set up our tx event data and determine if player is new or not
552         bool _isNewPlayer = determinePID(_addr);
553 
554         // fetch player id
555         uint256 _pID = pIDxAddr_[_addr];
556 
557         // manage affiliate residuals
558         // if no affiliate code was given or player tried to use their own, lolz
559         uint256 _affID;
560         if (_affCode != "" && _affCode != _name)
561         {
562             // get affiliate ID from aff Code
563             _affID = pIDxName_[_affCode];
564 
565             // if affID is not the same as previously stored
566             if (_affID != plyr_[_pID].laff)
567             {
568                 // update last affiliate
569                 plyr_[_pID].laff = _affID;
570             }
571         }
572 
573         // register name
574         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
575 
576         return(_isNewPlayer, _affID);
577     }
578 
579     //==============================================================================
580     //   _ _ _|_    _   .
581     //  _\(/_ | |_||_)  .
582     //=============|================================================================
583     function addGame(address _gameAddress, string _gameNameStr)
584     public
585     {
586         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
587         gID_++;
588         bytes32 _name = _gameNameStr.nameFilter();
589         gameIDs_[_gameAddress] = gID_;
590         gameNames_[_gameAddress] = _name;
591         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
592 
593         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
594         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
595         games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
596         games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
597     }
598 
599     function setRegistrationFee(uint256 _fee)
600     public
601     {
602         registrationFee_ = _fee;
603     }
604 
605 }
606 
607 /**
608 * @title -Name Filter- v0.1.9
609 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
610 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
611 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
612 *                                  _____                      _____
613 *                                 (, /     /)       /) /)    (, /      /)          /)
614 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
615 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
616 *          ┴ ┴                /   /          .-/ _____   (__ /
617 *                            (__ /          (_/ (, /                                      /)™
618 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
619 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
620 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
621 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
622 *              _       __    _      ____      ____  _   _    _____  ____  ___
623 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
624 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
625 *
626 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
627 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
628 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
629 */
630 library NameFilter {
631 
632     /**
633      * @dev filters name strings
634      * -converts uppercase to lower case.
635      * -makes sure it does not start/end with a space
636      * -makes sure it does not contain multiple spaces in a row
637      * -cannot be only numbers
638      * -cannot start with 0x
639      * -restricts characters to A-Z, a-z, 0-9, and space.
640      * @return reprocessed string in bytes32 format
641      */
642     function nameFilter(string _input)
643     internal
644     pure
645     returns(bytes32)
646     {
647         bytes memory _temp = bytes(_input);
648         uint256 _length = _temp.length;
649 
650         //sorry limited to 32 characters
651         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
652         // make sure it doesnt start with or end with space
653         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
654         // make sure first two characters are not 0x
655         if (_temp[0] == 0x30)
656         {
657             require(_temp[1] != 0x78, "string cannot start with 0x");
658             require(_temp[1] != 0x58, "string cannot start with 0X");
659         }
660 
661         // create a bool to track if we have a non number character
662         bool _hasNonNumber;
663 
664         // convert & check
665         for (uint256 i = 0; i < _length; i++)
666         {
667             // if its uppercase A-Z
668             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
669             {
670                 // convert to lower case a-z
671                 _temp[i] = byte(uint(_temp[i]) + 32);
672 
673                 // we have a non number
674                 if (_hasNonNumber == false)
675                     _hasNonNumber = true;
676             } else {
677                 require
678                 (
679                 // require character is a space
680                     _temp[i] == 0x20 ||
681                 // OR lowercase a-z
682                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
683                 // or 0-9
684                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
685                     "string contains invalid characters"
686                 );
687                 // make sure theres not 2x spaces in a row
688                 if (_temp[i] == 0x20)
689                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
690 
691                 // see if we have a character other than a number
692                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
693                     _hasNonNumber = true;
694             }
695         }
696 
697         require(_hasNonNumber == true, "string cannot be only numbers");
698 
699         bytes32 _ret;
700         assembly {
701             _ret := mload(add(_temp, 32))
702         }
703         return (_ret);
704     }
705 }
706 
707 /**
708  * @title SafeMath v0.1.9
709  * @dev Math operations with safety checks that throw on error
710  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
711  * - added sqrt
712  * - added sq
713  * - added pwr
714  * - changed asserts to requires with error log outputs
715  * - removed div, its useless
716  */
717 library SafeMath {
718 
719     /**
720     * @dev Multiplies two numbers, throws on overflow.
721     */
722     function mul(uint256 a, uint256 b)
723     internal
724     pure
725     returns (uint256 c)
726     {
727         if (a == 0) {
728             return 0;
729         }
730         c = a * b;
731         require(c / a == b, "SafeMath mul failed");
732         return c;
733     }
734 
735     /**
736     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
737     */
738     function sub(uint256 a, uint256 b)
739     internal
740     pure
741     returns (uint256)
742     {
743         require(b <= a, "SafeMath sub failed");
744         return a - b;
745     }
746 
747     /**
748     * @dev Adds two numbers, throws on overflow.
749     */
750     function add(uint256 a, uint256 b)
751     internal
752     pure
753     returns (uint256 c)
754     {
755         c = a + b;
756         require(c >= a, "SafeMath add failed");
757         return c;
758     }
759 
760     /**
761      * @dev gives square root of given x.
762      */
763     function sqrt(uint256 x)
764     internal
765     pure
766     returns (uint256 y)
767     {
768         uint256 z = ((add(x,1)) / 2);
769         y = x;
770         while (z < y)
771         {
772             y = z;
773             z = ((add((x / z),z)) / 2);
774         }
775     }
776 
777     /**
778      * @dev gives square. multiplies x by x
779      */
780     function sq(uint256 x)
781     internal
782     pure
783     returns (uint256)
784     {
785         return (mul(x,x));
786     }
787 
788     /**
789      * @dev x to the power of y
790      */
791     function pwr(uint256 x, uint256 y)
792     internal
793     pure
794     returns (uint256)
795     {
796         if (x==0)
797             return (0);
798         else if (y==0)
799             return (1);
800         else
801         {
802             uint256 z = x;
803             for (uint256 i=1; i < y; i++)
804                 z = mul(z,x);
805             return (z);
806         }
807     }
808 }