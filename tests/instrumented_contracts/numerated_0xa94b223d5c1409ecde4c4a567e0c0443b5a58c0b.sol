1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookInterface {
4     function getPlayerID(address _addr) external returns (uint256);
5     function getPlayerName(uint256 _pID) external view returns (bytes32);
6     function getPlayerLAff(uint256 _pID) external view returns (uint256);
7     function getPlayerAddr(uint256 _pID) external view returns (address);
8     function getNameFee() external view returns (uint256);
9     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
10     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
11     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
12 }
13 pragma solidity ^0.4.24;
14 
15 interface PlayerBookReceiverInterface {
16     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
17     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
18 }
19 pragma solidity ^0.4.24;
20 
21 /**
22  * @title SafeMath v0.1.9
23  * @dev Math operations with safety checks that throw on error
24  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
25  * - added sqrt
26  * - added sq
27  * - added pwr
28  * - changed asserts to requires with error log outputs
29  * - removed div, its useless
30  */
31 library SafeMath {
32 
33     /**
34     * @dev Multiplies two numbers, throws on overflow.
35     */
36     function mul(uint256 a, uint256 b)
37     internal
38     pure
39     returns (uint256 c)
40     {
41         if (a == 0) {
42             return 0;
43         }
44         c = a * b;
45         require(c / a == b, "SafeMath mul failed");
46         return c;
47     }
48 
49     /**
50     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b)
53     internal
54     pure
55     returns (uint256)
56     {
57         require(b <= a, "SafeMath sub failed");
58         return a - b;
59     }
60 
61     /**
62     * @dev Adds two numbers, throws on overflow.
63     */
64     function add(uint256 a, uint256 b)
65     internal
66     pure
67     returns (uint256 c)
68     {
69         c = a + b;
70         require(c >= a, "SafeMath add failed");
71         return c;
72     }
73 
74     /**
75      * @dev gives square root of given x.
76      */
77     function sqrt(uint256 x)
78     internal
79     pure
80     returns (uint256 y)
81     {
82         uint256 z = ((add(x,1)) / 2);
83         y = x;
84         while (z < y)
85         {
86             y = z;
87             z = ((add((x / z),z)) / 2);
88         }
89     }
90 
91     /**
92      * @dev gives square. multiplies x by x
93      */
94     function sq(uint256 x)
95     internal
96     pure
97     returns (uint256)
98     {
99         return (mul(x,x));
100     }
101 
102     /**
103      * @dev x to the power of y
104      */
105     function pwr(uint256 x, uint256 y)
106     internal
107     pure
108     returns (uint256)
109     {
110         if (x==0)
111             return (0);
112         else if (y==0)
113             return (1);
114         else
115         {
116             uint256 z = x;
117             for (uint256 i=1; i < y; i++)
118                 z = mul(z,x);
119             return (z);
120         }
121     }
122 }
123 pragma solidity ^0.4.24;
124 
125 library NameFilter {
126 
127     /**
128      * @dev filters name strings
129      * -converts uppercase to lower case.
130      * -makes sure it does not start/end with a space
131      * -makes sure it does not contain multiple spaces in a row
132      * -cannot be only numbers
133      * -cannot start with 0x
134      * -restricts characters to A-Z, a-z, 0-9, and space.
135      * @return reprocessed string in bytes32 format
136      */
137     function nameFilter(string _input)
138     internal
139     pure
140     returns(bytes32)
141     {
142         bytes memory _temp = bytes(_input);
143         uint256 _length = _temp.length;
144 
145         //sorry limited to 32 characters
146         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
147         // make sure it doesnt start with or end with space
148         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
149         // make sure first two characters are not 0x
150         if (_temp[0] == 0x30)
151         {
152             require(_temp[1] != 0x78, "string cannot start with 0x");
153             require(_temp[1] != 0x58, "string cannot start with 0X");
154         }
155 
156         // create a bool to track if we have a non number character
157         bool _hasNonNumber;
158 
159         // convert & check
160         for (uint256 i = 0; i < _length; i++)
161         {
162             // if its uppercase A-Z
163             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
164             {
165                 // convert to lower case a-z
166                 _temp[i] = byte(uint(_temp[i]) + 32);
167 
168                 // we have a non number
169                 if (_hasNonNumber == false)
170                     _hasNonNumber = true;
171             } else {
172                 require
173                 (
174                 // require character is a space
175                     _temp[i] == 0x20 ||
176                 // OR lowercase a-z
177                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
178                 // or 0-9
179                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
180                     "string contains invalid characters"
181                 );
182                 // make sure theres not 2x spaces in a row
183                 if (_temp[i] == 0x20)
184                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
185 
186                 // see if we have a character other than a number
187                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
188                     _hasNonNumber = true;
189             }
190         }
191 
192         require(_hasNonNumber == true, "string cannot be only numbers");
193 
194         bytes32 _ret;
195         assembly {
196             _ret := mload(add(_temp, 32))
197         }
198         return (_ret);
199     }
200 }
201 pragma solidity ^0.4.24;
202 
203 
204 /**
205  * @title Ownable
206  * @dev The Ownable contract has an owner address, and provides basic authorization control
207  * functions, this simplifies the implementation of "user permissions".
208  */
209 contract Ownable {
210   address public owner;
211 
212 
213   event OwnershipRenounced(address indexed previousOwner);
214   event OwnershipTransferred(
215     address indexed previousOwner,
216     address indexed newOwner
217   );
218 
219 
220   /**
221    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
222    * account.
223    */
224   constructor() public {
225     owner = msg.sender;
226   }
227 
228   /**
229    * @dev Throws if called by any account other than the owner.
230    */
231   modifier onlyOwner() {
232     require(msg.sender == owner);
233     _;
234   }
235 
236   /**
237    * @dev Allows the current owner to relinquish control of the contract.
238    * @notice Renouncing to ownership will leave the contract without an owner.
239    * It will not be possible to call the functions with the `onlyOwner`
240    * modifier anymore.
241    */
242   function renounceOwnership() public onlyOwner {
243     emit OwnershipRenounced(owner);
244     owner = address(0);
245   }
246 
247   /**
248    * @dev Allows the current owner to transfer control of the contract to a newOwner.
249    * @param _newOwner The address to transfer ownership to.
250    */
251   function transferOwnership(address _newOwner) public onlyOwner {
252     _transferOwnership(_newOwner);
253   }
254 
255   /**
256    * @dev Transfers control of the contract to a newOwner.
257    * @param _newOwner The address to transfer ownership to.
258    */
259   function _transferOwnership(address _newOwner) internal {
260     require(_newOwner != address(0));
261     emit OwnershipTransferred(owner, _newOwner);
262     owner = _newOwner;
263   }
264 }
265 pragma solidity ^0.4.24;
266 
267 // "./PlayerBookReceiverInterface.sol";
268 // "./PlayerBookInterface.sol";
269 // "./SafeMath.sol";
270 // "./NameFilter.sol";
271 // 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
272 
273 contract PlayerBook is PlayerBookInterface, Ownable {
274     using NameFilter for string;
275     using SafeMath for uint256;
276 
277     //==============================================================================
278     //     _| _ _|_ _    _ _ _|_    _   .
279     //    (_|(_| | (_|  _\(/_ | |_||_)  .
280     //=============================|================================================
281     uint256 public registrationFee_ = 0;            // price to register a name
282     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
283     mapping(address => bytes32) public gameNames_;          // lookup a games name
284     mapping(address => uint256) public gameIDs_;            // lokup a games ID
285     uint256 public gID_;        // total number of games
286     uint256 public pID_;        // total number of players
287     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
288     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
289     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
290     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
291     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
292     struct Player {
293         address addr;
294         bytes32 name;
295         uint256 laff;
296         uint256 names;
297     }
298     //==============================================================================
299     //     _ _  _  __|_ _    __|_ _  _  .
300     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
301     //==============================================================================
302     constructor()
303     public
304     {
305         // premine the dev names (sorry not sorry)
306         // No keys are purchased with this method, it's simply locking our addresses,
307         // PID's and names for referral codes.
308         address addr1 = 0xcdd46c662df6b2e17f8274714c8105aa96e95c4f;
309         address addr2 = 0x2ed121eb73778055996585d11fd29926bbd2a057;
310         bytes32 name1 = "first";
311         bytes32 name2 = "second";
312 
313         plyr_[1].addr = addr1;
314         plyr_[1].name = name1;
315         plyr_[1].names = 1;
316         pIDxAddr_[addr1] = 1;
317         pIDxName_[name1] = 1;
318         plyrNames_[1][name1] = true;
319         plyrNameList_[1][1] = name1;
320 
321         plyr_[2].addr = addr2;
322         plyr_[2].name = name2;
323         plyr_[2].names = 1;
324         pIDxAddr_[addr2] = 2;
325         pIDxName_[name2] = 2;
326         plyrNames_[2][name2] = true;
327         plyrNameList_[2][1] = name2;
328 
329         pID_ = 2;
330     }
331     //==============================================================================
332     //     _ _  _  _|. |`. _  _ _  .
333     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
334     //==============================================================================
335     /**
336      * @dev prevents contracts from interacting with fomo3d
337      */
338     modifier isHuman() {
339         address _addr = msg.sender;
340         uint256 _codeLength;
341 
342         assembly {_codeLength := extcodesize(_addr)}
343         require(_codeLength == 0, "sorry humans only");
344         _;
345     }
346 
347     modifier isRegisteredGame()
348     {
349         require(gameIDs_[msg.sender] != 0);
350         _;
351     }
352     //==============================================================================
353     //     _    _  _ _|_ _  .
354     //    (/_\/(/_| | | _\  .
355     //==============================================================================
356     // fired whenever a player registers a name
357     event onNewName
358     (
359         uint256 indexed playerID,
360         address indexed playerAddress,
361         bytes32 indexed playerName,
362         bool isNewPlayer,
363         uint256 affiliateID,
364         address affiliateAddress,
365         bytes32 affiliateName,
366         uint256 amountPaid,
367         uint256 timeStamp
368     );
369 
370     //==============================================================================
371     //     _  _ _|__|_ _  _ _  .
372     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
373     //=====_|=======================================================================
374     function checkIfNameValid(string _nameStr)
375     public
376     view
377     returns(bool)
378     {
379         bytes32 _name = _nameStr.nameFilter();
380         if (pIDxName_[_name] == 0)
381             return (true);
382         else
383             return (false);
384     }
385     //==============================================================================
386     //     _    |_ |. _   |`    _  __|_. _  _  _  .
387     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
388     //====|=========================================================================
389     /**
390      * @dev registers a name.  UI will always display the last name you registered.
391      * but you will still own all previously registered names to use as affiliate
392      * links.
393      * - must pay a registration fee.
394      * - name must be unique
395      * - names will be converted to lowercase
396      * - name cannot start or end with a space
397      * - cannot have more than 1 space in a row
398      * - cannot be only numbers
399      * - cannot start with 0x
400      * - name must be at least 1 char
401      * - max length of 32 characters long
402      * - allowed characters: a-z, 0-9, and space
403      * -functionhash- 0x921dec21 (using ID for affiliate)
404      * -functionhash- 0x3ddd4698 (using address for affiliate)
405      * -functionhash- 0x685ffd83 (using name for affiliate)
406      * @param _nameString players desired name
407      * @param _affCode affiliate ID, address, or name of who refered you
408      * @param _all set to true if you want this to push your info to all games
409      * (this might cost a lot of gas)
410      */
411     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
412     isHuman()
413     public
414     payable
415     {
416         // make sure name fees paid
417         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
418 
419         // filter name + condition checks
420         bytes32 _name = NameFilter.nameFilter(_nameString);
421 
422         // set up address
423         address _addr = msg.sender;
424 
425         // set up our tx event data and determine if player is new or not
426         bool _isNewPlayer = determinePID(_addr);
427 
428         // fetch player id
429         uint256 _pID = pIDxAddr_[_addr];
430 
431         // manage affiliate residuals
432         // if no affiliate code was given, no new affiliate code was given, or the
433         // player tried to use their own pID as an affiliate code, lolz
434         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
435         {
436             // update last affiliate
437             plyr_[_pID].laff = _affCode;
438         } else if (_affCode == _pID) {
439             _affCode = 0;
440         }
441 
442         // register name
443         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
444     }
445 
446     function registerNameXaddr(string _nameString, address _affCode, bool _all)
447     isHuman()
448     public
449     payable
450     {
451         // make sure name fees paid
452         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
453 
454         // filter name + condition checks
455         bytes32 _name = NameFilter.nameFilter(_nameString);
456 
457         // set up address
458         address _addr = msg.sender;
459 
460         // set up our tx event data and determine if player is new or not
461         bool _isNewPlayer = determinePID(_addr);
462 
463         // fetch player id
464         uint256 _pID = pIDxAddr_[_addr];
465 
466         // manage affiliate residuals
467         // if no affiliate code was given or player tried to use their own, lolz
468         uint256 _affID;
469         if (_affCode != address(0) && _affCode != _addr)
470         {
471             // get affiliate ID from aff Code
472             _affID = pIDxAddr_[_affCode];
473 
474             // if affID is not the same as previously stored
475             if (_affID != plyr_[_pID].laff)
476             {
477                 // update last affiliate
478                 plyr_[_pID].laff = _affID;
479             }
480         }
481 
482         // register name
483         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
484     }
485 
486     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
487     isHuman()
488     public
489     payable
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
523         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
524     }
525 
526     /**
527      * @dev players, if you registered a profile, before a game was released, or
528      * set the all bool to false when you registered, use this function to push
529      * your profile to a single game.  also, if you've  updated your name, you
530      * can use this to push your name to games of your choosing.
531      * -functionhash- 0x81c5b206
532      * @param _gameID game id
533      */
534     function addMeToGame(uint256 _gameID)
535     isHuman()
536     public
537     {
538         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
539         address _addr = msg.sender;
540         uint256 _pID = pIDxAddr_[_addr];
541         require(_pID != 0, "hey there buddy, you dont even have an account");
542         uint256 _totalNames = plyr_[_pID].names;
543 
544         // add players profile and most recent name
545         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
546 
547         // add list of all names
548         if (_totalNames > 1)
549             for (uint256 ii = 1; ii <= _totalNames; ii++)
550                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
551     }
552 
553     /**
554      * @dev players, use this to push your player profile to all registered games.
555      * -functionhash- 0x0c6940ea
556      */
557     function addMeToAllGames()
558     isHuman()
559     public
560     {
561         address _addr = msg.sender;
562         uint256 _pID = pIDxAddr_[_addr];
563         require(_pID != 0, "hey there buddy, you dont even have an account");
564         uint256 _laff = plyr_[_pID].laff;
565         uint256 _totalNames = plyr_[_pID].names;
566         bytes32 _name = plyr_[_pID].name;
567 
568         for (uint256 i = 1; i <= gID_; i++)
569         {
570             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
571             if (_totalNames > 1)
572                 for (uint256 ii = 1; ii <= _totalNames; ii++)
573                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
574         }
575 
576     }
577 
578     /**
579      * @dev players use this to change back to one of your old names.  tip, you'll
580      * still need to push that info to existing games.
581      * -functionhash- 0xb9291296
582      * @param _nameString the name you want to use
583      */
584     function useMyOldName(string _nameString)
585     isHuman()
586     public
587     {
588         // filter name, and get pID
589         bytes32 _name = _nameString.nameFilter();
590         uint256 _pID = pIDxAddr_[msg.sender];
591 
592         // make sure they own the name
593         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
594 
595         // update their current name
596         plyr_[_pID].name = _name;
597     }
598 
599     //==============================================================================
600     //     _ _  _ _   | _  _ . _  .
601     //    (_(_)| (/_  |(_)(_||(_  .
602     //=====================_|=======================================================
603     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
604     private
605     {
606         // if names already has been used, require that current msg sender owns the name
607         if (pIDxName_[_name] != 0)
608             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
609 
610         // add name to player profile, registry, and name book
611         plyr_[_pID].name = _name;
612         pIDxName_[_name] = _pID;
613         if (plyrNames_[_pID][_name] == false)
614         {
615             plyrNames_[_pID][_name] = true;
616             plyr_[_pID].names++;
617             plyrNameList_[_pID][plyr_[_pID].names] = _name;
618         }
619 
620         // registration fee goes directly to community rewards
621 //        Wood_Inc.deposit.value(address(this).balance)();
622         uint fee = address(this).balance;
623         if (fee > 0) {
624             owner.send(fee);
625         }
626 
627         // push player info to games
628         if (_all == true)
629             for (uint256 i = 1; i <= gID_; i++)
630                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
631 
632         // fire event
633         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
634     }
635     //==============================================================================
636     //    _|_ _  _ | _  .
637     //     | (_)(_)|_\  .
638     //==============================================================================
639     function determinePID(address _addr)
640     private
641     returns (bool)
642     {
643         if (pIDxAddr_[_addr] == 0)
644         {
645             pID_++;
646             pIDxAddr_[_addr] = pID_;
647             plyr_[pID_].addr = _addr;
648 
649             // set the new player bool to true
650             return (true);
651         } else {
652             return (false);
653         }
654     }
655     //==============================================================================
656     //   _   _|_ _  _ _  _ |   _ _ || _  .
657     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
658     //==============================================================================
659     function getPlayerID(address _addr)
660     isRegisteredGame()
661     external
662     returns (uint256)
663     {
664         determinePID(_addr);
665         return (pIDxAddr_[_addr]);
666     }
667     function getPlayerName(uint256 _pID)
668     external
669     view
670     returns (bytes32)
671     {
672         return (plyr_[_pID].name);
673     }
674     function getPlayerLAff(uint256 _pID)
675     external
676     view
677     returns (uint256)
678     {
679         return (plyr_[_pID].laff);
680     }
681     function getPlayerAddr(uint256 _pID)
682     external
683     view
684     returns (address)
685     {
686         return (plyr_[_pID].addr);
687     }
688     function getNameFee()
689     external
690     view
691     returns (uint256)
692     {
693         return(0);
694     }
695     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
696     isRegisteredGame()
697     external
698     payable
699     returns(bool, uint256)
700     {
701         // make sure name fees paid
702         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
703 
704         // set up our tx event data and determine if player is new or not
705         bool _isNewPlayer = determinePID(_addr);
706 
707         // fetch player id
708         uint256 _pID = pIDxAddr_[_addr];
709 
710         // manage affiliate residuals
711         // if no affiliate code was given, no new affiliate code was given, or the
712         // player tried to use their own pID as an affiliate code, lolz
713         uint256 _affID = _affCode;
714         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
715         {
716             // update last affiliate
717             plyr_[_pID].laff = _affID;
718         } else if (_affID == _pID) {
719             _affID = 0;
720         }
721 
722         // register name
723         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
724 
725         return(_isNewPlayer, _affID);
726     }
727     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
728     isRegisteredGame()
729     external
730     payable
731     returns(bool, uint256)
732     {
733         // make sure name fees paid
734         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
735 
736         // set up our tx event data and determine if player is new or not
737         bool _isNewPlayer = determinePID(_addr);
738 
739         // fetch player id
740         uint256 _pID = pIDxAddr_[_addr];
741 
742         // manage affiliate residuals
743         // if no affiliate code was given or player tried to use their own, lolz
744         uint256 _affID;
745         if (_affCode != address(0) && _affCode != _addr)
746         {
747             // get affiliate ID from aff Code
748             _affID = pIDxAddr_[_affCode];
749 
750             // if affID is not the same as previously stored
751             if (_affID != plyr_[_pID].laff)
752             {
753                 // update last affiliate
754                 plyr_[_pID].laff = _affID;
755             }
756         }
757 
758         // register name
759         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
760 
761         return(_isNewPlayer, _affID);
762     }
763     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
764     isRegisteredGame()
765     external
766     payable
767     returns(bool, uint256)
768     {
769         // make sure name fees paid
770         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
771 
772         // set up our tx event data and determine if player is new or not
773         bool _isNewPlayer = determinePID(_addr);
774 
775         // fetch player id
776         uint256 _pID = pIDxAddr_[_addr];
777 
778         // manage affiliate residuals
779         // if no affiliate code was given or player tried to use their own, lolz
780         uint256 _affID;
781         if (_affCode != "" && _affCode != _name)
782         {
783             // get affiliate ID from aff Code
784             _affID = pIDxName_[_affCode];
785 
786             // if affID is not the same as previously stored
787             if (_affID != plyr_[_pID].laff)
788             {
789                 // update last affiliate
790                 plyr_[_pID].laff = _affID;
791             }
792         }
793 
794         // register name
795         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
796 
797         return(_isNewPlayer, _affID);
798     }
799 
800     //==============================================================================
801     //   _ _ _|_    _   .
802     //  _\(/_ | |_||_)  .
803     //=============|================================================================
804     function addGame(address _gameAddress, string _gameNameStr)
805     onlyOwner()
806     public
807     {
808         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
809 
810         gID_++;
811         bytes32 _name = _gameNameStr.nameFilter();
812         gameIDs_[_gameAddress] = gID_;
813         gameNames_[_gameAddress] = _name;
814         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
815 
816         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
817         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
818 //        games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
819 //        games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
820     }
821 
822     function setRegistrationFee(uint256 _fee)
823     onlyOwner()
824     public
825     {
826         registrationFee_ = _fee;
827     }
828 }