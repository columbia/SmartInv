1 pragma solidity ^0.4.18;
2 
3 // File: contracts\Auction.sol
4 
5 /**
6  * @title 竞拍接口
7  */
8 contract Auction {
9     function bid() public payable returns (bool);
10     function end() public returns (bool);
11 
12     event AuctionBid(address indexed from, uint256 value);
13 }
14 
15 // File: contracts\Base.sol
16 
17 library Base {
18     struct NTVUConfig {
19         uint bidStartValue;
20         int bidStartTime;
21         int bidEndTime;
22 
23         uint tvUseStartTime;
24         uint tvUseEndTime;
25 
26         bool isPrivate;
27         bool special;
28     }
29 }
30 
31 // File: contracts\ownership\Ownable.sol
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 }
57 
58 // File: contracts\util\SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65   /**
66   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 // File: contracts\token\ERC20Basic.sol
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 // File: contracts\token\BasicToken.sol
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   uint256 totalSupply_;
109 
110   /**
111   * @dev total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 // File: contracts\util\StringUtils.sol
145 
146 library StringUtils {
147     function uintToString(uint v) internal pure returns (string str) {
148         uint maxlength = 100;
149         bytes memory reversed = new bytes(maxlength);
150         uint i = 0;
151         while (v != 0) {
152             uint remainder = v % 10;
153             v = v / 10;
154             reversed[i++] = byte(48 + remainder);
155         }
156 
157         bytes memory s = new bytes(i);
158         for (uint j = 0; j < i; j++) {
159             s[j] = reversed[i - 1 - j];
160         }
161 
162         str = string(s);
163     }
164 
165     function concat(string _base, string _value) internal pure returns (string) {
166         bytes memory _baseBytes = bytes(_base);
167         bytes memory _valueBytes = bytes(_value);
168 
169         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
170         bytes memory _newValue = bytes(_tmpValue);
171 
172         uint i;
173         uint j;
174 
175         for(i=0; i<_baseBytes.length; i++) {
176             _newValue[j++] = _baseBytes[i];
177         }
178 
179         for(i=0; i<_valueBytes.length; i++) {
180             _newValue[j++] = _valueBytes[i];
181         }
182 
183         return string(_newValue);
184     }
185 
186     function bytesToBytes32(bytes memory source) internal pure returns (bytes32 result) {
187         require(source.length <= 32);
188 
189         if (source.length == 0) {
190             return 0x0;
191         }
192 
193         assembly {
194             result := mload(add(source, 32))
195         }
196     }
197 
198     function toBytes96(string memory text) internal pure returns (bytes32, bytes32, bytes32, uint8) {
199         bytes memory temp = bytes(text);
200         len = uint8(temp.length);
201         require(len <= 96);
202 
203         uint8 i=0;
204         uint8 j=0;
205         uint8 k=0;
206 
207         string memory _b1 = new string(32);
208         bytes memory b1 = bytes(_b1);
209 
210         string memory _b2 = new string(32);
211         bytes memory b2 = bytes(_b2);
212 
213         string memory _b3 = new string(32);
214         bytes memory b3 = bytes(_b3);
215 
216         uint8 len;
217 
218         for(i=0; i<len; i++) {
219             k = i / 32;
220             j = i % 32;
221 
222             if (k == 0) {
223                 b1[j] = temp[i];
224             } else if(k == 1) {
225                 b2[j] = temp[i];
226             } else if(k == 2) {
227                 b3[j] = temp[i];
228             } 
229         }
230 
231         return (bytesToBytes32(b1), bytesToBytes32(b2), bytesToBytes32(b3), len);
232     }
233 
234     function fromBytes96(bytes32 b1, bytes32 b2, bytes32 b3, uint8 len) internal pure returns (string) {
235         require(len <= 96);
236         string memory _tmpValue = new string(len);
237         bytes memory temp = bytes(_tmpValue);
238 
239         uint8 i;
240         uint8 j = 0;
241 
242         for(i=0; i<32; i++) {
243             if (j >= len) break;
244             temp[j++] = b1[i];
245         }
246 
247         for(i=0; i<32; i++) {
248             if (j >= len) break;
249             temp[j++] = b2[i];
250         }
251 
252         for(i=0; i<32; i++) {
253             if (j >= len) break;
254             temp[j++] = b3[i];
255         }
256 
257         return string(temp);
258     }
259 }
260 
261 // File: contracts\NTVUToken.sol
262 
263 /**
264  * 链上真心话时段币
265  */
266 contract NTVUToken is BasicToken, Ownable, Auction {
267     string public name;
268     string public symbol = "FOT";
269 
270     uint8 public number = 0;
271     uint8 public decimals = 0;
272     uint public INITIAL_SUPPLY = 1;
273 
274     uint public bidStartValue;
275     uint public bidStartTime;
276     uint public bidEndTime;
277 
278     uint public tvUseStartTime;
279     uint public tvUseEndTime;
280 
281     bool public isPrivate = false;
282 
283     uint public maxBidValue;
284     address public maxBidAccount;
285 
286     bool internal auctionEnded = false;
287 
288     string public text; // 用户配置文本
289     string public auditedText; // 审核通过的文本
290     string public defaultText; // 默认文本
291     uint8 public auditStatus = 0; // 0:未审核；1:审核通过；2:审核不通过
292 
293     uint32 public bidCount;
294     uint32 public auctorCount;
295 
296     mapping(address => bool) acutors;
297 
298     address public ethSaver; // 竞拍所得ETH保管者
299 
300     /**
301      * 时段币合约构造函数
302      *
303      * 拍卖期间如有更高出价，前一手出价者的以太坊自动退回其钱包
304      *
305      * @param _number 时段币的序号，从0开始
306      * @param _bidStartValue 起拍价，单位 wei
307      * @param _bidStartTime 起拍/私募开始时间，单位s
308      * @param _bidEndTime 起拍/私募结束时间，单位s
309      * @param _tvUseStartTime 时段币文本开始播放时间
310      * @param _tvUseEndTime 时段币文本结束播放时间
311      * @param _isPrivate 是否为私募
312      * @param _defaultText 默认文本
313      * @param _ethSaver 竞拍所得保管着
314      */
315     function NTVUToken(uint8 _number, uint _bidStartValue, uint _bidStartTime, uint _bidEndTime, uint _tvUseStartTime, uint _tvUseEndTime, bool _isPrivate, string _defaultText, address _ethSaver) public {
316         number = _number;
317 
318         if (_number + 1 < 10) {
319             symbol = StringUtils.concat(symbol, StringUtils.concat("0", StringUtils.uintToString(_number + 1)));
320         } else {
321             symbol = StringUtils.concat(symbol, StringUtils.uintToString(_number + 1));
322         }
323 
324         name = symbol;
325         totalSupply_ = INITIAL_SUPPLY;
326         balances[msg.sender] = INITIAL_SUPPLY;
327 
328         bidStartValue = _bidStartValue;
329         bidStartTime = _bidStartTime;
330         bidEndTime = _bidEndTime;
331 
332         tvUseStartTime = _tvUseStartTime;
333         tvUseEndTime = _tvUseEndTime;
334 
335         isPrivate = _isPrivate;
336 
337         defaultText = _defaultText;
338 
339         ethSaver = _ethSaver;
340     }
341 
342     /**
343      * 竞拍出价
344      *
345      * 拍卖期间如有更高出价，前一手出价者的以太坊自动退回其钱包
346      */
347     function bid() public payable returns (bool) {
348         require(now >= bidStartTime); // 竞拍开始时间到后才能竞拍
349         require(now < bidEndTime); // 竞拍截止时间到后不能再竞拍
350         require(msg.value >= bidStartValue); // 拍卖金额需要大于起拍价
351         require(msg.value >= maxBidValue + 0.05 ether); // 最低0.05ETH加价
352         require(!isPrivate || (isPrivate && maxBidAccount == address(0))); // 竞拍或者私募第一次出价
353 
354         // 如果上次有人出价，将上次出价的ETH退还给他
355         if (maxBidAccount != address(0)) {
356             maxBidAccount.transfer(maxBidValue);
357         } 
358         
359         maxBidAccount = msg.sender;
360         maxBidValue = msg.value;
361         AuctionBid(maxBidAccount, maxBidValue); // 发出有人出价事件
362 
363         // 统计出价次数
364         bidCount++;
365 
366         // 统计出价人数
367         bool bided = acutors[msg.sender];
368         if (!bided) {
369             auctorCount++;
370             acutors[msg.sender] = true;
371         }
372     }
373 
374     /**
375      * 竞拍结束
376      *
377      * 拍卖结束后，系统确认交易，出价最高者获得该时段Token。
378      */
379     function end() public returns (bool) {
380         require(!auctionEnded); // 已经结束竞拍了不能再结束
381         require((now >= bidEndTime) || (isPrivate && maxBidAccount != address(0))); // 普通竞拍拍卖结束后才可以结束竞拍，私募只要出过价就可以结束竞拍
382    
383         // 如果有人出价，将时段代币转给出价最高的人
384         if (maxBidAccount != address(0)) {
385             address _from = owner;
386             address _to = maxBidAccount;
387             uint _value = INITIAL_SUPPLY;
388 
389             // 将时段币转给出价最高的人
390             balances[_from] = balances[_from].sub(_value);
391             balances[_to] = balances[_to].add(_value);
392             Transfer(_from, _to, _value); // 通知出价最高的人收到时段币了
393 
394             //将时段币中ETH转给ethSaver
395             ethSaver.transfer(this.balance);
396         }
397 
398         auctionEnded = true;
399     }
400 
401     /**
402      * 配置上链文本
403      *
404      * 购得时段后（包含拍卖和私募），可以设置时段文本
405      * 每时段文字接受中文30字以内（含标点和空格），多出字符不显示。
406      * 审核截止时间是，每个时段播出前30分钟
407      */
408     function setText(string _text) public {
409         require(INITIAL_SUPPLY == balances[msg.sender]); // 拥有时段币的人可以设置文本
410         require(bytes(_text).length > 0 && bytes(_text).length <= 90); // 汉字使用UTF8编码，1个汉字最多占用3个字节，所以最多写90个字节的字
411         require(now < tvUseStartTime - 30 minutes); // 开播前30分钟不能再设置文本
412 
413         text = _text;
414     }
415 
416     function getTextBytes96() public view returns(bytes32, bytes32, bytes32, uint8) {
417         return StringUtils.toBytes96(text);
418     }
419 
420     /**
421      * 审核文本
422      */
423     function auditText(uint8 _status, string _text) external onlyOwner {
424         require((now >= tvUseStartTime - 30 minutes) && (now < tvUseEndTime)); // 时段播出前30分钟为审核时间，截止到时段播出结束时间
425         auditStatus = _status;
426 
427         if (_status == 2) { // 审核失败，更新审核文本
428             auditedText = _text;
429         } else if (_status == 1) { // 审核通过使用用户设置的文本
430             auditedText = text; 
431         }
432     }
433 
434     /**
435      * 获取显示文本
436      */
437     function getShowText() public view returns(string) {
438         if (auditStatus == 1 || auditStatus == 2) { // 审核过了
439             return auditedText;
440         } else { // 没有审核，显示默认文本
441             return defaultText;
442         }
443     }
444 
445     function getShowTextBytes96() public view returns(bytes32, bytes32, bytes32, uint8) {
446         return StringUtils.toBytes96(getShowText());
447     }
448 
449     /**
450      * 转账代币
451      *
452      * 获得时段后，时段播出前，不可以转卖。时段播出后，可以作为纪念币转卖
453      */
454     function transfer(address _to, uint256 _value) public returns (bool) {
455         require(now >= tvUseEndTime); // 时段播出后，可以转卖。
456 
457         super.transfer(_to, _value);
458     }
459 
460     /**
461      * 获取时段币状态信息
462      *
463      */
464     function getInfo() public view returns(
465         string _symbol,
466         string _name,
467         uint _bidStartValue, 
468         uint _bidStartTime, 
469         uint _bidEndTime, 
470         uint _tvUseStartTime,
471         uint _tvUseEndTime,
472         bool _isPrivate
473         ) {
474         _symbol = symbol;
475         _name = name;
476 
477         _bidStartValue = bidStartValue;
478         _bidStartTime = bidStartTime;
479         _bidEndTime = bidEndTime;
480 
481         _tvUseStartTime = tvUseStartTime;
482         _tvUseEndTime = tvUseEndTime;
483 
484         _isPrivate = isPrivate;
485     }
486 
487     /**
488      * 获取时段币可变状态信息
489      *
490      */
491     function getMutalbeInfo() public view returns(
492         uint _maxBidValue,
493         address _maxBidAccount,
494         bool _auctionEnded,
495         string _text,
496         uint8 _auditStatus,
497         uint8 _number,
498         string _auditedText,
499         uint32 _bidCount,
500         uint32 _auctorCount
501         ) {
502         _maxBidValue = maxBidValue;
503         _maxBidAccount = maxBidAccount;
504 
505         _auctionEnded = auctionEnded;
506 
507         _text = text;
508         _auditStatus = auditStatus;
509 
510         _number = number;
511         _auditedText = auditedText;
512 
513         _bidCount = bidCount;
514         _auctorCount = auctorCount;
515     }
516 
517     /**
518      * 提取以太坊到ethSaver
519      */
520     function reclaimEther() external onlyOwner {
521         require((now > bidEndTime) || (isPrivate && maxBidAccount != address(0))); // 普通竞拍拍卖结束后或者私募完成后，可以提币到ethSaver。
522         ethSaver.transfer(this.balance);
523     }
524 
525     /**
526      * 默认给合约转以太坊就是出价
527      */
528     function() payable public {
529         bid(); // 出价
530     }
531 }
532 
533 // File: contracts\NTVToken.sol
534 
535 /**
536  * 链上真心话合约
537  */
538 contract NTVToken is Ownable {
539     using SafeMath for uint256;
540 
541     uint8 public MAX_TIME_RANGE_COUNT = 66; // 最多发行66个时段代币
542 
543     bool public isRunning; // 是否启动运行
544 
545     uint public onlineTime; // 上线时间，第一时段上电视的时间
546     uint8 public totalTimeRange; // 当前已经释放的总的时段数
547     mapping(uint => address) internal timeRanges; // 每个时段的合约地址，编号从0开始
548 
549     string public defaultText = "浪花有意千里雪，桃花无言一队春。"; // 忘记审核使用的默认文本
550 
551     mapping(uint8 => Base.NTVUConfig) internal dayConfigs; // 每天时段配置
552     mapping(uint8 => Base.NTVUConfig) internal specialConfigs; // 特殊时段配置
553 
554     address public ethSaver; // 竞拍所得ETH保管者
555 
556     event OnTV(address indexed ntvu, address indexed winer, string text); // 文本上电视
557 
558     /**
559      * 佛系电视合约构造函数
560      */
561     function NTVToken() public {}
562 
563     /**
564      * 启动区块链电视
565      *
566      * @param _onlineTime 区块链电视上线时间，必须为整点，例如 2018-03-26 00:00:00
567      * @param _ethSaver 竞拍所得ETH保管者
568      */
569     function startup(uint256 _onlineTime, address _ethSaver) public onlyOwner {
570         require(!isRunning); // 只能上线一次，上线后不能停止
571         require((_onlineTime - 57600) % 1 days == 0); // 上线时间只能是整天时间，57600为北京时间的'1970/1/2 0:0:0'
572         require(_onlineTime >= now); // 上线时间需要大于当前时间
573         require(_ethSaver != address(0));
574 
575         onlineTime = _onlineTime;
576         ethSaver = _ethSaver;
577 
578         isRunning = true;
579 
580         // ---------------------------
581         // 每天的时段配置，共6个时段
582         //
583         // 通用规则：
584         // 1、首拍后，每天18:30-22:00为竞拍时间
585         // ---------------------------
586         uint8[6] memory tvUseStartTimes = [0, 10, 12, 18, 20, 22]; // 电视使用开始时段
587         uint8[6] memory tvUseEndTimes = [2, 12, 14, 20, 22, 24]; // 电视使用结束时段
588 
589         for (uint8 i=0; i<6; i++) {
590             dayConfigs[i].bidStartValue = 0.1 ether; // 正常起拍价0.1ETH
591             dayConfigs[i].bidStartTime = 18 hours + 30 minutes - 1 days; // 一天前晚上 18:30起拍
592             dayConfigs[i].bidEndTime = 22 hours - 1 days; // 一天前晚上 22:00 结束拍卖
593 
594             dayConfigs[i].tvUseStartTime = uint(tvUseStartTimes[i]) * 1 hours;
595             dayConfigs[i].tvUseEndTime = uint(tvUseEndTimes[i]) * 1 hours;
596 
597             dayConfigs[i].isPrivate = false; // 正常都是竞拍，非私募
598         }
599 
600         // ---------------------------
601         // 特殊时段配置
602         // ---------------------------
603 
604         // 首拍，第1天的6个时段都是首拍，拍卖时间从两天前的18:30到一天前的22:00
605         for(uint8 p=0; p<6; p++) {
606             specialConfigs[p].special = true;
607             
608             specialConfigs[p].bidStartValue = 0.1 ether; // 起拍价0.1ETH
609             specialConfigs[p].bidStartTime = 18 hours + 30 minutes - 2 days; // 两天前的18:30
610             specialConfigs[p].bidEndTime = 22 hours - 1 days; // 一天前的22:00
611             specialConfigs[p].isPrivate = false; // 非私募
612         }
613     }
614 
615     /**
616      * 获取区块的时间戳，单位s
617      */
618     function time() constant internal returns (uint) {
619         return block.timestamp;
620     }
621 
622     /**
623      * 获取某个时间是上线第几天，第1天返回1，上线之前返回0
624      * 
625      * @param timestamp 时间戳
626      */
627     function dayFor(uint timestamp) constant public returns (uint) {
628         return timestamp < onlineTime
629             ? 0
630             : (timestamp.sub(onlineTime) / 1 days) + 1;
631     }
632 
633     /**
634      * 获取当前时间是今天的第几个时段，第一个时段返回1，没有匹配的返回0
635      *
636      * @param timestamp 时间戳
637      */
638     function numberFor(uint timestamp) constant public returns (uint8) {
639         if (timestamp >= onlineTime) {
640             uint current = timestamp.sub(onlineTime) % 1 days;
641 
642             for(uint8 i=0; i<6; i++) {
643                 if (dayConfigs[i].tvUseStartTime<=current && current<dayConfigs[i].tvUseEndTime) {
644                     return (i + 1);
645                 }
646             }
647         }
648 
649         return 0;
650     }
651 
652     /**
653      * 创建时段币
654      */
655     function createNTVU() public onlyOwner {
656         require(isRunning);
657         require(totalTimeRange < MAX_TIME_RANGE_COUNT);
658 
659         uint8 number = totalTimeRange++;
660         uint8 day = number / 6;
661         uint8 num = number % 6;
662 
663         Base.NTVUConfig memory cfg = dayConfigs[num]; // 读取每天时段的默认配置
664 
665         // 如果有特殊配置则覆盖
666         Base.NTVUConfig memory expCfg = specialConfigs[number];
667         if (expCfg.special) {
668             cfg.bidStartValue = expCfg.bidStartValue;
669             cfg.bidStartTime = expCfg.bidStartTime;
670             cfg.bidEndTime = expCfg.bidEndTime;
671             cfg.isPrivate = expCfg.isPrivate;
672         }
673 
674         // 根据上线时间计算具体的时段时间
675         uint bidStartTime = uint(int(onlineTime) + day * 24 hours + cfg.bidStartTime);
676         uint bidEndTime = uint(int(onlineTime) + day * 24 hours + cfg.bidEndTime);
677         uint tvUseStartTime = onlineTime + day * 24 hours + cfg.tvUseStartTime;
678         uint tvUseEndTime = onlineTime + day * 24 hours + cfg.tvUseEndTime;
679 
680         timeRanges[number] = new NTVUToken(number, cfg.bidStartValue, bidStartTime, bidEndTime, tvUseStartTime, tvUseEndTime, cfg.isPrivate, defaultText, ethSaver);
681     }
682 
683     /**
684      * 查询所有时段
685      */
686     function queryNTVUs(uint startIndex, uint count) public view returns(address[]){
687         startIndex = (startIndex < totalTimeRange)? startIndex : totalTimeRange;
688         count = (startIndex + count < totalTimeRange) ? count : (totalTimeRange - startIndex);
689 
690         address[] memory result = new address[](count);
691         for(uint i=0; i<count; i++) {
692             result[i] = timeRanges[startIndex + i];
693         }
694 
695         return result;
696     }
697 
698     /**
699      * 查询当前正在播放的时段
700      */
701     function playingNTVU() public view returns(address){
702         uint day = dayFor(time());
703         uint8 num = numberFor(time());
704 
705         if (day>0 && (num>0 && num<=6)) {
706             day = day - 1;
707             num = num - 1;
708 
709             return timeRanges[day * 6 + uint(num)];
710         } else {
711             return address(0);
712         }
713     }
714 
715     /**
716      * 审核文本
717      */
718     function auditNTVUText(uint8 index, uint8 status, string _text) public onlyOwner {
719         require(isRunning); // 合约启动后才能审核
720         require(index >= 0 && index < totalTimeRange); //只能审核已经上线的时段
721         require(status==1 || (status==2 && bytes(_text).length>0 && bytes(_text).length <= 90)); // 审核不通，需要配置文本
722 
723         address ntvu = timeRanges[index];
724         assert(ntvu != address(0));
725 
726         NTVUToken ntvuToken = NTVUToken(ntvu);
727         ntvuToken.auditText(status, _text);
728 
729         var (b1, b2, b3, len) = ntvuToken.getShowTextBytes96();
730         var auditedText = StringUtils.fromBytes96(b1, b2, b3, len);
731         OnTV(ntvuToken, ntvuToken.maxBidAccount(), auditedText); // 审核后的文本记录到日志中
732     }
733 
734     /**
735      * 获取电视播放文本
736      */
737     function getText() public view returns(string){
738         address playing = playingNTVU();
739 
740         if (playing != address(0)) {
741             NTVUToken ntvuToken = NTVUToken(playing);
742 
743             var (b1, b2, b3, len) = ntvuToken.getShowTextBytes96();
744             return StringUtils.fromBytes96(b1, b2, b3, len);
745         } else {
746             return ""; // 当前不是播放时段，返回空文本
747         }
748     }
749 
750     /**
751      * 获取竞拍状态
752      */
753     function status() public view returns(uint8) {
754         if (!isRunning) {
755             return 0; // 未启动拍卖
756         } else if (time() < onlineTime) {
757             return 1; // 未到首播时间
758         } else {
759             if (totalTimeRange == 0) {
760                 return 2; // 没有创建播放时段
761             } else {
762                 if (time() < NTVUToken(timeRanges[totalTimeRange - 1]).tvUseEndTime()) {
763                     return 3; // 整个竞拍活动进行中
764                 } else {
765                     return 4; // 整个竞拍活动已结束
766                 }
767             }
768         }
769     }
770     
771     /**
772      * 获取总的竞拍人数
773      */
774     function totalAuctorCount() public view returns(uint32) {
775         uint32 total = 0;
776 
777         for(uint8 i=0; i<totalTimeRange; i++) {
778             total += NTVUToken(timeRanges[i]).auctorCount();
779         }
780 
781         return total;
782     }
783 
784     /**
785      * 获取总的竞拍次数
786      */
787     function totalBidCount() public view returns(uint32) {
788         uint32 total = 0;
789 
790         for(uint8 i=0; i<totalTimeRange; i++) {
791             total += NTVUToken(timeRanges[i]).bidCount();
792         }
793 
794         return total;
795     }
796 
797     /**
798      * 获取总的出价ETH
799      */
800     function totalBidEth() public view returns(uint) {
801         uint total = 0;
802 
803         for(uint8 i=0; i<totalTimeRange; i++) {
804             total += NTVUToken(timeRanges[i]).balance;
805         }
806 
807         total += this.balance;
808         total += ethSaver.balance;
809 
810         return total;
811     }
812 
813     /**
814      * 获取历史出价最高的ETH
815      */
816     function maxBidEth() public view returns(uint) {
817         uint maxETH = 0;
818 
819         for(uint8 i=0; i<totalTimeRange; i++) {
820             uint val = NTVUToken(timeRanges[i]).maxBidValue();
821             maxETH =  (val > maxETH) ? val : maxETH;
822         }
823 
824         return maxETH;
825     }
826 
827     /**
828      * 提取当前合约的ETH到ethSaver
829      */
830     function reclaimEther() public onlyOwner {
831         require(isRunning);
832 
833         ethSaver.transfer(this.balance);
834     }
835 
836     /**
837      * 提取时段币的ETH到ethSaver
838      */
839     function reclaimNtvuEther(uint8 index) public onlyOwner {
840         require(isRunning);
841         require(index >= 0 && index < totalTimeRange); //只能审核已经上线的时段
842 
843         NTVUToken(timeRanges[index]).reclaimEther();
844     }
845 
846     /**
847      * 接收ETH
848      */
849     function() payable external {}
850 }