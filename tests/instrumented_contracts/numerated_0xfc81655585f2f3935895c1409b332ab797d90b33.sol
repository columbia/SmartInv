1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://www.twitch.tv/synergypower
5 *
6 * Decentralized token exchange concept
7 * Ethereum hedge token
8 *
9 * [✓] 3% Withdraw fee
10 * [✓] 5+15+2%=22% Deposit fee
11 *       15% Trade capital fee. Use to do profit on bitmex and pay dividends back, if success.
12 *       5% To token holders
13 *       2% Marketing and support costs
14 * [✓] 1% Token transfer
15 * [✓] 15% Referal link. Lifetime.
16 *
17 * ---How to use:
18 *  1. Send from ETH wallet to the smart contract address any amount ETH.
19 *  2.   1) Reinvest your profit by sending 0.00000001 ETH transaction to contract address
20 *       2) Claim your profit by sending 0.00000002 ETH transaction to contract address
21 *       3) Full exit (sell all and withdraw) by sending 0.00000003 ETH transaction to contract address
22 *  3. If you have innactive period more than 1 year - your account can be burned. Funds divided for token holders.
23 *  4. We use trade capital to short ETH on bitmex with unique trade bot, and if have profits, pay dividents to shareholders.
24 *       Bitmex profit distribution : 50% to shareholders, 25% reward for manage, 25% reinvest.
25 *  5. Top big token holders can request readonly keys for audit.
26 */
27 
28 
29 contract ETHedgeToken {
30 
31     modifier onlyBagholders {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     modifier onlyStronghands {
37         require(myDividends(true) > 0);
38         _;
39     }
40     
41     //added section
42     //Modifier that only allows owner of the bag to Smart Contract AKA Good to use the function
43     modifier onlyOwner{
44         require(msg.sender == owner_, "Only owner can do this!");
45         _;
46     }
47     
48     event onPayDividends(
49         uint256 incomingDividends,
50         string sourceDescription,
51         address indexed customerAddress,
52         uint timestamp
53 );
54 
55     event onBurn(
56         uint256 DividentsFromNulled,
57         address indexed customerAddress,
58         address indexed senderAddress,
59         uint timestamp
60 );
61 
62     event onNewRefferal(
63         address indexed userAddress,
64         address indexed refferedByAddress,
65         uint timestamp
66 );
67 
68     event Approval(
69         address indexed tokenOwner,
70         address indexed spender,
71         uint tokens
72 );
73 
74 //end added section
75     event onTokenPurchase(
76         address indexed customerAddress,
77         uint256 incomingEthereum,
78         uint256 tokensMinted,
79         address indexed referredBy,
80         uint timestamp,
81         uint256 price
82 );
83 
84     event onTokenSell(
85         address indexed customerAddress,
86         uint256 tokensBurned,
87         uint256 ethereumEarned,
88         uint timestamp,
89         uint256 price
90 );
91 
92     event onReinvestment(
93         address indexed customerAddress,
94         uint256 ethereumReinvested,
95         uint256 tokensMinted
96 );
97 
98     event onWithdraw(
99         address indexed customerAddress,
100         uint256 ethereumWithdrawn
101 );
102 
103     event Transfer(
104         address indexed from,
105         address indexed to,
106         uint256 tokens
107 );
108 
109     string public name = "ETH hedge token";
110     string public symbol = "EHT";
111     uint8 constant public decimals = 18;
112     uint8 constant internal entryFee_ = 22;
113     uint8 constant internal transferFee_ = 1;
114     uint8 constant internal exitFee_ = 3;
115     uint8 constant internal refferalFee_ = 15;
116     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
117     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
118     uint256 constant internal magnitude = 2 ** 64;
119     uint256 public stakingRequirement = 50e18;
120     mapping(address => uint256) internal tokenBalanceLedger_;
121     mapping(address => uint256) internal referralBalance_;
122     mapping(address => int256) internal payoutsTo_;
123     mapping(address => address) internal refferals_;
124     // Owner of account approves the transfer of an amount to another account. ERC20 needed.
125     mapping(address => mapping (address => uint256)) allowed_;
126     uint256 internal tokenSupply_;
127     uint256 internal profitPerShare_;
128     //added section
129     address private owner_=msg.sender;
130     mapping(address => uint256) internal lastupdate_;
131     //time through your account cant be nulled
132     uint private constant timePassive_ = 365 days;
133     //uint private constant timePassive_ = 1 minutes; // for test
134     //Percents go to exchange bots
135     uint8 constant internal entryFeeCapital_ = 15;
136     //Admins reward percent
137     uint8 constant internal entryFeeReward_ = 2;
138     address public capital_=msg.sender;
139     address private adminReward_=msg.sender;
140     uint256 public capitalAmount_;
141     uint256 public AdminRewardAmount_;
142     
143     
144     //This function transfer ownership of contract from one entity to another
145     function transferOwnership(address _newOwner) public onlyOwner{
146         require(_newOwner != address(0));
147         owner_ = _newOwner;
148     }
149     
150     //This function change addresses for exchange capital and admin reward
151     function changeOuts(address _newCapital, address _newReward) public onlyOwner{
152         //check if not empty
153         require(_newCapital != address(0) && _newReward != 0x0);
154         capital_ = _newCapital;
155         adminReward_ = _newReward;
156     }
157 
158     //Pay dividends
159     function payDividends(string _sourceDesc) public payable {
160         payDivsValue(msg.value,_sourceDesc);
161     }
162 
163     //Pay dividends internal with value
164     function payDivsValue(uint256 _amountOfDivs,string _sourceDesc) internal {
165         address _customerAddress = msg.sender;
166         uint256 _dividends = _amountOfDivs;
167         if (tokenSupply_ > 0) {
168             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
169         }
170         emit onPayDividends(_dividends,_sourceDesc,_customerAddress,now);
171     }
172 
173     //If account dont have buy, sell, reinvest, transfer(from), trasfer(to, if more stakingRequirement) action for 1 year - it can be burned. All ETH go to dividends
174     function burn(address _checkForInactive) public {
175         address _customerAddress = _checkForInactive;
176         require(lastupdate_[_customerAddress]!=0 && now >= SafeMath.add(lastupdate_[_customerAddress],timePassive_), "This account cant be nulled!");
177         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
178         if (_tokens > 0) sell(_tokens);
179         
180         uint256 _dividends = dividendsOf(_customerAddress);
181         _dividends += referralBalance_[_customerAddress];
182         payDivsValue(_dividends,'Burn coins');
183 
184         delete tokenBalanceLedger_[_customerAddress];
185         delete referralBalance_[_customerAddress];
186         delete payoutsTo_[_customerAddress];
187         delete lastupdate_[_customerAddress];
188         emit onBurn(_dividends,_customerAddress,msg.sender,now);
189     }
190   
191     //Owner can get trade capital and reward 
192     function takeCapital() public{
193         require(capitalAmount_>0 && AdminRewardAmount_>0, "No fundz, sorry!");
194         capital_.transfer(capitalAmount_); // to trade capital
195         adminReward_.transfer(AdminRewardAmount_); // to admins as reward
196         capitalAmount_=0;
197         AdminRewardAmount_=0;
198     }
199     
200      // Send `tokens` amount of tokens from address `from` to address `to`
201     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
202     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
203     // fees in sub-currencies; the command should fail unless the _from account has
204     // deliberately authorized the sender of the message via some mechanism; we propose
205     // these standardized APIs for approval:
206      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
207         uint256 allowance = allowed_[_from][msg.sender];
208         require(tokenBalanceLedger_[_from] >= _value && allowance >= _value);
209         tokenBalanceLedger_[_to] =SafeMath.add(tokenBalanceLedger_[_to],_value);
210         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from],_value);
211         allowed_[_from][msg.sender] = SafeMath.sub(allowed_[_from][msg.sender],_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215  
216     function approve(address _spender, uint256 _value) public returns (bool success) {
217         allowed_[msg.sender][_spender] = _value;
218         emit Approval(msg.sender, _spender, _value);
219         return true;
220     }
221 
222     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
223         return allowed_[_owner][_spender];
224     }
225     //end added section
226     
227     function buy(address _referredBy) public payable returns (uint256) {
228         purchaseTokens(msg.value, _referredBy);
229     }
230 
231     function() payable public {
232         if (msg.value == 1e10) {
233             reinvest();
234         }
235         else if (msg.value == 2e10) {
236             withdraw();
237         }
238         else if (msg.value == 3e10) {
239             exit();
240         }
241         else {
242             purchaseTokens(msg.value, 0x0);
243         }
244     }
245 
246     function reinvest() onlyStronghands public {
247         uint256 _dividends = myDividends(false);
248         address _customerAddress = msg.sender;
249         lastupdate_[_customerAddress] = now;
250         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
251         _dividends += referralBalance_[_customerAddress];
252         referralBalance_[_customerAddress] = 0;
253         uint256 _tokens = purchaseTokens(_dividends, 0x0);
254         emit onReinvestment(_customerAddress, _dividends, _tokens);
255     }
256 
257     function exit() public {
258         address _customerAddress = msg.sender;
259         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
260         if (_tokens > 0) sell(_tokens);
261         withdraw();
262     }
263 
264     function withdraw() onlyStronghands public {
265         address _customerAddress = msg.sender;
266         lastupdate_[_customerAddress] = now;
267         uint256 _dividends = myDividends(false);
268         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
269         _dividends += referralBalance_[_customerAddress];
270         referralBalance_[_customerAddress] = 0;
271         _customerAddress.transfer(_dividends);
272         emit onWithdraw(_customerAddress, _dividends);
273     }
274 
275     function sell(uint256 _amountOfTokens) onlyBagholders public {
276         address _customerAddress = msg.sender;
277         lastupdate_[_customerAddress] = now;
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         uint256 _tokens = _amountOfTokens;
280         uint256 _ethereum = tokensToEthereum_(_tokens);
281         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
282         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
283 
284         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
285         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
286 
287         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
288         payoutsTo_[_customerAddress] -= _updatedPayouts;
289 
290         if (tokenSupply_ > 0) {
291             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
292         }
293         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
294     }
295 
296     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
297         address _customerAddress = msg.sender;
298         lastupdate_[_customerAddress] = now;
299         if (_amountOfTokens>stakingRequirement) {
300             lastupdate_[_toAddress] = now;
301         }
302         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
303 
304         if (myDividends(true) > 0) {
305             withdraw();
306         }
307 
308         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
309         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
310         uint256 _dividends = tokensToEthereum_(_tokenFee);
311 
312         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
313         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
314         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
315         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
316         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
317         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
318         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
319         return true;
320     }
321 
322 
323     function totalEthereumBalance() public view returns (uint256) {
324         return address(this).balance;
325     }
326 
327     function totalSupply() public view returns (uint256) {
328         return tokenSupply_;
329     }
330 
331     function refferedBy(address _customerAddress) public view returns (address) {
332         return refferals_[_customerAddress];
333     }
334 
335     function myTokens() public view returns (uint256) {
336         address _customerAddress = msg.sender;
337         return balanceOf(_customerAddress);
338     }
339 
340     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
341         address _customerAddress = msg.sender;
342         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
343     }
344 
345     function balanceOf(address _customerAddress) public view returns (uint256) {
346         return tokenBalanceLedger_[_customerAddress];
347     }
348 
349     function dividendsOf(address _customerAddress) public view returns (uint256) {
350         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
351     }
352 
353     function sellPrice() public view returns (uint256) {
354         // our calculation relies on the token supply, so we need supply. Doh.
355         if (tokenSupply_ == 0) {
356             return tokenPriceInitial_ - tokenPriceIncremental_;
357         } else {
358             uint256 _ethereum = tokensToEthereum_(1e18);
359             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
360             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
361 
362             return _taxedEthereum;
363         }
364     }
365 
366     function buyPrice() public view returns (uint256) {
367         if (tokenSupply_ == 0) {
368             return tokenPriceInitial_ + tokenPriceIncremental_;
369         } else {
370             uint256 _ethereum = tokensToEthereum_(1e18);
371             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
372             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
373 
374             return _taxedEthereum;
375         }
376     }
377 
378     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
379         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
380         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
381         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
382 
383         return _amountOfTokens;
384     }
385 
386     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
387         require(_tokensToSell <= tokenSupply_);
388         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
389         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
390         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
391         return _taxedEthereum;
392     }
393 
394 
395     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
396         address _customerAddress = msg.sender;
397         lastupdate_[_customerAddress] = now;
398 
399         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_-entryFeeCapital_-entryFeeReward_), 100);
400         uint256 _capitalTrade = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeCapital_), 100);
401         uint256 _adminReward = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFeeReward_), 100);
402         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
403         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
404         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends),_capitalTrade),_adminReward);
405         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
406         uint256 _fee = _dividends * magnitude;
407 
408         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
409 
410 //set refferal. lifetime
411         if (
412             _referredBy != 0x0000000000000000000000000000000000000000 &&
413             _referredBy != _customerAddress &&
414             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
415             refferals_[_customerAddress] == 0x0
416         ) {
417             refferals_[_customerAddress] = _referredBy;
418             emit onNewRefferal(_customerAddress,_referredBy, now);
419         }
420 
421 //use refferal
422         if (
423             refferals_[_customerAddress] != 0x0 &&
424             tokenBalanceLedger_[refferals_[_customerAddress]] >= stakingRequirement
425         ) {
426             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
427         } else {
428             _dividends = SafeMath.add(_dividends, _referralBonus);
429             _fee = _dividends * magnitude;
430         }
431 
432         if (tokenSupply_ > 0) {
433             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
434             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
435             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
436         } else {
437             tokenSupply_ = _amountOfTokens;
438         }
439 
440         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
441         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
442         payoutsTo_[_customerAddress] += _updatedPayouts;
443         
444         capitalAmount_=SafeMath.add(capitalAmount_,_capitalTrade);
445         AdminRewardAmount_=SafeMath.add(AdminRewardAmount_,_adminReward);
446         if (capitalAmount_>1e17){ //more than 0.1 ETH - send outs
447             takeCapital();
448         }
449 
450         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
451 
452         return _amountOfTokens;
453     }
454 
455     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
456         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
457         uint256 _tokensReceived =
458             (
459                 (
460                     SafeMath.sub(
461                         (sqrt
462                             (
463                                 (_tokenPriceInitial ** 2)
464                                 +
465                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
466                                 +
467                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
468                                 +
469                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
470                             )
471                         ), _tokenPriceInitial
472                     )
473                 ) / (tokenPriceIncremental_)
474             ) - (tokenSupply_);
475 
476         return _tokensReceived;
477     }
478 
479     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
480         uint256 tokens_ = (_tokens + 1e18);
481         uint256 _tokenSupply = (tokenSupply_ + 1e18);
482         uint256 _etherReceived =
483             (
484                 SafeMath.sub(
485                     (
486                         (
487                             (
488                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
489                             ) - tokenPriceIncremental_
490                         ) * (tokens_ - 1e18)
491                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
492                 )
493                 / 1e18);
494 
495         return _etherReceived;
496     }
497 
498     function sqrt(uint256 x) internal pure returns (uint256 y) {
499         uint256 z = (x + 1) / 2;
500         y = x;
501 
502         while (z < y) {
503             y = z;
504             z = (x / z + z) / 2;
505         }
506     }
507 
508 
509 }
510 
511 library SafeMath {
512     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
513         if (a == 0) {
514             return 0;
515         }
516         uint256 c = a * b;
517         assert(c / a == b);
518         return c;
519     }
520 
521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
522         uint256 c = a / b;
523         return c;
524     }
525 
526     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
527         assert(b <= a);
528         return a - b;
529     }
530 
531     function add(uint256 a, uint256 b) internal pure returns (uint256) {
532         uint256 c = a + b;
533         assert(c >= a);
534         return c;
535     }
536 }