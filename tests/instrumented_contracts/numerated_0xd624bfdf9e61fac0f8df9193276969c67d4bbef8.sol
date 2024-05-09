1 pragma solidity ^0.4.25;
2 
3 contract CryptoLike {
4 
5     modifier onlyBagholders {
6         require(myTokens() > 0);
7         _;
8     }
9 
10     modifier onlyStronghands {
11         require(myDividends(true) > 0);
12         _;
13     }
14 
15     event onTokenPurchase(
16         address indexed customerAddress,
17         uint256 incomingEthereum,
18         uint256 tokensMinted,
19         address indexed referredBy,
20         uint timestamp,
21         uint256 price
22 );
23 
24     event onTokenSell(
25         address indexed customerAddress,
26         uint256 tokensBurned,
27         uint256 ethereumEarned,
28         uint timestamp,
29         uint256 price
30 );
31 
32     event onReinvestment(
33         address indexed customerAddress,
34         uint256 ethereumReinvested,
35         uint256 tokensMinted
36 );
37 
38     event onWithdraw(
39         address indexed customerAddress,
40         uint256 ethereumWithdrawn
41 );
42 
43     event Transfer(
44         address indexed from,
45         address indexed to,
46         uint256 tokens
47 );
48 
49     string public name = "CryptoLike";
50     string public symbol = "CLK";
51     uint8 constant public decimals = 18;
52     uint8 constant internal entryFee_ = 10;
53     uint8 constant internal transferFee_ = 1;
54     uint8 constant internal exitFee_ = 4;
55     uint8 constant internal refferalFee_ = 33;
56     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
57     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
58     uint256 constant internal magnitude = 2 ** 64;
59     uint256 public stakingRequirement = 50e18;
60     mapping(address => uint256) internal tokenBalanceLedger_;
61     mapping(address => uint256) internal referralBalance_;
62     mapping(address => int256) internal payoutsTo_;
63     uint256 internal tokenSupply_;
64     uint256 internal profitPerShare_;
65 
66     function buy(address _referredBy) public payable returns (uint256) {
67         purchaseTokens(msg.value, _referredBy);
68     }
69 
70     function() payable public {
71         purchaseTokens(msg.value, 0x0);
72     }
73 
74     function reinvest() onlyStronghands public {
75         uint256 _dividends = myDividends(false);
76         address _customerAddress = msg.sender;
77         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
78         _dividends += referralBalance_[_customerAddress];
79         referralBalance_[_customerAddress] = 0;
80         uint256 _tokens = purchaseTokens(_dividends, 0x0);
81         emit onReinvestment(_customerAddress, _dividends, _tokens);
82     }
83 
84     function exit() public {
85         address _customerAddress = msg.sender;
86         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
87         if (_tokens > 0) sell(_tokens);
88         withdraw();
89     }
90 
91     function withdraw() onlyStronghands public {
92         address _customerAddress = msg.sender;
93         uint256 _dividends = myDividends(false);
94         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
95         _dividends += referralBalance_[_customerAddress];
96         referralBalance_[_customerAddress] = 0;
97         _customerAddress.transfer(_dividends);
98         emit onWithdraw(_customerAddress, _dividends);
99     }
100 
101     function sell(uint256 _amountOfTokens) onlyBagholders public {
102         address _customerAddress = msg.sender;
103         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
104         uint256 _tokens = _amountOfTokens;
105         uint256 _ethereum = tokensToEthereum_(_tokens);
106         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
107         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
108 
109         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
110         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
111 
112         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
113         payoutsTo_[_customerAddress] -= _updatedPayouts;
114 
115         if (tokenSupply_ > 0) {
116             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
117         }
118         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
119     }
120 
121     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
122         address _customerAddress = msg.sender;
123         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
124 
125         if (myDividends(true) > 0) {
126             withdraw();
127         }
128 
129         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
130         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
131         uint256 _dividends = tokensToEthereum_(_tokenFee);
132 
133         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
134         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
135         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
136         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
137         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
138         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
139         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
140         return true;
141     }
142 
143 
144     function totalEthereumBalance() public view returns (uint256) {
145         return address(this).balance;
146     }
147 
148     function totalSupply() public view returns (uint256) {
149         return tokenSupply_;
150     }
151 
152     function myTokens() public view returns (uint256) {
153         address _customerAddress = msg.sender;
154         return balanceOf(_customerAddress);
155     }
156 
157     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
158         address _customerAddress = msg.sender;
159         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
160     }
161 
162     function balanceOf(address _customerAddress) public view returns (uint256) {
163         return tokenBalanceLedger_[_customerAddress];
164     }
165 
166     function dividendsOf(address _customerAddress) public view returns (uint256) {
167         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
168     }
169 
170     function sellPrice() public view returns (uint256) {
171         // our calculation relies on the token supply, so we need supply. Doh.
172         if (tokenSupply_ == 0) {
173             return tokenPriceInitial_ - tokenPriceIncremental_;
174         } else {
175             uint256 _ethereum = tokensToEthereum_(1e18);
176             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
177             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
178 
179             return _taxedEthereum;
180         }
181     }
182 
183     function buyPrice() public view returns (uint256) {
184         if (tokenSupply_ == 0) {
185             return tokenPriceInitial_ + tokenPriceIncremental_;
186         } else {
187             uint256 _ethereum = tokensToEthereum_(1e18);
188             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
189             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
190 
191             return _taxedEthereum;
192         }
193     }
194 
195     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
196         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
197         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
198         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
199 
200         return _amountOfTokens;
201     }
202 
203     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
204         require(_tokensToSell <= tokenSupply_);
205         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
206         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
207         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
208         return _taxedEthereum;
209     }
210 
211 
212     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
213         address _customerAddress = msg.sender;
214         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
215         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
216         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
217         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
218         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
219         uint256 _fee = _dividends * magnitude;
220 
221         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
222 
223         if (
224             _referredBy != 0x0000000000000000000000000000000000000000 &&
225             _referredBy != _customerAddress &&
226             tokenBalanceLedger_[_referredBy] >= stakingRequirement
227         ) {
228             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
229         } else {
230             _dividends = SafeMath.add(_dividends, _referralBonus);
231             _fee = _dividends * magnitude;
232         }
233 
234         if (tokenSupply_ > 0) {
235             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
236             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
237             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
238         } else {
239             tokenSupply_ = _amountOfTokens;
240         }
241 
242         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
243         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
244         payoutsTo_[_customerAddress] += _updatedPayouts;
245         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
246 
247         return _amountOfTokens;
248     }
249 
250     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
251         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
252         uint256 _tokensReceived =
253             (
254                 (
255                     SafeMath.sub(
256                         (sqrt
257                             (
258                                 (_tokenPriceInitial ** 2)
259                                 +
260                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
261                                 +
262                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
263                                 +
264                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
265                             )
266                         ), _tokenPriceInitial
267                     )
268                 ) / (tokenPriceIncremental_)
269             ) - (tokenSupply_);
270 
271         return _tokensReceived;
272     }
273 
274     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
275         uint256 tokens_ = (_tokens + 1e18);
276         uint256 _tokenSupply = (tokenSupply_ + 1e18);
277         uint256 _etherReceived =
278             (
279                 SafeMath.sub(
280                     (
281                         (
282                             (
283                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
284                             ) - tokenPriceIncremental_
285                         ) * (tokens_ - 1e18)
286                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
287                 )
288                 / 1e18);
289 
290         return _etherReceived;
291     }
292 
293     function sqrt(uint256 x) internal pure returns (uint256 y) {
294         uint256 z = (x + 1) / 2;
295         y = x;
296 
297         while (z < y) {
298             y = z;
299             z = (x / z + z) / 2;
300         }
301     }
302 
303 
304 }
305 
306 library SafeMath {
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         if (a == 0) {
309             return 0;
310         }
311         uint256 c = a * b;
312         assert(c / a == b);
313         return c;
314     }
315 
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         uint256 c = a / b;
318         return c;
319     }
320 
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         assert(b <= a);
323         return a - b;
324     }
325 
326     function add(uint256 a, uint256 b) internal pure returns (uint256) {
327         uint256 c = a + b;
328         assert(c >= a);
329         return c;
330     }
331 }