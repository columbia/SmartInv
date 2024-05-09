1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/subscription/Subscription.sol
121 
122 contract Subscription is Ownable {
123   uint256 constant UINT256_MAX = ~uint256(0);
124   using SafeMath for uint256;
125 
126   /// @dev The token being use (C8)
127   ERC20 public token;
128 
129   /// @dev Address where fee are collected
130   address public wallet;
131 
132   /// @dev Cost per day of membership for C8 token
133   uint256 public subscriptionRate;
134 
135   uint public fee;
136 
137   uint256 lastAppId;
138 
139   struct Pricing {
140     uint256 day;
141     uint256 price;
142   }
143 
144   struct Application {
145     /// @dev Application Id.
146     uint256 appId;
147 
148     /// @dev Application name.
149     bytes32 appName;
150 
151     /// @dev Beneficiary address.
152     address beneficiary;
153 
154     /// @dev Owner address.
155     address owner;
156 
157     /// @dev Timestamp of when Membership expires UserId=>timestamp of expire.
158     mapping(uint256 => uint256) subscriptionExpiration;
159 
160     Pricing[] prices;
161   }
162 
163   mapping(uint256 => Application) public applications;
164 
165   /**
166    * Event for subscription purchase logging
167    * @param purchaser who paid for the subscription
168    * @param userId user id who will benefit from purchase
169    * @param day day of subscription purchased
170    * @param amount amount of subscription purchased in wei
171    * @param expiration expiration of user subscription.
172    */
173   event SubscriptionPurchase(
174     address indexed purchaser,
175     uint256 indexed _appId,
176     uint256 indexed userId,
177     uint256 day,
178     uint256 amount,
179     uint256 expiration
180   );
181 
182   event Registration(
183     address indexed creator,
184     uint256 _appId,
185     bytes32 _appName,
186     uint256 _price,
187     address _beneficiary
188   );
189 
190   function Subscription(
191     uint _fee,
192     address _fundWallet,
193     ERC20 _token) public
194   {
195     require(_token != address(0));
196     require(_fundWallet != address(0));
197     require(_fee > 0);
198     token = _token;
199     wallet = _fundWallet;
200     fee = _fee;
201     lastAppId = 0;
202   }
203 
204   function renewSubscriptionByDays(uint256 _appId, uint256 _userId, uint _day) external {
205     Application storage app = applications[_appId];
206     require(app.appId == _appId);
207     require(_day >= 1);
208     uint256 amount = getPrice(_appId, _day);
209     require(amount > 0);
210 
211     uint256 txFee = processFee(amount);
212     uint256 toAppOwner = amount.sub(txFee);
213     require(token.transferFrom(msg.sender, app.beneficiary, toAppOwner));
214 
215     uint256 currentExpiration = app.subscriptionExpiration[_userId];
216     // If their membership already expired...
217     if (currentExpiration < now) {
218       // ...use `now` as the starting point of their new subscription
219       currentExpiration = now;
220     }
221     uint256 newExpiration = currentExpiration.add(_day.mul(1 days));
222     app.subscriptionExpiration[_userId] = newExpiration;
223     emit SubscriptionPurchase(
224       msg.sender,
225       _appId,
226       _userId,
227       _day,
228       amount,
229       newExpiration);
230   }
231 
232   function registration(
233     bytes32 _appName,
234     uint256 _price,
235     address _beneficiary)
236   external
237   {
238     require(_appName != "");
239     require(_price > 0);
240     require(_beneficiary != address(0));
241     lastAppId = lastAppId.add(1);
242     Application storage app = applications[lastAppId];
243     app.appId = lastAppId;
244     app.appName = _appName;
245     app.beneficiary = _beneficiary;
246     app.owner = msg.sender;
247     app.prices.push(Pricing({
248       day : 1,
249       price : _price
250       }));
251     emit Registration(
252       msg.sender,
253       lastAppId,
254       _appName,
255       _price,
256       _beneficiary);
257   }
258 
259   function setPrice(uint256 _appId, uint256[] _days, uint256[] _prices) external {
260     Application storage app = applications[_appId];
261     require(app.owner == msg.sender);
262     app.prices.length = 0;
263     for (uint i = 0; i < _days.length; i++) {
264       require(_days[i] > 0);
265       require(_prices[i] > 0);
266       app.prices.push(Pricing({
267         day : _days[i],
268         price : _prices[i]
269         }));
270     }
271   }
272 
273   /// @dev Set fee percent for Carboneum team.
274   function setFee(uint _fee) external onlyOwner {
275     fee = _fee;
276   }
277 
278   function getExpiration(uint256 _appId, uint256 _userId) public view returns (uint256) {
279     Application storage app = applications[_appId];
280     return app.subscriptionExpiration[_userId];
281   }
282 
283   function getPrice(uint256 _appId, uint256 _day) public view returns (uint256) {
284     Application storage app = applications[_appId];
285     uint256 amount = UINT256_MAX;
286     for (uint i = 0; i < app.prices.length; i++) {
287       if (_day == app.prices[i].day) {
288         amount = app.prices[i].price;
289       } else if (_day > app.prices[i].day) {
290         uint256 rate = app.prices[i].price.div(app.prices[i].day);
291         uint256 amountInPrice = _day.mul(rate);
292         if (amountInPrice < amount) {
293           amount = amountInPrice;
294         }
295       }
296     }
297     if (amount == UINT256_MAX) {
298       amount = 0;
299     }
300     return amount;
301   }
302 
303   function processFee(uint256 _weiAmount) internal returns (uint256) {
304     uint256 txFee = _weiAmount.mul(fee).div(100);
305     require(token.transferFrom(msg.sender, wallet, txFee));
306     return txFee;
307   }
308 }