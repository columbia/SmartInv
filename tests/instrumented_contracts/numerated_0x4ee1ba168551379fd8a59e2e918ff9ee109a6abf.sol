1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 //  . _ _|_ _  _ |` _  _ _  _  .
5 //  || | | (/_| ~|~(_|(_(/__\  .
6 //==============================================================================
7 
8 interface PlayerBookReceiverInterface {
9     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
10     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
11 }
12 
13 interface TeamDreamInterface {
14     function requiredSignatures() external view returns(uint256);
15     function requiredDevSignatures() external view returns(uint256);
16     function adminCount() external view returns(uint256);
17     function devCount() external view returns(uint256);
18     function adminName(address _who) external view returns(bytes32);
19     function isAdmin(address _who) external view returns(bool);
20     function isDev(address _who) external view returns(bool);
21 }
22 
23 interface TeamDreamHubInterface {
24     function deposit() external payable;
25 }
26 
27 contract PlayerBook {
28     using NameFilter for string;
29     using SafeMath for uint256;
30 	
31 	address private owner;
32     
33 	TeamDreamHubInterface public TeamDreamHub_;
34     TeamDreamInterface public TeamDream_;
35     MSFun.Data private msData;
36     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamDream_.requiredDevSignatures(), _whatFunction));}
37     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
38     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
39     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
40     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
41     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamDream_.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamDream_.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamDream_.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
42 //==============================================================================
43 //     _| _ _|_ _    _ _ _|_    _   .
44 //    (_|(_| | (_|  _\(/_ | |_||_)  .
45 //=============================|================================================    
46     uint256 public registrationFee_ = 10 finney;            // price to register a name
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
67     constructor(address _TeamDreamHubSCaddress, address _TeamDreamSCaddress)
68         public
69     {
70 		owner = msg.sender;	
71 	
72 		TeamDreamHub_ = TeamDreamHubInterface(_TeamDreamHubSCaddress);
73 		TeamDream_ = TeamDreamInterface(_TeamDreamSCaddress);
74 
75         // premine the dev names (sorry not sorry)
76             // No keys are purchased with this method, it's simply locking our addresses,
77             // PID's and names for referral codes.
78 			
79 		//reminder---should also add them into the addGame() function
80         plyr_[1].addr = owner;
81         plyr_[1].name = "lb";
82         plyr_[1].names = 1;
83         pIDxAddr_[owner] = 1;
84         pIDxName_["lb"] = 1;
85         plyrNames_[1]["lb"] = true;
86         plyrNameList_[1][1] = "lb";
87         
88         plyr_[2].addr = 0xEd5E1C52B48C8a6cfEc77DeB57Be61D097d2eE28;
89         plyr_[2].name = "al";
90         plyr_[2].names = 1;
91         pIDxAddr_[0xEd5E1C52B48C8a6cfEc77DeB57Be61D097d2eE28] = 2;
92         pIDxName_["al"] = 2;
93         plyrNames_[2]["al"] = true;
94         plyrNameList_[2][1] = "al";   
95 
96 		plyr_[3].addr = 0x059743e7B1086c852e0459ded4E8Bc254E7d93CD;
97         plyr_[3].name = "tr";
98         plyr_[3].names = 1;
99         pIDxAddr_[0x059743e7B1086c852e0459ded4E8Bc254E7d93CD] = 3;
100         pIDxName_["tr"] = 3;
101         plyrNames_[3]["tr"] = true;
102         plyrNameList_[3][1] = "tr";
103         
104         pID_ = 3;
105     }
106 //==============================================================================
107 //     _ _  _  _|. |`. _  _ _  .
108 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
109 //==============================================================================    
110     /**
111      * @dev prevents contracts from interacting with fomo3d 
112      */
113     modifier isHuman() {
114         address _addr = msg.sender;
115 		require (_addr == tx.origin);
116 		
117         uint256 _codeLength;
118         
119         assembly {_codeLength := extcodesize(_addr)}
120         require(_codeLength == 0, "sorry humans only");
121         _;
122     }
123     
124     modifier onlyDevs() 
125     {
126         require(TeamDream_.isDev(msg.sender) == true, "msg sender is not a dev");
127         _;
128     }
129     
130     modifier isRegisteredGame()
131     {
132         require(gameIDs_[msg.sender] != 0);
133         _;
134     }
135 //==============================================================================
136 //     _    _  _ _|_ _  .
137 //    (/_\/(/_| | | _\  .
138 //==============================================================================    
139     // fired whenever a player registers a name
140     event onNewName
141     (
142         uint256 indexed playerID,
143         address indexed playerAddress,
144         bytes32 indexed playerName,
145         bool isNewPlayer,
146         uint256 affiliateID,
147         address affiliateAddress,
148         bytes32 affiliateName,
149         uint256 amountPaid,
150         uint256 timeStamp
151     );
152 //==============================================================================
153 //     _  _ _|__|_ _  _ _  .
154 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
155 //=====_|=======================================================================
156     function checkIfNameValid(string _nameStr)
157         public
158         view
159         returns(bool)
160     {
161         bytes32 _name = _nameStr.nameFilter();
162         if (pIDxName_[_name] == 0)
163             return (true);
164         else 
165             return (false);
166     }
167 //==============================================================================
168 //     _    |_ |. _   |`    _  __|_. _  _  _  .
169 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
170 //====|=========================================================================    
171     /**
172      * @dev registers a name.  UI will always display the last name you registered.
173      * but you will still own all previously registered names to use as affiliate 
174      * links.
175      * - must pay a registration fee.
176      * - name must be unique
177      * - names will be converted to lowercase
178      * - name cannot start or end with a space 
179      * - cannot have more than 1 space in a row
180      * - cannot be only numbers
181      * - cannot start with 0x 
182      * - name must be at least 1 char
183      * - max length of 32 characters long
184      * - allowed characters: a-z, 0-9, and space
185      * -functionhash- 0x921dec21 (using ID for affiliate)
186      * -functionhash- 0x3ddd4698 (using address for affiliate)
187      * -functionhash- 0x685ffd83 (using name for affiliate)
188      * @param _nameString players desired name
189      * @param _affCode affiliate ID, address, or name of who refered you
190      * @param _all set to true if you want this to push your info to all games 
191      * (this might cost a lot of gas)
192      */
193     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
194         isHuman()
195         public
196         payable 
197     {
198         // make sure name fees paid
199         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
200         
201         // filter name + condition checks
202         bytes32 _name = NameFilter.nameFilter(_nameString);
203         
204         // set up address 
205         address _addr = msg.sender;
206         
207         // set up our tx event data and determine if player is new or not
208         bool _isNewPlayer = determinePID(_addr);
209         
210         // fetch player id
211         uint256 _pID = pIDxAddr_[_addr];
212         
213         // manage affiliate residuals
214         // if no affiliate code was given, no new affiliate code was given, or the 
215         // player tried to use their own pID as an affiliate code, lolz
216         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
217         {
218             // update last affiliate 
219             plyr_[_pID].laff = _affCode;
220         } else if (_affCode == _pID) {
221             _affCode = 0;
222         }
223         
224         // register name 
225         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
226     }
227     
228     function registerNameXaddr(string _nameString, address _affCode, bool _all)
229         isHuman()
230         public
231         payable 
232     {
233         // make sure name fees paid
234         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
235         
236         // filter name + condition checks
237         bytes32 _name = NameFilter.nameFilter(_nameString);
238         
239         // set up address 
240         address _addr = msg.sender;
241         
242         // set up our tx event data and determine if player is new or not
243         bool _isNewPlayer = determinePID(_addr);
244         
245         // fetch player id
246         uint256 _pID = pIDxAddr_[_addr];
247         
248         // manage affiliate residuals
249         // if no affiliate code was given or player tried to use their own, lolz
250         uint256 _affID;
251         if (_affCode != address(0) && _affCode != _addr)
252         {
253             // get affiliate ID from aff Code 
254             _affID = pIDxAddr_[_affCode];
255             
256             // if affID is not the same as previously stored 
257             if (_affID != plyr_[_pID].laff)
258             {
259                 // update last affiliate
260                 plyr_[_pID].laff = _affID;
261             }
262         }
263         
264         // register name 
265         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
266     }
267     
268     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
269         isHuman()
270         public
271         payable 
272     {
273         // make sure name fees paid
274         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
275         
276         // filter name + condition checks
277         bytes32 _name = NameFilter.nameFilter(_nameString);
278         
279         // set up address 
280         address _addr = msg.sender;
281         
282         // set up our tx event data and determine if player is new or not
283         bool _isNewPlayer = determinePID(_addr);
284         
285         // fetch player id
286         uint256 _pID = pIDxAddr_[_addr];
287         
288         // manage affiliate residuals
289         // if no affiliate code was given or player tried to use their own, lolz
290         uint256 _affID;
291         if (_affCode != "" && _affCode != _name)
292         {
293             // get affiliate ID from aff Code 
294             _affID = pIDxName_[_affCode];
295             
296             // if affID is not the same as previously stored 
297             if (_affID != plyr_[_pID].laff)
298             {
299                 // update last affiliate
300                 plyr_[_pID].laff = _affID;
301             }
302         }
303         
304         // register name 
305         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
306     }
307     
308     /**
309      * @dev players, if you registered a profile, before a game was released, or
310      * set the all bool to false when you registered, use this function to push
311      * your profile to a single game.  also, if you've  updated your name, you
312      * can use this to push your name to games of your choosing.
313      * -functionhash- 0x81c5b206
314      * @param _gameID game id 
315      */
316     function addMeToGame(uint256 _gameID)
317         isHuman()
318         public
319     {
320         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
321         address _addr = msg.sender;
322         uint256 _pID = pIDxAddr_[_addr];
323         require(_pID != 0, "hey there buddy, you dont even have an account");
324         uint256 _totalNames = plyr_[_pID].names;
325         
326         // add players profile and most recent name
327         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
328         
329         // add list of all names
330         if (_totalNames > 1)
331             for (uint256 ii = 1; ii <= _totalNames; ii++)
332                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
333     }
334     
335     /**
336      * @dev players, use this to push your player profile to all registered games.
337      * -functionhash- 0x0c6940ea
338      */
339     function addMeToAllGames()
340         isHuman()
341         public
342     {
343         address _addr = msg.sender;
344         uint256 _pID = pIDxAddr_[_addr];
345         require(_pID != 0, "hey there buddy, you dont even have an account");
346         uint256 _laff = plyr_[_pID].laff;
347         uint256 _totalNames = plyr_[_pID].names;
348         bytes32 _name = plyr_[_pID].name;
349         
350         for (uint256 i = 1; i <= gID_; i++)
351         {
352             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
353             if (_totalNames > 1)
354                 for (uint256 ii = 1; ii <= _totalNames; ii++)
355                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
356         }
357                 
358     }
359     
360     /**
361      * @dev players use this to change back to one of your old names.  tip, you'll
362      * still need to push that info to existing games.
363      * -functionhash- 0xb9291296
364      * @param _nameString the name you want to use 
365      */
366     function useMyOldName(string _nameString)
367         isHuman()
368         public 
369     {
370         // filter name, and get pID
371         bytes32 _name = _nameString.nameFilter();
372         uint256 _pID = pIDxAddr_[msg.sender];
373         
374         // make sure they own the name 
375         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
376         
377         // update their current name 
378         plyr_[_pID].name = _name;
379     }
380     
381 //==============================================================================
382 //     _ _  _ _   | _  _ . _  .
383 //    (_(_)| (/_  |(_)(_||(_  . 
384 //=====================_|=======================================================    
385     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
386         private
387     {
388         // if names already has been used, require that current msg sender owns the name
389         if (pIDxName_[_name] != 0)
390             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
391         
392         // add name to player profile, registry, and name book
393         plyr_[_pID].name = _name;
394         pIDxName_[_name] = _pID;
395         if (plyrNames_[_pID][_name] == false)
396         {
397             plyrNames_[_pID][_name] = true;
398             plyr_[_pID].names++;
399             plyrNameList_[_pID][plyr_[_pID].names] = _name;
400         }
401         
402         // registration fee goes directly to community rewards
403 		TeamDreamHub_.deposit.value(address(this).balance)();
404         
405         // push player info to games
406         if (_all == true)
407             for (uint256 i = 1; i <= gID_; i++)
408                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
409         
410         // fire event
411         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
412     }
413 //==============================================================================
414 //    _|_ _  _ | _  .
415 //     | (_)(_)|_\  .
416 //==============================================================================    
417     function determinePID(address _addr)
418         private
419         returns (bool)
420     {
421         if (pIDxAddr_[_addr] == 0)
422         {
423             pID_++;
424             pIDxAddr_[_addr] = pID_;
425             plyr_[pID_].addr = _addr;
426             
427             // set the new player bool to true
428             return (true);
429         } else {
430             return (false);
431         }
432     }
433 //==============================================================================
434 //   _   _|_ _  _ _  _ |   _ _ || _  .
435 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
436 //==============================================================================
437     function getPlayerID(address _addr)
438         isRegisteredGame()
439         external
440         returns (uint256)
441     {
442         determinePID(_addr);
443         return (pIDxAddr_[_addr]);
444     }
445     function getPlayerName(uint256 _pID)
446         external
447         view
448         returns (bytes32)
449     {
450         return (plyr_[_pID].name);
451     }
452     function getPlayerLAff(uint256 _pID)
453         external
454         view
455         returns (uint256)
456     {
457         return (plyr_[_pID].laff);
458     }
459     function getPlayerAddr(uint256 _pID)
460         external
461         view
462         returns (address)
463     {
464         return (plyr_[_pID].addr);
465     }
466     function getNameFee()
467         external
468         view
469         returns (uint256)
470     {
471         return(registrationFee_);
472     }
473     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
474         isRegisteredGame()
475         external
476         payable
477         returns(bool, uint256)
478     {
479         // make sure name fees paid
480         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
481         
482         // set up our tx event data and determine if player is new or not
483         bool _isNewPlayer = determinePID(_addr);
484         
485         // fetch player id
486         uint256 _pID = pIDxAddr_[_addr];
487         
488         // manage affiliate residuals
489         // if no affiliate code was given, no new affiliate code was given, or the 
490         // player tried to use their own pID as an affiliate code, lolz
491         uint256 _affID = _affCode;
492         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
493         {
494             // update last affiliate 
495             plyr_[_pID].laff = _affID;
496         } else if (_affID == _pID) {
497             _affID = 0;
498         }
499         
500         // register name 
501         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
502         
503         return(_isNewPlayer, _affID);
504     }
505     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
506         isRegisteredGame()
507         external
508         payable
509         returns(bool, uint256)
510     {
511         // make sure name fees paid
512         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
513         
514         // set up our tx event data and determine if player is new or not
515         bool _isNewPlayer = determinePID(_addr);
516         
517         // fetch player id
518         uint256 _pID = pIDxAddr_[_addr];
519         
520         // manage affiliate residuals
521         // if no affiliate code was given or player tried to use their own, lolz
522         uint256 _affID;
523         if (_affCode != address(0) && _affCode != _addr)
524         {
525             // get affiliate ID from aff Code 
526             _affID = pIDxAddr_[_affCode];
527             
528             // if affID is not the same as previously stored 
529             if (_affID != plyr_[_pID].laff)
530             {
531                 // update last affiliate
532                 plyr_[_pID].laff = _affID;
533             }
534         }
535         
536         // register name 
537         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
538         
539         return(_isNewPlayer, _affID);
540     }
541     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
542         isRegisteredGame()
543         external
544         payable
545         returns(bool, uint256)
546     {
547         // make sure name fees paid
548         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
549         
550         // set up our tx event data and determine if player is new or not
551         bool _isNewPlayer = determinePID(_addr);
552         
553         // fetch player id
554         uint256 _pID = pIDxAddr_[_addr];
555         
556         // manage affiliate residuals
557         // if no affiliate code was given or player tried to use their own, lolz
558         uint256 _affID;
559         if (_affCode != "" && _affCode != _name)
560         {
561             // get affiliate ID from aff Code 
562             _affID = pIDxName_[_affCode];
563             
564             // if affID is not the same as previously stored 
565             if (_affID != plyr_[_pID].laff)
566             {
567                 // update last affiliate
568                 plyr_[_pID].laff = _affID;
569             }
570         }
571         
572         // register name 
573         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
574         
575         return(_isNewPlayer, _affID);
576     }
577     
578 //==============================================================================
579 //   _ _ _|_    _   .
580 //  _\(/_ | |_||_)  .
581 //=============|================================================================
582     function addGame(address _gameAddress, string _gameNameStr)
583         onlyDevs()
584         public
585     {
586         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
587         
588         if (multiSigDev("addGame") == true)
589         {deleteProposal("addGame");
590             gID_++;
591             bytes32 _name = _gameNameStr.nameFilter();
592             gameIDs_[_gameAddress] = gID_;
593             gameNames_[_gameAddress] = _name;
594             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
595         
596             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
597 			games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
598             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);            
599         }
600     }
601     
602     function setRegistrationFee(uint256 _fee)
603         onlyDevs()
604         public
605     {
606         if (multiSigDev("setRegistrationFee") == true)
607         {deleteProposal("setRegistrationFee");
608             registrationFee_ = _fee;
609         }
610     }
611         
612 } 
613 
614 /**
615 * @title -Name Filter- v0.1.9
616 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
617 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
618 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
619 *                                  _____                      _____
620 *                                 (, /     /)       /) /)    (, /      /)          /)
621 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
622 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
623 *          ┴ ┴                /   /          .-/ _____   (__ /                               
624 *                            (__ /          (_/ (, /                                      /)™ 
625 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
626 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
627 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
628 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
629 *              _       __    _      ____      ____  _   _    _____  ____  ___  
630 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
631 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
632 *
633 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
634 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
635 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
636 */
637 library NameFilter {
638     
639     /**
640      * @dev filters name strings
641      * -converts uppercase to lower case.  
642      * -makes sure it does not start/end with a space
643      * -makes sure it does not contain multiple spaces in a row
644      * -cannot be only numbers
645      * -cannot start with 0x 
646      * -restricts characters to A-Z, a-z, 0-9, and space.
647      * @return reprocessed string in bytes32 format
648      */
649     function nameFilter(string _input)
650         internal
651         pure
652         returns(bytes32)
653     {
654         bytes memory _temp = bytes(_input);
655         uint256 _length = _temp.length;
656         
657         //sorry limited to 32 characters
658         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
659         // make sure it doesnt start with or end with space
660         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
661         // make sure first two characters are not 0x
662         if (_temp[0] == 0x30)
663         {
664             require(_temp[1] != 0x78, "string cannot start with 0x");
665             require(_temp[1] != 0x58, "string cannot start with 0X");
666         }
667         
668         // create a bool to track if we have a non number character
669         bool _hasNonNumber;
670         
671         // convert & check
672         for (uint256 i = 0; i < _length; i++)
673         {
674             // if its uppercase A-Z
675             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
676             {
677                 // convert to lower case a-z
678                 _temp[i] = byte(uint(_temp[i]) + 32);
679                 
680                 // we have a non number
681                 if (_hasNonNumber == false)
682                     _hasNonNumber = true;
683             } else {
684                 require
685                 (
686                     // require character is a space
687                     _temp[i] == 0x20 || 
688                     // OR lowercase a-z
689                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
690                     // or 0-9
691                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
692                     "string contains invalid characters"
693                 );
694                 // make sure theres not 2x spaces in a row
695                 if (_temp[i] == 0x20)
696                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
697                 
698                 // see if we have a character other than a number
699                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
700                     _hasNonNumber = true;    
701             }
702         }
703         
704         require(_hasNonNumber == true, "string cannot be only numbers");
705         
706         bytes32 _ret;
707         assembly {
708             _ret := mload(add(_temp, 32))
709         }
710         return (_ret);
711     }
712 }
713 
714 /**
715  * @title SafeMath v0.1.9
716  * @dev Math operations with safety checks that throw on error
717  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
718  * - added sqrt
719  * - added sq
720  * - added pwr 
721  * - changed asserts to requires with error log outputs
722  * - removed div, its useless
723  */
724 library SafeMath {
725     
726     /**
727     * @dev Multiplies two numbers, throws on overflow.
728     */
729     function mul(uint256 a, uint256 b) 
730         internal 
731         pure 
732         returns (uint256 c) 
733     {
734         if (a == 0) {
735             return 0;
736         }
737         c = a * b;
738         require(c / a == b, "SafeMath mul failed");
739         return c;
740     }
741 
742     /**
743     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
744     */
745     function sub(uint256 a, uint256 b)
746         internal
747         pure
748         returns (uint256) 
749     {
750         require(b <= a, "SafeMath sub failed");
751         return a - b;
752     }
753 
754     /**
755     * @dev Adds two numbers, throws on overflow.
756     */
757     function add(uint256 a, uint256 b)
758         internal
759         pure
760         returns (uint256 c) 
761     {
762         c = a + b;
763         require(c >= a, "SafeMath add failed");
764         return c;
765     }
766     
767     /**
768      * @dev gives square root of given x.
769      */
770     function sqrt(uint256 x)
771         internal
772         pure
773         returns (uint256 y) 
774     {
775         uint256 z = ((add(x,1)) / 2);
776         y = x;
777         while (z < y) 
778         {
779             y = z;
780             z = ((add((x / z),z)) / 2);
781         }
782     }
783     
784     /**
785      * @dev gives square. multiplies x by x
786      */
787     function sq(uint256 x)
788         internal
789         pure
790         returns (uint256)
791     {
792         return (mul(x,x));
793     }
794     
795     /**
796      * @dev x to the power of y 
797      */
798     function pwr(uint256 x, uint256 y)
799         internal 
800         pure 
801         returns (uint256)
802     {
803         if (x==0)
804             return (0);
805         else if (y==0)
806             return (1);
807         else 
808         {
809             uint256 z = x;
810             for (uint256 i=1; i < y; i++)
811                 z = mul(z,x);
812             return (z);
813         }
814     }
815 }
816 
817 /** @title -MSFun- v0.2.4
818  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
819  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
820  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
821  *                                  _____                      _____
822  *                                 (, /     /)       /) /)    (, /      /)          /)
823  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
824  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
825  *          ┴ ┴                /   /          .-/ _____   (__ /                               
826  *                            (__ /          (_/ (, /                                      /)™ 
827  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
828  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
829  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
830  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
831  *  _           _             _  _  _  _             _  _  _  _  _                                      
832  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
833  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
834  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
835  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
836  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
837  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
838  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
839  *
840  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
841  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
842  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
843  *  
844  *         ┌──────────────────────────────────────────────────────────────────────┐
845  *         │ MSFun, is an importable library that gives your contract the ability │
846  *         │ add multiSig requirement to functions.                               │
847  *         └──────────────────────────────────────────────────────────────────────┘
848  *                                ┌────────────────────┐
849  *                                │ Setup Instructions │
850  *                                └────────────────────┘
851  * (Step 1) import the library into your contract
852  * 
853  *    import "./MSFun.sol";
854  *
855  * (Step 2) set up the signature data for msFun
856  * 
857  *     MSFun.Data private msData;
858  *                                ┌────────────────────┐
859  *                                │ Usage Instructions │
860  *                                └────────────────────┘
861  * at the beginning of a function
862  * 
863  *     function functionName() 
864  *     {
865  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
866  *         {
867  *             MSFun.deleteProposal(msData, "functionName");
868  * 
869  *             // put function body here 
870  *         }
871  *     }
872  *                           ┌─────────────────────────────────┐
873  *                           │ Optional Wrappers For TeamDream │
874  *                           └─────────────────────────────────┘
875  * multiSig wrapper function (cuts down on inputs, improves readability)
876  * this wrapper is HIGHLY recommended
877  * 
878  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamDream.requiredSignatures(), _whatFunction));}
879  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamDream.requiredDevSignatures(), _whatFunction));}
880  *
881  * wrapper for delete proposal (makes code cleaner)
882  *     
883  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
884  *                             ┌────────────────────────────┐
885  *                             │ Utility & Vanity Functions │
886  *                             └────────────────────────────┘
887  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
888  * function, with argument inputs that the other admins do not agree upon, the function
889  * can never be executed until the undesirable arguments are approved.
890  * 
891  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
892  * 
893  * for viewing who has signed a proposal & proposal data
894  *     
895  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
896  *
897  * lets you check address of up to 3 signers (address)
898  * 
899  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
900  *
901  * same as above but will return names in string format.
902  *
903  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamDream.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamDream.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamDream.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
904  *                             ┌──────────────────────────┐
905  *                             │ Functions In Depth Guide │
906  *                             └──────────────────────────┘
907  * In the following examples, the Data is the proposal set for this library.  And
908  * the bytes32 is the name of the function.
909  *
910  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
911  *      proposal for the function being called.  The uint256 is the required 
912  *      number of signatures needed before the multiSig will return true.  
913  *      Upon first call, multiSig will create a proposal and store the arguments 
914  *      passed with the function call as msgData.  Any admins trying to sign the 
915  *      function call will need to send the same argument values. Once required
916  *      number of signatures is reached this will return a bool of true.
917  * 
918  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
919  *      you will want to delete the proposal data.  This does that.
920  *
921  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
922  * 
923  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
924  *      the proposal 
925  * 
926  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
927  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
928  */
929 
930 library MSFun {
931     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
932     // DATA SETS
933     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
934     // contact data setup
935     struct Data 
936     {
937         mapping (bytes32 => ProposalData) proposal_;
938     }
939     struct ProposalData 
940     {
941         // a hash of msg.data 
942         bytes32 msgData;
943         // number of signers
944         uint256 count;
945         // tracking of wither admins have signed
946         mapping (address => bool) admin;
947         // list of admins who have signed
948         mapping (uint256 => address) log;
949     }
950     
951     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
952     // MULTI SIG FUNCTIONS
953     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
954     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
955         internal
956         returns(bool) 
957     {
958         // our proposal key will be a hash of our function name + our contracts address 
959         // by adding our contracts address to this, we prevent anyone trying to circumvent
960         // the proposal's security via external calls.
961         bytes32 _whatProposal = whatProposal(_whatFunction);
962         
963         // this is just done to make the code more readable.  grabs the signature count
964         uint256 _currentCount = self.proposal_[_whatProposal].count;
965         
966         // store the address of the person sending the function call.  we use msg.sender 
967         // here as a layer of security.  in case someone imports our contract and tries to 
968         // circumvent function arguments.  still though, our contract that imports this
969         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
970         // calls the function will be a signer. 
971         address _whichAdmin = msg.sender;
972         
973         // prepare our msg data.  by storing this we are able to verify that all admins
974         // are approving the same argument input to be executed for the function.  we hash 
975         // it and store in bytes32 so its size is known and comparable
976         bytes32 _msgData = keccak256(msg.data);
977         
978         // check to see if this is a new execution of this proposal or not
979         if (_currentCount == 0)
980         {
981             // if it is, lets record the original signers data
982             self.proposal_[_whatProposal].msgData = _msgData;
983             
984             // record original senders signature
985             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
986             
987             // update log (used to delete records later, and easy way to view signers)
988             // also useful if the calling function wants to give something to a 
989             // specific signer.  
990             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
991             
992             // track number of signatures
993             self.proposal_[_whatProposal].count += 1;  
994             
995             // if we now have enough signatures to execute the function, lets
996             // return a bool of true.  we put this here in case the required signatures
997             // is set to 1.
998             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
999                 return(true);
1000             }            
1001         // if its not the first execution, lets make sure the msgData matches
1002         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
1003             // msgData is a match
1004             // make sure admin hasnt already signed
1005             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
1006             {
1007                 // record their signature
1008                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1009                 
1010                 // update log (used to delete records later, and easy way to view signers)
1011                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1012                 
1013                 // track number of signatures
1014                 self.proposal_[_whatProposal].count += 1;  
1015             }
1016             
1017             // if we now have enough signatures to execute the function, lets
1018             // return a bool of true.
1019             // we put this here for a few reasons.  (1) in normal operation, if 
1020             // that last recorded signature got us to our required signatures.  we 
1021             // need to return bool of true.  (2) if we have a situation where the 
1022             // required number of signatures was adjusted to at or lower than our current 
1023             // signature count, by putting this here, an admin who has already signed,
1024             // can call the function again to make it return a true bool.  but only if
1025             // they submit the correct msg data
1026             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1027                 return(true);
1028             }
1029         }
1030     }
1031     
1032     
1033     // deletes proposal signature data after successfully executing a multiSig function
1034     function deleteProposal(Data storage self, bytes32 _whatFunction)
1035         internal
1036     {
1037         //done for readability sake
1038         bytes32 _whatProposal = whatProposal(_whatFunction);
1039         address _whichAdmin;
1040         
1041         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1042         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1043         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1044             _whichAdmin = self.proposal_[_whatProposal].log[i];
1045             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1046             delete self.proposal_[_whatProposal].log[i];
1047         }
1048         //delete the rest of the data in the record
1049         delete self.proposal_[_whatProposal];
1050     }
1051     
1052     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1053     // HELPER FUNCTIONS
1054     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1055 
1056     function whatProposal(bytes32 _whatFunction)
1057         private
1058         view
1059         returns(bytes32)
1060     {
1061         return(keccak256(abi.encodePacked(_whatFunction,this)));
1062     }
1063     
1064     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1065     // VANITY FUNCTIONS
1066     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1067     // returns a hashed version of msg.data sent by original signer for any given function
1068     function checkMsgData (Data storage self, bytes32 _whatFunction)
1069         internal
1070         view
1071         returns (bytes32 msg_data)
1072     {
1073         bytes32 _whatProposal = whatProposal(_whatFunction);
1074         return (self.proposal_[_whatProposal].msgData);
1075     }
1076     
1077     // returns number of signers for any given function
1078     function checkCount (Data storage self, bytes32 _whatFunction)
1079         internal
1080         view
1081         returns (uint256 signature_count)
1082     {
1083         bytes32 _whatProposal = whatProposal(_whatFunction);
1084         return (self.proposal_[_whatProposal].count);
1085     }
1086     
1087     // returns address of an admin who signed for any given function
1088     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1089         internal
1090         view
1091         returns (address signer)
1092     {
1093         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1094         bytes32 _whatProposal = whatProposal(_whatFunction);
1095         return (self.proposal_[_whatProposal].log[_signer - 1]);
1096     }
1097 }