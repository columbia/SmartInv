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
41 
42     address private reciverbank ;
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
68     constructor(address bankaddr)
69         public
70     {
71         // premine the dev names (sorry not sorry)
72             // No keys are purchased with this method, it's simply locking our addresses,
73             // PID's and names for referral codes.
74         plyr_[1].addr = bankaddr;
75         plyr_[1].name = "play";
76         plyr_[1].names = 1;
77         pIDxAddr_[bankaddr] = 1;
78         pIDxName_["play"] = 1;
79         plyrNames_[1]["play"] = true;
80         plyrNameList_[1][1] = "play";
81             
82         pID_ = 1;
83 
84         reciverbank = bankaddr;
85     }
86 //==============================================================================
87 //     _ _  _  _|. |`. _  _ _  .
88 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
89 //==============================================================================    
90     /**
91      * @dev prevents contracts from interacting with fomo3d 
92      */
93     modifier isHuman() {
94         address _addr = msg.sender;
95         uint256 _codeLength;
96         
97         assembly {_codeLength := extcodesize(_addr)}
98         require(_codeLength == 0, "sorry humans only");
99         _;
100     }
101 
102     modifier onlyDevs() 
103     {
104         require(admin == msg.sender, "msg sender is not a dev");
105         _;
106     }
107     
108     modifier isRegisteredGame()
109     {
110         require(gameIDs_[msg.sender] != 0);
111         _;
112     }
113 //==============================================================================
114 //     _    _  _ _|_ _  .
115 //    (/_\/(/_| | | _\  .
116 //==============================================================================    
117     // fired whenever a player registers a name
118     event onNewName
119     (
120         uint256 indexed playerID,
121         address indexed playerAddress,
122         bytes32 indexed playerName,
123         bool isNewPlayer,
124         uint256 affiliateID,
125         address affiliateAddress,
126         bytes32 affiliateName,
127         uint256 amountPaid,
128         uint256 timeStamp
129     );
130 //==============================================================================
131 //     _  _ _|__|_ _  _ _  .
132 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
133 //=====_|=======================================================================
134     function checkIfNameValid(string _nameStr)
135         public
136         view
137         returns(bool)
138     {
139         bytes32 _name = _nameStr.nameFilter();
140         if (pIDxName_[_name] == 0)
141             return (true);
142         else 
143             return (false);
144     }
145 //==============================================================================
146 //     _    |_ |. _   |`    _  __|_. _  _  _  .
147 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
148 //====|=========================================================================    
149     /**
150      * @dev registers a name.  UI will always display the last name you registered.
151      * but you will still own all previously registered names to use as affiliate 
152      * links.
153      * - must pay a registration fee.
154      * - name must be unique
155      * - names will be converted to lowercase
156      * - name cannot start or end with a space 
157      * - cannot have more than 1 space in a row
158      * - cannot be only numbers
159      * - cannot start with 0x 
160      * - name must be at least 1 char
161      * - max length of 32 characters long
162      * - allowed characters: a-z, 0-9, and space
163      * -functionhash- 0x921dec21 (using ID for affiliate)
164      * -functionhash- 0x3ddd4698 (using address for affiliate)
165      * -functionhash- 0x685ffd83 (using name for affiliate)
166      * @param _nameString players desired name
167      * @param _affCode affiliate ID, address, or name of who refered you
168      * @param _all set to true if you want this to push your info to all games 
169      * (this might cost a lot of gas)
170      */
171     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
172         isHuman()
173         public
174         payable 
175     {
176         // make sure name fees paid
177         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
178         
179         // filter name + condition checks
180         bytes32 _name = NameFilter.nameFilter(_nameString);
181         
182         // set up address 
183         address _addr = msg.sender;
184         
185         // set up our tx event data and determine if player is new or not
186         bool _isNewPlayer = determinePID(_addr);
187         
188         // fetch player id
189         uint256 _pID = pIDxAddr_[_addr];
190         
191         // manage affiliate residuals
192         // if no affiliate code was given, no new affiliate code was given, or the 
193         // player tried to use their own pID as an affiliate code, lolz
194         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
195         {
196             // update last affiliate 
197             plyr_[_pID].laff = _affCode;
198         } else if (_affCode == _pID) {
199             _affCode = 0;
200         }
201         
202         // register name 
203         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
204     }
205     
206     function registerNameXaddr(string _nameString, address _affCode, bool _all)
207         isHuman()
208         public
209         payable 
210     {
211         // make sure name fees paid
212         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
213         
214         // filter name + condition checks
215         bytes32 _name = NameFilter.nameFilter(_nameString);
216         
217         // set up address 
218         address _addr = msg.sender;
219         
220         // set up our tx event data and determine if player is new or not
221         bool _isNewPlayer = determinePID(_addr);
222         
223         // fetch player id
224         uint256 _pID = pIDxAddr_[_addr];
225         
226         // manage affiliate residuals
227         // if no affiliate code was given or player tried to use their own, lolz
228         uint256 _affID;
229         if (_affCode != address(0) && _affCode != _addr)
230         {
231             // get affiliate ID from aff Code 
232             _affID = pIDxAddr_[_affCode];
233             
234             // if affID is not the same as previously stored 
235             if (_affID != plyr_[_pID].laff)
236             {
237                 // update last affiliate
238                 plyr_[_pID].laff = _affID;
239             }
240         }
241         
242         // register name 
243         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
244     }
245     
246     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
247         isHuman()
248         public
249         payable 
250     {
251         // make sure name fees paid
252         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
253         
254         // filter name + condition checks
255         bytes32 _name = NameFilter.nameFilter(_nameString);
256         
257         // set up address 
258         address _addr = msg.sender;
259         
260         // set up our tx event data and determine if player is new or not
261         bool _isNewPlayer = determinePID(_addr);
262         
263         // fetch player id
264         uint256 _pID = pIDxAddr_[_addr];
265         
266         // manage affiliate residuals
267         // if no affiliate code was given or player tried to use their own, lolz
268         uint256 _affID;
269         if (_affCode != "" && _affCode != _name)
270         {
271             // get affiliate ID from aff Code 
272             _affID = pIDxName_[_affCode];
273             
274             // if affID is not the same as previously stored 
275             if (_affID != plyr_[_pID].laff)
276             {
277                 // update last affiliate
278                 plyr_[_pID].laff = _affID;
279             }
280         }
281         
282         // register name 
283         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
284     }
285     
286     /**
287      * @dev players, if you registered a profile, before a game was released, or
288      * set the all bool to false when you registered, use this function to push
289      * your profile to a single game.  also, if you've  updated your name, you
290      * can use this to push your name to games of your choosing.
291      * -functionhash- 0x81c5b206
292      * @param _gameID game id 
293      */
294     function addMeToGame(uint256 _gameID)
295         isHuman()
296         public
297     {
298         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
299         address _addr = msg.sender;
300         uint256 _pID = pIDxAddr_[_addr];
301         require(_pID != 0, "hey there buddy, you dont even have an account");
302         uint256 _totalNames = plyr_[_pID].names;
303         
304         // add players profile and most recent name
305         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
306         
307         // add list of all names
308         if (_totalNames > 1)
309             for (uint256 ii = 1; ii <= _totalNames; ii++)
310                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
311     }
312     
313     /**
314      * @dev players, use this to push your player profile to all registered games.
315      * -functionhash- 0x0c6940ea
316      */
317     function addMeToAllGames()
318         isHuman()
319         public
320     {
321         address _addr = msg.sender;
322         uint256 _pID = pIDxAddr_[_addr];
323         require(_pID != 0, "hey there buddy, you dont even have an account");
324         uint256 _laff = plyr_[_pID].laff;
325         uint256 _totalNames = plyr_[_pID].names;
326         bytes32 _name = plyr_[_pID].name;
327         
328         for (uint256 i = 1; i <= gID_; i++)
329         {
330             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
331             if (_totalNames > 1)
332                 for (uint256 ii = 1; ii <= _totalNames; ii++)
333                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
334         }
335                 
336     }
337     
338     /**
339      * @dev players use this to change back to one of your old names.  tip, you'll
340      * still need to push that info to existing games.
341      * -functionhash- 0xb9291296
342      * @param _nameString the name you want to use 
343      */
344     function useMyOldName(string _nameString)
345         isHuman()
346         public 
347     {
348         // filter name, and get pID
349         bytes32 _name = _nameString.nameFilter();
350         uint256 _pID = pIDxAddr_[msg.sender];
351         
352         // make sure they own the name 
353         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
354         
355         // update their current name 
356         plyr_[_pID].name = _name;
357     }
358     
359 //==============================================================================
360 //     _ _  _ _   | _  _ . _  .
361 //    (_(_)| (/_  |(_)(_||(_  . 
362 //=====================_|=======================================================    
363     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
364         private
365     {
366         // if names already has been used, require that current msg sender owns the name
367         if (pIDxName_[_name] != 0)
368             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
369         
370         // add name to player profile, registry, and name book
371         plyr_[_pID].name = _name;
372         pIDxName_[_name] = _pID;
373         if (plyrNames_[_pID][_name] == false)
374         {
375             plyrNames_[_pID][_name] = true;
376             plyr_[_pID].names++;
377             plyrNameList_[_pID][plyr_[_pID].names] = _name;
378         }
379         
380         // registration fee goes directly to community rewards
381         reciverbank.transfer(address(this).balance);
382         
383         // push player info to games
384         if (_all == true)
385             for (uint256 i = 1; i <= gID_; i++)
386                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
387         
388         // fire event
389         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
390     }
391 //==============================================================================
392 //    _|_ _  _ | _  .
393 //     | (_)(_)|_\  .
394 //==============================================================================    
395     function determinePID(address _addr)
396         private
397         returns (bool)
398     {
399         if (pIDxAddr_[_addr] == 0)
400         {
401             pID_++;
402             pIDxAddr_[_addr] = pID_;
403             plyr_[pID_].addr = _addr;
404             
405             // set the new player bool to true
406             return (true);
407         } else {
408             return (false);
409         }
410     }
411 //==============================================================================
412 //   _   _|_ _  _ _  _ |   _ _ || _  .
413 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
414 //==============================================================================
415     function getPlayerID(address _addr)
416         isRegisteredGame()
417         external
418         returns (uint256)
419     {
420         determinePID(_addr);
421         return (pIDxAddr_[_addr]);
422     }
423     function getPlayerName(uint256 _pID)
424         external
425         view
426         returns (bytes32)
427     {
428         return (plyr_[_pID].name);
429     }
430     function getPlayerLAff(uint256 _pID)
431         external
432         view
433         returns (uint256)
434     {
435         return (plyr_[_pID].laff);
436     }
437     function getPlayerAddr(uint256 _pID)
438         external
439         view
440         returns (address)
441     {
442         return (plyr_[_pID].addr);
443     }
444     function getNameFee()
445         external
446         view
447         returns (uint256)
448     {
449         return(registrationFee_);
450     }
451     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
452         isRegisteredGame()
453         external
454         payable
455         returns(bool, uint256)
456     {
457         // make sure name fees paid
458         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
459         
460         // set up our tx event data and determine if player is new or not
461         bool _isNewPlayer = determinePID(_addr);
462         
463         // fetch player id
464         uint256 _pID = pIDxAddr_[_addr];
465         
466         // manage affiliate residuals
467         // if no affiliate code was given, no new affiliate code was given, or the 
468         // player tried to use their own pID as an affiliate code, lolz
469         uint256 _affID = _affCode;
470         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
471         {
472             // update last affiliate 
473             plyr_[_pID].laff = _affID;
474         } else if (_affID == _pID) {
475             _affID = 0;
476         }
477         
478         // register name 
479         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
480         
481         return(_isNewPlayer, _affID);
482     }
483     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
484         isRegisteredGame()
485         external
486         payable
487         returns(bool, uint256)
488     {
489         // make sure name fees paid
490         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
491         
492         // set up our tx event data and determine if player is new or not
493         bool _isNewPlayer = determinePID(_addr);
494         
495         // fetch player id
496         uint256 _pID = pIDxAddr_[_addr];
497         
498         // manage affiliate residuals
499         // if no affiliate code was given or player tried to use their own, lolz
500         uint256 _affID;
501         if (_affCode != address(0) && _affCode != _addr)
502         {
503             // get affiliate ID from aff Code 
504             _affID = pIDxAddr_[_affCode];
505             
506             // if affID is not the same as previously stored 
507             if (_affID != plyr_[_pID].laff)
508             {
509                 // update last affiliate
510                 plyr_[_pID].laff = _affID;
511             }
512         }
513         
514         // register name 
515         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
516         
517         return(_isNewPlayer, _affID);
518     }
519     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
520         isRegisteredGame()
521         external
522         payable
523         returns(bool, uint256)
524     {
525         // make sure name fees paid
526         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
527         
528         // set up our tx event data and determine if player is new or not
529         bool _isNewPlayer = determinePID(_addr);
530         
531         // fetch player id
532         uint256 _pID = pIDxAddr_[_addr];
533         
534         // manage affiliate residuals
535         // if no affiliate code was given or player tried to use their own, lolz
536         uint256 _affID;
537         if (_affCode != "" && _affCode != _name)
538         {
539             // get affiliate ID from aff Code 
540             _affID = pIDxName_[_affCode];
541             
542             // if affID is not the same as previously stored 
543             if (_affID != plyr_[_pID].laff)
544             {
545                 // update last affiliate
546                 plyr_[_pID].laff = _affID;
547             }
548         }
549         
550         // register name 
551         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
552         
553         return(_isNewPlayer, _affID);
554     }
555     
556 
557     function changeadmin(address _adminAddress) onlyDevs() public
558     {
559         admin = _adminAddress;
560     }
561 
562     function changebank(address _bankAddress) onlyDevs() public
563     {
564         reciverbank = _bankAddress;
565     }
566 //==============================================================================
567 //   _ _ _|_    _   .
568 //  _\(/_ | |_||_)  .
569 //=============|================================================================
570     function addGame(address _gameAddress, string _gameNameStr)
571         onlyDevs()
572         public
573     {
574         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
575             gID_++;
576             bytes32 _name = _gameNameStr.nameFilter();
577             gameIDs_[_gameAddress] = gID_;
578             gameNames_[_gameAddress] = _name;
579             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
580         
581             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
582     }
583     
584     function setRegistrationFee(uint256 _fee)
585         onlyDevs()
586         public
587     {
588       registrationFee_ = _fee;
589     }
590         
591 } 
592 
593 /**
594 * @title -Name Filter- v0.1.9
595 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
596 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
597 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
598 *                                  _____                      _____
599 *                                 (, /     /)       /) /)    (, /      /)          /)
600 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
601 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
602 *          ┴ ┴                /   /          .-/ _____   (__ /                               
603 *                            (__ /          (_/ (, /                                      /)™ 
604 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
605 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
606 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
607 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
608 *              _       __    _      ____      ____  _   _    _____  ____  ___  
609 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
610 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
611 *
612 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
613 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
614 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
615 */
616 library NameFilter {
617     
618     /**
619      * @dev filters name strings
620      * -converts uppercase to lower case.  
621      * -makes sure it does not start/end with a space
622      * -makes sure it does not contain multiple spaces in a row
623      * -cannot be only numbers
624      * -cannot start with 0x 
625      * -restricts characters to A-Z, a-z, 0-9, and space.
626      * @return reprocessed string in bytes32 format
627      */
628     function nameFilter(string _input)
629         internal
630         pure
631         returns(bytes32)
632     {
633         bytes memory _temp = bytes(_input);
634         uint256 _length = _temp.length;
635         
636         //sorry limited to 32 characters
637         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
638         // make sure it doesnt start with or end with space
639         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
640         // make sure first two characters are not 0x
641         if (_temp[0] == 0x30)
642         {
643             require(_temp[1] != 0x78, "string cannot start with 0x");
644             require(_temp[1] != 0x58, "string cannot start with 0X");
645         }
646         
647         // create a bool to track if we have a non number character
648         bool _hasNonNumber;
649         
650         // convert & check
651         for (uint256 i = 0; i < _length; i++)
652         {
653             // if its uppercase A-Z
654             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
655             {
656                 // convert to lower case a-z
657                 _temp[i] = byte(uint(_temp[i]) + 32);
658                 
659                 // we have a non number
660                 if (_hasNonNumber == false)
661                     _hasNonNumber = true;
662             } else {
663                 require
664                 (
665                     // require character is a space
666                     _temp[i] == 0x20 || 
667                     // OR lowercase a-z
668                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
669                     // or 0-9
670                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
671                     "string contains invalid characters"
672                 );
673                 // make sure theres not 2x spaces in a row
674                 if (_temp[i] == 0x20)
675                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
676                 
677                 // see if we have a character other than a number
678                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
679                     _hasNonNumber = true;    
680             }
681         }
682         
683         require(_hasNonNumber == true, "string cannot be only numbers");
684         
685         bytes32 _ret;
686         assembly {
687             _ret := mload(add(_temp, 32))
688         }
689         return (_ret);
690     }
691 }
692 
693 /**
694  * @title SafeMath v0.1.9
695  * @dev Math operations with safety checks that throw on error
696  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
697  * - added sqrt
698  * - added sq
699  * - added pwr 
700  * - changed asserts to requires with error log outputs
701  * - removed div, its useless
702  */
703 library SafeMath {
704     
705     /**
706     * @dev Multiplies two numbers, throws on overflow.
707     */
708     function mul(uint256 a, uint256 b) 
709         internal 
710         pure 
711         returns (uint256 c) 
712     {
713         if (a == 0) {
714             return 0;
715         }
716         c = a * b;
717         require(c / a == b, "SafeMath mul failed");
718         return c;
719     }
720 
721     /**
722     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b)
725         internal
726         pure
727         returns (uint256) 
728     {
729         require(b <= a, "SafeMath sub failed");
730         return a - b;
731     }
732 
733     /**
734     * @dev Adds two numbers, throws on overflow.
735     */
736     function add(uint256 a, uint256 b)
737         internal
738         pure
739         returns (uint256 c) 
740     {
741         c = a + b;
742         require(c >= a, "SafeMath add failed");
743         return c;
744     }
745     
746     /**
747      * @dev gives square root of given x.
748      */
749     function sqrt(uint256 x)
750         internal
751         pure
752         returns (uint256 y) 
753     {
754         uint256 z = ((add(x,1)) / 2);
755         y = x;
756         while (z < y) 
757         {
758             y = z;
759             z = ((add((x / z),z)) / 2);
760         }
761     }
762     
763     /**
764      * @dev gives square. multiplies x by x
765      */
766     function sq(uint256 x)
767         internal
768         pure
769         returns (uint256)
770     {
771         return (mul(x,x));
772     }
773     
774     /**
775      * @dev x to the power of y 
776      */
777     function pwr(uint256 x, uint256 y)
778         internal 
779         pure 
780         returns (uint256)
781     {
782         if (x==0)
783             return (0);
784         else if (y==0)
785             return (1);
786         else 
787         {
788             uint256 z = x;
789             for (uint256 i=1; i < y; i++)
790                 z = mul(z,x);
791             return (z);
792         }
793     }
794 }