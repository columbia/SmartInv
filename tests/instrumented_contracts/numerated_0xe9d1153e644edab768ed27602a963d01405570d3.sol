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
14     address private communityAddr = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;
15     address private activate_addr = 0x6C7DFE3c255a098Ea031f334436DD50345cFC737;
16 //==============================================================================
17 //     _| _ _|_ _    _ _ _|_    _   .
18 //    (_|(_| | (_|  _\(/_ | |_||_)  .
19 //=============================|================================================    
20     uint256 public registrationFee_ = 10 finney;            // price to register a name
21     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
22     mapping(address => bytes32) public gameNames_;          // lookup a games name
23     mapping(address => uint256) public gameIDs_;            // lokup a games ID
24     uint256 public gID_;        // total number of games
25     uint256 public pID_;        // total number of players
26     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
27     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
28     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
29     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
30     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
31     struct Player {
32         address addr;
33         bytes32 name;
34         uint256 laff;
35         uint256 names;
36     }
37 //==============================================================================
38 //     _ _  _  __|_ _    __|_ _  _  .
39 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
40 //==============================================================================    
41     constructor()
42         public
43     {
44         // premine the dev names (sorry not sorry)
45             // No keys are purchased with this method, it's simply locking our addresses,
46             // PID's and names for referral codes.
47         plyr_[1].addr = 0x33E161A482C560DCA9180D84706eCDd2D906668B;
48         plyr_[1].name = "west1";
49         plyr_[1].names = 1;
50         pIDxAddr_[0x33E161A482C560DCA9180D84706eCDd2D906668B] = 1;
51         pIDxName_["west1"] = 1;
52         plyrNames_[1]["west1"] = true;
53         plyrNameList_[1][1] = "west1";
54         
55         plyr_[2].addr = 0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c;
56         plyr_[2].name = "west2";
57         plyr_[2].names = 1;
58         pIDxAddr_[0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c] = 2;
59         pIDxName_["west2"] = 2;
60         plyrNames_[2]["west2"] = true;
61         plyrNameList_[2][1] = "west2";
62         
63         plyr_[3].addr = 0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B;
64         plyr_[3].name = "west3";
65         plyr_[3].names = 1;
66         pIDxAddr_[0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B] = 3;
67         pIDxName_["west3"] = 3;
68         plyrNames_[3]["west3"] = true;
69         plyrNameList_[3][1] = "west3";
70         
71         plyr_[4].addr = 0x7649938FAdf6C597F27349D338e3bDC8488c14e6;
72         plyr_[4].name = "west4";
73         plyr_[4].names = 1;
74         pIDxAddr_[0x7649938FAdf6C597F27349D338e3bDC8488c14e6] = 4;
75         pIDxName_["west4"] = 4;
76         plyrNames_[4]["west4"] = true;
77         plyrNameList_[4][1] = "west4";
78         
79         pID_ = 4;
80     }
81 //==============================================================================
82 //     _ _  _  _|. |`. _  _ _  .
83 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
84 //==============================================================================    
85     /**
86      * @dev prevents contracts from interacting with fomo3d 
87      */
88     modifier isHuman() {
89         address _addr = msg.sender;
90         uint256 _codeLength;
91         
92         assembly {_codeLength := extcodesize(_addr)}
93         require(_codeLength == 0, "sorry humans only");
94         _;
95     }
96     
97     modifier onlyCommunity() 
98     {
99         require(msg.sender == activate_addr, "msg sender is not the community");
100         _;
101     }
102     
103     modifier isRegisteredGame()
104     {
105         require(gameIDs_[msg.sender] != 0);
106         _;
107     }
108 //==============================================================================
109 //     _    _  _ _|_ _  .
110 //    (/_\/(/_| | | _\  .
111 //==============================================================================    
112     // fired whenever a player registers a name
113     event onNewName
114     (
115         uint256 indexed playerID,
116         address indexed playerAddress,
117         bytes32 indexed playerName,
118         bool isNewPlayer,
119         uint256 affiliateID,
120         address affiliateAddress,
121         bytes32 affiliateName,
122         uint256 amountPaid,
123         uint256 timeStamp
124     );
125 //==============================================================================
126 //     _  _ _|__|_ _  _ _  .
127 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
128 //=====_|=======================================================================
129     function checkIfNameValid(string _nameStr)
130         public
131         view
132         returns(bool)
133     {
134         bytes32 _name = _nameStr.nameFilter();
135         if (pIDxName_[_name] == 0)
136             return (true);
137         else 
138             return (false);
139     }
140 //==============================================================================
141 //     _    |_ |. _   |`    _  __|_. _  _  _  .
142 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
143 //====|=========================================================================    
144     /**
145      * @dev registers a name.  UI will always display the last name you registered.
146      * but you will still own all previously registered names to use as affiliate 
147      * links.
148      * - must pay a registration fee.
149      * - name must be unique
150      * - names will be converted to lowercase
151      * - name cannot start or end with a space 
152      * - cannot have more than 1 space in a row
153      * - cannot be only numbers
154      * - cannot start with 0x 
155      * - name must be at least 1 char
156      * - max length of 32 characters long
157      * - allowed characters: a-z, 0-9, and space
158      * -functionhash- 0x921dec21 (using ID for affiliate)
159      * -functionhash- 0x3ddd4698 (using address for affiliate)
160      * -functionhash- 0x685ffd83 (using name for affiliate)
161      * @param _nameString players desired name
162      * @param _affCode affiliate ID, address, or name of who refered you
163      * @param _all set to true if you want this to push your info to all games 
164      * (this might cost a lot of gas)
165      */
166     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
167         isHuman()
168         public
169         payable 
170     {
171         // make sure name fees paid
172         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
173         
174         // filter name + condition checks
175         bytes32 _name = NameFilter.nameFilter(_nameString);
176         
177         // set up address 
178         address _addr = msg.sender;
179         
180         // set up our tx event data and determine if player is new or not
181         bool _isNewPlayer = determinePID(_addr);
182         
183         // fetch player id
184         uint256 _pID = pIDxAddr_[_addr];
185         
186         // manage affiliate residuals
187         // if no affiliate code was given, no new affiliate code was given, or the 
188         // player tried to use their own pID as an affiliate code, lolz
189         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
190         {
191             // update last affiliate 
192             plyr_[_pID].laff = _affCode;
193         } else if (_affCode == _pID) {
194             _affCode = 0;
195         }
196         
197         // register name 
198         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
199     }
200     
201     function registerNameXaddr(string _nameString, address _affCode, bool _all)
202         isHuman()
203         public
204         payable 
205     {
206         // make sure name fees paid
207         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
208         
209         // filter name + condition checks
210         bytes32 _name = NameFilter.nameFilter(_nameString);
211         
212         // set up address 
213         address _addr = msg.sender;
214         
215         // set up our tx event data and determine if player is new or not
216         bool _isNewPlayer = determinePID(_addr);
217         
218         // fetch player id
219         uint256 _pID = pIDxAddr_[_addr];
220         
221         // manage affiliate residuals
222         // if no affiliate code was given or player tried to use their own, lolz
223         uint256 _affID;
224         if (_affCode != address(0) && _affCode != _addr)
225         {
226             // get affiliate ID from aff Code 
227             _affID = pIDxAddr_[_affCode];
228             
229             // if affID is not the same as previously stored 
230             if (_affID != plyr_[_pID].laff)
231             {
232                 // update last affiliate
233                 plyr_[_pID].laff = _affID;
234             }
235         }
236         
237         // register name 
238         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
239     }
240     
241     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
242         isHuman()
243         public
244         payable 
245     {
246         // make sure name fees paid
247         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
248         
249         // filter name + condition checks
250         bytes32 _name = NameFilter.nameFilter(_nameString);
251         
252         // set up address 
253         address _addr = msg.sender;
254         
255         // set up our tx event data and determine if player is new or not
256         bool _isNewPlayer = determinePID(_addr);
257         
258         // fetch player id
259         uint256 _pID = pIDxAddr_[_addr];
260         
261         // manage affiliate residuals
262         // if no affiliate code was given or player tried to use their own, lolz
263         uint256 _affID;
264         if (_affCode != "" && _affCode != _name)
265         {
266             // get affiliate ID from aff Code 
267             _affID = pIDxName_[_affCode];
268             
269             // if affID is not the same as previously stored 
270             if (_affID != plyr_[_pID].laff)
271             {
272                 // update last affiliate
273                 plyr_[_pID].laff = _affID;
274             }
275         }
276         
277         // register name 
278         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
279     }
280     
281     /**
282      * @dev players, if you registered a profile, before a game was released, or
283      * set the all bool to false when you registered, use this function to push
284      * your profile to a single game.  also, if you've  updated your name, you
285      * can use this to push your name to games of your choosing.
286      * -functionhash- 0x81c5b206
287      * @param _gameID game id 
288      */
289     function addMeToGame(uint256 _gameID)
290         isHuman()
291         public
292     {
293         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
294         address _addr = msg.sender;
295         uint256 _pID = pIDxAddr_[_addr];
296         require(_pID != 0, "hey there buddy, you dont even have an account");
297         uint256 _totalNames = plyr_[_pID].names;
298         
299         // add players profile and most recent name
300         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
301         
302         // add list of all names
303         if (_totalNames > 1)
304             for (uint256 ii = 1; ii <= _totalNames; ii++)
305                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
306     }
307     
308     /**
309      * @dev players, use this to push your player profile to all registered games.
310      * -functionhash- 0x0c6940ea
311      */
312     function addMeToAllGames()
313         isHuman()
314         public
315     {
316         address _addr = msg.sender;
317         uint256 _pID = pIDxAddr_[_addr];
318         require(_pID != 0, "hey there buddy, you dont even have an account");
319         uint256 _laff = plyr_[_pID].laff;
320         uint256 _totalNames = plyr_[_pID].names;
321         bytes32 _name = plyr_[_pID].name;
322         
323         for (uint256 i = 1; i <= gID_; i++)
324         {
325             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
326             if (_totalNames > 1)
327                 for (uint256 ii = 1; ii <= _totalNames; ii++)
328                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
329         }
330                 
331     }
332     
333     /**
334      * @dev players use this to change back to one of your old names.  tip, you'll
335      * still need to push that info to existing games.
336      * -functionhash- 0xb9291296
337      * @param _nameString the name you want to use 
338      */
339     function useMyOldName(string _nameString)
340         isHuman()
341         public 
342     {
343         // filter name, and get pID
344         bytes32 _name = _nameString.nameFilter();
345         uint256 _pID = pIDxAddr_[msg.sender];
346         
347         // make sure they own the name 
348         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
349         
350         // update their current name 
351         plyr_[_pID].name = _name;
352     }
353     
354 //==============================================================================
355 //     _ _  _ _   | _  _ . _  .
356 //    (_(_)| (/_  |(_)(_||(_  . 
357 //=====================_|=======================================================    
358     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
359         private
360     {
361         // if names already has been used, require that current msg sender owns the name
362         if (pIDxName_[_name] != 0)
363             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
364         
365         // add name to player profile, registry, and name book
366         plyr_[_pID].name = _name;
367         pIDxName_[_name] = _pID;
368         if (plyrNames_[_pID][_name] == false)
369         {
370             plyrNames_[_pID][_name] = true;
371             plyr_[_pID].names++;
372             plyrNameList_[_pID][plyr_[_pID].names] = _name;
373         }
374         
375         // registration fee goes directly to community rewards
376         communityAddr.transfer(address(this).balance);
377         
378         // push player info to games
379         if (_all == true)
380             for (uint256 i = 1; i <= gID_; i++)
381                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
382         
383         // fire event
384         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
385     }
386 //==============================================================================
387 //    _|_ _  _ | _  .
388 //     | (_)(_)|_\  .
389 //==============================================================================    
390     function determinePID(address _addr)
391         private
392         returns (bool)
393     {
394         if (pIDxAddr_[_addr] == 0)
395         {
396             pID_++;
397             pIDxAddr_[_addr] = pID_;
398             plyr_[pID_].addr = _addr;
399             
400             // set the new player bool to true
401             return (true);
402         } else {
403             return (false);
404         }
405     }
406 //==============================================================================
407 //   _   _|_ _  _ _  _ |   _ _ || _  .
408 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
409 //==============================================================================
410     function getPlayerID(address _addr)
411         isRegisteredGame()
412         external
413         returns (uint256)
414     {
415         determinePID(_addr);
416         return (pIDxAddr_[_addr]);
417     }
418     function getPlayerName(uint256 _pID)
419         external
420         view
421         returns (bytes32)
422     {
423         return (plyr_[_pID].name);
424     }
425     function getPlayerLAff(uint256 _pID)
426         external
427         view
428         returns (uint256)
429     {
430         return (plyr_[_pID].laff);
431     }
432     function getPlayerAddr(uint256 _pID)
433         external
434         view
435         returns (address)
436     {
437         return (plyr_[_pID].addr);
438     }
439     function getNameFee()
440         external
441         view
442         returns (uint256)
443     {
444         return(registrationFee_);
445     }
446     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
447         isRegisteredGame()
448         external
449         payable
450         returns(bool, uint256)
451     {
452         // make sure name fees paid
453         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
454         
455         // set up our tx event data and determine if player is new or not
456         bool _isNewPlayer = determinePID(_addr);
457         
458         // fetch player id
459         uint256 _pID = pIDxAddr_[_addr];
460         
461         // manage affiliate residuals
462         // if no affiliate code was given, no new affiliate code was given, or the 
463         // player tried to use their own pID as an affiliate code, lolz
464         uint256 _affID = _affCode;
465         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
466         {
467             // update last affiliate 
468             plyr_[_pID].laff = _affID;
469         } else if (_affID == _pID) {
470             _affID = 0;
471         }
472         
473         // register name 
474         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
475         
476         return(_isNewPlayer, _affID);
477     }
478     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
479         isRegisteredGame()
480         external
481         payable
482         returns(bool, uint256)
483     {
484         // make sure name fees paid
485         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
486         
487         // set up our tx event data and determine if player is new or not
488         bool _isNewPlayer = determinePID(_addr);
489         
490         // fetch player id
491         uint256 _pID = pIDxAddr_[_addr];
492         
493         // manage affiliate residuals
494         // if no affiliate code was given or player tried to use their own, lolz
495         uint256 _affID;
496         if (_affCode != address(0) && _affCode != _addr)
497         {
498             // get affiliate ID from aff Code 
499             _affID = pIDxAddr_[_affCode];
500             
501             // if affID is not the same as previously stored 
502             if (_affID != plyr_[_pID].laff)
503             {
504                 // update last affiliate
505                 plyr_[_pID].laff = _affID;
506             }
507         }
508         
509         // register name 
510         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
511         
512         return(_isNewPlayer, _affID);
513     }
514     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
515         isRegisteredGame()
516         external
517         payable
518         returns(bool, uint256)
519     {
520         // make sure name fees paid
521         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
522         
523         // set up our tx event data and determine if player is new or not
524         bool _isNewPlayer = determinePID(_addr);
525         
526         // fetch player id
527         uint256 _pID = pIDxAddr_[_addr];
528         
529         // manage affiliate residuals
530         // if no affiliate code was given or player tried to use their own, lolz
531         uint256 _affID;
532         if (_affCode != "" && _affCode != _name)
533         {
534             // get affiliate ID from aff Code 
535             _affID = pIDxName_[_affCode];
536             
537             // if affID is not the same as previously stored 
538             if (_affID != plyr_[_pID].laff)
539             {
540                 // update last affiliate
541                 plyr_[_pID].laff = _affID;
542             }
543         }
544         
545         // register name 
546         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
547         
548         return(_isNewPlayer, _affID);
549     }
550     
551 //==============================================================================
552 //   _ _ _|_    _   .
553 //  _\(/_ | |_||_)  .
554 //=============|================================================================
555     function addGame(address _gameAddress, string _gameNameStr)
556      onlyCommunity()
557         public
558     {
559         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
560 
561             gID_++;
562             bytes32 _name = _gameNameStr.nameFilter();
563             gameIDs_[_gameAddress] = gID_;
564             gameNames_[_gameAddress] = _name;
565             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
566         
567             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
568             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
569             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
570             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
571     }
572     
573     function setRegistrationFee(uint256 _fee)
574      onlyCommunity()
575         public
576     {
577             registrationFee_ = _fee;
578     }
579         
580 } 
581 
582 /**
583 * @title -Name Filter- v0.1.9
584 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
585 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
586 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
587 *                                  _____                      _____
588 *                                 (, /     /)       /) /)    (, /      /)          /)
589 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
590 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
591 *          ┴ ┴                /   /          .-/ _____   (__ /                               
592 *                            (__ /          (_/ (, /                                      /)™ 
593 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
594 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
595 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
596 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
597 *              _       __    _      ____      ____  _   _    _____  ____  ___  
598 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
599 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
600 *
601 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
602 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dddos │
603 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
604 */
605 library NameFilter {
606     
607     /**
608      * @dev filters name strings
609      * -converts uppercase to lower case.  
610      * -makes sure it does not start/end with a space
611      * -makes sure it does not contain multiple spaces in a row
612      * -cannot be only numbers
613      * -cannot start with 0x 
614      * -restricts characters to A-Z, a-z, 0-9, and space.
615      * @return reprocessed string in bytes32 format
616      */
617     function nameFilter(string _input)
618         internal
619         pure
620         returns(bytes32)
621     {
622         bytes memory _temp = bytes(_input);
623         uint256 _length = _temp.length;
624         
625         //sorry limited to 32 characters
626         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
627         // make sure it doesnt start with or end with space
628         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
629         // make sure first two characters are not 0x
630         if (_temp[0] == 0x30)
631         {
632             require(_temp[1] != 0x78, "string cannot start with 0x");
633             require(_temp[1] != 0x58, "string cannot start with 0X");
634         }
635         
636         // create a bool to track if we have a non number character
637         bool _hasNonNumber;
638         
639         // convert & check
640         for (uint256 i = 0; i < _length; i++)
641         {
642             // if its uppercase A-Z
643             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
644             {
645                 // convert to lower case a-z
646                 _temp[i] = byte(uint(_temp[i]) + 32);
647                 
648                 // we have a non number
649                 if (_hasNonNumber == false)
650                     _hasNonNumber = true;
651             } else {
652                 require
653                 (
654                     // require character is a space
655                     _temp[i] == 0x20 || 
656                     // OR lowercase a-z
657                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
658                     // or 0-9
659                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
660                     "string contains invalid characters"
661                 );
662                 // make sure theres not 2x spaces in a row
663                 if (_temp[i] == 0x20)
664                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
665                 
666                 // see if we have a character other than a number
667                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
668                     _hasNonNumber = true;    
669             }
670         }
671         
672         require(_hasNonNumber == true, "string cannot be only numbers");
673         
674         bytes32 _ret;
675         assembly {
676             _ret := mload(add(_temp, 32))
677         }
678         return (_ret);
679     }
680 }
681 
682 /**
683  * @title SafeMath v0.1.9
684  * @dev Math operations with safety checks that throw on error
685  * change notes:  original SafeMath library from OpenZeppelin modified by dddos
686  * - added sqrt
687  * - added sq
688  * - added pwr 
689  * - changed asserts to requires with error log outputs
690  * - removed div, its useless
691  */
692 library SafeMath {
693     
694     /**
695     * @dev Multiplies two numbers, throws on overflow.
696     */
697     function mul(uint256 a, uint256 b) 
698         internal 
699         pure 
700         returns (uint256 c) 
701     {
702         if (a == 0) {
703             return 0;
704         }
705         c = a * b;
706         require(c / a == b, "SafeMath mul failed");
707         return c;
708     }
709 
710     /**
711     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
712     */
713     function sub(uint256 a, uint256 b)
714         internal
715         pure
716         returns (uint256) 
717     {
718         require(b <= a, "SafeMath sub failed");
719         return a - b;
720     }
721 
722     /**
723     * @dev Adds two numbers, throws on overflow.
724     */
725     function add(uint256 a, uint256 b)
726         internal
727         pure
728         returns (uint256 c) 
729     {
730         c = a + b;
731         require(c >= a, "SafeMath add failed");
732         return c;
733     }
734     
735     /**
736      * @dev gives square root of given x.
737      */
738     function sqrt(uint256 x)
739         internal
740         pure
741         returns (uint256 y) 
742     {
743         uint256 z = ((add(x,1)) / 2);
744         y = x;
745         while (z < y) 
746         {
747             y = z;
748             z = ((add((x / z),z)) / 2);
749         }
750     }
751     
752     /**
753      * @dev gives square. multiplies x by x
754      */
755     function sq(uint256 x)
756         internal
757         pure
758         returns (uint256)
759     {
760         return (mul(x,x));
761     }
762     
763     /**
764      * @dev x to the power of y 
765      */
766     function pwr(uint256 x, uint256 y)
767         internal 
768         pure 
769         returns (uint256)
770     {
771         if (x==0)
772             return (0);
773         else if (y==0)
774             return (1);
775         else 
776         {
777             uint256 z = x;
778             for (uint256 i=1; i < y; i++)
779                 z = mul(z,x);
780             return (z);
781         }
782     }
783 }