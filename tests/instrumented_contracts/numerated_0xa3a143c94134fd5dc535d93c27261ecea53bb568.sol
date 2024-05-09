1 pragma solidity 0.4.26;
2 
3 contract Hourglass {
4     modifier onlyHolders()     {require(myTokens() > 0);       _;}
5     modifier onlyStronghands() {require(myDividends(true) > 0);_;}
6 
7     event onTokenPurchase(address indexed customerAddress, uint256 incomingEthereum, uint256 tokensMinted, address indexed referredBy);
8     event onTokenSell(address indexed customerAddress, uint256 tokensBurned, uint256 ethereumEarned);
9     event onReinvestment(address indexed customerAddress, uint256 ethereumReinvested, uint256 tokensMinted);
10     event onWithdraw(address indexed customerAddress, uint256 ethereumWithdrawn);
11     event Transfer(address indexed from, address indexed to, uint256 tokens);
12 
13     string public name = "Arcadium 3D";
14     string public symbol = "ARC3D";
15     uint8 constant public decimals = 18;
16     uint8 constant internal dividendFee_ = 10;
17     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
18     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
19     uint256 constant internal magnitude = 2**64;
20 
21     mapping(address => uint256) internal tokenBalanceLedger_;
22     mapping(address => uint256) internal referralBalance_;
23     mapping(address => uint256) internal referralUseCount_;
24     mapping(address => int256) internal payoutsTo_;
25 
26     uint256 internal tokenSupply_ = 0;
27     uint256 internal profitPerShare_;
28 
29     constructor() public {}
30 
31     function buy(address _referredBy) public payable returns(uint256) {purchaseTokens(msg.value, _referredBy);}
32     
33     function() payable public {purchaseTokens(msg.value, 0x0);}
34     
35     function referralLinkUseCount(address _player) public view returns(uint256) {return referralUseCount_[_player];}
36     
37     function reinvest() onlyStronghands() public {
38         uint256 _dividends = myDividends(false);
39         address _customerAddress = msg.sender;
40         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
41         _dividends += referralBalance_[_customerAddress];
42         referralBalance_[_customerAddress] = 0;
43         uint256 _tokens = purchaseTokens(_dividends, 0x0);
44         emit onReinvestment(_customerAddress, _dividends, _tokens);
45     }
46 
47     function exit() public {
48         address _customerAddress = msg.sender;
49         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
50         if(_tokens > 0) sell(_tokens);
51         withdraw();
52     }
53 
54     function withdraw() onlyStronghands() public {
55         address _customerAddress = msg.sender;
56         uint256 _dividends = myDividends(false);
57         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
58         _dividends += referralBalance_[_customerAddress];
59         referralBalance_[_customerAddress] = 0;
60         _customerAddress.transfer(_dividends);
61         emit onWithdraw(_customerAddress, _dividends);
62     }
63 
64     function sell(uint256 _amountOfTokens) onlyHolders() public {
65         address _customerAddress = msg.sender;
66         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
67         uint256 _tokens = _amountOfTokens;
68         uint256 _ethereum = tokensToEthereum_(_tokens);
69         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
70         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
71         
72         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
73         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
74         
75         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
76         payoutsTo_[_customerAddress] -= _updatedPayouts;
77         if (tokenSupply_ > 0) {profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);}
78         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
79     }
80 
81      function transfer(address _toAddress, uint256 _amountOfTokens) onlyHolders() public returns(bool) {
82         require(_toAddress != address(0));
83         address _customerAddress = msg.sender;
84         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
85         if(myDividends(true) > 0) withdraw();
86         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
87         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
88         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
89         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
90         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
91         return true;
92     }
93 
94     function totalEthereumBalance() public view returns(uint) {return address(this).balance;}
95     function totalSupply() public view returns(uint256) {return tokenSupply_;}
96 
97     function myTokens() public view returns(uint256) {
98         address _customerAddress = msg.sender;
99         return balanceOf(_customerAddress);
100     }
101 
102     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
103         address _customerAddress = msg.sender;
104         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
105     }
106 
107     function balanceOf(address _customerAddress) view public returns(uint256) {return tokenBalanceLedger_[_customerAddress];}
108     function dividendsOf(address _customerAddress) view public returns(uint256) {return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;}
109     function sellPrice() public view returns(uint256) {
110         if(tokenSupply_ == 0){
111             return tokenPriceInitial_ - tokenPriceIncremental_;
112         } else {
113             uint256 _ethereum = tokensToEthereum_(1e18);
114             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
115             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
116             return _taxedEthereum;
117         }
118     }
119 
120     function buyPrice() public view returns(uint256) {
121         if(tokenSupply_ == 0){
122             return tokenPriceInitial_ + tokenPriceIncremental_;
123         } else {
124             uint256 _ethereum = tokensToEthereum_(1e18);
125             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
126             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
127             return _taxedEthereum;
128         }
129     }
130     
131     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
132         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
133         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
134         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
135         return _amountOfTokens;
136     }
137 
138     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
139         require(_tokensToSell <= tokenSupply_);
140         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
141         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
142         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
143         return _taxedEthereum;
144     }
145 
146     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns(uint256) {
147         address _customerAddress = msg.sender;
148         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
149         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
150         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
151         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
152         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
153         uint256 _fee = _dividends * magnitude;
154 
155         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
156         
157         if(
158             _referredBy != 0x0000000000000000000000000000000000000000
159         ){
160             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
161             referralUseCount_[_referredBy] = SafeMath.add(referralUseCount_[_referredBy], 1);
162         } else {
163             _dividends = SafeMath.add(_dividends, _referralBonus);
164             _fee = _dividends * magnitude;
165         }
166 
167         if(tokenSupply_ > 0){
168             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
169             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
170             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
171         
172         } else {
173             tokenSupply_ = _amountOfTokens;
174         }
175         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
176         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
177         payoutsTo_[_customerAddress] += _updatedPayouts;
178         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
179         
180         return _amountOfTokens;
181     }
182 
183     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
184         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
185         uint256 _tokensReceived = ((SafeMath.sub((sqrt((_tokenPriceInitial**2)+(2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))+(((tokenPriceIncremental_)**2)*(tokenSupply_**2))+(2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_))), _tokenPriceInitial))/(tokenPriceIncremental_))-(tokenSupply_);
186         return _tokensReceived;
187     }
188 
189      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
190         uint256 tokens_ = (_tokens + 1e18);
191         uint256 _tokenSupply = (tokenSupply_ + 1e18);
192         uint256 _etherReceived = (SafeMath.sub((((tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18)))-tokenPriceIncremental_)*(tokens_ - 1e18)),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2)/1e18);
193         return _etherReceived;
194     }
195 
196     function sqrt(uint x) internal pure returns (uint y) {
197         uint z = (x + 1) / 2; y = x;
198         while (z < y) {y = z; z = (x / z + z) / 2;}
199     }
200 }
201 
202 library SafeMath {
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {if (a == 0) {return 0;} uint256 c = a * b; assert(c / a == b); return c;}
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a / b; return c;}
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; assert(c >= a); return c;}
207 }