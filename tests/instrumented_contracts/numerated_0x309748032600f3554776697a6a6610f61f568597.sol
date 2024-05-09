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
71             // PID's and names for referral codes. //引用代码的PID和名称
72         plyr_[1].addr = 0x584f2b61b5fdae9aed5d12e1bf7f77db3766fc68;  //justo的钱包地址
73         plyr_[1].name = "justo";
74         plyr_[1].names = 1;
75         pIDxAddr_[0x584f2b61b5fdae9aed5d12e1bf7f77db3766fc68] = 1;
76         pIDxName_["justo"] = 1;
77         plyrNames_[1]["justo"] = true;
78         plyrNameList_[1][1] = "justo";
79 
80         pID_ = 1;
81     }
82 //==============================================================================
83 //     _ _  _  _|. |`. _  _ _  .
84 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
85 //==============================================================================
86     /**
87      * @dev prevents contracts from interacting with fomo3d
88      */
89     modifier isHuman() {
90         address _addr = msg.sender;
91         uint256 _codeLength;
92 
93         assembly {_codeLength := extcodesize(_addr)}
94         require(_codeLength == 0, "sorry humans only");
95         _;
96     }
97 
98     modifier onlyDevs()
99     {
100         require(admin == msg.sender, "msg sender is not a dev");
101         _;
102     }
103 
104     modifier isRegisteredGame()
105     {
106         require(gameIDs_[msg.sender] != 0);
107         _;
108     }
109 //==============================================================================
110 //     _    _  _ _|_ _  .
111 //    (/_\/(/_| | | _\  .
112 //==============================================================================
113     // fired whenever a player registers a name
114     event onNewName
115     (
116         uint256 indexed playerID,
117         address indexed playerAddress,
118         bytes32 indexed playerName,
119         bool isNewPlayer,
120         uint256 affiliateID,
121         address affiliateAddress,
122         bytes32 affiliateName,
123         uint256 amountPaid,
124         uint256 timeStamp
125     );
126 //==============================================================================
127 //     _  _ _|__|_ _  _ _  .
128 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
129 //=====_|=======================================================================
130     function checkIfNameValid(string _nameStr)
131         public
132         view
133         returns(bool)
134     {
135         bytes32 _name = _nameStr.nameFilter();
136         if (pIDxName_[_name] == 0)
137             return (true);
138         else
139             return (false);
140     }
141 //==============================================================================
142 //     _    |_ |. _   |`    _  __|_. _  _  _  .
143 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
144 //====|=========================================================================
145     /**
146      * @dev registers a name.  UI will always display the last name you registered.
147      * but you will still own all previously registered names to use as affiliate
148      * links.
149      * - must pay a registration fee.
150      * - name must be unique
151      * - names will be converted to lowercase
152      * - name cannot start or end with a space
153      * - cannot have more than 1 space in a row
154      * - cannot be only numbers
155      * - cannot start with 0x
156      * - name must be at least 1 char
157      * - max length of 32 characters long
158      * - allowed characters: a-z, 0-9, and space
159      * -functionhash- 0x921dec21 (using ID for affiliate)
160      * -functionhash- 0x3ddd4698 (using address for affiliate)
161      * -functionhash- 0x685ffd83 (using name for affiliate)
162      * @param _nameString players desired name
163      * @param _affCode affiliate ID, address, or name of who refered you
164      * @param _all set to true if you want this to push your info to all games
165      * (this might cost a lot of gas)
166      */
167     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
168         isHuman()
169         public
170         payable
171     {
172         // make sure name fees paid
173         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
174 
175         // filter name + condition checks
176         bytes32 _name = NameFilter.nameFilter(_nameString);
177 
178         // set up address
179         address _addr = msg.sender;
180 
181         // set up our tx event data and determine if player is new or not
182         bool _isNewPlayer = determinePID(_addr);
183 
184         // fetch player id
185         uint256 _pID = pIDxAddr_[_addr];
186 
187         // manage affiliate residuals
188         // if no affiliate code was given, no new affiliate code was given, or the
189         // player tried to use their own pID as an affiliate code, lolz
190         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
191         {
192             // update last affiliate
193             plyr_[_pID].laff = _affCode;
194         } else if (_affCode == _pID) {
195             _affCode = 0;
196         }
197 
198         // register name
199         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
200     }
201 
202     function registerNameXaddr(string _nameString, address _affCode, bool _all)
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
225         if (_affCode != address(0) && _affCode != _addr)
226         {
227             // get affiliate ID from aff Code
228             _affID = pIDxAddr_[_affCode];
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
242     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
243         isHuman()
244         public
245         payable
246     {
247         // make sure name fees paid
248         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
249 
250         // filter name + condition checks
251         bytes32 _name = NameFilter.nameFilter(_nameString);
252 
253         // set up address
254         address _addr = msg.sender;
255 
256         // set up our tx event data and determine if player is new or not
257         bool _isNewPlayer = determinePID(_addr);
258 
259         // fetch player id
260         uint256 _pID = pIDxAddr_[_addr];
261 
262         // manage affiliate residuals
263         // if no affiliate code was given or player tried to use their own, lolz
264         uint256 _affID;
265         if (_affCode != "" && _affCode != _name)
266         {
267             // get affiliate ID from aff Code
268             _affID = pIDxName_[_affCode];
269 
270             // if affID is not the same as previously stored
271             if (_affID != plyr_[_pID].laff)
272             {
273                 // update last affiliate
274                 plyr_[_pID].laff = _affID;
275             }
276         }
277 
278         // register name
279         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
280     }
281 
282     /**
283      * @dev players, if you registered a profile, before a game was released, or
284      * set the all bool to false when you registered, use this function to push
285      * your profile to a single game.  also, if you've  updated your name, you
286      * can use this to push your name to games of your choosing.
287      * -functionhash- 0x81c5b206
288      * @param _gameID game id
289      */
290     function addMeToGame(uint256 _gameID)
291         isHuman()
292         public
293     {
294         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
295         address _addr = msg.sender;
296         uint256 _pID = pIDxAddr_[_addr];
297         require(_pID != 0, "hey there buddy, you dont even have an account");
298         uint256 _totalNames = plyr_[_pID].names;
299 
300         // add players profile and most recent name
301         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
302 
303         // add list of all names
304         if (_totalNames > 1)
305             for (uint256 ii = 1; ii <= _totalNames; ii++)
306                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
307     }
308 
309     /**
310      * @dev players, use this to push your player profile to all registered games.
311      * -functionhash- 0x0c6940ea
312      */
313     function addMeToAllGames()
314         isHuman()
315         public
316     {
317         address _addr = msg.sender;
318         uint256 _pID = pIDxAddr_[_addr];
319         require(_pID != 0, "hey there buddy, you dont even have an account");
320         uint256 _laff = plyr_[_pID].laff;
321         uint256 _totalNames = plyr_[_pID].names;
322         bytes32 _name = plyr_[_pID].name;
323 
324         for (uint256 i = 1; i <= gID_; i++)
325         {
326             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
327             if (_totalNames > 1)
328                 for (uint256 ii = 1; ii <= _totalNames; ii++)
329                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
330         }
331 
332     }
333 
334     /**
335      * @dev players use this to change back to one of your old names.  tip, you'll
336      * still need to push that info to existing games.
337      * -functionhash- 0xb9291296
338      * @param _nameString the name you want to use
339      */
340     function useMyOldName(string _nameString)
341         isHuman()
342         public
343     {
344         // filter name, and get pID
345         bytes32 _name = _nameString.nameFilter();
346         uint256 _pID = pIDxAddr_[msg.sender];
347 
348         // make sure they own the name
349         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
350 
351         // update their current name
352         plyr_[_pID].name = _name;
353     }
354 
355 //==============================================================================
356 //     _ _  _ _   | _  _ . _  .
357 //    (_(_)| (/_  |(_)(_||(_  .
358 //=====================_|=======================================================
359     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
360         private
361     {
362         // if names already has been used, require that current msg sender owns the name
363         if (pIDxName_[_name] != 0)
364             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
365 
366         // add name to player profile, registry, and name book
367         plyr_[_pID].name = _name;
368         pIDxName_[_name] = _pID;
369         if (plyrNames_[_pID][_name] == false)
370         {
371             plyrNames_[_pID][_name] = true;
372             plyr_[_pID].names++;
373             plyrNameList_[_pID][plyr_[_pID].names] = _name;
374         }
375 
376         // registration fee goes directly to community rewards
377         admin.transfer(address(this).balance);
378 
379         // push player info to games
380         if (_all == true)
381             for (uint256 i = 1; i <= gID_; i++)
382                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
383 
384         // fire event
385         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
386     }
387 //==============================================================================
388 //    _|_ _  _ | _  .
389 //     | (_)(_)|_\  .
390 //==============================================================================
391     function determinePID(address _addr)
392         private
393         returns (bool)
394     {
395         if (pIDxAddr_[_addr] == 0)
396         {
397             pID_++;
398             pIDxAddr_[_addr] = pID_;
399             plyr_[pID_].addr = _addr;
400 
401             // set the new player bool to true
402             return (true);
403         } else {
404             return (false);
405         }
406     }
407 //==============================================================================
408 //   _   _|_ _  _ _  _ |   _ _ || _  .
409 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
410 //==============================================================================
411     function getPlayerID(address _addr)
412         isRegisteredGame()
413         external
414         returns (uint256)
415     {
416         determinePID(_addr);
417         return (pIDxAddr_[_addr]);
418     }
419     function getPlayerName(uint256 _pID)
420         external
421         view
422         returns (bytes32)
423     {
424         return (plyr_[_pID].name);
425     }
426     function getPlayerLAff(uint256 _pID)
427         external
428         view
429         returns (uint256)
430     {
431         return (plyr_[_pID].laff);
432     }
433     function getPlayerAddr(uint256 _pID)
434         external
435         view
436         returns (address)
437     {
438         return (plyr_[_pID].addr);
439     }
440     function getNameFee()
441         external
442         view
443         returns (uint256)
444     {
445         return(registrationFee_);
446     }
447     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
448         isRegisteredGame()
449         external
450         payable
451         returns(bool, uint256)
452     {
453         // make sure name fees paid
454         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
455 
456         // set up our tx event data and determine if player is new or not
457         bool _isNewPlayer = determinePID(_addr);
458 
459         // fetch player id
460         uint256 _pID = pIDxAddr_[_addr];
461 
462         // manage affiliate residuals
463         // if no affiliate code was given, no new affiliate code was given, or the
464         // player tried to use their own pID as an affiliate code, lolz
465         uint256 _affID = _affCode;
466         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
467         {
468             // update last affiliate
469             plyr_[_pID].laff = _affID;
470         } else if (_affID == _pID) {
471             _affID = 0;
472         }
473 
474         // register name
475         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
476 
477         return(_isNewPlayer, _affID);
478     }
479     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
480         isRegisteredGame()
481         external
482         payable
483         returns(bool, uint256)
484     {
485         // make sure name fees paid
486         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
487 
488         // set up our tx event data and determine if player is new or not
489         bool _isNewPlayer = determinePID(_addr);
490 
491         // fetch player id
492         uint256 _pID = pIDxAddr_[_addr];
493 
494         // manage affiliate residuals
495         // if no affiliate code was given or player tried to use their own, lolz
496         uint256 _affID;
497         if (_affCode != address(0) && _affCode != _addr)
498         {
499             // get affiliate ID from aff Code
500             _affID = pIDxAddr_[_affCode];
501 
502             // if affID is not the same as previously stored
503             if (_affID != plyr_[_pID].laff)
504             {
505                 // update last affiliate
506                 plyr_[_pID].laff = _affID;
507             }
508         }
509 
510         // register name
511         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
512 
513         return(_isNewPlayer, _affID);
514     }
515     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
516         isRegisteredGame()
517         external
518         payable
519         returns(bool, uint256)
520     {
521         // make sure name fees paid
522         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
523 
524         // set up our tx event data and determine if player is new or not
525         bool _isNewPlayer = determinePID(_addr);
526 
527         // fetch player id
528         uint256 _pID = pIDxAddr_[_addr];
529 
530         // manage affiliate residuals
531         // if no affiliate code was given or player tried to use their own, lolz
532         uint256 _affID;
533         if (_affCode != "" && _affCode != _name)
534         {
535             // get affiliate ID from aff Code
536             _affID = pIDxName_[_affCode];
537 
538             // if affID is not the same as previously stored
539             if (_affID != plyr_[_pID].laff)
540             {
541                 // update last affiliate
542                 plyr_[_pID].laff = _affID;
543             }
544         }
545 
546         // register name
547         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
548 
549         return(_isNewPlayer, _affID);
550     }
551 
552 //==============================================================================
553 //   _ _ _|_    _   .
554 //  _\(/_ | |_||_)  .
555 //=============|================================================================
556     function addGame(address _gameAddress, string _gameNameStr)
557         onlyDevs()
558         public
559     {
560         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
561             gID_++;
562             bytes32 _name = _gameNameStr.nameFilter();
563             gameIDs_[_gameAddress] = gID_;
564             gameNames_[_gameAddress] = _name;
565             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
566 
567             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
568             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
569             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
570             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
571     }
572 
573     function setRegistrationFee(uint256 _fee)
574         onlyDevs()
575         public
576     {
577       registrationFee_ = _fee;
578     }
579 
580 }
581 
582 /**
583 * @title -Name Filter- v0.1.9
584 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
585 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
586 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
587 *                                  _____                      _____
588 *                                 (, /     /)       /) /)    (, /      /)          /)
589 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
590 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
591 *          ┴ ┴                /   /          .-/ _____   (__ /
592 *                            (__ /          (_/ (, /                                      /)™
593 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
594 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
595 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
596 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
597 *              _       __    _      ____      ____  _   _    _____  ____  ___
598 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
599 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
600 *
601 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
602 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
603 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
604 */
605 library NameFilter {
606 
607     /**
608      * @dev filters name strings
609      * -converts uppercase to lower case.
610      * -makes sure it does not start/end with a space
611      * -makes sure it does not contain multiple spaces in a row
612      * -cannot be only numbers
613      * -cannot start with 0x
614      * -restricts characters to A-Z, a-z, 0-9, and space.
615      * @return reprocessed string in bytes32 format
616      */
617     function nameFilter(string _input)
618         internal
619         pure
620         returns(bytes32)
621     {
622         bytes memory _temp = bytes(_input);
623         uint256 _length = _temp.length;
624 
625         //sorry limited to 32 characters
626         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
627         // make sure it doesnt start with or end with space
628         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
629         // make sure first two characters are not 0x
630         if (_temp[0] == 0x30)
631         {
632             require(_temp[1] != 0x78, "string cannot start with 0x");
633             require(_temp[1] != 0x58, "string cannot start with 0X");
634         }
635 
636         // create a bool to track if we have a non number character
637         bool _hasNonNumber;
638 
639         // convert & check
640         for (uint256 i = 0; i < _length; i++)
641         {
642             // if its uppercase A-Z
643             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
644             {
645                 // convert to lower case a-z
646                 _temp[i] = byte(uint(_temp[i]) + 32);
647 
648                 // we have a non number
649                 if (_hasNonNumber == false)
650                     _hasNonNumber = true;
651             } else {
652                 require
653                 (
654                     // require character is a space
655                     _temp[i] == 0x20 ||
656                     // OR lowercase a-z
657                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
658                     // or 0-9
659                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
660                     "string contains invalid characters"
661                 );
662                 // make sure theres not 2x spaces in a row
663                 if (_temp[i] == 0x20)
664                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
665 
666                 // see if we have a character other than a number
667                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
668                     _hasNonNumber = true;
669             }
670         }
671 
672         require(_hasNonNumber == true, "string cannot be only numbers");
673 
674         bytes32 _ret;
675         assembly {
676             _ret := mload(add(_temp, 32))
677         }
678         return (_ret);
679     }
680 }
681 
682 /**
683  * @title SafeMath v0.1.9
684  * @dev Math operations with safety checks that throw on error
685  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
686  * - added sqrt
687  * - added sq
688  * - added pwr
689  * - changed asserts to requires with error log outputs
690  * - removed div, its useless
691  */
692 library SafeMath {
693 
694     /**
695     * @dev Multiplies two numbers, throws on overflow.
696     */
697     function mul(uint256 a, uint256 b)
698         internal
699         pure
700         returns (uint256 c)
701     {
702         if (a == 0) {
703             return 0;
704         }
705         c = a * b;
706         require(c / a == b, "SafeMath mul failed");
707         return c;
708     }
709 
710     /**
711     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
712     */
713     function sub(uint256 a, uint256 b)
714         internal
715         pure
716         returns (uint256)
717     {
718         require(b <= a, "SafeMath sub failed");
719         return a - b;
720     }
721 
722     /**
723     * @dev Adds two numbers, throws on overflow.
724     */
725     function add(uint256 a, uint256 b)
726         internal
727         pure
728         returns (uint256 c)
729     {
730         c = a + b;
731         require(c >= a, "SafeMath add failed");
732         return c;
733     }
734 
735     /**
736      * @dev gives square root of given x.
737      */
738     function sqrt(uint256 x)
739         internal
740         pure
741         returns (uint256 y)
742     {
743         uint256 z = ((add(x,1)) / 2);
744         y = x;
745         while (z < y)
746         {
747             y = z;
748             z = ((add((x / z),z)) / 2);
749         }
750     }
751 
752     /**
753      * @dev gives square. multiplies x by x
754      */
755     function sq(uint256 x)
756         internal
757         pure
758         returns (uint256)
759     {
760         return (mul(x,x));
761     }
762 
763     /**
764      * @dev x to the power of y
765      */
766     function pwr(uint256 x, uint256 y)
767         internal
768         pure
769         returns (uint256)
770     {
771         if (x==0)
772             return (0);
773         else if (y==0)
774             return (1);
775         else
776         {
777             uint256 z = x;
778             for (uint256 i=1; i < y; i++)
779                 z = mul(z,x);
780             return (z);
781         }
782     }
783 }