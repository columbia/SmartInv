1 pragma solidity ^0.4.25;
2 
3 
4 contract GoldMiner {
5 
6     modifier onlyBagholders {
7         require(myTokens() > 0);
8         _;
9     }
10 
11     modifier onlyStronghands {
12         require(myDividends(true) > 0);
13         _;
14     }
15 
16     event onTokenPurchase(
17         address indexed customerAddress,
18         uint256 incomingEthereum,
19         uint256 tokensMinted,
20         address indexed referredBy,
21         uint timestamp,
22         uint256 price
23 );
24 
25     event onTokenSell(
26         address indexed customerAddress,
27         uint256 tokensBurned,
28         uint256 ethereumEarned,
29         uint timestamp,
30         uint256 price
31 );
32 
33     event onReinvestment(
34         address indexed customerAddress,
35         uint256 ethereumReinvested,
36         uint256 tokensMinted
37 );
38 
39     event onWithdraw(
40         address indexed customerAddress,
41         uint256 ethereumWithdrawn
42 );
43 
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 tokens
48 );
49 
50     string public name = "Gold Miner";
51     string public symbol = "GMR";
52     uint8 constant public decimals = 18;
53     uint8 constant internal entryFee_ = 10;
54     uint8 constant internal transferFee_ = 1;
55     uint8 constant internal exitFee_ = 4;
56     uint8 constant internal refferalFee_ = 33;
57     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
58     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
59     uint256 constant internal magnitude = 2 ** 64;
60     uint256 public stakingRequirement = 50e18;
61     mapping(address => uint256) internal tokenBalanceLedger_;
62     mapping(address => uint256) internal referralBalance_;
63     mapping(address => int256) internal payoutsTo_;
64     uint256 internal tokenSupply_;
65     uint256 internal profitPerShare_;
66 
67     function buy(address _referredBy) public payable returns (uint256) {
68         purchaseTokens(msg.value, _referredBy);
69     }
70 
71     function() payable public {
72         purchaseTokens(msg.value, 0x0);
73     }
74 
75     function reinvest() onlyStronghands public {
76         uint256 _dividends = myDividends(false);
77         address _customerAddress = msg.sender;
78         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
79         _dividends += referralBalance_[_customerAddress];
80         referralBalance_[_customerAddress] = 0;
81         uint256 _tokens = purchaseTokens(_dividends, 0x0);
82         emit onReinvestment(_customerAddress, _dividends, _tokens);
83     }
84 
85     function exit() public {
86         address _customerAddress = msg.sender;
87         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
88         if (_tokens > 0) sell(_tokens);
89         withdraw();
90     }
91 
92     function withdraw() onlyStronghands public {
93         address _customerAddress = msg.sender;
94         uint256 _dividends = myDividends(false);
95         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
96         _dividends += referralBalance_[_customerAddress];
97         referralBalance_[_customerAddress] = 0;
98         _customerAddress.transfer(_dividends);
99         emit onWithdraw(_customerAddress, _dividends);
100     }
101 
102     function sell(uint256 _amountOfTokens) onlyBagholders public {
103         address _customerAddress = msg.sender;
104         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
105         uint256 _tokens = _amountOfTokens;
106         uint256 _ethereum = tokensToEthereum_(_tokens);
107         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
108         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
109 
110         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
111         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
112 
113         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
114         payoutsTo_[_customerAddress] -= _updatedPayouts;
115 
116         if (tokenSupply_ > 0) {
117             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
118         }
119         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
120     }
121 
122     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
123         address _customerAddress = msg.sender;
124         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
125 
126         if (myDividends(true) > 0) {
127             withdraw();
128         }
129 
130         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
131         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
132         uint256 _dividends = tokensToEthereum_(_tokenFee);
133 
134         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
135         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
136         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
137         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
138         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
139         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
140         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
141         return true;
142     }
143 
144 
145     function totalEthereumBalance() public view returns (uint256) {
146         return address (this).balance;
147     }
148 
149     function totalSupply() public view returns (uint256) {
150         return tokenSupply_;
151     }
152 
153     function myTokens() public view returns (uint256) {
154         address _customerAddress = msg.sender;
155         return balanceOf(_customerAddress);
156     }
157 
158     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
159         address _customerAddress = msg.sender;
160         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
161     }
162 
163     function balanceOf(address _customerAddress) public view returns (uint256) {
164         return tokenBalanceLedger_[_customerAddress];
165     }
166 
167     function dividendsOf(address _customerAddress) public view returns (uint256) {
168         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
169     }
170 
171     function sellPrice() public view returns (uint256) {
172         // our calculation relies on the token supply, so we need supply. Doh.
173         if (tokenSupply_ == 0) {
174             return tokenPriceInitial_ - tokenPriceIncremental_;
175         } else {
176             uint256 _ethereum = tokensToEthereum_(1e18);
177             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
178             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
179 
180             return _taxedEthereum;
181         }
182     }
183 
184     function buyPrice() public view returns (uint256) {
185         if (tokenSupply_ == 0) {
186             return tokenPriceInitial_ + tokenPriceIncremental_;
187         } else {
188             uint256 _ethereum = tokensToEthereum_(1e18);
189             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
190             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
191 
192             return _taxedEthereum;
193         }
194     }
195 
196     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
197         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
198         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
199         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
200 
201         return _amountOfTokens;
202     }
203 
204     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
205         require(_tokensToSell <= tokenSupply_);
206         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
207         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
208         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
209         return _taxedEthereum;
210     }
211 
212 
213     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
214         address _customerAddress = msg.sender;
215         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
216         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
217         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
218         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
219         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
220         uint256 _fee = _dividends * magnitude;
221 
222         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
223 
224         if (
225             _referredBy != 0x0000000000000000000000000000000000000000 &&
226             _referredBy != _customerAddress &&
227             tokenBalanceLedger_[_referredBy] >= stakingRequirement
228         ) {
229             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
230         } else {
231             _dividends = SafeMath.add(_dividends, _referralBonus);
232             _fee = _dividends * magnitude;
233         }
234 
235         if (tokenSupply_ > 0) {
236             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
237             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
238             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
239         } else {
240             tokenSupply_ = _amountOfTokens;
241         }
242 
243         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
244         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
245         payoutsTo_[_customerAddress] += _updatedPayouts;
246         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
247 
248         return _amountOfTokens;
249     }
250 
251     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
252         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
253         uint256 _tokensReceived =
254             (
255                 (
256                     SafeMath.sub(
257                         (sqrt
258                             (
259                                 (_tokenPriceInitial ** 2)
260                                 +
261                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
262                                 +
263                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
264                                 +
265                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
266                             )
267                         ), _tokenPriceInitial
268                     )
269                 ) / (tokenPriceIncremental_)
270             ) - (tokenSupply_);
271 
272         return _tokensReceived;
273     }
274 
275     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
276         uint256 tokens_ = (_tokens + 1e18);
277         uint256 _tokenSupply = (tokenSupply_ + 1e18);
278         uint256 _etherReceived =
279             (
280                 SafeMath.sub(
281                     (
282                         (
283                             (
284                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
285                             ) - tokenPriceIncremental_
286                         ) * (tokens_ - 1e18)
287                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
288                 )
289                 / 1e18);
290 
291         return _etherReceived;
292     }
293 
294     function sqrt(uint256 x) internal pure returns (uint256 y) {
295         uint256 z = (x + 1) / 2;
296         y = x;
297 
298         while (z < y) {
299             y = z;
300             z = (x / z + z) / 2;
301         }
302     }
303 
304 
305 }
306 
307 library SafeMath {
308     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
309         if (a == 0) {
310             return 0;
311         }
312         uint256 c = a * b;
313         assert(c / a == b);
314         return c;
315     }
316 
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         uint256 c = a / b;
319         return c;
320     }
321 
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         assert(b <= a);
324         return a - b;
325     }
326 
327     function add(uint256 a, uint256 b) internal pure returns (uint256) {
328         uint256 c = a + b;
329         assert(c >= a);
330         return c;
331     }
332 }