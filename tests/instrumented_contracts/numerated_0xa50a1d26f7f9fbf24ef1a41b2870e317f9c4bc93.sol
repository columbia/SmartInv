1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 contract PlayerBook {
9     using NameFilter for string;
10     using SafeMath for uint256;
11 
12     MSFun.Data private msData;
13     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
14     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
15     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
16     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
17     //==============================================================================
18     //     _| _ _|_ _    _ _ _|_    _   .
19     //    (_|(_| | (_|  _\(/_ | |_||_)  .
20     //=============================|================================================
21     address private adminAddress;
22     uint256 public registrationFee_ = 10 finney;            // price to register a name
23     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
24     mapping(address => bytes32) public gameNames_;          // lookup a games name
25     mapping(address => uint256) public gameIDs_;            // lokup a games ID
26     uint256 public gID_;        // total number of games
27     uint256 public pID_;        // total number of players
28     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
29     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
30     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
31     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
32     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
33     struct Player {
34         address addr;
35         bytes32 name;
36         uint256 laff;
37         uint256 names;
38     }
39     //==============================================================================
40     //     _ _  _  __|_ _    __|_ _  _  .
41     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
42     //==============================================================================
43     constructor()
44     public
45     {
46         adminAddress = msg.sender;
47         // premine the dev names (sorry not sorry)
48         // No keys are purchased with this method, it's simply locking our addresses,
49         // PID's and names for referral codes.
50         plyr_[1].addr = adminAddress;
51         plyr_[1].name = "inventor";
52         plyr_[1].names = 1;
53         pIDxAddr_[adminAddress] = 1;
54         pIDxName_["inventor"] = 1;
55         plyrNames_[1]["inventor"] = true;
56         plyrNameList_[1][1] = "inventor";
57 
58         pID_ = 1;
59     }
60     //==============================================================================
61     //     _ _  _  _|. |`. _  _ _  .
62     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
63     //==============================================================================
64     /**
65      * @dev prevents contracts from interacting with fomo3d
66      */
67     modifier isHuman() {
68         address _addr = msg.sender;
69         uint256 _codeLength;
70 
71         assembly {_codeLength := extcodesize(_addr)}
72         require(_codeLength == 0, "sorry humans only");
73         _;
74     }
75 
76     modifier onlyDevs()
77     {
78         require(msg.sender == adminAddress, "msg sender is not a dev");
79         _;
80     }
81 
82     modifier isRegisteredGame()
83     {
84         require(gameIDs_[msg.sender] != 0);
85         _;
86     }
87     //==============================================================================
88     //     _    _  _ _|_ _  .
89     //    (/_\/(/_| | | _\  .
90     //==============================================================================
91     // fired whenever a player registers a name
92     event onNewName
93     (
94         uint256 indexed playerID,
95         address indexed playerAddress,
96         bytes32 indexed playerName,
97         bool isNewPlayer,
98         uint256 affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 amountPaid,
102         uint256 timeStamp
103     );
104     //==============================================================================
105     //     _  _ _|__|_ _  _ _  .
106     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
107     //=====_|=======================================================================
108     function checkIfNameValid(string _nameStr)
109     public
110     view
111     returns(bool)
112     {
113         bytes32 _name = _nameStr.nameFilter();
114         if (pIDxName_[_name] == 0)
115             return (true);
116         else
117             return (false);
118     }
119     //==============================================================================
120     //     _    |_ |. _   |`    _  __|_. _  _  _  .
121     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
122     //====|=========================================================================
123     /**
124      * @dev registers a name.  UI will always display the last name you registered.
125      * but you will still own all previously registered names to use as affiliate
126      * links.
127      * - must pay a registration fee.
128      * - name must be unique
129      * - names will be converted to lowercase
130      * - name cannot start or end with a space
131      * - cannot have more than 1 space in a row
132      * - cannot be only numbers
133      * - cannot start with 0x
134      * - name must be at least 1 char
135      * - max length of 32 characters long
136      * - allowed characters: a-z, 0-9, and space
137      * -functionhash- 0x921dec21 (using ID for affiliate)
138      * -functionhash- 0x3ddd4698 (using address for affiliate)
139      * -functionhash- 0x685ffd83 (using name for affiliate)
140      * @param _nameString players desired name
141      * @param _affCode affiliate ID, address, or name of who refered you
142      * @param _all set to true if you want this to push your info to all games
143      * (this might cost a lot of gas)
144      */
145     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
146     isHuman()
147     public
148     payable
149     {
150         // make sure name fees paid
151         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
152 
153         // filter name + condition checks
154         bytes32 _name = NameFilter.nameFilter(_nameString);
155 
156         // set up address
157         address _addr = msg.sender;
158 
159         // set up our tx event data and determine if player is new or not
160         bool _isNewPlayer = determinePID(_addr);
161 
162         // fetch player id
163         uint256 _pID = pIDxAddr_[_addr];
164 
165         // manage affiliate residuals
166         // if no affiliate code was given, no new affiliate code was given, or the
167         // player tried to use their own pID as an affiliate code, lolz
168         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
169         {
170             // update last affiliate
171             plyr_[_pID].laff = _affCode;
172         } else if (_affCode == _pID) {
173             _affCode = 0;
174         }
175 
176         // register name
177         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
178     }
179 
180     function registerNameXaddr(string _nameString, address _affCode, bool _all)
181     isHuman()
182     public
183     payable
184     {
185         // make sure name fees paid
186         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
187 
188         // filter name + condition checks
189         bytes32 _name = NameFilter.nameFilter(_nameString);
190 
191         // set up address
192         address _addr = msg.sender;
193 
194         // set up our tx event data and determine if player is new or not
195         bool _isNewPlayer = determinePID(_addr);
196 
197         // fetch player id
198         uint256 _pID = pIDxAddr_[_addr];
199 
200         // manage affiliate residuals
201         // if no affiliate code was given or player tried to use their own, lolz
202         uint256 _affID;
203         if (_affCode != address(0) && _affCode != _addr)
204         {
205             // get affiliate ID from aff Code
206             _affID = pIDxAddr_[_affCode];
207 
208             // if affID is not the same as previously stored
209             if (_affID != plyr_[_pID].laff)
210             {
211                 // update last affiliate
212                 plyr_[_pID].laff = _affID;
213             }
214         }
215 
216         // register name
217         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
218     }
219 
220     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
221     isHuman()
222     public
223     payable
224     {
225         // make sure name fees paid
226         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
227 
228         // filter name + condition checks
229         bytes32 _name = NameFilter.nameFilter(_nameString);
230 
231         // set up address
232         address _addr = msg.sender;
233 
234         // set up our tx event data and determine if player is new or not
235         bool _isNewPlayer = determinePID(_addr);
236 
237         // fetch player id
238         uint256 _pID = pIDxAddr_[_addr];
239 
240         // manage affiliate residuals
241         // if no affiliate code was given or player tried to use their own, lolz
242         uint256 _affID;
243         if (_affCode != "" && _affCode != _name)
244         {
245             // get affiliate ID from aff Code
246             _affID = pIDxName_[_affCode];
247 
248             // if affID is not the same as previously stored
249             if (_affID != plyr_[_pID].laff)
250             {
251                 // update last affiliate
252                 plyr_[_pID].laff = _affID;
253             }
254         }
255 
256         // register name
257         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
258     }
259 
260     /**
261      * @dev players, if you registered a profile, before a game was released, or
262      * set the all bool to false when you registered, use this function to push
263      * your profile to a single game.  also, if you've  updated your name, you
264      * can use this to push your name to games of your choosing.
265      * -functionhash- 0x81c5b206
266      * @param _gameID game id
267      */
268     function addMeToGame(uint256 _gameID)
269     isHuman()
270     public
271     {
272         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
273         address _addr = msg.sender;
274         uint256 _pID = pIDxAddr_[_addr];
275         require(_pID != 0, "hey there buddy, you dont even have an account");
276         uint256 _totalNames = plyr_[_pID].names;
277 
278         // add players profile and most recent name
279         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
280 
281         // add list of all names
282         if (_totalNames > 1)
283             for (uint256 ii = 1; ii <= _totalNames; ii++)
284                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
285     }
286 
287     /**
288      * @dev players, use this to push your player profile to all registered games.
289      * -functionhash- 0x0c6940ea
290      */
291     function addMeToAllGames()
292     isHuman()
293     public
294     {
295         address _addr = msg.sender;
296         uint256 _pID = pIDxAddr_[_addr];
297         require(_pID != 0, "hey there buddy, you dont even have an account");
298         uint256 _laff = plyr_[_pID].laff;
299         uint256 _totalNames = plyr_[_pID].names;
300         bytes32 _name = plyr_[_pID].name;
301 
302         for (uint256 i = 1; i <= gID_; i++)
303         {
304             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
305             if (_totalNames > 1)
306                 for (uint256 ii = 1; ii <= _totalNames; ii++)
307                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
308         }
309 
310     }
311 
312     /**
313      * @dev players use this to change back to one of your old names.  tip, you'll
314      * still need to push that info to existing games.
315      * -functionhash- 0xb9291296
316      * @param _nameString the name you want to use
317      */
318     function useMyOldName(string _nameString)
319     isHuman()
320     public
321     {
322         // filter name, and get pID
323         bytes32 _name = _nameString.nameFilter();
324         uint256 _pID = pIDxAddr_[msg.sender];
325 
326         // make sure they own the name
327         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
328 
329         // update their current name
330         plyr_[_pID].name = _name;
331     }
332 
333     //==============================================================================
334     //     _ _  _ _   | _  _ . _  .
335     //    (_(_)| (/_  |(_)(_||(_  .
336     //=====================_|=======================================================
337     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
338     private
339     {
340         // if names already has been used, require that current msg sender owns the name
341         if (pIDxName_[_name] != 0)
342             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
343 
344         // add name to player profile, registry, and name book
345         plyr_[_pID].name = _name;
346         pIDxName_[_name] = _pID;
347         if (plyrNames_[_pID][_name] == false)
348         {
349             plyrNames_[_pID][_name] = true;
350             plyr_[_pID].names++;
351             plyrNameList_[_pID][plyr_[_pID].names] = _name;
352         }
353 
354         adminAddress.transfer(address(this).balance);
355 
356         // push player info to games
357         if (_all == true)
358             for (uint256 i = 1; i <= gID_; i++)
359                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
360 
361         // fire event
362         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
363     }
364     //==============================================================================
365     //    _|_ _  _ | _  .
366     //     | (_)(_)|_\  .
367     //==============================================================================
368     function determinePID(address _addr)
369     private
370     returns (bool)
371     {
372         if (pIDxAddr_[_addr] == 0)
373         {
374             pID_++;
375             pIDxAddr_[_addr] = pID_;
376             plyr_[pID_].addr = _addr;
377 
378             // set the new player bool to true
379             return (true);
380         } else {
381             return (false);
382         }
383     }
384     //==============================================================================
385     //   _   _|_ _  _ _  _ |   _ _ || _  .
386     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
387     //==============================================================================
388     function getPlayerID(address _addr)
389     isRegisteredGame()
390     external
391     returns (uint256)
392     {
393         determinePID(_addr);
394         return (pIDxAddr_[_addr]);
395     }
396     function getPlayerName(uint256 _pID)
397     external
398     view
399     returns (bytes32)
400     {
401         return (plyr_[_pID].name);
402     }
403     function getPlayerLAff(uint256 _pID)
404     external
405     view
406     returns (uint256)
407     {
408         return (plyr_[_pID].laff);
409     }
410     function getPlayerAddr(uint256 _pID)
411     external
412     view
413     returns (address)
414     {
415         return (plyr_[_pID].addr);
416     }
417     function getNameFee()
418     external
419     view
420     returns (uint256)
421     {
422         return(registrationFee_);
423     }
424     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
425     isRegisteredGame()
426     external
427     payable
428     returns(bool, uint256)
429     {
430         // make sure name fees paid
431         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
432 
433         // set up our tx event data and determine if player is new or not
434         bool _isNewPlayer = determinePID(_addr);
435 
436         // fetch player id
437         uint256 _pID = pIDxAddr_[_addr];
438 
439         // manage affiliate residuals
440         // if no affiliate code was given, no new affiliate code was given, or the
441         // player tried to use their own pID as an affiliate code, lolz
442         uint256 _affID = _affCode;
443         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
444         {
445             // update last affiliate
446             plyr_[_pID].laff = _affID;
447         } else if (_affID == _pID) {
448             _affID = 0;
449         }
450 
451         // register name
452         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
453 
454         return(_isNewPlayer, _affID);
455     }
456     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
457     isRegisteredGame()
458     external
459     payable
460     returns(bool, uint256)
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
472         // if no affiliate code was given or player tried to use their own, lolz
473         uint256 _affID;
474         if (_affCode != address(0) && _affCode != _addr)
475         {
476             // get affiliate ID from aff Code
477             _affID = pIDxAddr_[_affCode];
478 
479             // if affID is not the same as previously stored
480             if (_affID != plyr_[_pID].laff)
481             {
482                 // update last affiliate
483                 plyr_[_pID].laff = _affID;
484             }
485         }
486 
487         // register name
488         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
489 
490         return(_isNewPlayer, _affID);
491     }
492     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
493     isRegisteredGame()
494     external
495     payable
496     returns(bool, uint256)
497     {
498         // make sure name fees paid
499         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
500 
501         // set up our tx event data and determine if player is new or not
502         bool _isNewPlayer = determinePID(_addr);
503 
504         // fetch player id
505         uint256 _pID = pIDxAddr_[_addr];
506 
507         // manage affiliate residuals
508         // if no affiliate code was given or player tried to use their own, lolz
509         uint256 _affID;
510         if (_affCode != "" && _affCode != _name)
511         {
512             // get affiliate ID from aff Code
513             _affID = pIDxName_[_affCode];
514 
515             // if affID is not the same as previously stored
516             if (_affID != plyr_[_pID].laff)
517             {
518                 // update last affiliate
519                 plyr_[_pID].laff = _affID;
520             }
521         }
522 
523         // register name
524         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
525 
526         return(_isNewPlayer, _affID);
527     }
528 
529     function addGame(address _gameAddress, string _gameNameStr)
530     onlyDevs()
531     public
532     {
533         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
534 
535         gID_++;
536         bytes32 _name = _gameNameStr.nameFilter();
537         gameIDs_[_gameAddress] = gID_;
538         gameNames_[_gameAddress] = _name;
539         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
540 
541         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
542     }
543 }
544 
545 library NameFilter {
546 
547     /**
548      * @dev filters name strings
549      * -converts uppercase to lower case.
550      * -makes sure it does not start/end with a space
551      * -makes sure it does not contain multiple spaces in a row
552      * -cannot be only numbers
553      * -cannot start with 0x
554      * -restricts characters to A-Z, a-z, 0-9, and space.
555      * @return reprocessed string in bytes32 format
556      */
557     function nameFilter(string _input)
558     internal
559     pure
560     returns(bytes32)
561     {
562         bytes memory _temp = bytes(_input);
563         uint256 _length = _temp.length;
564 
565         //sorry limited to 32 characters
566         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
567         // make sure it doesnt start with or end with space
568         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
569         // make sure first two characters are not 0x
570         if (_temp[0] == 0x30)
571         {
572             require(_temp[1] != 0x78, "string cannot start with 0x");
573             require(_temp[1] != 0x58, "string cannot start with 0X");
574         }
575 
576         // create a bool to track if we have a non number character
577         bool _hasNonNumber;
578 
579         // convert & check
580         for (uint256 i = 0; i < _length; i++)
581         {
582             // if its uppercase A-Z
583             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
584             {
585                 // convert to lower case a-z
586                 _temp[i] = byte(uint(_temp[i]) + 32);
587 
588                 // we have a non number
589                 if (_hasNonNumber == false)
590                     _hasNonNumber = true;
591             } else {
592                 require
593                 (
594                 // require character is a space
595                     _temp[i] == 0x20 ||
596                 // OR lowercase a-z
597                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
598                 // or 0-9
599                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
600                     "string contains invalid characters"
601                 );
602                 // make sure theres not 2x spaces in a row
603                 if (_temp[i] == 0x20)
604                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
605 
606                 // see if we have a character other than a number
607                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
608                     _hasNonNumber = true;
609             }
610         }
611 
612         require(_hasNonNumber == true, "string cannot be only numbers");
613 
614         bytes32 _ret;
615         assembly {
616             _ret := mload(add(_temp, 32))
617         }
618         return (_ret);
619     }
620 }
621 
622 /**
623  * @title SafeMath v0.1.9
624  * @dev Math operations with safety checks that throw on error
625  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
626  * - added sqrt
627  * - added sq
628  * - added pwr
629  * - changed asserts to requires with error log outputs
630  * - removed div, its useless
631  */
632 library SafeMath {
633 
634     /**
635     * @dev Multiplies two numbers, throws on overflow.
636     */
637     function mul(uint256 a, uint256 b)
638     internal
639     pure
640     returns (uint256 c)
641     {
642         if (a == 0) {
643             return 0;
644         }
645         c = a * b;
646         require(c / a == b, "SafeMath mul failed");
647         return c;
648     }
649 
650     /**
651     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
652     */
653     function sub(uint256 a, uint256 b)
654     internal
655     pure
656     returns (uint256)
657     {
658         require(b <= a, "SafeMath sub failed");
659         return a - b;
660     }
661 
662     /**
663     * @dev Adds two numbers, throws on overflow.
664     */
665     function add(uint256 a, uint256 b)
666     internal
667     pure
668     returns (uint256 c)
669     {
670         c = a + b;
671         require(c >= a, "SafeMath add failed");
672         return c;
673     }
674 
675     /**
676      * @dev gives square root of given x.
677      */
678     function sqrt(uint256 x)
679     internal
680     pure
681     returns (uint256 y)
682     {
683         uint256 z = ((add(x,1)) / 2);
684         y = x;
685         while (z < y)
686         {
687             y = z;
688             z = ((add((x / z),z)) / 2);
689         }
690     }
691 
692     /**
693      * @dev gives square. multiplies x by x
694      */
695     function sq(uint256 x)
696     internal
697     pure
698     returns (uint256)
699     {
700         return (mul(x,x));
701     }
702 
703     /**
704      * @dev x to the power of y
705      */
706     function pwr(uint256 x, uint256 y)
707     internal
708     pure
709     returns (uint256)
710     {
711         if (x==0)
712             return (0);
713         else if (y==0)
714             return (1);
715         else
716         {
717             uint256 z = x;
718             for (uint256 i=1; i < y; i++)
719                 z = mul(z,x);
720             return (z);
721         }
722     }
723 }
724 
725 library MSFun {
726     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
727     // DATA SETS
728     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
729     // contact data setup
730     struct Data
731     {
732         mapping (bytes32 => ProposalData) proposal_;
733     }
734     struct ProposalData
735     {
736         // a hash of msg.data
737         bytes32 msgData;
738         // number of signers
739         uint256 count;
740         // tracking of wither admins have signed
741         mapping (address => bool) admin;
742         // list of admins who have signed
743         mapping (uint256 => address) log;
744     }
745 
746     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
747     // MULTI SIG FUNCTIONS
748     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
749     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
750     internal
751     returns(bool)
752     {
753         // our proposal key will be a hash of our function name + our contracts address
754         // by adding our contracts address to this, we prevent anyone trying to circumvent
755         // the proposal's security via external calls.
756         bytes32 _whatProposal = whatProposal(_whatFunction);
757 
758         // this is just done to make the code more readable.  grabs the signature count
759         uint256 _currentCount = self.proposal_[_whatProposal].count;
760 
761         // store the address of the person sending the function call.  we use msg.sender
762         // here as a layer of security.  in case someone imports our contract and tries to
763         // circumvent function arguments.  still though, our contract that imports this
764         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
765         // calls the function will be a signer.
766         address _whichAdmin = msg.sender;
767 
768         // prepare our msg data.  by storing this we are able to verify that all admins
769         // are approving the same argument input to be executed for the function.  we hash
770         // it and store in bytes32 so its size is known and comparable
771         bytes32 _msgData = keccak256(msg.data);
772 
773         // check to see if this is a new execution of this proposal or not
774         if (_currentCount == 0)
775         {
776             // if it is, lets record the original signers data
777             self.proposal_[_whatProposal].msgData = _msgData;
778 
779             // record original senders signature
780             self.proposal_[_whatProposal].admin[_whichAdmin] = true;
781 
782             // update log (used to delete records later, and easy way to view signers)
783             // also useful if the calling function wants to give something to a
784             // specific signer.
785             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;
786 
787             // track number of signatures
788             self.proposal_[_whatProposal].count += 1;
789 
790             // if we now have enough signatures to execute the function, lets
791             // return a bool of true.  we put this here in case the required signatures
792             // is set to 1.
793             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
794                 return(true);
795             }
796             // if its not the first execution, lets make sure the msgData matches
797         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
798             // msgData is a match
799             // make sure admin hasnt already signed
800             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false)
801             {
802                 // record their signature
803                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;
804 
805                 // update log (used to delete records later, and easy way to view signers)
806                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;
807 
808                 // track number of signatures
809                 self.proposal_[_whatProposal].count += 1;
810             }
811 
812             // if we now have enough signatures to execute the function, lets
813             // return a bool of true.
814             // we put this here for a few reasons.  (1) in normal operation, if
815             // that last recorded signature got us to our required signatures.  we
816             // need to return bool of true.  (2) if we have a situation where the
817             // required number of signatures was adjusted to at or lower than our current
818             // signature count, by putting this here, an admin who has already signed,
819             // can call the function again to make it return a true bool.  but only if
820             // they submit the correct msg data
821             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
822                 return(true);
823             }
824         }
825     }
826 
827 
828     // deletes proposal signature data after successfully executing a multiSig function
829     function deleteProposal(Data storage self, bytes32 _whatFunction)
830     internal
831     {
832         //done for readability sake
833         bytes32 _whatProposal = whatProposal(_whatFunction);
834         address _whichAdmin;
835 
836         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this
837         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
838         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
839             _whichAdmin = self.proposal_[_whatProposal].log[i];
840             delete self.proposal_[_whatProposal].admin[_whichAdmin];
841             delete self.proposal_[_whatProposal].log[i];
842         }
843         //delete the rest of the data in the record
844         delete self.proposal_[_whatProposal];
845     }
846 
847     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
848     // HELPER FUNCTIONS
849     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
850 
851     function whatProposal(bytes32 _whatFunction)
852     private
853     view
854     returns(bytes32)
855     {
856         return(keccak256(abi.encodePacked(_whatFunction,this)));
857     }
858 
859     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
860     // VANITY FUNCTIONS
861     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
862     // returns a hashed version of msg.data sent by original signer for any given function
863     function checkMsgData (Data storage self, bytes32 _whatFunction)
864     internal
865     view
866     returns (bytes32 msg_data)
867     {
868         bytes32 _whatProposal = whatProposal(_whatFunction);
869         return (self.proposal_[_whatProposal].msgData);
870     }
871 
872     // returns number of signers for any given function
873     function checkCount (Data storage self, bytes32 _whatFunction)
874     internal
875     view
876     returns (uint256 signature_count)
877     {
878         bytes32 _whatProposal = whatProposal(_whatFunction);
879         return (self.proposal_[_whatProposal].count);
880     }
881 
882     // returns address of an admin who signed for any given function
883     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
884     internal
885     view
886     returns (address signer)
887     {
888         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
889         bytes32 _whatProposal = whatProposal(_whatFunction);
890         return (self.proposal_[_whatProposal].log[_signer - 1]);
891     }
892 }