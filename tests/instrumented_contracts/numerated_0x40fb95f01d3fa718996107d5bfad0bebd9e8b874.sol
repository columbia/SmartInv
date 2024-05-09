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
29 interface JIincForwarderInterface {
30     function deposit() external payable returns(bool);
31     function status() external view returns(address, address, bool);
32     function startMigration(address _newCorpBank) external returns(bool);
33     function cancelMigration() external returns(bool);
34     function finishMigration() external returns(bool);
35     function setup(address _firstCorpBank) external;
36 }
37 
38 interface PlayerBookReceiverInterface {
39     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
40     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
41 }
42 
43 interface TeamJustInterface {
44     function requiredSignatures() external view returns(uint256);
45     function requiredDevSignatures() external view returns(uint256);
46     function adminCount() external view returns(uint256);
47     function devCount() external view returns(uint256);
48     function adminName(address _who) external view returns(bytes32);
49     function isAdmin(address _who) external view returns(bool);
50     function isDev(address _who) external view returns(bool);
51 }
52 
53 contract PlayerBook {
54     using NameFilter for string;
55     using SafeMath for uint256;
56     
57     // Hack 闭源合约
58     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x548e2295fc38b69000ff43a730933919b08c2562);
59     TeamJustInterface constant private TeamJust = TeamJustInterface(0x1599470505ec590a2aa85ef8d7dfed7833a60831);
60     address constant private reward = 0x30D4d6079829082e5A4bCaAbf6887362527B8838;
61     
62     MSFun.Data private msData;
63     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
64     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
65     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
66     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
67     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
68     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
69 //==============================================================================
70 //     _| _ _|_ _    _ _ _|_    _   .
71 //    (_|(_| | (_|  _\(/_ | |_||_)  .
72 //=============================|================================================    
73     uint256 public registrationFee_ = 10 finney;            // price to register a name
74     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
75     mapping(address => bytes32) public gameNames_;          // lookup a games name
76     mapping(address => uint256) public gameIDs_;            // lokup a games ID
77     uint256 public gID_;        // total number of games
78     uint256 public pID_;        // total number of players
79     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
80     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
81     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
82     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
83     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
84     struct Player {
85         address addr;
86         bytes32 name;
87         uint256 laff;
88         uint256 names;
89     }
90 //==============================================================================
91 //     _ _  _  __|_ _    __|_ _  _  .
92 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
93 //==============================================================================    
94     constructor()
95         public
96     {
97         // premine the dev names (sorry not sorry)
98             // No keys are purchased with this method, it's simply locking our addresses,
99             // PID's and names for referral codes.
100         plyr_[1].addr = 0x3D3B33b8F50AB9e8F5a9Ff369853F0e638450aDB;
101         plyr_[1].name = "justo";
102         plyr_[1].names = 1;
103         pIDxAddr_[0x3D3B33b8F50AB9e8F5a9Ff369853F0e638450aDB] = 1;
104         pIDxName_["justo"] = 1;
105         plyrNames_[1]["justo"] = true;
106         plyrNameList_[1][1] = "justo";
107         
108         plyr_[2].addr = 0xE54c005c9eF185CfE70209AD825301F9a84534A8;
109         plyr_[2].name = "mantso";
110         plyr_[2].names = 1;
111         pIDxAddr_[0xE54c005c9eF185CfE70209AD825301F9a84534A8] = 2;
112         pIDxName_["mantso"] = 2;
113         plyrNames_[2]["mantso"] = true;
114         plyrNameList_[2][1] = "mantso";
115         
116         plyr_[3].addr = 0x5f4D36184A3264454CACE497B0c346E9A51F5eaB;
117         plyr_[3].name = "sumpunk";
118         plyr_[3].names = 1;
119         pIDxAddr_[0x5f4D36184A3264454CACE497B0c346E9A51F5eaB] = 3;
120         pIDxName_["sumpunk"] = 3;
121         plyrNames_[3]["sumpunk"] = true;
122         plyrNameList_[3][1] = "sumpunk";
123         
124         plyr_[4].addr = 0x28C0F6142D1232C9E663e29cc0a6F8F087269373;
125         plyr_[4].name = "inventor";
126         plyr_[4].names = 1;
127         pIDxAddr_[0x28C0F6142D1232C9E663e29cc0a6F8F087269373] = 4;
128         pIDxName_["inventor"] = 4;
129         plyrNames_[4]["inventor"] = true;
130         plyrNameList_[4][1] = "inventor";
131         
132         pID_ = 4;
133     }
134 //==============================================================================
135 //     _ _  _  _|. |`. _  _ _  .
136 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
137 //==============================================================================    
138     /**
139      * @dev prevents contracts from interacting with fomo3d 
140      */
141     modifier isHuman() {
142         address _addr = msg.sender;
143         uint256 _codeLength;
144         
145         assembly {_codeLength := extcodesize(_addr)}
146         require(_codeLength == 0, "sorry humans only");
147         _;
148     }
149     
150     modifier onlyDevs() 
151     {
152         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
153         _;
154     }
155     
156     modifier isRegisteredGame()
157     {
158         require(gameIDs_[msg.sender] != 0);
159         _;
160     }
161 //==============================================================================
162 //     _    _  _ _|_ _  .
163 //    (/_\/(/_| | | _\  .
164 //==============================================================================    
165     // fired whenever a player registers a name
166     event onNewName
167     (
168         uint256 indexed playerID,
169         address indexed playerAddress,
170         bytes32 indexed playerName,
171         bool isNewPlayer,
172         uint256 affiliateID,
173         address affiliateAddress,
174         bytes32 affiliateName,
175         uint256 amountPaid,
176         uint256 timeStamp
177     );
178 //==============================================================================
179 //     _  _ _|__|_ _  _ _  .
180 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
181 //=====_|=======================================================================
182     function checkIfNameValid(string _nameStr)
183         public
184         view
185         returns(bool)
186     {
187         bytes32 _name = _nameStr.nameFilter();
188         if (pIDxName_[_name] == 0)
189             return (true);
190         else 
191             return (false);
192     }
193 //==============================================================================
194 //     _    |_ |. _   |`    _  __|_. _  _  _  .
195 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
196 //====|=========================================================================    
197     /**
198      * @dev registers a name.  UI will always display the last name you registered.
199      * but you will still own all previously registered names to use as affiliate 
200      * links.
201      * - must pay a registration fee.
202      * - name must be unique
203      * - names will be converted to lowercase
204      * - name cannot start or end with a space 
205      * - cannot have more than 1 space in a row
206      * - cannot be only numbers
207      * - cannot start with 0x 
208      * - name must be at least 1 char
209      * - max length of 32 characters long
210      * - allowed characters: a-z, 0-9, and space
211      * -functionhash- 0x921dec21 (using ID for affiliate)
212      * -functionhash- 0x3ddd4698 (using address for affiliate)
213      * -functionhash- 0x685ffd83 (using name for affiliate)
214      * @param _nameString players desired name
215      * @param _affCode affiliate ID, address, or name of who refered you
216      * @param _all set to true if you want this to push your info to all games 
217      * (this might cost a lot of gas)
218      */
219     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
220         isHuman()
221         public
222         payable 
223     {
224         // make sure name fees paid
225         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
226         
227         // filter name + condition checks
228         bytes32 _name = NameFilter.nameFilter(_nameString);
229         
230         // set up address 
231         address _addr = msg.sender;
232         
233         // set up our tx event data and determine if player is new or not
234         bool _isNewPlayer = determinePID(_addr);
235         
236         // fetch player id
237         uint256 _pID = pIDxAddr_[_addr];
238         
239         // manage affiliate residuals
240         // if no affiliate code was given, no new affiliate code was given, or the 
241         // player tried to use their own pID as an affiliate code, lolz
242         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
243         {
244             // update last affiliate 
245             plyr_[_pID].laff = _affCode;
246         } else if (_affCode == _pID) {
247             _affCode = 0;
248         }
249         
250         // register name 
251         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
252     }
253     
254     function registerNameXaddr(string _nameString, address _affCode, bool _all)
255         isHuman()
256         public
257         payable 
258     {
259         // make sure name fees paid
260         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
261         
262         // filter name + condition checks
263         bytes32 _name = NameFilter.nameFilter(_nameString);
264         
265         // set up address 
266         address _addr = msg.sender;
267         
268         // set up our tx event data and determine if player is new or not
269         bool _isNewPlayer = determinePID(_addr);
270         
271         // fetch player id
272         uint256 _pID = pIDxAddr_[_addr];
273         
274         // manage affiliate residuals
275         // if no affiliate code was given or player tried to use their own, lolz
276         uint256 _affID;
277         if (_affCode != address(0) && _affCode != _addr)
278         {
279             // get affiliate ID from aff Code 
280             _affID = pIDxAddr_[_affCode];
281             
282             // if affID is not the same as previously stored 
283             if (_affID != plyr_[_pID].laff)
284             {
285                 // update last affiliate
286                 plyr_[_pID].laff = _affID;
287             }
288         }
289         
290         // register name 
291         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
292     }
293     
294     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
295         isHuman()
296         public
297         payable 
298     {
299         // make sure name fees paid
300         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
301         
302         // filter name + condition checks
303         bytes32 _name = NameFilter.nameFilter(_nameString);
304         
305         // set up address 
306         address _addr = msg.sender;
307         
308         // set up our tx event data and determine if player is new or not
309         bool _isNewPlayer = determinePID(_addr);
310         
311         // fetch player id
312         uint256 _pID = pIDxAddr_[_addr];
313         
314         // manage affiliate residuals
315         // if no affiliate code was given or player tried to use their own, lolz
316         uint256 _affID;
317         if (_affCode != "" && _affCode != _name)
318         {
319             // get affiliate ID from aff Code 
320             _affID = pIDxName_[_affCode];
321             
322             // if affID is not the same as previously stored 
323             if (_affID != plyr_[_pID].laff)
324             {
325                 // update last affiliate
326                 plyr_[_pID].laff = _affID;
327             }
328         }
329         
330         // register name 
331         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
332     }
333     
334     /**
335      * @dev players, if you registered a profile, before a game was released, or
336      * set the all bool to false when you registered, use this function to push
337      * your profile to a single game.  also, if you've  updated your name, you
338      * can use this to push your name to games of your choosing.
339      * -functionhash- 0x81c5b206
340      * @param _gameID game id 
341      */
342     function addMeToGame(uint256 _gameID)
343         isHuman()
344         public
345     {
346         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
347         address _addr = msg.sender;
348         uint256 _pID = pIDxAddr_[_addr];
349         require(_pID != 0, "hey there buddy, you dont even have an account");
350         uint256 _totalNames = plyr_[_pID].names;
351         
352         // add players profile and most recent name
353         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
354         
355         // add list of all names
356         if (_totalNames > 1)
357             for (uint256 ii = 1; ii <= _totalNames; ii++)
358                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
359     }
360     
361     /**
362      * @dev players, use this to push your player profile to all registered games.
363      * -functionhash- 0x0c6940ea
364      */
365     function addMeToAllGames()
366         isHuman()
367         public
368     {
369         address _addr = msg.sender;
370         uint256 _pID = pIDxAddr_[_addr];
371         require(_pID != 0, "hey there buddy, you dont even have an account");
372         uint256 _laff = plyr_[_pID].laff;
373         uint256 _totalNames = plyr_[_pID].names;
374         bytes32 _name = plyr_[_pID].name;
375         
376         for (uint256 i = 1; i <= gID_; i++)
377         {
378             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
379             if (_totalNames > 1)
380                 for (uint256 ii = 1; ii <= _totalNames; ii++)
381                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
382         }
383                 
384     }
385     
386     /**
387      * @dev players use this to change back to one of your old names.  tip, you'll
388      * still need to push that info to existing games.
389      * -functionhash- 0xb9291296
390      * @param _nameString the name you want to use 
391      */
392     function useMyOldName(string _nameString)
393         isHuman()
394         public 
395     {
396         // filter name, and get pID
397         bytes32 _name = _nameString.nameFilter();
398         uint256 _pID = pIDxAddr_[msg.sender];
399         
400         // make sure they own the name 
401         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
402         
403         // update their current name 
404         plyr_[_pID].name = _name;
405     }
406     
407 //==============================================================================
408 //     _ _  _ _   | _  _ . _  .
409 //    (_(_)| (/_  |(_)(_||(_  . 
410 //=====================_|=======================================================    
411     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
412         private
413     {
414         // if names already has been used, require that current msg sender owns the name
415         if (pIDxName_[_name] != 0)
416             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
417         
418         // add name to player profile, registry, and name book
419         plyr_[_pID].name = _name;
420         pIDxName_[_name] = _pID;
421         if (plyrNames_[_pID][_name] == false)
422         {
423             plyrNames_[_pID][_name] = true;
424             plyr_[_pID].names++;
425             plyrNameList_[_pID][plyr_[_pID].names] = _name;
426         }
427         
428         // registration fee goes directly to community rewards
429         // Jekyll_Island_Inc.deposit.value(address(this).balance)();
430         reward.send(address(this).balance);
431         
432         // push player info to games
433         if (_all == true)
434             for (uint256 i = 1; i <= gID_; i++)
435                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
436         
437         // fire event
438         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
439     }
440 //==============================================================================
441 //    _|_ _  _ | _  .
442 //     | (_)(_)|_\  .
443 //==============================================================================    
444     function determinePID(address _addr)
445         private
446         returns (bool)
447     {
448         if (pIDxAddr_[_addr] == 0)
449         {
450             pID_++;
451             pIDxAddr_[_addr] = pID_;
452             plyr_[pID_].addr = _addr;
453             
454             // set the new player bool to true
455             return (true);
456         } else {
457             return (false);
458         }
459     }
460 //==============================================================================
461 //   _   _|_ _  _ _  _ |   _ _ || _  .
462 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
463 //==============================================================================
464     function getPlayerID(address _addr)
465         isRegisteredGame()
466         external
467         returns (uint256)
468     {
469         determinePID(_addr);
470         return (pIDxAddr_[_addr]);
471     }
472     function getPlayerName(uint256 _pID)
473         external
474         view
475         returns (bytes32)
476     {
477         return (plyr_[_pID].name);
478     }
479     function getPlayerLAff(uint256 _pID)
480         external
481         view
482         returns (uint256)
483     {
484         return (plyr_[_pID].laff);
485     }
486     function getPlayerAddr(uint256 _pID)
487         external
488         view
489         returns (address)
490     {
491         return (plyr_[_pID].addr);
492     }
493     function getNameFee()
494         external
495         view
496         returns (uint256)
497     {
498         return(registrationFee_);
499     }
500     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
501         isRegisteredGame()
502         external
503         payable
504         returns(bool, uint256)
505     {
506         // make sure name fees paid
507         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
508         
509         // set up our tx event data and determine if player is new or not
510         bool _isNewPlayer = determinePID(_addr);
511         
512         // fetch player id
513         uint256 _pID = pIDxAddr_[_addr];
514         
515         // manage affiliate residuals
516         // if no affiliate code was given, no new affiliate code was given, or the 
517         // player tried to use their own pID as an affiliate code, lolz
518         uint256 _affID = _affCode;
519         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
520         {
521             // update last affiliate 
522             plyr_[_pID].laff = _affID;
523         } else if (_affID == _pID) {
524             _affID = 0;
525         }
526         
527         // register name 
528         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
529         
530         return(_isNewPlayer, _affID);
531     }
532     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
533         isRegisteredGame()
534         external
535         payable
536         returns(bool, uint256)
537     {
538         // make sure name fees paid
539         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
540         
541         // set up our tx event data and determine if player is new or not
542         bool _isNewPlayer = determinePID(_addr);
543         
544         // fetch player id
545         uint256 _pID = pIDxAddr_[_addr];
546         
547         // manage affiliate residuals
548         // if no affiliate code was given or player tried to use their own, lolz
549         uint256 _affID;
550         if (_affCode != address(0) && _affCode != _addr)
551         {
552             // get affiliate ID from aff Code 
553             _affID = pIDxAddr_[_affCode];
554             
555             // if affID is not the same as previously stored 
556             if (_affID != plyr_[_pID].laff)
557             {
558                 // update last affiliate
559                 plyr_[_pID].laff = _affID;
560             }
561         }
562         
563         // register name 
564         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
565         
566         return(_isNewPlayer, _affID);
567     }
568     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
569         isRegisteredGame()
570         external
571         payable
572         returns(bool, uint256)
573     {
574         // make sure name fees paid
575         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
576         
577         // set up our tx event data and determine if player is new or not
578         bool _isNewPlayer = determinePID(_addr);
579         
580         // fetch player id
581         uint256 _pID = pIDxAddr_[_addr];
582         
583         // manage affiliate residuals
584         // if no affiliate code was given or player tried to use their own, lolz
585         uint256 _affID;
586         if (_affCode != "" && _affCode != _name)
587         {
588             // get affiliate ID from aff Code 
589             _affID = pIDxName_[_affCode];
590             
591             // if affID is not the same as previously stored 
592             if (_affID != plyr_[_pID].laff)
593             {
594                 // update last affiliate
595                 plyr_[_pID].laff = _affID;
596             }
597         }
598         
599         // register name 
600         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
601         
602         return(_isNewPlayer, _affID);
603     }
604     
605 //==============================================================================
606 //   _ _ _|_    _   .
607 //  _\(/_ | |_||_)  .
608 //=============|================================================================
609     function addGame(address _gameAddress, string _gameNameStr)
610         onlyDevs()
611         public
612     {
613         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
614         
615         if (multiSigDev("addGame") == true)
616         {deleteProposal("addGame");
617             gID_++;
618             bytes32 _name = _gameNameStr.nameFilter();
619             gameIDs_[_gameAddress] = gID_;
620             gameNames_[_gameAddress] = _name;
621             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
622         
623             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
624             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
625             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
626             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
627         }
628     }
629     
630     function setRegistrationFee(uint256 _fee)
631         onlyDevs()
632         public
633     {
634         if (multiSigDev("setRegistrationFee") == true)
635         {deleteProposal("setRegistrationFee");
636             registrationFee_ = _fee;
637         }
638     }
639         
640 } 
641 
642 /**
643 * @title -Name Filter- v0.1.9
644 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
645 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
646 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
647 *                                  _____                      _____
648 *                                 (, /     /)       /) /)    (, /      /)          /)
649 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
650 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
651 *          ┴ ┴                /   /          .-/ _____   (__ /                               
652 *                            (__ /          (_/ (, /                                      /)™ 
653 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
654 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
655 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
656 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
657 *              _       __    _      ____      ____  _   _    _____  ____  ___  
658 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
659 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
660 *
661 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
662 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
663 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
664 */
665 library NameFilter {
666     
667     /**
668      * @dev filters name strings
669      * -converts uppercase to lower case.  
670      * -makes sure it does not start/end with a space
671      * -makes sure it does not contain multiple spaces in a row
672      * -cannot be only numbers
673      * -cannot start with 0x 
674      * -restricts characters to A-Z, a-z, 0-9, and space.
675      * @return reprocessed string in bytes32 format
676      */
677     function nameFilter(string _input)
678         internal
679         pure
680         returns(bytes32)
681     {
682         bytes memory _temp = bytes(_input);
683         uint256 _length = _temp.length;
684         
685         //sorry limited to 32 characters
686         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
687         // make sure it doesnt start with or end with space
688         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
689         // make sure first two characters are not 0x
690         if (_temp[0] == 0x30)
691         {
692             require(_temp[1] != 0x78, "string cannot start with 0x");
693             require(_temp[1] != 0x58, "string cannot start with 0X");
694         }
695         
696         // create a bool to track if we have a non number character
697         bool _hasNonNumber;
698         
699         // convert & check
700         for (uint256 i = 0; i < _length; i++)
701         {
702             // if its uppercase A-Z
703             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
704             {
705                 // convert to lower case a-z
706                 _temp[i] = byte(uint(_temp[i]) + 32);
707                 
708                 // we have a non number
709                 if (_hasNonNumber == false)
710                     _hasNonNumber = true;
711             } else {
712                 require
713                 (
714                     // require character is a space
715                     _temp[i] == 0x20 || 
716                     // OR lowercase a-z
717                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
718                     // or 0-9
719                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
720                     "string contains invalid characters"
721                 );
722                 // make sure theres not 2x spaces in a row
723                 if (_temp[i] == 0x20)
724                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
725                 
726                 // see if we have a character other than a number
727                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
728                     _hasNonNumber = true;    
729             }
730         }
731         
732         require(_hasNonNumber == true, "string cannot be only numbers");
733         
734         bytes32 _ret;
735         assembly {
736             _ret := mload(add(_temp, 32))
737         }
738         return (_ret);
739     }
740 }
741 
742 /**
743  * @title SafeMath v0.1.9
744  * @dev Math operations with safety checks that throw on error
745  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
746  * - added sqrt
747  * - added sq
748  * - added pwr 
749  * - changed asserts to requires with error log outputs
750  * - removed div, its useless
751  */
752 library SafeMath {
753     
754     /**
755     * @dev Multiplies two numbers, throws on overflow.
756     */
757     function mul(uint256 a, uint256 b) 
758         internal 
759         pure 
760         returns (uint256 c) 
761     {
762         if (a == 0) {
763             return 0;
764         }
765         c = a * b;
766         require(c / a == b, "SafeMath mul failed");
767         return c;
768     }
769 
770     /**
771     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
772     */
773     function sub(uint256 a, uint256 b)
774         internal
775         pure
776         returns (uint256) 
777     {
778         require(b <= a, "SafeMath sub failed");
779         return a - b;
780     }
781 
782     /**
783     * @dev Adds two numbers, throws on overflow.
784     */
785     function add(uint256 a, uint256 b)
786         internal
787         pure
788         returns (uint256 c) 
789     {
790         c = a + b;
791         require(c >= a, "SafeMath add failed");
792         return c;
793     }
794     
795     /**
796      * @dev gives square root of given x.
797      */
798     function sqrt(uint256 x)
799         internal
800         pure
801         returns (uint256 y) 
802     {
803         uint256 z = ((add(x,1)) / 2);
804         y = x;
805         while (z < y) 
806         {
807             y = z;
808             z = ((add((x / z),z)) / 2);
809         }
810     }
811     
812     /**
813      * @dev gives square. multiplies x by x
814      */
815     function sq(uint256 x)
816         internal
817         pure
818         returns (uint256)
819     {
820         return (mul(x,x));
821     }
822     
823     /**
824      * @dev x to the power of y 
825      */
826     function pwr(uint256 x, uint256 y)
827         internal 
828         pure 
829         returns (uint256)
830     {
831         if (x==0)
832             return (0);
833         else if (y==0)
834             return (1);
835         else 
836         {
837             uint256 z = x;
838             for (uint256 i=1; i < y; i++)
839                 z = mul(z,x);
840             return (z);
841         }
842     }
843 }
844 
845 /** @title -MSFun- v0.2.4
846  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
847  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
848  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
849  *                                  _____                      _____
850  *                                 (, /     /)       /) /)    (, /      /)          /)
851  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
852  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
853  *          ┴ ┴                /   /          .-/ _____   (__ /                               
854  *                            (__ /          (_/ (, /                                      /)™ 
855  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
856  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
857  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
858  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
859  *  _           _             _  _  _  _             _  _  _  _  _                                      
860  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
861  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
862  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
863  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
864  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
865  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
866  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
867  *
868  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
869  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
870  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
871  *  
872  *         ┌──────────────────────────────────────────────────────────────────────┐
873  *         │ MSFun, is an importable library that gives your contract the ability │
874  *         │ add multiSig requirement to functions.                               │
875  *         └──────────────────────────────────────────────────────────────────────┘
876  *                                ┌────────────────────┐
877  *                                │ Setup Instructions │
878  *                                └────────────────────┘
879  * (Step 1) import the library into your contract
880  * 
881  *    import "./MSFun.sol";
882  *
883  * (Step 2) set up the signature data for msFun
884  * 
885  *     MSFun.Data private msData;
886  *                                ┌────────────────────┐
887  *                                │ Usage Instructions │
888  *                                └────────────────────┘
889  * at the beginning of a function
890  * 
891  *     function functionName() 
892  *     {
893  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
894  *         {
895  *             MSFun.deleteProposal(msData, "functionName");
896  * 
897  *             // put function body here 
898  *         }
899  *     }
900  *                           ┌────────────────────────────────┐
901  *                           │ Optional Wrappers For TeamJust │
902  *                           └────────────────────────────────┘
903  * multiSig wrapper function (cuts down on inputs, improves readability)
904  * this wrapper is HIGHLY recommended
905  * 
906  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
907  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
908  *
909  * wrapper for delete proposal (makes code cleaner)
910  *     
911  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
912  *                             ┌────────────────────────────┐
913  *                             │ Utility & Vanity Functions │
914  *                             └────────────────────────────┘
915  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
916  * function, with argument inputs that the other admins do not agree upon, the function
917  * can never be executed until the undesirable arguments are approved.
918  * 
919  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
920  * 
921  * for viewing who has signed a proposal & proposal data
922  *     
923  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
924  *
925  * lets you check address of up to 3 signers (address)
926  * 
927  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
928  *
929  * same as above but will return names in string format.
930  *
931  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
932  *                             ┌──────────────────────────┐
933  *                             │ Functions In Depth Guide │
934  *                             └──────────────────────────┘
935  * In the following examples, the Data is the proposal set for this library.  And
936  * the bytes32 is the name of the function.
937  *
938  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
939  *      proposal for the function being called.  The uint256 is the required 
940  *      number of signatures needed before the multiSig will return true.  
941  *      Upon first call, multiSig will create a proposal and store the arguments 
942  *      passed with the function call as msgData.  Any admins trying to sign the 
943  *      function call will need to send the same argument values. Once required
944  *      number of signatures is reached this will return a bool of true.
945  * 
946  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
947  *      you will want to delete the proposal data.  This does that.
948  *
949  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
950  * 
951  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
952  *      the proposal 
953  * 
954  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
955  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
956  */
957 
958 library MSFun {
959     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
960     // DATA SETS
961     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
962     // contact data setup
963     struct Data 
964     {
965         mapping (bytes32 => ProposalData) proposal_;
966     }
967     struct ProposalData 
968     {
969         // a hash of msg.data 
970         bytes32 msgData;
971         // number of signers
972         uint256 count;
973         // tracking of wither admins have signed
974         mapping (address => bool) admin;
975         // list of admins who have signed
976         mapping (uint256 => address) log;
977     }
978     
979     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
980     // MULTI SIG FUNCTIONS
981     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
982     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
983         internal
984         returns(bool) 
985     {
986         // our proposal key will be a hash of our function name + our contracts address 
987         // by adding our contracts address to this, we prevent anyone trying to circumvent
988         // the proposal's security via external calls.
989         bytes32 _whatProposal = whatProposal(_whatFunction);
990         
991         // this is just done to make the code more readable.  grabs the signature count
992         uint256 _currentCount = self.proposal_[_whatProposal].count;
993         
994         // store the address of the person sending the function call.  we use msg.sender 
995         // here as a layer of security.  in case someone imports our contract and tries to 
996         // circumvent function arguments.  still though, our contract that imports this
997         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
998         // calls the function will be a signer. 
999         address _whichAdmin = msg.sender;
1000         
1001         // prepare our msg data.  by storing this we are able to verify that all admins
1002         // are approving the same argument input to be executed for the function.  we hash 
1003         // it and store in bytes32 so its size is known and comparable
1004         bytes32 _msgData = keccak256(msg.data);
1005         
1006         // check to see if this is a new execution of this proposal or not
1007         if (_currentCount == 0)
1008         {
1009             // if it is, lets record the original signers data
1010             self.proposal_[_whatProposal].msgData = _msgData;
1011             
1012             // record original senders signature
1013             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1014             
1015             // update log (used to delete records later, and easy way to view signers)
1016             // also useful if the calling function wants to give something to a 
1017             // specific signer.  
1018             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1019             
1020             // track number of signatures
1021             self.proposal_[_whatProposal].count += 1;  
1022             
1023             // if we now have enough signatures to execute the function, lets
1024             // return a bool of true.  we put this here in case the required signatures
1025             // is set to 1.
1026             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1027                 return(true);
1028             }            
1029         // if its not the first execution, lets make sure the msgData matches
1030         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
1031             // msgData is a match
1032             // make sure admin hasnt already signed
1033             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
1034             {
1035                 // record their signature
1036                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1037                 
1038                 // update log (used to delete records later, and easy way to view signers)
1039                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1040                 
1041                 // track number of signatures
1042                 self.proposal_[_whatProposal].count += 1;  
1043             }
1044             
1045             // if we now have enough signatures to execute the function, lets
1046             // return a bool of true.
1047             // we put this here for a few reasons.  (1) in normal operation, if 
1048             // that last recorded signature got us to our required signatures.  we 
1049             // need to return bool of true.  (2) if we have a situation where the 
1050             // required number of signatures was adjusted to at or lower than our current 
1051             // signature count, by putting this here, an admin who has already signed,
1052             // can call the function again to make it return a true bool.  but only if
1053             // they submit the correct msg data
1054             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1055                 return(true);
1056             }
1057         }
1058     }
1059     
1060     
1061     // deletes proposal signature data after successfully executing a multiSig function
1062     function deleteProposal(Data storage self, bytes32 _whatFunction)
1063         internal
1064     {
1065         //done for readability sake
1066         bytes32 _whatProposal = whatProposal(_whatFunction);
1067         address _whichAdmin;
1068         
1069         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1070         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1071         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1072             _whichAdmin = self.proposal_[_whatProposal].log[i];
1073             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1074             delete self.proposal_[_whatProposal].log[i];
1075         }
1076         //delete the rest of the data in the record
1077         delete self.proposal_[_whatProposal];
1078     }
1079     
1080     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1081     // HELPER FUNCTIONS
1082     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1083 
1084     function whatProposal(bytes32 _whatFunction)
1085         private
1086         view
1087         returns(bytes32)
1088     {
1089         return(keccak256(abi.encodePacked(_whatFunction,this)));
1090     }
1091     
1092     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1093     // VANITY FUNCTIONS
1094     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1095     // returns a hashed version of msg.data sent by original signer for any given function
1096     function checkMsgData (Data storage self, bytes32 _whatFunction)
1097         internal
1098         view
1099         returns (bytes32 msg_data)
1100     {
1101         bytes32 _whatProposal = whatProposal(_whatFunction);
1102         return (self.proposal_[_whatProposal].msgData);
1103     }
1104     
1105     // returns number of signers for any given function
1106     function checkCount (Data storage self, bytes32 _whatFunction)
1107         internal
1108         view
1109         returns (uint256 signature_count)
1110     {
1111         bytes32 _whatProposal = whatProposal(_whatFunction);
1112         return (self.proposal_[_whatProposal].count);
1113     }
1114     
1115     // returns address of an admin who signed for any given function
1116     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1117         internal
1118         view
1119         returns (address signer)
1120     {
1121         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1122         bytes32 _whatProposal = whatProposal(_whatFunction);
1123         return (self.proposal_[_whatProposal].log[_signer - 1]);
1124     }
1125 }