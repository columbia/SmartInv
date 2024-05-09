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
15     address private admin2;
16 //==============================================================================
17 //     _| _ _|_ _    _ _ _|_    _   .
18 //    (_|(_| | (_|  _\(/_ | |_||_)  .
19 //=============================|================================================    
20     uint256 public registrationFee_ = 10 finney;            // price to register a name
21     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
22     mapping(address => bytes32) public gameNames_;          // lookup a games name
23     mapping(address => uint256) public gameIDs_;            // lokup a games ID
24     uint256 public gID_;        // total number of games
25     uint256 public pID_;        // total number of players
26     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
27     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
28     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
29     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
30     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
31     struct Player {
32         address addr;
33         bytes32 name;
34         uint256 laff;
35         uint256 names;
36     }
37 //==============================================================================
38 //     _ _  _  __|_ _    __|_ _  _  .
39 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
40 //==============================================================================    
41     constructor(address founder) 
42     public 
43     {
44         admin2 = founder;
45          // No keys are purchased with this method, it's simply locking our addresses,
46         // PID's and names for referral codes.
47         plyr_[1].addr = 0x7e474fe5Cfb720804860215f407111183cbc2f85;
48         plyr_[1].name = "kenny";
49         plyr_[1].names = 1;
50         pIDxAddr_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = 1;
51         pIDxName_["kenny"] = 1;
52         plyrNames_[1]["kenny"] = true;
53         plyrNameList_[1][1] = "kenny";
54     }
55    
56 //==============================================================================
57 //     _ _  _  _|. |`. _  _ _  .
58 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
59 //==============================================================================    
60     /**
61      * @dev prevents contracts from interacting
62      */
63     modifier isHuman() {
64         address _addr = msg.sender;
65         uint256 _codeLength;
66         
67         assembly {_codeLength := extcodesize(_addr)}
68         require(_codeLength == 0);
69         require(_addr == tx.origin);
70         _;
71     }
72    
73     modifier onlyAdmin()
74     {
75         require(msg.sender == admin);
76         _;
77     }
78     
79     modifier isRegisteredGame()
80     {
81         require(gameIDs_[msg.sender] != 0);
82         _;
83     }
84 //==============================================================================
85 //     _    _  _ _|_ _  .
86 //    (/_\/(/_| | | _\  .
87 //==============================================================================    
88     // fired whenever a player registers a name
89     event onNewName
90     (
91         uint256 indexed playerID,
92         address indexed playerAddress,
93         bytes32 indexed playerName,
94         bool isNewPlayer,
95         uint256 affiliateID,
96         address affiliateAddress,
97         bytes32 affiliateName,
98         uint256 amountPaid,
99         uint256 timeStamp
100     );
101 //==============================================================================
102 //     _  _ _|__|_ _  _ _  .
103 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
104 //=====_|=======================================================================
105     function checkIfNameValid(string _nameStr)
106         public
107         view
108         returns(bool)
109     {
110         bytes32 _name = _nameStr.nameFilter();
111         if (pIDxName_[_name] == 0)
112             return (true);
113         else 
114             return (false);
115     }
116 //==============================================================================
117 //     _    |_ |. _   |`    _  __|_. _  _  _  .
118 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
119 //====|=========================================================================    
120     /**
121      * @dev registers a name.  UI will always display the last name you registered.
122      * but you will still own all previously registered names to use as affiliate 
123      * links.
124      * - must pay a registration fee.
125      * - name must be unique
126      * - names will be converted to lowercase
127      * - name cannot start or end with a space 
128      * - cannot have more than 1 space in a row
129      * - cannot be only numbers
130      * - cannot start with 0x 
131      * - name must be at least 1 char
132      * - max length of 32 characters long
133      * - allowed characters: a-z, 0-9, and space
134      * -functionhash- 0x921dec21 (using ID for affiliate)
135      * -functionhash- 0x3ddd4698 (using address for affiliate)
136      * -functionhash- 0x685ffd83 (using name for affiliate)
137      * @param _nameString players desired name
138      * @param _affCode affiliate ID, address, or name of who refered you
139      * @param _all set to true if you want this to push your info to all games 
140      * (this might cost a lot of gas)
141      */
142     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
143         isHuman()
144         public
145         payable 
146     {
147         // make sure name fees paid
148         require (msg.value >= registrationFee_);
149         
150         // filter name + condition checks
151         bytes32 _name = NameFilter.nameFilter(_nameString);
152         
153         // set up address 
154         address _addr = msg.sender;
155         
156         // set up our tx event data and determine if player is new or not
157         bool _isNewPlayer = determinePID(_addr);
158         
159         // fetch player id
160         uint256 _pID = pIDxAddr_[_addr];
161         
162         // manage affiliate residuals
163         // if no affiliate code was given, no new affiliate code was given, or the 
164         // player tried to use their own pID as an affiliate code
165         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
166         {
167             // update last affiliate 
168             plyr_[_pID].laff = _affCode;
169         } else if (_affCode == _pID) {
170             _affCode = 0;
171         }
172         
173         // register name 
174         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
175     }
176     
177     function registerNameXaddr(string _nameString, address _affCode, bool _all)
178         isHuman()
179         public
180         payable 
181     {
182         // make sure name fees paid
183         require (msg.value >= registrationFee_);
184         
185         // filter name + condition checks
186         bytes32 _name = NameFilter.nameFilter(_nameString);
187         
188         // set up address 
189         address _addr = msg.sender;
190         
191         // set up our tx event data and determine if player is new or not
192         bool _isNewPlayer = determinePID(_addr);
193         
194         // fetch player id
195         uint256 _pID = pIDxAddr_[_addr];
196         
197         // manage affiliate residuals
198         // if no affiliate code was given or player tried to use their own, lolz
199         uint256 _affID;
200         if (_affCode != address(0) && _affCode != _addr)
201         {
202             // get affiliate ID from aff Code 
203             _affID = pIDxAddr_[_affCode];
204             
205             // if affID is not the same as previously stored 
206             if (_affID != plyr_[_pID].laff)
207             {
208                 // update last affiliate
209                 plyr_[_pID].laff = _affID;
210             }
211         }
212         
213         // register name 
214         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
215     }
216     
217     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
218         isHuman()
219         public
220         payable 
221     {
222         // make sure name fees paid
223         require (msg.value >= registrationFee_);
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
238         // if no affiliate code was given or player tried to use their own, lolz
239         uint256 _affID;
240         if (_affCode != "" && _affCode != _name)
241         {
242             // get affiliate ID from aff Code 
243             _affID = pIDxName_[_affCode];
244             
245             // if affID is not the same as previously stored 
246             if (_affID != plyr_[_pID].laff)
247             {
248                 // update last affiliate
249                 plyr_[_pID].laff = _affID;
250             }
251         }
252         
253         // register name 
254         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
255     }
256     
257     /**
258      * @dev players, if you registered a profile, before a game was released, or
259      * set the all bool to false when you registered, use this function to push
260      * your profile to a single game.  also, if you've  updated your name, you
261      * can use this to push your name to games of your choosing.
262      * -functionhash- 0x81c5b206
263      * @param _gameID game id 
264      */
265     function addMeToGame(uint256 _gameID)
266         isHuman()
267         public
268     {
269         require(_gameID <= gID_);
270         address _addr = msg.sender;
271         uint256 _pID = pIDxAddr_[_addr];
272         require(_pID != 0);
273         uint256 _totalNames = plyr_[_pID].names;
274         
275         // add players profile and most recent name
276         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
277         
278         // add list of all names
279         if (_totalNames > 1)
280             for (uint256 ii = 1; ii <= _totalNames; ii++)
281                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
282     }
283     
284     
285     
286     /**
287      * @dev players use this to change back to one of your old names.  
288      * -functionhash- 0xb9291296
289      * @param _nameString the name you want to use 
290      */
291     function useMyOldName(string _nameString)
292         isHuman()
293         public 
294     {
295         // filter name, and get pID
296         bytes32 _name = _nameString.nameFilter();
297         uint256 _pID = pIDxAddr_[msg.sender];
298         
299         // make sure they own the name 
300         require(plyrNames_[_pID][_name] == true);
301         
302         // update their current name 
303         plyr_[_pID].name = _name;
304     }
305     
306 //==============================================================================
307 //     _ _  _ _   | _  _ . _  .
308 //    (_(_)| (/_  |(_)(_||(_  . 
309 //=====================_|=======================================================    
310     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
311         private
312     {
313         // if names already has been used, require that current msg sender owns the name
314         if (pIDxName_[_name] != 0)
315             require(plyrNames_[_pID][_name] == true);
316         
317         // add name to player profile, registry, and name book
318         plyr_[_pID].name = _name;
319         pIDxName_[_name] = _pID;
320         if (plyrNames_[_pID][_name] == false)
321         {
322             plyrNames_[_pID][_name] = true;
323             plyr_[_pID].names++;
324             plyrNameList_[_pID][plyr_[_pID].names] = _name;
325         }
326         uint256 founderFee = (address(this).balance / 2);
327         admin.transfer(founderFee);
328         admin2.transfer(founderFee);
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