1 /**
2  * Copyright (c) 2019 STX AG license@stx.swiss
3  */
4 
5 pragma solidity ^0.5.3;
6 
7 /**
8  * @title Math
9  * @dev Assorted math operations
10  */
11 library Math {
12     /**
13     * @dev Returns the largest of two numbers.
14     */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20     * @dev Returns the smallest of two numbers.
21     */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27     * @dev Calculates the average of two numbers. Since these are integers,
28     * averages of an even and odd number cannot be represented, and will be
29     * rounded down.
30     */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Unsigned math operations with safety checks that revert on error
40  */
41 library SafeMath {
42     /**
43     * @dev Multiplies two unsigned integers, reverts on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82     * @dev Adds two unsigned integers, reverts on overflow.
83     */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87 
88         return c;
89     }
90 
91     /**
92     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93     * reverts when dividing by zero.
94     */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 interface IERC20 {
106     function transfer(address to, uint256 value) external returns (bool);
107 
108     function approve(address spender, uint256 value) external returns (bool);
109 
110     function transferFrom(address from, address to, uint256 value) external returns (bool);
111 
112     function totalSupply() external view returns (uint256);
113 
114     function balanceOf(address who) external view returns (uint256);
115 
116     function allowance(address owner, address spender) external view returns (uint256);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /**
124  * @title SafeERC20
125  * @dev Wrappers around ERC20 operations that throw on failure.
126  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
127  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
128  */
129 library SafeERC20 {
130     using SafeMath for uint256;
131 
132     function safeTransfer(IERC20 token, address to, uint256 value) internal {
133         require(token.transfer(to, value));
134     }
135 
136     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
137         require(token.transferFrom(from, to, value));
138     }
139 
140     function safeApprove(IERC20 token, address spender, uint256 value) internal {
141         // safeApprove should only be called when setting an initial allowance,
142         // or when resetting it to zero. To increase and decrease it, use
143         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
144         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
145         require(token.approve(spender, value));
146     }
147 
148     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
149         uint256 newAllowance = token.allowance(address(this), spender).add(value);
150         require(token.approve(spender, newAllowance));
151     }
152 
153     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
154         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
155         require(token.approve(spender, newAllowance));
156     }
157 }
158 
159 contract MoneyMarketInterface {
160   function getSupplyBalance(address account, address asset) public view returns (uint);
161   function supply(address asset, uint amount) public returns (uint);
162   function withdraw(address asset, uint requestedAmount) public returns (uint);
163 }
164 
165 contract LoanEscrow {
166   using SafeERC20 for IERC20;
167   using SafeMath for uint256;
168 
169   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
170   IERC20 public dai = IERC20(DAI_ADDRESS);
171 
172   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
173   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
174 
175   event Deposited(address indexed from, uint256 daiAmount);
176   event Pulled(address indexed to, uint256 daiAmount);
177   event InterestWithdrawn(address indexed to, uint256 daiAmount);
178 
179   mapping(address => uint256) public deposits;
180   mapping(address => uint256) public pulls;
181   uint256 public deposited;
182   uint256 public pulled;
183 
184   modifier onlyBlockimmo() {
185     require(msg.sender == blockimmo());
186     _;
187   }
188 
189   function blockimmo() public returns (address);
190 
191   function withdrawInterest() public onlyBlockimmo {
192     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(pulled).sub(deposited);
193     require(amountInterest > 0, "no interest");
194 
195     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
196     require(errorCode == 0, "withdraw failed");
197 
198     dai.safeTransfer(msg.sender, amountInterest);
199     emit InterestWithdrawn(msg.sender, amountInterest);
200   }
201 
202   function deposit(address _from, uint256 _amountDai) internal {
203     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
204     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
205 
206     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
207     require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
208 
209     uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
210     require(errorCode == 0, "supply failed");
211     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
212 
213     deposits[_from] = deposits[_from].add(_amountDai);
214     deposited = deposited.add(_amountDai);
215     emit Deposited(_from, _amountDai);
216   }
217 
218   function pull(address _to, uint256 _amountDai, bool refund) internal {
219     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
220     require(errorCode == 0, "withdraw failed");
221 
222     if (refund) {
223       deposits[_to] = deposits[_to].sub(_amountDai);
224       deposited = deposited.sub(_amountDai);
225     } else {
226       pulls[_to] = pulls[_to].add(_amountDai);
227       pulled = pulled.add(_amountDai);
228     }
229 
230     dai.safeTransfer(_to, _amountDai);
231     emit Pulled(_to, _amountDai);
232   }
233 }
234 
235 contract WhitelistInterface {
236   function hasRole(address _operator, string memory _role) public view returns (bool);
237 }
238 
239 contract WhitelistProxyInterface {
240   function owner() public view returns (address);
241   function whitelist() public view returns (WhitelistInterface);
242 }
243 
244 contract Exchange is LoanEscrow {
245   using SafeERC20 for IERC20;
246   using SafeMath for uint256;
247 
248   uint256 public constant POINTS = uint256(10) ** 32;
249 
250   address public constant WHITELIST_PROXY_ADDRESS = 0x77eb36579e77e6a4bcd2Ca923ada0705DE8b4114;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
251   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
252 
253   struct Order {
254     bool buy;
255     uint256 closingTime;
256     uint256 numberOfTokens;
257     uint256 numberOfDai;
258     IERC20 token;
259     address from;
260   }
261 
262   mapping(bytes32 => Order) public orders;
263 
264   event OrderDeleted(bytes32 indexed order);
265   event OrderFilled(bytes32 indexed order, uint256 numberOfTokens, uint256 numberOfDai, address indexed to);
266   event OrderPosted(bytes32 indexed order, bool indexed buy, uint256 closingTime, uint256 numberOfTokens, uint256 numberOfDai, IERC20 indexed token, address from);
267 
268   function blockimmo() public returns (address) {
269     return whitelistProxy.owner();
270   }
271 
272   function deleteOrder(bytes32 _hash) public {
273     Order memory o = orders[_hash];
274     require(o.from == msg.sender || !isValid(_hash));
275 
276     if (o.buy)
277       pull(o.from, o.numberOfDai, true);
278 
279     _deleteOrder(_hash);
280   }
281 
282   function fillOrders(bytes32[] memory _hashes, address _from, uint256 _numberOfTokens, uint256 _numberOfDai) public {
283     uint256 remainingTokens = _numberOfTokens;
284     uint256 remainingDai = _numberOfDai;
285 
286     for (uint256 i = 0; i < _hashes.length; i++) {
287       bytes32 hash = _hashes[i];
288       require(isValid(hash), "invalid order");
289 
290       Order memory o = orders[hash];
291 
292       uint256 coefficient = (o.buy ? remainingTokens : remainingDai).mul(POINTS).div(o.buy ? o.numberOfTokens : o.numberOfDai);
293 
294       uint256 nTokens = o.numberOfTokens.mul(Math.min(coefficient, POINTS)).div(POINTS);
295       uint256 vDai = o.numberOfDai.mul(Math.min(coefficient, POINTS)).div(POINTS);
296 
297       o.buy ? remainingTokens -= nTokens : remainingDai -= vDai;
298       o.buy ? pull(_from, vDai, false) : dai.safeTransferFrom(msg.sender, o.from, vDai);
299       o.token.safeTransferFrom(o.buy ? _from : o.from, o.buy ? o.from : _from, nTokens);
300 
301       emit OrderFilled(hash, nTokens, vDai, _from);
302       _deleteOrder(hash);
303 
304       if (coefficient < POINTS)
305         _postOrder(o.buy, o.closingTime, o.numberOfTokens.sub(nTokens), o.numberOfDai.sub(vDai), o.token, o.from);
306     }
307   }
308 
309   function isValid(bytes32 _hash) public view returns (bool valid) {
310     Order memory o = orders[_hash];
311 
312     valid = now <= o.closingTime && o.closingTime <= now.add(4 weeks);
313     valid = valid && (o.buy || (o.token.balanceOf(o.from) >= o.numberOfTokens && o.token.allowance(o.from, address(this)) >= o.numberOfTokens));
314     valid = valid && o.numberOfTokens > 0 && o.numberOfDai > 0;
315     valid = valid && whitelistProxy.whitelist().hasRole(address(o.token), "authorized");
316   }
317 
318   function postOrder(bool _buy, uint256 _closingTime, address _from, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token) public {
319     if (_buy)
320       deposit(_from, _numberOfDai);
321 
322     _postOrder(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
323   }
324 
325   function _deleteOrder(bytes32 _hash) internal {
326     delete orders[_hash];
327     emit OrderDeleted(_hash);
328   }
329 
330   function _postOrder(bool _buy, uint256 _closingTime, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token, address _from) internal {
331     bytes32 hash = keccak256(abi.encodePacked(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from));
332     require(orders[hash].closingTime == 0, "order exists");
333 
334     orders[hash] = Order(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
335 
336     require(isValid(hash), "invalid order");
337     emit OrderPosted(hash, _buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
338   }
339 }