1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 pragma solidity ^0.4.18;
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable(address _owner) public {
53     owner = _owner;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(tx.origin == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 pragma solidity ^0.4.19;
77 
78 contract Stoppable is Ownable {
79   bool public halted;
80 
81   event SaleStopped(address owner, uint256 datetime);
82 
83   function Stoppable(address owner) public Ownable(owner) {}
84 
85   modifier stopInEmergency {
86     require(!halted);
87     _;
88   }
89 
90   modifier onlyInEmergency {
91     require(halted);
92     _;
93   }
94 
95   function hasHalted() public view returns (bool isHalted) {
96   	return halted;
97   }
98 
99    // called by the owner on emergency, triggers stopped state
100   function stopICO() external onlyOwner {
101     halted = true;
102     SaleStopped(msg.sender, now);
103   }
104 }
105 
106 pragma solidity ^0.4.19;
107 
108 /* SALE_mtf is the smart contract facilitating MetaFusions first public crowdsale. Created by Iconemy on 11/10/18
109  * SALE_mtf allows the owner of the MetaFusion tokens to 'allow' the sale to sell a portion of tokens on his/her behalf, 
110  * this will then allow the owner to run further sales in the future by allowing to spend a further portion of tokens. 
111  * The sale is stoppable therefore, the owner can stop the sale in an emergency and allow the investors to withdraw their 
112  * investments. 
113  */
114 contract SALE_mtf is Stoppable {
115   using SafeMath for uint256;
116 
117   bool private approval = false;
118 
119   mtfToken public token;
120   uint256 public rate;
121 
122   uint256 public startTime;
123   uint256 public endTime;
124 
125   uint256 public weiRaised;
126   uint256 public tokensSent;
127 
128   mapping(address => uint256) public balanceOf;
129   mapping(address => uint256) public tokenBalanceOf;
130 
131   address public iconemy_wallet;
132   uint256 public commission; 
133 
134   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount, uint256 datetime);
135   event BeneficiaryWithdrawal(address beneficiary, uint256 amount, uint256 datetime);
136   event CommissionCollected(address beneficiary, uint256 amount, uint256 datetime);
137 
138   // CONSTRUCTOR
139   function SALE_mtf(address _token, uint256 _rate, uint256 _startTime, uint256 _endTime, address _iconemy, address _owner) public Stoppable(_owner) {
140     require(_startTime > now);
141     require(_startTime < _endTime);
142 
143     token = mtfToken(_token);
144 
145     rate = _rate;
146     startTime = _startTime;
147     endTime = _endTime;
148     iconemy_wallet = _iconemy;
149   }
150 
151   // Recieve approval is used in the sales interface on the MetaFusion ERC-20 token, allowing the owner to use approveAndCall
152   // When this function is called, we check the allowance of the sale the tokens interface and store 1% of that as a maximum commission
153   // We do this to reserve 1% of tokens in the case that the sale sells out, Iconemy will collect the full 1%. 
154   function receiveApproval() onlyOwner external {
155     approval = true;
156     uint256 allowance = allowanceOf();
157 
158     // Reserved for Iconemy commission
159     commission = allowance / 100;
160   }
161 
162   // Uses the token interface to check how many tokens the sale is allowed to sell
163   function allowanceOf() public view returns(uint256) {
164     return token.allowanceOf(owner, this);
165   }
166 
167   // Shows that the sale has been given approval to sell tokens by the token owner
168   function hasApproval() public view returns(bool) {
169     return approval;
170   }
171 
172   function getPrice() public view returns(uint256) {
173     return rate;
174   }
175 
176   /*
177    * This method has taken from Pickeringware ltd
178    * We have split this method down into overidable functions which may affect how users purchase tokens
179   */ 
180   function buyTokens() public stopInEmergency payable {
181     uint256 weiAmount = msg.value;
182 
183     // calculate token amount to be created
184     uint256 tokens = tokensToRecieve(weiAmount);
185 
186     validPurchase(tokens);
187 
188     finalizeSale(msg.sender, weiAmount, tokens);
189 
190     TokenPurchase(msg.sender, msg.value, tokens, now);
191   }
192 
193   //Check that the amount of tokens requested is less than or equal to the ammount of tokens allowed to send
194   function checkAllowance(uint256 _tokens) public view {
195     uint256 allowance = allowanceOf();
196 
197     allowance = allowance - commission;
198 
199     require(allowance >= _tokens);
200   }
201 
202   // If the transfer function works using the token interface, mark the balances of the buyer
203   function finalizeSale(address from, uint256 _weiAmount, uint256 _tokens) internal {
204     require(token.transferFrom(owner, from, _tokens));
205 
206     balanceOf[from] = balanceOf[from].add(_weiAmount);
207     tokenBalanceOf[from] = tokenBalanceOf[from].add(_tokens);
208 
209     weiRaised = weiRaised.add(_weiAmount);
210     tokensSent = tokensSent.add(_tokens);
211   }
212 
213   // Calculate amount of tokens due for the amount of ETH sent
214   function tokensToRecieve(uint256 _wei) internal view returns (uint256 tokens) {
215     return _wei.div(rate);
216   }
217 
218   // @return true if crowdsale event has ended
219   function hasEnded() public view returns (bool) {
220     return now > endTime || halted;
221   }
222 
223   // Checks if the purchase is valid
224   function validPurchase(uint256 _tokens) internal view returns (bool) {
225     require(!hasEnded());
226 
227     checkAllowance(_tokens);
228 
229     bool withinPeriod = now >= startTime && now <= endTime;
230 
231     bool nonZeroPurchase = msg.value != 0;
232 
233     require(withinPeriod && nonZeroPurchase);
234   }
235 
236   // Allows someone to check if they are valid for a refund
237   // This can be used front-end to show/hide the collect refund function 
238   function refundAvailable() public view returns(bool) {
239     return balanceOf[msg.sender] > 0 && hasHalted();
240   }
241 
242   // Allows an investor to collect their investment if the sale was stopped prematurely
243   function collectRefund() public onlyInEmergency {
244     uint256 balance = balanceOf[msg.sender];
245 
246     require(balance > 0);
247 
248     balanceOf[msg.sender] = 0;
249 
250     msg.sender.transfer(balance);
251   }
252 
253   // Allows the owner to collect the eth raised in the sale
254   function collectInvestment() public onlyOwner stopInEmergency returns(bool) {
255     require(hasEnded());
256 
257     owner.transfer(weiRaised);
258     BeneficiaryWithdrawal(owner, weiRaised, now);
259   }
260 
261   // Allows Iconemy to collect 1% of the tokens sold in the crowdsale
262   function collectCommission() public stopInEmergency returns(bool) {
263     require(msg.sender == iconemy_wallet);
264     require(hasEnded());
265 
266     uint256 one_percent = tokensSent / 100;
267 
268     finalizeSale(iconemy_wallet, 0, one_percent);
269 
270     CommissionCollected(iconemy_wallet, one_percent, now);
271   }
272 }  
273 
274 // Token interface used for interacting with the MetaFusion ERC-20 contract
275 contract mtfToken { 
276   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success); 
277   function allowanceOf(address _owner, address _spender) public constant returns (uint256 remaining);
278 }