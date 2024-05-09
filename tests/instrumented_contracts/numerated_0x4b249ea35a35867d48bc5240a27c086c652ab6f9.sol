1 /**
2  * Copyright (c) 2019 STX AG license@stx.swiss
3  * No license
4  */
5 
6 pragma solidity ^0.5.3;
7 
8 /**
9  * @title Math
10  * @dev Assorted math operations
11  */
12 library Math {
13     /**
14     * @dev Returns the largest of two numbers.
15     */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21     * @dev Returns the smallest of two numbers.
22     */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28     * @dev Calculates the average of two numbers. Since these are integers,
29     * averages of an even and odd number cannot be represented, and will be
30     * rounded down.
31     */
32     function average(uint256 a, uint256 b) internal pure returns (uint256) {
33         // (a + b) / 2 can overflow, so we distribute
34         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
35     }
36 }
37 
38 /**
39  * @title ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/20
41  */
42 interface IERC20 {
43     function transfer(address to, uint256 value) external returns (bool);
44 
45     function approve(address spender, uint256 value) external returns (bool);
46 
47     function transferFrom(address from, address to, uint256 value) external returns (bool);
48 
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address who) external view returns (uint256);
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title SafeMath
62  * @dev Unsigned math operations with safety checks that revert on error
63  */
64 library SafeMath {
65     /**
66     * @dev Multiplies two unsigned integers, reverts on overflow.
67     */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b);
78 
79         return c;
80     }
81 
82     /**
83     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
84     */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0);
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96     */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105     * @dev Adds two unsigned integers, reverts on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
116     * reverts when dividing by zero.
117     */
118     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b != 0);
120         return a % b;
121     }
122 }
123 
124 /**
125  * @title SafeERC20
126  * @dev Wrappers around ERC20 operations that throw on failure.
127  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
128  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
129  */
130 library SafeERC20 {
131     using SafeMath for uint256;
132 
133     function safeTransfer(IERC20 token, address to, uint256 value) internal {
134         require(token.transfer(to, value));
135     }
136 
137     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
138         require(token.transferFrom(from, to, value));
139     }
140 
141     function safeApprove(IERC20 token, address spender, uint256 value) internal {
142         // safeApprove should only be called when setting an initial allowance,
143         // or when resetting it to zero. To increase and decrease it, use
144         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
145         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
146         require(token.approve(spender, value));
147     }
148 
149     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
150         uint256 newAllowance = token.allowance(address(this), spender).add(value);
151         require(token.approve(spender, newAllowance));
152     }
153 
154     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
155         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
156         require(token.approve(spender, newAllowance));
157     }
158 }
159 
160 contract MoneyMarketInterface {
161   function getSupplyBalance(address account, address asset) public view returns (uint);
162   function supply(address asset, uint amount) public returns (uint);
163   function withdraw(address asset, uint requestedAmount) public returns (uint);
164 }
165 
166 contract LoanEscrow {
167   using SafeERC20 for IERC20;
168   using SafeMath for uint256;
169 
170   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
171   IERC20 public dai = IERC20(DAI_ADDRESS);
172 
173   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
174   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
175 
176   event Deposited(address indexed from, uint256 daiAmount);
177   event Pulled(address indexed to, uint256 daiAmount);
178   event InterestWithdrawn(address indexed to, uint256 daiAmount);
179 
180   mapping(address => uint256) public deposits;
181   mapping(address => uint256) public pulls;
182   uint256 public deposited;
183   uint256 public pulled;
184 
185   modifier onlyBlockimmo() {
186     require(msg.sender == blockimmo());
187     _;
188   }
189 
190   function blockimmo() public returns (address);
191 
192   function withdrawInterest() public onlyBlockimmo {
193     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(pulled).sub(deposited);
194     require(amountInterest > 0, "no interest");
195 
196     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
197     require(errorCode == 0, "withdraw failed");
198 
199     dai.safeTransfer(msg.sender, amountInterest);
200     emit InterestWithdrawn(msg.sender, amountInterest);
201   }
202 
203   function deposit(address _from, uint256 _amountDai) internal {
204     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
205     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
206 
207     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
208     require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
209 
210     uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
211     require(errorCode == 0, "supply failed");
212     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
213 
214     deposits[_from] = deposits[_from].add(_amountDai);
215     deposited = deposited.add(_amountDai);
216     emit Deposited(_from, _amountDai);
217   }
218 
219   function pull(address _to, uint256 _amountDai, bool refund) internal {
220     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
221     require(errorCode == 0, "withdraw failed");
222 
223     if (refund) {
224       deposits[_to] = deposits[_to].sub(_amountDai);
225       deposited = deposited.sub(_amountDai);
226     } else {
227       pulls[_to] = pulls[_to].add(_amountDai);
228       pulled = pulled.add(_amountDai);
229     }
230 
231     dai.safeTransfer(_to, _amountDai);
232     emit Pulled(_to, _amountDai);
233   }
234 }
235 
236 contract WhitelistInterface {
237   function hasRole(address _operator, string memory _role) public view returns (bool);
238 }
239 
240 contract WhitelistProxyInterface {
241   function owner() public view returns (address);
242   function whitelist() public view returns (WhitelistInterface);
243 }
244 
245 contract Exchange is LoanEscrow {
246   using SafeERC20 for IERC20;
247   using SafeMath for uint256;
248 
249   uint256 public constant POINTS = uint256(10) ** 32;
250 
251   address public constant WHITELIST_PROXY_ADDRESS = 0x77eb36579e77e6a4bcd2Ca923ada0705DE8b4114;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
252   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
253 
254   struct Order {
255     bool buy;
256     uint256 closingTime;
257     uint256 numberOfTokens;
258     uint256 numberOfDai;
259     IERC20 token;
260     address from;
261   }
262 
263   mapping(bytes32 => Order) public orders;
264 
265   event OrderDeleted(bytes32 indexed order);
266   event OrderFilled(bytes32 indexed order, uint256 numberOfTokens, uint256 numberOfDai, address indexed to);
267   event OrderPosted(bytes32 indexed order, bool indexed buy, uint256 closingTime, uint256 numberOfTokens, uint256 numberOfDai, IERC20 indexed token, address from);
268 
269   function blockimmo() public returns (address) {
270     return whitelistProxy.owner();
271   }
272 
273   function deleteOrder(bytes32 _hash) public {
274     Order memory o = orders[_hash];
275     require(o.from == msg.sender || !isValid(_hash));
276 
277     if (o.buy)
278       pull(o.from, o.numberOfDai, true);
279 
280     _deleteOrder(_hash);
281   }
282 
283   function fillOrders(bytes32[] memory _hashes, address _from, uint256 _numberOfTokens, uint256 _numberOfDai) public {
284     uint256 remainingTokens = _numberOfTokens;
285     uint256 remainingDai = _numberOfDai;
286 
287     for (uint256 i = 0; i < _hashes.length; i++) {
288       bytes32 hash = _hashes[i];
289       require(isValid(hash), "invalid order");
290 
291       Order memory o = orders[hash];
292 
293       uint256 coefficient = (o.buy ? remainingTokens : remainingDai).mul(POINTS).div(o.buy ? o.numberOfTokens : o.numberOfDai);
294 
295       uint256 nTokens = o.numberOfTokens.mul(Math.min(coefficient, POINTS)).div(POINTS);
296       uint256 vDai = o.numberOfDai.mul(Math.min(coefficient, POINTS)).div(POINTS);
297 
298       o.buy ? remainingTokens -= nTokens : remainingDai -= vDai;
299       o.buy ? pull(_from, vDai, false) : dai.safeTransferFrom(msg.sender, o.from, vDai);
300       o.token.safeTransferFrom(o.buy ? _from : o.from, o.buy ? o.from : _from, nTokens);
301 
302       emit OrderFilled(hash, nTokens, vDai, _from);
303       _deleteOrder(hash);
304 
305       if (coefficient < POINTS)
306         _postOrder(o.buy, o.closingTime, o.numberOfTokens.sub(nTokens), o.numberOfDai.sub(vDai), o.token, o.from);
307     }
308   }
309 
310   function isValid(bytes32 _hash) public view returns (bool valid) {
311     Order memory o = orders[_hash];
312 
313     valid = now <= o.closingTime && o.closingTime <= now.add(1 weeks);
314     valid = valid && (o.buy || (o.token.balanceOf(o.from) >= o.numberOfTokens && o.token.allowance(o.from, address(this)) >= o.numberOfTokens));
315     valid = valid && o.numberOfTokens > 0 && o.numberOfDai > 0;
316     valid = valid && whitelistProxy.whitelist().hasRole(address(o.token), "authorized");
317   }
318 
319   function postOrder(bool _buy, uint256 _closingTime, address _from, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token) public {
320     if (_buy)
321       deposit(_from, _numberOfDai);
322 
323     _postOrder(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
324   }
325 
326   function _deleteOrder(bytes32 _hash) internal {
327     delete orders[_hash];
328     emit OrderDeleted(_hash);
329   }
330 
331   function _postOrder(bool _buy, uint256 _closingTime, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token, address _from) internal {
332     bytes32 hash = keccak256(abi.encodePacked(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from));
333     orders[hash] = Order(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
334 
335     require(isValid(hash), "invalid order");
336     emit OrderPosted(hash, _buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
337   }
338 }