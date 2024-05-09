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
15 interface Baliv {
16     function getPrice(address fromToken_, address toToken_) external view returns(uint256);
17 }
18 
19 contract SafeMath {
20     function safeAdd(uint x, uint y)
21         internal
22         pure
23     returns(uint) {
24       uint256 z = x + y;
25       require((z >= x) && (z >= y));
26       return z;
27     }
28 
29     function safeSub(uint x, uint y)
30         internal
31         pure
32     returns(uint) {
33       require(x >= y);
34       uint256 z = x - y;
35       return z;
36     }
37 
38     function safeMul(uint x, uint y)
39         internal
40         pure
41     returns(uint) {
42       uint z = x * y;
43       require((x == 0) || (z / x == y));
44       return z;
45     }
46     
47     function safeDiv(uint x, uint y)
48         internal
49         pure
50     returns(uint) {
51         require(y > 0);
52         return x / y;
53     }
54 
55     function random(uint N, uint salt)
56         internal
57         view
58     returns(uint) {
59       bytes32 hash = keccak256(block.number, msg.sender, salt);
60       return uint(hash) % N;
61     }
62 }
63 
64 contract Authorization {
65     mapping(address => bool) internal authbook;
66     address[] public operators;
67     address public owner;
68     bool public powerStatus = true;
69     function Authorization()
70         public
71         payable
72     {
73         owner = msg.sender;
74         assignOperator(msg.sender);
75     }
76     modifier onlyOwner
77     {
78         assert(msg.sender == owner);
79         _;
80     }
81     modifier onlyOperator
82     {
83         assert(checkOperator(msg.sender));
84         _;
85     }
86     modifier onlyActive
87     {
88         assert(powerStatus);
89         _;
90     }
91     function powerSwitch(
92         bool onOff_
93     )
94         public
95         onlyOperator
96     {
97         powerStatus = onOff_;
98     }
99     function transferOwnership(address newOwner_)
100         onlyOwner
101         public
102     {
103         owner = newOwner_;
104     }
105     
106     function assignOperator(address user_)
107         public
108         onlyOwner
109     {
110         if(user_ != address(0) && !authbook[user_]) {
111             authbook[user_] = true;
112             operators.push(user_);
113         }
114     }
115     
116     function dismissOperator(address user_)
117         public
118         onlyOwner
119     {
120         delete authbook[user_];
121         for(uint i = 0; i < operators.length; i++) {
122             if(operators[i] == user_) {
123                 operators[i] = operators[operators.length - 1];
124                 operators.length -= 1;
125             }
126         }
127     }
128 
129     function checkOperator(address user_)
130         public
131         view
132     returns(bool) {
133         return authbook[user_];
134     }
135 }
136 
137 contract StandardToken is SafeMath {
138     mapping(address => uint256) balances;
139     mapping(address => mapping (address => uint256)) allowed;
140     uint256 public totalSupply;
141 
142     event Transfer(address indexed _from, address indexed _to, uint256 _value);
143     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
144     event Issue(address indexed _to, uint256 indexed _value);
145     event Burn(address indexed _from, uint256 indexed _value);
146 
147     /* constructure */
148     function StandardToken() public payable {}
149 
150     /* Send coins */
151     function transfer(
152         address to_,
153         uint256 amount_
154     )
155         public
156     returns(bool success) {
157         if(balances[msg.sender] >= amount_ && amount_ > 0) {
158             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
159             balances[to_] = safeAdd(balances[to_], amount_);
160             emit Transfer(msg.sender, to_, amount_);
161             return true;
162         } else {
163             return false;
164         }
165     }
166 
167     /* A contract attempts to get the coins */
168     function transferFrom(
169         address from_,
170         address to_,
171         uint256 amount_
172     ) public returns(bool success) {
173         if(balances[from_] >= amount_ && allowed[from_][msg.sender] >= amount_ && amount_ > 0) {
174             balances[to_] = safeAdd(balances[to_], amount_);
175             balances[from_] = safeSub(balances[from_], amount_);
176             allowed[from_][msg.sender] = safeSub(allowed[from_][msg.sender], amount_);
177             emit Transfer(from_, to_, amount_);
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     function balanceOf(
185         address _owner
186     )
187         constant
188         public
189     returns (uint256 balance) {
190         return balances[_owner];
191     }
192 
193     /* Allow another contract to spend some tokens in your behalf */
194     function approve(
195         address _spender,
196         uint256 _value
197     )
198         public
199     returns (bool success) {
200         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 }
210 
211 contract XPAAssetToken is StandardToken, Authorization {
212     // metadata
213     address[] public burners;
214     string public name;
215     string public symbol;
216     uint256 public defaultExchangeRate;
217     uint256 public constant decimals = 18;
218 
219     // constructor
220     function XPAAssetToken(
221         string symbol_,
222         string name_,
223         uint256 defaultExchangeRate_
224     )
225         public
226     {
227         totalSupply = 0;
228         symbol = symbol_;
229         name = name_;
230         defaultExchangeRate = defaultExchangeRate_ > 0 ? defaultExchangeRate_ : 0.01 ether;
231     }
232 
233     function transferOwnership(
234         address newOwner_
235     )
236         onlyOwner
237         public
238     {
239         owner = newOwner_;
240     }
241 
242     function create(
243         address user_,
244         uint256 amount_
245     )
246         public
247         onlyOperator
248     returns(bool success) {
249         if(amount_ > 0 && user_ != address(0)) {
250             totalSupply = safeAdd(totalSupply, amount_);
251             balances[user_] = safeAdd(balances[user_], amount_);
252             emit Issue(owner, amount_);
253             emit Transfer(owner, user_, amount_);
254             return true;
255         }
256     }
257 
258     function burn(
259         uint256 amount_
260     )
261         public
262     returns(bool success) {
263         require(allowToBurn(msg.sender));
264         if(amount_ > 0 && balances[msg.sender] >= amount_) {
265             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
266             totalSupply = safeSub(totalSupply, amount_);
267             emit Transfer(msg.sender, owner, amount_);
268             emit Burn(owner, amount_);
269             return true;
270         }
271     }
272 
273     function burnFrom(
274         address user_,
275         uint256 amount_
276     )
277         public
278     returns(bool success) {
279         require(allowToBurn(msg.sender));
280         if(balances[user_] >= amount_ && allowed[user_][msg.sender] >= amount_ && amount_ > 0) {
281             balances[user_] = safeSub(balances[user_], amount_);
282             totalSupply = safeSub(totalSupply, amount_);
283             allowed[user_][msg.sender] = safeSub(allowed[user_][msg.sender], amount_);
284             emit Transfer(user_, owner, amount_);
285             emit Burn(owner, amount_);
286             return true;
287         }
288     }
289 
290     function getDefaultExchangeRate(
291     )
292         public
293         view
294     returns(uint256) {
295         return defaultExchangeRate;
296     }
297 
298     function getSymbol(
299     )
300         public
301         view
302     returns(bytes32) {
303         return keccak256(symbol);
304     }
305 
306     function assignBurner(
307         address account_
308     )
309         public
310         onlyOperator
311     {
312         require(account_ != address(0));
313         for(uint256 i = 0; i < burners.length; i++) {
314             if(burners[i] == account_) {
315                 return;
316             }
317         }
318         burners.push(account_);
319     }
320 
321     function dismissBunner(
322         address account_
323     )
324         public
325         onlyOperator
326     {
327         require(account_ != address(0));
328         for(uint256 i = 0; i < burners.length; i++) {
329             if(burners[i] == account_) {
330                 burners[i] = burners[burners.length - 1];
331                 burners.length -= 1;
332             }
333         }
334     }
335 
336     function allowToBurn(
337         address account_
338     )
339         public
340         view
341     returns(bool) {
342         if(checkOperator(account_)) {
343             return true;
344         }
345         for(uint256 i = 0; i < burners.length; i++) {
346             if(burners[i] == account_) {
347                 return true;
348             }
349         }
350     }
351 }
352 
353 contract TokenFactory is Authorization {
354     string public version = "0.5.0";
355 
356     event eNominatingExchange(address);
357     event eNominatingXPAAssets(address);
358     event eNominatingETHAssets(address);
359     event eCancelNominatingExchange(address);
360     event eCancelNominatingXPAAssets(address);
361     event eCancelNominatingETHAssets(address);
362     event eChangeExchange(address, address);
363     event eChangeXPAAssets(address, address);
364     event eChangeETHAssets(address, address);
365     event eAddFundAccount(address);
366     event eRemoveFundAccount(address);
367 
368     address[] public assetTokens;
369     address[] public fundAccounts;
370     address public exchange = 0x008ea74569c1b9bbb13780114b6b5e93396910070a;
371     address public exchangeOldVersion = 0x0013b4b9c415213bb2d0a5d692b6f2e787b927c211;
372     address public XPAAssets = address(0);
373     address public ETHAssets = address(0);
374     address public candidateXPAAssets = address(0);
375     address public candidateETHAssets = address(0);
376     address public candidateExchange = address(0);
377     uint256 public candidateTillXPAAssets = 0;
378     uint256 public candidateTillETHAssets = 0;
379     uint256 public candidateTillExchange = 0;
380     address public XPA = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
381     address public ETH = address(0);
382 
383     function createToken(
384         string symbol_,
385         string name_,
386         uint256 defaultExchangeRate_
387     )
388         public
389     returns(address) {
390         require(msg.sender == XPAAssets);
391         bool tokenRepeat = false;
392         address newAsset;
393         for(uint256 i = 0; i < assetTokens.length; i++) {
394             if(XPAAssetToken(assetTokens[i]).getSymbol() == keccak256(symbol_)){
395                 tokenRepeat = true;
396                 newAsset = assetTokens[i];
397                 break;
398             }
399         }
400         if(!tokenRepeat){
401             newAsset = new XPAAssetToken(symbol_, name_, defaultExchangeRate_);
402             XPAAssetToken(newAsset).assignOperator(XPAAssets);
403             XPAAssetToken(newAsset).assignOperator(ETHAssets);
404             for(uint256 j = 0; j < fundAccounts.length; j++) {
405                 XPAAssetToken(newAsset).assignBurner(fundAccounts[j]);
406             }
407             assetTokens.push(newAsset);
408         }
409         return newAsset;
410     }
411 
412     // set to candadite, after 7 days set to exchange, set again after 7 days
413     function setExchange(
414         address exchange_
415     )
416         public
417         onlyOperator
418     {
419         require(
420             exchange_ != address(0)
421         );
422         if(
423             exchange_ == exchange &&
424             candidateExchange != address(0)
425         ) {
426             emit eCancelNominatingExchange(candidateExchange);
427             candidateExchange = address(0);
428             candidateTillExchange = 0;
429         } else if(
430             exchange == address(0)
431         ) {
432             // initial value
433             emit eChangeExchange(address(0), exchange_);
434             exchange = exchange_;
435             exchangeOldVersion = exchange_;
436         } else if(
437             exchange_ != candidateExchange &&
438             candidateTillExchange + 86400 * 7 < block.timestamp
439         ) {
440             // set to candadite
441             emit eNominatingExchange(exchange_);
442             candidateExchange = exchange_;
443             candidateTillExchange = block.timestamp + 86400 * 7;
444         } else if(
445             exchange_ == candidateExchange &&
446             candidateTillExchange < block.timestamp
447         ) {
448             // set to exchange
449             emit eChangeExchange(exchange, candidateExchange);
450             exchangeOldVersion = exchange;
451             exchange = candidateExchange;
452             candidateExchange = address(0);
453         }
454     }
455 
456     function setXPAAssets(
457         address XPAAssets_
458     )
459         public
460         onlyOperator
461     {
462         require(
463             XPAAssets_ != address(0)
464         );
465         if(
466             XPAAssets_ == XPAAssets &&
467             candidateXPAAssets != address(0)
468         ) {
469             emit eCancelNominatingXPAAssets(candidateXPAAssets);
470             candidateXPAAssets = address(0);
471             candidateTillXPAAssets = 0;
472         } else if(
473             XPAAssets == address(0)
474         ) {
475             // initial value
476             emit eChangeXPAAssets(address(0), XPAAssets_);
477             XPAAssets = XPAAssets_;
478         } else if(
479             XPAAssets_ != candidateXPAAssets &&
480             candidateTillXPAAssets + 86400 * 7 < block.timestamp
481         ) {
482             // set to candadite
483             emit eNominatingXPAAssets(XPAAssets_);
484             candidateXPAAssets = XPAAssets_;
485             candidateTillXPAAssets = block.timestamp + 86400 * 7;
486         } else if(
487             XPAAssets_ == candidateXPAAssets &&
488             candidateTillXPAAssets < block.timestamp
489         ) {
490             // set to XPAAssets
491             emit eChangeXPAAssets(XPAAssets, candidateXPAAssets);
492             dismissTokenOperator(XPAAssets);
493             assignTokenOperator(candidateXPAAssets);
494             XPAAssets = candidateXPAAssets;
495             candidateXPAAssets = address(0);
496         }
497     }
498 
499     function setETHAssets(
500         address ETHAssets_
501     )
502         public
503         onlyOperator
504     {
505         require(
506             ETHAssets_ != address(0)
507         );
508         if(
509             ETHAssets_ == ETHAssets &&
510             candidateETHAssets != address(0)
511         ) {
512             emit eCancelNominatingETHAssets(candidateETHAssets);
513             candidateETHAssets = address(0);
514             candidateTillETHAssets = 0;
515         } else if(
516             ETHAssets == address(0)
517         ) {
518             // initial value
519             ETHAssets = ETHAssets_;
520         } else if(
521             ETHAssets_ != candidateETHAssets &&
522             candidateTillETHAssets + 86400 * 7 < block.timestamp
523         ) {
524             // set to candadite
525             emit eNominatingETHAssets(ETHAssets_);
526             candidateETHAssets = ETHAssets_;
527             candidateTillETHAssets = block.timestamp + 86400 * 7;
528         } else if(
529             ETHAssets_ == candidateETHAssets &&
530             candidateTillETHAssets < block.timestamp
531         ) {
532             // set to ETHAssets
533             emit eChangeETHAssets(ETHAssets, candidateETHAssets);
534             dismissTokenOperator(ETHAssets);
535             assignTokenOperator(candidateETHAssets);
536             ETHAssets = candidateETHAssets;
537             candidateETHAssets = address(0);
538         }
539     }
540 
541     function addFundAccount(
542         address account_
543     )
544         public
545         onlyOperator
546     {
547         require(account_ != address(0));
548         for(uint256 i = 0; i < fundAccounts.length; i++) {
549             if(fundAccounts[i] == account_) {
550                 return;
551             }
552         }
553         for(uint256 j = 0; j < assetTokens.length; j++) {
554             XPAAssetToken(assetTokens[i]).assignBurner(account_);
555         }
556         emit eAddFundAccount(account_);
557         fundAccounts.push(account_);
558     }
559 
560     function removeFundAccount(
561         address account_
562     )
563         public
564         onlyOperator
565     {
566         require(account_ != address(0));
567         uint256 i = 0;
568         uint256 j = 0;
569         for(i = 0; i < fundAccounts.length; i++) {
570             if(fundAccounts[i] == account_) {
571                 for(j = 0; j < assetTokens.length; j++) {
572                     XPAAssetToken(assetTokens[i]).dismissBunner(account_);
573                 }
574                 fundAccounts[i] = fundAccounts[fundAccounts.length - 1];
575                 fundAccounts.length -= 1;
576             }
577         }
578     }
579 
580     function getPrice(
581         address token_
582     ) 
583         public
584         view
585     returns(uint256) {
586         uint256 currPrice = Baliv(exchange).getPrice(XPA, token_);
587         if(currPrice == 0) {
588             currPrice = XPAAssetToken(token_).getDefaultExchangeRate();
589         }
590         return currPrice;
591     }
592 
593     function getAssetLength(
594     )
595         public
596         view
597     returns(uint256) {
598         return assetTokens.length;
599     }
600 
601     function getAssetToken(
602         uint256 index_
603     )
604         public
605         view
606     returns(address) {
607         return assetTokens[index_];
608     }
609 
610     function assignTokenOperator(address user_)
611         internal
612     {
613         if(user_ != address(0)) {
614             for(uint256 i = 0; i < assetTokens.length; i++) {
615                 XPAAssetToken(assetTokens[i]).assignOperator(user_);
616             }
617         }
618     }
619     
620     function dismissTokenOperator(address user_)
621         internal
622     {
623         if(user_ != address(0)) {
624             for(uint256 i = 0; i < assetTokens.length; i++) {
625                 XPAAssetToken(assetTokens[i]).dismissOperator(user_);
626             }
627         }
628     }
629 }