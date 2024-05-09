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
175     address public oldXPAAssets = 0x0002992af1dd8140193b87d2ab620ca22f6e19f26c;
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
372             
373             require(Token(XPA).transfer(fundAccount, safeDiv(safeMul(safeSub(userFromAmount, remainingXPA), 1 ether), safeAdd(1 ether, offsetFeeRate)))); //轉帳至平倉基金
374             fromAmountBooks[user_] = remainingXPA;
375         }else if(
376             user_ != user && 
377             block.timestamp > (forceOffsetBooks[user_] + 28800) &&
378             getMortgageRate(user_) >= getClosingLine()
379         ){
380             forceOffsetBooks[user_] = block.timestamp;
381                 
382             uint256 punishXPA = getPunishXPA(user_); //get 10% xpa
383             emit eOffset(user, user_, punishXPA);
384 
385             uint256[3] memory forceOffsetFee;
386             forceOffsetFee[0] = safeDiv(safeMul(punishXPA, forceOffsetBasicFeeRate), 1 ether); //基本手續費(收益)
387             forceOffsetFee[1] = safeDiv(safeMul(punishXPA, forceOffsetExtraFeeRate), 1 ether); //額外手續費(平倉基金)
388             forceOffsetFee[2] = safeDiv(safeMul(punishXPA, forceOffsetExecuteFeeRate), 1 ether);//執行手續費(執行者)
389             forceOffsetFee[2] = forceOffsetFee[2] > forceOffsetExecuteMaxFee ? forceOffsetExecuteMaxFee : forceOffsetFee[2];
390 
391             profit = safeAdd(profit, forceOffsetFee[0]);
392             uint256 allFee = safeAdd(forceOffsetFee[2],safeAdd(forceOffsetFee[0], forceOffsetFee[1]));
393             remainingXPA = safeSub(punishXPA,allFee);
394 
395             for(uint256 i = 0; i < xpaAsset.length; i++) {
396                 if(getLoanAmount(user_, xpaAsset[i]) > 0){
397                     remainingXPA = executeOffset(user_, remainingXPA, xpaAsset[i],0);
398                     if(remainingXPA == 0){
399                         break;
400                     }
401                 }
402             }
403                 
404             fromAmountBooks[user_] = safeSub(fromAmountBooks[user_], safeSub(punishXPA, remainingXPA));
405             require(Token(XPA).transfer(fundAccount, safeAdd(forceOffsetFee[1],safeSub(safeSub(punishXPA, allFee), remainingXPA)))); //轉帳至平倉基金
406             require(Token(XPA).transfer(msg.sender, forceOffsetFee[2])); //執行手續費轉給執行者
407         }
408     }
409     
410     function executeOffset(
411         address user_,
412         uint256 xpaAmount_,
413         address xpaAssetToken,
414         uint256 feeRate
415     )
416         internal
417     returns(uint256){
418         uint256 fromXPAAsset = safeDiv(safeMul(xpaAmount_,getPrice(xpaAssetToken)),1 ether);
419         uint256 userToAmount = toAmountBooks[user_][xpaAssetToken];
420         uint256 fee = safeDiv(safeMul(userToAmount, feeRate), 1 ether);
421         uint256 burnXPA;
422         uint256 burnXPAAsset;
423         if(fromXPAAsset >= safeAdd(userToAmount, fee)){
424             burnXPA = safeDiv(safeMul(safeAdd(userToAmount, fee), 1 ether), getPrice(xpaAssetToken));
425             emit eExecuteOffset(burnXPA, xpaAssetToken, safeAdd(userToAmount, fee));
426             xpaAmount_ = safeSub(xpaAmount_, burnXPA);
427             toAmountBooks[user_][xpaAssetToken] = 0;
428             profit = safeAdd(profit, safeDiv(safeMul(fee,1 ether), getPrice(xpaAssetToken)));
429             if(
430                 !FundAccount(fundAccount).burn(xpaAssetToken, userToAmount)
431             ){
432                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken],userToAmount);
433             }
434 
435         }else{
436             
437             fee = safeDiv(safeMul(xpaAmount_, feeRate), 1 ether);
438             profit = safeAdd(profit, fee);
439             burnXPAAsset = safeDiv(safeMul(safeSub(xpaAmount_, fee),getPrice(xpaAssetToken)),1 ether);
440             toAmountBooks[user_][xpaAssetToken] = safeSub(userToAmount, burnXPAAsset);
441             emit eExecuteOffset(xpaAmount_, xpaAssetToken, burnXPAAsset);
442             
443             xpaAmount_ = 0;
444             if(
445                 !FundAccount(fundAccount).burn(xpaAssetToken, burnXPAAsset)
446             ){
447                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken], burnXPAAsset);
448             }
449             
450         }
451         return xpaAmount_;
452     }
453     
454     function getPunishXPA(
455         address user_
456     )
457         internal
458         view 
459     returns(uint256){
460         uint256 userFromAmount = fromAmountBooks[user_];
461         uint256 punishXPA = safeDiv(safeMul(userFromAmount, 0.1 ether),1 ether);
462         if(userFromAmount <= safeAdd(minForceOffsetAmount, 100 ether)){
463             return userFromAmount;
464         }else if(punishXPA < minForceOffsetAmount){
465             return minForceOffsetAmount;
466         }else if(punishXPA > maxForceOffsetAmount){
467             return maxForceOffsetAmount;
468         }else{
469             return punishXPA;
470         }
471     }
472     
473     // 取得用戶抵押率, user: 指定用戶
474     function getMortgageRate(
475         address user_
476     ) 
477         public
478         view 
479     returns(uint256){
480         if(fromAmountBooks[user_] != 0){
481             uint256 totalLoanXPA = 0;
482             for(uint256 i = 0; i < xpaAsset.length; i++) {
483                 totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
484             }
485             return safeDiv(safeMul(totalLoanXPA,1 ether),fromAmountBooks[user_]);
486         }else{
487             return 0;
488         }
489     }
490         
491     // 取得最高抵押率
492     function getHighestMortgageRate() 
493         public
494         view 
495     returns(uint256){
496         uint256 totalXPA = Token(XPA).totalSupply();
497         uint256 issueRate = safeDiv(safeMul(Token(XPA).balanceOf(this), 1 ether), totalXPA);
498         if(issueRate >= 0.7 ether){
499             return 0.7 ether;
500         }else if(issueRate >= 0.6 ether){
501             return 0.6 ether;
502         }else if(issueRate >= 0.5 ether){
503             return 0.5 ether;
504         }else if(issueRate >= 0.3 ether){
505             return 0.3 ether;
506         }else{
507             return 0.1 ether;
508         }
509     }
510     
511     // 取得平倉線
512     function getClosingLine() 
513         public
514         view
515     returns(uint256){
516         uint256 highestMortgageRate = getHighestMortgageRate();
517         if(highestMortgageRate >= 0.6 ether){
518             return safeAdd(highestMortgageRate, 0.1 ether);
519         }else{
520             return 0.6 ether;
521         }
522     }
523     
524     // 取得 XPA Assets 匯率 
525     function getPrice(
526         address token_
527     ) 
528         public
529         view
530     returns(uint256){
531         return TokenFactory(tokenFactory).getPrice(token_);
532     }
533     
534     // 取得用戶可提領的XPA(扣掉最高抵押率後的XPA)
535     function getUsableXPA(
536         address user_
537     )
538         public
539         view
540     returns(uint256) {
541         uint256 totalLoanXPA = 0;
542         for(uint256 i = 0; i < xpaAsset.length; i++) {
543             totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
544         }
545         if(fromAmountBooks[user_] > safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate())){
546             return safeSub(fromAmountBooks[user_], safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate()));
547         }else{
548             return 0;
549         }
550     }
551     
552     // 取得用戶可借貸 XPA Assets 最大額度, user: 指定用戶
553     /*function getUsableAmount(
554         address user_,
555         address token_
556     ) 
557         public
558         view
559     returns(uint256) {
560         uint256 amount = safeDiv(safeMul(fromAmountBooks[user_], getPrice(token_)), 1 ether);
561         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
562     }*/
563     
564     // 取得用戶已借貸 XPA Assets 數量, user: 指定用戶
565     function getLoanAmount(
566         address user_,
567         address token_
568     ) 
569         public
570         view
571     returns(uint256) {
572         return toAmountBooks[user_][token_];
573     }
574     
575     // 取得用戶剩餘可借貸 XPA Assets 額度, user: 指定用戶
576     function getRemainingAmount(
577         address user_,
578         address token_
579     ) 
580         public
581         view
582     returns(uint256) {
583         uint256 amount = safeDiv(safeMul(getUsableXPA(user_), getPrice(token_)), 1 ether);
584         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
585     }
586     
587     function burnFundAccount(
588         address token_,
589         uint256 amount_
590     )
591         onlyOperator
592         public
593     {
594         if(
595             FundAccount(fundAccount).burn(token_, amount_)
596         ){
597             unPaidFundAccount[token_] = safeSub(unPaidFundAccount[token_], amount_);
598         }
599     }
600 
601     function transferProfit(
602         address token_,
603         uint256 amount_
604     )
605         onlyOperator 
606         public
607     {
608         require(amount_ > 0);
609         if(
610             XPA != token_ && 
611             Token(token_).balanceOf(this) >= amount_
612         ) {
613             require(Token(token_).transfer(bank, amount_));
614         }
615 
616         if(
617             XPA == token_ && 
618             Token(XPA).balanceOf(this) >= amount_
619         ) {
620             profit = safeSub(profit,amount_);
621             require(Token(token_).transfer(bank, amount_));
622         }
623 
624     }
625         
626     function setFeeRate(
627         uint256 withDrawFeerate_,
628         uint256 offsetFeerate_,
629         uint256 forceOffsetBasicFeerate_,
630         uint256 forceOffsetExecuteFeerate_,
631         uint256 forceOffsetExtraFeerate_,
632         uint256 forceOffsetExecuteMaxFee_
633     )
634         onlyOperator 
635         public
636     {
637         require(withDrawFeerate_ < 0.05 ether);
638         require(offsetFeerate_ < 0.05 ether);
639         require(forceOffsetBasicFeerate_ < 0.05 ether);
640         require(forceOffsetExecuteFeerate_ < 0.05 ether);
641         require(forceOffsetExtraFeerate_ < 0.05 ether);
642         withdrawFeeRate = withDrawFeerate_;
643         offsetFeeRate = offsetFeerate_;
644         forceOffsetBasicFeeRate = forceOffsetBasicFeerate_;
645         forceOffsetExecuteFeeRate = forceOffsetExecuteFeerate_;
646         forceOffsetExtraFeeRate = forceOffsetExtraFeerate_;
647         forceOffsetExecuteMaxFee = forceOffsetExecuteMaxFee_;
648     }
649 
650     function migrate(
651         address newContract_
652     )
653         public
654         onlyOwner
655     {
656         require(newContract_ != address(0));
657         if(
658             newXPAAssets == address(0) &&
659             XPAAssets(newContract_).transferXPAAssetAndProfit(xpaAsset, profit) &&
660             Token(XPA).transfer(newContract_, Token(XPA).balanceOf(this))
661         ) {
662             forceOff = true;
663             powerStatus = false;
664             newXPAAssets = newContract_;
665             for(uint256 i = 0; i < xpaAsset.length; i++) {
666                 XPAAssets(newContract_).transferUnPaidFundAccount(xpaAsset[i], unPaidFundAccount[xpaAsset[i]]);
667             }
668             emit eMigrate(newContract_);
669         }
670     }
671     
672     function transferXPAAssetAndProfit(
673         address[] xpaAsset_,
674         uint256 profit_
675     )
676         public
677         onlyOperator
678     returns(bool) {
679         require(msg.sender == oldXPAAssets);
680         xpaAsset = xpaAsset_;
681         profit = profit_;
682         return true;
683     }
684     
685     function transferUnPaidFundAccount(
686         address xpaAsset_,
687         uint256 unPaidAmount_
688     )
689         public
690         onlyOperator
691     returns(bool) {
692         require(msg.sender == oldXPAAssets);
693         unPaidFundAccount[xpaAsset_] = unPaidAmount_;
694         return true;
695     }
696     
697     function migratingAmountBooks(
698         address user_,
699         address newContract_
700     )
701         public
702         onlyOperator
703     {
704         XPAAssets(newContract_).migrateAmountBooks(user_); 
705     }
706     
707     function migrateAmountBooks(
708         address user_
709     )
710         public
711         onlyOperator 
712     {
713         require(msg.sender == oldXPAAssets);
714         require(!migrateBooks[user_]);
715 
716         migrateBooks[user_] = true;
717         fromAmountBooks[user_] = safeAdd(fromAmountBooks[user_],XPAAssets(oldXPAAssets).getFromAmountBooks(user_));
718         forceOffsetBooks[user_] = XPAAssets(oldXPAAssets).getForceOffsetBooks(user_);
719         for(uint256 i = 0; i < xpaAsset.length; i++) {
720             toAmountBooks[user_][xpaAsset[i]] = safeAdd(toAmountBooks[user_][xpaAsset[i]], XPAAssets(oldXPAAssets).getLoanAmount(user_,xpaAsset[i]));
721         }
722         emit eMigrateAmount(user_);
723     }
724     
725     function getFromAmountBooks(
726         address user_
727     )
728         public
729         view 
730     returns(uint256) {
731         return fromAmountBooks[user_];
732     }
733     
734     function getForceOffsetBooks(
735         address user_
736     )
737         public 
738         view 
739     returns(uint256) {
740         return forceOffsetBooks[user_];
741     }
742 }