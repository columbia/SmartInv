1 pragma solidity ^0.4.25;
2 
3 /*
4 * http://ethedge.co
5 * https://gosutech.github.io (backup)
6 *
7 * Decentralized token exchange concept
8 * A sustainable business model (non-zero-sum game)
9 *
10 * [✓] 5% Withdraw fee
11 * [✓] 5+9+1%=15% Deposit fee
12 *       9% Trade capital fee. Use to do profit on different crypto assets and pay dividends back, if success.
13 *       5% To token holders
14 *       1% devs costs
15 * [✓] 1% Token transfer.
16 * [✓] 15% Referal link. Lifetime.
17 *
18 * ---How to use:
19 *  1. Send from ETH wallet to the smart contract address any amount ETH.
20 *  2.   1) Reinvest your profit by sending 0.00000001 ETH transaction to contract address
21 *       2) Claim your profit by sending 0.00000002 ETH transaction to contract address
22 *       3) Full exit (sell all and withdraw) by sending 0.00000003 ETH transaction to contract address
23 *  3. If you have innactive period more than 1 year - your account can be burned. Funds divided for token holders.
24 *  4. We use trade capital to invest to different crypto assets
25 *  5. Top big token holders can request audit.
26 */
27 
28     interface DevsInterface {
29     function payDividends(string _sourceDesc) public payable;
30 }
31 
32 
33 contract ETHedgeToken {
34 
35     modifier onlyBagholders {
36         require(myTokens() > 0);
37         _;
38     }
39 
40     modifier onlyStronghands {
41         require(myDividends(true) > 0);
42         _;
43     }
44     
45     //added section
46     //Modifier that only allows owner of the bag to Smart Contract AKA Good to use the function
47     modifier onlyOwner{
48         require(msg.sender == owner_, "Only owner can do this!");
49         _;
50     }
51     
52     event onPayDividends(
53         uint256 incomingDividends,
54         string sourceDescription,
55         address indexed customerAddress,
56         uint timestamp
57 );
58 
59     event onBurn(
60         uint256 DividentsFromNulled,
61         address indexed customerAddress,
62         address indexed senderAddress,
63         uint timestamp
64 );
65 
66     event onNewRefferal(
67         address indexed userAddress,
68         address indexed refferedByAddress,
69         uint timestamp
70 );
71 
72     event onTakeCapital(
73         address indexed capitalAddress,
74         address indexed devAddress,
75         uint256 capitalEth,
76         uint256 devEth,
77         address indexed senderAddress,
78         uint timestamp
79 );
80 
81     event Approval(
82         address indexed tokenOwner,
83         address indexed spender,
84         uint tokens
85 );
86 
87 //end added section
88     event onTokenPurchase(
89         address indexed customerAddress,
90         uint256 incomingEthereum,
91         uint256 tokensMinted,
92         address indexed referredBy,
93         uint timestamp,
94         uint256 price
95 );
96 
97     event onTokenSell(
98         address indexed customerAddress,
99         uint256 tokensBurned,
100         uint256 ethereumEarned,
101         uint timestamp,
102         uint256 price
103 );
104 
105     event onReinvestment(
106         address indexed customerAddress,
107         uint256 ethereumReinvested,
108         uint256 tokensMinted
109 );
110 
111     event onWithdraw(
112         address indexed customerAddress,
113         uint256 ethereumWithdrawn
114 );
115 
116     event Transfer(
117         address indexed from,
118         address indexed to,
119         uint256 tokens
120 );
121 
122     string public name = "ETH hedge token";
123     string public symbol = "EHT";
124     uint8 constant public decimals = 18;
125     uint8 constant internal entryFee_ = 15;//full costs
126     uint8 constant internal transferFee_ = 1;
127     uint8 constant internal exitFee_ = 5;
128     uint8 constant internal refferalFee_ = 15;
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2 ** 64;
132     uint256 public stakingRequirement = 50e18;
133     mapping(address => uint256) internal tokenBalanceLedger_;
134     mapping(address => uint256) internal referralBalance_;
135     mapping(address => int256) internal payoutsTo_;
136     mapping(address => address) internal refferals_;
137     // Owner of account approves the transfer of an amount to another account. ERC20 needed.
138     mapping(address => mapping (address => uint256)) allowed_;
139     uint256 internal tokenSupply_;
140     uint256 internal profitPerShare_;
141     //added section
142     address private owner_=msg.sender;
143     mapping(address => uint256) internal lastupdate_;
144     //time through your account cant be nulled
145     uint private constant timePassive_ = 365 days;
146     //uint private constant timePassive_ = 1 minutes; // for test
147     //Percents go to exchange bots
148     uint8 constant internal entryFeeCapital_ = 9;
149     //Admins reward percent
150     uint8 constant internal entryFeeReward_ = 1;
151     address public capital_=msg.sender;
152     address public devReward_=0xafC1D46163308c81BFb12d305CCb7deAbb39E1fE;//devs contract address
153     uint256 public capitalAmount_;
154     uint256 public AdminRewardAmount_;
155     
156     
157     //This function transfer ownership of contract from one entity to another
158     function transferOwnership(address _newOwner) public onlyOwner{
159         require(_newOwner != address(0));
160         owner_ = _newOwner;
161     }
162     
163     //This function change addresses for exchange capital and admin reward
164     function changeOuts(address _newCapital) public onlyOwner{
165         //check if not empty
166         require(_newCapital != address(0));
167         capital_ = _newCapital;
168     }
169 
170     //Pay dividends
171     function payDividends(string _sourceDesc) public payable {
172         payDivsValue(msg.value,_sourceDesc);
173     }
174 
175     //Pay dividends internal with value
176     function payDivsValue(uint256 _amountOfDivs,string _sourceDesc) internal {
177         address _customerAddress = msg.sender;
178         uint256 _dividends = _amountOfDivs;
179         if (tokenSupply_ > 0) {
180             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
181         }
182         emit onPayDividends(_dividends,_sourceDesc,_customerAddress,now);
183     }
184 
185     //If account dont have buy, sell, reinvest, transfer(from), trasfer(to, if more stakingRequirement) action for 1 year - it can be burned. All ETH go to dividends
186     function burn(address _checkForInactive) public {
187         address _customerAddress = _checkForInactive;
188         require(lastupdate_[_customerAddress]!=0 && now >= SafeMath.add(lastupdate_[_customerAddress],timePassive_), "This account cant be nulled!");
189         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
190         if (_tokens > 0) sell(_tokens);
191         
192         uint256 _dividends = dividendsOf(_customerAddress);
193         _dividends += referralBalance_[_customerAddress];
194         payDivsValue(_dividends,'Burn coins');
195 
196         delete tokenBalanceLedger_[_customerAddress];
197         delete referralBalance_[_customerAddress];
198         delete payoutsTo_[_customerAddress];
199         delete lastupdate_[_customerAddress];
200         emit onBurn(_dividends,_customerAddress,msg.sender,now);
201     }
202   
203     //Owner can get trade capital and reward 
204     function takeCapital() public{
205         require(capitalAmount_>0 && AdminRewardAmount_>0, "No fundz, sorry!");
206         uint256 capitalAmountTrans=capitalAmount_;
207         uint256 adminAmountTrans=AdminRewardAmount_;
208         capitalAmount_=0;
209         AdminRewardAmount_=0;
210 //        capital_.transfer(capitalAmountTrans); // to trade capital
211         capital_.call.value(capitalAmountTrans)(); // to trade capital, can use another contract
212         DevsInterface devContract_ = DevsInterface(devReward_);
213         devContract_.payDividends.value(adminAmountTrans)('ethedge.co source');
214         emit onTakeCapital(capital_,devReward_,capitalAmountTrans,adminAmountTrans,msg.sender,now);
215     }
216     
217      // Send `tokens` amount of tokens from address `from` to address `to`
218     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
219     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
220     // fees in sub-currencies; the command should fail unless the _from account has
221     // deliberately authorized the sender of the message via some mechanism; we propose
222     // these standardized APIs for approval:
223      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
224         uint256 allowance = allowed_[_from][_to];
225         uint256 _amountOfTokens=_value;
226         require(tokenBalanceLedger_[_from] >= _amountOfTokens && allowance >= _amountOfTokens);
227         if ((dividendsOf(_from) + referralBalance_[_from])>0){
228             withdrawAddr(_from);
229         }
230         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
231         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
232         uint256 _dividends = tokensToEthereum_(_tokenFee);
233         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
234         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from],_amountOfTokens);
235         tokenBalanceLedger_[_to] =SafeMath.add(tokenBalanceLedger_[_to],_taxedTokens);
236         payoutsTo_[_from] -= (int256) (profitPerShare_ * _amountOfTokens);
237         payoutsTo_[_to] += (int256) (profitPerShare_ * _taxedTokens);
238         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
239         allowed_[_from][_to] = SafeMath.sub(allowed_[_from][_to],_amountOfTokens);
240         emit Transfer(_from, _to, _amountOfTokens);
241         return true;
242     }
243  
244     function approve(address _spender, uint256 _value) public returns (bool success) {
245         allowed_[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
251         return allowed_[_owner][_spender];
252     }
253     //end added section
254     
255     function buy(address _referredBy) public payable returns (uint256) {
256         purchaseTokens(msg.value, _referredBy);
257     }
258 
259     function() payable public {
260         if (msg.value == 1e10) {
261             reinvest();
262         }
263         else if (msg.value == 2e10) {
264             withdraw();
265         }
266         else if (msg.value == 3e10) {
267             exit();
268         }
269         else {
270             purchaseTokens(msg.value, 0x0);
271         }
272     }
273 
274     function reinvest() onlyStronghands public {
275         uint256 _dividends = myDividends(false);
276         address _customerAddress = msg.sender;
277         lastupdate_[_customerAddress] = now;
278         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
279         _dividends += referralBalance_[_customerAddress];
280         referralBalance_[_customerAddress] = 0;
281         uint256 _tokens = purchaseTokens(_dividends, 0x0);
282         emit onReinvestment(_customerAddress, _dividends, _tokens);
283     }
284 
285     function exit() public {
286         address _customerAddress = msg.sender;
287         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
288         if (_tokens > 0) sell(_tokens);
289         withdraw();
290     }
291 
292     function withdraw() onlyStronghands public {
293         address _customerAddress = msg.sender;
294         withdrawAddr(_customerAddress);
295     }
296 
297     function withdrawAddr(address _fromAddress) onlyStronghands internal {
298         address _customerAddress = _fromAddress;
299         lastupdate_[_customerAddress] = now;
300         uint256 _dividends = myDividends(false);
301         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
302         _dividends += referralBalance_[_customerAddress];
303         referralBalance_[_customerAddress] = 0;
304         _customerAddress.transfer(_dividends);
305         emit onWithdraw(_customerAddress, _dividends);
306     }
307 
308     function sell(uint256 _amountOfTokens) onlyBagholders public {
309         address _customerAddress = msg.sender;
310         lastupdate_[_customerAddress] = now;
311         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
312         uint256 _tokens = _amountOfTokens;
313         uint256 _ethereum = tokensToEthereum_(_tokens);
314         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
315         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
316 
317         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
318         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
319 
320         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
321         payoutsTo_[_customerAddress] -= _updatedPayouts;
322 
323         if (tokenSupply_ > 0) {
324             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325         }
326         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
327     }
328 
329     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
330         address _customerAddress = msg.sender;
331         lastupdate_[_customerAddress] = now;
332         if (_amountOfTokens>stakingRequirement) {
333             lastupdate_[_toAddress] = now;
334         }
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336 
337         if (myDividends(true) > 0) {
338             withdraw();
339         }
340 
341         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
342         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
343         uint256 _dividends = tokensToEthereum_(_tokenFee);
344 
345         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
346         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
347         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
348         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
349         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
350         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
351         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
352         return true;
353     }
354 
355 
356     function totalEthereumBalance() public view returns (uint256) {
357         return address(this).balance;
358     }
359 
360     function totalSupply() public view returns (uint256) {
361         return tokenSupply_;
362     }
363 
364     function refferedBy(address _customerAddress) public view returns (address) {
365         return refferals_[_customerAddress];
366     }
367 
368     function myTokens() public view returns (uint256) {
369         address _customerAddress = msg.sender;
370         return balanceOf(_customerAddress);
371     }
372 
373     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
374         address _customerAddress = msg.sender;
375         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
376     }
377 
378     function balanceOf(address _customerAddress) public view returns (uint256) {
379         return tokenBalanceLedger_[_customerAddress];
380     }
381 
382     function dividendsOf(address _customerAddress) public view returns (uint256) {
383         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
384     }
385 
386     function sellPrice() public view returns (uint256) {
387         // our calculation relies on the token supply, so we need supply. Doh.
388         if (tokenSupply_ == 0) {
389             return tokenPriceInitial_ - tokenPriceIncremental_;
390         } else {
391             uint256 _ethereum = tokensToEthereum_(1e18);
392             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
393             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
394 
395             return _taxedEthereum;
396         }
397     }
398 
399     function buyPrice() public view returns (uint256) {
400         if (tokenSupply_ == 0) {
401             return tokenPriceInitial_ + tokenPriceIncremental_;
402         } else {
403             uint256 _ethereum = tokensToEthereum_(1e18);
404             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
405             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
406 
407             return _taxedEthereum;
408         }
409     }
410 
411     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
412         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
413         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
414         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
415 
416         return _amountOfTokens;
417     }
418 
419     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
420         require(_tokensToSell <= tokenSupply_);
421         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
422         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
423         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
424         return _taxedEthereum;
425     }
426 
427 
428     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
429         address _customerAddress = msg.sender;
430         lastupdate_[_customerAddress] = now;
431 
432         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_-entryFeeCapital_-entryFeeReward_), 100);
433 //        uint256 _fullTax = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
434         uint256 _capitalTrade = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeCapital_), 100);
435         uint256 _adminReward = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeReward_), 100);
436         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
437         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
438         uint256 _taxedEthereum = SafeMath.div(SafeMath.mul(_incomingEthereum, 100-entryFee_), 100);
439         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
440         uint256 _fee = _dividends * magnitude;
441 
442         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
443 
444 //set refferal. lifetime
445         if (
446             _referredBy != 0x0000000000000000000000000000000000000000 &&
447             _referredBy != _customerAddress &&
448             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
449             refferals_[_customerAddress] == 0x0
450         ) {
451             refferals_[_customerAddress] = _referredBy;
452             emit onNewRefferal(_customerAddress,_referredBy, now);
453         }
454 
455 //use refferal
456         if (
457             refferals_[_customerAddress] != 0x0 &&
458             tokenBalanceLedger_[refferals_[_customerAddress]] >= stakingRequirement
459         ) {
460             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
461         } else {
462             _dividends = SafeMath.add(_dividends, _referralBonus);
463             _fee = _dividends * magnitude;
464         }
465 
466         if (tokenSupply_ > 0) {
467             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
468             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
469             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
470         } else {
471             tokenSupply_ = _amountOfTokens;
472         }
473 
474         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
475         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
476         payoutsTo_[_customerAddress] += _updatedPayouts;
477         
478         capitalAmount_=SafeMath.add(capitalAmount_,_capitalTrade);
479         AdminRewardAmount_=SafeMath.add(AdminRewardAmount_,_adminReward);
480         if (capitalAmount_>1e17){ //more than 0.1 ETH - send outs
481             takeCapital();
482         }
483 
484         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
485 
486         return _amountOfTokens;
487     }
488 
489     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
490         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
491         uint256 _tokensReceived =
492             (
493                 (
494                     SafeMath.sub(
495                         (sqrt
496                             (
497                                 (_tokenPriceInitial ** 2)
498                                 +
499                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
500                                 +
501                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
502                                 +
503                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
504                             )
505                         ), _tokenPriceInitial
506                     )
507                 ) / (tokenPriceIncremental_)
508             ) - (tokenSupply_);
509 
510         return _tokensReceived;
511     }
512 
513     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
514         uint256 tokens_ = (_tokens + 1e18);
515         uint256 _tokenSupply = (tokenSupply_ + 1e18);
516         uint256 _etherReceived =
517             (
518                 SafeMath.sub(
519                     (
520                         (
521                             (
522                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
523                             ) - tokenPriceIncremental_
524                         ) * (tokens_ - 1e18)
525                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
526                 )
527                 / 1e18);
528 
529         return _etherReceived;
530     }
531 
532     function sqrt(uint256 x) internal pure returns (uint256 y) {
533         uint256 z = (x + 1) / 2;
534         y = x;
535 
536         while (z < y) {
537             y = z;
538             z = (x / z + z) / 2;
539         }
540     }
541 
542 
543 }
544 
545 library SafeMath {
546     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
547         if (a == 0) {
548             return 0;
549         }
550         uint256 c = a * b;
551         assert(c / a == b);
552         return c;
553     }
554 
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         uint256 c = a / b;
557         return c;
558     }
559 
560     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
561         assert(b <= a);
562         return a - b;
563     }
564 
565     function add(uint256 a, uint256 b) internal pure returns (uint256) {
566         uint256 c = a + b;
567         assert(c >= a);
568         return c;
569     }
570 }