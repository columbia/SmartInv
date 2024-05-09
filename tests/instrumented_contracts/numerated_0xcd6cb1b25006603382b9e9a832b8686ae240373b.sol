1 pragma solidity ^0.4.25;
2 
3 contract IStdToken {
4     function balanceOf(address _owner) public view returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
7 }
8 
9 contract EtheramaCommon {
10     
11     //main adrministrators of the Etherama network
12     mapping(address => bool) private _administrators;
13 
14     //main managers of the Etherama network
15     mapping(address => bool) private _managers;
16 
17     
18     modifier onlyAdministrator() {
19         require(_administrators[msg.sender]);
20         _;
21     }
22 
23     modifier onlyAdministratorOrManager() {
24         require(_administrators[msg.sender] || _managers[msg.sender]);
25         _;
26     }
27     
28     constructor() public {
29         _administrators[msg.sender] = true;
30     }
31     
32     
33     function addAdministator(address addr) onlyAdministrator public {
34         _administrators[addr] = true;
35     }
36 
37     function removeAdministator(address addr) onlyAdministrator public {
38         _administrators[addr] = false;
39     }
40 
41     function isAdministrator(address addr) public view returns (bool) {
42         return _administrators[addr];
43     }
44 
45     function addManager(address addr) onlyAdministrator public {
46         _managers[addr] = true;
47     }
48 
49     function removeManager(address addr) onlyAdministrator public {
50         _managers[addr] = false;
51     }
52     
53     function isManager(address addr) public view returns (bool) {
54         return _managers[addr];
55     }
56 }
57 
58 
59 contract EtheramaGasPriceLimit is EtheramaCommon {
60     
61     uint256 public MAX_GAS_PRICE = 0 wei;
62     
63     event onSetMaxGasPrice(uint256 val);    
64     
65     //max gas price modifier for buy/sell transactions in order to avoid a "front runner" vulnerability.
66     //It is applied to all network contracts
67     modifier validGasPrice(uint256 val) {
68         require(val > 0);
69         _;
70     }
71     
72     constructor(uint256 maxGasPrice) public validGasPrice(maxGasPrice) {
73         setMaxGasPrice(maxGasPrice);
74     } 
75     
76     
77     //only main administators or managers can set max gas price
78     function setMaxGasPrice(uint256 val) public validGasPrice(val) onlyAdministratorOrManager {
79         MAX_GAS_PRICE = val;
80         
81         emit onSetMaxGasPrice(val);
82     }
83 }
84 
85 // Core contract for Etherama network
86 contract EtheramaCore is EtheramaGasPriceLimit {
87     
88     uint256 constant public MAGNITUDE = 2**64;
89 
90     // Max and min amount of tokens which can be bought or sold. There are such limits because of math precision
91     uint256 constant public MIN_TOKEN_DEAL_VAL = 0.1 ether;
92     uint256 constant public MAX_TOKEN_DEAL_VAL = 1000000 ether;
93 
94     // same same for ETH
95     uint256 constant public MIN_ETH_DEAL_VAL = 0.001 ether;
96     uint256 constant public MAX_ETH_DEAL_VAL = 200000 ether;
97     
98     // percent of a transaction commission which is taken for Big Promo bonus
99     uint256 public _bigPromoPercent = 5 ether;
100 
101     // percent of a transaction commission which is taken for Quick Promo bonus
102     uint256 public _quickPromoPercent = 5 ether;
103 
104     // percent of a transaction commission which is taken for Etherama DEV team
105     uint256 public _devRewardPercent = 15 ether;
106     
107     // percent of a transaction commission which is taken for Token Owner. 
108     uint256 public _tokenOwnerRewardPercent = 30 ether;
109 
110     // percent of a transaction commission which is taken for share reward. Each token holder receives a small reward from each buy or sell transaction proportionally his holding. 
111     uint256 public _shareRewardPercent = 25 ether;
112 
113     // percent of a transaction commission which is taken for a feraral link owner. If there is no any referal then this part of commission goes to share reward.
114     uint256 public _refBonusPercent = 20 ether;
115 
116     // interval of blocks for Big Promo bonus. It means that a user which buy a bunch of tokens for X ETH in that particular block will receive a special bonus 
117     uint128 public _bigPromoBlockInterval = 9999;
118 
119     // same same for Quick Promo
120     uint128 public _quickPromoBlockInterval = 100;
121     
122     // minimum eth amount of a purchase which is required to participate in promo.
123     uint256 public _promoMinPurchaseEth = 1 ether;
124     
125     // minimum eth purchase which is required to get a referal link.
126     uint256 public _minRefEthPurchase = 0.5 ether;
127 
128     // percent of fee which is supposed to distribute.
129     uint256 public _totalIncomeFeePercent = 100 ether;
130 
131     // current collected big promo bonus
132     uint256 public _currentBigPromoBonus;
133     // current collected quick promo bonus
134     uint256 public _currentQuickPromoBonus;
135     
136     uint256 public _devReward;
137 
138     
139     uint256 public _initBlockNum;
140 
141     mapping(address => bool) private _controllerContracts;
142     mapping(uint256 => address) private _controllerIndexer;
143     uint256 private _controllerContractCount;
144     
145     //user token balances per data contracts
146     mapping(address => mapping(address => uint256)) private _userTokenLocalBalances;
147     //user reward payouts per data contracts
148     mapping(address => mapping(address => uint256)) private _rewardPayouts;
149     //user ref rewards per data contracts
150     mapping(address => mapping(address => uint256)) private _refBalances;
151     //user won quick promo bonuses per data contracts
152     mapping(address => mapping(address => uint256)) private _promoQuickBonuses;
153     //user won big promo bonuses per data contracts
154     mapping(address => mapping(address => uint256)) private _promoBigBonuses;  
155     //user saldo between buys and sels in eth per data contracts
156     mapping(address => mapping(address => uint256)) private _userEthVolumeSaldos;  
157 
158     //bonuses per share per data contracts
159     mapping(address => uint256) private _bonusesPerShare;
160     //buy counts per data contracts
161     mapping(address => uint256) private _buyCounts;
162     //sell counts per data contracts
163     mapping(address => uint256) private _sellCounts;
164     //total volume eth per data contracts
165     mapping(address => uint256) private _totalVolumeEth;
166     //total volume tokens per data contracts
167     mapping(address => uint256) private _totalVolumeToken;
168 
169     
170     event onWithdrawUserBonus(address indexed userAddress, uint256 ethWithdrawn); 
171 
172 
173     modifier onlyController() {
174         require(_controllerContracts[msg.sender]);
175         _;
176     }
177     
178     constructor(uint256 maxGasPrice) EtheramaGasPriceLimit(maxGasPrice) public { 
179          _initBlockNum = block.number;
180     }
181     
182     function getInitBlockNum() public view returns (uint256) {
183         return _initBlockNum;
184     }
185     
186     function addControllerContract(address addr) onlyAdministrator public {
187         _controllerContracts[addr] = true;
188         _controllerIndexer[_controllerContractCount] = addr;
189         _controllerContractCount = SafeMath.add(_controllerContractCount, 1);
190     }
191 
192     function removeControllerContract(address addr) onlyAdministrator public {
193         _controllerContracts[addr] = false;
194     }
195     
196     function changeControllerContract(address oldAddr, address newAddress) onlyAdministrator public {
197          _controllerContracts[oldAddr] = false;
198          _controllerContracts[newAddress] = true;
199     }
200     
201     function setBigPromoInterval(uint128 val) onlyAdministrator public {
202         _bigPromoBlockInterval = val;
203     }
204 
205     function setQuickPromoInterval(uint128 val) onlyAdministrator public {
206         _quickPromoBlockInterval = val;
207     }
208     
209     function addBigPromoBonus() onlyController payable public {
210         _currentBigPromoBonus = SafeMath.add(_currentBigPromoBonus, msg.value);
211     }
212     
213     function addQuickPromoBonus() onlyController payable public {
214         _currentQuickPromoBonus = SafeMath.add(_currentQuickPromoBonus, msg.value);
215     }
216     
217     
218     function setPromoMinPurchaseEth(uint256 val) onlyAdministrator public {
219         _promoMinPurchaseEth = val;
220     }
221     
222     function setMinRefEthPurchase(uint256 val) onlyAdministrator public {
223         _minRefEthPurchase = val;
224     }
225     
226     function setTotalIncomeFeePercent(uint256 val) onlyController public {
227         require(val > 0 && val <= 100 ether);
228 
229         _totalIncomeFeePercent = val;
230     }
231         
232     
233     // set reward persentages of buy/sell fee. Token owner cannot take more than 40%.
234     function setRewardPercentages(uint256 tokenOwnerRewardPercent, uint256 shareRewardPercent, uint256 refBonusPercent, uint256 bigPromoPercent, uint256 quickPromoPercent) onlyAdministrator public {
235         require(tokenOwnerRewardPercent <= 40 ether);
236         require(shareRewardPercent <= 100 ether);
237         require(refBonusPercent <= 100 ether);
238         require(bigPromoPercent <= 100 ether);
239         require(quickPromoPercent <= 100 ether);
240 
241         require(tokenOwnerRewardPercent + shareRewardPercent + refBonusPercent + _devRewardPercent + _bigPromoPercent + _quickPromoPercent == 100 ether);
242 
243         _tokenOwnerRewardPercent = tokenOwnerRewardPercent;
244         _shareRewardPercent = shareRewardPercent;
245         _refBonusPercent = refBonusPercent;
246         _bigPromoPercent = bigPromoPercent;
247         _quickPromoPercent = quickPromoPercent;
248     }    
249     
250     
251     function payoutQuickBonus(address userAddress) onlyController public {
252         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
253         _promoQuickBonuses[dataContractAddress][userAddress] = SafeMath.add(_promoQuickBonuses[dataContractAddress][userAddress], _currentQuickPromoBonus);
254         _currentQuickPromoBonus = 0;
255     }
256     
257     function payoutBigBonus(address userAddress) onlyController public {
258         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
259         _promoBigBonuses[dataContractAddress][userAddress] = SafeMath.add(_promoBigBonuses[dataContractAddress][userAddress], _currentBigPromoBonus);
260         _currentBigPromoBonus = 0;
261     }
262 
263     function addDevReward() onlyController payable public {
264         _devReward = SafeMath.add(_devReward, msg.value);
265     }    
266     
267     function withdrawDevReward() onlyAdministrator public {
268         uint256 reward = _devReward;
269         _devReward = 0;
270 
271         msg.sender.transfer(reward);
272     }
273     
274     function getBlockNumSinceInit() public view returns(uint256) {
275         return block.number - getInitBlockNum();
276     }
277 
278     function getQuickPromoRemainingBlocks() public view returns(uint256) {
279         uint256 d = getBlockNumSinceInit() % _quickPromoBlockInterval;
280         d = d == 0 ? _quickPromoBlockInterval : d;
281 
282         return _quickPromoBlockInterval - d;
283     }
284 
285     function getBigPromoRemainingBlocks() public view returns(uint256) {
286         uint256 d = getBlockNumSinceInit() % _bigPromoBlockInterval;
287         d = d == 0 ? _bigPromoBlockInterval : d;
288 
289         return _bigPromoBlockInterval - d;
290     } 
291     
292     
293     function getBonusPerShare(address dataContractAddress) public view returns(uint256) {
294         return _bonusesPerShare[dataContractAddress];
295     }
296     
297     function getTotalBonusPerShare() public view returns (uint256 res) {
298         for (uint256 i = 0; i < _controllerContractCount; i++) {
299             res = SafeMath.add(res, _bonusesPerShare[Etherama(_controllerIndexer[i]).getDataContractAddress()]);
300         }          
301     }
302     
303     
304     function addBonusPerShare() onlyController payable public {
305         EtheramaData data = Etherama(msg.sender)._data();
306         uint256 shareBonus = (msg.value * MAGNITUDE) / data.getTotalTokenSold();
307         
308         _bonusesPerShare[address(data)] = SafeMath.add(_bonusesPerShare[address(data)], shareBonus);
309     }        
310  
311     function getUserRefBalance(address dataContractAddress, address userAddress) public view returns(uint256) {
312         return _refBalances[dataContractAddress][userAddress];
313     }
314     
315     function getUserRewardPayouts(address dataContractAddress, address userAddress) public view returns(uint256) {
316         return _rewardPayouts[dataContractAddress][userAddress];
317     }    
318 
319     function resetUserRefBalance(address userAddress) onlyController public {
320         resetUserRefBalance(Etherama(msg.sender).getDataContractAddress(), userAddress);
321     }
322     
323     function resetUserRefBalance(address dataContractAddress, address userAddress) internal {
324         _refBalances[dataContractAddress][userAddress] = 0;
325     }
326     
327     function addUserRefBalance(address userAddress) onlyController payable public {
328         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
329         _refBalances[dataContractAddress][userAddress] = SafeMath.add(_refBalances[dataContractAddress][userAddress], msg.value);
330     }
331 
332     function addUserRewardPayouts(address userAddress, uint256 val) onlyController public {
333         addUserRewardPayouts(Etherama(msg.sender).getDataContractAddress(), userAddress, val);
334     }    
335 
336     function addUserRewardPayouts(address dataContractAddress, address userAddress, uint256 val) internal {
337         _rewardPayouts[dataContractAddress][userAddress] = SafeMath.add(_rewardPayouts[dataContractAddress][userAddress], val);
338     }
339 
340     function resetUserPromoBonus(address userAddress) onlyController public {
341         resetUserPromoBonus(Etherama(msg.sender).getDataContractAddress(), userAddress);
342     }
343     
344     function resetUserPromoBonus(address dataContractAddress, address userAddress) internal {
345         _promoQuickBonuses[dataContractAddress][userAddress] = 0;
346         _promoBigBonuses[dataContractAddress][userAddress] = 0;
347     }
348     
349     
350     function trackBuy(address userAddress, uint256 volEth, uint256 volToken) onlyController public {
351         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
352         _buyCounts[dataContractAddress] = SafeMath.add(_buyCounts[dataContractAddress], 1);
353         _userEthVolumeSaldos[dataContractAddress][userAddress] = SafeMath.add(_userEthVolumeSaldos[dataContractAddress][userAddress], volEth);
354         
355         trackTotalVolume(dataContractAddress, volEth, volToken);
356     }
357 
358     function trackSell(address userAddress, uint256 volEth, uint256 volToken) onlyController public {
359         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
360         _sellCounts[dataContractAddress] = SafeMath.add(_sellCounts[dataContractAddress], 1);
361         _userEthVolumeSaldos[dataContractAddress][userAddress] = SafeMath.sub(_userEthVolumeSaldos[dataContractAddress][userAddress], volEth);
362         
363         trackTotalVolume(dataContractAddress, volEth, volToken);
364     }
365     
366     function trackTotalVolume(address dataContractAddress, uint256 volEth, uint256 volToken) internal {
367         _totalVolumeEth[dataContractAddress] = SafeMath.add(_totalVolumeEth[dataContractAddress], volEth);
368         _totalVolumeToken[dataContractAddress] = SafeMath.add(_totalVolumeToken[dataContractAddress], volToken);
369     }
370     
371     function getBuyCount(address dataContractAddress) public view returns (uint256) {
372         return _buyCounts[dataContractAddress];
373     }
374     
375     function getTotalBuyCount() public view returns (uint256 res) {
376         for (uint256 i = 0; i < _controllerContractCount; i++) {
377             res = SafeMath.add(res, _buyCounts[Etherama(_controllerIndexer[i]).getDataContractAddress()]);
378         }         
379     }
380     
381     function getSellCount(address dataContractAddress) public view returns (uint256) {
382         return _sellCounts[dataContractAddress];
383     }
384     
385     function getTotalSellCount() public view returns (uint256 res) {
386         for (uint256 i = 0; i < _controllerContractCount; i++) {
387             res = SafeMath.add(res, _sellCounts[Etherama(_controllerIndexer[i]).getDataContractAddress()]);
388         }         
389     }
390 
391     function getTotalVolumeEth(address dataContractAddress) public view returns (uint256) {
392         return _totalVolumeEth[dataContractAddress];
393     }
394     
395     function getTotalVolumeToken(address dataContractAddress) public view returns (uint256) {
396         return _totalVolumeToken[dataContractAddress];
397     }
398 
399     function getUserEthVolumeSaldo(address dataContractAddress, address userAddress) public view returns (uint256) {
400         return _userEthVolumeSaldos[dataContractAddress][userAddress];
401     }
402     
403     function getUserTotalEthVolumeSaldo(address userAddress) public view returns (uint256 res) {
404         for (uint256 i = 0; i < _controllerContractCount; i++) {
405             res = SafeMath.add(res, _userEthVolumeSaldos[Etherama(_controllerIndexer[i]).getDataContractAddress()][userAddress]);
406         } 
407     }
408     
409     function getTotalCollectedPromoBonus() public view returns (uint256) {
410         return SafeMath.add(_currentBigPromoBonus, _currentQuickPromoBonus);
411     }
412 
413     function getUserTotalPromoBonus(address dataContractAddress, address userAddress) public view returns (uint256) {
414         return SafeMath.add(_promoQuickBonuses[dataContractAddress][userAddress], _promoBigBonuses[dataContractAddress][userAddress]);
415     }
416     
417     function getUserQuickPromoBonus(address dataContractAddress, address userAddress) public view returns (uint256) {
418         return _promoQuickBonuses[dataContractAddress][userAddress];
419     }
420     
421     function getUserBigPromoBonus(address dataContractAddress, address userAddress) public view returns (uint256) {
422         return _promoBigBonuses[dataContractAddress][userAddress];
423     }
424 
425     
426     function getUserTokenLocalBalance(address dataContractAddress, address userAddress) public view returns(uint256) {
427         return _userTokenLocalBalances[dataContractAddress][userAddress];
428     }
429   
430     
431     function addUserTokenLocalBalance(address userAddress, uint256 val) onlyController public {
432         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
433         _userTokenLocalBalances[dataContractAddress][userAddress] = SafeMath.add(_userTokenLocalBalances[dataContractAddress][userAddress], val);
434     }
435     
436     function subUserTokenLocalBalance(address userAddress, uint256 val) onlyController public {
437         address dataContractAddress = Etherama(msg.sender).getDataContractAddress();
438         _userTokenLocalBalances[dataContractAddress][userAddress] = SafeMath.sub(_userTokenLocalBalances[dataContractAddress][userAddress], val);
439     }
440 
441   
442     function getUserReward(address dataContractAddress, address userAddress, bool incShareBonus, bool incRefBonus, bool incPromoBonus) public view returns(uint256 reward) {
443         EtheramaData data = EtheramaData(dataContractAddress);
444         
445         if (incShareBonus) {
446             reward = data.getBonusPerShare() * data.getActualUserTokenBalance(userAddress);
447             reward = ((reward < data.getUserRewardPayouts(userAddress)) ? 0 : SafeMath.sub(reward, data.getUserRewardPayouts(userAddress))) / MAGNITUDE;
448         }
449         
450         if (incRefBonus) reward = SafeMath.add(reward, data.getUserRefBalance(userAddress));
451         if (incPromoBonus) reward = SafeMath.add(reward, data.getUserTotalPromoBonus(userAddress));
452         
453         return reward;
454     }
455     
456     //user's total reward from all the tokens on the table. includes share reward + referal bonus + promo bonus
457     function getUserTotalReward(address userAddress, bool incShareBonus, bool incRefBonus, bool incPromoBonus) public view returns(uint256 res) {
458         for (uint256 i = 0; i < _controllerContractCount; i++) {
459             address dataContractAddress = Etherama(_controllerIndexer[i]).getDataContractAddress();
460             
461             res = SafeMath.add(res, getUserReward(dataContractAddress, userAddress, incShareBonus, incRefBonus, incPromoBonus));
462         }
463     }
464     
465     //current user's reward
466     function getCurrentUserReward(bool incRefBonus, bool incPromoBonus) public view returns(uint256) {
467         return getUserTotalReward(msg.sender, true, incRefBonus, incPromoBonus);
468     }
469  
470     //current user's total reward from all the tokens on the table
471     function getCurrentUserTotalReward() public view returns(uint256) {
472         return getUserTotalReward(msg.sender, true, true, true);
473     }
474     
475     //user's share bonus from all the tokens on the table
476     function getCurrentUserShareBonus() public view returns(uint256) {
477         return getUserTotalReward(msg.sender, true, false, false);
478     }
479     
480     //current user's ref bonus from all the tokens on the table
481     function getCurrentUserRefBonus() public view returns(uint256) {
482         return getUserTotalReward(msg.sender, false, true, false);
483     }
484     
485     //current user's promo bonus from all the tokens on the table
486     function getCurrentUserPromoBonus() public view returns(uint256) {
487         return getUserTotalReward(msg.sender, false, false, true);
488     }
489     
490     //is ref link available for the user
491     function isRefAvailable(address refAddress) public view returns(bool) {
492         return getUserTotalEthVolumeSaldo(refAddress) >= _minRefEthPurchase;
493     }
494     
495     //is ref link available for the current user
496     function isRefAvailable() public view returns(bool) {
497         return isRefAvailable(msg.sender);
498     }
499     
500      //Withdraws all of the user earnings.
501     function withdrawUserReward() public {
502         uint256 reward = getRewardAndPrepareWithdraw();
503         
504         require(reward > 0);
505         
506         msg.sender.transfer(reward);
507         
508         emit onWithdrawUserBonus(msg.sender, reward);
509     }
510 
511     //gather all the user's reward and prepare it to withdaw
512     function getRewardAndPrepareWithdraw() internal returns(uint256 reward) {
513         
514         for (uint256 i = 0; i < _controllerContractCount; i++) {
515 
516             address dataContractAddress = Etherama(_controllerIndexer[i]).getDataContractAddress();
517             
518             reward = SafeMath.add(reward, getUserReward(dataContractAddress, msg.sender, true, false, false));
519 
520             // add share reward to payouts
521             addUserRewardPayouts(dataContractAddress, msg.sender, reward * MAGNITUDE);
522 
523             // add ref bonus
524             reward = SafeMath.add(reward, getUserRefBalance(dataContractAddress, msg.sender));
525             resetUserRefBalance(dataContractAddress, msg.sender);
526             
527             // add promo bonus
528             reward = SafeMath.add(reward, getUserTotalPromoBonus(dataContractAddress, msg.sender));
529             resetUserPromoBonus(dataContractAddress, msg.sender);
530         }
531         
532         return reward;
533     }
534     
535     //withdaw all the remamining ETH if there is no one active contract. We don't want to leave them here forever
536     function withdrawRemainingEthAfterAll() onlyAdministrator public {
537         for (uint256 i = 0; i < _controllerContractCount; i++) {
538             if (Etherama(_controllerIndexer[i]).isActive()) revert();
539         }
540         
541         msg.sender.transfer(address(this).balance);
542     }
543 
544     
545     
546     function calcPercent(uint256 amount, uint256 percent) public pure returns(uint256) {
547         return SafeMath.div(SafeMath.mul(SafeMath.div(amount, 100), percent), 1 ether);
548     }
549 
550     //Converts real num to uint256. Works only with positive numbers.
551     function convertRealTo256(int128 realVal) public pure returns(uint256) {
552         int128 roundedVal = RealMath.fromReal(RealMath.mul(realVal, RealMath.toReal(1e12)));
553 
554         return SafeMath.mul(uint256(roundedVal), uint256(1e6));
555     }
556 
557     //Converts uint256 to real num. Possible a little loose of precision
558     function convert256ToReal(uint256 val) public pure returns(int128) {
559         uint256 intVal = SafeMath.div(val, 1e6);
560         require(RealMath.isUInt256ValidIn64(intVal));
561         
562         return RealMath.fraction(int64(intVal), 1e12);
563     }    
564 }
565 
566 // Data contract for Etherama contract controller. Data contract cannot be changed so no data can be lost. On the other hand Etherama controller can be replaced if some error is found.
567 contract EtheramaData {
568 
569     // tranding token address
570     address constant public TOKEN_CONTRACT_ADDRESS = 0x83cee9e086A77e492eE0bB93C2B0437aD6fdECCc;
571     
572     // token price in the begining
573     uint256 constant public TOKEN_PRICE_INITIAL = 0.0023 ether;
574     // a percent of the token price which adds/subs each _priceSpeedInterval tokens
575     uint64 constant public PRICE_SPEED_PERCENT = 5;
576     // Token price speed interval. For instance, if PRICE_SPEED_PERCENT = 5 and PRICE_SPEED_INTERVAL = 10000 it means that after 10000 tokens are bought/sold  token price will increase/decrease for 5%.
577     uint64 constant public PRICE_SPEED_INTERVAL = 10000;
578     // lock-up period in days. Until this period is expeired nobody can close the contract or withdraw users' funds
579     uint64 constant public EXP_PERIOD_DAYS = 365;
580 
581     
582     mapping(address => bool) private _administrators;
583     uint256 private  _administratorCount;
584 
585     uint64 public _initTime;
586     uint64 public _expirationTime;
587     uint256 public _tokenOwnerReward;
588     
589     uint256 public _totalSupply;
590     int128 public _realTokenPrice;
591 
592     address public _controllerAddress = address(0x0);
593 
594     EtheramaCore public _core;
595 
596     uint256 public _initBlockNum;
597     
598     bool public _hasMaxPurchaseLimit = false;
599     
600     IStdToken public _token;
601 
602     //only main contract
603     modifier onlyController() {
604         require(msg.sender == _controllerAddress);
605         _;
606     }
607 
608     constructor(address coreAddress) public {
609         require(coreAddress != address(0x0));
610 
611         _core = EtheramaCore(coreAddress);
612         _initBlockNum = block.number;
613     }
614     
615     function init() public {
616         require(_controllerAddress == address(0x0));
617         require(TOKEN_CONTRACT_ADDRESS != address(0x0));
618         require(RealMath.isUInt64ValidIn64(PRICE_SPEED_PERCENT) && PRICE_SPEED_PERCENT > 0);
619         require(RealMath.isUInt64ValidIn64(PRICE_SPEED_INTERVAL) && PRICE_SPEED_INTERVAL > 0);
620         
621         
622         _controllerAddress = msg.sender;
623 
624         _token = IStdToken(TOKEN_CONTRACT_ADDRESS);
625         _initTime = uint64(now);
626         _expirationTime = _initTime + EXP_PERIOD_DAYS * 1 days;
627         _realTokenPrice = _core.convert256ToReal(TOKEN_PRICE_INITIAL);
628     }
629     
630     function isInited()  public view returns(bool) {
631         return (_controllerAddress != address(0x0));
632     }
633     
634     function getCoreAddress()  public view returns(address) {
635         return address(_core);
636     }
637     
638 
639     function setNewControllerAddress(address newAddress) onlyController public {
640         _controllerAddress = newAddress;
641     }
642 
643 
644     
645     function getPromoMinPurchaseEth() public view returns(uint256) {
646         return _core._promoMinPurchaseEth();
647     }
648 
649     function addAdministator(address addr) onlyController public {
650         _administrators[addr] = true;
651         _administratorCount = SafeMath.add(_administratorCount, 1);
652     }
653 
654     function removeAdministator(address addr) onlyController public {
655         _administrators[addr] = false;
656         _administratorCount = SafeMath.sub(_administratorCount, 1);
657     }
658 
659     function getAdministratorCount() public view returns(uint256) {
660         return _administratorCount;
661     }
662     
663     function isAdministrator(address addr) public view returns(bool) {
664         return _administrators[addr];
665     }
666 
667     
668     function getCommonInitBlockNum() public view returns (uint256) {
669         return _core.getInitBlockNum();
670     }
671     
672     
673     function resetTokenOwnerReward() onlyController public {
674         _tokenOwnerReward = 0;
675     }
676     
677     function addTokenOwnerReward(uint256 val) onlyController public {
678         _tokenOwnerReward = SafeMath.add(_tokenOwnerReward, val);
679     }
680     
681     function getCurrentBigPromoBonus() public view returns (uint256) {
682         return _core._currentBigPromoBonus();
683     }        
684     
685 
686     function getCurrentQuickPromoBonus() public view returns (uint256) {
687         return _core._currentQuickPromoBonus();
688     }    
689 
690     function getTotalCollectedPromoBonus() public view returns (uint256) {
691         return _core.getTotalCollectedPromoBonus();
692     }    
693 
694     function setTotalSupply(uint256 val) onlyController public {
695         _totalSupply = val;
696     }
697     
698     function setRealTokenPrice(int128 val) onlyController public {
699         _realTokenPrice = val;
700     }    
701     
702     
703     function setHasMaxPurchaseLimit(bool val) onlyController public {
704         _hasMaxPurchaseLimit = val;
705     }
706     
707     function getUserTokenLocalBalance(address userAddress) public view returns(uint256) {
708         return _core.getUserTokenLocalBalance(address(this), userAddress);
709     }
710     
711     function getActualUserTokenBalance(address userAddress) public view returns(uint256) {
712         return SafeMath.min(getUserTokenLocalBalance(userAddress), _token.balanceOf(userAddress));
713     }  
714     
715     function getBonusPerShare() public view returns(uint256) {
716         return _core.getBonusPerShare(address(this));
717     }
718     
719     function getUserRewardPayouts(address userAddress) public view returns(uint256) {
720         return _core.getUserRewardPayouts(address(this), userAddress);
721     }
722     
723     function getUserRefBalance(address userAddress) public view returns(uint256) {
724         return _core.getUserRefBalance(address(this), userAddress);
725     }
726     
727     function getUserReward(address userAddress, bool incRefBonus, bool incPromoBonus) public view returns(uint256) {
728         return _core.getUserReward(address(this), userAddress, true, incRefBonus, incPromoBonus);
729     }
730     
731     function getUserTotalPromoBonus(address userAddress) public view returns(uint256) {
732         return _core.getUserTotalPromoBonus(address(this), userAddress);
733     }
734     
735     function getUserBigPromoBonus(address userAddress) public view returns(uint256) {
736         return _core.getUserBigPromoBonus(address(this), userAddress);
737     }
738 
739     function getUserQuickPromoBonus(address userAddress) public view returns(uint256) {
740         return _core.getUserQuickPromoBonus(address(this), userAddress);
741     }
742 
743     function getRemainingTokenAmount() public view returns(uint256) {
744         return _token.balanceOf(_controllerAddress);
745     }
746 
747     function getTotalTokenSold() public view returns(uint256) {
748         return _totalSupply - getRemainingTokenAmount();
749     }   
750     
751     function getUserEthVolumeSaldo(address userAddress) public view returns(uint256) {
752         return _core.getUserEthVolumeSaldo(address(this), userAddress);
753     }
754 
755 }
756 
757 
758 contract Etherama {
759 
760     IStdToken public _token;
761     EtheramaData public _data;
762     EtheramaCore public _core;
763 
764 
765     bool public isActive = false;
766     bool public isMigrationToNewControllerInProgress = false;
767     bool public isActualContractVer = true;
768     address public migrationContractAddress = address(0x0);
769     bool public isMigrationApproved = false;
770 
771     address private _creator = address(0x0);
772     
773 
774     event onTokenPurchase(address indexed userAddress, uint256 incomingEth, uint256 tokensMinted, address indexed referredBy);
775     
776     event onTokenSell(address indexed userAddress, uint256 tokensBurned, uint256 ethEarned);
777     
778     event onReinvestment(address indexed userAddress, uint256 ethReinvested, uint256 tokensMinted);
779     
780     event onWithdrawTokenOwnerReward(address indexed toAddress, uint256 ethWithdrawn); 
781 
782     event onWinQuickPromo(address indexed userAddress, uint256 ethWon);    
783    
784     event onWinBigPromo(address indexed userAddress, uint256 ethWon);    
785 
786 
787     // only people with tokens
788     modifier onlyContractUsers() {
789         require(getUserLocalTokenBalance(msg.sender) > 0);
790         _;
791     }
792     
793 
794     // administrators can:
795     // -> change minimal amout of tokens to get a ref link.
796     // administrators CANNOT:
797     // -> take funds
798     // -> disable withdrawals
799     // -> kill the contract
800     // -> change the price of tokens
801     // -> suspend the contract
802     modifier onlyAdministrator() {
803         require(isCurrentUserAdministrator());
804         _;
805     }
806     
807     //core administrator can only approve contract migration after its code review
808     modifier onlyCoreAdministrator() {
809         require(_core.isAdministrator(msg.sender));
810         _;
811     }
812 
813     // only active state of the contract. Administator can activate it, but canncon deactive untill lock-up period is expired.
814     modifier onlyActive() {
815         require(isActive);
816         _;
817     }
818 
819     // maximum gas price for buy/sell transactions to avoid "front runner" vulnerability.   
820     modifier validGasPrice() {
821         require(tx.gasprice <= _core.MAX_GAS_PRICE());
822         _;
823     }
824     
825     // eth value must be greater than 0 for purchase transactions
826     modifier validPayableValue() {
827         require(msg.value > 0);
828         _;
829     }
830     
831     modifier onlyCoreContract() {
832         require(msg.sender == _data.getCoreAddress());
833         _;
834     }
835 
836     // dataContractAddress - data contract address where all the data is collected and separated from the controller
837     constructor(address dataContractAddress) public {
838         
839         require(dataContractAddress != address(0x0));
840         _data = EtheramaData(dataContractAddress);
841         
842         if (!_data.isInited()) {
843             _data.init();
844             _data.addAdministator(msg.sender);
845             _creator = msg.sender;
846         }
847         
848         _token = _data._token();
849         _core = _data._core();
850     }
851 
852 
853 
854     function addAdministator(address addr) onlyAdministrator public {
855         _data.addAdministator(addr);
856     }
857 
858     function removeAdministator(address addr) onlyAdministrator public {
859         _data.removeAdministator(addr);
860     }
861 
862     // transfer ownership request of the contract to token owner from contract creator. The new administator has to accept ownership to finish the transferring.
863     function transferOwnershipRequest(address addr) onlyAdministrator public {
864         addAdministator(addr);
865     }
866 
867     // accept transfer ownership.
868     function acceptOwnership() onlyAdministrator public {
869         require(_creator != address(0x0));
870 
871         removeAdministator(_creator);
872 
873         require(_data.getAdministratorCount() == 1);
874     }
875     
876     // if there is a maximim purchase limit then a user can buy only amount of tokens which he had before, not more.
877     function setHasMaxPurchaseLimit(bool val) onlyAdministrator public {
878         _data.setHasMaxPurchaseLimit(val);
879     }
880         
881     // activate the controller contract. After calling this function anybody can start trading the contrant's tokens
882     function activate() onlyAdministrator public {
883         require(!isActive);
884         
885         if (getTotalTokenSupply() == 0) setTotalSupply();
886         require(getTotalTokenSupply() > 0);
887         
888         isActive = true;
889         isMigrationToNewControllerInProgress = false;
890     }
891 
892     // Close the contract and withdraw all the funds. The contract cannot be closed before lock up period is expired.
893     function finish() onlyActive onlyAdministrator public {
894         require(uint64(now) >= _data._expirationTime());
895         
896         _token.transfer(msg.sender, getRemainingTokenAmount());   
897         msg.sender.transfer(getTotalEthBalance());
898         
899         isActive = false;
900     }
901     
902     //Converts incoming eth to tokens
903     function buy(address refAddress, uint256 minReturn) onlyActive validGasPrice validPayableValue public payable returns(uint256) {
904         return purchaseTokens(msg.value, refAddress, minReturn);
905     }
906 
907     //sell tokens for eth. before call this func you have to call "approve" in the ERC20 token contract
908     function sell(uint256 tokenAmount, uint256 minReturn) onlyActive onlyContractUsers validGasPrice public returns(uint256) {
909         if (tokenAmount > getCurrentUserLocalTokenBalance() || tokenAmount == 0) return 0;
910 
911         uint256 ethAmount = 0; uint256 totalFeeEth = 0; uint256 tokenPrice = 0;
912         (ethAmount, totalFeeEth, tokenPrice) = estimateSellOrder(tokenAmount, true);
913         require(ethAmount >= minReturn);
914 
915         subUserTokens(msg.sender, tokenAmount);
916 
917         msg.sender.transfer(ethAmount);
918 
919         updateTokenPrice(-_core.convert256ToReal(tokenAmount));
920 
921         distributeFee(totalFeeEth, address(0x0));
922         
923         uint256 userEthVol = _data.getUserEthVolumeSaldo(msg.sender);
924         _core.trackSell(msg.sender, ethAmount > userEthVol ? userEthVol : ethAmount, tokenAmount);
925        
926         emit onTokenSell(msg.sender, tokenAmount, ethAmount);
927 
928         return ethAmount;
929     }   
930 
931 
932     //Fallback function to handle eth that was sent straight to the contract
933     function() onlyActive validGasPrice validPayableValue payable external {
934         purchaseTokens(msg.value, address(0x0), 1);
935     }
936 
937     // withdraw token owner's reward
938     function withdrawTokenOwnerReward() onlyAdministrator public {
939         uint256 reward = getTokenOwnerReward();
940         
941         require(reward > 0);
942         
943         _data.resetTokenOwnerReward();
944 
945         msg.sender.transfer(reward);
946 
947         emit onWithdrawTokenOwnerReward(msg.sender, reward);
948     }
949 
950     // prepare the contract for migration to another one in case of some errors or refining
951     function prepareForMigration() onlyAdministrator public {
952         require(!isMigrationToNewControllerInProgress);
953         isMigrationToNewControllerInProgress = true;
954     }
955 
956     // accept funds transfer to a new controller during a migration.
957     function migrateFunds() payable public {
958         require(isMigrationToNewControllerInProgress);
959     }
960     
961 
962     //HELPERS
963 
964     // max gas price for buy/sell transactions  
965     function getMaxGasPrice() public view returns(uint256) {
966         return _core.MAX_GAS_PRICE();
967     }
968 
969     // max gas price for buy/sell transactions
970     function getExpirationTime() public view returns (uint256) {
971         return _data._expirationTime();
972     }
973             
974     // time till lock-up period is expired 
975     function getRemainingTimeTillExpiration() public view returns (uint256) {
976         if (_data._expirationTime() <= uint64(now)) return 0;
977         
978         return _data._expirationTime() - uint64(now);
979     }
980 
981     
982     function isCurrentUserAdministrator() public view returns(bool) {
983         return _data.isAdministrator(msg.sender);
984     }
985 
986     //data contract address where all the data is holded
987     function getDataContractAddress() public view returns(address) {
988         return address(_data);
989     }
990 
991     // get trading token contract address
992     function getTokenAddress() public view returns(address) {
993         return address(_token);
994     }
995 
996     // request migration to new contract. After request Etherama dev team should review its code and approve it if it is OK
997     function requestControllerContractMigration(address newControllerAddr) onlyAdministrator public {
998         require(!isMigrationApproved);
999         
1000         migrationContractAddress = newControllerAddr;
1001     }
1002     
1003     // Dev team gives a pervission to updagrade the contract after code review, transfer all the funds, activate new abilities or fix some errors.
1004     function approveControllerContractMigration() onlyCoreAdministrator public {
1005         isMigrationApproved = true;
1006     }
1007     
1008     //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.
1009     function migrateToNewNewControllerContract() onlyAdministrator public {
1010         require(isMigrationApproved && migrationContractAddress != address(0x0) && isActualContractVer);
1011         
1012         isActive = false;
1013 
1014         Etherama newController = Etherama(address(migrationContractAddress));
1015         _data.setNewControllerAddress(migrationContractAddress);
1016 
1017         uint256 remainingTokenAmount = getRemainingTokenAmount();
1018         uint256 ethBalance = getTotalEthBalance();
1019 
1020         if (remainingTokenAmount > 0) _token.transfer(migrationContractAddress, remainingTokenAmount); 
1021         if (ethBalance > 0) newController.migrateFunds.value(ethBalance)();
1022         
1023         isActualContractVer = false;
1024     }
1025 
1026     //total buy count
1027     function getBuyCount() public view returns(uint256) {
1028         return _core.getBuyCount(getDataContractAddress());
1029     }
1030     //total sell count
1031     function getSellCount() public view returns(uint256) {
1032         return _core.getSellCount(getDataContractAddress());
1033     }
1034     //total eth volume
1035     function getTotalVolumeEth() public view returns(uint256) {
1036         return _core.getTotalVolumeEth(getDataContractAddress());
1037     }   
1038     //total token volume
1039     function getTotalVolumeToken() public view returns(uint256) {
1040         return _core.getTotalVolumeToken(getDataContractAddress());
1041     } 
1042     //current bonus per 1 token in ETH
1043     function getBonusPerShare() public view returns (uint256) {
1044         return SafeMath.div(SafeMath.mul(_data.getBonusPerShare(), 1 ether), _core.MAGNITUDE());
1045     }    
1046     //token initial price in ETH
1047     function getTokenInitialPrice() public view returns(uint256) {
1048         return _data.TOKEN_PRICE_INITIAL();
1049     }
1050 
1051     function getDevRewardPercent() public view returns(uint256) {
1052         return _core._devRewardPercent();
1053     }
1054 
1055     function getTokenOwnerRewardPercent() public view returns(uint256) {
1056         return _core._tokenOwnerRewardPercent();
1057     }
1058     
1059     function getShareRewardPercent() public view returns(uint256) {
1060         return _core._shareRewardPercent();
1061     }
1062     
1063     function getRefBonusPercent() public view returns(uint256) {
1064         return _core._refBonusPercent();
1065     }
1066     
1067     function getBigPromoPercent() public view returns(uint256) {
1068         return _core._bigPromoPercent();
1069     }
1070     
1071     function getQuickPromoPercent() public view returns(uint256) {
1072         return _core._quickPromoPercent();
1073     }
1074 
1075     function getBigPromoBlockInterval() public view returns(uint256) {
1076         return _core._bigPromoBlockInterval();
1077     }
1078 
1079     function getQuickPromoBlockInterval() public view returns(uint256) {
1080         return _core._quickPromoBlockInterval();
1081     }
1082 
1083     function getPromoMinPurchaseEth() public view returns(uint256) {
1084         return _core._promoMinPurchaseEth();
1085     }
1086 
1087 
1088     function getPriceSpeedPercent() public view returns(uint64) {
1089         return _data.PRICE_SPEED_PERCENT();
1090     }
1091 
1092     function getPriceSpeedTokenBlock() public view returns(uint64) {
1093         return _data.PRICE_SPEED_INTERVAL();
1094     }
1095 
1096     function getMinRefEthPurchase() public view returns (uint256) {
1097         return _core._minRefEthPurchase();
1098     }    
1099 
1100     function getTotalCollectedPromoBonus() public view returns (uint256) {
1101         return _data.getTotalCollectedPromoBonus();
1102     }   
1103 
1104     function getCurrentBigPromoBonus() public view returns (uint256) {
1105         return _data.getCurrentBigPromoBonus();
1106     }  
1107 
1108     function getCurrentQuickPromoBonus() public view returns (uint256) {
1109         return _data.getCurrentQuickPromoBonus();
1110     }    
1111 
1112     //current token price
1113     function getCurrentTokenPrice() public view returns(uint256) {
1114         return _core.convertRealTo256(_data._realTokenPrice());
1115     }
1116 
1117     //contract's eth balance
1118     function getTotalEthBalance() public view returns(uint256) {
1119         return address(this).balance;
1120     }
1121     
1122     //amount of tokens which were funded to the contract initially
1123     function getTotalTokenSupply() public view returns(uint256) {
1124         return _data._totalSupply();
1125     }
1126 
1127     //amount of tokens which are still available for selling on the contract
1128     function getRemainingTokenAmount() public view returns(uint256) {
1129         return _token.balanceOf(address(this));
1130     }
1131     
1132     //amount of tokens which where sold by the contract
1133     function getTotalTokenSold() public view returns(uint256) {
1134         return getTotalTokenSupply() - getRemainingTokenAmount();
1135     }
1136     
1137     //user's token amount which were bought from the contract
1138     function getUserLocalTokenBalance(address userAddress) public view returns(uint256) {
1139         return _data.getUserTokenLocalBalance(userAddress);
1140     }
1141     
1142     //current user's token amount which were bought from the contract
1143     function getCurrentUserLocalTokenBalance() public view returns(uint256) {
1144         return getUserLocalTokenBalance(msg.sender);
1145     }    
1146 
1147     //is referal link available for the current user
1148     function isCurrentUserRefAvailable() public view returns(bool) {
1149         return _core.isRefAvailable();
1150     }
1151 
1152 
1153     function getCurrentUserRefBonus() public view returns(uint256) {
1154         return _data.getUserRefBalance(msg.sender);
1155     }
1156     
1157     function getCurrentUserPromoBonus() public view returns(uint256) {
1158         return _data.getUserTotalPromoBonus(msg.sender);
1159     }
1160     
1161     //max and min values of a deal in tokens
1162     function getTokenDealRange() public view returns(uint256, uint256) {
1163         return (_core.MIN_TOKEN_DEAL_VAL(), _core.MAX_TOKEN_DEAL_VAL());
1164     }
1165     
1166     //max and min values of a deal in ETH
1167     function getEthDealRange() public view returns(uint256, uint256) {
1168         uint256 minTokenVal; uint256 maxTokenVal;
1169         (minTokenVal, maxTokenVal) = getTokenDealRange();
1170         
1171         return ( SafeMath.max(_core.MIN_ETH_DEAL_VAL(), tokensToEth(minTokenVal, true)), SafeMath.min(_core.MAX_ETH_DEAL_VAL(), tokensToEth(maxTokenVal, true)) );
1172     }
1173     
1174     //user's total reward from all the tokens on the table. includes share reward + referal bonus + promo bonus
1175     function getUserReward(address userAddress, bool isTotal) public view returns(uint256) {
1176         return isTotal ? 
1177             _core.getUserTotalReward(userAddress, true, true, true) :
1178             _data.getUserReward(userAddress, true, true);
1179     }
1180     
1181     //price for selling 1 token. mostly useful only for frontend
1182     function get1TokenSellPrice() public view returns(uint256) {
1183         uint256 tokenAmount = 1 ether;
1184 
1185         uint256 ethAmount = 0; uint256 totalFeeEth = 0; uint256 tokenPrice = 0;
1186         (ethAmount, totalFeeEth, tokenPrice) = estimateSellOrder(tokenAmount, true);
1187 
1188         return ethAmount;
1189     }
1190     
1191     //price for buying 1 token. mostly useful only for frontend
1192     function get1TokenBuyPrice() public view returns(uint256) {
1193         uint256 ethAmount = 1 ether;
1194 
1195         uint256 tokenAmount = 0; uint256 totalFeeEth = 0; uint256 tokenPrice = 0;
1196         (tokenAmount, totalFeeEth, tokenPrice) = estimateBuyOrder(ethAmount, true);  
1197 
1198         return SafeMath.div(ethAmount * 1 ether, tokenAmount);
1199     }
1200 
1201     //calc current reward for holding @tokenAmount tokens
1202     function calcReward(uint256 tokenAmount) public view returns(uint256) {
1203         return (uint256) ((int256)(_data.getBonusPerShare() * tokenAmount)) / _core.MAGNITUDE();
1204     }  
1205 
1206     //esimate buy order by amount of ETH/tokens. returns tokens/eth amount after the deal, total fee in ETH and average token price
1207     function estimateBuyOrder(uint256 amount, bool fromEth) public view returns(uint256, uint256, uint256) {
1208         uint256 minAmount; uint256 maxAmount;
1209         (minAmount, maxAmount) = fromEth ? getEthDealRange() : getTokenDealRange();
1210         //require(amount >= minAmount && amount <= maxAmount);
1211 
1212         uint256 ethAmount = fromEth ? amount : tokensToEth(amount, true);
1213         require(ethAmount > 0);
1214 
1215         uint256 tokenAmount = fromEth ? ethToTokens(amount, true) : amount;
1216         uint256 totalFeeEth = calcTotalFee(tokenAmount, true);
1217         require(ethAmount > totalFeeEth);
1218 
1219         uint256 tokenPrice = SafeMath.div(ethAmount * 1 ether, tokenAmount);
1220 
1221         return (fromEth ? tokenAmount : SafeMath.add(ethAmount, totalFeeEth), totalFeeEth, tokenPrice);
1222     }
1223     
1224     //esimate sell order by amount of tokens/ETH. returns eth/tokens amount after the deal, total fee in ETH and average token price
1225     function estimateSellOrder(uint256 amount, bool fromToken) public view returns(uint256, uint256, uint256) {
1226         uint256 minAmount; uint256 maxAmount;
1227         (minAmount, maxAmount) = fromToken ? getTokenDealRange() : getEthDealRange();
1228         //require(amount >= minAmount && amount <= maxAmount);
1229 
1230         uint256 tokenAmount = fromToken ? amount : ethToTokens(amount, false);
1231         require(tokenAmount > 0);
1232         
1233         uint256 ethAmount = fromToken ? tokensToEth(tokenAmount, false) : amount;
1234         uint256 totalFeeEth = calcTotalFee(tokenAmount, false);
1235         require(ethAmount > totalFeeEth);
1236 
1237         uint256 tokenPrice = SafeMath.div(ethAmount * 1 ether, tokenAmount);
1238         
1239         return (fromToken ? ethAmount : tokenAmount, totalFeeEth, tokenPrice);
1240     }
1241 
1242     //returns max user's purchase limit in tokens if _hasMaxPurchaseLimit pamam is set true. If it is a user cannot by more tokens that hs already bought on some other exchange
1243     function getUserMaxPurchase(address userAddress) public view returns(uint256) {
1244         return _token.balanceOf(userAddress) - SafeMath.mul(getUserLocalTokenBalance(userAddress), 2);
1245     }
1246     //current urser's max purchase limit in tokens
1247     function getCurrentUserMaxPurchase() public view returns(uint256) {
1248         return getUserMaxPurchase(msg.sender);
1249     }
1250 
1251     //token owener collected reward
1252     function getTokenOwnerReward() public view returns(uint256) {
1253         return _data._tokenOwnerReward();
1254     }
1255 
1256     //current user's won promo bonuses
1257     function getCurrentUserTotalPromoBonus() public view returns(uint256) {
1258         return _data.getUserTotalPromoBonus(msg.sender);
1259     }
1260 
1261     //current user's won big promo bonuses
1262     function getCurrentUserBigPromoBonus() public view returns(uint256) {
1263         return _data.getUserBigPromoBonus(msg.sender);
1264     }
1265     //current user's won quick promo bonuses
1266     function getCurrentUserQuickPromoBonus() public view returns(uint256) {
1267         return _data.getUserQuickPromoBonus(msg.sender);
1268     }
1269    
1270     //amount of block since core contract is deployed
1271     function getBlockNumSinceInit() public view returns(uint256) {
1272         return _core.getBlockNumSinceInit();
1273     }
1274 
1275     //remaing amount of blocks to win a quick promo bonus
1276     function getQuickPromoRemainingBlocks() public view returns(uint256) {
1277         return _core.getQuickPromoRemainingBlocks();
1278     }
1279     //remaing amount of blocks to win a big promo bonus
1280     function getBigPromoRemainingBlocks() public view returns(uint256) {
1281         return _core.getBigPromoRemainingBlocks();
1282     } 
1283     
1284     
1285     // INTERNAL FUNCTIONS
1286     
1287     function purchaseTokens(uint256 ethAmount, address refAddress, uint256 minReturn) internal returns(uint256) {
1288         uint256 tokenAmount = 0; uint256 totalFeeEth = 0; uint256 tokenPrice = 0;
1289         (tokenAmount, totalFeeEth, tokenPrice) = estimateBuyOrder(ethAmount, true);
1290         require(tokenAmount >= minReturn);
1291 
1292         if (_data._hasMaxPurchaseLimit()) {
1293             //user has to have at least equal amount of tokens which he's willing to buy 
1294             require(getCurrentUserMaxPurchase() >= tokenAmount);
1295         }
1296 
1297         require(tokenAmount > 0 && (SafeMath.add(tokenAmount, getTotalTokenSold()) > getTotalTokenSold()));
1298 
1299         if (refAddress == msg.sender || !_core.isRefAvailable(refAddress)) refAddress = address(0x0);
1300 
1301         distributeFee(totalFeeEth, refAddress);
1302 
1303         addUserTokens(msg.sender, tokenAmount);
1304 
1305         // the user is not going to receive any reward for the current purchase
1306         _core.addUserRewardPayouts(msg.sender, _data.getBonusPerShare() * tokenAmount);
1307 
1308         checkAndSendPromoBonus(ethAmount);
1309         
1310         updateTokenPrice(_core.convert256ToReal(tokenAmount));
1311         
1312         _core.trackBuy(msg.sender, ethAmount, tokenAmount);
1313 
1314         emit onTokenPurchase(msg.sender, ethAmount, tokenAmount, refAddress);
1315         
1316         return tokenAmount;
1317     }
1318 
1319     function setTotalSupply() internal {
1320         require(_data._totalSupply() == 0);
1321 
1322         uint256 tokenAmount = _token.balanceOf(address(this));
1323 
1324         _data.setTotalSupply(tokenAmount);
1325     }
1326 
1327 
1328     function checkAndSendPromoBonus(uint256 purchaseAmountEth) internal {
1329         if (purchaseAmountEth < _data.getPromoMinPurchaseEth()) return;
1330 
1331         if (getQuickPromoRemainingBlocks() == 0) sendQuickPromoBonus();
1332         if (getBigPromoRemainingBlocks() == 0) sendBigPromoBonus();
1333     }
1334 
1335     function sendQuickPromoBonus() internal {
1336         _core.payoutQuickBonus(msg.sender);
1337 
1338         emit onWinQuickPromo(msg.sender, _data.getCurrentQuickPromoBonus());
1339     }
1340 
1341     function sendBigPromoBonus() internal {
1342         _core.payoutBigBonus(msg.sender);
1343 
1344         emit onWinBigPromo(msg.sender, _data.getCurrentBigPromoBonus());
1345     }
1346 
1347     function distributeFee(uint256 totalFeeEth, address refAddress) internal {
1348         addProfitPerShare(totalFeeEth, refAddress);
1349         addDevReward(totalFeeEth);
1350         addTokenOwnerReward(totalFeeEth);
1351         addBigPromoBonus(totalFeeEth);
1352         addQuickPromoBonus(totalFeeEth);
1353     }
1354 
1355     function addProfitPerShare(uint256 totalFeeEth, address refAddress) internal {
1356         uint256 refBonus = calcRefBonus(totalFeeEth);
1357         uint256 totalShareReward = calcTotalShareRewardFee(totalFeeEth);
1358 
1359         if (refAddress != address(0x0)) {
1360             _core.addUserRefBalance.value(refBonus)(refAddress);
1361         } else {
1362             totalShareReward = SafeMath.add(totalShareReward, refBonus);
1363         }
1364 
1365         if (getTotalTokenSold() == 0) {
1366             _data.addTokenOwnerReward(totalShareReward);
1367         } else {
1368             _core.addBonusPerShare.value(totalShareReward)();
1369         }
1370     }
1371 
1372     function addDevReward(uint256 totalFeeEth) internal {
1373         _core.addDevReward.value(calcDevReward(totalFeeEth))();
1374     }    
1375     
1376     function addTokenOwnerReward(uint256 totalFeeEth) internal {
1377         _data.addTokenOwnerReward(calcTokenOwnerReward(totalFeeEth));
1378     }  
1379 
1380     function addBigPromoBonus(uint256 totalFeeEth) internal {
1381         _core.addBigPromoBonus.value(calcBigPromoBonus(totalFeeEth))();
1382     }
1383 
1384     function addQuickPromoBonus(uint256 totalFeeEth) internal {
1385         _core.addQuickPromoBonus.value(calcQuickPromoBonus(totalFeeEth))();
1386     }   
1387 
1388 
1389     function addUserTokens(address user, uint256 tokenAmount) internal {
1390         _core.addUserTokenLocalBalance(user, tokenAmount);
1391         _token.transfer(msg.sender, tokenAmount);   
1392     }
1393 
1394     function subUserTokens(address user, uint256 tokenAmount) internal {
1395         _core.subUserTokenLocalBalance(user, tokenAmount);
1396         _token.transferFrom(user, address(this), tokenAmount);    
1397     }
1398 
1399     function updateTokenPrice(int128 realTokenAmount) public {
1400         _data.setRealTokenPrice(calc1RealTokenRateFromRealTokens(realTokenAmount));
1401     }
1402 
1403     function ethToTokens(uint256 ethAmount, bool isBuy) internal view returns(uint256) {
1404         int128 realEthAmount = _core.convert256ToReal(ethAmount);
1405         int128 t0 = RealMath.div(realEthAmount, _data._realTokenPrice());
1406         int128 s = getRealPriceSpeed();
1407 
1408         int128 tn =  RealMath.div(t0, RealMath.toReal(100));
1409 
1410         for (uint i = 0; i < 100; i++) {
1411 
1412             int128 tns = RealMath.mul(tn, s);
1413             int128 exptns = RealMath.exp( RealMath.mul(tns, RealMath.toReal(isBuy ? int64(1) : int64(-1))) );
1414 
1415             int128 tn1 = RealMath.div(
1416                 RealMath.mul( RealMath.mul(tns, tn), exptns ) + t0,
1417                 RealMath.mul( exptns, RealMath.toReal(1) + tns )
1418             );
1419 
1420             if (RealMath.abs(tn-tn1) < RealMath.fraction(1, 1e18)) break;
1421 
1422             tn = tn1;
1423         }
1424 
1425         return _core.convertRealTo256(tn);
1426     }
1427 
1428     function tokensToEth(uint256 tokenAmount, bool isBuy) internal view returns(uint256) {
1429         int128 realTokenAmount = _core.convert256ToReal(tokenAmount);
1430         int128 s = getRealPriceSpeed();
1431         int128 expArg = RealMath.mul(RealMath.mul(realTokenAmount, s), RealMath.toReal(isBuy ? int64(1) : int64(-1)));
1432         
1433         int128 realEthAmountFor1Token = RealMath.mul(_data._realTokenPrice(), RealMath.exp(expArg));
1434         int128 realEthAmount = RealMath.mul(realTokenAmount, realEthAmountFor1Token);
1435 
1436         return _core.convertRealTo256(realEthAmount);
1437     }
1438 
1439     function calcTotalFee(uint256 tokenAmount, bool isBuy) internal view returns(uint256) {
1440         int128 realTokenAmount = _core.convert256ToReal(tokenAmount);
1441         int128 factor = RealMath.toReal(isBuy ? int64(1) : int64(-1));
1442         int128 rateAfterDeal = calc1RealTokenRateFromRealTokens(RealMath.mul(realTokenAmount, factor));
1443         int128 delta = RealMath.div(rateAfterDeal - _data._realTokenPrice(), RealMath.toReal(2));
1444         int128 fee = RealMath.mul(realTokenAmount, delta);
1445         
1446         //commission for sells is a bit lower due to rounding error
1447         if (!isBuy) fee = RealMath.mul(fee, RealMath.fraction(95, 100));
1448 
1449         return _core.calcPercent(_core.convertRealTo256(RealMath.mul(fee, factor)), _core._totalIncomeFeePercent());
1450     }
1451 
1452 
1453 
1454     function calc1RealTokenRateFromRealTokens(int128 realTokenAmount) internal view returns(int128) {
1455         int128 expArg = RealMath.mul(realTokenAmount, getRealPriceSpeed());
1456 
1457         return RealMath.mul(_data._realTokenPrice(), RealMath.exp(expArg));
1458     }
1459     
1460     function getRealPriceSpeed() internal view returns(int128) {
1461         require(RealMath.isUInt64ValidIn64(_data.PRICE_SPEED_PERCENT()));
1462         require(RealMath.isUInt64ValidIn64(_data.PRICE_SPEED_INTERVAL()));
1463         
1464         return RealMath.div(RealMath.fraction(int64(_data.PRICE_SPEED_PERCENT()), 100), RealMath.toReal(int64(_data.PRICE_SPEED_INTERVAL())));
1465     }
1466 
1467 
1468     function calcTotalShareRewardFee(uint256 totalFee) internal view returns(uint256) {
1469         return _core.calcPercent(totalFee, _core._shareRewardPercent());
1470     }
1471     
1472     function calcRefBonus(uint256 totalFee) internal view returns(uint256) {
1473         return _core.calcPercent(totalFee, _core._refBonusPercent());
1474     }
1475     
1476     function calcTokenOwnerReward(uint256 totalFee) internal view returns(uint256) {
1477         return _core.calcPercent(totalFee, _core._tokenOwnerRewardPercent());
1478     }
1479 
1480     function calcDevReward(uint256 totalFee) internal view returns(uint256) {
1481         return _core.calcPercent(totalFee, _core._devRewardPercent());
1482     }
1483 
1484     function calcQuickPromoBonus(uint256 totalFee) internal view returns(uint256) {
1485         return _core.calcPercent(totalFee, _core._quickPromoPercent());
1486     }    
1487 
1488     function calcBigPromoBonus(uint256 totalFee) internal view returns(uint256) {
1489         return _core.calcPercent(totalFee, _core._bigPromoPercent());
1490     }        
1491 
1492 
1493 }
1494 
1495 
1496 library SafeMath {
1497 
1498     /**
1499     * @dev Multiplies two numbers, throws on overflow.
1500     */
1501     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1502         if (a == 0) {
1503             return 0;
1504         }
1505         uint256 c = a * b;
1506         assert(c / a == b);
1507         return c;
1508     }
1509 
1510     /**
1511     * @dev Integer division of two numbers, truncating the quotient.
1512     */
1513     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1514         // assert(b > 0); // Solidity automatically throws when dividing by 0
1515         uint256 c = a / b;
1516         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1517         return c;
1518     }
1519 
1520     /**
1521     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1522     */
1523     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1524         assert(b <= a);
1525         return a - b;
1526     }
1527 
1528     /**
1529     * @dev Adds two numbers, throws on overflow.
1530     */
1531     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1532         uint256 c = a + b;
1533         assert(c >= a);
1534         return c;
1535     } 
1536 
1537     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1538         return a < b ? a : b;
1539     }   
1540 
1541     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1542         return a < b ? b : a;
1543     }   
1544 }
1545 
1546 //taken from https://github.com/NovakDistributed/macroverse/blob/master/contracts/RealMath.sol and a bit modified
1547 library RealMath {
1548     
1549     int64 constant MIN_INT64 = int64((uint64(1) << 63));
1550     int64 constant MAX_INT64 = int64(~((uint64(1) << 63)));
1551     
1552     /**
1553      * How many total bits are there?
1554      */
1555     int256 constant REAL_BITS = 128;
1556     
1557     /**
1558      * How many fractional bits are there?
1559      */
1560     int256 constant REAL_FBITS = 64;
1561     
1562     /**
1563      * How many integer bits are there?
1564      */
1565     int256 constant REAL_IBITS = REAL_BITS - REAL_FBITS;
1566     
1567     /**
1568      * What's the first non-fractional bit
1569      */
1570     int128 constant REAL_ONE = int128(1) << REAL_FBITS;
1571     
1572     /**
1573      * What's the last fractional bit?
1574      */
1575     int128 constant REAL_HALF = REAL_ONE >> 1;
1576     
1577     /**
1578      * What's two? Two is pretty useful.
1579      */
1580     int128 constant REAL_TWO = REAL_ONE << 1;
1581     
1582     /**
1583      * And our logarithms are based on ln(2).
1584      */
1585     int128 constant REAL_LN_TWO = 762123384786;
1586     
1587     /**
1588      * It is also useful to have Pi around.
1589      */
1590     int128 constant REAL_PI = 3454217652358;
1591     
1592     /**
1593      * And half Pi, to save on divides.
1594      * TODO: That might not be how the compiler handles constants.
1595      */
1596     int128 constant REAL_HALF_PI = 1727108826179;
1597     
1598     /**
1599      * And two pi, which happens to be odd in its most accurate representation.
1600      */
1601     int128 constant REAL_TWO_PI = 6908435304715;
1602     
1603     /**
1604      * What's the sign bit?
1605      */
1606     int128 constant SIGN_MASK = int128(1) << 127;
1607     
1608 
1609     function getMinInt64() internal pure returns (int64) {
1610         return MIN_INT64;
1611     }
1612     
1613     function getMaxInt64() internal pure returns (int64) {
1614         return MAX_INT64;
1615     }
1616     
1617     function isUInt256ValidIn64(uint256 val) internal pure returns (bool) {
1618         return val >= 0 && val <= uint256(getMaxInt64());
1619     }
1620     
1621     function isInt256ValidIn64(int256 val) internal pure returns (bool) {
1622         return val >= int256(getMinInt64()) && val <= int256(getMaxInt64());
1623     }
1624     
1625     function isUInt64ValidIn64(uint64 val) internal pure returns (bool) {
1626         return val >= 0 && val <= uint64(getMaxInt64());
1627     }
1628     
1629     function isInt128ValidIn64(int128 val) internal pure returns (bool) {
1630         return val >= int128(getMinInt64()) && val <= int128(getMaxInt64());
1631     }
1632 
1633     /**
1634      * Convert an integer to a real. Preserves sign.
1635      */
1636     function toReal(int64 ipart) internal pure returns (int128) {
1637         return int128(ipart) * REAL_ONE;
1638     }
1639     
1640     /**
1641      * Convert a real to an integer. Preserves sign.
1642      */
1643     function fromReal(int128 real_value) internal pure returns (int64) {
1644         int128 intVal = real_value / REAL_ONE;
1645         require(isInt128ValidIn64(intVal));
1646         
1647         return int64(intVal);
1648     }
1649     
1650     
1651     /**
1652      * Get the absolute value of a real. Just the same as abs on a normal int128.
1653      */
1654     function abs(int128 real_value) internal pure returns (int128) {
1655         if (real_value > 0) {
1656             return real_value;
1657         } else {
1658             return -real_value;
1659         }
1660     }
1661     
1662     
1663     /**
1664      * Get the fractional part of a real, as a real. Ignores sign (so fpart(-0.5) is 0.5).
1665      */
1666     function fpart(int128 real_value) internal pure returns (int128) {
1667         // This gets the fractional part but strips the sign
1668         return abs(real_value) % REAL_ONE;
1669     }
1670 
1671     /**
1672      * Get the fractional part of a real, as a real. Respects sign (so fpartSigned(-0.5) is -0.5).
1673      */
1674     function fpartSigned(int128 real_value) internal pure returns (int128) {
1675         // This gets the fractional part but strips the sign
1676         int128 fractional = fpart(real_value);
1677         return real_value < 0 ? -fractional : fractional;
1678     }
1679     
1680     /**
1681      * Get the integer part of a fixed point value.
1682      */
1683     function ipart(int128 real_value) internal pure returns (int128) {
1684         // Subtract out the fractional part to get the real part.
1685         return real_value - fpartSigned(real_value);
1686     }
1687     
1688     /**
1689      * Multiply one real by another. Truncates overflows.
1690      */
1691     function mul(int128 real_a, int128 real_b) internal pure returns (int128) {
1692         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
1693         // So we just have to clip off the extra REAL_FBITS fractional bits.
1694         return int128((int256(real_a) * int256(real_b)) >> REAL_FBITS);
1695     }
1696     
1697     /**
1698      * Divide one real by another real. Truncates overflows.
1699      */
1700     function div(int128 real_numerator, int128 real_denominator) internal pure returns (int128) {
1701         // We use the reverse of the multiplication trick: convert numerator from
1702         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
1703         return int128((int256(real_numerator) * REAL_ONE) / int256(real_denominator));
1704     }
1705     
1706     /**
1707      * Create a real from a rational fraction.
1708      */
1709     function fraction(int64 numerator, int64 denominator) internal pure returns (int128) {
1710         return div(toReal(numerator), toReal(denominator));
1711     }
1712     
1713     // Now we have some fancy math things (like pow and trig stuff). This isn't
1714     // in the RealMath that was deployed with the original Macroverse
1715     // deployment, so it needs to be linked into your contract statically.
1716     
1717     /**
1718      * Raise a number to a positive integer power in O(log power) time.
1719      * See <https://stackoverflow.com/a/101613>
1720      */
1721     function ipow(int128 real_base, int64 exponent) internal pure returns (int128) {
1722         if (exponent < 0) {
1723             // Negative powers are not allowed here.
1724             revert();
1725         }
1726         
1727         // Start with the 0th power
1728         int128 real_result = REAL_ONE;
1729         while (exponent != 0) {
1730             // While there are still bits set
1731             if ((exponent & 0x1) == 0x1) {
1732                 // If the low bit is set, multiply in the (many-times-squared) base
1733                 real_result = mul(real_result, real_base);
1734             }
1735             // Shift off the low bit
1736             exponent = exponent >> 1;
1737             // Do the squaring
1738             real_base = mul(real_base, real_base);
1739         }
1740         
1741         // Return the final result.
1742         return real_result;
1743     }
1744     
1745     /**
1746      * Zero all but the highest set bit of a number.
1747      * See <https://stackoverflow.com/a/53184>
1748      */
1749     function hibit(uint256 val) internal pure returns (uint256) {
1750         // Set all the bits below the highest set bit
1751         val |= (val >>  1);
1752         val |= (val >>  2);
1753         val |= (val >>  4);
1754         val |= (val >>  8);
1755         val |= (val >> 16);
1756         val |= (val >> 32);
1757         val |= (val >> 64);
1758         val |= (val >> 128);
1759         return val ^ (val >> 1);
1760     }
1761     
1762     /**
1763      * Given a number with one bit set, finds the index of that bit.
1764      */
1765     function findbit(uint256 val) internal pure returns (uint8 index) {
1766         index = 0;
1767         // We and the value with alternating bit patters of various pitches to find it.
1768         
1769         if (val & 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA != 0) {
1770             // Picth 1
1771             index |= 1;
1772         }
1773         if (val & 0xCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC != 0) {
1774             // Pitch 2
1775             index |= 2;
1776         }
1777         if (val & 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0 != 0) {
1778             // Pitch 4
1779             index |= 4;
1780         }
1781         if (val & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00 != 0) {
1782             // Pitch 8
1783             index |= 8;
1784         }
1785         if (val & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000 != 0) {
1786             // Pitch 16
1787             index |= 16;
1788         }
1789         if (val & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000 != 0) {
1790             // Pitch 32
1791             index |= 32;
1792         }
1793         if (val & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000 != 0) {
1794             // Pitch 64
1795             index |= 64;
1796         }
1797         if (val & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000 != 0) {
1798             // Pitch 128
1799             index |= 128;
1800         }
1801     }
1802     
1803     /**
1804      * Shift real_arg left or right until it is between 1 and 2. Return the
1805      * rescaled value, and the number of bits of right shift applied. Shift may be negative.
1806      *
1807      * Expresses real_arg as real_scaled * 2^shift, setting shift to put real_arg between [1 and 2).
1808      *
1809      * Rejects 0 or negative arguments.
1810      */
1811     function rescale(int128 real_arg) internal pure returns (int128 real_scaled, int64 shift) {
1812         if (real_arg <= 0) {
1813             // Not in domain!
1814             revert();
1815         }
1816         
1817         require(isInt256ValidIn64(REAL_FBITS));
1818         
1819         // Find the high bit
1820         int64 high_bit = findbit(hibit(uint256(real_arg)));
1821         
1822         // We'll shift so the high bit is the lowest non-fractional bit.
1823         shift = high_bit - int64(REAL_FBITS);
1824         
1825         if (shift < 0) {
1826             // Shift left
1827             real_scaled = real_arg << -shift;
1828         } else if (shift >= 0) {
1829             // Shift right
1830             real_scaled = real_arg >> shift;
1831         }
1832     }
1833     
1834     /**
1835      * Calculate the natural log of a number. Rescales the input value and uses
1836      * the algorithm outlined at <https://math.stackexchange.com/a/977836> and
1837      * the ipow implementation.
1838      *
1839      * Lets you artificially limit the number of iterations.
1840      *
1841      * Note that it is potentially possible to get an un-converged value; lack
1842      * of convergence does not throw.
1843      */
1844     function lnLimited(int128 real_arg, int max_iterations) internal pure returns (int128) {
1845         if (real_arg <= 0) {
1846             // Outside of acceptable domain
1847             revert();
1848         }
1849         
1850         if (real_arg == REAL_ONE) {
1851             // Handle this case specially because people will want exactly 0 and
1852             // not ~2^-39 ish.
1853             return 0;
1854         }
1855         
1856         // We know it's positive, so rescale it to be between [1 and 2)
1857         int128 real_rescaled;
1858         int64 shift;
1859         (real_rescaled, shift) = rescale(real_arg);
1860         
1861         // Compute the argument to iterate on
1862         int128 real_series_arg = div(real_rescaled - REAL_ONE, real_rescaled + REAL_ONE);
1863         
1864         // We will accumulate the result here
1865         int128 real_series_result = 0;
1866         
1867         for (int64 n = 0; n < max_iterations; n++) {
1868             // Compute term n of the series
1869             int128 real_term = div(ipow(real_series_arg, 2 * n + 1), toReal(2 * n + 1));
1870             // And add it in
1871             real_series_result += real_term;
1872             if (real_term == 0) {
1873                 // We must have converged. Next term is too small to represent.
1874                 break;
1875             }
1876             // If we somehow never converge I guess we will run out of gas
1877         }
1878         
1879         // Double it to account for the factor of 2 outside the sum
1880         real_series_result = mul(real_series_result, REAL_TWO);
1881         
1882         // Now compute and return the overall result
1883         return mul(toReal(shift), REAL_LN_TWO) + real_series_result;
1884         
1885     }
1886     
1887     /**
1888      * Calculate a natural logarithm with a sensible maximum iteration count to
1889      * wait until convergence. Note that it is potentially possible to get an
1890      * un-converged value; lack of convergence does not throw.
1891      */
1892     function ln(int128 real_arg) internal pure returns (int128) {
1893         return lnLimited(real_arg, 100);
1894     }
1895     
1896 
1897      /**
1898      * Calculate e^x. Uses the series given at
1899      * <http://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap04/exp.html>.
1900      *
1901      * Lets you artificially limit the number of iterations.
1902      *
1903      * Note that it is potentially possible to get an un-converged value; lack
1904      * of convergence does not throw.
1905      */
1906     function expLimited(int128 real_arg, int max_iterations) internal pure returns (int128) {
1907         // We will accumulate the result here
1908         int128 real_result = 0;
1909         
1910         // We use this to save work computing terms
1911         int128 real_term = REAL_ONE;
1912         
1913         for (int64 n = 0; n < max_iterations; n++) {
1914             // Add in the term
1915             real_result += real_term;
1916             
1917             // Compute the next term
1918             real_term = mul(real_term, div(real_arg, toReal(n + 1)));
1919             
1920             if (real_term == 0) {
1921                 // We must have converged. Next term is too small to represent.
1922                 break;
1923             }
1924             // If we somehow never converge I guess we will run out of gas
1925         }
1926         
1927         // Return the result
1928         return real_result;
1929         
1930     }
1931 
1932     function expLimited(int128 real_arg, int max_iterations, int k) internal pure returns (int128) {
1933         // We will accumulate the result here
1934         int128 real_result = 0;
1935         
1936         // We use this to save work computing terms
1937         int128 real_term = REAL_ONE;
1938         
1939         for (int64 n = 0; n < max_iterations; n++) {
1940             // Add in the term
1941             real_result += real_term;
1942             
1943             // Compute the next term
1944             real_term = mul(real_term, div(real_arg, toReal(n + 1)));
1945             
1946             if (real_term == 0) {
1947                 // We must have converged. Next term is too small to represent.
1948                 break;
1949             }
1950 
1951             if (n == k) return real_term;
1952 
1953             // If we somehow never converge I guess we will run out of gas
1954         }
1955         
1956         // Return the result
1957         return real_result;
1958         
1959     }
1960 
1961     /**
1962      * Calculate e^x with a sensible maximum iteration count to wait until
1963      * convergence. Note that it is potentially possible to get an un-converged
1964      * value; lack of convergence does not throw.
1965      */
1966     function exp(int128 real_arg) internal pure returns (int128) {
1967         return expLimited(real_arg, 100);
1968     }
1969     
1970     /**
1971      * Raise any number to any power, except for negative bases to fractional powers.
1972      */
1973     function pow(int128 real_base, int128 real_exponent) internal pure returns (int128) {
1974         if (real_exponent == 0) {
1975             // Anything to the 0 is 1
1976             return REAL_ONE;
1977         }
1978         
1979         if (real_base == 0) {
1980             if (real_exponent < 0) {
1981                 // Outside of domain!
1982                 revert();
1983             }
1984             // Otherwise it's 0
1985             return 0;
1986         }
1987         
1988         if (fpart(real_exponent) == 0) {
1989             // Anything (even a negative base) is super easy to do to an integer power.
1990             
1991             if (real_exponent > 0) {
1992                 // Positive integer power is easy
1993                 return ipow(real_base, fromReal(real_exponent));
1994             } else {
1995                 // Negative integer power is harder
1996                 return div(REAL_ONE, ipow(real_base, fromReal(-real_exponent)));
1997             }
1998         }
1999         
2000         if (real_base < 0) {
2001             // It's a negative base to a non-integer power.
2002             // In general pow(-x^y) is undefined, unless y is an int or some
2003             // weird rational-number-based relationship holds.
2004             revert();
2005         }
2006         
2007         // If it's not a special case, actually do it.
2008         return exp(mul(real_exponent, ln(real_base)));
2009     }
2010 }