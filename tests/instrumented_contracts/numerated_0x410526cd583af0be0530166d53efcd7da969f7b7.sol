1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath v0.1.9
5  * @dev Math operations with safety checks that throw on error
6  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
7  * - added sqrt
8  * - added sq
9  * - added pwr 
10  * - changed asserts to requires with error log outputs
11  * - removed div, its useless
12  */
13  
14 library SafeMath {
15     
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) 
20         internal 
21         pure 
22         returns (uint256 c) 
23     {
24         if (a == 0) {
25             return 0;
26         }
27         c = a * b;
28         require(c / a == b, "SafeMath mul failed");
29         return c;
30     }
31 
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return c;
40     }
41     
42     /**
43     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b)
46         internal
47         pure
48         returns (uint256) 
49     {
50         require(b <= a, "SafeMath sub failed");
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b)
58         internal
59         pure
60         returns (uint256 c) 
61     {
62         c = a + b;
63         require(c >= a, "SafeMath add failed");
64         return c;
65     }
66     
67     /**
68      * @dev gives square root of given x.
69      */
70     function sqrt(uint256 x)
71         internal
72         pure
73         returns (uint256 y) 
74     {
75         uint256 z = ((add(x,1)) / 2);
76         y = x;
77         while (z < y) 
78         {
79             y = z;
80             z = ((add((x / z),z)) / 2);
81         }
82     }
83     
84     /**
85      * @dev gives square. multiplies x by x
86      */
87     function sq(uint256 x)
88         internal
89         pure
90         returns (uint256)
91     {
92         return (mul(x,x));
93     }
94     
95     /**
96      * @dev x to the power of y 
97      */
98     function pwr(uint256 x, uint256 y)
99         internal 
100         pure 
101         returns (uint256)
102     {
103         if (x==0)
104             return (0);
105         else if (y==0)
106             return (1);
107         else 
108         {
109             uint256 z = x;
110             for (uint256 i=1; i < y; i++)
111                 z = mul(z,x);
112             return (z);
113         }
114     }
115 }
116 /*
117  * NameFilter library
118  */
119 library NameFilter {
120     /**
121      * @dev filters name strings
122      * -converts uppercase to lower case.  
123      * -makes sure it does not start/end with a space
124      * -makes sure it does not contain multiple spaces in a row
125      * -cannot be only numbers
126      * -cannot start with 0x 
127      * -restricts characters to A-Z, a-z, 0-9, and space.
128      * @return reprocessed string in bytes32 format
129      */
130     function nameFilter(string _input)
131         internal
132         pure
133         returns(bytes32)
134     {
135         bytes memory _temp = bytes(_input);
136         uint256 _length = _temp.length;
137         
138         //sorry limited to 32 characters
139         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
140         // make sure it doesnt start with or end with space
141         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
142         // make sure first two characters are not 0x
143         if (_temp[0] == 0x30)
144         {
145             require(_temp[1] != 0x78, "string cannot start with 0x");
146             require(_temp[1] != 0x58, "string cannot start with 0X");
147         }
148         
149         // create a bool to track if we have a non number character
150         bool _hasNonNumber;
151         
152         // convert & check
153         for (uint256 i = 0; i < _length; i++)
154         {
155             // if its uppercase A-Z
156             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
157             {
158                 // convert to lower case a-z
159                 _temp[i] = byte(uint(_temp[i]) + 32);
160                 
161                 // we have a non number
162                 if (_hasNonNumber == false)
163                     _hasNonNumber = true;
164             } else {
165                 require
166                 (
167                     // require character is a space
168                     _temp[i] == 0x20 || 
169                     // OR lowercase a-z
170                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
171                     // or 0-9
172                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
173                     "string contains invalid characters"
174                 );
175                 // make sure theres not 2x spaces in a row
176                 if (_temp[i] == 0x20)
177                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
178                 
179                 // see if we have a character other than a number
180                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
181                     _hasNonNumber = true;    
182             }
183         }
184         
185         require(_hasNonNumber == true, "string cannot be only numbers");
186         
187         bytes32 _ret;
188         assembly {
189             _ret := mload(add(_temp, 32))
190         }
191         return (_ret);
192     }
193 }
194 
195 /**
196  interface : PlayerBookReceiverInterface
197  */
198 interface PlayerBookReceiverInterface {
199     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
200     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
201 }
202 
203 /**
204  contract : PlayerBook
205  */
206 contract PlayerBook{
207     /****************************************************************************************** 
208      导入的库
209      */
210     using SafeMath for *;
211     using NameFilter for string;
212     /******************************************************************************************
213      社区地址
214      */
215     address public communityAddr;
216     function initCommunityAddr(address addr) isAdmin() public {
217         require(address(addr) != address(0x0), "Empty address not allowed.");
218         require(address(communityAddr) == address(0x0), "Community address has been set.");
219         communityAddr = addr ;
220     }
221     /******************************************************************************************
222      合约权限管理
223      设计：会设计用户权限管理，
224         9 => 管理员角色
225         0 => 没有任何权限
226      */
227 
228     // 用户地址到角色的表
229     mapping(address => uint256)     private users ;
230     // 初始化
231     function initUsers() private {
232         // 初始化下列地址帐户为管理员
233         users[0x89b2E7Ee504afd522E07F80Ae7b9d4D228AF3fe2] = 9 ;
234         users[msg.sender] = 9 ;
235     }
236     // 是否是管理员
237     modifier isAdmin() {
238         uint256 role = users[msg.sender];
239         require((role==9), "Must be admin.");
240         _;
241     }
242     /******************************************************************************************
243      检查是帐户地址还是合约地址   
244      */
245     modifier isHuman {
246         address _addr = msg.sender;
247         uint256 _codeLength;
248         assembly {_codeLength := extcodesize(_addr)}
249         require(_codeLength == 0, "Humans only");
250         _;
251     }
252     /****************************************************************************************** 
253      事件定义
254      */
255     event onNewName
256     (
257         uint256 indexed playerID,
258         address indexed playerAddress,
259         bytes32 indexed playerName,
260         bool isNewPlayer,
261         uint256 affiliateID,
262         address affiliateAddress,
263         bytes32 affiliateName,
264         uint256 amountPaid,
265         uint256 timeStamp
266     );
267     // 注册玩家信息
268     struct Player {
269         address addr;
270         bytes32 name;
271         uint256 laff;
272         uint256 names;
273     }
274     /******************************************************************************************  
275      注册费用：初始为 0.01 ether
276      条件：
277      1. 必须是管理员才可以更新
278      */
279     uint256 public registrationFee_ = 10 finney; 
280     function setRegistrationFee(uint256 _fee) isAdmin() public {
281         registrationFee_ = _fee ;
282     }
283     /******************************************************************************************
284      注册游戏
285      */
286     // 注册的游戏列表
287     mapping(uint256 => PlayerBookReceiverInterface) public games_;
288     // 注册的游戏名称列表
289     mapping(address => bytes32) public gameNames_;
290     // 注册的游戏ID列表
291     mapping(address => uint256) public gameIDs_;
292     // 游戏数目
293     uint256 public gID_;
294     // 判断是否是注册游戏
295     modifier isRegisteredGame() {
296         require(gameIDs_[msg.sender] != 0);
297         _;
298     }
299     /****************************************************************************************** 
300      新增游戏
301      条件：
302      1. 游戏不存在
303      */
304     function addGame(address _gameAddress, string _gameNameStr) isAdmin() public {
305         require(gameIDs_[_gameAddress] == 0, "Game already registered");
306         gID_++;
307         bytes32 _name = _gameNameStr.nameFilter();
308         gameIDs_[_gameAddress] = gID_;
309         gameNames_[_gameAddress] = _name;
310         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
311     }
312     /****************************************************************************************** 
313      玩家信息
314      */
315     // 玩家数目
316     uint256 public pID_;
317     // 玩家地址=>玩家ID
318     mapping (address => uint256) public pIDxAddr_;
319     // 玩家名称=>玩家ID
320     mapping (bytes32 => uint256) public pIDxName_;  
321     // 玩家ID => 玩家数据
322     mapping (uint256 => Player) public plyr_; 
323     // 玩家ID => 玩家名称 => 
324     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
325     // 玩家ID => 名称编号 => 玩家名称
326     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; 
327     /******************************************************************************************
328      初始玩家 
329      */
330      function initPlayers() private {
331         pID_ = 0;
332      }
333     /******************************************************************************************
334      判断玩家名字是否有效（是否已经注册过）
335      */
336     function checkIfNameValid(string _nameStr) public view returns(bool){
337         bytes32 _name = _nameStr.nameFilter();
338         if (pIDxName_[_name] == 0) return (true);
339         else return (false);
340     }
341     /******************************************************************************************
342      构造函数
343      */
344     constructor() public {
345         // 初始化用户
346         initUsers() ;
347         // 初始化玩家
348         initPlayers();
349         // 初始化社区基金地址
350         communityAddr = address(0x3C07f9f7164Bf72FDBefd9438658fAcD94Ed4439);
351 
352     }
353     /******************************************************************************************
354      注册名字
355      _nameString: 名字
356      _affCode：推荐人编号
357      _all：是否是注册到所有游戏中
358      条件：
359      1. 是账户地址
360      2. 要付费
361      */
362     function registerNameXID(string _nameString, uint256 _affCode, bool _all) isHuman() public payable{
363         // 要求注册费用,不需要付费
364         //require (msg.value >= registrationFee_, "You have to pay the name fee");
365 
366         bytes32 _name = NameFilter.nameFilter(_nameString);
367         address _addr = msg.sender;
368         bool _isNewPlayer = determinePID(_addr);
369         uint256 _pID = pIDxAddr_[_addr];
370         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
371             plyr_[_pID].laff = _affCode;
372         }else{
373             _affCode = 0;
374         }
375         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
376     }
377     /**
378      注册名字
379      _nameString: 名字
380      _affCode：推荐人地址
381      _all：是否是注册到所有游戏中
382      条件：
383      1. 是账户地址
384      2. 要付费
385      */
386     function registerNameXaddr(string _nameString, address _affCode, bool _all) isHuman() public payable{
387         // 要求注册费用,不需要付费
388         //require (msg.value >= registrationFee_, "You have to pay the name fee");
389         
390         bytes32 _name = NameFilter.nameFilter(_nameString);
391         address _addr = msg.sender;
392         bool _isNewPlayer = determinePID(_addr);
393         uint256 _pID = pIDxAddr_[_addr];
394         uint256 _affID;
395         if (_affCode != address(0) && _affCode != _addr){
396             _affID = pIDxAddr_[_affCode];
397             if (_affID != plyr_[_pID].laff){
398                 plyr_[_pID].laff = _affID;
399             }
400         }
401         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
402     }
403     /**
404      注册名字
405      _nameString: 名字
406      _affCode：推荐人名称
407      _all：是否是注册到所有游戏中
408      条件：
409      1. 是账户地址
410      2. 要付费
411      */
412     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) isHuman() public payable{
413         // 要求注册费用,不需要付费
414         //require (msg.value >= registrationFee_, "You have to pay the name fee");
415         
416         bytes32 _name = NameFilter.nameFilter(_nameString);
417         address _addr = msg.sender;
418         bool _isNewPlayer = determinePID(_addr);
419         uint256 _pID = pIDxAddr_[_addr];
420         uint256 _affID;
421         if (_affCode != "" && _affCode != _name){
422             _affID = pIDxName_[_affCode];
423             if (_affID != plyr_[_pID].laff){
424                 plyr_[_pID].laff = _affID;
425             }
426         }
427         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
428     }
429 
430     /**
431      注册
432      _pID:          玩家编号
433      _addr:         玩家地址
434      _affID:        从属
435      _name:         名称
436     _isNewPlayer:   是否是新玩家
437     _all:           是否注册到所有游戏
438      */
439     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all) private {
440         // 判断是否已经注册过
441         if (pIDxName_[_name] != 0)
442             require(plyrNames_[_pID][_name] == true, "That names already taken");
443         // 
444         plyr_[_pID].name = _name;
445         pIDxName_[_name] = _pID;
446         if (plyrNames_[_pID][_name] == false) {
447             plyrNames_[_pID][_name] = true;
448             plyr_[_pID].names++;
449             plyrNameList_[_pID][plyr_[_pID].names] = _name;
450         }
451         // 将注册费用转到社区基金合约账户中
452         if(address(this).balance>0){
453             if(address(communityAddr) != address(0x0)) {
454                 communityAddr.transfer(address(this).balance);
455             }
456         }
457 
458         if (_all == true)
459             for (uint256 i = 1; i <= gID_; i++)
460                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
461         
462         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
463     }
464     /**
465      如果是新玩家，则返回真
466      */
467     function determinePID(address _addr) private returns (bool) {
468         if (pIDxAddr_[_addr] == 0){
469             pID_++;
470             pIDxAddr_[_addr] = pID_;
471             plyr_[pID_].addr = _addr;
472             return (true) ;
473         }else{
474             return (false);
475         }
476     }
477     /**
478      */
479     function addMeToGame(uint256 _gameID) isHuman() public {
480         require(_gameID <= gID_, "Game doesn't exist yet");
481         address _addr = msg.sender;
482         uint256 _pID = pIDxAddr_[_addr];
483         require(_pID != 0, "You dont even have an account");
484         uint256 _totalNames = plyr_[_pID].names;
485         
486         // add players profile and most recent name
487         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
488         
489         // add list of all names
490         if (_totalNames > 1)
491             for (uint256 ii = 1; ii <= _totalNames; ii++)
492                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
493     }
494 
495     function addMeToAllGames() isHuman() public {
496         address _addr = msg.sender;
497         uint256 _pID = pIDxAddr_[_addr];
498         require(_pID != 0, "You dont even have an account");
499         uint256 _laff = plyr_[_pID].laff;
500         uint256 _totalNames = plyr_[_pID].names;
501         bytes32 _name = plyr_[_pID].name;
502         
503         for (uint256 i = 1; i <= gID_; i++){
504             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
505             if (_totalNames > 1)
506                 for (uint256 ii = 1; ii <= _totalNames; ii++)
507                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
508         }
509     }
510 
511     function useMyOldName(string _nameString) isHuman() public {
512         // filter name, and get pID
513         bytes32 _name = _nameString.nameFilter();
514         uint256 _pID = pIDxAddr_[msg.sender];
515         
516         // make sure they own the name 
517         require(plyrNames_[_pID][_name] == true, "Thats not a name you own");
518         
519         // update their current name 
520         plyr_[_pID].name = _name;
521     }
522     /**
523      PlayerBookInterface Interface 
524      */
525     function getPlayerID(address _addr) external returns (uint256){
526         determinePID(_addr);
527         return (pIDxAddr_[_addr]);
528     }
529 
530     function getPlayerName(uint256 _pID) external view returns (bytes32){
531         return (plyr_[_pID].name);
532     }
533 
534     function getPlayerLAff(uint256 _pID) external view returns (uint256) {
535         return (plyr_[_pID].laff);
536     }
537 
538     function getPlayerAddr(uint256 _pID) external view returns (address) {
539         return (plyr_[_pID].addr);
540     }
541 
542     function getNameFee() external view returns (uint256){
543         return (registrationFee_);
544     }
545     
546     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) 
547         isRegisteredGame()
548         external payable returns(bool, uint256){
549         // 要求注册费用,不需要付费
550         //require (msg.value >= registrationFee_, "You have to pay the name fee");
551 
552         bool _isNewPlayer = determinePID(_addr);
553         uint256 _pID = pIDxAddr_[_addr];
554         uint256 _affID = _affCode;
555         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) {
556             plyr_[_pID].laff = _affID;
557         } else if (_affID == _pID) {
558             _affID = 0;
559         }      
560         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
561         return(_isNewPlayer, _affID);
562     }
563     //
564     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) 
565         isRegisteredGame()
566         external payable returns(bool, uint256){
567         // 要求注册费用,不需要付费
568         //require (msg.value >= registrationFee_, "You have to pay the name fee");
569 
570         bool _isNewPlayer = determinePID(_addr);
571         uint256 _pID = pIDxAddr_[_addr];
572         uint256 _affID;
573         if (_affCode != address(0) && _affCode != _addr){
574             _affID = pIDxAddr_[_affCode];
575             if (_affID != plyr_[_pID].laff){
576                 plyr_[_pID].laff = _affID;
577             }
578         }
579         
580         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
581         
582         return(_isNewPlayer, _affID);    
583     }
584     //
585     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) 
586         isRegisteredGame()
587         external payable returns(bool, uint256){
588         // 要求注册费用,不需要付费
589         //require (msg.value >= registrationFee_, "You have to pay the name fee");
590 
591         bool _isNewPlayer = determinePID(_addr);
592         uint256 _pID = pIDxAddr_[_addr];
593         uint256 _affID;
594         if (_affCode != "" && _affCode != _name){
595             _affID = pIDxName_[_affCode];
596             if (_affID != plyr_[_pID].laff){
597                 plyr_[_pID].laff = _affID;
598             }
599         }
600         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
601         return(_isNewPlayer, _affID);            
602     }
603 }