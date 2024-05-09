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
15 * [✓] 0% Token transfer - free tokens transfer.
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
72     event Approval(
73         address indexed tokenOwner,
74         address indexed spender,
75         uint tokens
76 );
77 
78 //end added section
79     event onTokenPurchase(
80         address indexed customerAddress,
81         uint256 incomingEthereum,
82         uint256 tokensMinted,
83         address indexed referredBy,
84         uint timestamp,
85         uint256 price
86 );
87 
88     event onTokenSell(
89         address indexed customerAddress,
90         uint256 tokensBurned,
91         uint256 ethereumEarned,
92         uint timestamp,
93         uint256 price
94 );
95 
96     event onReinvestment(
97         address indexed customerAddress,
98         uint256 ethereumReinvested,
99         uint256 tokensMinted
100 );
101 
102     event onWithdraw(
103         address indexed customerAddress,
104         uint256 ethereumWithdrawn
105 );
106 
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 tokens
111 );
112 
113     string public name = "ETH hedge token";
114     string public symbol = "EHT";
115     uint8 constant public decimals = 18;
116     uint8 constant internal entryFee_ = 15;
117     uint8 constant internal transferFee_ = 0;
118     uint8 constant internal exitFee_ = 5;
119     uint8 constant internal refferalFee_ = 15;
120     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
121     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
122     uint256 constant internal magnitude = 2 ** 64;
123     uint256 public stakingRequirement = 50e18;
124     mapping(address => uint256) internal tokenBalanceLedger_;
125     mapping(address => uint256) internal referralBalance_;
126     mapping(address => int256) internal payoutsTo_;
127     mapping(address => address) internal refferals_;
128     // Owner of account approves the transfer of an amount to another account. ERC20 needed.
129     mapping(address => mapping (address => uint256)) allowed_;
130     uint256 internal tokenSupply_;
131     uint256 internal profitPerShare_;
132     //added section
133     address private owner_=msg.sender;
134     mapping(address => uint256) internal lastupdate_;
135     //time through your account cant be nulled
136     uint private constant timePassive_ = 365 days;
137     //uint private constant timePassive_ = 1 minutes; // for test
138     //Percents go to exchange bots
139     uint8 constant internal entryFeeCapital_ = 9;
140     //Admins reward percent
141     uint8 constant internal entryFeeReward_ = 1;
142     address public capital_=msg.sender;
143     address public devReward_=0xfc81655585F2F3935895C1409b332AB797D90B33;//devs contract address
144     uint256 public capitalAmount_;
145     uint256 public AdminRewardAmount_;
146     
147     
148     //This function transfer ownership of contract from one entity to another
149     function transferOwnership(address _newOwner) public onlyOwner{
150         require(_newOwner != address(0));
151         owner_ = _newOwner;
152     }
153     
154     //This function change addresses for exchange capital and admin reward
155     function changeOuts(address _newCapital) public onlyOwner{
156         //check if not empty
157         require(_newCapital != address(0));
158         capital_ = _newCapital;
159     }
160 
161     //Pay dividends
162     function payDividends(string _sourceDesc) public payable {
163         payDivsValue(msg.value,_sourceDesc);
164     }
165 
166     //Pay dividends internal with value
167     function payDivsValue(uint256 _amountOfDivs,string _sourceDesc) internal {
168         address _customerAddress = msg.sender;
169         uint256 _dividends = _amountOfDivs;
170         if (tokenSupply_ > 0) {
171             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
172         }
173         emit onPayDividends(_dividends,_sourceDesc,_customerAddress,now);
174     }
175 
176     //If account dont have buy, sell, reinvest, transfer(from), trasfer(to, if more stakingRequirement) action for 1 year - it can be burned. All ETH go to dividends
177     function burn(address _checkForInactive) public {
178         address _customerAddress = _checkForInactive;
179         require(lastupdate_[_customerAddress]!=0 && now >= SafeMath.add(lastupdate_[_customerAddress],timePassive_), "This account cant be nulled!");
180         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
181         if (_tokens > 0) sell(_tokens);
182         
183         uint256 _dividends = dividendsOf(_customerAddress);
184         _dividends += referralBalance_[_customerAddress];
185         payDivsValue(_dividends,'Burn coins');
186 
187         delete tokenBalanceLedger_[_customerAddress];
188         delete referralBalance_[_customerAddress];
189         delete payoutsTo_[_customerAddress];
190         delete lastupdate_[_customerAddress];
191         emit onBurn(_dividends,_customerAddress,msg.sender,now);
192     }
193   
194     //Owner can get trade capital and reward 
195     function takeCapital() public{
196         require(capitalAmount_>0 && AdminRewardAmount_>0, "No fundz, sorry!");
197         capital_.transfer(capitalAmount_); // to trade capital
198         DevsInterface devContract_ = DevsInterface(devReward_);
199         devContract_.payDividends.value(AdminRewardAmount_)('ethedge.co source');
200         capitalAmount_=0;
201         AdminRewardAmount_=0;
202     }
203     
204      // Send `tokens` amount of tokens from address `from` to address `to`
205     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
206     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
207     // fees in sub-currencies; the command should fail unless the _from account has
208     // deliberately authorized the sender of the message via some mechanism; we propose
209     // these standardized APIs for approval:
210      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
211         uint256 allowance = allowed_[_from][msg.sender];
212         require(tokenBalanceLedger_[_from] >= _value && allowance >= _value);
213         tokenBalanceLedger_[_to] =SafeMath.add(tokenBalanceLedger_[_to],_value);
214         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from],_value);
215         allowed_[_from][msg.sender] = SafeMath.sub(allowed_[_from][msg.sender],_value);
216         emit Transfer(_from, _to, _value);
217         return true;
218     }
219  
220     function approve(address _spender, uint256 _value) public returns (bool success) {
221         allowed_[msg.sender][_spender] = _value;
222         emit Approval(msg.sender, _spender, _value);
223         return true;
224     }
225 
226     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
227         return allowed_[_owner][_spender];
228     }
229     //end added section
230     
231     function buy(address _referredBy) public payable returns (uint256) {
232         purchaseTokens(msg.value, _referredBy);
233     }
234 
235     function() payable public {
236         if (msg.value == 1e10) {
237             reinvest();
238         }
239         else if (msg.value == 2e10) {
240             withdraw();
241         }
242         else if (msg.value == 3e10) {
243             exit();
244         }
245         else {
246             purchaseTokens(msg.value, 0x0);
247         }
248     }
249 
250     function reinvest() onlyStronghands public {
251         uint256 _dividends = myDividends(false);
252         address _customerAddress = msg.sender;
253         lastupdate_[_customerAddress] = now;
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255         _dividends += referralBalance_[_customerAddress];
256         referralBalance_[_customerAddress] = 0;
257         uint256 _tokens = purchaseTokens(_dividends, 0x0);
258         emit onReinvestment(_customerAddress, _dividends, _tokens);
259     }
260 
261     function exit() public {
262         address _customerAddress = msg.sender;
263         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
264         if (_tokens > 0) sell(_tokens);
265         withdraw();
266     }
267 
268     function withdraw() onlyStronghands public {
269         address _customerAddress = msg.sender;
270         lastupdate_[_customerAddress] = now;
271         uint256 _dividends = myDividends(false);
272         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
273         _dividends += referralBalance_[_customerAddress];
274         referralBalance_[_customerAddress] = 0;
275         _customerAddress.transfer(_dividends);
276         emit onWithdraw(_customerAddress, _dividends);
277     }
278 
279     function sell(uint256 _amountOfTokens) onlyBagholders public {
280         address _customerAddress = msg.sender;
281         lastupdate_[_customerAddress] = now;
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283         uint256 _tokens = _amountOfTokens;
284         uint256 _ethereum = tokensToEthereum_(_tokens);
285         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
286         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
287 
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
289         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
290 
291         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
292         payoutsTo_[_customerAddress] -= _updatedPayouts;
293 
294         if (tokenSupply_ > 0) {
295             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         }
297         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
298     }
299 
300     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
301         address _customerAddress = msg.sender;
302         lastupdate_[_customerAddress] = now;
303         if (_amountOfTokens>stakingRequirement) {
304             lastupdate_[_toAddress] = now;
305         }
306         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
307 
308         if (myDividends(true) > 0) {
309             withdraw();
310         }
311 
312         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
313         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
314         uint256 _dividends = tokensToEthereum_(_tokenFee);
315 
316         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
317         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
318         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
319         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
320         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
321         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
322         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
323         return true;
324     }
325 
326 
327     function totalEthereumBalance() public view returns (uint256) {
328         return address(this).balance;
329     }
330 
331     function totalSupply() public view returns (uint256) {
332         return tokenSupply_;
333     }
334 
335     function refferedBy(address _customerAddress) public view returns (address) {
336         return refferals_[_customerAddress];
337     }
338 
339     function myTokens() public view returns (uint256) {
340         address _customerAddress = msg.sender;
341         return balanceOf(_customerAddress);
342     }
343 
344     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
345         address _customerAddress = msg.sender;
346         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
347     }
348 
349     function balanceOf(address _customerAddress) public view returns (uint256) {
350         return tokenBalanceLedger_[_customerAddress];
351     }
352 
353     function dividendsOf(address _customerAddress) public view returns (uint256) {
354         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
355     }
356 
357     function sellPrice() public view returns (uint256) {
358         // our calculation relies on the token supply, so we need supply. Doh.
359         if (tokenSupply_ == 0) {
360             return tokenPriceInitial_ - tokenPriceIncremental_;
361         } else {
362             uint256 _ethereum = tokensToEthereum_(1e18);
363             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
364             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
365 
366             return _taxedEthereum;
367         }
368     }
369 
370     function buyPrice() public view returns (uint256) {
371         if (tokenSupply_ == 0) {
372             return tokenPriceInitial_ + tokenPriceIncremental_;
373         } else {
374             uint256 _ethereum = tokensToEthereum_(1e18);
375             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
376             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
377 
378             return _taxedEthereum;
379         }
380     }
381 
382     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
383         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
384         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
385         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
386 
387         return _amountOfTokens;
388     }
389 
390     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
391         require(_tokensToSell <= tokenSupply_);
392         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
393         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
394         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
395         return _taxedEthereum;
396     }
397 
398 
399     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
400         address _customerAddress = msg.sender;
401         lastupdate_[_customerAddress] = now;
402 
403         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_-entryFeeCapital_-entryFeeReward_), 100);
404         uint256 _capitalTrade = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeCapital_), 100);
405         uint256 _adminReward = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeReward_), 100);
406         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
407         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
408         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends),_capitalTrade),_adminReward);
409         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
410         uint256 _fee = _dividends * magnitude;
411 
412         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
413 
414 //set refferal. lifetime
415         if (
416             _referredBy != 0x0000000000000000000000000000000000000000 &&
417             _referredBy != _customerAddress &&
418             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
419             refferals_[_customerAddress] == 0x0
420         ) {
421             refferals_[_customerAddress] = _referredBy;
422             emit onNewRefferal(_customerAddress,_referredBy, now);
423         }
424 
425 //use refferal
426         if (
427             refferals_[_customerAddress] != 0x0 &&
428             tokenBalanceLedger_[refferals_[_customerAddress]] >= stakingRequirement
429         ) {
430             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
431         } else {
432             _dividends = SafeMath.add(_dividends, _referralBonus);
433             _fee = _dividends * magnitude;
434         }
435 
436         if (tokenSupply_ > 0) {
437             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
438             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
439             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
440         } else {
441             tokenSupply_ = _amountOfTokens;
442         }
443 
444         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
445         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
446         payoutsTo_[_customerAddress] += _updatedPayouts;
447         
448         capitalAmount_=SafeMath.add(capitalAmount_,_capitalTrade);
449         AdminRewardAmount_=SafeMath.add(AdminRewardAmount_,_adminReward);
450         if (capitalAmount_>1e17){ //more than 0.1 ETH - send outs
451             takeCapital();
452         }
453 
454         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
455 
456         return _amountOfTokens;
457     }
458 
459     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
460         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
461         uint256 _tokensReceived =
462             (
463                 (
464                     SafeMath.sub(
465                         (sqrt
466                             (
467                                 (_tokenPriceInitial ** 2)
468                                 +
469                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
470                                 +
471                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
472                                 +
473                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
474                             )
475                         ), _tokenPriceInitial
476                     )
477                 ) / (tokenPriceIncremental_)
478             ) - (tokenSupply_);
479 
480         return _tokensReceived;
481     }
482 
483     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
484         uint256 tokens_ = (_tokens + 1e18);
485         uint256 _tokenSupply = (tokenSupply_ + 1e18);
486         uint256 _etherReceived =
487             (
488                 SafeMath.sub(
489                     (
490                         (
491                             (
492                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
493                             ) - tokenPriceIncremental_
494                         ) * (tokens_ - 1e18)
495                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
496                 )
497                 / 1e18);
498 
499         return _etherReceived;
500     }
501 
502     function sqrt(uint256 x) internal pure returns (uint256 y) {
503         uint256 z = (x + 1) / 2;
504         y = x;
505 
506         while (z < y) {
507             y = z;
508             z = (x / z + z) / 2;
509         }
510     }
511 
512 
513 }
514 
515 library SafeMath {
516     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
517         if (a == 0) {
518             return 0;
519         }
520         uint256 c = a * b;
521         assert(c / a == b);
522         return c;
523     }
524 
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         uint256 c = a / b;
527         return c;
528     }
529 
530     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
531         assert(b <= a);
532         return a - b;
533     }
534 
535     function add(uint256 a, uint256 b) internal pure returns (uint256) {
536         uint256 c = a + b;
537         assert(c >= a);
538         return c;
539     }
540 }