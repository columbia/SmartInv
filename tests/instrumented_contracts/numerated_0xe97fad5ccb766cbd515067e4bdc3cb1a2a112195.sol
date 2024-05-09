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
23     TeamAnonymousInterface constant private TeamAnonymous = TeamAnonymousInterface(0xb4E5E4759A25eaFb4055FA450B71c7281fA97e45);
24     
25     MSFun.Data private msData;
26     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamAnonymous.requiredDevSignatures(), _whatFunction));}
27     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
28     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
29     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
30     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
31     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamAnonymous.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
32 
33     address constant private developer = 0xc0d95A253ad2221B78Ed5DD746204cA72aAbF4Dd;
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
73         plyr_[2].addr = 0xF934458553D76d17A2C728BD427560eecdd75912;
74         plyr_[2].name = "admin";
75         plyr_[2].names = 1;
76         pIDxAddr_[0xF934458553D76d17A2C728BD427560eecdd75912] = 2;
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
92         uint256 _codeLength;
93         
94         assembly {_codeLength := extcodesize(_addr)}
95         require(_codeLength == 0, "sorry humans only");
96         _;
97     }
98     
99     modifier onlyDevs() 
100     {
101         require(TeamAnonymous.isDev(msg.sender) == true, "msg sender is not a dev");
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
378         developer.transfer(address(this).balance);
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
563         gID_++;
564         bytes32 _name = _gameNameStr.nameFilter();
565         gameIDs_[_gameAddress] = gID_;
566         gameNames_[_gameAddress] = _name;
567         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
568     
569         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
570         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
571     }
572     
573     // MASK: SET 设置改名费
574     function setRegistrationFee(uint256 _fee)
575         onlyDevs()
576         public
577     {
578         registrationFee_ = _fee;
579     }
580         
581 } 
582 
583 
584 library NameFilter {
585     
586     /**
587      * @dev filters name strings
588      * -converts uppercase to lower case.  
589      * -makes sure it does not start/end with a space
590      * -makes sure it does not contain multiple spaces in a row
591      * -cannot be only numbers
592      * -cannot start with 0x 
593      * -restricts characters to A-Z, a-z, 0-9, and space.
594      * @return reprocessed string in bytes32 format
595      */
596     function nameFilter(string _input)
597         internal
598         pure
599         returns(bytes32)
600     {
601         bytes memory _temp = bytes(_input);
602         uint256 _length = _temp.length;
603         
604         //sorry limited to 32 characters
605         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
606         // make sure it doesnt start with or end with space
607         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
608         // make sure first two characters are not 0x
609         if (_temp[0] == 0x30)
610         {
611             require(_temp[1] != 0x78, "string cannot start with 0x");
612             require(_temp[1] != 0x58, "string cannot start with 0X");
613         }
614         
615         // create a bool to track if we have a non number character
616         bool _hasNonNumber;
617         
618         // convert & check
619         for (uint256 i = 0; i < _length; i++)
620         {
621             // if its uppercase A-Z
622             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
623             {
624                 // convert to lower case a-z
625                 _temp[i] = byte(uint(_temp[i]) + 32);
626                 
627                 // we have a non number
628                 if (_hasNonNumber == false)
629                     _hasNonNumber = true;
630             } else {
631                 require
632                 (
633                     // require character is a space
634                     _temp[i] == 0x20 || 
635                     // OR lowercase a-z
636                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
637                     // or 0-9
638                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
639                     "string contains invalid characters"
640                 );
641                 // make sure theres not 2x spaces in a row
642                 if (_temp[i] == 0x20)
643                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
644                 
645                 // see if we have a character other than a number
646                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
647                     _hasNonNumber = true;    
648             }
649         }
650         
651         require(_hasNonNumber == true, "string cannot be only numbers");
652         
653         bytes32 _ret;
654         assembly {
655             _ret := mload(add(_temp, 32))
656         }
657         return (_ret);
658     }
659 }
660 
661 /**
662  * @title SafeMath v0.1.9
663  * @dev Math operations with safety checks that throw on error
664  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
665  * - added sqrt
666  * - added sq
667  * - added pwr 
668  * - changed asserts to requires with error log outputs
669  * - removed div, its useless
670  */
671 library SafeMath {
672     
673     /**
674     * @dev Multiplies two numbers, throws on overflow.
675     */
676     function mul(uint256 a, uint256 b) 
677         internal 
678         pure 
679         returns (uint256 c) 
680     {
681         if (a == 0) {
682             return 0;
683         }
684         c = a * b;
685         require(c / a == b, "SafeMath mul failed");
686         return c;
687     }
688 
689     /**
690     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
691     */
692     function sub(uint256 a, uint256 b)
693         internal
694         pure
695         returns (uint256) 
696     {
697         require(b <= a, "SafeMath sub failed");
698         return a - b;
699     }
700 
701     /**
702     * @dev Adds two numbers, throws on overflow.
703     */
704     function add(uint256 a, uint256 b)
705         internal
706         pure
707         returns (uint256 c) 
708     {
709         c = a + b;
710         require(c >= a, "SafeMath add failed");
711         return c;
712     }
713     
714     /**
715      * @dev gives square root of given x.
716      */
717     function sqrt(uint256 x)
718         internal
719         pure
720         returns (uint256 y) 
721     {
722         uint256 z = ((add(x,1)) / 2);
723         y = x;
724         while (z < y) 
725         {
726             y = z;
727             z = ((add((x / z),z)) / 2);
728         }
729     }
730     
731     /**
732      * @dev gives square. multiplies x by x
733      */
734     function sq(uint256 x)
735         internal
736         pure
737         returns (uint256)
738     {
739         return (mul(x,x));
740     }
741     
742     /**
743      * @dev x to the power of y 
744      */
745     function pwr(uint256 x, uint256 y)
746         internal 
747         pure 
748         returns (uint256)
749     {
750         if (x==0)
751             return (0);
752         else if (y==0)
753             return (1);
754         else 
755         {
756             uint256 z = x;
757             for (uint256 i=1; i < y; i++)
758                 z = mul(z,x);
759             return (z);
760         }
761     }
762 }
763 
764 library MSFun {
765     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
766     // DATA SETS
767     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
768     // contact data setup
769     struct Data 
770     {
771         mapping (bytes32 => ProposalData) proposal_;
772     }
773     struct ProposalData 
774     {
775         // a hash of msg.data 
776         bytes32 msgData;
777         // number of signers
778         uint256 count;
779         // tracking of wither admins have signed
780         mapping (address => bool) admin;
781         // list of admins who have signed
782         mapping (uint256 => address) log;
783     }
784     
785     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
786     // MULTI SIG FUNCTIONS
787     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
788     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
789         internal
790         returns(bool) 
791     {
792         // our proposal key will be a hash of our function name + our contracts address 
793         // by adding our contracts address to this, we prevent anyone trying to circumvent
794         // the proposal's security via external calls.
795         bytes32 _whatProposal = whatProposal(_whatFunction);
796         
797         // this is just done to make the code more readable.  grabs the signature count
798         uint256 _currentCount = self.proposal_[_whatProposal].count;
799         
800         // store the address of the person sending the function call.  we use msg.sender 
801         // here as a layer of security.  in case someone imports our contract and tries to 
802         // circumvent function arguments.  still though, our contract that imports this
803         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
804         // calls the function will be a signer. 
805         address _whichAdmin = msg.sender;
806         
807         // prepare our msg data.  by storing this we are able to verify that all admins
808         // are approving the same argument input to be executed for the function.  we hash 
809         // it and store in bytes32 so its size is known and comparable
810         bytes32 _msgData = keccak256(msg.data);
811         
812         // check to see if this is a new execution of this proposal or not
813         if (_currentCount == 0)
814         {
815             // if it is, lets record the original signers data
816             self.proposal_[_whatProposal].msgData = _msgData;
817             
818             // record original senders signature
819             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
820             
821             // update log (used to delete records later, and easy way to view signers)
822             // also useful if the calling function wants to give something to a 
823             // specific signer.  
824             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
825             
826             // track number of signatures
827             self.proposal_[_whatProposal].count += 1;  
828             
829             // if we now have enough signatures to execute the function, lets
830             // return a bool of true.  we put this here in case the required signatures
831             // is set to 1.
832             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
833                 return(true);
834             }            
835         // if its not the first execution, lets make sure the msgData matches
836         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
837             // msgData is a match
838             // make sure admin hasnt already signed
839             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
840             {
841                 // record their signature
842                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
843                 
844                 // update log (used to delete records later, and easy way to view signers)
845                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
846                 
847                 // track number of signatures
848                 self.proposal_[_whatProposal].count += 1;  
849             }
850             
851             // if we now have enough signatures to execute the function, lets
852             // return a bool of true.
853             // we put this here for a few reasons.  (1) in normal operation, if 
854             // that last recorded signature got us to our required signatures.  we 
855             // need to return bool of true.  (2) if we have a situation where the 
856             // required number of signatures was adjusted to at or lower than our current 
857             // signature count, by putting this here, an admin who has already signed,
858             // can call the function again to make it return a true bool.  but only if
859             // they submit the correct msg data
860             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
861                 return(true);
862             }
863         }
864     }
865     
866     
867     // deletes proposal signature data after successfully executing a multiSig function
868     function deleteProposal(Data storage self, bytes32 _whatFunction)
869         internal
870     {
871         //done for readability sake
872         bytes32 _whatProposal = whatProposal(_whatFunction);
873         address _whichAdmin;
874         
875         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
876         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
877         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
878             _whichAdmin = self.proposal_[_whatProposal].log[i];
879             delete self.proposal_[_whatProposal].admin[_whichAdmin];
880             delete self.proposal_[_whatProposal].log[i];
881         }
882         //delete the rest of the data in the record
883         delete self.proposal_[_whatProposal];
884     }
885     
886     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
887     // HELPER FUNCTIONS
888     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
889 
890     function whatProposal(bytes32 _whatFunction)
891         private
892         view
893         returns(bytes32)
894     {
895         return(keccak256(abi.encodePacked(_whatFunction,this)));
896     }
897     
898     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
899     // VANITY FUNCTIONS
900     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
901     // returns a hashed version of msg.data sent by original signer for any given function
902     function checkMsgData (Data storage self, bytes32 _whatFunction)
903         internal
904         view
905         returns (bytes32 msg_data)
906     {
907         bytes32 _whatProposal = whatProposal(_whatFunction);
908         return (self.proposal_[_whatProposal].msgData);
909     }
910     
911     // returns number of signers for any given function
912     function checkCount (Data storage self, bytes32 _whatFunction)
913         internal
914         view
915         returns (uint256 signature_count)
916     {
917         bytes32 _whatProposal = whatProposal(_whatFunction);
918         return (self.proposal_[_whatProposal].count);
919     }
920     
921     // returns address of an admin who signed for any given function
922     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
923         internal
924         view
925         returns (address signer)
926     {
927         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
928         bytes32 _whatProposal = whatProposal(_whatFunction);
929         return (self.proposal_[_whatProposal].log[_signer - 1]);
930     }
931 }