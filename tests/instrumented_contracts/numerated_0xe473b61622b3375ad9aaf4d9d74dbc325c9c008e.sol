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
41     address private yyyy;
42     address private gggg;
43     
44 //==============================================================================
45 //     _| _ _|_ _    _ _ _|_    _   .
46 //    (_|(_| | (_|  _\(/_ | |_||_)  .
47 //=============================|================================================    
48     uint256 public registrationFee_ = 10 finney;            // price to register a name
49     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
50     mapping(address => bytes32) public gameNames_;          // lookup a games name
51     mapping(address => uint256) public gameIDs_;            // lokup a games ID
52     uint256 public gID_;        // total number of games
53     uint256 public pID_;        // total number of players
54     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
55     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
56     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
57     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
58     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
59     struct Player {
60         address addr;
61         bytes32 name;
62         uint256 laff;
63         uint256 names;
64     }
65 //==============================================================================
66 //     _ _  _  __|_ _    __|_ _  _  .
67 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
68 //==============================================================================    
69     constructor(address _yyyy, address _gggg)
70         public
71     {
72         yyyy = _yyyy;
73         gggg = _gggg;
74         
75         pID_ = 10000;
76     }
77 //==============================================================================
78 //     _ _  _  _|. |`. _  _ _  .
79 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
80 //==============================================================================    
81     /**
82      * @dev prevents contracts from interacting with fomo3d 
83      */
84     modifier isHuman() {
85         address _addr = msg.sender;
86         uint256 _codeLength;
87         
88         assembly {_codeLength := extcodesize(_addr)}
89         require(_codeLength == 0, "sorry humans only");
90         _;
91     }
92 
93     modifier onlyDevs() 
94     {
95         require(admin == msg.sender, "msg sender is not a dev");
96         _;
97     }
98     
99     modifier isRegisteredGame()
100     {
101         require(gameIDs_[msg.sender] != 0);
102         _;
103     }
104 //==============================================================================
105 //     _    _  _ _|_ _  .
106 //    (/_\/(/_| | | _\  .
107 //==============================================================================    
108     // fired whenever a player registers a name
109     event onNewName
110     (
111         uint256 indexed playerID,
112         address indexed playerAddress,
113         bytes32 indexed playerName,
114         bool isNewPlayer,
115         uint256 affiliateID,
116         address affiliateAddress,
117         bytes32 affiliateName,
118         uint256 amountPaid,
119         uint256 timeStamp
120     );
121 //==============================================================================
122 //     _  _ _|__|_ _  _ _  .
123 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
124 //=====_|=======================================================================
125     function checkIfNameValid(string _nameStr)
126         public
127         view
128         returns(bool)
129     {
130         bytes32 _name = _nameStr.nameFilter();
131         if (pIDxName_[_name] == 0)
132             return (true);
133         else 
134             return (false);
135     }
136 //==============================================================================
137 //     _    |_ |. _   |`    _  __|_. _  _  _  .
138 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
139 //====|=========================================================================    
140     /**
141      * @dev registers a name.  UI will always display the last name you registered.
142      * but you will still own all previously registered names to use as affiliate 
143      * links.
144      * - must pay a registration fee.
145      * - name must be unique
146      * - names will be converted to lowercase
147      * - name cannot start or end with a space 
148      * - cannot have more than 1 space in a row
149      * - cannot be only numbers
150      * - cannot start with 0x 
151      * - name must be at least 1 char
152      * - max length of 32 characters long
153      * - allowed characters: a-z, 0-9, and space
154      * -functionhash- 0x921dec21 (using ID for affiliate)
155      * -functionhash- 0x3ddd4698 (using address for affiliate)
156      * -functionhash- 0x685ffd83 (using name for affiliate)
157      * @param _nameString players desired name
158      * @param _affCode affiliate ID, address, or name of who refered you
159      * @param _all set to true if you want this to push your info to all games 
160      * (this might cost a lot of gas)
161      */
162     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
163         isHuman()
164         public
165         payable 
166     {
167         // make sure name fees paid
168         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
169         
170         // filter name + condition checks
171         bytes32 _name = NameFilter.nameFilter(_nameString);
172         
173         // set up address 
174         address _addr = msg.sender;
175         
176         // set up our tx event data and determine if player is new or not
177         bool _isNewPlayer = determinePID(_addr);
178         
179         // fetch player id
180         uint256 _pID = pIDxAddr_[_addr];
181         
182         // manage affiliate residuals
183         // if no affiliate code was given, no new affiliate code was given, or the 
184         // player tried to use their own pID as an affiliate code, lolz
185         if (plyr_[_pID].laff == 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
186         {
187             // update last affiliate 
188             plyr_[_pID].laff = _affCode;
189         } 
190         _affCode = plyr_[_pID].laff;
191 
192         // register name 
193         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
194     }
195     
196     function registerNameXaddr(string _nameString, address _affCode, bool _all)
197         isHuman()
198         public
199         payable 
200     {
201         // make sure name fees paid
202         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
203         
204         // filter name + condition checks
205         bytes32 _name = NameFilter.nameFilter(_nameString);
206         
207         // set up address 
208         address _addr = msg.sender;
209         
210         // set up our tx event data and determine if player is new or not
211         bool _isNewPlayer = determinePID(_addr);
212         
213         // fetch player id
214         uint256 _pID = pIDxAddr_[_addr];
215         
216         // manage affiliate residuals
217         // if no affiliate code was given or player tried to use their own, lolz
218         uint256 _affID;
219         // get affiliate ID from aff Code 
220         _affID = pIDxAddr_[_affCode];
221             
222         // if affID is not the same as previously stored 
223         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff != 0)
224         {
225                 // update last affiliate
226                 plyr_[_pID].laff = _affID;
227         }
228         _affID = plyr_[_pID].laff;
229         
230         // register name 
231         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
232     }
233     
234     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
235         isHuman()
236         public
237         payable 
238     {
239         // make sure name fees paid
240         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
241         
242         // filter name + condition checks
243         bytes32 _name = NameFilter.nameFilter(_nameString);
244         
245         // set up address 
246         address _addr = msg.sender;
247         
248         // set up our tx event data and determine if player is new or not
249         bool _isNewPlayer = determinePID(_addr);
250         
251         // fetch player id
252         uint256 _pID = pIDxAddr_[_addr];
253         
254         // manage affiliate residuals
255         // if no affiliate code was given or player tried to use their own, lolz
256         uint256 _affID;
257         // get affiliate ID from aff Code 
258         _affID = pIDxName_[_affCode];
259             
260         // if affID is not the same as previously stored 
261         if (_affID != plyr_[_pID].laff && _affID != _pID && plyr_[_pID].laff != 0)
262         {
263                 // update last affiliate
264                 plyr_[_pID].laff = _affID;
265         }
266         _affID = plyr_[_pID].laff;
267         
268         // register name 
269         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
270     }
271     
272     /**
273      * @dev players, if you registered a profile, before a game was released, or
274      * set the all bool to false when you registered, use this function to push
275      * your profile to a single game.  also, if you've  updated your name, you
276      * can use this to push your name to games of your choosing.
277      * -functionhash- 0x81c5b206
278      * @param _gameID game id 
279      */
280     function addMeToGame(uint256 _gameID)
281         isHuman()
282         public
283     {
284         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
285         address _addr = msg.sender;
286         uint256 _pID = pIDxAddr_[_addr];
287         require(_pID != 0, "hey there buddy, you dont even have an account");
288         uint256 _totalNames = plyr_[_pID].names;
289         
290         // add players profile and most recent name
291         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
292         
293         // add list of all names
294         if (_totalNames > 1)
295             for (uint256 ii = 1; ii <= _totalNames; ii++)
296                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
297     }
298     
299     /**
300      * @dev players, use this to push your player profile to all registered games.
301      * -functionhash- 0x0c6940ea
302      */
303     function addMeToAllGames()
304         isHuman()
305         public
306     {
307         address _addr = msg.sender;
308         uint256 _pID = pIDxAddr_[_addr];
309         require(_pID != 0, "hey there buddy, you dont even have an account");
310         uint256 _laff = plyr_[_pID].laff;
311         uint256 _totalNames = plyr_[_pID].names;
312         bytes32 _name = plyr_[_pID].name;
313         
314         for (uint256 i = 1; i <= gID_; i++)
315         {
316             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
317             if (_totalNames > 1)
318                 for (uint256 ii = 1; ii <= _totalNames; ii++)
319                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
320         }
321                 
322     }
323     
324     /**
325      * @dev players use this to change back to one of your old names.  tip, you'll
326      * still need to push that info to existing games.
327      * -functionhash- 0xb9291296
328      * @param _nameString the name you want to use 
329      */
330     function useMyOldName(string _nameString)
331         isHuman()
332         public 
333     {
334         // filter name, and get pID
335         bytes32 _name = _nameString.nameFilter();
336         uint256 _pID = pIDxAddr_[msg.sender];
337         
338         // make sure they own the name 
339         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
340         
341         // update their current name 
342         plyr_[_pID].name = _name;
343     }
344     
345 //==============================================================================
346 //     _ _  _ _   | _  _ . _  .
347 //    (_(_)| (/_  |(_)(_||(_  . 
348 //=====================_|=======================================================    
349     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
350         private
351     {
352         // if names already has been used, require that current msg sender owns the name
353         if (pIDxName_[_name] != 0)
354             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
355         
356         // add name to player profile, registry, and name book
357         plyr_[_pID].name = _name;
358         pIDxName_[_name] = _pID;
359         if (plyrNames_[_pID][_name] == false)
360         {
361             plyrNames_[_pID][_name] = true;
362             plyr_[_pID].names++;
363             plyrNameList_[_pID][plyr_[_pID].names] = _name;
364         }
365         
366         // registration fee goes directly to community rewards
367         yyyy.transfer(((address(this).balance).mul(80)/100));
368         gggg.transfer(address(this).balance);
369         
370         // push player info to games
371         if (_all == true)
372             for (uint256 i = 1; i <= gID_; i++)
373                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
374         
375         // fire event
376         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
377     }
378 //==============================================================================
379 //    _|_ _  _ | _  .
380 //     | (_)(_)|_\  .
381 //==============================================================================    
382     function determinePID(address _addr)
383         private
384         returns (bool)
385     {
386         if (pIDxAddr_[_addr] == 0)
387         {
388             pID_++;
389             pIDxAddr_[_addr] = pID_;
390             plyr_[pID_].addr = _addr;
391             
392             // set the new player bool to true
393             return (true);
394         } else {
395             return (false);
396         }
397     }
398 //==============================================================================
399 //   _   _|_ _  _ _  _ |   _ _ || _  .
400 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
401 //==============================================================================
402     function getPlayerID(address _addr)
403         isRegisteredGame()
404         external
405         returns (uint256)
406     {
407         determinePID(_addr);
408         return (pIDxAddr_[_addr]);
409     }
410     function getPlayerName(uint256 _pID)
411         external
412         view
413         returns (bytes32)
414     {
415         return (plyr_[_pID].name);
416     }
417     function getPlayerLAff(uint256 _pID)
418         external
419         view
420         returns (uint256)
421     {
422         return (plyr_[_pID].laff);
423     }
424     function getPlayerAddr(uint256 _pID)
425         external
426         view
427         returns (address)
428     {
429         return (plyr_[_pID].addr);
430     }
431     function getNameFee()
432         external
433         view
434         returns (uint256)
435     {
436         return(registrationFee_);
437     }
438     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
439         isRegisteredGame()
440         external
441         payable
442         returns(bool, uint256)
443     {
444         // make sure name fees paid
445         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
446         
447         // set up our tx event data and determine if player is new or not
448         bool _isNewPlayer = determinePID(_addr);
449         
450         // fetch player id
451         uint256 _pID = pIDxAddr_[_addr];
452         
453         // manage affiliate residuals
454         // if no affiliate code was given, no new affiliate code was given, or the 
455         // player tried to use their own pID as an affiliate code, lolz
456         uint256 _affID = _affCode;
457         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
458         {
459             // update last affiliate 
460             plyr_[_pID].laff = _affID;
461         } else if (_affID == _pID) {
462             _affID = 0;
463         }
464         
465         // register name 
466         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
467         
468         return(_isNewPlayer, _affID);
469     }
470     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
471         isRegisteredGame()
472         external
473         payable
474         returns(bool, uint256)
475     {
476         // make sure name fees paid
477         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
478         
479         // set up our tx event data and determine if player is new or not
480         bool _isNewPlayer = determinePID(_addr);
481         
482         // fetch player id
483         uint256 _pID = pIDxAddr_[_addr];
484         
485         // manage affiliate residuals
486         // if no affiliate code was given or player tried to use their own, lolz
487         uint256 _affID;
488         if (_affCode != address(0) && _affCode != _addr)
489         {
490             // get affiliate ID from aff Code 
491             _affID = pIDxAddr_[_affCode];
492             
493             // if affID is not the same as previously stored 
494             if (_affID != plyr_[_pID].laff)
495             {
496                 // update last affiliate
497                 plyr_[_pID].laff = _affID;
498             }
499         }
500         
501         // register name 
502         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
503         
504         return(_isNewPlayer, _affID);
505     }
506     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
507         isRegisteredGame()
508         external
509         payable
510         returns(bool, uint256)
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
524         if (_affCode != "" && _affCode != _name)
525         {
526             // get affiliate ID from aff Code 
527             _affID = pIDxName_[_affCode];
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
542     
543 //==============================================================================
544 //   _ _ _|_    _   .
545 //  _\(/_ | |_||_)  .
546 //=============|================================================================
547     function addGame(address _gameAddress, string _gameNameStr)
548         onlyDevs()
549         public
550     {
551         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
552             gID_++;
553             bytes32 _name = _gameNameStr.nameFilter();
554             gameIDs_[_gameAddress] = gID_;
555             gameNames_[_gameAddress] = _name;
556             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
557         
558             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
559             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
560             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
561             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
562     }
563     
564     function setRegistrationFee(uint256 _fee)
565         onlyDevs()
566         public
567     {
568       registrationFee_ = _fee;
569     }
570         
571 } 
572 
573 /**
574 * @title -Name Filter- v0.1.9
575 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
576 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
577 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
578 *                                  _____                      _____
579 *                                 (, /     /)       /) /)    (, /      /)          /)
580 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
581 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
582 *          ┴ ┴                /   /          .-/ _____   (__ /                               
583 *                            (__ /          (_/ (, /                                      /)™ 
584 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
585 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
586 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
587 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
588 *              _       __    _      ____      ____  _   _    _____  ____  ___  
589 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
590 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
591 *
592 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
593 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
594 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
595 */
596 library NameFilter {
597     
598     /**
599      * @dev filters name strings
600      * -converts uppercase to lower case.  
601      * -makes sure it does not start/end with a space
602      * -makes sure it does not contain multiple spaces in a row
603      * -cannot be only numbers
604      * -cannot start with 0x 
605      * -restricts characters to A-Z, a-z, 0-9, and space.
606      * @return reprocessed string in bytes32 format
607      */
608     function nameFilter(string _input)
609         internal
610         pure
611         returns(bytes32)
612     {
613         bytes memory _temp = bytes(_input);
614         uint256 _length = _temp.length;
615         
616         //sorry limited to 32 characters
617         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
618         // make sure it doesnt start with or end with space
619         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
620         // make sure first two characters are not 0x
621         if (_temp[0] == 0x30)
622         {
623             require(_temp[1] != 0x78, "string cannot start with 0x");
624             require(_temp[1] != 0x58, "string cannot start with 0X");
625         }
626         
627         // create a bool to track if we have a non number character
628         bool _hasNonNumber;
629         
630         // convert & check
631         for (uint256 i = 0; i < _length; i++)
632         {
633             // if its uppercase A-Z
634             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
635             {
636                 // convert to lower case a-z
637                 _temp[i] = byte(uint(_temp[i]) + 32);
638                 
639                 // we have a non number
640                 if (_hasNonNumber == false)
641                     _hasNonNumber = true;
642             } else {
643                 require
644                 (
645                     // require character is a space
646                     _temp[i] == 0x20 || 
647                     // OR lowercase a-z
648                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
649                     // or 0-9
650                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
651                     "string contains invalid characters"
652                 );
653                 // make sure theres not 2x spaces in a row
654                 if (_temp[i] == 0x20)
655                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
656                 
657                 // see if we have a character other than a number
658                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
659                     _hasNonNumber = true;    
660             }
661         }
662         
663         require(_hasNonNumber == true, "string cannot be only numbers");
664         
665         bytes32 _ret;
666         assembly {
667             _ret := mload(add(_temp, 32))
668         }
669         return (_ret);
670     }
671 }
672 
673 /**
674  * @title SafeMath v0.1.9
675  * @dev Math operations with safety checks that throw on error
676  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
677  * - added sqrt
678  * - added sq
679  * - added pwr 
680  * - changed asserts to requires with error log outputs
681  * - removed div, its useless
682  */
683 library SafeMath {
684     
685     /**
686     * @dev Multiplies two numbers, throws on overflow.
687     */
688     function mul(uint256 a, uint256 b) 
689         internal 
690         pure 
691         returns (uint256 c) 
692     {
693         if (a == 0) {
694             return 0;
695         }
696         c = a * b;
697         require(c / a == b, "SafeMath mul failed");
698         return c;
699     }
700 
701     /**
702     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
703     */
704     function sub(uint256 a, uint256 b)
705         internal
706         pure
707         returns (uint256) 
708     {
709         require(b <= a, "SafeMath sub failed");
710         return a - b;
711     }
712 
713     /**
714     * @dev Adds two numbers, throws on overflow.
715     */
716     function add(uint256 a, uint256 b)
717         internal
718         pure
719         returns (uint256 c) 
720     {
721         c = a + b;
722         require(c >= a, "SafeMath add failed");
723         return c;
724     }
725     
726     /**
727      * @dev gives square root of given x.
728      */
729     function sqrt(uint256 x)
730         internal
731         pure
732         returns (uint256 y) 
733     {
734         uint256 z = ((add(x,1)) / 2);
735         y = x;
736         while (z < y) 
737         {
738             y = z;
739             z = ((add((x / z),z)) / 2);
740         }
741     }
742     
743     /**
744      * @dev gives square. multiplies x by x
745      */
746     function sq(uint256 x)
747         internal
748         pure
749         returns (uint256)
750     {
751         return (mul(x,x));
752     }
753     
754     /**
755      * @dev x to the power of y 
756      */
757     function pwr(uint256 x, uint256 y)
758         internal 
759         pure 
760         returns (uint256)
761     {
762         if (x==0)
763             return (0);
764         else if (y==0)
765             return (1);
766         else 
767         {
768             uint256 z = x;
769             for (uint256 i=1; i < y; i++)
770                 z = mul(z,x);
771             return (z);
772         }
773     }
774 }