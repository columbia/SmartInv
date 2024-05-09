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
43       uint256 z = x + y;
44       require((z >= x) && (z >= y));
45       return z;
46     }
47 
48     function safeSub(uint x, uint y)
49         internal
50         pure
51     returns(uint) {
52       require(x >= y);
53       uint256 z = x - y;
54       return z;
55     }
56 
57     function safeMul(uint x, uint y)
58         internal
59         pure
60     returns(uint) {
61       uint z = x * y;
62       require((x == 0) || (z / x == y));
63       return z;
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
78       bytes32 hash = keccak256(block.number, msg.sender, salt);
79       return uint(hash) % N;
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
177     address public tokenFactory = 0x0036B86289ccCE0984251CCCA62871b589B0F52d68;
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
212         uint256 initCanOffsetTime_
213     ) public {
214         initCanOffsetTime = initCanOffsetTime_;
215     }
216 
217     function setFundAccount(
218         address fundAccount_
219     )
220         public
221         onlyOperator
222     {
223         if(fundAccount_ != address(0)) {
224             fundAccount = fundAccount_;
225         }
226     }
227 
228     function createToken(
229         string symbol_,
230         string name_,
231         uint256 defaultExchangeRate_
232     )
233         public
234         onlyOperator 
235     {
236         address newAsset = TokenFactory(tokenFactory).createToken(symbol_, name_, defaultExchangeRate_);
237         for(uint256 i = 0; i < xpaAsset.length; i++) {
238             if(xpaAsset[i] == newAsset){
239                 return;
240             }
241         }
242         xpaAsset.push(newAsset);
243     }
244 
245     //抵押 XPA
246     function mortgage(
247         address representor_
248     )
249         onlyActive
250         public
251     {
252         address user = getUser(representor_);
253         uint256 amount_ = Token(XPA).allowance(msg.sender, this); // get mortgage amount
254         if(
255             amount_ >= 100 ether && 
256             Token(XPA).transferFrom(msg.sender, this, amount_) 
257         ){
258             fromAmountBooks[user] = safeAdd(fromAmountBooks[user], amount_); // update books
259             emit eMortgage(user,amount_); // wirte event
260         }
261     }
262     
263     // 借出 XPA Assets, amount: 指定借出金額
264     function withdraw(
265         address token_,
266         uint256 amount_,
267         address representor_
268     ) 
269         onlyActive 
270         public 
271     {
272         address user = getUser(representor_);
273         if(
274             token_ != XPA &&
275             amount_ > 0 &&
276             amount_ <= safeDiv(safeMul(safeDiv(safeMul(getUsableXPA(user), getPrice(token_)), 1 ether), getHighestMortgageRate()), 1 ether)
277         ){
278             toAmountBooks[user][token_] = safeAdd(toAmountBooks[user][token_],amount_);
279             uint256 withdrawFee = safeDiv(safeMul(amount_,withdrawFeeRate),1 ether); // calculate withdraw fee
280             XPAAssetToken(token_).create(user, safeSub(amount_, withdrawFee));
281             XPAAssetToken(token_).create(this, withdrawFee);
282             emit eWithdraw(user, token_, amount_); // write event
283         }
284     }
285     
286     // 領回 XPA, amount: 指定領回金額
287     function withdrawXPA(
288         uint256 amount_,
289         address representor_
290     )
291         onlyActive
292         public
293     {
294         address user = getUser(representor_);
295         if(
296             amount_ >= 100 ether && 
297             amount_ <= getUsableXPA(user)
298         ){
299             fromAmountBooks[user] = safeSub(fromAmountBooks[user], amount_);
300             require(Token(XPA).transfer(user, amount_));
301             emit eWithdraw(user, XPA, amount_); // write event
302         }    
303     }
304     
305     // 檢查額度是否足夠借出 XPA Assets
306     /*function checkWithdraw(
307         address token_,
308         uint256 amount_,
309         address user_
310     ) 
311         internal  
312         view
313     returns(bool) {
314         if(
315             token_ != XPA && 
316             amount_ <= safeDiv(safeMul(safeDiv(safeMul(getUsableXPA(user_), getPrice(token_)), 1 ether), getHighestMortgageRate()), 1 ether)
317         ){
318             return true;
319         }else if(
320             token_ == XPA && 
321             amount_ <= getUsableXPA(user_)
322         ){
323             return true;
324         }else{
325             return false;
326         }
327     }*/
328 
329     // 還款 XPA Assets, amount: 指定還回金額
330     function repayment(
331         address token_,
332         uint256 amount_,
333         address representor_
334     )
335         onlyActive 
336         public
337     {
338         address user = getUser(representor_);
339         if(
340             XPAAssetToken(token_).burnFrom(user, amount_)
341         ) {
342             toAmountBooks[user][token_] = safeSub(toAmountBooks[user][token_],amount_);
343             emit eRepayment(user, token_, amount_);
344         }
345     }
346     
347     // 平倉 / 強行平倉, user: 指定平倉對象
348     function offset(
349         address user_,
350         address token_
351     )
352         onlyActive
353         public
354     {
355         uint256 userFromAmount = fromAmountBooks[user_] >= maxForceOffsetAmount ? maxForceOffsetAmount : fromAmountBooks[user_];
356         require(block.timestamp > initCanOffsetTime);
357         require(userFromAmount > 0);
358         address user = getUser(user_);
359 
360         if(
361             user_ == user &&
362             getLoanAmount(user, token_) > 0
363         ){
364             emit eOffset(user, user_, userFromAmount);
365             uint256 remainingXPA = executeOffset(user_, userFromAmount, token_, offsetFeeRate);
366             
367             require(Token(XPA).transfer(fundAccount, safeDiv(safeMul(safeSub(userFromAmount, remainingXPA), 1 ether), safeAdd(1 ether, offsetFeeRate)))); //轉帳至平倉基金
368             fromAmountBooks[user_] = remainingXPA;
369         }else if(
370             user_ != user && 
371             block.timestamp > (forceOffsetBooks[user_] + 28800) &&
372             getMortgageRate(user_) >= getClosingLine()
373         ){
374             forceOffsetBooks[user_] = block.timestamp;
375                 
376             uint256 punishXPA = getPunishXPA(user_); //get 10% xpa
377             emit eOffset(user, user_, punishXPA);
378 
379             uint256[3] memory forceOffsetFee;
380             forceOffsetFee[0] = safeDiv(safeMul(punishXPA, forceOffsetBasicFeeRate), 1 ether); //基本手續費(收益)
381             forceOffsetFee[1] = safeDiv(safeMul(punishXPA, forceOffsetExtraFeeRate), 1 ether); //額外手續費(平倉基金)
382             forceOffsetFee[2] = safeDiv(safeMul(punishXPA, forceOffsetExecuteFeeRate), 1 ether);//執行手續費(執行者)
383             forceOffsetFee[2] = forceOffsetFee[2] > forceOffsetExecuteMaxFee ? forceOffsetExecuteMaxFee : forceOffsetFee[2];
384 
385             profit = safeAdd(profit, forceOffsetFee[0]);
386             uint256 allFee = safeAdd(forceOffsetFee[2],safeAdd(forceOffsetFee[0], forceOffsetFee[1]));
387             remainingXPA = safeSub(punishXPA,allFee);
388 
389             for(uint256 i = 0; i < xpaAsset.length; i++) {
390                 if(getLoanAmount(user_, xpaAsset[i]) > 0){
391                     remainingXPA = executeOffset(user_, remainingXPA, xpaAsset[i],0);
392                     if(remainingXPA == 0){
393                         break;
394                     }
395                 }
396             }
397                 
398             fromAmountBooks[user_] = safeSub(fromAmountBooks[user_], safeSub(punishXPA, remainingXPA));
399             require(Token(XPA).transfer(fundAccount, safeAdd(forceOffsetFee[1],safeSub(safeSub(punishXPA, allFee), remainingXPA)))); //轉帳至平倉基金
400             require(Token(XPA).transfer(msg.sender, forceOffsetFee[2])); //執行手續費轉給執行者
401         }
402     }
403     
404     function executeOffset(
405         address user_,
406         uint256 xpaAmount_,
407         address xpaAssetToken,
408         uint256 feeRate
409     )
410         internal
411     returns(uint256){
412         uint256 fromXPAAsset = safeDiv(safeMul(xpaAmount_,getPrice(xpaAssetToken)),1 ether);
413         uint256 userToAmount = toAmountBooks[user_][xpaAssetToken];
414         uint256 fee = safeDiv(safeMul(userToAmount, feeRate), 1 ether);
415         uint256 burnXPA;
416         uint256 burnXPAAsset;
417         if(fromXPAAsset >= safeAdd(userToAmount, fee)){
418             burnXPA = safeDiv(safeMul(safeAdd(userToAmount, fee), 1 ether), getPrice(xpaAssetToken));
419             emit eExecuteOffset(burnXPA, xpaAssetToken, safeAdd(userToAmount, fee));
420             xpaAmount_ = safeSub(xpaAmount_, burnXPA);
421             toAmountBooks[user_][xpaAssetToken] = 0;
422             profit = safeAdd(profit, safeDiv(safeMul(fee,1 ether), getPrice(xpaAssetToken)));
423             if(
424                 !FundAccount(fundAccount).burn(xpaAssetToken, userToAmount)
425             ){
426                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken],userToAmount);
427             }
428 
429         }else{
430             
431             fee = safeDiv(safeMul(xpaAmount_, feeRate), 1 ether);
432             profit = safeAdd(profit, fee);
433             burnXPAAsset = safeDiv(safeMul(safeSub(xpaAmount_, fee),getPrice(xpaAssetToken)),1 ether);
434             toAmountBooks[user_][xpaAssetToken] = safeSub(userToAmount, burnXPAAsset);
435             emit eExecuteOffset(xpaAmount_, xpaAssetToken, burnXPAAsset);
436             
437             xpaAmount_ = 0;
438             if(
439                 !FundAccount(fundAccount).burn(xpaAssetToken, burnXPAAsset)
440             ){
441                 unPaidFundAccount[xpaAssetToken] = safeAdd(unPaidFundAccount[xpaAssetToken], burnXPAAsset);
442             }
443             
444         }
445         return xpaAmount_;
446     }
447     
448     function getPunishXPA(
449         address user_
450     )
451         internal
452         view 
453     returns(uint256){
454         uint256 userFromAmount = fromAmountBooks[user_];
455         uint256 punishXPA = safeDiv(safeMul(userFromAmount, 0.1 ether),1 ether);
456         if(userFromAmount <= safeAdd(minForceOffsetAmount, 100 ether)){
457             return userFromAmount;
458         }else if(punishXPA < minForceOffsetAmount){
459             return minForceOffsetAmount;
460         }else if(punishXPA > maxForceOffsetAmount){
461             return maxForceOffsetAmount;
462         }else{
463             return punishXPA;
464         }
465     }
466     
467     // 取得用戶抵押率, user: 指定用戶
468     function getMortgageRate(
469         address user_
470     ) 
471         public
472         view 
473     returns(uint256){
474         if(fromAmountBooks[user_] != 0){
475             uint256 totalLoanXPA = 0;
476             for(uint256 i = 0; i < xpaAsset.length; i++) {
477                 totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
478             }
479             return safeDiv(safeMul(totalLoanXPA,1 ether),fromAmountBooks[user_]);
480         }else{
481             return 0;
482         }
483     }
484         
485     // 取得最高抵押率
486     function getHighestMortgageRate() 
487         public
488         view 
489     returns(uint256){
490         uint256 totalXPA = Token(XPA).totalSupply();
491         uint256 issueRate = safeDiv(safeMul(Token(XPA).balanceOf(this), 1 ether), totalXPA);
492         if(issueRate >= 0.7 ether){
493             return 0.7 ether;
494         }else if(issueRate >= 0.6 ether){
495             return 0.6 ether;
496         }else if(issueRate >= 0.5 ether){
497             return 0.5 ether;
498         }else if(issueRate >= 0.3 ether){
499             return 0.3 ether;
500         }else{
501             return 0.1 ether;
502         }
503     }
504     
505     // 取得平倉線
506     function getClosingLine() 
507         public
508         view
509     returns(uint256){
510         uint256 highestMortgageRate = getHighestMortgageRate();
511         if(highestMortgageRate >= 0.6 ether){
512             return safeAdd(highestMortgageRate, 0.1 ether);
513         }else{
514             return 0.6 ether;
515         }
516     }
517     
518     // 取得 XPA Assets 匯率 
519     function getPrice(
520         address token_
521     ) 
522         public
523         view
524     returns(uint256){
525         return TokenFactory(tokenFactory).getPrice(token_);
526     }
527     
528     // 取得用戶可提領的XPA(扣掉最高抵押率後的XPA)
529     function getUsableXPA(
530         address user_
531     )
532         public
533         view
534     returns(uint256) {
535         uint256 totalLoanXPA = 0;
536         for(uint256 i = 0; i < xpaAsset.length; i++) {
537             totalLoanXPA = safeAdd(totalLoanXPA, safeDiv(safeMul(getLoanAmount(user_,xpaAsset[i]), 1 ether), getPrice(xpaAsset[i])));
538         }
539         if(fromAmountBooks[user_] > safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate())){
540             return safeSub(fromAmountBooks[user_], safeDiv(safeMul(totalLoanXPA, 1 ether), getHighestMortgageRate()));
541         }else{
542             return 0;
543         }
544     }
545     
546     // 取得用戶可借貸 XPA Assets 最大額度, user: 指定用戶
547     /*function getUsableAmount(
548         address user_,
549         address token_
550     ) 
551         public
552         view
553     returns(uint256) {
554         uint256 amount = safeDiv(safeMul(fromAmountBooks[user_], getPrice(token_)), 1 ether);
555         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
556     }*/
557     
558     // 取得用戶已借貸 XPA Assets 數量, user: 指定用戶
559     function getLoanAmount(
560         address user_,
561         address token_
562     ) 
563         public
564         view
565     returns(uint256) {
566         return toAmountBooks[user_][token_];
567     }
568     
569     // 取得用戶剩餘可借貸 XPA Assets 額度, user: 指定用戶
570     function getRemainingAmount(
571         address user_,
572         address token_
573     ) 
574         public
575         view
576     returns(uint256) {
577         uint256 amount = safeDiv(safeMul(getUsableXPA(user_), getPrice(token_)), 1 ether);
578         return safeDiv(safeMul(amount, getHighestMortgageRate()), 1 ether);
579     }
580     
581     function burnFundAccount(
582         address token_,
583         uint256 amount_
584     )
585         onlyOperator
586         public
587     {
588         if(
589             FundAccount(fundAccount).burn(token_, amount_)
590         ){
591             unPaidFundAccount[token_] = safeSub(unPaidFundAccount[token_], amount_);
592         }
593     }
594 
595     function transferProfit(
596         uint256 token_,
597         uint256 amount_
598     )
599         onlyOperator 
600         public
601     {
602         if(amount_ > 0 && Token(token_).balanceOf(this) >= amount_){
603             require(Token(token_).transfer(bank, amount_));
604             profit = safeSub(profit,amount_);
605         }
606     }
607         
608     function setFeeRate(
609         uint256 withDrawFeerate_,
610         uint256 offsetFeerate_,
611         uint256 forceOffsetBasicFeerate_,
612         uint256 forceOffsetExecuteFeerate_,
613         uint256 forceOffsetExtraFeerate_,
614         uint256 forceOffsetExecuteMaxFee_
615     )
616         onlyOperator 
617         public
618     {
619         require(withDrawFeerate_ < 0.05 ether);
620         require(offsetFeerate_ < 0.05 ether);
621         require(forceOffsetBasicFeerate_ < 0.05 ether);
622         require(forceOffsetExecuteFeerate_ < 0.05 ether);
623         require(forceOffsetExtraFeerate_ < 0.05 ether);
624         withdrawFeeRate = withDrawFeerate_;
625         offsetFeeRate = offsetFeerate_;
626         forceOffsetBasicFeeRate = forceOffsetBasicFeerate_;
627         forceOffsetExecuteFeeRate = forceOffsetExecuteFeerate_;
628         forceOffsetExtraFeeRate = forceOffsetExtraFeerate_;
629         forceOffsetExecuteMaxFee = forceOffsetExecuteMaxFee_;
630     }
631 
632     function migrate(
633         address newContract_
634     )
635         public
636         onlyOwner
637     {
638         if(
639             newXPAAssets == address(0) &&
640             XPAAssets(newContract_).transferXPAAssetAndProfit(xpaAsset, profit) &&
641             Token(XPA).transfer(newContract_, Token(XPA).balanceOf(this))
642         ) {
643             forceOff = true;
644             powerStatus = false;
645             newXPAAssets = newContract_;
646             for(uint256 i = 0; i < xpaAsset.length; i++) {
647                 XPAAssets(newContract_).transferUnPaidFundAccount(xpaAsset[i], unPaidFundAccount[xpaAsset[i]]);
648             }
649             emit eMigrate(newContract_);
650         }
651     }
652     
653     function transferXPAAssetAndProfit(
654         address[] xpaAsset_,
655         uint256 profit_
656     )
657         public
658         onlyOperator
659     returns(bool) {
660         xpaAsset = xpaAsset_;
661         profit = profit_;
662         return true;
663     }
664     
665     function transferUnPaidFundAccount(
666         address xpaAsset_,
667         uint256 unPaidAmount_
668     )
669         public
670         onlyOperator
671     returns(bool) {
672         unPaidFundAccount[xpaAsset_] = unPaidAmount_;
673         return true;
674     }
675     
676     function migratingAmountBooks(
677         address user_,
678         address newContract_
679     )
680         public
681         onlyOperator
682     {
683         XPAAssets(newContract_).migrateAmountBooks(user_); 
684     }
685     
686     function migrateAmountBooks(
687         address user_
688     )
689         public
690         onlyOperator 
691     {
692         require(msg.sender == oldXPAAssets);
693         require(!migrateBooks[user_]);
694 
695         migrateBooks[user_] = true;
696         fromAmountBooks[user_] = safeAdd(fromAmountBooks[user_],XPAAssets(oldXPAAssets).getFromAmountBooks(user_));
697         forceOffsetBooks[user_] = XPAAssets(oldXPAAssets).getForceOffsetBooks(user_);
698         for(uint256 i = 0; i < xpaAsset.length; i++) {
699             toAmountBooks[user_][xpaAsset[i]] = safeAdd(toAmountBooks[user_][xpaAsset[i]], XPAAssets(oldXPAAssets).getLoanAmount(user_,xpaAsset[i]));
700         }
701         emit eMigrateAmount(user_);
702     }
703     
704     function getFromAmountBooks(
705         address user_
706     )
707         public
708         view 
709     returns(uint256) {
710         return fromAmountBooks[user_];
711     }
712     
713     function getForceOffsetBooks(
714         address user_
715     )
716         public 
717         view 
718     returns(uint256) {
719         return forceOffsetBooks[user_];
720     }
721 }