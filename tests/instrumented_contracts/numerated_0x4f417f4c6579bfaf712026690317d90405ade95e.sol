1 pragma solidity ^0.4.20; // solhint-disable-line
2 
3 
4 /*
5   modified pyramid contract by Cryptopinions (https://ethverify.net)
6 */
7 contract DailyDivsSavings{
8   using SafeMath for uint;
9   address public ceo;
10   address public ceo2;
11   mapping(address => address) public referrer;//who has referred who
12   mapping(address => uint256) public referralsHeld;//amount of eth from referrals held
13   mapping(address => uint256) public refBuys;//how many people you have referred
14   mapping(address => uint256) public tokenBalanceLedger_;
15   mapping(address => int256) public payoutsTo_;
16   uint256 public tokenSupply_ = 0;
17   uint256 public profitPerShare_;
18   uint256 constant internal magnitude = 2**64;
19   uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
20   uint8 constant internal dividendFee_ = 50;
21 
22   event onTokenPurchase(
23       address indexed customerAddress,
24       uint256 incomingEthereum,
25       uint256 tokensMinted,
26       address indexed referredBy
27   );
28    event onTokenSell(
29        address indexed customerAddress,
30        uint256 tokensBurned,
31        uint256 ethereumEarned
32    );
33 
34    event onReinvestment(
35        address indexed customerAddress,
36        uint256 ethereumReinvested,
37        uint256 tokensMinted
38    );
39 
40    event onWithdraw(
41        address indexed customerAddress,
42        uint256 ethereumWithdrawn
43    );
44 
45    function DailyDivsSavings() public{
46      ceo=msg.sender;
47      ceo2=0x93c5371707D2e015aEB94DeCBC7892eC1fa8dd80;
48    }
49 
50   function ethereumToTokens_(uint _ethereum) public view returns(uint){
51     //require(_ethereum>tokenPriceInitial_);
52     return _ethereum.div(tokenPriceInitial_);
53   }
54   function tokensToEthereum_(uint _tokens) public view returns(uint){
55     return tokenPriceInitial_.mul(_tokens);
56   }
57   function myHalfDividends() public view returns(uint){
58     return (dividendsOf(msg.sender)*98)/200;//no safemath because for external use only
59   }
60   function myDividends()
61     public
62     view
63     returns(uint256)
64   {
65       return dividendsOf(msg.sender) ;
66   }
67   function dividendsOf(address _customerAddress)
68       view
69       public
70       returns(uint)
71   {
72       return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
73   }
74   function balance() public view returns(uint256){
75     return address(this).balance;
76   }
77   function mySavings() public view returns(uint){
78     return tokensToEthereum_(tokenBalanceLedger_[msg.sender]);
79   }
80   function depositNoRef() public payable{
81     deposit(0);
82   }
83   function deposit(address ref) public payable{
84     require(ref!=msg.sender);
85     if(referrer[msg.sender]==0 && ref!=0){
86       referrer[msg.sender]=ref;
87       refBuys[ref]+=1;
88     }
89 
90     purchaseTokens(msg.value);
91   }
92   function purchaseTokens(uint _incomingEthereum) private
93     {
94         address _customerAddress = msg.sender;
95         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
96         uint256 _dividends = _undividedDividends;
97         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
98         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
99         uint256 _fee = _dividends * magnitude;
100 
101         require(_amountOfTokens.add(tokenSupply_) > tokenSupply_);
102 
103 
104 
105         // we can't give people infinite ethereum
106         if(tokenSupply_ > 0){
107 
108             // add tokens to the pool
109             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
110 
111             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
112             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
113 
114             // calculate the amount of tokens the customer receives over his purchase
115             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
116 
117         } else {
118             // add tokens to the pool
119             tokenSupply_ = _amountOfTokens;
120         }
121 
122         // update circulating supply & the ledger address for the customer
123         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
124 
125         //remove divs from before buy
126         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
127         payoutsTo_[_customerAddress] += _updatedPayouts;
128 
129         // fire event
130         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, 0);
131 
132         //return _amountOfTokens;
133     }
134     function sell(uint _amountOfEth) public {
135       reinvest();
136       sell_(ethereumToTokens_(_amountOfEth));
137       withdraw();
138     }
139     function withdraw()
140     private
141     {
142         // setup data
143         address _customerAddress = msg.sender;
144         uint256 _dividends = myDividends(); // get ref. bonus later in the code
145 
146         // update dividend tracker
147         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
148 
149         // add ref. bonus
150         //_dividends += referralBalance_[_customerAddress];
151         //referralBalance_[_customerAddress] = 0;
152 
153         //payout
154         _customerAddress.transfer(_dividends);
155 
156         // fire event
157         onWithdraw(_customerAddress, _dividends);
158     }
159     function sell_(uint256 _amountOfTokens)
160         private
161     {
162         // setup data
163         address _customerAddress = msg.sender;
164         require(tokenBalanceLedger_[_customerAddress]>0);
165         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
166         uint256 _tokens = _amountOfTokens;
167         uint256 _ethereum = tokensToEthereum_(_tokens);
168         //uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
169         uint256 _taxedEthereum = _ethereum;//SafeMath.sub(_ethereum, _dividends);
170 
171         // burn the sold tokens
172         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
173         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
174 
175         // update dividends tracker
176         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
177         payoutsTo_[_customerAddress] -= _updatedPayouts;
178 
179         // no divs on sell
180         //if (tokenSupply_ > 0) {
181             // update the amount of dividends per token
182             //profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
183         //}
184 
185         // fire event
186         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
187     }
188     function reinvest()
189     public
190     {
191         // fetch dividends
192         uint256 _dividends = myDividends(); // retrieve ref. bonus later in the code
193         //require(_dividends>1);
194         // pay out the dividends virtually
195         address _customerAddress = msg.sender;
196         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
197 
198         // retrieve ref. bonus
199         //_dividends += referralBalance_[_customerAddress];
200         //referralBalance_[_customerAddress] = 0;
201 
202         uint halfDivs=_dividends.div(2);
203 
204         // dispatch a buy order with the virtualized "withdrawn dividends"
205         if(ethereumToTokens_(halfDivs.add(referralsHeld[msg.sender]))>0){
206           purchaseTokens(halfDivs.add(referralsHeld[msg.sender]));//uint256 _tokens =
207           referralsHeld[msg.sender]=0;
208         }
209 
210         //give half to the referrer
211 
212         address refaddr=referrer[_customerAddress];
213         if(refaddr==0){
214           uint quarterDivs=halfDivs.div(2);
215           referralsHeld[ceo]=referralsHeld[ceo].add(quarterDivs);
216           referralsHeld[ceo2]=referralsHeld[ceo2].add(quarterDivs);
217         }
218         else{
219           referralsHeld[refaddr]=referralsHeld[refaddr].add(halfDivs);
220         }
221 
222         // fire event
223         onReinvestment(_customerAddress, _dividends, halfDivs);
224     }
225 }
226 library SafeMath {
227 
228   /**
229   * @dev Multiplies two numbers, throws on overflow.
230   */
231   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232     if (a == 0) {
233       return 0;
234     }
235     uint256 c = a * b;
236     assert(c / a == b);
237     return c;
238   }
239 
240   /**
241   * @dev Integer division of two numbers, truncating the quotient.
242   */
243   function div(uint256 a, uint256 b) internal pure returns (uint256) {
244     // assert(b > 0); // Solidity automatically throws when dividing by 0
245     uint256 c = a / b;
246     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247     return c;
248   }
249 
250   /**
251   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
252   */
253   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254     assert(b <= a);
255     return a - b;
256   }
257 
258   /**
259   * @dev Adds two numbers, throws on overflow.
260   */
261   function add(uint256 a, uint256 b) internal pure returns (uint256) {
262     uint256 c = a + b;
263     assert(c >= a);
264     return c;
265   }
266 }