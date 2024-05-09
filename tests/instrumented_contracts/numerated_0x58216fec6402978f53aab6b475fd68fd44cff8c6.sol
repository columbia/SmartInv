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
31 }
32 
33 interface PlayerBookReceiverInterface {
34     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
35     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
36 }
37 
38 interface TeamJustInterface {
39     function requiredSignatures() external view returns(uint256);
40     function requiredDevSignatures() external view returns(uint256);
41     function adminCount() external view returns(uint256);
42     function devCount() external view returns(uint256);
43     function adminName(address _who) external view returns(bytes32);
44     function isAdmin(address _who) external view returns(bool);
45     function isDev(address _who) external view returns(bool);
46 }
47 
48 contract PlayerBook {
49     using NameFilter for string;
50     using SafeMath for uint256;
51     
52     
53     TeamJustInterface constant private TeamJust = TeamJustInterface(0x3520393029503f50b7ddce0db4352ecb2e87c0c1);
54     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xe5f55d966ef9b4d541b286dd5237209d7de9959f);
55     MSFun.Data private msData;
56     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
57     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
58     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
59     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
60     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
61     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
62 //==============================================================================
63 //     _| _ _|_ _    _ _ _|_    _   .
64 //    (_|(_| | (_|  _\(/_ | |_||_)  .
65 //=============================|================================================   
66     uint256 public registrationFee_ = 10 finney;            // price to register a name
67     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
68     mapping(address => bytes32) public gameNames_;          // lookup a games name
69     mapping(address => uint256) public gameIDs_;            // lokup a games ID
70     uint256 public gID_;        // total number of games
71     uint256 public pID_;        // total number of players
72     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
73     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
74     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
75     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
76     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
77     struct Player {
78         address addr;
79         bytes32 name;
80         uint256 laff;
81         uint256 names;
82     }
83     uint256 public stepcode;
84 //==============================================================================
85 //     _ _  _  __|_ _    __|_ _  _  .
86 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
87 //==============================================================================    
88     constructor()
89         public
90     {
91         // premine the dev names (sorry not sorry)
92             // No keys are purchased with this method, it's simply locking our addresses,
93             // PID's and names for referral codes.
94         plyr_[1].addr = 0x6c4575b6283445e5b2e4f46ea706f86ebfbdd1e9;
95         plyr_[1].name = "justo";
96         plyr_[1].names = 1;
97         pIDxAddr_[0x6c4575b6283445e5b2e4f46ea706f86ebfbdd1e9] = 1;
98         pIDxName_["justo"] = 1;
99         plyrNames_[1]["justo"] = true;
100         plyrNameList_[1][1] = "justo";
101         
102         plyr_[2].addr = 0xcae6db99b3eadc9c9ea4a9515c8ddd26894eccdd;
103         plyr_[2].name = "mantso";
104         plyr_[2].names = 1;
105         pIDxAddr_[0xcae6db99b3eadc9c9ea4a9515c8ddd26894eccdd] = 2;
106         pIDxName_["mantso"] = 2;
107         plyrNames_[2]["mantso"] = true;
108         plyrNameList_[2][1] = "mantso";
109         
110         plyr_[3].addr = 0xDDeD7B59cfF636B9b8d1C7e072817cd75Fa08767;
111         plyr_[3].name = "sumpunk";
112         plyr_[3].names = 1;
113         pIDxAddr_[0xDDeD7B59cfF636B9b8d1C7e072817cd75Fa08767] = 3;
114         pIDxName_["sumpunk"] = 3;
115         plyrNames_[3]["sumpunk"] = true;
116         plyrNameList_[3][1] = "sumpunk";
117         
118         plyr_[4].addr = 0x24e0162606d558ac113722adc6597b434089adb7;
119         plyr_[4].name = "inventor";
120         plyr_[4].names = 1;
121         pIDxAddr_[0x24e0162606d558ac113722adc6597b434089adb7] = 4;
122         pIDxName_["inventor"] = 4;
123         plyrNames_[4]["inventor"] = true;
124         plyrNameList_[4][1] = "inventor";
125         
126         pID_ = 4;
127     }
128 //==============================================================================
129 //     _ _  _  _|. |`. _  _ _  .
130 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
131 //==============================================================================    
132     /**
133      * @dev prevents contracts from interacting with fomo3d 
134      */
135     modifier isHuman() {
136         address _addr = msg.sender;
137         uint256 _codeLength;
138         
139         assembly {_codeLength := extcodesize(_addr)}
140         require(_codeLength == 0, "sorry humans only");
141         _;
142     }
143     
144     modifier onlyDevs() 
145     {
146         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
147         _;
148     }
149     
150     modifier isRegisteredGame()
151     {
152         require(gameIDs_[msg.sender] != 0);
153         _;
154     }
155 //==============================================================================
156 //     _    _  _ _|_ _  .
157 //    (/_\/(/_| | | _\  .
158 //==============================================================================    
159     // fired whenever a player registers a name
160     event onNewName
161     (
162         uint256 indexed playerID,
163         address indexed playerAddress,
164         bytes32 indexed playerName,
165         bool isNewPlayer,
166         uint256 affiliateID,
167         address affiliateAddress,
168         bytes32 affiliateName,
169         uint256 amountPaid,
170         uint256 timeStamp
171     );
172 //==============================================================================
173 //     _  _ _|__|_ _  _ _  .
174 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
175 //=====_|=======================================================================
176     function checkIfNameValid(string _nameStr)
177         public
178         view
179         returns(bool)
180     {
181         bytes32 _name = _nameStr.nameFilter();
182         if (pIDxName_[_name] == 0)
183             return (true);
184         else 
185             return (false);
186     }
187 //==============================================================================
188 //     _    |_ |. _   |`    _  __|_. _  _  _  .
189 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
190 //====|=========================================================================    
191     /**
192      * @dev registers a name.  UI will always display the last name you registered.
193      * but you will still own all previously registered names to use as affiliate 
194      * links.
195      * - must pay a registration fee.
196      * - name must be unique
197      * - names will be converted to lowercase
198      * - name cannot start or end with a space 
199      * - cannot have more than 1 space in a row
200      * - cannot be only numbers
201      * - cannot start with 0x 
202      * - name must be at least 1 char
203      * - max length of 32 characters long
204      * - allowed characters: a-z, 0-9, and space
205      * -functionhash- 0x921dec21 (using ID for affiliate)
206      * -functionhash- 0x3ddd4698 (using address for affiliate)
207      * -functionhash- 0x685ffd83 (using name for affiliate)
208      * @param _nameString players desired name
209      * @param _affCode affiliate ID, address, or name of who refered you
210      * @param _all set to true if you want this to push your info to all games 
211      * (this might cost a lot of gas)
212      */
213     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
214         isHuman()
215         public
216         payable 
217     {
218         // make sure name fees paid
219         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
220         
221         // filter name + condition checks
222         bytes32 _name = NameFilter.nameFilter(_nameString);
223         
224         // set up address 
225         address _addr = msg.sender;
226         
227         // set up our tx event data and determine if player is new or not
228         bool _isNewPlayer = determinePID(_addr);
229         
230         // fetch player id
231         uint256 _pID = pIDxAddr_[_addr];
232         
233         // manage affiliate residuals
234         // if no affiliate code was given, no new affiliate code was given, or the 
235         // player tried to use their own pID as an affiliate code, lolz
236         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
237         {
238             // update last affiliate 
239             plyr_[_pID].laff = _affCode;
240         } else if (_affCode == _pID) {
241             _affCode = 0;
242         }
243         
244         // register name 
245         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
246     }
247     
248     function registerNameXaddr(string _nameString, address _affCode, bool _all)
249         isHuman()
250         public
251         payable 
252     {
253         // make sure name fees paid
254         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
255         
256         // filter name + condition checks
257         bytes32 _name = NameFilter.nameFilter(_nameString);
258         
259         // set up address 
260         address _addr = msg.sender;
261         
262         // set up our tx event data and determine if player is new or not
263         bool _isNewPlayer = determinePID(_addr);
264         
265         // fetch player id
266         uint256 _pID = pIDxAddr_[_addr];
267         
268         // manage affiliate residuals
269         // if no affiliate code was given or player tried to use their own, lolz
270         uint256 _affID;
271         if (_affCode != address(0) && _affCode != _addr)
272         {
273             // get affiliate ID from aff Code 
274             _affID = pIDxAddr_[_affCode];
275             
276             // if affID is not the same as previously stored 
277             if (_affID != plyr_[_pID].laff)
278             {
279                 // update last affiliate
280                 plyr_[_pID].laff = _affID;
281             }
282         }
283         
284         // register name 
285         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
286     }
287     
288     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
289         isHuman()
290         public
291         payable 
292     {
293         // make sure name fees paid
294         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
295         
296         // filter name + condition checks
297         bytes32 _name = NameFilter.nameFilter(_nameString);
298         
299         // set up address 
300         address _addr = msg.sender;
301         
302         // set up our tx event data and determine if player is new or not
303         bool _isNewPlayer = determinePID(_addr);
304         
305         // fetch player id
306         uint256 _pID = pIDxAddr_[_addr];
307         
308         // manage affiliate residuals
309         // if no affiliate code was given or player tried to use their own, lolz
310         uint256 _affID;
311         if (_affCode != "" && _affCode != _name)
312         {
313             // get affiliate ID from aff Code 
314             _affID = pIDxName_[_affCode];
315             
316             // if affID is not the same as previously stored 
317             if (_affID != plyr_[_pID].laff)
318             {
319                 // update last affiliate
320                 plyr_[_pID].laff = _affID;
321             }
322         }
323         
324         // register name 
325         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
326     }
327     
328     /**
329      * @dev players, if you registered a profile, before a game was released, or
330      * set the all bool to false when you registered, use this function to push
331      * your profile to a single game.  also, if you've  updated your name, you
332      * can use this to push your name to games of your choosing.
333      * -functionhash- 0x81c5b206
334      * @param _gameID game id 
335      */
336     function addMeToGame(uint256 _gameID)
337         isHuman()
338         public
339     {
340         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
341         address _addr = msg.sender;
342         uint256 _pID = pIDxAddr_[_addr];
343         require(_pID != 0, "hey there buddy, you dont even have an account");
344         uint256 _totalNames = plyr_[_pID].names;
345         
346         // add players profile and most recent name
347         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
348         
349         // add list of all names
350         if (_totalNames > 1)
351             for (uint256 ii = 1; ii <= _totalNames; ii++)
352                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
353     }
354     
355     /**
356      * @dev players, use this to push your player profile to all registered games.
357      * -functionhash- 0x0c6940ea
358      */
359     function addMeToAllGames()
360         isHuman()
361         public
362     {
363         address _addr = msg.sender;
364         uint256 _pID = pIDxAddr_[_addr];
365         require(_pID != 0, "hey there buddy, you dont even have an account");
366         uint256 _laff = plyr_[_pID].laff;
367         uint256 _totalNames = plyr_[_pID].names;
368         bytes32 _name = plyr_[_pID].name;
369         
370         for (uint256 i = 1; i <= gID_; i++)
371         {
372             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
373             if (_totalNames > 1)
374                 for (uint256 ii = 1; ii <= _totalNames; ii++)
375                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
376         }
377                 
378     }
379     
380     /**
381      * @dev players use this to change back to one of your old names.  tip, you'll
382      * still need to push that info to existing games.
383      * -functionhash- 0xb9291296
384      * @param _nameString the name you want to use 
385      */
386     function useMyOldName(string _nameString)
387         isHuman()
388         public 
389     {
390         // filter name, and get pID
391         bytes32 _name = _nameString.nameFilter();
392         uint256 _pID = pIDxAddr_[msg.sender];
393         
394         // make sure they own the name 
395         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
396         
397         // update their current name 
398         plyr_[_pID].name = _name;
399     }
400     
401 //==============================================================================
402 //     _ _  _ _   | _  _ . _  .
403 //    (_(_)| (/_  |(_)(_||(_  . 
404 //=====================_|=======================================================    
405     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
406         private
407     {
408         // if names already has been used, require that current msg sender owns the name
409         if (pIDxName_[_name] != 0)
410             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
411         
412         // add name to player profile, registry, and name book
413         plyr_[_pID].name = _name;
414         pIDxName_[_name] = _pID;
415         if (plyrNames_[_pID][_name] == false)
416         {
417             plyrNames_[_pID][_name] = true;
418             plyr_[_pID].names++;
419             plyrNameList_[_pID][plyr_[_pID].names] = _name;
420         }
421         
422         // registration fee goes directly to community rewards
423         Jekyll_Island_Inc.deposit.value(address(this).balance)();
424        
425         // push player info to games
426         if (_all == true)
427             for (uint256 i = 1; i <= gID_; i++)
428                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
429         
430         // fire event
431         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
432     }
433 //==============================================================================
434 //    _|_ _  _ | _  .
435 //     | (_)(_)|_\  .
436 //==============================================================================    
437     function determinePID(address _addr)
438         private
439         returns (bool)
440     {
441         if (pIDxAddr_[_addr] == 0)
442         {
443             pID_++;
444             pIDxAddr_[_addr] = pID_;
445             plyr_[pID_].addr = _addr;
446             
447             // set the new player bool to true
448             return (true);
449         } else {
450             return (false);
451         }
452     }
453 //==============================================================================
454 //   _   _|_ _  _ _  _ |   _ _ || _  .
455 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
456 //==============================================================================
457     function getPlayerID(address _addr)
458         isRegisteredGame()
459         external
460         returns (uint256)
461     {
462         determinePID(_addr);
463         return (pIDxAddr_[_addr]);
464     }
465     function getPlayerName(uint256 _pID)
466         external
467         view
468         returns (bytes32)
469     {
470         return (plyr_[_pID].name);
471     }
472     function getPlayerLAff(uint256 _pID)
473         external
474         view
475         returns (uint256)
476     {
477         return (plyr_[_pID].laff);
478     }
479     function getPlayerAddr(uint256 _pID)
480         external
481         view
482         returns (address)
483     {
484         return (plyr_[_pID].addr);
485     }
486     function getNameFee()
487         external
488         view
489         returns (uint256)
490     {
491         return(registrationFee_);
492     }
493     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
494         isRegisteredGame()
495         external
496         payable
497         returns(bool, uint256)
498     {
499         // make sure name fees paid
500         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
501         
502         // set up our tx event data and determine if player is new or not
503         bool _isNewPlayer = determinePID(_addr);
504         
505         // fetch player id
506         uint256 _pID = pIDxAddr_[_addr];
507         
508         // manage affiliate residuals
509         // if no affiliate code was given, no new affiliate code was given, or the 
510         // player tried to use their own pID as an affiliate code, lolz
511         uint256 _affID = _affCode;
512         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
513         {
514             // update last affiliate 
515             plyr_[_pID].laff = _affID;
516         } else if (_affID == _pID) {
517             _affID = 0;
518         }
519         
520         // register name 
521         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
522         
523         return(_isNewPlayer, _affID);
524     }
525     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
526         isRegisteredGame()
527         external
528         payable
529         returns(bool, uint256)
530     {
531         // make sure name fees paid
532         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
533         
534         // set up our tx event data and determine if player is new or not
535         bool _isNewPlayer = determinePID(_addr);
536         
537         // fetch player id
538         uint256 _pID = pIDxAddr_[_addr];
539         
540         // manage affiliate residuals
541         // if no affiliate code was given or player tried to use their own, lolz
542         uint256 _affID;
543         if (_affCode != address(0) && _affCode != _addr)
544         {
545             // get affiliate ID from aff Code 
546             _affID = pIDxAddr_[_affCode];
547             
548             // if affID is not the same as previously stored 
549             if (_affID != plyr_[_pID].laff)
550             {
551                 // update last affiliate
552                 plyr_[_pID].laff = _affID;
553             }
554         }
555         
556         // register name 
557         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
558         
559         return(_isNewPlayer, _affID);
560     }
561     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
562         isRegisteredGame()
563         external
564         payable
565         returns(bool, uint256)
566     {
567         // make sure name fees paid
568         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
569         
570         // set up our tx event data and determine if player is new or not
571         bool _isNewPlayer = determinePID(_addr);
572         
573         // fetch player id
574         uint256 _pID = pIDxAddr_[_addr];
575         
576         // manage affiliate residuals
577         // if no affiliate code was given or player tried to use their own, lolz
578         uint256 _affID;
579         if (_affCode != "" && _affCode != _name)
580         {
581             // get affiliate ID from aff Code 
582             _affID = pIDxName_[_affCode];
583             
584             // if affID is not the same as previously stored 
585             if (_affID != plyr_[_pID].laff)
586             {
587                 // update last affiliate
588                 plyr_[_pID].laff = _affID;
589             }
590         }
591         
592         // register name 
593         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
594         
595         return(_isNewPlayer, _affID);
596     }
597     
598 //==============================================================================
599 //   _ _ _|_    _   .
600 //  _\(/_ | |_||_)  .onlyDevs
601 //=============|================================================================
602     function addGame(address _gameAddress, string _gameNameStr)
603         onlyDevs()
604         public
605     {
606         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
607         
608         if (multiSigDev("addGame") == true)
609         {
610             deleteProposal("addGame");
611             gID_++;
612             bytes32 _name = _gameNameStr.nameFilter();
613             gameIDs_[_gameAddress] = gID_;
614             gameNames_[_gameAddress] = _name;
615             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
616         
617             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
618             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
619             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
620             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
621             stepcode=1;
622         }else
623         {
624             stepcode=2;
625         }
626 
627     }
628     function getGame(address _gameAddress)
629     public
630     returns(bytes32)    
631     {
632         require(gameIDs_[_gameAddress] != 0, "derp, that games not been registered");
633         return(gameNames_[_gameAddress]);
634     }
635     function setRegistrationFee(uint256 _fee)
636         onlyDevs()
637         public
638     {
639         if (multiSigDev("setRegistrationFee") == true)
640         {deleteProposal("setRegistrationFee");
641             registrationFee_ = _fee;
642         }
643     }
644         
645 } 
646 
647 /**
648 * @title -Name Filter- v0.1.9
649 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
650 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
651 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
652 *                                  _____                      _____
653 *                                 (, /     /)       /) /)    (, /      /)          /)
654 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
655 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
656 *          ┴ ┴                /   /          .-/ _____   (__ /                               
657 *                            (__ /          (_/ (, /                                      /)™ 
658 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
659 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
660 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
661 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
662 *              _       __    _      ____      ____  _   _    _____  ____  ___  
663 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
664 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
665 *
666 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
667 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
668 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
669 */
670 library NameFilter {
671     
672     /**
673      * @dev filters name strings
674      * -converts uppercase to lower case.  
675      * -makes sure it does not start/end with a space
676      * -makes sure it does not contain multiple spaces in a row
677      * -cannot be only numbers
678      * -cannot start with 0x 
679      * -restricts characters to A-Z, a-z, 0-9, and space.
680      * @return reprocessed string in bytes32 format
681      */
682     function nameFilter(string _input)
683         internal
684         pure
685         returns(bytes32)
686     {
687         bytes memory _temp = bytes(_input);
688         uint256 _length = _temp.length;
689         
690         //sorry limited to 32 characters
691         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
692         // make sure it doesnt start with or end with space
693         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
694         // make sure first two characters are not 0x
695         if (_temp[0] == 0x30)
696         {
697             require(_temp[1] != 0x78, "string cannot start with 0x");
698             require(_temp[1] != 0x58, "string cannot start with 0X");
699         }
700         
701         // create a bool to track if we have a non number character
702         bool _hasNonNumber;
703         
704         // convert & check
705         for (uint256 i = 0; i < _length; i++)
706         {
707             // if its uppercase A-Z
708             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
709             {
710                 // convert to lower case a-z
711                 _temp[i] = byte(uint(_temp[i]) + 32);
712                 
713                 // we have a non number
714                 if (_hasNonNumber == false)
715                     _hasNonNumber = true;
716             } else {
717                 require
718                 (
719                     // require character is a space
720                     _temp[i] == 0x20 || 
721                     // OR lowercase a-z
722                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
723                     // or 0-9
724                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
725                     "string contains invalid characters"
726                 );
727                 // make sure theres not 2x spaces in a row
728                 if (_temp[i] == 0x20)
729                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
730                 
731                 // see if we have a character other than a number
732                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
733                     _hasNonNumber = true;    
734             }
735         }
736         
737         require(_hasNonNumber == true, "string cannot be only numbers");
738         
739         bytes32 _ret;
740         assembly {
741             _ret := mload(add(_temp, 32))
742         }
743         return (_ret);
744     }
745 }
746 
747 /**
748  * @title SafeMath v0.1.9
749  * @dev Math operations with safety checks that throw on error
750  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
751  * - added sqrt
752  * - added sq
753  * - added pwr 
754  * - changed asserts to requires with error log outputs
755  * - removed div, its useless
756  */
757 library SafeMath {
758     
759     /**
760     * @dev Multiplies two numbers, throws on overflow.
761     */
762     function mul(uint256 a, uint256 b) 
763         internal 
764         pure 
765         returns (uint256 c) 
766     {
767         if (a == 0) {
768             return 0;
769         }
770         c = a * b;
771         require(c / a == b, "SafeMath mul failed");
772         return c;
773     }
774 
775     /**
776     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
777     */
778     function sub(uint256 a, uint256 b)
779         internal
780         pure
781         returns (uint256) 
782     {
783         require(b <= a, "SafeMath sub failed");
784         return a - b;
785     }
786 
787     /**
788     * @dev Adds two numbers, throws on overflow.
789     */
790     function add(uint256 a, uint256 b)
791         internal
792         pure
793         returns (uint256 c) 
794     {
795         c = a + b;
796         require(c >= a, "SafeMath add failed");
797         return c;
798     }
799     
800     /**
801      * @dev gives square root of given x.
802      */
803     function sqrt(uint256 x)
804         internal
805         pure
806         returns (uint256 y) 
807     {
808         uint256 z = ((add(x,1)) / 2);
809         y = x;
810         while (z < y) 
811         {
812             y = z;
813             z = ((add((x / z),z)) / 2);
814         }
815     }
816     
817     /**
818      * @dev gives square. multiplies x by x
819      */
820     function sq(uint256 x)
821         internal
822         pure
823         returns (uint256)
824     {
825         return (mul(x,x));
826     }
827     
828     /**
829      * @dev x to the power of y 
830      */
831     function pwr(uint256 x, uint256 y)
832         internal 
833         pure 
834         returns (uint256)
835     {
836         if (x==0)
837             return (0);
838         else if (y==0)
839             return (1);
840         else 
841         {
842             uint256 z = x;
843             for (uint256 i=1; i < y; i++)
844                 z = mul(z,x);
845             return (z);
846         }
847     }
848 }
849 
850 /** @title -MSFun- v0.2.4
851  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
852  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
853  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
854  *                                  _____                      _____
855  *                                 (, /     /)       /) /)    (, /      /)          /)
856  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
857  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
858  *          ┴ ┴                /   /          .-/ _____   (__ /                               
859  *                            (__ /          (_/ (, /                                      /)™ 
860  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
861  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
862  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
863  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
864  *  _           _             _  _  _  _             _  _  _  _  _                                      
865  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
866  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
867  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
868  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
869  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
870  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
871  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
872  *
873  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
874  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
875  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
876  *  
877  *         ┌──────────────────────────────────────────────────────────────────────┐
878  *         │ MSFun, is an importable library that gives your contract the ability │
879  *         │ add multiSig requirement to functions.                               │
880  *         └──────────────────────────────────────────────────────────────────────┘
881  *                                ┌────────────────────┐
882  *                                │ Setup Instructions │
883  *                                └────────────────────┘
884  * (Step 1) import the library into your contract
885  * 
886  *    import "./MSFun.sol";
887  *
888  * (Step 2) set up the signature data for msFun
889  * 
890  *     MSFun.Data private msData;
891  *                                ┌────────────────────┐
892  *                                │ Usage Instructions │
893  *                                └────────────────────┘
894  * at the beginning of a function
895  * 
896  *     function functionName() 
897  *     {
898  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
899  *         {
900  *             MSFun.deleteProposal(msData, "functionName");
901  * 
902  *             // put function body here 
903  *         }
904  *     }
905  *                           ┌────────────────────────────────┐
906  *                           │ Optional Wrappers For TeamJust │
907  *                           └────────────────────────────────┘
908  * multiSig wrapper function (cuts down on inputs, improves readability)
909  * this wrapper is HIGHLY recommended
910  * 
911  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
912  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
913  *
914  * wrapper for delete proposal (makes code cleaner)
915  *     
916  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
917  *                             ┌────────────────────────────┐
918  *                             │ Utility & Vanity Functions │
919  *                             └────────────────────────────┘
920  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
921  * function, with argument inputs that the other admins do not agree upon, the function
922  * can never be executed until the undesirable arguments are approved.
923  * 
924  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
925  * 
926  * for viewing who has signed a proposal & proposal data
927  *     
928  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
929  *
930  * lets you check address of up to 3 signers (address)
931  * 
932  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
933  *
934  * same as above but will return names in string format.
935  *
936  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
937  *                             ┌──────────────────────────┐
938  *                             │ Functions In Depth Guide │
939  *                             └──────────────────────────┘
940  * In the following examples, the Data is the proposal set for this library.  And
941  * the bytes32 is the name of the function.
942  *
943  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
944  *      proposal for the function being called.  The uint256 is the required 
945  *      number of signatures needed before the multiSig will return true.  
946  *      Upon first call, multiSig will create a proposal and store the arguments 
947  *      passed with the function call as msgData.  Any admins trying to sign the 
948  *      function call will need to send the same argument values. Once required
949  *      number of signatures is reached this will return a bool of true.
950  * 
951  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
952  *      you will want to delete the proposal data.  This does that.
953  *
954  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
955  * 
956  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
957  *      the proposal 
958  * 
959  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
960  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
961  */
962 
963 library MSFun {
964     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
965     // DATA SETS
966     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
967     // contact data setup
968     struct Data 
969     {
970         mapping (bytes32 => ProposalData) proposal_;
971     }
972     struct ProposalData 
973     {
974         // a hash of msg.data 
975         bytes32 msgData;
976         // number of signers
977         uint256 count;
978         // tracking of wither admins have signed
979         mapping (address => bool) admin;
980         // list of admins who have signed
981         mapping (uint256 => address) log;
982     }
983     
984     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
985     // MULTI SIG FUNCTIONS
986     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
987     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
988         internal
989         returns(bool) 
990     {
991         // our proposal key will be a hash of our function name + our contracts address 
992         // by adding our contracts address to this, we prevent anyone trying to circumvent
993         // the proposal's security via external calls.
994         bytes32 _whatProposal = whatProposal(_whatFunction);
995         
996         // this is just done to make the code more readable.  grabs the signature count
997         uint256 _currentCount = self.proposal_[_whatProposal].count;
998         
999         // store the address of the person sending the function call.  we use msg.sender 
1000         // here as a layer of security.  in case someone imports our contract and tries to 
1001         // circumvent function arguments.  still though, our contract that imports this
1002         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
1003         // calls the function will be a signer. 
1004         address _whichAdmin = msg.sender;
1005         
1006         // prepare our msg data.  by storing this we are able to verify that all admins
1007         // are approving the same argument input to be executed for the function.  we hash 
1008         // it and store in bytes32 so its size is known and comparable
1009         bytes32 _msgData = keccak256(msg.data);
1010         
1011         // check to see if this is a new execution of this proposal or not
1012         if (_currentCount == 0)
1013         {
1014             // if it is, lets record the original signers data
1015             self.proposal_[_whatProposal].msgData = _msgData;
1016             
1017             // record original senders signature
1018             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1019             
1020             // update log (used to delete records later, and easy way to view signers)
1021             // also useful if the calling function wants to give something to a 
1022             // specific signer.  
1023             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1024             
1025             // track number of signatures
1026             self.proposal_[_whatProposal].count += 1;  
1027             
1028             // if we now have enough signatures to execute the function, lets
1029             // return a bool of true.  we put this here in case the required signatures
1030             // is set to 1.
1031             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1032                 return(true);
1033             }            
1034         // if its not the first execution, lets make sure the msgData matches
1035         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
1036             // msgData is a match
1037             // make sure admin hasnt already signed
1038             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
1039             {
1040                 // record their signature
1041                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
1042                 
1043                 // update log (used to delete records later, and easy way to view signers)
1044                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
1045                 
1046                 // track number of signatures
1047                 self.proposal_[_whatProposal].count += 1;  
1048             }
1049             
1050             // if we now have enough signatures to execute the function, lets
1051             // return a bool of true.
1052             // we put this here for a few reasons.  (1) in normal operation, if 
1053             // that last recorded signature got us to our required signatures.  we 
1054             // need to return bool of true.  (2) if we have a situation where the 
1055             // required number of signatures was adjusted to at or lower than our current 
1056             // signature count, by putting this here, an admin who has already signed,
1057             // can call the function again to make it return a true bool.  but only if
1058             // they submit the correct msg data
1059             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
1060                 return(true);
1061             }
1062         }
1063     }
1064     
1065     
1066     // deletes proposal signature data after successfully executing a multiSig function
1067     function deleteProposal(Data storage self, bytes32 _whatFunction)
1068         internal
1069     {
1070         //done for readability sake
1071         bytes32 _whatProposal = whatProposal(_whatFunction);
1072         address _whichAdmin;
1073         
1074         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
1075         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
1076         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
1077             _whichAdmin = self.proposal_[_whatProposal].log[i];
1078             delete self.proposal_[_whatProposal].admin[_whichAdmin];
1079             delete self.proposal_[_whatProposal].log[i];
1080         }
1081         //delete the rest of the data in the record
1082         delete self.proposal_[_whatProposal];
1083     }
1084     
1085     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1086     // HELPER FUNCTIONS
1087     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1088 
1089     function whatProposal(bytes32 _whatFunction)
1090         private
1091         view
1092         returns(bytes32)
1093     {
1094         return(keccak256(abi.encodePacked(_whatFunction,this)));
1095     }
1096     
1097     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1098     // VANITY FUNCTIONS
1099     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1100     // returns a hashed version of msg.data sent by original signer for any given function
1101     function checkMsgData (Data storage self, bytes32 _whatFunction)
1102         internal
1103         view
1104         returns (bytes32 msg_data)
1105     {
1106         bytes32 _whatProposal = whatProposal(_whatFunction);
1107         return (self.proposal_[_whatProposal].msgData);
1108     }
1109     
1110     // returns number of signers for any given function
1111     function checkCount (Data storage self, bytes32 _whatFunction)
1112         internal
1113         view
1114         returns (uint256 signature_count)
1115     {
1116         bytes32 _whatProposal = whatProposal(_whatFunction);
1117         return (self.proposal_[_whatProposal].count);
1118     }
1119     
1120     // returns address of an admin who signed for any given function
1121     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
1122         internal
1123         view
1124         returns (address signer)
1125     {
1126         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
1127         bytes32 _whatProposal = whatProposal(_whatFunction);
1128         return (self.proposal_[_whatProposal].log[_signer - 1]);
1129     }
1130 }