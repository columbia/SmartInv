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
53     address constant private Jekyll_Island_Inc = address(0xb51d0DF324c513Cf07efD075Cc5bccA1D0F211Ab);
54     //TeamJustInterface constant private TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
55     
56 
57 
58 
59 //==============================================================================
60 //     _| _ _|_ _    _ _ _|_    _   .
61 //    (_|(_| | (_|  _\(/_ | |_||_)  .
62 //=============================|================================================    
63     uint256 public registrationFee_ = 10 finney;            // price to register a name
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
91     }
92 //==============================================================================
93 //     _ _  _  _|. |`. _  _ _  .
94 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
95 //==============================================================================    
96     /**
97      * @dev prevents contracts from interacting with fomo3d 
98      */
99     modifier isHuman() {
100         require(msg.sender==tx.origin);
101         _;
102     }
103     
104     modifier onlyDevs() 
105     {
106         require(devs[msg.sender]); //require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
107         _;
108     }
109     
110     modifier isRegisteredGame()
111     {
112         require(gameIDs_[msg.sender] != 0);
113         _;
114     }
115 //==============================================================================
116 //     _    _  _ _|_ _  .
117 //    (/_\/(/_| | | _\  .
118 //==============================================================================    
119     // fired whenever a player registers a name
120     event onNewName
121     (
122         uint256 indexed playerID,
123         address indexed playerAddress,
124         bytes32 indexed playerName,
125         bool isNewPlayer,
126         uint256 affiliateID,
127         address affiliateAddress,
128         bytes32 affiliateName,
129         uint256 amountPaid,
130         uint256 timeStamp
131     );
132 //==============================================================================
133 //     _  _ _|__|_ _  _ _  .
134 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
135 //=====_|=======================================================================
136     function checkIfNameValid(string _nameStr)
137         public
138         view
139         returns(bool)
140     {
141         bytes32 _name = _nameStr.nameFilter();
142         if (pIDxName_[_name] == 0)
143             return (true);
144         else 
145             return (false);
146     }
147 //==============================================================================
148 //     _    |_ |. _   |`    _  __|_. _  _  _  .
149 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
150 //====|=========================================================================    
151     /**
152      * @dev registers a name.  UI will always display the last name you registered.
153      * but you will still own all previously registered names to use as affiliate 
154      * links.
155      * - must pay a registration fee.
156      * - name must be unique
157      * - names will be converted to lowercase
158      * - name cannot start or end with a space 
159      * - cannot have more than 1 space in a row
160      * - cannot be only numbers
161      * - cannot start with 0x 
162      * - name must be at least 1 char
163      * - max length of 32 characters long
164      * - allowed characters: a-z, 0-9, and space
165      * -functionhash- 0x921dec21 (using ID for affiliate)
166      * -functionhash- 0x3ddd4698 (using address for affiliate)
167      * -functionhash- 0x685ffd83 (using name for affiliate)
168      * @param _nameString players desired name
169      * @param _affCode affiliate ID, address, or name of who refered you
170      * @param _all set to true if you want this to push your info to all games 
171      * (this might cost a lot of gas)
172      */
173     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
174         isHuman()
175         public
176         payable 
177     {
178         // make sure name fees paid
179         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
180         
181         // filter name + condition checks
182         bytes32 _name = NameFilter.nameFilter(_nameString);
183         
184         // set up address 
185         address _addr = msg.sender;
186         
187         // set up our tx event data and determine if player is new or not
188         bool _isNewPlayer = determinePID(_addr);
189         
190         // fetch player id
191         uint256 _pID = pIDxAddr_[_addr];
192         
193         // manage affiliate residuals
194         // if no affiliate code was given, no new affiliate code was given, or the 
195         // player tried to use their own pID as an affiliate code, lolz
196         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
197         {
198             // update last affiliate 
199             plyr_[_pID].laff = _affCode;
200         } else if (_affCode == _pID) {
201             _affCode = 0;
202         }
203         
204         // register name 
205         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
206     }
207     
208     function registerNameXaddr(string _nameString, address _affCode, bool _all)
209         isHuman()
210         public
211         payable 
212     {
213         // make sure name fees paid
214         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
215         
216         // filter name + condition checks
217         bytes32 _name = NameFilter.nameFilter(_nameString);
218         
219         // set up address 
220         address _addr = msg.sender;
221         
222         // set up our tx event data and determine if player is new or not
223         bool _isNewPlayer = determinePID(_addr);
224         
225         // fetch player id
226         uint256 _pID = pIDxAddr_[_addr];
227         
228         // manage affiliate residuals
229         // if no affiliate code was given or player tried to use their own, lolz
230         uint256 _affID;
231         if (_affCode != address(0) && _affCode != _addr)
232         {
233             // get affiliate ID from aff Code 
234             _affID = pIDxAddr_[_affCode];
235             
236             // if affID is not the same as previously stored 
237             if (_affID != plyr_[_pID].laff)
238             {
239                 // update last affiliate
240                 plyr_[_pID].laff = _affID;
241             }
242         }
243         
244         // register name 
245         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
246     }
247     
248     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
249         isHuman()
250         public
251         payable 
252     {
253         // make sure name fees paid
254         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
255         
256         // filter name + condition checks
257         bytes32 _name = NameFilter.nameFilter(_nameString);
258         
259         // set up address 
260         address _addr = msg.sender;
261         
262         // set up our tx event data and determine if player is new or not
263         bool _isNewPlayer = determinePID(_addr);
264         
265         // fetch player id
266         uint256 _pID = pIDxAddr_[_addr];
267         
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         uint256 _affID;
271         if (_affCode != "" && _affCode != _name)
272         {
273             // get affiliate ID from aff Code 
274             _affID = pIDxName_[_affCode];
275             
276             // if affID is not the same as previously stored 
277             if (_affID != plyr_[_pID].laff)
278             {
279                 // update last affiliate
280                 plyr_[_pID].laff = _affID;
281             }
282         }
283         
284         // register name 
285         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
286     }
287     
288     /**
289      * @dev players, if you registered a profile, before a game was released, or
290      * set the all bool to false when you registered, use this function to push
291      * your profile to a single game.  also, if you've  updated your name, you
292      * can use this to push your name to games of your choosing.
293      * -functionhash- 0x81c5b206
294      * @param _gameID game id 
295      */
296     function addMeToGame(uint256 _gameID)
297         isHuman()
298         public
299     {
300         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
301         address _addr = msg.sender;
302         uint256 _pID = pIDxAddr_[_addr];
303         require(_pID != 0, "hey there buddy, you dont even have an account");
304         uint256 _totalNames = plyr_[_pID].names;
305         
306         // add players profile and most recent name
307         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
308         
309         // add list of all names
310         if (_totalNames > 1)
311             for (uint256 ii = 1; ii <= _totalNames; ii++)
312                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
313     }
314     
315     /**
316      * @dev players, use this to push your player profile to all registered games.
317      * -functionhash- 0x0c6940ea
318      */
319     function addMeToAllGames()
320         isHuman()
321         public
322     {
323         address _addr = msg.sender;
324         uint256 _pID = pIDxAddr_[_addr];
325         require(_pID != 0, "hey there buddy, you dont even have an account");
326         uint256 _laff = plyr_[_pID].laff;
327         uint256 _totalNames = plyr_[_pID].names;
328         bytes32 _name = plyr_[_pID].name;
329         
330         for (uint256 i = 1; i <= gID_; i++)
331         {
332             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
333             if (_totalNames > 1)
334                 for (uint256 ii = 1; ii <= _totalNames; ii++)
335                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
336         }
337                 
338     }
339     
340     /**
341      * @dev players use this to change back to one of your old names.  tip, you'll
342      * still need to push that info to existing games.
343      * -functionhash- 0xb9291296
344      * @param _nameString the name you want to use 
345      */
346     function useMyOldName(string _nameString)
347         isHuman()
348         public 
349     {
350         // filter name, and get pID
351         bytes32 _name = _nameString.nameFilter();
352         uint256 _pID = pIDxAddr_[msg.sender];
353         
354         // make sure they own the name 
355         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
356         
357         // update their current name 
358         plyr_[_pID].name = _name;
359     }
360     
361 //==============================================================================
362 //     _ _  _ _   | _  _ . _  .
363 //    (_(_)| (/_  |(_)(_||(_  . 
364 //=====================_|=======================================================    
365     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
366         private
367     {
368         // if names already has been used, require that current msg sender owns the name
369         if (pIDxName_[_name] != 0)
370             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
371         
372         // add name to player profile, registry, and name book
373         plyr_[_pID].name = _name;
374         pIDxName_[_name] = _pID;
375         if (plyrNames_[_pID][_name] == false)
376         {
377             plyrNames_[_pID][_name] = true;
378             plyr_[_pID].names++;
379             plyrNameList_[_pID][plyr_[_pID].names] = _name;
380         }
381         
382         // registration fee goes directly to community rewards
383         Jekyll_Island_Inc.transfer(address(this).balance);
384         
385         // push player info to games
386         if (_all == true)
387             for (uint256 i = 1; i <= gID_; i++)
388                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
389         
390         // fire event
391         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
392     }
393 //==============================================================================
394 //    _|_ _  _ | _  .
395 //     | (_)(_)|_\  .
396 //==============================================================================    
397     function determinePID(address _addr)
398         private
399         returns (bool)
400     {
401         if (pIDxAddr_[_addr] == 0)
402         {
403             pID_++;
404             pIDxAddr_[_addr] = pID_;
405             plyr_[pID_].addr = _addr;
406             
407             // set the new player bool to true
408             return (true);
409         } else {
410             return (false);
411         }
412     }
413 //==============================================================================
414 //   _   _|_ _  _ _  _ |   _ _ || _  .
415 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
416 //==============================================================================
417     function getPlayerID(address _addr)
418         isRegisteredGame()
419         external
420         returns (uint256)
421     {
422         determinePID(_addr);
423         return (pIDxAddr_[_addr]);
424     }
425     function getPlayerName(uint256 _pID)
426         external
427         view
428         returns (bytes32)
429     {
430         return (plyr_[_pID].name);
431     }
432     function getPlayerLAff(uint256 _pID)
433         external
434         view
435         returns (uint256)
436     {
437         return (plyr_[_pID].laff);
438     }
439     function getPlayerAddr(uint256 _pID)
440         external
441         view
442         returns (address)
443     {
444         return (plyr_[_pID].addr);
445     }
446     function getNameFee()
447         external
448         view
449         returns (uint256)
450     {
451         return(registrationFee_);
452     }
453     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
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
469         // if no affiliate code was given, no new affiliate code was given, or the 
470         // player tried to use their own pID as an affiliate code, lolz
471         uint256 _affID = _affCode;
472         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
473         {
474             // update last affiliate 
475             plyr_[_pID].laff = _affID;
476         } else if (_affID == _pID) {
477             _affID = 0;
478         }
479         
480         // register name 
481         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
482         
483         return(_isNewPlayer, _affID);
484     }
485     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
486         isRegisteredGame()
487         external
488         payable
489         returns(bool, uint256)
490     {
491         // make sure name fees paid
492         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
493         
494         // set up our tx event data and determine if player is new or not
495         bool _isNewPlayer = determinePID(_addr);
496         
497         // fetch player id
498         uint256 _pID = pIDxAddr_[_addr];
499         
500         // manage affiliate residuals
501         // if no affiliate code was given or player tried to use their own, lolz
502         uint256 _affID;
503         if (_affCode != address(0) && _affCode != _addr)
504         {
505             // get affiliate ID from aff Code 
506             _affID = pIDxAddr_[_affCode];
507             
508             // if affID is not the same as previously stored 
509             if (_affID != plyr_[_pID].laff)
510             {
511                 // update last affiliate
512                 plyr_[_pID].laff = _affID;
513             }
514         }
515         
516         // register name 
517         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
518         
519         return(_isNewPlayer, _affID);
520     }
521     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
522         isRegisteredGame()
523         external
524         payable
525         returns(bool, uint256)
526     {
527         // make sure name fees paid
528         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
529         
530         // set up our tx event data and determine if player is new or not
531         bool _isNewPlayer = determinePID(_addr);
532         
533         // fetch player id
534         uint256 _pID = pIDxAddr_[_addr];
535         
536         // manage affiliate residuals
537         // if no affiliate code was given or player tried to use their own, lolz
538         uint256 _affID;
539         if (_affCode != "" && _affCode != _name)
540         {
541             // get affiliate ID from aff Code 
542             _affID = pIDxName_[_affCode];
543             
544             // if affID is not the same as previously stored 
545             if (_affID != plyr_[_pID].laff)
546             {
547                 // update last affiliate
548                 plyr_[_pID].laff = _affID;
549             }
550         }
551         
552         // register name 
553         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
554         
555         return(_isNewPlayer, _affID);
556     }
557     
558 //==============================================================================
559 //   _ _ _|_    _   .
560 //  _\(/_ | |_||_)  .
561 //=============|================================================================
562     function addGame(address _gameAddress, string _gameNameStr)
563         onlyDevs()
564         public
565     {
566         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
567         
568 
569             gID_++;
570             bytes32 _name = _gameNameStr.nameFilter();
571             gameIDs_[_gameAddress] = gID_;
572             gameNames_[_gameAddress] = _name;
573             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
574         
575             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
576             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
577             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
578             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
579         
580     }
581     
582     function setRegistrationFee(uint256 _fee)
583         onlyDevs()
584         public
585     {
586 
587             registrationFee_ = _fee;
588         
589     }
590         
591 } 
592 
593 /**
594 * @title -Name Filter- v0.1.9
595 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
596 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
597 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
598 *                                  _____                      _____
599 *                                 (, /     /)       /) /)    (, /      /)          /)
600 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
601 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
602 *          ┴ ┴                /   /          .-/ _____   (__ /                               
603 *                            (__ /          (_/ (, /                                      /)™ 
604 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
605 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
606 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
607 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
608 *              _       __    _      ____      ____  _   _    _____  ____  ___  
609 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
610 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
611 *
612 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
613 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
614 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
615 */
616 library NameFilter {
617     
618     /**
619      * @dev filters name strings
620      * -converts uppercase to lower case.  
621      * -makes sure it does not start/end with a space
622      * -makes sure it does not contain multiple spaces in a row
623      * -cannot be only numbers
624      * -cannot start with 0x 
625      * -restricts characters to A-Z, a-z, 0-9, and space.
626      * @return reprocessed string in bytes32 format
627      */
628     function nameFilter(string _input)
629         internal
630         pure
631         returns(bytes32)
632     {
633         bytes memory _temp = bytes(_input);
634         uint256 _length = _temp.length;
635         
636         //sorry limited to 32 characters
637         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
638         // make sure it doesnt start with or end with space
639         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
640         // make sure first two characters are not 0x
641         if (_temp[0] == 0x30)
642         {
643             require(_temp[1] != 0x78, "string cannot start with 0x");
644             require(_temp[1] != 0x58, "string cannot start with 0X");
645         }
646         
647         // create a bool to track if we have a non number character
648         bool _hasNonNumber;
649         
650         // convert & check
651         for (uint256 i = 0; i < _length; i++)
652         {
653             // if its uppercase A-Z
654             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
655             {
656                 // convert to lower case a-z
657                 _temp[i] = byte(uint(_temp[i]) + 32);
658                 
659                 // we have a non number
660                 if (_hasNonNumber == false)
661                     _hasNonNumber = true;
662             } else {
663                 require
664                 (
665                     // require character is a space
666                     _temp[i] == 0x20 || 
667                     // OR lowercase a-z
668                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
669                     // or 0-9
670                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
671                     "string contains invalid characters"
672                 );
673                 // make sure theres not 2x spaces in a row
674                 if (_temp[i] == 0x20)
675                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
676                 
677                 // see if we have a character other than a number
678                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
679                     _hasNonNumber = true;    
680             }
681         }
682         
683         require(_hasNonNumber == true, "string cannot be only numbers");
684         
685         bytes32 _ret;
686         assembly {
687             _ret := mload(add(_temp, 32))
688         }
689         return (_ret);
690     }
691 }
692 
693 /**
694  * @title SafeMath v0.1.9
695  * @dev Math operations with safety checks that throw on error
696  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
697  * - added sqrt
698  * - added sq
699  * - added pwr 
700  * - changed asserts to requires with error log outputs
701  * - removed div, its useless
702  */
703 library SafeMath {
704     
705     /**
706     * @dev Multiplies two numbers, throws on overflow.
707     */
708     function mul(uint256 a, uint256 b) 
709         internal 
710         pure 
711         returns (uint256 c) 
712     {
713         if (a == 0) {
714             return 0;
715         }
716         c = a * b;
717         require(c / a == b, "SafeMath mul failed");
718         return c;
719     }
720 
721     /**
722     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b)
725         internal
726         pure
727         returns (uint256) 
728     {
729         require(b <= a, "SafeMath sub failed");
730         return a - b;
731     }
732 
733     /**
734     * @dev Adds two numbers, throws on overflow.
735     */
736     function add(uint256 a, uint256 b)
737         internal
738         pure
739         returns (uint256 c) 
740     {
741         c = a + b;
742         require(c >= a, "SafeMath add failed");
743         return c;
744     }
745     
746     /**
747      * @dev gives square root of given x.
748      */
749     function sqrt(uint256 x)
750         internal
751         pure
752         returns (uint256 y) 
753     {
754         uint256 z = ((add(x,1)) / 2);
755         y = x;
756         while (z < y) 
757         {
758             y = z;
759             z = ((add((x / z),z)) / 2);
760         }
761     }
762     
763     /**
764      * @dev gives square. multiplies x by x
765      */
766     function sq(uint256 x)
767         internal
768         pure
769         returns (uint256)
770     {
771         return (mul(x,x));
772     }
773     
774     /**
775      * @dev x to the power of y 
776      */
777     function pwr(uint256 x, uint256 y)
778         internal 
779         pure 
780         returns (uint256)
781     {
782         if (x==0)
783             return (0);
784         else if (y==0)
785             return (1);
786         else 
787         {
788             uint256 z = x;
789             for (uint256 i=1; i < y; i++)
790                 z = mul(z,x);
791             return (z);
792         }
793     }
794 }