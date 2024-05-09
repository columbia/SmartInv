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
28 // JIincForwarderInterface is not needed in our contract.
29 
30 interface PlayerBookReceiverInterface {
31     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
32     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
33 }
34 
35 contract PlayerBook {
36     using NameFilter for string;
37     using SafeMath for uint256;
38     
39     address private admin = msg.sender;
40 //==============================================================================
41 //     _| _ _|_ _    _ _ _|_    _   .
42 //    (_|(_| | (_|  _\(/_ | |_||_)  .
43 //=============================|================================================    
44     uint256 public registrationFee_ = 10 finney;            // price to register a name
45     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
46     mapping(address => bytes32) public gameNames_;          // lookup a games name
47     mapping(address => uint256) public gameIDs_;            // lokup a games ID
48     uint256 public gID_;        // total number of games
49     uint256 public pID_;        // total number of players
50     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
51     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
52     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
53     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
54     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
55     struct Player {
56         address addr;
57         bytes32 name;
58         uint256 laff;
59         uint256 names;
60     }
61 //==============================================================================
62 //     _ _  _  __|_ _    __|_ _  _  .
63 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
64 //==============================================================================    
65     constructor()
66         public
67     {
68         // premine the dev names (sorry not sorry)
69             // No keys are purchased with this method, it's simply locking our addresses,
70             // PID's and names for referral codes.
71         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
72         plyr_[1].name = "justo";
73         plyr_[1].names = 1;
74         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
75         pIDxName_["justo"] = 1;
76         plyrNames_[1]["justo"] = true;
77         plyrNameList_[1][1] = "justo";
78         
79         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
80         plyr_[2].name = "mantso";
81         plyr_[2].names = 1;
82         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
83         pIDxName_["mantso"] = 2;
84         plyrNames_[2]["mantso"] = true;
85         plyrNameList_[2][1] = "mantso";
86         
87         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
88         plyr_[3].name = "sumpunk";
89         plyr_[3].names = 1;
90         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
91         pIDxName_["sumpunk"] = 3;
92         plyrNames_[3]["sumpunk"] = true;
93         plyrNameList_[3][1] = "sumpunk";
94         
95         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
96         plyr_[4].name = "inventor";
97         plyr_[4].names = 1;
98         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
99         pIDxName_["inventor"] = 4;
100         plyrNames_[4]["inventor"] = true;
101         plyrNameList_[4][1] = "inventor";
102         
103         pID_ = 4;
104     }
105 //==============================================================================
106 //     _ _  _  _|. |`. _  _ _  .
107 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
108 //==============================================================================    
109     /**
110      * @dev prevents contracts from interacting with fomo3d 
111      */
112     modifier isHuman() {
113         address _addr = msg.sender;
114         uint256 _codeLength;
115         
116         assembly {_codeLength := extcodesize(_addr)}
117         require(_codeLength == 0, "sorry humans only");
118         _;
119     }
120    
121     modifier onlyDevs()
122         {
123         require(msg.sender == admin);
124         _;
125     } 
126     
127     modifier isRegisteredGame()
128     {
129         require(gameIDs_[msg.sender] != 0);
130         _;
131     }
132 //==============================================================================
133 //     _    _  _ _|_ _  .
134 //    (/_\/(/_| | | _\  .
135 //==============================================================================    
136     // fired whenever a player registers a name
137     event onNewName
138     (
139         uint256 indexed playerID,
140         address indexed playerAddress,
141         bytes32 indexed playerName,
142         bool isNewPlayer,
143         uint256 affiliateID,
144         address affiliateAddress,
145         bytes32 affiliateName,
146         uint256 amountPaid,
147         uint256 timeStamp
148     );
149 //==============================================================================
150 //     _  _ _|__|_ _  _ _  .
151 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
152 //=====_|=======================================================================
153     function checkIfNameValid(string _nameStr)
154         public
155         view
156         returns(bool)
157     {
158         bytes32 _name = _nameStr.nameFilter();
159         if (pIDxName_[_name] == 0)
160             return (true);
161         else 
162             return (false);
163     }
164 //==============================================================================
165 //     _    |_ |. _   |`    _  __|_. _  _  _  .
166 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
167 //====|=========================================================================    
168     /**
169      * @dev registers a name.  UI will always display the last name you registered.
170      * but you will still own all previously registered names to use as affiliate 
171      * links.
172      * - must pay a registration fee.
173      * - name must be unique
174      * - names will be converted to lowercase
175      * - name cannot start or end with a space 
176      * - cannot have more than 1 space in a row
177      * - cannot be only numbers
178      * - cannot start with 0x 
179      * - name must be at least 1 char
180      * - max length of 32 characters long
181      * - allowed characters: a-z, 0-9, and space
182      * -functionhash- 0x921dec21 (using ID for affiliate)
183      * -functionhash- 0x3ddd4698 (using address for affiliate)
184      * -functionhash- 0x685ffd83 (using name for affiliate)
185      * @param _nameString players desired name
186      * @param _affCode affiliate ID, address, or name of who refered you
187      * @param _all set to true if you want this to push your info to all games 
188      * (this might cost a lot of gas)
189      */
190     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
191         isHuman()
192         public
193         payable 
194     {
195         
196         // filter name + condition checks
197         bytes32 _name = NameFilter.nameFilter(_nameString);
198         
199         // set up address 
200         address _addr = msg.sender;
201         
202         // set up our tx event data and determine if player is new or not
203         bool _isNewPlayer = determinePID(_addr);
204         
205         // fetch player id
206         uint256 _pID = pIDxAddr_[_addr];
207         
208         // manage affiliate residuals
209         // if no affiliate code was given, no new affiliate code was given, or the 
210         // player tried to use their own pID as an affiliate code, lolz
211         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
212         {
213             // update last affiliate 
214             plyr_[_pID].laff = _affCode;
215         } else if (_affCode == _pID) {
216             _affCode = 0;
217         }
218         
219         // register name 
220         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
221     }
222     
223     function registerNameXaddr(string _nameString, address _affCode, bool _all)
224         isHuman()
225         public
226         payable 
227     {
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
266         
267         // filter name + condition checks
268         bytes32 _name = NameFilter.nameFilter(_nameString);
269         
270         // set up address 
271         address _addr = msg.sender;
272         
273         // set up our tx event data and determine if player is new or not
274         bool _isNewPlayer = determinePID(_addr);
275         
276         // fetch player id
277         uint256 _pID = pIDxAddr_[_addr];
278         
279         // manage affiliate residuals
280         // if no affiliate code was given or player tried to use their own, lolz
281         uint256 _affID;
282         if (_affCode != "" && _affCode != _name)
283         {
284             // get affiliate ID from aff Code 
285             _affID = pIDxName_[_affCode];
286             
287             // if affID is not the same as previously stored 
288             if (_affID != plyr_[_pID].laff)
289             {
290                 // update last affiliate
291                 plyr_[_pID].laff = _affID;
292             }
293         }
294         
295         // register name 
296         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
297     }
298     
299     /**
300      * @dev players, if you registered a profile, before a game was released, or
301      * set the all bool to false when you registered, use this function to push
302      * your profile to a single game.  also, if you've  updated your name, you
303      * can use this to push your name to games of your choosing.
304      * -functionhash- 0x81c5b206
305      * @param _gameID game id 
306      */
307     function addMeToGame(uint256 _gameID)
308         isHuman()
309         public
310     {
311         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
312         address _addr = msg.sender;
313         uint256 _pID = pIDxAddr_[_addr];
314         require(_pID != 0, "hey there buddy, you dont even have an account");
315         uint256 _totalNames = plyr_[_pID].names;
316         
317         // add players profile and most recent name
318         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
319         
320         // add list of all names
321         if (_totalNames > 1)
322             for (uint256 ii = 1; ii <= _totalNames; ii++)
323                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
324     }
325     
326     /**
327      * @dev players, use this to push your player profile to all registered games.
328      * -functionhash- 0x0c6940ea
329      */
330     function addMeToAllGames()
331         isHuman()
332         public
333     {
334         address _addr = msg.sender;
335         uint256 _pID = pIDxAddr_[_addr];
336         require(_pID != 0, "hey there buddy, you dont even have an account");
337         uint256 _laff = plyr_[_pID].laff;
338         uint256 _totalNames = plyr_[_pID].names;
339         bytes32 _name = plyr_[_pID].name;
340         
341         for (uint256 i = 1; i <= gID_; i++)
342         {
343             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
344             if (_totalNames > 1)
345                 for (uint256 ii = 1; ii <= _totalNames; ii++)
346                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
347         }
348                 
349     }
350     
351     /**
352      * @dev players use this to change back to one of your old names.  tip, you'll
353      * still need to push that info to existing games.
354      * -functionhash- 0xb9291296
355      * @param _nameString the name you want to use 
356      */
357     function useMyOldName(string _nameString)
358         isHuman()
359         public 
360     {
361         // filter name, and get pID
362         bytes32 _name = _nameString.nameFilter();
363         uint256 _pID = pIDxAddr_[msg.sender];
364         
365         // make sure they own the name 
366         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
367         
368         // update their current name 
369         plyr_[_pID].name = _name;
370     }
371     
372 //==============================================================================
373 //     _ _  _ _   | _  _ . _  .
374 //    (_(_)| (/_  |(_)(_||(_  . 
375 //=====================_|=======================================================    
376     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
377         private
378     {
379         // if names already has been used, require that current msg sender owns the name
380         if (pIDxName_[_name] != 0)
381             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
382         
383         // add name to player profile, registry, and name book
384         plyr_[_pID].name = _name;
385         pIDxName_[_name] = _pID;
386         if (plyrNames_[_pID][_name] == false)
387         {
388             plyrNames_[_pID][_name] = true;
389             plyr_[_pID].names++;
390             plyrNameList_[_pID][plyr_[_pID].names] = _name;
391         }
392         
393         // push player info to games
394         if (_all == true)
395             for (uint256 i = 1; i <= gID_; i++)
396                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
397         
398         // fire event
399         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
400     }
401 //==============================================================================
402 //    _|_ _  _ | _  .
403 //     | (_)(_)|_\  .
404 //==============================================================================    
405     function determinePID(address _addr)
406         private
407         returns (bool)
408     {
409         if (pIDxAddr_[_addr] == 0)
410         {
411             pID_++;
412             pIDxAddr_[_addr] = pID_;
413             plyr_[pID_].addr = _addr;
414             
415             // set the new player bool to true
416             return (true);
417         } else {
418             return (false);
419         }
420     }
421 //==============================================================================
422 //   _   _|_ _  _ _  _ |   _ _ || _  .
423 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
424 //==============================================================================
425     function getPlayerID(address _addr)
426         isRegisteredGame()
427         external
428         returns (uint256)
429     {
430         determinePID(_addr);
431         return (pIDxAddr_[_addr]);
432     }
433     function getPlayerName(uint256 _pID)
434         external
435         view
436         returns (bytes32)
437     {
438         return (plyr_[_pID].name);
439     }
440     function getPlayerLAff(uint256 _pID)
441         external
442         view
443         returns (uint256)
444     {
445         return (plyr_[_pID].laff);
446     }
447     function getPlayerAddr(uint256 _pID)
448         external
449         view
450         returns (address)
451     {
452         return (plyr_[_pID].addr);
453     }
454     function getNameFee()
455         external
456         view
457         returns (uint256)
458     {
459         return(registrationFee_);
460     }
461     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
462         isRegisteredGame()
463         external
464         payable
465         returns(bool, uint256)
466     {
467         
468         // set up our tx event data and determine if player is new or not
469         bool _isNewPlayer = determinePID(_addr);
470         
471         // fetch player id
472         uint256 _pID = pIDxAddr_[_addr];
473         
474         // manage affiliate residuals
475         // if no affiliate code was given, no new affiliate code was given, or the 
476         // player tried to use their own pID as an affiliate code, lolz
477         uint256 _affID = _affCode;
478         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
479         {
480             // update last affiliate 
481             plyr_[_pID].laff = _affID;
482         } else if (_affID == _pID) {
483             _affID = 0;
484         }
485         
486         // register name 
487         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
488         
489         return(_isNewPlayer, _affID);
490     }
491     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
492         isRegisteredGame()
493         external
494         payable
495         returns(bool, uint256)
496     {
497         
498         // set up our tx event data and determine if player is new or not
499         bool _isNewPlayer = determinePID(_addr);
500         
501         // fetch player id
502         uint256 _pID = pIDxAddr_[_addr];
503         
504         // manage affiliate residuals
505         // if no affiliate code was given or player tried to use their own, lolz
506         uint256 _affID;
507         if (_affCode != address(0) && _affCode != _addr)
508         {
509             // get affiliate ID from aff Code 
510             _affID = pIDxAddr_[_affCode];
511             
512             // if affID is not the same as previously stored 
513             if (_affID != plyr_[_pID].laff)
514             {
515                 // update last affiliate
516                 plyr_[_pID].laff = _affID;
517             }
518         }
519         
520         // register name 
521         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
522         
523         return(_isNewPlayer, _affID);
524     }
525     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
526         isRegisteredGame()
527         external
528         payable
529         returns(bool, uint256)
530     {
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
568             gID_++;
569             bytes32 _name = _gameNameStr.nameFilter();
570             gameIDs_[_gameAddress] = gID_;
571             gameNames_[_gameAddress] = _name;
572             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
573         
574             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
575             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
576             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
577             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
578     }
579     
580     function setRegistrationFee(uint256 _fee)
581         onlyDevs()
582         public
583     {
584       registrationFee_ = _fee;
585     }
586         
587 } 
588 
589 /**
590 * @title -Name Filter- v0.1.9
591 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
592 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
593 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
594 *                                  _____                      _____
595 *                                 (, /     /)       /) /)    (, /      /)          /)
596 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
597 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
598 *          ┴ ┴                /   /          .-/ _____   (__ /                               
599 *                            (__ /          (_/ (, /                                      /)™ 
600 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
601 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
602 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
603 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
604 *              _       __    _      ____      ____  _   _    _____  ____  ___  
605 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
606 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
607 *
608 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
609 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
610 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
611 */
612 library NameFilter {
613     
614     /**
615      * @dev filters name strings
616      * -converts uppercase to lower case.  
617      * -makes sure it does not start/end with a space
618      * -makes sure it does not contain multiple spaces in a row
619      * -cannot be only numbers
620      * -cannot start with 0x 
621      * -restricts characters to A-Z, a-z, 0-9, and space.
622      * @return reprocessed string in bytes32 format
623      */
624     function nameFilter(string _input)
625         internal
626         pure
627         returns(bytes32)
628     {
629         bytes memory _temp = bytes(_input);
630         uint256 _length = _temp.length;
631         
632         //sorry limited to 32 characters
633         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
634         // make sure it doesnt start with or end with space
635         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
636         // make sure first two characters are not 0x
637         if (_temp[0] == 0x30)
638         {
639             require(_temp[1] != 0x78, "string cannot start with 0x");
640             require(_temp[1] != 0x58, "string cannot start with 0X");
641         }
642         
643         // create a bool to track if we have a non number character
644         bool _hasNonNumber;
645         
646         // convert & check
647         for (uint256 i = 0; i < _length; i++)
648         {
649             // if its uppercase A-Z
650             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
651             {
652                 // convert to lower case a-z
653                 _temp[i] = byte(uint(_temp[i]) + 32);
654                 
655                 // we have a non number
656                 if (_hasNonNumber == false)
657                     _hasNonNumber = true;
658             } else {
659                 require
660                 (
661                     // require character is a space
662                     _temp[i] == 0x20 || 
663                     // OR lowercase a-z
664                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
665                     // or 0-9
666                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
667                     "string contains invalid characters"
668                 );
669                 // make sure theres not 2x spaces in a row
670                 if (_temp[i] == 0x20)
671                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
672                 
673                 // see if we have a character other than a number
674                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
675                     _hasNonNumber = true;    
676             }
677         }
678         
679         require(_hasNonNumber == true, "string cannot be only numbers");
680         
681         bytes32 _ret;
682         assembly {
683             _ret := mload(add(_temp, 32))
684         }
685         return (_ret);
686     }
687 }
688 
689 /**
690  * @title SafeMath v0.1.9
691  * @dev Math operations with safety checks that throw on error
692  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
693  * - added sqrt
694  * - added sq
695  * - added pwr 
696  * - changed asserts to requires with error log outputs
697  * - removed div, its useless
698  */
699 library SafeMath {
700     
701     /**
702     * @dev Multiplies two numbers, throws on overflow.
703     */
704     function mul(uint256 a, uint256 b) 
705         internal 
706         pure 
707         returns (uint256 c) 
708     {
709         if (a == 0) {
710             return 0;
711         }
712         c = a * b;
713         require(c / a == b, "SafeMath mul failed");
714         return c;
715     }
716 
717     /**
718     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
719     */
720     function sub(uint256 a, uint256 b)
721         internal
722         pure
723         returns (uint256) 
724     {
725         require(b <= a, "SafeMath sub failed");
726         return a - b;
727     }
728 
729     /**
730     * @dev Adds two numbers, throws on overflow.
731     */
732     function add(uint256 a, uint256 b)
733         internal
734         pure
735         returns (uint256 c) 
736     {
737         c = a + b;
738         require(c >= a, "SafeMath add failed");
739         return c;
740     }
741     
742     /**
743      * @dev gives square root of given x.
744      */
745     function sqrt(uint256 x)
746         internal
747         pure
748         returns (uint256 y) 
749     {
750         uint256 z = ((add(x,1)) / 2);
751         y = x;
752         while (z < y) 
753         {
754             y = z;
755             z = ((add((x / z),z)) / 2);
756         }
757     }
758     
759     /**
760      * @dev gives square. multiplies x by x
761      */
762     function sq(uint256 x)
763         internal
764         pure
765         returns (uint256)
766     {
767         return (mul(x,x));
768     }
769     
770     /**
771      * @dev x to the power of y 
772      */
773     function pwr(uint256 x, uint256 y)
774         internal 
775         pure 
776         returns (uint256)
777     {
778         if (x==0)
779             return (0);
780         else if (y==0)
781             return (1);
782         else 
783         {
784             uint256 z = x;
785             for (uint256 i=1; i < y; i++)
786                 z = mul(z,x);
787             return (z);
788         }
789     }
790 }