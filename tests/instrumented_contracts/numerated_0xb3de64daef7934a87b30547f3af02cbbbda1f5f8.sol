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
507     // ---------
508     // Dont accept ETH;
509     // ---------
510     function () public payable { 
511         revert();
512     }
513 
514     function buyXaddr(address _pAddr, address _affCode, uint256 _eth, string _keyType)//sent
515     // isActivated()
516     // isHuman()
517     onlyOwner()
518     // isWithinLimits(msg.value)
519     public
520     // payable
521     // returns(uint256)
522     {
523         // set up our tx event data and determine if player is new or not
524         // F3Ddatasets.EventReturns memory _eventData_;
525         // _eventData_ = determinePID(_eventData_);
526         determinePID(_pAddr);
527 
528         // fetch player id
529         uint256 _pID = pIDxAddr_[_pAddr];
530 
531         // manage affiliate residuals
532         uint256 _affID;
533         // if no affiliate code was given or player tried to use their own, lolz
534         if (_affCode == address(0) || _affCode == _pAddr)
535         {
536             // use last stored affiliate code
537             _affID = plyr_[_pID].laff;
538 
539             // if affiliate code was given
540         } else {
541             // get affiliate ID from aff Code
542             _affID = pIDxAddr_[_affCode];
543 
544             // if affID is not the same as previously stored
545             if (_affID != plyr_[_pID].laff)
546             {
547                 // update last affiliate
548                 plyr_[_pID].laff = _affID;
549             }
550         }
551 
552         // verify a valid team was selected
553         // _team = verifyTeam(_team);
554 
555         // buy core
556         buyCore(_pID, _affID, _eth, _keyType);
557     }
558 
559     function registerNameXaddr(string   memory  _nameString, address _affCode, bool _all)//sent,user
560     // isHuman()
561     // onlyOwner()
562     public
563     payable
564     {
565         bytes32 _name = _nameString.nameFilter();
566         address _addr = msg.sender;
567         uint256 _paid = msg.value;
568         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
569 
570         if(_isNewPlayer) plyNum_++;
571 
572         uint256 _pID = pIDxAddr_[_addr];
573 
574         // fire event
575         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
576     }
577 
578     function ttlSply()
579     public
580     view
581     returns(uint256, uint256, uint256, uint256)
582     {
583         return (cosdNum_, coscNum_, totalVolume_, totalVltCosd_);
584     }
585    
586     function getBuyPrice()
587     public
588     view
589     returns(uint256)
590     {
591         return price_;
592     }
593   
594     function getPlayerInfoByAddress(address _addr)
595     public
596     view
597     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
598     {
599         // setup local rID
600         // uint256 _rID = rID_;
601         // address _addr = _addr_;
602 
603         // if (_addr == address(0))
604         // {
605         //     _addr == msg.sender;
606         // }
607         uint256 _pID = pIDxAddr_[_addr];
608 
609         return
610         (
611             _pID,
612             plyr_[_pID].name,
613             plyr_[_pID].laff,    
614             plyr_[_pID].eth,
615             plyr_[_pID].cosd,       
616             plyr_[_pID].cosc,
617             plyr_[_pID].hldVltCosd,
618             plyr_[_pID].affCosd,
619             plyr_[_pID].affCosc,
620             plyr_[_pID].totalHldVltCosd,
621             plyr_[_pID].totalAffCos,
622             plyr_[_pID].totalWinCos
623         );
624     }
625 
626    
627     function buyCore(uint256 _pID, uint256 _affID, uint256 _eth, string _keyType)
628     private
629     // returns(uint256)
630     {
631         uint256 _keys;
632         // if eth left is greater than min eth allowed (sorry no pocket lint)
633         if (_eth >= 0)
634         {
635             require(_eth >= getBuyPrice());
636             // mint the new keys
637             _keys = keysRec(_eth);
638             // pay 2% out to community rewards
639             uint256 _aff;
640             uint256 _com;
641             uint256 _holders;
642             uint256 _self;
643 
644             // if (isCosd(_keyType) == true) {
645             //     _aff        = _keys.mul(fees_[0].aff)/100;
646             //     _com        = _keys.mul(fees_[0].com)/100;
647             //     _holders    = _keys.mul(fees_[0].holders)/100;
648             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
649             // }else{
650             //     _aff        = _keys.mul(fees_[2].aff)/100;
651             //     _com        = _keys.mul(fees_[2].com)/100;
652             //     _holders    = _keys.mul(fees_[2].holders)/100;
653             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
654             // }
655 
656             // // if they bought at least 1 whole key
657             // if (_keys >= 1)
658             // {
659             //     // set new leaders
660             //     if (round_[_rID].plyr != _pID)
661             //         round_[_rID].plyr = _pID;
662             //     if (round_[_rID].team != _team)
663             //         round_[_rID].team = _team;
664             // }
665             // update player
666             if(isCosd(_keyType) == true){
667                 
668                 _aff        = _keys * 5/100;
669                 _com        = _keys * 2/100;
670                 _holders    = _keys * 3/100;
671                 _self       = _keys.sub(_aff).sub(_com).sub(_holders);
672 
673                 uint256 _hldCosd;
674                 for (uint256 i = 1; i <= plyNum_; i++) {
675                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
676                 }
677 
678                 //Player
679                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
680                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
681                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
682                 
683                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
684 
685                 for (uint256 j = 1; j <= plyNum_; j++) {
686                     if(plyr_[j].cosd>0) {
687                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
688                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
689                         
690                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
691                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
692                         emit F3Devents.onRecHldVltCosd
693                         (
694                             plyr_[j].addr,
695                             plyr_[j].name,
696                             plyr_[j].hldVltCosd
697                         );
698                     }
699                 }
700                 //team
701                 // rndTmEth_[_rID][_team].cosd = _self.add(rndTmEth_[_rID][_team].cosd);
702                 cosdNum_ = cosdNum_.add(_keys);
703                 totalVolume_ = totalVolume_.add(_keys);
704             }
705             else{//cosc
706                 _aff        = _keys *4/100;
707                 _com        = _keys *1/100;
708                 // _holders    = _keys.mul(fees_[2].holders)/100;
709                 _self       = _keys.sub(_aff).sub(_com);
710                 //Player
711                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_self);
712                 plyr_[pIDCom_].cosc = plyr_[pIDCom_].cosc.add(_com);
713                 plyr_[_affID].affCosc = plyr_[_affID].affCosc.add(_aff);
714                 
715                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
716                 // rndTmEth_[_rID][_team].cosc = _self.add(rndTmEth_[_rID][_team].cosc);
717                 coscNum_ = coscNum_.add(_keys);
718                 totalVolume_ = totalVolume_.add(_keys);
719             }
720 
721             // keyNum_ = keyNum_.add(_keys);//update
722         }
723 
724         // return _keys;
725     }  
726 
727    
728     function sellKeys(uint256 _pID, uint256 _keys, string _keyType)//send
729     // isActivated()
730     // isHuman()
731     onlyOwner()
732     // isWithinLimits(msg.value)
733     public
734     // payable
735     returns(uint256)
736     {
737         // uint256 _pID = _pID_;
738         // uint256 _keys = _keys_;
739         require(_keys>0);
740         uint256 _eth;
741 
742         // uint256 _aff;
743         // uint256 _com;
744         uint256 _holders;
745         uint256 _self;
746         // if (isCosd(_keyType) == true) {
747         //         // _aff        = _keys.mul(fees_[1].aff)/100;
748         //         // _com        = _keys.mul(fees_[1].com)/100;
749         //         _holders    = _keys.mul(fees_[1].holders)/100;
750         //         // _self       = _keys.sub(_aff).sub(_com);
751         //         _self       = _self.sub(_holders);
752         // }else{
753         //         // _aff        = _keys.mul(fees_[3].aff)/100;
754         //         // _com        = _keys.mul(fees_[3].com)/100;
755         //         _holders    = _keys.mul(fees_[3].holders)/100;
756         //         // _self       = _keys.sub(_aff).sub(_com);
757         //         _self       = _self.sub(_holders);
758         // }
759         //split
760        if(isCosd(_keyType) == true){
761                 require(plyr_[_pID].cosd >= _keys,"Do not have cosd!");
762                 
763                 // _aff        = _keys.mul(fees_[1].aff)/100;
764                 // _com        = _keys.mul(fees_[1].com)/100;
765                 _holders    = _keys * 20/100;
766                 // _self       = _keys.sub(_aff).sub(_com);
767                 _self       = _keys.sub(_holders);
768 
769                 uint256 _hldCosd;
770                 for (uint256 i = 1; i <= plyNum_; i++) {
771                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
772                 }
773 
774                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
775 
776                 _eth = ethRec(_self);
777                 plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
778 
779                 for (uint256 j = 1; j <= plyNum_; j++) {
780                     if( plyr_[j].cosd>0) {                    
781                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
782                         
783                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
784                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
785                         emit F3Devents.onRecHldVltCosd
786                         (
787                             plyr_[j].addr,
788                             plyr_[j].name,
789                             plyr_[j].hldVltCosd
790                         );
791                     }
792                 }
793                 cosdNum_ = cosdNum_.sub(_self);
794                 totalVolume_ = totalVolume_.add(_keys);
795        }
796        else{
797             require(plyr_[_pID].cosc >= _keys,"Do not have cosc!");           
798 
799             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
800 
801             _eth = ethRec(_keys);
802             plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
803             
804             coscNum_ = coscNum_.sub(_keys);
805             totalVolume_ = totalVolume_.add(_keys);
806        }
807 
808     //   keyNum_ = keyNum_.sub(_keys);//update
809        // _eth = _keys.ethRec(getBuyPrice());
810 
811        return _eth;
812     }
813 
814     function addCosToGame(uint256 _pID, uint256 _keys, string _keyType)//sent
815     onlyOwner()
816     public
817     // returns(bool)
818     {
819             // uint256 _rID = rID_;
820             // uint256 _now = now;
821 
822             uint256 _aff;
823             uint256 _com;
824             uint256 _holders;
825             // uint256 _self;
826             uint256 _affID = plyr_[_pID].laff;
827 
828             // update player
829             if(isCosd(_keyType) == true){         //扣除9%
830 
831                 require(plyr_[_pID].cosd >= _keys);
832 
833                 _aff        = _keys *1/100;
834                 _com        = _keys *3/100;
835                 _holders    = _keys *5/100;
836                 // _self       = _keys.sub(_aff).sub(_com).sub(_holders);
837                 //Player
838                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
839 
840                 uint256 _hldCosd;
841                 for (uint256 i = 1; i <= plyNum_; i++) {
842                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
843                 }
844 
845                 //Player
846                 // plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
847                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
848                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
849             
850                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
851 
852                 for (uint256 j = 1; j <= plyNum_; j++) {
853                     if(plyr_[j].cosd>0) {
854                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
855                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
856                         
857                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
858                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
859                         emit F3Devents.onRecHldVltCosd
860                         (
861                             plyr_[j].addr,
862                             plyr_[j].name,
863                             plyr_[j].hldVltCosd
864                         );
865                     }
866                 }
867             }
868             else{//cosc
869                 require(plyr_[_pID].cosc >= _keys);
870                 //Player
871                 plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
872             }
873         
874             // return true;
875     }
876 
877     function winCosFromGame(uint256 _pID, uint256 _keys, string _keyType)//sent
878     onlyOwner()
879     public
880     // returns(bool)
881     {
882             // uint256 _rID = rID_;
883             // uint256 _now = now;
884 
885             // update player
886             if(isCosd(_keyType) == true){
887                 // require(plyr_[_pID].cosd >= _keys);
888                 //Player
889                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_keys);
890             }
891             else{//cosc
892                 // require(plyr_[_pID].cosc >= _keys);
893                 //Player
894                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_keys);
895             }
896             
897             plyr_[_pID].totalWinCos = plyr_[_pID].totalWinCos.add(_keys);
898         
899             // return true;
900     }    
901    
902     function iWantXKeys(uint256 _keys)
903     public
904     view
905     returns(uint256)
906     {
907         return eth(_keys);
908     }
909     
910     function howManyKeysCanBuy(uint256 _eth)
911     public
912     view
913     returns(uint256)
914     {
915         return keys(_eth);
916     }
917     //==============================================================================
918     //    _|_ _  _ | _  .
919     //     | (_)(_)|_\  .
920     // //==============================================================================
921     // 
922     //  @dev receives name/player info from names contract
923     //  
924     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
925     external
926     {
927         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
928         if (pIDxAddr_[_addr] != _pID)
929             pIDxAddr_[_addr] = _pID;
930         if (pIDxName_[_name] != _pID)
931             pIDxName_[_name] = _pID;
932         if (plyr_[_pID].addr != _addr)
933             plyr_[_pID].addr = _addr;
934         if (plyr_[_pID].name != _name)
935             plyr_[_pID].name = _name;
936         if (plyr_[_pID].laff != _laff)
937             plyr_[_pID].laff = _laff;
938         if (plyrNames_[_pID][_name] == false)
939             plyrNames_[_pID][_name] = true;
940     }
941 
942     //  **
943     //  * @dev receives entire player name list
944     //  *
945     function receivePlayerNameList(uint256 _pID, bytes32 _name)
946     external
947     {
948         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
949         if(plyrNames_[_pID][_name] == false)
950             plyrNames_[_pID][_name] = true;
951     }
952 
953     // **
954     //  * @dev gets existing or registers new pID.  use this when a player may be new
955     //  * @return pID
956     //  *
957     function determinePID(address _pAddr)
958     private
959     {
960         uint256 _pID = pIDxAddr_[_pAddr];
961         // if player is new to this version of fomo3d
962         if (_pID == 0)
963         {
964             // grab their player ID, name and last aff ID, from player names contract
965             _pID = PlayerBook.getPlayerID(_pAddr);
966             bytes32 _name = PlayerBook.getPlayerName(_pID);
967             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
968 
969             // set up player account
970             pIDxAddr_[_pAddr] = _pID;
971             plyr_[_pID].addr = _pAddr;
972 
973             if (_name != "")
974             {
975                 pIDxName_[_name] = _pID;
976                 plyr_[_pID].name = _name;
977                 plyrNames_[_pID][_name] = true;
978             }
979 
980             if (_laff != 0 && _laff != _pID)
981                 plyr_[_pID].laff = _laff;
982 
983             // set the new player bool to true
984             // _eventData_.compressedData = _eventData_.compressedData + 1;
985             // plyNum_++;
986         }
987         // return (_eventData_);
988     }
989     
990     function withdrawETH(uint256 _pID)//send
991     // isHuman()
992     onlyOwner()
993     public
994     returns(bool)
995     {
996         if (plyr_[_pID].eth>0) {
997             plyr_[_pID].eth = 0;
998         }
999         return true;
1000     }
1001 
1002     function withdrawHoldVault(uint256 _pID)//send
1003     // isHuman()
1004     onlyOwner()
1005     public
1006     returns(bool)
1007     {
1008         if (plyr_[_pID].hldVltCosd>0) {
1009             plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].hldVltCosd);
1010             
1011             plyr_[_pID].totalHldVltCosd = plyr_[_pID].totalHldVltCosd.add(plyr_[_pID].hldVltCosd);
1012             totalVltCosd_ = totalVltCosd_.add(plyr_[_pID].hldVltCosd);
1013                         
1014             plyr_[_pID].hldVltCosd = 0;
1015         }
1016 
1017         emit F3Devents.onWithdrawHoldVault
1018                     (
1019                         _pID,
1020                         plyr_[_pID].addr,
1021                         plyr_[_pID].name,
1022                         plyr_[_pID].cosd,
1023                         plyr_[_pID].hldVltCosd
1024                     );
1025 
1026         return true;
1027     }
1028 
1029     function withdrawAffVault(uint256 _pID, string _keyType)//send
1030     // isHuman()
1031     onlyOwner()
1032     public
1033     returns(bool)
1034     {
1035 
1036         if(isCosd(_keyType) == true){
1037 
1038             if (plyr_[_pID].affCosd>0) {
1039                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].affCosd);
1040                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosd);
1041                 plyr_[_pID].affCosd = 0;
1042             }
1043         }
1044         else{
1045             if (plyr_[_pID].affCosc>0) {
1046                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(plyr_[_pID].affCosc);
1047                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosc);
1048                 plyr_[_pID].affCosc = 0;
1049             }
1050         }
1051 
1052         emit F3Devents.onWithdrawAffVault
1053         (
1054                         _pID,
1055                         plyr_[_pID].addr,
1056                         plyr_[_pID].name,
1057                         plyr_[_pID].cosd,
1058                         plyr_[_pID].cosc,
1059                         plyr_[_pID].affCosd,
1060                         plyr_[_pID].affCosc
1061         );
1062 
1063         return true;
1064     }
1065 
1066     function transferToAnotherAddr(address _from, address _to, uint256 _keys, string _keyType) //sent
1067     // isHuman()
1068     onlyOwner()
1069     public
1070     // returns(bool)
1071     {
1072         // uint256 _rID = rID_;
1073         // uint256 _holders;
1074         // uint256 _self;
1075         // uint256 i;
1076 
1077         // determinePID();
1078         // fetch player id
1079         uint256 _pID = pIDxAddr_[_from];
1080         uint256 _tID = pIDxAddr_[_to];
1081 
1082         require(_tID > 0);
1083     
1084         if (isCosd(_keyType) == true) {
1085 
1086                 require(plyr_[_pID].cosd >= _keys);
1087 
1088                 // uint256 _hldCosd;
1089                 // for ( i = 1; i <= plyNum_; i++) {
1090                 //     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
1091                 // }
1092 
1093                 // _holders = _keys * 20/100;
1094                 // // _aff =     plyrRnds_[_pID][_rID].wonCosd * 1/100;
1095                 // _self = _keys.sub(_holders);
1096 
1097                 plyr_[_tID].cosd = plyr_[_tID].cosd.add(_keys);
1098                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
1099 
1100                 // for ( i = 1; i <= plyNum_; i++) {
1101                 //     if(plyr_[i].cosd>0) plyr_[i].hldVltCosd = plyr_[i].hldVltCosd.add(_holders.mul(plyr_[i].cosd).div(_hldCosd));
1102                 // }
1103         }
1104 
1105         else{
1106             require(plyr_[_pID].cosc >= _keys);
1107 
1108             plyr_[_tID].cosc = plyr_[_tID].cosc.add(_keys);
1109             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
1110         }
1111 
1112         // emit F3Devents.onWithdrawWonCosFromGame
1113         //             (
1114         //                 _pID,
1115         //                 msg.sender,
1116         //                 plyr_[i].name,
1117         //                 plyr_[_pID].cosd,
1118         //                 plyr_[_pID].cosc,
1119         //                 plyr_[_pID].affVltCosd
1120         //             );
1121 
1122         // return true;
1123     }
1124     
1125     function isCosd(string _keyType)
1126     public
1127     pure
1128     returns(bool)
1129     {
1130         if( bytes(_keyType).length == 8 )
1131         {
1132             return true;
1133         }
1134         else 
1135         {
1136             return false;
1137         }
1138     }
1139     
1140     // function setResult(string _keyType) //send
1141     // public
1142     // // pure
1143     // returns(string)
1144     // {
1145     //     result_ = bytes(_keyType).length;
1146         
1147     //     return (_keyType);
1148     // }
1149     
1150     // function getResult(string _keyType)
1151     // public
1152     // pure
1153     // returns(uint256)
1154     // {
1155     //     // return bytes(_keyType).length;
1156     //     if( bytes(_keyType).length == 8 )
1157     //     {
1158     //         return 100;
1159     //     }
1160     //     else 
1161     //     {
1162     //         return 50;
1163     //     }
1164     // }
1165     
1166     function keysRec(uint256 _eth)
1167     internal
1168     returns (uint256)
1169     {
1170         // require(_price >= 10**16);
1171         
1172         uint256 _rstAmount = 0;
1173         uint256 _price = price_;
1174         // uint256 _keyNum = cosdNum_.add(coscNum_);
1175         // require(_eth >= msg.value);
1176 
1177         while(_eth >= _price){
1178             _eth = _eth - _price;
1179             _price = _price + 5 *10**11;
1180             
1181             if(_price >= 2 *10**17){ 
1182                 _price = 2 *10**17;
1183                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1184             }
1185             
1186             _rstAmount++;
1187         }
1188         
1189         price_ = _price;
1190 
1191         return _rstAmount;
1192     }
1193 
1194     function ethRec(uint256 _keys)
1195     internal
1196     returns (uint256)
1197     {
1198         // require(_price >= 10**16);
1199         
1200         uint256 _eth = 0;
1201         uint256 _price = price_;
1202         uint256 _keyNum = cosdNum_.add(coscNum_);
1203         // require(_eth >= msg.value);
1204 
1205         for(uint256 i=0;i < _keys;i++){
1206             if(_price < 10**16) _price = 10**16;
1207             
1208             _eth = _eth + _price;
1209             _price = _price - 5 *10**11;
1210             
1211             if(_price < 10**16) _price = 10**16;
1212             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1213         }
1214         
1215         price_ = _price;
1216 
1217         return _eth;
1218     }
1219 
1220     function keys(uint256 _eth)
1221     internal
1222     view
1223     returns(uint256)
1224     {
1225          // require(_price >= 10**16);
1226         
1227         uint256 _rstAmount = 0;
1228         uint256 _price = price_;
1229         // uint256 _keyNum = cosdNum_.add(coscNum_);
1230         // require(_eth >= _price);
1231 
1232         while(_eth >= _price){
1233             _eth = _eth - _price;
1234             _price = _price + 5 *10**11;
1235             
1236             if(_price >= 2 *10**17){ 
1237                 _price = 2 *10**17;
1238                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1239             }
1240             
1241             _rstAmount++;
1242         }
1243         
1244         // price_ = _price;
1245 
1246         return _rstAmount;
1247     }
1248 
1249     function eth(uint256 _keys)
1250     internal
1251     view
1252     returns(uint256)
1253     {
1254         // require(_price >= 10**16);
1255         
1256         uint256 _eth = 0;
1257         uint256 _price = price_;
1258         uint256 _keyNum = cosdNum_.add(coscNum_);
1259         // require(_eth >= msg.value);
1260 
1261         for(uint256 i=0;i < _keys;i++){
1262             if(_price < 10**16) _price = 10**16;
1263             
1264             _eth = _eth + _price;
1265             _price = _price - 5 *10**11;
1266             
1267             if(_price < 10**16) _price = 10**16;
1268             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1269         }
1270         
1271         // price_ = _price;
1272 
1273         return _eth;
1274     }
1275     
1276     //==============================================================================
1277     //    (~ _  _    _._|_    .
1278     //    _)(/_(_|_|| | | \/  .
1279     //====================/=========================================================
1280     // ** upon contract deploy, it will be deactivated.  this is a one time
1281     //  * use function that will activate the contract.  we do this so devs
1282     //  * have time to set things up on the web end                            **
1283     // bool public activated_ = false;
1284     // function activate()
1285     // public 
1286     // onlyOwner {
1287     //     // make sure that its been linked.
1288     //     //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1289 
1290     //     // can only be ran once
1291     //     require(activated_ == false, "fomo3d already activated");
1292 
1293     //     // activate the contract
1294     //     activated_ = true;
1295 
1296     //     // lets start first round
1297     //     // rID_ = 1;
1298     //     // round_[1].strt = now;
1299     //     // round_[1].end  = now.add(rndInit_);
1300     // }
1301 }
1302 
1303 library F3Ddatasets {
1304     //compressedData key
1305     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1306     // 0 - new player (bool)
1307     // 1 - joined round (bool)
1308     // 2 - new  leader (bool)
1309     // 3-5 - air drop tracker (uint 0-999)
1310     // 6-16 - round end time
1311     // 17 - winnerTeam
1312     // 18 - 28 timestamp
1313     // 29 - team
1314     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1315     // 31 - airdrop happened bool
1316     // 32 - airdrop tier
1317     // 33 - airdrop amount won
1318     //compressedIDs key
1319     // [77-52][51-26][25-0]
1320     // 0-25 - pID
1321     // 26-51 - winPID
1322     // 52-77 - rID
1323     // struct EventReturns {
1324     //     uint256 compressedData;
1325     //     uint256 compressedIDs;
1326     //     address winnerAddr;         // winner address
1327     //     bytes32 winnerName;         // winner name
1328     //     uint256 amountWonCosd;          // amount won
1329     //     uint256 amountWonCosc;          // amount won
1330     // }
1331     struct Player {
1332         address addr;   // player address
1333         bytes32 name;   // player name
1334         uint256 laff;   // last affiliate id used
1335         uint256 eth;
1336         uint256 cosd;    // winnings vault
1337         uint256 cosc;    // winnings vault
1338         // uint256 lrnd;   // last round played
1339         // uint256 rounds; //超过xxxcosd的轮数累计
1340         // uint256 redtProp; //买道具赠送的累计亏损减少率
1341         // uint256 redt1;
1342         // uint256 redt3;
1343         uint256 hldVltCosd;
1344         uint256 affCosd;
1345         uint256 affCosc;
1346         uint256 totalHldVltCosd;
1347         uint256 totalAffCos;
1348         uint256 totalWinCos;
1349     }
1350     // struct PlayerRounds {
1351     //     uint256 cosd;   // keys
1352     //     uint256 cosc;   // keys
1353     //     bool hadProp;
1354     //     uint256 propID;
1355     //     uint256 redtPRProp; //lossReductionRate，玩家当前回合道具总亏损减少率
1356     //     uint256 incrPRProp; //Income increase rate收入增加率
1357     //     uint256 team;
1358     //     // bool first;
1359     //     uint256 firstCosd;//第一阶段投入的COS资金，可减少20% 亏损率
1360     //     uint256 firstCosc;//第一阶段投入的COS资金，可减少20% 亏损率
1361     //     uint256 redtPRFirst;
1362     //     uint256 wonCosd;
1363     //     uint256 wonCosc;
1364     //     uint256 wonCosdRcd;
1365     //     uint256 wonCoscRcd;
1366     // }
1367     // struct Round {
1368     //     uint256 plyr;   // pID of player in lead
1369     //     uint256 team;   // tID of team in lead
1370     //     uint256 end;    // time ends/ended
1371     //     bool ended;     // has round end function been ran
1372     //     uint256 strt;   // time round started
1373     //     uint256 cosd;   // keys
1374     //     uint256 cosc;   // keys
1375     //     uint256 winTeam;
1376     // }     
1377     // struct Team {
1378     //     uint256 teamID;        
1379     //     uint256 winRate;    // 胜率
1380     //     uint256 eth;
1381     //     uint256 cosd;
1382     //     uint256 cosc;
1383     // }
1384     // struct Prop {           //道具
1385     //     uint256 propID;         
1386     //     uint256 price;
1387     //     uint256 oID;
1388     // }
1389     // struct Leader {           //道具       
1390     //     uint256 price;
1391     //     uint256 oID;
1392     // }
1393     // struct Fee {
1394     //     uint256 aff;          // % of buy in thats paid to referrer  of current round推荐人分配比例
1395     //     uint256 com;    // % of buy in thats paid for comnunity
1396     //     uint256 holders; //key holders
1397     // }
1398 }
1399 
1400 library F3DKeysCalcLong {
1401     using SafeMath for *;
1402 
1403     function random() internal pure returns (uint256) {
1404        uint ranNum = uint(keccak256(msg.data)) % 100;
1405        return ranNum;
1406    }
1407 }