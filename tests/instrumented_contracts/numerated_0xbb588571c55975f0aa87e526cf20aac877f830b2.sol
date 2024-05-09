1 pragma solidity ^0.4.24;
2 
3 interface JIincForwarderInterface {
4     function deposit() external payable returns(bool);
5     function status() external view returns(address, address, bool);
6     function startMigration(address _newCorpBank) external returns(bool);
7     function cancelMigration() external returns(bool);
8     function finishMigration() external returns(bool);
9     function setup(address _firstCorpBank) external;
10 }
11 
12 interface PlayerBookReceiverInterface {
13     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
14     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
15 }
16 
17 interface TeamJustInterface {
18     function requiredSignatures() external view returns(uint256);
19     function requiredDevSignatures() external view returns(uint256);
20     function adminCount() external view returns(uint256);
21     function devCount() external view returns(uint256);
22     function adminName(address _who) external view returns(bytes32);
23     function isAdmin(address _who) external view returns(bool);
24     function isDev(address _who) external view returns(bool);
25 }
26 
27 contract PlayerBook {
28     using NameFilter for string;
29     using SafeMath for uint256;
30 
31 	//for setting
32     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x84AB3c7f95E664223b871Ec2b4FA37E39f1B1F40);
33     TeamJustInterface constant private TeamJust = TeamJustInterface(0x4D499E43eadbab98b8995F473163dAca0Fd8ac3a);
34 
35     MSFun.Data private msData;
36     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
37     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
38     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
39     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
40     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
41     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
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
67     constructor()
68         public
69     {
70         // premine the dev names (sorry not sorry)
71             // No keys are purchased with this method, it's simply locking our addresses,
72             // PID's and names for referral codes.
73         plyr_[1].addr = 0x700D7ccD114D988f0CEDDFCc60dd8c3a2f7b49FB;
74         plyr_[1].name = "f3dlink";
75         plyr_[1].names = 1;
76         pIDxAddr_[0x700D7ccD114D988f0CEDDFCc60dd8c3a2f7b49FB] = 1;
77         pIDxName_["f3dlink"] = 1;
78         plyrNames_[1]["f3dlink"] = true;
79         plyrNameList_[1][1] = "f3dlink";
80         
81         pID_ = 1;
82     }
83 //==============================================================================
84 //     _ _  _  _|. |`. _  _ _  .
85 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
86 //==============================================================================    
87     /**
88      * @dev prevents contracts from interacting with fomo3d 
89      */
90     modifier isHuman() {
91         address _addr = msg.sender;
92         uint256 _codeLength;
93         
94         assembly {_codeLength := extcodesize(_addr)}
95         require(_codeLength == 0, "sorry humans only");
96         _;
97     }
98     
99     modifier onlyDevs() 
100     {
101         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
102         _;
103     }
104     
105     modifier isRegisteredGame()
106     {
107         require(gameIDs_[msg.sender] != 0);
108         _;
109     }
110 //==============================================================================
111 //     _    _  _ _|_ _  .
112 //    (/_\/(/_| | | _\  .
113 //==============================================================================    
114     // fired whenever a player registers a name
115     event onNewName
116     (
117         uint256 indexed playerID,
118         address indexed playerAddress,
119         bytes32 indexed playerName,
120         bool isNewPlayer,
121         uint256 affiliateID,
122         address affiliateAddress,
123         bytes32 affiliateName,
124         uint256 amountPaid,
125         uint256 timeStamp
126     );
127 //==============================================================================
128 //     _  _ _|__|_ _  _ _  .
129 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
130 //=====_|=======================================================================
131     function checkIfNameValid(string _nameStr)
132         public
133         view
134         returns(bool)
135     {
136         bytes32 _name = _nameStr.nameFilter();
137         if (pIDxName_[_name] == 0)
138             return (true);
139         else 
140             return (false);
141     }
142 //==============================================================================
143 //     _    |_ |. _   |`    _  __|_. _  _  _  .
144 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
145 //====|=========================================================================    
146     /**
147      * @dev registers a name.  UI will always display the last name you registered.
148      * but you will still own all previously registered names to use as affiliate 
149      * links.
150      * - must pay a registration fee.
151      * - name must be unique
152      * - names will be converted to lowercase
153      * - name cannot start or end with a space 
154      * - cannot have more than 1 space in a row
155      * - cannot be only numbers
156      * - cannot start with 0x 
157      * - name must be at least 1 char
158      * - max length of 32 characters long
159      * - allowed characters: a-z, 0-9, and space
160      * -functionhash- 0x921dec21 (using ID for affiliate)
161      * -functionhash- 0x3ddd4698 (using address for affiliate)
162      * -functionhash- 0x685ffd83 (using name for affiliate)
163      * @param _nameString players desired name
164      * @param _affCode affiliate ID, address, or name of who refered you
165      * @param _all set to true if you want this to push your info to all games 
166      * (this might cost a lot of gas)
167      */
168     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
169         isHuman()
170         public
171         payable 
172     {
173         // make sure name fees paid
174         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
175         
176         // filter name + condition checks
177         bytes32 _name = NameFilter.nameFilter(_nameString);
178         
179         // set up address 
180         address _addr = msg.sender;
181         
182         // set up our tx event data and determine if player is new or not
183         bool _isNewPlayer = determinePID(_addr);
184         
185         // fetch player id
186         uint256 _pID = pIDxAddr_[_addr];
187         
188         // manage affiliate residuals
189         // if no affiliate code was given, no new affiliate code was given, or the 
190         // player tried to use their own pID as an affiliate code, lolz
191         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
192         {
193             // update last affiliate 
194             plyr_[_pID].laff = _affCode;
195         } else if (_affCode == _pID) {
196             _affCode = 0;
197         }
198         
199         // register name 
200         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
201     }
202     
203     function registerNameXaddr(string _nameString, address _affCode, bool _all)
204         isHuman()
205         public
206         payable 
207     {
208         // make sure name fees paid
209         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
210         
211         // filter name + condition checks
212         bytes32 _name = NameFilter.nameFilter(_nameString);
213         
214         // set up address 
215         address _addr = msg.sender;
216         
217         // set up our tx event data and determine if player is new or not
218         bool _isNewPlayer = determinePID(_addr);
219         
220         // fetch player id
221         uint256 _pID = pIDxAddr_[_addr];
222         
223         // manage affiliate residuals
224         // if no affiliate code was given or player tried to use their own, lolz
225         uint256 _affID;
226         if (_affCode != address(0) && _affCode != _addr)
227         {
228             // get affiliate ID from aff Code 
229             _affID = pIDxAddr_[_affCode];
230             
231             // if affID is not the same as previously stored 
232             if (_affID != plyr_[_pID].laff)
233             {
234                 // update last affiliate
235                 plyr_[_pID].laff = _affID;
236             }
237         }
238         
239         // register name 
240         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
241     }
242     
243     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
244         isHuman()
245         public
246         payable 
247     {
248         // make sure name fees paid
249         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
250         
251         // filter name + condition checks
252         bytes32 _name = NameFilter.nameFilter(_nameString);
253         
254         // set up address 
255         address _addr = msg.sender;
256         
257         // set up our tx event data and determine if player is new or not
258         bool _isNewPlayer = determinePID(_addr);
259         
260         // fetch player id
261         uint256 _pID = pIDxAddr_[_addr];
262         
263         // manage affiliate residuals
264         // if no affiliate code was given or player tried to use their own, lolz
265         uint256 _affID;
266         if (_affCode != "" && _affCode != _name)
267         {
268             // get affiliate ID from aff Code 
269             _affID = pIDxName_[_affCode];
270             
271             // if affID is not the same as previously stored 
272             if (_affID != plyr_[_pID].laff)
273             {
274                 // update last affiliate
275                 plyr_[_pID].laff = _affID;
276             }
277         }
278         
279         // register name 
280         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
281     }
282     
283     /**
284      * @dev players, if you registered a profile, before a game was released, or
285      * set the all bool to false when you registered, use this function to push
286      * your profile to a single game.  also, if you've  updated your name, you
287      * can use this to push your name to games of your choosing.
288      * -functionhash- 0x81c5b206
289      * @param _gameID game id 
290      */
291     function addMeToGame(uint256 _gameID)
292         isHuman()
293         public
294     {
295         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
296         address _addr = msg.sender;
297         uint256 _pID = pIDxAddr_[_addr];
298         require(_pID != 0, "hey there buddy, you dont even have an account");
299         uint256 _totalNames = plyr_[_pID].names;
300         
301         // add players profile and most recent name
302         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
303         
304         // add list of all names
305         if (_totalNames > 1)
306             for (uint256 ii = 1; ii <= _totalNames; ii++)
307                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
308     }
309     
310     /**
311      * @dev players, use this to push your player profile to all registered games.
312      * -functionhash- 0x0c6940ea
313      */
314     function addMeToAllGames()
315         isHuman()
316         public
317     {
318         address _addr = msg.sender;
319         uint256 _pID = pIDxAddr_[_addr];
320         require(_pID != 0, "hey there buddy, you dont even have an account");
321         uint256 _laff = plyr_[_pID].laff;
322         uint256 _totalNames = plyr_[_pID].names;
323         bytes32 _name = plyr_[_pID].name;
324         
325         for (uint256 i = 1; i <= gID_; i++)
326         {
327             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
328             if (_totalNames > 1)
329                 for (uint256 ii = 1; ii <= _totalNames; ii++)
330                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
331         }
332                 
333     }
334     
335     /**
336      * @dev players use this to change back to one of your old names.  tip, you'll
337      * still need to push that info to existing games.
338      * -functionhash- 0xb9291296
339      * @param _nameString the name you want to use 
340      */
341     function useMyOldName(string _nameString)
342         isHuman()
343         public 
344     {
345         // filter name, and get pID
346         bytes32 _name = _nameString.nameFilter();
347         uint256 _pID = pIDxAddr_[msg.sender];
348         
349         // make sure they own the name 
350         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
351         
352         // update their current name 
353         plyr_[_pID].name = _name;
354     }
355     
356 //==============================================================================
357 //     _ _  _ _   | _  _ . _  .
358 //    (_(_)| (/_  |(_)(_||(_  . 
359 //=====================_|=======================================================    
360     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
361         private
362     {
363         // if names already has been used, require that current msg sender owns the name
364         if (pIDxName_[_name] != 0)
365             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
366         
367         // add name to player profile, registry, and name book
368         plyr_[_pID].name = _name;
369         pIDxName_[_name] = _pID;
370         if (plyrNames_[_pID][_name] == false)
371         {
372             plyrNames_[_pID][_name] = true;
373             plyr_[_pID].names++;
374             plyrNameList_[_pID][plyr_[_pID].names] = _name;
375         }
376         
377         // registration fee goes directly to community rewards
378         Jekyll_Island_Inc.deposit.value(address(this).balance)();
379         
380         // push player info to games
381         if (_all == true)
382             for (uint256 i = 1; i <= gID_; i++)
383                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
384         
385         // fire event
386         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
387     }
388 //==============================================================================
389 //    _|_ _  _ | _  .
390 //     | (_)(_)|_\  .
391 //==============================================================================    
392     function determinePID(address _addr)
393         private
394         returns (bool)
395     {
396         if (pIDxAddr_[_addr] == 0)
397         {
398             pID_++;
399             pIDxAddr_[_addr] = pID_;
400             plyr_[pID_].addr = _addr;
401             
402             // set the new player bool to true
403             return (true);
404         } else {
405             return (false);
406         }
407     }
408 //==============================================================================
409 //   _   _|_ _  _ _  _ |   _ _ || _  .
410 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
411 //==============================================================================
412     function getPlayerID(address _addr)
413         isRegisteredGame()
414         external
415         returns (uint256)
416     {
417         determinePID(_addr);
418         return (pIDxAddr_[_addr]);
419     }
420     function getPlayerName(uint256 _pID)
421         external
422         view
423         returns (bytes32)
424     {
425         return (plyr_[_pID].name);
426     }
427     function getPlayerLAff(uint256 _pID)
428         external
429         view
430         returns (uint256)
431     {
432         return (plyr_[_pID].laff);
433     }
434     function getPlayerAddr(uint256 _pID)
435         external
436         view
437         returns (address)
438     {
439         return (plyr_[_pID].addr);
440     }
441     function getNameFee()
442         external
443         view
444         returns (uint256)
445     {
446         return(registrationFee_);
447     }
448     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
449         isRegisteredGame()
450         external
451         payable
452         returns(bool, uint256)
453     {
454         // make sure name fees paid
455         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
456         
457         // set up our tx event data and determine if player is new or not
458         bool _isNewPlayer = determinePID(_addr);
459         
460         // fetch player id
461         uint256 _pID = pIDxAddr_[_addr];
462         
463         // manage affiliate residuals
464         // if no affiliate code was given, no new affiliate code was given, or the 
465         // player tried to use their own pID as an affiliate code, lolz
466         uint256 _affID = _affCode;
467         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
468         {
469             // update last affiliate 
470             plyr_[_pID].laff = _affID;
471         } else if (_affID == _pID) {
472             _affID = 0;
473         }
474         
475         // register name 
476         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
477         
478         return(_isNewPlayer, _affID);
479     }
480     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
481         isRegisteredGame()
482         external
483         payable
484         returns(bool, uint256)
485     {
486         // make sure name fees paid
487         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
488         
489         // set up our tx event data and determine if player is new or not
490         bool _isNewPlayer = determinePID(_addr);
491         
492         // fetch player id
493         uint256 _pID = pIDxAddr_[_addr];
494         
495         // manage affiliate residuals
496         // if no affiliate code was given or player tried to use their own, lolz
497         uint256 _affID;
498         if (_affCode != address(0) && _affCode != _addr)
499         {
500             // get affiliate ID from aff Code 
501             _affID = pIDxAddr_[_affCode];
502             
503             // if affID is not the same as previously stored 
504             if (_affID != plyr_[_pID].laff)
505             {
506                 // update last affiliate
507                 plyr_[_pID].laff = _affID;
508             }
509         }
510         
511         // register name 
512         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
513         
514         return(_isNewPlayer, _affID);
515     }
516     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
517         isRegisteredGame()
518         external
519         payable
520         returns(bool, uint256)
521     {
522         // make sure name fees paid
523         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
524         
525         // set up our tx event data and determine if player is new or not
526         bool _isNewPlayer = determinePID(_addr);
527         
528         // fetch player id
529         uint256 _pID = pIDxAddr_[_addr];
530         
531         // manage affiliate residuals
532         // if no affiliate code was given or player tried to use their own, lolz
533         uint256 _affID;
534         if (_affCode != "" && _affCode != _name)
535         {
536             // get affiliate ID from aff Code 
537             _affID = pIDxName_[_affCode];
538             
539             // if affID is not the same as previously stored 
540             if (_affID != plyr_[_pID].laff)
541             {
542                 // update last affiliate
543                 plyr_[_pID].laff = _affID;
544             }
545         }
546         
547         // register name 
548         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
549         
550         return(_isNewPlayer, _affID);
551     }
552     
553 //==============================================================================
554 //   _ _ _|_    _   .
555 //  _\(/_ | |_||_)  .
556 //=============|================================================================
557     function addGame(address _gameAddress, string _gameNameStr)
558         onlyDevs()
559         public
560     {
561         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
562         
563         if (multiSigDev("addGame") == true)
564         {deleteProposal("addGame");
565             gID_++;
566             bytes32 _name = _gameNameStr.nameFilter();
567             gameIDs_[_gameAddress] = gID_;
568             gameNames_[_gameAddress] = _name;
569             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
570         
571             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
572             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
573             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
574             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
575         }
576     }
577     
578     function setRegistrationFee(uint256 _fee)
579         onlyDevs()
580         public
581     {
582         if (multiSigDev("setRegistrationFee") == true)
583         {deleteProposal("setRegistrationFee");
584             registrationFee_ = _fee;
585         }
586     }
587         
588 } 
589 
590 /**
591 * @title -Name Filter- v0.1.9
592 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
593 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
594 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
595 *                                  _____                      _____
596 *                                 (, /     /)       /) /)    (, /      /)          /)
597 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
598 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
599 *          ┴ ┴                /   /          .-/ _____   (__ /                               
600 *                            (__ /          (_/ (, /                                      /)™ 
601 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
602 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
603 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
604 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
605 *              _       __    _      ____      ____  _   _    _____  ____  ___  
606 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
607 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
608 *
609 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
610 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
611 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
612 */
613 library NameFilter {
614     
615     /**
616      * @dev filters name strings
617      * -converts uppercase to lower case.  
618      * -makes sure it does not start/end with a space
619      * -makes sure it does not contain multiple spaces in a row
620      * -cannot be only numbers
621      * -cannot start with 0x 
622      * -restricts characters to A-Z, a-z, 0-9, and space.
623      * @return reprocessed string in bytes32 format
624      */
625     function nameFilter(string _input)
626         internal
627         pure
628         returns(bytes32)
629     {
630         bytes memory _temp = bytes(_input);
631         uint256 _length = _temp.length;
632         
633         //sorry limited to 32 characters
634         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
635         // make sure it doesnt start with or end with space
636         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
637         // make sure first two characters are not 0x
638         if (_temp[0] == 0x30)
639         {
640             require(_temp[1] != 0x78, "string cannot start with 0x");
641             require(_temp[1] != 0x58, "string cannot start with 0X");
642         }
643         
644         // create a bool to track if we have a non number character
645         bool _hasNonNumber;
646         
647         // convert & check
648         for (uint256 i = 0; i < _length; i++)
649         {
650             // if its uppercase A-Z
651             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
652             {
653                 // convert to lower case a-z
654                 _temp[i] = byte(uint(_temp[i]) + 32);
655                 
656                 // we have a non number
657                 if (_hasNonNumber == false)
658                     _hasNonNumber = true;
659             } else {
660                 require
661                 (
662                     // require character is a space
663                     _temp[i] == 0x20 || 
664                     // OR lowercase a-z
665                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
666                     // or 0-9
667                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
668                     "string contains invalid characters"
669                 );
670                 // make sure theres not 2x spaces in a row
671                 if (_temp[i] == 0x20)
672                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
673                 
674                 // see if we have a character other than a number
675                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
676                     _hasNonNumber = true;    
677             }
678         }
679         
680         require(_hasNonNumber == true, "string cannot be only numbers");
681         
682         bytes32 _ret;
683         assembly {
684             _ret := mload(add(_temp, 32))
685         }
686         return (_ret);
687     }
688 }
689 
690 /**
691  * @title SafeMath v0.1.9
692  * @dev Math operations with safety checks that throw on error
693  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
694  * - added sqrt
695  * - added sq
696  * - added pwr 
697  * - changed asserts to requires with error log outputs
698  * - removed div, its useless
699  */
700 library SafeMath {
701     
702     /**
703     * @dev Multiplies two numbers, throws on overflow.
704     */
705     function mul(uint256 a, uint256 b) 
706         internal 
707         pure 
708         returns (uint256 c) 
709     {
710         if (a == 0) {
711             return 0;
712         }
713         c = a * b;
714         require(c / a == b, "SafeMath mul failed");
715         return c;
716     }
717 
718     /**
719     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
720     */
721     function sub(uint256 a, uint256 b)
722         internal
723         pure
724         returns (uint256) 
725     {
726         require(b <= a, "SafeMath sub failed");
727         return a - b;
728     }
729 
730     /**
731     * @dev Adds two numbers, throws on overflow.
732     */
733     function add(uint256 a, uint256 b)
734         internal
735         pure
736         returns (uint256 c) 
737     {
738         c = a + b;
739         require(c >= a, "SafeMath add failed");
740         return c;
741     }
742     
743     /**
744      * @dev gives square root of given x.
745      */
746     function sqrt(uint256 x)
747         internal
748         pure
749         returns (uint256 y) 
750     {
751         uint256 z = ((add(x,1)) / 2);
752         y = x;
753         while (z < y) 
754         {
755             y = z;
756             z = ((add((x / z),z)) / 2);
757         }
758     }
759     
760     /**
761      * @dev gives square. multiplies x by x
762      */
763     function sq(uint256 x)
764         internal
765         pure
766         returns (uint256)
767     {
768         return (mul(x,x));
769     }
770     
771     /**
772      * @dev x to the power of y 
773      */
774     function pwr(uint256 x, uint256 y)
775         internal 
776         pure 
777         returns (uint256)
778     {
779         if (x==0)
780             return (0);
781         else if (y==0)
782             return (1);
783         else 
784         {
785             uint256 z = x;
786             for (uint256 i=1; i < y; i++)
787                 z = mul(z,x);
788             return (z);
789         }
790     }
791 }
792 
793 /** @title -MSFun- v0.2.4
794  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
795  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
796  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
797  *                                  _____                      _____
798  *                                 (, /     /)       /) /)    (, /      /)          /)
799  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
800  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
801  *          ┴ ┴                /   /          .-/ _____   (__ /                               
802  *                            (__ /          (_/ (, /                                      /)™ 
803  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
804  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
805  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
806  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
807  *  _           _             _  _  _  _             _  _  _  _  _                                      
808  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
809  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
810  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
811  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
812  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
813  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
814  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
815  *
816  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
817  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
818  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
819  *  
820  *         ┌──────────────────────────────────────────────────────────────────────┐
821  *         │ MSFun, is an importable library that gives your contract the ability │
822  *         │ add multiSig requirement to functions.                               │
823  *         └──────────────────────────────────────────────────────────────────────┘
824  *                                ┌────────────────────┐
825  *                                │ Setup Instructions │
826  *                                └────────────────────┘
827  * (Step 1) import the library into your contract
828  * 
829  *    import "./MSFun.sol";
830  *
831  * (Step 2) set up the signature data for msFun
832  * 
833  *     MSFun.Data private msData;
834  *                                ┌────────────────────┐
835  *                                │ Usage Instructions │
836  *                                └────────────────────┘
837  * at the beginning of a function
838  * 
839  *     function functionName() 
840  *     {
841  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
842  *         {
843  *             MSFun.deleteProposal(msData, "functionName");
844  * 
845  *             // put function body here 
846  *         }
847  *     }
848  *                           ┌────────────────────────────────┐
849  *                           │ Optional Wrappers For TeamJust │
850  *                           └────────────────────────────────┘
851  * multiSig wrapper function (cuts down on inputs, improves readability)
852  * this wrapper is HIGHLY recommended
853  * 
854  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
855  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
856  *
857  * wrapper for delete proposal (makes code cleaner)
858  *     
859  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
860  *                             ┌────────────────────────────┐
861  *                             │ Utility & Vanity Functions │
862  *                             └────────────────────────────┘
863  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
864  * function, with argument inputs that the other admins do not agree upon, the function
865  * can never be executed until the undesirable arguments are approved.
866  * 
867  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
868  * 
869  * for viewing who has signed a proposal & proposal data
870  *     
871  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
872  *
873  * lets you check address of up to 3 signers (address)
874  * 
875  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
876  *
877  * same as above but will return names in string format.
878  *
879  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
880  *                             ┌──────────────────────────┐
881  *                             │ Functions In Depth Guide │
882  *                             └──────────────────────────┘
883  * In the following examples, the Data is the proposal set for this library.  And
884  * the bytes32 is the name of the function.
885  *
886  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
887  *      proposal for the function being called.  The uint256 is the required 
888  *      number of signatures needed before the multiSig will return true.  
889  *      Upon first call, multiSig will create a proposal and store the arguments 
890  *      passed with the function call as msgData.  Any admins trying to sign the 
891  *      function call will need to send the same argument values. Once required
892  *      number of signatures is reached this will return a bool of true.
893  * 
894  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
895  *      you will want to delete the proposal data.  This does that.
896  *
897  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
898  * 
899  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
900  *      the proposal 
901  * 
902  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
903  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
904  */
905 
906 library MSFun {
907     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
908     // DATA SETS
909     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
910     // contact data setup
911     struct Data 
912     {
913         mapping (bytes32 => ProposalData) proposal_;
914     }
915     struct ProposalData 
916     {
917         // a hash of msg.data 
918         bytes32 msgData;
919         // number of signers
920         uint256 count;
921         // tracking of wither admins have signed
922         mapping (address => bool) admin;
923         // list of admins who have signed
924         mapping (uint256 => address) log;
925     }
926     
927     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
928     // MULTI SIG FUNCTIONS
929     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
930     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
931         internal
932         returns(bool) 
933     {
934         // our proposal key will be a hash of our function name + our contracts address 
935         // by adding our contracts address to this, we prevent anyone trying to circumvent
936         // the proposal's security via external calls.
937         bytes32 _whatProposal = whatProposal(_whatFunction);
938         
939         // this is just done to make the code more readable.  grabs the signature count
940         uint256 _currentCount = self.proposal_[_whatProposal].count;
941         
942         // store the address of the person sending the function call.  we use msg.sender 
943         // here as a layer of security.  in case someone imports our contract and tries to 
944         // circumvent function arguments.  still though, our contract that imports this
945         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
946         // calls the function will be a signer. 
947         address _whichAdmin = msg.sender;
948         
949         // prepare our msg data.  by storing this we are able to verify that all admins
950         // are approving the same argument input to be executed for the function.  we hash 
951         // it and store in bytes32 so its size is known and comparable
952         bytes32 _msgData = keccak256(msg.data);
953         
954         // check to see if this is a new execution of this proposal or not
955         if (_currentCount == 0)
956         {
957             // if it is, lets record the original signers data
958             self.proposal_[_whatProposal].msgData = _msgData;
959             
960             // record original senders signature
961             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
962             
963             // update log (used to delete records later, and easy way to view signers)
964             // also useful if the calling function wants to give something to a 
965             // specific signer.  
966             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
967             
968             // track number of signatures
969             self.proposal_[_whatProposal].count += 1;  
970             
971             // if we now have enough signatures to execute the function, lets
972             // return a bool of true.  we put this here in case the required signatures
973             // is set to 1.
974             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
975                 return(true);
976             }            
977         // if its not the first execution, lets make sure the msgData matches
978         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
979             // msgData is a match
980             // make sure admin hasnt already signed
981             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
982             {
983                 // record their signature
984                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
985                 
986                 // update log (used to delete records later, and easy way to view signers)
987                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
988                 
989                 // track number of signatures
990                 self.proposal_[_whatProposal].count += 1;  
991             }
992             
993             // if we now have enough signatures to execute the function, lets
994             // return a bool of true.
995             // we put this here for a few reasons.  (1) in normal operation, if 
996             // that last recorded signature got us to our required signatures.  we 
997             // need to return bool of true.  (2) if we have a situation where the 
998             // required number of signatures was adjusted to at or lower than our current 
999             // signature count, by putting this here, an admin who has already signed,
1000             // can call the function again to make it return a true bool.  but only if
1001             // they submit the correct msg data
1002             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1003                 return(true);
1004             }
1005         }
1006     }
1007     
1008     
1009     // deletes proposal signature data after successfully executing a multiSig function
1010     function deleteProposal(Data storage self, bytes32 _whatFunction)
1011         internal
1012     {
1013         //done for readability sake
1014         bytes32 _whatProposal = whatProposal(_whatFunction);
1015         address _whichAdmin;
1016         
1017         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1018         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1019         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1020             _whichAdmin = self.proposal_[_whatProposal].log[i];
1021             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1022             delete self.proposal_[_whatProposal].log[i];
1023         }
1024         //delete the rest of the data in the record
1025         delete self.proposal_[_whatProposal];
1026     }
1027     
1028     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1029     // HELPER FUNCTIONS
1030     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1031 
1032     function whatProposal(bytes32 _whatFunction)
1033         private
1034         view
1035         returns(bytes32)
1036     {
1037         return(keccak256(abi.encodePacked(_whatFunction,this)));
1038     }
1039     
1040     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1041     // VANITY FUNCTIONS
1042     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1043     // returns a hashed version of msg.data sent by original signer for any given function
1044     function checkMsgData (Data storage self, bytes32 _whatFunction)
1045         internal
1046         view
1047         returns (bytes32 msg_data)
1048     {
1049         bytes32 _whatProposal = whatProposal(_whatFunction);
1050         return (self.proposal_[_whatProposal].msgData);
1051     }
1052     
1053     // returns number of signers for any given function
1054     function checkCount (Data storage self, bytes32 _whatFunction)
1055         internal
1056         view
1057         returns (uint256 signature_count)
1058     {
1059         bytes32 _whatProposal = whatProposal(_whatFunction);
1060         return (self.proposal_[_whatProposal].count);
1061     }
1062     
1063     // returns address of an admin who signed for any given function
1064     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1065         internal
1066         view
1067         returns (address signer)
1068     {
1069         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1070         bytes32 _whatProposal = whatProposal(_whatFunction);
1071         return (self.proposal_[_whatProposal].log[_signer - 1]);
1072     }
1073 }