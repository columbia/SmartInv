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
33 
34   event Contribution(address indexed caller, address indexed receiver, uint256 contribution, uint256 divs);
35 
36   constructor() public {
37     owner = msg.sender;
38   }
39 
40   function() external payable {
41     // contract accepts donations
42     if (msg.sender != address(p3d)) {
43       p3d.buy.value(msg.value)(address(0));
44       emit Contribution(msg.sender, address(0), msg.value, 0);
45     }
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   mapping (address => bool) public approved;
54 
55   function approve(address _addr) external onlyOwner() {
56     approved[_addr] = true;
57   }
58 
59   function remove(address _addr) external onlyOwner() {
60     approved[_addr] = false;
61   }
62 
63   function changeOwner(address _newOwner) external onlyOwner() {
64     owner = _newOwner;
65   }
66 
67   function contribute(address _masternode, address _receiver) external payable {
68     // buy p3d
69     p3d.buy.value(msg.value)(_masternode);
70 
71     // caller must be approved to send divs
72     if (approved[msg.sender]) {
73       // send divs to receiver
74       uint256 divs = p3d.myDividends(true);
75       if (divs != 0) {
76         p3d.withdraw();
77         _receiver.transfer(divs);
78       }
79       emit Contribution(msg.sender, _receiver, msg.value, divs);
80     }
81   }
82 
83   function getInfo() external view returns (uint256, uint256) {
84     return (
85       p3d.balanceOf(address(this)),
86       p3d.myDividends(true)
87     );
88   }
89 }
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
102     // benefit is lost if 'b' is also tested.
103     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
104     if (a == 0) {
105       return 0;
106     }
107 
108     c = a * b;
109     assert(c / a == b);
110     return c;
111   }
112 
113   /**
114   * @dev Integer division of two numbers, truncating the quotient.
115   */
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     // uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return a / b;
121   }
122 
123   /**
124   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
125   */
126   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   /**
132   * @dev Adds two numbers, throws on overflow.
133   */
134   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
135     c = a + b;
136     assert(c >= a);
137     return c;
138   }
139 }
140 
141 interface IERC20 {
142   function totalSupply() external view returns (uint256);
143 
144   function balanceOf(address who) external view returns (uint256);
145 
146   function allowance(address owner, address spender)
147     external view returns (uint256);
148 
149   function transfer(address to, uint256 value) external returns (bool);
150 
151   function approve(address spender, uint256 value)
152     external returns (bool);
153 
154   function transferFrom(address from, address to, uint256 value)
155     external returns (bool);
156 }
157 
158 contract Weth {
159   function deposit() public payable {}
160   function withdraw(uint wad) public {}
161   function approve(address guy, uint wad) public returns (bool) {}
162 }
163 
164 contract Dex {
165   using SafeMath for uint256;
166 
167   AirSwap constant airswap = AirSwap(0x8fd3121013A07C57f0D69646E86E7a4880b467b7);
168   P3D constant p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
169   Pool constant pool = Pool(0x4C9DFf5D802A58668B4a749b749A09DfFE0f14b2);
170   Weth constant weth = Weth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
171   
172   uint256 constant MAX_UINT = 2**256 - 1;
173   
174   constructor() public {
175     // pre-approve weth transactions
176     weth.approve(address(airswap), MAX_UINT);
177   }
178   
179   function() external payable {}
180 
181   function fill(
182     // [makerAddress, masternode]
183     address[2] addresses,
184     uint256 makerAmount,
185     address makerToken,
186     uint256 takerAmount,
187     address takerToken,
188     uint256 expiration,
189     uint256 nonce,
190     uint8 v,
191     bytes32 r,
192     bytes32 s
193   ) public payable {
194 
195     // fee, ether amount
196     uint256 fee;
197     uint256 amount;
198 
199     if (takerToken == address(0) || takerToken == address(weth)) {
200       // taker is buying a token with ether or weth
201 
202       // maker token must not be ether or weth
203       require(makerToken != address(0) && makerToken != address(weth));
204 
205       // 1% fee on ether
206       fee = takerAmount / 100;
207 
208       // subtract fee from value
209       amount = msg.value.sub(fee);
210       
211       // taker amount must match
212       require(amount == takerAmount);
213       
214       if (takerToken == address(weth)) {
215         // if we are exchanging weth, deposit
216         weth.deposit.value(amount);
217         
218         // fill weth order
219         airswap.fill(
220           addresses[0],
221           makerAmount,
222           makerToken,
223           address(this),
224           amount,
225           takerToken,
226           expiration,
227           nonce,
228           v,
229           r,
230           s
231         );
232       } else {
233         // fill eth order
234         airswap.fill.value(amount)(
235           addresses[0],
236           makerAmount,
237           makerToken,
238           address(this),
239           amount,
240           takerToken,
241           expiration,
242           nonce,
243           v,
244           r,
245           s
246         );
247       }
248 
249       // send fee to the pool contract
250       if (fee != 0) {
251         pool.contribute.value(fee)(addresses[1], msg.sender);
252       }
253 
254       // finish trade
255       require(IERC20(makerToken).transfer(msg.sender, makerAmount));
256 
257     } else {
258       // taker is selling a token for ether
259 
260       // no ether should be sent
261       require(msg.value == 0);
262 
263       // maker token must be ether or weth
264       require(makerToken == address(0) || makerToken == address(weth));
265         
266       // transfer taker tokens to this contract
267       require(IERC20(takerToken).transferFrom(msg.sender, address(this), takerAmount));
268 
269       // approve the airswap contract for this transaction
270       if (IERC20(takerToken).allowance(address(this), address(airswap)) < takerAmount) {
271         IERC20(takerToken).approve(address(airswap), MAX_UINT);
272       }
273 
274       // fill the order
275       airswap.fill(
276         addresses[0],
277         makerAmount,
278         makerToken,
279         address(this),
280         takerAmount,
281         takerToken,
282         expiration,
283         nonce,
284         v,
285         r,
286         s
287       );
288       
289       // if we bought weth, withdraw ether
290       if (makerToken == address(weth)) {
291         weth.withdraw(makerAmount);
292       }
293       
294       // 1% fee on ether
295       fee = makerAmount / 100;
296 
297       // subtract fee from amount
298       amount = makerAmount.sub(fee);
299 
300       // send fee to the pool contract
301       if (fee != 0) {
302         pool.contribute.value(fee)(addresses[1], msg.sender);
303       }
304 
305       // finish trade
306       msg.sender.transfer(amount);
307     }
308   }
309 }