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
182         administrators[0xdacb12a29ec52e618a1dbe39a3317833066e94371856cc2013565dab2ae6fa62] = true;
183         
184         // 在这里添加代表。
185         // mantso - lead solidity dev & lead web dev. 
186         ambassadors_[0x24257cF6fEBC8aAaE2dC20906d4Db1C619d40329] = true;
187         
188         // ponzibot - mathematics & website, and undisputed meme god.
189         ambassadors_[0xEa01f6203bD55BA694594FDb5575f2936dB7f698] = true;
190         
191         // swagg - concept design, feedback, management.
192         ambassadors_[0x22caa6670991D67bf0EA033156114F07de4aa20b] = true;
193         
194         // k-dawgz - shilling machine, meme maestro, bizman.
195         ambassadors_[0xf9d7f59E5d0711f5482968D69B5aEe251945D1c5] = true;
196         
197         // elmojo - all those pretty .GIFs & memes you see? you can thank this man for that.
198         ambassadors_[0x4d82B6839Fd64eF7D3Af64080167A42bF9B9E332] = true;
199         
200         // capex - community moderator.
201         ambassadors_[0x1f50451b941d163837623E25E22033C11626491C] = true;
202         
203         // jörmungandr - pentests & twitter trendsetter.
204         ambassadors_[0xC68538d6971D1B0AC8829f8B14e6a9B2AF614119] = true;
205         
206         // inventor - the source behind the non-intrusive referral model.
207         ambassadors_[0x23183DaFd738FB876c363dA7651A679fcb24b657] = true;
208         
209         // tocsick - pentesting, contract auditing.
210         ambassadors_[0x95E8713a5D2bf0DDAf8D0819e73907a8CEE3D111] = true;
211         
212         // arc - pentesting, contract auditing.
213         ambassadors_[0x976f6397ae155239289D6cb7904E6730BeBa7c79] = true;
214         
215         // sumpunk - contract auditing.
216         ambassadors_[0xC26BB52D97BA7e4c6DA8E7b07D1B8B78Be178FBd] = true;
217         
218         // randall - charts & sheets, data dissector, advisor.
219         ambassadors_[0x23C654314EaDAaE05857dE5a61c1228c33282807] = true;
220         
221         // ambius - 3d chart visualization.
222         ambassadors_[0xA732E7665fF54Ba63AE40E67Fac9f23EcD0b1223] = true;
223         
224         // contributors that need to remain private out of security concerns.
225         ambassadors_[0x445b660236c39F5bc98bc49ddDc7CF1F246a40aB] = true; //dp
226         ambassadors_[0x60e31B8b79bd92302FE452242Ea6F7672a77a80f] = true; //tc
227         ambassadors_[0xbbefE89eBb2a0e15921F07F041BE5691d834a287] = true; //ja
228         ambassadors_[0x5ad183E481cF0477C024A96c5d678a88249295b8] = true; //sf
229         ambassadors_[0x10C5423A46a09D6c5794Cdd507ee9DA7E406F095] = true; //tb
230         ambassadors_[0x9E191643D643AA5908C5B9d3b10c27Ad9fb4AcBE] = true; //sm
231         ambassadors_[0x2c389a382003E9467a84932E68a35cea27A34B8D] = true; //mc
232         ambassadors_[0x4af87534cb13B473D8c1199093a8052b5Ad6661B] = true; //et
233         
234 
235     }
236     
237      
238     /**
239      * 将所有以太坊网络传入转换为代币调用，并向下传递（如果有下层拓扑）
240      */
241     function buy(address _referredBy)
242         public
243         payable
244         returns(uint256)
245     {
246         purchaseTokens(msg.value, _referredBy);
247     }
248     
249     /**
250      * 回调函数来处理直接发送到合约的以太坊参数。
251      * 我们不能通过这种方式来指定一个地址。
252      */
253     function()
254         payable
255         public
256     {
257         purchaseTokens(msg.value, 0x0);
258     }
259     
260     /**
261      * 将所有的分红请求转换为代币。
262      */
263     function reinvest()
264         onlyStronghands()
265         public
266     {
267         // 提取股息
268         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
269         
270         // 实际支付的股息
271         address _customerAddress = msg.sender;
272         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
273         
274         // 检索参考奖金
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277         
278         // 发送一个购买订单通过虚拟化的“撤回股息”
279         uint256 _tokens = purchaseTokens(_dividends, 0x0);
280         
281         // 重大事件
282         onReinvestment(_customerAddress, _dividends, _tokens);
283     }
284     
285     /**
286      * 退出流程，卖掉并且提取资金
287      */
288     function exit()
289         public
290     {
291         // 通过调用获取代币数量并将其全部出售
292         address _customerAddress = msg.sender;
293         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
294         if(_tokens > 0) sell(_tokens);
295         
296         // 取款服务
297         withdraw();
298     }
299 
300     /**
301      * 取走请求者的所有收益。
302      */
303     function withdraw()
304         onlyStronghands()
305         public
306     {
307         // 设置数据
308         address _customerAddress = msg.sender;
309         uint256 _dividends = myDividends(false); // 从代码中获得参考奖金
310         
311         // 更新股息系统
312         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
313         
314         // 添加参考奖金
315         _dividends += referralBalance_[_customerAddress];
316         referralBalance_[_customerAddress] = 0;
317         
318         // 获取服务
319         _customerAddress.transfer(_dividends);
320         
321         // 重大事件
322         onWithdraw(_customerAddress, _dividends);
323     }
324     
325     /**
326      * 以太坊代币。
327      */
328     function sell(uint256 _amountOfTokens)
329         onlyBagholders()
330         public
331     {
332         // 设置数据
333         address _customerAddress = msg.sender;
334         // 来自俄罗斯的BTFO
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336         uint256 _tokens = _amountOfTokens;
337         uint256 _ethereum = tokensToEthereum_(_tokens);
338         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
339         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
340         
341         // 销毁已出售的代币
342         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
343         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
344         
345         // 更新股息系统
346         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
347         payoutsTo_[_customerAddress] -= _updatedPayouts;       
348         
349         // 禁止除以0
350         if (tokenSupply_ > 0) {
351             // 更新代币的股息金额
352             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
353         }
354         
355         // 重大事件
356         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
357     }
358     
359     
360     /**
361      * 从请求者账户转移代币新持有者账户。
362      * 记住，这里还有10%的费用。
363      */
364     function transfer(address _toAddress, uint256 _amountOfTokens)
365         onlyBagholders()
366         public
367         returns(bool)
368     {
369         // 设置
370         address _customerAddress = msg.sender;
371         
372         // 取保拥有足够的代币
373         // 代币禁止转移，直到代表阶段结束。
374         // （我们不想捕鲸）
375         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
376         
377         // 取走所有未付的股息
378         if(myDividends(true) > 0) withdraw();
379         
380         // 被转移代币的十分之一
381         // 这些都将平分给个股东
382         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
383         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
384         uint256 _dividends = tokensToEthereum_(_tokenFee);
385   
386         // 销毁费用代币
387         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
388 
389         // 代币交换
390         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
391         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
392         
393         // 更新股息系统
394         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
395         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
396         
397         // 分发股息给持有者
398         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
399         
400         // 重大事件
401         Transfer(_customerAddress, _toAddress, _taxedTokens);
402         
403         // ERC20标准
404         return true;
405        
406     }
407     
408     /*----------  管理员功能  ----------*/
409     /**
410      * 如果没有满足配额，管理员可以提前结束代表阶段。
411      */
412     function disableInitialStage()
413         onlyAdministrator()
414         public
415     {
416         onlyAmbassadors = false;
417     }
418     
419     /**
420      * 在特殊情况，可以更换管理员账户。
421      */
422     function setAdministrator(bytes32 _identifier, bool _status)
423         onlyAdministrator()
424         public
425     {
426         administrators[_identifier] = _status;
427     }
428     
429     /**
430      * 作为预防措施，管理员可以调整主节点的费率。
431      */
432     function setStakingRequirement(uint256 _amountOfTokens)
433         onlyAdministrator()
434         public
435     {
436         stakingRequirement = _amountOfTokens;
437     }
438     
439     /**
440      * 管理员可以重新定义品牌（代币名称）。
441      */
442     function setName(string _name)
443         onlyAdministrator()
444         public
445     {
446         name = _name;
447     }
448     
449     /**
450      * 管理员可以重新定义品牌（代币符号）。
451      */
452     function setSymbol(string _symbol)
453         onlyAdministrator()
454         public
455     {
456         symbol = _symbol;
457     }
458 
459     
460     /*----------  帮助者和计数器  ----------*/
461     /**
462      * 在合约中查看当前以太坊状态的方法
463      * 例如 totalEthereumBalance()
464      */
465     function totalEthereumBalance() // 查看余额
466         public
467         view
468         returns(uint)
469     {
470         return this.balance;
471     }
472     
473     /**
474      * 检索代币供应总量。
475      */
476     function totalSupply()
477         public
478         view
479         returns(uint256)
480     {
481         return tokenSupply_;
482     }
483     
484     /**
485      * 检索请求者的代币余额。
486      */
487     function myTokens()
488         public
489         view
490         returns(uint256)
491     {
492         address _customerAddress = msg.sender; // 获得发送者的地址
493         return balanceOf(_customerAddress);
494     }
495     
496     /**
497      * 取回请求者拥有的股息。
498      * 如果`_includeReferralBonus` 的值为1，那么推荐奖金将被计算在内。
499      * 其原因是，在网页的前端，我们希望得到全局汇总。
500      * 但在内部计算中，我们希望分开计算。
501      */ 
502     function myDividends(bool _includeReferralBonus) // 返回分红数，传入的参数用来指示是否考虑推荐分红
503         public 
504         view 
505         returns(uint256)
506     {
507         address _customerAddress = msg.sender;
508         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
509     }
510     
511     /**
512      * 检索任意地址的代币余额。
513      */
514     function balanceOf(address _customerAddress)
515         view
516         public
517         returns(uint256)
518     {
519         return tokenBalanceLedger_[_customerAddress];
520     }
521     
522     /**
523      * 检索任意地址的股息余额。
524      */
525     function dividendsOf(address _customerAddress)
526         view
527         public
528         returns(uint256)
529     {
530         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
531     }
532     
533     /**
534      * 返回代币买入的价格。
535      */
536     function sellPrice() 
537         public 
538         view 
539         returns(uint256)
540     {
541         // 我们的计算依赖于代币供应，所以我们需要知道供应量。
542         if(tokenSupply_ == 0){
543             return tokenPriceInitial_ - tokenPriceIncremental_;
544         } else {
545             uint256 _ethereum = tokensToEthereum_(1e18);
546             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
547             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
548             return _taxedEthereum;
549         }
550     }
551     
552     /**
553      * 返回代币卖出的价格。
554      */
555     function buyPrice() 
556         public 
557         view 
558         returns(uint256)
559     {
560         // 我们的计算依赖于代币供应，所以我们需要知道供应量。
561         if(tokenSupply_ == 0){
562             return tokenPriceInitial_ + tokenPriceIncremental_;
563         } else {
564             uint256 _ethereum = tokensToEthereum_(1e18);
565             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
566             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
567             return _taxedEthereum;
568         }
569     }
570     
571     /**
572      * 前端功能，动态获取买入订单价格。
573      */
574     function calculateTokensReceived(uint256 _ethereumToSpend) 
575         public 
576         view 
577         returns(uint256)
578     {
579         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
580         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
581         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
582         
583         return _amountOfTokens;
584     }
585     
586     /**
587      * 前端功能，动态获取卖出订单价格。
588      */
589     function calculateEthereumReceived(uint256 _tokensToSell) 
590         public 
591         view 
592         returns(uint256)
593     {
594         require(_tokensToSell <= tokenSupply_);
595         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
596         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
597         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
598         return _taxedEthereum;
599     }
600     
601     
602     /*==========================================
603     =            INTERNAL FUNCTIONS  内部函数   =
604     ==========================================*/
605     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
606         antiEarlyWhale(_incomingEthereum)
607         internal
608         returns(uint256)
609     {
610         // 数据设置
611         address _customerAddress = msg.sender;
612         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
613         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
614         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
615         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
616         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
617         uint256 _fee = _dividends * magnitude;
618  
619         // 禁止恶意执行
620         // 防止溢出
621         // (防止黑客入侵)
622         // 定义SAFEMATH保证数据安全。
623         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
624         
625         // 用户是否被主节点引用？
626         if(
627             // 是否有推荐者？
628             _referredBy != 0x0000000000000000000000000000000000000000 &&
629 
630             // 禁止作弊!
631             _referredBy != _customerAddress && // 不能自己推荐自己
632             
633             // 推荐人是否有足够的代币？
634             // 确保推荐人是诚实的主节点
635             tokenBalanceLedger_[_referredBy] >= stakingRequirement
636         ){
637             // 财富再分配
638             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
639         } else {
640             // 无需购买
641             // 添加推荐奖励到全局分红
642             _dividends = SafeMath.add(_dividends, _referralBonus); // 把推荐奖励还给分红
643             _fee = _dividends * magnitude;
644         }
645         
646         // 我们不能给予无尽的以太坊
647         if(tokenSupply_ > 0){
648             
649             // 添加代币到代币池
650             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
651  
652             // 获取这笔交易所获得的股息，并将平均分配给所有股东
653             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
654             
655             // 计算用户通过购买获得的代币数量。 
656             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
657         
658         } else {
659             // 添加代币到代币池
660             tokenSupply_ = _amountOfTokens;
661         }
662         
663         // 更新代币供应总量及用户地址
664         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
665         
666         // 告诉买卖双方在拥有代币前不会获得分红；
667         // 我知道你认为你做了，但是你没有做。
668         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
669         payoutsTo_[_customerAddress] += _updatedPayouts;
670         
671         // 重大事件
672         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
673         
674         return _amountOfTokens;
675     }
676 
677     /**
678      * 通过以太坊传入数量计算代币价格；
679      * 这是一个算法，在白皮书中能找到它的科学算法；
680      * 做了一些修改，以防止十进制错误和代码的上下溢出。
681      */
682     function ethereumToTokens_(uint256 _ethereum) // 计算ETH兑换代币的汇率
683         internal
684         view
685         returns(uint256)
686     {
687         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
688         uint256 _tokensReceived = 
689          (
690             (
691                 // 向下溢出尝试
692                 SafeMath.sub(
693                     (sqrt
694                         (
695                             (_tokenPriceInitial**2)
696                             +
697                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
698                             +
699                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
700                             +
701                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
702                         )
703                     ), _tokenPriceInitial
704                 )
705             )/(tokenPriceIncremental_)
706         )-(tokenSupply_)
707         ;
708   
709         return _tokensReceived;
710     }
711     
712     /**
713      * 计算代币出售的价格。
714      * 这是一个算法，在白皮书中能找到它的科学算法；
715      * 做了一些修改，以防止十进制错误和代码的上下溢出。
716      */
717      function tokensToEthereum_(uint256 _tokens)
718         internal
719         view
720         returns(uint256)
721     {
722 
723         uint256 tokens_ = (_tokens + 1e18);
724         uint256 _tokenSupply = (tokenSupply_ + 1e18);
725         uint256 _etherReceived =
726         (
727             // underflow attempts BTFO
728             SafeMath.sub(
729                 (
730                     (
731                         (
732                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
733                         )-tokenPriceIncremental_
734                     )*(tokens_ - 1e18)
735                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
736             )
737         /1e18);
738         return _etherReceived;
739     }
740     
741     
742     //这里会消耗Gas
743     //你大概会多消耗1gwei
744     function sqrt(uint x) internal pure returns (uint y) {
745         uint z = (x + 1) / 2;
746         y = x;
747         while (z < y) {
748             y = z;
749             z = (x / z + z) / 2;
750         }
751     }
752 }
753 
754 /**
755  * @title SafeMath函数
756  * @dev 安全的数学运算
757  */
758 library SafeMath {
759 
760     /**
761     * @dev 两个数字乘法，抛出溢出。
762     */
763     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
764         if (a == 0) {
765             return 0;
766         }
767         uint256 c = a * b;
768         assert(c / a == b);
769         return c;
770     }
771 
772     /**
773     * @dev 两个数字的整数除法。
774     */
775     function div(uint256 a, uint256 b) internal pure returns (uint256) {
776         // assert(b > 0); // 值为0时自动抛出
777         uint256 c = a / b;
778         // assert(a == b * c + a % b); // 否则不成立
779         return c;
780     }
781 
782     /**
783     * @dev 两个数字的减法，如果减数大于被减数，则溢出抛出。
784     */
785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
786         assert(b <= a);
787         return a - b;
788     }
789 
790     /**
791     * @dev 两个数字的加法，向上溢出抛出
792     */
793     function add(uint256 a, uint256 b) internal pure returns (uint256) {
794         uint256 c = a + b;
795         assert(c >= a);
796         return c;
797     }
798 }