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
29 interface ZethrBankroll {
30     function deposit() external payable;
31 }
32 
33 interface PlayerBookReceiverInterface {
34     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
35     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
36 }
37 
38 interface TeamJustInterface {
39     function requiredSignatures() external view returns(uint256);
40     function requiredDevSignatures() external view returns(uint256);
41     function adminCount() external view returns(uint256);
42     function devCount() external view returns(uint256);
43     function adminName(address _who) external view returns(bytes32);
44     function isAdmin(address _who) external view returns(bool);
45     function isDev(address _who) external view returns(bool);
46 }
47 
48 contract PlayerBook {
49     using NameFilter for string;
50     using SafeMath for uint256;
51     // CHANGEME
52     // this is now the Zethr Bankroll
53     address constant private Jekyll_Island_Inc = address(0xe7c3101745b3dd71228006084dccb619340f8390);
54     //TeamJustInterface constant private TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
55     
56 
57 
58 
59 //==============================================================================
60 //     _| _ _|_ _    _ _ _|_    _   .
61 //    (_|(_| | (_|  _\(/_ | |_||_)  .
62 //=============================|================================================    
63     uint256 public registrationFee_ = 25 finney;            // price to register a name
64     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
65     mapping(address => bytes32) public gameNames_;          // lookup a games name
66     mapping(address => uint256) public gameIDs_;            // lokup a games ID
67     uint256 public gID_;        // total number of games
68     uint256 public pID_;        // total number of players
69     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
70     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
71     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
72     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
73     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
74     
75     mapping(address => bool) devs;
76 
77     struct Player {
78         address addr;
79         bytes32 name;
80         uint256 laff;
81         uint256 names;
82     }
83 //==============================================================================
84 //     _ _  _  __|_ _    __|_ _  _  .
85 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
86 //==============================================================================    
87     constructor()
88         public
89     {
90         devs[msg.sender] = true;
91         devs[0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285] = true;
92     }
93 //==============================================================================
94 //     _ _  _  _|. |`. _  _ _  .
95 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
96 //==============================================================================    
97     /**
98      * @dev prevents contracts from interacting with fomo3d 
99      */
100     modifier isHuman() {
101         require(msg.sender==tx.origin);
102         _;
103     }
104     
105     modifier onlyDevs() 
106     {
107         require(devs[msg.sender]); //require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
108         _;
109     }
110     
111     modifier isRegisteredGame()
112     {
113         require(gameIDs_[msg.sender] != 0);
114         _;
115     }
116 //==============================================================================
117 //     _    _  _ _|_ _  .
118 //    (/_\/(/_| | | _\  .
119 //==============================================================================    
120     // fired whenever a player registers a name
121     event onNewName
122     (
123         uint256 indexed playerID,
124         address indexed playerAddress,
125         bytes32 indexed playerName,
126         bool isNewPlayer,
127         uint256 affiliateID,
128         address affiliateAddress,
129         bytes32 affiliateName,
130         uint256 amountPaid,
131         uint256 timeStamp
132     );
133 //==============================================================================
134 //     _  _ _|__|_ _  _ _  .
135 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
136 //=====_|=======================================================================
137     function checkIfNameValid(string _nameStr)
138         public
139         view
140         returns(bool)
141     {
142         bytes32 _name = _nameStr.nameFilter();
143         if (pIDxName_[_name] == 0)
144             return (true);
145         else 
146             return (false);
147     }
148 //==============================================================================
149 //     _    |_ |. _   |`    _  __|_. _  _  _  .
150 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
151 //====|=========================================================================    
152     /**
153      * @dev registers a name.  UI will always display the last name you registered.
154      * but you will still own all previously registered names to use as affiliate 
155      * links.
156      * - must pay a registration fee.
157      * - name must be unique
158      * - names will be converted to lowercase
159      * - name cannot start or end with a space 
160      * - cannot have more than 1 space in a row
161      * - cannot be only numbers
162      * - cannot start with 0x 
163      * - name must be at least 1 char
164      * - max length of 32 characters long
165      * - allowed characters: a-z, 0-9, and space
166      * -functionhash- 0x921dec21 (using ID for affiliate)
167      * -functionhash- 0x3ddd4698 (using address for affiliate)
168      * -functionhash- 0x685ffd83 (using name for affiliate)
169      * @param _nameString players desired name
170      * @param _affCode affiliate ID, address, or name of who refered you
171      * @param _all set to true if you want this to push your info to all games 
172      * (this might cost a lot of gas)
173      */
174     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
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
195         // if no affiliate code was given, no new affiliate code was given, or the 
196         // player tried to use their own pID as an affiliate code, lolz
197         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
198         {
199             // update last affiliate 
200             plyr_[_pID].laff = _affCode;
201         } else if (_affCode == _pID) {
202             _affCode = 0;
203         }
204         
205         // register name 
206         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
207     }
208     
209     function registerNameXaddr(string _nameString, address _affCode, bool _all)
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
232         if (_affCode != address(0) && _affCode != _addr)
233         {
234             // get affiliate ID from aff Code 
235             _affID = pIDxAddr_[_affCode];
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
249     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
250         isHuman()
251         public
252         payable 
253     {
254         // make sure name fees paid
255         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
256         
257         // filter name + condition checks
258         bytes32 _name = NameFilter.nameFilter(_nameString);
259         
260         // set up address 
261         address _addr = msg.sender;
262         
263         // set up our tx event data and determine if player is new or not
264         bool _isNewPlayer = determinePID(_addr);
265         
266         // fetch player id
267         uint256 _pID = pIDxAddr_[_addr];
268         
269         // manage affiliate residuals
270         // if no affiliate code was given or player tried to use their own, lolz
271         uint256 _affID;
272         if (_affCode != "" && _affCode != _name)
273         {
274             // get affiliate ID from aff Code 
275             _affID = pIDxName_[_affCode];
276             
277             // if affID is not the same as previously stored 
278             if (_affID != plyr_[_pID].laff)
279             {
280                 // update last affiliate
281                 plyr_[_pID].laff = _affID;
282             }
283         }
284         
285         // register name 
286         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
287     }
288     
289     /**
290      * @dev players, if you registered a profile, before a game was released, or
291      * set the all bool to false when you registered, use this function to push
292      * your profile to a single game.  also, if you've  updated your name, you
293      * can use this to push your name to games of your choosing.
294      * -functionhash- 0x81c5b206
295      * @param _gameID game id 
296      */
297     function addMeToGame(uint256 _gameID)
298         isHuman()
299         public
300     {
301         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
302         address _addr = msg.sender;
303         uint256 _pID = pIDxAddr_[_addr];
304         require(_pID != 0, "hey there buddy, you dont even have an account");
305         uint256 _totalNames = plyr_[_pID].names;
306         
307         // add players profile and most recent name
308         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
309         
310         // add list of all names
311         if (_totalNames > 1)
312             for (uint256 ii = 1; ii <= _totalNames; ii++)
313                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
314     }
315     
316     /**
317      * @dev players, use this to push your player profile to all registered games.
318      * -functionhash- 0x0c6940ea
319      */
320     function addMeToAllGames()
321         isHuman()
322         public
323     {
324         address _addr = msg.sender;
325         uint256 _pID = pIDxAddr_[_addr];
326         require(_pID != 0, "hey there buddy, you dont even have an account");
327         uint256 _laff = plyr_[_pID].laff;
328         uint256 _totalNames = plyr_[_pID].names;
329         bytes32 _name = plyr_[_pID].name;
330         
331         for (uint256 i = 1; i <= gID_; i++)
332         {
333             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
334             if (_totalNames > 1)
335                 for (uint256 ii = 1; ii <= _totalNames; ii++)
336                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
337         }
338                 
339     }
340     
341     /**
342      * @dev players use this to change back to one of your old names.  tip, you'll
343      * still need to push that info to existing games.
344      * -functionhash- 0xb9291296
345      * @param _nameString the name you want to use 
346      */
347     function useMyOldName(string _nameString)
348         isHuman()
349         public 
350     {
351         // filter name, and get pID
352         bytes32 _name = _nameString.nameFilter();
353         uint256 _pID = pIDxAddr_[msg.sender];
354         
355         // make sure they own the name 
356         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
357         
358         // update their current name 
359         plyr_[_pID].name = _name;
360     }
361     
362 //==============================================================================
363 //     _ _  _ _   | _  _ . _  .
364 //    (_(_)| (/_  |(_)(_||(_  . 
365 //=====================_|=======================================================    
366     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
367         private
368     {
369         // if names already has been used, require that current msg sender owns the name
370         if (pIDxName_[_name] != 0)
371             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
372         
373         // add name to player profile, registry, and name book
374         plyr_[_pID].name = _name;
375         pIDxName_[_name] = _pID;
376         if (plyrNames_[_pID][_name] == false)
377         {
378             plyrNames_[_pID][_name] = true;
379             plyr_[_pID].names++;
380             plyrNameList_[_pID][plyr_[_pID].names] = _name;
381         }
382         
383         // registration fee goes directly to community rewards
384         Jekyll_Island_Inc.transfer(address(this).balance);
385         
386         // push player info to games
387         if (_all == true)
388             for (uint256 i = 1; i <= gID_; i++)
389                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
390         
391         // fire event
392         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
393     }
394 //==============================================================================
395 //    _|_ _  _ | _  .
396 //     | (_)(_)|_\  .
397 //==============================================================================    
398     function determinePID(address _addr)
399         private
400         returns (bool)
401     {
402         if (pIDxAddr_[_addr] == 0)
403         {
404             pID_++;
405             pIDxAddr_[_addr] = pID_;
406             plyr_[pID_].addr = _addr;
407             
408             // set the new player bool to true
409             return (true);
410         } else {
411             return (false);
412         }
413     }
414 //==============================================================================
415 //   _   _|_ _  _ _  _ |   _ _ || _  .
416 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
417 //==============================================================================
418     function getPlayerID(address _addr)
419         isRegisteredGame()
420         external
421         returns (uint256)
422     {
423         determinePID(_addr);
424         return (pIDxAddr_[_addr]);
425     }
426     function getPlayerName(uint256 _pID)
427         external
428         view
429         returns (bytes32)
430     {
431         return (plyr_[_pID].name);
432     }
433     function getPlayerLAff(uint256 _pID)
434         external
435         view
436         returns (uint256)
437     {
438         return (plyr_[_pID].laff);
439     }
440     function getPlayerAddr(uint256 _pID)
441         external
442         view
443         returns (address)
444     {
445         return (plyr_[_pID].addr);
446     }
447     function getNameFee()
448         external
449         view
450         returns (uint256)
451     {
452         return(registrationFee_);
453     }
454     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
455         isRegisteredGame()
456         external
457         payable
458         returns(bool, uint256)
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
470         // if no affiliate code was given, no new affiliate code was given, or the 
471         // player tried to use their own pID as an affiliate code, lolz
472         uint256 _affID = _affCode;
473         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
474         {
475             // update last affiliate 
476             plyr_[_pID].laff = _affID;
477         } else if (_affID == _pID) {
478             _affID = 0;
479         }
480         
481         // register name 
482         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
483         
484         return(_isNewPlayer, _affID);
485     }
486     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
487         isRegisteredGame()
488         external
489         payable
490         returns(bool, uint256)
491     {
492         // make sure name fees paid
493         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
494         
495         // set up our tx event data and determine if player is new or not
496         bool _isNewPlayer = determinePID(_addr);
497         
498         // fetch player id
499         uint256 _pID = pIDxAddr_[_addr];
500         
501         // manage affiliate residuals
502         // if no affiliate code was given or player tried to use their own, lolz
503         uint256 _affID;
504         if (_affCode != address(0) && _affCode != _addr)
505         {
506             // get affiliate ID from aff Code 
507             _affID = pIDxAddr_[_affCode];
508             
509             // if affID is not the same as previously stored 
510             if (_affID != plyr_[_pID].laff)
511             {
512                 // update last affiliate
513                 plyr_[_pID].laff = _affID;
514             }
515         }
516         
517         // register name 
518         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
519         
520         return(_isNewPlayer, _affID);
521     }
522     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
523         isRegisteredGame()
524         external
525         payable
526         returns(bool, uint256)
527     {
528         // make sure name fees paid
529         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
530         
531         // set up our tx event data and determine if player is new or not
532         bool _isNewPlayer = determinePID(_addr);
533         
534         // fetch player id
535         uint256 _pID = pIDxAddr_[_addr];
536         
537         // manage affiliate residuals
538         // if no affiliate code was given or player tried to use their own, lolz
539         uint256 _affID;
540         if (_affCode != "" && _affCode != _name)
541         {
542             // get affiliate ID from aff Code 
543             _affID = pIDxName_[_affCode];
544             
545             // if affID is not the same as previously stored 
546             if (_affID != plyr_[_pID].laff)
547             {
548                 // update last affiliate
549                 plyr_[_pID].laff = _affID;
550             }
551         }
552         
553         // register name 
554         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
555         
556         return(_isNewPlayer, _affID);
557     }
558     
559 //==============================================================================
560 //   _ _ _|_    _   .
561 //  _\(/_ | |_||_)  .
562 //=============|================================================================
563     function addGame(address _gameAddress, string _gameNameStr)
564         onlyDevs()
565         public
566     {
567         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
568         
569 
570             gID_++;
571             bytes32 _name = _gameNameStr.nameFilter();
572             gameIDs_[_gameAddress] = gID_;
573             gameNames_[_gameAddress] = _name;
574             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
575         
576             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
577             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
578             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
579             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
580         
581     }
582     
583     function setRegistrationFee(uint256 _fee)
584         onlyDevs()
585         public
586     {
587 
588             registrationFee_ = _fee;
589         
590     }
591         
592 } 
593 
594 /**
595 * @title -Name Filter- v0.1.9
596 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
597 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
598 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
599 *                                  _____                      _____
600 *                                 (, /     /)       /) /)    (, /      /)          /)
601 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
602 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
603 *          ┴ ┴                /   /          .-/ _____   (__ /                               
604 *                            (__ /          (_/ (, /                                      /)™ 
605 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
606 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
607 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
608 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
609 *              _       __    _      ____      ____  _   _    _____  ____  ___  
610 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
611 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
612 *
613 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
614 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
615 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
616 */
617 library NameFilter {
618     
619     /**
620      * @dev filters name strings
621      * -converts uppercase to lower case.  
622      * -makes sure it does not start/end with a space
623      * -makes sure it does not contain multiple spaces in a row
624      * -cannot be only numbers
625      * -cannot start with 0x 
626      * -restricts characters to A-Z, a-z, 0-9, and space.
627      * @return reprocessed string in bytes32 format
628      */
629     function nameFilter(string _input)
630         internal
631         pure
632         returns(bytes32)
633     {
634         bytes memory _temp = bytes(_input);
635         uint256 _length = _temp.length;
636         
637         //sorry limited to 32 characters
638         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
639         // make sure it doesnt start with or end with space
640         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
641         // make sure first two characters are not 0x
642         if (_temp[0] == 0x30)
643         {
644             require(_temp[1] != 0x78, "string cannot start with 0x");
645             require(_temp[1] != 0x58, "string cannot start with 0X");
646         }
647         
648         // create a bool to track if we have a non number character
649         bool _hasNonNumber;
650         
651         // convert & check
652         for (uint256 i = 0; i < _length; i++)
653         {
654             // if its uppercase A-Z
655             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
656             {
657                 // convert to lower case a-z
658                 _temp[i] = byte(uint(_temp[i]) + 32);
659                 
660                 // we have a non number
661                 if (_hasNonNumber == false)
662                     _hasNonNumber = true;
663             } else {
664                 require
665                 (
666                     // require character is a space
667                     _temp[i] == 0x20 || 
668                     // OR lowercase a-z
669                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
670                     // or 0-9
671                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
672                     "string contains invalid characters"
673                 );
674                 // make sure theres not 2x spaces in a row
675                 if (_temp[i] == 0x20)
676                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
677                 
678                 // see if we have a character other than a number
679                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
680                     _hasNonNumber = true;    
681             }
682         }
683         
684         require(_hasNonNumber == true, "string cannot be only numbers");
685         
686         bytes32 _ret;
687         assembly {
688             _ret := mload(add(_temp, 32))
689         }
690         return (_ret);
691     }
692 }
693 
694 /**
695  * @title SafeMath v0.1.9
696  * @dev Math operations with safety checks that throw on error
697  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
698  * - added sqrt
699  * - added sq
700  * - added pwr 
701  * - changed asserts to requires with error log outputs
702  * - removed div, its useless
703  */
704 library SafeMath {
705     
706     /**
707     * @dev Multiplies two numbers, throws on overflow.
708     */
709     function mul(uint256 a, uint256 b) 
710         internal 
711         pure 
712         returns (uint256 c) 
713     {
714         if (a == 0) {
715             return 0;
716         }
717         c = a * b;
718         require(c / a == b, "SafeMath mul failed");
719         return c;
720     }
721 
722     /**
723     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
724     */
725     function sub(uint256 a, uint256 b)
726         internal
727         pure
728         returns (uint256) 
729     {
730         require(b <= a, "SafeMath sub failed");
731         return a - b;
732     }
733 
734     /**
735     * @dev Adds two numbers, throws on overflow.
736     */
737     function add(uint256 a, uint256 b)
738         internal
739         pure
740         returns (uint256 c) 
741     {
742         c = a + b;
743         require(c >= a, "SafeMath add failed");
744         return c;
745     }
746     
747     /**
748      * @dev gives square root of given x.
749      */
750     function sqrt(uint256 x)
751         internal
752         pure
753         returns (uint256 y) 
754     {
755         uint256 z = ((add(x,1)) / 2);
756         y = x;
757         while (z < y) 
758         {
759             y = z;
760             z = ((add((x / z),z)) / 2);
761         }
762     }
763     
764     /**
765      * @dev gives square. multiplies x by x
766      */
767     function sq(uint256 x)
768         internal
769         pure
770         returns (uint256)
771     {
772         return (mul(x,x));
773     }
774     
775     /**
776      * @dev x to the power of y 
777      */
778     function pwr(uint256 x, uint256 y)
779         internal 
780         pure 
781         returns (uint256)
782     {
783         if (x==0)
784             return (0);
785         else if (y==0)
786             return (1);
787         else 
788         {
789             uint256 z = x;
790             for (uint256 i=1; i < y; i++)
791                 z = mul(z,x);
792             return (z);
793         }
794     }
795 }