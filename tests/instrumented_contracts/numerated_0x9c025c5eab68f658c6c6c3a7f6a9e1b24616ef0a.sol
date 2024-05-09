1 pragma solidity ^0.4.25;
2 
3 /*
4  [Rules]
5 
6  [✓] 10% Deposit fee
7             33% => referrer (or contract owner, if none)
8             10% => contract owner
9             57% => dividends
10  [✓] 1% Withdraw fee
11            100% => contract owner
12 */
13 
14 contract NeutrinoTokenStandard {
15     modifier onlyBagholders {
16         require(myTokens() > 0);
17         _;
18     }
19 
20     modifier onlyStronghands {
21         require(myDividends(true) > 0);
22         _;
23     }
24 
25     event onTokenPurchase(
26         address indexed customerAddress,
27         uint256 incomingEthereum,
28         uint256 tokensMinted,
29         address indexed referredBy,
30         uint timestamp,
31         uint256 price
32     );
33 
34     event onTokenSell(
35         address indexed customerAddress,
36         uint256 tokensBurned,
37         uint256 ethereumEarned,
38         uint timestamp,
39         uint256 price
40     );
41 
42     event onReinvestment(
43         address indexed customerAddress,
44         uint256 ethereumReinvested,
45         uint256 tokensMinted
46     );
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51     );
52 
53     string public name = "Neutrino Token Standard";
54     string public symbol = "NTS";
55     address constant internal boss = 0x10d915C0B3e01090C7B5f80eF2D9CdB616283853;
56     uint8 constant public decimals = 18;
57     uint8 constant internal entryFee_ = 10;
58     uint8 constant internal exitFee_ = 1;
59     uint8 constant internal refferalFee_ = 33;
60     uint8 constant internal ownerFee1 = 10;
61     uint8 constant internal ownerFee2 = 25;
62     uint32 holdTimeInBlocks = 558000;
63     uint256 constant internal tokenPrice = 0.001 ether;
64     
65     uint256 constant internal magnitude = 2 ** 64;
66     uint256 public stakingRequirement = 50e18;
67     mapping(address => uint256) internal tokenBalanceLedger_;
68     mapping(address => uint256) internal referralBalance_;
69     mapping(address => int256) internal payoutsTo_;
70     mapping(address => uint256) public since;
71 
72     uint256 internal tokenSupply_;
73     uint256 internal profitPerShare_;
74 
75     function buy(address _referredBy) public payable returns (uint256) {
76         return purchaseTokens(msg.value, _referredBy);
77     }
78 
79     function() payable public {
80         purchaseTokens(msg.value, 0x0);
81     }
82 
83     function reinvest() onlyStronghands public {
84         uint256 _dividends = myDividends(false);
85         address _customerAddress = msg.sender;
86         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
87         _dividends += referralBalance_[_customerAddress];
88         referralBalance_[_customerAddress] = 0;
89         uint256 _tokens = purchaseTokens(_dividends, 0x0);
90         emit onReinvestment(_customerAddress, _dividends, _tokens);
91     }
92 
93     function exit() public {
94         address _customerAddress = msg.sender;
95         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
96         if (_tokens > 0) sell(_tokens);
97         withdraw();
98     }
99 
100     function withdraw() onlyStronghands public {
101         address _customerAddress = msg.sender;
102         uint256 _dividends = myDividends(false);
103         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
104         _dividends += referralBalance_[_customerAddress];
105         referralBalance_[_customerAddress] = 0;
106         _customerAddress.transfer(_dividends);
107         emit onWithdraw(_customerAddress, _dividends);
108     }
109 
110     function sell(uint256 _amountOfTokens) onlyBagholders public {
111         address _customerAddress = msg.sender;
112         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
113         uint256 _tokens = _amountOfTokens;
114         uint256 _ethereum = tokensToEthereum_(_tokens);
115 
116         uint8 applyFee = exitFee_;
117         if (since[msg.sender] + holdTimeInBlocks < block.number) applyFee = 20;
118 
119         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, applyFee), 100);
120         uint256 forBoss = SafeMath.div(SafeMath.mul(_dividends, ownerFee2), 100);
121         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
122 
123         _dividends = SafeMath.sub(_dividends, forBoss);
124 
125         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
126         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
127 
128         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
129         payoutsTo_[_customerAddress] -= _updatedPayouts;
130         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
131 
132         if (tokenSupply_ > 0) {
133             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
134         }
135         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
136     }
137 
138     function totalEthereumBalance() public view returns (uint256) {
139         return address(this).balance;
140     }
141 
142     function totalSupply() public view returns (uint256) {
143         return tokenSupply_;
144     }
145 
146     function myTokens() public view returns (uint256) {
147         address _customerAddress = msg.sender;
148         return balanceOf(_customerAddress);
149     }
150 
151     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
152         address _customerAddress = msg.sender;
153         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
154     }
155 
156     function balanceOf(address _customerAddress) public view returns (uint256) {
157         return tokenBalanceLedger_[_customerAddress];
158     }
159 
160     function dividendsOf(address _customerAddress) public view returns (uint256) {
161         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
162     }
163 
164     function sellPrice() public pure returns (uint256) {
165         uint256 _ethereum = tokensToEthereum_(1e18);
166         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
167         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
168 
169         return _taxedEthereum;
170     }
171 
172     function buyPrice() public pure returns (uint256) {
173         uint256 _ethereum = tokensToEthereum_(1e18);
174         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
175         uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
176 
177         return _taxedEthereum;
178     }
179 
180     function calculateTokensReceived(uint256 _ethereumToSpend) public pure returns (uint256) {
181         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
182         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
183         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
184 
185         return _amountOfTokens;
186     }
187 
188     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
189         require(_tokensToSell <= tokenSupply_);
190         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
191         uint8 applyFee = exitFee_;
192         if (since[msg.sender] + holdTimeInBlocks > block.number) applyFee = 20;
193         
194         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, applyFee), 100);
195         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
196         return _taxedEthereum;
197     }
198 
199     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
200         address _customerAddress = msg.sender;
201         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
202         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
203         uint256 forBoss = SafeMath.div(SafeMath.mul(_undividedDividends, ownerFee1), 100);
204         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus), forBoss);
205         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
206         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
207         uint256 _fee = _dividends * magnitude;
208 
209         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
210 
211         if (
212             _referredBy != 0x0000000000000000000000000000000000000000 &&
213             _referredBy != _customerAddress &&
214             tokenBalanceLedger_[_referredBy] >= stakingRequirement
215         ) {
216             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
217             emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
218         } else {
219             referralBalance_[boss] = SafeMath.add(referralBalance_[boss], _referralBonus);
220             emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, 0x0, now, buyPrice());
221         }
222 
223         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
224 
225         if (tokenSupply_ > 0) {
226             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
227             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
228             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
229         } else {
230             tokenSupply_ = _amountOfTokens;
231         }
232 
233         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
234         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
235         payoutsTo_[_customerAddress] += _updatedPayouts;
236         if (since[msg.sender] == 0) since[msg.sender] = block.number;
237 
238         return _amountOfTokens;
239     }
240 
241     function ethereumToTokens_(uint256 _ethereum) public pure returns (uint256) {
242         uint256 _tokensReceived = SafeMath.div(SafeMath.mul(_ethereum, 1e18), tokenPrice);
243 
244         return _tokensReceived;
245     }
246 
247     function tokensToEthereum_(uint256 _tokens) public pure returns (uint256) {
248         uint256 _etherReceived = SafeMath.div(SafeMath.mul(_tokens, tokenPrice), 1e18);
249 
250         return _etherReceived;
251     }
252 
253     function sqrt(uint256 x) internal pure returns (uint256 y) {
254         uint256 z = (x + 1) / 2;
255         y = x;
256 
257         while (z < y) {
258             y = z;
259             z = (x / z + z) / 2;
260         }
261     }
262 }
263 
264 library SafeMath {
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266         if (a == 0) {
267             return 0;
268         }
269         uint256 c = a * b;
270         require(c / a == b);
271         return c;
272     }
273 
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         require(b > 0);
276         uint256 c = a / b;
277         return c;
278     }
279 
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         require(b <= a);
282         return a - b;
283     }
284 
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         uint256 c = a + b;
287         require(c >= a);
288         return c;
289     }
290 }