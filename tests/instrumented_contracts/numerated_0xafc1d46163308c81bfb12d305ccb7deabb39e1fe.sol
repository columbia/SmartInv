1 pragma solidity ^0.4.25;
2 
3 /*
4 * http://ethedge.tech
5 * http://epictoken.dnsup.net/ (backup)
6 *
7 * Decentralized token exchange concept
8 * A sustainable business model (non-zero-sum game)
9 *
10 * [✓] 3% Withdraw fee
11 * [✓] 5+15+1%+1%=22% Deposit fee
12 *       15% Trade capital fee. Use to do profit on different crypto assets and pay dividends back, if success.
13 *       5% To token holders
14 *       1% Marketing costs
15 *       1% Devs costs
16 * [✓] 1% Token transfer - free tokens transfer.
17 * [✓] 15% Referal link. Lifetime.
18 *
19 * ---How to use:
20 *  1. Send from ETH wallet to the smart contract address any amount ETH.
21 *  2.   1) Reinvest your profit by sending 0.00000001 ETH transaction to contract address
22 *       2) Claim your profit by sending 0.00000002 ETH transaction to contract address
23 *       3) Full exit (sell all and withdraw) by sending 0.00000003 ETH transaction to contract address
24 *  3. If you have innactive period more than 1 year - your account can be burned. Funds divided for token holders.
25 *  4. We use trade capital to invest to different crypto assets
26 *  5. Top big token holders can request audit.
27 */
28 
29 
30     interface DevsInterface {
31     function payDividends(string _sourceDesc) public payable;
32 }
33 
34 contract ETHedgeToken {
35 
36     modifier onlyBagholders {
37         require(myTokens() > 0);
38         _;
39     }
40 
41     modifier onlyStronghands {
42         require(myDividends(true) > 0);
43         _;
44     }
45     
46     //added section
47     //Modifier that only allows owner of the bag to Smart Contract AKA Good to use the function
48     modifier onlyOwner{
49         require(msg.sender == owner_, "Only owner can do this!");
50         _;
51     }
52     
53     event onPayDividends(
54         uint256 incomingDividends,
55         string sourceDescription,
56         address indexed customerAddress,
57         uint timestamp
58 );
59 
60     event onBurn(
61         uint256 DividentsFromNulled,
62         address indexed customerAddress,
63         address indexed senderAddress,
64         uint timestamp
65 );
66 
67     event onNewRefferal(
68         address indexed userAddress,
69         address indexed refferedByAddress,
70         uint timestamp
71 );
72 
73     event onTakeCapital(
74         address indexed capitalAddress,
75         address marketingAddress,
76         address devAddress,
77         uint256 capitalEth,
78         uint256 marketingEth,
79         uint256 devEth,
80         address indexed senderAddress,
81         uint timestamp
82 );
83 
84     event Approval(
85         address indexed tokenOwner,
86         address indexed spender,
87         uint tokens
88 );
89 
90 //end added section
91     event onTokenPurchase(
92         address indexed customerAddress,
93         uint256 incomingEthereum,
94         uint256 tokensMinted,
95         address indexed referredBy,
96         uint timestamp,
97         uint256 price
98 );
99 
100     event onTokenSell(
101         address indexed customerAddress,
102         uint256 tokensBurned,
103         uint256 ethereumEarned,
104         uint timestamp,
105         uint256 price
106 );
107 
108     event onReinvestment(
109         address indexed customerAddress,
110         uint256 ethereumReinvested,
111         uint256 tokensMinted
112 );
113 
114     event onWithdraw(
115         address indexed customerAddress,
116         uint256 ethereumWithdrawn
117 );
118 
119     event Transfer(
120         address indexed from,
121         address indexed to,
122         uint256 tokens
123 );
124 
125     string public name = "ETH hedge token";
126     string public symbol = "EHT";
127     uint8 constant public decimals = 18;
128     uint8 constant internal entryFee_ = 22;
129     uint8 constant internal transferFee_ = 1;
130     uint8 constant internal exitFee_ = 3;
131     uint8 constant internal refferalFee_ = 15;
132     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
134     uint256 constant internal magnitude = 2 ** 64;
135     uint256 public stakingRequirement = 50e18;
136     mapping(address => uint256) internal tokenBalanceLedger_;
137     mapping(address => uint256) internal referralBalance_;
138     mapping(address => int256) internal payoutsTo_;
139     mapping(address => address) internal refferals_;
140     // Owner of account approves the transfer of an amount to another account. ERC20 needed.
141     mapping(address => mapping (address => uint256)) allowed_;
142     uint256 internal tokenSupply_;
143     uint256 internal profitPerShare_;
144     //added section
145     address private owner_=msg.sender;
146     mapping(address => uint256) internal lastupdate_;
147     //time through your account cant be nulled
148     uint private constant timePassive_ = 365 days;
149     //uint private constant timePassive_ = 1 minutes; // for test
150     
151     uint8 constant internal entryFeeCapital_ = 15;//Percents go to capital
152     uint8 constant internal entryFeeMarketing_ = 1;//Marketing reward percent
153     uint8 constant internal entryFeeDevs_ = 1;//Developer reward percent
154     address public capital_=msg.sender;
155     address public marketingReward_=msg.sender;
156     //address public devsReward_=0xf713832e70fAF38491F5986F750bE062c394eb38; //this is contract! testnet
157     address public devsReward_=0xfc81655585F2F3935895C1409b332AB797D90B33; //this is contract!
158     uint256 public capitalAmount_;
159     uint256 public marketingRewardAmount_;
160     uint256 public devsRewardAmount_;
161     
162     
163     //This function transfer ownership of contract from one entity to another
164     function transferOwnership(address _newOwner) public onlyOwner{
165         require(_newOwner != address(0));
166         owner_ = _newOwner;
167     }
168     
169     //This function change addresses for exchange capital,marketing and devs reward
170     function changeOuts(address _newCapital, address _newMarketing, address _newDevs) public onlyOwner{
171         //check if not empty
172         require(_newCapital != address(0) && _newMarketing != 0x0 && _newDevs != 0x0);
173         capital_ = _newCapital;
174         marketingReward_ = _newMarketing;
175         devsReward_ = _newDevs;
176     }
177 
178     //Pay dividends
179     function payDividends(string _sourceDesc) public payable {
180         payDivsValue(msg.value,_sourceDesc);
181     }
182 
183     //Pay dividends internal with value
184     function payDivsValue(uint256 _amountOfDivs,string _sourceDesc) internal {
185         address _customerAddress = msg.sender;
186         uint256 _dividends = _amountOfDivs;
187         if (tokenSupply_ > 0) {
188             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
189         }
190         emit onPayDividends(_dividends,_sourceDesc,_customerAddress,now);
191     }
192 
193     //If account dont have buy, sell, reinvest, transfer(from), trasfer(to, if more stakingRequirement) action for 1 year - it can be burned. All ETH go to dividends
194     function burn(address _checkForInactive) public {
195         address _customerAddress = _checkForInactive;
196         require(lastupdate_[_customerAddress]!=0 && now >= SafeMath.add(lastupdate_[_customerAddress],timePassive_), "This account cant be nulled!");
197         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
198         if (_tokens > 0) sell(_tokens);
199         
200         uint256 _dividends = dividendsOf(_customerAddress);
201         _dividends += referralBalance_[_customerAddress];
202         payDivsValue(_dividends,'Burn coins');
203 
204         delete tokenBalanceLedger_[_customerAddress];
205         delete referralBalance_[_customerAddress];
206         delete payoutsTo_[_customerAddress];
207         delete lastupdate_[_customerAddress];
208         emit onBurn(_dividends,_customerAddress,msg.sender,now);
209     }
210   
211     //Owner can get trade capital and reward 
212     function takeCapital() public{
213         require(capitalAmount_>0 && marketingRewardAmount_>0, "No fundz, sorry!");
214         uint256 capitalAmountTrans=capitalAmount_;
215         uint256 marketingAmountTrans=marketingRewardAmount_;
216         uint256 devsAmountTrans=devsRewardAmount_;
217         capitalAmount_=0;
218         marketingRewardAmount_=0;
219         devsRewardAmount_=0;
220 //        capital_.transfer(capitalAmountTrans); // to trade capital
221         capital_.call.value(capitalAmountTrans)(); // to trade capital, can use another contract
222         marketingReward_.call.value(marketingAmountTrans)(); // to marketing and support, can use another contract
223         DevsInterface devContract_ = DevsInterface(devsReward_);
224         devContract_.payDividends.value(devsAmountTrans)('ethedge.tech source');
225 
226         emit onTakeCapital(capital_,marketingReward_,devsReward_,capitalAmountTrans,marketingAmountTrans,devsAmountTrans,msg.sender,now);
227     }
228     
229      // Send `tokens` amount of tokens from address `from` to address `to`
230     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
231     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
232     // fees in sub-currencies; the command should fail unless the _from account has
233     // deliberately authorized the sender of the message via some mechanism; we propose
234     // these standardized APIs for approval:
235      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
236         uint256 allowance = allowed_[_from][_to];
237         uint256 _amountOfTokens=_value;
238         require(tokenBalanceLedger_[_from] >= _amountOfTokens && allowance >= _amountOfTokens);
239         if ((dividendsOf(_from) + referralBalance_[_from])>0){
240             withdrawAddr(_from);
241         }
242         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
243         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
244         uint256 _dividends = tokensToEthereum_(_tokenFee);
245         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
246         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from],_amountOfTokens);
247         tokenBalanceLedger_[_to] =SafeMath.add(tokenBalanceLedger_[_to],_taxedTokens);
248         payoutsTo_[_from] -= (int256) (profitPerShare_ * _amountOfTokens);
249         payoutsTo_[_to] += (int256) (profitPerShare_ * _taxedTokens);
250         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
251         allowed_[_from][_to] = SafeMath.sub(allowed_[_from][_to],_amountOfTokens);
252         emit Transfer(_from, _to, _amountOfTokens);
253         return true;
254     }
255  
256     function approve(address _spender, uint256 _value) public returns (bool success) {
257         allowed_[msg.sender][_spender] = _value;
258         emit Approval(msg.sender, _spender, _value);
259         return true;
260     }
261 
262     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
263         return allowed_[_owner][_spender];
264     }
265     //end added section
266     
267     function buy(address _referredBy) public payable returns (uint256) {
268         purchaseTokens(msg.value, _referredBy);
269     }
270 
271     function() payable public {
272         if (msg.value == 1e10) {
273             reinvest();
274         }
275         else if (msg.value == 2e10) {
276             withdraw();
277         }
278         else if (msg.value == 3e10) {
279             exit();
280         }
281         else {
282             purchaseTokens(msg.value, 0x0);
283         }
284     }
285 
286     function reinvest() onlyStronghands public {
287         uint256 _dividends = myDividends(false);
288         address _customerAddress = msg.sender;
289         lastupdate_[_customerAddress] = now;
290         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
291         _dividends += referralBalance_[_customerAddress];
292         referralBalance_[_customerAddress] = 0;
293         uint256 _tokens = purchaseTokens(_dividends, 0x0);
294         emit onReinvestment(_customerAddress, _dividends, _tokens);
295     }
296 
297     function exit() public {
298         address _customerAddress = msg.sender;
299         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
300         if (_tokens > 0) sell(_tokens);
301         withdraw();
302     }
303 
304     function withdraw() onlyStronghands public {
305         address _customerAddress = msg.sender;
306         withdrawAddr(_customerAddress);
307     }
308 
309     function withdrawAddr(address _fromAddress) onlyStronghands internal {
310         address _customerAddress = _fromAddress;
311         lastupdate_[_customerAddress] = now;
312         uint256 _dividends = myDividends(false);
313         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
314         _dividends += referralBalance_[_customerAddress];
315         referralBalance_[_customerAddress] = 0;
316         _customerAddress.transfer(_dividends);
317         emit onWithdraw(_customerAddress, _dividends);
318     }
319 
320     function sell(uint256 _amountOfTokens) onlyBagholders public {
321         address _customerAddress = msg.sender;
322         lastupdate_[_customerAddress] = now;
323         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
324         uint256 _tokens = _amountOfTokens;
325         uint256 _ethereum = tokensToEthereum_(_tokens);
326         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
327         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
328 
329         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
330         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
331 
332         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
333         payoutsTo_[_customerAddress] -= _updatedPayouts;
334 
335         if (tokenSupply_ > 0) {
336             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         }
338         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
339     }
340 
341     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
342         address _customerAddress = msg.sender;
343         lastupdate_[_customerAddress] = now;
344         if (_amountOfTokens>stakingRequirement) {
345             lastupdate_[_toAddress] = now;
346         }
347         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
348 
349         if (myDividends(true) > 0) {
350             withdraw();
351         }
352 
353         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
354         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
355         uint256 _dividends = tokensToEthereum_(_tokenFee);
356 
357         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
358         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
359         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
360         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
361         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
362         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
363         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
364         return true;
365     }
366 
367 
368     function totalEthereumBalance() public view returns (uint256) {
369         return address(this).balance;
370     }
371 
372     function totalSupply() public view returns (uint256) {
373         return tokenSupply_;
374     }
375 
376     function refferedBy(address _customerAddress) public view returns (address) {
377         return refferals_[_customerAddress];
378     }
379 
380     function myTokens() public view returns (uint256) {
381         address _customerAddress = msg.sender;
382         return balanceOf(_customerAddress);
383     }
384 
385     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
386         address _customerAddress = msg.sender;
387         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
388     }
389 
390     function balanceOf(address _customerAddress) public view returns (uint256) {
391         return tokenBalanceLedger_[_customerAddress];
392     }
393 
394     function dividendsOf(address _customerAddress) public view returns (uint256) {
395         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
396     }
397 
398     function sellPrice() public view returns (uint256) {
399         // our calculation relies on the token supply, so we need supply. Doh.
400         if (tokenSupply_ == 0) {
401             return tokenPriceInitial_ - tokenPriceIncremental_;
402         } else {
403             uint256 _ethereum = tokensToEthereum_(1e18);
404             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
405             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
406 
407             return _taxedEthereum;
408         }
409     }
410 
411     function buyPrice() public view returns (uint256) {
412         if (tokenSupply_ == 0) {
413             return tokenPriceInitial_ + tokenPriceIncremental_;
414         } else {
415             uint256 _ethereum = tokensToEthereum_(1e18);
416             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
417             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
418 
419             return _taxedEthereum;
420         }
421     }
422 
423     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
424         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
425         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
426         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
427 
428         return _amountOfTokens;
429     }
430 
431     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
432         require(_tokensToSell <= tokenSupply_);
433         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
434         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
435         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
436         return _taxedEthereum;
437     }
438 
439     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
440         address _customerAddress = msg.sender;
441         lastupdate_[_customerAddress] = now;
442         
443         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_-entryFeeCapital_-entryFeeMarketing_-entryFeeDevs_), 100);
444 //        uint256 _capitalTrade = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeCapital_), 100);
445 //        uint256 _marketingReward = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeMarketing_), 100);
446 //        uint256 _devsReward = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeDevs_), 100);
447         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
448         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
449         uint256 _taxedEthereum = SafeMath.div(SafeMath.mul(_incomingEthereum, 100-entryFee_), 100);
450         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
451         uint256 _fee = _dividends * magnitude;
452         
453         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
454 
455 //set refferal. lifetime
456         if (
457             _referredBy != 0x0000000000000000000000000000000000000000 &&
458             _referredBy != _customerAddress &&
459             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
460             refferals_[_customerAddress] == 0x0
461         ) {
462             refferals_[_customerAddress] = _referredBy;
463             emit onNewRefferal(_customerAddress,_referredBy, now);
464         }
465 
466 //use refferal
467         if (
468             refferals_[_customerAddress] != 0x0 &&
469             tokenBalanceLedger_[refferals_[_customerAddress]] >= stakingRequirement
470         ) {
471             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
472         } else {
473             _dividends = SafeMath.add(_dividends, _referralBonus);
474             _fee = _dividends * magnitude;
475         }
476 
477         if (tokenSupply_ > 0) {
478             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
479             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
480             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
481         } else {
482             tokenSupply_ = _amountOfTokens;
483         }
484 
485         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
486         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
487         payoutsTo_[_customerAddress] += _updatedPayouts;
488 
489         capitalAmount_=SafeMath.add(capitalAmount_,SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeCapital_), 100));
490         marketingRewardAmount_=SafeMath.add(marketingRewardAmount_,SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeMarketing_), 100));
491         devsRewardAmount_=SafeMath.add(devsRewardAmount_,SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeDevs_), 100));
492         if (capitalAmount_>1e17){ //more than 0.1 ETH - send outs
493             takeCapital();
494         }
495 
496         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
497 
498         return _amountOfTokens;
499     }
500 
501     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
502         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
503         uint256 _tokensReceived =
504             (
505                 (
506                     SafeMath.sub(
507                         (sqrt
508                             (
509                                 (_tokenPriceInitial ** 2)
510                                 +
511                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
512                                 +
513                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
514                                 +
515                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
516                             )
517                         ), _tokenPriceInitial
518                     )
519                 ) / (tokenPriceIncremental_)
520             ) - (tokenSupply_);
521 
522         return _tokensReceived;
523     }
524 
525     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
526         uint256 tokens_ = (_tokens + 1e18);
527         uint256 _tokenSupply = (tokenSupply_ + 1e18);
528         uint256 _etherReceived =
529             (
530                 SafeMath.sub(
531                     (
532                         (
533                             (
534                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
535                             ) - tokenPriceIncremental_
536                         ) * (tokens_ - 1e18)
537                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
538                 )
539                 / 1e18);
540 
541         return _etherReceived;
542     }
543 
544     function sqrt(uint256 x) internal pure returns (uint256 y) {
545         uint256 z = (x + 1) / 2;
546         y = x;
547 
548         while (z < y) {
549             y = z;
550             z = (x / z + z) / 2;
551         }
552     }
553 
554 
555 }
556 
557 library SafeMath {
558     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
559         if (a == 0) {
560             return 0;
561         }
562         uint256 c = a * b;
563         assert(c / a == b);
564         return c;
565     }
566 
567     function div(uint256 a, uint256 b) internal pure returns (uint256) {
568         uint256 c = a / b;
569         return c;
570     }
571 
572     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
573         assert(b <= a);
574         return a - b;
575     }
576 
577     function add(uint256 a, uint256 b) internal pure returns (uint256) {
578         uint256 c = a + b;
579         assert(c >= a);
580         return c;
581     }
582 }