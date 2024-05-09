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
14     address private communityAddr = 0x180A14aF38384dc15Ce96cbcabCfC8F47794AC3E;
15     address private activateAddr1 = 0x6C7DFE3c255a098Ea031f334436DD50345cFC737;
16     address private activateAddr2 = 0x180A14aF38384dc15Ce96cbcabCfC8F47794AC3E;
17 //==============================================================================
18 //     _| _ _|_ _    _ _ _|_    _   .
19 //    (_|(_| | (_|  _\(/_ | |_||_)  .
20 //=============================|================================================    
21     uint256 public registrationFee_ = 1 finney;            // price to register a name
22     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
23     mapping(address => bytes32) public gameNames_;          // lookup a games name
24     mapping(address => uint256) public gameIDs_;            // lokup a games ID
25     uint256 public gID_;        // total number of games
26     uint256 public pID_;        // total number of players
27     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
28     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
29     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
30     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
31     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
32     struct Player {
33         address addr;
34         bytes32 name;
35         uint256 laff;
36         uint256 names;
37     }
38 //==============================================================================
39 //     _ _  _  __|_ _    __|_ _  _  .
40 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
41 //==============================================================================    
42     constructor()
43         public
44     {
45         // premine the dev names (sorry not sorry)
46             // No keys are purchased with this method, it's simply locking our addresses,
47             // PID's and names for referral codes.
48         plyr_[1].addr = 0x33E161A482C560DCA9180D84706eCDd2D906668B;
49         plyr_[1].name = "daddy";
50         plyr_[1].names = 1;
51         pIDxAddr_[0x33E161A482C560DCA9180D84706eCDd2D906668B] = 1;
52         pIDxName_["daddy"] = 1;
53         plyrNames_[1]["daddy"] = true;
54         plyrNameList_[1][1] = "daddy";
55         
56         plyr_[2].addr = 0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c;
57         plyr_[2].name = "suoha";
58         plyr_[2].names = 1;
59         pIDxAddr_[0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c] = 2;
60         pIDxName_["suoha"] = 2;
61         plyrNames_[2]["suoha"] = true;
62         plyrNameList_[2][1] = "suoha";
63         
64         plyr_[3].addr = 0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B;
65         plyr_[3].name = "nodumb";
66         plyr_[3].names = 1;
67         pIDxAddr_[0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B] = 3;
68         pIDxName_["nodumb"] = 3;
69         plyrNames_[3]["nodumb"] = true;
70         plyrNameList_[3][1] = "nodumb";
71         
72         plyr_[4].addr = 0x7649938FAdf6C597F27349D338e3bDC8488c14e6;
73         plyr_[4].name = "dddos";
74         plyr_[4].names = 1;
75         pIDxAddr_[0x7649938FAdf6C597F27349D338e3bDC8488c14e6] = 4;
76         pIDxName_["dddos"] = 4;
77         plyrNames_[4]["dddos"] = true;
78         plyrNameList_[4][1] = "dddos";
79         
80         pID_ = 4;
81     }
82 //==============================================================================
83 //     _ _  _  _|. |`. _  _ _  .
84 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
85 //==============================================================================    
86     /**
87      * @dev prevents contracts from interacting with fomo3d 
88      */
89     modifier isHuman() {
90         address _addr = msg.sender;
91         uint256 _codeLength;
92         
93         assembly {_codeLength := extcodesize(_addr)}
94         require(_codeLength == 0, "sorry humans only");
95         _;
96     }
97     
98     modifier onlyCommunity() 
99     {
100         require(msg.sender == activateAddr1 || msg.sender == activateAddr2, "msg sender is not the community");
101         _;
102     }
103     
104     modifier isRegisteredGame()
105     {
106         require(gameIDs_[msg.sender] != 0);
107         _;
108     }
109 //==============================================================================
110 //     _    _  _ _|_ _  .
111 //    (/_\/(/_| | | _\  .
112 //==============================================================================    
113     // fired whenever a player registers a name
114     event onNewName
115     (
116         uint256 indexed playerID,
117         address indexed playerAddress,
118         bytes32 indexed playerName,
119         bool isNewPlayer,
120         uint256 affiliateID,
121         address affiliateAddress,
122         bytes32 affiliateName,
123         uint256 amountPaid,
124         uint256 timeStamp
125     );
126 //==============================================================================
127 //     _  _ _|__|_ _  _ _  .
128 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
129 //=====_|=======================================================================
130     function checkIfNameValid(string _nameStr)
131         public
132         view
133         returns(bool)
134     {
135         bytes32 _name = _nameStr.nameFilter();
136         if (pIDxName_[_name] == 0)
137             return (true);
138         else 
139             return (false);
140     }
141 //==============================================================================
142 //     _    |_ |. _   |`    _  __|_. _  _  _  .
143 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
144 //====|=========================================================================    
145     /**
146      * @dev registers a name.  UI will always display the last name you registered.
147      * but you will still own all previously registered names to use as affiliate 
148      * links.
149      * - must pay a registration fee.
150      * - name must be unique
151      * - names will be converted to lowercase
152      * - name cannot start or end with a space 
153      * - cannot have more than 1 space in a row
154      * - cannot be only numbers
155      * - cannot start with 0x 
156      * - name must be at least 1 char
157      * - max length of 32 characters long
158      * - allowed characters: a-z, 0-9, and space
159      * -functionhash- 0x921dec21 (using ID for affiliate)
160      * -functionhash- 0x3ddd4698 (using address for affiliate)
161      * -functionhash- 0x685ffd83 (using name for affiliate)
162      * @param _nameString players desired name
163      * @param _affCode affiliate ID, address, or name of who refered you
164      * @param _all set to true if you want this to push your info to all games 
165      * (this might cost a lot of gas)
166      */
167     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
168         isHuman()
169         public
170         payable 
171     {
172         // make sure name fees paid
173         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
174         
175         // filter name + condition checks
176         bytes32 _name = NameFilter.nameFilter(_nameString);
177         
178         // set up address 
179         address _addr = msg.sender;
180         
181         // set up our tx event data and determine if player is new or not
182         bool _isNewPlayer = determinePID(_addr);
183         
184         // fetch player id
185         uint256 _pID = pIDxAddr_[_addr];
186         
187         // manage affiliate residuals
188         // if no affiliate code was given, no new affiliate code was given, or the 
189         // player tried to use their own pID as an affiliate code, lolz
190         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
191         {
192             // update last affiliate 
193             plyr_[_pID].laff = _affCode;
194         } else if (_affCode == _pID) {
195             _affCode = 0;
196         }
197         
198         // register name 
199         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
200     }
201     
202     function registerNameXaddr(string _nameString, address _affCode, bool _all)
203         isHuman()
204         public
205         payable 
206     {
207         // make sure name fees paid
208         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
209         
210         // filter name + condition checks
211         bytes32 _name = NameFilter.nameFilter(_nameString);
212         
213         // set up address 
214         address _addr = msg.sender;
215         
216         // set up our tx event data and determine if player is new or not
217         bool _isNewPlayer = determinePID(_addr);
218         
219         // fetch player id
220         uint256 _pID = pIDxAddr_[_addr];
221         
222         // manage affiliate residuals
223         // if no affiliate code was given or player tried to use their own, lolz
224         uint256 _affID;
225         if (_affCode != address(0) && _affCode != _addr)
226         {
227             // get affiliate ID from aff Code 
228             _affID = pIDxAddr_[_affCode];
229             
230             // if affID is not the same as previously stored 
231             if (_affID != plyr_[_pID].laff)
232             {
233                 // update last affiliate
234                 plyr_[_pID].laff = _affID;
235             }
236         }
237         
238         // register name 
239         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
240     }
241     
242     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
243         isHuman()
244         public
245         payable 
246     {
247         // make sure name fees paid
248         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
249         
250         // filter name + condition checks
251         bytes32 _name = NameFilter.nameFilter(_nameString);
252         
253         // set up address 
254         address _addr = msg.sender;
255         
256         // set up our tx event data and determine if player is new or not
257         bool _isNewPlayer = determinePID(_addr);
258         
259         // fetch player id
260         uint256 _pID = pIDxAddr_[_addr];
261         
262         // manage affiliate residuals
263         // if no affiliate code was given or player tried to use their own, lolz
264         uint256 _affID;
265         if (_affCode != "" && _affCode != _name)
266         {
267             // get affiliate ID from aff Code 
268             _affID = pIDxName_[_affCode];
269             
270             // if affID is not the same as previously stored 
271             if (_affID != plyr_[_pID].laff)
272             {
273                 // update last affiliate
274                 plyr_[_pID].laff = _affID;
275             }
276         }
277         
278         // register name 
279         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
280     }
281     
282     /**
283      * @dev players, if you registered a profile, before a game was released, or
284      * set the all bool to false when you registered, use this function to push
285      * your profile to a single game.  also, if you've  updated your name, you
286      * can use this to push your name to games of your choosing.
287      * -functionhash- 0x81c5b206
288      * @param _gameID game id 
289      */
290     function addMeToGame(uint256 _gameID)
291         isHuman()
292         public
293     {
294         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
295         address _addr = msg.sender;
296         uint256 _pID = pIDxAddr_[_addr];
297         require(_pID != 0, "hey there buddy, you dont even have an account");
298         uint256 _totalNames = plyr_[_pID].names;
299         
300         // add players profile and most recent name
301         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
302         
303         // add list of all names
304         if (_totalNames > 1)
305             for (uint256 ii = 1; ii <= _totalNames; ii++)
306                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
307     }
308     
309     /**
310      * @dev players, use this to push your player profile to all registered games.
311      * -functionhash- 0x0c6940ea
312      */
313     function addMeToAllGames()
314         isHuman()
315         public
316     {
317         address _addr = msg.sender;
318         uint256 _pID = pIDxAddr_[_addr];
319         require(_pID != 0, "hey there buddy, you dont even have an account");
320         uint256 _laff = plyr_[_pID].laff;
321         uint256 _totalNames = plyr_[_pID].names;
322         bytes32 _name = plyr_[_pID].name;
323         
324         for (uint256 i = 1; i <= gID_; i++)
325         {
326             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
327             if (_totalNames > 1)
328                 for (uint256 ii = 1; ii <= _totalNames; ii++)
329                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
330         }
331                 
332     }
333     
334     /**
335      * @dev players use this to change back to one of your old names.  tip, you'll
336      * still need to push that info to existing games.
337      * -functionhash- 0xb9291296
338      * @param _nameString the name you want to use 
339      */
340     function useMyOldName(string _nameString)
341         isHuman()
342         public 
343     {
344         // filter name, and get pID
345         bytes32 _name = _nameString.nameFilter();
346         uint256 _pID = pIDxAddr_[msg.sender];
347         
348         // make sure they own the name 
349         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
350         
351         // update their current name 
352         plyr_[_pID].name = _name;
353     }
354     
355 //==============================================================================
356 //     _ _  _ _   | _  _ . _  .
357 //    (_(_)| (/_  |(_)(_||(_  . 
358 //=====================_|=======================================================    
359     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
360         private
361     {
362         // if names already has been used, require that current msg sender owns the name
363         if (pIDxName_[_name] != 0)
364             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
365         
366         // add name to player profile, registry, and name book
367         plyr_[_pID].name = _name;
368         pIDxName_[_name] = _pID;
369         if (plyrNames_[_pID][_name] == false)
370         {
371             plyrNames_[_pID][_name] = true;
372             plyr_[_pID].names++;
373             plyrNameList_[_pID][plyr_[_pID].names] = _name;
374         }
375         
376         // registration fee goes directly to community rewards
377         communityAddr.transfer(address(this).balance);
378         
379         // push player info to games
380         if (_all == true)
381             for (uint256 i = 1; i <= gID_; i++)
382                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
383         
384         // fire event
385         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
386     }
387 //==============================================================================
388 //    _|_ _  _ | _  .
389 //     | (_)(_)|_\  .
390 //==============================================================================    
391     function determinePID(address _addr)
392         private
393         returns (bool)
394     {
395         if (pIDxAddr_[_addr] == 0)
396         {
397             pID_++;
398             pIDxAddr_[_addr] = pID_;
399             plyr_[pID_].addr = _addr;
400             
401             // set the new player bool to true
402             return (true);
403         } else {
404             return (false);
405         }
406     }
407 //==============================================================================
408 //   _   _|_ _  _ _  _ |   _ _ || _  .
409 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
410 //==============================================================================
411     function getPlayerID(address _addr)
412         isRegisteredGame()
413         external
414         returns (uint256)
415     {
416         determinePID(_addr);
417         return (pIDxAddr_[_addr]);
418     }
419     function getPlayerName(uint256 _pID)
420         external
421         view
422         returns (bytes32)
423     {
424         return (plyr_[_pID].name);
425     }
426     function getPlayerLAff(uint256 _pID)
427         external
428         view
429         returns (uint256)
430     {
431         return (plyr_[_pID].laff);
432     }
433     function getPlayerAddr(uint256 _pID)
434         external
435         view
436         returns (address)
437     {
438         return (plyr_[_pID].addr);
439     }
440     function getNameFee()
441         external
442         view
443         returns (uint256)
444     {
445         return(registrationFee_);
446     }
447     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
448         isRegisteredGame()
449         external
450         payable
451         returns(bool, uint256)
452     {
453         // make sure name fees paid
454         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
455         
456         // set up our tx event data and determine if player is new or not
457         bool _isNewPlayer = determinePID(_addr);
458         
459         // fetch player id
460         uint256 _pID = pIDxAddr_[_addr];
461         
462         // manage affiliate residuals
463         // if no affiliate code was given, no new affiliate code was given, or the 
464         // player tried to use their own pID as an affiliate code, lolz
465         uint256 _affID = _affCode;
466         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
467         {
468             // update last affiliate 
469             plyr_[_pID].laff = _affID;
470         } else if (_affID == _pID) {
471             _affID = 0;
472         }
473         
474         // register name 
475         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
476         
477         return(_isNewPlayer, _affID);
478     }
479     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
480         isRegisteredGame()
481         external
482         payable
483         returns(bool, uint256)
484     {
485         // make sure name fees paid
486         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
487         
488         // set up our tx event data and determine if player is new or not
489         bool _isNewPlayer = determinePID(_addr);
490         
491         // fetch player id
492         uint256 _pID = pIDxAddr_[_addr];
493         
494         // manage affiliate residuals
495         // if no affiliate code was given or player tried to use their own, lolz
496         uint256 _affID;
497         if (_affCode != address(0) && _affCode != _addr)
498         {
499             // get affiliate ID from aff Code 
500             _affID = pIDxAddr_[_affCode];
501             
502             // if affID is not the same as previously stored 
503             if (_affID != plyr_[_pID].laff)
504             {
505                 // update last affiliate
506                 plyr_[_pID].laff = _affID;
507             }
508         }
509         
510         // register name 
511         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
512         
513         return(_isNewPlayer, _affID);
514     }
515     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
516         isRegisteredGame()
517         external
518         payable
519         returns(bool, uint256)
520     {
521         // make sure name fees paid
522         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
523         
524         // set up our tx event data and determine if player is new or not
525         bool _isNewPlayer = determinePID(_addr);
526         
527         // fetch player id
528         uint256 _pID = pIDxAddr_[_addr];
529         
530         // manage affiliate residuals
531         // if no affiliate code was given or player tried to use their own, lolz
532         uint256 _affID;
533         if (_affCode != "" && _affCode != _name)
534         {
535             // get affiliate ID from aff Code 
536             _affID = pIDxName_[_affCode];
537             
538             // if affID is not the same as previously stored 
539             if (_affID != plyr_[_pID].laff)
540             {
541                 // update last affiliate
542                 plyr_[_pID].laff = _affID;
543             }
544         }
545         
546         // register name 
547         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
548         
549         return(_isNewPlayer, _affID);
550     }
551     
552 //==============================================================================
553 //   _ _ _|_    _   .
554 //  _\(/_ | |_||_)  .
555 //=============|================================================================
556     function addGame(address _gameAddress, string _gameNameStr)
557      onlyCommunity()
558         public
559     {
560         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
561 
562             gID_++;
563             bytes32 _name = _gameNameStr.nameFilter();
564             gameIDs_[_gameAddress] = gID_;
565             gameNames_[_gameAddress] = _name;
566             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
567         
568             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
569             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
570             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
571             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
572     }
573     
574     function setRegistrationFee(uint256 _fee)
575      onlyCommunity()
576         public
577     {
578             registrationFee_ = _fee;
579     }
580         
581 } 
582 
583 /**
584 * @title -Name Filter- v0.1.9
585 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
586 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
587 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
588 *                                  _____                      _____
589 *                                 (, /     /)       /) /)    (, /      /)          /)
590 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
591 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
592 *          ┴ ┴                /   /          .-/ _____   (__ /                               
593 *                            (__ /          (_/ (, /                                      /)? 
594 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
595 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
596 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  ? Jekyll Island Inc. 2018
597 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
598 *              _       __    _      ____      ____  _   _    _____  ____  ___  
599 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
600 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
601 *
602 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
603 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dddos │
604 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
605 */
606 library NameFilter {
607     
608     /**
609      * @dev filters name strings
610      * -converts uppercase to lower case.  
611      * -makes sure it does not start/end with a space
612      * -makes sure it does not contain multiple spaces in a row
613      * -cannot be only numbers
614      * -cannot start with 0x 
615      * -restricts characters to A-Z, a-z, 0-9, and space.
616      * @return reprocessed string in bytes32 format
617      */
618     function nameFilter(string _input)
619         internal
620         pure
621         returns(bytes32)
622     {
623         bytes memory _temp = bytes(_input);
624         uint256 _length = _temp.length;
625         
626         //sorry limited to 32 characters
627         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
628         // make sure it doesnt start with or end with space
629         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
630         // make sure first two characters are not 0x
631         if (_temp[0] == 0x30)
632         {
633             require(_temp[1] != 0x78, "string cannot start with 0x");
634             require(_temp[1] != 0x58, "string cannot start with 0X");
635         }
636         
637         // create a bool to track if we have a non number character
638         bool _hasNonNumber;
639         
640         // convert & check
641         for (uint256 i = 0; i < _length; i++)
642         {
643             // if its uppercase A-Z
644             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
645             {
646                 // convert to lower case a-z
647                 _temp[i] = byte(uint(_temp[i]) + 32);
648                 
649                 // we have a non number
650                 if (_hasNonNumber == false)
651                     _hasNonNumber = true;
652             } else {
653                 require
654                 (
655                     // require character is a space
656                     _temp[i] == 0x20 || 
657                     // OR lowercase a-z
658                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
659                     // or 0-9
660                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
661                     "string contains invalid characters"
662                 );
663                 // make sure theres not 2x spaces in a row
664                 if (_temp[i] == 0x20)
665                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
666                 
667                 // see if we have a character other than a number
668                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
669                     _hasNonNumber = true;    
670             }
671         }
672         
673         require(_hasNonNumber == true, "string cannot be only numbers");
674         
675         bytes32 _ret;
676         assembly {
677             _ret := mload(add(_temp, 32))
678         }
679         return (_ret);
680     }
681 }
682 
683 /**
684  * @title SafeMath v0.1.9
685  * @dev Math operations with safety checks that throw on error
686  * change notes:  original SafeMath library from OpenZeppelin modified by dddos
687  * - added sqrt
688  * - added sq
689  * - added pwr 
690  * - changed asserts to requires with error log outputs
691  * - removed div, its useless
692  */
693 library SafeMath {
694     
695     /**
696     * @dev Multiplies two numbers, throws on overflow.
697     */
698     function mul(uint256 a, uint256 b) 
699         internal 
700         pure 
701         returns (uint256 c) 
702     {
703         if (a == 0) {
704             return 0;
705         }
706         c = a * b;
707         require(c / a == b, "SafeMath mul failed");
708         return c;
709     }
710 
711     /**
712     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
713     */
714     function sub(uint256 a, uint256 b)
715         internal
716         pure
717         returns (uint256) 
718     {
719         require(b <= a, "SafeMath sub failed");
720         return a - b;
721     }
722 
723     /**
724     * @dev Adds two numbers, throws on overflow.
725     */
726     function add(uint256 a, uint256 b)
727         internal
728         pure
729         returns (uint256 c) 
730     {
731         c = a + b;
732         require(c >= a, "SafeMath add failed");
733         return c;
734     }
735     
736     /**
737      * @dev gives square root of given x.
738      */
739     function sqrt(uint256 x)
740         internal
741         pure
742         returns (uint256 y) 
743     {
744         uint256 z = ((add(x,1)) / 2);
745         y = x;
746         while (z < y) 
747         {
748             y = z;
749             z = ((add((x / z),z)) / 2);
750         }
751     }
752     
753     /**
754      * @dev gives square. multiplies x by x
755      */
756     function sq(uint256 x)
757         internal
758         pure
759         returns (uint256)
760     {
761         return (mul(x,x));
762     }
763     
764     /**
765      * @dev x to the power of y 
766      */
767     function pwr(uint256 x, uint256 y)
768         internal 
769         pure 
770         returns (uint256)
771     {
772         if (x==0)
773             return (0);
774         else if (y==0)
775             return (1);
776         else 
777         {
778             uint256 z = x;
779             for (uint256 i=1; i < y; i++)
780                 z = mul(z,x);
781             return (z);
782         }
783     }
784 }