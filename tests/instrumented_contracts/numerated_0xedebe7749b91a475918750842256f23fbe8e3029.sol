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
53         
54         pID_ = 1;
55     }
56    
57 //==============================================================================
58 //     _ _  _  _|. |`. _  _ _  .
59 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
60 //==============================================================================    
61     /**
62      * @dev prevents contracts from interacting
63      */
64     modifier isHuman() {
65         address _addr = msg.sender;
66         uint256 _codeLength;
67         
68         assembly {_codeLength := extcodesize(_addr)}
69         require(_codeLength == 0);
70         require(_addr == tx.origin);
71         _;
72     }
73    
74     modifier onlyAdmin()
75     {
76         require(msg.sender == admin);
77         _;
78     }
79     
80     modifier isRegisteredGame()
81     {
82         require(gameIDs_[msg.sender] != 0);
83         _;
84     }
85 //==============================================================================
86 //     _    _  _ _|_ _  .
87 //    (/_\/(/_| | | _\  .
88 //==============================================================================    
89     // fired whenever a player registers a name
90     event onNewName
91     (
92         uint256 indexed playerID,
93         address indexed playerAddress,
94         bytes32 indexed playerName,
95         bool isNewPlayer,
96         uint256 affiliateID,
97         address affiliateAddress,
98         bytes32 affiliateName,
99         uint256 amountPaid,
100         uint256 timeStamp
101     );
102 //==============================================================================
103 //     _  _ _|__|_ _  _ _  .
104 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
105 //=====_|=======================================================================
106     function checkIfNameValid(string _nameStr)
107         public
108         view
109         returns(bool)
110     {
111         bytes32 _name = _nameStr.nameFilter();
112         if (pIDxName_[_name] == 0)
113             return (true);
114         else 
115             return (false);
116     }
117 //==============================================================================
118 //     _    |_ |. _   |`    _  __|_. _  _  _  .
119 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
120 //====|=========================================================================    
121     /**
122      * @dev registers a name.  UI will always display the last name you registered.
123      * but you will still own all previously registered names to use as affiliate 
124      * links.
125      * - must pay a registration fee.
126      * - name must be unique
127      * - names will be converted to lowercase
128      * - name cannot start or end with a space 
129      * - cannot have more than 1 space in a row
130      * - cannot be only numbers
131      * - cannot start with 0x 
132      * - name must be at least 1 char
133      * - max length of 32 characters long
134      * - allowed characters: a-z, 0-9, and space
135      * -functionhash- 0x921dec21 (using ID for affiliate)
136      * -functionhash- 0x3ddd4698 (using address for affiliate)
137      * -functionhash- 0x685ffd83 (using name for affiliate)
138      * @param _nameString players desired name
139      * @param _affCode affiliate ID, address, or name of who refered you
140      * @param _all set to true if you want this to push your info to all games 
141      * (this might cost a lot of gas)
142      */
143     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
144         isHuman()
145         public
146         payable 
147     {
148         // make sure name fees paid
149         require (msg.value >= registrationFee_);
150         
151         // filter name + condition checks
152         bytes32 _name = NameFilter.nameFilter(_nameString);
153         
154         // set up address 
155         address _addr = msg.sender;
156         
157         // set up our tx event data and determine if player is new or not
158         bool _isNewPlayer = determinePID(_addr);
159         
160         // fetch player id
161         uint256 _pID = pIDxAddr_[_addr];
162         
163         // manage affiliate residuals
164         // if no affiliate code was given, no new affiliate code was given, or the 
165         // player tried to use their own pID as an affiliate code
166         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
167         {
168             // update last affiliate 
169             plyr_[_pID].laff = _affCode;
170         } else if (_affCode == _pID) {
171             _affCode = 0;
172         }
173         
174         // register name 
175         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
176     }
177     
178     function registerNameXaddr(string _nameString, address _affCode, bool _all)
179         isHuman()
180         public
181         payable 
182     {
183         // make sure name fees paid
184         require (msg.value >= registrationFee_);
185         
186         // filter name + condition checks
187         bytes32 _name = NameFilter.nameFilter(_nameString);
188         
189         // set up address 
190         address _addr = msg.sender;
191         
192         // set up our tx event data and determine if player is new or not
193         bool _isNewPlayer = determinePID(_addr);
194         
195         // fetch player id
196         uint256 _pID = pIDxAddr_[_addr];
197         
198         // manage affiliate residuals
199         // if no affiliate code was given or player tried to use their own, lolz
200         uint256 _affID;
201         if (_affCode != address(0) && _affCode != _addr)
202         {
203             // get affiliate ID from aff Code 
204             _affID = pIDxAddr_[_affCode];
205             
206             // if affID is not the same as previously stored 
207             if (_affID != plyr_[_pID].laff)
208             {
209                 // update last affiliate
210                 plyr_[_pID].laff = _affID;
211             }
212         }
213         
214         // register name 
215         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
216     }
217     
218     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
219         isHuman()
220         public
221         payable 
222     {
223         // make sure name fees paid
224         require (msg.value >= registrationFee_);
225         
226         // filter name + condition checks
227         bytes32 _name = NameFilter.nameFilter(_nameString);
228         
229         // set up address 
230         address _addr = msg.sender;
231         
232         // set up our tx event data and determine if player is new or not
233         bool _isNewPlayer = determinePID(_addr);
234         
235         // fetch player id
236         uint256 _pID = pIDxAddr_[_addr];
237         
238         // manage affiliate residuals
239         // if no affiliate code was given or player tried to use their own, lolz
240         uint256 _affID;
241         if (_affCode != "" && _affCode != _name)
242         {
243             // get affiliate ID from aff Code 
244             _affID = pIDxName_[_affCode];
245             
246             // if affID is not the same as previously stored 
247             if (_affID != plyr_[_pID].laff)
248             {
249                 // update last affiliate
250                 plyr_[_pID].laff = _affID;
251             }
252         }
253         
254         // register name 
255         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
256     }
257     
258     /**
259      * @dev players, if you registered a profile, before a game was released, or
260      * set the all bool to false when you registered, use this function to push
261      * your profile to a single game.  also, if you've  updated your name, you
262      * can use this to push your name to games of your choosing.
263      * -functionhash- 0x81c5b206
264      * @param _gameID game id 
265      */
266     function addMeToGame(uint256 _gameID)
267         isHuman()
268         public
269     {
270         require(_gameID <= gID_);
271         address _addr = msg.sender;
272         uint256 _pID = pIDxAddr_[_addr];
273         require(_pID != 0);
274         uint256 _totalNames = plyr_[_pID].names;
275         
276         // add players profile and most recent name
277         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
278         
279         // add list of all names
280         if (_totalNames > 1)
281             for (uint256 ii = 1; ii <= _totalNames; ii++)
282                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
283     }
284     
285     
286     
287     /**
288      * @dev players use this to change back to one of your old names.  
289      * -functionhash- 0xb9291296
290      * @param _nameString the name you want to use 
291      */
292     function useMyOldName(string _nameString)
293         isHuman()
294         public 
295     {
296         // filter name, and get pID
297         bytes32 _name = _nameString.nameFilter();
298         uint256 _pID = pIDxAddr_[msg.sender];
299         
300         // make sure they own the name 
301         require(plyrNames_[_pID][_name] == true);
302         
303         // update their current name 
304         plyr_[_pID].name = _name;
305     }
306     
307 //==============================================================================
308 //     _ _  _ _   | _  _ . _  .
309 //    (_(_)| (/_  |(_)(_||(_  . 
310 //=====================_|=======================================================    
311     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
312         private
313     {
314         // if names already has been used, require that current msg sender owns the name
315         if (pIDxName_[_name] != 0)
316             require(plyrNames_[_pID][_name] == true);
317         
318         // add name to player profile, registry, and name book
319         plyr_[_pID].name = _name;
320         pIDxName_[_name] = _pID;
321         if (plyrNames_[_pID][_name] == false)
322         {
323             plyrNames_[_pID][_name] = true;
324             plyr_[_pID].names++;
325             plyrNameList_[_pID][plyr_[_pID].names] = _name;
326         }
327         
328         admin.transfer(address(this).balance);
329         
330         // push player info to games
331         if (_all == true)
332             for (uint256 i = 1; i <= gID_; i++)
333                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
334         
335         // fire event
336         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
337     }
338 //==============================================================================
339 //    _|_ _  _ | _  .
340 //     | (_)(_)|_\  .
341 //==============================================================================    
342     function determinePID(address _addr)
343         private
344         returns (bool)
345     {
346         if (pIDxAddr_[_addr] == 0)
347         {
348             pID_++;
349             pIDxAddr_[_addr] = pID_;
350             plyr_[pID_].addr = _addr;
351             
352             // set the new player bool to true
353             return (true);
354         } else {
355             return (false);
356         }
357     }
358 //==============================================================================
359 //   _   _|_ _  _ _  _ |   _ _ || _  .
360 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
361 //==============================================================================
362     function getPlayerID(address _addr)
363         isRegisteredGame()
364         external
365         returns (uint256)
366     {
367         determinePID(_addr);
368         return (pIDxAddr_[_addr]);
369     }
370     function getPlayerName(uint256 _pID)
371         external
372         view
373         returns (bytes32)
374     {
375         return (plyr_[_pID].name);
376     }
377     function getPlayerLAff(uint256 _pID)
378         external
379         view
380         returns (uint256)
381     {
382         return (plyr_[_pID].laff);
383     }
384     function getPlayerAddr(uint256 _pID)
385         external
386         view
387         returns (address)
388     {
389         return (plyr_[_pID].addr);
390     }
391     function getNameFee()
392         external
393         view
394         returns (uint256)
395     {
396         return(registrationFee_);
397     }
398     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
399         isRegisteredGame()
400         external
401         payable
402         returns(bool, uint256)
403     {
404         // make sure name fees paid
405         require (msg.value >= registrationFee_);
406         
407         // set up our tx event data and determine if player is new or not
408         bool _isNewPlayer = determinePID(_addr);
409         
410         // fetch player id
411         uint256 _pID = pIDxAddr_[_addr];
412         
413         // manage affiliate residuals
414         // if no affiliate code was given, no new affiliate code was given, or the 
415         // player tried to use their own pID as an affiliate code
416         uint256 _affID = _affCode;
417         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
418         {
419             // update last affiliate 
420             plyr_[_pID].laff = _affID;
421         } else if (_affID == _pID) {
422             _affID = 0;
423         }
424         
425         // register name 
426         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
427         
428         return(_isNewPlayer, _affID);
429     }
430     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
431         isRegisteredGame()
432         external
433         payable
434         returns(bool, uint256)
435     {
436         // make sure name fees paid
437         require (msg.value >= registrationFee_);
438         
439         // set up our tx event data and determine if player is new or not
440         bool _isNewPlayer = determinePID(_addr);
441         
442         // fetch player id
443         uint256 _pID = pIDxAddr_[_addr];
444         
445         // manage affiliate residuals
446         // if no affiliate code was given or player tried to use their own
447         uint256 _affID;
448         if (_affCode != address(0) && _affCode != _addr)
449         {
450             // get affiliate ID from aff Code 
451             _affID = pIDxAddr_[_affCode];
452             
453             // if affID is not the same as previously stored 
454             if (_affID != plyr_[_pID].laff)
455             {
456                 // update last affiliate
457                 plyr_[_pID].laff = _affID;
458             }
459         }
460         
461         // register name 
462         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
463         
464         return(_isNewPlayer, _affID);
465     }
466     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
467         isRegisteredGame()
468         external
469         payable
470         returns(bool, uint256)
471     {
472         // make sure name fees paid
473         require (msg.value >= registrationFee_);
474         
475         // set up our tx event data and determine if player is new or not
476         bool _isNewPlayer = determinePID(_addr);
477         
478         // fetch player id
479         uint256 _pID = pIDxAddr_[_addr];
480         
481         // manage affiliate residuals
482         // if no affiliate code was given or player tried to use their own
483         uint256 _affID;
484         if (_affCode != "" && _affCode != _name)
485         {
486             // get affiliate ID from aff Code 
487             _affID = pIDxName_[_affCode];
488             
489             // if affID is not the same as previously stored 
490             if (_affID != plyr_[_pID].laff)
491             {
492                 // update last affiliate
493                 plyr_[_pID].laff = _affID;
494             }
495         }
496         
497         // register name 
498         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
499         
500         return(_isNewPlayer, _affID);
501     }
502     
503 //==============================================================================
504 //   _ _ _|_    _   .
505 //  _\(/_ | |_||_)  .
506 //=============|================================================================
507     function addGame(address _gameAddress, string _gameNameStr)
508         onlyAdmin()
509         public
510     {
511         require(gameIDs_[_gameAddress] == 0);
512             gID_++;
513             bytes32 _name = _gameNameStr.nameFilter();
514             gameIDs_[_gameAddress] = gID_;
515             gameNames_[_gameAddress] = _name;
516             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
517     }
518     
519     function setRegistrationFee(uint256 _fee)
520         onlyAdmin()
521         public
522 
523     {
524       registrationFee_ = _fee;
525     }
526         
527 } 
528 
529 
530 library NameFilter {
531     
532     /**
533      * @dev filters name strings
534      * -converts uppercase to lower case.  
535      * -makes sure it does not start/end with a space
536      * -makes sure it does not contain multiple spaces in a row
537      * -cannot be only numbers
538      * -cannot start with 0x 
539      * -restricts characters to A-Z, a-z, 0-9, and space.
540      * @return reprocessed string in bytes32 format
541      */
542     function nameFilter(string _input)
543         internal
544         pure
545         returns(bytes32)
546     {
547         bytes memory _temp = bytes(_input);
548         uint256 _length = _temp.length;
549         
550         //sorry limited to 32 characters
551         require (_length <= 32 && _length > 0);
552         // make sure it doesnt start with or end with space
553         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
554         // make sure first two characters are not 0x
555         if (_temp[0] == 0x30)
556         {
557             require(_temp[1] != 0x78);
558             require(_temp[1] != 0x58);
559         }
560         
561         // create a bool to track if we have a non number character
562         bool _hasNonNumber;
563         
564         // convert & check
565         for (uint256 i = 0; i < _length; i++)
566         {
567             // if its uppercase A-Z
568             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
569             {
570                 // convert to lower case a-z
571                 _temp[i] = byte(uint(_temp[i]) + 32);
572                 
573                 // we have a non number
574                 if (_hasNonNumber == false)
575                     _hasNonNumber = true;
576             } else {
577                 require
578                 (
579                     // require character is a space
580                     _temp[i] == 0x20 || 
581                     // OR lowercase a-z
582                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
583                     // or 0-9
584                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
585                 // make sure theres not 2x spaces in a row
586                 if (_temp[i] == 0x20)
587                     require( _temp[i+1] != 0x20);
588                 
589                 // see if we have a character other than a number
590                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
591                     _hasNonNumber = true;    
592             }
593         }
594         
595         require(_hasNonNumber == true);
596         
597         bytes32 _ret;
598         assembly {
599             _ret := mload(add(_temp, 32))
600         }
601         return (_ret);
602     }
603 }
604 
605 /**
606  * @title SafeMath v0.1.9
607  * @dev Math operations with safety checks that throw on error
608  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
609  * - added sqrt
610  * - added sq
611  * - added pwr 
612  * - changed asserts to requires with error log outputs
613  * - removed div, its useless
614  */
615 library SafeMath {
616     
617     /**
618     * @dev Multiplies two numbers, throws on overflow.
619     */
620     function mul(uint256 a, uint256 b) 
621         internal 
622         pure 
623         returns (uint256 c) 
624     {
625         if (a == 0) {
626             return 0;
627         }
628         c = a * b;
629         require(c / a == b, "SafeMath mul failed");
630         return c;
631     }
632 
633     /**
634     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
635     */
636     function sub(uint256 a, uint256 b)
637         internal
638         pure
639         returns (uint256) 
640     {
641         require(b <= a, "SafeMath sub failed");
642         return a - b;
643     }
644 
645     /**
646     * @dev Adds two numbers, throws on overflow.
647     */
648     function add(uint256 a, uint256 b)
649         internal
650         pure
651         returns (uint256 c) 
652     {
653         c = a + b;
654         require(c >= a, "SafeMath add failed");
655         return c;
656     }
657     
658     /**
659      * @dev gives square root of given x.
660      */
661     function sqrt(uint256 x)
662         internal
663         pure
664         returns (uint256 y) 
665     {
666         uint256 z = ((add(x,1)) / 2);
667         y = x;
668         while (z < y) 
669         {
670             y = z;
671             z = ((add((x / z),z)) / 2);
672         }
673     }
674     
675     /**
676      * @dev gives square. multiplies x by x
677      */
678     function sq(uint256 x)
679         internal
680         pure
681         returns (uint256)
682     {
683         return (mul(x,x));
684     }
685     
686     /**
687      * @dev x to the power of y 
688      */
689     function pwr(uint256 x, uint256 y)
690         internal 
691         pure 
692         returns (uint256)
693     {
694         if (x==0)
695             return (0);
696         else if (y==0)
697             return (1);
698         else 
699         {
700             uint256 z = x;
701             for (uint256 i=1; i < y; i++)
702                 z = mul(z,x);
703             return (z);
704         }
705     }
706 }