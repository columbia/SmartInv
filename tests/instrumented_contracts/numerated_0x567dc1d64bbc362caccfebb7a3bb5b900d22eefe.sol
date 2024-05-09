1 pragma solidity ^0.4.24;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr 
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16     
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) 
21         internal 
22         pure 
23         returns (uint256 c) 
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b > 0);
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256 c) 
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67     
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72         internal
73         pure
74         returns (uint256 y) 
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y) 
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84     
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89         internal
90         pure
91         returns (uint256)
92     {
93         return (mul(x,x));
94     }
95     
96     /**
97      * @dev x to the power of y 
98      */
99     function pwr(uint256 x, uint256 y)
100         internal 
101         pure 
102         returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else 
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 
118 // File: contracts/library/NameFilter.sol
119 
120 library NameFilter {
121     /**
122      * @dev filters name strings
123      * -converts uppercase to lower case.  
124      * -makes sure it does not start/end with a space
125      * -makes sure it does not contain multiple spaces in a row
126      * -cannot be only numbers
127      * -cannot start with 0x 
128      * -restricts characters to A-Z, a-z, 0-9, and space.
129      * @return reprocessed string in bytes32 format
130      */
131     function nameFilter(string _input)
132         internal
133         pure
134         returns(bytes32)
135     {
136         bytes memory _temp = bytes(_input);
137         uint256 _length = _temp.length;
138         
139         //sorry limited to 32 characters
140         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
141         // make sure it doesnt start with or end with space
142         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
143         // make sure first two characters are not 0x
144         if (_temp[0] == 0x30)
145         {
146             require(_temp[1] != 0x78, "string cannot start with 0x");
147             require(_temp[1] != 0x58, "string cannot start with 0X");
148         }
149         
150         // create a bool to track if we have a non number character
151         bool _hasNonNumber;
152         
153         // convert & check
154         for (uint256 i = 0; i < _length; i++)
155         {
156             // if its uppercase A-Z
157             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
158             {
159                 // convert to lower case a-z
160                 _temp[i] = byte(uint(_temp[i]) + 32);
161                 
162                 // we have a non number
163                 if (_hasNonNumber == false)
164                     _hasNonNumber = true;
165             } else {
166                 require
167                 (
168                     // require character is a space
169                     _temp[i] == 0x20 || 
170                     // OR lowercase a-z
171                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
172                     // or 0-9
173                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
174                     "string contains invalid characters"
175                 );
176                 // make sure theres not 2x spaces in a row
177                 if (_temp[i] == 0x20)
178                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
179                 
180                 // see if we have a character other than a number
181                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
182                     _hasNonNumber = true;    
183             }
184         }
185         
186         require(_hasNonNumber == true, "string cannot be only numbers");
187         
188         bytes32 _ret;
189         assembly {
190             _ret := mload(add(_temp, 32))
191         }
192         return (_ret);
193     }
194 }
195 
196 // File: contracts/interface/PlayerBookReceiverInterface.sol
197 
198 interface PlayerBookReceiverInterface {
199     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name) external;
200     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
201 }
202 
203 // File: contracts/PlayerBook.sol
204 
205 contract PlayerBook {
206     using NameFilter for string;
207     using SafeMath for uint256;
208 
209     address public owner;
210 
211     uint256 public registrationFee_ = 10 finney;            // price to register a name
212 
213     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
214     mapping(address => bytes32) public gameNames_;          // lookup a games name
215     mapping(address => uint256) public gameIDs_;            // lokup a games ID
216 
217     uint256 public gID_;        // total number of games
218     uint256 public pID_;        // total number of players
219 
220     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
221     mapping(bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
222     mapping(uint256 => Player) public plyr_;               // (pID => data) player data
223     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
224     mapping(uint256 => mapping(uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
225 
226     struct Player {
227         address addr;
228         bytes32 name;
229         uint256 laff;
230         uint256 names;
231     }
232 
233     constructor()
234         public
235     {
236         owner = msg.sender;
237 
238         // premine the dev names
239         // No keys are purchased with this method, it's simply locking our addresses,
240         // PID's and names for referral codes.
241         plyr_[1].addr = 0x36653dE42a90b53785Fa592E4C1b9498fd9Fd72d;
242         plyr_[1].name = "wyx";
243         plyr_[1].names = 1;
244         pIDxAddr_[0x36653dE42a90b53785Fa592E4C1b9498fd9Fd72d] = 1;
245         pIDxName_["wyx"] = 1;
246         plyrNames_[1]["wyx"] = true;
247         plyrNameList_[1][1] = "wyx";
248 
249         pID_ = 1;
250     }
251 
252     modifier onlyOwner {
253         assert(owner == msg.sender);
254         _;
255     }
256 
257     /**
258      * @dev prevents contracts from interacting with ReserveBag 
259      */
260     modifier isHuman() {
261         address _addr = msg.sender;
262         require (_addr == tx.origin);
263 
264         uint256 _codeLength;
265 
266         assembly {_codeLength := extcodesize(_addr)}
267         require(_codeLength == 0, "sorry humans only");
268         _;
269     }
270 
271     modifier isRegisteredGame()
272     {
273         require(gameIDs_[msg.sender] != 0);
274         _;
275     }
276 
277     // fired whenever a player registers a name
278     event onNewName
279     (
280         uint256 indexed playerID,
281         address indexed playerAddress,
282         bytes32 indexed playerName,
283         bool isNewPlayer,
284         uint256 affiliateID,
285         address affiliateAddress,
286         bytes32 affiliateName,
287         uint256 amountPaid,
288         uint256 timeStamp
289     );
290 
291     // (for UI & viewing things on etherscan)
292     function checkIfNameValid(string _nameStr)
293         public
294         view
295         returns(bool)
296     {
297         bytes32 _name = _nameStr.nameFilter();
298         if(pIDxName_[_name] == 0)
299             return true;
300         else
301             return false;
302     }
303 
304 // public functions ====================================
305     /**
306      * @dev registers a name.  UI will always display the last name you registered.
307      * but you will still own all previously registered names to use as affiliate 
308      * links.
309      * - must pay a registration fee.
310      * - name must be unique
311      * - names will be converted to lowercase
312      * - name cannot start or end with a space 
313      * - cannot have more than 1 space in a row
314      * - cannot be only numbers
315      * - cannot start with 0x 
316      * - name must be at least 1 char
317      * - max length of 32 characters long
318      * - allowed characters: a-z, 0-9, and space
319      * -functionhash- 0x921dec21 (using ID for affiliate)
320      * -functionhash- 0x3ddd4698 (using address for affiliate)
321      * -functionhash- 0x685ffd83 (using name for affiliate)
322      * @param _nameString players desired name
323      * @param _affCode affiliate ID, address, or name of who refered you
324      * @param _all set to true if you want this to push your info to all games 
325      * (this might cost a lot of gas)
326      */
327     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
328         isHuman()
329         public
330         payable
331     {
332         // make sure name fees paid
333         require(msg.value >= registrationFee_, "you have to pay the name fee");
334 
335         // filter name + condition checks
336         bytes32 _name = NameFilter.nameFilter(_nameString);
337 
338         // set up address 
339         address _addr = msg.sender;
340 
341         // determine if player is new or not
342         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
343 
344         // manage affiliate residuals
345         // if no affiliate code was given, no new affiliate code was given, or the 
346         // player tried to use their own pID as an affiliate code, lolz
347         if(_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
348             // update last affiliate 
349             plyr_[_pID].laff = _affCode;
350         } else if(_affCode == _pID) {
351             _affCode = 0;
352         }
353 
354         // register name 
355         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
356     }
357 
358     function registerNameXaddr(string _nameString, address _affCode, bool _all)
359         isHuman()
360         public
361         payable
362     {
363         // make sure name fees paid
364         require(msg.value >= registrationFee_, "you have to pay the name fee");
365 
366         // filter name + condition checks
367         bytes32 _name = NameFilter.nameFilter(_nameString);
368 
369         // set up address 
370         address _addr = msg.sender;
371 
372         // determine if player is new or not
373         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
374 
375         // manage affiliate residuals
376         // if no affiliate code was given or player tried to use their own, lolz
377         uint256 _affID;
378         if(_affCode != address(0) && _affCode != _addr) {
379             // get affiliate ID from aff Code 
380             _affID = pIDxAddr_[_affCode];
381 
382             // if affID is not the same as previously stored 
383             if(_affID != plyr_[_pID].laff) {
384                 // update last affiliate
385                 plyr_[_pID].laff = _affID;
386             }
387         }
388 
389         // register name 
390         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
391     }
392 
393     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
394         isHuman()
395         public
396         payable 
397     {
398         // make sure name fees paid
399         require(msg.value >= registrationFee_, "you have to pay the name fee");
400 
401         // filter name + condition checks
402         bytes32 _name = NameFilter.nameFilter(_nameString);
403 
404         // set up address 
405         address _addr = msg.sender;
406 
407         // determine if player is new or not
408         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
409 
410         // manage affiliate residuals
411         // if no affiliate code was given or player tried to use their own, lolz
412         uint256 _affID;
413         if(_affCode != "" && _affCode != _name) {
414             // get affiliate ID from aff Code 
415             _affID = pIDxName_[_affCode];
416 
417             // if affID is not the same as previously stored 
418             if(_affID != plyr_[_pID].laff) {
419                 // update last affiliate
420                 plyr_[_pID].laff = _affID;
421             }
422         }
423 
424         // register name 
425         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
426     }
427 
428     /**
429      * @dev players, if you registered a profile, before a game was released, or
430      * set the all bool to false when you registered, use this function to push
431      * your profile to a single game.  also, if you've  updated your name, you
432      * can use this to push your name to games of your choosing.
433      * -functionhash- 0x81c5b206
434      * @param _gameID game id 
435      */
436     function addMeToGame(uint256 _gameID)
437         isHuman()
438         public
439     {
440         require(gID_ > 0 && _gameID <= gID_, "that game doesn't exist yet");
441 
442         address _addr = msg.sender;
443 
444         uint256 _pID = pIDxAddr_[_addr];
445         require(_pID != 0, "you dont even have an account");
446 
447         uint256 _totalNames = plyr_[_pID].names;
448 
449         // add players profile and most recent name
450         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name);
451 
452         // add list of all names
453         if(_totalNames > 1) {
454             for (uint256 j = 1; j <= _totalNames; j++) {
455                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][j]);
456             }
457         }
458     }
459 
460     /**
461      * @dev players, use this to push your player profile to all registered games.
462      * -functionhash- 0x0c6940ea
463      */
464     function addMeToAllGames()
465         isHuman()
466         public
467     {
468         address _addr = msg.sender;
469 
470         uint256 _pID = pIDxAddr_[_addr];
471         require(_pID != 0, "you dont even have an account");
472 
473         // uint256 _laff = plyr_[_pID].laff;
474         uint256 _totalNames = plyr_[_pID].names;
475         bytes32 _name = plyr_[_pID].name;
476 
477         for(uint256 i = 1; i <= gID_; i++) {
478             games_[i].receivePlayerInfo(_pID, _addr, _name);
479             if(_totalNames > 1) {
480                 for(uint256 j = 1; j <= _totalNames; j++) {
481                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][j]);
482                 }
483             }
484         }
485     }
486 
487     /**
488      * @dev players use this to change back to one of your old names.  tip, you'll
489      * still need to push that info to existing games.
490      * -functionhash- 0xb9291296
491      * @param _nameString the name you want to use 
492      */
493     function useMyOldName(string _nameString)
494         isHuman()
495         public 
496     {
497         // filter name, and get pID
498         bytes32 _name = _nameString.nameFilter();
499         uint256 _pID = pIDxAddr_[msg.sender];
500 
501         // make sure they own the name 
502         require(plyrNames_[_pID][_name], "thats not a name you own");
503 
504         // update their current name 
505         plyr_[_pID].name = _name;
506     }
507 
508 // core logic =========================================
509     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
510         private
511     {
512         // if names already has been used, require that current msg sender owns the name
513         if(pIDxName_[_name] != 0) {
514             require(plyrNames_[_pID][_name], "that name already taken");
515         }
516 
517         // add name to player profile, registry, and name book
518         plyr_[_pID].name = _name;
519         pIDxName_[_name] = _pID;
520         if(!plyrNames_[_pID][_name]) {
521             plyrNames_[_pID][_name] = true;
522             // plyr_[_pID].names++;
523             uint256 namesCount = plyr_[_pID].names + 1;
524             plyr_[_pID].names = namesCount;
525             plyrNameList_[_pID][namesCount] = _name;
526         }
527 
528         // registration fee goes directly to contract owner
529         owner.transfer(msg.value);
530 
531         // push player info to games
532         if(_all) {
533             for(uint256 i = 1; i <= gID_; i++) {
534                 games_[i].receivePlayerInfo(_pID, _addr, _name);
535             }
536         }
537 
538         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
539     }
540 
541 // tools ===============================================
542 // return pid & new player flag
543     function determinePID(address _addr)
544         private
545         returns(uint256, bool)
546     {
547         uint256 _pid = pIDxAddr_[_addr];
548         if(_pid == 0)
549         {
550             pID_++;
551             pIDxAddr_[_addr] = pID_;
552             plyr_[pID_].addr = _addr;
553 
554             return (pID_, true);
555         } else {
556             return (_pid, false);
557         }
558     }
559 
560 // external calls =====================================
561     function getPlayerID(address _addr)
562         isRegisteredGame()
563         external
564         returns (uint256)
565     {
566         (uint256 _pid, ) = determinePID(_addr);
567         return _pid;
568     }
569 
570     function getPlayerName(uint256 _pID)
571         external
572         view
573         returns(bytes32)
574     {
575         return plyr_[_pID].name;
576     }
577 
578     function getPlayerLAff(uint256 _pID)
579         external
580         view
581         returns(uint256)
582     {
583         return plyr_[_pID].laff;
584     }
585 
586     function getPlayerAddr(uint256 _pID)
587         external
588         view
589         returns(address)
590     {
591         return plyr_[_pID].addr;
592     }
593 
594     function getNameFee()
595         external
596         view
597         returns(uint256)
598     {
599         return registrationFee_;
600     }
601 
602     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
603         isRegisteredGame()
604         external
605         payable
606         returns(bool, uint256)
607     {
608         // make sure name fees paid
609         require(msg.value >= registrationFee_, "you have to pay the name fee");
610 
611         // determine if player is new or not
612         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
613 
614         // manage affiliate residuals
615         // if no affiliate code was given, no new affiliate code was given, or the 
616         // player tried to use their own pID as an affiliate code, lolz
617         uint256 _affID = _affCode;
618         if(_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
619         {
620             // update last affiliate 
621             plyr_[_pID].laff = _affID;
622         } else if(_affID == _pID) {
623             _affID = 0;
624         }
625 
626         // register name 
627         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
628 
629         return (_isNewPlayer, _affID);
630     }
631 
632     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
633         isRegisteredGame()
634         external
635         payable
636         returns(bool, uint256)
637     {
638         // make sure name fees paid
639         require(msg.value >= registrationFee_, "you have to pay the name fee");
640 
641         // determine if player is new or not
642         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
643 
644         // manage affiliate residuals
645         // if no affiliate code was given or player tried to use their own, lolz
646         uint256 _affID;
647         if(_affCode != address(0) && _affCode != _addr)
648         {
649             // get affiliate ID from aff Code 
650             _affID = pIDxAddr_[_affCode];
651             
652             // if affID is not the same as previously stored 
653             if(_affID != plyr_[_pID].laff)
654             {
655                 // update last affiliate
656                 plyr_[_pID].laff = _affID;
657             }
658         }
659 
660         // register name 
661         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
662         
663         return (_isNewPlayer, _affID);
664     }
665 
666     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
667         isRegisteredGame()
668         external
669         payable
670         returns(bool, uint256)
671     {
672         // make sure name fees paid
673         require(msg.value >= registrationFee_, "you have to pay the name fee");
674 
675         // determine if player is new or not
676         (uint256 _pID, bool _isNewPlayer) = determinePID(_addr);
677 
678         // manage affiliate residuals
679         // if no affiliate code was given or player tried to use their own, lolz
680         uint256 _affID;
681         if(_affCode != "" && _affCode != _name)
682         {
683             // get affiliate ID from aff Code 
684             _affID = pIDxName_[_affCode];
685             
686             // if affID is not the same as previously stored 
687             if(_affID != plyr_[_pID].laff)
688             {
689                 // update last affiliate
690                 plyr_[_pID].laff = _affID;
691             }
692         }
693 
694         // register name 
695         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
696 
697         return(_isNewPlayer, _affID);
698     }
699 
700 // setup ==================================
701     function addGame(address _gameAddress, string _gameNameStr)
702         onlyOwner()
703         public
704     {
705         require(gameIDs_[_gameAddress] == 0, "that games already been registered");
706 
707         gID_++;
708         bytes32 _name = _gameNameStr.nameFilter();
709         gameIDs_[_gameAddress] = gID_;
710         gameNames_[_gameAddress] = _name;
711         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
712 
713         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name);
714     }
715 
716     function setRegistrationFee(uint256 _fee)
717         onlyOwner()
718         public
719     {
720         registrationFee_ = _fee;
721     }
722 }