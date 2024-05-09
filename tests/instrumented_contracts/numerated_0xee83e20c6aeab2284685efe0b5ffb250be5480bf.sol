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
72         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
73         plyr_[1].name = "justo";
74         plyr_[1].names = 1;
75         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
76         pIDxName_["justo"] = 1;
77         plyrNames_[1]["justo"] = true;
78         plyrNameList_[1][1] = "justo";
79         
80         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
81         plyr_[2].name = "mantso";
82         plyr_[2].names = 1;
83         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
84         pIDxName_["mantso"] = 2;
85         plyrNames_[2]["mantso"] = true;
86         plyrNameList_[2][1] = "mantso";
87         
88         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
89         plyr_[3].name = "sumpunk";
90         plyr_[3].names = 1;
91         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
92         pIDxName_["sumpunk"] = 3;
93         plyrNames_[3]["sumpunk"] = true;
94         plyrNameList_[3][1] = "sumpunk";
95         
96         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
97         plyr_[4].name = "inventor";
98         plyr_[4].names = 1;
99         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
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
122     
123     modifier isRegisteredGame()
124     {
125         require(gameIDs_[msg.sender] != 0);
126         _;
127     }
128 //==============================================================================
129 //     _    _  _ _|_ _  .
130 //    (/_\/(/_| | | _\  .
131 //==============================================================================    
132     // fired whenever a player registers a name
133     event onNewName
134     (
135         uint256 indexed playerID,
136         address indexed playerAddress,
137         bytes32 indexed playerName,
138         bool isNewPlayer,
139         uint256 affiliateID,
140         address affiliateAddress,
141         bytes32 affiliateName,
142         uint256 amountPaid,
143         uint256 timeStamp
144     );
145 //==============================================================================
146 //     _  _ _|__|_ _  _ _  .
147 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
148 //=====_|=======================================================================
149     function checkIfNameValid(string _nameStr)
150         public
151         view
152         returns(bool)
153     {
154         bytes32 _name = _nameStr.nameFilter();
155         if (pIDxName_[_name] == 0)
156             return (true);
157         else 
158             return (false);
159     }
160 //==============================================================================
161 //     _    |_ |. _   |`    _  __|_. _  _  _  .
162 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
163 //====|=========================================================================    
164     /**
165      * @dev registers a name.  UI will always display the last name you registered.
166      * but you will still own all previously registered names to use as affiliate 
167      * links.
168      * - must pay a registration fee.
169      * - name must be unique
170      * - names will be converted to lowercase
171      * - name cannot start or end with a space 
172      * - cannot have more than 1 space in a row
173      * - cannot be only numbers
174      * - cannot start with 0x 
175      * - name must be at least 1 char
176      * - max length of 32 characters long
177      * - allowed characters: a-z, 0-9, and space
178      * -functionhash- 0x921dec21 (using ID for affiliate)
179      * -functionhash- 0x3ddd4698 (using address for affiliate)
180      * -functionhash- 0x685ffd83 (using name for affiliate)
181      * @param _nameString players desired name
182      * @param _affCode affiliate ID, address, or name of who refered you
183      * @param _all set to true if you want this to push your info to all games 
184      * (this might cost a lot of gas)
185      */
186     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
187         isHuman()
188         public
189         payable 
190     {
191         // make sure name fees paid
192         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
193         
194         // filter name + condition checks
195         bytes32 _name = NameFilter.nameFilter(_nameString);
196         
197         // set up address 
198         address _addr = msg.sender;
199         
200         // set up our tx event data and determine if player is new or not
201         bool _isNewPlayer = determinePID(_addr);
202         
203         // fetch player id
204         uint256 _pID = pIDxAddr_[_addr];
205         
206         // manage affiliate residuals
207         // if no affiliate code was given, no new affiliate code was given, or the 
208         // player tried to use their own pID as an affiliate code, lolz
209         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
210         {
211             // update last affiliate 
212             plyr_[_pID].laff = _affCode;
213         } else if (_affCode == _pID) {
214             _affCode = 0;
215         }
216         
217         // register name 
218         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
219     }
220     
221     function registerNameXaddr(string _nameString, address _affCode, bool _all)
222         isHuman()
223         public
224         payable 
225     {
226         // make sure name fees paid
227         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
228         
229         // filter name + condition checks
230         bytes32 _name = NameFilter.nameFilter(_nameString);
231         
232         // set up address 
233         address _addr = msg.sender;
234         
235         // set up our tx event data and determine if player is new or not
236         bool _isNewPlayer = determinePID(_addr);
237         
238         // fetch player id
239         uint256 _pID = pIDxAddr_[_addr];
240         
241         // manage affiliate residuals
242         // if no affiliate code was given or player tried to use their own, lolz
243         uint256 _affID;
244         if (_affCode != address(0) && _affCode != _addr)
245         {
246             // get affiliate ID from aff Code 
247             _affID = pIDxAddr_[_affCode];
248             
249             // if affID is not the same as previously stored 
250             if (_affID != plyr_[_pID].laff)
251             {
252                 // update last affiliate
253                 plyr_[_pID].laff = _affID;
254             }
255         }
256         
257         // register name 
258         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
259     }
260     
261     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
262         isHuman()
263         public
264         payable 
265     {
266         // make sure name fees paid
267         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
268         
269         // filter name + condition checks
270         bytes32 _name = NameFilter.nameFilter(_nameString);
271         
272         // set up address 
273         address _addr = msg.sender;
274         
275         // set up our tx event data and determine if player is new or not
276         bool _isNewPlayer = determinePID(_addr);
277         
278         // fetch player id
279         uint256 _pID = pIDxAddr_[_addr];
280         
281         // manage affiliate residuals
282         // if no affiliate code was given or player tried to use their own, lolz
283         uint256 _affID;
284         if (_affCode != "" && _affCode != _name)
285         {
286             // get affiliate ID from aff Code 
287             _affID = pIDxName_[_affCode];
288             
289             // if affID is not the same as previously stored 
290             if (_affID != plyr_[_pID].laff)
291             {
292                 // update last affiliate
293                 plyr_[_pID].laff = _affID;
294             }
295         }
296         
297         // register name 
298         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
299     }
300     
301     /**
302      * @dev players, if you registered a profile, before a game was released, or
303      * set the all bool to false when you registered, use this function to push
304      * your profile to a single game.  also, if you've  updated your name, you
305      * can use this to push your name to games of your choosing.
306      * -functionhash- 0x81c5b206
307      * @param _gameID game id 
308      */
309     function addMeToGame(uint256 _gameID)
310         isHuman()
311         public
312     {
313         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
314         address _addr = msg.sender;
315         uint256 _pID = pIDxAddr_[_addr];
316         require(_pID != 0, "hey there buddy, you dont even have an account");
317         uint256 _totalNames = plyr_[_pID].names;
318         
319         // add players profile and most recent name
320         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
321         
322         // add list of all names
323         if (_totalNames > 1)
324             for (uint256 ii = 1; ii <= _totalNames; ii++)
325                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
326     }
327     
328     /**
329      * @dev players, use this to push your player profile to all registered games.
330      * -functionhash- 0x0c6940ea
331      */
332     function addMeToAllGames()
333         isHuman()
334         public
335     {
336         address _addr = msg.sender;
337         uint256 _pID = pIDxAddr_[_addr];
338         require(_pID != 0, "hey there buddy, you dont even have an account");
339         uint256 _laff = plyr_[_pID].laff;
340         uint256 _totalNames = plyr_[_pID].names;
341         bytes32 _name = plyr_[_pID].name;
342         
343         for (uint256 i = 1; i <= gID_; i++)
344         {
345             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
346             if (_totalNames > 1)
347                 for (uint256 ii = 1; ii <= _totalNames; ii++)
348                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
349         }
350                 
351     }
352     
353     /**
354      * @dev players use this to change back to one of your old names.  tip, you'll
355      * still need to push that info to existing games.
356      * -functionhash- 0xb9291296
357      * @param _nameString the name you want to use 
358      */
359     function useMyOldName(string _nameString)
360         isHuman()
361         public 
362     {
363         // filter name, and get pID
364         bytes32 _name = _nameString.nameFilter();
365         uint256 _pID = pIDxAddr_[msg.sender];
366         
367         // make sure they own the name 
368         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
369         
370         // update their current name 
371         plyr_[_pID].name = _name;
372     }
373     
374 //==============================================================================
375 //     _ _  _ _   | _  _ . _  .
376 //    (_(_)| (/_  |(_)(_||(_  . 
377 //=====================_|=======================================================    
378     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
379         private
380     {
381         // if names already has been used, require that current msg sender owns the name
382         if (pIDxName_[_name] != 0)
383             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
384         
385         // add name to player profile, registry, and name book
386         plyr_[_pID].name = _name;
387         pIDxName_[_name] = _pID;
388         if (plyrNames_[_pID][_name] == false)
389         {
390             plyrNames_[_pID][_name] = true;
391             plyr_[_pID].names++;
392             plyrNameList_[_pID][plyr_[_pID].names] = _name;
393         }
394         
395         // registration fee goes directly to community rewards
396         admin.transfer(address(this).balance);
397         
398         // push player info to games
399         if (_all == true)
400             for (uint256 i = 1; i <= gID_; i++)
401                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
402         
403         // fire event
404         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
405     }
406 //==============================================================================
407 //    _|_ _  _ | _  .
408 //     | (_)(_)|_\  .
409 //==============================================================================    
410     function determinePID(address _addr)
411         private
412         returns (bool)
413     {
414         if (pIDxAddr_[_addr] == 0)
415         {
416             pID_++;
417             pIDxAddr_[_addr] = pID_;
418             plyr_[pID_].addr = _addr;
419             
420             // set the new player bool to true
421             return (true);
422         } else {
423             return (false);
424         }
425     }
426 //==============================================================================
427 //   _   _|_ _  _ _  _ |   _ _ || _  .
428 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
429 //==============================================================================
430     function getPlayerID(address _addr)
431         isRegisteredGame()
432         external
433         returns (uint256)
434     {
435         determinePID(_addr);
436         return (pIDxAddr_[_addr]);
437     }
438     function getPlayerName(uint256 _pID)
439         external
440         view
441         returns (bytes32)
442     {
443         return (plyr_[_pID].name);
444     }
445     function getPlayerLAff(uint256 _pID)
446         external
447         view
448         returns (uint256)
449     {
450         return (plyr_[_pID].laff);
451     }
452     function getPlayerAddr(uint256 _pID)
453         external
454         view
455         returns (address)
456     {
457         return (plyr_[_pID].addr);
458     }
459     function getNameFee()
460         external
461         view
462         returns (uint256)
463     {
464         return(registrationFee_);
465     }
466     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
467         isRegisteredGame()
468         external
469         payable
470         returns(bool, uint256)
471     {
472         // make sure name fees paid
473         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
474         
475         // set up our tx event data and determine if player is new or not
476         bool _isNewPlayer = determinePID(_addr);
477         
478         // fetch player id
479         uint256 _pID = pIDxAddr_[_addr];
480         
481         // manage affiliate residuals
482         // if no affiliate code was given, no new affiliate code was given, or the 
483         // player tried to use their own pID as an affiliate code, lolz
484         uint256 _affID = _affCode;
485         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
486         {
487             // update last affiliate 
488             plyr_[_pID].laff = _affID;
489         } else if (_affID == _pID) {
490             _affID = 0;
491         }
492         
493         // register name 
494         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
495         
496         return(_isNewPlayer, _affID);
497     }
498     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
499         isRegisteredGame()
500         external
501         payable
502         returns(bool, uint256)
503     {
504         // make sure name fees paid
505         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
506         
507         // set up our tx event data and determine if player is new or not
508         bool _isNewPlayer = determinePID(_addr);
509         
510         // fetch player id
511         uint256 _pID = pIDxAddr_[_addr];
512         
513         // manage affiliate residuals
514         // if no affiliate code was given or player tried to use their own, lolz
515         uint256 _affID;
516         if (_affCode != address(0) && _affCode != _addr)
517         {
518             // get affiliate ID from aff Code 
519             _affID = pIDxAddr_[_affCode];
520             
521             // if affID is not the same as previously stored 
522             if (_affID != plyr_[_pID].laff)
523             {
524                 // update last affiliate
525                 plyr_[_pID].laff = _affID;
526             }
527         }
528         
529         // register name 
530         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
531         
532         return(_isNewPlayer, _affID);
533     }
534     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
535         isRegisteredGame()
536         external
537         payable
538         returns(bool, uint256)
539     {
540         // make sure name fees paid
541         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
542         
543         // set up our tx event data and determine if player is new or not
544         bool _isNewPlayer = determinePID(_addr);
545         
546         // fetch player id
547         uint256 _pID = pIDxAddr_[_addr];
548         
549         // manage affiliate residuals
550         // if no affiliate code was given or player tried to use their own, lolz
551         uint256 _affID;
552         if (_affCode != "" && _affCode != _name)
553         {
554             // get affiliate ID from aff Code 
555             _affID = pIDxName_[_affCode];
556             
557             // if affID is not the same as previously stored 
558             if (_affID != plyr_[_pID].laff)
559             {
560                 // update last affiliate
561                 plyr_[_pID].laff = _affID;
562             }
563         }
564         
565         // register name 
566         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
567         
568         return(_isNewPlayer, _affID);
569     }
570     
571 //==============================================================================
572 //   _ _ _|_    _   .
573 //  _\(/_ | |_||_)  .
574 //=============|================================================================
575     function addGame(address _gameAddress, string _gameNameStr)
576         public
577     {
578         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
579             gID_++;
580             bytes32 _name = _gameNameStr.nameFilter();
581             gameIDs_[_gameAddress] = gID_;
582             gameNames_[_gameAddress] = _name;
583             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
584         
585             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
586             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
587             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
588             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
589     }
590     
591     function setRegistrationFee(uint256 _fee)
592         public
593     {
594       registrationFee_ = _fee;
595     }
596         
597 } 
598 
599 /**
600 * @title -Name Filter- v0.1.9
601 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
602 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
603 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
604 *                                  _____                      _____
605 *                                 (, /     /)       /) /)    (, /      /)          /)
606 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
607 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
608 *          ┴ ┴                /   /          .-/ _____   (__ /                               
609 *                            (__ /          (_/ (, /                                      /)™ 
610 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
611 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
612 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
613 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
614 *              _       __    _      ____      ____  _   _    _____  ____  ___  
615 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
616 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
617 *
618 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
619 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
620 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
621 */
622 library NameFilter {
623     
624     /**
625      * @dev filters name strings
626      * -converts uppercase to lower case.  
627      * -makes sure it does not start/end with a space
628      * -makes sure it does not contain multiple spaces in a row
629      * -cannot be only numbers
630      * -cannot start with 0x 
631      * -restricts characters to A-Z, a-z, 0-9, and space.
632      * @return reprocessed string in bytes32 format
633      */
634     function nameFilter(string _input)
635         internal
636         pure
637         returns(bytes32)
638     {
639         bytes memory _temp = bytes(_input);
640         uint256 _length = _temp.length;
641         
642         //sorry limited to 32 characters
643         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
644         // make sure it doesnt start with or end with space
645         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
646         // make sure first two characters are not 0x
647         if (_temp[0] == 0x30)
648         {
649             require(_temp[1] != 0x78, "string cannot start with 0x");
650             require(_temp[1] != 0x58, "string cannot start with 0X");
651         }
652         
653         // create a bool to track if we have a non number character
654         bool _hasNonNumber;
655         
656         // convert & check
657         for (uint256 i = 0; i < _length; i++)
658         {
659             // if its uppercase A-Z
660             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
661             {
662                 // convert to lower case a-z
663                 _temp[i] = byte(uint(_temp[i]) + 32);
664                 
665                 // we have a non number
666                 if (_hasNonNumber == false)
667                     _hasNonNumber = true;
668             } else {
669                 require
670                 (
671                     // require character is a space
672                     _temp[i] == 0x20 || 
673                     // OR lowercase a-z
674                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
675                     // or 0-9
676                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
677                     "string contains invalid characters"
678                 );
679                 // make sure theres not 2x spaces in a row
680                 if (_temp[i] == 0x20)
681                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
682                 
683                 // see if we have a character other than a number
684                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
685                     _hasNonNumber = true;    
686             }
687         }
688         
689         require(_hasNonNumber == true, "string cannot be only numbers");
690         
691         bytes32 _ret;
692         assembly {
693             _ret := mload(add(_temp, 32))
694         }
695         return (_ret);
696     }
697 }
698 
699 /**
700  * @title SafeMath v0.1.9
701  * @dev Math operations with safety checks that throw on error
702  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
703  * - added sqrt
704  * - added sq
705  * - added pwr 
706  * - changed asserts to requires with error log outputs
707  * - removed div, its useless
708  */
709 library SafeMath {
710     
711     /**
712     * @dev Multiplies two numbers, throws on overflow.
713     */
714     function mul(uint256 a, uint256 b) 
715         internal 
716         pure 
717         returns (uint256 c) 
718     {
719         if (a == 0) {
720             return 0;
721         }
722         c = a * b;
723         require(c / a == b, "SafeMath mul failed");
724         return c;
725     }
726 
727     /**
728     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
729     */
730     function sub(uint256 a, uint256 b)
731         internal
732         pure
733         returns (uint256) 
734     {
735         require(b <= a, "SafeMath sub failed");
736         return a - b;
737     }
738 
739     /**
740     * @dev Adds two numbers, throws on overflow.
741     */
742     function add(uint256 a, uint256 b)
743         internal
744         pure
745         returns (uint256 c) 
746     {
747         c = a + b;
748         require(c >= a, "SafeMath add failed");
749         return c;
750     }
751     
752     /**
753      * @dev gives square root of given x.
754      */
755     function sqrt(uint256 x)
756         internal
757         pure
758         returns (uint256 y) 
759     {
760         uint256 z = ((add(x,1)) / 2);
761         y = x;
762         while (z < y) 
763         {
764             y = z;
765             z = ((add((x / z),z)) / 2);
766         }
767     }
768     
769     /**
770      * @dev gives square. multiplies x by x
771      */
772     function sq(uint256 x)
773         internal
774         pure
775         returns (uint256)
776     {
777         return (mul(x,x));
778     }
779     
780     /**
781      * @dev x to the power of y 
782      */
783     function pwr(uint256 x, uint256 y)
784         internal 
785         pure 
786         returns (uint256)
787     {
788         if (x==0)
789             return (0);
790         else if (y==0)
791             return (1);
792         else 
793         {
794             uint256 z = x;
795             for (uint256 i=1; i < y; i++)
796                 z = mul(z,x);
797             return (z);
798         }
799     }
800 }