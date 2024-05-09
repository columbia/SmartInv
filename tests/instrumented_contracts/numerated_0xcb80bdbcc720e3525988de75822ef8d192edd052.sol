1 /*
2  * -PlayerBook - v0.3.14
3  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
4  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
5  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
6  *                                  _____                      _____
7  *                                 (, /     /)       /) /)    (, /      /)          /)
8  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
9  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
10  *          ┴ ┴                /   /          .-/ _____   (__ /
11  *                            (__ /          (_/ (, /                                      /)™
12  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
13  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
14  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
15  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
16  *     ______   _                                 ______                 _          
17  *====(_____ \=| |===============================(____  \===============| |=============*
18  *     _____) )| |  _____  _   _  _____   ____    ____)  )  ___    ___  | |  _
19  *    |  ____/ | | (____ || | | || ___ | / ___)  |  __  (  / _ \  / _ \ | |_/ )
20  *    | |      | | / ___ || |_| || ____|| |      | |__)  )| |_| || |_| ||  _ (
21  *====|_|=======\_)\_____|=\__  ||_____)|_|======|______/==\___/==\___/=|_|=\_)=========*
22  *                        (____/
23  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       
24  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │                      
25  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘    
26  */
27 
28 
29 interface PlayerBookReceiverInterface {
30     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
31     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
32 }
33 
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
121     
122     modifier isRegisteredGame()
123     {
124         require(gameIDs_[msg.sender] != 0);
125         _;
126     }
127 //==============================================================================
128 //     _    _  _ _|_ _  .
129 //    (/_\/(/_| | | _\  .
130 //==============================================================================    
131     // fired whenever a player registers a name
132     event onNewName
133     (
134         uint256 indexed playerID,
135         address indexed playerAddress,
136         bytes32 indexed playerName,
137         bool isNewPlayer,
138         uint256 affiliateID,
139         address affiliateAddress,
140         bytes32 affiliateName,
141         uint256 amountPaid,
142         uint256 timeStamp
143     );
144 //==============================================================================
145 //     _  _ _|__|_ _  _ _  .
146 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
147 //=====_|=======================================================================
148     function checkIfNameValid(string _nameStr)
149         public
150         view
151         returns(bool)
152     {
153         bytes32 _name = _nameStr.nameFilter();
154         if (pIDxName_[_name] == 0)
155             return (true);
156         else 
157             return (false);
158     }
159 //==============================================================================
160 //     _    |_ |. _   |`    _  __|_. _  _  _  .
161 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
162 //====|=========================================================================    
163     /**
164      * @dev registers a name.  UI will always display the last name you registered.
165      * but you will still own all previously registered names to use as affiliate 
166      * links.
167      * - must pay a registration fee.
168      * - name must be unique
169      * - names will be converted to lowercase
170      * - name cannot start or end with a space 
171      * - cannot have more than 1 space in a row
172      * - cannot be only numbers
173      * - cannot start with 0x 
174      * - name must be at least 1 char
175      * - max length of 32 characters long
176      * - allowed characters: a-z, 0-9, and space
177      * -functionhash- 0x921dec21 (using ID for affiliate)
178      * -functionhash- 0x3ddd4698 (using address for affiliate)
179      * -functionhash- 0x685ffd83 (using name for affiliate)
180      * @param _nameString players desired name
181      * @param _affCode affiliate ID, address, or name of who refered you
182      * @param _all set to true if you want this to push your info to all games 
183      * (this might cost a lot of gas)
184      */
185     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
186         isHuman()
187         public
188         payable 
189     {
190         // make sure name fees paid
191         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
192         
193         // filter name + condition checks
194         bytes32 _name = NameFilter.nameFilter(_nameString);
195         
196         // set up address 
197         address _addr = msg.sender;
198         
199         // set up our tx event data and determine if player is new or not
200         bool _isNewPlayer = determinePID(_addr);
201         
202         // fetch player id
203         uint256 _pID = pIDxAddr_[_addr];
204         
205         // manage affiliate residuals
206         // if no affiliate code was given, no new affiliate code was given, or the 
207         // player tried to use their own pID as an affiliate code, lolz
208         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
209         {
210             // update last affiliate 
211             plyr_[_pID].laff = _affCode;
212         } else if (_affCode == _pID) {
213             _affCode = 0;
214         }
215         
216         // register name 
217         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
218     }
219     
220     function registerNameXaddr(string _nameString, address _affCode, bool _all)
221         isHuman()
222         public
223         payable 
224     {
225         // make sure name fees paid
226         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
227         
228         // filter name + condition checks
229         bytes32 _name = NameFilter.nameFilter(_nameString);
230         
231         // set up address 
232         address _addr = msg.sender;
233         
234         // set up our tx event data and determine if player is new or not
235         bool _isNewPlayer = determinePID(_addr);
236         
237         // fetch player id
238         uint256 _pID = pIDxAddr_[_addr];
239         
240         // manage affiliate residuals
241         // if no affiliate code was given or player tried to use their own, lolz
242         uint256 _affID;
243         if (_affCode != address(0) && _affCode != _addr)
244         {
245             // get affiliate ID from aff Code 
246             _affID = pIDxAddr_[_affCode];
247             
248             // if affID is not the same as previously stored 
249             if (_affID != plyr_[_pID].laff)
250             {
251                 // update last affiliate
252                 plyr_[_pID].laff = _affID;
253             }
254         }
255         
256         // register name 
257         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
258     }
259     
260     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
261         isHuman()
262         public
263         payable 
264     {
265         // make sure name fees paid
266         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
267         
268         // filter name + condition checks
269         bytes32 _name = NameFilter.nameFilter(_nameString);
270         
271         // set up address 
272         address _addr = msg.sender;
273         
274         // set up our tx event data and determine if player is new or not
275         bool _isNewPlayer = determinePID(_addr);
276         
277         // fetch player id
278         uint256 _pID = pIDxAddr_[_addr];
279         
280         // manage affiliate residuals
281         // if no affiliate code was given or player tried to use their own, lolz
282         uint256 _affID;
283         if (_affCode != "" && _affCode != _name)
284         {
285             // get affiliate ID from aff Code 
286             _affID = pIDxName_[_affCode];
287             
288             // if affID is not the same as previously stored 
289             if (_affID != plyr_[_pID].laff)
290             {
291                 // update last affiliate
292                 plyr_[_pID].laff = _affID;
293             }
294         }
295         
296         // register name 
297         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
298     }
299     
300     /**
301      * @dev players, if you registered a profile, before a game was released, or
302      * set the all bool to false when you registered, use this function to push
303      * your profile to a single game.  also, if you've  updated your name, you
304      * can use this to push your name to games of your choosing.
305      * -functionhash- 0x81c5b206
306      * @param _gameID game id 
307      */
308     function addMeToGame(uint256 _gameID)
309         isHuman()
310         public
311     {
312         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
313         address _addr = msg.sender;
314         uint256 _pID = pIDxAddr_[_addr];
315         require(_pID != 0, "hey there buddy, you dont even have an account");
316         uint256 _totalNames = plyr_[_pID].names;
317         
318         // add players profile and most recent name
319         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
320         
321         // add list of all names
322         if (_totalNames > 1)
323             for (uint256 ii = 1; ii <= _totalNames; ii++)
324                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
325     }
326     
327     /**
328      * @dev players, use this to push your player profile to all registered games.
329      * -functionhash- 0x0c6940ea
330      */
331     function addMeToAllGames()
332         isHuman()
333         public
334     {
335         address _addr = msg.sender;
336         uint256 _pID = pIDxAddr_[_addr];
337         require(_pID != 0, "hey there buddy, you dont even have an account");
338         uint256 _laff = plyr_[_pID].laff;
339         uint256 _totalNames = plyr_[_pID].names;
340         bytes32 _name = plyr_[_pID].name;
341         
342         for (uint256 i = 1; i <= gID_; i++)
343         {
344             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
345             if (_totalNames > 1)
346                 for (uint256 ii = 1; ii <= _totalNames; ii++)
347                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
348         }
349                 
350     }
351     
352     /**
353      * @dev players use this to change back to one of your old names.  tip, you'll
354      * still need to push that info to existing games.
355      * -functionhash- 0xb9291296
356      * @param _nameString the name you want to use 
357      */
358     function useMyOldName(string _nameString)
359         isHuman()
360         public 
361     {
362         // filter name, and get pID
363         bytes32 _name = _nameString.nameFilter();
364         uint256 _pID = pIDxAddr_[msg.sender];
365         
366         // make sure they own the name 
367         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
368         
369         // update their current name 
370         plyr_[_pID].name = _name;
371     }
372     
373 //==============================================================================
374 //     _ _  _ _   | _  _ . _  .
375 //    (_(_)| (/_  |(_)(_||(_  . 
376 //=====================_|=======================================================    
377     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
378         private
379     {
380         // if names already has been used, require that current msg sender owns the name
381         if (pIDxName_[_name] != 0)
382             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
383         
384         // add name to player profile, registry, and name book
385         plyr_[_pID].name = _name;
386         pIDxName_[_name] = _pID;
387         if (plyrNames_[_pID][_name] == false)
388         {
389             plyrNames_[_pID][_name] = true;
390             plyr_[_pID].names++;
391             plyrNameList_[_pID][plyr_[_pID].names] = _name;
392         }
393         
394         // registration fee goes directly to community rewards
395         admin.transfer(address(this).balance);
396         
397         // push player info to games
398         if (_all == true)
399             for (uint256 i = 1; i <= gID_; i++)
400                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
401         
402         // fire event
403         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
404     }
405 //==============================================================================
406 //    _|_ _  _ | _  .
407 //     | (_)(_)|_\  .
408 //==============================================================================    
409     function determinePID(address _addr)
410         private
411         returns (bool)
412     {
413         if (pIDxAddr_[_addr] == 0)
414         {
415             pID_++;
416             pIDxAddr_[_addr] = pID_;
417             plyr_[pID_].addr = _addr;
418             
419             // set the new player bool to true
420             return (true);
421         } else {
422             return (false);
423         }
424     }
425 //==============================================================================
426 //   _   _|_ _  _ _  _ |   _ _ || _  .
427 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
428 //==============================================================================
429     function getPlayerID(address _addr)
430         isRegisteredGame()
431         external
432         returns (uint256)
433     {
434         determinePID(_addr);
435         return (pIDxAddr_[_addr]);
436     }
437     function getPlayerName(uint256 _pID)
438         external
439         view
440         returns (bytes32)
441     {
442         return (plyr_[_pID].name);
443     }
444     function getPlayerLAff(uint256 _pID)
445         external
446         view
447         returns (uint256)
448     {
449         return (plyr_[_pID].laff);
450     }
451     function getPlayerAddr(uint256 _pID)
452         external
453         view
454         returns (address)
455     {
456         return (plyr_[_pID].addr);
457     }
458     function getNameFee()
459         external
460         view
461         returns (uint256)
462     {
463         return(registrationFee_);
464     }
465     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
466         isRegisteredGame()
467         external
468         payable
469         returns(bool, uint256)
470     {
471         // make sure name fees paid
472         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
473         
474         // set up our tx event data and determine if player is new or not
475         bool _isNewPlayer = determinePID(_addr);
476         
477         // fetch player id
478         uint256 _pID = pIDxAddr_[_addr];
479         
480         // manage affiliate residuals
481         // if no affiliate code was given, no new affiliate code was given, or the 
482         // player tried to use their own pID as an affiliate code, lolz
483         uint256 _affID = _affCode;
484         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
485         {
486             // update last affiliate 
487             plyr_[_pID].laff = _affID;
488         } else if (_affID == _pID) {
489             _affID = 0;
490         }
491         
492         // register name 
493         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
494         
495         return(_isNewPlayer, _affID);
496     }
497     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
498         isRegisteredGame()
499         external
500         payable
501         returns(bool, uint256)
502     {
503         // make sure name fees paid
504         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
505         
506         // set up our tx event data and determine if player is new or not
507         bool _isNewPlayer = determinePID(_addr);
508         
509         // fetch player id
510         uint256 _pID = pIDxAddr_[_addr];
511         
512         // manage affiliate residuals
513         // if no affiliate code was given or player tried to use their own, lolz
514         uint256 _affID;
515         if (_affCode != address(0) && _affCode != _addr)
516         {
517             // get affiliate ID from aff Code 
518             _affID = pIDxAddr_[_affCode];
519             
520             // if affID is not the same as previously stored 
521             if (_affID != plyr_[_pID].laff)
522             {
523                 // update last affiliate
524                 plyr_[_pID].laff = _affID;
525             }
526         }
527         
528         // register name 
529         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
530         
531         return(_isNewPlayer, _affID);
532     }
533     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
534         isRegisteredGame()
535         external
536         payable
537         returns(bool, uint256)
538     {
539         // make sure name fees paid
540         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
541         
542         // set up our tx event data and determine if player is new or not
543         bool _isNewPlayer = determinePID(_addr);
544         
545         // fetch player id
546         uint256 _pID = pIDxAddr_[_addr];
547         
548         // manage affiliate residuals
549         // if no affiliate code was given or player tried to use their own, lolz
550         uint256 _affID;
551         if (_affCode != "" && _affCode != _name)
552         {
553             // get affiliate ID from aff Code 
554             _affID = pIDxName_[_affCode];
555             
556             // if affID is not the same as previously stored 
557             if (_affID != plyr_[_pID].laff)
558             {
559                 // update last affiliate
560                 plyr_[_pID].laff = _affID;
561             }
562         }
563         
564         // register name 
565         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
566         
567         return(_isNewPlayer, _affID);
568     }
569     
570 //==============================================================================
571 //   _ _ _|_    _   .
572 //  _\(/_ | |_||_)  .
573 //=============|================================================================
574     function addGame(address _gameAddress, string _gameNameStr)
575         public
576     {
577         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
578             gID_++;
579             bytes32 _name = _gameNameStr.nameFilter();
580             gameIDs_[_gameAddress] = gID_;
581             gameNames_[_gameAddress] = _name;
582             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
583         
584             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
585             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
586             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
587             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
588     }
589     
590     function setRegistrationFee(uint256 _fee)
591         public
592     {
593       registrationFee_ = _fee;
594     }
595         
596 } 
597 
598 /**
599 * @title -Name Filter- v0.1.9
600 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
601 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
602 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
603 *                                  _____                      _____
604 *                                 (, /     /)       /) /)    (, /      /)          /)
605 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
606 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
607 *          ┴ ┴                /   /          .-/ _____   (__ /                               
608 *                            (__ /          (_/ (, /                                      /)™ 
609 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
610 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
611 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
612 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
613 *              _       __    _      ____      ____  _   _    _____  ____  ___  
614 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
615 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
616 *
617 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
618 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
619 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
620 */
621 library NameFilter {
622     
623     /**
624      * @dev filters name strings
625      * -converts uppercase to lower case.  
626      * -makes sure it does not start/end with a space
627      * -makes sure it does not contain multiple spaces in a row
628      * -cannot be only numbers
629      * -cannot start with 0x 
630      * -restricts characters to A-Z, a-z, 0-9, and space.
631      * @return reprocessed string in bytes32 format
632      */
633     function nameFilter(string _input)
634         internal
635         pure
636         returns(bytes32)
637     {
638         bytes memory _temp = bytes(_input);
639         uint256 _length = _temp.length;
640         
641         //sorry limited to 32 characters
642         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
643         // make sure it doesnt start with or end with space
644         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
645         // make sure first two characters are not 0x
646         if (_temp[0] == 0x30)
647         {
648             require(_temp[1] != 0x78, "string cannot start with 0x");
649             require(_temp[1] != 0x58, "string cannot start with 0X");
650         }
651         
652         // create a bool to track if we have a non number character
653         bool _hasNonNumber;
654         
655         // convert & check
656         for (uint256 i = 0; i < _length; i++)
657         {
658             // if its uppercase A-Z
659             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
660             {
661                 // convert to lower case a-z
662                 _temp[i] = byte(uint(_temp[i]) + 32);
663                 
664                 // we have a non number
665                 if (_hasNonNumber == false)
666                     _hasNonNumber = true;
667             } else {
668                 require
669                 (
670                     // require character is a space
671                     _temp[i] == 0x20 || 
672                     // OR lowercase a-z
673                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
674                     // or 0-9
675                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
676                     "string contains invalid characters"
677                 );
678                 // make sure theres not 2x spaces in a row
679                 if (_temp[i] == 0x20)
680                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
681                 
682                 // see if we have a character other than a number
683                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
684                     _hasNonNumber = true;    
685             }
686         }
687         
688         require(_hasNonNumber == true, "string cannot be only numbers");
689         
690         bytes32 _ret;
691         assembly {
692             _ret := mload(add(_temp, 32))
693         }
694         return (_ret);
695     }
696 }
697 
698 /**
699  * @title SafeMath v0.1.9
700  * @dev Math operations with safety checks that throw on error
701  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
702  * - added sqrt
703  * - added sq
704  * - added pwr 
705  * - changed asserts to requires with error log outputs
706  * - removed div, its useless
707  */
708 library SafeMath {
709     
710     /**
711     * @dev Multiplies two numbers, throws on overflow.
712     */
713     function mul(uint256 a, uint256 b) 
714         internal 
715         pure 
716         returns (uint256 c) 
717     {
718         if (a == 0) {
719             return 0;
720         }
721         c = a * b;
722         require(c / a == b, "SafeMath mul failed");
723         return c;
724     }
725 
726     /**
727     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
728     */
729     function sub(uint256 a, uint256 b)
730         internal
731         pure
732         returns (uint256) 
733     {
734         require(b <= a, "SafeMath sub failed");
735         return a - b;
736     }
737 
738     /**
739     * @dev Adds two numbers, throws on overflow.
740     */
741     function add(uint256 a, uint256 b)
742         internal
743         pure
744         returns (uint256 c) 
745     {
746         c = a + b;
747         require(c >= a, "SafeMath add failed");
748         return c;
749     }
750     
751     /**
752      * @dev gives square root of given x.
753      */
754     function sqrt(uint256 x)
755         internal
756         pure
757         returns (uint256 y) 
758     {
759         uint256 z = ((add(x,1)) / 2);
760         y = x;
761         while (z < y) 
762         {
763             y = z;
764             z = ((add((x / z),z)) / 2);
765         }
766     }
767     
768     /**
769      * @dev gives square. multiplies x by x
770      */
771     function sq(uint256 x)
772         internal
773         pure
774         returns (uint256)
775     {
776         return (mul(x,x));
777     }
778     
779     /**
780      * @dev x to the power of y 
781      */
782     function pwr(uint256 x, uint256 y)
783         internal 
784         pure 
785         returns (uint256)
786     {
787         if (x==0)
788             return (0);
789         else if (y==0)
790             return (1);
791         else 
792         {
793             uint256 z = x;
794             for (uint256 i=1; i < y; i++)
795                 z = mul(z,x);
796             return (z);
797         }
798     }
799 }