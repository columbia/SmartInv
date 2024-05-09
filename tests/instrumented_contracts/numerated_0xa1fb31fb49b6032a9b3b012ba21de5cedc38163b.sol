1 pragma solidity ^0.4.21;
2 
3 interface Token {
4     function totalSupply() constant external returns (uint256 ts);
5     function balanceOf(address _owner) constant external returns (uint256 balance);
6     function transfer(address _to, uint256 _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 interface XPAAssetToken {
16     function create(address user_, uint256 amount_) external returns(bool success);
17     function burn(uint256 amount_) external returns(bool success);
18     function burnFrom(address user_, uint256 amount_) external returns(bool success);
19     function getDefaultExchangeRate() external returns(uint256);
20     function getSymbol() external returns(bytes32);
21 }
22 
23 interface Baliv {
24     function getPrice(address fromToken_, address toToken_) external view returns(uint256);
25 }
26 
27 interface FundAccount {
28     function burn(address Token_, uint256 Amount_) external view returns(bool);
29 }
30 
31 interface TokenFactory {
32     function createToken(string symbol_, string name_, uint256 defaultExchangeRate_) external returns(address);
33     function getPrice(address token_) external view returns(uint256);
34     function getAssetLength() external view returns(uint256);
35     function getAssetToken(uint256 index_) external view returns(address);
36 }
37 
38 contract SafeMath {
39     function safeAdd(uint x, uint y)
40         internal
41         pure
42     returns(uint) {
43         uint256 z = x + y;
44         require((z >= x) && (z >= y));
45         return z;
46     }
47 
48     function safeSub(uint x, uint y)
49         internal
50         pure
51     returns(uint) {
52         require(x >= y);
53         uint256 z = x - y;
54         return z;
55     }
56 
57     function safeMul(uint x, uint y)
58         internal
59         pure
60     returns(uint) {
61         uint z = x * y;
62         require((x == 0) || (z / x == y));
63         return z;
64     }
65     
66     function safeDiv(uint x, uint y)
67         internal
68         pure
69     returns(uint) {
70         require(y > 0);
71         return x / y;
72     }
73 
74     function random(uint N, uint salt)
75         internal
76         view
77     returns(uint) {
78         bytes32 hash = keccak256(block.number, msg.sender, salt);
79         return uint(hash) % N;
80     }
81 }
82 
83 contract Authorization {
84     mapping(address => address) public agentBooks;
85     address public owner;
86     address public operator;
87     address public bank;
88     bool public powerStatus = true;
89     bool public forceOff = false;
90     function Authorization()
91         public
92     {
93         owner = msg.sender;
94         operator = msg.sender;
95         bank = msg.sender;
96     }
97     modifier onlyOwner
98     {
99         assert(msg.sender == owner);
100         _;
101     }
102     modifier onlyOperator
103     {
104         assert(msg.sender == operator || msg.sender == owner);
105         _;
106     }
107     modifier onlyActive
108     {
109         assert(powerStatus);
110         _;
111     }
112     function powerSwitch(
113         bool onOff_
114     )
115         public
116         onlyOperator
117     {
118         if(forceOff) {
119             powerStatus = false;
120         } else {
121             powerStatus = onOff_;
122         }
123     }
124     function transferOwnership(address newOwner_)
125         onlyOwner
126         public
127     {
128         owner = newOwner_;
129     }
130     
131     function assignOperator(address user_)
132         public
133         onlyOwner
134     {
135         operator = user_;
136         agentBooks[bank] = user_;
137     }
138     
139     function assignBank(address bank_)
140         public
141         onlyOwner
142     {
143         bank = bank_;
144     }
145     function assignAgent(
146         address agent_
147     )
148         public
149     {
150         agentBooks[msg.sender] = agent_;
151     }
152     function isRepresentor(
153         address representor_
154     )
155         public
156         view
157     returns(bool) {
158         return agentBooks[representor_] == msg.sender;
159     }
160     function getUser(
161         address representor_
162     )
163         internal
164         view
165     returns(address) {
166         return isRepresentor(representor_) ? representor_ : msg.sender;
167     }
168 }
169 
170 contract XPAAssets is SafeMath, Authorization {
171     string public version = "0.5.0";
172 
173     // contracts
174     address public XPA = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
175     address public oldXPAAssets = 0x00D0F7d665996B745b2399a127D5d84DAcd42D251f;
176     address public newXPAAssets = address(0);
177     address public tokenFactory = 0x001393F1fb2E243Ee68Efe172eBb6831772633A926;
178     // setting
179     uint256 public maxForceOffsetAmount = 1000000 ether;
180     uint256 public minForceOffsetAmount = 10000 ether;
181     
182     // events
183     event eMortgage(address, uint256);
184     event eWithdraw(address, address, uint256);
185     event eRepayment(address, address, uint256);
186     event eOffset(address, address, uint256);
187     event eExecuteOffset(uint256, address, uint256);
188     event eMigrate(address);
189     event eMigrateAmount(address);
190 
191     //data
192     mapping(address => uint256) public fromAmountBooks;
193     mapping(address => mapping(address => uint256)) public toAmountBooks;
194     mapping(address => uint256) public forceOffsetBooks;
195     mapping(address => bool) public migrateBooks;
196     address[] public xpaAsset;
197     address public fundAccount;
198     uint256 public profit = 0;
199     mapping(address => uint256) public unPaidFundAccount;
200     uint256 public initCanOffsetTime = 0;
201     
202     //fee
203     uint256 public withdrawFeeRate = 0.02 ether; // 提領手續費
204     uint256 public offsetFeeRate = 0.02 ether;   // 平倉手續費
205     uint256 public forceOffsetBasicFeeRate = 0.02 ether; // 強制平倉基本費
206     uint256 public forceOffsetExecuteFeeRate = 0.01 ether;// 強制平倉執行費
207     uint256 public forceOffsetExtraFeeRate = 0.05 ether; // 強制平倉額外手續費
208     uint256 public forceOffsetExecuteMaxFee = 1000 ether; 
209     
210     // constructor
211     function XPAAssets(
212         uint256 initCanOffsetTime_,
213         address XPAAddr,
214         address factoryAddr,
215         address oldXPAAssetsAddr
216     ) public {
217         initCanOffsetTime = initCanOffsetTime_;
218         XPA = XPAAddr;
219         tokenFactory = factoryAddr;
220         oldXPAAssets = oldXPAAssetsAddr;
221     }
222 
223     function setFundAccount(
224         address fundAccount_
225     )
226         public
227         onlyOperator
228     {
229         if(fundAccount_ != address(0)) {
230             fundAccount = fundAccount_;
231         }
232     }
233 
234     function createToken(
235         string symbol_,
236         string name_,
237         uint256 defaultExchangeRate_
238     )
239         public
240         onlyOperator 
241     {
242         address newAsset = TokenFactory(tokenFactory).createToken(symbol_, name_, defaultExchangeRate_);
243         for(uint256 i = 0; i < xpaAsset.length; i++) {
244             if(xpaAsset[i] == newAsset){
245                 return;
246             }
247         }
248         xpaAsset.push(newAsset);
249     }
250 
251     //抵押 XPA
252     function mortgage(
253         address representor_
254     )
255         onlyActive
256         public
257     {
258         address user = getUser(representor_);
259         uint256 amount_ = Token(XPA).allowance(msg.sender, this); // get mortgage amount
260         if(
261             amount_ >= 100 ether && 
262             Token(XPA).transferFrom(msg.sender, this, amount_) 
263         ){
264             fromAmountBooks[user] = safeAdd(fromAmountBooks[user], amount_); // update books
265             emit eMortgage(user,amount_); // wirte event
266         }
267     }
268     
269     // 借出 XPA Assets, amount: 指定借出金額
270     function withdraw(
271         address token_,
272         uint256 amount_,
273         address representor_
274     ) 
275         onlyActive 
276         public 
277     {
278         address user = getUser(representor_);
279         if(
280             token_ != XPA &&
281             amount_ > 0 &&
282             amount_ <= safeDiv(safeMul(safeDiv(safeMul(getUsableXPA(user), getPrice(token_)), 1 ether), getHighestMortgageRate()), 1 ether)
283         ){
284             toAmountBooks[user][token_] = safeAdd(toAmountBooks[user][token_],amount_);
285             uint256 withdrawFee = safeDiv(safeMul(amount_,withdrawFeeRate),1 ether); // calculate withdraw fee
286             XPAAssetToken(token_).create(user, safeSub(amount_, withdrawFee));
287             XPAAssetToken(token_).create(this, withdrawFee);
288             emit eWithdraw(user, token_, amount_); // write event
289         }
290     }
291     
292     // 領回 XPA, amount: 指定領回金額
293     function withdrawXPA(
294         uint256 amount_,
295         address representor_
296     )
297         onlyActive
298         public
299     {
300         address user = getUser(representor_);
301         if(
302             amount_ >= 100 ether && 
303             amount_ <= getUsableXPA(user)
304         ){
305             fromAmountBooks[user] = safeSub(fromAmountBooks[user], amount_);
306             require(Token(XPA).transfer(user, amount_));
307             emit eWithdraw(user, XPA, amount_); // write event
308         }    
309     }
310     
311     // 檢查額度是否足夠借出 XPA Assets
312     /*function checkWithdraw(
313         address token_,
314         uint256 amount_,
315         address user_
316     ) 
317         internal  
318         view
319     returns(bool) {
320         if(
321             token_ != XPA && 
322             amount_ <= safeDiv(safeMul(safeDiv(safeMul(getUsableXPA(user_), getPrice(token_)), 1 ether), getHighestMortgageRate()), 1 ether)
323         ){
324             return true;
325         }else if(
326             token_ == XPA && 
327             amount_ <= getUsableXPA(user_)
328         ){
329             return true;
330         }else{
331             return false;
332         }
333     }*/
334 
335     // 還款 XPA Assets, amount: 指定還回金額
336     function repayment(
337         address token_,
338         uint256 amount_,
339         address representor_
340     )
341         onlyActive 
342         public
343     {
344         address user = getUser(representor_);
345         if(
346             XPAAssetToken(token_).burnFrom(user, amount_)
347         ) {
348             toAmountBooks[user][token_] = safeSub(toAmountBooks[user][token_],amount_);
349             emit eRepayment(user, token_, amount_);
350         }
351     }
352     
353     // 平倉 / 強行平倉, user: 指定平倉對象
354     function offset(
355         address user_,
356         address token_
357     )
358         onlyActive
359         public
360     {
361         uint256 userFromAmount = fromAmountBooks[user_] >= maxForceOffsetAmount ? maxForceOffsetAmount : fromAmountBooks[user_];
362         require(block.timestamp > initCanOffsetTime);
363         require(userFromAmount > 0);
364         address user = getUser(user_);
365 
366         if(
367             user_ == user &&
368             getLoanAmount(user, token_) > 0
369         ){
370             emit eOffset(user, user_, userFromAmount);
371             uint256 remainingXPA = executeOffset(user_, userFromAmount, token_, offsetFeeRate);
372             if(remainingXPA > 0){
373                 require(Token(XPA).transfer(fundAccount, safeDiv(safeMul(safeSub(userFromAmount, remainingXPA), 1 ether), safeAdd(1 ether, offsetFeeRate)))); //轉帳至平倉基金
374             } else {
375                 require(Token(XPA).transfer(fundAccount, safeDiv(safeMul(safeSub(userFromAmount, remainingXPA), safeSub(1 ether, offsetFeeRate)), 1 ether))); //轉帳至平倉基金
376             }
377             
378             fromAmountBooks[user_] = safeSub(fromAmountBooks[user_], safeSub(userFromAmount, remainingXPA));
379         }else if(
380             user_ != user && 
381             block.timestamp > (forceOffsetBooks[user_] + 28800) &&
382             getMortgageRate(user_) >= getClosingLine()
383         ){
384             forceOffsetBooks[user_] = block.timestamp;
385                 
386             uint256 punishXPA = getPunishXPA(user_); //get 10% xpa
387             emit eOffset(user, user_, punishXPA);
388 
389             uint256[3] memory forceOffsetFee;
390             forceOffsetFee[0] = safeDiv(safeMul(punishXPA, forceOffsetBasicFeeRate), 1 ether); //基本手續費(收益)
391             forceOffsetFee[1] = safeDiv(safeMul(punishXPA, forceOffsetExtraFeeRate), 1 ether); //額外手續費(平倉基金)
392             forceOffsetFee[2] = safeDiv(safeMul(punishXPA, forceOffsetExecuteFeeRate), 1 ether);//執行手續費(執行者)
393             forceOffsetFee[2] = forceOffsetFee[2] > forceOffsetExecuteMaxFee ? forceOffsetExecuteMaxFee : forceOffsetFee[2];
394 
395             profit = safeAdd(profit, forceOffsetFee[0]);
396             uint256 allFee = safeAdd(forceOffsetFee[2],safeAdd(forceOffsetFee[0], forceOffsetFee[1]));
397             remainingXPA = safeSub(punishXPA,allFee);
398 
399             for(uint256 i = 0; i < xpaAsset.length; i++) {
400                 if(getLoanAmount(user_, xpaAsset[i]) > 0){
401                     remainingXPA = executeOffset(user_, remainingXPA, xpaAsset[i],0);
402                     if(remainingXPA == 0){
403                         break;
404                     }
405                 }
406             }
407                 
408             fromAmountBooks[user_] = safeSub(fromAmountBooks[user_], safeSub(punishXPA, remainingXPA));
409             require(Token(XPA).transfer(fundAccount, safeAdd(forceOffsetFee[1],safeSub(safeSub(punishXPA, allFee), remainingXPA)))); //轉帳至平倉基金
410             require(Token(XPA).transfer(msg.sender, forceOffsetFee[2])); //執行手續費轉給執行者
411         }
412     }
413     
414     function executeOffset(
415         address user_,
416         uint256 xpaAmount_,
417         address xpaAssetToken,
418         uint256 feeRate
419     )
420         internal
421     returns(uint256){
422         uint256 fromXPAAsset = safeDiv(safeMul(xpaAmount_,getPrice(xpaAssetToken)),1 ether);
423         uint256 userToAmount = toAmountBooks[user_][xpaAssetToken];
424         uint256 fee = safeDiv(safeMul(userToAmount, feeRate), 1 ether);
425         uint256 burnXPA;
426         uint256 burnXPAAsset;
427         if(fromXPAAsset >= safeAdd(userToAmount, fee)){
428             burnXPA = safeDiv(safeMul(safeAdd(userToAmount, fee), 1 ether), getPrice(xpaAssetToken));
429             emit eExecuteOffset(burnXPA, xpaAssetToken, safeAdd(userToAmount, fee));
430             xpaAmount_ = safeSub(xpaAmount_, burnXPA);
431             toAmountBooks[user_][xpaAssetToken] = 0;
432             profit = safeAdd(profit, safeDiv(safeMul(fee,1 ether), getPrice(xpaAssetToken)));
433             if(
434                 !FundAccount(fundAccount).burn(xpaAssetToken, userToAmount)
435             ){
436                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken],userToAmount);
437             }
438 
439         }else{
440             
441             fee = safeDiv(safeMul(xpaAmount_, feeRate), 1 ether);
442             profit = safeAdd(profit, fee);
443             burnXPAAsset = safeDiv(safeMul(safeSub(xpaAmount_, fee),getPrice(xpaAssetToken)),1 ether);
444             toAmountBooks[user_][xpaAssetToken] = safeSub(userToAmount, burnXPAAsset);
445             emit eExecuteOffset(xpaAmount_, xpaAssetToken, burnXPAAsset);
446             
447             xpaAmount_ = 0;
448             if(
449                 !FundAccount(fundAccount).burn(xpaAssetToken, burnXPAAsset)
450             ){
451                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken], burnXPAAsset);
452             }
453             
454         }
455         return xpaAmount_;
456     }
457     
458     function getPunishXPA(
459         address user_
460     )
461         internal
462         view 
463     returns(uint256){
464         uint256 userFromAmount = fromAmountBooks[user_];
465         uint256 punishXPA = safeDiv(safeMul(userFromAmount, 0.1 ether),1 ether);
466         if(userFromAmount <= safeAdd(minForceOffsetAmount, 100 ether)){
467             return userFromAmount;
468         }else if(punishXPA < minForceOffsetAmount){
469             return minForceOffsetAmount;
470         }else if(punishXPA > maxForceOffsetAmount){
471             return maxForceOffsetAmount;
472         }else{
473             return punishXPA;
474         }
475     }
476     
477     // 取得用戶抵押率, user: 指定用戶
478     function getMortgageRate(
479         address user_
480     ) 
481         public
482         view 
483     returns(uint256){
484         if(fromAmountBooks[user_] != 0){
485             uint256 totalLoanXPA = 0;
486             for(uint256 i = 0; i < xpaAsset.length; i++) {
487                 totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
488             }
489             return safeDiv(safeMul(totalLoanXPA,1 ether),fromAmountBooks[user_]);
490         }else{
491             return 0;
492         }
493     }
494         
495     // 取得最高抵押率
496     function getHighestMortgageRate() 
497         public
498         view 
499     returns(uint256){
500         uint256 totalXPA = Token(XPA).totalSupply();
501         uint256 issueRate = safeDiv(safeMul(Token(XPA).balanceOf(this), 1 ether), totalXPA);
502         if(issueRate >= 0.7 ether){
503             return 0.7 ether;
504         }else if(issueRate >= 0.6 ether){
505             return 0.6 ether;
506         }else if(issueRate >= 0.5 ether){
507             return 0.5 ether;
508         }else if(issueRate >= 0.3 ether){
509             return 0.3 ether;
510         }else{
511             return 0.1 ether;
512         }
513     }
514     
515     // 取得平倉線
516     function getClosingLine() 
517         public
518         view
519     returns(uint256){
520         uint256 highestMortgageRate = getHighestMortgageRate();
521         if(highestMortgageRate >= 0.6 ether){
522             return safeAdd(highestMortgageRate, 0.1 ether);
523         }else{
524             return 0.6 ether;
525         }
526     }
527     
528     // 取得 XPA Assets 匯率 
529     function getPrice(
530         address token_
531     ) 
532         public
533         view
534     returns(uint256){
535         return TokenFactory(tokenFactory).getPrice(token_);
536     }
537     
538     // 取得用戶可提領的XPA(扣掉最高抵押率後的XPA)
539     function getUsableXPA(
540         address user_
541     )
542         public
543         view
544     returns(uint256) {
545         uint256 totalLoanXPA = 0;
546         for(uint256 i = 0; i < xpaAsset.length; i++) {
547             totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
548         }
549         if(fromAmountBooks[user_] > safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate())){
550             return safeSub(fromAmountBooks[user_], safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate()));
551         }else{
552             return 0;
553         }
554     }
555     
556     // 取得用戶可借貸 XPA Assets 最大額度, user: 指定用戶
557     /*function getUsableAmount(
558         address user_,
559         address token_
560     ) 
561         public
562         view
563     returns(uint256) {
564         uint256 amount = safeDiv(safeMul(fromAmountBooks[user_], getPrice(token_)), 1 ether);
565         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
566     }*/
567     
568     // 取得用戶已借貸 XPA Assets 數量, user: 指定用戶
569     function getLoanAmount(
570         address user_,
571         address token_
572     ) 
573         public
574         view
575     returns(uint256) {
576         return toAmountBooks[user_][token_];
577     }
578     
579     // 取得用戶剩餘可借貸 XPA Assets 額度, user: 指定用戶
580     function getRemainingAmount(
581         address user_,
582         address token_
583     ) 
584         public
585         view
586     returns(uint256) {
587         uint256 amount = safeDiv(safeMul(getUsableXPA(user_), getPrice(token_)), 1 ether);
588         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
589     }
590     
591     function burnFundAccount(
592         address token_,
593         uint256 amount_
594     )
595         onlyOperator
596         public
597     {
598         if(
599             FundAccount(fundAccount).burn(token_, amount_)
600         ){
601             unPaidFundAccount[token_] = safeSub(unPaidFundAccount[token_], amount_);
602         }
603     }
604 
605     function transferProfit(
606         address token_,
607         uint256 amount_
608     )
609         onlyOperator 
610         public
611     {
612         require(amount_ > 0);
613         if(
614             XPA != token_ && 
615             Token(token_).balanceOf(this) >= amount_
616         ) {
617             require(Token(token_).transfer(bank, amount_));
618         }
619 
620         if(
621             XPA == token_ && 
622             Token(XPA).balanceOf(this) >= amount_
623         ) {
624             profit = safeSub(profit,amount_);
625             require(Token(token_).transfer(bank, amount_));
626         }
627 
628     }
629         
630     function setFeeRate(
631         uint256 withDrawFeerate_,
632         uint256 offsetFeerate_,
633         uint256 forceOffsetBasicFeerate_,
634         uint256 forceOffsetExecuteFeerate_,
635         uint256 forceOffsetExtraFeerate_,
636         uint256 forceOffsetExecuteMaxFee_
637     )
638         onlyOperator 
639         public
640     {
641         require(withDrawFeerate_ < 0.05 ether);
642         require(offsetFeerate_ < 0.05 ether);
643         require(forceOffsetBasicFeerate_ < 0.05 ether);
644         require(forceOffsetExecuteFeerate_ < 0.05 ether);
645         require(forceOffsetExtraFeerate_ < 0.05 ether);
646         withdrawFeeRate = withDrawFeerate_;
647         offsetFeeRate = offsetFeerate_;
648         forceOffsetBasicFeeRate = forceOffsetBasicFeerate_;
649         forceOffsetExecuteFeeRate = forceOffsetExecuteFeerate_;
650         forceOffsetExtraFeeRate = forceOffsetExtraFeerate_;
651         forceOffsetExecuteMaxFee = forceOffsetExecuteMaxFee_;
652     }
653     
654     function setForceOffsetAmount(
655         uint256 maxForceOffsetAmount_,
656         uint256 minForceOffsetAmount_
657     )
658         onlyOperator
659         public
660     {
661         maxForceOffsetAmount = maxForceOffsetAmount_;
662         minForceOffsetAmount = minForceOffsetAmount_;
663     }
664         
665     function migrate(
666         address newContract_
667     )
668         public
669         onlyOwner
670     {
671         require(newContract_ != address(0));
672         if(
673             newXPAAssets == address(0) &&
674             XPAAssets(newContract_).transferXPAAssetAndProfit(xpaAsset, profit) &&
675             Token(XPA).transfer(newContract_, Token(XPA).balanceOf(this))
676         ) {
677             forceOff = true;
678             powerStatus = false;
679             newXPAAssets = newContract_;
680             for(uint256 i = 0; i < xpaAsset.length; i++) {
681                 XPAAssets(newContract_).transferUnPaidFundAccount(xpaAsset[i], unPaidFundAccount[xpaAsset[i]]);
682             }
683             emit eMigrate(newContract_);
684         }
685     }
686     
687     function transferXPAAssetAndProfit(
688         address[] xpaAsset_,
689         uint256 profit_
690     )
691         public
692         onlyOperator
693     returns(bool) {
694         require(msg.sender == oldXPAAssets);
695         xpaAsset = xpaAsset_;
696         profit = profit_;
697         return true;
698     }
699     
700     function transferUnPaidFundAccount(
701         address xpaAsset_,
702         uint256 unPaidAmount_
703     )
704         public
705         onlyOperator
706     returns(bool) {
707         require(msg.sender == oldXPAAssets);
708         unPaidFundAccount[xpaAsset_] = unPaidAmount_;
709         return true;
710     }
711     
712     function migratingAmountBooks(
713         address user_,
714         address newContract_
715     )
716         public
717         onlyOperator
718     {
719         XPAAssets(newContract_).migrateAmountBooks(user_); 
720     }
721     
722     function migrateAmountBooks(
723         address user_
724     )
725         public
726         onlyOperator 
727     {
728         require(msg.sender == oldXPAAssets);
729         require(!migrateBooks[user_]);
730 
731         migrateBooks[user_] = true;
732         fromAmountBooks[user_] = safeAdd(fromAmountBooks[user_],XPAAssets(oldXPAAssets).getFromAmountBooks(user_));
733         forceOffsetBooks[user_] = XPAAssets(oldXPAAssets).getForceOffsetBooks(user_);
734         for(uint256 i = 0; i < xpaAsset.length; i++) {
735             toAmountBooks[user_][xpaAsset[i]] = safeAdd(toAmountBooks[user_][xpaAsset[i]], XPAAssets(oldXPAAssets).getLoanAmount(user_,xpaAsset[i]));
736         }
737         emit eMigrateAmount(user_);
738     }
739     
740     function getFromAmountBooks(
741         address user_
742     )
743         public
744         view 
745     returns(uint256) {
746         return fromAmountBooks[user_];
747     }
748     
749     function getForceOffsetBooks(
750         address user_
751     )
752         public 
753         view 
754     returns(uint256) {
755         return forceOffsetBooks[user_];
756     }
757 }