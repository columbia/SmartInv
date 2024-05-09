1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6  该项目将在11.11.2018上启动。 链接到我们的官方电报和Youtube频道在发射当天的项目。
7 
8 
9 * Token concept
10 
11 *  15% Deposit fee - 进入项目的费用（所有资金都分配给代币的持有人)
12 *  1% Token transfer 
13 *  3,5% Referal link ()
14 *  0.5% _admin (from buy)
15 *  3% _onreclame (from sell)
16 *  3% Withdraw fee - 从项目中撤出的佣金（所有资金都分配给代币的持有人)
17 *
18 */
19 
20 contract TokenForMainContract {
21 
22     modifier onlyBagholders {    
23         require(myTokens() > 0);
24         _;
25     }
26     modifier onlyStronghands {  
27         require(myDividends(true) > 0);
28         _;
29     }
30     event onTokenPurchase(
31         address indexed customerAddress,
32         uint256 incomingEthereum,
33         uint256 tokensMinted,
34         address indexed referredBy,
35         uint timestamp,
36         uint256 price
37 );
38     event onTokenSell(
39         address indexed customerAddress,
40         uint256 tokensBurned,
41         uint256 ethereumEarned,
42         uint timestamp,
43         uint256 price
44 );
45     event onReinvestment(
46         address indexed customerAddress,
47         uint256 ethereumReinvested,
48         uint256 tokensMinted
49 );
50     event onWithdraw(
51         address indexed customerAddress,
52         uint256 ethereumWithdrawn
53 );
54     event Transfer(
55         address indexed from,
56         address indexed to,
57         uint256 tokens
58 );
59     string public name = "Token For Main Contract";
60     string public symbol = "TFMC";
61     uint8 constant public decimals = 18;
62     uint8 constant internal entryFee_ = 15;
63     uint8 constant internal transferFee_ = 1;
64     uint8 constant internal exitFee_ = 3;
65     uint8 constant internal onreclame = 3;
66     uint8 constant internal refferalFee_ = 35;
67     uint8 constant internal adminFee_ = 5;
68     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; 
69     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; 
70     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
71     uint256 public stakingRequirement = 30e18;    
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     uint256 internal tokenSupply_;
76     uint256 internal profitPerShare_;
77     
78     function buy(address _referredBy) public payable returns (uint256) {
79         purchaseTokens(msg.value, _referredBy);
80     }
81     function() payable public {
82         purchaseTokens(msg.value, 0x0);
83     }
84 
85     function reinvest() onlyStronghands public {
86         uint256 _dividends = myDividends(false);
87         address _customerAddress = msg.sender;
88         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
89         _dividends += referralBalance_[_customerAddress];
90         referralBalance_[_customerAddress] = 0;
91         uint256 _tokens = purchaseTokens(_dividends, 0x0);
92         emit onReinvestment(_customerAddress, _dividends, _tokens);
93     }
94 
95     function exit() public {
96         address _customerAddress = msg.sender;
97         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
98         if (_tokens > 0) sell(_tokens);
99         withdraw();
100     }
101 
102     function withdraw() onlyStronghands public {
103         address _customerAddress = msg.sender;
104         uint256 _dividends = myDividends(false);
105         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
106         _dividends += referralBalance_[_customerAddress];
107         referralBalance_[_customerAddress] = 0;
108         _customerAddress.transfer(_dividends);
109         emit onWithdraw(_customerAddress, _dividends);
110     }
111 
112     function sell(uint256 _amountOfTokens) onlyBagholders public {
113         address _customerAddress = msg.sender;
114         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
115         uint256 _tokens = _amountOfTokens;
116         uint256 _ethereum = tokensToEthereum_(_tokens);
117         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
118         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
119          if (_customerAddress != 0x5eD5c934c17EBbb5CF52f4B2b653Fa563B44C645){
120         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
121         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
122         tokenBalanceLedger_[0x5eD5c934c17EBbb5CF52f4B2b653Fa563B44C645] += _reclama;}
123      
124         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
125         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
126         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
127         payoutsTo_[_customerAddress] -= _updatedPayouts;
128         
129         if (tokenSupply_ > 0) {
130             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
131         }
132         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
133     }
134 
135     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
136         address _customerAddress = msg.sender;
137         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
138 
139         if (myDividends(true) > 0) {
140             withdraw();
141         }
142 
143         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
144         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
145         uint256 _dividends = tokensToEthereum_(_tokenFee);
146 
147         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
148         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
149         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
150         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
151         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
152         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
153         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
154         return true;
155     }
156 
157     address contractAddress = this;
158 
159     function totalEthereumBalance() public view returns (uint256) {
160         return contractAddress.balance;
161     }
162     function totalSupply() public view returns (uint256) {
163         return tokenSupply_;
164     }
165      function myTokens() public view returns(uint256)
166     {   address _customerAddress = msg.sender;
167         return balanceOf(_customerAddress);
168     }
169     function myDividends(bool _includeReferralBonus) public view returns(uint256)
170     {   address _customerAddress = msg.sender;
171         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
172     }
173     function balanceOf(address _customerAddress) view public returns(uint256)
174     {
175         return tokenBalanceLedger_[_customerAddress];
176     }
177     function dividendsOf(address _customerAddress) view public returns(uint256)
178     {
179         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
180     }
181        function sellPrice() public view returns (uint256) {
182         if (tokenSupply_ == 0) {
183             return tokenPriceInitial_ - tokenPriceIncremental_;
184         } else {
185             uint256 _ethereum = tokensToEthereum_(1e18);
186             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
187             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
188 
189             return _taxedEthereum;
190         }
191     }
192     function buyPrice() public view returns (uint256) {
193         if (tokenSupply_ == 0) {
194             return tokenPriceInitial_ + tokenPriceIncremental_;
195         } else {
196             uint256 _ethereum = tokensToEthereum_(1e18);
197             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
198             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
199 
200             return _taxedEthereum;
201         }
202     }
203     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
204         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
205         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
206         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
207 
208         return _amountOfTokens;
209     }
210     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
211         require(_tokensToSell <= tokenSupply_);
212         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
213         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
214         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
215         return _taxedEthereum;
216     }
217     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
218         address _customerAddress = msg.sender;
219         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
220         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
221         if (_customerAddress != 0x5eD5c934c17EBbb5CF52f4B2b653Fa563B44C645){
222             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
223             _dividends = SafeMath.sub(_dividends, _admin);
224             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
225             tokenBalanceLedger_[0x5eD5c934c17EBbb5CF52f4B2b653Fa563B44C645] += _adminamountOfTokens;
226         }
227         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
228         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
229         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
230         
231         uint256 _fee = _dividends * magnitude;
232         
233         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
234 
235         if (
236             _referredBy != 0x0000000000000000000000000000000000000000 &&
237             _referredBy != _customerAddress &&
238             tokenBalanceLedger_[_referredBy] >= stakingRequirement
239         ) {
240             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
241         } else {
242             _dividends = SafeMath.add(_dividends, _referralBonus);
243             _fee = _dividends * magnitude;
244         }
245 
246         if (tokenSupply_ > 0) {
247             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
248             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
249             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
250 
251         } else { 
252             tokenSupply_ = _amountOfTokens;
253         }
254 
255         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
256        
257         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
258         payoutsTo_[_customerAddress] += _updatedPayouts;
259 
260         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
261 
262         return _amountOfTokens;
263     }
264 
265     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
266         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
267         uint256 _tokensReceived =
268             (
269                 (
270                     SafeMath.sub(
271                         (sqrt(
272                                 (_tokenPriceInitial ** 2)
273                                 +
274                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
275                                 +
276                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
277                                 +
278                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
279                             )
280                         ), _tokenPriceInitial
281                     )
282                 ) / (tokenPriceIncremental_)
283             ) - (tokenSupply_);
284 
285         return _tokensReceived;
286     }
287 
288     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
289         uint256 tokens_ = (_tokens + 1e18);
290         uint256 _tokenSupply = (tokenSupply_ + 1e18);
291         uint256 _etherReceived =
292             (
293                 SafeMath.sub(
294                     (
295                         (
296                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
297                             ) - tokenPriceIncremental_
298                         ) * (tokens_ - 1e18)
299                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
300                 )
301                 / 1e18);
302 
303         return _etherReceived;
304     }
305 
306     function sqrt(uint256 x) internal pure returns (uint256 y) {
307         uint256 z = (x + 1) / 2;
308         y = x;
309 
310         while (z < y) {
311             y = z;
312             z = (x / z + z) / 2;
313         }
314     }
315 }
316 
317 library SafeMath {
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         if (a == 0) {
320             return 0;
321         }
322         uint256 c = a * b;
323         assert(c / a == b);
324         return c;
325     }
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         uint256 c = a / b;
328         return c;
329     }
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         assert(b <= a);
332         return a - b;
333     }
334     function add(uint256 a, uint256 b) internal pure returns (uint256) {
335         uint256 c = a + b;
336         assert(c >= a);
337         return c;
338     }
339 }