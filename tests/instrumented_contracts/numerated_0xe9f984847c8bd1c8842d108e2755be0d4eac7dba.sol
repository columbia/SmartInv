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
14 //==============================================================================
15 //     _| _ _|_ _    _ _ _|_    _   .
16 //    (_|(_| | (_|  _\(/_ | |_||_)  .
17 //=============================|================================================    
18     uint256 public registrationFee_ = 10 finney;            // price to register a name
19     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
20     mapping(address => bytes32) public gameNames_;          // lookup a games name
21     mapping(address => uint256) public gameIDs_;            // lokup a games ID
22     uint256 public gID_;        // total number of games
23     uint256 public pID_;        // total number of players
24     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
25     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
26     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
27     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
28     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
29     struct Player {
30         address addr;
31         bytes32 name;
32         uint256 laff;
33         uint256 names;
34     }
35 //==============================================================================
36 //     _ _  _  __|_ _    __|_ _  _  .
37 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
38 //==============================================================================    
39     constructor()
40         public
41     {
42         // premine the dev names (sorry not sorry)
43             // No keys are purchased with this method, it's simply locking our addresses,
44             // PID's and names for referral codes.
45         plyr_[1].addr = 0x8cf80A006D545bC3B0eFc5BB9A929a2f32B903cC;
46         plyr_[1].name = "Linx";
47         plyr_[1].names = 1;
48         pIDxAddr_[0x8cf80A006D545bC3B0eFc5BB9A929a2f32B903cC] = 1;
49         pIDxName_["linx"] = 1;
50         plyrNames_[1]["justo"] = true;
51         plyrNameList_[1][1] = "linx";
52                 
53         pID_ = 1;
54     }
55 //==============================================================================
56 //     _ _  _  _|. |`. _  _ _  .
57 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
58 //==============================================================================    
59     /**
60      * @dev prevents contracts from interacting with fomo3d 
61      */
62     modifier isHuman() {
63         address _addr = msg.sender;
64         uint256 _codeLength;
65         
66         assembly {_codeLength := extcodesize(_addr)}
67         require(_codeLength == 0, "sorry humans only");
68         _;
69     }
70    
71     
72     modifier isRegisteredGame()
73     {
74         require(gameIDs_[msg.sender] != 0);
75         _;
76     }
77 //==============================================================================
78 //     _    _  _ _|_ _  .
79 //    (/_\/(/_| | | _\  .
80 //==============================================================================    
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
94 //==============================================================================
95 //     _  _ _|__|_ _  _ _  .
96 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
97 //=====_|=======================================================================
98     function checkIfNameValid(string _nameStr)
99         public
100         view
101         returns(bool)
102     {
103         bytes32 _name = _nameStr.nameFilter();
104         if (pIDxName_[_name] == 0)
105             return (true);
106         else 
107             return (false);
108     }
109 //==============================================================================
110 //     _    |_ |. _   |`    _  __|_. _  _  _  .
111 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
112 //====|=========================================================================    
113     /**
114      * @dev registers a name.  UI will always display the last name you registered.
115      * but you will still own all previously registered names to use as affiliate 
116      * links.
117      * - must pay a registration fee.
118      * - name must be unique
119      * - names will be converted to lowercase
120      * - name cannot start or end with a space 
121      * - cannot have more than 1 space in a row
122      * - cannot be only numbers
123      * - cannot start with 0x 
124      * - name must be at least 1 char
125      * - max length of 32 characters long
126      * - allowed characters: a-z, 0-9, and space
127      * -functionhash- 0x921dec21 (using ID for affiliate)
128      * -functionhash- 0x3ddd4698 (using address for affiliate)
129      * -functionhash- 0x685ffd83 (using name for affiliate)
130      * @param _nameString players desired name
131      * @param _affCode affiliate ID, address, or name of who refered you
132      * @param _all set to true if you want this to push your info to all games 
133      * (this might cost a lot of gas)
134      */
135     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
136         isHuman()
137         public
138         payable 
139     {
140         // make sure name fees paid
141         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
142         
143         // filter name + condition checks
144         bytes32 _name = NameFilter.nameFilter(_nameString);
145         
146         // set up address 
147         address _addr = msg.sender;
148         
149         // set up our tx event data and determine if player is new or not
150         bool _isNewPlayer = determinePID(_addr);
151         
152         // fetch player id
153         uint256 _pID = pIDxAddr_[_addr];
154         
155         // manage affiliate residuals
156         // if no affiliate code was given, no new affiliate code was given, or the 
157         // player tried to use their own pID as an affiliate code, lolz
158         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
159         {
160             // update last affiliate 
161             plyr_[_pID].laff = _affCode;
162         } else if (_affCode == _pID) {
163             _affCode = 0;
164         }
165         
166         // register name 
167         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
168     }
169     
170     function registerNameXaddr(string _nameString, address _affCode, bool _all)
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
191         // if no affiliate code was given or player tried to use their own, lolz
192         uint256 _affID;
193         if (_affCode != address(0) && _affCode != _addr)
194         {
195             // get affiliate ID from aff Code 
196             _affID = pIDxAddr_[_affCode];
197             
198             // if affID is not the same as previously stored 
199             if (_affID != plyr_[_pID].laff)
200             {
201                 // update last affiliate
202                 plyr_[_pID].laff = _affID;
203             }
204         }
205         
206         // register name 
207         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
208     }
209     
210     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
211         isHuman()
212         public
213         payable 
214     {
215         // make sure name fees paid
216         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
217         
218         // filter name + condition checks
219         bytes32 _name = NameFilter.nameFilter(_nameString);
220         
221         // set up address 
222         address _addr = msg.sender;
223         
224         // set up our tx event data and determine if player is new or not
225         bool _isNewPlayer = determinePID(_addr);
226         
227         // fetch player id
228         uint256 _pID = pIDxAddr_[_addr];
229         
230         // manage affiliate residuals
231         // if no affiliate code was given or player tried to use their own, lolz
232         uint256 _affID;
233         if (_affCode != "" && _affCode != _name)
234         {
235             // get affiliate ID from aff Code 
236             _affID = pIDxName_[_affCode];
237             
238             // if affID is not the same as previously stored 
239             if (_affID != plyr_[_pID].laff)
240             {
241                 // update last affiliate
242                 plyr_[_pID].laff = _affID;
243             }
244         }
245         
246         // register name 
247         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
248     }
249     
250     /**
251      * @dev players, if you registered a profile, before a game was released, or
252      * set the all bool to false when you registered, use this function to push
253      * your profile to a single game.  also, if you've  updated your name, you
254      * can use this to push your name to games of your choosing.
255      * -functionhash- 0x81c5b206
256      * @param _gameID game id 
257      */
258     function addMeToGame(uint256 _gameID)
259         isHuman()
260         public
261     {
262         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
263         address _addr = msg.sender;
264         uint256 _pID = pIDxAddr_[_addr];
265         require(_pID != 0, "hey there buddy, you dont even have an account");
266         uint256 _totalNames = plyr_[_pID].names;
267         
268         // add players profile and most recent name
269         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
270         
271         // add list of all names
272         if (_totalNames > 1)
273             for (uint256 ii = 1; ii <= _totalNames; ii++)
274                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
275     }
276     
277     /**
278      * @dev players, use this to push your player profile to all registered games.
279      * -functionhash- 0x0c6940ea
280      */
281     function addMeToAllGames()
282         isHuman()
283         public
284     {
285         address _addr = msg.sender;
286         uint256 _pID = pIDxAddr_[_addr];
287         require(_pID != 0, "hey there buddy, you dont even have an account");
288         uint256 _laff = plyr_[_pID].laff;
289         uint256 _totalNames = plyr_[_pID].names;
290         bytes32 _name = plyr_[_pID].name;
291         
292         for (uint256 i = 1; i <= gID_; i++)
293         {
294             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
295             if (_totalNames > 1)
296                 for (uint256 ii = 1; ii <= _totalNames; ii++)
297                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
298         }
299                 
300     }
301     
302     /**
303      * @dev players use this to change back to one of your old names.  tip, you'll
304      * still need to push that info to existing games.
305      * -functionhash- 0xb9291296
306      * @param _nameString the name you want to use 
307      */
308     function useMyOldName(string _nameString)
309         isHuman()
310         public 
311     {
312         // filter name, and get pID
313         bytes32 _name = _nameString.nameFilter();
314         uint256 _pID = pIDxAddr_[msg.sender];
315         
316         // make sure they own the name 
317         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
318         
319         // update their current name 
320         plyr_[_pID].name = _name;
321     }
322     
323 //==============================================================================
324 //     _ _  _ _   | _  _ . _  .
325 //    (_(_)| (/_  |(_)(_||(_  . 
326 //=====================_|=======================================================    
327     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
328         private
329     {
330         // if names already has been used, require that current msg sender owns the name
331         if (pIDxName_[_name] != 0)
332             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
333         
334         // add name to player profile, registry, and name book
335         plyr_[_pID].name = _name;
336         pIDxName_[_name] = _pID;
337         if (plyrNames_[_pID][_name] == false)
338         {
339             plyrNames_[_pID][_name] = true;
340             plyr_[_pID].names++;
341             plyrNameList_[_pID][plyr_[_pID].names] = _name;
342         }
343         
344         // registration fee goes directly to community rewards
345         admin.transfer(address(this).balance);
346         
347         // push player info to games
348         if (_all == true)
349             for (uint256 i = 1; i <= gID_; i++)
350                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
351         
352         // fire event
353         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
354     }
355 //==============================================================================
356 //    _|_ _  _ | _  .
357 //     | (_)(_)|_\  .
358 //==============================================================================    
359     function determinePID(address _addr)
360         private
361         returns (bool)
362     {
363         if (pIDxAddr_[_addr] == 0)
364         {
365             pID_++;
366             pIDxAddr_[_addr] = pID_;
367             plyr_[pID_].addr = _addr;
368             
369             // set the new player bool to true
370             return (true);
371         } else {
372             return (false);
373         }
374     }
375 //==============================================================================
376 //   _   _|_ _  _ _  _ |   _ _ || _  .
377 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
378 //==============================================================================
379     function getPlayerID(address _addr)
380         isRegisteredGame()
381         external
382         returns (uint256)
383     {
384         determinePID(_addr);
385         return (pIDxAddr_[_addr]);
386     }
387     function getPlayerName(uint256 _pID)
388         external
389         view
390         returns (bytes32)
391     {
392         return (plyr_[_pID].name);
393     }
394     function getPlayerLAff(uint256 _pID)
395         external
396         view
397         returns (uint256)
398     {
399         return (plyr_[_pID].laff);
400     }
401     function getPlayerAddr(uint256 _pID)
402         external
403         view
404         returns (address)
405     {
406         return (plyr_[_pID].addr);
407     }
408     function getNameFee()
409         external
410         view
411         returns (uint256)
412     {
413         return(registrationFee_);
414     }
415     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
416         isRegisteredGame()
417         external
418         payable
419         returns(bool, uint256)
420     {
421         // make sure name fees paid
422         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
423         
424         // set up our tx event data and determine if player is new or not
425         bool _isNewPlayer = determinePID(_addr);
426         
427         // fetch player id
428         uint256 _pID = pIDxAddr_[_addr];
429         
430         // manage affiliate residuals
431         // if no affiliate code was given, no new affiliate code was given, or the 
432         // player tried to use their own pID as an affiliate code, lolz
433         uint256 _affID = _affCode;
434         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
435         {
436             // update last affiliate 
437             plyr_[_pID].laff = _affID;
438         } else if (_affID == _pID) {
439             _affID = 0;
440         }
441         
442         // register name 
443         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
444         
445         return(_isNewPlayer, _affID);
446     }
447     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
448         isRegisteredGame()
449         external
450         payable
451         returns(bool, uint256)
452     {
453         // make sure name fees paid
454         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
455         
456         // set up our tx event data and determine if player is new or not
457         bool _isNewPlayer = determinePID(_addr);
458         
459         // fetch player id
460         uint256 _pID = pIDxAddr_[_addr];
461         
462         // manage affiliate residuals
463         // if no affiliate code was given or player tried to use their own, lolz
464         uint256 _affID;
465         if (_affCode != address(0) && _affCode != _addr)
466         {
467             // get affiliate ID from aff Code 
468             _affID = pIDxAddr_[_affCode];
469             
470             // if affID is not the same as previously stored 
471             if (_affID != plyr_[_pID].laff)
472             {
473                 // update last affiliate
474                 plyr_[_pID].laff = _affID;
475             }
476         }
477         
478         // register name 
479         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
480         
481         return(_isNewPlayer, _affID);
482     }
483     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
484         isRegisteredGame()
485         external
486         payable
487         returns(bool, uint256)
488     {
489         // make sure name fees paid
490         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
491         
492         // set up our tx event data and determine if player is new or not
493         bool _isNewPlayer = determinePID(_addr);
494         
495         // fetch player id
496         uint256 _pID = pIDxAddr_[_addr];
497         
498         // manage affiliate residuals
499         // if no affiliate code was given or player tried to use their own, lolz
500         uint256 _affID;
501         if (_affCode != "" && _affCode != _name)
502         {
503             // get affiliate ID from aff Code 
504             _affID = pIDxName_[_affCode];
505             
506             // if affID is not the same as previously stored 
507             if (_affID != plyr_[_pID].laff)
508             {
509                 // update last affiliate
510                 plyr_[_pID].laff = _affID;
511             }
512         }
513         
514         // register name 
515         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
516         
517         return(_isNewPlayer, _affID);
518     }
519     
520 //==============================================================================
521 //   _ _ _|_    _   .
522 //  _\(/_ | |_||_)  .
523 //=============|================================================================
524     function addGame(address _gameAddress, string _gameNameStr)
525         public
526     {
527         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
528             gID_++;
529             bytes32 _name = _gameNameStr.nameFilter();
530             gameIDs_[_gameAddress] = gID_;
531             gameNames_[_gameAddress] = _name;
532             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
533         
534             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
535             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
536             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
537             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
538     }
539     
540     function setRegistrationFee(uint256 _fee)
541         public
542     {
543       registrationFee_ = _fee;
544     }
545         
546 } 
547 
548 library NameFilter {
549     
550     /**
551      * @dev filters name strings
552      * -converts uppercase to lower case.  
553      * -makes sure it does not start/end with a space
554      * -makes sure it does not contain multiple spaces in a row
555      * -cannot be only numbers
556      * -cannot start with 0x 
557      * -restricts characters to A-Z, a-z, 0-9, and space.
558      * @return reprocessed string in bytes32 format
559      */
560     function nameFilter(string _input)
561         internal
562         pure
563         returns(bytes32)
564     {
565         bytes memory _temp = bytes(_input);
566         uint256 _length = _temp.length;
567         
568         //sorry limited to 32 characters
569         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
570         // make sure it doesnt start with or end with space
571         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
572         // make sure first two characters are not 0x
573         if (_temp[0] == 0x30)
574         {
575             require(_temp[1] != 0x78, "string cannot start with 0x");
576             require(_temp[1] != 0x58, "string cannot start with 0X");
577         }
578         
579         // create a bool to track if we have a non number character
580         bool _hasNonNumber;
581         
582         // convert & check
583         for (uint256 i = 0; i < _length; i++)
584         {
585             // if its uppercase A-Z
586             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
587             {
588                 // convert to lower case a-z
589                 _temp[i] = byte(uint(_temp[i]) + 32);
590                 
591                 // we have a non number
592                 if (_hasNonNumber == false)
593                     _hasNonNumber = true;
594             } else {
595                 require
596                 (
597                     // require character is a space
598                     _temp[i] == 0x20 || 
599                     // OR lowercase a-z
600                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
601                     // or 0-9
602                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
603                     "string contains invalid characters"
604                 );
605                 // make sure theres not 2x spaces in a row
606                 if (_temp[i] == 0x20)
607                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
608                 
609                 // see if we have a character other than a number
610                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
611                     _hasNonNumber = true;    
612             }
613         }
614         
615         require(_hasNonNumber == true, "string cannot be only numbers");
616         
617         bytes32 _ret;
618         assembly {
619             _ret := mload(add(_temp, 32))
620         }
621         return (_ret);
622     }
623 }
624 
625 /**
626  * @title SafeMath v0.1.9
627  * @dev Math operations with safety checks that throw on error
628  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
629  * - added sqrt
630  * - added sq
631  * - added pwr 
632  * - changed asserts to requires with error log outputs
633  * - removed div, its useless
634  */
635 library SafeMath {
636     
637     /**
638     * @dev Multiplies two numbers, throws on overflow.
639     */
640     function mul(uint256 a, uint256 b) 
641         internal 
642         pure 
643         returns (uint256 c) 
644     {
645         if (a == 0) {
646             return 0;
647         }
648         c = a * b;
649         require(c / a == b, "SafeMath mul failed");
650         return c;
651     }
652 
653     /**
654     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
655     */
656     function sub(uint256 a, uint256 b)
657         internal
658         pure
659         returns (uint256) 
660     {
661         require(b <= a, "SafeMath sub failed");
662         return a - b;
663     }
664 
665     /**
666     * @dev Adds two numbers, throws on overflow.
667     */
668     function add(uint256 a, uint256 b)
669         internal
670         pure
671         returns (uint256 c) 
672     {
673         c = a + b;
674         require(c >= a, "SafeMath add failed");
675         return c;
676     }
677     
678     /**
679      * @dev gives square root of given x.
680      */
681     function sqrt(uint256 x)
682         internal
683         pure
684         returns (uint256 y) 
685     {
686         uint256 z = ((add(x,1)) / 2);
687         y = x;
688         while (z < y) 
689         {
690             y = z;
691             z = ((add((x / z),z)) / 2);
692         }
693     }
694     
695     /**
696      * @dev gives square. multiplies x by x
697      */
698     function sq(uint256 x)
699         internal
700         pure
701         returns (uint256)
702     {
703         return (mul(x,x));
704     }
705     
706     /**
707      * @dev x to the power of y 
708      */
709     function pwr(uint256 x, uint256 y)
710         internal 
711         pure 
712         returns (uint256)
713     {
714         if (x==0)
715             return (0);
716         else if (y==0)
717             return (1);
718         else 
719         {
720             uint256 z = x;
721             for (uint256 i=1; i < y; i++)
722                 z = mul(z,x);
723             return (z);
724         }
725     }
726 }