1 pragma solidity ^0.4.20;
2 
3 /*
4 *
5 * From CryptoGaming Discord
6 * cryptogamingcoin.surge.sh
7 * https://discord.gg/jrvSZ5K
8 * ??????????????
9 *
10 * CRYPTOGAMINGCOIN (CGC)
11 * Join us to the MOOOOOOOOON!
12 *
13 * -> What?
14 * Incorporated the strong points of different POW{x}, best config:
15 * [✓] 20% dividends for token purchase, shared among all token holders.
16 * [✓] 10% dividends for token transfer, shared among all token holders.
17 * [✓] 25% dividends for token selling.
18 * [✓] 7% dividends is given to referrer.
19 * [✓] 50 tokens to activate Masternodes.
20 *????
21 */
22 
23 contract CryptoGaming {
24     modifier onlyBagholders {
25         require(myTokens() > 0);
26         _;
27     }
28     modifier onlyStronghands {
29         require(myDividends(true) > 0);
30         _;
31     }
32     event onTokenPurchase(
33         address indexed customerAddress,
34         uint256 incomingEthereum,
35         uint256 tokensMinted,
36         address indexed referredBy,
37         uint timestamp,
38         uint256 price
39     );
40     event onTokenSell(
41         address indexed customerAddress,
42         uint256 tokensBurned,
43         uint256 ethereumEarned,
44         uint timestamp,
45         uint256 price
46     );
47     event onReinvestment(
48         address indexed customerAddress,
49         uint256 ethereumReinvested,
50         uint256 tokensMinted
51     );
52     event onWithdraw(
53         address indexed customerAddress,
54         uint256 ethereumWithdrawn
55     );
56     // ERC20
57     event Transfer(
58         address indexed from,
59         address indexed to,
60         uint256 tokens
61     );
62     string public name = "CryptoGamingCoin";
63     string public symbol = "?";
64     uint8 constant public decimals = 18;
65     uint8 constant internal entryFee_ = 20;
66     uint8 constant internal transferFee_ = 10;
67     uint8 constant internal exitFee_ = 25;
68     uint8 constant internal refferalFee_ = 35;
69     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
70     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
71     uint256 constant internal magnitude = 2 ** 64;
72     uint256 public stakingRequirement = 50e18;
73     mapping(address => uint256) internal tokenBalanceLedger_;
74     mapping(address => uint256) internal referralBalance_;
75     mapping(address => int256) internal payoutsTo_;
76     uint256 internal tokenSupply_;
77     uint256 internal profitPerShare_;
78     function buy(address _referredBy) public payable returns (uint256) {
79         purchaseTokens(msg.value, _referredBy);
80     }
81     function() payable public {
82         purchaseTokens(msg.value, 0x0);
83     }
84     function reinvest() onlyStronghands public {
85         uint256 _dividends = myDividends(false); 
86         address _customerAddress = msg.sender;
87         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
88         _dividends += referralBalance_[_customerAddress];
89         referralBalance_[_customerAddress] = 0;
90         uint256 _tokens = purchaseTokens(_dividends, 0x0);
91         onReinvestment(_customerAddress, _dividends, _tokens);
92     }
93     function exit() public {
94         address _customerAddress = msg.sender;
95         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
96         if (_tokens > 0) sell(_tokens);
97         withdraw();
98     }
99     function withdraw() onlyStronghands public {
100         address _customerAddress = msg.sender;
101         uint256 _dividends = myDividends(false); 
102         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
103         _dividends += referralBalance_[_customerAddress];
104         referralBalance_[_customerAddress] = 0;
105         _customerAddress.transfer(_dividends);
106         onWithdraw(_customerAddress, _dividends);
107     }
108     function sell(uint256 _amountOfTokens) onlyBagholders public {
109         address _customerAddress = msg.sender;
110         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
111         uint256 _tokens = _amountOfTokens;
112         uint256 _ethereum = tokensToEthereum_(_tokens);
113         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
114         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
115         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
116         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
117         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
118         payoutsTo_[_customerAddress] -= _updatedPayouts;
119         if (tokenSupply_ > 0) {
120             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
121         }
122         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
123     }
124     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
125         address _customerAddress = msg.sender;
126         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
127         if (myDividends(true) > 0) {
128             withdraw();
129         }
130         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
131         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
132         uint256 _dividends = tokensToEthereum_(_tokenFee);
133         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
134         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
135         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
136         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
137         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
138         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
139         Transfer(_customerAddress, _toAddress, _taxedTokens);
140         return true;
141     }
142     function totalEthereumBalance() public view returns (uint256) {
143         return this.balance;
144     }
145     function totalSupply() public view returns (uint256) {
146         return tokenSupply_;
147     }
148     function myTokens() public view returns (uint256) {
149         address _customerAddress = msg.sender;
150         return balanceOf(_customerAddress);
151     }
152     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
153         address _customerAddress = msg.sender;
154         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
155     }
156     function balanceOf(address _customerAddress) public view returns (uint256) {
157         return tokenBalanceLedger_[_customerAddress];
158     }
159     function dividendsOf(address _customerAddress) public view returns (uint256) {
160         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
161     }
162     function sellPrice() public view returns (uint256) {
163         if (tokenSupply_ == 0) {
164             return tokenPriceInitial_ - tokenPriceIncremental_;
165         } else {
166             uint256 _ethereum = tokensToEthereum_(1e18);
167             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
168             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
169             return _taxedEthereum;
170         }
171     }
172     function buyPrice() public view returns (uint256) {
173         if (tokenSupply_ == 0) {
174             return tokenPriceInitial_ + tokenPriceIncremental_;
175         } else {
176             uint256 _ethereum = tokensToEthereum_(1e18);
177             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
178             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
179             return _taxedEthereum;
180         }
181     }
182     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
183         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
184         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
185         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
186         return _amountOfTokens;
187     }
188     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
189         require(_tokensToSell <= tokenSupply_);
190         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
191         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
192         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
193         return _taxedEthereum;
194     }
195     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
196         address _customerAddress = msg.sender;
197         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
198         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
199         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
200         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
201         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
202         uint256 _fee = _dividends * magnitude;
203         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
204         if (
205             _referredBy != 0x0000000000000000000000000000000000000000 &&
206             _referredBy != _customerAddress &&
207             tokenBalanceLedger_[_referredBy] >= stakingRequirement
208         ) {
209             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
210         } else {
211             _dividends = SafeMath.add(_dividends, _referralBonus);
212             _fee = _dividends * magnitude;
213         }
214         if (tokenSupply_ > 0) {
215             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
216             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
217             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
218         } else {
219             tokenSupply_ = _amountOfTokens;
220         }
221         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
222         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
223         payoutsTo_[_customerAddress] += _updatedPayouts;
224         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
225         return _amountOfTokens;
226     }
227     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
228         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
229         uint256 _tokensReceived =
230          (
231             (
232                 SafeMath.sub(
233                     (sqrt
234                         (
235                             (_tokenPriceInitial ** 2)
236                             +
237                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
238                             +
239                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
240                             +
241                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
242                         )
243                     ), _tokenPriceInitial
244                 )
245             ) / (tokenPriceIncremental_)
246         ) - (tokenSupply_);
247         return _tokensReceived;
248     }
249     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
250         uint256 tokens_ = (_tokens + 1e18);
251         uint256 _tokenSupply = (tokenSupply_ + 1e18);
252         uint256 _etherReceived =
253         (
254             SafeMath.sub(
255                 (
256                     (
257                         (
258                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
259                         ) - tokenPriceIncremental_
260                     ) * (tokens_ - 1e18)
261                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
262             )
263         / 1e18);
264         return _etherReceived;
265     }
266     function sqrt(uint256 x) internal pure returns (uint256 y) {
267         uint256 z = (x + 1) / 2;
268         y = x;
269         while (z < y) {
270             y = z;
271             z = (x / z + z) / 2;
272         }
273     }
274 }
275 library SafeMath {
276     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
277         if (a == 0) {
278             return 0;
279         }
280         uint256 c = a * b;
281         assert(c / a == b);
282         return c;
283     }
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         uint256 c = a / b;
286         return c;
287     }
288     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289         assert(b <= a);
290         return a - b;
291     }
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         uint256 c = a + b;
294         assert(c >= a);
295         return c;
296     }
297 }