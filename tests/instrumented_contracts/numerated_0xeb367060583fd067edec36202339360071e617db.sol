1 pragma solidity ^0.4.24;
2 interface PlayerBookReceiverInterface {
3     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
4     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
5 }
6 
7 
8 contract PlayerBook {
9     using NameFilter for string;
10     using SafeMath for uint256;
11      
12     address private _owner;
13     
14     uint256 public registrationFee_ = 10 finney;            // price to register a name
15     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
16     mapping(address => bytes32) public gameNames_;          // lookup a games name
17     mapping(address => uint256) public gameIDs_;            // lokup a games ID
18     uint256 public gID_;        // total number of games
19     uint256 public pID_;        // total number of players
20     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
21     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
22     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
23     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
24     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
25     struct Player {
26         address addr;
27         bytes32 name;
28         uint256 laff;
29         uint256 names;
30     }
31     constructor()
32         public
33     {
34         _owner = msg.sender;
35     }
36     
37     modifier isHuman() {
38         address _addr = msg.sender;
39         uint256 _codeLength;
40         
41         assembly {_codeLength := extcodesize(_addr)}
42         require(_codeLength == 0, "sorry humans only");
43         _;
44     }
45     
46     modifier onlyOwner() 
47     {
48         require(msg.sender == _owner, "msg sender is not owner");
49         _;
50     }
51     
52     modifier isRegisteredGame()
53     {
54         require(gameIDs_[msg.sender] != 0);
55         _;
56     } 
57     // fired whenever a player registers a name
58     event onNewName
59     (
60         uint256 indexed playerID,
61         address indexed playerAddress,
62         bytes32 indexed playerName,
63         bool isNewPlayer,
64         uint256 affiliateID,
65         address affiliateAddress,
66         bytes32 affiliateName,
67         uint256 amountPaid,
68         uint256 timeStamp
69     );
70     function checkIfNameValid(string _nameStr)
71         public
72         view
73         returns(bool)
74     {
75         bytes32 _name = _nameStr.nameFilter();
76         if (pIDxName_[_name] == 0)
77             return (true);
78         else 
79             return (false);
80     }
81     /**
82      * @dev registers a name.  UI will always display the last name you registered.
83      * but you will still own all previously registered names to use as affiliate 
84      * links.
85      * - must pay a registration fee.
86      * - name must be unique
87      * - names will be converted to lowercase
88      * - name cannot start or end with a space 
89      * - cannot have more than 1 space in a row
90      * - cannot be only numbers
91      * - cannot start with 0x 
92      * - name must be at least 1 char
93      * - max length of 32 characters long
94      * - allowed characters: a-z, 0-9, and space
95      * -functionhash- 0x921dec21 (using ID for affiliate)
96      * -functionhash- 0x3ddd4698 (using address for affiliate)
97      * -functionhash- 0x685ffd83 (using name for affiliate)
98      * @param _nameString players desired name
99      * @param _affCode affiliate ID, address, or name of who refered you
100      * @param _all set to true if you want this to push your info to all games 
101      * (this might cost a lot of gas)
102      */
103     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
104         isHuman()
105         public
106         payable 
107     {
108         // make sure name fees paid
109         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
110         
111         // filter name + condition checks
112         bytes32 _name = NameFilter.nameFilter(_nameString);
113         
114         // set up address 
115         address _addr = msg.sender;
116         
117         // set up our tx event data and determine if player is new or not
118         bool _isNewPlayer = determinePID(_addr);
119         
120         // fetch player id
121         uint256 _pID = pIDxAddr_[_addr];
122         
123         // manage affiliate residuals
124         // if no affiliate code was given, no new affiliate code was given, or the 
125         // player tried to use their own pID as an affiliate code, lolz
126         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
127         {
128             // update last affiliate 
129             plyr_[_pID].laff = _affCode;
130         } else if (_affCode == _pID) {
131             _affCode = 0;
132         }
133         
134         // register name 
135         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
136     }
137     
138     function registerNameXaddr(string _nameString, address _affCode, bool _all)
139         isHuman()
140         public
141         payable 
142     {
143         // make sure name fees paid
144         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
145         
146         // filter name + condition checks
147         bytes32 _name = NameFilter.nameFilter(_nameString);
148         
149         // set up address 
150         address _addr = msg.sender;
151         
152         // set up our tx event data and determine if player is new or not
153         bool _isNewPlayer = determinePID(_addr);
154         
155         // fetch player id
156         uint256 _pID = pIDxAddr_[_addr];
157         
158         // manage affiliate residuals
159         // if no affiliate code was given or player tried to use their own, lolz
160         uint256 _affID;
161         if (_affCode != address(0) && _affCode != _addr)
162         {
163             // get affiliate ID from aff Code 
164             _affID = pIDxAddr_[_affCode];
165             
166             // if affID is not the same as previously stored 
167             if (_affID != plyr_[_pID].laff)
168             {
169                 // update last affiliate
170                 plyr_[_pID].laff = _affID;
171             }
172         }
173         
174         // register name 
175         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
176     }
177     
178     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
179         isHuman()
180         public
181         payable 
182     {
183         // make sure name fees paid
184         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
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
201         if (_affCode != "" && _affCode != _name)
202         {
203             // get affiliate ID from aff Code 
204             _affID = pIDxName_[_affCode];
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
218     /**
219      * @dev players, if you registered a profile, before a game was released, or
220      * set the all bool to false when you registered, use this function to push
221      * your profile to a single game.  also, if you've  updated your name, you
222      * can use this to push your name to games of your choosing.
223      * -functionhash- 0x81c5b206
224      * @param _gameID game id 
225      */
226     function addMeToGame(uint256 _gameID)
227         isHuman()
228         public
229     {
230         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
231         address _addr = msg.sender;
232         uint256 _pID = pIDxAddr_[_addr];
233         require(_pID != 0, "hey there buddy, you dont even have an account");
234         uint256 _totalNames = plyr_[_pID].names;
235         
236         // add players profile and most recent name
237         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
238         
239         // add list of all names
240         if (_totalNames > 1)
241             for (uint256 ii = 1; ii <= _totalNames; ii++)
242                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
243     }
244     
245     /**
246      * @dev players, use this to push your player profile to all registered games.
247      * -functionhash- 0x0c6940ea
248      */
249     function addMeToAllGames()
250         isHuman()
251         public
252     {
253         address _addr = msg.sender;
254         uint256 _pID = pIDxAddr_[_addr];
255         require(_pID != 0, "hey there buddy, you dont even have an account");
256         uint256 _laff = plyr_[_pID].laff;
257         uint256 _totalNames = plyr_[_pID].names;
258         bytes32 _name = plyr_[_pID].name;
259         
260         for (uint256 i = 1; i <= gID_; i++)
261         {
262             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
263             if (_totalNames > 1)
264                 for (uint256 ii = 1; ii <= _totalNames; ii++)
265                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
266         }
267                 
268     }
269     
270     /**
271      * @dev players use this to change back to one of your old names.  tip, you'll
272      * still need to push that info to existing games.
273      * -functionhash- 0xb9291296
274      * @param _nameString the name you want to use 
275      */
276     function useMyOldName(string _nameString)
277         isHuman()
278         public 
279     {
280         // filter name, and get pID
281         bytes32 _name = _nameString.nameFilter();
282         uint256 _pID = pIDxAddr_[msg.sender];
283         
284         // make sure they own the name 
285         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
286         
287         // update their current name 
288         plyr_[_pID].name = _name;
289     }
290     
291     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
292         private
293     {
294         // if names already has been used, require that current msg sender owns the name
295         if (pIDxName_[_name] != 0)
296             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
297         
298         // add name to player profile, registry, and name book
299         plyr_[_pID].name = _name;
300         pIDxName_[_name] = _pID;
301         if (plyrNames_[_pID][_name] == false)
302         {
303             plyrNames_[_pID][_name] = true;
304             plyr_[_pID].names++;
305             plyrNameList_[_pID][plyr_[_pID].names] = _name;
306         }
307         
308         // registration fee goes directly to community rewards
309         _owner.transfer(address(this).balance);
310         // Jekyll_Island_Inc.deposit.value(address(this).balance)();
311         
312         // push player info to games
313         if (_all == true)
314             for (uint256 i = 1; i <= gID_; i++)
315                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
316         
317         // fire event
318         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
319     } 
320     function determinePID(address _addr)
321         private
322         returns (bool)
323     {
324         if (pIDxAddr_[_addr] == 0)
325         {
326             pID_++;
327             pIDxAddr_[_addr] = pID_;
328             plyr_[pID_].addr = _addr;
329             
330             // set the new player bool to true
331             return (true);
332         } else {
333             return (false);
334         }
335     }
336     function getPlayerID(address _addr)
337         isRegisteredGame()
338         external
339         returns (uint256)
340     {
341         determinePID(_addr);
342         return (pIDxAddr_[_addr]);
343     }
344     function getPlayerName(uint256 _pID)
345         external
346         view
347         returns (bytes32)
348     {
349         return (plyr_[_pID].name);
350     }
351     function getPlayerLAff(uint256 _pID)
352         external
353         view
354         returns (uint256)
355     {
356         return (plyr_[_pID].laff);
357     }
358     function getPlayerAddr(uint256 _pID)
359         external
360         view
361         returns (address)
362     {
363         return (plyr_[_pID].addr);
364     }
365     function getNameFee()
366         external
367         view
368         returns (uint256)
369     {
370         return(registrationFee_);
371     }
372     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
373         isRegisteredGame()
374         external
375         payable
376         returns(bool, uint256)
377     {
378         // make sure name fees paid
379         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
380         
381         // set up our tx event data and determine if player is new or not
382         bool _isNewPlayer = determinePID(_addr);
383         
384         // fetch player id
385         uint256 _pID = pIDxAddr_[_addr];
386         
387         // manage affiliate residuals
388         // if no affiliate code was given, no new affiliate code was given, or the 
389         // player tried to use their own pID as an affiliate code, lolz
390         uint256 _affID = _affCode;
391         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
392         {
393             // update last affiliate 
394             plyr_[_pID].laff = _affID;
395         } else if (_affID == _pID) {
396             _affID = 0;
397         }
398         
399         // register name 
400         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
401         
402         return(_isNewPlayer, _affID);
403     }
404     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
405         isRegisteredGame()
406         external
407         payable
408         returns(bool, uint256)
409     {
410         // make sure name fees paid
411         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
412         
413         // set up our tx event data and determine if player is new or not
414         bool _isNewPlayer = determinePID(_addr);
415         
416         // fetch player id
417         uint256 _pID = pIDxAddr_[_addr];
418         
419         // manage affiliate residuals
420         // if no affiliate code was given or player tried to use their own, lolz
421         uint256 _affID;
422         if (_affCode != address(0) && _affCode != _addr)
423         {
424             // get affiliate ID from aff Code 
425             _affID = pIDxAddr_[_affCode];
426             
427             // if affID is not the same as previously stored 
428             if (_affID != plyr_[_pID].laff)
429             {
430                 // update last affiliate
431                 plyr_[_pID].laff = _affID;
432             }
433         }
434         
435         // register name 
436         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
437         
438         return(_isNewPlayer, _affID);
439     }
440     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
441         isRegisteredGame()
442         external
443         payable
444         returns(bool, uint256)
445     {
446         // make sure name fees paid
447         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
448         
449         // set up our tx event data and determine if player is new or not
450         bool _isNewPlayer = determinePID(_addr);
451         
452         // fetch player id
453         uint256 _pID = pIDxAddr_[_addr];
454         
455         // manage affiliate residuals
456         // if no affiliate code was given or player tried to use their own, lolz
457         uint256 _affID;
458         if (_affCode != "" && _affCode != _name)
459         {
460             // get affiliate ID from aff Code 
461             _affID = pIDxName_[_affCode];
462             
463             // if affID is not the same as previously stored 
464             if (_affID != plyr_[_pID].laff)
465             {
466                 // update last affiliate
467                 plyr_[_pID].laff = _affID;
468             }
469         }
470         
471         // register name 
472         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
473         
474         return(_isNewPlayer, _affID);
475     }
476     
477     function addGame(address _gameAddress, string _gameNameStr)
478         onlyOwner()
479         public
480     {
481         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
482         
483         gID_++;
484         bytes32 _name = _gameNameStr.nameFilter();
485         gameIDs_[_gameAddress] = gID_;
486         gameNames_[_gameAddress] = _name;
487         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
488     
489         // games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
490         // games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
491         // games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
492         // games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
493     }
494     
495     function setRegistrationFee(uint256 _fee)
496         onlyOwner()
497         public
498     {
499         registrationFee_ = _fee;
500     }
501         
502 } 
503 
504 library NameFilter {
505     
506     /**
507      * @dev filters name strings
508      * -converts uppercase to lower case.  
509      * -makes sure it does not start/end with a space
510      * -makes sure it does not contain multiple spaces in a row
511      * -cannot be only numbers
512      * -cannot start with 0x 
513      * -restricts characters to A-Z, a-z, 0-9, and space.
514      * @return reprocessed string in bytes32 format
515      */
516     function nameFilter(string _input)
517         internal
518         pure
519         returns(bytes32)
520     {
521         bytes memory _temp = bytes(_input);
522         uint256 _length = _temp.length;
523         
524         //sorry limited to 32 characters
525         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
526         // make sure it doesnt start with or end with space
527         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
528         // make sure first two characters are not 0x
529         if (_temp[0] == 0x30)
530         {
531             require(_temp[1] != 0x78, "string cannot start with 0x");
532             require(_temp[1] != 0x58, "string cannot start with 0X");
533         }
534         
535         // create a bool to track if we have a non number character
536         bool _hasNonNumber;
537         
538         // convert & check
539         for (uint256 i = 0; i < _length; i++)
540         {
541             // if its uppercase A-Z
542             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
543             {
544                 // convert to lower case a-z
545                 _temp[i] = byte(uint(_temp[i]) + 32);
546                 
547                 // we have a non number
548                 if (_hasNonNumber == false)
549                     _hasNonNumber = true;
550             } else {
551                 require
552                 (
553                     // require character is a space
554                     _temp[i] == 0x20 || 
555                     // OR lowercase a-z
556                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
557                     // or 0-9
558                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
559                     "string contains invalid characters"
560                 );
561                 // make sure theres not 2x spaces in a row
562                 if (_temp[i] == 0x20)
563                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
564                 
565                 // see if we have a character other than a number
566                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
567                     _hasNonNumber = true;    
568             }
569         }
570         
571         require(_hasNonNumber == true, "string cannot be only numbers");
572         
573         bytes32 _ret;
574         assembly {
575             _ret := mload(add(_temp, 32))
576         }
577         return (_ret);
578     }
579 }
580 
581 /**
582  * @title SafeMath v0.1.9
583  * @dev Math operations with safety checks that throw on error
584  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
585  * - added sqrt
586  * - added sq
587  * - added pwr 
588  * - changed asserts to requires with error log outputs
589  * - removed div, its useless
590  */
591 library SafeMath {
592     
593     /**
594     * @dev Multiplies two numbers, throws on overflow.
595     */
596     function mul(uint256 a, uint256 b) 
597         internal 
598         pure 
599         returns (uint256 c) 
600     {
601         if (a == 0) {
602             return 0;
603         }
604         c = a * b;
605         require(c / a == b, "SafeMath mul failed");
606         return c;
607     }
608 
609     /**
610     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
611     */
612     function sub(uint256 a, uint256 b)
613         internal
614         pure
615         returns (uint256) 
616     {
617         require(b <= a, "SafeMath sub failed");
618         return a - b;
619     }
620 
621     /**
622     * @dev Adds two numbers, throws on overflow.
623     */
624     function add(uint256 a, uint256 b)
625         internal
626         pure
627         returns (uint256 c) 
628     {
629         c = a + b;
630         require(c >= a, "SafeMath add failed");
631         return c;
632     }
633     
634     /**
635      * @dev gives square root of given x.
636      */
637     function sqrt(uint256 x)
638         internal
639         pure
640         returns (uint256 y) 
641     {
642         uint256 z = ((add(x,1)) / 2);
643         y = x;
644         while (z < y) 
645         {
646             y = z;
647             z = ((add((x / z),z)) / 2);
648         }
649     }
650     
651     /**
652      * @dev gives square. multiplies x by x
653      */
654     function sq(uint256 x)
655         internal
656         pure
657         returns (uint256)
658     {
659         return (mul(x,x));
660     }
661     
662     /**
663      * @dev x to the power of y 
664      */
665     function pwr(uint256 x, uint256 y)
666         internal 
667         pure 
668         returns (uint256)
669     {
670         if (x==0)
671             return (0);
672         else if (y==0)
673             return (1);
674         else 
675         {
676             uint256 z = x;
677             for (uint256 i=1; i < y; i++)
678                 z = mul(z,x);
679             return (z);
680         }
681     }
682 }