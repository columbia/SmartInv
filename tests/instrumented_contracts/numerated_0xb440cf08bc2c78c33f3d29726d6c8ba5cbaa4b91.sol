1 pragma solidity 0.4.25;
2 
3 
4 interface FSForwarderInterface {
5     function deposit() external payable returns(bool);
6 }
7 
8 
9 /// @title Contract for managing player names and affiliate payments.
10 /// @notice This contract manages player names and affiliate payments
11 /// from registered games. Players can buy multiple names and select
12 /// which name to be used. Players who buy affiliate memberships can
13 /// receive affiliate payments from registered games.
14 /// Players can withdraw affiliate payments at any time.
15 /// @dev The address of the forwarder is hardcoded. Check 'TODO' before
16 /// deploy.
17 contract FSBook {
18     using NameFilter for string;
19     using SafeMath for uint256;
20 
21     // TODO : CHECK THE ADDRESS!!!
22     FSForwarderInterface constant private FSKingCorp = FSForwarderInterface(0x3a2321DDC991c50518969B93d2C6B76bf5309790);
23 
24     // data    
25     uint256 public registrationFee_ = 10 finney;            // price to register a name
26     uint256 public affiliateFee_ = 500 finney;              // price to become an affiliate
27     uint256 public pID_;        // total number of players
28 
29     // (addr => pID) returns player id by address
30     mapping (address => uint256) public pIDxAddr_;
31     // (name => pID) returns player id by name
32     mapping (bytes32 => uint256) public pIDxName_;
33     // (pID => data) player data
34     mapping (uint256 => Player) public plyr_;
35     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
36     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
37     // (pID => nameNum => name) list of names a player owns
38     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_;
39     // registered games
40     mapping (address => bool) public registeredGames_;
41 
42 
43     struct Player {
44         address addr;
45         bytes32 name;
46         bool hasAff;
47 
48         uint256 aff;
49         uint256 withdrawnAff;
50 
51         uint256 laff;
52         uint256 affT2;
53         uint256 names;
54     }
55 
56 
57     // constructor
58     constructor()
59         public
60     {
61         // premine the dev names (sorry not sorry)
62         // No keys are purchased with this method, it's simply locking our addresses,
63         // PID's and names for referral codes.
64         plyr_[1].addr = 0xe0b005384df8f4d80e9a69b6210ec1929a935d97;
65         plyr_[1].name = "sportking";
66         plyr_[1].hasAff = true;
67         plyr_[1].names = 1;
68         pIDxAddr_[0xe0b005384df8f4d80e9a69b6210ec1929a935d97] = 1;
69         pIDxName_["sportking"] = 1;
70         plyrNames_[1]["sportking"] = true;
71         plyrNameList_[1][1] = "sportking";
72 
73         pID_ = 1;
74     }
75 
76     // modifiers
77     
78     /// @dev prevents contracts from interacting with fsbook
79     modifier isHuman() {
80         address _addr = msg.sender;
81         require (_addr == tx.origin, "Human only");
82 
83         uint256 _codeLength;
84         assembly { _codeLength := extcodesize(_addr) }
85         require(_codeLength == 0, "Human only");
86         _;
87     }
88     
89 
90     // TODO: Check address!!!
91     /// @dev Check if caller is one of the owner(s).
92     modifier onlyDevs() 
93     {
94         // TODO : CHECK THE ADDRESS!!!
95         require(msg.sender == 0xe0b005384df8f4d80e9a69b6210ec1929a935d97 ||
96             msg.sender == 0xe3ff68fb79fee1989fb67eb04e196e361ecaec3e ||
97             msg.sender == 0xb914843d2e56722a2c133eff956d1f99b820d468 ||
98             msg.sender == 0xc52FA2C9411fCd4f58be2d6725094689C46242f2, "msg sender is not a dev");
99         _;
100     }
101 
102 
103     /// @dev Check if caller is registered.
104     modifier isRegisteredGame() {
105         require(registeredGames_[msg.sender] == true, "sender is not registered");
106         _;
107     }
108     
109     // events
110 
111     event onNewName
112     (
113         uint256 indexed playerID,
114         address indexed playerAddress,
115         bytes32 indexed playerName,
116         bool isNewPlayer,
117         uint256 affiliateID,
118         address affiliateAddress,
119         bytes32 affiliateName,
120         uint256 amountPaid,
121         uint256 timestamp
122     );
123 
124     event onNewAffiliate
125     (
126         uint256 indexed playerID,
127         address indexed playerAddress,
128         bytes32 indexed playerName,
129         uint256 amountPaid,
130         uint256 timestamp
131     );
132 
133     event onUseOldName
134     (
135         uint256 indexed playerID,
136         address indexed playerAddress,
137         bytes32 indexed playerName,
138         uint256 timestamp
139     );
140 
141     event onGameRegistered
142     (
143         address indexed gameAddress,
144         bool enabled,
145         uint256 timestamp
146     );
147 
148     event onWithdraw
149     (
150         uint256 indexed playerID,
151         address indexed playerAddress,
152         bytes32 indexed playerName,
153         uint256 amount,
154         uint256 timestamp  
155     );
156 
157     // getters:
158     function checkIfNameValid(string _nameStr)
159         public
160         view
161         returns(bool)
162     {
163         bytes32 _name = _nameStr.nameFilter();
164         if (pIDxName_[_name] == 0)
165             return (true);
166         else 
167             return (false);
168     }
169 
170     // public functions:
171     /**
172      * @dev registers a name.  UI will always display the last name you registered.
173      * but you will still own all previously registered names to use as affiliate 
174      * links.
175      * - must pay a registration fee.
176      * - name must be unique
177      * - names will be converted to lowercase
178      * - name cannot start or end with a space 
179      * - cannot have more than 1 space in a row
180      * - cannot be only numbers
181      * - cannot start with 0x 
182      * - name must be at least 1 char
183      * - max length of 32 characters long
184      * - allowed characters: a-z, 0-9, and space
185      * -functionhash- 0x921dec21 (using ID for affiliate)
186      * -functionhash- 0x3ddd4698 (using address for affiliate)
187      * -functionhash- 0x685ffd83 (using name for affiliate)
188      * @param _nameString players desired name
189      * @param _affCode affiliate ID, address, or name of who refered you
190      * (this might cost a lot of gas)
191      */
192 
193     function registerNameXID(string _nameString, uint256 _affCode)
194         external
195         payable 
196         isHuman()
197     {
198         // make sure name fees paid
199         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
200         
201         // filter name + condition checks
202         bytes32 _name = NameFilter.nameFilter(_nameString);
203         
204         // set up address 
205         address _addr = msg.sender;
206         
207         // set up our tx event data and determine if player is new or not
208         bool _isNewPlayer = determinePID(_addr);
209         
210         // fetch player id
211         uint256 _pID = pIDxAddr_[_addr];
212         
213         // manage affiliate residuals
214         // if no affiliate code was given, no new affiliate code was given, or the 
215         // player tried to use their own pID as an affiliate code, lolz
216         uint256 _affID = _affCode;
217         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
218         {
219             // update last affiliate 
220             plyr_[_pID].laff = _affCode;
221         } else if (_affCode == _pID) {
222             _affID = 0;
223         }
224         
225         // register name 
226         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
227     }
228     
229 
230     function registerNameXaddr(string _nameString, address _affCode)
231         external
232         payable 
233         isHuman()
234     {
235         // make sure name fees paid
236         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
237         
238         // filter name + condition checks
239         bytes32 _name = NameFilter.nameFilter(_nameString);
240         
241         // set up address 
242         address _addr = msg.sender;
243         
244         // set up our tx event data and determine if player is new or not
245         bool _isNewPlayer = determinePID(_addr);
246         
247         // fetch player id
248         uint256 _pID = pIDxAddr_[_addr];
249         
250         // manage affiliate residuals
251         // if no affiliate code was given or player tried to use their own, lolz
252         uint256 _affID;
253         if (_affCode != address(0) && _affCode != _addr)
254         {
255             // get affiliate ID from aff Code 
256             _affID = pIDxAddr_[_affCode];
257             
258             // if affID is not the same as previously stored 
259             if (_affID != plyr_[_pID].laff)
260             {
261                 // update last affiliate
262                 plyr_[_pID].laff = _affID;
263             }
264         }
265         
266         // register name 
267         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
268     }
269     
270 
271     function registerNameXname(string _nameString, bytes32 _affCode)
272         external
273         payable 
274         isHuman()
275     {
276         // make sure name fees paid
277         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
278         
279         // filter name + condition checks
280         bytes32 _name = NameFilter.nameFilter(_nameString);
281         
282         // set up address 
283         address _addr = msg.sender;
284         
285         // set up our tx event data and determine if player is new or not
286         bool _isNewPlayer = determinePID(_addr);
287         
288         // fetch player id
289         uint256 _pID = pIDxAddr_[_addr];
290         
291         // manage affiliate residuals
292         // if no affiliate code was given or player tried to use their own, lolz
293         uint256 _affID;
294         if (_affCode != "" && _affCode != _name)
295         {
296             // get affiliate ID from aff Code 
297             _affID = pIDxName_[_affCode];
298             
299             // if affID is not the same as previously stored 
300             if (_affID != plyr_[_pID].laff)
301             {
302                 // update last affiliate
303                 plyr_[_pID].laff = _affID;
304             }
305         }
306         
307         // register name 
308         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
309     }
310 
311 
312     function registerAffiliate()
313         external
314         payable
315         isHuman()
316     {
317         // make sure name fees paid
318         require (msg.value >= affiliateFee_, "umm.....  you have to pay the name fee");
319 
320         // set up address 
321         address _addr = msg.sender;
322         uint256 _pID = pIDxAddr_[_addr];
323 
324         require (_pID > 0, "you need to be registered");
325         require (plyr_[_pID].hasAff == false, "already registered as affiliate");
326 
327         FSKingCorp.deposit.value(msg.value)();
328         plyr_[_pID].hasAff = true;
329 
330         bytes32 _name = plyr_[_pID].name;
331 
332         // fire event
333         emit onNewAffiliate(_pID, _addr, _name, msg.value, now);
334     }
335 
336 
337     function registerGame(address _contract, bool _enable)
338         external
339         isHuman()
340         onlyDevs()
341     {
342         registeredGames_[_contract] = _enable;
343 
344         emit onGameRegistered(_contract, _enable, now);
345     }
346     
347     /**
348      * @dev players use this to change back to one of your old names.  tip, you'll
349      * still need to push that info to existing games.
350      * -functionhash- 0xb9291296
351      * @param _nameString the name you want to use 
352      */
353     function useMyOldName(string _nameString)
354         external
355         isHuman()
356     {
357         // filter name, and get pID
358         bytes32 _name = _nameString.nameFilter();
359         address _addr = msg.sender;
360         uint256 _pID = pIDxAddr_[_addr];
361         
362         // make sure they own the name 
363         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
364         
365         // update their current name 
366         plyr_[_pID].name = _name;
367 
368         emit onUseOldName(_pID, _addr, _name, now);
369     }
370 
371     // deposit affiliate to a code
372     function depositAffiliate(uint256 _pID)
373         external
374         payable
375         isRegisteredGame()
376     {
377         require(plyr_[_pID].hasAff == true, "Not registered as affiliate");
378 
379         uint256 value = msg.value;
380         plyr_[_pID].aff = value.add(plyr_[_pID].aff);
381     }
382 
383     // withdraw money
384     function withdraw()
385         external
386         isHuman()
387     {
388         address _addr = msg.sender;
389         uint256 _pID = pIDxAddr_[_addr];
390         bytes32 _name = plyr_[_pID].name;
391         require(_pID != 0, "need to be registered");
392 
393         uint256 _remainValue = (plyr_[_pID].aff).sub(plyr_[_pID].withdrawnAff);
394         if (_remainValue > 0) {
395             plyr_[_pID].withdrawnAff = plyr_[_pID].aff;
396             address(msg.sender).transfer(_remainValue);
397         }
398 
399         emit onWithdraw(_pID, _addr, _name, _remainValue, now);
400     }
401     
402     // core logics:
403     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer)
404         private
405     {
406         // if names already has been used, require that current msg sender owns the name
407         if (pIDxName_[_name] != 0)
408             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
409         
410         // add name to player profile, registry, and name book
411         plyr_[_pID].name = _name;
412         plyr_[_pID].affT2 = _affID;
413         pIDxName_[_name] = _pID;
414         if (plyrNames_[_pID][_name] == false)
415         {
416             plyrNames_[_pID][_name] = true;
417             plyr_[_pID].names++;
418             plyrNameList_[_pID][plyr_[_pID].names] = _name;
419         }
420         
421         // TODO: MODIFY THIS
422         // registration fee goes directly to community rewards
423         //FSKingCorp.deposit.value(address(this).balance)();
424         FSKingCorp.deposit.value(msg.value)();
425         
426         // fire event
427         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
428     }
429 
430     function determinePID(address _addr)
431         private
432         returns (bool)
433     {
434         if (pIDxAddr_[_addr] == 0)
435         {
436             pID_++;
437             pIDxAddr_[_addr] = pID_;
438             plyr_[pID_].addr = _addr;
439             
440             // set the new player bool to true
441             return (true);
442         } else {
443             return (false);
444         }
445     }
446 
447     // external calls:
448     function getPlayerID(address _addr)
449         external
450         isRegisteredGame()
451         returns (uint256)
452     {
453         determinePID(_addr);
454         return (pIDxAddr_[_addr]);
455     }
456 
457     function getPlayerName(uint256 _pID)
458         external
459         view
460         returns (bytes32)
461     {
462         return (plyr_[_pID].name);
463     }
464 
465     function getPlayerLAff(uint256 _pID)
466         external
467         view
468         returns (uint256)
469     {
470         return (plyr_[_pID].laff);
471     }
472 
473     function setPlayerLAff(uint256 _pID, uint256 _lAff)
474         external
475         isRegisteredGame()
476     {
477         if (_pID != _lAff && plyr_[_pID].laff != _lAff) {
478             plyr_[_pID].laff = _lAff;
479         }
480     }
481 
482     function getPlayerAffT2(uint256 _pID)
483         external
484         view
485         returns (uint256)
486     {
487         return (plyr_[_pID].affT2);
488     }
489 
490     function getPlayerAddr(uint256 _pID)
491         external
492         view
493         returns (address)
494     {
495         return (plyr_[_pID].addr);
496     }
497 
498     function getPlayerHasAff(uint256 _pID)
499         external
500         view
501         returns (bool)
502     {
503         return (plyr_[_pID].hasAff);
504     }
505 
506     function getNameFee()
507         external
508         view
509         returns (uint256)
510     {
511         return(registrationFee_);
512     }
513 
514     function getAffiliateFee()
515         external
516         view
517         returns (uint256)
518     {
519         return (affiliateFee_);
520     }
521     
522     function setRegistrationFee(uint256 _fee)
523         external
524         onlyDevs()
525     {
526         registrationFee_ = _fee;
527     }
528 
529     function setAffiliateFee(uint256 _fee)
530         external
531         onlyDevs()
532     {
533         affiliateFee_ = _fee;
534     }
535 
536 } 
537 
538 library NameFilter {
539     
540     /**
541      * @dev filters name strings
542      * -converts uppercase to lower case.  
543      * -makes sure it does not start/end with a space
544      * -makes sure it does not contain multiple spaces in a row
545      * -cannot be only numbers
546      * -cannot start with 0x 
547      * -restricts characters to A-Z, a-z, 0-9, and space.
548      * @return reprocessed string in bytes32 format
549      */
550     function nameFilter(string _input)
551         internal
552         pure
553         returns(bytes32)
554     {
555         bytes memory _temp = bytes(_input);
556         uint256 _length = _temp.length;
557         
558         //sorry limited to 32 characters
559         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
560         // make sure it doesnt start with or end with space
561         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
562         // make sure first two characters are not 0x
563         if (_temp[0] == 0x30)
564         {
565             require(_temp[1] != 0x78, "string cannot start with 0x");
566             require(_temp[1] != 0x58, "string cannot start with 0X");
567         }
568         
569         // create a bool to track if we have a non number character
570         bool _hasNonNumber;
571         
572         // convert & check
573         for (uint256 i = 0; i < _length; i++)
574         {
575             // if its uppercase A-Z
576             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
577             {
578                 // convert to lower case a-z
579                 _temp[i] = byte(uint(_temp[i]) + 32);
580                 
581                 // we have a non number
582                 if (_hasNonNumber == false)
583                     _hasNonNumber = true;
584             } else {
585                 require
586                 (
587                     // require character is a space
588                     _temp[i] == 0x20 || 
589                     // OR lowercase a-z
590                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
591                     // or 0-9
592                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
593                     "string contains invalid characters"
594                 );
595                 // make sure theres not 2x spaces in a row
596                 if (_temp[i] == 0x20)
597                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
598                 
599                 // see if we have a character other than a number
600                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
601                     _hasNonNumber = true;    
602             }
603         }
604         
605         require(_hasNonNumber == true, "string cannot be only numbers");
606         
607         bytes32 _ret;
608         assembly {
609             _ret := mload(add(_temp, 32))
610         }
611         return (_ret);
612     }
613 }
614 
615 /**
616  * @title SafeMath v0.1.9
617  * @dev Math operations with safety checks that throw on error
618  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
619  * - added sqrt
620  * - added sq
621  * - added pwr 
622  * - changed asserts to requires with error log outputs
623  * - removed div, its useless
624  */
625 library SafeMath {
626     
627     /**
628     * @dev Multiplies two numbers, throws on overflow.
629     */
630     function mul(uint256 a, uint256 b) 
631         internal 
632         pure 
633         returns (uint256 c) 
634     {
635         if (a == 0) {
636             return 0;
637         }
638         c = a * b;
639         require(c / a == b, "SafeMath mul failed");
640         return c;
641     }
642 
643     /**
644     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
645     */
646     function sub(uint256 a, uint256 b)
647         internal
648         pure
649         returns (uint256) 
650     {
651         require(b <= a, "SafeMath sub failed");
652         return a - b;
653     }
654 
655     /**
656     * @dev Adds two numbers, throws on overflow.
657     */
658     function add(uint256 a, uint256 b)
659         internal
660         pure
661         returns (uint256 c) 
662     {
663         c = a + b;
664         require(c >= a, "SafeMath add failed");
665         return c;
666     }
667     
668     /**
669      * @dev gives square root of given x.
670      */
671     function sqrt(uint256 x)
672         internal
673         pure
674         returns (uint256 y) 
675     {
676         uint256 z = ((add(x,1)) / 2);
677         y = x;
678         while (z < y) 
679         {
680             y = z;
681             z = ((add((x / z),z)) / 2);
682         }
683     }
684     
685     /**
686      * @dev gives square. multiplies x by x
687      */
688     function sq(uint256 x)
689         internal
690         pure
691         returns (uint256)
692     {
693         return (mul(x,x));
694     }
695     
696     /**
697      * @dev x to the power of y 
698      */
699     function pwr(uint256 x, uint256 y)
700         internal 
701         pure 
702         returns (uint256)
703     {
704         if (x==0)
705             return (0);
706         else if (y==0)
707             return (1);
708         else 
709         {
710             uint256 z = x;
711             for (uint256 i=1; i < y; i++)
712                 z = mul(z,x);
713             return (z);
714         }
715     }
716 }