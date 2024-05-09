1 pragma solidity ^0.5.15;
2 
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint256 supply);
6 
7     function balanceOf(address _owner) external view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value)
10         external
11         returns (bool success);
12 
13     function transferFrom(
14         address _from,
15         address _to,
16         uint256 _value
17     ) external returns (bool success);
18 
19     function approve(address _spender, uint256 _value)
20         external
21         returns (bool success);
22 
23     function allowance(address _owner, address _spender)
24         external
25         view
26         returns (uint256 remaining);
27 
28     function decimals() external view returns (uint256 digits);
29 
30     event Approval(
31         address indexed _owner,
32         address indexed _spender,
33         uint256 _value
34     );
35 }
36 
37 
38 contract HexDex {
39     /*=================================
40   =            MODIFIERS            =
41   =================================*/
42     // only people with tokens
43     modifier onlyBagholders() {
44         require(myTokens() > 0);
45         _;
46     }
47 
48     // only people with profits
49     modifier onlyStronghands() {
50         require(myDividends(true) > 0);
51         _;
52     }
53 
54     modifier onlyAdmin() {
55         require(msg.sender == administrator);
56         _;
57     }
58 
59     /*==============================
60   =            EVENTS            =
61   ==============================*/
62     event onTokenPurchase(
63         address indexed customerAddress,
64         bytes32 customerName,
65         uint256 incomingEthereum,
66         uint256 tokensMinted,
67         address indexed referredBy,
68         bool isReinvest
69     );
70 
71     event onTokenSell(
72         address indexed customerAddress,
73         bytes32 customerName,
74         uint256 tokensBurned,
75         uint256 ethereumEarned
76     );
77 
78     event onWithdraw(
79         address indexed customerAddress,
80         bytes32 customerName,
81         uint256 ethereumWithdrawn
82     );
83 
84     // ERC20
85     event Transfer(address indexed from, address indexed to, uint256 tokens);
86 
87     /*=====================================
88   =            CONFIGURABLES            =
89   =====================================*/
90     string public name = "HexDex";
91     string public symbol = "H3D";
92     uint8 public constant decimals = 8;
93     uint8 internal constant dividendFee_ = 10; // 10%
94     uint256 internal constant HEX_CENT = 1e6;
95     uint256 internal constant HEX = 1e8;
96     uint256 internal constant tokenPriceInitial_ = 1 * HEX;
97     uint256 internal constant tokenPriceIncremental_ = 10 * HEX_CENT;
98     uint256 internal constant magnitude = 2**64;
99     address internal constant tokenAddress = address(
100         0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39
101     );
102 
103     uint256 internal cubeStartTime = now;
104 
105     // admin for premine lock
106     address internal administrator;
107 
108     // ambassadors
109     uint256 ambassadorLimit = HEX * 20000; // 20k hex per ambassador
110     uint256 devLimit = HEX * 100000;
111     mapping(address => bool) public ambassadors; // who the ambassadors are
112     mapping(address => bool) public dev;
113 
114     address[33] ambassadorList = [
115         0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f,
116         0xe8f49490d2b172870b3B225e9fcD39b5D68b2e9E,
117         0x5161e1380cd661D7d993c8a3b3E57b059Ad8d7A4,
118         0x4Ca9046dcd4C8712450250208D7eD6fCEbAf75a5,
119         0xC697BE0b5b82284391A878B226e2f9AfC6B94710,
120         0x5cB87df0834cd82297C63eF075421401995914ae,
121         0x53F403421110BA93086BCFB40e80C7346035aDF6,
122         0x11ba6C4732B1a7f30deA51C23b8ED4c1F88dCD57,
123         0xb7032661C1DA18A52830A5e97bdE5569ed3c2A5F,
124         0x73c371F85246797e4f7f68F7F46b9261EBa2F853,
125         0xffc1eD0C150890c163D940146565df6064588d3e,
126         0x5DD516f5dC0E68C5A37D20284Dabd754e35AfF1c,
127         0x554fdECe1B1319075d7Bf2F5137076C21A202249,
128         0xcF7b442C41795e874b223D4ADeED8cda87A23d00,
129         0x87cb806192eC699398511c7aB44b3595C051D13C,
130         0x1c2c72269ce1aD29933F090547b4102a9c398f34,
131         0x9b411116f92504562EDCf3a1b14Ae226Bc1489Fc,
132         0x2E7E5DE7D87A29B16284092B19891c80B0F43eCa,
133         0xada8694dd1B511E72F467e7242E7123088aED064,
134         0x5269BF8720946b5c38FBf361a947bA9D30C91313,
135         0x21e0111e60D5449BdBa67ee6c014B5384644a714,
136         0xB96d8107D613b6b593b4531Fc353B282af7fbeF5,
137         0x71A4b5895A077806E8cd9F85a5253A9DEbd593fD,
138         0x73018870D10173ae6F71Cac3047ED3b6d175F274,
139         0x8E2Efa9eD16f07d9B153D295d35025FD677BaE99,
140         0x112b3496AAD76CD34a29C335266A968D65fBa10a,
141         0x9D7a76fD386eDEB3A871c3A096Ca875aDc1a55b7,
142         0x05227e4FA98a6415ef1927E902dc781AA7eD518a,
143         0x18600fE707D883c1FD16f002A09241D630270233,
144         0x8ec43a855007c61Ce75406DB8b2079207F7d597a,
145         0x09a054B60bd3B908791B55eEE81b515B93831E99,
146         0x982D72A38A2CB0ed8F2fae5B22C122f1C9c89a13,
147         0xa683C1b815997a7Fa38f6178c84675FC4c79AC2B
148     ];
149 
150     address[10] devList = [
151         0x818F1B08E38376E9635C5bE156B8786317e833b3,
152         0xa765a22C97c38c8Ce50FEA453cE92723C7637AA2,
153         0xEe54D208f62368B4efFe176CB548A317dcAe963F,
154         0x43678bB266e75F50Fbe5927128Ab51930b447eaB,
155         0x5138240E96360ad64010C27eB0c685A8b2eDE4F2,
156         0x39E00115d71313fD5983DE3Cf2b5820dd3Cc4447,
157         0xcFAa3449DFfB82Bf5B37e42FbCf43170c6C8e4AD,
158         0x90D20d17Cc9e07020bB490c5e34f486286d3Eeb2,
159         0x074F21a36217d7615d0202faA926aEFEBB5a9999,
160         0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6
161     ];
162 
163     uint256 numAmbassadorsDeposited;
164 
165     function depositPremine() public {
166         require(ambassadors[msg.sender]); // require them to be an ambassador
167         ambassadors[msg.sender] = false; // make them not an ambassador after this transaction! so they can't buy in twice
168         ERC20 Hex = ERC20(tokenAddress);
169 
170         // you must deposit EXACTLY 20k
171         Hex.transferFrom(msg.sender, address(this), ambassadorLimit);
172         numAmbassadorsDeposited++;
173     }
174 
175     uint256 numDevDeposited;
176 
177     function depositDevPremine() public {
178         require(dev[msg.sender]);
179         dev[msg.sender] = false;
180         ERC20 Hex = ERC20(tokenAddress);
181 
182         Hex.transferFrom(msg.sender, address(this), devLimit);
183         numDevDeposited++;
184     }
185 
186     function executePremineBuy() public onlyAdmin() {
187         require(now < cubeStartTime);
188         ERC20 Hex = ERC20(tokenAddress);
189 
190         // first buy in with 1 hex so that we don't black hole a bunch of stuff
191         Hex.transferFrom(msg.sender, address(this), 1 * HEX);
192         purchaseTokens(1 * HEX, address(0x0), false);
193 
194         // then buy in the full amount with the amount of hex in the contract minus 1
195         purchaseTokens(
196             Hex.balanceOf(address(this)) - (1 * HEX),
197             address(0x0),
198             false
199         );
200 
201         // now that we have a bunch of tokens, transfer them out to each ambassador fairly!
202         uint256 premineTokenShare = tokenSupply_ /
203             (numAmbassadorsDeposited + (numDevDeposited * 5));
204 
205         for (uint256 i = 0; i < 33; i++) {
206             // if this call returns false, it means the person is NO LONGER an ambassador - which means they HAVE deposited
207             // which means we SHOULD give them their token share!
208             if (ambassadors[ambassadorList[i]] == false) {
209                 transfer(ambassadorList[i], premineTokenShare);
210             }
211         }
212 
213         for (uint256 j = 0; j < 10; j++) {
214             // if this call returns false, it means the person is NO LONGER an ambassador - which means they HAVE deposited
215             // which means we SHOULD give them their token share!
216             if (dev[devList[j]] == false) {
217                 transfer(devList[j], premineTokenShare * 5);
218             }
219         }
220     }
221 
222     function restart() public onlyAdmin() {
223         require(now < cubeStartTime);
224         // Only called if something goes wrong during premine
225         ERC20 Hex = ERC20(tokenAddress);
226         Hex.transfer(administrator, Hex.balanceOf(address(this)));
227     }
228 
229     // username interface
230     UsernameInterface private username;
231 
232     /*================================
233   =            DATASETS            =
234   ================================*/
235     // amount of shares for each address (scaled number)
236     mapping(address => uint256) internal tokenBalanceLedger_;
237     mapping(address => uint256) internal referralBalance_;
238     mapping(address => int256) internal payoutsTo_;
239     mapping(address => bool) internal approvedDistributors;
240     uint256 internal tokenSupply_ = 0;
241     uint256 internal profitPerShare_;
242 
243     /*=======================================
244   =            PUBLIC FUNCTIONS            =
245   =======================================*/
246     /*
247      * -- APPLICATION ENTRY POINTS --
248      */
249     constructor(address usernameAddress, uint256 when_start) public {
250         ambassadors[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = true;
251         ambassadors[0xe8f49490d2b172870b3B225e9fcD39b5D68b2e9E] = true;
252         ambassadors[0x5161e1380cd661D7d993c8a3b3E57b059Ad8d7A4] = true;
253         ambassadors[0x4Ca9046dcd4C8712450250208D7eD6fCEbAf75a5] = true;
254         ambassadors[0xC697BE0b5b82284391A878B226e2f9AfC6B94710] = true;
255         ambassadors[0x5cB87df0834cd82297C63eF075421401995914ae] = true;
256         ambassadors[0x53F403421110BA93086BCFB40e80C7346035aDF6] = true;
257         ambassadors[0x11ba6C4732B1a7f30deA51C23b8ED4c1F88dCD57] = true;
258         ambassadors[0xb7032661C1DA18A52830A5e97bdE5569ed3c2A5F] = true;
259         ambassadors[0x73c371F85246797e4f7f68F7F46b9261EBa2F853] = true;
260         ambassadors[0xffc1eD0C150890c163D940146565df6064588d3e] = true;
261         ambassadors[0x5DD516f5dC0E68C5A37D20284Dabd754e35AfF1c] = true;
262         ambassadors[0x554fdECe1B1319075d7Bf2F5137076C21A202249] = true;
263         ambassadors[0xcF7b442C41795e874b223D4ADeED8cda87A23d00] = true;
264         ambassadors[0x87cb806192eC699398511c7aB44b3595C051D13C] = true;
265         ambassadors[0x1c2c72269ce1aD29933F090547b4102a9c398f34] = true;
266         ambassadors[0x9b411116f92504562EDCf3a1b14Ae226Bc1489Fc] = true;
267         ambassadors[0x2E7E5DE7D87A29B16284092B19891c80B0F43eCa] = true;
268         ambassadors[0xada8694dd1B511E72F467e7242E7123088aED064] = true;
269         ambassadors[0x5269BF8720946b5c38FBf361a947bA9D30C91313] = true;
270         ambassadors[0x21e0111e60D5449BdBa67ee6c014B5384644a714] = true;
271         ambassadors[0xB96d8107D613b6b593b4531Fc353B282af7fbeF5] = true;
272         ambassadors[0x71A4b5895A077806E8cd9F85a5253A9DEbd593fD] = true;
273         ambassadors[0x73018870D10173ae6F71Cac3047ED3b6d175F274] = true;
274         ambassadors[0x8E2Efa9eD16f07d9B153D295d35025FD677BaE99] = true;
275         ambassadors[0x112b3496AAD76CD34a29C335266A968D65fBa10a] = true;
276         ambassadors[0x9D7a76fD386eDEB3A871c3A096Ca875aDc1a55b7] = true;
277         ambassadors[0x05227e4FA98a6415ef1927E902dc781AA7eD518a] = true;
278         ambassadors[0x18600fE707D883c1FD16f002A09241D630270233] = true;
279         ambassadors[0x8ec43a855007c61Ce75406DB8b2079207F7d597a] = true;
280         ambassadors[0x09a054B60bd3B908791B55eEE81b515B93831E99] = true;
281         ambassadors[0x982D72A38A2CB0ed8F2fae5B22C122f1C9c89a13] = true;
282         ambassadors[0xa683C1b815997a7Fa38f6178c84675FC4c79AC2B] = true;
283 
284         dev[0x818F1B08E38376E9635C5bE156B8786317e833b3] = true;
285         dev[0xa765a22C97c38c8Ce50FEA453cE92723C7637AA2] = true;
286         dev[0xEe54D208f62368B4efFe176CB548A317dcAe963F] = true;
287         dev[0x43678bB266e75F50Fbe5927128Ab51930b447eaB] = true;
288         dev[0x5138240E96360ad64010C27eB0c685A8b2eDE4F2] = true;
289         dev[0x39E00115d71313fD5983DE3Cf2b5820dd3Cc4447] = true;
290         dev[0xcFAa3449DFfB82Bf5B37e42FbCf43170c6C8e4AD] = true;
291         dev[0x90D20d17Cc9e07020bB490c5e34f486286d3Eeb2] = true;
292         dev[0x074F21a36217d7615d0202faA926aEFEBB5a9999] = true;
293         dev[0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6] = true;
294 
295         username = UsernameInterface(usernameAddress);
296         cubeStartTime = when_start;
297         administrator = msg.sender;
298     }
299 
300     function startTime() public view returns (uint256 _startTime) {
301         _startTime = cubeStartTime;
302     }
303 
304     function approveDistributor(address newDistributor) public onlyAdmin() {
305         approvedDistributors[newDistributor] = true;
306     }
307 
308     /**
309      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
310      */
311     function buy(address _referredBy, uint256 amount) public returns (uint256) {
312         ERC20 Hex = ERC20(tokenAddress);
313         Hex.transferFrom(msg.sender, address(this), amount);
314         purchaseTokens(amount, _referredBy, false);
315     }
316 
317     /**
318      * refuse to receive any tokens directly sent
319      *
320      */
321     function() external payable {
322         revert();
323     }
324 
325     function distribute(uint256 amount) external payable {
326         require(approvedDistributors[msg.sender] == true);
327         ERC20 Hex = ERC20(tokenAddress);
328         Hex.transferFrom(msg.sender, address(this), amount);
329         profitPerShare_ = SafeMath.add(
330             profitPerShare_,
331             (amount * magnitude) / tokenSupply_
332         );
333     }
334 
335     /**
336      * Converts all of caller's dividends to tokens.
337      */
338     function reinvest() public onlyStronghands() {
339         // fetch dividends
340         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
341 
342         // pay out the dividends virtually
343         address _customerAddress = msg.sender;
344         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
345 
346         // retrieve ref. bonus
347         _dividends += referralBalance_[_customerAddress];
348         referralBalance_[_customerAddress] = 0;
349 
350         // dispatch a buy order with the virtualized "withdrawn dividends"
351         purchaseTokens(_dividends, address(0x0), true);
352     }
353 
354     /**
355      * Alias of sell() and withdraw().
356      */
357     function exit() public {
358         // get token count for caller & sell them all
359         address _customerAddress = msg.sender;
360         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
361         if (_tokens > 0) sell(_tokens);
362 
363         withdraw();
364     }
365 
366     /**
367      * Withdraws all of the callers earnings.
368      */
369     function withdraw() public onlyStronghands() {
370         // setup data
371         address _customerAddress = msg.sender;
372         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
373 
374         // update dividend tracker
375         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
376 
377         // add ref. bonus
378         _dividends += referralBalance_[_customerAddress];
379         referralBalance_[_customerAddress] = 0;
380 
381         // lambo delivery service
382         ERC20 Hex = ERC20(tokenAddress);
383         Hex.transfer(_customerAddress, _dividends);
384 
385         // fire event
386         emit onWithdraw(
387             _customerAddress,
388             username.getNameByAddress(msg.sender),
389             _dividends
390         );
391     }
392 
393     /**
394      * Liquifies tokens to ethereum.
395      */
396     function sell(uint256 _amountOfTokens) public onlyBagholders() {
397         // setup data
398         address _customerAddress = msg.sender;
399         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
400         uint256 _tokens = _amountOfTokens;
401         uint256 _ethereum = tokensToEthereum_(_tokens);
402         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
403         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
404 
405         // burn the sold tokens
406         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
407         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
408             tokenBalanceLedger_[_customerAddress],
409             _tokens
410         );
411 
412         // update dividends tracker
413         int256 _updatedPayouts = (int256)(
414             profitPerShare_ * _tokens + (_taxedEthereum * magnitude)
415         );
416         payoutsTo_[_customerAddress] -= _updatedPayouts;
417 
418         // dividing by zero is a bad idea
419         if (tokenSupply_ > 0) {
420             // update the amount of dividends per token
421             profitPerShare_ = SafeMath.add(
422                 profitPerShare_,
423                 (_dividends * magnitude) / tokenSupply_
424             );
425         }
426 
427         // fire event
428         emit onTokenSell(
429             _customerAddress,
430             username.getNameByAddress(msg.sender),
431             _tokens,
432             _taxedEthereum
433         );
434     }
435 
436     /**
437      * To heck with the transfer fee
438      * Who needs it
439      */
440     function transfer(address _toAddress, uint256 _amountOfTokens)
441         public
442         onlyBagholders()
443         returns (bool)
444     {
445         // setup
446         address _customerAddress = msg.sender;
447 
448         // make sure we have the requested tokens
449         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
450 
451         // withdraw all outstanding dividends first
452         if (myDividends(true) > 0) withdraw();
453 
454         // exchange tokens
455         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
456             tokenBalanceLedger_[_customerAddress],
457             _amountOfTokens
458         );
459         tokenBalanceLedger_[_toAddress] = SafeMath.add(
460             tokenBalanceLedger_[_toAddress],
461             _amountOfTokens
462         );
463 
464         // update dividend trackers
465         payoutsTo_[_customerAddress] -= (int256)(
466             profitPerShare_ * _amountOfTokens
467         );
468         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);
469 
470         // fire event
471         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
472 
473         // ERC20
474         return true;
475     }
476 
477     /*----------  HELPERS AND CALCULATORS  ----------*/
478     /**
479      * Method to view the current Ethereum stored in the contract
480      * Example: totalEthereumBalance()
481      */
482     function totalEthereumBalance() public view returns (uint256) {
483         return address(this).balance;
484     }
485 
486     /**
487      * Retrieve the total token supply.
488      */
489     function totalSupply() public view returns (uint256) {
490         return tokenSupply_;
491     }
492 
493     /**
494      * Retrieve the number of aambassadors deposited.
495      */
496     function numAmbassadorsDep() public view returns (uint256) {
497         return numAmbassadorsDeposited;
498     }
499 
500     /**
501      * Retrieve the number of developers deposited.
502      */
503     function numDevDep() public view returns (uint256) {
504         return numDevDeposited;
505     }
506 
507     /**
508      * Retrieve the tokens owned by the caller.
509      */
510     function myTokens() public view returns (uint256) {
511         address _customerAddress = msg.sender;
512         return balanceOf(_customerAddress);
513     }
514 
515     /**
516      * Retrieve the dividends owned by the caller.
517      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
518      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
519      * But in the internal calculations, we want them separate.
520      */
521     function myDividends(bool _includeReferralBonus)
522         public
523         view
524         returns (uint256)
525     {
526         address _customerAddress = msg.sender;
527         return
528             _includeReferralBonus
529                 ? dividendsOf(_customerAddress) +
530                     referralBalance_[_customerAddress]
531                 : dividendsOf(_customerAddress);
532     }
533 
534     /**
535      * Retrieve the token balance of any single address.
536      */
537     function balanceOf(address _customerAddress) public view returns (uint256) {
538         return tokenBalanceLedger_[_customerAddress];
539     }
540 
541     /**
542      * Retrieve the dividend balance of any single address.
543      */
544     function dividendsOf(address _customerAddress)
545         public
546         view
547         returns (uint256)
548     {
549         return
550             (uint256)(
551                 (int256)(
552                     profitPerShare_ * tokenBalanceLedger_[_customerAddress]
553                 ) - payoutsTo_[_customerAddress]
554             ) / magnitude;
555     }
556 
557     /**
558      * Return the sell price of 1 individual token.
559      */
560     function sellPrice() public view returns (uint256) {
561         // our calculation relies on the token supply, so we need supply.
562         if (tokenSupply_ == 0) {
563             return tokenPriceInitial_ - tokenPriceIncremental_;
564         } else {
565             uint256 _ethereum = tokensToEthereum_(1e8);
566             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
567             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
568             return _taxedEthereum;
569         }
570     }
571 
572     /**
573      * Return the buy price of 1 individual token.
574      */
575     function buyPrice() public view returns (uint256) {
576         if (tokenSupply_ == 0) {
577             return tokenPriceInitial_ + tokenPriceIncremental_;
578         } else {
579             uint256 _ethereum = tokensToEthereum_(1e8);
580             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
581             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
582             return _taxedEthereum;
583         }
584     }
585 
586     /**
587      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
588      */
589     function calculateTokensReceived(uint256 _ethereumToSpend)
590         public
591         view
592         returns (uint256)
593     {
594         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
595         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
596         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
597 
598         return _amountOfTokens;
599     }
600 
601     /**
602      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
603      */
604     function calculateEthereumReceived(uint256 _tokensToSell)
605         public
606         view
607         returns (uint256)
608     {
609         require(_tokensToSell <= tokenSupply_);
610         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
611         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
612         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
613         return _taxedEthereum;
614     }
615 
616     /*==========================================
617   =            INTERNAL FUNCTIONS            =
618   ==========================================*/
619     function purchaseTokens(
620         uint256 _incomingEthereum,
621         address _referredBy,
622         bool isReinvest
623     ) internal returns (uint256) {
624         if (now < startTime()) {
625             require(msg.sender == administrator);
626         }
627 
628         // data setup
629         uint256 _undividedDividends = SafeMath.div(
630             _incomingEthereum,
631             dividendFee_
632         );
633         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
634         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
635         uint256 _taxedEthereum = SafeMath.sub(
636             _incomingEthereum,
637             _undividedDividends
638         );
639         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
640         uint256 _fee = _dividends * magnitude;
641 
642         require(
643             _amountOfTokens > 0 &&
644                 (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_)
645         );
646 
647         // is the user referred by a masternode?
648         if (
649             // is this a referred purchase?
650             _referredBy != 0x0000000000000000000000000000000000000000 &&
651             // no cheating!
652             _referredBy != msg.sender
653         ) {
654             // wealth redistribution
655             referralBalance_[_referredBy] = SafeMath.add(
656                 referralBalance_[_referredBy],
657                 _referralBonus
658             );
659         } else {
660             // no ref purchase
661             // add the referral bonus back to the global dividends
662             _dividends = SafeMath.add(_dividends, _referralBonus);
663             _fee = _dividends * magnitude;
664         }
665 
666         // we can't give people infinite ethereum
667         if (tokenSupply_ > 0) {
668             // add tokens to the pool
669             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
670 
671             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
672             profitPerShare_ += ((_dividends * magnitude) / (tokenSupply_));
673 
674             // calculate the amount of tokens the customer receives over his purchase
675             _fee =
676                 _fee -
677                 (_fee -
678                     (_amountOfTokens *
679                         ((_dividends * magnitude) / (tokenSupply_))));
680         } else {
681             // add tokens to the pool
682             tokenSupply_ = _amountOfTokens;
683         }
684 
685         // update circulating supply & the ledger address for the customer
686         tokenBalanceLedger_[msg.sender] = SafeMath.add(
687             tokenBalanceLedger_[msg.sender],
688             _amountOfTokens
689         );
690 
691         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
692         //really i know you think you do but you don't
693         int256 _updatedPayouts = (int256)(
694             (profitPerShare_ * _amountOfTokens) - _fee
695         );
696         payoutsTo_[msg.sender] += _updatedPayouts;
697 
698         // fire event
699         emit onTokenPurchase(
700             msg.sender,
701             username.getNameByAddress(msg.sender),
702             _incomingEthereum,
703             _amountOfTokens,
704             _referredBy,
705             isReinvest
706         );
707 
708         return _amountOfTokens;
709     }
710 
711     /**
712      * Calculate Token price based on an amount of incoming ethereum
713      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
714      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
715      */
716     function ethereumToTokens_(uint256 _ethereum)
717         internal
718         view
719         returns (uint256)
720     {
721         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e8;
722         uint256 _tokensReceived = ((
723             SafeMath.sub(
724                 (
725                     sqrt(
726                         (_tokenPriceInitial**2) +
727                             (2 *
728                                 (tokenPriceIncremental_ * 1e8) *
729                                 (_ethereum * 1e8)) +
730                             (((tokenPriceIncremental_)**2) *
731                                 (tokenSupply_**2)) +
732                             (2 *
733                                 (tokenPriceIncremental_) *
734                                 _tokenPriceInitial *
735                                 tokenSupply_)
736                     )
737                 ),
738                 _tokenPriceInitial
739             )
740         ) / (tokenPriceIncremental_)) - (tokenSupply_);
741 
742         return _tokensReceived;
743     }
744 
745     /**
746      * Calculate token sell value.
747      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
748      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
749      */
750     function tokensToEthereum_(uint256 _tokens)
751         internal
752         view
753         returns (uint256)
754     {
755         uint256 tokens_ = (_tokens + 1e8);
756         uint256 _tokenSupply = (tokenSupply_ + 1e8);
757         uint256 _etherReceived = (SafeMath.sub(
758             (((tokenPriceInitial_ +
759                 (tokenPriceIncremental_ * (_tokenSupply / 1e8))) -
760                 tokenPriceIncremental_) * (tokens_ - 1e8)),
761             (tokenPriceIncremental_ * ((tokens_**2 - tokens_) / 1e8)) / 2
762         ) / 1e8);
763         return _etherReceived;
764     }
765 
766     //This is where all your gas goes apparently
767     function sqrt(uint256 x) internal pure returns (uint256 y) {
768         uint256 z = (x + 1) / 2;
769         y = x;
770         while (z < y) {
771             y = z;
772             z = (x / z + z) / 2;
773         }
774     }
775 }
776 
777 
778 interface UsernameInterface {
779     function getNameByAddress(address _addr) external view returns (bytes32);
780 }
781 
782 
783 /**
784  * @title SafeMath
785  * @dev Math operations with safety checks that throw on error
786  */
787 library SafeMath {
788     /**
789      * @dev Multiplies two numbers, throws on overflow.
790      */
791     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
792         if (a == 0) {
793             return 0;
794         }
795         uint256 c = a * b;
796         require(c / a == b);
797         return c;
798     }
799 
800     /**
801      * @dev Integer division of two numbers, truncating the quotient.
802      */
803     function div(uint256 a, uint256 b) internal pure returns (uint256) {
804         uint256 c = a / b;
805         return c;
806     }
807 
808     /**
809      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
810      */
811     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
812         require(b <= a);
813         return a - b;
814     }
815 
816     /**
817      * @dev Adds two numbers, throws on overflow.
818      */
819     function add(uint256 a, uint256 b) internal pure returns (uint256) {
820         uint256 c = a + b;
821         require(c >= a);
822         return c;
823     }
824 }