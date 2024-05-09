1 pragma solidity ^0.4.24;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) public onlyOwner {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) public onlyOwner {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42 
43     function RemoveModerator(address _oldModerator) public onlyOwner {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) public onlyOwner {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 interface ERC20 {
56     function totalSupply() public view returns (uint supply);
57     function balanceOf(address _owner) public view returns (uint balance);
58     function transfer(address _to, uint _value) public returns (bool success);
59     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
60     function approve(address _spender, uint _value) public returns (bool success);
61     function allowance(address _owner, address _spender) public view returns (uint remaining);
62     function decimals() public view returns(uint digits);
63     event Approval(address indexed _owner, address indexed _spender, uint _value);
64 }
65 
66 contract EtheremonDataBase {
67     uint64 public totalMonster;
68     uint32 public totalClass;
69 
70     // write
71     function addElementToArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint8 _value) external returns(uint);
72     function addMonsterObj(uint32 _classId, address _trainer, string _name) external returns(uint64);
73     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) external;
74 
75     // read
76     function getElementInArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index) external constant returns(uint8);
77     function getMonsterClass(uint32 _classId) external constant returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
78     function getMonsterObj(uint64 _objId) external constant returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
79 }
80 
81 contract EtheremonEnum {
82     enum ResultCode {
83         SUCCESS,
84         ERROR_CLASS_NOT_FOUND,
85         ERROR_LOW_BALANCE,
86         ERROR_SEND_FAIL,
87         ERROR_NOT_TRAINER,
88         ERROR_NOT_ENOUGH_MONEY,
89         ERROR_INVALID_AMOUNT
90     }
91 
92     enum ArrayType {
93         CLASS_TYPE,
94         STAT_STEP,
95         STAT_START,
96         STAT_BASE,
97         OBJ_SKILL
98     }
99 
100     enum PropertyType {
101         ANCESTOR,
102         XFACTOR
103     }
104 }
105 
106 interface EtheremonMonsterNFTInterface {
107    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
108    function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);
109 }
110 
111 contract EtheremonWorldNFT is BasicAccessControl {
112     uint8 constant public STAT_COUNT = 6;
113     uint8 constant public STAT_MAX = 32;
114 
115     struct MonsterClassAcc {
116         uint32 classId;
117         uint256 price;
118         uint256 returnPrice;
119         uint32 total;
120         bool catchable;
121     }
122 
123     struct MonsterObjAcc {
124         uint64 monsterId;
125         uint32 classId;
126         address trainer;
127         string name;
128         uint32 exp;
129         uint32 createIndex;
130         uint32 lastClaimIndex;
131         uint createTime;
132     }
133 
134     address public dataContract;
135     address public monsterNFT;
136 
137     mapping(uint32 => bool) public classWhitelist;
138     mapping(address => bool) public addressWhitelist;
139 
140     uint public gapFactor = 5;
141     uint public priceIncreasingRatio = 1000;
142 
143     function setContract(address _dataContract, address _monsterNFT) external onlyModerators {
144         dataContract = _dataContract;
145         monsterNFT = _monsterNFT;
146     }
147 
148     function setConfig(uint _gapFactor, uint _priceIncreasingRatio) external onlyModerators {
149         gapFactor = _gapFactor;
150         priceIncreasingRatio = _priceIncreasingRatio;
151     }
152 
153     function setClassWhitelist(uint32 _classId, bool _status) external onlyModerators {
154         classWhitelist[_classId] = _status;
155     }
156 
157     function setAddressWhitelist(address _smartcontract, bool _status) external onlyModerators {
158         addressWhitelist[_smartcontract] = _status;
159     }
160 
161     function mintMonster(uint32 _classId, address _trainer, string _name) external onlyModerators returns(uint) {
162         EtheremonDataBase data = EtheremonDataBase(dataContract);
163         // add monster
164         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
165         uint8 value;
166         uint seed = getRandom(_trainer, block.number-1, objId);
167         // generate base stat for the previous one
168         for (uint i=0; i < STAT_COUNT; i += 1) {
169             seed /= 100;
170             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
171             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
172         }
173 
174         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _trainer, objId);
175         return objId;
176     }
177 
178     function burnMonster(uint64 _tokenId) external onlyModerators {
179         // need to check condition before calling this function
180         EtheremonDataBase data = EtheremonDataBase(dataContract);
181         MonsterObjAcc memory obj;
182         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_tokenId);
183         require(obj.trainer != address(0));
184         data.removeMonsterIdMapping(obj.trainer, _tokenId);
185         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(obj.trainer, address(0), _tokenId);
186     }
187 
188     function catchMonsterNFT(uint32 _classId, string _name) external isActive payable {
189         EtheremonDataBase data = EtheremonDataBase(dataContract);
190         MonsterClassAcc memory class;
191         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
192         if (class.classId == 0 || class.catchable == false) {
193             revert();
194         }
195 
196         uint price = class.price;
197         if (class.total > 0)
198             price += class.price*(class.total-1)/priceIncreasingRatio;
199         if (msg.value < price) {
200             revert();
201         }
202 
203         // add new monster
204         uint64 objId = data.addMonsterObj(_classId, msg.sender, _name);
205         uint8 value;
206         uint seed = getRandom(msg.sender, block.number-1, objId);
207         // generate base stat for the previous one
208         for (uint i=0; i < STAT_COUNT; i += 1) {
209             seed /= 100;
210             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
211             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
212         }
213 
214         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), msg.sender, objId);
215         // refund extra
216         if (msg.value > price) {
217             msg.sender.transfer((msg.value - price));
218         }
219     }
220 
221     // for whitelist contracts, no refund extra
222     function catchMonster(address _player, uint32 _classId, string _name) external isActive payable returns(uint tokenId) {
223         if (addressWhitelist[msg.sender] == false) {
224             revert();
225         }
226 
227         EtheremonDataBase data = EtheremonDataBase(dataContract);
228         MonsterClassAcc memory class;
229         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
230         if (class.classId == 0) {
231             revert();
232         }
233 
234         if (class.catchable == false && classWhitelist[_classId] == false) {
235             revert();
236         }
237 
238         uint price = class.price;
239         if (class.total > gapFactor) {
240             price += class.price*(class.total - gapFactor)/priceIncreasingRatio;
241         }
242         if (msg.value < price) {
243             revert();
244         }
245 
246         // add new monster
247         uint64 objId = data.addMonsterObj(_classId, _player, _name);
248         uint8 value;
249         uint seed = getRandom(_player, block.number-1, objId);
250         // generate base stat for the previous one
251         for (uint i=0; i < STAT_COUNT; i += 1) {
252             seed /= 100;
253             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
254             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
255         }
256 
257         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _player, objId);
258         return objId;
259     }
260 
261     function getMonsterClassBasic(uint32 _classId) external constant returns(uint256, uint256, uint256, bool) {
262         EtheremonDataBase data = EtheremonDataBase(dataContract);
263         MonsterClassAcc memory class;
264         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
265         return (class.price, class.returnPrice, class.total, class.catchable);
266     }
267 
268     function getPrice(uint32 _classId) external constant returns(bool catchable, uint price) {
269         EtheremonDataBase data = EtheremonDataBase(dataContract);
270         MonsterClassAcc memory class;
271         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
272 
273         price = class.price;
274         if (class.total > 0)
275             price += class.price*(class.total-1)/priceIncreasingRatio;
276 
277         if (class.catchable == false) {
278             return (classWhitelist[_classId], price);
279         } else {
280             return (true, price);
281         }
282     }
283 
284     // public api
285     function getRandom(address _player, uint _block, uint _count) public view returns(uint) {
286         return uint(keccak256(abi.encodePacked(blockhash(_block), _player, _count)));
287     }
288 
289     function withdrawEther(address _sendTo, uint _amount) public onlyOwner {
290         if (_amount > address(this).balance) {
291             revert();
292         }
293         _sendTo.transfer(_amount);
294     }
295 }
296 
297 interface KyberNetworkProxyInterface {
298     function maxGasPrice() public view returns(uint);
299     function getUserCapInWei(address user) public view returns(uint);
300     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
301     function enabled() public view returns(bool);
302     function info(bytes32 id) public view returns(uint);
303 
304     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
305         returns (uint expectedRate, uint slippageRate);
306 
307     function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount,
308         uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
309 }
310 
311 contract Utils {
312 
313     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
314     uint  constant internal PRECISION = (10**18);
315     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
316     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
317     uint  constant internal MAX_DECIMALS = 18;
318     uint  constant internal ETH_DECIMALS = 18;
319     mapping(address=>uint) internal decimals;
320 
321     function setDecimals(ERC20 token) internal {
322         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
323         else decimals[token] = token.decimals();
324     }
325 
326     function getDecimals(ERC20 token) internal view returns(uint) {
327         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
328         uint tokenDecimals = decimals[token];
329         // technically, there might be token with decimals 0
330         // moreover, very possible that old tokens have decimals 0
331         // these tokens will just have higher gas fees.
332         if(tokenDecimals == 0) return token.decimals();
333 
334         return tokenDecimals;
335     }
336 
337     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
338         require(srcQty <= MAX_QTY);
339         require(rate <= MAX_RATE);
340 
341         if (dstDecimals >= srcDecimals) {
342             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
343             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
344         } else {
345             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
346             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
347         }
348     }
349 
350     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
351         require(dstQty <= MAX_QTY);
352         require(rate <= MAX_RATE);
353         
354         //source quantity is rounded up. to avoid dest quantity being too low.
355         uint numerator;
356         uint denominator;
357         if (srcDecimals >= dstDecimals) {
358             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
359             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
360             denominator = rate;
361         } else {
362             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
363             numerator = (PRECISION * dstQty);
364             denominator = (rate * (10**(dstDecimals - srcDecimals)));
365         }
366         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
367     }
368 }
369 
370 contract Utils2 is Utils {
371 
372     /// @dev get the balance of a user.
373     /// @param token The token type
374     /// @return The balance
375     function getBalance(ERC20 token, address user) public view returns(uint) {
376         if (token == ETH_TOKEN_ADDRESS)
377             return user.balance;
378         else
379             return token.balanceOf(user);
380     }
381 
382     function getDecimalsSafe(ERC20 token) internal returns(uint) {
383 
384         if (decimals[token] == 0) {
385             setDecimals(token);
386         }
387 
388         return decimals[token];
389     }
390 
391     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
392         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
393     }
394 
395     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
396         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
397     }
398 
399     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
400         internal pure returns(uint)
401     {
402         require(srcAmount <= MAX_QTY);
403         require(destAmount <= MAX_QTY);
404 
405         if (dstDecimals >= srcDecimals) {
406             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
407             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
408         } else {
409             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
410             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
411         }
412     }
413 }
414 
415 interface WrapEtheremonInterface {
416     /// @notice Can only be called by operators
417     /// @dev Sets the KyberNetwork address
418     /// @param _KyberNetwork KyberNetwork contract address
419     function setKyberNetwork(address _KyberNetwork) public;
420 
421     /// @dev Get the ETH price of the Etheremon monster and if it is catchable
422     /// @param _etheremon EtheremonWorldNFT address
423     /// @param _classId Class ID of monster
424     /// @param _payPrice Price of monster passed from Etheremon server
425     /// @return catchable, monsterInETH
426     function getMonsterPriceInETH(
427         EtheremonWorldNFT _etheremon,
428         uint32 _classId,
429         uint _payPrice
430     )
431         public
432         view
433         returns (
434             bool catchable,
435             uint monsterInETH
436         );
437 
438     /// @dev Get the rates of the Etheremon monster
439     /// @param _kyberProxy KyberNetworkProxyInterface address
440     /// @param token ERC20 token address
441     /// @param monsterInETH Price of the monster in ETH
442     /// @return expectedRate, slippageRate
443     function getMonsterRates(
444         KyberNetworkProxyInterface _kyberProxy,
445         ERC20 token,
446         uint monsterInETH
447     )
448         public
449         view
450         returns (
451             uint expectedRate,
452             uint slippageRate
453         );
454 
455     /// @dev Get the token price and rates of the Etheremon monster
456     /// @param token ERC20 token address
457     /// @param expectedRate Expected rate of ETH to token
458     /// @param monsterInETH Price of the monster in ETH
459     /// @return monsterInTokens
460     function getMonsterPriceInTokens(
461         ERC20 token,
462         uint expectedRate,
463         uint monsterInETH
464     )
465         public
466         view
467         returns (uint monsterInTokens);
468 
469     /// @dev Acquires the monster from Etheremon using tokens
470     /// @param _kyberProxy KyberNetworkProxyInterface address
471     /// @param _etheremon EtheremonWorldNFT address
472     /// @param _classId Class ID of monster
473     /// @param _name Name of the monster
474     /// @param token ERC20 token address
475     /// @param tokenQty Amount of tokens to be transferred by user
476     /// @param maxDestQty Actual amount of ETH needed to purchase the monster
477     /// @param minRate The minimum rate or slippage rate.
478     /// @param walletId Wallet ID where Kyber referral fees will be sent to
479     /// @return monsterId
480     function catchMonster(
481         KyberNetworkProxyInterface _kyberProxy,
482         EtheremonWorldNFT _etheremon,
483         uint32 _classId,
484         string _name,
485         ERC20 token,
486         uint tokenQty,
487         uint maxDestQty,
488         uint minRate,
489         address walletId
490     )
491         public
492         returns (uint monsterId);
493 }
494 
495 contract WrapEtheremonPermissions {
496     event TransferAdmin(address newAdmin);
497     event OperatorAdded(address newOperator, bool isAdd);
498 
499     address public admin;
500     address[] public operatorsGroup;
501     mapping(address=>bool) internal operators;
502     uint constant internal MAX_GROUP_SIZE = 50;
503 
504     constructor () public {
505         admin = msg.sender;
506     }
507 
508     modifier onlyAdmin() {
509         require(msg.sender == admin);
510         _;
511     }
512 
513     modifier onlyOperator() {
514         require(operators[msg.sender]);
515         _;
516     }
517 
518     function transferAdmin(address newAdmin) public onlyAdmin {
519         require(newAdmin != address(0));
520         emit TransferAdmin(newAdmin);
521         admin = newAdmin;
522     }
523 
524     function addOperator(address newOperator) public onlyAdmin {
525         require(!operators[newOperator]);
526         require(operatorsGroup.length < MAX_GROUP_SIZE);
527 
528         emit OperatorAdded(newOperator, true);
529         operators[newOperator] = true;
530         operatorsGroup.push(newOperator);
531     }
532 
533     function removeOperator (address operator) public onlyAdmin {
534         require(operators[operator]);
535         operators[operator] = false;
536 
537         for (uint i = 0; i < operatorsGroup.length; ++i) {
538             if (operatorsGroup[i] == operator) {
539                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
540                 operatorsGroup.length -= 1;
541                 emit OperatorAdded(operator, false);
542                 break;
543             }
544         }
545     }
546 }
547 
548 contract WrapEtheremon is WrapEtheremonInterface, WrapEtheremonPermissions, Utils2 {
549     event SwapTokenChange(uint startTokenBalance, uint change);
550     event CaughtWithToken(address indexed sender, uint monsterId, ERC20 token, uint amount);
551     event ETHReceived(address indexed sender, uint amount);
552 
553     address public KyberNetwork;
554     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
555 
556     /// @dev Contract contstructor
557     /// @param _KyberNetwork KyberNetwork main contract address
558     constructor (address _KyberNetwork) public {
559         KyberNetwork = _KyberNetwork;
560     }
561 
562     /// @dev Return the ETH to user that was taken back by the network
563     function() public payable {
564         // Only receive ETH from KyberNetwork main contract
565         require(msg.sender == KyberNetwork);
566         emit ETHReceived(msg.sender, msg.value);
567     }
568 
569     /// @notice Can only be called by operators
570     /// @dev Sets the KyberNetwork address
571     /// @param _KyberNetwork KyberNetwork contract address
572     function setKyberNetwork(address _KyberNetwork) public onlyOperator {
573       KyberNetwork = _KyberNetwork;
574     }
575 
576     /// @dev Get the ETH price of the Etheremon monster and if it is catchable
577     /// @param _etheremon EtheremonWorldNFT address
578     /// @param _classId Class ID of monster
579     /// @param _payPrice Price of monster passed from Etheremon server
580     /// @return catchable, monsterInETH
581     function getMonsterPriceInETH(
582         EtheremonWorldNFT _etheremon,
583         uint32 _classId,
584         uint _payPrice
585     )
586         public
587         view
588         returns (
589             bool catchable,
590             uint monsterInETH
591         )
592     {
593         // Get monster details from Etheremon contract
594         (catchable, monsterInETH) = _etheremon.getPrice(_classId);
595 
596         // Get the highest price from contract pricing or offchain pricing
597         monsterInETH = max(monsterInETH, _payPrice);
598 
599         return (catchable, monsterInETH);
600     }
601 
602     /// @dev Get the rates of the Etheremon monster
603     /// @param _kyberProxy KyberNetworkProxyInterface address
604     /// @param token ERC20 token address
605     /// @param monsterInETH Price of the monster in ETH
606     /// @return expectedRate, slippageRate
607     function getMonsterRates(
608         KyberNetworkProxyInterface _kyberProxy,
609         ERC20 token,
610         uint monsterInETH
611     )
612         public
613         view
614         returns (
615             uint expectedRate,
616             uint slippageRate
617         )
618     {
619         // Get the expected and slippage rates of the token to ETH
620         (expectedRate, slippageRate) = _kyberProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, monsterInETH);
621 
622         return (expectedRate, slippageRate);
623     }
624 
625     /// @dev Get the token price and rates of the Etheremon monster
626     /// @param token ERC20 token address
627     /// @param expectedRate Expected rate of ETH to token
628     /// @param monsterInETH Price of the monster in ETH
629     /// @return monsterInTokens
630     function getMonsterPriceInTokens(
631         ERC20 token,
632         uint expectedRate,
633         uint monsterInETH
634     )
635         public
636         view
637         returns (uint monsterInTokens)
638     {
639         // If expectedRate is 0, return 0 for monster price in tokens
640         if (expectedRate == 0) {
641             return 0;
642         }
643 
644         // Calculate monster price in tokens
645         monsterInTokens = calcSrcAmount(ETH_TOKEN_ADDRESS, token, monsterInETH, expectedRate);
646 
647         return monsterInTokens;
648     }
649 
650     /// @dev Acquires the monster from Etheremon using tokens
651     /// @param _kyberProxy KyberNetworkProxyInterface address
652     /// @param _etheremon EtheremonWorldNFT address
653     /// @param _classId Class ID of monster
654     /// @param _name Name of the monster
655     /// @param token ERC20 token address
656     /// @param tokenQty Amount of tokens to be transferred by user
657     /// @param maxDestQty Actual amount of ETH needed to purchase the monster
658     /// @param minRate The minimum rate or slippage rate.
659     /// @param walletId Wallet ID where Kyber referral fees will be sent to
660     /// @return monsterId
661     function catchMonster(
662         KyberNetworkProxyInterface _kyberProxy,
663         EtheremonWorldNFT _etheremon,
664         uint32 _classId,
665         string _name,
666         ERC20 token,
667         uint tokenQty,
668         uint maxDestQty,
669         uint minRate,
670         address walletId
671     )
672         public
673         returns (uint monsterId)
674     {
675         // Check that the player has transferred the token to this contract
676         require(token.transferFrom(msg.sender, this, tokenQty));
677 
678         // Get the starting token balance of the player's wallet
679         uint startTokenBalance = token.balanceOf(this);
680 
681         // Mitigate ERC20 Approve front-running attack, by initially setting
682         // allowance to 0
683         require(token.approve(_kyberProxy, 0));
684 
685         // Verify that the token balance has not decreased from front-running
686         require(token.balanceOf(this) == startTokenBalance);
687 
688         // Once verified, set the token allowance to tokenQty
689         require(token.approve(_kyberProxy, tokenQty));
690 
691         // Swap player's token to ETH to send to Etheremon payments contract
692         uint userETH = _kyberProxy.tradeWithHint(
693             token,
694             tokenQty,
695             ETH_TOKEN_ADDRESS,
696             address(this),
697             maxDestQty,
698             minRate,
699             walletId,
700             ""
701         );
702 
703         // Acquire the monster and send to player
704         monsterId = _etheremon.catchMonster.value(userETH)(msg.sender, _classId, _name);
705 
706         // Log event that monster was caught using tokens
707         emit CaughtWithToken(msg.sender, monsterId, token, tokenQty);
708 
709         // Return change to player if any
710         calcPlayerChange(token, startTokenBalance);
711 
712         return monsterId;
713     }
714 
715     /// @dev Calculates token change and returns to player
716     /// @param token ERC20 token address
717     /// @param startTokenBalance Starting token balance of the player's wallet
718     function calcPlayerChange(ERC20 token, uint startTokenBalance) private {
719         // Calculate change of player
720         uint change = token.balanceOf(this);
721 
722         // Send back change if change is > 0
723         if (change > 0) {
724             // Log the exchange event
725             emit SwapTokenChange(startTokenBalance, change);
726 
727             // Transfer change back to player
728             token.transfer(msg.sender, change);
729         }
730     }
731 
732     /// @dev Gets the max between two uint params
733     /// @param a Param A
734     /// @param b Param B
735     /// @return result
736     function max(uint a, uint b) private pure returns (uint result) {
737         return a > b ? a : b;
738     }
739 }