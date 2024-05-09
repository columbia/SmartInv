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
13 
14 /**
15  * @title SafeMath v0.1.9
16  * @dev Math operations with safety checks that throw on error
17  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
18  * - added sqrt
19  * - added sq
20  * - added pwr
21  * - changed asserts to requires with error log outputs
22  * - removed div, its useless
23  */
24 library SafeMath {
25 
26     /**
27     * @dev Multiplies two numbers, throws on overflow.
28     */
29     function mul(uint256 a, uint256 b)
30     internal
31     pure
32     returns (uint256 c)
33     {
34         if (a == 0 || b == 0) {
35             return 0;
36         }
37         c = a * b;
38         require(c / a == b, "SafeMath mul failed");
39         return c;
40     }
41 
42     /**
43     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b)
46     internal
47     pure
48     returns (uint256)
49     {
50         require(b <= a, "SafeMath sub failed");
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b)
58     internal
59     pure
60     returns (uint256 c)
61     {
62         c = a + b;
63         require(c >= a, "SafeMath add failed");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) 
68     internal 
69     pure 
70     returns (uint256 c) 
71     {
72         // require(b > 0);
73         if(b <= 0) return 0;
74         else return a / b;
75     }
76 
77     /**
78      * @dev gives square root of given x.
79      */
80     function sqrt(uint256 x)
81     internal
82     pure
83     returns (uint256 y)
84     {
85         uint256 z = ((add(x,1)) / 2);
86         y = x;
87         while (z < y)
88         {
89             y = z;
90             z = ((add((x / z),z)) / 2);
91         }
92     }
93 
94     /**
95      * @dev gives square. multiplies x by x
96      */
97     function sq(uint256 x)
98     internal
99     pure
100     returns (uint256)
101     {
102         return (mul(x,x));
103     }
104 
105     /**
106      * @dev x to the power of y
107      */
108     function pwr(uint256 x, uint256 y)
109     internal
110     pure
111     returns (uint256)
112     {
113         if (x==0)
114             return (0);
115         else if (y==0)
116             return (1);
117         else
118         {
119             uint256 z = x;
120             for (uint256 i=1; i < y; i++)
121                 z = mul(z,x);
122             return (z);
123         }
124     }
125 }
126 
127 library NameFilter {
128 
129     /**
130      * @dev filters name strings
131      * -converts uppercase to lower case.
132      * -makes sure it does not start/end with a space
133      * -makes sure it does not contain multiple spaces in a row
134      * -cannot be only numbers
135      * -cannot start with 0x
136      * -restricts characters to A-Z, a-z, 0-9, and space.
137      * @return reprocessed string in bytes32 format
138      */
139     function nameFilter(string  _input)
140     internal
141     pure
142     returns(bytes32)
143     {
144         bytes memory _temp = bytes(_input);
145         uint256 _length = _temp.length;
146 
147         //sorry limited to 32 characters
148         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
149         // make sure it doesnt start with or end with space
150         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
151         // make sure first two characters are not 0x
152         if (_temp[0] == 0x30)
153         {
154             require(_temp[1] != 0x78, "string cannot start with 0x");
155             require(_temp[1] != 0x58, "string cannot start with 0X");
156         }
157 
158         // create a bool to track if we have a non number character
159         bool _hasNonNumber;
160 
161         // convert & check
162         for (uint256 i = 0; i < _length; i++)
163         {
164             // if its uppercase A-Z
165             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
166             {
167                 // convert to lower case a-z
168                 _temp[i] = byte(uint(_temp[i]) + 32);
169 
170                 // we have a non number
171                 if (_hasNonNumber == false)
172                     _hasNonNumber = true;
173             } else {
174                 require
175                 (
176                 // require character is a space
177                     _temp[i] == 0x20 ||
178                 // OR lowercase a-z
179                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
180                 // or 0-9
181                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
182                     "string contains invalid characters"
183                 );
184                 // make sure theres not 2x spaces in a row
185                 if (_temp[i] == 0x20)
186                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
187 
188                 // see if we have a character other than a number
189                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
190                     _hasNonNumber = true;
191             }
192         }
193 
194         require(_hasNonNumber == true, "string cannot be only numbers");
195 
196         bytes32 _ret;
197         assembly {
198             _ret := mload(add(_temp, 32))
199         }
200         return (_ret);
201     }
202 }
203 
204 
205 /**
206  * @title Ownable
207  * @dev The Ownable contract has an owner address, and provides basic authorization control
208  * functions, this simplifies the implementation of "user permissions".
209  */
210 contract Ownable {
211     address public owner;
212 
213 
214     event OwnershipRenounced(address indexed previousOwner);
215     event OwnershipTransferred(
216         address indexed previousOwner,
217         address indexed newOwner
218     );
219 
220 
221     /**
222      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223      * account.
224      */
225     constructor() public {
226         owner = msg.sender;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(msg.sender == owner);
234         _;
235     }
236 
237     /**
238      * @dev Allows the current owner to relinquish control of the contract.
239      * @notice Renouncing to ownership will leave the contract without an owner.
240      * It will not be possible to call the functions with the `onlyOwner`
241      * modifier anymore.
242      */
243     function renounceOwnership() public onlyOwner {
244         emit OwnershipRenounced(owner);
245         owner = address(0);
246     }
247 
248     /**
249      * @dev Allows the current owner to transfer control of the contract to a newOwner.
250      * @param _newOwner The address to transfer ownership to.
251      */
252     function transferOwnership(address _newOwner) public onlyOwner {
253         _transferOwnership(_newOwner);
254     }
255 
256     /**
257      * @dev Transfers control of the contract to a newOwner.
258      * @param _newOwner The address to transfer ownership to.
259      */
260     function _transferOwnership(address _newOwner) internal {
261         require(_newOwner != address(0));
262         emit OwnershipTransferred(owner, _newOwner);
263         owner = _newOwner;
264     }
265 }
266 
267 // "./PlayerBookInterface.sol";
268 // "./SafeMath.sol";
269 // "./NameFilter.sol";
270 // 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
271 
272 //==============================================================================
273 //     _    _  _ _|_ _  .
274 //    (/_\/(/_| | | _\  .
275 //==============================================================================
276 contract F3Devents {
277     /*
278     event debug (
279         uint16 code,
280         uint256 value,
281         bytes32 msg
282     );
283     */
284 
285     // fired whenever a player registers a name
286     event onNewName
287     (
288         uint256 indexed playerID,
289         address indexed playerAddress,
290         bytes32 indexed playerName,
291         bool isNewPlayer,
292         uint256 affiliateID,
293         address affiliateAddress,
294         bytes32 affiliateName,
295         uint256 amountPaid,
296         uint256 timeStamp
297     );
298 
299     // (fomo3d long only) fired whenever a player tries a buy after round timer
300     // hit zero, and causes end round to be ran.
301     // emit F3Devents.onBuyAndDistribute
302     //             (
303     //                 msg.sender,
304     //                 plyr_[_pID].name,
305     //                 plyr_[_pID].cosd,
306     //                 plyr_[_pID].cosc,
307     //                 plyr_[pIDCom_].cosd,
308     //                 plyr_[pIDCom_].cosc,
309     //                 plyr_[_affID].affVltCosd,
310     //                 plyr_[_affID].affVltCosc,
311     //                 keyNum_
312     //             );
313     event onBuyAndDistribute
314     (
315         address playerAddress,
316         bytes32 playerName,
317         uint256 pCosd,
318         uint256 pCosc,
319         uint256 comCosd,
320         uint256 comCosc,
321         uint256 affVltCosd,
322         uint256 affVltCosc,
323         uint256 keyNums
324     );
325 
326     // emit F3Devents.onRecHldVltCosd
327     //                     (
328     //                         msg.sender,
329     //                         plyr_[j].name,
330     //                         plyr_[j].hldVltCosd
331     //                     );
332     event onRecHldVltCosd
333     (
334         address playerAddress,
335         bytes32 playerName, 
336         uint256 hldVltCosd
337     );
338 
339     // emit F3Devents.onSellAndDistribute
340     //             (
341     //                 msg.sender,
342     //                 plyr_[_pID].name,
343     //                 plyr_[_pID].cosd,
344     //                 plyr_[_pID].cosc,
345     //                 keyNum_
346     //             );
347     event onSellAndDistribute
348     (
349         address playerAddress,
350         bytes32 playerName,
351         uint256 pCosd,
352         uint256 pCosc,
353         uint256 keyNums
354     );
355 
356    
357     event onWithdrawHoldVault
358     (
359         uint256 indexed playerID,
360         address playerAddress,
361         bytes32 playerName,
362         uint256 plyr_cosd,
363         uint256 plyr_hldVltCosd
364     );
365     
366     event onWithdrawAffVault
367     (
368         uint256 indexed playerID,
369         address playerAddress,
370         bytes32 playerName,
371         uint256 plyr_cosd,
372         uint256 plyr_cosc,
373         uint256 plyr_affVltCosd,
374         uint256 plyr_affVltCosc
375     );
376     
377     event onWithdrawWonCosFromGame
378     (
379         uint256 indexed playerID,
380         address playerAddress,
381         bytes32 playerName,
382         uint256 plyr_cosd,
383         uint256 plyr_cosc,
384         uint256 plyr_affVltCosd
385     );
386 }
387 
388 contract modularLong is F3Devents {}
389 
390 contract FoMo3DLong is modularLong, Ownable {
391     using SafeMath for *;
392     using NameFilter for *;
393     using F3DKeysCalcLong for *;
394 
395     //    otherFoMo3D private otherF3D_;
396     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x82cFeBf0F80B9617b8D13368eFC9B76C48F096d4);
397 
398      //==============================================================================
399     //     _ _  _  |`. _     _ _ |_ | _  _  .
400     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
401     //=================_|===========================================================
402     string constant public name = "FoMo3D World";
403     string constant public symbol = "F3DW";
404     //    uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO
405     // uint256 constant public rndGap_ = 0; // 120 seconds;         // length of ICO phase.
406     // uint256 constant public rndInit_ = 350 minutes;                // round timer starts at this
407     // uint256 constant public rndShow_ = 10 minutes;                // 
408     // uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
409     // uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
410 
411     // uint256 constant public rndFirst_ = 1 hours;                // a round fist step timer can be
412 
413     // uint256 constant public threshould_ = 10;//超过XXX个cos
414 
415     uint256 public rID_;    // round id number / total rounds that have happened
416     uint256 public plyNum_ = 2;
417     // uint256 public keyNum_ = 0;
418     uint256 public cosdNum_ = 0;
419     uint256 public coscNum_ = 0;
420     uint256 public totalVolume_ = 0;
421     uint256 public totalVltCosd_ = 0;
422     uint256 public result_ = 0;
423     uint256 public price_ = 10**16;
424     uint256 public priceCntThreshould_ = 100000; 
425 
426     uint256 constant public pIDCom_ = 1;
427     //****************
428     // PLAYER DATA
429     //****************
430     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
431     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
432     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
433     // mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
434     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
435     //****************
436     // ROUND DATA
437     //****************
438     // mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
439     // mapping (uint256 => mapping(uint256 => F3Ddatasets.Prop)) public rndProp_;      // (rID => propID => data) eth in per team, by round id and team id
440     // mapping (uint256 => mapping(uint256 => F3Ddatasets.Team)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
441     // mapping (uint256 => F3Ddatasets.Leader) public rndLd_;      // (rID => data) eth in per team, by round id and team id
442     
443     //****************
444     // TEAM FEE DATA
445     //****************
446 
447     // mapping (uint256 => F3Ddatasets.Team) public teams_;          // (teamID => team)
448     // mapping (uint256 => F3Ddatasets.Prop) public props_;          // (teamID => team)
449     // mapping (uint256 => F3Ddatasets.Fee) public fees_;          // (teamID => team)
450     
451     //F3Ddatasets.EventReturns  _eventData_;
452     
453     // fees_[0] = F3Ddatasets.Fee(5,2,3);    //cosdBuyFee
454     // fees_[1] = F3Ddatasets.Fee(0,0,20);  //cosdSellFee
455     // fees_[2] = F3Ddatasets.Fee(4,1,0);    //coscBuyFee
456     // fees_[3] = F3Ddatasets.Fee(0,0,0);   //coscSellFee
457 
458     constructor()
459     public
460     {
461         //teams
462         // teams_[0] = F3Ddatasets.Team(0,70,0);
463         // teams_[1] = F3Ddatasets.Team(1,30,0);
464         //props
465         // props_[0] = F3Ddatasets.Prop(0,5,20,20);
466         // props_[1] = F3Ddatasets.Prop(1,2,0,20);
467         // props_[2] = F3Ddatasets.Prop(2,2,10,0);
468         // props_[3] = F3Ddatasets.Prop(3,1,0,10);
469         // props_[4] = F3Ddatasets.Prop(4,1,10,0);
470         //fees
471         // fees_[0] = F3Ddatasets.Fee(5,2,3);    //cosdBuyFee
472         // fees_[1] = F3Ddatasets.Fee(0,0,20);  //cosdSellFee
473         // fees_[2] = F3Ddatasets.Fee(4,1,0);    //coscBuyFee
474         // fees_[3] = F3Ddatasets.Fee(0,0,0);   //coscSellFee
475     }
476 
477     // **
478     //  * @dev used to make sure no one can interact with contract until it has
479     //  * been activated.
480     //  *
481     // modifier isActivated() {
482     //     require(activated_ == true, "its not ready yet.  check ?eta in discord");
483     //     _;
484     // }
485 
486     /**
487      * @dev prevents contracts from interacting with fomo3d
488      */
489     modifier isHuman() {
490         address _addr = msg.sender;
491         uint256 _codeLength;
492 
493         assembly {_codeLength := extcodesize(_addr)}
494         require(_codeLength == 0, "sorry humans only");
495         _;
496     }
497 
498     /**
499      * @dev sets boundaries for incoming tx
500      */
501     modifier isWithinLimits(uint256 _eth) {
502         require(_eth >= 1000000000, "pocket lint: not a valid currency");
503         //require(_eth <= 100000000000000000000000, "no vitalik, no");
504         _;
505     }
506 
507     function buyXaddr(address _pAddr, address _affCode, uint256 _eth, string _keyType)//sent
508     // isActivated()
509     // isHuman()
510     onlyOwner()
511     // isWithinLimits(msg.value)
512     public
513     // payable
514     // returns(uint256)
515     {
516         // set up our tx event data and determine if player is new or not
517         // F3Ddatasets.EventReturns memory _eventData_;
518         // _eventData_ = determinePID(_eventData_);
519         determinePID(_pAddr);
520 
521         // fetch player id
522         uint256 _pID = pIDxAddr_[_pAddr];
523 
524         // manage affiliate residuals
525         uint256 _affID;
526         // if no affiliate code was given or player tried to use their own, lolz
527         if (_affCode == address(0) || _affCode == _pAddr)
528         {
529             // use last stored affiliate code
530             _affID = plyr_[_pID].laff;
531 
532             // if affiliate code was given
533         } else {
534             // get affiliate ID from aff Code
535             _affID = pIDxAddr_[_affCode];
536 
537             // if affID is not the same as previously stored
538             if (_affID != plyr_[_pID].laff)
539             {
540                 // update last affiliate
541                 plyr_[_pID].laff = _affID;
542             }
543         }
544 
545         // verify a valid team was selected
546         // _team = verifyTeam(_team);
547 
548         // buy core
549         buyCore(_pID, _affID, _eth, _keyType);
550     }
551 
552     function registerNameXaddr(string   memory  _nameString, address _affCode, bool _all)//sent,user
553     // isHuman()
554     // onlyOwner()
555     public
556     payable
557     {
558         bytes32 _name = _nameString.nameFilter();
559         address _addr = msg.sender;
560         uint256 _paid = msg.value;
561         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
562 
563         if(_isNewPlayer) plyNum_++;
564 
565         uint256 _pID = pIDxAddr_[_addr];
566 
567         // fire event
568         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
569     }
570 
571     function ttlSply()
572     public
573     view
574     returns(uint256, uint256, uint256, uint256)
575     {
576         return (cosdNum_, coscNum_, totalVolume_, totalVltCosd_);
577     }
578    
579     function getBuyPrice()
580     public
581     view
582     returns(uint256)
583     {
584         return price_;
585     }
586   
587     function getPlayerInfoByAddress(address _addr)
588     public
589     view
590     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
591     {
592         // setup local rID
593         // uint256 _rID = rID_;
594         // address _addr = _addr_;
595 
596         // if (_addr == address(0))
597         // {
598         //     _addr == msg.sender;
599         // }
600         uint256 _pID = pIDxAddr_[_addr];
601 
602         return
603         (
604             _pID,
605             plyr_[_pID].name,
606             plyr_[_pID].laff,    
607             plyr_[_pID].eth,
608             plyr_[_pID].cosd,       
609             plyr_[_pID].cosc,
610             plyr_[_pID].hldVltCosd,
611             plyr_[_pID].affCosd,
612             plyr_[_pID].affCosc,
613             plyr_[_pID].totalHldVltCosd,
614             plyr_[_pID].totalAffCos,
615             plyr_[_pID].totalWinCos
616         );
617     }
618 
619    
620     function buyCore(uint256 _pID, uint256 _affID, uint256 _eth, string _keyType)
621     private
622     // returns(uint256)
623     {
624         uint256 _keys;
625         // if eth left is greater than min eth allowed (sorry no pocket lint)
626         if (_eth >= 0)
627         {
628             require(_eth >= getBuyPrice());
629             // mint the new keys
630             _keys = keysRec(_eth);
631             // pay 2% out to community rewards
632             uint256 _aff;
633             uint256 _com;
634             uint256 _holders;
635             uint256 _self;
636 
637             // if (isCosd(_keyType) == true) {
638             //     _aff        = _keys.mul(fees_[0].aff)/100;
639             //     _com        = _keys.mul(fees_[0].com)/100;
640             //     _holders    = _keys.mul(fees_[0].holders)/100;
641             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
642             // }else{
643             //     _aff        = _keys.mul(fees_[2].aff)/100;
644             //     _com        = _keys.mul(fees_[2].com)/100;
645             //     _holders    = _keys.mul(fees_[2].holders)/100;
646             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
647             // }
648 
649             // // if they bought at least 1 whole key
650             // if (_keys >= 1)
651             // {
652             //     // set new leaders
653             //     if (round_[_rID].plyr != _pID)
654             //         round_[_rID].plyr = _pID;
655             //     if (round_[_rID].team != _team)
656             //         round_[_rID].team = _team;
657             // }
658             // update player
659             if(isCosd(_keyType) == true){
660                 
661                 _aff        = _keys * 5/100;
662                 _com        = _keys * 2/100;
663                 _holders    = _keys * 3/100;
664                 _self       = _keys.sub(_aff).sub(_com).sub(_holders);
665 
666                 uint256 _hldCosd;
667                 for (uint256 i = 1; i <= plyNum_; i++) {
668                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
669                 }
670 
671                 //Player
672                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
673                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
674                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
675                 
676                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
677 
678                 for (uint256 j = 1; j <= plyNum_; j++) {
679                     if(plyr_[j].cosd>0) {
680                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
681                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
682                         
683                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
684                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
685                         emit F3Devents.onRecHldVltCosd
686                         (
687                             plyr_[j].addr,
688                             plyr_[j].name,
689                             plyr_[j].hldVltCosd
690                         );
691                     }
692                 }
693                 //team
694                 // rndTmEth_[_rID][_team].cosd = _self.add(rndTmEth_[_rID][_team].cosd);
695                 cosdNum_ = cosdNum_.add(_keys);
696                 totalVolume_ = totalVolume_.add(_keys);
697             }
698             else{//cosc
699                 _aff        = _keys *4/100;
700                 _com        = _keys *1/100;
701                 // _holders    = _keys.mul(fees_[2].holders)/100;
702                 _self       = _keys.sub(_aff).sub(_com);
703                 //Player
704                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_self);
705                 plyr_[pIDCom_].cosc = plyr_[pIDCom_].cosc.add(_com);
706                 plyr_[_affID].affCosc = plyr_[_affID].affCosc.add(_aff);
707                 
708                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
709                 // rndTmEth_[_rID][_team].cosc = _self.add(rndTmEth_[_rID][_team].cosc);
710                 coscNum_ = coscNum_.add(_keys);
711                 totalVolume_ = totalVolume_.add(_keys);
712             }
713 
714             // keyNum_ = keyNum_.add(_keys);//update
715         }
716 
717         // return _keys;
718     }  
719 
720    
721     function sellKeys(uint256 _pID, uint256 _keys, string _keyType)//send
722     // isActivated()
723     // isHuman()
724     onlyOwner()
725     // isWithinLimits(msg.value)
726     public
727     // payable
728     returns(uint256)
729     {
730         // uint256 _pID = _pID_;
731         // uint256 _keys = _keys_;
732         require(_keys>0);
733         uint256 _eth;
734 
735         // uint256 _aff;
736         // uint256 _com;
737         uint256 _holders;
738         uint256 _self;
739         // if (isCosd(_keyType) == true) {
740         //         // _aff        = _keys.mul(fees_[1].aff)/100;
741         //         // _com        = _keys.mul(fees_[1].com)/100;
742         //         _holders    = _keys.mul(fees_[1].holders)/100;
743         //         // _self       = _keys.sub(_aff).sub(_com);
744         //         _self       = _self.sub(_holders);
745         // }else{
746         //         // _aff        = _keys.mul(fees_[3].aff)/100;
747         //         // _com        = _keys.mul(fees_[3].com)/100;
748         //         _holders    = _keys.mul(fees_[3].holders)/100;
749         //         // _self       = _keys.sub(_aff).sub(_com);
750         //         _self       = _self.sub(_holders);
751         // }
752         //split
753        if(isCosd(_keyType) == true){
754                 require(plyr_[_pID].cosd >= _keys,"Do not have cosd!");
755                 
756                 // _aff        = _keys.mul(fees_[1].aff)/100;
757                 // _com        = _keys.mul(fees_[1].com)/100;
758                 _holders    = _keys * 20/100;
759                 // _self       = _keys.sub(_aff).sub(_com);
760                 _self       = _keys.sub(_holders);
761 
762                 uint256 _hldCosd;
763                 for (uint256 i = 1; i <= plyNum_; i++) {
764                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
765                 }
766 
767                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
768 
769                 _eth = ethRec(_self);
770                 plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
771 
772                 for (uint256 j = 1; j <= plyNum_; j++) {
773                     if( plyr_[j].cosd>0) {                    
774                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
775                         
776                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
777                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
778                         emit F3Devents.onRecHldVltCosd
779                         (
780                             plyr_[j].addr,
781                             plyr_[j].name,
782                             plyr_[j].hldVltCosd
783                         );
784                     }
785                 }
786                 cosdNum_ = cosdNum_.sub(_self);
787                 totalVolume_ = totalVolume_.add(_keys);
788        }
789        else{
790             require(plyr_[_pID].cosc >= _keys,"Do not have cosc!");           
791 
792             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
793 
794             _eth = ethRec(_keys);
795             plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
796             
797             coscNum_ = coscNum_.sub(_keys);
798             totalVolume_ = totalVolume_.add(_keys);
799        }
800 
801     //   keyNum_ = keyNum_.sub(_keys);//update
802        // _eth = _keys.ethRec(getBuyPrice());
803 
804        return _eth;
805     }
806 
807     function addCosToGame(uint256 _pID, uint256 _keys, string _keyType)//sent
808     onlyOwner()
809     public
810     // returns(bool)
811     {
812             // uint256 _rID = rID_;
813             // uint256 _now = now;
814 
815             uint256 _aff;
816             uint256 _com;
817             uint256 _holders;
818             // uint256 _self;
819             uint256 _affID = plyr_[_pID].laff;
820 
821             // update player
822             if(isCosd(_keyType) == true){         //扣除9%
823 
824                 require(plyr_[_pID].cosd >= _keys);
825 
826                 _aff        = _keys *1/100;
827                 _com        = _keys *3/100;
828                 _holders    = _keys *5/100;
829                 // _self       = _keys.sub(_aff).sub(_com).sub(_holders);
830                 //Player
831                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
832 
833                 uint256 _hldCosd;
834                 for (uint256 i = 1; i <= plyNum_; i++) {
835                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
836                 }
837 
838                 //Player
839                 // plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
840                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
841                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
842             
843                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
844 
845                 for (uint256 j = 1; j <= plyNum_; j++) {
846                     if(plyr_[j].cosd>0) {
847                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
848                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
849                         
850                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
851                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
852                         emit F3Devents.onRecHldVltCosd
853                         (
854                             plyr_[j].addr,
855                             plyr_[j].name,
856                             plyr_[j].hldVltCosd
857                         );
858                     }
859                 }
860             }
861             else{//cosc
862                 require(plyr_[_pID].cosc >= _keys);
863                 //Player
864                 plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
865             }
866         
867             // return true;
868     }
869 
870     function winCosFromGame(uint256 _pID, uint256 _keys, string _keyType)//sent
871     onlyOwner()
872     public
873     // returns(bool)
874     {
875             // uint256 _rID = rID_;
876             // uint256 _now = now;
877 
878             // update player
879             if(isCosd(_keyType) == true){
880                 // require(plyr_[_pID].cosd >= _keys);
881                 //Player
882                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_keys);
883             }
884             else{//cosc
885                 // require(plyr_[_pID].cosc >= _keys);
886                 //Player
887                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_keys);
888             }
889             
890             plyr_[_pID].totalWinCos = plyr_[_pID].totalWinCos.add(_keys);
891         
892             // return true;
893     }    
894    
895     function iWantXKeys(uint256 _keys)
896     public
897     view
898     returns(uint256)
899     {
900         return eth(_keys);
901     }
902     
903     function howManyKeysCanBuy(uint256 _eth)
904     public
905     view
906     returns(uint256)
907     {
908         return keys(_eth);
909     }
910     //==============================================================================
911     //    _|_ _  _ | _  .
912     //     | (_)(_)|_\  .
913     // //==============================================================================
914     // 
915     //  @dev receives name/player info from names contract
916     //  
917     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
918     external
919     {
920         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
921         if (pIDxAddr_[_addr] != _pID)
922             pIDxAddr_[_addr] = _pID;
923         if (pIDxName_[_name] != _pID)
924             pIDxName_[_name] = _pID;
925         if (plyr_[_pID].addr != _addr)
926             plyr_[_pID].addr = _addr;
927         if (plyr_[_pID].name != _name)
928             plyr_[_pID].name = _name;
929         if (plyr_[_pID].laff != _laff)
930             plyr_[_pID].laff = _laff;
931         if (plyrNames_[_pID][_name] == false)
932             plyrNames_[_pID][_name] = true;
933     }
934 
935     //  **
936     //  * @dev receives entire player name list
937     //  *
938     function receivePlayerNameList(uint256 _pID, bytes32 _name)
939     external
940     {
941         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
942         if(plyrNames_[_pID][_name] == false)
943             plyrNames_[_pID][_name] = true;
944     }
945 
946     // **
947     //  * @dev gets existing or registers new pID.  use this when a player may be new
948     //  * @return pID
949     //  *
950     function determinePID(address _pAddr)
951     private
952     {
953         uint256 _pID = pIDxAddr_[_pAddr];
954         // if player is new to this version of fomo3d
955         if (_pID == 0)
956         {
957             // grab their player ID, name and last aff ID, from player names contract
958             _pID = PlayerBook.getPlayerID(_pAddr);
959             bytes32 _name = PlayerBook.getPlayerName(_pID);
960             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
961 
962             // set up player account
963             pIDxAddr_[_pAddr] = _pID;
964             plyr_[_pID].addr = _pAddr;
965 
966             if (_name != "")
967             {
968                 pIDxName_[_name] = _pID;
969                 plyr_[_pID].name = _name;
970                 plyrNames_[_pID][_name] = true;
971             }
972 
973             if (_laff != 0 && _laff != _pID)
974                 plyr_[_pID].laff = _laff;
975 
976             // set the new player bool to true
977             // _eventData_.compressedData = _eventData_.compressedData + 1;
978             // plyNum_++;
979         }
980         // return (_eventData_);
981     }
982     
983     function withdrawETH(uint256 _pID)//send
984     // isHuman()
985     onlyOwner()
986     public
987     returns(bool)
988     {
989         if (plyr_[_pID].eth>0) {
990             plyr_[_pID].eth = 0;
991         }
992         return true;
993     }
994 
995     function withdrawHoldVault(uint256 _pID)//send
996     // isHuman()
997     onlyOwner()
998     public
999     returns(bool)
1000     {
1001         if (plyr_[_pID].hldVltCosd>0) {
1002             plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].hldVltCosd);
1003             
1004             plyr_[_pID].totalHldVltCosd = plyr_[_pID].totalHldVltCosd.add(plyr_[_pID].hldVltCosd);
1005             totalVltCosd_ = totalVltCosd_.add(plyr_[_pID].hldVltCosd);
1006                         
1007             plyr_[_pID].hldVltCosd = 0;
1008         }
1009 
1010         emit F3Devents.onWithdrawHoldVault
1011                     (
1012                         _pID,
1013                         plyr_[_pID].addr,
1014                         plyr_[_pID].name,
1015                         plyr_[_pID].cosd,
1016                         plyr_[_pID].hldVltCosd
1017                     );
1018 
1019         return true;
1020     }
1021 
1022     function withdrawAffVault(uint256 _pID, string _keyType)//send
1023     // isHuman()
1024     onlyOwner()
1025     public
1026     returns(bool)
1027     {
1028 
1029         if(isCosd(_keyType) == true){
1030 
1031             if (plyr_[_pID].affCosd>0) {
1032                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].affCosd);
1033                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosd);
1034                 plyr_[_pID].affCosd = 0;
1035             }
1036         }
1037         else{
1038             if (plyr_[_pID].affCosc>0) {
1039                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(plyr_[_pID].affCosc);
1040                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosc);
1041                 plyr_[_pID].affCosc = 0;
1042             }
1043         }
1044 
1045         emit F3Devents.onWithdrawAffVault
1046         (
1047                         _pID,
1048                         plyr_[_pID].addr,
1049                         plyr_[_pID].name,
1050                         plyr_[_pID].cosd,
1051                         plyr_[_pID].cosc,
1052                         plyr_[_pID].affCosd,
1053                         plyr_[_pID].affCosc
1054         );
1055 
1056         return true;
1057     }
1058 
1059     function transferToAnotherAddr(address _from, address _to, uint256 _keys, string _keyType) //sent
1060     // isHuman()
1061     onlyOwner()
1062     public
1063     // returns(bool)
1064     {
1065         // uint256 _rID = rID_;
1066         // uint256 _holders;
1067         // uint256 _self;
1068         // uint256 i;
1069 
1070         // determinePID();
1071         // fetch player id
1072         uint256 _pID = pIDxAddr_[_from];
1073         uint256 _tID = pIDxAddr_[_to];
1074 
1075         require(_tID > 0);
1076     
1077         if (isCosd(_keyType) == true) {
1078 
1079                 require(plyr_[_pID].cosd >= _keys);
1080 
1081                 // uint256 _hldCosd;
1082                 // for ( i = 1; i <= plyNum_; i++) {
1083                 //     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
1084                 // }
1085 
1086                 // _holders = _keys * 20/100;
1087                 // // _aff =     plyrRnds_[_pID][_rID].wonCosd * 1/100;
1088                 // _self = _keys.sub(_holders);
1089 
1090                 plyr_[_tID].cosd = plyr_[_tID].cosd.add(_keys);
1091                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
1092 
1093                 // for ( i = 1; i <= plyNum_; i++) {
1094                 //     if(plyr_[i].cosd>0) plyr_[i].hldVltCosd = plyr_[i].hldVltCosd.add(_holders.mul(plyr_[i].cosd).div(_hldCosd));
1095                 // }
1096         }
1097 
1098         else{
1099             require(plyr_[_pID].cosc >= _keys);
1100 
1101             plyr_[_tID].cosc = plyr_[_tID].cosc.add(_keys);
1102             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
1103         }
1104 
1105         // emit F3Devents.onWithdrawWonCosFromGame
1106         //             (
1107         //                 _pID,
1108         //                 msg.sender,
1109         //                 plyr_[i].name,
1110         //                 plyr_[_pID].cosd,
1111         //                 plyr_[_pID].cosc,
1112         //                 plyr_[_pID].affVltCosd
1113         //             );
1114 
1115         // return true;
1116     }
1117     
1118     function isCosd(string _keyType)
1119     public
1120     pure
1121     returns(bool)
1122     {
1123         if( bytes(_keyType).length == 8 )
1124         {
1125             return true;
1126         }
1127         else 
1128         {
1129             return false;
1130         }
1131     }
1132     
1133     // function setResult(string _keyType) //send
1134     // public
1135     // // pure
1136     // returns(string)
1137     // {
1138     //     result_ = bytes(_keyType).length;
1139         
1140     //     return (_keyType);
1141     // }
1142     
1143     // function getResult(string _keyType)
1144     // public
1145     // pure
1146     // returns(uint256)
1147     // {
1148     //     // return bytes(_keyType).length;
1149     //     if( bytes(_keyType).length == 8 )
1150     //     {
1151     //         return 100;
1152     //     }
1153     //     else 
1154     //     {
1155     //         return 50;
1156     //     }
1157     // }
1158     
1159     function keysRec(uint256 _eth)
1160     internal
1161     returns (uint256)
1162     {
1163         // require(_price >= 10**16);
1164         
1165         uint256 _rstAmount = 0;
1166         uint256 _price = price_;
1167         // uint256 _keyNum = cosdNum_.add(coscNum_);
1168         // require(_eth >= msg.value);
1169 
1170         while(_eth >= _price){
1171             _eth = _eth - _price;
1172             _price = _price + 5 *10**11;
1173             
1174             if(_price >= 2 *10**17){ 
1175                 _price = 2 *10**17;
1176                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1177             }
1178             
1179             _rstAmount++;
1180         }
1181         
1182         price_ = _price;
1183 
1184         return _rstAmount;
1185     }
1186 
1187     function ethRec(uint256 _keys)
1188     internal
1189     returns (uint256)
1190     {
1191         // require(_price >= 10**16);
1192         
1193         uint256 _eth = 0;
1194         uint256 _price = price_;
1195         uint256 _keyNum = cosdNum_.add(coscNum_);
1196         // require(_eth >= msg.value);
1197 
1198         for(uint256 i=0;i < _keys;i++){
1199             if(_price < 10**16) _price = 10**16;
1200             
1201             _eth = _eth + _price;
1202             _price = _price - 5 *10**11;
1203             
1204             if(_price < 10**16) _price = 10**16;
1205             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1206         }
1207         
1208         price_ = _price;
1209 
1210         return _eth;
1211     }
1212 
1213     function keys(uint256 _eth)
1214     internal
1215     view
1216     returns(uint256)
1217     {
1218          // require(_price >= 10**16);
1219         
1220         uint256 _rstAmount = 0;
1221         uint256 _price = price_;
1222         // uint256 _keyNum = cosdNum_.add(coscNum_);
1223         // require(_eth >= _price);
1224 
1225         while(_eth >= _price){
1226             _eth = _eth - _price;
1227             _price = _price + 5 *10**11;
1228             
1229             if(_price >= 2 *10**17){ 
1230                 _price = 2 *10**17;
1231                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1232             }
1233             
1234             _rstAmount++;
1235         }
1236         
1237         // price_ = _price;
1238 
1239         return _rstAmount;
1240     }
1241 
1242     function eth(uint256 _keys)
1243     internal
1244     view
1245     returns(uint256)
1246     {
1247         // require(_price >= 10**16);
1248         
1249         uint256 _eth = 0;
1250         uint256 _price = price_;
1251         uint256 _keyNum = cosdNum_.add(coscNum_);
1252         // require(_eth >= msg.value);
1253 
1254         for(uint256 i=0;i < _keys;i++){
1255             if(_price < 10**16) _price = 10**16;
1256             
1257             _eth = _eth + _price;
1258             _price = _price - 5 *10**11;
1259             
1260             if(_price < 10**16) _price = 10**16;
1261             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1262         }
1263         
1264         // price_ = _price;
1265 
1266         return _eth;
1267     }
1268     
1269     //==============================================================================
1270     //    (~ _  _    _._|_    .
1271     //    _)(/_(_|_|| | | \/  .
1272     //====================/=========================================================
1273     // ** upon contract deploy, it will be deactivated.  this is a one time
1274     //  * use function that will activate the contract.  we do this so devs
1275     //  * have time to set things up on the web end                            **
1276     // bool public activated_ = false;
1277     // function activate()
1278     // public 
1279     // onlyOwner {
1280     //     // make sure that its been linked.
1281     //     //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1282 
1283     //     // can only be ran once
1284     //     require(activated_ == false, "fomo3d already activated");
1285 
1286     //     // activate the contract
1287     //     activated_ = true;
1288 
1289     //     // lets start first round
1290     //     // rID_ = 1;
1291     //     // round_[1].strt = now;
1292     //     // round_[1].end  = now.add(rndInit_);
1293     // }
1294 }
1295 
1296 library F3Ddatasets {
1297     //compressedData key
1298     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1299     // 0 - new player (bool)
1300     // 1 - joined round (bool)
1301     // 2 - new  leader (bool)
1302     // 3-5 - air drop tracker (uint 0-999)
1303     // 6-16 - round end time
1304     // 17 - winnerTeam
1305     // 18 - 28 timestamp
1306     // 29 - team
1307     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1308     // 31 - airdrop happened bool
1309     // 32 - airdrop tier
1310     // 33 - airdrop amount won
1311     //compressedIDs key
1312     // [77-52][51-26][25-0]
1313     // 0-25 - pID
1314     // 26-51 - winPID
1315     // 52-77 - rID
1316     // struct EventReturns {
1317     //     uint256 compressedData;
1318     //     uint256 compressedIDs;
1319     //     address winnerAddr;         // winner address
1320     //     bytes32 winnerName;         // winner name
1321     //     uint256 amountWonCosd;          // amount won
1322     //     uint256 amountWonCosc;          // amount won
1323     // }
1324     struct Player {
1325         address addr;   // player address
1326         bytes32 name;   // player name
1327         uint256 laff;   // last affiliate id used
1328         uint256 eth;
1329         uint256 cosd;    // winnings vault
1330         uint256 cosc;    // winnings vault
1331         // uint256 lrnd;   // last round played
1332         // uint256 rounds; //超过xxxcosd的轮数累计
1333         // uint256 redtProp; //买道具赠送的累计亏损减少率
1334         // uint256 redt1;
1335         // uint256 redt3;
1336         uint256 hldVltCosd;
1337         uint256 affCosd;
1338         uint256 affCosc;
1339         uint256 totalHldVltCosd;
1340         uint256 totalAffCos;
1341         uint256 totalWinCos;
1342     }
1343     // struct PlayerRounds {
1344     //     uint256 cosd;   // keys
1345     //     uint256 cosc;   // keys
1346     //     bool hadProp;
1347     //     uint256 propID;
1348     //     uint256 redtPRProp; //lossReductionRate，玩家当前回合道具总亏损减少率
1349     //     uint256 incrPRProp; //Income increase rate收入增加率
1350     //     uint256 team;
1351     //     // bool first;
1352     //     uint256 firstCosd;//第一阶段投入的COS资金，可减少20% 亏损率
1353     //     uint256 firstCosc;//第一阶段投入的COS资金，可减少20% 亏损率
1354     //     uint256 redtPRFirst;
1355     //     uint256 wonCosd;
1356     //     uint256 wonCosc;
1357     //     uint256 wonCosdRcd;
1358     //     uint256 wonCoscRcd;
1359     // }
1360     // struct Round {
1361     //     uint256 plyr;   // pID of player in lead
1362     //     uint256 team;   // tID of team in lead
1363     //     uint256 end;    // time ends/ended
1364     //     bool ended;     // has round end function been ran
1365     //     uint256 strt;   // time round started
1366     //     uint256 cosd;   // keys
1367     //     uint256 cosc;   // keys
1368     //     uint256 winTeam;
1369     // }     
1370     // struct Team {
1371     //     uint256 teamID;        
1372     //     uint256 winRate;    // 胜率
1373     //     uint256 eth;
1374     //     uint256 cosd;
1375     //     uint256 cosc;
1376     // }
1377     // struct Prop {           //道具
1378     //     uint256 propID;         
1379     //     uint256 price;
1380     //     uint256 oID;
1381     // }
1382     // struct Leader {           //道具       
1383     //     uint256 price;
1384     //     uint256 oID;
1385     // }
1386     // struct Fee {
1387     //     uint256 aff;          // % of buy in thats paid to referrer  of current round推荐人分配比例
1388     //     uint256 com;    // % of buy in thats paid for comnunity
1389     //     uint256 holders; //key holders
1390     // }
1391 }
1392 
1393 library F3DKeysCalcLong {
1394     using SafeMath for *;
1395 
1396     function random() internal pure returns (uint256) {
1397        uint ranNum = uint(keccak256(msg.data)) % 100;
1398        return ranNum;
1399    }
1400 }