1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 
9 contract PlayerBook {
10     using NameFilter for string;
11     using SafeMath for uint256;
12 
13     address private admin = msg.sender;
14     address private com = 0xaba7a09EDBe80403Ab705B95df24A5cE60Ec3b12;
15     //==============================================================================
16     //     _| _ _|_ _    _ _ _|_    _   .
17     //    (_|(_| | (_|  _\(/_ | |_||_)  .
18     //=============================|================================================
19     uint256 public registrationFee_ = 10 finney;            // price to register a name
20     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
21     mapping(address => bytes32) public gameNames_;          // lookup a games name
22     mapping(address => uint256) public gameIDs_;            // lokup a games ID
23     uint256 public gID_;        // total number of games
24     uint256 public pID_;        // total number of players
25     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
26     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
27     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
28     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
29     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
30     struct Player {
31         address addr;
32         bytes32 name;
33         uint256 laff;
34         uint256 names;
35     }
36     //==============================================================================
37     //     _ _  _  __|_ _    __|_ _  _  .
38     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
39     //==============================================================================
40     constructor()
41     public
42     {
43         // premine the dev names (sorry not sorry)
44         // No keys are purchased with this method, it's simply locking our addresses,
45         // PID's and names for referral codes.
46         plyr_[1].addr = com;
47         plyr_[1].name = "play";
48         plyr_[1].names = 1;
49         pIDxAddr_[com] = 1;
50         pIDxName_["play"] = 1;
51         plyrNames_[1]["play"] = true;
52         plyrNameList_[1][1] = "play";
53 
54         pID_ = 1;
55     }
56     //==============================================================================
57     //     _ _  _  _|. |`. _  _ _  .
58     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
59     //==============================================================================
60     /**
61      * @dev prevents contracts from interacting with fomo3d
62      */
63     modifier isHuman() {
64         address _addr = msg.sender;
65         uint256 _codeLength;
66 
67         assembly {_codeLength := extcodesize(_addr)}
68         require(_codeLength == 0, "sorry humans only");
69         _;
70     }
71 
72     modifier isRegisteredGame()
73     {
74         require(gameIDs_[msg.sender] != 0);
75         _;
76     }
77     //==============================================================================
78     //     _    _  _ _|_ _  .
79     //    (/_\/(/_| | | _\  .
80     //==============================================================================
81     // fired whenever a player registers a name
82     event onNewName
83     (
84         uint256 indexed playerID,
85         address indexed playerAddress,
86         bytes32 indexed playerName,
87         bool isNewPlayer,
88         uint256 affiliateID,
89         address affiliateAddress,
90         bytes32 affiliateName,
91         uint256 amountPaid,
92         uint256 timeStamp
93     );
94 
95     function checkIfNameValid(string _nameStr)
96     public
97     view
98     returns(bool)
99     {
100         bytes32 _name = _nameStr.nameFilter();
101         if (pIDxName_[_name] == 0)
102             return (true);
103         else
104             return (false);
105     }
106     //==============================================================================
107     //     _    |_ |. _   |`    _  __|_. _  _  _  .
108     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
109     //====|=========================================================================
110     /**
111      * @dev registers a name.  UI will always display the last name you registered.
112      * but you will still own all previously registered names to use as affiliate
113      * links.
114      * - must pay a registration fee.
115      * - name must be unique
116      * - names will be converted to lowercase
117      * - name cannot start or end with a space
118      * - cannot have more than 1 space in a row
119      * - cannot be only numbers
120      * - cannot start with 0x
121      * - name must be at least 1 char
122      * - max length of 32 characters long
123      * - allowed characters: a-z, 0-9, and space
124      * -functionhash- 0x921dec21 (using ID for affiliate)
125      * -functionhash- 0x3ddd4698 (using address for affiliate)
126      * -functionhash- 0x685ffd83 (using name for affiliate)
127      * @param _nameString players desired name
128      * @param _affCode affiliate ID, address, or name of who refered you
129      * @param _all set to true if you want this to push your info to all games
130      * (this might cost a lot of gas)
131      */
132     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
133     isHuman()
134     public
135     payable
136     {
137         // make sure name fees paid
138         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
139 
140         // filter name + condition checks
141         bytes32 _name = NameFilter.nameFilter(_nameString);
142 
143         // set up address
144         address _addr = msg.sender;
145 
146         // set up our tx event data and determine if player is new or not
147         bool _isNewPlayer = determinePID(_addr);
148 
149         // fetch player id
150         uint256 _pID = pIDxAddr_[_addr];
151 
152         // manage affiliate residuals
153         // if no affiliate code was given, no new affiliate code was given, or the
154         // player tried to use their own pID as an affiliate code, lolz
155         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
156         {
157             // update last affiliate
158             plyr_[_pID].laff = _affCode;
159         } else if (_affCode == _pID) {
160             _affCode = 0;
161         }
162 
163         // register name
164         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
165     }
166 
167     function registerNameXaddr(string _nameString, address _affCode, bool _all)
168     isHuman()
169     public
170     payable
171     {
172         // make sure name fees paid
173         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
174 
175         // filter name + condition checks
176         bytes32 _name = NameFilter.nameFilter(_nameString);
177 
178         // set up address
179         address _addr = msg.sender;
180 
181         // set up our tx event data and determine if player is new or not
182         bool _isNewPlayer = determinePID(_addr);
183 
184         // fetch player id
185         uint256 _pID = pIDxAddr_[_addr];
186 
187         // manage affiliate residuals
188         // if no affiliate code was given or player tried to use their own, lolz
189         uint256 _affID;
190         if (_affCode != address(0) && _affCode != _addr)
191         {
192             // get affiliate ID from aff Code
193             _affID = pIDxAddr_[_affCode];
194 
195             // if affID is not the same as previously stored
196             if (_affID != plyr_[_pID].laff)
197             {
198                 // update last affiliate
199                 plyr_[_pID].laff = _affID;
200             }
201         }
202 
203         // register name
204         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
205     }
206 
207     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
208     isHuman()
209     public
210     payable
211     {
212         // make sure name fees paid
213         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
214 
215         // filter name + condition checks
216         bytes32 _name = NameFilter.nameFilter(_nameString);
217 
218         // set up address
219         address _addr = msg.sender;
220 
221         // set up our tx event data and determine if player is new or not
222         bool _isNewPlayer = determinePID(_addr);
223 
224         // fetch player id
225         uint256 _pID = pIDxAddr_[_addr];
226 
227         // manage affiliate residuals
228         // if no affiliate code was given or player tried to use their own, lolz
229         uint256 _affID;
230         if (_affCode != "" && _affCode != _name)
231         {
232             // get affiliate ID from aff Code
233             _affID = pIDxName_[_affCode];
234 
235             // if affID is not the same as previously stored
236             if (_affID != plyr_[_pID].laff)
237             {
238                 // update last affiliate
239                 plyr_[_pID].laff = _affID;
240             }
241         }
242 
243         // register name
244         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
245     }
246 
247     /**
248      * @dev players, if you registered a profile, before a game was released, or
249      * set the all bool to false when you registered, use this function to push
250      * your profile to a single game.  also, if you've  updated your name, you
251      * can use this to push your name to games of your choosing.
252      * -functionhash- 0x81c5b206
253      * @param _gameID game id
254      */
255     function addMeToGame(uint256 _gameID)
256     isHuman()
257     public
258     {
259         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
260         address _addr = msg.sender;
261         uint256 _pID = pIDxAddr_[_addr];
262         require(_pID != 0, "hey there buddy, you dont even have an account");
263         uint256 _totalNames = plyr_[_pID].names;
264 
265         // add players profile and most recent name
266         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
267 
268         // add list of all names
269         if (_totalNames > 1)
270             for (uint256 ii = 1; ii <= _totalNames; ii++)
271                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
272     }
273 
274     /**
275      * @dev players, use this to push your player profile to all registered games.
276      * -functionhash- 0x0c6940ea
277      */
278     function addMeToAllGames()
279     isHuman()
280     public
281     {
282         address _addr = msg.sender;
283         uint256 _pID = pIDxAddr_[_addr];
284         require(_pID != 0, "hey there buddy, you dont even have an account");
285         uint256 _laff = plyr_[_pID].laff;
286         uint256 _totalNames = plyr_[_pID].names;
287         bytes32 _name = plyr_[_pID].name;
288 
289         for (uint256 i = 1; i <= gID_; i++)
290         {
291             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
292             if (_totalNames > 1)
293                 for (uint256 ii = 1; ii <= _totalNames; ii++)
294                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
295         }
296 
297     }
298 
299     /**
300      * @dev players use this to change back to one of your old names.  tip, you'll
301      * still need to push that info to existing games.
302      * -functionhash- 0xb9291296
303      * @param _nameString the name you want to use
304      */
305     function useMyOldName(string _nameString)
306     isHuman()
307     public
308     {
309         // filter name, and get pID
310         bytes32 _name = _nameString.nameFilter();
311         uint256 _pID = pIDxAddr_[msg.sender];
312 
313         // make sure they own the name
314         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
315 
316         // update their current name
317         plyr_[_pID].name = _name;
318     }
319 
320     //==============================================================================
321     //     _ _  _ _   | _  _ . _  .
322     //    (_(_)| (/_  |(_)(_||(_  .
323     //=====================_|=======================================================
324     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
325     private
326     {
327         // if names already has been used, require that current msg sender owns the name
328         if (pIDxName_[_name] != 0)
329             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
330 
331         // add name to player profile, registry, and name book
332         plyr_[_pID].name = _name;
333         pIDxName_[_name] = _pID;
334         if (plyrNames_[_pID][_name] == false)
335         {
336             plyrNames_[_pID][_name] = true;
337             plyr_[_pID].names++;
338             plyrNameList_[_pID][plyr_[_pID].names] = _name;
339         }
340 
341         // registration fee goes directly to community rewards
342         com.transfer(address(this).balance);
343 
344         // push player info to games
345         if (_all == true)
346             for (uint256 i = 1; i <= gID_; i++)
347                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
348 
349         // fire event
350         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
351     }
352     //==============================================================================
353     //    _|_ _  _ | _  .
354     //     | (_)(_)|_\  .
355     //==============================================================================
356     function determinePID(address _addr)
357     private
358     returns (bool)
359     {
360         if (pIDxAddr_[_addr] == 0)
361         {
362             pID_++;
363             pIDxAddr_[_addr] = pID_;
364             plyr_[pID_].addr = _addr;
365 
366             // set the new player bool to true
367             return (true);
368         } else {
369             return (false);
370         }
371     }
372     //==============================================================================
373     //   _   _|_ _  _ _  _ |   _ _ || _  .
374     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
375     //==============================================================================
376     function getPlayerID(address _addr)
377     isRegisteredGame()
378     external
379     returns (uint256)
380     {
381         determinePID(_addr);
382         return (pIDxAddr_[_addr]);
383     }
384     function getPlayerName(uint256 _pID)
385     external
386     view
387     returns (bytes32)
388     {
389         return (plyr_[_pID].name);
390     }
391     function getPlayerLAff(uint256 _pID)
392     external
393     view
394     returns (uint256)
395     {
396         return (plyr_[_pID].laff);
397     }
398     function getPlayerAddr(uint256 _pID)
399     external
400     view
401     returns (address)
402     {
403         return (plyr_[_pID].addr);
404     }
405     function getNameFee()
406     external
407     view
408     returns (uint256)
409     {
410         return(registrationFee_);
411     }
412     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
413     isRegisteredGame()
414     external
415     payable
416     returns(bool, uint256)
417     {
418         // make sure name fees paid
419         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
420 
421         // set up our tx event data and determine if player is new or not
422         bool _isNewPlayer = determinePID(_addr);
423 
424         // fetch player id
425         uint256 _pID = pIDxAddr_[_addr];
426 
427         // manage affiliate residuals
428         // if no affiliate code was given, no new affiliate code was given, or the
429         // player tried to use their own pID as an affiliate code, lolz
430         uint256 _affID = _affCode;
431         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
432         {
433             // update last affiliate
434             plyr_[_pID].laff = _affID;
435         } else if (_affID == _pID) {
436             _affID = 0;
437         }
438 
439         // register name
440         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
441 
442         return(_isNewPlayer, _affID);
443     }
444     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
445     isRegisteredGame()
446     external
447     payable
448     returns(bool, uint256)
449     {
450         // make sure name fees paid
451         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
452 
453         // set up our tx event data and determine if player is new or not
454         bool _isNewPlayer = determinePID(_addr);
455 
456         // fetch player id
457         uint256 _pID = pIDxAddr_[_addr];
458 
459         // manage affiliate residuals
460         // if no affiliate code was given or player tried to use their own, lolz
461         uint256 _affID;
462         if (_affCode != address(0) && _affCode != _addr)
463         {
464             // get affiliate ID from aff Code
465             _affID = pIDxAddr_[_affCode];
466 
467             // if affID is not the same as previously stored
468             if (_affID != plyr_[_pID].laff)
469             {
470                 // update last affiliate
471                 plyr_[_pID].laff = _affID;
472             }
473         }
474 
475         // register name
476         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
477 
478         return(_isNewPlayer, _affID);
479     }
480     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
481     isRegisteredGame()
482     external
483     payable
484     returns(bool, uint256)
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
498         if (_affCode != "" && _affCode != _name)
499         {
500             // get affiliate ID from aff Code
501             _affID = pIDxName_[_affCode];
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
516 
517     //==============================================================================
518     //   _ _ _|_    _   .
519     //  _\(/_ | |_||_)  .
520     //=============|================================================================
521     function addGame(address _gameAddress, string _gameNameStr)
522     public
523     {
524         require(msg.sender == admin, "only admin can call");
525 
526         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
527         gID_++;
528         bytes32 _name = _gameNameStr.nameFilter();
529         gameIDs_[_gameAddress] = gID_;
530         gameNames_[_gameAddress] = _name;
531         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
532 
533         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
534     }
535 
536     function setRegistrationFee(uint256 _fee)
537     public
538     {
539         require(msg.sender == admin, "only admin can call");
540         registrationFee_ = _fee;
541     }
542 
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