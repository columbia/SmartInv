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
19 contract TokenRecipient {
20     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
21 }
22 
23 contract SafeMath {
24     function safeAdd(uint x, uint y)
25         internal
26         pure
27     returns(uint) {
28         uint256 z = x + y;
29         require((z >= x) && (z >= y));
30         return z;
31     }
32 
33     function safeSub(uint x, uint y)
34         internal
35         pure
36     returns(uint) {
37         require(x >= y);
38         uint256 z = x - y;
39         return z;
40     }
41 
42     function safeMul(uint x, uint y)
43         internal
44         pure
45     returns(uint) {
46         uint z = x * y;
47         require((x == 0) || (z / x == y));
48         return z;
49     }
50     
51     function safeDiv(uint x, uint y)
52         internal
53         pure
54     returns(uint) {
55         require(y > 0);
56         return x / y;
57     }
58 
59     function random(uint N, uint salt)
60         internal
61         view
62     returns(uint) {
63         bytes32 hash = keccak256(block.number, msg.sender, salt);
64         return uint(hash) % N;
65     }
66 }
67 
68 contract Authorization {
69     mapping(address => bool) internal authbook;
70     address[] public operators;
71     address public owner;
72     bool public powerStatus = true;
73     function Authorization()
74         public
75         payable
76     {
77         owner = msg.sender;
78         assignOperator(msg.sender);
79     }
80     modifier onlyOwner
81     {
82         assert(msg.sender == owner);
83         _;
84     }
85     modifier onlyOperator
86     {
87         assert(checkOperator(msg.sender));
88         _;
89     }
90     modifier onlyActive
91     {
92         assert(powerStatus);
93         _;
94     }
95     function powerSwitch(
96         bool onOff_
97     )
98         public
99         onlyOperator
100     {
101         powerStatus = onOff_;
102     }
103     function transferOwnership(address newOwner_)
104         onlyOwner
105         public
106     {
107         owner = newOwner_;
108     }
109     
110     function assignOperator(address user_)
111         public
112         onlyOwner
113     {
114         if(user_ != address(0) && !authbook[user_]) {
115             authbook[user_] = true;
116             operators.push(user_);
117         }
118     }
119     
120     function dismissOperator(address user_)
121         public
122         onlyOwner
123     {
124         delete authbook[user_];
125         for(uint i = 0; i < operators.length; i++) {
126             if(operators[i] == user_) {
127                 operators[i] = operators[operators.length - 1];
128                 operators.length -= 1;
129             }
130         }
131     }
132 
133     function checkOperator(address user_)
134         public
135         view
136     returns(bool) {
137         return authbook[user_];
138     }
139 }
140 
141 contract StandardToken is SafeMath {
142     mapping(address => uint256) balances;
143     mapping(address => mapping (address => uint256)) allowed;
144     uint256 public totalSupply;
145 
146     event Transfer(address indexed _from, address indexed _to, uint256 _value);
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148     event Issue(address indexed _to, uint256 indexed _value);
149     event Burn(address indexed _from, uint256 indexed _value);
150 
151     /* constructure */
152     function StandardToken() public payable {}
153 
154     /* Send coins */
155     function transfer(
156         address to_,
157         uint256 amount_
158     )
159         public
160     returns(bool success) {
161         if(balances[msg.sender] >= amount_ && amount_ > 0) {
162             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
163             balances[to_] = safeAdd(balances[to_], amount_);
164             emit Transfer(msg.sender, to_, amount_);
165             return true;
166         } else {
167             return false;
168         }
169     }
170 
171     /* A contract attempts to get the coins */
172     function transferFrom(
173         address from_,
174         address to_,
175         uint256 amount_
176     ) public returns(bool success) {
177         if(balances[from_] >= amount_ && allowed[from_][msg.sender] >= amount_ && amount_ > 0) {
178             balances[to_] = safeAdd(balances[to_], amount_);
179             balances[from_] = safeSub(balances[from_], amount_);
180             allowed[from_][msg.sender] = safeSub(allowed[from_][msg.sender], amount_);
181             emit Transfer(from_, to_, amount_);
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     function balanceOf(
189         address _owner
190     )
191         constant
192         public
193     returns (uint256 balance) {
194         return balances[_owner];
195     }
196 
197     /* Allow another contract to spend some tokens in your behalf */
198     function approve(
199         address _spender,
200         uint256 _value
201     )
202         public
203     returns (bool success) {
204         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
205         allowed[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /* Approve and then communicate the approved contract in a single tx */
211     function approveAndCall(
212         address _spender,
213         uint256 _value,
214         bytes _extraData
215     )
216         public
217     returns (bool success) {    
218         if (approve(_spender, _value)) {
219             TokenRecipient(_spender).receiveApproval(msg.sender, _value, this, _extraData);
220             return true;
221         }
222     }
223 
224     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
225         return allowed[_owner][_spender];
226     }
227 }
228 
229 contract XPAAssetToken is StandardToken, Authorization {
230     // metadata
231     address[] public burners;
232     string public name;
233     string public symbol;
234     uint256 public defaultExchangeRate;
235     uint256 public constant decimals = 18;
236 
237     // constructor
238     function XPAAssetToken(
239         string symbol_,
240         string name_,
241         uint256 defaultExchangeRate_
242     )
243         public
244     {
245         totalSupply = 0;
246         symbol = symbol_;
247         name = name_;
248         defaultExchangeRate = defaultExchangeRate_ > 0 ? defaultExchangeRate_ : 0.01 ether;
249     }
250 
251     function transferOwnership(
252         address newOwner_
253     )
254         onlyOwner
255         public
256     {
257         owner = newOwner_;
258     }
259 
260     function create(
261         address user_,
262         uint256 amount_
263     )
264         public
265         onlyOperator
266     returns(bool success) {
267         if(amount_ > 0 && user_ != address(0)) {
268             totalSupply = safeAdd(totalSupply, amount_);
269             balances[user_] = safeAdd(balances[user_], amount_);
270             emit Issue(owner, amount_);
271             emit Transfer(owner, user_, amount_);
272             return true;
273         }
274     }
275 
276     function burn(
277         uint256 amount_
278     )
279         public
280     returns(bool success) {
281         require(allowToBurn(msg.sender));
282         if(amount_ > 0 && balances[msg.sender] >= amount_) {
283             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
284             totalSupply = safeSub(totalSupply, amount_);
285             emit Transfer(msg.sender, owner, amount_);
286             emit Burn(owner, amount_);
287             return true;
288         }
289     }
290 
291     function burnFrom(
292         address user_,
293         uint256 amount_
294     )
295         public
296     returns(bool success) {
297         require(allowToBurn(msg.sender));
298         if(balances[user_] >= amount_ && allowed[user_][msg.sender] >= amount_ && amount_ > 0) {
299             balances[user_] = safeSub(balances[user_], amount_);
300             totalSupply = safeSub(totalSupply, amount_);
301             allowed[user_][msg.sender] = safeSub(allowed[user_][msg.sender], amount_);
302             emit Transfer(user_, owner, amount_);
303             emit Burn(owner, amount_);
304             return true;
305         }
306     }
307 
308     function getDefaultExchangeRate(
309     )
310         public
311         view
312     returns(uint256) {
313         return defaultExchangeRate;
314     }
315 
316     function getSymbol(
317     )
318         public
319         view
320     returns(bytes32) {
321         return keccak256(symbol);
322     }
323 
324     function assignBurner(
325         address account_
326     )
327         public
328         onlyOperator
329     {
330         require(account_ != address(0));
331         for(uint256 i = 0; i < burners.length; i++) {
332             if(burners[i] == account_) {
333                 return;
334             }
335         }
336         burners.push(account_);
337     }
338 
339     function dismissBunner(
340         address account_
341     )
342         public
343         onlyOperator
344     {
345         require(account_ != address(0));
346         for(uint256 i = 0; i < burners.length; i++) {
347             if(burners[i] == account_) {
348                 burners[i] = burners[burners.length - 1];
349                 burners.length -= 1;
350             }
351         }
352     }
353 
354     function allowToBurn(
355         address account_
356     )
357         public
358         view
359     returns(bool) {
360         if(checkOperator(account_)) {
361             return true;
362         }
363         for(uint256 i = 0; i < burners.length; i++) {
364             if(burners[i] == account_) {
365                 return true;
366             }
367         }
368     }
369 }
370 
371 contract TokenFactory is Authorization {
372     string public version = "0.5.0";
373 
374     event eNominatingExchange(address);
375     event eNominatingXPAAssets(address);
376     event eNominatingETHAssets(address);
377     event eCancelNominatingExchange(address);
378     event eCancelNominatingXPAAssets(address);
379     event eCancelNominatingETHAssets(address);
380     event eChangeExchange(address, address);
381     event eChangeXPAAssets(address, address);
382     event eChangeETHAssets(address, address);
383     event eAddFundAccount(address);
384     event eRemoveFundAccount(address);
385 
386     address[] public assetTokens;
387     address[] public fundAccounts;
388     address public exchange = 0x008ea74569c1b9bbb13780114b6b5e93396910070a;
389     address public exchangeOldVersion = 0x0013b4b9c415213bb2d0a5d692b6f2e787b927c211;
390     address public XPAAssets = address(0);
391     address public ETHAssets = address(0);
392     address public candidateXPAAssets = address(0);
393     address public candidateETHAssets = address(0);
394     address public candidateExchange = address(0);
395     uint256 public candidateTillXPAAssets = 0;
396     uint256 public candidateTillETHAssets = 0;
397     uint256 public candidateTillExchange = 0;
398     address public XPA = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
399     address public ETH = address(0);
400 
401      /* constructor */
402     function TokenFactory(
403         address XPAAddr, 
404         address balivAddr
405     ) public {
406         XPA = XPAAddr;
407         exchange = balivAddr;
408     }
409 
410     function createToken(
411         string symbol_,
412         string name_,
413         uint256 defaultExchangeRate_
414     )
415         public
416     returns(address) {
417         require(msg.sender == XPAAssets);
418         bool tokenRepeat = false;
419         address newAsset;
420         for(uint256 i = 0; i < assetTokens.length; i++) {
421             if(XPAAssetToken(assetTokens[i]).getSymbol() == keccak256(symbol_)){
422                 tokenRepeat = true;
423                 newAsset = assetTokens[i];
424                 break;
425             }
426         }
427         if(!tokenRepeat){
428             newAsset = new XPAAssetToken(symbol_, name_, defaultExchangeRate_);
429             XPAAssetToken(newAsset).assignOperator(XPAAssets);
430             XPAAssetToken(newAsset).assignOperator(ETHAssets);
431             for(uint256 j = 0; j < fundAccounts.length; j++) {
432                 XPAAssetToken(newAsset).assignBurner(fundAccounts[j]);
433             }
434             assetTokens.push(newAsset);
435         }
436         return newAsset;
437     }
438 
439     // set to candadite, after 7 days set to exchange, set again after 7 days
440     function setExchange(
441         address exchange_
442     )
443         public
444         onlyOperator
445     {
446         require(
447             exchange_ != address(0)
448         );
449         if(
450             exchange_ == exchange &&
451             candidateExchange != address(0)
452         ) {
453             emit eCancelNominatingExchange(candidateExchange);
454             candidateExchange = address(0);
455             candidateTillExchange = 0;
456         } else if(
457             exchange == address(0)
458         ) {
459             // initial value
460             emit eChangeExchange(address(0), exchange_);
461             exchange = exchange_;
462             exchangeOldVersion = exchange_;
463         } else if(
464             exchange_ != candidateExchange &&
465             candidateTillExchange + 86400 * 7 < block.timestamp
466         ) {
467             // set to candadite
468             emit eNominatingExchange(exchange_);
469             candidateExchange = exchange_;
470             candidateTillExchange = block.timestamp + 86400 * 7;
471         } else if(
472             exchange_ == candidateExchange &&
473             candidateTillExchange < block.timestamp
474         ) {
475             // set to exchange
476             emit eChangeExchange(exchange, candidateExchange);
477             exchangeOldVersion = exchange;
478             exchange = candidateExchange;
479             candidateExchange = address(0);
480         }
481     }
482 
483     function setXPAAssets(
484         address XPAAssets_
485     )
486         public
487         onlyOperator
488     {
489         require(
490             XPAAssets_ != address(0)
491         );
492         if(
493             XPAAssets_ == XPAAssets &&
494             candidateXPAAssets != address(0)
495         ) {
496             emit eCancelNominatingXPAAssets(candidateXPAAssets);
497             candidateXPAAssets = address(0);
498             candidateTillXPAAssets = 0;
499         } else if(
500             XPAAssets == address(0)
501         ) {
502             // initial value
503             emit eChangeXPAAssets(address(0), XPAAssets_);
504             XPAAssets = XPAAssets_;
505         } else if(
506             XPAAssets_ != candidateXPAAssets &&
507             candidateTillXPAAssets + 86400 * 7 < block.timestamp
508         ) {
509             // set to candadite
510             emit eNominatingXPAAssets(XPAAssets_);
511             candidateXPAAssets = XPAAssets_;
512             candidateTillXPAAssets = block.timestamp + 86400 * 7;
513         } else if(
514             XPAAssets_ == candidateXPAAssets &&
515             candidateTillXPAAssets < block.timestamp
516         ) {
517             // set to XPAAssets
518             emit eChangeXPAAssets(XPAAssets, candidateXPAAssets);
519             dismissTokenOperator(XPAAssets);
520             assignTokenOperator(candidateXPAAssets);
521             XPAAssets = candidateXPAAssets;
522             candidateXPAAssets = address(0);
523         }
524     }
525 
526     function setETHAssets(
527         address ETHAssets_
528     )
529         public
530         onlyOperator
531     {
532         require(
533             ETHAssets_ != address(0)
534         );
535         if(
536             ETHAssets_ == ETHAssets &&
537             candidateETHAssets != address(0)
538         ) {
539             emit eCancelNominatingETHAssets(candidateETHAssets);
540             candidateETHAssets = address(0);
541             candidateTillETHAssets = 0;
542         } else if(
543             ETHAssets == address(0)
544         ) {
545             // initial value
546             ETHAssets = ETHAssets_;
547         } else if(
548             ETHAssets_ != candidateETHAssets &&
549             candidateTillETHAssets + 86400 * 7 < block.timestamp
550         ) {
551             // set to candadite
552             emit eNominatingETHAssets(ETHAssets_);
553             candidateETHAssets = ETHAssets_;
554             candidateTillETHAssets = block.timestamp + 86400 * 7;
555         } else if(
556             ETHAssets_ == candidateETHAssets &&
557             candidateTillETHAssets < block.timestamp
558         ) {
559             // set to ETHAssets
560             emit eChangeETHAssets(ETHAssets, candidateETHAssets);
561             dismissTokenOperator(ETHAssets);
562             assignTokenOperator(candidateETHAssets);
563             ETHAssets = candidateETHAssets;
564             candidateETHAssets = address(0);
565         }
566     }
567 
568     function addFundAccount(
569         address account_
570     )
571         public
572         onlyOperator
573     {
574         require(account_ != address(0));
575         for(uint256 i = 0; i < fundAccounts.length; i++) {
576             if(fundAccounts[i] == account_) {
577                 return;
578             }
579         }
580         for(uint256 j = 0; j < assetTokens.length; j++) {
581             XPAAssetToken(assetTokens[i]).assignBurner(account_);
582         }
583         emit eAddFundAccount(account_);
584         fundAccounts.push(account_);
585     }
586 
587     function removeFundAccount(
588         address account_
589     )
590         public
591         onlyOperator
592     {
593         require(account_ != address(0));
594         uint256 i = 0;
595         uint256 j = 0;
596         for(i = 0; i < fundAccounts.length; i++) {
597             if(fundAccounts[i] == account_) {
598                 for(j = 0; j < assetTokens.length; j++) {
599                     XPAAssetToken(assetTokens[i]).dismissBunner(account_);
600                 }
601                 fundAccounts[i] = fundAccounts[fundAccounts.length - 1];
602                 fundAccounts.length -= 1;
603             }
604         }
605     }
606 
607     function getPrice(
608         address token_
609     ) 
610         public
611         view
612     returns(uint256) {
613         uint256 currPrice = Baliv(exchange).getPrice(XPA, token_);
614         if(currPrice == 0) {
615             currPrice = XPAAssetToken(token_).getDefaultExchangeRate();
616         }
617         return currPrice;
618     }
619 
620     function getAssetLength(
621     )
622         public
623         view
624     returns(uint256) {
625         return assetTokens.length;
626     }
627 
628     function getAssetToken(
629         uint256 index_
630     )
631         public
632         view
633     returns(address) {
634         return assetTokens[index_];
635     }
636 
637     function assignTokenOperator(address user_)
638         internal
639     {
640         if(user_ != address(0)) {
641             for(uint256 i = 0; i < assetTokens.length; i++) {
642                 XPAAssetToken(assetTokens[i]).assignOperator(user_);
643             }
644         }
645     }
646     
647     function dismissTokenOperator(address user_)
648         internal
649     {
650         if(user_ != address(0)) {
651             for(uint256 i = 0; i < assetTokens.length; i++) {
652                 XPAAssetToken(assetTokens[i]).dismissOperator(user_);
653             }
654         }
655     }
656 }