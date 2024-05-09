1 pragma solidity ^0.4.25;
2 
3 /*
4 * Token concept
5 *  3% Withdraw fee - выход
6 *  13% Deposit fee - вход
7 *  1% Token transfer 
8 *  3,5% Referal link ()
9 *  0.5% _admin (from buy)
10 *  3% _onreclame (from sell)
11 *
12 */
13 
14 contract miningtokenforever {
15 
16     modifier onlyBagholders {    
17         require(myTokens() > 0);
18         _;
19     }
20     modifier onlyStronghands {  
21         require(myDividends(true) > 0);
22         _;
23     }
24     event onTokenPurchase(
25         address indexed customerAddress,
26         uint256 incomingEthereum,
27         uint256 tokensMinted,
28         address indexed referredBy,
29         uint timestamp,
30         uint256 price
31 );
32     event onTokenSell(
33         address indexed customerAddress,
34         uint256 tokensBurned,
35         uint256 ethereumEarned,
36         uint timestamp,
37         uint256 price
38 );
39     event onReinvestment(
40         address indexed customerAddress,
41         uint256 ethereumReinvested,
42         uint256 tokensMinted
43 );
44     event onWithdraw(
45         address indexed customerAddress,
46         uint256 ethereumWithdrawn
47 );
48     event Transfer(
49         address indexed from,
50         address indexed to,
51         uint256 tokens
52 );
53     string public name = "mining token forever";
54     string public symbol = "MTF";
55     uint8 constant public decimals = 18;
56     uint8 constant internal entryFee_ = 13;
57     uint8 constant internal transferFee_ = 1;
58     uint8 constant internal exitFee_ = 3;
59     uint8 constant internal onreclame = 3;
60     uint8 constant internal refferalFee_ = 35;
61     uint8 constant internal adminFee_ = 5;
62     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
63     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
64     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
65     uint256 public stakingRequirement = 20e18;    //сколько токенов нужно для рефералки 
66     mapping(address => uint256) internal tokenBalanceLedger_;
67     mapping(address => uint256) internal referralBalance_;
68     mapping(address => int256) internal payoutsTo_;
69     uint256 internal tokenSupply_;
70     uint256 internal profitPerShare_;
71     
72     function buy(address _referredBy) public payable returns (uint256) {
73         purchaseTokens(msg.value, _referredBy);
74     }
75 
76     function() payable public {
77         purchaseTokens(msg.value, 0x0);
78     }
79 
80     function reinvest() onlyStronghands public {
81         uint256 _dividends = myDividends(false);
82         address _customerAddress = msg.sender;
83         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
84         _dividends += referralBalance_[_customerAddress];
85         referralBalance_[_customerAddress] = 0;
86         uint256 _tokens = purchaseTokens(_dividends, 0x0);
87         emit onReinvestment(_customerAddress, _dividends, _tokens);
88     }
89 
90     function exit() public {
91         address _customerAddress = msg.sender;
92         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
93         if (_tokens > 0) sell(_tokens);
94         withdraw();
95     }
96 
97     function withdraw() onlyStronghands public {
98         address _customerAddress = msg.sender;
99         uint256 _dividends = myDividends(false);
100         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
101         _dividends += referralBalance_[_customerAddress];
102         referralBalance_[_customerAddress] = 0;
103         _customerAddress.transfer(_dividends);
104         emit onWithdraw(_customerAddress, _dividends);
105     }
106 
107     function sell(uint256 _amountOfTokens) onlyBagholders public {
108         address _customerAddress = msg.sender;
109         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
110         uint256 _tokens = _amountOfTokens;
111         uint256 _ethereum = tokensToEthereum_(_tokens);
112         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
113         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
114          if (_customerAddress != 0xe29E740D736742645628b91836bC2bf2E003bD3f){
115         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
116         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
117         tokenBalanceLedger_[0xe29E740D736742645628b91836bC2bf2E003bD3f] += _reclama;}
118      
119         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
120         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
121         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
122         payoutsTo_[_customerAddress] -= _updatedPayouts;
123         
124         if (tokenSupply_ > 0) {
125             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
126         }
127         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
128     }
129 
130     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
131         address _customerAddress = msg.sender;
132         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
133 
134         if (myDividends(true) > 0) {
135             withdraw();
136         }
137 
138         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
139         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
140         uint256 _dividends = tokensToEthereum_(_tokenFee);
141 
142         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
143         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
144         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
145         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
146         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
147         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
148         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
149         return true;
150     }
151 
152     address contractAddress = this;
153 
154     function totalEthereumBalance() public view returns (uint256) {
155         return contractAddress.balance;
156     }
157 
158     function totalSupply() public view returns (uint256) {
159         return tokenSupply_;
160     }
161 
162      function myTokens() public view returns(uint256)
163     {   address _customerAddress = msg.sender;
164         return balanceOf(_customerAddress);
165     }
166      
167     function myDividends(bool _includeReferralBonus) public view returns(uint256)
168     {   address _customerAddress = msg.sender;
169         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
170     }
171     
172     function balanceOf(address _customerAddress) view public returns(uint256)
173     {
174         return tokenBalanceLedger_[_customerAddress];
175     }
176     
177     function dividendsOf(address _customerAddress) view public returns(uint256)
178     {
179         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
180     }
181     
182     function sellPrice() public view returns (uint256) {
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
218 
219 
220     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
221         address _customerAddress = msg.sender;
222         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
223         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
224         if (_customerAddress != 0xe29E740D736742645628b91836bC2bf2E003bD3f){
225             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
226             _dividends = SafeMath.sub(_dividends, _admin);
227             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
228             tokenBalanceLedger_[0xe29E740D736742645628b91836bC2bf2E003bD3f] += _adminamountOfTokens;
229         }
230         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
231         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
232         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
233         
234         uint256 _fee = _dividends * magnitude;
235         
236         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
237 
238         if (
239             _referredBy != 0x0000000000000000000000000000000000000000 &&
240             _referredBy != _customerAddress &&
241             tokenBalanceLedger_[_referredBy] >= stakingRequirement
242         ) {
243             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
244         } else {
245             _dividends = SafeMath.add(_dividends, _referralBonus);
246             _fee = _dividends * magnitude;
247         }
248 
249         if (tokenSupply_ > 0) {
250             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
251             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
252             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
253 
254         } else { 
255             tokenSupply_ = _amountOfTokens;
256         }
257 
258         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
259        
260         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
261         payoutsTo_[_customerAddress] += _updatedPayouts;
262 
263         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
264 
265         return _amountOfTokens;
266     }
267 
268     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
269         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
270         uint256 _tokensReceived =
271             (
272                 (
273                     SafeMath.sub(
274                         (sqrt(
275                                 (_tokenPriceInitial ** 2)
276                                 +
277                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
278                                 +
279                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
280                                 +
281                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
282                             )
283                         ), _tokenPriceInitial
284                     )
285                 ) / (tokenPriceIncremental_)
286             ) - (tokenSupply_);
287 
288         return _tokensReceived;
289     }
290 
291     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
292         uint256 tokens_ = (_tokens + 1e18);
293         uint256 _tokenSupply = (tokenSupply_ + 1e18);
294         uint256 _etherReceived =
295             (
296                 SafeMath.sub(
297                     (
298                         (
299                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
300                             ) - tokenPriceIncremental_
301                         ) * (tokens_ - 1e18)
302                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
303                 )
304                 / 1e18);
305 
306         return _etherReceived;
307     }
308 
309     function sqrt(uint256 x) internal pure returns (uint256 y) {
310         uint256 z = (x + 1) / 2;
311         y = x;
312 
313         while (z < y) {
314             y = z;
315             z = (x / z + z) / 2;
316         }
317     }
318 
319 
320 }
321 
322 library SafeMath {
323     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324         if (a == 0) {
325             return 0;
326         }
327         uint256 c = a * b;
328         assert(c / a == b);
329         return c;
330     }
331 
332     function div(uint256 a, uint256 b) internal pure returns (uint256) {
333         uint256 c = a / b;
334         return c;
335     }
336 
337     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
338         assert(b <= a);
339         return a - b;
340     }
341 
342     function add(uint256 a, uint256 b) internal pure returns (uint256) {
343         uint256 c = a + b;
344         assert(c >= a);
345         return c;
346     }
347 }