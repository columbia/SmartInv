1 pragma solidity 0.4.25;
2 
3 // File: contracts\lib\NameFilter.sol
4 
5 library NameFilter {
6     
7     /**
8      * @dev filters name strings
9      * -converts uppercase to lower case.  
10      * -makes sure it does not start/end with a space
11      * -makes sure it does not contain multiple spaces in a row
12      * -cannot be only numbers
13      * -cannot start with 0x 
14      * -restricts characters to A-Z, a-z, 0-9, and space.
15      * @return reprocessed string in bytes32 format
16      */
17     function nameFilter(string _input)
18         internal
19         pure
20         returns(bytes32)
21     {
22         bytes memory _temp = bytes(_input);
23         uint256 _length = _temp.length;
24         
25         //sorry limited to 32 characters
26         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
27         // make sure it doesnt start with or end with space
28         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
29         // make sure first two characters are not 0x
30         if (_temp[0] == 0x30)
31         {
32             require(_temp[1] != 0x78, "string cannot start with 0x");
33             require(_temp[1] != 0x58, "string cannot start with 0X");
34         }
35         
36         // create a bool to track if we have a non number character
37         bool _hasNonNumber;
38         
39         // convert & check
40         for (uint256 i = 0; i < _length; i++)
41         {
42             // if its uppercase A-Z
43             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
44             {
45                 // convert to lower case a-z
46                 _temp[i] = byte(uint(_temp[i]) + 32);
47                 
48                 // we have a non number
49                 if (_hasNonNumber == false)
50                     _hasNonNumber = true;
51             } else {
52                 require
53                 (
54                     // require character is a space
55                     _temp[i] == 0x20 || 
56                     // OR lowercase a-z
57                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
58                     // or 0-9
59                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
60                     "string contains invalid characters"
61                 );
62                 // make sure theres not 2x spaces in a row
63                 if (_temp[i] == 0x20)
64                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
65                 
66                 // see if we have a character other than a number
67                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
68                     _hasNonNumber = true;    
69             }
70         }
71         
72         require(_hasNonNumber == true, "string cannot be only numbers");
73         
74         bytes32 _ret;
75         assembly {
76             _ret := mload(add(_temp, 32))
77         }
78         return (_ret);
79     }
80 }
81 
82 // File: contracts\lib\SafeMath.sol
83 
84 /// @title SafeMath v0.1.9
85 /// @dev Math operations with safety checks that throw on error
86 /// change notes: original SafeMath library from OpenZeppelin modified by Inventor
87 /// - added sqrt
88 /// - added sq
89 /// - added pwr 
90 /// - changed asserts to requires with error log outputs
91 /// - removed div, its useless
92 library SafeMath {
93     
94     /// @dev Multiplies two numbers, throws on overflow.
95     function mul(uint256 a, uint256 b) 
96         internal 
97         pure 
98         returns (uint256 c) 
99     {
100         if (a == 0) {
101             return 0;
102         }
103         c = a * b;
104         require(c / a == b, "SafeMath mul failed");
105         return c;
106     }
107 
108 
109     /// @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110     function sub(uint256 a, uint256 b)
111         internal
112         pure
113         returns (uint256) 
114     {
115         require(b <= a, "SafeMath sub failed");
116         return a - b;
117     }
118 
119 
120     /// @dev Adds two numbers, throws on overflow.
121     function add(uint256 a, uint256 b)
122         internal
123         pure
124         returns (uint256 c) 
125     {
126         c = a + b;
127         require(c >= a, "SafeMath add failed");
128         return c;
129     }
130     
131 
132     /// @dev gives square root of given x.
133     function sqrt(uint256 x)
134         internal
135         pure
136         returns (uint256 y) 
137     {
138         uint256 z = ((add(x, 1)) / 2);
139         y = x;
140         while (z < y) {
141             y = z;
142             z = ((add((x / z), z)) / 2);
143         }
144     }
145 
146 
147     /// @dev gives square. multiplies x by x
148     function sq(uint256 x)
149         internal
150         pure
151         returns (uint256)
152     {
153         return (mul(x,x));
154     }
155 
156 
157     /// @dev x to the power of y 
158     function pwr(uint256 x, uint256 y)
159         internal 
160         pure 
161         returns (uint256)
162     {
163         if (x == 0) {
164             return (0);
165         } else if (y == 0) {
166             return (1);
167         } else {
168             uint256 z = x;
169             for (uint256 i = 1; i < y; i++) {
170                 z = mul(z,x);
171             }
172             return (z);
173         }
174     }
175 }
176 
177 // File: contracts\lib\Ownable.sol
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185     address public owner;
186     address public dev;
187 
188     /**
189     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190     * account.
191     */
192     constructor() public {
193         owner = msg.sender;
194     }
195 
196 
197     /**
198     * @dev Throws if called by any account other than the owner.
199     */
200     modifier onlyOwner() {
201         require(msg.sender == owner, "only owner");
202         _;
203     }
204 
205     /**
206     * @dev Throws if called by any account other than the dev.
207     */
208     modifier onlyDev() {
209         require(msg.sender == dev, "only dev");
210         _;
211     }
212 
213     /**
214     * @dev Throws if called by any account other than the owner or dev.
215     */
216     modifier onlyDevOrOwner() {
217         require(msg.sender == owner || msg.sender == dev, "only owner or dev");
218         _;
219     }
220 
221     /**
222     * @dev Allows the current owner to transfer control of the contract to a newOwner.
223     * @param newOwner The address to transfer ownership to.
224     */
225     function transferOwnership(address newOwner) onlyOwner public {
226         if (newOwner != address(0)) {
227             owner = newOwner;
228         }
229     }
230 
231     /**
232     * @dev Allows the current owner to set a new dev address.
233     * @param newDev The new dev address.
234     */
235     function setDev(address newDev) onlyOwner public {
236         if (newDev != address(0)) {
237             dev = newDev;
238         }
239     }
240 }
241 
242 // File: contracts\interface\BMForwarderInterface.sol
243 
244 interface BMForwarderInterface {
245     function deposit() external payable;
246 }
247 
248 // File: contracts\BMPlayerBook.sol
249 
250 /// @title Contract for managing player names and affiliate payments.
251 /// @notice This contract manages player names and affiliate payments
252 /// from registered games. Players can buy multiple names and select
253 /// which name to be used. Players who buy affiliate memberships can
254 /// receive affiliate payments from registered games.
255 /// Players can withdraw affiliate payments at any time.
256 /// @dev The address of the forwarder is hardcoded. Check 'TODO' before
257 /// deploy.
258 contract BMPlayerBook is Ownable {
259     using NameFilter for string;
260     using SafeMath for uint256;
261 
262     // TODO : CHECK THE ADDRESS!!!
263     BMForwarderInterface private Banker_Address;
264 
265     // data    
266     uint256 public registrationFee_ = 10 finney;            // price to register a name
267     uint256 public affiliateFee_ = 500 finney;              // price to become an affiliate
268     uint256 public pID_;        // total number of players
269 
270     // (addr => pID) returns player id by address
271     mapping (address => uint256) public pIDxAddr_;
272     // (name => pID) returns player id by name
273     mapping (bytes32 => uint256) public pIDxName_;
274     // (pID => data) player data
275     mapping (uint256 => Player) public plyr_;
276     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
277     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
278     // (pID => nameNum => name) list of names a player owns
279     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_;
280     // registered games
281     mapping (address => bool) public registeredGames_;
282 
283 
284     struct Player {
285         address addr;
286         bytes32 name;
287         bool hasAff;
288 
289         uint256 aff;
290         uint256 withdrawnAff;
291 
292         uint256 laff;
293         uint256 affT2;
294         uint256 names;
295     }
296 
297 
298     // constructor
299     constructor()
300         public
301     {
302         pID_ = 0;
303     }
304 
305     // modifiers
306     
307     /// @dev prevents contracts from interacting with playerbook
308     modifier isHuman() {
309         address _addr = msg.sender;
310         require (_addr == tx.origin, "Human only");
311 
312         uint256 _codeLength;
313         assembly { _codeLength := extcodesize(_addr) }
314         require(_codeLength == 0, "Human only");
315         _;
316     }
317     
318     /// @dev Check if caller is registered.
319     modifier isRegisteredGame() {
320         require(registeredGames_[msg.sender] == true, "sender is not registered");
321         _;
322     }
323     
324     // events
325 
326     event onNewName
327     (
328         uint256 indexed playerID,
329         address indexed playerAddress,
330         bytes32 indexed playerName,
331         bool isNewPlayer,
332         uint256 affiliateID,
333         address affiliateAddress,
334         bytes32 affiliateName,
335         uint256 amountPaid,
336         uint256 timestamp
337     );
338 
339     event onNewAffiliate
340     (
341         uint256 indexed playerID,
342         address indexed playerAddress,
343         bytes32 indexed playerName,
344         uint256 amountPaid,
345         uint256 timestamp
346     );
347 
348     event onUseOldName
349     (
350         uint256 indexed playerID,
351         address indexed playerAddress,
352         bytes32 indexed playerName,
353         uint256 timestamp
354     );
355 
356     event onGameRegistered
357     (
358         address indexed gameAddress,
359         bool enabled,
360         uint256 timestamp
361     );
362 
363     event onWithdraw
364     (
365         uint256 indexed playerID,
366         address indexed playerAddress,
367         bytes32 indexed playerName,
368         uint256 amount,
369         uint256 timestamp  
370     );
371 
372     // getters:
373     function checkIfNameValid(string _nameStr)
374         public
375         view
376         returns(bool)
377     {
378         bytes32 _name = _nameStr.nameFilter();
379         if (pIDxName_[_name] == 0)
380             return (true);
381         else 
382             return (false);
383     }
384 
385     // public functions:
386     /**
387      * @dev registers a name.  UI will always display the last name you registered.
388      * but you will still own all previously registered names to use as affiliate 
389      * links.
390      * - must pay a registration fee.
391      * - name must be unique
392      * - names will be converted to lowercase
393      * - name cannot start or end with a space 
394      * - cannot have more than 1 space in a row
395      * - cannot be only numbers
396      * - cannot start with 0x 
397      * - name must be at least 1 char
398      * - max length of 32 characters long
399      * - allowed characters: a-z, 0-9, and space
400      * -functionhash- 0x921dec21 (using ID for affiliate)
401      * -functionhash- 0x3ddd4698 (using address for affiliate)
402      * -functionhash- 0x685ffd83 (using name for affiliate)
403      * @param _nameString players desired name
404      * @param _affCode affiliate ID, address, or name of who refered you
405      * (this might cost a lot of gas)
406      */
407 
408     function registerNameXID(string _nameString, uint256 _affCode)
409         external
410         payable 
411         isHuman()
412     {
413         // make sure name fees paid
414         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
415         
416         // filter name + condition checks
417         bytes32 _name = NameFilter.nameFilter(_nameString);
418         
419         // set up address 
420         address _addr = msg.sender;
421         
422         // set up our tx event data and determine if player is new or not
423         bool _isNewPlayer = determinePID(_addr);
424         
425         // fetch player id
426         uint256 _pID = pIDxAddr_[_addr];
427         
428         // manage affiliate residuals
429         // if no affiliate code was given, no new affiliate code was given, or the 
430         // player tried to use their own pID as an affiliate code, lolz
431         uint256 _affID = _affCode;
432         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
433         {
434             // update last affiliate 
435             plyr_[_pID].laff = _affCode;
436         } else if (_affCode == _pID) {
437             _affID = 0;
438         }
439         
440         // register name 
441         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
442     }
443     
444 
445     function registerNameXaddr(string _nameString, address _affCode)
446         external
447         payable 
448         isHuman()
449     {
450         // make sure name fees paid
451         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
452         
453         // filter name + condition checks
454         bytes32 _name = NameFilter.nameFilter(_nameString);
455         
456         // set up address 
457         address _addr = msg.sender;
458         
459         // set up our tx event data and determine if player is new or not
460         bool _isNewPlayer = determinePID(_addr);
461         
462         // fetch player id
463         uint256 _pID = pIDxAddr_[_addr];
464         
465         // manage affiliate residuals
466         // if no affiliate code was given or player tried to use their own, lolz
467         uint256 _affID;
468         if (_affCode != address(0) && _affCode != _addr)
469         {
470             // get affiliate ID from aff Code 
471             _affID = pIDxAddr_[_affCode];
472             
473             // if affID is not the same as previously stored 
474             if (_affID != plyr_[_pID].laff)
475             {
476                 // update last affiliate
477                 plyr_[_pID].laff = _affID;
478             }
479         }
480         
481         // register name 
482         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
483     }
484     
485 
486     function registerNameXname(string _nameString, bytes32 _affCode)
487         external
488         payable 
489         isHuman()
490     {
491         // make sure name fees paid
492         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
493         
494         // filter name + condition checks
495         bytes32 _name = NameFilter.nameFilter(_nameString);
496         
497         // set up address 
498         address _addr = msg.sender;
499         
500         // set up our tx event data and determine if player is new or not
501         bool _isNewPlayer = determinePID(_addr);
502         
503         // fetch player id
504         uint256 _pID = pIDxAddr_[_addr];
505         
506         // manage affiliate residuals
507         // if no affiliate code was given or player tried to use their own, lolz
508         uint256 _affID;
509         if (_affCode != "" && _affCode != _name)
510         {
511             // get affiliate ID from aff Code 
512             _affID = pIDxName_[_affCode];
513             
514             // if affID is not the same as previously stored 
515             if (_affID != plyr_[_pID].laff)
516             {
517                 // update last affiliate
518                 plyr_[_pID].laff = _affID;
519             }
520         }
521         
522         // register name 
523         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
524     }
525 
526 
527     function registerAffiliate()
528         external
529         payable
530         isHuman()
531     {
532         // make sure name fees paid
533         require (msg.value >= affiliateFee_, "umm.....  you have to pay the name fee");
534 
535         // set up address 
536         address _addr = msg.sender;
537         uint256 _pID = pIDxAddr_[_addr];
538 
539         require (_pID > 0, "you need to be registered");
540         require (plyr_[_pID].hasAff == false, "already registered as affiliate");
541 
542         Banker_Address.deposit.value(msg.value)();
543         plyr_[_pID].hasAff = true;
544 
545         bytes32 _name = plyr_[_pID].name;
546 
547         // fire event
548         emit onNewAffiliate(_pID, _addr, _name, msg.value, now);
549     }
550 
551 
552     function registerGame(address _contract, bool _enable)
553         external
554         isHuman()
555         onlyOwner()
556     {
557         registeredGames_[_contract] = _enable;
558 
559         emit onGameRegistered(_contract, _enable, now);
560     }
561     
562     /**
563      * @dev players use this to change back to one of your old names.  tip, you'll
564      * still need to push that info to existing games.
565      * -functionhash- 0xb9291296
566      * @param _nameString the name you want to use 
567      */
568     function useMyOldName(string _nameString)
569         external
570         isHuman()
571     {
572         // filter name, and get pID
573         bytes32 _name = _nameString.nameFilter();
574         address _addr = msg.sender;
575         uint256 _pID = pIDxAddr_[_addr];
576         
577         // make sure they own the name 
578         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
579         
580         // update their current name 
581         plyr_[_pID].name = _name;
582 
583         emit onUseOldName(_pID, _addr, _name, now);
584     }
585 
586     // deposit affiliate to a code
587     function depositAffiliate(uint256 _pID)
588         external
589         payable
590         isRegisteredGame()
591     {
592         require(plyr_[_pID].hasAff == true, "Not registered as affiliate");
593 
594         uint256 value = msg.value;
595         plyr_[_pID].aff = value.add(plyr_[_pID].aff);
596     }
597 
598     // withdraw money
599     function withdraw()
600         external
601         isHuman()
602     {
603         address _addr = msg.sender;
604         uint256 _pID = pIDxAddr_[_addr];
605         bytes32 _name = plyr_[_pID].name;
606         require(_pID != 0, "need to be registered");
607 
608         uint256 _remainValue = (plyr_[_pID].aff).sub(plyr_[_pID].withdrawnAff);
609         if (_remainValue > 0) {
610             plyr_[_pID].withdrawnAff = plyr_[_pID].aff;
611             address(msg.sender).transfer(_remainValue);
612         }
613 
614         emit onWithdraw(_pID, _addr, _name, _remainValue, now);
615     }
616     
617     // core logics:
618     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer)
619         private
620     {
621         // if names already has been used, require that current msg sender owns the name
622         if (pIDxName_[_name] != 0)
623             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
624         
625         // add name to player profile, registry, and name book
626         plyr_[_pID].name = _name;
627         plyr_[_pID].affT2 = _affID;
628         pIDxName_[_name] = _pID;
629         if (plyrNames_[_pID][_name] == false)
630         {
631             plyrNames_[_pID][_name] = true;
632             plyr_[_pID].names++;
633             plyrNameList_[_pID][plyr_[_pID].names] = _name;
634         }
635         
636         // TODO: MODIFY THIS
637         // registration fee goes directly to community rewards
638         //Banker_Address.deposit.value(address(this).balance)();
639         Banker_Address.deposit.value(msg.value)();
640         
641         // fire event
642         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
643     }
644 
645     function determinePID(address _addr)
646         private
647         returns (bool)
648     {
649         if (pIDxAddr_[_addr] == 0)
650         {
651             pID_++;
652             pIDxAddr_[_addr] = pID_;
653             plyr_[pID_].addr = _addr;
654             
655             // set the new player bool to true
656             return (true);
657         } else {
658             return (false);
659         }
660     }
661 
662     // external calls:
663     function getPlayerID(address _addr)
664         external
665         isRegisteredGame()
666         returns (uint256)
667     {
668         determinePID(_addr);
669         return (pIDxAddr_[_addr]);
670     }
671 
672     function getPlayerName(uint256 _pID)
673         external
674         view
675         returns (bytes32)
676     {
677         return (plyr_[_pID].name);
678     }
679 
680     function getPlayerLAff(uint256 _pID)
681         external
682         view
683         returns (uint256)
684     {
685         return (plyr_[_pID].laff);
686     }
687 
688     function setPlayerLAff(uint256 _pID, uint256 _lAff)
689         external
690         isRegisteredGame()
691     {
692         if (_pID != _lAff && plyr_[_pID].laff != _lAff) {
693             plyr_[_pID].laff = _lAff;
694         }
695     }
696 
697     function getPlayerAffT2(uint256 _pID)
698         external
699         view
700         returns (uint256)
701     {
702         return (plyr_[_pID].affT2);
703     }
704 
705     function getPlayerAddr(uint256 _pID)
706         external
707         view
708         returns (address)
709     {
710         return (plyr_[_pID].addr);
711     }
712 
713     function getPlayerHasAff(uint256 _pID)
714         external
715         view
716         returns (bool)
717     {
718         return (plyr_[_pID].hasAff);
719     }
720 
721     function getNameFee()
722         external
723         view
724         returns (uint256)
725     {
726         return(registrationFee_);
727     }
728 
729     function getAffiliateFee()
730         external
731         view
732         returns (uint256)
733     {
734         return (affiliateFee_);
735     }
736     
737     function setRegistrationFee(uint256 _fee)
738         external
739         onlyOwner()
740     {
741         registrationFee_ = _fee;
742     }
743 
744     function setAffiliateFee(uint256 _fee)
745         external
746         onlyOwner()
747     {
748         affiliateFee_ = _fee;
749     }
750 
751     /**
752     * @dev Allows the current owner to transfer Banker_Address to a new banker.
753     * @param banker The address to transfer Banker_Address to.
754     */
755     function transferBanker(BMForwarderInterface banker) 
756         public
757         onlyOwner()
758     {
759         if (banker != address(0)) {
760             Banker_Address = banker;
761         }
762     }
763 
764 }