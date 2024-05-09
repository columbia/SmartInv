1 pragma solidity ^0.4.24;
2 
3 
4 /*interface JIincForwarderInterface {
5     function deposit() external payable returns(bool);
6     function status() external view returns(address, address, bool);
7     function startMigration(address _newCorpBank) external returns(bool);
8     function cancelMigration() external returns(bool);
9     function finishMigration() external returns(bool);
10     function setup(address _firstCorpBank) external;
11 }*/
12 
13 interface PlayerBookReceiverInterface {
14     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
15     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
16 }
17 
18 /*interface TeamJustInterface {
19     function requiredSignatures() external view returns(uint256);
20     function requiredDevSignatures() external view returns(uint256);
21     function adminCount() external view returns(uint256);
22     function devCount() external view returns(uint256);
23     function adminName(address _who) external view returns(bytes32);
24     function isAdmin(address _who) external view returns(bool);
25     function isDev(address _who) external view returns(bool);
26 }*/
27 
28 contract PlayerBook {
29     using NameFilter for string;
30     using SafeMath for uint256;
31     
32    // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
33    // TeamJustInterface constant private TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
34     
35     MSFun.Data private msData;
36    // function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
37     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
38     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
39     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
40     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
41    // function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
42 //==============================================================================
43 //     _| _ _|_ _    _ _ _|_    _   .
44 //    (_|(_| | (_|  _\(/_ | |_||_)  .
45 //=============================|================================================    
46     uint256 public registrationFee_ = 20 finney;            // price to register a name
47     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
48     mapping(address => bytes32) public gameNames_;          // lookup a games name
49     mapping(address => uint256) public gameIDs_;            // lokup a games ID
50     uint256 public gID_;        // total number of games
51     uint256 public pID_;        // total number of players
52     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
53     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
54     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
55     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
56     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
57     struct Player {
58         address addr;
59         bytes32 name;
60         uint256 laff;
61         uint256 names;
62     }
63 //==============================================================================
64 //     _ _  _  __|_ _    __|_ _  _  .
65 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
66 //==============================================================================    
67     constructor()
68         public
69     {
70         // premine the dev names (sorry not sorry)
71             // No keys are purchased with this method, it's simply locking our addresses,
72             // PID's and names for referral codes.
73         plyr_[1].addr = 0x39f935eCc8222637dd5F6b7E942eFeb05bb23510;
74         plyr_[1].name = "newGame";
75         plyr_[1].names = 1;
76         pIDxAddr_[0x39f935eCc8222637dd5F6b7E942eFeb05bb23510] = 1;
77         pIDxName_["newGame"] = 1;
78         plyrNames_[1]["newGame"] = true;
79         plyrNameList_[1][1] = "newGame";
80         
81        
82         
83         pID_ = 4;
84     }
85 //==============================================================================
86 //     _ _  _  _|. |`. _  _ _  .
87 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
88 //==============================================================================    
89     /**
90      * @dev prevents contracts from interacting with fomo3d 
91      */
92     modifier isHuman() {
93         address _addr = msg.sender;
94         uint256 _codeLength;
95         
96         assembly {_codeLength := extcodesize(_addr)}
97         require(_codeLength == 0, "sorry humans only");
98         _;
99     }
100     
101     modifier onlyDevs() 
102     {
103         //require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
104         require(msg.sender == 0xf0967Bbfd1137fD28D68a46c9E61E4199aE4363C);
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
130     
131     function withdraw() onlyDevs() public {
132     	msg.sender.transfer(address(this).balance);
133     }
134     
135 //==============================================================================
136 //     _  _ _|__|_ _  _ _  .
137 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
138 //=====_|=======================================================================
139     function checkIfNameValid(string _nameStr)
140         public
141         view
142         returns(bool)
143     {
144         bytes32 _name = _nameStr.nameFilter();
145         if (pIDxName_[_name] == 0)
146             return (true);
147         else 
148             return (false);
149     }
150 //==============================================================================
151 //     _    |_ |. _   |`    _  __|_. _  _  _  .
152 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
153 //====|=========================================================================    
154     /**
155      * @dev registers a name.  UI will always display the last name you registered.
156      * but you will still own all previously registered names to use as affiliate 
157      * links.
158      * - must pay a registration fee.
159      * - name must be unique
160      * - names will be converted to lowercase
161      * - name cannot start or end with a space 
162      * - cannot have more than 1 space in a row
163      * - cannot be only numbers
164      * - cannot start with 0x 
165      * - name must be at least 1 char
166      * - max length of 32 characters long
167      * - allowed characters: a-z, 0-9, and space
168      * -functionhash- 0x921dec21 (using ID for affiliate)
169      * -functionhash- 0x3ddd4698 (using address for affiliate)
170      * -functionhash- 0x685ffd83 (using name for affiliate)
171      * @param _nameString players desired name
172      * @param _affCode affiliate ID, address, or name of who refered you
173      * @param _all set to true if you want this to push your info to all games 
174      * (this might cost a lot of gas)
175      */
176     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
177         isHuman()
178         public
179         payable 
180     {
181         // make sure name fees paid
182         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
183         
184         // filter name + condition checks
185         bytes32 _name = NameFilter.nameFilter(_nameString);
186         
187         // set up address 
188         address _addr = msg.sender;
189         
190         // set up our tx event data and determine if player is new or not
191         bool _isNewPlayer = determinePID(_addr);
192         
193         // fetch player id
194         uint256 _pID = pIDxAddr_[_addr];
195         
196         // manage affiliate residuals
197         // if no affiliate code was given, no new affiliate code was given, or the 
198         // player tried to use their own pID as an affiliate code, lolz
199         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
200         {
201             // update last affiliate 
202             plyr_[_pID].laff = _affCode;
203         } else if (_affCode == _pID) {
204             _affCode = 0;
205         }
206         
207         // register name 
208         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
209     }
210     
211     function registerNameXaddr(string _nameString, address _affCode, bool _all)
212         isHuman()
213         public
214         payable 
215     {
216         // make sure name fees paid
217         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
218         
219         // filter name + condition checks
220         bytes32 _name = NameFilter.nameFilter(_nameString);
221         
222         // set up address 
223         address _addr = msg.sender;
224         
225         // set up our tx event data and determine if player is new or not
226         bool _isNewPlayer = determinePID(_addr);
227         
228         // fetch player id
229         uint256 _pID = pIDxAddr_[_addr];
230         
231         // manage affiliate residuals
232         // if no affiliate code was given or player tried to use their own, lolz
233         uint256 _affID;
234         if (_affCode != address(0) && _affCode != _addr)
235         {
236             // get affiliate ID from aff Code 
237             _affID = pIDxAddr_[_affCode];
238             
239             // if affID is not the same as previously stored 
240             if (_affID != plyr_[_pID].laff)
241             {
242                 // update last affiliate
243                 plyr_[_pID].laff = _affID;
244             }
245         }
246         
247         // register name 
248         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
249     }
250     
251     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
252         isHuman()
253         public
254         payable 
255     {
256         // make sure name fees paid
257         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
258         
259         // filter name + condition checks
260         bytes32 _name = NameFilter.nameFilter(_nameString);
261         
262         // set up address 
263         address _addr = msg.sender;
264         
265         // set up our tx event data and determine if player is new or not
266         bool _isNewPlayer = determinePID(_addr);
267         
268         // fetch player id
269         uint256 _pID = pIDxAddr_[_addr];
270         
271         // manage affiliate residuals
272         // if no affiliate code was given or player tried to use their own, lolz
273         uint256 _affID;
274         if (_affCode != "" && _affCode != _name)
275         {
276             // get affiliate ID from aff Code 
277             _affID = pIDxName_[_affCode];
278             
279             // if affID is not the same as previously stored 
280             if (_affID != plyr_[_pID].laff)
281             {
282                 // update last affiliate
283                 plyr_[_pID].laff = _affID;
284             }
285         }
286         
287         // register name 
288         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
289     }
290     
291     /**
292      * @dev players, if you registered a profile, before a game was released, or
293      * set the all bool to false when you registered, use this function to push
294      * your profile to a single game.  also, if you've  updated your name, you
295      * can use this to push your name to games of your choosing.
296      * -functionhash- 0x81c5b206
297      * @param _gameID game id 
298      */
299     function addMeToGame(uint256 _gameID)
300         isHuman()
301         public
302     {
303         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
304         address _addr = msg.sender;
305         uint256 _pID = pIDxAddr_[_addr];
306         require(_pID != 0, "hey there buddy, you dont even have an account");
307         uint256 _totalNames = plyr_[_pID].names;
308         
309         // add players profile and most recent name
310         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
311         
312         // add list of all names
313         if (_totalNames > 1)
314             for (uint256 ii = 1; ii <= _totalNames; ii++)
315                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
316     }
317     
318     /**
319      * @dev players, use this to push your player profile to all registered games.
320      * -functionhash- 0x0c6940ea
321      */
322     function addMeToAllGames()
323         isHuman()
324         public
325     {
326         address _addr = msg.sender;
327         uint256 _pID = pIDxAddr_[_addr];
328         require(_pID != 0, "hey there buddy, you dont even have an account");
329         uint256 _laff = plyr_[_pID].laff;
330         uint256 _totalNames = plyr_[_pID].names;
331         bytes32 _name = plyr_[_pID].name;
332         
333         for (uint256 i = 1; i <= gID_; i++)
334         {
335             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
336             if (_totalNames > 1)
337                 for (uint256 ii = 1; ii <= _totalNames; ii++)
338                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
339         }
340                 
341     }
342     
343     /**
344      * @dev players use this to change back to one of your old names.  tip, you'll
345      * still need to push that info to existing games.
346      * -functionhash- 0xb9291296
347      * @param _nameString the name you want to use 
348      */
349     function useMyOldName(string _nameString)
350         isHuman()
351         public 
352     {
353         // filter name, and get pID
354         bytes32 _name = _nameString.nameFilter();
355         uint256 _pID = pIDxAddr_[msg.sender];
356         
357         // make sure they own the name 
358         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
359         
360         // update their current name 
361         plyr_[_pID].name = _name;
362     }
363     
364 //==============================================================================
365 //     _ _  _ _   | _  _ . _  .
366 //    (_(_)| (/_  |(_)(_||(_  . 
367 //=====================_|=======================================================    
368     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
369         private
370     {
371         // if names already has been used, require that current msg sender owns the name
372         if (pIDxName_[_name] != 0)
373             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
374         
375         // add name to player profile, registry, and name book
376         plyr_[_pID].name = _name;
377         pIDxName_[_name] = _pID;
378         if (plyrNames_[_pID][_name] == false)
379         {
380             plyrNames_[_pID][_name] = true;
381             plyr_[_pID].names++;
382             plyrNameList_[_pID][plyr_[_pID].names] = _name;
383         }
384         
385         // registration fee goes directly to community rewards
386         //Jekyll_Island_Inc.deposit.value(address(this).balance)();
387         
388         // push player info to games
389         if (_all == true)
390             for (uint256 i = 1; i <= gID_; i++)
391                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
392         
393         // fire event
394         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
395     }
396 //==============================================================================
397 //    _|_ _  _ | _  .
398 //     | (_)(_)|_\  .
399 //==============================================================================    
400     function determinePID(address _addr)
401         private
402         returns (bool)
403     {
404         if (pIDxAddr_[_addr] == 0)
405         {
406             pID_++;
407             pIDxAddr_[_addr] = pID_;
408             plyr_[pID_].addr = _addr;
409             
410             // set the new player bool to true
411             return (true);
412         } else {
413             return (false);
414         }
415     }
416 //==============================================================================
417 //   _   _|_ _  _ _  _ |   _ _ || _  .
418 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
419 //==============================================================================
420     function getPlayerID(address _addr)
421         isRegisteredGame()
422         external
423         returns (uint256)
424     {
425         determinePID(_addr);
426         return (pIDxAddr_[_addr]);
427     }
428     function getPlayerName(uint256 _pID)
429         external
430         view
431         returns (bytes32)
432     {
433         return (plyr_[_pID].name);
434     }
435     function getPlayerLAff(uint256 _pID)
436         external
437         view
438         returns (uint256)
439     {
440         return (plyr_[_pID].laff);
441     }
442     function getPlayerAddr(uint256 _pID)
443         external
444         view
445         returns (address)
446     {
447         return (plyr_[_pID].addr);
448     }
449     function getNameFee()
450         external
451         view
452         returns (uint256)
453     {
454         return(registrationFee_);
455     }
456     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
457         isRegisteredGame()
458         external
459         payable
460         returns(bool, uint256)
461     {
462         // make sure name fees paid
463         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
464         
465         // set up our tx event data and determine if player is new or not
466         bool _isNewPlayer = determinePID(_addr);
467         
468         // fetch player id
469         uint256 _pID = pIDxAddr_[_addr];
470         
471         // manage affiliate residuals
472         // if no affiliate code was given, no new affiliate code was given, or the 
473         // player tried to use their own pID as an affiliate code, lolz
474         uint256 _affID = _affCode;
475         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
476         {
477             // update last affiliate 
478             plyr_[_pID].laff = _affID;
479         } else if (_affID == _pID) {
480             _affID = 0;
481         }
482         
483         // register name 
484         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
485         
486         return(_isNewPlayer, _affID);
487     }
488     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
489         isRegisteredGame()
490         external
491         payable
492         returns(bool, uint256)
493     {
494         // make sure name fees paid
495         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
496         
497         // set up our tx event data and determine if player is new or not
498         bool _isNewPlayer = determinePID(_addr);
499         
500         // fetch player id
501         uint256 _pID = pIDxAddr_[_addr];
502         
503         // manage affiliate residuals
504         // if no affiliate code was given or player tried to use their own, lolz
505         uint256 _affID;
506         if (_affCode != address(0) && _affCode != _addr)
507         {
508             // get affiliate ID from aff Code 
509             _affID = pIDxAddr_[_affCode];
510             
511             // if affID is not the same as previously stored 
512             if (_affID != plyr_[_pID].laff)
513             {
514                 // update last affiliate
515                 plyr_[_pID].laff = _affID;
516             }
517         }
518         
519         // register name 
520         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
521         
522         return(_isNewPlayer, _affID);
523     }
524     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
525         isRegisteredGame()
526         external
527         payable
528         returns(bool, uint256)
529     {
530         // make sure name fees paid
531         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
532         
533         // set up our tx event data and determine if player is new or not
534         bool _isNewPlayer = determinePID(_addr);
535         
536         // fetch player id
537         uint256 _pID = pIDxAddr_[_addr];
538         
539         // manage affiliate residuals
540         // if no affiliate code was given or player tried to use their own, lolz
541         uint256 _affID;
542         if (_affCode != "" && _affCode != _name)
543         {
544             // get affiliate ID from aff Code 
545             _affID = pIDxName_[_affCode];
546             
547             // if affID is not the same as previously stored 
548             if (_affID != plyr_[_pID].laff)
549             {
550                 // update last affiliate
551                 plyr_[_pID].laff = _affID;
552             }
553         }
554         
555         // register name 
556         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
557         
558         return(_isNewPlayer, _affID);
559     }
560     
561 //==============================================================================
562 //   _ _ _|_    _   .
563 //  _\(/_ | |_||_)  .
564 //=============|================================================================
565     function addGame(address _gameAddress, string _gameNameStr)
566         onlyDevs()
567         public
568     {
569         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
570         
571         //if (multiSigDev("addGame") == true)
572         //{
573             deleteProposal("addGame");
574             gID_++;
575             bytes32 _name = _gameNameStr.nameFilter();
576             gameIDs_[_gameAddress] = gID_;
577             gameNames_[_gameAddress] = _name;
578             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
579         
580             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
581             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
582             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
583             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
584        // }
585     }
586     
587     function setRegistrationFee(uint256 _fee)
588         onlyDevs()
589         public
590     {
591        // if (multiSigDev("setRegistrationFee") == true)
592        //{
593             deleteProposal("setRegistrationFee");
594             registrationFee_ = _fee;
595        // }
596     }
597         
598 } 
599 
600 /**
601 * @title -Name Filter- v0.1.9
602 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
603 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
604 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
605 *                                  _____                      _____
606 *                                 (, /     /)       /) /)    (, /      /)          /)
607 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
608 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
609 *          ┴ ┴                /   /          .-/ _____   (__ /                               
610 *                            (__ /          (_/ (, /                                      /)™ 
611 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
612 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
613 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
614 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
615 *              _       __    _      ____      ____  _   _    _____  ____  ___  
616 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
617 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
618 *
619 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
620 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
621 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
622 */
623 library NameFilter {
624     
625     /**
626      * @dev filters name strings
627      * -converts uppercase to lower case.  
628      * -makes sure it does not start/end with a space
629      * -makes sure it does not contain multiple spaces in a row
630      * -cannot be only numbers
631      * -cannot start with 0x 
632      * -restricts characters to A-Z, a-z, 0-9, and space.
633      * @return reprocessed string in bytes32 format
634      */
635     function nameFilter(string _input)
636         internal
637         pure
638         returns(bytes32)
639     {
640         bytes memory _temp = bytes(_input);
641         uint256 _length = _temp.length;
642         
643         //sorry limited to 32 characters
644         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
645         // make sure it doesnt start with or end with space
646         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
647         // make sure first two characters are not 0x
648         if (_temp[0] == 0x30)
649         {
650             require(_temp[1] != 0x78, "string cannot start with 0x");
651             require(_temp[1] != 0x58, "string cannot start with 0X");
652         }
653         
654         // create a bool to track if we have a non number character
655         bool _hasNonNumber;
656         
657         // convert & check
658         for (uint256 i = 0; i < _length; i++)
659         {
660             // if its uppercase A-Z
661             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
662             {
663                 // convert to lower case a-z
664                 _temp[i] = byte(uint(_temp[i]) + 32);
665                 
666                 // we have a non number
667                 if (_hasNonNumber == false)
668                     _hasNonNumber = true;
669             } else {
670                 require
671                 (
672                     // require character is a space
673                     _temp[i] == 0x20 || 
674                     // OR lowercase a-z
675                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
676                     // or 0-9
677                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
678                     "string contains invalid characters"
679                 );
680                 // make sure theres not 2x spaces in a row
681                 if (_temp[i] == 0x20)
682                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
683                 
684                 // see if we have a character other than a number
685                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
686                     _hasNonNumber = true;    
687             }
688         }
689         
690         require(_hasNonNumber == true, "string cannot be only numbers");
691         
692         bytes32 _ret;
693         assembly {
694             _ret := mload(add(_temp, 32))
695         }
696         return (_ret);
697     }
698 }
699 
700 /**
701  * @title SafeMath v0.1.9
702  * @dev Math operations with safety checks that throw on error
703  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
704  * - added sqrt
705  * - added sq
706  * - added pwr 
707  * - changed asserts to requires with error log outputs
708  * - removed div, its useless
709  */
710 library SafeMath {
711     
712     /**
713     * @dev Multiplies two numbers, throws on overflow.
714     */
715     function mul(uint256 a, uint256 b) 
716         internal 
717         pure 
718         returns (uint256 c) 
719     {
720         if (a == 0) {
721             return 0;
722         }
723         c = a * b;
724         require(c / a == b, "SafeMath mul failed");
725         return c;
726     }
727 
728     /**
729     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
730     */
731     function sub(uint256 a, uint256 b)
732         internal
733         pure
734         returns (uint256) 
735     {
736         require(b <= a, "SafeMath sub failed");
737         return a - b;
738     }
739 
740     /**
741     * @dev Adds two numbers, throws on overflow.
742     */
743     function add(uint256 a, uint256 b)
744         internal
745         pure
746         returns (uint256 c) 
747     {
748         c = a + b;
749         require(c >= a, "SafeMath add failed");
750         return c;
751     }
752     
753     /**
754      * @dev gives square root of given x.
755      */
756     function sqrt(uint256 x)
757         internal
758         pure
759         returns (uint256 y) 
760     {
761         uint256 z = ((add(x,1)) / 2);
762         y = x;
763         while (z < y) 
764         {
765             y = z;
766             z = ((add((x / z),z)) / 2);
767         }
768     }
769     
770     /**
771      * @dev gives square. multiplies x by x
772      */
773     function sq(uint256 x)
774         internal
775         pure
776         returns (uint256)
777     {
778         return (mul(x,x));
779     }
780     
781     /**
782      * @dev x to the power of y 
783      */
784     function pwr(uint256 x, uint256 y)
785         internal 
786         pure 
787         returns (uint256)
788     {
789         if (x==0)
790             return (0);
791         else if (y==0)
792             return (1);
793         else 
794         {
795             uint256 z = x;
796             for (uint256 i=1; i < y; i++)
797                 z = mul(z,x);
798             return (z);
799         }
800     }
801 }
802 
803 
804 library MSFun {
805     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
806     // DATA SETS
807     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
808     // contact data setup
809     struct Data 
810     {
811         mapping (bytes32 => ProposalData) proposal_;
812     }
813     struct ProposalData 
814     {
815         // a hash of msg.data 
816         bytes32 msgData;
817         // number of signers
818         uint256 count;
819         // tracking of wither admins have signed
820         mapping (address => bool) admin;
821         // list of admins who have signed
822         mapping (uint256 => address) log;
823     }
824     
825     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
826     // MULTI SIG FUNCTIONS
827     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
828     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
829         internal
830         returns(bool) 
831     {
832         // our proposal key will be a hash of our function name + our contracts address 
833         // by adding our contracts address to this, we prevent anyone trying to circumvent
834         // the proposal's security via external calls.
835         bytes32 _whatProposal = whatProposal(_whatFunction);
836         
837         // this is just done to make the code more readable.  grabs the signature count
838         uint256 _currentCount = self.proposal_[_whatProposal].count;
839         
840         // store the address of the person sending the function call.  we use msg.sender 
841         // here as a layer of security.  in case someone imports our contract and tries to 
842         // circumvent function arguments.  still though, our contract that imports this
843         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
844         // calls the function will be a signer. 
845         address _whichAdmin = msg.sender;
846         
847         // prepare our msg data.  by storing this we are able to verify that all admins
848         // are approving the same argument input to be executed for the function.  we hash 
849         // it and store in bytes32 so its size is known and comparable
850         bytes32 _msgData = keccak256(msg.data);
851         
852         // check to see if this is a new execution of this proposal or not
853         if (_currentCount == 0)
854         {
855             // if it is, lets record the original signers data
856             self.proposal_[_whatProposal].msgData = _msgData;
857             
858             // record original senders signature
859             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
860             
861             // update log (used to delete records later, and easy way to view signers)
862             // also useful if the calling function wants to give something to a 
863             // specific signer.  
864             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
865             
866             // track number of signatures
867             self.proposal_[_whatProposal].count += 1;  
868             
869             // if we now have enough signatures to execute the function, lets
870             // return a bool of true.  we put this here in case the required signatures
871             // is set to 1.
872             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
873                 return(true);
874             }            
875         // if its not the first execution, lets make sure the msgData matches
876         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
877             // msgData is a match
878             // make sure admin hasnt already signed
879             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
880             {
881                 // record their signature
882                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
883                 
884                 // update log (used to delete records later, and easy way to view signers)
885                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
886                 
887                 // track number of signatures
888                 self.proposal_[_whatProposal].count += 1;  
889             }
890             
891             // if we now have enough signatures to execute the function, lets
892             // return a bool of true.
893             // we put this here for a few reasons.  (1) in normal operation, if 
894             // that last recorded signature got us to our required signatures.  we 
895             // need to return bool of true.  (2) if we have a situation where the 
896             // required number of signatures was adjusted to at or lower than our current 
897             // signature count, by putting this here, an admin who has already signed,
898             // can call the function again to make it return a true bool.  but only if
899             // they submit the correct msg data
900             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
901                 return(true);
902             }
903         }
904     }
905     
906     
907     // deletes proposal signature data after successfully executing a multiSig function
908     function deleteProposal(Data storage self, bytes32 _whatFunction)
909         internal
910     {
911         //done for readability sake
912         bytes32 _whatProposal = whatProposal(_whatFunction);
913         address _whichAdmin;
914         
915         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
916         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
917         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
918             _whichAdmin = self.proposal_[_whatProposal].log[i];
919             delete self.proposal_[_whatProposal].admin[_whichAdmin];
920             delete self.proposal_[_whatProposal].log[i];
921         }
922         //delete the rest of the data in the record
923         delete self.proposal_[_whatProposal];
924     }
925     
926     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
927     // HELPER FUNCTIONS
928     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
929 
930     function whatProposal(bytes32 _whatFunction)
931         private
932         view
933         returns(bytes32)
934     {
935         return(keccak256(abi.encodePacked(_whatFunction,this)));
936     }
937     
938     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
939     // VANITY FUNCTIONS
940     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
941     // returns a hashed version of msg.data sent by original signer for any given function
942     function checkMsgData (Data storage self, bytes32 _whatFunction)
943         internal
944         view
945         returns (bytes32 msg_data)
946     {
947         bytes32 _whatProposal = whatProposal(_whatFunction);
948         return (self.proposal_[_whatProposal].msgData);
949     }
950     
951     // returns number of signers for any given function
952     function checkCount (Data storage self, bytes32 _whatFunction)
953         internal
954         view
955         returns (uint256 signature_count)
956     {
957         bytes32 _whatProposal = whatProposal(_whatFunction);
958         return (self.proposal_[_whatProposal].count);
959     }
960     
961     // returns address of an admin who signed for any given function
962     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
963         internal
964         view
965         returns (address signer)
966     {
967         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
968         bytes32 _whatProposal = whatProposal(_whatFunction);
969         return (self.proposal_[_whatProposal].log[_signer - 1]);
970     }
971 }