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
507     function()
508     // isHuman()
509     public
510     // payable
511     {
512         // return false;
513     }
514 
515     function buyXaddr(address _pAddr, address _affCode, uint256 _eth, string _keyType)//sent
516     // isActivated()
517     // isHuman()
518     onlyOwner()
519     // isWithinLimits(msg.value)
520     public
521     // payable
522     // returns(uint256)
523     {
524         // set up our tx event data and determine if player is new or not
525         // F3Ddatasets.EventReturns memory _eventData_;
526         // _eventData_ = determinePID(_eventData_);
527         determinePID(_pAddr);
528 
529         // fetch player id
530         uint256 _pID = pIDxAddr_[_pAddr];
531 
532         // manage affiliate residuals
533         uint256 _affID;
534         // if no affiliate code was given or player tried to use their own, lolz
535         if (_affCode == address(0) || _affCode == _pAddr)
536         {
537             // use last stored affiliate code
538             _affID = plyr_[_pID].laff;
539 
540             // if affiliate code was given
541         } else {
542             // get affiliate ID from aff Code
543             _affID = pIDxAddr_[_affCode];
544 
545             // if affID is not the same as previously stored
546             if (_affID != plyr_[_pID].laff)
547             {
548                 // update last affiliate
549                 plyr_[_pID].laff = _affID;
550             }
551         }
552 
553         // verify a valid team was selected
554         // _team = verifyTeam(_team);
555 
556         // buy core
557         buyCore(_pID, _affID, _eth, _keyType);
558     }
559 
560     function registerNameXaddr(string   memory  _nameString, address _affCode, bool _all)//sent,user
561     // isHuman()
562     // onlyOwner()
563     public
564     payable
565     {
566         bytes32 _name = _nameString.nameFilter();
567         address _addr = msg.sender;
568         uint256 _paid = msg.value;
569         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
570 
571         if(_isNewPlayer) plyNum_++;
572 
573         uint256 _pID = pIDxAddr_[_addr];
574 
575         // fire event
576         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
577     }
578 
579     function totalSupply()
580     public
581     view
582     returns(uint256,uint256,uint256,uint256)
583     {
584         return (cosdNum_, coscNum_, totalVolume_, totalVltCosd_);
585     }
586    
587     function getBuyPrice()
588     public
589     view
590     returns(uint256)
591     {
592         return price_;
593     }
594   
595     function getPlayerInfoByAddress(address _addr)
596     public
597     view
598     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
599     {
600         // setup local rID
601         // uint256 _rID = rID_;
602         // address _addr = _addr_;
603 
604         // if (_addr == address(0))
605         // {
606         //     _addr == msg.sender;
607         // }
608         uint256 _pID = pIDxAddr_[_addr];
609 
610         return
611         (
612             _pID,
613             plyr_[_pID].name,
614             plyr_[_pID].laff,    
615             plyr_[_pID].eth,
616             plyr_[_pID].cosd,       
617             plyr_[_pID].cosc,
618             plyr_[_pID].hldVltCosd,
619             plyr_[_pID].affCosd,
620             plyr_[_pID].affCosc,
621             plyr_[_pID].totalHldVltCosd,
622             plyr_[_pID].totalAffCos,
623             plyr_[_pID].totalWinCos
624         );
625     }
626 
627    
628     function buyCore(uint256 _pID, uint256 _affID, uint256 _eth, string _keyType)
629     private
630     // returns(uint256)
631     {
632         uint256 _keys;
633         // if eth left is greater than min eth allowed (sorry no pocket lint)
634         if (_eth >= 0)
635         {
636             require(_eth >= getBuyPrice());
637             // mint the new keys
638             _keys = keysRec(_eth);
639             // pay 2% out to community rewards
640             uint256 _aff;
641             uint256 _com;
642             uint256 _holders;
643             uint256 _self;
644 
645             // if (isCosd(_keyType) == true) {
646             //     _aff        = _keys.mul(fees_[0].aff)/100;
647             //     _com        = _keys.mul(fees_[0].com)/100;
648             //     _holders    = _keys.mul(fees_[0].holders)/100;
649             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
650             // }else{
651             //     _aff        = _keys.mul(fees_[2].aff)/100;
652             //     _com        = _keys.mul(fees_[2].com)/100;
653             //     _holders    = _keys.mul(fees_[2].holders)/100;
654             //     _self       = _keys.sub(_aff).sub(_com).sub(_holders);
655             // }
656 
657             // // if they bought at least 1 whole key
658             // if (_keys >= 1)
659             // {
660             //     // set new leaders
661             //     if (round_[_rID].plyr != _pID)
662             //         round_[_rID].plyr = _pID;
663             //     if (round_[_rID].team != _team)
664             //         round_[_rID].team = _team;
665             // }
666             // update player
667             if(isCosd(_keyType) == true){
668                 
669                 _aff        = _keys * 5/100;
670                 _com        = _keys * 2/100;
671                 _holders    = _keys * 3/100;
672                 _self       = _keys.sub(_aff).sub(_com).sub(_holders);
673 
674                 uint256 _hldCosd;
675                 for (uint256 i = 1; i <= plyNum_; i++) {
676                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
677                 }
678 
679                 //Player
680                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
681                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
682                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
683                 
684                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
685 
686                 for (uint256 j = 1; j <= plyNum_; j++) {
687                     if(plyr_[j].cosd>0) {
688                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
689                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
690                         
691                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
692                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
693                         emit F3Devents.onRecHldVltCosd
694                         (
695                             plyr_[j].addr,
696                             plyr_[j].name,
697                             plyr_[j].hldVltCosd
698                         );
699                     }
700                 }
701                 //team
702                 // rndTmEth_[_rID][_team].cosd = _self.add(rndTmEth_[_rID][_team].cosd);
703                 cosdNum_ = cosdNum_.add(_keys);
704                 totalVolume_ = totalVolume_.add(_keys);
705             }
706             else{//cosc
707                 _aff        = _keys *4/100;
708                 _com        = _keys *1/100;
709                 // _holders    = _keys.mul(fees_[2].holders)/100;
710                 _self       = _keys.sub(_aff).sub(_com);
711                 //Player
712                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_self);
713                 plyr_[pIDCom_].cosc = plyr_[pIDCom_].cosc.add(_com);
714                 plyr_[_affID].affCosc = plyr_[_affID].affCosc.add(_aff);
715                 
716                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
717                 // rndTmEth_[_rID][_team].cosc = _self.add(rndTmEth_[_rID][_team].cosc);
718                 coscNum_ = coscNum_.add(_keys);
719                 totalVolume_ = totalVolume_.add(_keys);
720             }
721 
722             // keyNum_ = keyNum_.add(_keys);//update
723         }
724 
725         // return _keys;
726     }  
727 
728    
729     function sellKeys(uint256 _pID, uint256 _keys, string _keyType)//send
730     // isActivated()
731     // isHuman()
732     onlyOwner()
733     // isWithinLimits(msg.value)
734     public
735     // payable
736     returns(uint256)
737     {
738         // uint256 _pID = _pID_;
739         // uint256 _keys = _keys_;
740         require(_keys>0);
741         uint256 _eth;
742 
743         // uint256 _aff;
744         // uint256 _com;
745         uint256 _holders;
746         uint256 _self;
747         // if (isCosd(_keyType) == true) {
748         //         // _aff        = _keys.mul(fees_[1].aff)/100;
749         //         // _com        = _keys.mul(fees_[1].com)/100;
750         //         _holders    = _keys.mul(fees_[1].holders)/100;
751         //         // _self       = _keys.sub(_aff).sub(_com);
752         //         _self       = _self.sub(_holders);
753         // }else{
754         //         // _aff        = _keys.mul(fees_[3].aff)/100;
755         //         // _com        = _keys.mul(fees_[3].com)/100;
756         //         _holders    = _keys.mul(fees_[3].holders)/100;
757         //         // _self       = _keys.sub(_aff).sub(_com);
758         //         _self       = _self.sub(_holders);
759         // }
760         //split
761        if(isCosd(_keyType) == true){
762                 require(plyr_[_pID].cosd >= _keys,"Do not have cosd!");
763                 
764                 // _aff        = _keys.mul(fees_[1].aff)/100;
765                 // _com        = _keys.mul(fees_[1].com)/100;
766                 _holders    = _keys * 20/100;
767                 // _self       = _keys.sub(_aff).sub(_com);
768                 _self       = _keys.sub(_holders);
769 
770                 uint256 _hldCosd;
771                 for (uint256 i = 1; i <= plyNum_; i++) {
772                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
773                 }
774 
775                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
776 
777                 _eth = ethRec(_self);
778                 plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
779 
780                 for (uint256 j = 1; j <= plyNum_; j++) {
781                     if( plyr_[j].cosd>0) {                    
782                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
783                         
784                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
785                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
786                         emit F3Devents.onRecHldVltCosd
787                         (
788                             plyr_[j].addr,
789                             plyr_[j].name,
790                             plyr_[j].hldVltCosd
791                         );
792                     }
793                 }
794                 cosdNum_ = cosdNum_.sub(_self);
795                 totalVolume_ = totalVolume_.add(_keys);
796        }
797        else{
798             require(plyr_[_pID].cosc >= _keys,"Do not have cosc!");           
799 
800             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
801 
802             _eth = ethRec(_keys);
803             plyr_[_pID].eth = plyr_[_pID].eth.add(_eth);
804             
805             coscNum_ = coscNum_.sub(_keys);
806             totalVolume_ = totalVolume_.add(_keys);
807        }
808 
809     //   keyNum_ = keyNum_.sub(_keys);//update
810        // _eth = _keys.ethRec(getBuyPrice());
811 
812        return _eth;
813     }
814 
815     function addCosToGame(uint256 _pID, uint256 _keys, string _keyType)//sent
816     onlyOwner()
817     public
818     // returns(bool)
819     {
820             // uint256 _rID = rID_;
821             // uint256 _now = now;
822 
823             uint256 _aff;
824             uint256 _com;
825             uint256 _holders;
826             // uint256 _self;
827             uint256 _affID = plyr_[_pID].laff;
828 
829             // update player
830             if(isCosd(_keyType) == true){         //扣除9%
831 
832                 require(plyr_[_pID].cosd >= _keys);
833 
834                 _aff        = _keys *1/100;
835                 _com        = _keys *3/100;
836                 _holders    = _keys *5/100;
837                 // _self       = _keys.sub(_aff).sub(_com).sub(_holders);
838                 //Player
839                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
840 
841                 uint256 _hldCosd;
842                 for (uint256 i = 1; i <= plyNum_; i++) {
843                     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
844                 }
845 
846                 //Player
847                 // plyr_[_pID].cosd = plyr_[_pID].cosd.add(_self);
848                 plyr_[pIDCom_].cosd = plyr_[pIDCom_].cosd.add(_com);
849                 plyr_[_affID].affCosd = plyr_[_affID].affCosd.add(_aff);
850             
851                 // plyr_[_affID].totalAffCos = plyr_[_affID].totalAffCos.add(_aff);
852 
853                 for (uint256 j = 1; j <= plyNum_; j++) {
854                     if(plyr_[j].cosd>0) {
855                         // plyrRnds_[j][_rID].cosd = plyrRnds_[j][_rID].cosd.add(_holders.div(_otherHodles));
856                         plyr_[j].hldVltCosd = plyr_[j].hldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
857                         
858                         // plyr_[j].totalHldVltCosd = plyr_[j].totalHldVltCosd.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
859                         // totalVltCosd_ = totalVltCosd_.add(_holders.mul(plyr_[j].cosd).div(_hldCosd));
860                         emit F3Devents.onRecHldVltCosd
861                         (
862                             plyr_[j].addr,
863                             plyr_[j].name,
864                             plyr_[j].hldVltCosd
865                         );
866                     }
867                 }
868             }
869             else{//cosc
870                 require(plyr_[_pID].cosc >= _keys);
871                 //Player
872                 plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
873             }
874         
875             // return true;
876     }
877 
878     function winCosFromGame(uint256 _pID, uint256 _keys, string _keyType)//sent
879     onlyOwner()
880     public
881     // returns(bool)
882     {
883             // uint256 _rID = rID_;
884             // uint256 _now = now;
885 
886             // update player
887             if(isCosd(_keyType) == true){
888                 // require(plyr_[_pID].cosd >= _keys);
889                 //Player
890                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(_keys);
891             }
892             else{//cosc
893                 // require(plyr_[_pID].cosc >= _keys);
894                 //Player
895                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(_keys);
896             }
897             
898             plyr_[_pID].totalWinCos = plyr_[_pID].totalWinCos.add(_keys);
899         
900             // return true;
901     }    
902    
903     function iWantXKeys(uint256 _keys)
904     public
905     view
906     returns(uint256)
907     {
908         return eth(_keys);
909     }
910     
911     function howManyKeysCanBuy(uint256 _eth)
912     public
913     view
914     returns(uint256)
915     {
916         return keys(_eth);
917     }
918     //==============================================================================
919     //    _|_ _  _ | _  .
920     //     | (_)(_)|_\  .
921     // //==============================================================================
922     // 
923     //  @dev receives name/player info from names contract
924     //  
925     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
926     external
927     {
928         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
929         if (pIDxAddr_[_addr] != _pID)
930             pIDxAddr_[_addr] = _pID;
931         if (pIDxName_[_name] != _pID)
932             pIDxName_[_name] = _pID;
933         if (plyr_[_pID].addr != _addr)
934             plyr_[_pID].addr = _addr;
935         if (plyr_[_pID].name != _name)
936             plyr_[_pID].name = _name;
937         if (plyr_[_pID].laff != _laff)
938             plyr_[_pID].laff = _laff;
939         if (plyrNames_[_pID][_name] == false)
940             plyrNames_[_pID][_name] = true;
941     }
942 
943     //  **
944     //  * @dev receives entire player name list
945     //  *
946     function receivePlayerNameList(uint256 _pID, bytes32 _name)
947     external
948     {
949         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
950         if(plyrNames_[_pID][_name] == false)
951             plyrNames_[_pID][_name] = true;
952     }
953 
954     // **
955     //  * @dev gets existing or registers new pID.  use this when a player may be new
956     //  * @return pID
957     //  *
958     function determinePID(address _pAddr)
959     private
960     {
961         uint256 _pID = pIDxAddr_[_pAddr];
962         // if player is new to this version of fomo3d
963         if (_pID == 0)
964         {
965             // grab their player ID, name and last aff ID, from player names contract
966             _pID = PlayerBook.getPlayerID(_pAddr);
967             bytes32 _name = PlayerBook.getPlayerName(_pID);
968             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
969 
970             // set up player account
971             pIDxAddr_[_pAddr] = _pID;
972             plyr_[_pID].addr = _pAddr;
973 
974             if (_name != "")
975             {
976                 pIDxName_[_name] = _pID;
977                 plyr_[_pID].name = _name;
978                 plyrNames_[_pID][_name] = true;
979             }
980 
981             if (_laff != 0 && _laff != _pID)
982                 plyr_[_pID].laff = _laff;
983 
984             // set the new player bool to true
985             // _eventData_.compressedData = _eventData_.compressedData + 1;
986             // plyNum_++;
987         }
988         // return (_eventData_);
989     }
990     
991     function withdrawETH(uint256 _pID)//send
992     // isHuman()
993     onlyOwner()
994     public
995     returns(bool)
996     {
997         if (plyr_[_pID].eth>0) {
998             plyr_[_pID].eth = 0;
999         }
1000         return true;
1001     }
1002 
1003     function withdrawHoldVault(uint256 _pID)//send
1004     // isHuman()
1005     onlyOwner()
1006     public
1007     returns(bool)
1008     {
1009         if (plyr_[_pID].hldVltCosd>0) {
1010             plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].hldVltCosd);
1011             
1012             plyr_[_pID].totalHldVltCosd = plyr_[_pID].totalHldVltCosd.add(plyr_[_pID].hldVltCosd);
1013             totalVltCosd_ = totalVltCosd_.add(plyr_[_pID].hldVltCosd);
1014                         
1015             plyr_[_pID].hldVltCosd = 0;
1016         }
1017 
1018         emit F3Devents.onWithdrawHoldVault
1019                     (
1020                         _pID,
1021                         plyr_[_pID].addr,
1022                         plyr_[_pID].name,
1023                         plyr_[_pID].cosd,
1024                         plyr_[_pID].hldVltCosd
1025                     );
1026 
1027         return true;
1028     }
1029 
1030     function withdrawAffVault(uint256 _pID, string _keyType)//send
1031     // isHuman()
1032     onlyOwner()
1033     public
1034     returns(bool)
1035     {
1036 
1037         if(isCosd(_keyType) == true){
1038 
1039             if (plyr_[_pID].affCosd>0) {
1040                 plyr_[_pID].cosd = plyr_[_pID].cosd.add(plyr_[_pID].affCosd);
1041                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosd);
1042                 plyr_[_pID].affCosd = 0;
1043             }
1044         }
1045         else{
1046             if (plyr_[_pID].affCosc>0) {
1047                 plyr_[_pID].cosc = plyr_[_pID].cosc.add(plyr_[_pID].affCosc);
1048                 plyr_[_pID].totalAffCos = plyr_[_pID].totalAffCos.add(plyr_[_pID].affCosc);
1049                 plyr_[_pID].affCosc = 0;
1050             }
1051         }
1052 
1053         emit F3Devents.onWithdrawAffVault
1054         (
1055                         _pID,
1056                         plyr_[_pID].addr,
1057                         plyr_[_pID].name,
1058                         plyr_[_pID].cosd,
1059                         plyr_[_pID].cosc,
1060                         plyr_[_pID].affCosd,
1061                         plyr_[_pID].affCosc
1062         );
1063 
1064         return true;
1065     }
1066 
1067     function transferToAnotherAddr(address _from, address _to, uint256 _keys, string _keyType) //sent
1068     // isHuman()
1069     onlyOwner()
1070     public
1071     // returns(bool)
1072     {
1073         // uint256 _rID = rID_;
1074         // uint256 _holders;
1075         // uint256 _self;
1076         // uint256 i;
1077 
1078         // determinePID();
1079         // fetch player id
1080         uint256 _pID = pIDxAddr_[_from];
1081         uint256 _tID = pIDxAddr_[_to];
1082 
1083         require(_tID > 0);
1084     
1085         if (isCosd(_keyType) == true) {
1086 
1087                 require(plyr_[_pID].cosd >= _keys);
1088 
1089                 // uint256 _hldCosd;
1090                 // for ( i = 1; i <= plyNum_; i++) {
1091                 //     if(plyr_[i].cosd>0) _hldCosd = _hldCosd.add(plyr_[i].cosd);
1092                 // }
1093 
1094                 // _holders = _keys * 20/100;
1095                 // // _aff =     plyrRnds_[_pID][_rID].wonCosd * 1/100;
1096                 // _self = _keys.sub(_holders);
1097 
1098                 plyr_[_tID].cosd = plyr_[_tID].cosd.add(_keys);
1099                 plyr_[_pID].cosd = plyr_[_pID].cosd.sub(_keys);
1100 
1101                 // for ( i = 1; i <= plyNum_; i++) {
1102                 //     if(plyr_[i].cosd>0) plyr_[i].hldVltCosd = plyr_[i].hldVltCosd.add(_holders.mul(plyr_[i].cosd).div(_hldCosd));
1103                 // }
1104         }
1105 
1106         else{
1107             require(plyr_[_pID].cosc >= _keys);
1108 
1109             plyr_[_tID].cosc = plyr_[_tID].cosc.add(_keys);
1110             plyr_[_pID].cosc = plyr_[_pID].cosc.sub(_keys);
1111         }
1112 
1113         // emit F3Devents.onWithdrawWonCosFromGame
1114         //             (
1115         //                 _pID,
1116         //                 msg.sender,
1117         //                 plyr_[i].name,
1118         //                 plyr_[_pID].cosd,
1119         //                 plyr_[_pID].cosc,
1120         //                 plyr_[_pID].affVltCosd
1121         //             );
1122 
1123         // return true;
1124     }
1125     
1126     function isCosd(string _keyType)
1127     public
1128     pure
1129     returns(bool)
1130     {
1131         if( bytes(_keyType).length == 8 )
1132         {
1133             return true;
1134         }
1135         else 
1136         {
1137             return false;
1138         }
1139     }
1140     
1141     // function setResult(string _keyType) //send
1142     // public
1143     // // pure
1144     // returns(string)
1145     // {
1146     //     result_ = bytes(_keyType).length;
1147         
1148     //     return (_keyType);
1149     // }
1150     
1151     // function getResult(string _keyType)
1152     // public
1153     // pure
1154     // returns(uint256)
1155     // {
1156     //     // return bytes(_keyType).length;
1157     //     if( bytes(_keyType).length == 8 )
1158     //     {
1159     //         return 100;
1160     //     }
1161     //     else 
1162     //     {
1163     //         return 50;
1164     //     }
1165     // }
1166     
1167     function keysRec(uint256 _eth)
1168     internal
1169     returns (uint256)
1170     {
1171         // require(_price >= 10**16);
1172         
1173         uint256 _rstAmount = 0;
1174         uint256 _price = price_;
1175         // uint256 _keyNum = cosdNum_.add(coscNum_);
1176         // require(_eth >= msg.value);
1177 
1178         while(_eth >= _price){
1179             _eth = _eth - _price;
1180             _price = _price + 5 *10**11;
1181             
1182             if(_price >= 2 *10**17){ 
1183                 _price = 2 *10**17;
1184                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1185             }
1186             
1187             _rstAmount++;
1188         }
1189         
1190         price_ = _price;
1191 
1192         return _rstAmount;
1193     }
1194 
1195     function ethRec(uint256 _keys)
1196     internal
1197     returns (uint256)
1198     {
1199         // require(_price >= 10**16);
1200         
1201         uint256 _eth = 0;
1202         uint256 _price = price_;
1203         uint256 _keyNum = cosdNum_.add(coscNum_);
1204         // require(_eth >= msg.value);
1205 
1206         for(uint256 i=0;i < _keys;i++){
1207             if(_price < 10**16) _price = 10**16;
1208             
1209             _eth = _eth + _price;
1210             _price = _price - 5 *10**11;
1211             
1212             if(_price < 10**16) _price = 10**16;
1213             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1214         }
1215         
1216         price_ = _price;
1217 
1218         return _eth;
1219     }
1220 
1221     function keys(uint256 _eth)
1222     internal
1223     view
1224     returns(uint256)
1225     {
1226          // require(_price >= 10**16);
1227         
1228         uint256 _rstAmount = 0;
1229         uint256 _price = price_;
1230         // uint256 _keyNum = cosdNum_.add(coscNum_);
1231         // require(_eth >= msg.value);
1232 
1233         while(_eth >= _price){
1234             _eth = _eth - _price;
1235             _price = _price + 5 *10**11;
1236             
1237             if(_price >= 2 *10**17){ 
1238                 _price = 2 *10**17;
1239                 // priceCntThreshould_ = _keyNum.add(_rstAmount);
1240             }
1241             
1242             _rstAmount++;
1243         }
1244         
1245         // price_ = _price;
1246 
1247         return _rstAmount;
1248     }
1249 
1250     function eth(uint256 _keys)
1251     internal
1252     view
1253     returns(uint256)
1254     {
1255         // require(_price >= 10**16);
1256         
1257         uint256 _eth = 0;
1258         uint256 _price = price_;
1259         uint256 _keyNum = cosdNum_.add(coscNum_);
1260         // require(_eth >= msg.value);
1261 
1262         for(uint256 i=0;i < _keys;i++){
1263             if(_price < 10**16) _price = 10**16;
1264             
1265             _eth = _eth + _price;
1266             _price = _price - 5 *10**11;
1267             
1268             if(_price < 10**16) _price = 10**16;
1269             if(_keyNum - i >= priceCntThreshould_) _price = 2 *10**17; 
1270         }
1271         
1272         // price_ = _price;
1273 
1274         return _eth;
1275     }
1276     
1277     //==============================================================================
1278     //    (~ _  _    _._|_    .
1279     //    _)(/_(_|_|| | | \/  .
1280     //====================/=========================================================
1281     // ** upon contract deploy, it will be deactivated.  this is a one time
1282     //  * use function that will activate the contract.  we do this so devs
1283     //  * have time to set things up on the web end                            **
1284     // bool public activated_ = false;
1285     // function activate()
1286     // public 
1287     // onlyOwner {
1288     //     // make sure that its been linked.
1289     //     //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1290 
1291     //     // can only be ran once
1292     //     require(activated_ == false, "fomo3d already activated");
1293 
1294     //     // activate the contract
1295     //     activated_ = true;
1296 
1297     //     // lets start first round
1298     //     // rID_ = 1;
1299     //     // round_[1].strt = now;
1300     //     // round_[1].end  = now.add(rndInit_);
1301     // }
1302 }
1303 
1304 library F3Ddatasets {
1305     //compressedData key
1306     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1307     // 0 - new player (bool)
1308     // 1 - joined round (bool)
1309     // 2 - new  leader (bool)
1310     // 3-5 - air drop tracker (uint 0-999)
1311     // 6-16 - round end time
1312     // 17 - winnerTeam
1313     // 18 - 28 timestamp
1314     // 29 - team
1315     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1316     // 31 - airdrop happened bool
1317     // 32 - airdrop tier
1318     // 33 - airdrop amount won
1319     //compressedIDs key
1320     // [77-52][51-26][25-0]
1321     // 0-25 - pID
1322     // 26-51 - winPID
1323     // 52-77 - rID
1324     // struct EventReturns {
1325     //     uint256 compressedData;
1326     //     uint256 compressedIDs;
1327     //     address winnerAddr;         // winner address
1328     //     bytes32 winnerName;         // winner name
1329     //     uint256 amountWonCosd;          // amount won
1330     //     uint256 amountWonCosc;          // amount won
1331     // }
1332     struct Player {
1333         address addr;   // player address
1334         bytes32 name;   // player name
1335         uint256 laff;   // last affiliate id used
1336         uint256 eth;
1337         uint256 cosd;    // winnings vault
1338         uint256 cosc;    // winnings vault
1339         // uint256 lrnd;   // last round played
1340         // uint256 rounds; //超过xxxcosd的轮数累计
1341         // uint256 redtProp; //买道具赠送的累计亏损减少率
1342         // uint256 redt1;
1343         // uint256 redt3;
1344         uint256 hldVltCosd;
1345         uint256 affCosd;
1346         uint256 affCosc;
1347         uint256 totalHldVltCosd;
1348         uint256 totalAffCos;
1349         uint256 totalWinCos;
1350     }
1351     // struct PlayerRounds {
1352     //     uint256 cosd;   // keys
1353     //     uint256 cosc;   // keys
1354     //     bool hadProp;
1355     //     uint256 propID;
1356     //     uint256 redtPRProp; //lossReductionRate，玩家当前回合道具总亏损减少率
1357     //     uint256 incrPRProp; //Income increase rate收入增加率
1358     //     uint256 team;
1359     //     // bool first;
1360     //     uint256 firstCosd;//第一阶段投入的COS资金，可减少20% 亏损率
1361     //     uint256 firstCosc;//第一阶段投入的COS资金，可减少20% 亏损率
1362     //     uint256 redtPRFirst;
1363     //     uint256 wonCosd;
1364     //     uint256 wonCosc;
1365     //     uint256 wonCosdRcd;
1366     //     uint256 wonCoscRcd;
1367     // }
1368     // struct Round {
1369     //     uint256 plyr;   // pID of player in lead
1370     //     uint256 team;   // tID of team in lead
1371     //     uint256 end;    // time ends/ended
1372     //     bool ended;     // has round end function been ran
1373     //     uint256 strt;   // time round started
1374     //     uint256 cosd;   // keys
1375     //     uint256 cosc;   // keys
1376     //     uint256 winTeam;
1377     // }     
1378     // struct Team {
1379     //     uint256 teamID;        
1380     //     uint256 winRate;    // 胜率
1381     //     uint256 eth;
1382     //     uint256 cosd;
1383     //     uint256 cosc;
1384     // }
1385     // struct Prop {           //道具
1386     //     uint256 propID;         
1387     //     uint256 price;
1388     //     uint256 oID;
1389     // }
1390     // struct Leader {           //道具       
1391     //     uint256 price;
1392     //     uint256 oID;
1393     // }
1394     // struct Fee {
1395     //     uint256 aff;          // % of buy in thats paid to referrer  of current round推荐人分配比例
1396     //     uint256 com;    // % of buy in thats paid for comnunity
1397     //     uint256 holders; //key holders
1398     // }
1399 }
1400 
1401 library F3DKeysCalcLong {
1402     using SafeMath for *;
1403 
1404     function random() internal pure returns (uint256) {
1405        uint ranNum = uint(keccak256(msg.data)) % 100;
1406        return ranNum;
1407    }
1408 }