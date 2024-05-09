1 pragma solidity ^0.4.25;
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
15     address public FundEIF = 0x0111E8A755a4212E6E1f13e75b1EABa8f837a213;
16     address public PoEIF = 0xFfB8ccA6D55762dF595F21E78f21CD8DfeadF1C8;
17 //==============================================================================
18 //     _| _ _|_ _    _ _ _|_    _   .
19 //    (_|(_| | (_|  _\(/_ | |_||_)  .
20 //=============================|================================================    
21     uint256 public registrationFee_ = 10 finney;            // price to register a name
22     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
23     mapping(address => bytes32) public gameNames_;          // lookup a games name
24     mapping(address => uint256) public gameIDs_;            // lokup a games ID
25     uint256 public gID_;        // total number of games
26     uint256 public pID_;        // total number of players
27     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
28     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
29     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
30     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
31     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
32     struct Player {
33         address addr;
34         bytes32 name;
35         uint256 laff;
36         uint256 names;
37     }
38 //==============================================================================
39 //     _ _  _  __|_ _    __|_ _  _  .
40 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
41 //==============================================================================    
42     constructor() 
43     public 
44     {
45         // dev name
46         plyr_[1].addr = admin;
47         plyr_[1].name = "play";
48         plyr_[1].names = 1;
49         pIDxAddr_[admin] = 1;
50         pIDxName_["play"] = 1;
51         plyrNames_[1]["play"] = true;
52         plyrNameList_[1][1] = "play";
53         pID_ = 1;
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
326         
327         
328         // EIF is sent fees through other FundEIF function manually
329        
330         
331         // push player info to games
332         if (_all == true)
333             for (uint256 i = 1; i <= gID_; i++)
334                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
335         
336         // fire event
337         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
338     }
339 //==============================================================================
340 //    _|_ _  _ | _  .
341 //     | (_)(_)|_\  .
342 //==============================================================================    
343     
344      function updateFundAddress(address _newAddress)
345         onlyAdmin()
346         public
347     {
348         FundEIF = _newAddress;
349     }
350 
351 
352     function payFund() public {   //Registration fee goes to EIF - function must be called manually so enough gas is sent
353         if(!FundEIF.call.value(address(this).balance)()) {
354             revert();
355         }
356     }
357 
358 
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
422         require (msg.value >= registrationFee_);
423         
424         // set up our tx event data and determine if player is new or not
425         bool _isNewPlayer = determinePID(_addr);
426         
427         // fetch player id
428         uint256 _pID = pIDxAddr_[_addr];
429         
430         // manage affiliate residuals
431         // if no affiliate code was given, no new affiliate code was given, or the 
432         // player tried to use their own pID as an affiliate code
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
454         require (msg.value >= registrationFee_);
455         
456         // set up our tx event data and determine if player is new or not
457         bool _isNewPlayer = determinePID(_addr);
458         
459         // fetch player id
460         uint256 _pID = pIDxAddr_[_addr];
461         
462         // manage affiliate residuals
463         // if no affiliate code was given or player tried to use their own
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
490         require (msg.value >= registrationFee_);
491         
492         // set up our tx event data and determine if player is new or not
493         bool _isNewPlayer = determinePID(_addr);
494         
495         // fetch player id
496         uint256 _pID = pIDxAddr_[_addr];
497         
498         // manage affiliate residuals
499         // if no affiliate code was given or player tried to use their own
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
525         onlyAdmin()
526         public
527     {
528         require(gameIDs_[_gameAddress] == 0);
529             gID_++;
530             bytes32 _name = _gameNameStr.nameFilter();
531             gameIDs_[_gameAddress] = gID_;
532             gameNames_[_gameAddress] = _name;
533             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
534     }
535     
536     function setRegistrationFee(uint256 _fee)
537         onlyAdmin()
538         public
539 
540     {
541       registrationFee_ = _fee;
542     }
543         
544 } 
545 
546 
547 library NameFilter {
548     
549     /**
550      * @dev filters name strings
551      * -converts uppercase to lower case.  
552      * -makes sure it does not start/end with a space
553      * -makes sure it does not contain multiple spaces in a row
554      * -cannot be only numbers
555      * -cannot start with 0x 
556      * -restricts characters to A-Z, a-z, 0-9, and space.
557      * @return reprocessed string in bytes32 format
558      */
559     function nameFilter(string _input)
560         internal
561         pure
562         returns(bytes32)
563     {
564         bytes memory _temp = bytes(_input);
565         uint256 _length = _temp.length;
566         
567         //sorry limited to 32 characters
568         require (_length <= 32 && _length > 0);
569         // make sure it doesnt start with or end with space
570         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
571         // make sure first two characters are not 0x
572         if (_temp[0] == 0x30)
573         {
574             require(_temp[1] != 0x78);
575             require(_temp[1] != 0x58);
576         }
577         
578         // create a bool to track if we have a non number character
579         bool _hasNonNumber;
580         
581         // convert & check
582         for (uint256 i = 0; i < _length; i++)
583         {
584             // if its uppercase A-Z
585             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
586             {
587                 // convert to lower case a-z
588                 _temp[i] = byte(uint(_temp[i]) + 32);
589                 
590                 // we have a non number
591                 if (_hasNonNumber == false)
592                     _hasNonNumber = true;
593             } else {
594                 require
595                 (
596                     // require character is a space
597                     _temp[i] == 0x20 || 
598                     // OR lowercase a-z
599                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
600                     // or 0-9
601                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
602                 // make sure theres not 2x spaces in a row
603                 if (_temp[i] == 0x20)
604                     require( _temp[i+1] != 0x20);
605                 
606                 // see if we have a character other than a number
607                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
608                     _hasNonNumber = true;    
609             }
610         }
611         
612         require(_hasNonNumber == true);
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
638         internal 
639         pure 
640         returns (uint256 c) 
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
654         internal
655         pure
656         returns (uint256) 
657     {
658         require(b <= a, "SafeMath sub failed");
659         return a - b;
660     }
661 
662     /**
663     * @dev Adds two numbers, throws on overflow.
664     */
665     function add(uint256 a, uint256 b)
666         internal
667         pure
668         returns (uint256 c) 
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
679         internal
680         pure
681         returns (uint256 y) 
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
696         internal
697         pure
698         returns (uint256)
699     {
700         return (mul(x,x));
701     }
702     
703     /**
704      * @dev x to the power of y 
705      */
706     function pwr(uint256 x, uint256 y)
707         internal 
708         pure 
709         returns (uint256)
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