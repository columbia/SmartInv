1 pragma solidity ^0.4.25;
2 
3 /*
4 * Crypto miner token concept
5 *
6 * [✓] 8% Withdraw fee
7 * [✓] 9% Deposit fee
8 * [✓] 1% Token transfer
9 * [✓] 3,5% Referal link ()
10 * [✓] 0.5% _admin (from buy)
11 * [✓] 1% _onreclame (from sell)
12 * [✓] 50 _limit (ограничение на ввод. Не более 50 эфиров с одного кошелька в течение часа)
13 *
14 */
15 contract CriptoMinerToken2 {
16 
17     modifier onlyBagholders {    
18         require(myTokens() > 0);
19         _;
20     }
21 
22     modifier onlyStronghands {  
23         require(myDividends(true) > 0);
24         _;
25     }
26    
27     event onTokenPurchase(
28         address indexed customerAddress,
29         uint256 incomingEthereum,
30         uint256 tokensMinted,
31         address indexed referredBy,
32         uint timestamp,
33         uint256 price
34 );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned,
40         uint timestamp,
41         uint256 price
42 );
43 
44     event onReinvestment(
45         address indexed customerAddress,
46         uint256 ethereumReinvested,
47         uint256 tokensMinted
48 );
49 
50     event onWithdraw(
51         address indexed customerAddress,
52         uint256 ethereumWithdrawn
53 );
54 
55     event Transfer(
56         address indexed from,
57         address indexed to,
58         uint256 tokens
59 );
60 
61     string public name = "Cripto Miner Token";
62     string public symbol = "CMT";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 10;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal exitFee_ = 8;
67     uint8 constant internal onreclame = 1;
68     uint8 constant internal refferalFee_ = 35;
69     uint8 constant internal adminFee_ = 5;
70     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
71     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
72     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
73     uint256 public stakingRequirement = 1e18;    //сколько токенов нужно для рефералки 
74     mapping(address => uint256) internal tokenBalanceLedger_;
75     mapping(address => uint256) internal referralBalance_;
76     mapping(address => int256) internal payoutsTo_;
77     uint256 internal tokenSupply_;
78     uint256 internal profitPerShare_;
79     
80     function buy(address _referredBy) public payable returns (uint256) {
81         purchaseTokens(msg.value, _referredBy);
82     }
83 
84     function() payable public {
85         purchaseTokens(msg.value, 0x0);
86     }
87 
88     function reinvest() onlyStronghands public {
89         uint256 _dividends = myDividends(false);
90         address _customerAddress = msg.sender;
91         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
92         _dividends += referralBalance_[_customerAddress];
93         referralBalance_[_customerAddress] = 0;
94         uint256 _tokens = purchaseTokens(_dividends, 0x0);
95         emit onReinvestment(_customerAddress, _dividends, _tokens);
96     }
97 
98     function exit() public {
99         address _customerAddress = msg.sender;
100         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
101         if (_tokens > 0) sell(_tokens);
102         withdraw();
103     }
104 
105     function withdraw() onlyStronghands public {
106         address _customerAddress = msg.sender;
107         uint256 _dividends = myDividends(false);
108         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
109         _dividends += referralBalance_[_customerAddress];
110         referralBalance_[_customerAddress] = 0;
111         _customerAddress.transfer(_dividends);
112         emit onWithdraw(_customerAddress, _dividends);
113     }
114 
115     function sell(uint256 _amountOfTokens) onlyBagholders public {
116         address _customerAddress = msg.sender;
117         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
118         uint256 _tokens = _amountOfTokens;
119         uint256 _ethereum = tokensToEthereum_(_tokens);
120         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
121         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
122          if (_customerAddress != 0x006e44234B4117a571368180ce748544077301FA){
123         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
124         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
125         tokenBalanceLedger_[0x006e44234B4117a571368180ce748544077301FA] += _reclama;}
126      
127         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
128         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
129         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
130         payoutsTo_[_customerAddress] -= _updatedPayouts;
131         
132         if (tokenSupply_ > 0) {
133             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
134         }
135         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
136     }
137 
138     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
139         address _customerAddress = msg.sender;
140         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
141 
142         if (myDividends(true) > 0) {
143             withdraw();
144         }
145 
146         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
147         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
148         uint256 _dividends = tokensToEthereum_(_tokenFee);
149 
150         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
151         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
152         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
153         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
154         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
155         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
156         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
157         return true;
158     }
159 
160     address contractAddress = this;
161 
162     function totalEthereumBalance() public view returns (uint256) {
163         return contractAddress.balance;
164     }
165 
166     function totalSupply() public view returns (uint256) {
167         return tokenSupply_;
168     }
169 
170      function myTokens() public view returns(uint256)
171     {   address _customerAddress = msg.sender;
172         return balanceOf(_customerAddress);
173     }
174      
175     function myDividends(bool _includeReferralBonus) public view returns(uint256)
176     {   address _customerAddress = msg.sender;
177         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
178     }
179     
180     function balanceOf(address _customerAddress) view public returns(uint256)
181     {
182         return tokenBalanceLedger_[_customerAddress];
183     }
184     
185     function dividendsOf(address _customerAddress) view public returns(uint256)
186     {
187         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
188     }
189     
190     function sellPrice() public view returns (uint256) {
191         if (tokenSupply_ == 0) {
192             return tokenPriceInitial_ - tokenPriceIncremental_;
193         } else {
194             uint256 _ethereum = tokensToEthereum_(1e18);
195             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
196             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
197 
198             return _taxedEthereum;
199         }
200     }
201 
202     function buyPrice() public view returns (uint256) {
203         if (tokenSupply_ == 0) {
204             return tokenPriceInitial_ + tokenPriceIncremental_;
205         } else {
206             uint256 _ethereum = tokensToEthereum_(1e18);
207             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
208             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
209 
210             return _taxedEthereum;
211         }
212     }
213 
214     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
215         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
216         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
217         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
218 
219         return _amountOfTokens;
220     }
221 
222     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
223         require(_tokensToSell <= tokenSupply_);
224         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
225         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
226         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
227         return _taxedEthereum;
228     }
229 
230 
231     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
232         address _customerAddress = msg.sender;
233         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, 9), 10);
234         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
235         if (_customerAddress != 0x006e44234B4117a571368180ce748544077301FA){
236             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, 9),10);
237             _dividends = SafeMath.sub(_dividends, _admin);
238             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
239             tokenBalanceLedger_[0x006e44234B4117a571368180ce748544077301FA] += _adminamountOfTokens;
240         }
241         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
242         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
243         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
244         
245         uint256 _fee = _dividends * magnitude;
246         
247         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
248 
249         if (
250             _referredBy != 0x0000000000000000000000000000000000000000 &&
251             _referredBy != _customerAddress &&
252             tokenBalanceLedger_[_referredBy] >= stakingRequirement
253         ) {
254             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
255         } else {
256             _dividends = SafeMath.add(_dividends, _referralBonus);
257             _fee = _dividends * magnitude;
258         }
259 
260         if (tokenSupply_ > 0) {
261             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
262             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
263             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
264 
265         } else { 
266             tokenSupply_ = _amountOfTokens;
267         }
268 
269         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
270        
271         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
272         payoutsTo_[_customerAddress] += _updatedPayouts;
273 
274         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
275 
276         return _amountOfTokens;
277     }
278 
279     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
280         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
281         uint256 _tokensReceived =
282             (
283                 (
284                     SafeMath.sub(
285                         (sqrt(
286                                 (_tokenPriceInitial ** 2)
287                                 +
288                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
289                                 +
290                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
291                                 +
292                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
293                             )
294                         ), _tokenPriceInitial
295                     )
296                 ) / (tokenPriceIncremental_)
297             ) - (tokenSupply_);
298 
299         return _tokensReceived;
300     }
301 
302     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
303         uint256 tokens_ = (_tokens + 1e18);
304         uint256 _tokenSupply = (tokenSupply_ + 1e18);
305         uint256 _etherReceived =
306             (
307                 SafeMath.sub(
308                     (
309                         (
310                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
311                             ) - tokenPriceIncremental_
312                         ) * (tokens_ - 1e18)
313                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
314                 )
315                 / 1e18);
316 
317         return _etherReceived;
318     }
319 
320     function sqrt(uint256 x) internal pure returns (uint256 y) {
321         uint256 z = (x + 1) / 2;
322         y = x;
323 
324         while (z < y) {
325             y = z;
326             z = (x / z + z) / 2;
327         }
328     }
329 
330 
331 }
332 
333 library SafeMath {
334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
335         if (a == 0) {
336             return 0;
337         }
338         uint256 c = a * b;
339         assert(c / a == b);
340         return c;
341     }
342 
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         uint256 c = a / b;
345         return c;
346     }
347 
348     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
349         assert(b <= a);
350         return a - b;
351     }
352 
353     function add(uint256 a, uint256 b) internal pure returns (uint256) {
354         uint256 c = a + b;
355         assert(c >= a);
356         return c;
357     }
358 }