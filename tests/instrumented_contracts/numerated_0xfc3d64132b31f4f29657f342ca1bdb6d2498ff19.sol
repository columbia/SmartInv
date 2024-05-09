1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6 
7 pragma solidity ^0.5.2;
8 
9 /**
10  * @title Math
11  * @dev Assorted math operations
12  */
13 library Math {
14     /**
15     * @dev Returns the largest of two numbers.
16     */
17     function max(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a >= b ? a : b;
19     }
20 
21     /**
22     * @dev Returns the smallest of two numbers.
23     */
24     function min(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a < b ? a : b;
26     }
27 
28     /**
29     * @dev Calculates the average of two numbers. Since these are integers,
30     * averages of an even and odd number cannot be represented, and will be
31     * rounded down.
32     */
33     function average(uint256 a, uint256 b) internal pure returns (uint256) {
34         // (a + b) / 2 can overflow, so we distribute
35         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
36     }
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Unsigned math operations with safety checks that revert on error
42  */
43 library SafeMath {
44     /**
45     * @dev Multiplies two unsigned integers, reverts on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
63     */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Solidity only automatically asserts when dividing by 0
66         require(b > 0);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Adds two unsigned integers, reverts on overflow.
85     */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a);
89 
90         return c;
91     }
92 
93     /**
94     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
95     * reverts when dividing by zero.
96     */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0);
99         return a % b;
100     }
101 }
102 
103 /**
104  * @title Secondary
105  * @dev A Secondary contract can only be used by its primary account (the one that created it)
106  */
107 contract Secondary {
108     address private _primary;
109 
110     event PrimaryTransferred(
111         address recipient
112     );
113 
114     /**
115      * @dev Sets the primary account to the one that is creating the Secondary contract.
116      */
117     constructor () internal {
118         _primary = msg.sender;
119         emit PrimaryTransferred(_primary);
120     }
121 
122     /**
123      * @dev Reverts if called from any account other than the primary.
124      */
125     modifier onlyPrimary() {
126         require(msg.sender == _primary);
127         _;
128     }
129 
130     /**
131      * @return the address of the primary.
132      */
133     function primary() public view returns (address) {
134         return _primary;
135     }
136 
137     /**
138      * @dev Transfers contract to a new primary.
139      * @param recipient The address of new primary.
140      */
141     function transferPrimary(address recipient) public onlyPrimary {
142         require(recipient != address(0));
143         _primary = recipient;
144         emit PrimaryTransferred(_primary);
145     }
146 }
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 interface IERC20 {
153     function transfer(address to, uint256 value) external returns (bool);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) external returns (bool);
158 
159     function totalSupply() external view returns (uint256);
160 
161     function balanceOf(address who) external view returns (uint256);
162 
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 /**
171  * @title SafeERC20
172  * @dev Wrappers around ERC20 operations that throw on failure.
173  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
174  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
175  */
176 library SafeERC20 {
177     using SafeMath for uint256;
178 
179     function safeTransfer(IERC20 token, address to, uint256 value) internal {
180         require(token.transfer(to, value));
181     }
182 
183     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
184         require(token.transferFrom(from, to, value));
185     }
186 
187     function safeApprove(IERC20 token, address spender, uint256 value) internal {
188         // safeApprove should only be called when setting an initial allowance,
189         // or when resetting it to zero. To increase and decrease it, use
190         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
191         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
192         require(token.approve(spender, value));
193     }
194 
195     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
196         uint256 newAllowance = token.allowance(address(this), spender).add(value);
197         require(token.approve(spender, newAllowance));
198     }
199 
200     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
201         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
202         require(token.approve(spender, newAllowance));
203     }
204 }
205 
206 contract MoneyMarketInterface {
207   function getSupplyBalance(address account, address asset) public view returns (uint);
208   function supply(address asset, uint amount) public returns (uint);
209   function withdraw(address asset, uint requestedAmount) public returns (uint);
210 }
211 
212 contract LoanEscrow is Secondary {
213   using SafeERC20 for IERC20;
214   using SafeMath for uint256;
215 
216   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
217   IERC20 public dai = IERC20(DAI_ADDRESS);
218 
219   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
220   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
221 
222   event Deposited(address indexed from, uint256 daiAmount);
223   event Pulled(address indexed to, uint256 daiAmount);
224   event InterestWithdrawn(address indexed to, uint256 daiAmount);
225 
226   mapping(address => uint256) public deposits;
227   mapping(address => uint256) public pulls;
228   uint256 public deposited;
229   uint256 public pulled;
230 
231   function withdrawInterest() public onlyPrimary {
232     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).sub(deposited).add(pulled);
233     require(amountInterest > 0, "no interest");
234 
235     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
236     require(errorCode == 0, "withdraw failed");
237 
238     dai.safeTransfer(msg.sender, amountInterest);
239     emit InterestWithdrawn(msg.sender, amountInterest);
240   }
241 
242   function deposit(address _from, uint256 _amountDai) internal {
243     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
244     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
245 
246     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
247     require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
248 
249     uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
250     require(errorCode == 0, "supply failed");
251     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
252 
253     deposits[_from] = deposits[_from].add(_amountDai);
254     deposited = deposited.add(_amountDai);
255     emit Deposited(_from, _amountDai);
256   }
257 
258   function pull(address _to, uint256 _amountDai, bool refund) internal {
259     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
260     require(errorCode == 0, "withdraw failed");
261 
262     if (refund) {
263       deposits[_to] = deposits[_to].sub(_amountDai);
264       deposited = deposited.sub(_amountDai);
265     } else {
266       pulls[_to] = pulls[_to].add(_amountDai);
267       pulled = pulled.add(_amountDai);
268     }
269 
270     dai.safeTransfer(_to, _amountDai);
271     emit Pulled(_to, _amountDai);
272   }
273 }
274 
275 contract WhitelistInterface {
276   function hasRole(address _operator, string memory _role) public view returns (bool);
277 }
278 
279 contract WhitelistProxyInterface {
280   function whitelist() public view returns (WhitelistInterface);
281 }
282 
283 contract Exchange is LoanEscrow {
284   using SafeERC20 for IERC20;
285   using SafeMath for uint256;
286 
287   uint256 public constant POINTS = uint256(10) ** 32;
288 
289   address public constant WHITELIST_PROXY_ADDRESS = 0x77eb36579e77e6a4bcd2Ca923ada0705DE8b4114;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
290   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
291 
292   struct Order {
293     bool buy;
294     uint256 closingTime;
295     uint256 numberOfTokens;
296     uint256 numberOfDai;
297     IERC20 token;
298     address from;
299   }
300 
301   mapping(bytes32 => Order) public orders;
302 
303   event OrderDeleted(bytes32 indexed order);
304   event OrderFilled(bytes32 indexed order, uint256 numberOfTokens, uint256 numberOfDai, address indexed to);
305   event OrderPosted(bytes32 indexed order, bool indexed buy, uint256 closingTime, uint256 numberOfTokens, uint256 numberOfDai, IERC20 indexed token, address from);
306 
307   function deleteOrder(bytes32 _hash) public {
308     Order memory o = orders[_hash];
309     require(o.from == msg.sender || !isValid(_hash));
310 
311     if (o.buy)
312       pull(o.from, o.numberOfDai, true);
313 
314     _deleteOrder(_hash);
315   }
316 
317   function fillOrders(bytes32[] memory _hashes, address _from, uint256 numberOfTokens) public {
318     uint256 remainingTokens = numberOfTokens;
319     uint256 remainingDai = dai.allowance(msg.sender, address(this));
320 
321     for (uint256 i = 0; i < _hashes.length; i++) {
322       bytes32 hash = _hashes[i];
323       require(isValid(hash), "invalid order");
324 
325       Order memory o = orders[hash];
326 
327       uint256 coefficient = (o.buy ? remainingTokens : remainingDai).mul(POINTS).div(o.buy ? o.numberOfTokens : o.numberOfDai);
328 
329       uint256 nTokens = o.numberOfTokens.mul(Math.min(coefficient, POINTS)).div(POINTS);
330       uint256 vDai = o.numberOfDai.mul(Math.min(coefficient, POINTS)).div(POINTS);
331 
332       o.buy ? remainingTokens -= nTokens : remainingDai -= vDai;
333       o.buy ? pull(_from, vDai, false) : dai.safeTransferFrom(msg.sender, o.from, vDai);
334       o.token.safeTransferFrom(o.buy ? _from : o.from, o.buy ? o.from : _from, nTokens);
335 
336       emit OrderFilled(hash, nTokens, vDai, _from);
337       _deleteOrder(hash);
338 
339       if (coefficient < POINTS)
340         _postOrder(o.buy, o.closingTime, o.numberOfTokens.sub(nTokens), o.numberOfDai.sub(vDai), o.token, o.from);
341     }
342 
343     dai.safeTransferFrom(msg.sender, _from, remainingDai);
344     require(dai.allowance(msg.sender, address(this)) == 0);
345   }
346 
347   function isValid(bytes32 _hash) public view returns (bool valid) {
348     Order memory o = orders[_hash];
349 
350     valid = o.buy || (o.token.balanceOf(o.from) >= o.numberOfTokens && o.token.allowance(o.from, address(this)) >= o.numberOfTokens);
351     valid = valid && now <= o.closingTime && o.closingTime <= now.add(1 weeks);
352     valid = valid && o.numberOfTokens > 0 && o.numberOfDai > 0;
353     valid = valid && whitelistProxy.whitelist().hasRole(address(o.token), "authorized");
354   }
355 
356   function postOrder(bool _buy, uint256 _closingTime, address _from, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token) public {
357     if (_buy)
358       deposit(_from, _numberOfDai);
359 
360     _postOrder(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
361   }
362 
363   function _deleteOrder(bytes32 _hash) internal {
364     delete orders[_hash];
365     emit OrderDeleted(_hash);
366   }
367 
368   function _postOrder(bool _buy, uint256 _closingTime, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token, address _from) internal {
369     bytes32 hash = keccak256(abi.encodePacked(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from));
370     orders[hash] = Order(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
371 
372     require(isValid(hash), "invalid order");
373     emit OrderPosted(hash, _buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
374   }
375 }