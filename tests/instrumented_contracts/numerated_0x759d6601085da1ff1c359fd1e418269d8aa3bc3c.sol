1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 abstract contract ReentrancyGuard {
5     uint256 private constant _NOT_ENTERED = 1;
6     uint256 private constant _ENTERED = 2;
7 
8     uint256 private _status;
9 
10     constructor() {
11         _status = _NOT_ENTERED;
12     }
13 
14     modifier nonReentrant() {
15         _nonReentrantBefore();
16         _;
17         _nonReentrantAfter();
18     }
19 
20     function _nonReentrantBefore() private {
21         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
22         _status = _ENTERED;
23     }
24 
25     function _nonReentrantAfter() private {
26         _status = _NOT_ENTERED;
27     }
28 }
29 
30 
31 abstract contract Context is ReentrancyGuard{
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49 
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56   
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61 
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(
74             newOwner != address(0),
75             "Ownable: new owner is the zero address"
76         );
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 
81 }
82 
83 interface ERC20Interface {
84     function transferFrom(address _from, address _to, uint _value)external;
85     function allowance(address _owner, address _spender) external returns (uint remaining);
86 }
87 
88 interface BEP20Interface {
89     function transferFrom(address _from, address _to, uint256 _value)external;
90 }
91 
92 
93 contract WalletPayment{
94     address private _betTokenAddress;
95     address private _tokenPoolAddress;
96     bool private ifEth;
97 
98     function _getIfEth()internal view returns (bool){
99         return ifEth;
100     }
101 
102     function _setIfEth(bool _ifEth)internal {
103        ifEth = _ifEth;
104     }
105 
106     function _getBetTokenAddress()internal view returns (address){
107         return _betTokenAddress;
108     }
109 
110     function _setBetTokenAddress(address betTokenAddress_)internal {
111         require(betTokenAddress_!=address(0),"WalletPayment:Address can not be zero.");
112         _betTokenAddress=betTokenAddress_;
113     }
114 
115     function _getTokenPoolAddress()internal view returns (address){
116         return _tokenPoolAddress;
117     }
118 
119     function _setTokenPoolAddress(address tokenPoolAddress_)internal {
120         require(tokenPoolAddress_!=address(0),"WalletPayment:Address can not be zero.");
121         _tokenPoolAddress=tokenPoolAddress_;
122     }
123 
124     function _payBetToken(uint256 amount)internal {
125         require(amount>0,"WalletPayment:Amount can not be zero.");
126         if(ifEth){
127           require(ERC20Interface(_betTokenAddress).allowance(msg.sender,address(this))>=amount,"WalletPayment: transfer amount exceeds allowance");
128           ERC20Interface(_betTokenAddress).transferFrom(msg.sender,_tokenPoolAddress,amount);
129         }else{
130           BEP20Interface(_betTokenAddress).transferFrom(msg.sender,_tokenPoolAddress,amount);
131         }
132         
133     }
134 
135     function _payBetTokenToUser(address to ,uint256 amount)internal {
136         require(to!=address(0),"WalletPayment:Address can not be zero.");
137         require(amount>0,"WalletPayment:Amount can not be zero.");
138          if(ifEth){
139           require(ERC20Interface(_betTokenAddress).allowance(_tokenPoolAddress,address(this))>=amount,"WalletPayment: transfer amount exceeds allowance");
140           ERC20Interface(_betTokenAddress).transferFrom(_tokenPoolAddress,to,amount);
141            }else{
142           BEP20Interface(_betTokenAddress).transferFrom(_tokenPoolAddress,to,amount);
143         }
144     }
145 }
146 
147   
148 
149 
150 contract  WalletAccountDomain{
151 
152   struct WalletAccountEntity{
153       address userAddress;
154       uint256 balance;
155       uint256 createTime;
156       uint256 updateTime;
157   }
158 }
159 
160 contract WalletAccountService is WalletAccountDomain{
161 
162   mapping(address=>WalletAccountEntity) private  walletAccounts;
163 
164   function _balanceOperation(address user,bool income,uint256 amount) internal  returns(uint256 newBalance){
165     require(user!=address(0),"WalletAccountService:Address can not be zero.");
166     require(amount>0,"WalletAccountService:Amount can not be zero.");
167 
168     WalletAccountEntity storage account = walletAccounts[user];
169     if(account.createTime ==0){
170       account.userAddress = user;
171       account.balance=0;
172       account.createTime=block.timestamp;
173       account.updateTime=block.timestamp;
174     }
175     if(income){
176       newBalance = account.balance + amount;
177     }else{
178       require(account.balance>=amount,"WalletAccountService : Insufficient Balance");
179       newBalance =  account.balance - amount;
180     }
181     account.balance = newBalance;
182     account.updateTime = block.timestamp;
183   }
184 
185   function _balanceOf(address user) internal view returns(uint256){
186     return walletAccounts[user].balance;
187   }
188   
189 
190 }
191 
192 contract WalletService is WalletAccountService,WalletPayment{
193   function _withdraw(uint256 amount) internal {
194     uint256 balance = _balanceOf(msg.sender);
195     require(amount>0,"WalletService : Amount can not be zero.");
196     require(balance >= amount,"WalletService : Insufficient Balance");
197     _balanceOperation(msg.sender,false,amount);
198     _payBetTokenToUser(msg.sender,amount);
199   } 
200 }
201 
202 
203 contract Sequence{
204   mapping(string =>uint256) private  sequences;
205   function _current(string memory seqKey) internal view returns(uint256){
206     return sequences[seqKey];
207   }
208 
209   function _increment(string memory seqKey) internal returns(uint256){
210     uint256 seqValue = sequences[seqKey];
211     seqValue = seqValue +1;
212     sequences[seqKey]=seqValue;
213     return seqValue;
214   }
215 }
216 
217 interface IMarketOddsFactory{
218   function calcOdds(MarketDomain.MarketBetBo calldata MarketBetBo,MarketDomain.MarketBetOptionBo [] calldata options) pure external returns (bool exceed,uint256 currentOdds,MarketDomain.MarketBetOptionBo [] memory currOptions);
219 }
220 
221 interface MarketSwapInterceptor{
222   // function onSwapBefore(address user,uint256 poolId,uint256 poolType,uint256 option,uint256 swapAmount)external;
223   function onSwapAfter(address user,uint256 poolId,uint256 poolType,uint256 option,uint256 swapAmount,uint256 odds)external;
224 }
225 
226 contract ConfigCenter{
227 
228   struct InterceptorConfig{
229     address contractAddress;
230     bool valid;
231   }
232 
233   mapping(uint256 =>address) private  marketOddsFactorys;
234   InterceptorConfig [] private  marketSwapInterceptors;
235 
236   function _setOddsFactory(
237     uint256 poolType,address factoryAddress)
238     internal
239   {
240   require(poolType>0 && factoryAddress!=address(0),"ConfigCenter: poolType or factoryAddress can not be zero.");
241   marketOddsFactorys[poolType]=factoryAddress;
242   }
243 
244   function _oddsFactoryOf(uint256 poolType)
245     view
246     internal
247     returns (address)
248   {
249   return marketOddsFactorys[poolType];
250   }
251 
252   function _installSwapInterceptor(
253     address marketSwapInterceptor)
254     internal
255   {
256   require(marketSwapInterceptor!=address(0),"ConfigCenter: marketSwapInterceptor can not be zero.");
257   bool exists;
258   bool valid;
259   uint256 index;
260   (exists,valid ,index) = _find(marketSwapInterceptor);
261   if(exists){
262     marketSwapInterceptors[index].valid = true;
263   }else{
264     marketSwapInterceptors.push(InterceptorConfig({
265       valid:true,
266       contractAddress:marketSwapInterceptor
267     }));
268   } 
269   }
270 
271   function _find(address _contractAddress)
272   view internal
273   returns (bool exists ,bool valid ,uint256 index)
274   {
275      if(marketSwapInterceptors.length==0){
276        return (false,false,0);
277      }
278     for(uint256 i = 0; i < marketSwapInterceptors.length; i++){
279       InterceptorConfig memory interceptor = marketSwapInterceptors[i];
280       if(interceptor.contractAddress == _contractAddress){
281         return (true,interceptor.valid,i);
282       }
283     }
284 
285   }
286 
287   function _unstallSwapInterceptor(
288     address marketSwapInterceptor)
289     internal
290   {
291   require(marketSwapInterceptor!=address(0),"ConfigCenter: marketSwapInterceptor can not be zero.");
292   bool exists;
293   bool valid;
294   uint256 index;
295   (exists,valid ,index) = _find(marketSwapInterceptor);
296   if(exists){
297     marketSwapInterceptors[index].valid = false;
298   }
299 }
300 
301   function _findAllSwapInterceptor()
302     view
303     internal
304     returns (InterceptorConfig [] memory )
305   {
306   return marketSwapInterceptors;
307   }
308 }
309 
310 
311 contract  MarketDomain{
312 
313     struct MarketBetOptionEntity{
314         uint256 option;
315         uint256 currOdds;
316         uint256 betTotalAmount;       
317     }
318 
319 
320     struct MarketPoolEntity{
321       uint256 poolId;
322       uint256 poolType;
323       uint256 fixtureId;
324       uint256 betMinAmount;
325       uint256 betMaxAmount;
326       uint256 fee;
327       bool    betEnable;
328       uint256 betBeginTime;
329       uint256 betEndTime;
330       uint256 createTime;
331       uint256 updateTime;
332   }
333 
334   struct MarketPoolAddDto{
335       uint256 poolId;
336       uint256 poolType;
337       uint256 fixtureId;
338       uint256 betMinAmount;
339       uint256 betMaxAmount;
340       uint256 fee;
341       bool    betEnable;
342       uint256 betBeginTime;
343       uint256 betEndTime;
344   }
345 
346   struct MarketPoolEditDto{
347       uint256 poolId;
348       uint256 fixtureId;
349       uint256 betMinAmount;
350       uint256 betMaxAmount;
351       bool    betEnable;
352       uint256 betBeginTime;
353       uint256 betEndTime;
354   }
355 
356 
357   struct MarketBetEntity{
358       uint256 betId;
359       uint256 poolId;
360       address userAddress;
361       uint256 option;
362       uint256 currOdds;
363       uint256 betAmount;
364       bool    drawed;
365       uint256 drawTime;
366       uint256 rewardAmout;
367       uint256 refundAmount;
368       uint256 createTime;
369       uint256 updateTime;
370   }
371 
372   struct MarketBetDto{
373       uint256 poolId;
374       uint256 option;
375       uint256 betAmount;
376       uint256 slide;
377   }
378   
379   struct MarketBetBo{
380     uint256 poolId;
381     uint256 poolType;
382     address user;
383     uint256 option;
384     uint256 betAmount;
385     uint256 slide;
386     uint256 fee;
387     uint256 minUnit;
388   }
389 
390   struct MarketBetOptionBo{
391         uint256 option;
392         uint256 currOdds;
393         uint256 betTotalAmount;       
394   }
395 }
396 
397 
398 contract MarketService is MarketDomain,Sequence,WalletService,ConfigCenter{
399     string private betIdKey = "BETID";
400     mapping(uint256=>MarketPoolEntity)  pools;
401     mapping(uint256=>MarketBetOptionEntity [])  poolOptions;
402     mapping(uint256=>MarketBetEntity)  bets;
403 
404     function _addMarketPoolEntity(
405      MarketPoolAddDto memory _poolAddDto)
406     internal
407    {
408      require(_poolAddDto.poolId>0,"MarketService: PoolId can not be zero.");
409      MarketPoolEntity storage localPool = pools[_poolAddDto.poolId];
410      require(localPool.poolId==0,"MarketService: Pool already exists.");
411      localPool.poolId = _poolAddDto.poolId;
412      localPool.poolType = _poolAddDto.poolType;
413      localPool.fixtureId = _poolAddDto.fixtureId;
414      localPool.betBeginTime = _poolAddDto.betBeginTime;
415      localPool.fee = _poolAddDto.fee;
416      localPool.betEndTime = _poolAddDto.betEndTime;
417      localPool.betEnable = _poolAddDto.betEnable;
418      localPool.betMinAmount = _poolAddDto.betMinAmount;
419      localPool.betMaxAmount = _poolAddDto.betMaxAmount;
420      localPool.createTime = block.timestamp;
421      localPool.updateTime = block.timestamp;
422     }
423 
424     function _editMarketPoolEntity(
425      MarketPoolEditDto memory _poolEditDto)
426     internal
427    {
428      require(_poolEditDto.poolId>0,"MarketService: PoolId can not be zero.");
429      MarketPoolEntity storage localPool = pools[_poolEditDto.poolId];
430      require(localPool.poolId>0,"MarketService: Pool not found!");
431      if(_poolEditDto.fixtureId>0){
432       localPool.fixtureId = _poolEditDto.fixtureId;
433      }
434      if(_poolEditDto.betBeginTime>0){
435        localPool.betBeginTime = _poolEditDto.betBeginTime;
436      }
437      if(_poolEditDto.betEndTime>0){
438        localPool.betEndTime = _poolEditDto.betEndTime;
439      }
440     if(_poolEditDto.betMinAmount>0){
441        localPool.betMinAmount = _poolEditDto.betMinAmount;
442      }
443      if(_poolEditDto.betMaxAmount>0){
444        localPool.betMaxAmount = _poolEditDto.betMaxAmount;
445      }
446      localPool.betEnable = _poolEditDto.betEnable;
447      localPool.updateTime = block.timestamp;
448     }
449 
450 
451     function _addMarketOptionEntities(
452       uint256 poolId,
453       uint256 [] memory optionArr,
454       uint256 [] memory initOddsArr,
455       uint256 [] memory betTotalAmountArr
456     )
457     internal
458    {
459      require(poolId>0,"MarketService: PoolId can not be zero.");
460      MarketPoolEntity storage localPool = pools[poolId];
461      require(localPool.poolId>0,"MarketService: Pool not found.");
462      MarketBetOptionEntity [] storage optionEntityArr = poolOptions[poolId];
463      require(optionEntityArr.length==0,"MarketService: Pool option already exists.");
464      require(optionArr.length==initOddsArr.length&&optionArr.length ==betTotalAmountArr.length ,"MarketService: optionArr length invalid.");    
465      for(uint256 i =0; i<optionArr.length; i++){
466        optionEntityArr.push(MarketBetOptionEntity({
467        option:optionArr[i],
468        currOdds:initOddsArr[i],
469        betTotalAmount:betTotalAmountArr[i]
470      }));
471      }
472     
473     }
474 
475     function _findMarketPoolEntity(uint256 poolId) internal view returns(MarketPoolEntity memory poolEntity){
476       poolEntity = pools[poolId];
477     }
478 
479     function _findMarketPoolBetOptionEntity(uint256 _poolId,uint256 _option) internal view returns(MarketBetOptionEntity memory result){
480       MarketBetOptionEntity [] memory  options =  poolOptions[_poolId];
481       for(uint256 i =0; i< options.length; i++){
482         MarketBetOptionEntity memory optionEntity = options[i];
483         if(optionEntity.option == _option){
484           result =  optionEntity;
485           break;
486         }
487       }
488     }
489 
490     function _findMarketPoolBetOptionEntitys(uint256 _poolId) internal view returns(MarketBetOptionEntity [] memory results){
491       return  poolOptions[_poolId];
492     }
493 
494  function _swap(
495    MarketBetDto
496    memory
497    _marketBetDto
498  ) internal returns(uint256 betId,uint256 finalOdds,uint256 createTime){
499   
500   MarketPoolEntity storage localPool = pools[_marketBetDto.poolId]; 
501   require(localPool.poolId>0,"MarketService: Invalid Pool.");
502   require(block.timestamp >=localPool.betBeginTime && block.timestamp <=localPool.betEndTime,"MarketService: Invalid bet time.");
503   require(_marketBetDto.betAmount >=localPool.betMinAmount && _marketBetDto.betAmount <=localPool.betMaxAmount,"MarketService: Invalid bet amount.");
504 
505 
506   MarketBetBo memory betBo = MarketBetBo({
507     poolId:_marketBetDto.poolId,
508     poolType:localPool.poolType,
509     user:msg.sender,
510     option:_marketBetDto.option,
511     betAmount:_marketBetDto.betAmount,
512     slide:_marketBetDto.slide,
513     minUnit:localPool.betMinAmount,
514     fee:localPool.fee
515   });
516 
517    _payBetToken(betBo.betAmount);
518 
519   MarketBetOptionEntity  [] storage optionEntiries = poolOptions[_marketBetDto.poolId];
520   MarketBetOptionBo [] memory optionBos = new MarketBetOptionBo [](optionEntiries.length);
521   bool finded = false;
522   for(uint256 i =0;i< optionEntiries.length;i ++){
523     MarketBetOptionEntity storage localOption = optionEntiries[i];
524     optionBos[i] = MarketBetOptionBo({
525       option:localOption.option,
526       currOdds:localOption.currOdds,
527       betTotalAmount:localOption.betTotalAmount
528     });
529     if(localOption.option == _marketBetDto.option){
530       finded = true;
531     }
532   }
533   require(finded,"MarketService: Invalid option.");
534    
535   uint256 nowTime = block.timestamp;
536   bool exceed;
537   uint256 currentOdds;
538   MarketBetOptionBo [] memory optionsRes;
539   address oddsFactoryAddress = _oddsFactoryOf(localPool.poolType);
540   require(oddsFactoryAddress!=address(0),"MarketService: oddsFactoryAddress not found!");
541   (exceed,currentOdds,optionsRes) = IMarketOddsFactory(oddsFactoryAddress).calcOdds(betBo,optionBos);
542   require(exceed == false,"MarketService: slide exceed.");
543   betId = _increment(betIdKey);
544   bets[betId] = MarketBetEntity({
545      betId:betId,
546      poolId:betBo.poolId,
547      userAddress:msg.sender,
548      option:betBo.option,
549      currOdds:currentOdds,
550      betAmount:betBo.betAmount,
551      drawed:false,
552      drawTime:0,
553      rewardAmout:0,
554      refundAmount:0,
555      createTime:nowTime,
556      updateTime:nowTime
557    });
558 
559    _modifyOptionsOnBet(optionEntiries,optionsRes);
560    createTime = nowTime;
561    finalOdds = currentOdds;
562 
563   _onSwapAfter(betBo,currentOdds);
564  }
565 
566  function _findBetEntity(uint256 betId)internal view returns(MarketBetEntity memory entity){
567    return bets[betId];
568  }
569 
570   function _onSwapAfter(MarketBetBo memory betbo,uint256 finalOdds)internal{
571     InterceptorConfig [] memory marketSwapInterceptors = _findAllSwapInterceptor();
572       if(marketSwapInterceptors.length >0){
573         for(uint256 i = 0; i< marketSwapInterceptors.length; i++){
574           InterceptorConfig memory interceptor = marketSwapInterceptors[i];
575           if(interceptor.valid){
576             MarketSwapInterceptor(interceptor.contractAddress).onSwapAfter(betbo.user,betbo.poolId,betbo.poolType,betbo.option,betbo.betAmount,finalOdds);
577           }      
578         }
579       }
580   }
581 
582 
583   function _modifyOptionsOnBet(MarketBetOptionEntity  []  storage options,MarketBetOptionBo [] memory optionBos)internal{
584     for(uint256 i = 0; i<options.length; i++){
585     MarketBetOptionEntity storage _option = options[i];
586     for(uint256 j = 0; j<optionBos.length; j++ ){
587       MarketBetOptionBo memory res = optionBos[j];
588       if(_option.option == res.option){
589         _option.currOdds = res.currOdds;
590         _option.betTotalAmount = res.betTotalAmount;
591       }
592     }
593   }
594  }
595   
596 
597 
598   function _draw(
599    uint256 [] calldata  betIdArr,
600    uint256 [] calldata  rewardArr,
601    uint256 [] calldata  refundArr
602  ) internal {   
603    for(uint256 i = 0; i<betIdArr.length; i++){
604      MarketBetEntity storage betEntity = bets[betIdArr[i]];
605      if(!betEntity.drawed){
606        betEntity.drawed=true;
607        betEntity.drawTime = block.timestamp;
608        betEntity.updateTime = block.timestamp;
609        betEntity.rewardAmout = rewardArr[i];
610        betEntity.refundAmount = refundArr[i];       
611        uint256 payAmount = rewardArr[i] + refundArr[i];
612        _balanceOperation(betEntity.userAddress,true,payAmount);
613      }
614    }
615 }
616 
617 }
618 
619 interface IOddsSwap{
620   function getBetTokenAddress()external view returns (address);
621   function setBetTokenAddress(address betTokenAddress)external;
622   function getTokenPoolAddress()external view returns (address);
623   function setTokenPoolAddress(address tokenPoolAddress)external;
624   function getIfEth()external view returns (bool);
625   function setIfEth(bool _ifEth)external;
626 
627   function setOddsFactory(uint256 poolType,address factoryAddress)external;
628   function oddsFactoryOf(uint256 poolType) view external returns (address);
629   function installSwapInterceptor(address marketSwapInterceptor)external;
630   function unstallSwapInterceptor(address marketSwapInterceptor)external;
631   function showAllSwapInterceptor() view external returns (address [] memory contractAddresses,bool [] memory valids);
632 
633   function findMarketPool(uint256 _poolId) external view returns(
634       uint256 poolId,
635       uint256 poolType,
636       uint256 fixtureId,
637       uint256 betMinAmount,
638       uint256 betMaxAmount,
639       uint256 fee,
640       bool    betEnable,
641       uint256 betBeginTime,
642       uint256 betEndTime,
643       uint256 createTime,
644       uint256 updateTime
645   );
646 
647   function addMarketPool(
648       uint256 poolId,
649       uint256 poolType,
650       uint256 fixtureId,
651       uint256 betMinAmount,
652       uint256 betMaxAmount,
653       uint256 fee,
654       bool    betEnable,
655       uint256 betBeginTime,
656       uint256 betEndTime
657   )external;
658 
659   function updateMarketPool(
660       uint256 poolId,
661       uint256 fixtureId,
662       uint256 betMinAmount,
663       uint256 betMaxAmount,
664       bool    betEnable,
665       uint256 betBeginTime,
666       uint256 betEndTime
667   )external;
668 
669   function findMarketPoolBetOption(
670       uint256 _poolId,
671       uint256 _option
672   )external returns(
673       uint256 option,
674       uint256 currOdds,
675       uint256 betTotalAmount
676   );
677 
678   function findMarketPoolBetAllOption(
679       uint256 _poolId
680   )external returns(
681       uint256 [] memory optionArr,
682       uint256 [] memory currOddsArr,
683       uint256 [] memory betTotalAmountArr
684   );
685 
686 
687   function addMarketPoolBetOptions(
688       uint256 poolId,
689       uint256 [] memory optionArr,
690       uint256 [] memory initOddsArr,
691       uint256 [] memory betTotalAmountArr
692   )external ;
693 
694   function draw(
695       uint256 [] calldata  betIdArr,
696       uint256 [] calldata  rewardArr,
697       uint256 [] calldata  refundArr
698   )external;
699   
700   function swap(
701     uint256 poolId,
702     uint256 option,
703     uint256 betAmount,
704     uint256 slide
705     )external;
706 
707   function findBetInfo(uint256 _betId) external view returns(
708       uint256 betId,
709       uint256 poolId,
710       address userAddress,
711       uint256 option,
712       uint256 currOdds,
713       uint256 betAmount,
714       bool    drawed,
715       uint256 drawTime,
716       uint256 rewardAmout,
717       uint256 refundAmount,
718       uint256 createTime,
719       uint256 updateTime
720   );
721   function balanceOf(address user) external view returns(uint256);  
722   function withdraw(uint256 amount) external returns(bool succeed);
723 
724   event SetBetTokenAddress(address betTokenAddress);
725   event SetTokenPoolAddress(address tokenPoolAddress);
726   event SetIfEth(bool ifEth);
727   event SetOddsFactory(uint256 poolType,address factoryAddress);
728   event InstallSwapInterceptor(address marketSwapInterceptor);
729   event UnstallSwapInterceptor(address marketSwapInterceptor);
730   event AddMarketPool(uint256 indexed poolId,uint256 poolType,uint256 fixtureId,uint256 betMinAmount,uint256 betMaxAmount,uint256 fee,bool betEnable,uint256 betBeginTime,uint256 betEndTime);
731   event UpdateMarketPool(uint256 indexed poolId,uint256 fixtureId,uint256 betMinAmount,uint256 betMaxAmount,bool  betEnable,uint256 betBeginTime,uint256 betEndTime);
732   event AddMarketBetOptions(uint256 indexed poolId,uint256 [] optionArr,uint256 [] initOddsArr,uint256 [] betTotalAmountArr);
733   event Draw( uint256 []  betIdArr, uint256 []  rewardArr,   uint256 []  refundArr,uint256 time);
734   event Swap(address indexed user,uint256 indexed poolId,uint256 betId,uint256 option,uint256 betAmount,uint256 slide,uint256 finalOdds,uint256 createTime);
735   event Withdraw(address indexed user,uint256 amount,uint256 time);
736 }
737 
738 contract OddsSwap is IOddsSwap,Ownable,MarketService{
739   function getBetTokenAddress()external view override returns (address){
740     return _getBetTokenAddress();
741   }
742   function setBetTokenAddress(address betTokenAddress)external override onlyOwner{
743     _setBetTokenAddress(betTokenAddress);
744     emit SetBetTokenAddress(betTokenAddress);
745   }
746   function getTokenPoolAddress()external view override returns (address){
747     return _getTokenPoolAddress();
748   }
749   function setTokenPoolAddress(address tokenPoolAddress)external override onlyOwner{
750     _setTokenPoolAddress(tokenPoolAddress);
751     emit SetTokenPoolAddress(tokenPoolAddress);
752   }
753 
754   function getIfEth()external view override returns (bool){
755     return _getIfEth();
756   }
757   function setIfEth(bool _ifEth)external override onlyOwner{
758     _setIfEth(_ifEth);
759     emit SetIfEth(_ifEth);
760   }
761 
762   function setOddsFactory(uint256 poolType,address factoryAddress)external override onlyOwner{
763     _setOddsFactory(poolType,factoryAddress);
764     emit SetOddsFactory(poolType,factoryAddress);
765   }
766   function oddsFactoryOf(uint256 poolType) view external override returns (address){
767     return _oddsFactoryOf(poolType);
768   }
769   function installSwapInterceptor(address marketSwapInterceptor)external override onlyOwner{
770     _installSwapInterceptor(marketSwapInterceptor);
771     emit InstallSwapInterceptor(marketSwapInterceptor);
772   }
773   function unstallSwapInterceptor(address marketSwapInterceptor)external override onlyOwner{
774     _unstallSwapInterceptor(marketSwapInterceptor);
775     emit UnstallSwapInterceptor(marketSwapInterceptor);
776   }
777   function showAllSwapInterceptor() view external override returns (address [] memory contractAddresses,bool [] memory valids){
778     ConfigCenter.InterceptorConfig [] memory all =  _findAllSwapInterceptor();
779     contractAddresses = new address[](all.length);
780     valids = new bool[](all.length);
781     for(uint256 i = 0;i< all.length; i++){
782       contractAddresses[i] = all[i].contractAddress;
783       valids[i] = all[i].valid;
784     }
785   }
786 
787   function addMarketPool(
788       uint256 poolId,
789       uint256 poolType,
790       uint256 fixtureId,
791       uint256 betMinAmount,
792       uint256 betMaxAmount,
793       uint256 fee,
794       bool    betEnable,
795       uint256 betBeginTime,
796       uint256 betEndTime
797   )external override onlyOwner{
798     MarketPoolAddDto memory dto = _toMarketAddDto(poolId,poolType,fixtureId,betMinAmount,betMaxAmount,fee,betEnable,betBeginTime,betEndTime);
799     _addMarketPoolEntity(dto);
800    emit AddMarketPool(dto.poolId,dto.poolType,dto.fixtureId,dto.betMinAmount,dto.betMaxAmount,dto.fee,dto.betEnable,dto.betBeginTime,dto.betEndTime);
801   }
802 
803   function _toMarketAddDto(
804       uint256 poolId,
805       uint256 poolType,
806       uint256 fixtureId,
807       uint256 betMinAmount,
808       uint256 betMaxAmount,
809       uint256 fee,
810       bool    betEnable,
811       uint256 betBeginTime,
812       uint256 betEndTime
813   ) internal pure returns(MarketPoolAddDto memory dto){
814       dto = MarketPoolAddDto({
815       poolId:poolId,
816       poolType:poolType,
817       fixtureId:fixtureId,
818       betMinAmount:betMinAmount,
819       betMaxAmount:betMaxAmount,
820       fee:fee,
821       betEnable:betEnable,
822       betBeginTime:betBeginTime,
823       betEndTime:betEndTime
824     });
825   }
826 
827 
828   function addMarketPoolBetOptions(
829       uint256 poolId,
830       uint256 [] memory optionArr,
831       uint256 [] memory initOddsArr,
832       uint256 [] memory betTotalAmountArr
833   )external override onlyOwner{
834     _addMarketOptionEntities(poolId,optionArr,initOddsArr,betTotalAmountArr);
835     emit AddMarketBetOptions(poolId,optionArr,initOddsArr,betTotalAmountArr);
836   }
837 
838 
839   function _toMarketBetDto(
840     uint256 poolId,
841     uint256 option,
842     uint256 betAmount,
843     uint256 slide
844   )internal pure returns (MarketBetDto memory betDto){
845     betDto = MarketBetDto({
846       poolId:poolId,
847       option:option,
848       betAmount:betAmount,
849       slide:slide
850     });
851   }
852 
853   function _toPoolEditDto(
854       uint256 poolId,
855       uint256 fixtureId,
856       uint256 betMinAmount,
857       uint256 betMaxAmount,
858       bool    betEnable,
859       uint256 betBeginTime,
860       uint256 betEndTime
861   )internal pure returns (MarketPoolEditDto memory poolEditDto){
862     poolEditDto = MarketPoolEditDto({
863       poolId:poolId,
864       fixtureId:fixtureId,
865       betMinAmount:betMinAmount,
866       betMaxAmount:betMaxAmount,
867       betEnable:betEnable,
868       betBeginTime:betBeginTime,
869       betEndTime:betEndTime
870     });
871   }
872 
873   function updateMarketPool(
874       uint256 poolId,
875       uint256 fixtureId,
876       uint256 betMinAmount,
877       uint256 betMaxAmount,
878       bool    betEnable,
879       uint256 betBeginTime,
880       uint256 betEndTime
881     )external override onlyOwner{
882       MarketPoolEditDto memory poolEditDto = _toPoolEditDto(poolId,fixtureId,betMinAmount,betMaxAmount,betEnable,betBeginTime,betEndTime);
883     _editMarketPoolEntity(poolEditDto);
884     emit UpdateMarketPool(poolId,fixtureId,betMinAmount,betMaxAmount,betEnable,betBeginTime,betEndTime);
885   }
886 
887   function findMarketPool(uint256 _poolId) external override view returns(
888       uint256 poolId,
889       uint256 poolType,
890       uint256 fixtureId,
891       uint256 betMinAmount,
892       uint256 betMaxAmount,
893       uint256 fee,
894       bool    betEnable,
895       uint256 betBeginTime,
896       uint256 betEndTime,
897       uint256 createTime,
898       uint256 updateTime){
899     MarketPoolEntity memory pool = _findMarketPoolEntity(_poolId);
900     return (pool.poolId,pool.poolType,pool.fixtureId,pool.betMinAmount,pool.betMaxAmount,pool.fee,pool.betEnable,pool.betBeginTime,pool.betEndTime,pool.createTime,pool.updateTime);
901   }
902 
903   function findMarketPoolBetOption(
904       uint256 _poolId,
905       uint256 _option
906   )external override view returns(
907       uint256 option,
908       uint256 currOdds,
909       uint256 betTotalAmount
910   ){
911       MarketBetOptionEntity memory optionEntity = _findMarketPoolBetOptionEntity(_poolId,_option);
912       return (optionEntity.option,optionEntity.currOdds,optionEntity.betTotalAmount);
913   }
914 
915 
916   function findMarketPoolBetAllOption(
917       uint256 _poolId
918   )external override view returns(
919       uint256 [] memory optionArr,
920       uint256 [] memory currOddsArr,
921       uint256 [] memory betTotalAmountArr
922   ){
923       MarketBetOptionEntity [] memory options = _findMarketPoolBetOptionEntitys(_poolId);
924       optionArr = new uint256[](options.length);
925       currOddsArr = new uint256[](options.length);
926       betTotalAmountArr = new uint256[](options.length);
927       for(uint256 i =0;i<options.length;i++){
928         optionArr[i] = options[i].option;
929         currOddsArr[i] = options[i].currOdds;
930         betTotalAmountArr[i] = options[i].betTotalAmount;
931       }
932   }
933 
934 
935   function draw(
936       uint256 [] calldata  betIdArr,
937       uint256 [] calldata  rewardArr,
938       uint256 [] calldata  refundArr
939     )external override onlyOwner{
940     _draw(betIdArr,rewardArr,refundArr);
941     emit Draw(betIdArr,rewardArr,refundArr,block.timestamp);
942   }
943 
944   function swap(
945     uint256 poolId,
946     uint256 option,
947     uint256 betAmount,
948     uint256 slide
949     )external nonReentrant override{
950     MarketBetDto memory marketBetDto = _toMarketBetDto(poolId,option,betAmount,slide);
951     uint256 betId;
952     uint256 finalOdds;
953     uint256 createTime;
954     (betId,finalOdds,createTime) = _swap(marketBetDto);
955     emit Swap(msg.sender,marketBetDto.poolId,betId,marketBetDto.option,marketBetDto.betAmount,marketBetDto.slide,finalOdds,createTime);
956   }
957 
958   function findBetInfo(uint256 _betId) external view override returns(
959       uint256 betId,
960       uint256 poolId,
961       address userAddress,
962       uint256 option,
963       uint256 currOdds,
964       uint256 betAmount,
965       bool    drawed,
966       uint256 drawTime,
967       uint256 rewardAmout,
968       uint256 refundAmount,
969       uint256 createTime,
970       uint256 updateTime
971   ){
972     MarketBetEntity memory bet = _findBetEntity(_betId);
973     return (bet.betId,bet.poolId,bet.userAddress,bet.option,bet.currOdds,bet.betAmount,bet.drawed,bet.drawTime,bet.rewardAmout,bet.refundAmount,bet.createTime,bet.updateTime);
974   }
975 
976   function balanceOf(address user) external view override returns(uint256) {
977     return _balanceOf(user);
978   }
979   function withdraw(uint256 amount) external nonReentrant override returns(bool succeed){
980     _withdraw(amount);
981     succeed =  true;
982     emit Withdraw(msg.sender,amount,block.timestamp);
983   }
984 
985   constructor(address betTokenAddress,address tokenPoolAddress){
986     _setBetTokenAddress(betTokenAddress);
987     _setTokenPoolAddress(tokenPoolAddress);
988   }
989 }