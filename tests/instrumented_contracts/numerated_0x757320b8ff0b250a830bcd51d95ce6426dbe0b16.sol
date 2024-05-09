1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ERC20Token {
38 
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   function mint(address _to, uint256 _amount) public returns (bool);
42   function totalSupply() public returns (uint256);
43 
44 }
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 /**
89  * @title Crowdsale
90  * @dev Crowdsale is a base contract for managing a token crowdsale.
91  * Crowdsales have a start and end timestamps, where investors can make
92  * token purchases and the crowdsale will assign them tokens based
93  * on a token per ETH rate. Funds collected are forwarded to a wallet
94  * as they arrive.
95  */
96 contract Crowdsale is Ownable {
97   using SafeMath for uint256;
98 
99   ERC20Token token;
100 
101   // start and end timestamps where investments are allowed (both inclusive)
102   uint256 public startTime;
103   uint256 public endTime;
104 
105   // address where funds are collected
106   address wallet;
107 
108   // how many token units a buyer gets per wei
109   uint256 public rate;
110 
111   // amount of raised money in wei
112   uint256 public weiRaised;
113 
114   uint256 public maxWei;
115 
116   bool paused;
117 
118   /**
119    * event for token purchase logging
120    * @param purchaser who paid for the tokens
121    * @param beneficiary who got the tokens
122    * @param value weis paid for purchase
123    * @param amount amount of tokens purchased
124    */
125   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
126 
127 
128   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token, uint256 _maxWei) public {
129     require(_startTime >= now);
130     require(_endTime >= _startTime);
131     require(_rate > 0);
132     require(_wallet != address(0));
133     require(_token != address(0));
134     require(_maxWei > 0);
135 
136     startTime = _startTime;
137     endTime = _endTime;
138     rate = _rate;
139     wallet = _wallet;
140     token = ERC20Token(_token);
141     maxWei = _maxWei;
142     paused = false;
143   }
144 
145   /**
146    * @notice Funtion to update exchange rate
147    * @dev Only owner is allowed
148    * @param _rate new exchange rate
149    */
150   function updateRate(uint256 _rate) public onlyOwner {
151     rate = _rate;
152   }
153 
154   /**
155    * @notice Funtion to update maxWei contribution
156    * @dev Only owner is allowed
157    * @param _maxWei new maxWei contribution
158    */
159   function updateMaxWei(uint256 _maxWei) public onlyOwner {
160     maxWei = _maxWei;
161   }
162 
163   /**
164    * @notice Funtion to update wallet for contributions
165    * @dev Only owner is allowed
166    * @param _newWallet new maxWei contribution
167    */
168   function updateWallet(address _newWallet) public onlyOwner {
169     wallet = _newWallet;
170   }
171 
172   /**
173    * @notice Funtion to pause the sale
174    * @dev Only owner is allowed
175    * @param _flag bool to set or unset pause on sale
176    */
177   function pauseSale(bool _flag) public onlyOwner {
178     paused = _flag;
179   }
180 
181   // fallback function can be used to buy tokens
182   function () external payable {
183     buyTokens(msg.sender);
184   }
185 
186   // low level token purchase function
187   function buyTokens(address beneficiary) public payable {
188     require(paused == false);
189     require(msg.value <= maxWei);
190     require(beneficiary != address(0));
191     require(validPurchase());
192 
193     uint256 weiAmount = msg.value;
194 
195     // calculate token amount to be created
196     uint256 tokens = weiAmount.mul(rate);
197 
198     // update state
199     weiRaised = weiRaised.add(weiAmount);
200 
201     token.mint(beneficiary, tokens);
202     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
203 
204     forwardFunds();
205   }
206 
207   // send ether to the fund collection wallet
208   // override to create custom fund forwarding mechanisms
209   function forwardFunds() internal {
210     wallet.transfer(msg.value);
211   }
212 
213   // @return true if the transaction can buy tokens
214   function validPurchase() internal view returns (bool) {
215     bool withinPeriod = now >= startTime && now <= endTime;
216     bool nonZeroPurchase = msg.value != 0;
217     return withinPeriod && nonZeroPurchase;
218   }
219 
220   // @return true if crowdsale event has ended
221   function hasEnded() public view returns (bool) {
222     return now > endTime;
223   }
224 
225 
226 }
227 
228 /**
229  * @title CappedCrowdsale
230  * @dev Extension of Crowdsale with a max amount of funds raised
231  */
232 contract CappedCrowdsale is Crowdsale {
233   using SafeMath for uint256;
234 
235   uint256 public cap;
236 
237   function CappedCrowdsale(uint256 _cap) public {
238     require(_cap > 0);
239     cap = _cap;
240   }
241 
242   /**
243    * @notice Funtion to updateCap
244    * @dev Only owner is allowed
245    * @param _newCap new cap of the crowdsale
246    */
247 
248   function updateCap(uint256 _newCap) public onlyOwner {
249     require(_newCap > weiRaised);
250     cap = _newCap;
251   }
252 
253   // overriding Crowdsale#validPurchase to add extra cap logic
254   // @return true if investors can buy at the moment
255   function validPurchase() internal view returns (bool) {
256     bool withinCap = weiRaised.add(msg.value) <= cap;
257     return super.validPurchase() && withinCap;
258   }
259 
260   // overriding Crowdsale#hasEnded to add cap logic
261   // @return true if crowdsale event has ended
262   function hasEnded() public view returns (bool) {
263     bool capReached = weiRaised >= cap;
264     return super.hasEnded() || capReached;
265   }
266 
267 }
268 
269 /**
270  * @title PrimeLendTokenICO for main ICO functions
271  */
272 contract PrimeLendTokenICO is CappedCrowdsale {
273 
274 
275   function PrimeLendTokenICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token, uint256 _maxWei) public
276     CappedCrowdsale(_cap)
277     Crowdsale(_startTime, _endTime, _rate, _wallet, _token, _maxWei)
278   {
279       require(_maxWei > 0);
280 
281   }
282 
283   function updateEndTime(uint256 _unixTime) public onlyOwner {
284 
285     endTime = _unixTime;
286     require(endTime > now);
287 
288   }
289 
290 }