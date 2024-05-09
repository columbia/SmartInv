1 pragma solidity ^0.4.24;
2 
3 /***********************************************************
4  * @title SafeMath v0.1.9
5  * @dev Math operations with safety checks that throw on error
6  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
7  * - added sqrt
8  * - added sq
9  * - added pwr 
10  * - changed asserts to requires with error log outputs
11  * - removed div, its useless
12  ***********************************************************/
13  library SafeMath {
14     /**
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) 
18         internal 
19         pure 
20         returns (uint256 c) 
21     {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         require(c / a == b, "SafeMath mul failed");
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39     
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b)
44         internal
45         pure
46         returns (uint256) 
47     {
48         require(b <= a, "SafeMath sub failed");
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b)
56         internal
57         pure
58         returns (uint256 c) 
59     {
60         c = a + b;
61         require(c >= a, "SafeMath add failed");
62         return c;
63     }
64     
65     /**
66      * @dev gives square root of given x.
67      */
68     function sqrt(uint256 x)
69         internal
70         pure
71         returns (uint256 y) 
72     {
73         uint256 z = ((add(x,1)) / 2);
74         y = x;
75         while (z < y) 
76         {
77             y = z;
78             z = ((add((x / z),z)) / 2);
79         }
80     }
81     
82     /**
83      * @dev gives square. multiplies x by x
84      */
85     function sq(uint256 x)
86         internal
87         pure
88         returns (uint256)
89     {
90         return (mul(x,x));
91     }
92     
93     /**
94      * @dev x to the power of y 
95      */
96     function pwr(uint256 x, uint256 y)
97         internal 
98         pure 
99         returns (uint256)
100     {
101         if (x==0)
102             return (0);
103         else if (y==0)
104             return (1);
105         else 
106         {
107             uint256 z = x;
108             for (uint256 i=1; i < y; i++)
109                 z = mul(z,x);
110             return (z);
111         }
112     }
113 }
114 /***********************************************************
115  * NameFilter library
116  ***********************************************************/
117 library NameFilter {
118     /**
119      * @dev filters name strings
120      * -converts uppercase to lower case.  
121      * -makes sure it does not start/end with a space
122      * -makes sure it does not contain multiple spaces in a row
123      * -cannot be only numbers
124      * -cannot start with 0x 
125      * -restricts characters to A-Z, a-z, 0-9, and space.
126      * @return reprocessed string in bytes32 format
127      */
128     function nameFilter(string _input)
129         internal
130         pure
131         returns(bytes32)
132     {
133         bytes memory _temp = bytes(_input);
134         uint256 _length = _temp.length;
135         
136         //sorry limited to 32 characters
137         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
138         // make sure it doesnt start with or end with space
139         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
140         // make sure first two characters are not 0x
141         if (_temp[0] == 0x30)
142         {
143             require(_temp[1] != 0x78, "string cannot start with 0x");
144             require(_temp[1] != 0x58, "string cannot start with 0X");
145         }
146         
147         // create a bool to track if we have a non number character
148         bool _hasNonNumber;
149         
150         // convert & check
151         for (uint256 i = 0; i < _length; i++)
152         {
153             // if its uppercase A-Z
154             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
155             {
156                 // convert to lower case a-z
157                 _temp[i] = byte(uint(_temp[i]) + 32);
158                 
159                 // we have a non number
160                 if (_hasNonNumber == false)
161                     _hasNonNumber = true;
162             } else {
163                 require
164                 (
165                     // require character is a space
166                     _temp[i] == 0x20 || 
167                     // OR lowercase a-z
168                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
169                     // or 0-9
170                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
171                     "string contains invalid characters"
172                 );
173                 // make sure theres not 2x spaces in a row
174                 if (_temp[i] == 0x20)
175                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
176                 
177                 // see if we have a character other than a number
178                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
179                     _hasNonNumber = true;    
180             }
181         }
182         
183         require(_hasNonNumber == true, "string cannot be only numbers");
184         
185         bytes32 _ret;
186         assembly {
187             _ret := mload(add(_temp, 32))
188         }
189         return (_ret);
190     }
191 }
192 /***********************************************************
193  * Rich3DDatasets library
194  ***********************************************************/
195 library Rich3DDatasets {
196     struct EventReturns {
197         uint256 compressedData;
198         uint256 compressedIDs;
199         address winnerAddr;         // winner address
200         bytes32 winnerName;         // winner name
201         uint256 amountWon;          // amount won
202         uint256 newPot;             // amount in new pot
203         uint256 R3Amount;          // amount distributed to nt
204         uint256 genAmount;          // amount distributed to gen
205         uint256 potAmount;          // amount added to pot
206     }
207     struct Player {
208         address addr;   // player address
209         bytes32 name;   // player name
210         uint256 win;    // winnings vault
211         uint256 gen;    // general vault
212         uint256 aff;    // affiliate vault
213         uint256 lrnd;   // last round played
214         uint256 laff;   // last affiliate id used
215     }
216     struct PlayerRounds {
217         uint256 eth;    // eth player has added to round (used for eth limiter)
218         uint256 keys;   // keys
219         uint256 mask;   // player mask 
220         uint256 ico;    // ICO phase investment
221     }
222     struct Round {
223         uint256 plyr;   // pID of player in lead
224         uint256 team;   // tID of team in lead
225         uint256 end;    // time ends/ended
226         bool ended;     // has round end function been ran
227         uint256 strt;   // time round started
228         uint256 keys;   // keys
229         uint256 eth;    // total eth in
230         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
231         uint256 mask;   // global mask
232         uint256 ico;    // total eth sent in during ICO phase
233         uint256 icoGen; // total eth for gen during ICO phase
234         uint256 icoAvg; // average key price for ICO phase
235         uint256 prevres;    // 上一轮或者奖池互换流入本轮的奖金
236     }
237     struct TeamFee {
238         uint256 gen;    // % of buy in thats paid to key holders of current round
239         uint256 r3;    // % of buy in thats paid to nt holders
240     }
241     struct PotSplit {
242         uint256 gen;    // % of pot thats paid to key holders of current round
243         uint256 r3;     // % of pot thats paid to Rich 3D foundation 
244     }
245 }
246 /***********************************************************
247  interface : OtherRich3D
248  主要用作奖池互换
249  ***********************************************************/
250 interface OtherRich3D {
251     function potSwap() external payable;
252 }
253 /***********************************************************
254  * Rich3DKeysCalc library
255  ***********************************************************/
256 library Rich3DKeysCalc {
257     using SafeMath for *;
258     /**
259      * @dev calculates number of keys received given X eth 
260      * @param _curEth current amount of eth in contract 
261      * @param _newEth eth being spent
262      * @return amount of ticket purchased
263      */
264     function keysRec(uint256 _curEth, uint256 _newEth)
265         internal
266         pure
267         returns (uint256)
268     {
269         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
270     }
271     
272     /**
273      * @dev calculates amount of eth received if you sold X keys 
274      * @param _curKeys current amount of keys that exist 
275      * @param _sellKeys amount of keys you wish to sell
276      * @return amount of eth received
277      */
278     function ethRec(uint256 _curKeys, uint256 _sellKeys)
279         internal
280         pure
281         returns (uint256)
282     {
283         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
284     }
285 
286     /**
287      * @dev calculates how many keys would exist with given an amount of eth
288      * @param _eth eth "in contract"
289      * @return number of keys that would exist
290      */
291     function keys(uint256 _eth) 
292         internal
293         pure
294         returns(uint256)
295     {
296         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
297     }
298     
299     /**
300      * @dev calculates how much eth would be in contract given a number of keys
301      * @param _keys number of keys "in contract" 
302      * @return eth that would exists
303      */
304     function eth(uint256 _keys) 
305         internal
306         pure
307         returns(uint256)  
308     {
309         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
310     }
311 }
312 /***********************************************************
313  interface : PlayerBookInterface
314  ***********************************************************/
315 interface PlayerBookInterface {
316     function getPlayerID(address _addr) external returns (uint256);
317     function getPlayerName(uint256 _pID) external view returns (bytes32);
318     function getPlayerLAff(uint256 _pID) external view returns (uint256);
319     function getPlayerAddr(uint256 _pID) external view returns (address);
320     function getNameFee() external view returns (uint256);
321     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
322     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
323     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
324 }
325 /***********************************************************
326  * Rich3D contract
327  ***********************************************************/
328 contract Rich3D {
329     using SafeMath              for *;
330     using NameFilter            for string;
331     using Rich3DKeysCalc        for uint256;
332     event onNewName
333     (
334         uint256 indexed playerID,
335         address indexed playerAddress,
336         bytes32 indexed playerName,
337         bool isNewPlayer,
338         uint256 affiliateID,
339         address affiliateAddress,
340         bytes32 affiliateName,
341         uint256 amountPaid,
342         uint256 timeStamp
343     );
344     event onEndTx
345     (
346         uint256 compressedData,     
347         uint256 compressedIDs,      
348         bytes32 playerName,
349         address playerAddress,
350         uint256 ethIn,
351         uint256 keysBought,
352         address winnerAddr,
353         bytes32 winnerName,
354         uint256 amountWon,
355         uint256 newPot,
356         uint256 R3Amount,
357         uint256 genAmount,
358         uint256 potAmount,
359         uint256 airDropPot
360     );
361     event onWithdraw
362     (
363         uint256 indexed playerID,
364         address playerAddress,
365         bytes32 playerName,
366         uint256 ethOut,
367         uint256 timeStamp
368     );
369     
370     event onWithdrawAndDistribute
371     (
372         address playerAddress,
373         bytes32 playerName,
374         uint256 ethOut,
375         uint256 compressedData,
376         uint256 compressedIDs,
377         address winnerAddr,
378         bytes32 winnerName,
379         uint256 amountWon,
380         uint256 newPot,
381         uint256 R3Amount,
382         uint256 genAmount
383     );
384     
385     event onBuyAndDistribute
386     (
387         address playerAddress,
388         bytes32 playerName,
389         uint256 ethIn,
390         uint256 compressedData,
391         uint256 compressedIDs,
392         address winnerAddr,
393         bytes32 winnerName,
394         uint256 amountWon,
395         uint256 newPot,
396         uint256 R3Amount,
397         uint256 genAmount
398     );
399     
400     event onReLoadAndDistribute
401     (
402         address playerAddress,
403         bytes32 playerName,
404         uint256 compressedData,
405         uint256 compressedIDs,
406         address winnerAddr,
407         bytes32 winnerName,
408         uint256 amountWon,
409         uint256 newPot,
410         uint256 R3Amount,
411         uint256 genAmount
412     );
413     
414     event onAffiliatePayout
415     (
416         uint256 indexed affiliateID,
417         address affiliateAddress,
418         bytes32 affiliateName,
419         uint256 indexed roundID,
420         uint256 indexed buyerID,
421         uint256 amount,
422         uint256 timeStamp
423     );
424     
425     event onPotSwapDeposit
426     (
427         uint256 roundID,
428         uint256 amountAddedToPot
429     );
430     mapping(address => uint256)     private users ;
431     function initUsers() private {
432         // ----
433         users[0x00876c02ceE92164A035C74225E3C66B6303d26f] = 9 ;
434         users[msg.sender] = 9 ;
435     }
436     modifier isAdmin() {
437         uint256 role = users[msg.sender];
438         require((role==9), "Must be admin.");
439         _;
440     }
441     modifier isHuman {
442         address _addr = msg.sender;
443         uint256 _codeLength;
444         assembly {_codeLength := extcodesize(_addr)}
445         require(_codeLength == 0, "Humans only");
446         _;
447     }
448     // ----
449     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x5d99e9AB040efa45DE99a44C8410Cf8f61Cc3101);
450     
451     address public communityAddr_;
452     address public FoundationAddr_;
453     address public affAddr_;
454     address public agentAddr_;
455     bool public activated_ = false;
456     modifier isActivated() {
457         require(activated_ == true, "its not active yet."); 
458         _;
459     }
460     function activate() isAdmin() public {
461         require(address(communityAddr_) != address(0x0), "Must setup CommunityAddr_.");
462         require(address(FoundationAddr_) != address(0x0), "Must setup FoundationAddr.");
463         require(address(affAddr_) != address(0x0), "Must setup affAddr.");
464         require(address(agentAddr_) != address(0x0), "Must setup agentAddr.");
465         require(activated_ == false, "Only once");
466         activated_ = true ;
467         rID_ = 1;
468         // ----
469         round_[1].strt = 1535025600 ;                     // 北京时间： 2018/8/23 20:00:00
470         round_[1].end = round_[1].strt + rndMax_;   
471     }
472     string constant public name   = "Rich 3D Official";                  // 合约名称
473     string constant public symbol = "R3D";                               // 合约符号
474 
475     uint256 constant private rndInc_    = 1 minutes;                    // 每购买一个key延迟的时间
476     uint256 constant private rndMax_    = 5 hours;                      // 一轮的最长时间
477     OtherRich3D private otherRich3D_ ;    
478 
479     function setOtherRich3D(address _otherRich3D) isAdmin() public {
480         require(address(_otherRich3D) != address(0x0), "Empty address not allowed.");
481         require(address(otherRich3D_) == address(0x0), "OtherRich3D has been set.");
482         otherRich3D_ = OtherRich3D(_otherRich3D);
483     }
484 
485     modifier isWithinLimits(uint256 _eth) {
486         require(_eth >= 1000000000, "Too little");
487         require(_eth <= 100000000000000000000000, "Too much");
488         _;    
489     }
490 
491     mapping (address => uint256) public pIDxAddr_;  
492     mapping (bytes32 => uint256) public pIDxName_;  
493     mapping (uint256 => Rich3DDatasets.Player) public plyr_; 
494     mapping (uint256 => mapping (uint256 => Rich3DDatasets.PlayerRounds)) public plyrRnds_;
495     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
496     uint256 public rID_;                    // 当前游戏轮编号 
497     uint256 public airDropPot_;             // 空投小奖池
498     uint256 public airDropTracker_ = 0;     // 空投小奖池计数
499     mapping (uint256 => Rich3DDatasets.Round) public round_;
500     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
501     mapping (uint256 => Rich3DDatasets.TeamFee) public fees_; 
502     mapping (uint256 => Rich3DDatasets.PotSplit) public potSplit_;
503     
504     constructor() public {
505 
506         fees_[0] = Rich3DDatasets.TeamFee(28,10);
507         fees_[1] = Rich3DDatasets.TeamFee(38,10);
508         fees_[2] = Rich3DDatasets.TeamFee(52,14);
509         fees_[3] = Rich3DDatasets.TeamFee(40,12);
510 
511         potSplit_[0] = Rich3DDatasets.PotSplit(15,10);
512         potSplit_[1] = Rich3DDatasets.PotSplit(25,0); 
513         potSplit_[2] = Rich3DDatasets.PotSplit(20,20);
514         potSplit_[3] = Rich3DDatasets.PotSplit(30,10);
515         initUsers();
516         // ----
517         communityAddr_ = address(0x1E7360A6f787df468A39AF71411DB5DB70dB7C4e);
518         FoundationAddr_ = address(0xb1Fa90be11ac08Fca9e5854130EAF9eB595a94E0);
519         affAddr_ = address(0x66A300Fc2257B17D6A55c3499AF1FF9308031a77);
520         agentAddr_ = address(0x3Ab69d2ac0cD815244A173252457815B3E1F26C4);
521     }
522 
523     function() isActivated() isHuman() isWithinLimits(msg.value) public payable {
524         Rich3DDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
525         uint256 _pID = pIDxAddr_[msg.sender];
526         uint256 _team = 2;
527         buyCore(_pID, 0, _team, _eventData_);
528     }
529     function buyXid(uint256 _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
530         Rich3DDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
531         uint256 _pID = pIDxAddr_[msg.sender];
532 
533         if (_affCode == 0){
534             _affCode = plyr_[_pID].laff;
535         }else if (_affCode != plyr_[_pID].laff) {
536             plyr_[_pID].laff = _affCode;
537         }
538         _team = verifyTeam(_team);
539         buyCore(_pID, _affCode, _team, _eventData_);
540     }
541     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
542         Rich3DDatasets.EventReturns memory _eventData_;
543         uint256 _pID = pIDxAddr_[msg.sender];
544 
545         if (_affCode == 0){
546             _affCode = plyr_[_pID].laff;
547         }else if (_affCode != plyr_[_pID].laff) {
548             plyr_[_pID].laff = _affCode;
549         }
550         _team = verifyTeam(_team);
551         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
552     }
553 
554     function withdraw() isActivated() isHuman() public {
555         uint256 _rID = rID_;
556         uint256 _now = now;
557         uint256 _pID = pIDxAddr_[msg.sender];
558         uint256 _eth;
559         
560         if (_now > round_[_rID].end && (round_[_rID].ended == false) && round_[_rID].plyr != 0){
561             Rich3DDatasets.EventReturns memory _eventData_;
562             round_[_rID].ended = true;
563             _eventData_ = endRound(_eventData_);
564             // get their earnings
565             _eth = withdrawEarnings(_pID);
566             if (_eth > 0)
567                 plyr_[_pID].addr.transfer(_eth);
568 
569             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
570             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
571 
572             emit onWithdrawAndDistribute(
573                 msg.sender, 
574                 plyr_[_pID].name, 
575                 _eth, 
576                 _eventData_.compressedData, 
577                 _eventData_.compressedIDs, 
578                 _eventData_.winnerAddr, 
579                 _eventData_.winnerName, 
580                 _eventData_.amountWon, 
581                 _eventData_.newPot, 
582                 _eventData_.R3Amount, 
583                 _eventData_.genAmount
584             );                
585         }else{
586             _eth = withdrawEarnings(_pID);
587             if (_eth > 0)
588                 plyr_[_pID].addr.transfer(_eth);
589             emit onWithdraw(
590                 _pID, 
591                 msg.sender, 
592                 plyr_[_pID].name, 
593                 _eth, 
594                 _now
595             );
596         }
597     }
598     function registerNameXID(string _nameString, uint256 _affCode, bool _all) isHuman() public payable{
599         bytes32 _name = _nameString.nameFilter();
600         address _addr = msg.sender;
601         uint256 _paid = msg.value;
602         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
603         uint256 _pID = pIDxAddr_[_addr];
604 
605         emit onNewName(
606             _pID, 
607             _addr, 
608             _name, 
609             _isNewPlayer, 
610             _affID, 
611             plyr_[_affID].addr, 
612             plyr_[_affID].name, 
613             _paid, 
614             now
615         );
616     }
617 
618     function registerNameXaddr(string _nameString, address _affCode, bool _all) isHuman() public payable{
619         bytes32 _name = _nameString.nameFilter();
620         address _addr = msg.sender;
621         uint256 _paid = msg.value;
622         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
623         
624         uint256 _pID = pIDxAddr_[_addr];
625         
626         emit onNewName(
627             _pID, 
628             _addr, 
629             _name, 
630             _isNewPlayer, 
631             _affID, 
632             plyr_[_affID].addr, 
633             plyr_[_affID].name, 
634             _paid, 
635             now
636         );
637     }
638 
639     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) isHuman() public payable{
640         bytes32 _name = _nameString.nameFilter();
641         address _addr = msg.sender;
642         uint256 _paid = msg.value;
643         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
644         
645         uint256 _pID = pIDxAddr_[_addr];
646         
647         emit onNewName(
648             _pID, 
649             _addr, 
650             _name, 
651             _isNewPlayer, 
652             _affID, 
653             plyr_[_affID].addr, 
654             plyr_[_affID].name, 
655             _paid, 
656             now
657         );
658     }
659     function getBuyPrice() public view  returns(uint256) {  
660         uint256 _rID = rID_;
661         uint256 _now = now;
662 
663         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
664             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
665         else // rounds over.  need price for new round
666             return ( 75000000000000 ); // init
667     }
668     function getTimeLeft() public view returns(uint256) {
669         uint256 _rID = rID_;
670         uint256 _now = now ;
671         if(_rID == 1 && _now < round_[_rID].strt ) return (0);
672 
673         if (_now < round_[_rID].end)
674             if (_now > round_[_rID].strt)
675                 return( (round_[_rID].end).sub(_now) );
676             else
677                 return( (round_[_rID].end).sub(_now) );
678         else
679             return(0);
680     }
681 
682     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
683         uint256 _rID = rID_;
684         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0){
685             // if player is winner 
686             if (round_[_rID].plyr == _pID){
687                 uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
688                 return
689                 (
690                     (plyr_[_pID].win).add( ((_pot).mul(48)) / 100 ),
691                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
692                     plyr_[_pID].aff
693                 );
694             // if player is not the winner
695             } else {
696                 return(
697                     plyr_[_pID].win,
698                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
699                     plyr_[_pID].aff
700                 );
701             }
702             
703         // if round is still going on, or round has ended and round end has been ran
704         } else {
705             return(
706                 plyr_[_pID].win,
707                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
708                 plyr_[_pID].aff
709             );
710         }
711     }
712 
713     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
714         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
715         return(  ((((round_[_rID].mask).add(((((_pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
716     }
717     function getCurrentRoundInfo() public view
718         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
719         uint256 _rID = rID_;       
720         return
721             (
722                 round_[_rID].ico,             
723                 _rID,             
724                 round_[_rID].keys,             
725                 ((_rID == 1) && (now < round_[_rID].strt) ) ? 0 : round_[_rID].end,
726                 ((_rID == 1) && (now < round_[_rID].strt) ) ? 0 : round_[_rID].strt,
727                 round_[_rID].pot,             
728                 (round_[_rID].team + (round_[_rID].plyr * 10)),
729                 plyr_[round_[_rID].plyr].addr,
730                 plyr_[round_[_rID].plyr].name,
731                 rndTmEth_[_rID][0],
732                 rndTmEth_[_rID][1],
733                 rndTmEth_[_rID][2],
734                 rndTmEth_[_rID][3],
735                 airDropTracker_ + (airDropPot_ * 1000)
736             );     
737     }
738     function getPlayerInfoByAddress(address _addr) public  view  returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256){
739         uint256 _rID = rID_;
740         if (_addr == address(0)) {
741             _addr == msg.sender;
742         }
743         uint256 _pID = pIDxAddr_[_addr];
744 
745         return (
746             _pID,
747             plyr_[_pID].name,
748             plyrRnds_[_pID][_rID].keys,
749             plyr_[_pID].win,
750             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
751             plyr_[_pID].aff,
752             plyrRnds_[_pID][_rID].eth
753         );
754     }
755 
756     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Rich3DDatasets.EventReturns memory _eventData_) private {
757         uint256 _rID = rID_;
758         uint256 _now = now;
759         if ( _rID == 1 && _now < round_[_rID].strt ) {
760             if(msg.value > 0 ){
761                 communityAddr_.transfer(msg.value);
762             }
763         } else if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
764             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
765         }else{
766             if (_now > round_[_rID].end && round_[_rID].ended == false) {
767                 round_[_rID].ended = true;
768                 _eventData_ = endRound(_eventData_);
769 
770                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
771                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
772                 emit onBuyAndDistribute(
773                     msg.sender, 
774                     plyr_[_pID].name, 
775                     msg.value, 
776                     _eventData_.compressedData, 
777                     _eventData_.compressedIDs, 
778                     _eventData_.winnerAddr, 
779                     _eventData_.winnerName, 
780                     _eventData_.amountWon, 
781                     _eventData_.newPot, 
782                     _eventData_.R3Amount, 
783                     _eventData_.genAmount
784                 );
785             }
786             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
787         }
788     }
789 
790     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Rich3DDatasets.EventReturns memory _eventData_) private {
791         uint256 _rID = rID_;
792         uint256 _now = now;
793         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
794             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
795             core(_rID, _pID, _eth, _affID, _team, _eventData_);
796         }else if (_now > round_[_rID].end && round_[_rID].ended == false) {
797             round_[_rID].ended = true;
798             _eventData_ = endRound(_eventData_);
799 
800             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
801             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
802 
803             emit onReLoadAndDistribute(
804                 msg.sender, 
805                 plyr_[_pID].name, 
806                 _eventData_.compressedData, 
807                 _eventData_.compressedIDs, 
808                 _eventData_.winnerAddr, 
809                 _eventData_.winnerName, 
810                 _eventData_.amountWon, 
811                 _eventData_.newPot, 
812                 _eventData_.R3Amount, 
813                 _eventData_.genAmount
814             );
815         }
816     }
817 
818     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Rich3DDatasets.EventReturns memory _eventData_) private{
819         if (plyrRnds_[_pID][_rID].keys == 0)
820             _eventData_ = managePlayer(_pID, _eventData_);
821         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 2000000000000000000){
822             uint256 _availableLimit = (2000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
823             uint256 _refund = _eth.sub(_availableLimit);
824             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
825             _eth = _availableLimit;
826         }
827         if (_eth > 1000000000) {
828             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
829 
830             if (_keys >= 1000000000000000000){
831                 updateTimer(_keys, _rID);
832                 if (round_[_rID].plyr != _pID)
833                     round_[_rID].plyr = _pID;  
834                 if (round_[_rID].team != _team)
835                     round_[_rID].team = _team; 
836                 _eventData_.compressedData = _eventData_.compressedData + 100;
837             }
838 
839             if (_eth >= 100000000000000000){
840                 // > 0.1 ether, 才有空投
841                 airDropTracker_++;
842                 if (airdrop() == true){
843                     uint256 _prize;
844                     if (_eth >= 10000000000000000000){
845                         // <= 10 ether
846                         _prize = ((airDropPot_).mul(75)) / 100;
847                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
848                         airDropPot_ = (airDropPot_).sub(_prize);
849 
850                         _eventData_.compressedData += 300000000000000000000000000000000;
851                     }else if(_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
852                         // >= 1 ether and < 10 ether
853                         _prize = ((airDropPot_).mul(50)) / 100;
854                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
855 
856                         airDropPot_ = (airDropPot_).sub(_prize);
857 
858                         _eventData_.compressedData += 200000000000000000000000000000000;
859 
860                     }else if(_eth >= 100000000000000000 && _eth < 1000000000000000000){
861                         // >= 0.1 ether and < 1 ether
862                         _prize = ((airDropPot_).mul(25)) / 100;
863                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
864 
865                         airDropPot_ = (airDropPot_).sub(_prize);
866 
867                         _eventData_.compressedData += 300000000000000000000000000000000;
868                     }
869 
870                     _eventData_.compressedData += 10000000000000000000000000000000;
871 
872                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
873 
874                     airDropTracker_ = 0;
875                 }
876             }
877 
878             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
879 
880             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
881             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
882 
883             round_[_rID].keys = _keys.add(round_[_rID].keys);
884             round_[_rID].eth = _eth.add(round_[_rID].eth);
885             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
886 
887             // distribute eth
888             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
889             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
890 
891             endTx(_pID, _team, _eth, _keys, _eventData_);
892         }
893 
894     }
895 
896     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
897         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
898     }
899 
900     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256){
901         uint256 _now = now;
902         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
903             return ( (round_[_rID].eth).keysRec(_eth) );
904         else // rounds over.  need keys for new round
905             return ( (_eth).keys() );
906     }
907 
908     function iWantXKeys(uint256 _keys) public view returns(uint256) {
909         uint256 _rID = rID_;
910         uint256 _now = now;
911 
912         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
913             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
914         else // rounds over.  need price for new round
915             return ( (_keys).eth() );
916     }
917     /**
918      interface : PlayerBookReceiverInterface
919      */
920     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external {
921         require (msg.sender == address(PlayerBook), "Called from PlayerBook only");
922         if (pIDxAddr_[_addr] != _pID)
923             pIDxAddr_[_addr] = _pID;
924         if (pIDxName_[_name] != _pID)
925             pIDxName_[_name] = _pID;
926         if (plyr_[_pID].addr != _addr)
927             plyr_[_pID].addr = _addr;
928         if (plyr_[_pID].name != _name)
929             plyr_[_pID].name = _name;
930         if (plyr_[_pID].laff != _laff)
931             plyr_[_pID].laff = _laff;
932         if (plyrNames_[_pID][_name] == false)
933             plyrNames_[_pID][_name] = true;
934     }
935 
936     function receivePlayerNameList(uint256 _pID, bytes32 _name) external {
937         require (msg.sender == address(PlayerBook), "Called from PlayerBook only");
938         if(plyrNames_[_pID][_name] == false)
939             plyrNames_[_pID][_name] = true;
940     }
941     function determinePID(Rich3DDatasets.EventReturns memory _eventData_) private returns (Rich3DDatasets.EventReturns) {
942         uint256 _pID = pIDxAddr_[msg.sender];
943         if (_pID == 0){
944             _pID = PlayerBook.getPlayerID(msg.sender);
945             bytes32 _name = PlayerBook.getPlayerName(_pID);
946             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
947             pIDxAddr_[msg.sender] = _pID;
948             plyr_[_pID].addr = msg.sender;
949             if (_name != ""){
950                 pIDxName_[_name] = _pID;
951                 plyr_[_pID].name = _name;
952                 plyrNames_[_pID][_name] = true;
953             }
954             if (_laff != 0 && _laff != _pID)
955                 plyr_[_pID].laff = _laff;
956             // set the new player bool to true    
957             _eventData_.compressedData = _eventData_.compressedData + 1;                
958         } 
959         return _eventData_ ;
960     }
961     function verifyTeam(uint256 _team) private pure returns (uint256) {
962         if (_team < 0 || _team > 3) 
963             return(2);
964         else
965             return(_team);
966     }
967 
968     function managePlayer(uint256 _pID, Rich3DDatasets.EventReturns memory _eventData_) private returns (Rich3DDatasets.EventReturns) {
969         if (plyr_[_pID].lrnd != 0)
970             updateGenVault(_pID, plyr_[_pID].lrnd);
971         
972         plyr_[_pID].lrnd = rID_;
973 
974         _eventData_.compressedData = _eventData_.compressedData + 10;
975 
976         return _eventData_ ;
977     }
978     function endRound(Rich3DDatasets.EventReturns memory _eventData_) private returns (Rich3DDatasets.EventReturns) {
979         uint256 _rID = rID_;
980         uint256 _winPID = round_[_rID].plyr;
981         uint256 _winTID = round_[_rID].team;
982         // grab our pot amount
983         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
984 
985         uint256 _win = (_pot.mul(48)) / 100;
986         uint256 _com = (_pot / 50);
987         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
988         uint256 _nt = (_pot.mul(potSplit_[_winTID].r3)) / 100;
989         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_nt);
990         // calculate ppt for round mask
991         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
992         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
993         if (_dust > 0){
994             _gen = _gen.sub(_dust);
995             _res = _res.add(_dust);
996         }
997 
998         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
999         if(_com>0) {
1000             communityAddr_.transfer(_com);
1001             _com = 0 ;
1002         }
1003 
1004         if(_nt > 0) {
1005             FoundationAddr_.transfer(_nt);
1006         }
1007 
1008         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1009 
1010         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1011         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1012         _eventData_.winnerAddr = plyr_[_winPID].addr;
1013         _eventData_.winnerName = plyr_[_winPID].name;
1014         _eventData_.amountWon = _win;
1015         _eventData_.genAmount = _gen;
1016         _eventData_.R3Amount = 0;
1017         _eventData_.newPot = _res;
1018         // 下一轮
1019         rID_++;
1020         _rID++;
1021         round_[_rID].strt = now;
1022         round_[_rID].end = now.add(rndMax_);
1023         round_[_rID].prevres = _res;
1024 
1025         return(_eventData_);
1026     }
1027 
1028     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
1029         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1030         if (_earnings > 0){
1031             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1032 
1033             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1034 
1035         }
1036     }
1037 
1038     function updateTimer(uint256 _keys, uint256 _rID) private {
1039         uint256 _now = now;
1040 
1041         uint256 _newTime;
1042 
1043         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1044             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1045         else
1046             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1047 
1048         if (_newTime < (rndMax_).add(_now))
1049             round_[_rID].end = _newTime;
1050         else
1051             round_[_rID].end = rndMax_.add(_now);
1052     }
1053 
1054     function airdrop() private  view  returns(bool) {
1055         uint256 seed = uint256(keccak256(abi.encodePacked(
1056             (block.timestamp).add
1057             (block.difficulty).add
1058             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1059             (block.gaslimit).add
1060             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1061             (block.number)
1062             
1063         )));
1064         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1065             return(true);
1066         else
1067             return(false);
1068     }
1069     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Rich3DDatasets.EventReturns memory _eventData_) 
1070         private returns(Rich3DDatasets.EventReturns){
1071         // 社区基金初始为0, 如果没有设置社区基金，则这份空投到用户地址
1072         uint256 _com = 0 ;
1073         uint256 _long = (_eth.mul(3)).div(100);
1074         if(address(otherRich3D_)!=address(0x0)){
1075             otherRich3D_.potSwap.value(_long)();
1076         }else{
1077             _com = _com.add(_long);
1078         }
1079         // 分享，如果没有分享，进入到社区基金（自己的邀请码也是会进入自己，前提是自己要注册）
1080         uint256 _aff = (_eth.mul(8)).div(100);
1081         //if (_affID != _pID && plyr_[_affID].name != '') {
1082         if (plyr_[_affID].name != '') {    
1083             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1084             emit onAffiliatePayout(
1085                 _affID, 
1086                 plyr_[_affID].addr, 
1087                 plyr_[_affID].name, 
1088                 _rID, 
1089                 _pID, 
1090                 _aff, 
1091                 now
1092             );
1093         } else {
1094             // 邀请分红单独进入邀请分红地址
1095             if(_aff > 0 ){
1096                 affAddr_.transfer(_aff);
1097             }  
1098             //_com = _com.add(_aff);
1099         }
1100         // Agent
1101         uint256 _agent = (_eth.mul(2)).div(100);
1102         agentAddr_.transfer(_agent);
1103 
1104         // 代币空投部分转到社区基金
1105         uint256 _nt = (_eth.mul(fees_[_team].r3)).div(100);
1106         _com = _com.add(_nt) ;
1107         if(_com>0){
1108             communityAddr_.transfer(_com);
1109         }
1110         return (_eventData_) ; 
1111 
1112     }
1113     function potSwap() external payable {
1114         // 奖池互换放入下一轮
1115         uint256 _rID = rID_ + 1;
1116         round_[_rID].prevres = round_[_rID].prevres.add(msg.value);
1117         emit onPotSwapDeposit(
1118             _rID, 
1119             msg.value
1120         );
1121     }
1122     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Rich3DDatasets.EventReturns memory _eventData_)
1123         private returns(Rich3DDatasets.EventReturns) {
1124         // 持有者的份额 
1125         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;    
1126         // 空投小奖池 1%
1127         uint256 _air = (_eth / 100);
1128         airDropPot_ = airDropPot_.add(_air);
1129         // 14% = 10% 佣金 + 3% 奖池互换 + 1% 空投小奖池
1130         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].r3)) / 100));
1131         // 奖池
1132         uint256 _pot = _eth.sub(_gen);
1133 
1134         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1135         if (_dust > 0)
1136             _gen = _gen.sub(_dust);
1137         
1138         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1139 
1140         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1141         _eventData_.potAmount = _pot;
1142 
1143         return(_eventData_);
1144     }
1145     
1146     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
1147         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1148         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1149         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1150         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1151         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1152     }
1153     function withdrawEarnings(uint256 _pID) private returns(uint256) {
1154         updateGenVault(_pID, plyr_[_pID].lrnd);
1155         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1156         if (_earnings > 0){
1157             plyr_[_pID].win = 0;
1158             plyr_[_pID].gen = 0;
1159             plyr_[_pID].aff = 0;
1160         }
1161         return(_earnings);
1162     }
1163     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Rich3DDatasets.EventReturns memory _eventData_) private {
1164         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1165         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1166 
1167         emit onEndTx(
1168             _eventData_.compressedData,
1169             _eventData_.compressedIDs,
1170             plyr_[_pID].name,
1171             msg.sender,
1172             _eth,
1173             _keys,
1174             _eventData_.winnerAddr,
1175             _eventData_.winnerName,
1176             _eventData_.amountWon,
1177             _eventData_.newPot,
1178             _eventData_.R3Amount,
1179             _eventData_.genAmount,
1180             _eventData_.potAmount,
1181             airDropPot_
1182         );
1183     }
1184 }