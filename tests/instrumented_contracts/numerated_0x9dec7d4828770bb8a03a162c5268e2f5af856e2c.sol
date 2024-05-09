1 contract AirSwap {
2     function fill(
3       address makerAddress,
4       uint makerAmount,
5       address makerToken,
6       address takerAddress,
7       uint takerAmount,
8       address takerToken,
9       uint256 expiration,
10       uint256 nonce,
11       uint8 v,
12       bytes32 r,
13       bytes32 s
14     ) payable {}
15 }
16 
17 contract P3D {
18   uint256 public stakingRequirement;
19   function buy(address _referredBy) public payable returns(uint256) {}
20   function balanceOf(address _customerAddress) view public returns(uint256) {}
21   function exit() public {}
22   function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {}
23   function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) { }
24   function myDividends(bool _includeReferralBonus) public view returns(uint256) {}
25   function withdraw() public {}
26   function totalSupply() public view returns(uint256);
27 }
28 
29 contract Pool {
30   P3D constant public p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
31 
32   address public owner;
33   uint256 public minimum;
34 
35   event Contribution(address indexed caller, address indexed receiver, uint256 contribution, uint256 payout);
36   event Approved(address addr);
37   event Removed(address addr);
38   event OwnerChanged(address owner);
39   event MinimumChanged(uint256 minimum);
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   function() external payable {
46     // accept donations
47     if (msg.sender != address(p3d)) {
48       p3d.buy.value(msg.value)(msg.sender);
49       emit Contribution(msg.sender, address(0), msg.value, 0);
50     }
51   }
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   mapping (address => bool) public approved;
59 
60   function approve(address _addr) external onlyOwner() {
61     approved[_addr] = true;
62     emit Approved(_addr);
63   }
64 
65   function remove(address _addr) external onlyOwner() {
66     approved[_addr] = false;
67     emit Removed(_addr);
68   }
69 
70   function changeOwner(address _newOwner) external onlyOwner() {
71     owner = _newOwner;
72     emit OwnerChanged(owner);
73   }
74   
75   function changeMinimum(uint256 _minimum) external onlyOwner() {
76     minimum = _minimum;
77     emit MinimumChanged(minimum);
78   }
79 
80   function contribute(address _masternode, address _receiver) external payable {
81     // buy p3d
82     p3d.buy.value(msg.value)(_masternode);
83     
84     uint256 payout;
85     
86     // caller must be approved and value must meet the minimum
87     if (approved[msg.sender] && msg.value >= minimum) {
88       payout = p3d.myDividends(true);
89       if (payout != 0) {
90         p3d.withdraw();
91         // send divs to receiver
92         _receiver.transfer(payout);
93       }
94     }
95     
96     emit Contribution(msg.sender, _receiver, msg.value, payout);
97   }
98 
99   function getInfo() external view returns (uint256, uint256) {
100     return (
101       p3d.balanceOf(address(this)),
102       p3d.myDividends(true)
103     );
104   }
105 }
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     // uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return a / b;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 interface IERC20 {
158   function totalSupply() external view returns (uint256);
159 
160   function balanceOf(address who) external view returns (uint256);
161 
162   function allowance(address owner, address spender)
163     external view returns (uint256);
164 
165   function transfer(address to, uint256 value) external returns (bool);
166 
167   function approve(address spender, uint256 value)
168     external returns (bool);
169 
170   function transferFrom(address from, address to, uint256 value)
171     external returns (bool);
172 }
173 
174 contract Weth {
175   function deposit() public payable {}
176   function withdraw(uint wad) public {}
177   function approve(address guy, uint wad) public returns (bool) {}
178 }
179 
180 contract Dex {
181   using SafeMath for uint256;
182 
183   AirSwap constant airswap = AirSwap(0x8fd3121013A07C57f0D69646E86E7a4880b467b7);
184   P3D constant p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
185   Pool constant pool = Pool(0xE00c09fEdD3d3Ed09e2D6F6F6E9B1597c1A99bc8);
186   Weth constant weth = Weth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
187   
188   uint256 constant MAX_UINT = 2**256 - 1;
189   
190   constructor() public {
191     // pre-approve weth transactions
192     weth.approve(address(airswap), MAX_UINT);
193   }
194   
195   function() external payable {}
196 
197   function fill(
198     // [makerAddress, masternode]
199     address[2] addresses,
200     uint256 makerAmount,
201     address makerToken,
202     uint256 takerAmount,
203     address takerToken,
204     uint256 expiration,
205     uint256 nonce,
206     uint8 v,
207     bytes32 r,
208     bytes32 s
209   ) public payable {
210 
211     // fee, ether amount
212     uint256 fee;
213     uint256 amount;
214 
215     if (takerToken == address(0) || takerToken == address(weth)) {
216       // taker is buying a token with ether or weth
217 
218       // maker token must not be ether or weth
219       require(makerToken != address(0) && makerToken != address(weth));
220 
221       // 1% fee on ether
222       fee = takerAmount / 100;
223 
224       // subtract fee from value
225       amount = msg.value.sub(fee);
226       
227       // taker amount must match
228       require(amount == takerAmount);
229       
230       if (takerToken == address(weth)) {
231         // if we are exchanging weth, deposit
232         weth.deposit.value(amount);
233         
234         // fill weth order
235         airswap.fill(
236           addresses[0],
237           makerAmount,
238           makerToken,
239           address(this),
240           amount,
241           takerToken,
242           expiration,
243           nonce,
244           v,
245           r,
246           s
247         );
248       } else {
249         // fill eth order
250         airswap.fill.value(amount)(
251           addresses[0],
252           makerAmount,
253           makerToken,
254           address(this),
255           amount,
256           takerToken,
257           expiration,
258           nonce,
259           v,
260           r,
261           s
262         );
263       }
264 
265       // send fee to the pool contract
266       if (fee != 0) {
267         pool.contribute.value(fee)(addresses[1], msg.sender);
268       }
269 
270       // finish trade
271       require(IERC20(makerToken).transfer(msg.sender, makerAmount));
272 
273     } else {
274       // taker is selling a token for ether
275 
276       // no ether should be sent
277       require(msg.value == 0);
278 
279       // maker token must be ether or weth
280       require(makerToken == address(0) || makerToken == address(weth));
281         
282       // transfer taker tokens to this contract
283       require(IERC20(takerToken).transferFrom(msg.sender, address(this), takerAmount));
284 
285       // approve the airswap contract for this transaction
286       if (IERC20(takerToken).allowance(address(this), address(airswap)) < takerAmount) {
287         IERC20(takerToken).approve(address(airswap), MAX_UINT);
288       }
289 
290       // fill the order
291       airswap.fill(
292         addresses[0],
293         makerAmount,
294         makerToken,
295         address(this),
296         takerAmount,
297         takerToken,
298         expiration,
299         nonce,
300         v,
301         r,
302         s
303       );
304       
305       // if we bought weth, withdraw ether
306       if (makerToken == address(weth)) {
307         weth.withdraw(makerAmount);
308       }
309       
310       // 1% fee on ether
311       fee = makerAmount / 100;
312 
313       // subtract fee from amount
314       amount = makerAmount.sub(fee);
315 
316       // send fee to the pool contract
317       if (fee != 0) {
318         pool.contribute.value(fee)(addresses[1], msg.sender);
319       }
320 
321       // finish trade
322       msg.sender.transfer(amount);
323     }
324   }
325 }