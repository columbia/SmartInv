1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 interface TeamAnonymousInterface {
9     function requiredSignatures() external view returns(uint256);
10     function requiredDevSignatures() external view returns(uint256);
11     function adminCount() external view returns(uint256);
12     function devCount() external view returns(uint256);
13     function adminName(address _who) external view returns(bytes32);
14     function isAdmin(address _who) external view returns(bool);
15     function isDev(address _who) external view returns(bool);
16 }
17 
18 contract PlayerBook {
19     using NameFilter for string;
20     using SafeMath for uint256;
21     
22     // TO DO: TEAM ADDRESS
23     TeamAnonymousInterface constant private TeamAnonymous = TeamAnonymousInterface(0x7c994f3cae4f745eec885b5b86fc138947044ba5);
24     
25     MSFun.Data private msData;
26     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamAnonymous.requiredDevSignatures(), _whatFunction));}
27     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
28     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
29     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
30     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
31     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
32 
33     address constant private team = 0x7298EFD119A830edab6C442632EEff14292609B0;
34     
35     uint256 public registrationFee_ = 10 finney;            // price to register a name
36     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
37     mapping(address => bytes32) public gameNames_;          // lookup a games name
38     mapping(address => uint256) public gameIDs_;            // lokup a games ID
39     uint256 public gID_;        // total number of games
40     uint256 public pID_;        // total number of players
41     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
42     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
43     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
44     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; 
45     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
46     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
47     struct Player {
48         address addr;
49         bytes32 name;
50         uint256 laff;
51         uint256 names;
52     }
53 //==============================================================================
54 //     _ _  _  __|_ _    __|_ _  _  .
55 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
56 //==============================================================================    
57     constructor()
58         public
59     {
60         // premine the dev names (sorry not sorry)
61             // No keys are purchased with this method, it's simply locking our addresses,
62             // PID's and names for referral codes.
63         
64         //管理员地址
65         plyr_[1].addr = 0x937328B032B7d9A972D5EB8CbDC0D3c9B0EB379D;
66         plyr_[1].name = "creator";
67         plyr_[1].names = 1;
68         pIDxAddr_[0x937328B032B7d9A972D5EB8CbDC0D3c9B0EB379D] = 1;
69         pIDxName_["creator"] = 1;
70         plyrNames_[1]["creator"] = true;
71         plyrNameList_[1][1] = "creator";
72         
73         plyr_[2].addr = 0x9aC45D299d3FB8E31C37714963f7D1FE4838fD0b;
74         plyr_[2].name = "admin";
75         plyr_[2].names = 1;
76         pIDxAddr_[0x9aC45D299d3FB8E31C37714963f7D1FE4838fD0b] = 2;
77         pIDxName_["admin"] = 2;
78         plyrNames_[2]["admin"] = true;
79         plyrNameList_[2][1] = "admin";
80         
81         pID_ = 2;
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
92         require (_addr == tx.origin);
93         
94         uint256 _codeLength;
95         
96         assembly {_codeLength := extcodesize(_addr)}
97         require(_codeLength == 0, "sorry humans only");
98         _;
99     }
100     
101     modifier onlyDevs() 
102     {
103         require(TeamAnonymous.isDev(msg.sender) == true, "msg sender is not a dev");
104         _;
105     }
106     
107     modifier isRegisteredGame()
108     {
109         require(gameIDs_[msg.sender] != 0);
110         _;
111     }
112 //==============================================================================
113 //     _    _  _ _|_ _  .
114 //    (/_\/(/_| | | _\  .
115 //==============================================================================    
116     // fired whenever a player registers a name
117     event onNewName
118     (
119         uint256 indexed playerID,
120         address indexed playerAddress,
121         bytes32 indexed playerName,
122         bool isNewPlayer,
123         uint256 affiliateID,
124         address affiliateAddress,
125         bytes32 affiliateName,
126         uint256 amountPaid,
127         uint256 timeStamp
128     );
129 //==============================================================================
130 //     _  _ _|__|_ _  _ _  .
131 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
132 //=====_|=======================================================================
133     function checkIfNameValid(string _nameStr)
134         public
135         view
136         returns(bool)
137     {
138         bytes32 _name = _nameStr.nameFilter();
139         if (pIDxName_[_name] == 0)
140             return (true);
141         else 
142             return (false);
143     }
144 //==============================================================================
145 //     _    |_ |. _   |`    _  __|_. _  _  _  .
146 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
147 //====|=========================================================================    
148     /**
149      * @dev registers a name.  UI will always display the last name you registered.
150      * but you will still own all previously registered names to use as affiliate 
151      * links.
152      * - must pay a registration fee.
153      * - name must be unique
154      * - names will be converted to lowercase
155      * - name cannot start or end with a space 
156      * - cannot have more than 1 space in a row
157      * - cannot be only numbers
158      * - cannot start with 0x 
159      * - name must be at least 1 char
160      * - max length of 32 characters long
161      * - allowed characters: a-z, 0-9, and space
162      * -functionhash- 0x921dec21 (using ID for affiliate)
163      * -functionhash- 0x3ddd4698 (using address for affiliate)
164      * -functionhash- 0x685ffd83 (using name for affiliate)
165      * @param _nameString players desired name
166      * @param _affCode affiliate ID, address, or name of who refered you
167      * @param _all set to true if you want this to push your info to all games 
168      * (this might cost a lot of gas)
169      */
170     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
171         isHuman()
172         public
173         payable 
174     {
175         // make sure name fees paid
176         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
177         
178         // filter name + condition checks
179         bytes32 _name = NameFilter.nameFilter(_nameString);
180         
181         // set up address 
182         address _addr = msg.sender;
183         
184         // set up our tx event data and determine if player is new or not
185         bool _isNewPlayer = determinePID(_addr);
186         
187         // fetch player id
188         uint256 _pID = pIDxAddr_[_addr];
189         
190         // manage affiliate residuals
191         // if no affiliate code was given, no new affiliate code was given, or the 
192         // player tried to use their own pID as an affiliate code, lolz
193         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
194         {
195             // update last affiliate 
196             plyr_[_pID].laff = _affCode;
197         } else if (_affCode == _pID) {
198             _affCode = 0;
199         }
200         
201         // register name 
202         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
203     }
204     
205     function registerNameXaddr(string _nameString, address _affCode, bool _all)
206         isHuman()
207         public
208         payable 
209     {
210         // make sure name fees paid
211         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
212         
213         // filter name + condition checks
214         bytes32 _name = NameFilter.nameFilter(_nameString);
215         
216         // set up address 
217         address _addr = msg.sender;
218         
219         // set up our tx event data and determine if player is new or not
220         bool _isNewPlayer = determinePID(_addr);
221         
222         // fetch player id
223         uint256 _pID = pIDxAddr_[_addr];
224         
225         // manage affiliate residuals
226         // if no affiliate code was given or player tried to use their own, lolz
227         uint256 _affID;
228         if (_affCode != address(0) && _affCode != _addr)
229         {
230             // get affiliate ID from aff Code 
231             _affID = pIDxAddr_[_affCode];
232             
233             // if affID is not the same as previously stored 
234             if (_affID != plyr_[_pID].laff)
235             {
236                 // update last affiliate
237                 plyr_[_pID].laff = _affID;
238             }
239         }
240         
241         // register name 
242         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
243     }
244     
245     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
246         isHuman()
247         public
248         payable 
249     {
250         // make sure name fees paid
251         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
252         
253         // filter name + condition checks
254         bytes32 _name = NameFilter.nameFilter(_nameString);
255         
256         // set up address 
257         address _addr = msg.sender;
258         
259         // set up our tx event data and determine if player is new or not
260         bool _isNewPlayer = determinePID(_addr);
261         
262         // fetch player id
263         uint256 _pID = pIDxAddr_[_addr];
264         
265         // manage affiliate residuals
266         // if no affiliate code was given or player tried to use their own, lolz
267         uint256 _affID;
268         if (_affCode != "" && _affCode != _name)
269         {
270             // get affiliate ID from aff Code 
271             _affID = pIDxName_[_affCode];
272             
273             // if affID is not the same as previously stored 
274             if (_affID != plyr_[_pID].laff)
275             {
276                 // update last affiliate
277                 plyr_[_pID].laff = _affID;
278             }
279         }
280         
281         // register name 
282         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
283     }
284     
285     /**
286      * @dev players, if you registered a profile, before a game was released, or
287      * set the all bool to false when you registered, use this function to push
288      * your profile to a single game.  also, if you've  updated your name, you
289      * can use this to push your name to games of your choosing.
290      * -functionhash- 0x81c5b206
291      * @param _gameID game id 
292      */
293     function addMeToGame(uint256 _gameID)
294         isHuman()
295         public
296     {
297         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
298         address _addr = msg.sender;
299         uint256 _pID = pIDxAddr_[_addr];
300         require(_pID != 0, "hey there buddy, you dont even have an account");
301         uint256 _totalNames = plyr_[_pID].names;
302         
303         // add players profile and most recent name
304         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
305         
306         // add list of all names
307         if (_totalNames > 1)
308             for (uint256 ii = 1; ii <= _totalNames; ii++)
309                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
310     }
311     
312     /**
313      * @dev players, use this to push your player profile to all registered games.
314      * -functionhash- 0x0c6940ea
315      */
316     function addMeToAllGames()
317         isHuman()
318         public
319     {
320         address _addr = msg.sender;
321         uint256 _pID = pIDxAddr_[_addr];
322         require(_pID != 0, "hey there buddy, you dont even have an account");
323         uint256 _laff = plyr_[_pID].laff;
324         uint256 _totalNames = plyr_[_pID].names;
325         bytes32 _name = plyr_[_pID].name;
326         
327         for (uint256 i = 1; i <= gID_; i++)
328         {
329             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
330             if (_totalNames > 1)
331                 for (uint256 ii = 1; ii <= _totalNames; ii++)
332                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
333         }
334                 
335     }
336     
337     /**
338      * @dev players use this to change back to one of your old names.  tip, you'll
339      * still need to push that info to existing games.
340      * -functionhash- 0xb9291296
341      * @param _nameString the name you want to use 
342      */
343     function useMyOldName(string _nameString)
344         isHuman()
345         public 
346     {
347         // filter name, and get pID
348         bytes32 _name = _nameString.nameFilter();
349         uint256 _pID = pIDxAddr_[msg.sender];
350         
351         // make sure they own the name 
352         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
353         
354         // update their current name 
355         plyr_[_pID].name = _name;
356     }
357     
358 //==============================================================================
359 //     _ _  _ _   | _  _ . _  .
360 //    (_(_)| (/_  |(_)(_||(_  . 
361 //=====================_|=======================================================    
362     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
363         private
364     {
365         // if names already has been used, require that current msg sender owns the name
366         if (pIDxName_[_name] != 0)
367             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
368         
369         // add name to player profile, registry, and name book
370         plyr_[_pID].name = _name;
371         pIDxName_[_name] = _pID;
372         if (plyrNames_[_pID][_name] == false)
373         {
374             plyrNames_[_pID][_name] = true;
375             plyr_[_pID].names++;
376             plyrNameList_[_pID][plyr_[_pID].names] = _name;
377         }
378         
379         // registration fee goes directly to community rewards
380         team.transfer(address(this).balance);
381         
382         // push player info to games
383         if (_all == true)
384             for (uint256 i = 1; i <= gID_; i++)
385                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
386         
387         // fire event
388         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
389     }
390 //==============================================================================
391 //    _|_ _  _ | _  .
392 //     | (_)(_)|_\  .
393 //==============================================================================    
394     function determinePID(address _addr)
395         private
396         returns (bool)
397     {
398         if (pIDxAddr_[_addr] == 0)
399         {
400             pID_++;
401             pIDxAddr_[_addr] = pID_;
402             plyr_[pID_].addr = _addr;
403             
404             // set the new player bool to true
405             return (true);
406         } else {
407             return (false);
408         }
409     }
410 //==============================================================================
411 //   _   _|_ _  _ _  _ |   _ _ || _  .
412 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
413 //==============================================================================
414     function getPlayerID(address _addr)
415         isRegisteredGame()
416         external
417         returns (uint256)
418     {
419         determinePID(_addr);
420         return (pIDxAddr_[_addr]);
421     }
422     function getPlayerName(uint256 _pID)
423         external
424         view
425         returns (bytes32)
426     {
427         return (plyr_[_pID].name);
428     }
429     function getPlayerLAff(uint256 _pID)
430         external
431         view
432         returns (uint256)
433     {
434         return (plyr_[_pID].laff);
435     }
436     function getPlayerAddr(uint256 _pID)
437         external
438         view
439         returns (address)
440     {
441         return (plyr_[_pID].addr);
442     }
443     function getNameFee()
444         external
445         view
446         returns (uint256)
447     {
448         return(registrationFee_);
449     }
450     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
451         isRegisteredGame()
452         external
453         payable
454         returns(bool, uint256)
455     {
456         // make sure name fees paid
457         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
458         
459         // set up our tx event data and determine if player is new or not
460         bool _isNewPlayer = determinePID(_addr);
461         
462         // fetch player id
463         uint256 _pID = pIDxAddr_[_addr];
464         
465         // manage affiliate residuals
466         // if no affiliate code was given, no new affiliate code was given, or the 
467         // player tried to use their own pID as an affiliate code, lolz
468         uint256 _affID = _affCode;
469         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
470         {
471             // update last affiliate 
472             plyr_[_pID].laff = _affID;
473         } else if (_affID == _pID) {
474             _affID = 0;
475         }
476         
477         // register name 
478         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
479         
480         return(_isNewPlayer, _affID);
481     }
482     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
483         isRegisteredGame()
484         external
485         payable
486         returns(bool, uint256)
487     {
488         // make sure name fees paid
489         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
490         
491         // set up our tx event data and determine if player is new or not
492         bool _isNewPlayer = determinePID(_addr);
493         
494         // fetch player id
495         uint256 _pID = pIDxAddr_[_addr];
496         
497         // manage affiliate residuals
498         // if no affiliate code was given or player tried to use their own, lolz
499         uint256 _affID;
500         if (_affCode != address(0) && _affCode != _addr)
501         {
502             // get affiliate ID from aff Code 
503             _affID = pIDxAddr_[_affCode];
504             
505             // if affID is not the same as previously stored 
506             if (_affID != plyr_[_pID].laff)
507             {
508                 // update last affiliate
509                 plyr_[_pID].laff = _affID;
510             }
511         }
512         
513         // register name 
514         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
515         
516         return(_isNewPlayer, _affID);
517     }
518     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
519         isRegisteredGame()
520         external
521         payable
522         returns(bool, uint256)
523     {
524         // make sure name fees paid
525         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
526         
527         // set up our tx event data and determine if player is new or not
528         bool _isNewPlayer = determinePID(_addr);
529         
530         // fetch player id
531         uint256 _pID = pIDxAddr_[_addr];
532         
533         // manage affiliate residuals
534         // if no affiliate code was given or player tried to use their own, lolz
535         uint256 _affID;
536         if (_affCode != "" && _affCode != _name)
537         {
538             // get affiliate ID from aff Code 
539             _affID = pIDxName_[_affCode];
540             
541             // if affID is not the same as previously stored 
542             if (_affID != plyr_[_pID].laff)
543             {
544                 // update last affiliate
545                 plyr_[_pID].laff = _affID;
546             }
547         }
548         
549         // register name 
550         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
551         
552         return(_isNewPlayer, _affID);
553     }
554     
555 //==============================================================================
556 //   _ _ _|_    _   .
557 //  _\(/_ | |_||_)  .
558 //=============|================================================================
559     function addGame(address _gameAddress, string _gameNameStr)
560         onlyDevs()
561         public
562     {
563         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
564     
565         gID_++;
566         bytes32 _name = _gameNameStr.nameFilter();
567         gameIDs_[_gameAddress] = gID_;
568         gameNames_[_gameAddress] = _name;
569         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
570     
571         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
572         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
573     }
574     
575     // MASK: SET 设置改名费
576     function setRegistrationFee(uint256 _fee)
577         onlyDevs()
578         public
579     {
580         registrationFee_ = _fee;
581     }
582         
583 } 
584 
585 
586 library NameFilter {
587     
588     /**
589      * @dev filters name strings
590      * -converts uppercase to lower case.  
591      * -makes sure it does not start/end with a space
592      * -makes sure it does not contain multiple spaces in a row
593      * -cannot be only numbers
594      * -cannot start with 0x 
595      * -restricts characters to A-Z, a-z, 0-9, and space.
596      * @return reprocessed string in bytes32 format
597      */
598     function nameFilter(string _input)
599         internal
600         pure
601         returns(bytes32)
602     {
603         bytes memory _temp = bytes(_input);
604         uint256 _length = _temp.length;
605         
606         //sorry limited to 32 characters
607         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
608         // make sure it doesnt start with or end with space
609         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
610         // make sure first two characters are not 0x
611         if (_temp[0] == 0x30)
612         {
613             require(_temp[1] != 0x78, "string cannot start with 0x");
614             require(_temp[1] != 0x58, "string cannot start with 0X");
615         }
616         
617         // create a bool to track if we have a non number character
618         bool _hasNonNumber;
619         
620         // convert & check
621         for (uint256 i = 0; i < _length; i++)
622         {
623             // if its uppercase A-Z
624             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
625             {
626                 // convert to lower case a-z
627                 _temp[i] = byte(uint(_temp[i]) + 32);
628                 
629                 // we have a non number
630                 if (_hasNonNumber == false)
631                     _hasNonNumber = true;
632             } else {
633                 require
634                 (
635                     // require character is a space
636                     _temp[i] == 0x20 || 
637                     // OR lowercase a-z
638                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
639                     // or 0-9
640                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
641                     "string contains invalid characters"
642                 );
643                 // make sure theres not 2x spaces in a row
644                 if (_temp[i] == 0x20)
645                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
646                 
647                 // see if we have a character other than a number
648                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
649                     _hasNonNumber = true;    
650             }
651         }
652         
653         require(_hasNonNumber == true, "string cannot be only numbers");
654         
655         bytes32 _ret;
656         assembly {
657             _ret := mload(add(_temp, 32))
658         }
659         return (_ret);
660     }
661 }
662 
663 /**
664  * @title SafeMath v0.1.9
665  * @dev Math operations with safety checks that throw on error
666  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
667  * - added sqrt
668  * - added sq
669  * - added pwr 
670  * - changed asserts to requires with error log outputs
671  * - removed div, its useless
672  */
673 library SafeMath {
674     
675     /**
676     * @dev Multiplies two numbers, throws on overflow.
677     */
678     function mul(uint256 a, uint256 b) 
679         internal 
680         pure 
681         returns (uint256 c) 
682     {
683         if (a == 0) {
684             return 0;
685         }
686         c = a * b;
687         require(c / a == b, "SafeMath mul failed");
688         return c;
689     }
690 
691     /**
692     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
693     */
694     function sub(uint256 a, uint256 b)
695         internal
696         pure
697         returns (uint256) 
698     {
699         require(b <= a, "SafeMath sub failed");
700         return a - b;
701     }
702 
703     /**
704     * @dev Adds two numbers, throws on overflow.
705     */
706     function add(uint256 a, uint256 b)
707         internal
708         pure
709         returns (uint256 c) 
710     {
711         c = a + b;
712         require(c >= a, "SafeMath add failed");
713         return c;
714     }
715     
716     /**
717      * @dev gives square root of given x.
718      */
719     function sqrt(uint256 x)
720         internal
721         pure
722         returns (uint256 y) 
723     {
724         uint256 z = ((add(x,1)) / 2);
725         y = x;
726         while (z < y) 
727         {
728             y = z;
729             z = ((add((x / z),z)) / 2);
730         }
731     }
732     
733     /**
734      * @dev gives square. multiplies x by x
735      */
736     function sq(uint256 x)
737         internal
738         pure
739         returns (uint256)
740     {
741         return (mul(x,x));
742     }
743     
744     /**
745      * @dev x to the power of y 
746      */
747     function pwr(uint256 x, uint256 y)
748         internal 
749         pure 
750         returns (uint256)
751     {
752         if (x==0)
753             return (0);
754         else if (y==0)
755             return (1);
756         else 
757         {
758             uint256 z = x;
759             for (uint256 i=1; i < y; i++)
760                 z = mul(z,x);
761             return (z);
762         }
763     }
764 }
765 
766 library MSFun {
767     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
768     // DATA SETS
769     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
770     // contact data setup
771     struct Data 
772     {
773         mapping (bytes32 => ProposalData) proposal_;
774     }
775     struct ProposalData 
776     {
777         // a hash of msg.data 
778         bytes32 msgData;
779         // number of signers
780         uint256 count;
781         // tracking of wither admins have signed
782         mapping (address => bool) admin;
783         // list of admins who have signed
784         mapping (uint256 => address) log;
785     }
786     
787     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
788     // MULTI SIG FUNCTIONS
789     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
790     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
791         internal
792         returns(bool) 
793     {
794         // our proposal key will be a hash of our function name + our contracts address 
795         // by adding our contracts address to this, we prevent anyone trying to circumvent
796         // the proposal's security via external calls.
797         bytes32 _whatProposal = whatProposal(_whatFunction);
798         
799         // this is just done to make the code more readable.  grabs the signature count
800         uint256 _currentCount = self.proposal_[_whatProposal].count;
801         
802         // store the address of the person sending the function call.  we use msg.sender 
803         // here as a layer of security.  in case someone imports our contract and tries to 
804         // circumvent function arguments.  still though, our contract that imports this
805         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
806         // calls the function will be a signer. 
807         address _whichAdmin = msg.sender;
808         
809         // prepare our msg data.  by storing this we are able to verify that all admins
810         // are approving the same argument input to be executed for the function.  we hash 
811         // it and store in bytes32 so its size is known and comparable
812         bytes32 _msgData = keccak256(msg.data);
813         
814         // check to see if this is a new execution of this proposal or not
815         if (_currentCount == 0)
816         {
817             // if it is, lets record the original signers data
818             self.proposal_[_whatProposal].msgData = _msgData;
819             
820             // record original senders signature
821             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
822             
823             // update log (used to delete records later, and easy way to view signers)
824             // also useful if the calling function wants to give something to a 
825             // specific signer.  
826             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
827             
828             // track number of signatures
829             self.proposal_[_whatProposal].count += 1;  
830             
831             // if we now have enough signatures to execute the function, lets
832             // return a bool of true.  we put this here in case the required signatures
833             // is set to 1.
834             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
835                 return(true);
836             }            
837         // if its not the first execution, lets make sure the msgData matches
838         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
839             // msgData is a match
840             // make sure admin hasnt already signed
841             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
842             {
843                 // record their signature
844                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
845                 
846                 // update log (used to delete records later, and easy way to view signers)
847                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
848                 
849                 // track number of signatures
850                 self.proposal_[_whatProposal].count += 1;  
851             }
852             
853             // if we now have enough signatures to execute the function, lets
854             // return a bool of true.
855             // we put this here for a few reasons.  (1) in normal operation, if 
856             // that last recorded signature got us to our required signatures.  we 
857             // need to return bool of true.  (2) if we have a situation where the 
858             // required number of signatures was adjusted to at or lower than our current 
859             // signature count, by putting this here, an admin who has already signed,
860             // can call the function again to make it return a true bool.  but only if
861             // they submit the correct msg data
862             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
863                 return(true);
864             }
865         }
866     }
867     
868     
869     // deletes proposal signature data after successfully executing a multiSig function
870     function deleteProposal(Data storage self, bytes32 _whatFunction)
871         internal
872     {
873         //done for readability sake
874         bytes32 _whatProposal = whatProposal(_whatFunction);
875         address _whichAdmin;
876         
877         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
878         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
879         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
880             _whichAdmin = self.proposal_[_whatProposal].log[i];
881             delete self.proposal_[_whatProposal].admin[_whichAdmin];
882             delete self.proposal_[_whatProposal].log[i];
883         }
884         //delete the rest of the data in the record
885         delete self.proposal_[_whatProposal];
886     }
887     
888     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
889     // HELPER FUNCTIONS
890     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
891 
892     function whatProposal(bytes32 _whatFunction)
893         private
894         view
895         returns(bytes32)
896     {
897         return(keccak256(abi.encodePacked(_whatFunction,this)));
898     }
899     
900     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
901     // VANITY FUNCTIONS
902     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
903     // returns a hashed version of msg.data sent by original signer for any given function
904     function checkMsgData (Data storage self, bytes32 _whatFunction)
905         internal
906         view
907         returns (bytes32 msg_data)
908     {
909         bytes32 _whatProposal = whatProposal(_whatFunction);
910         return (self.proposal_[_whatProposal].msgData);
911     }
912     
913     // returns number of signers for any given function
914     function checkCount (Data storage self, bytes32 _whatFunction)
915         internal
916         view
917         returns (uint256 signature_count)
918     {
919         bytes32 _whatProposal = whatProposal(_whatFunction);
920         return (self.proposal_[_whatProposal].count);
921     }
922     
923     // returns address of an admin who signed for any given function
924     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
925         internal
926         view
927         returns (address signer)
928     {
929         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
930         bytes32 _whatProposal = whatProposal(_whatFunction);
931         return (self.proposal_[_whatProposal].log[_signer - 1]);
932     }
933 }