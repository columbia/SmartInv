1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.5.17;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function decimals() external view returns (uint);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40 
41         return c;
42     }
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         return div(a, b, "SafeMath: division by zero");
45     }
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50 
51         return c;
52     }
53     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54         return mod(a, b, "SafeMath: modulo by zero");
55     }
56     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b != 0, errorMessage);
58         return a % b;
59     }
60 }
61 
62 library Address {
63     function isContract(address account) internal view returns (bool) {
64         bytes32 codehash;
65         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
66         // solhint-disable-next-line no-inline-assembly
67         assembly { codehash := extcodehash(account) }
68         return (codehash != 0x0 && codehash != accountHash);
69     }
70     function toPayable(address account) internal pure returns (address payable) {
71         return address(uint160(account));
72     }
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75 
76         // solhint-disable-next-line avoid-call-value
77         (bool success, ) = recipient.call.value(amount)("");
78         require(success, "Address: unable to send value, recipient may have reverted");
79     }
80 }
81 
82 library SafeERC20 {
83     using SafeMath for uint256;
84     using Address for address;
85 
86     function safeTransfer(IERC20 token, address to, uint256 value) internal {
87         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
88     }
89 
90     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
91         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
92     }
93 
94     function safeApprove(IERC20 token, address spender, uint256 value) internal {
95         require((value == 0) || (token.allowance(address(this), spender) == 0),
96             "SafeERC20: approve from non-zero to non-zero allowance"
97         );
98         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
99     }
100     function callOptionalReturn(IERC20 token, bytes memory data) private {
101         require(address(token).isContract(), "SafeERC20: call to non-contract");
102 
103         // solhint-disable-next-line avoid-low-level-calls
104         (bool success, bytes memory returndata) = address(token).call(data);
105         require(success, "SafeERC20: low-level call failed");
106 
107         if (returndata.length > 0) { // Return data is optional
108             // solhint-disable-next-line max-line-length
109             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
110         }
111     }
112 }
113 
114 interface Controller {
115     function vaults(address) external view returns (address);
116     function rewards() external view returns (address);
117 }
118 
119 /*
120 
121  A strategy must implement the following calls;
122  
123  - deposit()
124  - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller
125  - withdraw(uint) - Controller | Vault role - withdraw should always return to vault
126  - withdrawAll() - Controller | Vault role - withdraw should always return to vault
127  - balanceOf()
128  
129  Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller
130  
131 */
132 
133 interface Gauge {
134     function deposit(uint) external;
135     function balanceOf(address) external view returns (uint);
136     function withdraw(uint) external;
137 }
138 
139 interface Mintr {
140     function mint(address) external;
141 }
142 
143 interface Uni {
144     function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;
145 }
146 
147 interface yERC20 {
148   function deposit(uint256 _amount) external;
149   function withdraw(uint256 _amount) external;
150 }
151 
152 interface ICurveFi {
153 
154   function get_virtual_price() external view returns (uint);
155   function add_liquidity(
156     uint256[4] calldata amounts,
157     uint256 min_mint_amount
158   ) external;
159   function remove_liquidity_imbalance(
160     uint256[4] calldata amounts,
161     uint256 max_burn_amount
162   ) external;
163   function remove_liquidity(
164     uint256 _amount,
165     uint256[4] calldata amounts
166   ) external;
167   function exchange(
168     int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount
169   ) external;
170 }
171 
172 contract StrategyCurveYCRVVoter {
173     using SafeERC20 for IERC20;
174     using Address for address;
175     using SafeMath for uint256;
176     
177     address constant public want = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
178     address constant public pool = address(0xFA712EE4788C042e2B7BB55E6cb8ec569C4530c1);
179     address constant public mintr = address(0xd061D61a4d941c39E5453435B6345Dc261C2fcE0);
180     address constant public crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
181     address constant public uni = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
182     address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for crv <> weth <> dai route
183     
184     address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
185     address constant public ydai = address(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
186     address constant public curve = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
187     
188     uint public keepCRV = 1000;
189     uint constant public keepCRVMax = 10000;
190     
191     uint public performanceFee = 500;
192     uint constant public performanceMax = 10000;
193     
194     uint public withdrawalFee = 50;
195     uint constant public withdrawalMax = 10000;
196     
197     address public governance;
198     address public controller;
199     address public strategist;
200     
201     constructor(address _controller) public {
202         governance = msg.sender;
203         strategist = msg.sender;
204         controller = _controller;
205     }
206     
207     function getName() external pure returns (string memory) {
208         return "StrategyCurveYCRVVoter";
209     }
210     
211     function setStrategist(address _strategist) external {
212         require(msg.sender == governance, "!governance");
213         strategist = _strategist;
214     }
215     
216     function setKeepCRV(uint _keepCRV) external {
217         require(msg.sender == governance, "!governance");
218         keepCRV = _keepCRV;
219     }
220     
221     function setWithdrawalFee(uint _withdrawalFee) external {
222         require(msg.sender == governance, "!governance");
223         withdrawalFee = _withdrawalFee;
224     }
225     
226     function setPerformanceFee(uint _performanceFee) external {
227         require(msg.sender == governance, "!governance");
228         performanceFee = _performanceFee;
229     }
230     
231     function deposit() public {
232         uint _want = IERC20(want).balanceOf(address(this));
233         if (_want > 0) {
234             IERC20(want).safeApprove(pool, 0);
235             IERC20(want).safeApprove(pool, _want);
236             Gauge(pool).deposit(_want);
237         }
238         
239     }
240     
241     // Controller only function for creating additional rewards from dust
242     function withdraw(IERC20 _asset) external returns (uint balance) {
243         require(msg.sender == controller, "!controller");
244         require(want != address(_asset), "want");
245         require(crv != address(_asset), "crv");
246         require(ydai != address(_asset), "ydai");
247         require(dai != address(_asset), "dai");
248         balance = _asset.balanceOf(address(this));
249         _asset.safeTransfer(controller, balance);
250     }
251     
252     // Withdraw partial funds, normally used with a vault withdrawal
253     function withdraw(uint _amount) external {
254         require(msg.sender == controller, "!controller");
255         uint _balance = IERC20(want).balanceOf(address(this));
256         if (_balance < _amount) {
257             _amount = _withdrawSome(_amount.sub(_balance));
258             _amount = _amount.add(_balance);
259         }
260         
261         uint _fee = _amount.mul(withdrawalFee).div(withdrawalMax);
262         
263         IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);
264         address _vault = Controller(controller).vaults(address(want));
265         require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
266         
267         IERC20(want).safeTransfer(_vault, _amount.sub(_fee));
268     }
269     
270     // Withdraw all funds, normally used when migrating strategies
271     function withdrawAll() external returns (uint balance) {
272         require(msg.sender == controller, "!controller");
273         _withdrawAll();
274         
275         
276         balance = IERC20(want).balanceOf(address(this));
277         
278         address _vault = Controller(controller).vaults(address(want));
279         require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
280         IERC20(want).safeTransfer(_vault, balance);
281     }
282     
283     function _withdrawAll() internal {
284         Gauge(pool).withdraw(Gauge(pool).balanceOf(address(this)));
285     }
286     
287     function harvest() public {
288         require(msg.sender == strategist || msg.sender == governance, "!authorized");
289         Mintr(mintr).mint(pool);
290         uint _crv = IERC20(crv).balanceOf(address(this));
291         if (_crv > 0) {
292             
293             uint _keepCRV = _crv.mul(keepCRV).div(keepCRVMax);
294             IERC20(crv).safeTransfer(Controller(controller).rewards(), _keepCRV);
295             _crv = _crv.sub(_keepCRV);
296             
297             
298             IERC20(crv).safeApprove(uni, 0);
299             IERC20(crv).safeApprove(uni, _crv);
300             
301             address[] memory path = new address[](3);
302             path[0] = crv;
303             path[1] = weth;
304             path[2] = dai;
305             
306             Uni(uni).swapExactTokensForTokens(_crv, uint(0), path, address(this), now.add(1800));
307         }
308         uint _dai = IERC20(dai).balanceOf(address(this));
309         if (_dai > 0) {
310             IERC20(dai).safeApprove(ydai, 0);
311             IERC20(dai).safeApprove(ydai, _dai);
312             yERC20(ydai).deposit(_dai);
313         }
314         uint _ydai = IERC20(ydai).balanceOf(address(this));
315         if (_ydai > 0) {
316             IERC20(ydai).safeApprove(curve, 0);
317             IERC20(ydai).safeApprove(curve, _ydai);
318             ICurveFi(curve).add_liquidity([_ydai,0,0,0],0);
319         }
320         uint _want = IERC20(want).balanceOf(address(this));
321         if (_want > 0) {
322             uint _fee = _want.mul(performanceFee).div(performanceMax);
323             IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);
324             deposit();
325         }
326     }
327     
328     function _withdrawSome(uint256 _amount) internal returns (uint) {
329         Gauge(pool).withdraw(_amount);
330         return _amount;
331     }
332     
333     function balanceOfWant() public view returns (uint) {
334         return IERC20(want).balanceOf(address(this));
335     }
336     
337     function balanceOfPool() public view returns (uint) {
338         return Gauge(pool).balanceOf(address(this));
339     }
340     
341     function balanceOf() public view returns (uint) {
342         return balanceOfWant()
343                .add(balanceOfPool());
344     }
345     
346     function setGovernance(address _governance) external {
347         require(msg.sender == governance, "!governance");
348         governance = _governance;
349     }
350     
351     function setController(address _controller) external {
352         require(msg.sender == governance, "!governance");
353         controller = _controller;
354     }
355 }