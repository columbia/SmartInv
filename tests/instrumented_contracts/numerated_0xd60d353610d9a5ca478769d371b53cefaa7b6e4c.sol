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
57     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
58     TeamJustInterface constant private TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
59     
60     MSFun.Data private msData;
61     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
62     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
63     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
64     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
65     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
66     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
67 //==============================================================================
68 //     _| _ _|_ _    _ _ _|_    _   .
69 //    (_|(_| | (_|  _\(/_ | |_||_)  .
70 //=============================|================================================    
71     uint256 public registrationFee_ = 10 finney;            // price to register a name
72     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
73     mapping(address => bytes32) public gameNames_;          // lookup a games name
74     mapping(address => uint256) public gameIDs_;            // lokup a games ID
75     uint256 public gID_;        // total number of games
76     uint256 public pID_;        // total number of players
77     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
78     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
79     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
80     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
81     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
82     struct Player {
83         address addr;
84         bytes32 name;
85         uint256 laff;
86         uint256 names;
87     }
88 //==============================================================================
89 //     _ _  _  __|_ _    __|_ _  _  .
90 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
91 //==============================================================================    
92     constructor()
93         public
94     {
95         // premine the dev names (sorry not sorry)
96             // No keys are purchased with this method, it's simply locking our addresses,
97             // PID's and names for referral codes.
98         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
99         plyr_[1].name = "justo";
100         plyr_[1].names = 1;
101         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
102         pIDxName_["justo"] = 1;
103         plyrNames_[1]["justo"] = true;
104         plyrNameList_[1][1] = "justo";
105         
106         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
107         plyr_[2].name = "mantso";
108         plyr_[2].names = 1;
109         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
110         pIDxName_["mantso"] = 2;
111         plyrNames_[2]["mantso"] = true;
112         plyrNameList_[2][1] = "mantso";
113         
114         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
115         plyr_[3].name = "sumpunk";
116         plyr_[3].names = 1;
117         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
118         pIDxName_["sumpunk"] = 3;
119         plyrNames_[3]["sumpunk"] = true;
120         plyrNameList_[3][1] = "sumpunk";
121         
122         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
123         plyr_[4].name = "inventor";
124         plyr_[4].names = 1;
125         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
126         pIDxName_["inventor"] = 4;
127         plyrNames_[4]["inventor"] = true;
128         plyrNameList_[4][1] = "inventor";
129         
130         pID_ = 4;
131     }
132 //==============================================================================
133 //     _ _  _  _|. |`. _  _ _  .
134 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
135 //==============================================================================    
136     /**
137      * @dev prevents contracts from interacting with fomo3d 
138      */
139     modifier isHuman() {
140         address _addr = msg.sender;
141         uint256 _codeLength;
142         
143         assembly {_codeLength := extcodesize(_addr)}
144         require(_codeLength == 0, "sorry humans only");
145         _;
146     }
147     
148     modifier onlyDevs() 
149     {
150         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
151         _;
152     }
153     
154     modifier isRegisteredGame()
155     {
156         require(gameIDs_[msg.sender] != 0);
157         _;
158     }
159 //==============================================================================
160 //     _    _  _ _|_ _  .
161 //    (/_\/(/_| | | _\  .
162 //==============================================================================    
163     // fired whenever a player registers a name
164     event onNewName
165     (
166         uint256 indexed playerID,
167         address indexed playerAddress,
168         bytes32 indexed playerName,
169         bool isNewPlayer,
170         uint256 affiliateID,
171         address affiliateAddress,
172         bytes32 affiliateName,
173         uint256 amountPaid,
174         uint256 timeStamp
175     );
176 //==============================================================================
177 //     _  _ _|__|_ _  _ _  .
178 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
179 //=====_|=======================================================================
180     function checkIfNameValid(string _nameStr)
181         public
182         view
183         returns(bool)
184     {
185         bytes32 _name = _nameStr.nameFilter();
186         if (pIDxName_[_name] == 0)
187             return (true);
188         else 
189             return (false);
190     }
191 //==============================================================================
192 //     _    |_ |. _   |`    _  __|_. _  _  _  .
193 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
194 //====|=========================================================================    
195     /**
196      * @dev registers a name.  UI will always display the last name you registered.
197      * but you will still own all previously registered names to use as affiliate 
198      * links.
199      * - must pay a registration fee.
200      * - name must be unique
201      * - names will be converted to lowercase
202      * - name cannot start or end with a space 
203      * - cannot have more than 1 space in a row
204      * - cannot be only numbers
205      * - cannot start with 0x 
206      * - name must be at least 1 char
207      * - max length of 32 characters long
208      * - allowed characters: a-z, 0-9, and space
209      * -functionhash- 0x921dec21 (using ID for affiliate)
210      * -functionhash- 0x3ddd4698 (using address for affiliate)
211      * -functionhash- 0x685ffd83 (using name for affiliate)
212      * @param _nameString players desired name
213      * @param _affCode affiliate ID, address, or name of who refered you
214      * @param _all set to true if you want this to push your info to all games 
215      * (this might cost a lot of gas)
216      */
217     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
218         isHuman()
219         public
220         payable 
221     {
222         // make sure name fees paid
223         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
224         
225         // filter name + condition checks
226         bytes32 _name = NameFilter.nameFilter(_nameString);
227         
228         // set up address 
229         address _addr = msg.sender;
230         
231         // set up our tx event data and determine if player is new or not
232         bool _isNewPlayer = determinePID(_addr);
233         
234         // fetch player id
235         uint256 _pID = pIDxAddr_[_addr];
236         
237         // manage affiliate residuals
238         // if no affiliate code was given, no new affiliate code was given, or the 
239         // player tried to use their own pID as an affiliate code, lolz
240         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
241         {
242             // update last affiliate 
243             plyr_[_pID].laff = _affCode;
244         } else if (_affCode == _pID) {
245             _affCode = 0;
246         }
247         
248         // register name 
249         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
250     }
251     
252     function registerNameXaddr(string _nameString, address _affCode, bool _all)
253         isHuman()
254         public
255         payable 
256     {
257         // make sure name fees paid
258         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
259         
260         // filter name + condition checks
261         bytes32 _name = NameFilter.nameFilter(_nameString);
262         
263         // set up address 
264         address _addr = msg.sender;
265         
266         // set up our tx event data and determine if player is new or not
267         bool _isNewPlayer = determinePID(_addr);
268         
269         // fetch player id
270         uint256 _pID = pIDxAddr_[_addr];
271         
272         // manage affiliate residuals
273         // if no affiliate code was given or player tried to use their own, lolz
274         uint256 _affID;
275         if (_affCode != address(0) && _affCode != _addr)
276         {
277             // get affiliate ID from aff Code 
278             _affID = pIDxAddr_[_affCode];
279             
280             // if affID is not the same as previously stored 
281             if (_affID != plyr_[_pID].laff)
282             {
283                 // update last affiliate
284                 plyr_[_pID].laff = _affID;
285             }
286         }
287         
288         // register name 
289         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
290     }
291     
292     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
293         isHuman()
294         public
295         payable 
296     {
297         // make sure name fees paid
298         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
299         
300         // filter name + condition checks
301         bytes32 _name = NameFilter.nameFilter(_nameString);
302         
303         // set up address 
304         address _addr = msg.sender;
305         
306         // set up our tx event data and determine if player is new or not
307         bool _isNewPlayer = determinePID(_addr);
308         
309         // fetch player id
310         uint256 _pID = pIDxAddr_[_addr];
311         
312         // manage affiliate residuals
313         // if no affiliate code was given or player tried to use their own, lolz
314         uint256 _affID;
315         if (_affCode != "" && _affCode != _name)
316         {
317             // get affiliate ID from aff Code 
318             _affID = pIDxName_[_affCode];
319             
320             // if affID is not the same as previously stored 
321             if (_affID != plyr_[_pID].laff)
322             {
323                 // update last affiliate
324                 plyr_[_pID].laff = _affID;
325             }
326         }
327         
328         // register name 
329         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
330     }
331     
332     /**
333      * @dev players, if you registered a profile, before a game was released, or
334      * set the all bool to false when you registered, use this function to push
335      * your profile to a single game.  also, if you've  updated your name, you
336      * can use this to push your name to games of your choosing.
337      * -functionhash- 0x81c5b206
338      * @param _gameID game id 
339      */
340     function addMeToGame(uint256 _gameID)
341         isHuman()
342         public
343     {
344         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
345         address _addr = msg.sender;
346         uint256 _pID = pIDxAddr_[_addr];
347         require(_pID != 0, "hey there buddy, you dont even have an account");
348         uint256 _totalNames = plyr_[_pID].names;
349         
350         // add players profile and most recent name
351         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
352         
353         // add list of all names
354         if (_totalNames > 1)
355             for (uint256 ii = 1; ii <= _totalNames; ii++)
356                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
357     }
358     
359     /**
360      * @dev players, use this to push your player profile to all registered games.
361      * -functionhash- 0x0c6940ea
362      */
363     function addMeToAllGames()
364         isHuman()
365         public
366     {
367         address _addr = msg.sender;
368         uint256 _pID = pIDxAddr_[_addr];
369         require(_pID != 0, "hey there buddy, you dont even have an account");
370         uint256 _laff = plyr_[_pID].laff;
371         uint256 _totalNames = plyr_[_pID].names;
372         bytes32 _name = plyr_[_pID].name;
373         
374         for (uint256 i = 1; i <= gID_; i++)
375         {
376             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
377             if (_totalNames > 1)
378                 for (uint256 ii = 1; ii <= _totalNames; ii++)
379                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
380         }
381                 
382     }
383     
384     /**
385      * @dev players use this to change back to one of your old names.  tip, you'll
386      * still need to push that info to existing games.
387      * -functionhash- 0xb9291296
388      * @param _nameString the name you want to use 
389      */
390     function useMyOldName(string _nameString)
391         isHuman()
392         public 
393     {
394         // filter name, and get pID
395         bytes32 _name = _nameString.nameFilter();
396         uint256 _pID = pIDxAddr_[msg.sender];
397         
398         // make sure they own the name 
399         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
400         
401         // update their current name 
402         plyr_[_pID].name = _name;
403     }
404     
405 //==============================================================================
406 //     _ _  _ _   | _  _ . _  .
407 //    (_(_)| (/_  |(_)(_||(_  . 
408 //=====================_|=======================================================    
409     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
410         private
411     {
412         // if names already has been used, require that current msg sender owns the name
413         if (pIDxName_[_name] != 0)
414             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
415         
416         // add name to player profile, registry, and name book
417         plyr_[_pID].name = _name;
418         pIDxName_[_name] = _pID;
419         if (plyrNames_[_pID][_name] == false)
420         {
421             plyrNames_[_pID][_name] = true;
422             plyr_[_pID].names++;
423             plyrNameList_[_pID][plyr_[_pID].names] = _name;
424         }
425         
426         // registration fee goes directly to community rewards
427         Jekyll_Island_Inc.deposit.value(address(this).balance)();
428         
429         // push player info to games
430         if (_all == true)
431             for (uint256 i = 1; i <= gID_; i++)
432                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
433         
434         // fire event
435         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
436     }
437 //==============================================================================
438 //    _|_ _  _ | _  .
439 //     | (_)(_)|_\  .
440 //==============================================================================    
441     function determinePID(address _addr)
442         private
443         returns (bool)
444     {
445         if (pIDxAddr_[_addr] == 0)
446         {
447             pID_++;
448             pIDxAddr_[_addr] = pID_;
449             plyr_[pID_].addr = _addr;
450             
451             // set the new player bool to true
452             return (true);
453         } else {
454             return (false);
455         }
456     }
457 //==============================================================================
458 //   _   _|_ _  _ _  _ |   _ _ || _  .
459 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
460 //==============================================================================
461     function getPlayerID(address _addr)
462         isRegisteredGame()
463         external
464         returns (uint256)
465     {
466         determinePID(_addr);
467         return (pIDxAddr_[_addr]);
468     }
469     function getPlayerName(uint256 _pID)
470         external
471         view
472         returns (bytes32)
473     {
474         return (plyr_[_pID].name);
475     }
476     function getPlayerLAff(uint256 _pID)
477         external
478         view
479         returns (uint256)
480     {
481         return (plyr_[_pID].laff);
482     }
483     function getPlayerAddr(uint256 _pID)
484         external
485         view
486         returns (address)
487     {
488         return (plyr_[_pID].addr);
489     }
490     function getNameFee()
491         external
492         view
493         returns (uint256)
494     {
495         return(registrationFee_);
496     }
497     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
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
513         // if no affiliate code was given, no new affiliate code was given, or the 
514         // player tried to use their own pID as an affiliate code, lolz
515         uint256 _affID = _affCode;
516         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
517         {
518             // update last affiliate 
519             plyr_[_pID].laff = _affID;
520         } else if (_affID == _pID) {
521             _affID = 0;
522         }
523         
524         // register name 
525         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
526         
527         return(_isNewPlayer, _affID);
528     }
529     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
530         isRegisteredGame()
531         external
532         payable
533         returns(bool, uint256)
534     {
535         // make sure name fees paid
536         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
537         
538         // set up our tx event data and determine if player is new or not
539         bool _isNewPlayer = determinePID(_addr);
540         
541         // fetch player id
542         uint256 _pID = pIDxAddr_[_addr];
543         
544         // manage affiliate residuals
545         // if no affiliate code was given or player tried to use their own, lolz
546         uint256 _affID;
547         if (_affCode != address(0) && _affCode != _addr)
548         {
549             // get affiliate ID from aff Code 
550             _affID = pIDxAddr_[_affCode];
551             
552             // if affID is not the same as previously stored 
553             if (_affID != plyr_[_pID].laff)
554             {
555                 // update last affiliate
556                 plyr_[_pID].laff = _affID;
557             }
558         }
559         
560         // register name 
561         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
562         
563         return(_isNewPlayer, _affID);
564     }
565     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
566         isRegisteredGame()
567         external
568         payable
569         returns(bool, uint256)
570     {
571         // make sure name fees paid
572         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
573         
574         // set up our tx event data and determine if player is new or not
575         bool _isNewPlayer = determinePID(_addr);
576         
577         // fetch player id
578         uint256 _pID = pIDxAddr_[_addr];
579         
580         // manage affiliate residuals
581         // if no affiliate code was given or player tried to use their own, lolz
582         uint256 _affID;
583         if (_affCode != "" && _affCode != _name)
584         {
585             // get affiliate ID from aff Code 
586             _affID = pIDxName_[_affCode];
587             
588             // if affID is not the same as previously stored 
589             if (_affID != plyr_[_pID].laff)
590             {
591                 // update last affiliate
592                 plyr_[_pID].laff = _affID;
593             }
594         }
595         
596         // register name 
597         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
598         
599         return(_isNewPlayer, _affID);
600     }
601     
602 //==============================================================================
603 //   _ _ _|_    _   .
604 //  _\(/_ | |_||_)  .
605 //=============|================================================================
606     function addGame(address _gameAddress, string _gameNameStr)
607         onlyDevs()
608         public
609     {
610         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
611         
612         if (multiSigDev("addGame") == true)
613         {deleteProposal("addGame");
614             gID_++;
615             bytes32 _name = _gameNameStr.nameFilter();
616             gameIDs_[_gameAddress] = gID_;
617             gameNames_[_gameAddress] = _name;
618             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
619         
620             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
621             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
622             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
623             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
624         }
625     }
626     
627     function setRegistrationFee(uint256 _fee)
628         onlyDevs()
629         public
630     {
631         if (multiSigDev("setRegistrationFee") == true)
632         {deleteProposal("setRegistrationFee");
633             registrationFee_ = _fee;
634         }
635     }
636         
637 } 
638 
639 /**
640 * @title -Name Filter- v0.1.9
641 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
642 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
643 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
644 *                                  _____                      _____
645 *                                 (, /     /)       /) /)    (, /      /)          /)
646 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
647 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
648 *          ┴ ┴                /   /          .-/ _____   (__ /                               
649 *                            (__ /          (_/ (, /                                      /)™ 
650 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
651 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
652 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
653 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
654 *              _       __    _      ____      ____  _   _    _____  ____  ___  
655 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
656 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
657 *
658 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
659 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
660 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
661 */
662 library NameFilter {
663     
664     /**
665      * @dev filters name strings
666      * -converts uppercase to lower case.  
667      * -makes sure it does not start/end with a space
668      * -makes sure it does not contain multiple spaces in a row
669      * -cannot be only numbers
670      * -cannot start with 0x 
671      * -restricts characters to A-Z, a-z, 0-9, and space.
672      * @return reprocessed string in bytes32 format
673      */
674     function nameFilter(string _input)
675         internal
676         pure
677         returns(bytes32)
678     {
679         bytes memory _temp = bytes(_input);
680         uint256 _length = _temp.length;
681         
682         //sorry limited to 32 characters
683         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
684         // make sure it doesnt start with or end with space
685         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
686         // make sure first two characters are not 0x
687         if (_temp[0] == 0x30)
688         {
689             require(_temp[1] != 0x78, "string cannot start with 0x");
690             require(_temp[1] != 0x58, "string cannot start with 0X");
691         }
692         
693         // create a bool to track if we have a non number character
694         bool _hasNonNumber;
695         
696         // convert & check
697         for (uint256 i = 0; i < _length; i++)
698         {
699             // if its uppercase A-Z
700             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
701             {
702                 // convert to lower case a-z
703                 _temp[i] = byte(uint(_temp[i]) + 32);
704                 
705                 // we have a non number
706                 if (_hasNonNumber == false)
707                     _hasNonNumber = true;
708             } else {
709                 require
710                 (
711                     // require character is a space
712                     _temp[i] == 0x20 || 
713                     // OR lowercase a-z
714                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
715                     // or 0-9
716                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
717                     "string contains invalid characters"
718                 );
719                 // make sure theres not 2x spaces in a row
720                 if (_temp[i] == 0x20)
721                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
722                 
723                 // see if we have a character other than a number
724                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
725                     _hasNonNumber = true;    
726             }
727         }
728         
729         require(_hasNonNumber == true, "string cannot be only numbers");
730         
731         bytes32 _ret;
732         assembly {
733             _ret := mload(add(_temp, 32))
734         }
735         return (_ret);
736     }
737 }
738 
739 /**
740  * @title SafeMath v0.1.9
741  * @dev Math operations with safety checks that throw on error
742  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
743  * - added sqrt
744  * - added sq
745  * - added pwr 
746  * - changed asserts to requires with error log outputs
747  * - removed div, its useless
748  */
749 library SafeMath {
750     
751     /**
752     * @dev Multiplies two numbers, throws on overflow.
753     */
754     function mul(uint256 a, uint256 b) 
755         internal 
756         pure 
757         returns (uint256 c) 
758     {
759         if (a == 0) {
760             return 0;
761         }
762         c = a * b;
763         require(c / a == b, "SafeMath mul failed");
764         return c;
765     }
766 
767     /**
768     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
769     */
770     function sub(uint256 a, uint256 b)
771         internal
772         pure
773         returns (uint256) 
774     {
775         require(b <= a, "SafeMath sub failed");
776         return a - b;
777     }
778 
779     /**
780     * @dev Adds two numbers, throws on overflow.
781     */
782     function add(uint256 a, uint256 b)
783         internal
784         pure
785         returns (uint256 c) 
786     {
787         c = a + b;
788         require(c >= a, "SafeMath add failed");
789         return c;
790     }
791     
792     /**
793      * @dev gives square root of given x.
794      */
795     function sqrt(uint256 x)
796         internal
797         pure
798         returns (uint256 y) 
799     {
800         uint256 z = ((add(x,1)) / 2);
801         y = x;
802         while (z < y) 
803         {
804             y = z;
805             z = ((add((x / z),z)) / 2);
806         }
807     }
808     
809     /**
810      * @dev gives square. multiplies x by x
811      */
812     function sq(uint256 x)
813         internal
814         pure
815         returns (uint256)
816     {
817         return (mul(x,x));
818     }
819     
820     /**
821      * @dev x to the power of y 
822      */
823     function pwr(uint256 x, uint256 y)
824         internal 
825         pure 
826         returns (uint256)
827     {
828         if (x==0)
829             return (0);
830         else if (y==0)
831             return (1);
832         else 
833         {
834             uint256 z = x;
835             for (uint256 i=1; i < y; i++)
836                 z = mul(z,x);
837             return (z);
838         }
839     }
840 }
841 
842 /** @title -MSFun- v0.2.4
843  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
844  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
845  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
846  *                                  _____                      _____
847  *                                 (, /     /)       /) /)    (, /      /)          /)
848  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
849  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
850  *          ┴ ┴                /   /          .-/ _____   (__ /                               
851  *                            (__ /          (_/ (, /                                      /)™ 
852  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
853  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
854  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
855  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
856  *  _           _             _  _  _  _             _  _  _  _  _                                      
857  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
858  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
859  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
860  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
861  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
862  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
863  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
864  *
865  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
866  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
867  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
868  *  
869  *         ┌──────────────────────────────────────────────────────────────────────┐
870  *         │ MSFun, is an importable library that gives your contract the ability │
871  *         │ add multiSig requirement to functions.                               │
872  *         └──────────────────────────────────────────────────────────────────────┘
873  *                                ┌────────────────────┐
874  *                                │ Setup Instructions │
875  *                                └────────────────────┘
876  * (Step 1) import the library into your contract
877  * 
878  *    import "./MSFun.sol";
879  *
880  * (Step 2) set up the signature data for msFun
881  * 
882  *     MSFun.Data private msData;
883  *                                ┌────────────────────┐
884  *                                │ Usage Instructions │
885  *                                └────────────────────┘
886  * at the beginning of a function
887  * 
888  *     function functionName() 
889  *     {
890  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
891  *         {
892  *             MSFun.deleteProposal(msData, "functionName");
893  * 
894  *             // put function body here 
895  *         }
896  *     }
897  *                           ┌────────────────────────────────┐
898  *                           │ Optional Wrappers For TeamJust │
899  *                           └────────────────────────────────┘
900  * multiSig wrapper function (cuts down on inputs, improves readability)
901  * this wrapper is HIGHLY recommended
902  * 
903  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
904  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
905  *
906  * wrapper for delete proposal (makes code cleaner)
907  *     
908  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
909  *                             ┌────────────────────────────┐
910  *                             │ Utility & Vanity Functions │
911  *                             └────────────────────────────┘
912  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
913  * function, with argument inputs that the other admins do not agree upon, the function
914  * can never be executed until the undesirable arguments are approved.
915  * 
916  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
917  * 
918  * for viewing who has signed a proposal & proposal data
919  *     
920  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
921  *
922  * lets you check address of up to 3 signers (address)
923  * 
924  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
925  *
926  * same as above but will return names in string format.
927  *
928  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
929  *                             ┌──────────────────────────┐
930  *                             │ Functions In Depth Guide │
931  *                             └──────────────────────────┘
932  * In the following examples, the Data is the proposal set for this library.  And
933  * the bytes32 is the name of the function.
934  *
935  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
936  *      proposal for the function being called.  The uint256 is the required 
937  *      number of signatures needed before the multiSig will return true.  
938  *      Upon first call, multiSig will create a proposal and store the arguments 
939  *      passed with the function call as msgData.  Any admins trying to sign the 
940  *      function call will need to send the same argument values. Once required
941  *      number of signatures is reached this will return a bool of true.
942  * 
943  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
944  *      you will want to delete the proposal data.  This does that.
945  *
946  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
947  * 
948  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
949  *      the proposal 
950  * 
951  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
952  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
953  */
954 
955 library MSFun {
956     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
957     // DATA SETS
958     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
959     // contact data setup
960     struct Data 
961     {
962         mapping (bytes32 => ProposalData) proposal_;
963     }
964     struct ProposalData 
965     {
966         // a hash of msg.data 
967         bytes32 msgData;
968         // number of signers
969         uint256 count;
970         // tracking of wither admins have signed
971         mapping (address => bool) admin;
972         // list of admins who have signed
973         mapping (uint256 => address) log;
974     }
975     
976     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
977     // MULTI SIG FUNCTIONS
978     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
979     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
980         internal
981         returns(bool) 
982     {
983         // our proposal key will be a hash of our function name + our contracts address 
984         // by adding our contracts address to this, we prevent anyone trying to circumvent
985         // the proposal's security via external calls.
986         bytes32 _whatProposal = whatProposal(_whatFunction);
987         
988         // this is just done to make the code more readable.  grabs the signature count
989         uint256 _currentCount = self.proposal_[_whatProposal].count;
990         
991         // store the address of the person sending the function call.  we use msg.sender 
992         // here as a layer of security.  in case someone imports our contract and tries to 
993         // circumvent function arguments.  still though, our contract that imports this
994         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
995         // calls the function will be a signer. 
996         address _whichAdmin = msg.sender;
997         
998         // prepare our msg data.  by storing this we are able to verify that all admins
999         // are approving the same argument input to be executed for the function.  we hash 
1000         // it and store in bytes32 so its size is known and comparable
1001         bytes32 _msgData = keccak256(msg.data);
1002         
1003         // check to see if this is a new execution of this proposal or not
1004         if (_currentCount == 0)
1005         {
1006             // if it is, lets record the original signers data
1007             self.proposal_[_whatProposal].msgData = _msgData;
1008             
1009             // record original senders signature
1010             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1011             
1012             // update log (used to delete records later, and easy way to view signers)
1013             // also useful if the calling function wants to give something to a 
1014             // specific signer.  
1015             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1016             
1017             // track number of signatures
1018             self.proposal_[_whatProposal].count += 1;  
1019             
1020             // if we now have enough signatures to execute the function, lets
1021             // return a bool of true.  we put this here in case the required signatures
1022             // is set to 1.
1023             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1024                 return(true);
1025             }            
1026         // if its not the first execution, lets make sure the msgData matches
1027         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
1028             // msgData is a match
1029             // make sure admin hasnt already signed
1030             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
1031             {
1032                 // record their signature
1033                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1034                 
1035                 // update log (used to delete records later, and easy way to view signers)
1036                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1037                 
1038                 // track number of signatures
1039                 self.proposal_[_whatProposal].count += 1;  
1040             }
1041             
1042             // if we now have enough signatures to execute the function, lets
1043             // return a bool of true.
1044             // we put this here for a few reasons.  (1) in normal operation, if 
1045             // that last recorded signature got us to our required signatures.  we 
1046             // need to return bool of true.  (2) if we have a situation where the 
1047             // required number of signatures was adjusted to at or lower than our current 
1048             // signature count, by putting this here, an admin who has already signed,
1049             // can call the function again to make it return a true bool.  but only if
1050             // they submit the correct msg data
1051             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1052                 return(true);
1053             }
1054         }
1055     }
1056     
1057     
1058     // deletes proposal signature data after successfully executing a multiSig function
1059     function deleteProposal(Data storage self, bytes32 _whatFunction)
1060         internal
1061     {
1062         //done for readability sake
1063         bytes32 _whatProposal = whatProposal(_whatFunction);
1064         address _whichAdmin;
1065         
1066         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1067         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1068         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1069             _whichAdmin = self.proposal_[_whatProposal].log[i];
1070             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1071             delete self.proposal_[_whatProposal].log[i];
1072         }
1073         //delete the rest of the data in the record
1074         delete self.proposal_[_whatProposal];
1075     }
1076     
1077     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1078     // HELPER FUNCTIONS
1079     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1080 
1081     function whatProposal(bytes32 _whatFunction)
1082         private
1083         view
1084         returns(bytes32)
1085     {
1086         return(keccak256(abi.encodePacked(_whatFunction,this)));
1087     }
1088     
1089     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1090     // VANITY FUNCTIONS
1091     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1092     // returns a hashed version of msg.data sent by original signer for any given function
1093     function checkMsgData (Data storage self, bytes32 _whatFunction)
1094         internal
1095         view
1096         returns (bytes32 msg_data)
1097     {
1098         bytes32 _whatProposal = whatProposal(_whatFunction);
1099         return (self.proposal_[_whatProposal].msgData);
1100     }
1101     
1102     // returns number of signers for any given function
1103     function checkCount (Data storage self, bytes32 _whatFunction)
1104         internal
1105         view
1106         returns (uint256 signature_count)
1107     {
1108         bytes32 _whatProposal = whatProposal(_whatFunction);
1109         return (self.proposal_[_whatProposal].count);
1110     }
1111     
1112     // returns address of an admin who signed for any given function
1113     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1114         internal
1115         view
1116         returns (address signer)
1117     {
1118         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1119         bytes32 _whatProposal = whatProposal(_whatFunction);
1120         return (self.proposal_[_whatProposal].log[_signer - 1]);
1121     }
1122 }