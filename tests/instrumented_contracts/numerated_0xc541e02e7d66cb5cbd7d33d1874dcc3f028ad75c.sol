1 pragma solidity ^0.4.20;
2 
3 /*
4 * LastHero团队.
5 * -> 这是什么?
6 * 改进的自主金字塔资金模型:
7 * [x] 该合约是目前最稳定的智能合约，经受过所有的攻击测试!
8 * [x] 由ARC等多名安全专家审核测试。
9 * [X] 新功能：可部分卖出，而不必将你的所有资产全部卖出!
10 * [x] 新功能：可以在钱包之间传输代币。可以在智能合约中进行交易!
11 * [x] 新特性：世界首创POS节点以太坊职能合约，让V神疯狂的新功能。
12 * [x] 主节点：持有100个代币即可拥有自己的主节点，主节点是唯一的智能合约入口!
13 * [x] 主节点：所有通过你的主节点进入合约的玩家，你可以获得10%的分红!
14 *
15 * -> 关于项目?
16 * 我们的团队成员拥有超强的创建安全智能合约的能力。
17 * 新的开发团队由经验丰富的专业开发人员组成，并由资深合约安全专家审核。
18 * 另外，我们公开进行过数百次的模拟攻击，该合约从来没有被攻破过。
19 * 
20 * -> 这个项目的成员有哪些?
21 * - PonziBot (math/memes/main site/master)数学
22 * - Mantso (lead solidity dev/lead web3 dev)主程
23 * - swagg (concept design/feedback/management)概念设计/反馈/管理
24 * - Anonymous#1 (main site/web3/test cases)网站/web3/测试
25 * - Anonymous#2 (math formulae/whitepaper)数学推导/白皮书
26 *
27 * -> 该项目的安全审核人员:
28 * - Arc
29 * - tocisck
30 * - sumpunk
31 */
32 
33 contract Hourglass {
34     /*=================================
35     =            MODIFIERS  全局       =
36     =================================*/
37     // 只限持币用户
38     modifier onlyBagholders() {
39         require(myTokens() > 0);
40         _;
41     }
42     
43     // 只限收益用户
44     modifier onlyStronghands() {
45         require(myDividends(true) > 0);
46         _;
47     }
48     
49     // 管理员权限:
50     // -> 更改合约名称
51     // -> 更改代币名称
52     // -> 改变POS的难度（确保维持一个主节点需要多少代币，以避免滥发）
53     // 管理员没有权限做以下事宜:
54     // -> 动用资金
55     // -> 禁止用户取款
56     // -> 自毁合约
57     // -> 改变代币价格
58     modifier onlyAdministrator(){ // 用来确定是管理员
59         address _customerAddress = msg.sender;
60         require(administrators[keccak256(_customerAddress)]); // 在管理员列表中存在
61         _; // 表示在modifier的函数执行完后，开始执行其它函数
62     }
63     
64     
65     // 确保合约中第一批代币均等的分配
66     // 这意味着，不公平的优势成本是不可能存在的
67     // 这将为基金的健康成长打下坚实的基础。
68     modifier antiEarlyWhale(uint256 _amountOfEthereum){ // 判断状态
69         address _customerAddress = msg.sender;
70         
71         // 我们还是处于不利的投资地位吗?
72         // 既然如此，我们将禁止早期的大额投资 
73         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
74             require(
75                 // 这个用户在代表名单吗？
76                 ambassadors_[_customerAddress] == true &&
77                 
78                 // 用户购买量是否超过代表的最大配额？
79                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
80                 
81             );
82             
83             // 更新累计配额  
84             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
85         
86             // 执行
87             _;
88         } else {
89             // 如果基金中以太币数量下降到创世值，代表阶段也不会重新启动。
90             onlyAmbassadors = false;
91             _;    
92         }
93         
94     }
95     
96     
97     /*==============================
98     =            EVENTS  事件      =
99     ==============================*/
100     event onTokenPurchase( // 购买代币
101         address indexed customerAddress,
102         uint256 incomingEthereum,
103         uint256 tokensMinted,
104         address indexed referredBy
105     );
106     
107     event onTokenSell( // 出售代币
108         address indexed customerAddress,
109         uint256 tokensBurned,
110         uint256 ethereumEarned
111     );
112     
113     event onReinvestment( // 再投资
114         address indexed customerAddress,
115         uint256 ethereumReinvested,
116         uint256 tokensMinted
117     );
118     
119     event onWithdraw( // 提取资金
120         address indexed customerAddress,
121         uint256 ethereumWithdrawn
122     );
123     
124     // ERC20标准
125     event Transfer( // 一次交易
126         address indexed from,
127         address indexed to,
128         uint256 tokens
129     );
130     
131     
132     /*=====================================
133     =            CONFIGURABLES  配置       =
134     =====================================*/
135     string public name = "LastHero3D"; // 名字
136     string public symbol = "Keys"; // 符号
137     uint8 constant public decimals = 18; // 小数位
138     uint8 constant internal dividendFee_ = 10; // 交易分红比例
139     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; // 代币初始价格
140     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; // 代币递增价格
141     uint256 constant internal magnitude = 2**64;
142     
143     // 股份证明（默认值为100代币）
144     uint256 public stakingRequirement = 100e18;
145     
146     // 代表计划
147     mapping(address => bool) internal ambassadors_; // 代表集合
148     uint256 constant internal ambassadorMaxPurchase_ = 1 ether; // 最大购买
149     uint256 constant internal ambassadorQuota_ = 20 ether; // 购买限额
150     
151     
152     
153    /*================================
154     =            DATASETS   数据     =
155     ================================*/
156     // 每个地址的股份数量（按比例编号）
157     mapping(address => uint256) internal tokenBalanceLedger_; // 保存地址的代币数量
158     mapping(address => uint256) internal referralBalance_; // 保存地址的推荐分红
159     mapping(address => int256) internal payoutsTo_;
160     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
161     uint256 internal tokenSupply_ = 0;
162     uint256 internal profitPerShare_;
163     
164     // 管理员列表（管理员权限见上述）
165     mapping(bytes32 => bool) public administrators; // 管理者地址列表
166     
167     // 当代表制度成立，只有代表可以购买代币（这确保了完美的金字塔分布，以防持币比例不均）
168     bool public onlyAmbassadors = true; // 限制只有代表能够购买代币
169     
170 
171 
172     /*=======================================
173     =            PUBLIC FUNCTIONS 公开函数   =
174     =======================================*/
175     /*
176     * -- 应用入口 --  
177     */
178     function Hourglass()
179         public
180     {
181         // 在这里添加管理员
182         administrators[0x4d947d5487ba694cc3c03fbaae7a63f0aec61e26bf7284baa1e36f8cbdbfe7e1] = true;
183         administrators[0xdacb12a29ec52e618a1dbe39a3317833066e94371856cc2013565dab2ae6fa62] = true;
184         
185         // 在这里添加代表。
186         // mantso - lead solidity dev & lead web dev. 
187         ambassadors_[0xdD9eaEbc859051A801e2044636204271B5D6821A] = true;
188         
189         // ponzibot - mathematics & website, and undisputed meme god.
190         ambassadors_[0xd47671aA1c42cF274697C8Fdf77470509B296d09] = true;
191 
192         ambassadors_[0x8948e4b00deb0a5adb909f4dc5789d20d0851d71] = true;
193         
194 
195     }
196     
197      
198     /**
199      * 将所有以太坊网络传入转换为代币调用，并向下传递（如果有下层拓扑）
200      */
201     function buy(address _referredBy)
202         public
203         payable
204         returns(uint256)
205     {
206         purchaseTokens(msg.value, _referredBy);
207     }
208     
209     /**
210      * 回调函数来处理直接发送到合约的以太坊参数。
211      * 我们不能通过这种方式来指定一个地址。
212      */
213     function()
214         payable
215         public
216     {
217         purchaseTokens(msg.value, 0x0);
218     }
219     
220     /**
221      * 将所有的分红请求转换为代币。
222      */
223     function reinvest()
224         onlyStronghands()
225         public
226     {
227         // 提取股息
228         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
229         
230         // 实际支付的股息
231         address _customerAddress = msg.sender;
232         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
233         
234         // 检索参考奖金
235         _dividends += referralBalance_[_customerAddress];
236         referralBalance_[_customerAddress] = 0;
237         
238         // 发送一个购买订单通过虚拟化的“撤回股息”
239         uint256 _tokens = purchaseTokens(_dividends, 0x0);
240         
241         // 重大事件
242         onReinvestment(_customerAddress, _dividends, _tokens);
243     }
244     
245     /**
246      * 退出流程，卖掉并且提取资金
247      */
248     function exit()
249         public
250     {
251         // 通过调用获取代币数量并将其全部出售
252         address _customerAddress = msg.sender;
253         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
254         if(_tokens > 0) sell(_tokens);
255         
256         // 取款服务
257         withdraw();
258     }
259 
260     /**
261      * 取走请求者的所有收益。
262      */
263     function withdraw()
264         onlyStronghands()
265         public
266     {
267         // 设置数据
268         address _customerAddress = msg.sender;
269         uint256 _dividends = myDividends(false); // 从代码中获得参考奖金
270         
271         // 更新股息系统
272         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
273         
274         // 添加参考奖金
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277         
278         // 获取服务
279         _customerAddress.transfer(_dividends);
280         
281         // 重大事件
282         onWithdraw(_customerAddress, _dividends);
283     }
284     
285     /**
286      * 以太坊代币。
287      */
288     function sell(uint256 _amountOfTokens)
289         onlyBagholders()
290         public
291     {
292         // 设置数据
293         address _customerAddress = msg.sender;
294         // 来自俄罗斯的BTFO
295         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         uint256 _tokens = _amountOfTokens;
297         uint256 _ethereum = tokensToEthereum_(_tokens);
298         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
299         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
300         
301         // 销毁已出售的代币
302         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
304         
305         // 更新股息系统
306         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
307         payoutsTo_[_customerAddress] -= _updatedPayouts;       
308         
309         // 禁止除以0
310         if (tokenSupply_ > 0) {
311             // 更新代币的股息金额
312             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
313         }
314         
315         // 重大事件
316         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
317     }
318     
319     
320     /**
321      * 从请求者账户转移代币新持有者账户。
322      * 记住，这里还有10%的费用。
323      */
324     function transfer(address _toAddress, uint256 _amountOfTokens)
325         onlyBagholders()
326         public
327         returns(bool)
328     {
329         // 设置
330         address _customerAddress = msg.sender;
331         
332         // 取保拥有足够的代币
333         // 代币禁止转移，直到代表阶段结束。
334         // （我们不想捕鲸）
335         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336         
337         // 取走所有未付的股息
338         if(myDividends(true) > 0) withdraw();
339         
340         // 被转移代币的十分之一
341         // 这些都将平分给个股东
342         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
343         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
344         uint256 _dividends = tokensToEthereum_(_tokenFee);
345   
346         // 销毁费用代币
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
348 
349         // 代币交换
350         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
351         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
352         
353         // 更新股息系统
354         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
355         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
356         
357         // 分发股息给持有者
358         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
359         
360         // 重大事件
361         Transfer(_customerAddress, _toAddress, _taxedTokens);
362         
363         // ERC20标准
364         return true;
365        
366     }
367     
368     /*----------  管理员功能  ----------*/
369     /**
370      * 如果没有满足配额，管理员可以提前结束代表阶段。
371      */
372     function disableInitialStage()
373         onlyAdministrator()
374         public
375     {
376         onlyAmbassadors = false;
377     }
378     
379     /**
380      * 在特殊情况，可以更换管理员账户。
381      */
382     function setAdministrator(bytes32 _identifier, bool _status)
383         onlyAdministrator()
384         public
385     {
386         administrators[_identifier] = _status;
387     }
388     
389     /**
390      * 作为预防措施，管理员可以调整主节点的费率。
391      */
392     function setStakingRequirement(uint256 _amountOfTokens)
393         onlyAdministrator()
394         public
395     {
396         stakingRequirement = _amountOfTokens;
397     }
398     
399     /**
400      * 管理员可以重新定义品牌（代币名称）。
401      */
402     function setName(string _name)
403         onlyAdministrator()
404         public
405     {
406         name = _name;
407     }
408     
409     /**
410      * 管理员可以重新定义品牌（代币符号）。
411      */
412     function setSymbol(string _symbol)
413         onlyAdministrator()
414         public
415     {
416         symbol = _symbol;
417     }
418 
419     
420     /*----------  帮助者和计数器  ----------*/
421     /**
422      * 在合约中查看当前以太坊状态的方法
423      * 例如 totalEthereumBalance()
424      */
425     function totalEthereumBalance() // 查看余额
426         public
427         view
428         returns(uint)
429     {
430         return this.balance;
431     }
432     
433     /**
434      * 检索代币供应总量。
435      */
436     function totalSupply()
437         public
438         view
439         returns(uint256)
440     {
441         return tokenSupply_;
442     }
443     
444     /**
445      * 检索请求者的代币余额。
446      */
447     function myTokens()
448         public
449         view
450         returns(uint256)
451     {
452         address _customerAddress = msg.sender; // 获得发送者的地址
453         return balanceOf(_customerAddress);
454     }
455     
456     /**
457      * 取回请求者拥有的股息。
458      * 如果`_includeReferralBonus` 的值为1，那么推荐奖金将被计算在内。
459      * 其原因是，在网页的前端，我们希望得到全局汇总。
460      * 但在内部计算中，我们希望分开计算。
461      */ 
462     function myDividends(bool _includeReferralBonus) // 返回分红数，传入的参数用来指示是否考虑推荐分红
463         public 
464         view 
465         returns(uint256)
466     {
467         address _customerAddress = msg.sender;
468         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
469     }
470     
471     /**
472      * 检索任意地址的代币余额。
473      */
474     function balanceOf(address _customerAddress)
475         view
476         public
477         returns(uint256)
478     {
479         return tokenBalanceLedger_[_customerAddress];
480     }
481     
482     /**
483      * 检索任意地址的股息余额。
484      */
485     function dividendsOf(address _customerAddress)
486         view
487         public
488         returns(uint256)
489     {
490         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
491     }
492     
493     /**
494      * 返回代币买入的价格。
495      */
496     function sellPrice() 
497         public 
498         view 
499         returns(uint256)
500     {
501         // 我们的计算依赖于代币供应，所以我们需要知道供应量。
502         if(tokenSupply_ == 0){
503             return tokenPriceInitial_ - tokenPriceIncremental_;
504         } else {
505             uint256 _ethereum = tokensToEthereum_(1e18);
506             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
507             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
508             return _taxedEthereum;
509         }
510     }
511     
512     /**
513      * 返回代币卖出的价格。
514      */
515     function buyPrice() 
516         public 
517         view 
518         returns(uint256)
519     {
520         // 我们的计算依赖于代币供应，所以我们需要知道供应量。
521         if(tokenSupply_ == 0){
522             return tokenPriceInitial_ + tokenPriceIncremental_;
523         } else {
524             uint256 _ethereum = tokensToEthereum_(1e18);
525             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
526             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
527             return _taxedEthereum;
528         }
529     }
530     
531     /**
532      * 前端功能，动态获取买入订单价格。
533      */
534     function calculateTokensReceived(uint256 _ethereumToSpend) 
535         public 
536         view 
537         returns(uint256)
538     {
539         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
541         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
542         
543         return _amountOfTokens;
544     }
545     
546     /**
547      * 前端功能，动态获取卖出订单价格。
548      */
549     function calculateEthereumReceived(uint256 _tokensToSell) 
550         public 
551         view 
552         returns(uint256)
553     {
554         require(_tokensToSell <= tokenSupply_);
555         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
556         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
557         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
558         return _taxedEthereum;
559     }
560     
561     
562     /*==========================================
563     =            INTERNAL FUNCTIONS  内部函数   =
564     ==========================================*/
565     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
566         antiEarlyWhale(_incomingEthereum)
567         internal
568         returns(uint256)
569     {
570         // 数据设置
571         address _customerAddress = msg.sender;
572         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
573         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
574         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
575         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
576         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
577         uint256 _fee = _dividends * magnitude;
578  
579         // 禁止恶意执行
580         // 防止溢出
581         // (防止黑客入侵)
582         // 定义SAFEMATH保证数据安全。
583         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
584         
585         // 用户是否被主节点引用？
586         if(
587             // 是否有推荐者？
588             _referredBy != 0x0000000000000000000000000000000000000000 &&
589 
590             // 禁止作弊!
591             _referredBy != _customerAddress && // 不能自己推荐自己
592             
593             // 推荐人是否有足够的代币？
594             // 确保推荐人是诚实的主节点
595             tokenBalanceLedger_[_referredBy] >= stakingRequirement
596         ){
597             // 财富再分配
598             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
599         } else {
600             // 无需购买
601             // 添加推荐奖励到全局分红
602             _dividends = SafeMath.add(_dividends, _referralBonus); // 把推荐奖励还给分红
603             _fee = _dividends * magnitude;
604         }
605         
606         // 我们不能给予无尽的以太坊
607         if(tokenSupply_ > 0){
608             
609             // 添加代币到代币池
610             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
611  
612             // 获取这笔交易所获得的股息，并将平均分配给所有股东
613             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
614             
615             // 计算用户通过购买获得的代币数量。 
616             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
617         
618         } else {
619             // 添加代币到代币池
620             tokenSupply_ = _amountOfTokens;
621         }
622         
623         // 更新代币供应总量及用户地址
624         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
625         
626         // 告诉买卖双方在拥有代币前不会获得分红；
627         // 我知道你认为你做了，但是你没有做。
628         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
629         payoutsTo_[_customerAddress] += _updatedPayouts;
630         
631         // 重大事件
632         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
633         
634         return _amountOfTokens;
635     }
636 
637     /**
638      * 通过以太坊传入数量计算代币价格；
639      * 这是一个算法，在白皮书中能找到它的科学算法；
640      * 做了一些修改，以防止十进制错误和代码的上下溢出。
641      */
642     function ethereumToTokens_(uint256 _ethereum) // 计算ETH兑换代币的汇率
643         internal
644         view
645         returns(uint256)
646     {
647         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
648         uint256 _tokensReceived = 
649          (
650             (
651                 // 向下溢出尝试
652                 SafeMath.sub(
653                     (sqrt
654                         (
655                             (_tokenPriceInitial**2)
656                             +
657                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
658                             +
659                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
660                             +
661                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
662                         )
663                     ), _tokenPriceInitial
664                 )
665             )/(tokenPriceIncremental_)
666         )-(tokenSupply_)
667         ;
668   
669         return _tokensReceived;
670     }
671     
672     /**
673      * 计算代币出售的价格。
674      * 这是一个算法，在白皮书中能找到它的科学算法；
675      * 做了一些修改，以防止十进制错误和代码的上下溢出。
676      */
677      function tokensToEthereum_(uint256 _tokens)
678         internal
679         view
680         returns(uint256)
681     {
682 
683         uint256 tokens_ = (_tokens + 1e18);
684         uint256 _tokenSupply = (tokenSupply_ + 1e18);
685         uint256 _etherReceived =
686         (
687             // underflow attempts BTFO
688             SafeMath.sub(
689                 (
690                     (
691                         (
692                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
693                         )-tokenPriceIncremental_
694                     )*(tokens_ - 1e18)
695                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
696             )
697         /1e18);
698         return _etherReceived;
699     }
700     
701     
702     //这里会消耗Gas
703     //你大概会多消耗1gwei
704     function sqrt(uint x) internal pure returns (uint y) {
705         uint z = (x + 1) / 2;
706         y = x;
707         while (z < y) {
708             y = z;
709             z = (x / z + z) / 2;
710         }
711     }
712 }
713 
714 /**
715  * @title SafeMath函数
716  * @dev 安全的数学运算
717  */
718 library SafeMath {
719 
720     /**
721     * @dev 两个数字乘法，抛出溢出。
722     */
723     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
724         if (a == 0) {
725             return 0;
726         }
727         uint256 c = a * b;
728         assert(c / a == b);
729         return c;
730     }
731 
732     /**
733     * @dev 两个数字的整数除法。
734     */
735     function div(uint256 a, uint256 b) internal pure returns (uint256) {
736         // assert(b > 0); // 值为0时自动抛出
737         uint256 c = a / b;
738         // assert(a == b * c + a % b); // 否则不成立
739         return c;
740     }
741 
742     /**
743     * @dev 两个数字的减法，如果减数大于被减数，则溢出抛出。
744     */
745     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
746         assert(b <= a);
747         return a - b;
748     }
749 
750     /**
751     * @dev 两个数字的加法，向上溢出抛出
752     */
753     function add(uint256 a, uint256 b) internal pure returns (uint256) {
754         uint256 c = a + b;
755         assert(c >= a);
756         return c;
757     }
758 }