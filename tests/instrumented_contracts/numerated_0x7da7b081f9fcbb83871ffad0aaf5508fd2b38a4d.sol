1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://globalmoney.group
5 *
6 * Добро пожаловать в GlobalMoneyGroup!
7 * Пришло время оставить эти другие схемы и присоединиться к аутентичной российской 
8 * платформе Ethereum. Геймплей прост и прям. Никаких обещаний или приманок для игрока, 
9 * ПРОСТО ПРИБЫЛЬ!
10 *
11 * Наш контракт был проверен CryptoManicsRU, и у нас есть отличное партнерство 
12 * с https://scmonit.com, которое выйдет очень скоро. Не упустите возможность получить прибыль у нас.
13 *
14 * Total Crypto miner token concept
15 *
16 * [✓] 4% Снятие платы / Withdraw fee
17 * [✓] 14% Плата за бронирование / Deposit fee
18 * [✓] 1% Передача токена / Token transfer
19 * [✓] 3% Реферальная ссылка / Referal link ()
20 * [✓] 1% _admin (from buy)
21 * [✓] 1% _onreclame (from sell)
22 *
23 */
24 
25 contract GlobalMoney {
26 
27     modifier onlyBagholders {    
28         require(myTokens() > 0);
29         _;
30     }
31 
32     modifier onlyStronghands {  
33         require(myDividends(true) > 0);
34         _;
35     }
36 
37     modifier onlyAdmin () {
38         require(msg.sender == admin);
39         _;
40     }
41 
42     modifier buyActive() {
43         require(active == true);
44         _;
45     }
46    
47     event onTokenPurchase(
48         address indexed customerAddress,
49         uint256 incomingEthereum,
50         uint256 tokensMinted,
51         address indexed referredBy,
52         uint timestamp,
53         uint256 price
54 );
55 
56     event onTokenSell(
57         address indexed customerAddress,
58         uint256 tokensBurned,
59         uint256 ethereumEarned,
60         uint timestamp,
61         uint256 price
62 );
63 
64     event onReinvestment(
65         address indexed customerAddress,
66         uint256 ethereumReinvested,
67         uint256 tokensMinted
68 );
69 
70     event onWithdraw(
71         address indexed customerAddress,
72         uint256 ethereumWithdrawn
73 );
74 
75     event Transfer(
76         address indexed from,
77         address indexed to,
78         uint256 tokens
79 );
80 
81     string public name = "GlobalMoney";
82     string public symbol = "GMG";
83     uint8 constant public decimals = 18;
84     uint8 constant internal entryFee_ = 14;
85     uint8 constant internal transferFee_ = 1;
86     uint8 constant internal exitFee_ = 4;
87     uint8 constant internal onreclame = 1;
88     uint8 constant internal refferalFee_ = 30;
89     uint8 constant internal adminFee_ = 10;
90     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
91     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
92     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
93     uint256 public stakingRequirement = 1e18;    //сколько токенов нужно для рефералки 
94     mapping(address => uint256) internal tokenBalanceLedger_;
95     mapping(address => uint256) internal referralBalance_;
96     mapping(address => int256) internal payoutsTo_;
97     bool internal active = false;
98     address internal admin;
99     uint256 internal tokenSupply_;
100     uint256 internal profitPerShare_;
101 
102     constructor() public {
103         admin = msg.sender;
104     }
105     
106     function buy(address _referredBy) buyActive public payable returns (uint256) {
107         purchaseTokens(msg.value, _referredBy);
108     }
109 
110     function() buyActive payable public {
111         purchaseTokens(msg.value, 0x0);
112     }
113 
114     function reinvest() buyActive onlyStronghands public {
115         uint256 _dividends = myDividends(false);
116         address _customerAddress = msg.sender;
117         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
118         _dividends += referralBalance_[_customerAddress];
119         referralBalance_[_customerAddress] = 0;
120         uint256 _tokens = purchaseTokens(_dividends, 0x0);
121         emit onReinvestment(_customerAddress, _dividends, _tokens);
122     }
123 
124     function exit() public {
125         address _customerAddress = msg.sender;
126         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
127         if (_tokens > 0) sell(_tokens);
128         withdraw();
129     }
130 
131     function withdraw() onlyStronghands public {
132         address _customerAddress = msg.sender;
133         uint256 _dividends = myDividends(false);
134         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
135         _dividends += referralBalance_[_customerAddress];
136         referralBalance_[_customerAddress] = 0;
137         _customerAddress.transfer(_dividends);
138         emit onWithdraw(_customerAddress, _dividends);
139     }
140 
141     function sell(uint256 _amountOfTokens) onlyBagholders public {
142         address _customerAddress = msg.sender;
143         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
144         uint256 _tokens = _amountOfTokens;
145         uint256 _ethereum = tokensToEthereum_(_tokens);
146         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
147         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
148         if (_customerAddress != admin ) {
149             uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
150             _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
151             tokenBalanceLedger_[admin] += _reclama;
152         }
153      
154         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
155         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
156         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
157         payoutsTo_[_customerAddress] -= _updatedPayouts;
158         
159         if (tokenSupply_ > 0) {
160             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
161         }
162         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
163     }
164 
165     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
166         address _customerAddress = msg.sender;
167         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
168 
169         if (myDividends(true) > 0) {
170             withdraw();
171         }
172 
173         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
174         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
175         uint256 _dividends = tokensToEthereum_(_tokenFee);
176 
177         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
178         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
179         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
180         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
181         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
182         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
183         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
184         return true;
185     }
186 
187     function setActive() onlyAdmin public payable {
188         purchaseTokens(msg.value, 0x0);
189         active = true;
190     }
191 
192     address contractAddress = this;
193 
194     function totalEthereumBalance() public view returns (uint256) {
195         return contractAddress.balance;
196     }
197 
198     function totalSupply() public view returns (uint256) {
199         return tokenSupply_;
200     }
201 
202      function myTokens() public view returns(uint256)
203     {   address _customerAddress = msg.sender;
204         return balanceOf(_customerAddress);
205     }
206      
207     function myDividends(bool _includeReferralBonus) public view returns(uint256)
208     {   address _customerAddress = msg.sender;
209         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
210     }
211     
212     function balanceOf(address _customerAddress) view public returns(uint256)
213     {
214         return tokenBalanceLedger_[_customerAddress];
215     }
216     
217     function dividendsOf(address _customerAddress) view public returns(uint256)
218     {
219         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
220     }
221     
222     function sellPrice() public view returns (uint256) {
223         if (tokenSupply_ == 0) {
224             return tokenPriceInitial_ - tokenPriceIncremental_;
225         } else {
226             uint256 _ethereum = tokensToEthereum_(1e18);
227             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
228             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
229 
230             return _taxedEthereum;
231         }
232     }
233 
234     function buyPrice() public view returns (uint256) {
235         if (tokenSupply_ == 0) {
236             return tokenPriceInitial_ + tokenPriceIncremental_;
237         } else {
238             uint256 _ethereum = tokensToEthereum_(1e18);
239             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
240             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
241 
242             return _taxedEthereum;
243         }
244     }
245 
246     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
247         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
248         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
249         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
250 
251         return _amountOfTokens;
252     }
253 
254     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
255         require(_tokensToSell <= tokenSupply_);
256         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
257         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
258         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
259         return _taxedEthereum;
260     }
261 
262 
263     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
264         address _customerAddress = msg.sender;
265         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
266         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
267         if (_customerAddress != admin) {
268             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
269             _dividends = SafeMath.sub(_dividends, _admin);
270             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
271             tokenBalanceLedger_[admin] += _adminamountOfTokens;
272         }
273         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
274         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
275         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
276         
277         uint256 _fee = _dividends * magnitude;
278         
279         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
280 
281         if (
282             _referredBy != 0x0000000000000000000000000000000000000000 &&
283             _referredBy != _customerAddress &&
284             tokenBalanceLedger_[_referredBy] >= stakingRequirement
285         ) {
286             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
287         } else {
288             _dividends = SafeMath.add(_dividends, _referralBonus);
289             _fee = _dividends * magnitude;
290         }
291 
292         if (tokenSupply_ > 0) {
293             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
294             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
295             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
296 
297         } else { 
298             tokenSupply_ = _amountOfTokens;
299         }
300 
301         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
302        
303         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
304         payoutsTo_[_customerAddress] += _updatedPayouts;
305 
306         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
307 
308         return _amountOfTokens;
309     }
310 
311     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
312         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
313         uint256 _tokensReceived =
314             (
315                 (
316                     SafeMath.sub(
317                         (sqrt(
318                                 (_tokenPriceInitial ** 2)
319                                 +
320                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
321                                 +
322                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
323                                 +
324                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
325                             )
326                         ), _tokenPriceInitial
327                     )
328                 ) / (tokenPriceIncremental_)
329             ) - (tokenSupply_);
330 
331         return _tokensReceived;
332     }
333 
334     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
335         uint256 tokens_ = (_tokens + 1e18);
336         uint256 _tokenSupply = (tokenSupply_ + 1e18);
337         uint256 _etherReceived =
338             (
339                 SafeMath.sub(
340                     (
341                         (
342                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
343                             ) - tokenPriceIncremental_
344                         ) * (tokens_ - 1e18)
345                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
346                 )
347                 / 1e18);
348 
349         return _etherReceived;
350     }
351 
352     function sqrt(uint256 x) internal pure returns (uint256 y) {
353         uint256 z = (x + 1) / 2;
354         y = x;
355 
356         while (z < y) {
357             y = z;
358             z = (x / z + z) / 2;
359         }
360     }
361 
362 
363 }
364 
365 library SafeMath {
366     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
367         if (a == 0) {
368             return 0;
369         }
370         uint256 c = a * b;
371         assert(c / a == b);
372         return c;
373     }
374 
375     function div(uint256 a, uint256 b) internal pure returns (uint256) {
376         uint256 c = a / b;
377         return c;
378     }
379 
380     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
381         assert(b <= a);
382         return a - b;
383     }
384 
385     function add(uint256 a, uint256 b) internal pure returns (uint256) {
386         uint256 c = a + b;
387         assert(c >= a);
388         return c;
389     }
390 }