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
193  * NTech3DDatasets library
194  ***********************************************************/
195 library NTech3DDatasets {
196     struct EventReturns {
197         uint256 compressedData;
198         uint256 compressedIDs;
199         address winnerAddr;         // winner address
200         bytes32 winnerName;         // winner name
201         uint256 amountWon;          // amount won
202         uint256 newPot;             // amount in new pot
203         uint256 NTAmount;          // amount distributed to nt
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
239         uint256 nt;    // % of buy in thats paid to nt holders
240     }
241     struct PotSplit {
242         uint256 gen;    // % of pot thats paid to key holders of current round
243         uint256 nt;     // % of pot thats paid to NT foundation 
244     }
245 }
246 /***********************************************************
247  interface : OtherNTech3D
248  主要用作奖池互换
249  ***********************************************************/
250 interface OtherNTech3D {
251     function potSwap() external payable;
252 }
253 /***********************************************************
254  * NTech3DKeysCalcLong library
255  ***********************************************************/
256 library NTech3DKeysCalcLong {
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
312 
313 /***********************************************************
314  * ERC20 interface
315  * see https://github.com/ethereum/EIPs/issues/20
316  ***********************************************************/
317 contract ERC20 {
318     function totalSupply() public view returns (uint supply);
319     function balanceOf( address who ) public view returns (uint value);
320     function allowance( address owner, address spender ) public view returns (uint _allowance);
321 
322     function transfer( address to, uint value) public returns (bool ok);
323     function transferFrom( address from, address to, uint value) public returns (bool ok);
324     function approve( address spender, uint value ) public returns (bool ok);
325 
326     event Transfer( address indexed from, address indexed to, uint value);
327     event Approval( address indexed owner, address indexed spender, uint value);
328 }
329 /***********************************************************
330  interface : PlayerBookInterface
331  ***********************************************************/
332 interface PlayerBookInterface {
333     function getPlayerID(address _addr) external returns (uint256);
334     function getPlayerName(uint256 _pID) external view returns (bytes32);
335     function getPlayerLAff(uint256 _pID) external view returns (uint256);
336     function getPlayerAddr(uint256 _pID) external view returns (address);
337     function getNameFee() external view returns (uint256);
338     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
339     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
340     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
341 }
342 /***********************************************************
343  * NTech3DLong contract
344  ***********************************************************/
345 contract NTech3DLong {
346     /****************************************************************************************** 
347      导入的库
348      */
349     using SafeMath              for *;
350     using NameFilter            for string;
351     using NTech3DKeysCalcLong   for uint256;
352     /****************************************************************************************** 
353      事件
354      */
355     // 当玩家注册名字时调用
356     event onNewName
357     (
358         uint256 indexed playerID,
359         address indexed playerAddress,
360         bytes32 indexed playerName,
361         bool isNewPlayer,
362         uint256 affiliateID,
363         address affiliateAddress,
364         bytes32 affiliateName,
365         uint256 amountPaid,
366         uint256 timeStamp
367     );
368     // 购买完成后或者再次载入时调用
369     event onEndTx
370     (
371         uint256 compressedData,     
372         uint256 compressedIDs,      
373         bytes32 playerName,
374         address playerAddress,
375         uint256 ethIn,
376         uint256 keysBought,
377         address winnerAddr,
378         bytes32 winnerName,
379         uint256 amountWon,
380         uint256 newPot,
381         uint256 NTAmount,
382         uint256 genAmount,
383         uint256 potAmount,
384         uint256 airDropPot
385     );
386     
387     // 撤退时调用
388     event onWithdraw
389     (
390         uint256 indexed playerID,
391         address playerAddress,
392         bytes32 playerName,
393         uint256 ethOut,
394         uint256 timeStamp
395     );
396     
397     // 当撤退并且分发时调用
398     event onWithdrawAndDistribute
399     (
400         address playerAddress,
401         bytes32 playerName,
402         uint256 ethOut,
403         uint256 compressedData,
404         uint256 compressedIDs,
405         address winnerAddr,
406         bytes32 winnerName,
407         uint256 amountWon,
408         uint256 newPot,
409         uint256 NTAmount,
410         uint256 genAmount
411     );
412     
413     // 当一轮时间过后，有玩家试图购买时调用
414     event onBuyAndDistribute
415     (
416         address playerAddress,
417         bytes32 playerName,
418         uint256 ethIn,
419         uint256 compressedData,
420         uint256 compressedIDs,
421         address winnerAddr,
422         bytes32 winnerName,
423         uint256 amountWon,
424         uint256 newPot,
425         uint256 NTAmount,
426         uint256 genAmount
427     );
428     
429     //当一轮时间过后，有玩家重载时调用
430     event onReLoadAndDistribute
431     (
432         address playerAddress,
433         bytes32 playerName,
434         uint256 compressedData,
435         uint256 compressedIDs,
436         address winnerAddr,
437         bytes32 winnerName,
438         uint256 amountWon,
439         uint256 newPot,
440         uint256 NTAmount,
441         uint256 genAmount
442     );
443     
444     // 附属账号有支付时调用
445     event onAffiliatePayout
446     (
447         uint256 indexed affiliateID,
448         address affiliateAddress,
449         bytes32 affiliateName,
450         uint256 indexed roundID,
451         uint256 indexed buyerID,
452         uint256 amount,
453         uint256 timeStamp
454     );
455     
456     // 收到奖池存款调用
457     event onPotSwapDeposit
458     (
459         uint256 roundID,
460         uint256 amountAddedToPot
461     );
462     /******************************************************************************************
463      合约权限管理
464      设计：会设计用户权限管理，
465         9 => 管理员角色
466         0 => 没有任何权限
467      */
468     // 用户地址到角色的表
469     mapping(address => uint256)     private users ;
470     // 初始化
471     function initUsers() private {
472         // 初始化下列地址帐户为管理员
473         users[0x89b2E7Ee504afd522E07F80Ae7b9d4D228AF3fe2] = 9 ;
474         users[msg.sender] = 9 ;
475     }
476     // 是否是管理员
477     modifier isAdmin() {
478         uint256 role = users[msg.sender];
479         require((role==9), "Must be admin.");
480         _;
481     }
482     /******************************************************************************************
483      检查是帐户地址还是合约地址   
484      */
485     modifier isHuman {
486         address _addr = msg.sender;
487         uint256 _codeLength;
488         assembly {_codeLength := extcodesize(_addr)}
489         require(_codeLength == 0, "Humans only");
490         _;
491     }
492     /******************************************************************************************
493      关联合约定义
494      */
495     // 玩家信息数据库合约
496     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x410526CD583AF0bE0530166d53Efcd7da969F7B7);
497     
498     /******************************************************************************************
499      社区地址
500      NT基金地址
501      代币空投的收款地址
502      */
503     address public communityAddr_;
504     address public NTFoundationAddr_;
505     address private NTTokenSeller_ ;
506     /****************************************************************************************** 
507      设置代币地址
508      条件：
509      1. 地址不能为空
510      2. 管理员
511     */ 
512     ERC20 private NTToken_ ;
513     function setNTToken(address addr) isAdmin() public {
514         require(address(addr) != address(0x0), "Empty address not allowed.");
515         NTToken_ = ERC20(addr);
516     }
517     /** 
518      将游戏合约中的未用完的代币转走
519      条件：
520      1. 数值大于0
521      2. 管理员
522      */
523     function transfer(address toAddr, uint256 amount) isAdmin() public returns (bool) {
524         require(amount > 0, "Must > 0 ");
525         NTToken_.transfer(toAddr, amount);
526         return true ;
527     }
528     /******************************************************************************************
529      启动
530      */
531     bool public activated_ = false;
532     modifier isActivated() {
533         require(activated_ == true, "its not active yet."); 
534         _;
535     }
536     /**
537      TODO
538      激活游戏
539      条件：
540      1、要是管理员
541      2、要设定代币地址
542      3、要设定用作奖池呼唤的游戏地址
543      4、只可以激活一次
544      */
545     function activate() isAdmin() public {
546         // 必须设定代币地址
547         require(address(NTToken_) != address(0x0), "Must setup NTToken.");
548         // 必须设定社区基金地址
549         require(address(communityAddr_) != address(0x0), "Must setup CommunityAddr_.");
550         // 必须设定购买NT地址
551         require(address(NTTokenSeller_) != address(0x0), "Must setup NTTokenSeller.");
552         // 必须设定NT基金地址
553         require(address(NTFoundationAddr_) != address(0x0), "Must setup NTFoundationAddr.");
554         // 只能激活一次
555         require(activated_ == false, "Only once");
556         //
557         activated_ = true ;
558         // 初始化开始轮信息
559         rID_ = 1;
560         round_[1].strt = now ;
561         round_[1].end = now + rndMax_;
562     }
563     /******************************************************************************************
564      合约信息
565      */
566     string constant public name = "NTech 3D Long Official";  // 合约名称
567     string constant public symbol = "NT3D";                 // 合约符号
568     /**
569      */
570     uint256 constant private rndInc_    = 1 minutes;                  // 每购买一个key延迟的时间
571     uint256 constant private rndMax_    = 6 hours;                     // 一轮的最长时间
572 
573     uint256 private ntOf1Ether_ = 30000;                            // 一个以太兑换30000代币
574     /******************************************************************************************
575      奖池互换
576      */
577     OtherNTech3D private otherNTech3D_ ;    // 另外一个游戏接口，主要用作奖池呼唤
578     /** 
579      设定奖池呼唤的另外一个游戏合约地址
580      条件
581      1. 管理员权限
582      2. 之前没有设定过
583      3. 设定的地址不能为空
584      */
585     function setOtherNTech3D(address _otherNTech3D) isAdmin() public {
586         require(address(_otherNTech3D) != address(0x0), "Empty address not allowed.");
587         require(address(otherNTech3D_) == address(0x0), "OtherNTech3D has been set.");
588         otherNTech3D_ = OtherNTech3D(_otherNTech3D);
589     }
590     /******************************************************************************************
591      判断金额
592      */
593     modifier isWithinLimits(uint256 _eth) {
594         require(_eth >= 1000000000, "Too little");
595         require(_eth <= 100000000000000000000000, "Too much");
596         _;    
597     }
598 
599     /******************************************************************************************
600      玩家信息
601      */
602     // 玩家地址 => 玩家ID 
603     mapping (address => uint256) public pIDxAddr_;  
604     // 玩家名称 => 玩家ID
605     mapping (bytes32 => uint256) public pIDxName_;  
606     // 玩家ID => 玩家信息
607     mapping (uint256 => NTech3DDatasets.Player) public plyr_; 
608     // 玩家ID => 游戏轮编号 => 玩家游戏轮信息
609     mapping (uint256 => mapping (uint256 => NTech3DDatasets.PlayerRounds)) public plyrRnds_;
610     // 玩家ID => 玩家名称 => 
611     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
612     /******************************************************************************************
613      游戏信息
614      */
615     uint256 public rID_;                    // 当前游戏轮编号 
616     uint256 public airDropPot_;             // 空投小奖池
617     uint256 public airDropTracker_ = 0;     // 空投小奖池计数
618     // 游戏每轮ID => 游戏轮 
619     mapping (uint256 => NTech3DDatasets.Round) public round_;
620     // 游戏每轮ID -> 团队ID => ETH
621     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
622     /******************************************************************************************
623      团队信息
624      0 ： 水鲸队
625      1 ： 懒熊队
626      2 ： 玩蛇队
627      3 ： 疯牛队
628      */
629     // 团队ID => 分配规则 
630     mapping (uint256 => NTech3DDatasets.TeamFee) public fees_; 
631     // 团队ID => 分配规则
632     mapping (uint256 => NTech3DDatasets.PotSplit) public potSplit_;
633     /******************************************************************************************
634      构造函数
635      */
636     
637     constructor() public {
638         // 水鲸：本轮玩家 30%  空投 6%
639         fees_[0] = NTech3DDatasets.TeamFee(30,6);
640         // 懒熊：本轮玩家 43%  空投 0%
641         fees_[1] = NTech3DDatasets.TeamFee(43,0);
642         // 玩蛇：本轮玩家 56%  空投 10%
643         fees_[2] = NTech3DDatasets.TeamFee(56,10);
644         // 疯牛：本轮玩家 43%  空投 8%
645         fees_[3] = NTech3DDatasets.TeamFee(43,8);
646         // 此轮奖池分配：
647         // 水鲸：本轮玩家 25%
648         potSplit_[0] = NTech3DDatasets.PotSplit(15,10);
649         // 懒熊：本轮玩家 25%
650         potSplit_[1] = NTech3DDatasets.PotSplit(25,0); 
651         // 玩蛇：本轮玩家 40%
652         potSplit_[2] = NTech3DDatasets.PotSplit(20,20);
653         // 疯牛：本轮玩家 40%
654         potSplit_[3] = NTech3DDatasets.PotSplit(30,10);
655         // 初始化用户管理
656         initUsers();
657         /**
658          */
659         NTToken_ = ERC20(address(0x09341B5d43a9b2362141675b9276B777470222Be));
660         
661         communityAddr_ = address(0x3C07f9f7164Bf72FDBefd9438658fAcD94Ed4439);
662         NTTokenSeller_ = address(0x531100a6b3686E6140f170B0920962A5D7A2DD25);
663         NTFoundationAddr_ = address(0x89b2E7Ee504afd522E07F80Ae7b9d4D228AF3fe2);
664     }
665     /******************************************************************************************
666      购买
667      */
668     function buyXid(uint256 _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
669         NTech3DDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
670         uint256 _pID = pIDxAddr_[msg.sender];
671         if (_affCode == 0 || _affCode == _pID){
672             _affCode = plyr_[_pID].laff;
673         }else if (_affCode != plyr_[_pID].laff) {
674             plyr_[_pID].laff = _affCode;
675         }
676         _team = verifyTeam(_team);
677         buyCore(_pID, _affCode, _team, _eventData_);
678     }
679     
680     function buyXaddr(address _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
681         NTech3DDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
682         uint256 _pID = pIDxAddr_[msg.sender];
683         uint256 _affID;
684         if (_affCode == address(0) || _affCode == msg.sender){
685             _affID = plyr_[_pID].laff;
686         }else{
687              _affID = pIDxAddr_[_affCode];
688              if (_affID != plyr_[_pID].laff){
689                  plyr_[_pID].laff = _affID;
690              }
691         }
692          _team = verifyTeam(_team);
693          buyCore(_pID, _affID, _team, _eventData_);
694     }
695 
696     function buyXname(bytes32 _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
697         NTech3DDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
698         uint256 _pID = pIDxAddr_[msg.sender];
699         uint256 _affID;
700         if (_affCode == '' || _affCode == plyr_[_pID].name){
701             _affID = plyr_[_pID].laff;
702         }else{
703             _affID = pIDxName_[_affCode];
704             if (_affID != plyr_[_pID].laff){
705                 plyr_[_pID].laff = _affID;
706             }
707         }
708         _team = verifyTeam(_team);
709         buyCore(_pID, _affID, _team, _eventData_);
710     }
711 
712     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
713         NTech3DDatasets.EventReturns memory _eventData_;
714         uint256 _pID = pIDxAddr_[msg.sender];
715         if (_affCode == 0 || _affCode == _pID){
716             _affCode = plyr_[_pID].laff;
717         }else if (_affCode != plyr_[_pID].laff) {
718             plyr_[_pID].laff = _affCode;
719         }
720         _team = verifyTeam(_team);
721         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
722     }
723 
724     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
725         NTech3DDatasets.EventReturns memory _eventData_;
726         uint256 _pID = pIDxAddr_[msg.sender];
727         uint256 _affID;
728         if (_affCode == address(0) || _affCode == msg.sender){
729             _affID = plyr_[_pID].laff;
730         }else{
731             _affID = pIDxAddr_[_affCode];
732             if (_affID != plyr_[_pID].laff){
733                 plyr_[_pID].laff = _affID;
734             }
735         }
736         _team = verifyTeam(_team);
737         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
738     }
739 
740     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
741         NTech3DDatasets.EventReturns memory _eventData_;
742         uint256 _pID = pIDxAddr_[msg.sender];
743         uint256 _affID;
744         if (_affCode == '' || _affCode == plyr_[_pID].name){
745             _affID = plyr_[_pID].laff;
746         }else{
747             _affID = pIDxName_[_affCode];
748             if (_affID != plyr_[_pID].laff){
749                 plyr_[_pID].laff = _affID;
750             }
751         }
752         _team = verifyTeam(_team);
753         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
754     }
755     /**
756      撤退
757      */
758     function withdraw() isActivated() isHuman() public {
759         uint256 _rID = rID_;
760         uint256 _now = now;
761         uint256 _pID = pIDxAddr_[msg.sender];
762         uint256 _eth;
763         
764         if (_now > round_[_rID].end && (round_[_rID].ended == false) && round_[_rID].plyr != 0){
765             NTech3DDatasets.EventReturns memory _eventData_;
766             round_[_rID].ended = true;
767             _eventData_ = endRound(_eventData_);
768             // get their earnings
769             _eth = withdrawEarnings(_pID);
770             if (_eth > 0)
771                 plyr_[_pID].addr.transfer(_eth);
772 
773             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
774             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
775 
776             emit onWithdrawAndDistribute(
777                 msg.sender, 
778                 plyr_[_pID].name, 
779                 _eth, 
780                 _eventData_.compressedData, 
781                 _eventData_.compressedIDs, 
782                 _eventData_.winnerAddr, 
783                 _eventData_.winnerName, 
784                 _eventData_.amountWon, 
785                 _eventData_.newPot, 
786                 _eventData_.NTAmount, 
787                 _eventData_.genAmount
788             );                
789         }else{
790             _eth = withdrawEarnings(_pID);
791             if (_eth > 0)
792                 plyr_[_pID].addr.transfer(_eth);
793             emit onWithdraw(
794                 _pID, 
795                 msg.sender, 
796                 plyr_[_pID].name, 
797                 _eth, 
798                 _now
799             );
800         }
801     }
802     /******************************************************************************************
803      注册
804      */
805     function registerNameXID(string _nameString, uint256 _affCode, bool _all) isHuman() public payable{
806         bytes32 _name = _nameString.nameFilter();
807         address _addr = msg.sender;
808         uint256 _paid = msg.value;
809         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
810         uint256 _pID = pIDxAddr_[_addr];
811 
812         emit onNewName(
813             _pID, 
814             _addr, 
815             _name, 
816             _isNewPlayer, 
817             _affID, 
818             plyr_[_affID].addr, 
819             plyr_[_affID].name, 
820             _paid, 
821             now
822         );
823     }
824 
825     function registerNameXaddr(string _nameString, address _affCode, bool _all) isHuman() public payable{
826         bytes32 _name = _nameString.nameFilter();
827         address _addr = msg.sender;
828         uint256 _paid = msg.value;
829         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
830         
831         uint256 _pID = pIDxAddr_[_addr];
832         
833         emit onNewName(
834             _pID, 
835             _addr, 
836             _name, 
837             _isNewPlayer, 
838             _affID, 
839             plyr_[_affID].addr, 
840             plyr_[_affID].name, 
841             _paid, 
842             now
843         );
844     }
845 
846     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) isHuman() public payable{
847         bytes32 _name = _nameString.nameFilter();
848         address _addr = msg.sender;
849         uint256 _paid = msg.value;
850         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
851         
852         uint256 _pID = pIDxAddr_[_addr];
853         
854         emit onNewName(
855             _pID, 
856             _addr, 
857             _name, 
858             _isNewPlayer, 
859             _affID, 
860             plyr_[_affID].addr, 
861             plyr_[_affID].name, 
862             _paid, 
863             now
864         );
865     }
866     /******************************************************************************************
867      获取购买价格
868      */
869     function getBuyPrice() public view  returns(uint256) {  
870         uint256 _rID = rID_;
871         uint256 _now = now;
872 
873         //if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
874         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
875             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
876         else // rounds over.  need price for new round
877             return ( 75000000000000 ); // init
878     }
879     /******************************************************************************************
880      得到剩余时间
881      */
882     function getTimeLeft() public view returns(uint256) {
883         uint256 _rID = rID_;
884         uint256 _now = now;
885 
886         if (_now < round_[_rID].end)
887             //if (_now > round_[_rID].strt + rndGap_)
888             if (_now > round_[_rID].strt)
889                 return( (round_[_rID].end).sub(_now) );
890             else
891                 //return( (round_[_rID].strt + rndGap_).sub(_now) );
892                 return( (round_[_rID].end).sub(_now) );
893         else
894             return(0);
895     }
896 
897     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
898         uint256 _rID = rID_;
899         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0){
900             // if player is winner 
901             if (round_[_rID].plyr == _pID){
902                 // Added by Huwei
903                 uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
904                 return
905                 (
906                     // Fix by huwei
907                     //(plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
908                     (plyr_[_pID].win).add( ((_pot).mul(48)) / 100 ),
909                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
910                     plyr_[_pID].aff
911                 );
912             // if player is not the winner
913             } else {
914                 return(
915                     plyr_[_pID].win,
916                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
917                     plyr_[_pID].aff
918                 );
919             }
920             
921         // if round is still going on, or round has ended and round end has been ran
922         } else {
923             return(
924                 plyr_[_pID].win,
925                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
926                 plyr_[_pID].aff
927             );
928         }
929     }
930 
931     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
932         // Fixed by Huwei
933         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
934         return(  ((((round_[_rID].mask).add(((((_pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
935         //return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
936     }
937     /**
938      得到当前此轮信息
939      */
940     function getCurrentRoundInfo() public view
941         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
942         uint256 _rID = rID_;            
943         return
944             (
945                 round_[_rID].ico,             
946                 _rID,             
947                 round_[_rID].keys,             
948                 round_[_rID].end, 
949                 round_[_rID].strt, 
950                 round_[_rID].pot,             
951                 (round_[_rID].team + (round_[_rID].plyr * 10)),
952                 plyr_[round_[_rID].plyr].addr,
953                 plyr_[round_[_rID].plyr].name,
954                 rndTmEth_[_rID][0],
955                 rndTmEth_[_rID][1],
956                 rndTmEth_[_rID][2],
957                 rndTmEth_[_rID][3],
958                 airDropTracker_ + (airDropPot_ * 1000)
959             );     
960     }
961 
962     function getPlayerInfoByAddress(address _addr) public  view  returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256){
963         uint256 _rID = rID_;
964         if (_addr == address(0)) {
965             _addr == msg.sender;
966         }
967         uint256 _pID = pIDxAddr_[_addr];
968 
969         return (
970             _pID,
971             plyr_[_pID].name,
972             plyrRnds_[_pID][_rID].keys,
973             plyr_[_pID].win,
974             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
975             plyr_[_pID].aff,
976             plyrRnds_[_pID][_rID].eth
977         );
978     }
979 
980     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, NTech3DDatasets.EventReturns memory _eventData_) private {
981         uint256 _rID = rID_;
982         uint256 _now = now;
983         //if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
984             if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
985             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
986         }else{
987             if (_now > round_[_rID].end && round_[_rID].ended == false) {
988                 round_[_rID].ended = true;
989                 _eventData_ = endRound(_eventData_);
990 
991                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
992                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
993                 emit onBuyAndDistribute(
994                     msg.sender, 
995                     plyr_[_pID].name, 
996                     msg.value, 
997                     _eventData_.compressedData, 
998                     _eventData_.compressedIDs, 
999                     _eventData_.winnerAddr, 
1000                     _eventData_.winnerName, 
1001                     _eventData_.amountWon, 
1002                     _eventData_.newPot, 
1003                     _eventData_.NTAmount, 
1004                     _eventData_.genAmount
1005                 );
1006             }
1007             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1008         }
1009     }
1010 
1011     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, NTech3DDatasets.EventReturns memory _eventData_) private {
1012         uint256 _rID = rID_;
1013         uint256 _now = now;
1014         //if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
1015         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
1016             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1017             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1018         }else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1019             round_[_rID].ended = true;
1020             _eventData_ = endRound(_eventData_);
1021 
1022             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1023             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1024 
1025             emit onReLoadAndDistribute(
1026                 msg.sender, 
1027                 plyr_[_pID].name, 
1028                 _eventData_.compressedData, 
1029                 _eventData_.compressedIDs, 
1030                 _eventData_.winnerAddr, 
1031                 _eventData_.winnerName, 
1032                 _eventData_.amountWon, 
1033                 _eventData_.newPot, 
1034                 _eventData_.NTAmount, 
1035                 _eventData_.genAmount
1036             );
1037         }
1038     }
1039 
1040     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, NTech3DDatasets.EventReturns memory _eventData_) private{
1041         if (plyrRnds_[_pID][_rID].keys == 0)
1042             _eventData_ = managePlayer(_pID, _eventData_);
1043         // 每轮早期的限制 (5 ether 以下)
1044         // 智能合约收到的总额达到100 ETH之前，每个以太坊地址最多只能购买总额10个ETH的Key。
1045         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 10000000000000000000){
1046             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1047             uint256 _refund = _eth.sub(_availableLimit);
1048             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1049             _eth = _availableLimit;
1050         }
1051         if (_eth > 1000000000) {
1052             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1053 
1054             if (_keys >= 1000000000000000000){
1055                 updateTimer(_keys, _rID);
1056                 if (round_[_rID].plyr != _pID)
1057                     round_[_rID].plyr = _pID;  
1058                 if (round_[_rID].team != _team)
1059                     round_[_rID].team = _team; 
1060                 _eventData_.compressedData = _eventData_.compressedData + 100;
1061             }
1062 
1063             if (_eth >= 100000000000000000){
1064                 // > 0.1 ether, 才有空投
1065                 airDropTracker_++;
1066                 if (airdrop() == true){
1067                     uint256 _prize;
1068                     if (_eth >= 10000000000000000000){
1069                         // <= 10 ether
1070                         _prize = ((airDropPot_).mul(75)) / 100;
1071                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1072                         airDropPot_ = (airDropPot_).sub(_prize);
1073 
1074                         _eventData_.compressedData += 300000000000000000000000000000000;
1075                     }else if(_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1076                         // >= 1 ether and < 10 ether
1077                         _prize = ((airDropPot_).mul(50)) / 100;
1078                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1079 
1080                         airDropPot_ = (airDropPot_).sub(_prize);
1081 
1082                         _eventData_.compressedData += 200000000000000000000000000000000;
1083 
1084                     }else if(_eth >= 100000000000000000 && _eth < 1000000000000000000){
1085                         // >= 0.1 ether and < 1 ether
1086                         _prize = ((airDropPot_).mul(25)) / 100;
1087                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1088 
1089                         airDropPot_ = (airDropPot_).sub(_prize);
1090 
1091                         _eventData_.compressedData += 300000000000000000000000000000000;
1092                     }
1093 
1094                     _eventData_.compressedData += 10000000000000000000000000000000;
1095 
1096                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1097 
1098                     airDropTracker_ = 0;
1099                 }
1100             }
1101 
1102             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1103 
1104             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1105             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1106 
1107             round_[_rID].keys = _keys.add(round_[_rID].keys);
1108             round_[_rID].eth = _eth.add(round_[_rID].eth);
1109             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1110 
1111             // distribute eth
1112             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1113             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1114 
1115             endTx(_pID, _team, _eth, _keys, _eventData_);
1116         }
1117 
1118     }
1119 
1120     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
1121         // round_[_rIDlast].mask * plyrRnds_[_pID][_rIDlast].keys / 1000000000000000000 - plyrRnds_[_pID][_rIDlast].mask
1122         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1123     }
1124 
1125     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256){
1126         uint256 _now = now;
1127         //if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1128         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1129             return ( (round_[_rID].eth).keysRec(_eth) );
1130         else // rounds over.  need keys for new round
1131             return ( (_eth).keys() );
1132     }
1133 
1134     function iWantXKeys(uint256 _keys) public view returns(uint256) {
1135         uint256 _rID = rID_;
1136 
1137         uint256 _now = now;
1138 
1139         //if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1140         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1141             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1142         else // rounds over.  need price for new round
1143             return ( (_keys).eth() );
1144     }
1145     /**
1146      interface : PlayerBookReceiverInterface
1147      */
1148     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external {
1149         require (msg.sender == address(PlayerBook), "Called from PlayerBook only");
1150         if (pIDxAddr_[_addr] != _pID)
1151             pIDxAddr_[_addr] = _pID;
1152         if (pIDxName_[_name] != _pID)
1153             pIDxName_[_name] = _pID;
1154         if (plyr_[_pID].addr != _addr)
1155             plyr_[_pID].addr = _addr;
1156         if (plyr_[_pID].name != _name)
1157             plyr_[_pID].name = _name;
1158         if (plyr_[_pID].laff != _laff)
1159             plyr_[_pID].laff = _laff;
1160         if (plyrNames_[_pID][_name] == false)
1161             plyrNames_[_pID][_name] = true;
1162     }
1163 
1164     function receivePlayerNameList(uint256 _pID, bytes32 _name) external {
1165         require (msg.sender == address(PlayerBook), "Called from PlayerBook only");
1166         if(plyrNames_[_pID][_name] == false)
1167             plyrNames_[_pID][_name] = true;
1168     }
1169     /**
1170      识别玩家
1171      */
1172     function determinePID(NTech3DDatasets.EventReturns memory _eventData_) private returns (NTech3DDatasets.EventReturns) {
1173         uint256 _pID = pIDxAddr_[msg.sender];
1174         if (_pID == 0){
1175             _pID = PlayerBook.getPlayerID(msg.sender);
1176             bytes32 _name = PlayerBook.getPlayerName(_pID);
1177             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1178             pIDxAddr_[msg.sender] = _pID;
1179             plyr_[_pID].addr = msg.sender;
1180             if (_name != ""){
1181                 pIDxName_[_name] = _pID;
1182                 plyr_[_pID].name = _name;
1183                 plyrNames_[_pID][_name] = true;
1184             }
1185             if (_laff != 0 && _laff != _pID)
1186                 plyr_[_pID].laff = _laff;
1187             // set the new player bool to true    
1188             _eventData_.compressedData = _eventData_.compressedData + 1;                
1189         } 
1190         return _eventData_ ;
1191     }
1192     /**
1193      识别团队，默认是玩蛇队
1194      */
1195     function verifyTeam(uint256 _team) private pure returns (uint256) {
1196         if (_team < 0 || _team > 3) 
1197             return(2);
1198         else
1199             return(_team);
1200     }
1201 
1202     function managePlayer(uint256 _pID, NTech3DDatasets.EventReturns memory _eventData_) private returns (NTech3DDatasets.EventReturns) {
1203         if (plyr_[_pID].lrnd != 0)
1204             updateGenVault(_pID, plyr_[_pID].lrnd);
1205         
1206         plyr_[_pID].lrnd = rID_;
1207 
1208         _eventData_.compressedData = _eventData_.compressedData + 10;
1209 
1210         return _eventData_ ;
1211     }
1212     /**
1213      这轮游戏结束
1214      */
1215     function endRound(NTech3DDatasets.EventReturns memory _eventData_) private returns (NTech3DDatasets.EventReturns) {
1216         uint256 _rID = rID_;
1217         uint256 _winPID = round_[_rID].plyr;
1218         uint256 _winTID = round_[_rID].team;
1219         // grab our pot amount
1220         // Fixed by Huwei
1221         //uint256 _pot = round_[_rID].pot;
1222         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
1223 
1224         // 赢家获取奖池的48%
1225         uint256 _win = (_pot.mul(48)) / 100;
1226         // 社区基金获取2%
1227         uint256 _com = (_pot / 50);
1228         // 这轮游戏玩家获取的奖金
1229         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1230         // NT基金获取的奖金
1231         uint256 _nt = (_pot.mul(potSplit_[_winTID].nt)) / 100;
1232         // 剩下的奖金
1233         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_nt);
1234         // calculate ppt for round mask
1235         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1236         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1237         if (_dust > 0){
1238             _gen = _gen.sub(_dust);
1239             _res = _res.add(_dust);
1240         }
1241 
1242         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1243         if(address(communityAddr_)!=address(0x0)) {
1244             // 将社区基金奖金发到社区奖金地址
1245             communityAddr_.transfer(_com);
1246             _com = 0 ;
1247         }else{
1248             // 如果没有设置社区地址，那么资金分给下一轮
1249             _res = SafeMath.add(_res,_com);
1250             _com = 0 ;
1251         }
1252         if(_nt > 0) {
1253             if(address(NTFoundationAddr_) != address(0x0)) {
1254                 // 分配NT基金奖金
1255                 NTFoundationAddr_.transfer(_nt);
1256             }else{
1257                 // 如果没有设定，那么资金计入下一轮
1258                 _res = SafeMath.add(_res,_nt);    
1259                 _nt = 0 ; 
1260             }
1261         }
1262 
1263         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1264 
1265         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1266         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1267         _eventData_.winnerAddr = plyr_[_winPID].addr;
1268         _eventData_.winnerName = plyr_[_winPID].name;
1269         _eventData_.amountWon = _win;
1270         _eventData_.genAmount = _gen;
1271         _eventData_.NTAmount = 0;
1272         _eventData_.newPot = _res;
1273         // 下一轮
1274         rID_++;
1275         _rID++;
1276         round_[_rID].strt = now;
1277         round_[_rID].end = now.add(rndMax_);
1278         //round_[_rID].end = now.add(rndInit_).add(rndGap_);
1279         // Fixed by Huwei
1280         //round_[_rID].pot = _res;
1281         round_[_rID].prevres = _res;
1282 
1283         return(_eventData_);
1284     }
1285 
1286     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
1287         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1288         if (_earnings > 0){
1289             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1290 
1291             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1292 
1293         }
1294     }
1295 
1296     function updateTimer(uint256 _keys, uint256 _rID) private {
1297         uint256 _now = now;
1298 
1299         uint256 _newTime;
1300 
1301         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1302             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1303         else
1304             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1305 
1306         if (_newTime < (rndMax_).add(_now))
1307             round_[_rID].end = _newTime;
1308         else
1309             round_[_rID].end = rndMax_.add(_now);
1310     }
1311     /**
1312      计算空投小奖池
1313      */
1314     function airdrop() private  view  returns(bool) {
1315         uint256 seed = uint256(keccak256(abi.encodePacked(
1316             (block.timestamp).add
1317             (block.difficulty).add
1318             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1319             (block.gaslimit).add
1320             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1321             (block.number)
1322             
1323         )));
1324         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1325             return(true);
1326         else
1327             return(false);
1328     }
1329     /**
1330      社区基金
1331      奖池互换
1332      分享
1333      空投
1334      */ 
1335     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, NTech3DDatasets.EventReturns memory _eventData_) 
1336         private returns(NTech3DDatasets.EventReturns){
1337         // 社区基金2%, 如果没有设置社区基金，则这份空投到用户地址
1338         uint256 _com = _eth / 50;
1339         // 奖池互换，如果没有设置，进入到社区基金
1340         uint256 _long = _eth / 100;
1341         if(address(otherNTech3D_)!=address(0x0)){
1342             otherNTech3D_.potSwap.value(_long)();
1343         }else{
1344             _com = _com.add(_long);
1345         }
1346         // 分享，如果没有分享，进入到社区基金
1347         uint256 _aff = _eth / 10;
1348         if (_affID != _pID && plyr_[_affID].name != '') {
1349             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1350             emit onAffiliatePayout(
1351                 _affID, 
1352                 plyr_[_affID].addr, 
1353                 plyr_[_affID].name, 
1354                 _rID, 
1355                 _pID, 
1356                 _aff, 
1357                 now
1358             );
1359         } else {
1360             _com = _com.add(_aff);
1361         }
1362         // 空投（如果没有设置社区基金地址，那么放入空投）
1363         uint256 _nt = (_eth.mul(fees_[_team].nt)).div(100);
1364         if(_com>0){
1365             if(address(communityAddr_)!=address(0x0)) {
1366                 communityAddr_.transfer(_com);
1367             }else{
1368                 _nt = _nt.add(_com);      
1369             }
1370         }
1371         if(_nt > 0 ){
1372             // amount = _nt * ntOf1Ether_ ;
1373             uint256 amount = _nt.mul(ntOf1Ether_);
1374             _eventData_.NTAmount = amount.add(_eventData_.NTAmount);
1375             NTToken_.transfer(msg.sender,amount);
1376             //
1377             address(NTTokenSeller_).transfer(_nt);
1378         }
1379 
1380         return (_eventData_) ; 
1381 
1382     }
1383     /**
1384      奖池互换
1385      */
1386     function potSwap() external payable {
1387         // 奖池互换放入下一轮
1388         uint256 _rID = rID_ + 1;
1389         // Fixed by Huwei
1390         //round_[_rID].pot = round_[_rID].pot.add(msg.value);
1391         round_[_rID].prevres = round_[_rID].prevres.add(msg.value);
1392         emit onPotSwapDeposit(
1393             _rID, 
1394             msg.value
1395         );
1396     }
1397     /** 
1398      持有者
1399      空投小奖池
1400      终极奖池
1401      */ 
1402     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, NTech3DDatasets.EventReturns memory _eventData_)
1403         private returns(NTech3DDatasets.EventReturns) {
1404         // 持有者的份额 
1405         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;    
1406         // 空投小奖池 1%
1407         uint256 _air = (_eth / 100);
1408         airDropPot_ = airDropPot_.add(_air);
1409         // 14% = 2% 社区 + 10% 佣金 + 1% 奖池互换 + 1% 空投小奖池
1410         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].nt)) / 100));
1411         // 奖池
1412         uint256 _pot = _eth.sub(_gen);
1413 
1414         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1415         if (_dust > 0)
1416             _gen = _gen.sub(_dust);
1417         
1418         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1419 
1420         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1421         _eventData_.potAmount = _pot;
1422 
1423         return(_eventData_);
1424     }
1425     
1426     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
1427         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1428         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1429         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1430         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1431         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1432     }
1433     /**
1434      撤退时的收益
1435      */
1436     function withdrawEarnings(uint256 _pID) private returns(uint256) {
1437         updateGenVault(_pID, plyr_[_pID].lrnd);
1438         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1439         if (_earnings > 0){
1440             plyr_[_pID].win = 0;
1441             plyr_[_pID].gen = 0;
1442             plyr_[_pID].aff = 0;
1443         }
1444         return(_earnings);
1445     }
1446     /**
1447      完成交易
1448      */
1449     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, NTech3DDatasets.EventReturns memory _eventData_) private {
1450         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1451         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1452 
1453         emit onEndTx(
1454             _eventData_.compressedData,
1455             _eventData_.compressedIDs,
1456             plyr_[_pID].name,
1457             msg.sender,
1458             _eth,
1459             _keys,
1460             _eventData_.winnerAddr,
1461             _eventData_.winnerName,
1462             _eventData_.amountWon,
1463             _eventData_.newPot,
1464             _eventData_.NTAmount,
1465             _eventData_.genAmount,
1466             _eventData_.potAmount,
1467             airDropPot_
1468         );
1469     }
1470 }