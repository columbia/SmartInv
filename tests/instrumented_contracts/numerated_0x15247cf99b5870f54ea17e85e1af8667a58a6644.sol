1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 
10 contract PlayerBook {
11     using NameFilter for string;
12     using SafeMath for uint256;
13     
14     address private communityAddr = 0xD2F3F49CBEb8B8A23E6174B28643856dac70EB23;
15 //==============================================================================
16 //     _| _ _|_ _    _ _ _|_    _   .
17 //    (_|(_| | (_|  _\(/_ | |_||_)  .
18 //=============================|================================================    
19     uint256 public registrationFee_ = 10 finney;            // price to register a name
20     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
21     mapping(address => bytes32) public gameNames_;          // lookup a games name
22     mapping(address => uint256) public gameIDs_;            // lokup a games ID
23     uint256 public gID_;        // total number of games
24     uint256 public pID_;        // total number of players
25     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
26     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
27     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
28     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
29     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
30     struct Player {
31         address addr;
32         bytes32 name;
33         uint256 laff;
34         uint256 names;
35     }
36 //==============================================================================
37 //     _ _  _  __|_ _    __|_ _  _  .
38 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
39 //==============================================================================    
40     constructor()
41         public
42     {
43         // premine the dev names (sorry not sorry)
44             // No keys are purchased with this method, it's simply locking our addresses,
45             // PID's and names for referral codes.
46         plyr_[1].addr = 0x945Da75110a805C53209E809005c9ceF129DA012;
47         plyr_[1].name = "daddy";
48         plyr_[1].names = 1;
49         pIDxAddr_[0x945Da75110a805C53209E809005c9ceF129DA012] = 1;
50         pIDxName_["daddy"] = 1;
51         plyrNames_[1]["daddy"] = true;
52         plyrNameList_[1][1] = "daddy";
53         
54         plyr_[2].addr = 0x8A4cF0969f8b5D286b87C3713E8908C033A0f020;
55         plyr_[2].name = "player1";
56         plyr_[2].names = 1;
57         pIDxAddr_[0x8A4cF0969f8b5D286b87C3713E8908C033A0f020] = 2;
58         pIDxName_["player1"] = 2;
59         plyrNames_[2]["player1"] = true;
60         plyrNameList_[2][1] = "player1";
61         
62         pID_ = 2;
63     }
64 //==============================================================================
65 //     _ _  _  _|. |`. _  _ _  .
66 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
67 //==============================================================================    
68     /**
69      * @dev prevents contracts from interacting with fomo3d 
70      */
71     modifier isHuman() {
72         address _addr = msg.sender;
73         uint256 _codeLength;
74         
75         assembly {_codeLength := extcodesize(_addr)}
76         require(_codeLength == 0, "sorry humans only");
77         _;
78     }
79     
80     modifier onlyCommunity() 
81     {
82         require(msg.sender == communityAddr, "msg sender is not the community");
83         _;
84     }
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
359         communityAddr.transfer(address(this).balance);
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
539      onlyCommunity()
540         public
541     {
542         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
543 
544             gID_++;
545             bytes32 _name = _gameNameStr.nameFilter();
546             gameIDs_[_gameAddress] = gID_;
547             gameNames_[_gameAddress] = _name;
548             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
549         
550             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
551             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
552             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
553             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
554     }
555     
556     function setRegistrationFee(uint256 _fee)
557      onlyCommunity()
558         public
559     {
560             registrationFee_ = _fee;
561     }
562         
563 } 
564 
565 /**
566 * @title -Name Filter- v0.1.9
567 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
568 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
569 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
570 *                                  _____                      _____
571 *                                 (, /     /)       /) /)    (, /      /)          /)
572 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
573 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
574 *          ┴ ┴                /   /          .-/ _____   (__ /                               
575 *                            (__ /          (_/ (, /                                      /)™ 
576 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
577 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
578 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
579 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
580 *              _       __    _      ____      ____  _   _    _____  ____  ___  
581 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
582 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
583 *
584 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
585 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dddos │
586 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
587 */
588 library NameFilter {
589     
590     /**
591      * @dev filters name strings
592      * -converts uppercase to lower case.  
593      * -makes sure it does not start/end with a space
594      * -makes sure it does not contain multiple spaces in a row
595      * -cannot be only numbers
596      * -cannot start with 0x 
597      * -restricts characters to A-Z, a-z, 0-9, and space.
598      * @return reprocessed string in bytes32 format
599      */
600     function nameFilter(string _input)
601         internal
602         pure
603         returns(bytes32)
604     {
605         bytes memory _temp = bytes(_input);
606         uint256 _length = _temp.length;
607         
608         //sorry limited to 32 characters
609         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
610         // make sure it doesnt start with or end with space
611         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
612         // make sure first two characters are not 0x
613         if (_temp[0] == 0x30)
614         {
615             require(_temp[1] != 0x78, "string cannot start with 0x");
616             require(_temp[1] != 0x58, "string cannot start with 0X");
617         }
618         
619         // create a bool to track if we have a non number character
620         bool _hasNonNumber;
621         
622         // convert & check
623         for (uint256 i = 0; i < _length; i++)
624         {
625             // if its uppercase A-Z
626             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
627             {
628                 // convert to lower case a-z
629                 _temp[i] = byte(uint(_temp[i]) + 32);
630                 
631                 // we have a non number
632                 if (_hasNonNumber == false)
633                     _hasNonNumber = true;
634             } else {
635                 require
636                 (
637                     // require character is a space
638                     _temp[i] == 0x20 || 
639                     // OR lowercase a-z
640                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
641                     // or 0-9
642                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
643                     "string contains invalid characters"
644                 );
645                 // make sure theres not 2x spaces in a row
646                 if (_temp[i] == 0x20)
647                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
648                 
649                 // see if we have a character other than a number
650                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
651                     _hasNonNumber = true;    
652             }
653         }
654         
655         require(_hasNonNumber == true, "string cannot be only numbers");
656         
657         bytes32 _ret;
658         assembly {
659             _ret := mload(add(_temp, 32))
660         }
661         return (_ret);
662     }
663 }
664 
665 /**
666  * @title SafeMath v0.1.9
667  * @dev Math operations with safety checks that throw on error
668  * change notes:  original SafeMath library from OpenZeppelin modified by dddos
669  * - added sqrt
670  * - added sq
671  * - added pwr 
672  * - changed asserts to requires with error log outputs
673  * - removed div, its useless
674  */
675 library SafeMath {
676     
677     /**
678     * @dev Multiplies two numbers, throws on overflow.
679     */
680     function mul(uint256 a, uint256 b) 
681         internal 
682         pure 
683         returns (uint256 c) 
684     {
685         if (a == 0) {
686             return 0;
687         }
688         c = a * b;
689         require(c / a == b, "SafeMath mul failed");
690         return c;
691     }
692 
693     /**
694     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
695     */
696     function sub(uint256 a, uint256 b)
697         internal
698         pure
699         returns (uint256) 
700     {
701         require(b <= a, "SafeMath sub failed");
702         return a - b;
703     }
704 
705     /**
706     * @dev Adds two numbers, throws on overflow.
707     */
708     function add(uint256 a, uint256 b)
709         internal
710         pure
711         returns (uint256 c) 
712     {
713         c = a + b;
714         require(c >= a, "SafeMath add failed");
715         return c;
716     }
717     
718     /**
719      * @dev gives square root of given x.
720      */
721     function sqrt(uint256 x)
722         internal
723         pure
724         returns (uint256 y) 
725     {
726         uint256 z = ((add(x,1)) / 2);
727         y = x;
728         while (z < y) 
729         {
730             y = z;
731             z = ((add((x / z),z)) / 2);
732         }
733     }
734     
735     /**
736      * @dev gives square. multiplies x by x
737      */
738     function sq(uint256 x)
739         internal
740         pure
741         returns (uint256)
742     {
743         return (mul(x,x));
744     }
745     
746     /**
747      * @dev x to the power of y 
748      */
749     function pwr(uint256 x, uint256 y)
750         internal 
751         pure 
752         returns (uint256)
753     {
754         if (x==0)
755             return (0);
756         else if (y==0)
757             return (1);
758         else 
759         {
760             uint256 z = x;
761             for (uint256 i=1; i < y; i++)
762                 z = mul(z,x);
763             return (z);
764         }
765     }
766 }