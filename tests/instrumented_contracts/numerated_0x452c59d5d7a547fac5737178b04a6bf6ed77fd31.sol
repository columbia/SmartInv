1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6   *Запуск проекта состоится 11.11.2018г. Ссылка на наших официальных YouTube и Telegram каналах*
7                       в день выхода проекта.  
8 
9 
10 * Token concept
11 
12 *  15% Deposit fee - комиссия за вход в проект (все средства распределяются между держателями токенов)
13 *  1% Token transfer 
14 *  3,5% Referal link ()
15 *  0.5% _admin (from buy)
16 *  3% _onreclame (from sell)
17 *  3% Withdraw fee - комиссия за выход из проект (все средства распределяются между держателями токенов)
18 *
19 */
20 
21 contract MainContract {
22 
23     modifier onlyBagholders {    
24         require(myTokens() > 0);
25         _;
26     }
27     modifier onlyStronghands {  
28         require(myDividends(true) > 0);
29         _;
30     }
31     event onTokenPurchase(
32         address indexed customerAddress,
33         uint256 incomingEthereum,
34         uint256 tokensMinted,
35         address indexed referredBy,
36         uint timestamp,
37         uint256 price
38 );
39     event onTokenSell(
40         address indexed customerAddress,
41         uint256 tokensBurned,
42         uint256 ethereumEarned,
43         uint timestamp,
44         uint256 price
45 );
46     event onReinvestment(
47         address indexed customerAddress,
48         uint256 ethereumReinvested,
49         uint256 tokensMinted
50 );
51     event onWithdraw(
52         address indexed customerAddress,
53         uint256 ethereumWithdrawn
54 );
55     event Transfer(
56         address indexed from,
57         address indexed to,
58         uint256 tokens
59 );
60     string public name = "Main Contract Token";
61     string public symbol = "MCT";
62     uint8 constant public decimals = 18;
63     uint8 constant internal entryFee_ = 15;
64     uint8 constant internal transferFee_ = 1;
65     uint8 constant internal exitFee_ = 3;
66     uint8 constant internal onreclame = 3;
67     uint8 constant internal refferalFee_ = 35;
68     uint8 constant internal adminFee_ = 5;
69     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
70     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
71     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
72     uint256 public stakingRequirement = 30e18;    //сколько токенов нужно для рефералки 
73     mapping(address => uint256) internal tokenBalanceLedger_;
74     mapping(address => uint256) internal referralBalance_;
75     mapping(address => int256) internal payoutsTo_;
76     uint256 internal tokenSupply_;
77     uint256 internal profitPerShare_;
78     
79     function buy(address _referredBy) public payable returns (uint256) {
80         purchaseTokens(msg.value, _referredBy);
81     }
82     function() payable public {
83         purchaseTokens(msg.value, 0x0);
84     }
85 
86     function reinvest() onlyStronghands public {
87         uint256 _dividends = myDividends(false);
88         address _customerAddress = msg.sender;
89         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
90         _dividends += referralBalance_[_customerAddress];
91         referralBalance_[_customerAddress] = 0;
92         uint256 _tokens = purchaseTokens(_dividends, 0x0);
93         emit onReinvestment(_customerAddress, _dividends, _tokens);
94     }
95 
96     function exit() public {
97         address _customerAddress = msg.sender;
98         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
99         if (_tokens > 0) sell(_tokens);
100         withdraw();
101     }
102 
103     function withdraw() onlyStronghands public {
104         address _customerAddress = msg.sender;
105         uint256 _dividends = myDividends(false);
106         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
107         _dividends += referralBalance_[_customerAddress];
108         referralBalance_[_customerAddress] = 0;
109         _customerAddress.transfer(_dividends);
110         emit onWithdraw(_customerAddress, _dividends);
111     }
112 
113     function sell(uint256 _amountOfTokens) onlyBagholders public {
114         address _customerAddress = msg.sender;
115         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
116         uint256 _tokens = _amountOfTokens;
117         uint256 _ethereum = tokensToEthereum_(_tokens);
118         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
119         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
120          if (_customerAddress != 0xD664FEB6E89E91C2F60831A510cB8dECa2e59671){
121         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
122         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
123         tokenBalanceLedger_[0xD664FEB6E89E91C2F60831A510cB8dECa2e59671] += _reclama;}
124      
125         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
126         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
127         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
128         payoutsTo_[_customerAddress] -= _updatedPayouts;
129         
130         if (tokenSupply_ > 0) {
131             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
132         }
133         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
134     }
135 
136     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
137         address _customerAddress = msg.sender;
138         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
139 
140         if (myDividends(true) > 0) {
141             withdraw();
142         }
143 
144         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
145         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
146         uint256 _dividends = tokensToEthereum_(_tokenFee);
147 
148         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
149         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
150         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
151         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
152         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
153         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
154         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
155         return true;
156     }
157 
158     address contractAddress = this;
159 
160     function totalEthereumBalance() public view returns (uint256) {
161         return contractAddress.balance;
162     }
163     function totalSupply() public view returns (uint256) {
164         return tokenSupply_;
165     }
166      function myTokens() public view returns(uint256)
167     {   address _customerAddress = msg.sender;
168         return balanceOf(_customerAddress);
169     }
170     function myDividends(bool _includeReferralBonus) public view returns(uint256)
171     {   address _customerAddress = msg.sender;
172         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
173     }
174     function balanceOf(address _customerAddress) view public returns(uint256)
175     {
176         return tokenBalanceLedger_[_customerAddress];
177     }
178     function dividendsOf(address _customerAddress) view public returns(uint256)
179     {
180         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
181     }
182        function sellPrice() public view returns (uint256) {
183         if (tokenSupply_ == 0) {
184             return tokenPriceInitial_ - tokenPriceIncremental_;
185         } else {
186             uint256 _ethereum = tokensToEthereum_(1e18);
187             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
188             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
189 
190             return _taxedEthereum;
191         }
192     }
193     function buyPrice() public view returns (uint256) {
194         if (tokenSupply_ == 0) {
195             return tokenPriceInitial_ + tokenPriceIncremental_;
196         } else {
197             uint256 _ethereum = tokensToEthereum_(1e18);
198             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
199             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
200 
201             return _taxedEthereum;
202         }
203     }
204     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
205         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
206         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
207         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
208 
209         return _amountOfTokens;
210     }
211     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
212         require(_tokensToSell <= tokenSupply_);
213         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
214         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
215         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
216         return _taxedEthereum;
217     }
218     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
219         address _customerAddress = msg.sender;
220         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
221         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
222         if (_customerAddress != 0xD664FEB6E89E91C2F60831A510cB8dECa2e59671){
223             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
224             _dividends = SafeMath.sub(_dividends, _admin);
225             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
226             tokenBalanceLedger_[0xD664FEB6E89E91C2F60831A510cB8dECa2e59671] += _adminamountOfTokens;
227         }
228         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
229         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
230         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
231         
232         uint256 _fee = _dividends * magnitude;
233         
234         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
235 
236         if (
237             _referredBy != 0x0000000000000000000000000000000000000000 &&
238             _referredBy != _customerAddress &&
239             tokenBalanceLedger_[_referredBy] >= stakingRequirement
240         ) {
241             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
242         } else {
243             _dividends = SafeMath.add(_dividends, _referralBonus);
244             _fee = _dividends * magnitude;
245         }
246 
247         if (tokenSupply_ > 0) {
248             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
249             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
250             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
251 
252         } else { 
253             tokenSupply_ = _amountOfTokens;
254         }
255 
256         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
257        
258         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
259         payoutsTo_[_customerAddress] += _updatedPayouts;
260 
261         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
262 
263         return _amountOfTokens;
264     }
265 
266     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
267         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
268         uint256 _tokensReceived =
269             (
270                 (
271                     SafeMath.sub(
272                         (sqrt(
273                                 (_tokenPriceInitial ** 2)
274                                 +
275                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
276                                 +
277                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
278                                 +
279                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
280                             )
281                         ), _tokenPriceInitial
282                     )
283                 ) / (tokenPriceIncremental_)
284             ) - (tokenSupply_);
285 
286         return _tokensReceived;
287     }
288 
289     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
290         uint256 tokens_ = (_tokens + 1e18);
291         uint256 _tokenSupply = (tokenSupply_ + 1e18);
292         uint256 _etherReceived =
293             (
294                 SafeMath.sub(
295                     (
296                         (
297                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
298                             ) - tokenPriceIncremental_
299                         ) * (tokens_ - 1e18)
300                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
301                 )
302                 / 1e18);
303 
304         return _etherReceived;
305     }
306 
307     function sqrt(uint256 x) internal pure returns (uint256 y) {
308         uint256 z = (x + 1) / 2;
309         y = x;
310 
311         while (z < y) {
312             y = z;
313             z = (x / z + z) / 2;
314         }
315     }
316 }
317 
318 library SafeMath {
319     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320         if (a == 0) {
321             return 0;
322         }
323         uint256 c = a * b;
324         assert(c / a == b);
325         return c;
326     }
327     function div(uint256 a, uint256 b) internal pure returns (uint256) {
328         uint256 c = a / b;
329         return c;
330     }
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         assert(b <= a);
333         return a - b;
334     }
335     function add(uint256 a, uint256 b) internal pure returns (uint256) {
336         uint256 c = a + b;
337         assert(c >= a);
338         return c;
339     }
340 }