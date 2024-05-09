1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 
10 contract PlayerBook {
11     using NameFilter for string;
12     using SafeMath for uint256;
13     
14     address private admin = msg.sender;
15 //==============================================================================
16 //     _| _ _|_ _    _ _ _|_    _   .
17 //    (_|(_| | (_|  _\(/_ | |_||_)  .
18 //=============================|================================================    
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
36 //==============================================================================
37 //     _ _  _  __|_ _    __|_ _  _  .
38 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
39 //==============================================================================    
40     constructor() 
41     public 
42     {
43        
44          // No keys are purchased with this method, it's simply locking our addresses,
45         // PID's and names for referral codes.
46         plyr_[1].addr = 0x7e474fe5Cfb720804860215f407111183cbc2f85;
47         plyr_[1].name = "kenny";
48         plyr_[1].names = 1;
49         pIDxAddr_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = 1;
50         pIDxName_["kenny"] = 1;
51         plyrNames_[1]["kenny"] = true;
52         plyrNameList_[1][1] = "kenny";
53     }
54    
55 //==============================================================================
56 //     _ _  _  _|. |`. _  _ _  .
57 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
58 //==============================================================================    
59     /**
60      * @dev prevents contracts from interacting
61      */
62     modifier isHuman() {
63         address _addr = msg.sender;
64         uint256 _codeLength;
65         
66         assembly {_codeLength := extcodesize(_addr)}
67         require(_codeLength == 0);
68         require(_addr == tx.origin);
69         _;
70     }
71    
72     modifier onlyAdmin()
73     {
74         require(msg.sender == admin);
75         _;
76     }
77     
78     modifier isRegisteredGame()
79     {
80         require(gameIDs_[msg.sender] != 0);
81         _;
82     }
83 //==============================================================================
84 //     _    _  _ _|_ _  .
85 //    (/_\/(/_| | | _\  .
86 //==============================================================================    
87     // fired whenever a player registers a name
88     event onNewName
89     (
90         uint256 indexed playerID,
91         address indexed playerAddress,
92         bytes32 indexed playerName,
93         bool isNewPlayer,
94         uint256 affiliateID,
95         address affiliateAddress,
96         bytes32 affiliateName,
97         uint256 amountPaid,
98         uint256 timeStamp
99     );
100 //==============================================================================
101 //     _  _ _|__|_ _  _ _  .
102 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
103 //=====_|=======================================================================
104     function checkIfNameValid(string _nameStr)
105         public
106         view
107         returns(bool)
108     {
109         bytes32 _name = _nameStr.nameFilter();
110         if (pIDxName_[_name] == 0)
111             return (true);
112         else 
113             return (false);
114     }
115 //==============================================================================
116 //     _    |_ |. _   |`    _  __|_. _  _  _  .
117 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
118 //====|=========================================================================    
119     /**
120      * @dev registers a name.  UI will always display the last name you registered.
121      * but you will still own all previously registered names to use as affiliate 
122      * links.
123      * - must pay a registration fee.
124      * - name must be unique
125      * - names will be converted to lowercase
126      * - name cannot start or end with a space 
127      * - cannot have more than 1 space in a row
128      * - cannot be only numbers
129      * - cannot start with 0x 
130      * - name must be at least 1 char
131      * - max length of 32 characters long
132      * - allowed characters: a-z, 0-9, and space
133      * -functionhash- 0x921dec21 (using ID for affiliate)
134      * -functionhash- 0x3ddd4698 (using address for affiliate)
135      * -functionhash- 0x685ffd83 (using name for affiliate)
136      * @param _nameString players desired name
137      * @param _affCode affiliate ID, address, or name of who refered you
138      * @param _all set to true if you want this to push your info to all games 
139      * (this might cost a lot of gas)
140      */
141     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
142         isHuman()
143         public
144         payable 
145     {
146         // make sure name fees paid
147         require (msg.value >= registrationFee_);
148         
149         // filter name + condition checks
150         bytes32 _name = NameFilter.nameFilter(_nameString);
151         
152         // set up address 
153         address _addr = msg.sender;
154         
155         // set up our tx event data and determine if player is new or not
156         bool _isNewPlayer = determinePID(_addr);
157         
158         // fetch player id
159         uint256 _pID = pIDxAddr_[_addr];
160         
161         // manage affiliate residuals
162         // if no affiliate code was given, no new affiliate code was given, or the 
163         // player tried to use their own pID as an affiliate code
164         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
165         {
166             // update last affiliate 
167             plyr_[_pID].laff = _affCode;
168         } else if (_affCode == _pID) {
169             _affCode = 0;
170         }
171         
172         // register name 
173         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
174     }
175     
176     function registerNameXaddr(string _nameString, address _affCode, bool _all)
177         isHuman()
178         public
179         payable 
180     {
181         // make sure name fees paid
182         require (msg.value >= registrationFee_);
183         
184         // filter name + condition checks
185         bytes32 _name = NameFilter.nameFilter(_nameString);
186         
187         // set up address 
188         address _addr = msg.sender;
189         
190         // set up our tx event data and determine if player is new or not
191         bool _isNewPlayer = determinePID(_addr);
192         
193         // fetch player id
194         uint256 _pID = pIDxAddr_[_addr];
195         
196         // manage affiliate residuals
197         // if no affiliate code was given or player tried to use their own, lolz
198         uint256 _affID;
199         if (_affCode != address(0) && _affCode != _addr)
200         {
201             // get affiliate ID from aff Code 
202             _affID = pIDxAddr_[_affCode];
203             
204             // if affID is not the same as previously stored 
205             if (_affID != plyr_[_pID].laff)
206             {
207                 // update last affiliate
208                 plyr_[_pID].laff = _affID;
209             }
210         }
211         
212         // register name 
213         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
214     }
215     
216     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
217         isHuman()
218         public
219         payable 
220     {
221         // make sure name fees paid
222         require (msg.value >= registrationFee_);
223         
224         // filter name + condition checks
225         bytes32 _name = NameFilter.nameFilter(_nameString);
226         
227         // set up address 
228         address _addr = msg.sender;
229         
230         // set up our tx event data and determine if player is new or not
231         bool _isNewPlayer = determinePID(_addr);
232         
233         // fetch player id
234         uint256 _pID = pIDxAddr_[_addr];
235         
236         // manage affiliate residuals
237         // if no affiliate code was given or player tried to use their own, lolz
238         uint256 _affID;
239         if (_affCode != "" && _affCode != _name)
240         {
241             // get affiliate ID from aff Code 
242             _affID = pIDxName_[_affCode];
243             
244             // if affID is not the same as previously stored 
245             if (_affID != plyr_[_pID].laff)
246             {
247                 // update last affiliate
248                 plyr_[_pID].laff = _affID;
249             }
250         }
251         
252         // register name 
253         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
254     }
255     
256     /**
257      * @dev players, if you registered a profile, before a game was released, or
258      * set the all bool to false when you registered, use this function to push
259      * your profile to a single game.  also, if you've  updated your name, you
260      * can use this to push your name to games of your choosing.
261      * -functionhash- 0x81c5b206
262      * @param _gameID game id 
263      */
264     function addMeToGame(uint256 _gameID)
265         isHuman()
266         public
267     {
268         require(_gameID <= gID_);
269         address _addr = msg.sender;
270         uint256 _pID = pIDxAddr_[_addr];
271         require(_pID != 0);
272         uint256 _totalNames = plyr_[_pID].names;
273         
274         // add players profile and most recent name
275         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
276         
277         // add list of all names
278         if (_totalNames > 1)
279             for (uint256 ii = 1; ii <= _totalNames; ii++)
280                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
281     }
282     
283     
284     
285     /**
286      * @dev players use this to change back to one of your old names.  
287      * -functionhash- 0xb9291296
288      * @param _nameString the name you want to use 
289      */
290     function useMyOldName(string _nameString)
291         isHuman()
292         public 
293     {
294         // filter name, and get pID
295         bytes32 _name = _nameString.nameFilter();
296         uint256 _pID = pIDxAddr_[msg.sender];
297         
298         // make sure they own the name 
299         require(plyrNames_[_pID][_name] == true);
300         
301         // update their current name 
302         plyr_[_pID].name = _name;
303     }
304     
305 //==============================================================================
306 //     _ _  _ _   | _  _ . _  .
307 //    (_(_)| (/_  |(_)(_||(_  . 
308 //=====================_|=======================================================    
309     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
310         private
311     {
312         // if names already has been used, require that current msg sender owns the name
313         if (pIDxName_[_name] != 0)
314             require(plyrNames_[_pID][_name] == true);
315         
316         // add name to player profile, registry, and name book
317         plyr_[_pID].name = _name;
318         pIDxName_[_name] = _pID;
319         if (plyrNames_[_pID][_name] == false)
320         {
321             plyrNames_[_pID][_name] = true;
322             plyr_[_pID].names++;
323             plyrNameList_[_pID][plyr_[_pID].names] = _name;
324         }
325         
326         admin.transfer(address(this).balance);
327         
328         // push player info to games
329         if (_all == true)
330             for (uint256 i = 1; i <= gID_; i++)
331                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
332         
333         // fire event
334         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
335     }
336 //==============================================================================
337 //    _|_ _  _ | _  .
338 //     | (_)(_)|_\  .
339 //==============================================================================    
340     function determinePID(address _addr)
341         private
342         returns (bool)
343     {
344         if (pIDxAddr_[_addr] == 0)
345         {
346             pID_++;
347             pIDxAddr_[_addr] = pID_;
348             plyr_[pID_].addr = _addr;
349             
350             // set the new player bool to true
351             return (true);
352         } else {
353             return (false);
354         }
355     }
356 //==============================================================================
357 //   _   _|_ _  _ _  _ |   _ _ || _  .
358 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
359 //==============================================================================
360     function getPlayerID(address _addr)
361         isRegisteredGame()
362         external
363         returns (uint256)
364     {
365         determinePID(_addr);
366         return (pIDxAddr_[_addr]);
367     }
368     function getPlayerName(uint256 _pID)
369         external
370         view
371         returns (bytes32)
372     {
373         return (plyr_[_pID].name);
374     }
375     function getPlayerLAff(uint256 _pID)
376         external
377         view
378         returns (uint256)
379     {
380         return (plyr_[_pID].laff);
381     }
382     function getPlayerAddr(uint256 _pID)
383         external
384         view
385         returns (address)
386     {
387         return (plyr_[_pID].addr);
388     }
389     function getNameFee()
390         external
391         view
392         returns (uint256)
393     {
394         return(registrationFee_);
395     }
396     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
397         isRegisteredGame()
398         external
399         payable
400         returns(bool, uint256)
401     {
402         // make sure name fees paid
403         require (msg.value >= registrationFee_);
404         
405         // set up our tx event data and determine if player is new or not
406         bool _isNewPlayer = determinePID(_addr);
407         
408         // fetch player id
409         uint256 _pID = pIDxAddr_[_addr];
410         
411         // manage affiliate residuals
412         // if no affiliate code was given, no new affiliate code was given, or the 
413         // player tried to use their own pID as an affiliate code
414         uint256 _affID = _affCode;
415         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
416         {
417             // update last affiliate 
418             plyr_[_pID].laff = _affID;
419         } else if (_affID == _pID) {
420             _affID = 0;
421         }
422         
423         // register name 
424         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
425         
426         return(_isNewPlayer, _affID);
427     }
428     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
429         isRegisteredGame()
430         external
431         payable
432         returns(bool, uint256)
433     {
434         // make sure name fees paid
435         require (msg.value >= registrationFee_);
436         
437         // set up our tx event data and determine if player is new or not
438         bool _isNewPlayer = determinePID(_addr);
439         
440         // fetch player id
441         uint256 _pID = pIDxAddr_[_addr];
442         
443         // manage affiliate residuals
444         // if no affiliate code was given or player tried to use their own
445         uint256 _affID;
446         if (_affCode != address(0) && _affCode != _addr)
447         {
448             // get affiliate ID from aff Code 
449             _affID = pIDxAddr_[_affCode];
450             
451             // if affID is not the same as previously stored 
452             if (_affID != plyr_[_pID].laff)
453             {
454                 // update last affiliate
455                 plyr_[_pID].laff = _affID;
456             }
457         }
458         
459         // register name 
460         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
461         
462         return(_isNewPlayer, _affID);
463     }
464     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
465         isRegisteredGame()
466         external
467         payable
468         returns(bool, uint256)
469     {
470         // make sure name fees paid
471         require (msg.value >= registrationFee_);
472         
473         // set up our tx event data and determine if player is new or not
474         bool _isNewPlayer = determinePID(_addr);
475         
476         // fetch player id
477         uint256 _pID = pIDxAddr_[_addr];
478         
479         // manage affiliate residuals
480         // if no affiliate code was given or player tried to use their own
481         uint256 _affID;
482         if (_affCode != "" && _affCode != _name)
483         {
484             // get affiliate ID from aff Code 
485             _affID = pIDxName_[_affCode];
486             
487             // if affID is not the same as previously stored 
488             if (_affID != plyr_[_pID].laff)
489             {
490                 // update last affiliate
491                 plyr_[_pID].laff = _affID;
492             }
493         }
494         
495         // register name 
496         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
497         
498         return(_isNewPlayer, _affID);
499     }
500     
501 //==============================================================================
502 //   _ _ _|_    _   .
503 //  _\(/_ | |_||_)  .
504 //=============|================================================================
505     function addGame(address _gameAddress, string _gameNameStr)
506         onlyAdmin()
507         public
508     {
509         require(gameIDs_[_gameAddress] == 0);
510             gID_++;
511             bytes32 _name = _gameNameStr.nameFilter();
512             gameIDs_[_gameAddress] = gID_;
513             gameNames_[_gameAddress] = _name;
514             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
515     }
516     
517     function setRegistrationFee(uint256 _fee)
518         onlyAdmin()
519         public
520 
521     {
522       registrationFee_ = _fee;
523     }
524         
525 } 
526 
527 
528 library NameFilter {
529     
530     /**
531      * @dev filters name strings
532      * -converts uppercase to lower case.  
533      * -makes sure it does not start/end with a space
534      * -makes sure it does not contain multiple spaces in a row
535      * -cannot be only numbers
536      * -cannot start with 0x 
537      * -restricts characters to A-Z, a-z, 0-9, and space.
538      * @return reprocessed string in bytes32 format
539      */
540     function nameFilter(string _input)
541         internal
542         pure
543         returns(bytes32)
544     {
545         bytes memory _temp = bytes(_input);
546         uint256 _length = _temp.length;
547         
548         //sorry limited to 32 characters
549         require (_length <= 32 && _length > 0);
550         // make sure it doesnt start with or end with space
551         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
552         // make sure first two characters are not 0x
553         if (_temp[0] == 0x30)
554         {
555             require(_temp[1] != 0x78);
556             require(_temp[1] != 0x58);
557         }
558         
559         // create a bool to track if we have a non number character
560         bool _hasNonNumber;
561         
562         // convert & check
563         for (uint256 i = 0; i < _length; i++)
564         {
565             // if its uppercase A-Z
566             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
567             {
568                 // convert to lower case a-z
569                 _temp[i] = byte(uint(_temp[i]) + 32);
570                 
571                 // we have a non number
572                 if (_hasNonNumber == false)
573                     _hasNonNumber = true;
574             } else {
575                 require
576                 (
577                     // require character is a space
578                     _temp[i] == 0x20 || 
579                     // OR lowercase a-z
580                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
581                     // or 0-9
582                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
583                 // make sure theres not 2x spaces in a row
584                 if (_temp[i] == 0x20)
585                     require( _temp[i+1] != 0x20);
586                 
587                 // see if we have a character other than a number
588                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
589                     _hasNonNumber = true;    
590             }
591         }
592         
593         require(_hasNonNumber == true);
594         
595         bytes32 _ret;
596         assembly {
597             _ret := mload(add(_temp, 32))
598         }
599         return (_ret);
600     }
601 }
602 
603 /**
604  * @title SafeMath v0.1.9
605  * @dev Math operations with safety checks that throw on error
606  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
607  * - added sqrt
608  * - added sq
609  * - added pwr 
610  * - changed asserts to requires with error log outputs
611  * - removed div, its useless
612  */
613 library SafeMath {
614     
615     /**
616     * @dev Multiplies two numbers, throws on overflow.
617     */
618     function mul(uint256 a, uint256 b) 
619         internal 
620         pure 
621         returns (uint256 c) 
622     {
623         if (a == 0) {
624             return 0;
625         }
626         c = a * b;
627         require(c / a == b, "SafeMath mul failed");
628         return c;
629     }
630 
631     /**
632     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
633     */
634     function sub(uint256 a, uint256 b)
635         internal
636         pure
637         returns (uint256) 
638     {
639         require(b <= a, "SafeMath sub failed");
640         return a - b;
641     }
642 
643     /**
644     * @dev Adds two numbers, throws on overflow.
645     */
646     function add(uint256 a, uint256 b)
647         internal
648         pure
649         returns (uint256 c) 
650     {
651         c = a + b;
652         require(c >= a, "SafeMath add failed");
653         return c;
654     }
655     
656     /**
657      * @dev gives square root of given x.
658      */
659     function sqrt(uint256 x)
660         internal
661         pure
662         returns (uint256 y) 
663     {
664         uint256 z = ((add(x,1)) / 2);
665         y = x;
666         while (z < y) 
667         {
668             y = z;
669             z = ((add((x / z),z)) / 2);
670         }
671     }
672     
673     /**
674      * @dev gives square. multiplies x by x
675      */
676     function sq(uint256 x)
677         internal
678         pure
679         returns (uint256)
680     {
681         return (mul(x,x));
682     }
683     
684     /**
685      * @dev x to the power of y 
686      */
687     function pwr(uint256 x, uint256 y)
688         internal 
689         pure 
690         returns (uint256)
691     {
692         if (x==0)
693             return (0);
694         else if (y==0)
695             return (1);
696         else 
697         {
698             uint256 z = x;
699             for (uint256 i=1; i < y; i++)
700                 z = mul(z,x);
701             return (z);
702         }
703     }
704 }