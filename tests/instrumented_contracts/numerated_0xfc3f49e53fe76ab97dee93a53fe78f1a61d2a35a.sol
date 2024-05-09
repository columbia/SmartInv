1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 library SafeMath_Time {
33     function addTime(uint a, uint b) internal pure returns (uint) {
34         uint c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract Ownable {
41     address public owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     function Ownable() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53   
54     function transferOwnership(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 }
60 
61 interface token {
62     function transfer(address receiver, uint amount) external;
63     function freezeAccount(address target, bool freeze, uint startTime, uint endTime) external; 
64 }
65 
66 interface marketPrice {
67     function getUSDEth() external returns(uint256);
68 }
69 
70 contract BaseCrowdsale{
71     using SafeMath for uint256;
72     using SafeMath_Time for uint;
73 
74     token public ctrtToken;
75     address public wallet;
76     uint256 public weiRaised;
77 
78     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);    
79 
80     function init(address _wallet, address _token) internal {
81         require(_wallet != address(0));
82         require(_token != address(0));
83 
84         wallet = _wallet;
85         ctrtToken = token(_token);
86     }        
87 
88     function () external payable {
89         buyTokens(msg.sender);
90     }
91 
92     function buyTokens(address _beneficiary) public payable {
93         uint256 weiAmount = msg.value;
94 
95         // calculate token amount to be created
96         uint256 tokens = weiAmount;
97         tokens = _getTokenAmount(weiAmount);
98 
99         _preValidatePurchase(_beneficiary, weiAmount, tokens);
100 
101         // update state
102         weiRaised = weiRaised.add(weiAmount);
103 
104         _processPurchase(_beneficiary, weiAmount, tokens);
105 
106         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
107 
108         _updatePurchasingState(_beneficiary, weiAmount, tokens);
109 
110         _forwardFunds();
111         _postValidatePurchase(_beneficiary, weiAmount, tokens);
112     }
113 
114     function _getTokenAmount(uint256 _tokenAmount) internal view returns (uint256) {
115         uint256 Amount = _tokenAmount;
116         return Amount;
117     }
118 
119     function _updatePurchasingState(address _beneficiary, uint _weiAmount, uint256 _tokenAmount) internal {}
120     
121     function _preValidatePurchase(address _beneficiary, uint _weiAmount, uint256 _tokenAmount)  internal {
122         require(_beneficiary != address(0));
123         require(_weiAmount != 0);
124     }
125 
126     function _postValidatePurchase(address _beneficiary, uint _weiAmount, uint256 _tokenAmount) internal {        
127     }
128 
129     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
130         ctrtToken.transfer(_beneficiary, _tokenAmount);
131     }
132 
133     function _processPurchase(address _beneficiary, uint _weiAmount, uint256 _tokenAmount) internal {
134         _deliverTokens(_beneficiary, _tokenAmount);
135     }
136 
137     function _forwardFunds() internal {
138         wallet.transfer(msg.value);
139     }
140 }
141 
142 contract AdvanceCrowdsale is BaseCrowdsale, Ownable{
143     using SafeMath for uint256;
144     uint constant MAX_FUND_SIZE = 20;
145 
146     uint256[MAX_FUND_SIZE] public fundingGoalInToken;
147     uint256[MAX_FUND_SIZE] public amountRaisedInToken;
148     uint[MAX_FUND_SIZE] public rate;
149     uint[MAX_FUND_SIZE] public openingTimeArray;
150     uint[MAX_FUND_SIZE] public closingTimeArray;
151 
152     mapping(address => uint256) public balanceOf;
153 
154     uint256 public price;              //USD cent per token
155     uint public tokenPerEth;
156     uint public minFundInEther = 0;    
157     uint public usdPerEth = 0;          //USD cent    
158     marketPrice public ctrtMarketPrice;
159 
160     bool[MAX_FUND_SIZE] public isLockUpSale;
161     uint[MAX_FUND_SIZE] public lockDurationTime;
162 
163     event Refunding(uint pos, uint256 FundingGoalInToken, uint _rate, uint _openingTime, uint _closingTime,
164     bool _isLockUpSale, uint _lockDurationTime);
165     event TokenPrice(uint usdPerEth, uint tokenPerEth);
166 
167     function init(
168         address _wallet,
169         address _token,
170         address _marketPriceContract,
171         uint _usdPerEth,
172         uint _price
173     ) public         
174     {
175         super.init(_wallet, _token);
176         price = _price;
177         minFundInEther = 1;
178         ctrtMarketPrice = marketPrice(_marketPriceContract);
179         setUSDPerETH(_usdPerEth);
180     }
181     
182     function setFunding(
183         uint pos, uint256 _fundingGoalInToken, uint _rate, uint _openingTime, 
184         uint _closingTime, bool _isLockUpSale, uint _lockDurationTime)
185     public onlyOwner
186     {
187         require(pos < MAX_FUND_SIZE);
188         openingTimeArray[pos] = _openingTime;
189         closingTimeArray[pos] = _closingTime;
190         rate[pos] = _rate;
191         fundingGoalInToken[pos] = _fundingGoalInToken.mul(1 ether);
192         amountRaisedInToken[pos] = 0;
193 
194         isLockUpSale[pos] = _isLockUpSale;
195         lockDurationTime[pos] = _lockDurationTime.mul(1 minutes);
196         
197         emit Refunding(pos, _fundingGoalInToken, _rate, _openingTime, _closingTime, _isLockUpSale, _lockDurationTime);
198     }
199 
200     function hasClosed() public view returns (bool) {
201         for(uint i = 0; i < MAX_FUND_SIZE; ++i)
202         {
203             if(openingTimeArray[i] <= now && now <= closingTimeArray[i])
204             {
205                 return false;
206             }
207         }
208 
209         return true;
210     }
211 
212     function fundPos() public view returns (uint) {
213         for(uint i = 0; i < MAX_FUND_SIZE; ++i)
214         {
215             if(openingTimeArray[i] <= now && now <= closingTimeArray[i])
216             {
217                 return i;
218             }
219         }
220 
221         require(false);
222     }
223 
224     function setUSDPerETH(uint _usdPerEth) public onlyOwner{
225         require(_usdPerEth != 0);
226         usdPerEth = _usdPerEth;
227         tokenPerEth = usdPerEth.div(price).mul(1 ether);
228 
229         TokenPrice(usdPerEth, tokenPerEth);
230     }
231 
232     function SetUSDPerETH_byContract(uint _usdPerEth) internal {
233         require(_usdPerEth != 0);
234         usdPerEth = _usdPerEth;
235         tokenPerEth = usdPerEth.div(price).mul(1 ether);
236 
237         TokenPrice(usdPerEth, tokenPerEth);
238     }
239 
240     function setMarket(address _marketPrice) public onlyOwner{
241         ctrtMarketPrice = marketPrice(_marketPrice);
242     }
243 
244     function newLockUpAddress(address newAddress) public {
245         uint pos = fundPos();
246 
247         ctrtToken.freezeAccount(newAddress, true, block.timestamp, closingTimeArray[pos].addTime(lockDurationTime[pos]));
248     }
249 
250     function _preValidatePurchase(address _beneficiary, uint _weiAmount, uint256 _tokenAmount)  internal {
251         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);       
252         
253         require(hasClosed() == false);
254         uint pos = fundPos();
255 
256         require(fundingGoalInToken[pos] >= amountRaisedInToken[pos].add(_tokenAmount));        
257         require(minFundInEther <= msg.value);        
258     }
259      
260     function _getTokenAmount(uint256 _tokenAmount) internal view returns (uint256) {
261         if(ctrtMarketPrice != address(0))
262         {           
263             uint256 usd = ctrtMarketPrice.getUSDEth();
264     
265             if(usd != usdPerEth) {
266                 SetUSDPerETH_byContract(usd);
267             }
268         }
269         require(usdPerEth != 0);
270 
271         uint256 Amount = _tokenAmount.mul(tokenPerEth).div(1 ether);
272         
273         require(hasClosed() == false);
274         uint pos = fundPos();
275 
276         Amount = Amount.mul(rate[pos].add(100)).div(100);
277         return Amount;
278     }
279 
280     function _updatePurchasingState(address _beneficiary, uint _weiAmount, uint256 _tokenAmount) internal {        
281         balanceOf[msg.sender] = balanceOf[msg.sender].add(msg.value);
282         require(hasClosed() == false);
283         uint pos = fundPos();
284         amountRaisedInToken[pos] = amountRaisedInToken[pos].add(_tokenAmount);
285     }
286 
287     function _postValidatePurchase(address _beneficiary, uint _weiAmount, uint256 _tokenAmount) internal {
288         uint pos = fundPos();
289         if(true == isLockUpSale[pos])
290             newLockUpAddress(msg.sender);
291     }
292 }