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
41     address private mgt;
42     address private dev;
43 //==============================================================================
44 //     _| _ _|_ _    _ _ _|_    _   .
45 //    (_|(_| | (_|  _\(/_ | |_||_)  .
46 //=============================|================================================    
47     uint256 public registrationFee_ = 10 finney;            // price to register a name
48     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
49     mapping(address => bytes32) public gameNames_;          // lookup a games name
50     mapping(address => uint256) public gameIDs_;            // lokup a games ID
51     uint256 public gID_;        // total number of games
52     uint256 public pID_;        // total number of players
53     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
54     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
55     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
56     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
57     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
58     struct Player {
59         address addr;
60         bytes32 name;
61         uint256 laff;
62         uint256 names;
63     }
64 //==============================================================================
65 //     _ _  _  __|_ _    __|_ _  _  .
66 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
67 //==============================================================================    
68     constructor(address _mgt, address _dev)
69         public
70     {
71         mgt = _mgt;
72         dev = _dev;
73         // premine the dev names (sorry not sorry)
74             // No keys are purchased with this method, it's simply locking our addresses,
75             // PID's and names for referral codes.
76         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
77         plyr_[1].name = "justo";
78         plyr_[1].names = 1;
79         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
80         pIDxName_["justo"] = 1;
81         plyrNames_[1]["justo"] = true;
82         plyrNameList_[1][1] = "justo";
83         
84         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
85         plyr_[2].name = "mantso";
86         plyr_[2].names = 1;
87         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
88         pIDxName_["mantso"] = 2;
89         plyrNames_[2]["mantso"] = true;
90         plyrNameList_[2][1] = "mantso";
91         
92         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
93         plyr_[3].name = "sumpunk";
94         plyr_[3].names = 1;
95         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
96         pIDxName_["sumpunk"] = 3;
97         plyrNames_[3]["sumpunk"] = true;
98         plyrNameList_[3][1] = "sumpunk";
99         
100         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
101         plyr_[4].name = "inventor";
102         plyr_[4].names = 1;
103         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
104         pIDxName_["inventor"] = 4;
105         plyrNames_[4]["inventor"] = true;
106         plyrNameList_[4][1] = "inventor";
107         
108         pID_ = 4;
109     }
110 //==============================================================================
111 //     _ _  _  _|. |`. _  _ _  .
112 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
113 //==============================================================================    
114     /**
115      * @dev prevents contracts from interacting with fomo3d 
116      */
117     modifier isHuman() {
118         address _addr = msg.sender;
119         uint256 _codeLength;
120         
121         assembly {_codeLength := extcodesize(_addr)}
122         require(_codeLength == 0, "sorry humans only");
123         _;
124     }
125 
126     modifier onlyDevs() 
127     {
128         require(admin == msg.sender, "msg sender is not a dev");
129         _;
130     }
131     
132     modifier isRegisteredGame()
133     {
134         require(gameIDs_[msg.sender] != 0);
135         _;
136     }
137 //==============================================================================
138 //     _    _  _ _|_ _  .
139 //    (/_\/(/_| | | _\  .
140 //==============================================================================    
141     // fired whenever a player registers a name
142     event onNewName
143     (
144         uint256 indexed playerID,
145         address indexed playerAddress,
146         bytes32 indexed playerName,
147         bool isNewPlayer,
148         uint256 affiliateID,
149         address affiliateAddress,
150         bytes32 affiliateName,
151         uint256 amountPaid,
152         uint256 timeStamp
153     );
154 //==============================================================================
155 //     _  _ _|__|_ _  _ _  .
156 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
157 //=====_|=======================================================================
158     function checkIfNameValid(string _nameStr)
159         public
160         view
161         returns(bool)
162     {
163         bytes32 _name = _nameStr.nameFilter();
164         if (pIDxName_[_name] == 0)
165             return (true);
166         else 
167             return (false);
168     }
169 //==============================================================================
170 //     _    |_ |. _   |`    _  __|_. _  _  _  .
171 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
172 //====|=========================================================================    
173     /**
174      * @dev registers a name.  UI will always display the last name you registered.
175      * but you will still own all previously registered names to use as affiliate 
176      * links.
177      * - must pay a registration fee.
178      * - name must be unique
179      * - names will be converted to lowercase
180      * - name cannot start or end with a space 
181      * - cannot have more than 1 space in a row
182      * - cannot be only numbers
183      * - cannot start with 0x 
184      * - name must be at least 1 char
185      * - max length of 32 characters long
186      * - allowed characters: a-z, 0-9, and space
187      * -functionhash- 0x921dec21 (using ID for affiliate)
188      * -functionhash- 0x3ddd4698 (using address for affiliate)
189      * -functionhash- 0x685ffd83 (using name for affiliate)
190      * @param _nameString players desired name
191      * @param _affCode affiliate ID, address, or name of who refered you
192      * @param _all set to true if you want this to push your info to all games 
193      * (this might cost a lot of gas)
194      */
195     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
196         isHuman()
197         public
198         payable 
199     {
200         // make sure name fees paid
201         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
202         
203         // filter name + condition checks
204         bytes32 _name = NameFilter.nameFilter(_nameString);
205         
206         // set up address 
207         address _addr = msg.sender;
208         
209         // set up our tx event data and determine if player is new or not
210         bool _isNewPlayer = determinePID(_addr);
211         
212         // fetch player id
213         uint256 _pID = pIDxAddr_[_addr];
214         
215         // manage affiliate residuals
216         // if no affiliate code was given, no new affiliate code was given, or the 
217         // player tried to use their own pID as an affiliate code, lolz
218         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
219         {
220             // update last affiliate 
221             plyr_[_pID].laff = _affCode;
222         } else if (_affCode == _pID) {
223             _affCode = 0;
224         }
225         
226         // register name 
227         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
228     }
229     
230     function registerNameXaddr(string _nameString, address _affCode, bool _all)
231         isHuman()
232         public
233         payable 
234     {
235         // make sure name fees paid
236         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
237         
238         // filter name + condition checks
239         bytes32 _name = NameFilter.nameFilter(_nameString);
240         
241         // set up address 
242         address _addr = msg.sender;
243         
244         // set up our tx event data and determine if player is new or not
245         bool _isNewPlayer = determinePID(_addr);
246         
247         // fetch player id
248         uint256 _pID = pIDxAddr_[_addr];
249         
250         // manage affiliate residuals
251         // if no affiliate code was given or player tried to use their own, lolz
252         uint256 _affID;
253         if (_affCode != address(0) && _affCode != _addr)
254         {
255             // get affiliate ID from aff Code 
256             _affID = pIDxAddr_[_affCode];
257             
258             // if affID is not the same as previously stored 
259             if (_affID != plyr_[_pID].laff)
260             {
261                 // update last affiliate
262                 plyr_[_pID].laff = _affID;
263             }
264         }
265         
266         // register name 
267         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
268     }
269     
270     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
271         isHuman()
272         public
273         payable 
274     {
275         // make sure name fees paid
276         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
277         
278         // filter name + condition checks
279         bytes32 _name = NameFilter.nameFilter(_nameString);
280         
281         // set up address 
282         address _addr = msg.sender;
283         
284         // set up our tx event data and determine if player is new or not
285         bool _isNewPlayer = determinePID(_addr);
286         
287         // fetch player id
288         uint256 _pID = pIDxAddr_[_addr];
289         
290         // manage affiliate residuals
291         // if no affiliate code was given or player tried to use their own, lolz
292         uint256 _affID;
293         if (_affCode != "" && _affCode != _name)
294         {
295             // get affiliate ID from aff Code 
296             _affID = pIDxName_[_affCode];
297             
298             // if affID is not the same as previously stored 
299             if (_affID != plyr_[_pID].laff)
300             {
301                 // update last affiliate
302                 plyr_[_pID].laff = _affID;
303             }
304         }
305         
306         // register name 
307         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
308     }
309     
310     /**
311      * @dev players, if you registered a profile, before a game was released, or
312      * set the all bool to false when you registered, use this function to push
313      * your profile to a single game.  also, if you've  updated your name, you
314      * can use this to push your name to games of your choosing.
315      * -functionhash- 0x81c5b206
316      * @param _gameID game id 
317      */
318     function addMeToGame(uint256 _gameID)
319         isHuman()
320         public
321     {
322         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
323         address _addr = msg.sender;
324         uint256 _pID = pIDxAddr_[_addr];
325         require(_pID != 0, "hey there buddy, you dont even have an account");
326         uint256 _totalNames = plyr_[_pID].names;
327         
328         // add players profile and most recent name
329         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
330         
331         // add list of all names
332         if (_totalNames > 1)
333             for (uint256 ii = 1; ii <= _totalNames; ii++)
334                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
335     }
336     
337     /**
338      * @dev players, use this to push your player profile to all registered games.
339      * -functionhash- 0x0c6940ea
340      */
341     function addMeToAllGames()
342         isHuman()
343         public
344     {
345         address _addr = msg.sender;
346         uint256 _pID = pIDxAddr_[_addr];
347         require(_pID != 0, "hey there buddy, you dont even have an account");
348         uint256 _laff = plyr_[_pID].laff;
349         uint256 _totalNames = plyr_[_pID].names;
350         bytes32 _name = plyr_[_pID].name;
351         
352         for (uint256 i = 1; i <= gID_; i++)
353         {
354             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
355             if (_totalNames > 1)
356                 for (uint256 ii = 1; ii <= _totalNames; ii++)
357                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
358         }
359                 
360     }
361     
362     /**
363      * @dev players use this to change back to one of your old names.  tip, you'll
364      * still need to push that info to existing games.
365      * -functionhash- 0xb9291296
366      * @param _nameString the name you want to use 
367      */
368     function useMyOldName(string _nameString)
369         isHuman()
370         public 
371     {
372         // filter name, and get pID
373         bytes32 _name = _nameString.nameFilter();
374         uint256 _pID = pIDxAddr_[msg.sender];
375         
376         // make sure they own the name 
377         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
378         
379         // update their current name 
380         plyr_[_pID].name = _name;
381     }
382     
383 //==============================================================================
384 //     _ _  _ _   | _  _ . _  .
385 //    (_(_)| (/_  |(_)(_||(_  . 
386 //=====================_|=======================================================    
387     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
388         private
389     {
390         // if names already has been used, require that current msg sender owns the name
391         if (pIDxName_[_name] != 0)
392             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
393         
394         // add name to player profile, registry, and name book
395         plyr_[_pID].name = _name;
396         pIDxName_[_name] = _pID;
397         if (plyrNames_[_pID][_name] == false)
398         {
399             plyrNames_[_pID][_name] = true;
400             plyr_[_pID].names++;
401             plyrNameList_[_pID][plyr_[_pID].names] = _name;
402         }
403         
404         // registration fee goes directly to community rewards
405         dev.transfer(address(this).balance / 5);
406         mgt.transfer(address(this).balance);
407         
408         // push player info to games
409         if (_all == true)
410             for (uint256 i = 1; i <= gID_; i++)
411                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
412         
413         // fire event
414         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
415     }
416 //==============================================================================
417 //    _|_ _  _ | _  .
418 //     | (_)(_)|_\  .
419 //==============================================================================    
420     function determinePID(address _addr)
421         private
422         returns (bool)
423     {
424         if (pIDxAddr_[_addr] == 0)
425         {
426             pID_++;
427             pIDxAddr_[_addr] = pID_;
428             plyr_[pID_].addr = _addr;
429             
430             // set the new player bool to true
431             return (true);
432         } else {
433             return (false);
434         }
435     }
436 //==============================================================================
437 //   _   _|_ _  _ _  _ |   _ _ || _  .
438 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
439 //==============================================================================
440     function getPlayerID(address _addr)
441         isRegisteredGame()
442         external
443         returns (uint256)
444     {
445         determinePID(_addr);
446         return (pIDxAddr_[_addr]);
447     }
448     function getPlayerName(uint256 _pID)
449         external
450         view
451         returns (bytes32)
452     {
453         return (plyr_[_pID].name);
454     }
455     function getPlayerLAff(uint256 _pID)
456         external
457         view
458         returns (uint256)
459     {
460         return (plyr_[_pID].laff);
461     }
462     function getPlayerAddr(uint256 _pID)
463         external
464         view
465         returns (address)
466     {
467         return (plyr_[_pID].addr);
468     }
469     function getNameFee()
470         external
471         view
472         returns (uint256)
473     {
474         return(registrationFee_);
475     }
476     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
477         isRegisteredGame()
478         external
479         payable
480         returns(bool, uint256)
481     {
482         // make sure name fees paid
483         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
484         
485         // set up our tx event data and determine if player is new or not
486         bool _isNewPlayer = determinePID(_addr);
487         
488         // fetch player id
489         uint256 _pID = pIDxAddr_[_addr];
490         
491         // manage affiliate residuals
492         // if no affiliate code was given, no new affiliate code was given, or the 
493         // player tried to use their own pID as an affiliate code, lolz
494         uint256 _affID = _affCode;
495         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
496         {
497             // update last affiliate 
498             plyr_[_pID].laff = _affID;
499         } else if (_affID == _pID) {
500             _affID = 0;
501         }
502         
503         // register name 
504         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
505         
506         return(_isNewPlayer, _affID);
507     }
508     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
509         isRegisteredGame()
510         external
511         payable
512         returns(bool, uint256)
513     {
514         // make sure name fees paid
515         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
516         
517         // set up our tx event data and determine if player is new or not
518         bool _isNewPlayer = determinePID(_addr);
519         
520         // fetch player id
521         uint256 _pID = pIDxAddr_[_addr];
522         
523         // manage affiliate residuals
524         // if no affiliate code was given or player tried to use their own, lolz
525         uint256 _affID;
526         if (_affCode != address(0) && _affCode != _addr)
527         {
528             // get affiliate ID from aff Code 
529             _affID = pIDxAddr_[_affCode];
530             
531             // if affID is not the same as previously stored 
532             if (_affID != plyr_[_pID].laff)
533             {
534                 // update last affiliate
535                 plyr_[_pID].laff = _affID;
536             }
537         }
538         
539         // register name 
540         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
541         
542         return(_isNewPlayer, _affID);
543     }
544     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
545         isRegisteredGame()
546         external
547         payable
548         returns(bool, uint256)
549     {
550         // make sure name fees paid
551         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
552         
553         // set up our tx event data and determine if player is new or not
554         bool _isNewPlayer = determinePID(_addr);
555         
556         // fetch player id
557         uint256 _pID = pIDxAddr_[_addr];
558         
559         // manage affiliate residuals
560         // if no affiliate code was given or player tried to use their own, lolz
561         uint256 _affID;
562         if (_affCode != "" && _affCode != _name)
563         {
564             // get affiliate ID from aff Code 
565             _affID = pIDxName_[_affCode];
566             
567             // if affID is not the same as previously stored 
568             if (_affID != plyr_[_pID].laff)
569             {
570                 // update last affiliate
571                 plyr_[_pID].laff = _affID;
572             }
573         }
574         
575         // register name 
576         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
577         
578         return(_isNewPlayer, _affID);
579     }
580     
581 //==============================================================================
582 //   _ _ _|_    _   .
583 //  _\(/_ | |_||_)  .
584 //=============|================================================================
585     function addGame(address _gameAddress, string _gameNameStr)
586         onlyDevs()
587         public
588     {
589         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
590             gID_++;
591             bytes32 _name = _gameNameStr.nameFilter();
592             gameIDs_[_gameAddress] = gID_;
593             gameNames_[_gameAddress] = _name;
594             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
595         
596             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
597             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
598             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
599             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
600     }
601     
602     function setRegistrationFee(uint256 _fee)
603         onlyDevs()
604         public
605     {
606       registrationFee_ = _fee;
607     }
608         
609 } 
610 
611 /**
612 * @title -Name Filter- v0.1.9
613 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
614 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
615 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
616 *                                  _____                      _____
617 *                                 (, /     /)       /) /)    (, /      /)          /)
618 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
619 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
620 *          ┴ ┴                /   /          .-/ _____   (__ /                               
621 *                            (__ /          (_/ (, /                                      /)™ 
622 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
623 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
624 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
625 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
626 *              _       __    _      ____      ____  _   _    _____  ____  ___  
627 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
628 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
629 *
630 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
631 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
632 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
633 */
634 library NameFilter {
635     
636     /**
637      * @dev filters name strings
638      * -converts uppercase to lower case.  
639      * -makes sure it does not start/end with a space
640      * -makes sure it does not contain multiple spaces in a row
641      * -cannot be only numbers
642      * -cannot start with 0x 
643      * -restricts characters to A-Z, a-z, 0-9, and space.
644      * @return reprocessed string in bytes32 format
645      */
646     function nameFilter(string _input)
647         internal
648         pure
649         returns(bytes32)
650     {
651         bytes memory _temp = bytes(_input);
652         uint256 _length = _temp.length;
653         
654         //sorry limited to 32 characters
655         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
656         // make sure it doesnt start with or end with space
657         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
658         // make sure first two characters are not 0x
659         if (_temp[0] == 0x30)
660         {
661             require(_temp[1] != 0x78, "string cannot start with 0x");
662             require(_temp[1] != 0x58, "string cannot start with 0X");
663         }
664         
665         // create a bool to track if we have a non number character
666         bool _hasNonNumber;
667         
668         // convert & check
669         for (uint256 i = 0; i < _length; i++)
670         {
671             // if its uppercase A-Z
672             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
673             {
674                 // convert to lower case a-z
675                 _temp[i] = byte(uint(_temp[i]) + 32);
676                 
677                 // we have a non number
678                 if (_hasNonNumber == false)
679                     _hasNonNumber = true;
680             } else {
681                 require
682                 (
683                     // require character is a space
684                     _temp[i] == 0x20 || 
685                     // OR lowercase a-z
686                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
687                     // or 0-9
688                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
689                     "string contains invalid characters"
690                 );
691                 // make sure theres not 2x spaces in a row
692                 if (_temp[i] == 0x20)
693                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
694                 
695                 // see if we have a character other than a number
696                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
697                     _hasNonNumber = true;    
698             }
699         }
700         
701         require(_hasNonNumber == true, "string cannot be only numbers");
702         
703         bytes32 _ret;
704         assembly {
705             _ret := mload(add(_temp, 32))
706         }
707         return (_ret);
708     }
709 }
710 
711 /**
712  * @title SafeMath v0.1.9
713  * @dev Math operations with safety checks that throw on error
714  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
715  * - added sqrt
716  * - added sq
717  * - added pwr 
718  * - changed asserts to requires with error log outputs
719  * - removed div, its useless
720  */
721 library SafeMath {
722     
723     /**
724     * @dev Multiplies two numbers, throws on overflow.
725     */
726     function mul(uint256 a, uint256 b) 
727         internal 
728         pure 
729         returns (uint256 c) 
730     {
731         if (a == 0) {
732             return 0;
733         }
734         c = a * b;
735         require(c / a == b, "SafeMath mul failed");
736         return c;
737     }
738 
739     /**
740     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
741     */
742     function sub(uint256 a, uint256 b)
743         internal
744         pure
745         returns (uint256) 
746     {
747         require(b <= a, "SafeMath sub failed");
748         return a - b;
749     }
750 
751     /**
752     * @dev Adds two numbers, throws on overflow.
753     */
754     function add(uint256 a, uint256 b)
755         internal
756         pure
757         returns (uint256 c) 
758     {
759         c = a + b;
760         require(c >= a, "SafeMath add failed");
761         return c;
762     }
763     
764     /**
765      * @dev gives square root of given x.
766      */
767     function sqrt(uint256 x)
768         internal
769         pure
770         returns (uint256 y) 
771     {
772         uint256 z = ((add(x,1)) / 2);
773         y = x;
774         while (z < y) 
775         {
776             y = z;
777             z = ((add((x / z),z)) / 2);
778         }
779     }
780     
781     /**
782      * @dev gives square. multiplies x by x
783      */
784     function sq(uint256 x)
785         internal
786         pure
787         returns (uint256)
788     {
789         return (mul(x,x));
790     }
791     
792     /**
793      * @dev x to the power of y 
794      */
795     function pwr(uint256 x, uint256 y)
796         internal 
797         pure 
798         returns (uint256)
799     {
800         if (x==0)
801             return (0);
802         else if (y==0)
803             return (1);
804         else 
805         {
806             uint256 z = x;
807             for (uint256 i=1; i < y; i++)
808                 z = mul(z,x);
809             return (z);
810         }
811     }
812 }