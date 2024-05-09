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
68     {}
69 //==============================================================================
70 //     _ _  _  _|. |`. _  _ _  .
71 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
72 //==============================================================================    
73     /**
74      * @dev prevents contracts from interacting with fomo3d 
75      */
76     modifier isHuman() {
77         address _addr = msg.sender;
78         uint256 _codeLength;
79         
80         assembly {_codeLength := extcodesize(_addr)}
81         require(_codeLength == 0, "sorry humans only");
82         _;
83     }
84    
85     
86     modifier isRegisteredGame()
87     {
88         require(gameIDs_[msg.sender] != 0);
89         _;
90     }
91 //==============================================================================
92 //     _    _  _ _|_ _  .
93 //    (/_\/(/_| | | _\  .
94 //==============================================================================    
95     // fired whenever a player registers a name
96     event onNewName
97     (
98         uint256 indexed playerID,
99         address indexed playerAddress,
100         bytes32 indexed playerName,
101         bool isNewPlayer,
102         uint256 affiliateID,
103         address affiliateAddress,
104         bytes32 affiliateName,
105         uint256 amountPaid,
106         uint256 timeStamp
107     );
108 //==============================================================================
109 //     _  _ _|__|_ _  _ _  .
110 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
111 //=====_|=======================================================================
112     function checkIfNameValid(string _nameStr)
113         public
114         view
115         returns(bool)
116     {
117         bytes32 _name = _nameStr.nameFilter();
118         if (pIDxName_[_name] == 0)
119             return (true);
120         else 
121             return (false);
122     }
123 //==============================================================================
124 //     _    |_ |. _   |`    _  __|_. _  _  _  .
125 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
126 //====|=========================================================================    
127     /**
128      * @dev registers a name.  UI will always display the last name you registered.
129      * but you will still own all previously registered names to use as affiliate 
130      * links.
131      * - must pay a registration fee.
132      * - name must be unique
133      * - names will be converted to lowercase
134      * - name cannot start or end with a space 
135      * - cannot have more than 1 space in a row
136      * - cannot be only numbers
137      * - cannot start with 0x 
138      * - name must be at least 1 char
139      * - max length of 32 characters long
140      * - allowed characters: a-z, 0-9, and space
141      * -functionhash- 0x921dec21 (using ID for affiliate)
142      * -functionhash- 0x3ddd4698 (using address for affiliate)
143      * -functionhash- 0x685ffd83 (using name for affiliate)
144      * @param _nameString players desired name
145      * @param _affCode affiliate ID, address, or name of who refered you
146      * @param _all set to true if you want this to push your info to all games 
147      * (this might cost a lot of gas)
148      */
149     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
150         isHuman()
151         public
152         payable 
153     {
154         // make sure name fees paid
155         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
156         
157         // filter name + condition checks
158         bytes32 _name = NameFilter.nameFilter(_nameString);
159         
160         // set up address 
161         address _addr = msg.sender;
162         
163         // set up our tx event data and determine if player is new or not
164         bool _isNewPlayer = determinePID(_addr);
165         
166         // fetch player id
167         uint256 _pID = pIDxAddr_[_addr];
168         
169         // manage affiliate residuals
170         // if no affiliate code was given, no new affiliate code was given, or the 
171         // player tried to use their own pID as an affiliate code, lolz
172         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
173         {
174             // update last affiliate 
175             plyr_[_pID].laff = _affCode;
176         } else if (_affCode == _pID) {
177             _affCode = 0;
178         }
179         
180         // register name 
181         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
182     }
183     
184     function registerNameXaddr(string _nameString, address _affCode, bool _all)
185         isHuman()
186         public
187         payable 
188     {
189         // make sure name fees paid
190         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
191         
192         // filter name + condition checks
193         bytes32 _name = NameFilter.nameFilter(_nameString);
194         
195         // set up address 
196         address _addr = msg.sender;
197         
198         // set up our tx event data and determine if player is new or not
199         bool _isNewPlayer = determinePID(_addr);
200         
201         // fetch player id
202         uint256 _pID = pIDxAddr_[_addr];
203         
204         // manage affiliate residuals
205         // if no affiliate code was given or player tried to use their own, lolz
206         uint256 _affID;
207         if (_affCode != address(0) && _affCode != _addr)
208         {
209             // get affiliate ID from aff Code 
210             _affID = pIDxAddr_[_affCode];
211             
212             // if affID is not the same as previously stored 
213             if (_affID != plyr_[_pID].laff)
214             {
215                 // update last affiliate
216                 plyr_[_pID].laff = _affID;
217             }
218         }
219         
220         // register name 
221         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
222     }
223     
224     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
225         isHuman()
226         public
227         payable 
228     {
229         // make sure name fees paid
230         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
231         
232         // filter name + condition checks
233         bytes32 _name = NameFilter.nameFilter(_nameString);
234         
235         // set up address 
236         address _addr = msg.sender;
237         
238         // set up our tx event data and determine if player is new or not
239         bool _isNewPlayer = determinePID(_addr);
240         
241         // fetch player id
242         uint256 _pID = pIDxAddr_[_addr];
243         
244         // manage affiliate residuals
245         // if no affiliate code was given or player tried to use their own, lolz
246         uint256 _affID;
247         if (_affCode != "" && _affCode != _name)
248         {
249             // get affiliate ID from aff Code 
250             _affID = pIDxName_[_affCode];
251             
252             // if affID is not the same as previously stored 
253             if (_affID != plyr_[_pID].laff)
254             {
255                 // update last affiliate
256                 plyr_[_pID].laff = _affID;
257             }
258         }
259         
260         // register name 
261         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
262     }
263     
264     /**
265      * @dev players, if you registered a profile, before a game was released, or
266      * set the all bool to false when you registered, use this function to push
267      * your profile to a single game.  also, if you've  updated your name, you
268      * can use this to push your name to games of your choosing.
269      * -functionhash- 0x81c5b206
270      * @param _gameID game id 
271      */
272     function addMeToGame(uint256 _gameID)
273         isHuman()
274         public
275     {
276         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
277         address _addr = msg.sender;
278         uint256 _pID = pIDxAddr_[_addr];
279         require(_pID != 0, "hey there buddy, you dont even have an account");
280         uint256 _totalNames = plyr_[_pID].names;
281         
282         // add players profile and most recent name
283         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
284         
285         // add list of all names
286         if (_totalNames > 1)
287             for (uint256 ii = 1; ii <= _totalNames; ii++)
288                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
289     }
290     
291     /**
292      * @dev players, use this to push your player profile to all registered games.
293      * -functionhash- 0x0c6940ea
294      */
295     function addMeToAllGames()
296         isHuman()
297         public
298     {
299         address _addr = msg.sender;
300         uint256 _pID = pIDxAddr_[_addr];
301         require(_pID != 0, "hey there buddy, you dont even have an account");
302         uint256 _laff = plyr_[_pID].laff;
303         uint256 _totalNames = plyr_[_pID].names;
304         bytes32 _name = plyr_[_pID].name;
305         
306         for (uint256 i = 1; i <= gID_; i++)
307         {
308             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
309             if (_totalNames > 1)
310                 for (uint256 ii = 1; ii <= _totalNames; ii++)
311                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
312         }
313                 
314     }
315     
316     /**
317      * @dev players use this to change back to one of your old names.  tip, you'll
318      * still need to push that info to existing games.
319      * -functionhash- 0xb9291296
320      * @param _nameString the name you want to use 
321      */
322     function useMyOldName(string _nameString)
323         isHuman()
324         public 
325     {
326         // filter name, and get pID
327         bytes32 _name = _nameString.nameFilter();
328         uint256 _pID = pIDxAddr_[msg.sender];
329         
330         // make sure they own the name 
331         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
332         
333         // update their current name 
334         plyr_[_pID].name = _name;
335     }
336     
337 //==============================================================================
338 //     _ _  _ _   | _  _ . _  .
339 //    (_(_)| (/_  |(_)(_||(_  . 
340 //=====================_|=======================================================    
341     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
342         private
343     {
344         // if names already has been used, require that current msg sender owns the name
345         if (pIDxName_[_name] != 0)
346             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
347         
348         // add name to player profile, registry, and name book
349         plyr_[_pID].name = _name;
350         pIDxName_[_name] = _pID;
351         if (plyrNames_[_pID][_name] == false)
352         {
353             plyrNames_[_pID][_name] = true;
354             plyr_[_pID].names++;
355             plyrNameList_[_pID][plyr_[_pID].names] = _name;
356         }
357         
358         // registration fee goes directly to community rewards
359         admin.transfer(address(this).balance);
360         
361         // push player info to games
362         if (_all == true)
363             for (uint256 i = 1; i <= gID_; i++)
364                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
365         
366         // fire event
367         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
368     }
369 //==============================================================================
370 //    _|_ _  _ | _  .
371 //     | (_)(_)|_\  .
372 //==============================================================================    
373     function determinePID(address _addr)
374         private
375         returns (bool)
376     {
377         if (pIDxAddr_[_addr] == 0)
378         {
379             pID_++;
380             pIDxAddr_[_addr] = pID_;
381             plyr_[pID_].addr = _addr;
382             
383             // set the new player bool to true
384             return (true);
385         } else {
386             return (false);
387         }
388     }
389 //==============================================================================
390 //   _   _|_ _  _ _  _ |   _ _ || _  .
391 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
392 //==============================================================================
393     function getPlayerID(address _addr)
394         isRegisteredGame()
395         external
396         returns (uint256)
397     {
398         determinePID(_addr);
399         return (pIDxAddr_[_addr]);
400     }
401     function getPlayerName(uint256 _pID)
402         external
403         view
404         returns (bytes32)
405     {
406         return (plyr_[_pID].name);
407     }
408     function getPlayerLAff(uint256 _pID)
409         external
410         view
411         returns (uint256)
412     {
413         return (plyr_[_pID].laff);
414     }
415     function getPlayerAddr(uint256 _pID)
416         external
417         view
418         returns (address)
419     {
420         return (plyr_[_pID].addr);
421     }
422     function getNameFee()
423         external
424         view
425         returns (uint256)
426     {
427         return(registrationFee_);
428     }
429     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
430         isRegisteredGame()
431         external
432         payable
433         returns(bool, uint256)
434     {
435         // make sure name fees paid
436         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
437         
438         // set up our tx event data and determine if player is new or not
439         bool _isNewPlayer = determinePID(_addr);
440         
441         // fetch player id
442         uint256 _pID = pIDxAddr_[_addr];
443         
444         // manage affiliate residuals
445         // if no affiliate code was given, no new affiliate code was given, or the 
446         // player tried to use their own pID as an affiliate code, lolz
447         uint256 _affID = _affCode;
448         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
449         {
450             // update last affiliate 
451             plyr_[_pID].laff = _affID;
452         } else if (_affID == _pID) {
453             _affID = 0;
454         }
455         
456         // register name 
457         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
458         
459         return(_isNewPlayer, _affID);
460     }
461     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
462         isRegisteredGame()
463         external
464         payable
465         returns(bool, uint256)
466     {
467         // make sure name fees paid
468         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
469         
470         // set up our tx event data and determine if player is new or not
471         bool _isNewPlayer = determinePID(_addr);
472         
473         // fetch player id
474         uint256 _pID = pIDxAddr_[_addr];
475         
476         // manage affiliate residuals
477         // if no affiliate code was given or player tried to use their own, lolz
478         uint256 _affID;
479         if (_affCode != address(0) && _affCode != _addr)
480         {
481             // get affiliate ID from aff Code 
482             _affID = pIDxAddr_[_affCode];
483             
484             // if affID is not the same as previously stored 
485             if (_affID != plyr_[_pID].laff)
486             {
487                 // update last affiliate
488                 plyr_[_pID].laff = _affID;
489             }
490         }
491         
492         // register name 
493         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
494         
495         return(_isNewPlayer, _affID);
496     }
497     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
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
515         if (_affCode != "" && _affCode != _name)
516         {
517             // get affiliate ID from aff Code 
518             _affID = pIDxName_[_affCode];
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
533     
534 //==============================================================================
535 //   _ _ _|_    _   .
536 //  _\(/_ | |_||_)  .
537 //=============|================================================================
538     function addGame(address _gameAddress, string _gameNameStr)
539         public
540     {
541         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
542             gID_++;
543             bytes32 _name = _gameNameStr.nameFilter();
544             gameIDs_[_gameAddress] = gID_;
545             gameNames_[_gameAddress] = _name;
546             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
547         
548             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
549             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
550             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
551             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
552     }
553     
554     function setRegistrationFee(uint256 _fee)
555         public
556     {
557       registrationFee_ = _fee;
558     }
559         
560 } 
561 
562 /**
563 * @title -Name Filter- v0.1.9
564 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
565 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
566 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
567 *                                  _____                      _____
568 *                                 (, /     /)       /) /)    (, /      /)          /)
569 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
570 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
571 *          ┴ ┴                /   /          .-/ _____   (__ /                               
572 *                            (__ /          (_/ (, /                                      /)™ 
573 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
574 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
575 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
576 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
577 *              _       __    _      ____      ____  _   _    _____  ____  ___  
578 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
579 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
580 *
581 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
582 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
583 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
584 */
585 library NameFilter {
586     
587     /**
588      * @dev filters name strings
589      * -converts uppercase to lower case.  
590      * -makes sure it does not start/end with a space
591      * -makes sure it does not contain multiple spaces in a row
592      * -cannot be only numbers
593      * -cannot start with 0x 
594      * -restricts characters to A-Z, a-z, 0-9, and space.
595      * @return reprocessed string in bytes32 format
596      */
597     function nameFilter(string _input)
598         internal
599         pure
600         returns(bytes32)
601     {
602         bytes memory _temp = bytes(_input);
603         uint256 _length = _temp.length;
604         
605         //sorry limited to 32 characters
606         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
607         // make sure it doesnt start with or end with space
608         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
609         // make sure first two characters are not 0x
610         if (_temp[0] == 0x30)
611         {
612             require(_temp[1] != 0x78, "string cannot start with 0x");
613             require(_temp[1] != 0x58, "string cannot start with 0X");
614         }
615         
616         // create a bool to track if we have a non number character
617         bool _hasNonNumber;
618         
619         // convert & check
620         for (uint256 i = 0; i < _length; i++)
621         {
622             // if its uppercase A-Z
623             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
624             {
625                 // convert to lower case a-z
626                 _temp[i] = byte(uint(_temp[i]) + 32);
627                 
628                 // we have a non number
629                 if (_hasNonNumber == false)
630                     _hasNonNumber = true;
631             } else {
632                 require
633                 (
634                     // require character is a space
635                     _temp[i] == 0x20 || 
636                     // OR lowercase a-z
637                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
638                     // or 0-9
639                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
640                     "string contains invalid characters"
641                 );
642                 // make sure theres not 2x spaces in a row
643                 if (_temp[i] == 0x20)
644                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
645                 
646                 // see if we have a character other than a number
647                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
648                     _hasNonNumber = true;    
649             }
650         }
651         
652         require(_hasNonNumber == true, "string cannot be only numbers");
653         
654         bytes32 _ret;
655         assembly {
656             _ret := mload(add(_temp, 32))
657         }
658         return (_ret);
659     }
660 }
661 
662 /**
663  * @title SafeMath v0.1.9
664  * @dev Math operations with safety checks that throw on error
665  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
666  * - added sqrt
667  * - added sq
668  * - added pwr 
669  * - changed asserts to requires with error log outputs
670  * - removed div, its useless
671  */
672 library SafeMath {
673     
674     /**
675     * @dev Multiplies two numbers, throws on overflow.
676     */
677     function mul(uint256 a, uint256 b) 
678         internal 
679         pure 
680         returns (uint256 c) 
681     {
682         if (a == 0) {
683             return 0;
684         }
685         c = a * b;
686         require(c / a == b, "SafeMath mul failed");
687         return c;
688     }
689 
690     /**
691     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
692     */
693     function sub(uint256 a, uint256 b)
694         internal
695         pure
696         returns (uint256) 
697     {
698         require(b <= a, "SafeMath sub failed");
699         return a - b;
700     }
701 
702     /**
703     * @dev Adds two numbers, throws on overflow.
704     */
705     function add(uint256 a, uint256 b)
706         internal
707         pure
708         returns (uint256 c) 
709     {
710         c = a + b;
711         require(c >= a, "SafeMath add failed");
712         return c;
713     }
714     
715     /**
716      * @dev gives square root of given x.
717      */
718     function sqrt(uint256 x)
719         internal
720         pure
721         returns (uint256 y) 
722     {
723         uint256 z = ((add(x,1)) / 2);
724         y = x;
725         while (z < y) 
726         {
727             y = z;
728             z = ((add((x / z),z)) / 2);
729         }
730     }
731     
732     /**
733      * @dev gives square. multiplies x by x
734      */
735     function sq(uint256 x)
736         internal
737         pure
738         returns (uint256)
739     {
740         return (mul(x,x));
741     }
742     
743     /**
744      * @dev x to the power of y 
745      */
746     function pwr(uint256 x, uint256 y)
747         internal 
748         pure 
749         returns (uint256)
750     {
751         if (x==0)
752             return (0);
753         else if (y==0)
754             return (1);
755         else 
756         {
757             uint256 z = x;
758             for (uint256 i=1; i < y; i++)
759                 z = mul(z,x);
760             return (z);
761         }
762     }
763 }