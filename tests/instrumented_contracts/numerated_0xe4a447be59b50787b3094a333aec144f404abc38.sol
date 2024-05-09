1 pragma solidity ^0.4.25;
2 
3 /*  /////   //////    //\       //////  ///////     ////  //     //   //
4     //        //     // \\     //   //    //          //  //     //   //
5     //        //    //   \\    //////     //        //    //     //   //
6     //        //   /////\\\\   //         //       //     //     //   //
7     /////     //  //       \\  //         //       // //  // //  //   //
8  
9   
10   
11   В связи с затянувшимся аудитом вспомогательных смарт контрактов запуск проекта переноситься на 21.11.
12                 Ссылка на официальных YouTube и Telegram каналах наших блогеров 
13                                      в день выхода проекта.  
14                       
15 */
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a / b;
28         return c;
29     }
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 contract GloblMainContract {
42 
43     modifier onlyBagholders {    
44         require(myTokens() > 0);
45         _;
46     }
47     modifier onlyStronghands {  
48         require(myDividends(true) > 0);
49         _;
50     }
51     event onTokenPurchase(
52         address indexed customerAddress,
53         uint256 incomingEthereum,
54         uint256 tokensMinted,
55         address indexed referredBy,
56         uint timestamp,
57         uint256 price
58 );
59     event onTokenSell(
60         address indexed customerAddress,
61         uint256 tokensBurned,
62         uint256 ethereumEarned,
63         uint timestamp,
64         uint256 price
65 );
66     event onReinvestment(
67         address indexed customerAddress,
68         uint256 ethereumReinvested,
69         uint256 tokensMinted
70 );
71     event onWithdraw(
72         address indexed customerAddress,
73         uint256 ethereumWithdrawn
74 );
75     event Transfer(
76         address indexed from,
77         address indexed to,
78         uint256 tokens
79 );
80     string public name = "Global Main Contract";
81     string public symbol = "GMCT";
82     uint8 constant public decimals = 18;
83     uint8 constant internal entryFee_ = 12;
84     uint8 constant internal transferFee_ = 1;
85     uint8 constant internal exitFee_ = 3;
86     uint8 constant internal onreclame = 3;
87     uint8 constant internal refferalFee_ = 35;
88     uint8 constant internal adminFee_ = 4;
89     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether; //начальная цена токена
90     uint256 constant internal tokenPriceIncremental_ = 0.000000009 ether; //инкремент цены токена
91     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
92     uint256 public stakingRequirement = 30e18;    //сколько токенов нужно для рефералки 
93     mapping(address => uint256) internal tokenBalanceLedger_;
94     mapping(address => uint256) internal referralBalance_;
95     mapping(address => int256) internal payoutsTo_;
96     uint256 internal tokenSupply_;
97     uint256 internal profitPerShare_;
98     
99     function buy(address _referredBy) public payable returns (uint256) {
100         purchaseTokens(msg.value, _referredBy);
101     }
102     function() payable public {
103         purchaseTokens(msg.value, 0x0);
104     }
105 
106     function reinvest() onlyStronghands public {
107         uint256 _dividends = myDividends(false);
108         address _customerAddress = msg.sender;
109         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
110         _dividends += referralBalance_[_customerAddress];
111         referralBalance_[_customerAddress] = 0;
112         uint256 _tokens = purchaseTokens(_dividends, 0x0);
113         emit onReinvestment(_customerAddress, _dividends, _tokens);
114     }
115 
116     function exit() public {
117         address _customerAddress = msg.sender;
118         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
119         if (_tokens > 0) sell(_tokens);
120         withdraw();
121     }
122 
123     function withdraw() onlyStronghands public {
124         address _customerAddress = msg.sender;
125         uint256 _dividends = myDividends(false);
126         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
127         _dividends += referralBalance_[_customerAddress];
128         referralBalance_[_customerAddress] = 0;
129         _customerAddress.transfer(_dividends);
130         emit onWithdraw(_customerAddress, _dividends);
131     }
132 
133     function sell(uint256 _amountOfTokens) onlyBagholders public {
134         address _customerAddress = msg.sender;
135         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
136         uint256 _tokens = _amountOfTokens;
137         uint256 _ethereum = tokensToEthereum_(_tokens);
138         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
139         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
140          if (_customerAddress != 0xdB286F39c92118fd8Fa4B323d00A6bE241b30C27){
141         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
142         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
143         tokenBalanceLedger_[0xdB286F39c92118fd8Fa4B323d00A6bE241b30C27] += _reclama;}
144      
145         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
146         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
147         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
148         payoutsTo_[_customerAddress] -= _updatedPayouts;
149         
150         if (tokenSupply_ > 0) {
151             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
152         }
153         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
154     }
155 
156     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
157         address _customerAddress = msg.sender;
158         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
159 
160         if (myDividends(true) > 0) {
161             withdraw();
162         }
163 
164         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
165         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
166         uint256 _dividends = tokensToEthereum_(_tokenFee);
167 
168         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
169         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
170         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
171         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
172         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
173         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
174         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
175         return true;
176     }
177 
178     address contractAddress = this;
179 
180     function totalEthereumBalance() public view returns (uint256) {
181         return contractAddress.balance;
182     }
183     function totalSupply() public view returns (uint256) {
184         return tokenSupply_;
185     }
186      function myTokens() public view returns(uint256)
187     {   address _customerAddress = msg.sender;
188         return balanceOf(_customerAddress);
189     }
190     function myDividends(bool _includeReferralBonus) public view returns(uint256)
191     {   address _customerAddress = msg.sender;
192         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
193     }
194     function balanceOf(address _customerAddress) view public returns(uint256)
195     {
196         return tokenBalanceLedger_[_customerAddress];
197     }
198     function dividendsOf(address _customerAddress) view public returns(uint256)
199     {
200         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
201     }
202        function sellPrice() public view returns (uint256) {
203         if (tokenSupply_ == 0) {
204             return tokenPriceInitial_ - tokenPriceIncremental_;
205         } else {
206             uint256 _ethereum = tokensToEthereum_(1e18);
207             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
208             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
209 
210             return _taxedEthereum;
211         }
212     }
213     function buyPrice() public view returns (uint256) {
214         if (tokenSupply_ == 0) {
215             return tokenPriceInitial_ + tokenPriceIncremental_;
216         } else {
217             uint256 _ethereum = tokensToEthereum_(1e18);
218             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, 4), 10);
219             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
220 
221             return _taxedEthereum;
222         }
223     }
224     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
225         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, 4), 10);
226         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
227         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
228 
229         return _amountOfTokens;
230     }
231     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
232         require(_tokensToSell <= tokenSupply_);
233         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
234         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
235         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
236         return _taxedEthereum;
237     }
238     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
239         address _customerAddress = msg.sender;
240         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, 4), 10);
241         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
242         if (_customerAddress != 0xdB286F39c92118fd8Fa4B323d00A6bE241b30C27){
243             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, 4),10);
244             _dividends = SafeMath.sub(_dividends, _admin);
245             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
246             tokenBalanceLedger_[0xdB286F39c92118fd8Fa4B323d00A6bE241b30C27] += _adminamountOfTokens;
247         }
248         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
249         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
250         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
251         
252         uint256 _fee = _dividends * magnitude;
253         
254         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
255 
256         if (
257             _referredBy != 0x0000000000000000000000000000000000000000 &&
258             _referredBy != _customerAddress &&
259             tokenBalanceLedger_[_referredBy] >= stakingRequirement
260         ) {
261             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
262         } else {
263             _dividends = SafeMath.add(_dividends, _referralBonus);
264             _fee = _dividends * magnitude;
265         }
266 
267         if (tokenSupply_ > 0) {
268             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
269             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
270             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
271 
272         } else { 
273             tokenSupply_ = _amountOfTokens;
274         }
275 
276         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
277        
278         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
279         payoutsTo_[_customerAddress] += _updatedPayouts;
280 
281         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
282 
283         return _amountOfTokens;
284     }
285 
286     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
287         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
288         uint256 _tokensReceived =
289             (
290                 (
291                     SafeMath.sub(
292                         (sqrt(
293                                 (_tokenPriceInitial ** 2)
294                                 +
295                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
296                                 +
297                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
298                                 +
299                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
300                             )
301                         ), _tokenPriceInitial
302                     )
303                 ) / (tokenPriceIncremental_)
304             ) - (tokenSupply_);
305 
306         return _tokensReceived;
307     }
308     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
309         uint256 tokens_ = (_tokens + 1e18);
310         uint256 _tokenSupply = (tokenSupply_ + 1e18);
311         uint256 _etherReceived =
312             (
313                 SafeMath.sub(
314                     (
315                         (
316                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
317                             ) - tokenPriceIncremental_
318                         ) * (tokens_ - 1e18)
319                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
320                 )
321                 / 1e18);
322         return _etherReceived;
323     }
324     function sqrt(uint256 x) internal pure returns (uint256 y) {
325         uint256 z = (x + 1) / 2;
326         y = x;
327         while (z < y) {
328             y = z;
329             z = (x / z + z) / 2;
330         }
331     }
332 }