1 pragma solidity ^0.4.24;
2 
3 
4 interface JIincForwarderInterface {
5     function deposit() external payable returns(bool);
6     function status() external view returns(address, address, bool);
7     function startMigration(address _newCorpBank) external returns(bool);
8     function cancelMigration() external returns(bool);
9     function finishMigration() external returns(bool);
10     function setup(address _firstCorpBank) external;
11 }
12 
13 interface PlayerBookReceiverInterface {
14     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
15     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
16 }
17 
18 interface TeamJustInterface {
19     function requiredSignatures() external view returns(uint256);
20     function requiredDevSignatures() external view returns(uint256);
21     function adminCount() external view returns(uint256);
22     function devCount() external view returns(uint256);
23     function adminName(address _who) external view returns(bytes32);
24     function isAdmin(address _who) external view returns(bool);
25     function isDev(address _who) external view returns(bool);
26 }
27 
28 contract PlayerBook {
29     using NameFilter for string;
30     using SafeMath for uint256;
31     
32     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
33     address reward = 0x7218cd0a71ad54d966c3fd008811b67bd1825456;
34     TeamJustInterface constant private TeamJust = TeamJustInterface(0x1097dcccf27ee090e9bf1eaf0e1af11020c50aca);
35     
36     MSFun.Data private msData;
37     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
38     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
39     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
40     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
41     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
42     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
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
68     constructor()
69         public
70     {
71         // premine the dev names (sorry not sorry)
72             // No keys are purchased with this method, it's simply locking our addresses,
73             // PID's and names for referral codes.
74         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
75         plyr_[1].name = "justo";
76         plyr_[1].names = 1;
77         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
78         pIDxName_["justo"] = 1;
79         plyrNames_[1]["justo"] = true;
80         plyrNameList_[1][1] = "justo";
81         
82         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
83         plyr_[2].name = "mantso";
84         plyr_[2].names = 1;
85         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
86         pIDxName_["mantso"] = 2;
87         plyrNames_[2]["mantso"] = true;
88         plyrNameList_[2][1] = "mantso";
89         
90         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
91         plyr_[3].name = "sumpunk";
92         plyr_[3].names = 1;
93         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
94         pIDxName_["sumpunk"] = 3;
95         plyrNames_[3]["sumpunk"] = true;
96         plyrNameList_[3][1] = "sumpunk";
97         
98         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
99         plyr_[4].name = "inventor";
100         plyr_[4].names = 1;
101         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
102         pIDxName_["inventor"] = 4;
103         plyrNames_[4]["inventor"] = true;
104         plyrNameList_[4][1] = "inventor";
105         
106         pID_ = 4;
107     }
108 //==============================================================================
109 //     _ _  _  _|. |`. _  _ _  .
110 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
111 //==============================================================================    
112     /**
113      * @dev prevents contracts from interacting with fomo3d 
114      */
115     modifier isHuman() {
116         address _addr = msg.sender;
117         uint256 _codeLength;
118         
119         assembly {_codeLength := extcodesize(_addr)}
120         require(_codeLength == 0, "sorry humans only");
121         _;
122     }
123     
124     modifier onlyDevs() 
125     {
126         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
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
403         // Jekyll_Island_Inc.deposit.value(address(this).balance)();
404         reward.transfer(address(this).balance);
405         
406         // push player info to games
407         if (_all == true)
408             for (uint256 i = 1; i <= gID_; i++)
409                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
410         
411         // fire event
412         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
413     }
414 //==============================================================================
415 //    _|_ _  _ | _  .
416 //     | (_)(_)|_\  .
417 //==============================================================================    
418     function determinePID(address _addr)
419         private
420         returns (bool)
421     {
422         if (pIDxAddr_[_addr] == 0)
423         {
424             pID_++;
425             pIDxAddr_[_addr] = pID_;
426             plyr_[pID_].addr = _addr;
427             
428             // set the new player bool to true
429             return (true);
430         } else {
431             return (false);
432         }
433     }
434 //==============================================================================
435 //   _   _|_ _  _ _  _ |   _ _ || _  .
436 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
437 //==============================================================================
438     function getPlayerID(address _addr)
439         isRegisteredGame()
440         external
441         returns (uint256)
442     {
443         determinePID(_addr);
444         return (pIDxAddr_[_addr]);
445     }
446     function getPlayerName(uint256 _pID)
447         external
448         view
449         returns (bytes32)
450     {
451         return (plyr_[_pID].name);
452     }
453     function getPlayerLAff(uint256 _pID)
454         external
455         view
456         returns (uint256)
457     {
458         return (plyr_[_pID].laff);
459     }
460     function getPlayerAddr(uint256 _pID)
461         external
462         view
463         returns (address)
464     {
465         return (plyr_[_pID].addr);
466     }
467     function getNameFee()
468         external
469         view
470         returns (uint256)
471     {
472         return(registrationFee_);
473     }
474     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
475         isRegisteredGame()
476         external
477         payable
478         returns(bool, uint256)
479     {
480         // make sure name fees paid
481         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
482         
483         // set up our tx event data and determine if player is new or not
484         bool _isNewPlayer = determinePID(_addr);
485         
486         // fetch player id
487         uint256 _pID = pIDxAddr_[_addr];
488         
489         // manage affiliate residuals
490         // if no affiliate code was given, no new affiliate code was given, or the 
491         // player tried to use their own pID as an affiliate code, lolz
492         uint256 _affID = _affCode;
493         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
494         {
495             // update last affiliate 
496             plyr_[_pID].laff = _affID;
497         } else if (_affID == _pID) {
498             _affID = 0;
499         }
500         
501         // register name 
502         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
503         
504         return(_isNewPlayer, _affID);
505     }
506     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
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
524         if (_affCode != address(0) && _affCode != _addr)
525         {
526             // get affiliate ID from aff Code 
527             _affID = pIDxAddr_[_affCode];
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
542     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
543         isRegisteredGame()
544         external
545         payable
546         returns(bool, uint256)
547     {
548         // make sure name fees paid
549         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
550         
551         // set up our tx event data and determine if player is new or not
552         bool _isNewPlayer = determinePID(_addr);
553         
554         // fetch player id
555         uint256 _pID = pIDxAddr_[_addr];
556         
557         // manage affiliate residuals
558         // if no affiliate code was given or player tried to use their own, lolz
559         uint256 _affID;
560         if (_affCode != "" && _affCode != _name)
561         {
562             // get affiliate ID from aff Code 
563             _affID = pIDxName_[_affCode];
564             
565             // if affID is not the same as previously stored 
566             if (_affID != plyr_[_pID].laff)
567             {
568                 // update last affiliate
569                 plyr_[_pID].laff = _affID;
570             }
571         }
572         
573         // register name 
574         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
575         
576         return(_isNewPlayer, _affID);
577     }
578     
579 //==============================================================================
580 //   _ _ _|_    _   .
581 //  _\(/_ | |_||_)  .
582 //=============|================================================================
583     function addGame(address _gameAddress, string _gameNameStr)
584         onlyDevs()
585         public
586     {
587         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
588         
589         if (multiSigDev("addGame") == true)
590         {deleteProposal("addGame");
591             gID_++;
592             bytes32 _name = _gameNameStr.nameFilter();
593             gameIDs_[_gameAddress] = gID_;
594             gameNames_[_gameAddress] = _name;
595             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
596         
597             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
598             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
599             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
600             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
601         }
602     }
603     
604     function setRegistrationFee(uint256 _fee)
605         onlyDevs()
606         public
607     {
608         if (multiSigDev("setRegistrationFee") == true)
609         {deleteProposal("setRegistrationFee");
610             registrationFee_ = _fee;
611         }
612     }
613         
614 } 
615 
616 /**
617 * @title -Name Filter- v0.1.9
618 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
619 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
620 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
621 *                                  _____                      _____
622 *                                 (, /     /)       /) /)    (, /      /)          /)
623 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
624 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
625 *          ┴ ┴                /   /          .-/ _____   (__ /                               
626 *                            (__ /          (_/ (, /                                      /)™ 
627 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
628 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
629 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
630 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
631 *              _       __    _      ____      ____  _   _    _____  ____  ___  
632 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
633 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
634 *
635 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
636 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
637 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
638 */
639 library NameFilter {
640     
641     /**
642      * @dev filters name strings
643      * -converts uppercase to lower case.  
644      * -makes sure it does not start/end with a space
645      * -makes sure it does not contain multiple spaces in a row
646      * -cannot be only numbers
647      * -cannot start with 0x 
648      * -restricts characters to A-Z, a-z, 0-9, and space.
649      * @return reprocessed string in bytes32 format
650      */
651     function nameFilter(string _input)
652         internal
653         pure
654         returns(bytes32)
655     {
656         bytes memory _temp = bytes(_input);
657         uint256 _length = _temp.length;
658         
659         //sorry limited to 32 characters
660         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
661         // make sure it doesnt start with or end with space
662         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
663         // make sure first two characters are not 0x
664         if (_temp[0] == 0x30)
665         {
666             require(_temp[1] != 0x78, "string cannot start with 0x");
667             require(_temp[1] != 0x58, "string cannot start with 0X");
668         }
669         
670         // create a bool to track if we have a non number character
671         bool _hasNonNumber;
672         
673         // convert & check
674         for (uint256 i = 0; i < _length; i++)
675         {
676             // if its uppercase A-Z
677             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
678             {
679                 // convert to lower case a-z
680                 _temp[i] = byte(uint(_temp[i]) + 32);
681                 
682                 // we have a non number
683                 if (_hasNonNumber == false)
684                     _hasNonNumber = true;
685             } else {
686                 require
687                 (
688                     // require character is a space
689                     _temp[i] == 0x20 || 
690                     // OR lowercase a-z
691                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
692                     // or 0-9
693                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
694                     "string contains invalid characters"
695                 );
696                 // make sure theres not 2x spaces in a row
697                 if (_temp[i] == 0x20)
698                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
699                 
700                 // see if we have a character other than a number
701                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
702                     _hasNonNumber = true;    
703             }
704         }
705         
706         require(_hasNonNumber == true, "string cannot be only numbers");
707         
708         bytes32 _ret;
709         assembly {
710             _ret := mload(add(_temp, 32))
711         }
712         return (_ret);
713     }
714 }
715 
716 /**
717  * @title SafeMath v0.1.9
718  * @dev Math operations with safety checks that throw on error
719  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
720  * - added sqrt
721  * - added sq
722  * - added pwr 
723  * - changed asserts to requires with error log outputs
724  * - removed div, its useless
725  */
726 library SafeMath {
727     
728     /**
729     * @dev Multiplies two numbers, throws on overflow.
730     */
731     function mul(uint256 a, uint256 b) 
732         internal 
733         pure 
734         returns (uint256 c) 
735     {
736         if (a == 0) {
737             return 0;
738         }
739         c = a * b;
740         require(c / a == b, "SafeMath mul failed");
741         return c;
742     }
743 
744     /**
745     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
746     */
747     function sub(uint256 a, uint256 b)
748         internal
749         pure
750         returns (uint256) 
751     {
752         require(b <= a, "SafeMath sub failed");
753         return a - b;
754     }
755 
756     /**
757     * @dev Adds two numbers, throws on overflow.
758     */
759     function add(uint256 a, uint256 b)
760         internal
761         pure
762         returns (uint256 c) 
763     {
764         c = a + b;
765         require(c >= a, "SafeMath add failed");
766         return c;
767     }
768     
769     /**
770      * @dev gives square root of given x.
771      */
772     function sqrt(uint256 x)
773         internal
774         pure
775         returns (uint256 y) 
776     {
777         uint256 z = ((add(x,1)) / 2);
778         y = x;
779         while (z < y) 
780         {
781             y = z;
782             z = ((add((x / z),z)) / 2);
783         }
784     }
785     
786     /**
787      * @dev gives square. multiplies x by x
788      */
789     function sq(uint256 x)
790         internal
791         pure
792         returns (uint256)
793     {
794         return (mul(x,x));
795     }
796     
797     /**
798      * @dev x to the power of y 
799      */
800     function pwr(uint256 x, uint256 y)
801         internal 
802         pure 
803         returns (uint256)
804     {
805         if (x==0)
806             return (0);
807         else if (y==0)
808             return (1);
809         else 
810         {
811             uint256 z = x;
812             for (uint256 i=1; i < y; i++)
813                 z = mul(z,x);
814             return (z);
815         }
816     }
817 }
818 
819 /** @title -MSFun- v0.2.4
820  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
821  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
822  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
823  *                                  _____                      _____
824  *                                 (, /     /)       /) /)    (, /      /)          /)
825  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
826  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
827  *          ┴ ┴                /   /          .-/ _____   (__ /                               
828  *                            (__ /          (_/ (, /                                      /)™ 
829  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
830  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
831  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
832  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
833  *  _           _             _  _  _  _             _  _  _  _  _                                      
834  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
835  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
836  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
837  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
838  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
839  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
840  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
841  *
842  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
843  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
844  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
845  *  
846  *         ┌──────────────────────────────────────────────────────────────────────┐
847  *         │ MSFun, is an importable library that gives your contract the ability │
848  *         │ add multiSig requirement to functions.                               │
849  *         └──────────────────────────────────────────────────────────────────────┘
850  *                                ┌────────────────────┐
851  *                                │ Setup Instructions │
852  *                                └────────────────────┘
853  * (Step 1) import the library into your contract
854  * 
855  *    import "./MSFun.sol";
856  *
857  * (Step 2) set up the signature data for msFun
858  * 
859  *     MSFun.Data private msData;
860  *                                ┌────────────────────┐
861  *                                │ Usage Instructions │
862  *                                └────────────────────┘
863  * at the beginning of a function
864  * 
865  *     function functionName() 
866  *     {
867  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
868  *         {
869  *             MSFun.deleteProposal(msData, "functionName");
870  * 
871  *             // put function body here 
872  *         }
873  *     }
874  *                           ┌────────────────────────────────┐
875  *                           │ Optional Wrappers For TeamJust │
876  *                           └────────────────────────────────┘
877  * multiSig wrapper function (cuts down on inputs, improves readability)
878  * this wrapper is HIGHLY recommended
879  * 
880  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
881  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
882  *
883  * wrapper for delete proposal (makes code cleaner)
884  *     
885  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
886  *                             ┌────────────────────────────┐
887  *                             │ Utility & Vanity Functions │
888  *                             └────────────────────────────┘
889  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
890  * function, with argument inputs that the other admins do not agree upon, the function
891  * can never be executed until the undesirable arguments are approved.
892  * 
893  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
894  * 
895  * for viewing who has signed a proposal & proposal data
896  *     
897  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
898  *
899  * lets you check address of up to 3 signers (address)
900  * 
901  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
902  *
903  * same as above but will return names in string format.
904  *
905  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
906  *                             ┌──────────────────────────┐
907  *                             │ Functions In Depth Guide │
908  *                             └──────────────────────────┘
909  * In the following examples, the Data is the proposal set for this library.  And
910  * the bytes32 is the name of the function.
911  *
912  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
913  *      proposal for the function being called.  The uint256 is the required 
914  *      number of signatures needed before the multiSig will return true.  
915  *      Upon first call, multiSig will create a proposal and store the arguments 
916  *      passed with the function call as msgData.  Any admins trying to sign the 
917  *      function call will need to send the same argument values. Once required
918  *      number of signatures is reached this will return a bool of true.
919  * 
920  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
921  *      you will want to delete the proposal data.  This does that.
922  *
923  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
924  * 
925  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
926  *      the proposal 
927  * 
928  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
929  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
930  */
931 
932 library MSFun {
933     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
934     // DATA SETS
935     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
936     // contact data setup
937     struct Data 
938     {
939         mapping (bytes32 => ProposalData) proposal_;
940     }
941     struct ProposalData 
942     {
943         // a hash of msg.data 
944         bytes32 msgData;
945         // number of signers
946         uint256 count;
947         // tracking of wither admins have signed
948         mapping (address => bool) admin;
949         // list of admins who have signed
950         mapping (uint256 => address) log;
951     }
952     
953     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
954     // MULTI SIG FUNCTIONS
955     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
956     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
957         internal
958         returns(bool) 
959     {
960         // our proposal key will be a hash of our function name + our contracts address 
961         // by adding our contracts address to this, we prevent anyone trying to circumvent
962         // the proposal's security via external calls.
963         bytes32 _whatProposal = whatProposal(_whatFunction);
964         
965         // this is just done to make the code more readable.  grabs the signature count
966         uint256 _currentCount = self.proposal_[_whatProposal].count;
967         
968         // store the address of the person sending the function call.  we use msg.sender 
969         // here as a layer of security.  in case someone imports our contract and tries to 
970         // circumvent function arguments.  still though, our contract that imports this
971         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
972         // calls the function will be a signer. 
973         address _whichAdmin = msg.sender;
974         
975         // prepare our msg data.  by storing this we are able to verify that all admins
976         // are approving the same argument input to be executed for the function.  we hash 
977         // it and store in bytes32 so its size is known and comparable
978         bytes32 _msgData = keccak256(msg.data);
979         
980         // check to see if this is a new execution of this proposal or not
981         if (_currentCount == 0)
982         {
983             // if it is, lets record the original signers data
984             self.proposal_[_whatProposal].msgData = _msgData;
985             
986             // record original senders signature
987             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
988             
989             // update log (used to delete records later, and easy way to view signers)
990             // also useful if the calling function wants to give something to a 
991             // specific signer.  
992             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
993             
994             // track number of signatures
995             self.proposal_[_whatProposal].count += 1;  
996             
997             // if we now have enough signatures to execute the function, lets
998             // return a bool of true.  we put this here in case the required signatures
999             // is set to 1.
1000             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1001                 return(true);
1002             }            
1003         // if its not the first execution, lets make sure the msgData matches
1004         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
1005             // msgData is a match
1006             // make sure admin hasnt already signed
1007             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
1008             {
1009                 // record their signature
1010                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1011                 
1012                 // update log (used to delete records later, and easy way to view signers)
1013                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1014                 
1015                 // track number of signatures
1016                 self.proposal_[_whatProposal].count += 1;  
1017             }
1018             
1019             // if we now have enough signatures to execute the function, lets
1020             // return a bool of true.
1021             // we put this here for a few reasons.  (1) in normal operation, if 
1022             // that last recorded signature got us to our required signatures.  we 
1023             // need to return bool of true.  (2) if we have a situation where the 
1024             // required number of signatures was adjusted to at or lower than our current 
1025             // signature count, by putting this here, an admin who has already signed,
1026             // can call the function again to make it return a true bool.  but only if
1027             // they submit the correct msg data
1028             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1029                 return(true);
1030             }
1031         }
1032     }
1033     
1034     
1035     // deletes proposal signature data after successfully executing a multiSig function
1036     function deleteProposal(Data storage self, bytes32 _whatFunction)
1037         internal
1038     {
1039         //done for readability sake
1040         bytes32 _whatProposal = whatProposal(_whatFunction);
1041         address _whichAdmin;
1042         
1043         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1044         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1045         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1046             _whichAdmin = self.proposal_[_whatProposal].log[i];
1047             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1048             delete self.proposal_[_whatProposal].log[i];
1049         }
1050         //delete the rest of the data in the record
1051         delete self.proposal_[_whatProposal];
1052     }
1053     
1054     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1055     // HELPER FUNCTIONS
1056     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1057 
1058     function whatProposal(bytes32 _whatFunction)
1059         private
1060         view
1061         returns(bytes32)
1062     {
1063         return(keccak256(abi.encodePacked(_whatFunction,this)));
1064     }
1065     
1066     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1067     // VANITY FUNCTIONS
1068     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1069     // returns a hashed version of msg.data sent by original signer for any given function
1070     function checkMsgData (Data storage self, bytes32 _whatFunction)
1071         internal
1072         view
1073         returns (bytes32 msg_data)
1074     {
1075         bytes32 _whatProposal = whatProposal(_whatFunction);
1076         return (self.proposal_[_whatProposal].msgData);
1077     }
1078     
1079     // returns number of signers for any given function
1080     function checkCount (Data storage self, bytes32 _whatFunction)
1081         internal
1082         view
1083         returns (uint256 signature_count)
1084     {
1085         bytes32 _whatProposal = whatProposal(_whatFunction);
1086         return (self.proposal_[_whatProposal].count);
1087     }
1088     
1089     // returns address of an admin who signed for any given function
1090     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1091         internal
1092         view
1093         returns (address signer)
1094     {
1095         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1096         bytes32 _whatProposal = whatProposal(_whatFunction);
1097         return (self.proposal_[_whatProposal].log[_signer - 1]);
1098     }
1099 }