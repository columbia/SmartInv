1 pragma solidity ^0.4.21;
2 
3 /**
4 * Issued by
5 *       _                              __ _     _
6 *      | |                            / _| |   (_)
7 *    __| | __ _ _ __  _ __  ___  ___ | |_| |_   _  ___
8 *   / _` |/ _` | '_ \| '_ \/ __|/ _ \|  _| __| | |/ _ \
9 *  | (_| | (_| | |_) | |_) \__ \ (_) | | | |_ _| | (_) |
10 *   \__,_|\__,_| .__/| .__/|___/\___/|_|  \__(_)_|\___/
11 *              | |   | |
12 *              |_|   |_|
13 *
14 * 以太武侠(ethwuxia)
15 * wangangang1991 @ gmail.com
16 */
17 
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59   function max(uint a, uint b) internal pure returns (uint) {
60     if (a > b) return a;
61     else return b;
62   }
63 
64   function min(uint a, uint b) internal pure returns (uint) {
65     if (a < b) return a;
66     else return b;
67   }
68 }
69 
70 
71 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
72 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
73 contract ERC721 {
74     // Required methods
75     function totalSupply() public view returns (uint256 total);
76     function balanceOf(address _owner) public view returns (uint256 balance);
77     function ownerOf(uint256 _tokenId) public view returns (address owner);
78     function approve(address _to, uint256 _tokenId) public;
79     function transfer(address _to, uint256 _tokenId) public;
80     function transferFrom(address _from, address _to, uint256 _tokenId) public;
81 
82     // Events
83     event Transfer(address from, address to, uint256 tokenId);
84     event Approval(address owner, address approved, uint256 tokenId);
85 
86     // Optional
87     // function name() public view returns (string name);
88     // function symbol() public view returns (string symbol);
89     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
90     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
91 
92     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
93     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
94 }
95 
96 contract EthWuxia is ERC721{
97   using SafeMath for uint256;
98 
99   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
100   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
101   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
102   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
103 
104   uint public produceUnitSeconds = 86400;  // 每1天进行一次高级卡投放
105   uint public freeLotterySeconds = 3600 * 6;  // 每1天有一次免费抽卡的机会
106   uint public unitRareGrowth = 3;  // 每单位时间 稀有卡投放数量
107   uint public unitEpicGrowth = 0;  // 史诗卡投放数量
108   uint public unitMythGrowth = 0;  // 传说卡投放数量
109   uint public initialMartialTimes=1;  // 新的门派会有一定的概率加成 => 2被
110   uint public stepPrice = 1 finney;
111   uint public lotteryPrice = 10 finney;  // lotteryPrice
112   uint public dragonGirlLotteryPrice = 10 finney;
113   uint public dragonGirlLotteryNumber = 0;
114   address[] public listedDragonGirlLotteryUser = [address(0), address(0), address(0), address(0), address(0)];
115   address public wuxiaMaster = address(0);
116   uint public wuxiaMasterPrice = 100 finney;  // 每次加价100finny;
117   mapping (uint256 => address) public approvedOfItem;
118   uint public littleMonster = 1 ether; // 游戏收入每到1ether就生成一个以太怪
119 
120 
121   uint public totalEarning = 0;  // 总收入 => 总收入的10%用于生成EthMonster
122   uint public totalTrading = 0;  // 总流水  
123   uint public lotteryTotalEarning = 0;  // 抽卡收入 => 掌门人5%
124   uint public marketTotalEarning = 0;  // 市场交易收入 => 武林盟主5%
125   uint public smartSpeedEarning = 0;
126   uint public luckyStoneEarning = 0;
127   uint public hunterLicenceEarning = 0;
128   uint public travelTotalEarning = 0;
129   uint public masterTotalEarning = 0;
130   // 开服活动 抽奖10次送狩猎证书
131   bool public lotteryGiveHunt = false;
132   uint public lotteryGiveHuntMinimalNumber = 10;
133   uint public randNonce = 0;
134 
135 
136   mapping (address => uint) public mapUserLastFreeLotteryTimestamp;  // 用户上次抽奖的时间
137   mapping (address => uint) public mapUserPower;  // 实时维护用户的战斗力
138 
139   // ability does not support trade
140   mapping (address => bool) public mapUserHasSmartSpeed;  // 用户是否会凌波微步
141   uint public currentSmartSpeedNumber = 0;
142   // smartSpeedPrice = Min(0.1ether, 0.01ether*currentSmartSpeedNumber)
143 
144   mapping (address => bool) public mapUserHasLuckyStone;  // 用户是否有幸运宝石
145   uint public currentLuckyStoneNumber = 0;
146   // luckyStonePrice = Min(0.1ether, 0.01*ether*currentLuckyStoneNumber)
147 
148   mapping (address => bool) public mapUserHasHunterLicence;
149   uint public currentHunterNumber = 0;
150   // hunterPrice = Min(0.1ether, 0.01ether*currentHunterNumber)
151 
152   uint public totalUserNumber = 0;
153   uint public totalLotteryNumber = 0;
154   uint public totalBuyCardNumber = 0;
155   uint public totalSellCardNumber = 0;
156   uint public totalDragonLotteryNumber = 0;
157   mapping (uint => uint) public mapMartialUserCount;  // martial total user count
158   mapping (uint => uint) public mapMartialLotteryCount;  // martial total lottery count
159   mapping (address => uint) public mapUserLotteryNumber;
160 
161   // 合约支持动态增加新据点
162   struct Martial {
163       uint x;  // 门派坐标
164       uint y;  // 门派坐标
165       address owner;  // 门派盟主
166       uint lastProduceTime;  // 上一次的极品卡出产时间
167       uint martialId;
168       uint rareNumber;  // 稀有的
169       uint epicNumber;  // 史诗的
170       uint mythNumber;  // 传说的
171       uint enterPrice;  // 入场费 => 剑冢入场费为1ether
172       uint[] cardTypeList;  // 该门派出产的卡片
173   }
174 
175   // 充值额度的20%会被用作奖品
176   // 每1个ether 有一个0.1ether的以太怪 以太怪的血量为2*最高攻击力玩家的战斗力
177   // 每10个ether 有一个1ether的以太怪 以太怪血量为5*最高攻击力玩家的战斗力
178   // 以太怪奖励的10%将发给门派创始人
179   struct EtherMonster {
180       uint monsterId;
181       uint martialId;  // 该怪兽出现在哪个据点
182       uint balance;  // 奖金 => 奖励点的5%
183       uint blood;  // 血量 对于0.2ether的以太怪是3*最高攻击力玩家的战斗力 对于1ether的以太怪是10*最高攻击力玩家的战斗力
184       uint produceTime;  // 怪兽出现的时间 怪物需要在指定的时间内被击杀 掌门人将获得20%的收益
185       uint currentBlood;  // 当前血量
186       bool defeated;  // 是否已经被消灭
187       address winner;  // 获奖者
188   }
189 
190   mapping (address => uint) public mapUserLastAttackMonsterTimestamp;
191   uint public userAttackMonsterCDSeconds = 600;  // 用户每10分钟可以攻击一次EtherMonster怪
192   uint public maxUserPower = 0;  // 用于etherMonster血量估计
193   address public maxPowerUserAddress = address(0);
194   uint etherMonsterHuntSeconds = 3600;  // etherMonster的狩猎时间
195   uint littleEtherMonsterUnit = 0.5 ether;  // 3倍最高战力
196   uint bigEtherMonsterUnit = 5 ether;  // 10倍最高战力
197 
198   struct CardType {
199       uint typeId;
200       uint martialId;  // 卡片从属于那个门派
201       uint initPower;  // 初始战斗力
202       uint growthFactor;  // 成长系数
203       uint category;  // 卡片分类 => 1表示武侠 2表示武器 3表示武功 4表示阵法
204   }
205 
206   // 合成新卡的方式是: 两张旧卡片销毁 生成一张新卡片
207   struct Card {
208       uint cardId;
209       uint typeId;
210       uint level;  // 卡片等级 => 0表示普通 1表示稀有 2表示史诗 3表示传说
211       bool onSell;
212       uint sellPrice;
213       address owner;
214   }
215 
216 
217   address private owner;
218   mapping (address => bool) private admins;
219 
220   IItemRegistry private itemRegistry;
221   uint public travelUnitFee = 1 finney; // 0.001ether for each step
222 
223   uint256[] private listedItems;
224   Martial[] public listedMartials;  // 门派列表
225   CardType[] public listedCardType;  // 卡牌列表
226   Card[] public listedCard;
227   EtherMonster[] public listedEtherMonster;
228 
229   uint smallMonsterPowerFactor = 3;
230   uint bigMonsterPowerFactor = 5;
231 
232   mapping (uint256 => address) public mapOwnerOfCard;
233   mapping (address => uint) private mapUserCurrentMartialId;  // 用户当前的门派
234   mapping (address => bool) public mapUesrAlreadyMartialOwner;
235   mapping (address => bytes32) public mapUserNickname;
236 
237   bool public hasInitMartial = false;
238   bool public hasInitCard1 = false;
239   bool public hasInitCard2 = false;
240 
241   function EthWuxia () public {
242       owner = msg.sender;
243       admins[owner] = true;
244       lotteryGiveHunt = true;
245   }
246 
247   /* Modifiers */
248   modifier onlyOwner() {
249     require(owner == msg.sender);
250     _;
251   }
252 
253   modifier onlyAdmins() {
254     require(admins[msg.sender]);
255     _;
256   }
257 
258   /* Owner */
259   function setOwner (address _owner) onlyOwner() public {
260     owner = _owner;
261   }
262 
263   function getOwner() public view returns(address){
264       return owner;
265   }
266   function setItemRegistry (address _itemRegistry) onlyOwner() public {
267     itemRegistry = IItemRegistry(_itemRegistry);
268   }
269 
270   function addAdmin (address _admin) onlyOwner() public {
271     admins[_admin] = true;
272   }
273 
274   function removeAdmin (address _admin) onlyOwner() public {
275     delete admins[_admin];
276   }
277   
278   function disableLotteryGiveHunt() onlyOwner() public {
279       lotteryGiveHunt = false;
280   }
281   
282   function enableLotteryGiveHunt() onlyOwner() public {
283       lotteryGiveHunt = true;
284   }
285 
286   // 功能列表
287   // 1. 游戏更新 => 创建门派
288   // 1.1 createNewMartial
289   // 1.2 createNewCardType
290   function createNewMartial (uint x, uint y, uint enterPrice) onlyOwner() public {
291     require(x>=1);
292     require(y>=1);
293     Martial memory martial = Martial(x, y, address(0), now, listedMartials.length, unitRareGrowth * initialMartialTimes, unitEpicGrowth * initialMartialTimes, unitMythGrowth * initialMartialTimes, enterPrice, new uint[](0));
294     listedMartials.push(martial);
295   }
296 
297   // 1.2 创建卡片类型
298   function createNewCardType (uint martialId, uint initPower, uint growthFactor, uint category) onlyOwner() public {
299     require(initPower>=1);
300     require(growthFactor>=2);
301     require(category>=1);
302     require(category<=4);  // 武侠, 装备, 武功, 阵法
303     require(martialId < listedMartials.length);
304     listedMartials[martialId].cardTypeList.push(listedCardType.length);
305     CardType memory cardType = CardType(listedCardType.length, martialId, initPower, growthFactor, category);
306     listedCardType.push(cardType);
307   }
308 
309   // 2. 用户操作
310   // 2.1 凌波微步
311   // 2.2 幸运宝石
312   // 2.3 猎手
313   // 2.4 旅行location
314   // 2.5 抽奖
315   // 2.6 卡片合成
316   // 2.7 战斗力维护
317   // 2.8 掌门人
318   // 2.9 交易市场
319   // 2.10 武林盟主 => 10percent of market exchage
320   // 2.11 龙女彩票
321   // 2.12 etherMonster
322 
323   // 2.1 凌波微步
324   function userHasSmartSpeed(address userAddress) public view returns(bool) {
325     return mapUserHasSmartSpeed[userAddress];
326   }
327 
328   function getCurrentSmartSpeedPrice() public view returns(uint) {
329     // Min(0.1ether, 0.01ether+0.01ether*current)
330     return SafeMath.mul(SafeMath.min(10, currentSmartSpeedNumber), 10 finney);
331   }
332 
333   function buySmartSpeed () public payable {
334     uint currentSmartSpeedPrice = SafeMath.mul(SafeMath.min(10, currentSmartSpeedNumber), 10 finney);
335     require(msg.value >= currentSmartSpeedPrice);
336     require(!mapUserHasSmartSpeed[msg.sender]);
337     uint excess = msg.value.sub(currentSmartSpeedPrice);
338     currentSmartSpeedNumber += 1;
339 
340     if (excess > 0) {
341       msg.sender.transfer(excess);
342     }
343     mapUserHasSmartSpeed[msg.sender] = true;
344 
345     _tryCreateEtherMonster(totalEarning, totalEarning.add(currentSmartSpeedPrice));
346     totalEarning = totalEarning.add(currentSmartSpeedPrice);
347     totalTrading = totalTrading.add(currentSmartSpeedPrice);
348     smartSpeedEarning = smartSpeedEarning.add(currentSmartSpeedPrice);
349   }
350 
351   // 2.2 幸运宝石
352   function userHasLuckyStone(address userAddress) public view returns(bool) {
353     return mapUserHasLuckyStone[userAddress];
354   }
355 
356   function getCurrentLuckyStonePrice() public view returns(uint) {
357     // Min(0.1ether, 0.01ether+0.01ether*current)
358     return SafeMath.mul(SafeMath.min(10, currentLuckyStoneNumber), 10 finney);
359   }
360 
361   function buyLuckyStone() public payable {
362     uint currentLuckyStonePrice = SafeMath.mul(SafeMath.min(10, currentLuckyStoneNumber), 10 finney);
363     require(msg.value >= currentLuckyStonePrice);
364     require(!mapUserHasLuckyStone[msg.sender]);
365     uint excess = msg.value.sub(currentLuckyStonePrice);
366     currentLuckyStoneNumber += 1;
367     if (excess > 0) {
368       msg.sender.transfer(excess);
369     }
370     mapUserHasLuckyStone[msg.sender] = true;
371     _tryCreateEtherMonster(totalEarning, totalEarning.add(currentLuckyStonePrice));
372     totalEarning = totalEarning.add(currentLuckyStonePrice);
373     totalTrading = totalTrading.add(currentLuckyStonePrice);
374     luckyStoneEarning = luckyStoneEarning.add(currentLuckyStonePrice);
375   }
376 
377   function createEtherMonster(uint martialId, uint balance, uint blood) public onlyOwner {
378       require(martialId<listedMartials.length);
379       require(balance>0);
380       require(blood>0);
381       require(balance<address(this).balance);
382       EtherMonster memory monster = EtherMonster(listedEtherMonster.length, martialId, balance, blood, now, blood, false, address(0));
383       listedEtherMonster.push(monster);
384   }
385 
386 
387   // 2.3 狩猎证书
388   function userHasHunterLicence(address userAddress) public view returns(bool) {
389       return mapUserHasHunterLicence[userAddress];
390   }
391 
392   function getCurrentHunterLicencePrice() public view returns(uint) {
393     return SafeMath.mul(SafeMath.min(10, currentHunterNumber), 10 finney);
394   }
395 
396   function buyHunterLicence() public payable {
397     uint currentHunterLicencePrice = SafeMath.mul(SafeMath.min(10, currentHunterNumber), 10 finney);
398     require(msg.value >= currentHunterNumber);
399     require(!mapUserHasHunterLicence[msg.sender]);
400     uint excess = msg.value.sub(currentHunterLicencePrice);
401     currentHunterNumber += 1;
402     if (excess > 0) {
403       msg.sender.transfer(excess);
404     }
405     mapUserHasHunterLicence[msg.sender] = true;
406 
407     _tryCreateEtherMonster(totalEarning, totalEarning.add(currentHunterLicencePrice));
408     totalEarning = totalEarning.add(currentHunterLicencePrice);
409     totalTrading = totalTrading.add(currentHunterLicencePrice);
410     hunterLicenceEarning = hunterLicenceEarning.add(currentHunterLicencePrice);
411   }
412 
413   // 2.4 travel
414   // 用户当前的Martial
415   function getUserCurrentMartialId() public view returns(uint) {
416       return mapUserCurrentMartialId[msg.sender];
417   }
418 
419   // workaround for struct
420   // https://github.com/ethereum/remix-ide/issues/920#issuecomment-348069589
421   function getMartialInfo(uint martialId) public view returns(uint, uint, address, uint, uint, uint, uint, uint, uint, uint[]) {
422     require(martialId < listedMartials.length);
423     Martial memory martial = listedMartials[martialId];
424     return (martial.x, martial.y, martial.owner, martial.lastProduceTime, martial.martialId, martial.rareNumber, martial.epicNumber, martial.mythNumber, martial.enterPrice, martial.cardTypeList);
425   }
426   
427   function getMartialListInfo() public view returns(uint[]) {
428       // rareNumber, epicNumber, mythNumber, ownerPower
429       uint[] memory result = new uint[](listedMartials.length.mul(5)+1);
430       uint index = 1;
431       result[0] = listedMartials.length;
432       for (uint i=0; i<listedMartials.length;i++) {
433           Martial memory martial = listedMartials[i];
434           result[index] = martial.rareNumber;
435           result[index+1] = martial.epicNumber;
436           result[index+2] = martial.mythNumber;
437           result[index+3] = mapUserPower[martial.owner];
438           result[index+4] = mapMartialUserCount[i];
439           index += 5;
440       }
441       return result;
442   }
443   
444   function getMartialOwner() public view returns(address[]) {
445     address[] memory result = new address[](listedMartials.length);
446     for (uint i=0;i<listedMartials.length;i++) {
447         result[i] = listedMartials[i].owner;
448     }
449     return result;
450   }
451   
452   function getMartialNumber() public view returns(uint) {
453     return listedMartials.length;
454   }
455 
456   function absSub(uint a, uint b) private pure returns(uint) {
457     if (a>b) return a.sub(b);
458     return b.sub(a);
459   }
460   // 用户当前旅行的成本
461   function _getTravelPrice(address userAddress, uint martialId) private view returns(uint) {
462     Martial storage currentMartial = listedMartials[mapUserCurrentMartialId[userAddress]];
463     Martial storage nextMartial = listedMartials[martialId];
464     require(currentMartial.martialId != nextMartial.martialId);  // 旅程起点、终点不能相同
465     uint stepNumber = absSub(currentMartial.x, nextMartial.x).add(absSub(currentMartial.y, nextMartial.y));
466     uint travelPrice = stepNumber.mul(stepPrice).add(nextMartial.enterPrice);
467     // 凌波微步的旅行成本减半
468     if (mapUserHasSmartSpeed[userAddress]) {
469       travelPrice = travelPrice.div(2);
470     }
471     return travelPrice;
472   }
473 
474   function getTravelPrice(uint martialId) public view returns(uint) {
475     return _getTravelPrice(msg.sender, martialId);
476   }
477 
478   // 旅行
479   function changeMartial(uint martialId) public payable {
480     uint travelPrice = _getTravelPrice(msg.sender, martialId);
481     require(msg.value>=travelPrice);
482     require(martialId<listedMartials.length);
483     if (mapUserLotteryNumber[msg.sender] > 0) {
484         if (mapMartialUserCount[mapUserCurrentMartialId[msg.sender]] > 0) {
485             mapMartialUserCount[mapUserCurrentMartialId[msg.sender]] = mapMartialUserCount[mapUserCurrentMartialId[msg.sender]].sub(1);
486         }
487         mapMartialUserCount[martialId] += 1;
488     }
489     uint excess = msg.value.sub(travelPrice);
490     if (excess>0) {
491       msg.sender.transfer(excess);
492     }
493     mapUserCurrentMartialId[msg.sender] = martialId;
494     _tryCreateEtherMonster(totalEarning, totalEarning.add(travelPrice));
495     totalEarning = totalEarning.add(travelPrice);
496     travelTotalEarning = travelTotalEarning.add(travelPrice);
497   }
498 
499   // 2.5 lottery
500   // get random number in [0, maxNumber)
501   function getRandomNumber(uint maxNumber) private returns(uint) {
502     require(maxNumber>0);
503     randNonce += 1;
504     return uint(keccak256(now, randNonce, block.blockhash(block.number - 1), block.coinbase)) % maxNumber;
505   }
506   // 2.5 lottery
507   // whether user can lottery for free
508   function _canLotteryFree(address userAddress) private view returns(bool) {
509     uint lastLotteryTimestamp = mapUserLastFreeLotteryTimestamp[userAddress];
510     return now - lastLotteryTimestamp > freeLotterySeconds;
511   }
512 
513 // Test for Remix support of tuple params
514 //   uint public debugNumber = 0;
515 //   function setDebugNumber(uint a) {
516 //       debugNumber = a;
517 //   }
518 
519 //   function setDebugNumber2(uint a, uint b) {
520 //       debugNumber = b;
521 //   }
522 
523 //   function getDebugNumber() public view returns(uint) {
524 //       return debugNumber;
525 //   }
526   function debug() public view returns(uint, uint, uint, uint, bool) {
527       uint lastLotteryTimestamp = mapUserLastFreeLotteryTimestamp[msg.sender];
528       return (now, lastLotteryTimestamp, now-lastLotteryTimestamp, freeLotterySeconds, now - lastLotteryTimestamp > freeLotterySeconds);
529   }
530 
531   function getNowTimestamp() public view returns(uint) {
532       return now;
533   }
534 
535   function getMyLastFreeLotteryTimestamp() public view returns(uint) {
536     return mapUserLastFreeLotteryTimestamp[msg.sender];
537   }
538 
539   function canLotteryFree() public view returns(bool) {
540     return _canLotteryFree(msg.sender);
541   }
542 
543   //获取某个门派的所有卡片
544   function getMartialCardTypeIdList(uint martialId) public view returns(uint[]) {
545     require(martialId<listedMartials.length);
546     return listedMartials[martialId].cardTypeList;
547   }
548 
549   function getCardTypeInfo(uint typeId) public view returns(uint, uint, uint, uint, uint) {
550     require(typeId < listedCardType.length);
551     CardType memory cardType = listedCardType[typeId];
552     return (cardType.typeId, cardType.martialId, cardType.initPower, cardType.growthFactor, cardType.category);
553   }
554 
555   function getCardPower(uint cardTypeId, uint cardLevel) public view returns(uint){
556     require(cardLevel<=3);
557     require(cardTypeId<listedCardType.length);
558     CardType memory cardType = listedCardType[cardTypeId];
559     if (cardLevel == 0) {
560       return cardType.initPower;
561     } else if (cardLevel == 1) {
562       return cardType.initPower.mul(cardType.growthFactor);
563     } else if (cardLevel == 2) {
564       return cardType.initPower.mul(cardType.growthFactor).mul(cardType.growthFactor);
565     } else if (cardLevel == 3) {
566       return cardType.initPower.mul(cardType.growthFactor).mul(cardType.growthFactor).mul(cardType.growthFactor);
567     }
568   }
569 
570   function getUserPower(address userAddress) public view returns(uint) {
571       return mapUserPower[userAddress];
572   }
573   // 用户只能在自己的据点抽卡
574   function lottery() public payable {
575     require((msg.value >= lotteryPrice || _canLotteryFree(msg.sender)));
576     totalLotteryNumber = totalLotteryNumber.add(1);
577     uint currentLotteryPrice = 0;
578     if (_canLotteryFree(msg.sender)) {
579       mapUserLastFreeLotteryTimestamp[msg.sender] = now;
580     } else {
581       currentLotteryPrice = lotteryPrice;
582     }
583     uint excess = msg.value.sub(currentLotteryPrice);
584     // 掌门抽成
585     uint userCurrentMartialId = mapUserCurrentMartialId[msg.sender];
586     if (currentLotteryPrice > 0) {
587       address martialOwner = listedMartials[userCurrentMartialId].owner;
588       if (martialOwner != address(0)) {
589         uint martialOwnerCut = currentLotteryPrice.mul(30).div(100);
590         martialOwner.transfer(martialOwnerCut);
591         // martialOwner.transfer(currentLotteryPrice);
592       }
593     }
594     if (excess>0) {
595       msg.sender.transfer(excess);
596     }
597   
598     // cardType && cardLevel
599     // cardType
600     uint martialCardTypeCount = listedMartials[userCurrentMartialId].cardTypeList.length;
601     // 3个随机 50%概率本据点的卡 epic_number%抽到特殊卡 lotteryId抽到的卡片数量
602     uint randomNumber = getRandomNumber(martialCardTypeCount.mul(1000));
603 
604     uint lotteryCardTypeId = listedMartials[userCurrentMartialId].cardTypeList[randomNumber % martialCardTypeCount];
605     // 据点玩家有50%的概率抽到本据点的卡
606     if (randomNumber % 10 >= 5) {
607         lotteryCardTypeId = randomNumber % listedCardType.length;
608     }
609     randomNumber = randomNumber.div(10).div(martialCardTypeCount);
610     // cardLevel
611     if (now - listedMartials[userCurrentMartialId].lastProduceTime >= produceUnitSeconds) {
612       listedMartials[userCurrentMartialId].epicNumber += unitEpicGrowth;
613       listedMartials[userCurrentMartialId].rareNumber += unitRareGrowth;
614       listedMartials[userCurrentMartialId].mythNumber += unitMythGrowth;
615       listedMartials[userCurrentMartialId].lastProduceTime = listedMartials[userCurrentMartialId].lastProduceTime.add(produceUnitSeconds);
616     }
617     uint lotteryCardLevel = 0;
618     Martial memory userCurrentMartial = listedMartials[userCurrentMartialId];
619     uint luckyStoneFactor = 1;
620     if (mapUserHasLuckyStone[msg.sender]) {
621       luckyStoneFactor = 2;
622     }
623 
624     // 如果用户拥有luckyStone 那么抽到好卡的概率翻倍
625     // Free lottery can only get normal card
626     if (randomNumber % 100 < userCurrentMartial.mythNumber.mul(luckyStoneFactor) && userCurrentMartial.mythNumber > 0 && currentLotteryPrice>0) {
627       lotteryCardLevel = 3;
628       listedMartials[userCurrentMartialId].mythNumber = listedMartials[userCurrentMartialId].mythNumber.sub(1);
629     } else if (randomNumber % 100 < luckyStoneFactor.mul(userCurrentMartial.mythNumber.add(userCurrentMartial.epicNumber)) && userCurrentMartial.epicNumber > 0 && currentLotteryPrice > 0) {
630       lotteryCardLevel = 2;
631       listedMartials[userCurrentMartialId].epicNumber = listedMartials[userCurrentMartialId].epicNumber.sub(1);
632     } else if (randomNumber % 100 < luckyStoneFactor.mul(userCurrentMartial.mythNumber.add(userCurrentMartial.epicNumber.add(userCurrentMartial.rareNumber))) && userCurrentMartial.rareNumber > 0 && currentLotteryPrice > 0) {
633       lotteryCardLevel = 1;
634       listedMartials[userCurrentMartialId].rareNumber = listedMartials[userCurrentMartialId].rareNumber.sub(1);
635     }
636 
637     // issue card
638     Card memory card = Card(listedCard.length, lotteryCardTypeId, lotteryCardLevel, false, 0, msg.sender);
639     mapOwnerOfCard[listedCard.length] = msg.sender;
640     if (mapUserLotteryNumber[msg.sender] == 0) {
641         totalUserNumber = totalUserNumber.add(1);
642         mapMartialUserCount[mapUserCurrentMartialId[msg.sender]] += 1;
643     }
644     mapUserLotteryNumber[msg.sender] += 1;
645     if (lotteryGiveHunt && mapUserLotteryNumber[msg.sender] >= lotteryGiveHuntMinimalNumber) {
646         if (mapUserHasHunterLicence[msg.sender] == false) {
647             mapUserHasHunterLicence[msg.sender] = true;
648         }
649     }
650     mapMartialLotteryCount[mapUserCurrentMartialId[msg.sender]] += 1;
651     mapUserPower[msg.sender] = mapUserPower[msg.sender].add(getCardPower(lotteryCardTypeId, lotteryCardLevel));
652     if (mapUserPower[msg.sender] > maxUserPower) {
653       maxUserPower = mapUserPower[msg.sender];
654       maxPowerUserAddress = msg.sender;
655     }
656     listedCard.push(card);
657 
658     _tryCreateEtherMonster(totalEarning, totalEarning.add(currentLotteryPrice));
659     totalEarning = totalEarning.add(currentLotteryPrice);
660     totalTrading = totalTrading.add(currentLotteryPrice);
661     lotteryTotalEarning = lotteryTotalEarning.add(currentLotteryPrice);
662   }
663 
664   function getCardNumber() public view returns(uint) {
665       return listedCard.length;
666   }
667 
668   function getCardInfo(uint cardId) public view returns(uint, uint, uint, bool, uint, address) {
669       require(cardId<listedCard.length);
670       Card memory card = listedCard[cardId];
671       return (card.cardId, card.typeId, card.level, card.onSell, card.sellPrice, card.owner);
672   }
673   
674   function getGameStats() public view returns(uint, uint, uint, uint, uint, address) {
675       return (totalUserNumber, totalBuyCardNumber, totalLotteryNumber, totalEarning, totalTrading, wuxiaMaster);
676   }
677 
678   // 2.6 卡片合成
679   // 两张卡必须不能在卖出状态
680   function mergeCard(uint a, uint b) public {
681     require(a<listedCard.length);
682     require(b<listedCard.length);
683     require(listedCard[a].typeId==listedCard[b].typeId);
684     require(listedCard[a].level==listedCard[b].level);
685     require(listedCard[a].level<=2);  // 0 for normal, 1 for rare, 2 for epic, 3 for myth
686     require(!listedCard[a].onSell);
687     require(!listedCard[b].onSell);
688     require(mapOwnerOfCard[a]==msg.sender);
689     require(mapOwnerOfCard[b]==msg.sender);
690     Card memory card = Card(listedCard.length, listedCard[a].typeId, listedCard[a].level.add(1), false, 0, msg.sender);
691     mapOwnerOfCard[a] = address(0);
692     mapOwnerOfCard[b] = address(0);
693     listedCard[a].owner = address(0);
694     listedCard[b].owner = address(0);
695     mapOwnerOfCard[listedCard.length] = msg.sender;
696     listedCard.push(card);
697     // 需要维护用户的战斗力
698     mapUserPower[msg.sender] = mapUserPower[msg.sender].add(getCardPower(listedCard[a].typeId, listedCard[a].level.add(1)).sub(getCardPower(listedCard[a].typeId, listedCard[a].level).mul(2)));
699     if (mapUserPower[msg.sender] > maxUserPower) {
700       maxUserPower = mapUserPower[msg.sender];
701       maxPowerUserAddress = msg.sender;
702     }
703   }
704 
705   // 2.7 掌门人
706   // 争夺掌门人
707   function beatMartialOwner() public returns (bool){
708     uint myMartialId = mapUserCurrentMartialId[msg.sender];
709     address martialOwner = listedMartials[myMartialId].owner;
710     require(msg.sender!=martialOwner);
711     require(!mapUesrAlreadyMartialOwner[msg.sender]);
712     // 空的门派可以直接被占领
713     if (martialOwner==address(0)) {
714       listedMartials[myMartialId].owner = msg.sender;
715       mapUesrAlreadyMartialOwner[msg.sender] = true;
716       mapUesrAlreadyMartialOwner[martialOwner] = false;
717       return true;
718     } else {
719       if (mapUserPower[msg.sender] > mapUserPower[martialOwner]) {
720         listedMartials[myMartialId].owner = msg.sender;
721         mapUesrAlreadyMartialOwner[msg.sender] = true;
722         mapUesrAlreadyMartialOwner[martialOwner] = false;
723         return true;
724       } else {
725         return false;
726       }
727     }
728   }
729 
730   // 2.8 wuxiaMaster
731   // 回本周期长, 投资需谨慎
732   // 武林盟主将获得所有卡牌交易费用的5% 每获得1.1单位收益 武林盟主的价格会下降1 也就是说你最多可以获得投资的110%的收益
733   // 设立wuxiaMaster的主要目的是希望有看得起这个游戏的人 投一点钱 让我请女朋友吃顿自助
734   // 希望不会让你亏损~
735   function currentWulinMasterPrice() public view returns(uint){
736     return wuxiaMasterPrice;
737   }
738 
739   function buyWuxiaMaster() payable public {
740     require(msg.value>=wuxiaMasterPrice);
741     require(msg.sender!=wuxiaMaster);
742     // 给老的owner转出当时买入的价钱
743     wuxiaMaster.transfer(wuxiaMasterPrice - 100 finney);
744     uint excess = msg.value.sub(wuxiaMasterPrice);
745     // 转出余额
746     if (excess>0) {
747       msg.sender.transfer(excess);
748     }
749     // wuxiaMaster其实是亏钱买卖 不计入totalEarning
750     masterTotalEarning = masterTotalEarning.add(wuxiaMasterPrice);
751     totalTrading = totalTrading.add(wuxiaMasterPrice);
752 
753     // 更新武林盟主
754     wuxiaMaster = msg.sender;
755     wuxiaMasterPrice = wuxiaMasterPrice.add(100 finney);
756   }
757 
758 
759   // 2.9 card Trading
760   function sellCard(uint cardId, uint price) public {
761     require(cardId<listedCard.length);
762     totalSellCardNumber = totalSellCardNumber.add(1);
763     address cardOwner = mapOwnerOfCard[cardId];
764     require(cardOwner!=address(0));  // 不能卖出被销毁的卡
765     require(cardOwner==msg.sender);  // 只能卖出自己的卡
766     require(!listedCard[cardId].onSell); // 不能卖出已在卖出状态的卡
767     listedCard[cardId].onSell = true;
768     listedCard[cardId].sellPrice = price;
769   }
770 
771   function cancelSell(uint cardId) public {
772     require(cardId<listedCard.length);
773     address cardOwner = mapOwnerOfCard[cardId];
774     require(cardOwner!=address(0));
775     require(cardOwner==msg.sender);  // 只能取消自己的卡
776     require(listedCard[cardId].onSell); // 必须在待卖出状态
777     listedCard[cardId].onSell = false;
778   }
779 
780   // 用户卖出卡片 需要支付5%的佣金 其中2%给开发者 3%给武林盟主
781   function buyCard(uint cardId) payable public {
782     require(mapOwnerOfCard[cardId]!=address(0));
783     require(msg.sender!=mapOwnerOfCard[cardId]);
784     require(listedCard[cardId].onSell);
785     uint buyPrice = listedCard[cardId].sellPrice;
786     totalBuyCardNumber = totalBuyCardNumber.add(1);
787     require(msg.value>=buyPrice);
788     // 处理余额
789     uint excess = msg.value.sub(buyPrice);
790     if (excess>0) {
791       msg.sender.transfer(excess);
792     }
793     // 给开发5%
794     uint devCut = buyPrice.div(100).mul(0);
795     uint masterCut = buyPrice.div(100).mul(5);
796     if (wuxiaMaster==address(0)) {
797       devCut = devCut.add(masterCut);
798       masterCut = 0;
799     } else {
800       wuxiaMaster.transfer(masterCut);
801     }
802     // 修改wuxiaMaster的price
803     // 保证MasterPrice>=100 finney
804     uint masterPriceMinus = masterCut.mul(100).div(110);
805     if (wuxiaMasterPrice >= masterPriceMinus.add(100 finney)) {
806         wuxiaMasterPrice = wuxiaMasterPrice.sub(masterPriceMinus);
807     } else {
808         wuxiaMasterPrice = 100 finney;
809     }
810     // 给用户95%
811     uint moneyToSeller = buyPrice.sub(devCut.add(masterCut));
812     mapOwnerOfCard[cardId].transfer(moneyToSeller);
813     // 维护战力
814     uint cardPower = getCardPower(listedCard[cardId].typeId, listedCard[cardId].level);
815     // change onSell
816     listedCard[cardId].onSell = false;
817     mapUserPower[mapOwnerOfCard[cardId]] = mapUserPower[mapOwnerOfCard[cardId]].sub(cardPower);
818     mapUserPower[msg.sender] = mapUserPower[msg.sender].add(cardPower);
819     // // 所有权转移
820     mapOwnerOfCard[cardId] = msg.sender;
821     listedCard[cardId].owner = msg.sender;
822     // etherMonster
823     _tryCreateEtherMonster(totalEarning, totalEarning.add(devCut));
824     totalEarning = totalEarning.add(devCut);
825     totalTrading = totalTrading.add(buyPrice);
826     marketTotalEarning = marketTotalEarning.add(devCut);
827   }
828 
829   // 2.10 龙女彩票 => 每5张彩票开奖一次
830   // 获得一张普通的小龙女 cardType为0的卡片定义为小龙女
831   function getCurrentDragonGirlLotteryNumber() public view returns(uint) {
832     return dragonGirlLotteryNumber;
833   }
834 
835   function buyLittleDragonGirlLottery() public payable{
836     require(msg.value>=dragonGirlLotteryPrice);
837     require(listedCardType.length>0);
838     totalDragonLotteryNumber = totalDragonLotteryNumber.add(1);
839     listedDragonGirlLotteryUser[dragonGirlLotteryNumber] = msg.sender;
840     dragonGirlLotteryNumber = dragonGirlLotteryNumber.add(1);
841 
842     if (dragonGirlLotteryNumber == 5) {
843       // 抽奖
844       uint randomNumber = getRandomNumber(5);
845       address winner = listedDragonGirlLotteryUser[randomNumber];
846       mapOwnerOfCard[listedCard.length] = winner;
847       Card memory card = Card(listedCard.length, 0, 0, false, 0, winner);
848       listedCard.push(card);
849       // 更新获奖者战力
850       mapUserPower[winner] = mapUserPower[winner].add(getCardPower(0, 0));
851       dragonGirlLotteryNumber = 0;
852     }
853   }
854 
855   // 收入的30%反馈给掌门人和猎以太怪人
856   function _tryCreateEtherMonster(uint price_a, uint price_b) private {
857     uint priceTimes = price_b.div(0.5 ether);
858     // 40% for little monster
859     if (price_a<priceTimes*0.5 ether && price_b>=priceTimes*0.5 ether) {
860       // 生成小怪兽
861       uint martialId = getRandomNumber(listedMartials.length);
862       EtherMonster memory monster = EtherMonster(listedEtherMonster.length, martialId, 0.2 ether, maxUserPower.mul(smallMonsterPowerFactor), now, maxUserPower.mul(smallMonsterPowerFactor), false, address(0));
863       listedEtherMonster.push(monster);
864     }
865     priceTimes = price_b.div(5 ether);
866     // 20% for large monster
867     if (price_a<priceTimes*5 ether && price_b>=priceTimes*5 ether) {
868       // 生成大怪兽
869       uint bigMartialId = (getRandomNumber(listedEtherMonster.length).add(10007)) % listedMartials.length;
870       EtherMonster memory bigMonster = EtherMonster(listedEtherMonster.length, bigMartialId, 1 ether, maxUserPower.mul(bigMonsterPowerFactor), now, maxUserPower.mul(bigMonsterPowerFactor), false, address(0));
871       listedEtherMonster.push(bigMonster);
872     }
873   }
874 
875   function getEtherMonsterNumber() public view returns(uint) {
876     return listedEtherMonster.length;
877   }
878 
879   function getCanAttackMonsterIds() public view returns(uint[]) {
880       uint[] memory result = new uint[](listedEtherMonster.length+1);
881       uint index=0;
882       for (uint i=0; i<listedEtherMonster.length; i++) {
883         EtherMonster memory monster = listedEtherMonster[i];
884         if (monster.produceTime.add(etherMonsterHuntSeconds)>now && !monster.defeated) {
885             result[index] = i+1;
886             index += 1;
887         }
888       }
889       return result;
890     }
891 
892   function getOnSellCardIds() public view returns(uint[]) {
893       uint[] memory result = new uint[](listedCard.length+1);
894       uint index = 0;
895       for (uint i=0; i<listedCard.length; i++) {
896           if (listedCard[i].onSell) {
897               result[index] = i+1;
898               index += 1;
899           }
900       }
901       return result;
902   }
903 
904   function getEtherMonsterInfo(uint monsterId) public view returns(uint, uint, uint, uint, uint, uint, bool, address) {
905       require(monsterId<listedEtherMonster.length);
906       EtherMonster memory monster = listedEtherMonster[monsterId];
907       return (monster.monsterId, monster.martialId, monster.balance, monster.blood, monster.produceTime, monster.currentBlood, monster.defeated, monster.winner);
908   }
909 
910   // 掌门人会获得
911   function attackMonster(uint monsterId) public {
912     // 每个人只能攻击一次
913     require(!listedEtherMonster[monsterId].defeated);  // 没有被打败过
914     require(address(this).balance>=listedEtherMonster[monsterId].balance);  // 要有足够的奖金
915     require(mapUserLastAttackMonsterTimestamp[msg.sender].add(userAttackMonsterCDSeconds) < now);
916     require(listedEtherMonster[monsterId].produceTime.add(etherMonsterHuntSeconds) > now);
917     require(mapUserHasHunterLicence[msg.sender]);  // 用户有狩猎凭证
918     // 只要在该门派的人才能攻击
919     require(mapUserCurrentMartialId[msg.sender]==listedEtherMonster[monsterId].martialId);
920     // 判断monster当前的血量
921     uint monsterCurrentBlood = listedEtherMonster[monsterId].currentBlood;
922     uint monsterTotalBlood = listedEtherMonster[monsterId].blood;
923     mapUserLastAttackMonsterTimestamp[msg.sender] = now;
924     if (mapUserPower[msg.sender] >= monsterCurrentBlood) {
925       // 战力取胜
926       listedEtherMonster[monsterId].defeated = true;
927       listedEtherMonster[monsterId].winner = msg.sender;
928       _sendMonsterPrize(monsterId, msg.sender);
929     } else {
930       // 判断能否概率取胜
931       uint randomNumber = getRandomNumber(monsterTotalBlood);
932       if (randomNumber < mapUserPower[msg.sender]) {
933         listedEtherMonster[monsterId].defeated = true;
934         listedEtherMonster[monsterId].winner = msg.sender;
935         _sendMonsterPrize(monsterId, msg.sender);
936       } else {
937         listedEtherMonster[monsterId].currentBlood = monsterCurrentBlood.sub(mapUserPower[msg.sender]);
938       }
939     }
940   }
941 
942   function _sendMonsterPrize(uint monsterId, address winner) private {
943     uint totalPrize = listedEtherMonster[monsterId].balance;
944     uint martialOwnerCut = 0;
945     if (listedMartials[listedEtherMonster[monsterId].martialId].owner != address(0)) {
946       martialOwnerCut = totalPrize.mul(10).div(100);
947     }
948     winner.transfer(totalPrize.sub(martialOwnerCut));
949     listedMartials[listedEtherMonster[monsterId].martialId].owner.transfer(martialOwnerCut);
950   }
951 
952   // 2.12 用户设nickname
953   function setNickname(bytes32 nickname) public {
954     mapUserNickname[msg.sender] = nickname;
955   }
956 
957   function getAddressNickname(address userAddress) public view returns(bytes32){
958     return mapUserNickname[userAddress];
959   }
960 
961   // 2.13 统计指标
962   function listedMartialsLength() public view returns(uint length) {
963       return listedMartials.length;
964   }
965 
966 
967     function initMartial() onlyOwner() public {
968         require(!hasInitMartial);
969         createNewMartial(16,14,0);
970         createNewMartial(10,11,0);
971         createNewMartial(13,10,0);
972         createNewMartial(12,12,0);
973         createNewMartial(4,3,0);
974         createNewMartial(11,10,0);
975         createNewMartial(6,14,0);
976         createNewMartial(9,9,0);
977         createNewMartial(10,10,0);
978         createNewMartial(9,7,0);
979         createNewMartial(12,10,0);
980         hasInitMartial = true;
981     }
982 
983   function initCard1() onlyOwner() public {
984     require(!hasInitCard1);
985     createNewCardType(1,8,10,1);
986     createNewCardType(1,10,10,1);
987     createNewCardType(1,8,10,1);
988     createNewCardType(1,5,12,3);
989     createNewCardType(1,4,12,3);
990     createNewCardType(1,200,3,2);
991     createNewCardType(1,200,3,2);
992     createNewCardType(0,1,2,1);
993     createNewCardType(0,1,30,3);
994     createNewCardType(0,5,2,2);
995     createNewCardType(0,3,2,2);
996     createNewCardType(0,2,2,3);
997     createNewCardType(0,4,2,3);
998     createNewCardType(0,8,2,2);
999     createNewCardType(2,12,10,1);
1000     createNewCardType(2,10,10,1);
1001     createNewCardType(2,5,12,3);
1002     createNewCardType(2,5,12,3);
1003     createNewCardType(2,4,12,3);
1004     createNewCardType(2,5,20,4);
1005     createNewCardType(2,18,15,4);
1006     createNewCardType(3,13,10,1);
1007     createNewCardType(3,5,13,3);
1008     createNewCardType(3,5,12,3);
1009     createNewCardType(3,5,10,3);
1010     createNewCardType(3,10,8,3);
1011     createNewCardType(3,80,5,2);
1012     createNewCardType(3,7,20,4);
1013     createNewCardType(4,11,10,1);
1014     createNewCardType(4,10,10,1);
1015     createNewCardType(4,9,10,1);
1016     createNewCardType(4,5,12,3);
1017     createNewCardType(4,5,11,3);
1018     createNewCardType(4,5,10,3);
1019     createNewCardType(4,200,3,2);
1020     hasInitCard1 = true;
1021   }
1022 
1023     function initCard2() onlyOwner() public {
1024     require(!hasInitCard2);
1025     createNewCardType(5,10,10,1);
1026     createNewCardType(5,8,10,1);
1027     createNewCardType(5,5,8,1);
1028     createNewCardType(5,3,10,3);
1029     createNewCardType(5,5,12,3);
1030     createNewCardType(5,3,11,3);
1031     createNewCardType(5,70,4,2);
1032     createNewCardType(6,10,10,1);
1033     createNewCardType(6,6,8,1);
1034     createNewCardType(6,5,8,1);
1035     createNewCardType(6,4,12,3);
1036     createNewCardType(6,5,12,3);
1037     createNewCardType(6,5,12,3);
1038     createNewCardType(6,80,5,2);
1039     createNewCardType(7,10,12,1);
1040     createNewCardType(7,100,4,2);
1041     createNewCardType(7,100,5,2);
1042     createNewCardType(7,100,4,2);
1043     createNewCardType(7,100,4,2);
1044     createNewCardType(7,100,4,2);
1045     createNewCardType(8,10,10,1);
1046     createNewCardType(8,9,10,1);
1047     createNewCardType(8,5,6,1);
1048     createNewCardType(8,4,12,3);
1049     createNewCardType(8,5,12,3);
1050     createNewCardType(8,4,12,3);
1051     createNewCardType(8,4,20,4);
1052     createNewCardType(9,10,10,1);
1053     createNewCardType(9,7,10,1);
1054     createNewCardType(9,1,20,1);
1055     createNewCardType(9,5,13,3);
1056     createNewCardType(9,5,13,3);
1057     createNewCardType(9,80,5,2);
1058     createNewCardType(9,90,5,2);
1059     createNewCardType(10,9,10,1);
1060     createNewCardType(10,10,10,1);
1061     createNewCardType(10,4,12,1);
1062     createNewCardType(10,80,5,2);
1063     createNewCardType(10,5,12,3);
1064     createNewCardType(10,5,12,3);
1065     hasInitCard2 = true;
1066   }
1067 
1068   /* Withdraw */
1069   /*
1070     NOTICE: These functions withdraw the developer's cut which is left
1071     in the contract by `buy`. User funds are immediately sent to the old
1072     owner in `buy`, no user funds are left in the contract.
1073   */
1074   function withdrawAll () onlyAdmins() public {
1075    msg.sender.transfer(address(this).balance);
1076   }
1077 
1078   function withdrawAmount (uint256 _amount) onlyAdmins() public {
1079     msg.sender.transfer(_amount);
1080   }
1081 
1082   /* ERC721 */
1083 
1084   function name() public pure returns (string) {
1085     return "Ethwuxia.pro";
1086   }
1087 
1088   function symbol() public pure returns (string) {
1089     return "EWX";
1090   }
1091 
1092   function totalSupply() public view returns (uint256) {
1093     return listedCard.length;
1094   }
1095 
1096   function balanceOf (address _owner) public view returns (uint256 _balance) {
1097     uint counter = 0;
1098 
1099     for (uint i = 0; i < listedCard.length; i++) {
1100       if (ownerOf(listedCard[i].cardId) == _owner) {
1101         counter++;
1102       }
1103     }
1104 
1105     return counter;
1106   }
1107 
1108   function ownerOf (uint256 _itemId) public view returns (address _owner) {
1109     return mapOwnerOfCard[_itemId];
1110   }
1111 
1112   function tokensOf (address _owner) public view returns (uint[]) {
1113     uint[] memory result = new uint[](balanceOf(_owner));
1114 
1115     uint256 itemCounter = 0;
1116     for (uint256 i = 0; i < listedCard.length; i++) {
1117       if (ownerOf(i) == _owner) {
1118         result[itemCounter] = listedCard[i].cardId;
1119         itemCounter += 1;
1120       }
1121     }
1122     return result;
1123   }
1124 
1125   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
1126     return mapOwnerOfCard[_itemId] != address(0);
1127   }
1128 
1129   function approvedFor(uint256 _itemId) public view returns (address _approved) {
1130     return approvedOfItem[_itemId];
1131   }
1132 
1133   function approve(address _to, uint256 _itemId) public {
1134     require(msg.sender != _to);
1135     require(tokenExists(_itemId));
1136     require(ownerOf(_itemId) == msg.sender);
1137 
1138     if (_to == 0) {
1139       if (approvedOfItem[_itemId] != 0) {
1140         delete approvedOfItem[_itemId];
1141         emit Approval(msg.sender, 0, _itemId);
1142       }
1143     } else {
1144       approvedOfItem[_itemId] = _to;
1145       emit Approval(msg.sender, _to, _itemId);
1146     }
1147   }
1148 
1149   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
1150   function transfer(address _to, uint256 _itemId) public {
1151     require(msg.sender == ownerOf(_itemId));
1152     _transfer(msg.sender, _to, _itemId);
1153   }
1154 
1155   function transferFrom(address _from, address _to, uint256 _itemId) public {
1156     require(approvedFor(_itemId) == msg.sender);
1157     _transfer(_from, _to, _itemId);
1158   }
1159 
1160   function _transfer(address _from, address _to, uint256 _itemId) internal {
1161     require(tokenExists(_itemId));
1162     require(ownerOf(_itemId) == _from);
1163     require(_to != address(0));
1164     require(_to != address(this));
1165     return ;  // disable card transfer
1166 
1167     mapOwnerOfCard[_itemId] = _to;
1168     approvedOfItem[_itemId] = 0;
1169 
1170     emit Transfer(_from, _to, _itemId);
1171   }
1172 
1173   /* Read */
1174   function isAdmin (address _admin) public view returns (bool _isAdmin) {
1175     return admins[_admin];
1176   }
1177 
1178   /* Util */
1179   function isContract(address addr) internal view returns (bool) {
1180     uint size;
1181     assembly { size := extcodesize(addr) } // solium-disable-line
1182     return size > 0;
1183   }
1184 }
1185 
1186 interface IItemRegistry {
1187   function itemsForSaleLimit (uint256 _from, uint256 _take) external view returns (uint256[] _items);
1188   function ownerOf (uint256 _itemId) external view returns (address _owner);
1189   function priceOf (uint256 _itemId) external view returns (uint256 _price);
1190 }