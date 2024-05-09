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
28 interface PlayerBookReceiverInterface {
29     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
30     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
31 }
32 
33 contract PlayerBook {
34     using NameFilter for string;
35     using SafeMath for uint256;
36     
37     MSFun.Data private msData;
38 //==============================================================================
39 //     _| _ _|_ _    _ _ _|_    _   .
40 //    (_|(_| | (_|  _\(/_ | |_||_)  .
41 //=============================|================================================    
42     uint256 public registrationFee_ = 0 finney;            // price to register a name
43     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
44     mapping(address => bytes32) public gameNames_;          // lookup a games name
45     mapping(address => uint256) public gameIDs_;            // lokup a games ID
46     uint256 public gID_;        // total number of games
47     uint256 public pID_;        // total number of players
48     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
49     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
50     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
51     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
52     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
53     struct Player {
54         address addr;
55         bytes32 name;
56         uint256 laff;
57         uint256 names;
58     }
59 //==============================================================================
60 //     _ _  _  __|_ _    __|_ _  _  .
61 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
62 //==============================================================================    
63     constructor()
64         public
65     {   
66     }
67 //==============================================================================
68 //     _ _  _  _|. |`. _  _ _  .
69 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
70 //==============================================================================    
71     /**
72      * @dev prevents contracts from interacting with fomo3d 
73      */
74     modifier isHuman() {
75         address _addr = msg.sender;
76         uint256 _codeLength;
77         
78         assembly {_codeLength := extcodesize(_addr)}
79         require(_codeLength == 0, "sorry humans only");
80         _;
81     }
82     
83     modifier isRegisteredGame()
84     {
85         require(gameIDs_[msg.sender] != 0);
86         _;
87     }
88 //==============================================================================
89 //     _    _  _ _|_ _  .
90 //    (/_\/(/_| | | _\  .
91 //==============================================================================    
92     // fired whenever a player registers a name
93     event onNewName
94     (
95         uint256 indexed playerID,
96         address indexed playerAddress,
97         bytes32 indexed playerName,
98         bool isNewPlayer,
99         uint256 affiliateID,
100         address affiliateAddress,
101         bytes32 affiliateName,
102         uint256 amountPaid,
103         uint256 timeStamp
104     );
105 //==============================================================================
106 //     _  _ _|__|_ _  _ _  .
107 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
108 //=====_|=======================================================================
109     function checkIfNameValid(string _nameStr)
110         public
111         view
112         returns(bool)
113     {
114         bytes32 _name = _nameStr.nameFilter();
115         if (pIDxName_[_name] == 0)
116             return (true);
117         else 
118             return (false);
119     }
120 //==============================================================================
121 //     _    |_ |. _   |`    _  __|_. _  _  _  .
122 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
123 //====|=========================================================================    
124     /**
125      * @dev registers a name.  UI will always display the last name you registered.
126      * but you will still own all previously registered names to use as affiliate 
127      * links.
128      * - must pay a registration fee.
129      * - name must be unique
130      * - names will be converted to lowercase
131      * - name cannot start or end with a space 
132      * - cannot have more than 1 space in a row
133      * - cannot be only numbers
134      * - cannot start with 0x 
135      * - name must be at least 1 char
136      * - max length of 32 characters long
137      * - allowed characters: a-z, 0-9, and space
138      * -functionhash- 0x921dec21 (using ID for affiliate)
139      * -functionhash- 0x3ddd4698 (using address for affiliate)
140      * -functionhash- 0x685ffd83 (using name for affiliate)
141      * @param _nameString players desired name
142      * @param _affCode affiliate ID, address, or name of who refered you
143      * @param _all set to true if you want this to push your info to all games 
144      * (this might cost a lot of gas)
145      */
146     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
147         isHuman()
148         public
149         payable 
150     {
151         // filter name + condition checks
152         bytes32 _name = NameFilter.nameFilter(_nameString);
153         
154         // set up address 
155         address _addr = msg.sender;
156         
157         // set up our tx event data and determine if player is new or not
158         bool _isNewPlayer = determinePID(_addr);
159         
160         // fetch player id
161         uint256 _pID = pIDxAddr_[_addr];
162         
163         // manage affiliate residuals
164         // if no affiliate code was given, no new affiliate code was given, or the 
165         // player tried to use their own pID as an affiliate code, lolz
166         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
167         {
168             // update last affiliate 
169             plyr_[_pID].laff = _affCode;
170         } else if (_affCode == _pID) {
171             _affCode = 0;
172         }
173         
174         // register name 
175         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
176     }
177     
178     function registerNameXaddr(string _nameString, address _affCode, bool _all)
179         isHuman()
180         public
181         payable 
182     {
183         // filter name + condition checks
184         bytes32 _name = NameFilter.nameFilter(_nameString);
185         
186         // set up address 
187         address _addr = msg.sender;
188         
189         // set up our tx event data and determine if player is new or not
190         bool _isNewPlayer = determinePID(_addr);
191         
192         // fetch player id
193         uint256 _pID = pIDxAddr_[_addr];
194         
195         // manage affiliate residuals
196         // if no affiliate code was given or player tried to use their own, lolz
197         uint256 _affID;
198         if (_affCode != address(0) && _affCode != _addr)
199         {
200             // get affiliate ID from aff Code 
201             _affID = pIDxAddr_[_affCode];
202             
203             // if affID is not the same as previously stored 
204             if (_affID != plyr_[_pID].laff)
205             {
206                 // update last affiliate
207                 plyr_[_pID].laff = _affID;
208             }
209         }
210         
211         // register name 
212         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
213     }
214     
215     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
216         isHuman()
217         public
218         payable 
219     {
220         // filter name + condition checks
221         bytes32 _name = NameFilter.nameFilter(_nameString);
222         
223         // set up address 
224         address _addr = msg.sender;
225         
226         // set up our tx event data and determine if player is new or not
227         bool _isNewPlayer = determinePID(_addr);
228         
229         // fetch player id
230         uint256 _pID = pIDxAddr_[_addr];
231         
232         // manage affiliate residuals
233         // if no affiliate code was given or player tried to use their own, lolz
234         uint256 _affID;
235         if (_affCode != "" && _affCode != _name)
236         {
237             // get affiliate ID from aff Code 
238             _affID = pIDxName_[_affCode];
239             
240             // if affID is not the same as previously stored 
241             if (_affID != plyr_[_pID].laff)
242             {
243                 // update last affiliate
244                 plyr_[_pID].laff = _affID;
245             }
246         }
247         
248         // register name 
249         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
250     }
251     
252     /**
253      * @dev players, if you registered a profile, before a game was released, or
254      * set the all bool to false when you registered, use this function to push
255      * your profile to a single game.  also, if you've  updated your name, you
256      * can use this to push your name to games of your choosing.
257      * -functionhash- 0x81c5b206
258      * @param _gameID game id 
259      */
260     function addMeToGame(uint256 _gameID)
261         isHuman()
262         public
263     {
264         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
265         address _addr = msg.sender;
266         uint256 _pID = pIDxAddr_[_addr];
267         require(_pID != 0, "hey there buddy, you dont even have an account");
268         uint256 _totalNames = plyr_[_pID].names;
269         
270         // add players profile and most recent name
271         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
272         
273         // add list of all names
274         if (_totalNames > 1)
275             for (uint256 ii = 1; ii <= _totalNames; ii++)
276                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
277     }
278     
279     /**
280      * @dev players, use this to push your player profile to all registered games.
281      * -functionhash- 0x0c6940ea
282      */
283     function addMeToAllGames()
284         isHuman()
285         public
286     {
287         address _addr = msg.sender;
288         uint256 _pID = pIDxAddr_[_addr];
289         require(_pID != 0, "hey there buddy, you dont even have an account");
290         uint256 _laff = plyr_[_pID].laff;
291         uint256 _totalNames = plyr_[_pID].names;
292         bytes32 _name = plyr_[_pID].name;
293         
294         for (uint256 i = 1; i <= gID_; i++)
295         {
296             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
297             if (_totalNames > 1)
298                 for (uint256 ii = 1; ii <= _totalNames; ii++)
299                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
300         }
301                 
302     }
303     
304     /**
305      * @dev players use this to change back to one of your old names.  tip, you'll
306      * still need to push that info to existing games.
307      * -functionhash- 0xb9291296
308      * @param _nameString the name you want to use 
309      */
310     function useMyOldName(string _nameString)
311         isHuman()
312         public 
313     {
314         // filter name, and get pID
315         bytes32 _name = _nameString.nameFilter();
316         uint256 _pID = pIDxAddr_[msg.sender];
317         
318         // make sure they own the name 
319         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
320         
321         // update their current name 
322         plyr_[_pID].name = _name;
323     }
324     
325 //==============================================================================
326 //     _ _  _ _   | _  _ . _  .
327 //    (_(_)| (/_  |(_)(_||(_  . 
328 //=====================_|=======================================================    
329     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
330         private
331     {
332         // if names already has been used, require that current msg sender owns the name
333         if (pIDxName_[_name] != 0)
334             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
335         
336         // add name to player profile, registry, and name book
337         plyr_[_pID].name = _name;
338         pIDxName_[_name] = _pID;
339         if (plyrNames_[_pID][_name] == false)
340         {
341             plyrNames_[_pID][_name] = true;
342             plyr_[_pID].names++;
343             plyrNameList_[_pID][plyr_[_pID].names] = _name;
344         }
345         
346         // push player info to games
347         if (_all == true)
348             for (uint256 i = 1; i <= gID_; i++)
349                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
350         
351         // fire event
352         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
353     }
354 //==============================================================================
355 //    _|_ _  _ | _  .
356 //     | (_)(_)|_\  .
357 //==============================================================================    
358     function determinePID(address _addr)
359         private
360         returns (bool)
361     {
362         if (pIDxAddr_[_addr] == 0)
363         {
364             pID_++;
365             pIDxAddr_[_addr] = pID_;
366             plyr_[pID_].addr = _addr;
367             
368             // set the new player bool to true
369             return (true);
370         } else {
371             return (false);
372         }
373     }
374 //==============================================================================
375 //   _   _|_ _  _ _  _ |   _ _ || _  .
376 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
377 //==============================================================================
378     function getPlayerID(address _addr)
379         isRegisteredGame()
380         external
381         returns (uint256)
382     {
383         determinePID(_addr);
384         return (pIDxAddr_[_addr]);
385     }
386     function getPlayerName(uint256 _pID)
387         external
388         view
389         returns (bytes32)
390     {
391         return (plyr_[_pID].name);
392     }
393     function getPlayerLAff(uint256 _pID)
394         external
395         view
396         returns (uint256)
397     {
398         return (plyr_[_pID].laff);
399     }
400     function getPlayerAddr(uint256 _pID)
401         external
402         view
403         returns (address)
404     {
405         return (plyr_[_pID].addr);
406     }
407     function getNameFee()
408         external
409         view
410         returns (uint256)
411     {
412         return(registrationFee_);
413     }
414     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
415         isRegisteredGame()
416         external
417         payable
418         returns(bool, uint256)
419     {
420         // set up our tx event data and determine if player is new or not
421         bool _isNewPlayer = determinePID(_addr);
422         
423         // fetch player id
424         uint256 _pID = pIDxAddr_[_addr];
425         
426         // manage affiliate residuals
427         // if no affiliate code was given, no new affiliate code was given, or the 
428         // player tried to use their own pID as an affiliate code, lolz
429         uint256 _affID = _affCode;
430         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
431         {
432             // update last affiliate 
433             plyr_[_pID].laff = _affID;
434         } else if (_affID == _pID) {
435             _affID = 0;
436         }
437         
438         // register name 
439         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
440         
441         return(_isNewPlayer, _affID);
442     }
443     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
444         isRegisteredGame()
445         external
446         payable
447         returns(bool, uint256)
448     {
449         // set up our tx event data and determine if player is new or not
450         bool _isNewPlayer = determinePID(_addr);
451         
452         // fetch player id
453         uint256 _pID = pIDxAddr_[_addr];
454         
455         // manage affiliate residuals
456         // if no affiliate code was given or player tried to use their own, lolz
457         uint256 _affID;
458         if (_affCode != address(0) && _affCode != _addr)
459         {
460             // get affiliate ID from aff Code 
461             _affID = pIDxAddr_[_affCode];
462             
463             // if affID is not the same as previously stored 
464             if (_affID != plyr_[_pID].laff)
465             {
466                 // update last affiliate
467                 plyr_[_pID].laff = _affID;
468             }
469         }
470         
471         // register name 
472         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
473         
474         return(_isNewPlayer, _affID);
475     }
476     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
477         isRegisteredGame()
478         external
479         payable
480         returns(bool, uint256)
481     {
482         // set up our tx event data and determine if player is new or not
483         bool _isNewPlayer = determinePID(_addr);
484         
485         // fetch player id
486         uint256 _pID = pIDxAddr_[_addr];
487         
488         // manage affiliate residuals
489         // if no affiliate code was given or player tried to use their own, lolz
490         uint256 _affID;
491         if (_affCode != "" && _affCode != _name)
492         {
493             // get affiliate ID from aff Code 
494             _affID = pIDxName_[_affCode];
495             
496             // if affID is not the same as previously stored 
497             if (_affID != plyr_[_pID].laff)
498             {
499                 // update last affiliate
500                 plyr_[_pID].laff = _affID;
501             }
502         }
503         
504         // register name 
505         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
506         
507         return(_isNewPlayer, _affID);
508     }
509     
510 //==============================================================================
511 //   _ _ _|_    _   .
512 //  _\(/_ | |_||_)  .
513 //=============|================================================================
514     function addGame(address _gameAddress, string _gameNameStr)
515         public
516     {
517         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
518         
519         gID_++;
520         bytes32 _name = _gameNameStr.nameFilter();
521         gameIDs_[_gameAddress] = gID_;
522         gameNames_[_gameAddress] = _name;
523         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
524     
525     }
526 } 
527 
528 /**
529 * @title -Name Filter- v0.1.9
530 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
531 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
532 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
533 *                                  _____                      _____
534 *                                 (, /     /)       /) /)    (, /      /)          /)
535 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
536 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
537 *          ┴ ┴                /   /          .-/ _____   (__ /                               
538 *                            (__ /          (_/ (, /                                      /)™ 
539 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
540 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
541 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
542 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
543 *              _       __    _      ____      ____  _   _    _____  ____  ___  
544 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
545 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
546 *
547 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
548 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
549 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
550 */
551 library NameFilter {
552     
553     /**
554      * @dev filters name strings
555      * -converts uppercase to lower case.  
556      * -makes sure it does not start/end with a space
557      * -makes sure it does not contain multiple spaces in a row
558      * -cannot be only numbers
559      * -cannot start with 0x 
560      * -restricts characters to A-Z, a-z, 0-9, and space.
561      * @return reprocessed string in bytes32 format
562      */
563     function nameFilter(string _input)
564         internal
565         pure
566         returns(bytes32)
567     {
568         bytes memory _temp = bytes(_input);
569         uint256 _length = _temp.length;
570         
571         //sorry limited to 32 characters
572         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
573         // make sure it doesnt start with or end with space
574         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
575         // make sure first two characters are not 0x
576         if (_temp[0] == 0x30)
577         {
578             require(_temp[1] != 0x78, "string cannot start with 0x");
579             require(_temp[1] != 0x58, "string cannot start with 0X");
580         }
581         
582         // create a bool to track if we have a non number character
583         bool _hasNonNumber;
584         
585         // convert & check
586         for (uint256 i = 0; i < _length; i++)
587         {
588             // if its uppercase A-Z
589             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
590             {
591                 // convert to lower case a-z
592                 _temp[i] = byte(uint(_temp[i]) + 32);
593                 
594                 // we have a non number
595                 if (_hasNonNumber == false)
596                     _hasNonNumber = true;
597             } else {
598                 require
599                 (
600                     // require character is a space
601                     _temp[i] == 0x20 || 
602                     // OR lowercase a-z
603                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
604                     // or 0-9
605                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
606                     "string contains invalid characters"
607                 );
608                 // make sure theres not 2x spaces in a row
609                 if (_temp[i] == 0x20)
610                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
611                 
612                 // see if we have a character other than a number
613                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
614                     _hasNonNumber = true;    
615             }
616         }
617         
618         require(_hasNonNumber == true, "string cannot be only numbers");
619         
620         bytes32 _ret;
621         assembly {
622             _ret := mload(add(_temp, 32))
623         }
624         return (_ret);
625     }
626 }
627 
628 /**
629  * @title SafeMath v0.1.9
630  * @dev Math operations with safety checks that throw on error
631  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
632  * - added sqrt
633  * - added sq
634  * - added pwr 
635  * - changed asserts to requires with error log outputs
636  * - removed div, its useless
637  */
638 library SafeMath {
639     
640     /**
641     * @dev Multiplies two numbers, throws on overflow.
642     */
643     function mul(uint256 a, uint256 b) 
644         internal 
645         pure 
646         returns (uint256 c) 
647     {
648         if (a == 0) {
649             return 0;
650         }
651         c = a * b;
652         require(c / a == b, "SafeMath mul failed");
653         return c;
654     }
655 
656     /**
657     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
658     */
659     function sub(uint256 a, uint256 b)
660         internal
661         pure
662         returns (uint256) 
663     {
664         require(b <= a, "SafeMath sub failed");
665         return a - b;
666     }
667 
668     /**
669     * @dev Adds two numbers, throws on overflow.
670     */
671     function add(uint256 a, uint256 b)
672         internal
673         pure
674         returns (uint256 c) 
675     {
676         c = a + b;
677         require(c >= a, "SafeMath add failed");
678         return c;
679     }
680     
681     /**
682      * @dev gives square root of given x.
683      */
684     function sqrt(uint256 x)
685         internal
686         pure
687         returns (uint256 y) 
688     {
689         uint256 z = ((add(x,1)) / 2);
690         y = x;
691         while (z < y) 
692         {
693             y = z;
694             z = ((add((x / z),z)) / 2);
695         }
696     }
697     
698     /**
699      * @dev gives square. multiplies x by x
700      */
701     function sq(uint256 x)
702         internal
703         pure
704         returns (uint256)
705     {
706         return (mul(x,x));
707     }
708     
709     /**
710      * @dev x to the power of y 
711      */
712     function pwr(uint256 x, uint256 y)
713         internal 
714         pure 
715         returns (uint256)
716     {
717         if (x==0)
718             return (0);
719         else if (y==0)
720             return (1);
721         else 
722         {
723             uint256 z = x;
724             for (uint256 i=1; i < y; i++)
725                 z = mul(z,x);
726             return (z);
727         }
728     }
729 }
730 
731 /** @title -MSFun- v0.2.4
732  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
733  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
734  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
735  *                                  _____                      _____
736  *                                 (, /     /)       /) /)    (, /      /)          /)
737  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
738  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
739  *          ┴ ┴                /   /          .-/ _____   (__ /                               
740  *                            (__ /          (_/ (, /                                      /)™ 
741  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
742  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
743  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
744  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
745  *  _           _             _  _  _  _             _  _  _  _  _                                      
746  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
747  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
748  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
749  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
750  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
751  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
752  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
753  *
754  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
755  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
756  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
757  *  
758  *         ┌──────────────────────────────────────────────────────────────────────┐
759  *         │ MSFun, is an importable library that gives your contract the ability │
760  *         │ add multiSig requirement to functions.                               │
761  *         └──────────────────────────────────────────────────────────────────────┘
762  *                                ┌────────────────────┐
763  *                                │ Setup Instructions │
764  *                                └────────────────────┘
765  * (Step 1) import the library into your contract
766  * 
767  *    import "./MSFun.sol";
768  *
769  * (Step 2) set up the signature data for msFun
770  * 
771  *     MSFun.Data private msData;
772  *                                ┌────────────────────┐
773  *                                │ Usage Instructions │
774  *                                └────────────────────┘
775  * at the beginning of a function
776  * 
777  *     function functionName() 
778  *     {
779  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
780  *         {
781  *             MSFun.deleteProposal(msData, "functionName");
782  * 
783  *             // put function body here 
784  *         }
785  *     }
786  *                           ┌────────────────────────────────┐
787  *                           │ Optional Wrappers For TeamJust │
788  *                           └────────────────────────────────┘
789  * multiSig wrapper function (cuts down on inputs, improves readability)
790  * this wrapper is HIGHLY recommended
791  * 
792  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
793  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
794  *
795  * wrapper for delete proposal (makes code cleaner)
796  *     
797  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
798  *                             ┌────────────────────────────┐
799  *                             │ Utility & Vanity Functions │
800  *                             └────────────────────────────┘
801  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
802  * function, with argument inputs that the other admins do not agree upon, the function
803  * can never be executed until the undesirable arguments are approved.
804  * 
805  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
806  * 
807  * for viewing who has signed a proposal & proposal data
808  *     
809  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
810  *
811  * lets you check address of up to 3 signers (address)
812  * 
813  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
814  *
815  * same as above but will return names in string format.
816  *
817  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
818  *                             ┌──────────────────────────┐
819  *                             │ Functions In Depth Guide │
820  *                             └──────────────────────────┘
821  * In the following examples, the Data is the proposal set for this library.  And
822  * the bytes32 is the name of the function.
823  *
824  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
825  *      proposal for the function being called.  The uint256 is the required 
826  *      number of signatures needed before the multiSig will return true.  
827  *      Upon first call, multiSig will create a proposal and store the arguments 
828  *      passed with the function call as msgData.  Any admins trying to sign the 
829  *      function call will need to send the same argument values. Once required
830  *      number of signatures is reached this will return a bool of true.
831  * 
832  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
833  *      you will want to delete the proposal data.  This does that.
834  *
835  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
836  * 
837  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
838  *      the proposal 
839  * 
840  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
841  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
842  */
843 
844 library MSFun {
845     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
846     // DATA SETS
847     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
848     // contact data setup
849     struct Data 
850     {
851         mapping (bytes32 => ProposalData) proposal_;
852     }
853     struct ProposalData 
854     {
855         // a hash of msg.data 
856         bytes32 msgData;
857         // number of signers
858         uint256 count;
859         // tracking of wither admins have signed
860         mapping (address => bool) admin;
861         // list of admins who have signed
862         mapping (uint256 => address) log;
863     }
864     
865     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
866     // MULTI SIG FUNCTIONS
867     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
868     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
869         internal
870         returns(bool) 
871     {
872         // our proposal key will be a hash of our function name + our contracts address 
873         // by adding our contracts address to this, we prevent anyone trying to circumvent
874         // the proposal's security via external calls.
875         bytes32 _whatProposal = whatProposal(_whatFunction);
876         
877         // this is just done to make the code more readable.  grabs the signature count
878         uint256 _currentCount = self.proposal_[_whatProposal].count;
879         
880         // store the address of the person sending the function call.  we use msg.sender 
881         // here as a layer of security.  in case someone imports our contract and tries to 
882         // circumvent function arguments.  still though, our contract that imports this
883         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
884         // calls the function will be a signer. 
885         address _whichAdmin = msg.sender;
886         
887         // prepare our msg data.  by storing this we are able to verify that all admins
888         // are approving the same argument input to be executed for the function.  we hash 
889         // it and store in bytes32 so its size is known and comparable
890         bytes32 _msgData = keccak256(msg.data);
891         
892         // check to see if this is a new execution of this proposal or not
893         if (_currentCount == 0)
894         {
895             // if it is, lets record the original signers data
896             self.proposal_[_whatProposal].msgData = _msgData;
897             
898             // record original senders signature
899             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
900             
901             // update log (used to delete records later, and easy way to view signers)
902             // also useful if the calling function wants to give something to a 
903             // specific signer.  
904             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
905             
906             // track number of signatures
907             self.proposal_[_whatProposal].count += 1;  
908             
909             // if we now have enough signatures to execute the function, lets
910             // return a bool of true.  we put this here in case the required signatures
911             // is set to 1.
912             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
913                 return(true);
914             }            
915         // if its not the first execution, lets make sure the msgData matches
916         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
917             // msgData is a match
918             // make sure admin hasnt already signed
919             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
920             {
921                 // record their signature
922                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
923                 
924                 // update log (used to delete records later, and easy way to view signers)
925                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
926                 
927                 // track number of signatures
928                 self.proposal_[_whatProposal].count += 1;  
929             }
930             
931             // if we now have enough signatures to execute the function, lets
932             // return a bool of true.
933             // we put this here for a few reasons.  (1) in normal operation, if 
934             // that last recorded signature got us to our required signatures.  we 
935             // need to return bool of true.  (2) if we have a situation where the 
936             // required number of signatures was adjusted to at or lower than our current 
937             // signature count, by putting this here, an admin who has already signed,
938             // can call the function again to make it return a true bool.  but only if
939             // they submit the correct msg data
940             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
941                 return(true);
942             }
943         }
944     }
945     
946     
947     // deletes proposal signature data after successfully executing a multiSig function
948     function deleteProposal(Data storage self, bytes32 _whatFunction)
949         internal
950     {
951         //done for readability sake
952         bytes32 _whatProposal = whatProposal(_whatFunction);
953         address _whichAdmin;
954         
955         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
956         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
957         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
958             _whichAdmin = self.proposal_[_whatProposal].log[i];
959             delete self.proposal_[_whatProposal].admin[_whichAdmin];
960             delete self.proposal_[_whatProposal].log[i];
961         }
962         //delete the rest of the data in the record
963         delete self.proposal_[_whatProposal];
964     }
965     
966     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
967     // HELPER FUNCTIONS
968     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
969 
970     function whatProposal(bytes32 _whatFunction)
971         private
972         view
973         returns(bytes32)
974     {
975         return(keccak256(abi.encodePacked(_whatFunction,this)));
976     }
977     
978     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
979     // VANITY FUNCTIONS
980     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
981     // returns a hashed version of msg.data sent by original signer for any given function
982     function checkMsgData (Data storage self, bytes32 _whatFunction)
983         internal
984         view
985         returns (bytes32 msg_data)
986     {
987         bytes32 _whatProposal = whatProposal(_whatFunction);
988         return (self.proposal_[_whatProposal].msgData);
989     }
990     
991     // returns number of signers for any given function
992     function checkCount (Data storage self, bytes32 _whatFunction)
993         internal
994         view
995         returns (uint256 signature_count)
996     {
997         bytes32 _whatProposal = whatProposal(_whatFunction);
998         return (self.proposal_[_whatProposal].count);
999     }
1000     
1001     // returns address of an admin who signed for any given function
1002     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1003         internal
1004         view
1005         returns (address signer)
1006     {
1007         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1008         bytes32 _whatProposal = whatProposal(_whatFunction);
1009         return (self.proposal_[_whatProposal].log[_signer - 1]);
1010     }
1011 }