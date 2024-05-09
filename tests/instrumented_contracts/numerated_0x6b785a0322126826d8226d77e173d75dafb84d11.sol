1 /*  
2     SPDX-License-Identifier: MIT
3     A Bankteller Production
4     Bankroll Network
5     Copyright 2020
6 */
7 
8 /* 
9     Bankroll Vault Token (VLT) is the growth and store of value for the network on ETH. 
10     It is the first POL token (Proof of Liquidity) with verified liquidity that cannot be pulled by a central authority
11     Powered by Uniswap 
12     https://bankroll.network/vlt.html
13 */
14 //pragma solidity ^0.4.25;
15 
16 pragma solidity >=0.6.2;
17 
18 
19 interface IUniswapV2Router01 {
20     function factory() external pure returns (address);
21     function WETH() external pure returns (address);
22 
23     function addLiquidity(
24         address tokenA,
25         address tokenB,
26         uint amountADesired,
27         uint amountBDesired,
28         uint amountAMin,
29         uint amountBMin,
30         address to,
31         uint deadline
32     ) external returns (uint amountA, uint amountB, uint liquidity);
33     function addLiquidityETH(
34         address token,
35         uint amountTokenDesired,
36         uint amountTokenMin,
37         uint amountETHMin,
38         address to,
39         uint deadline
40     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41     function removeLiquidity(
42         address tokenA,
43         address tokenB,
44         uint liquidity,
45         uint amountAMin,
46         uint amountBMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountA, uint amountB);
50     function removeLiquidityETH(
51         address token,
52         uint liquidity,
53         uint amountTokenMin,
54         uint amountETHMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountToken, uint amountETH);
58     function removeLiquidityWithPermit(
59         address tokenA,
60         address tokenB,
61         uint liquidity,
62         uint amountAMin,
63         uint amountBMin,
64         address to,
65         uint deadline,
66         bool approveMax, uint8 v, bytes32 r, bytes32 s
67     ) external returns (uint amountA, uint amountB);
68     function removeLiquidityETHWithPermit(
69         address token,
70         uint liquidity,
71         uint amountTokenMin,
72         uint amountETHMin,
73         address to,
74         uint deadline,
75         bool approveMax, uint8 v, bytes32 r, bytes32 s
76     ) external returns (uint amountToken, uint amountETH);
77     function swapExactTokensForTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external returns (uint[] memory amounts);
84     function swapTokensForExactTokens(
85         uint amountOut,
86         uint amountInMax,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external returns (uint[] memory amounts);
91     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
92         external
93         payable
94         returns (uint[] memory amounts);
95     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
96         external
97         returns (uint[] memory amounts);
98     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
99         external
100         returns (uint[] memory amounts);
101     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
102         external
103         payable
104         returns (uint[] memory amounts);
105 
106     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
107     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
108     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
109     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
110     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
111 
112 }
113 
114 interface IUniswapV2Router02 is IUniswapV2Router01 {
115     function removeLiquidityETHSupportingFeeOnTransferTokens(
116         address token,
117         uint liquidity,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external returns (uint amountETH);
123     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
124         address token,
125         uint liquidity,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline,
130         bool approveMax, uint8 v, bytes32 r, bytes32 s
131     ) external returns (uint amountETH);
132 
133     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140     function swapExactETHForTokensSupportingFeeOnTransferTokens(
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external payable;
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 interface IERC20 {
156   function totalSupply() external view returns (uint256);
157   function balanceOf(address who) external view returns (uint256);
158   function allowance(address owner, address spender) external view returns (uint256);
159   function transfer(address to, uint256 value) external returns (bool);
160   function approve(address spender, uint256 value) external returns (bool);
161   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
162   function transferFrom(address from, address to, uint256 value) external returns (bool);
163 
164   event Transfer(address indexed from, address indexed to, uint256 value);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 interface ApproveAndCallFallBack {
169     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
170 }
171 
172 
173 contract VaultToken is IERC20 {
174   using SafeMath for uint256;
175 
176   mapping (address => uint256) private balances;
177   mapping (address => mapping (address => uint256)) private allowed;
178   string public constant name  = "Bankroll Vault";
179   string public constant symbol = "VLT";
180   uint8 public constant decimals = 18;
181   bool public isBootStrapped = false; 
182   
183   IUniswapV2Router02 public router;
184 
185   
186   address public owner = msg.sender;
187 
188   uint256 _totalSupply = 1800000 * (10 ** 18); // 1.8 million supply
189 
190   /**
191    * @dev Construct a new token linked to a Uniswap environment
192    * @param routerAddr Address of IUniswapV2Router
193    */
194   constructor(address routerAddr) public {
195       
196     router = IUniswapV2Router02(routerAddr);  
197   }
198   
199   /**
200    * @dev Bootstrap the supply distribution and fund the UniswapV2 liquidity pool
201    */
202   function bootstrap() external payable returns (bool){
203       
204       
205       require(isBootStrapped == false, 'Require unintialized token');
206       require(msg.sender == owner, 'Require ownership');
207       require(msg.value >= 1 ether, 'Require atleast 1 ETH');
208       
209       //Distribute tokens 
210       // 82% for OTC presale buyers; 7% market making; 11% locked liquidity forever
211       address token = address(this);
212       balances[owner] = _totalSupply * 89 / 100;
213       
214       balances[token] = _totalSupply.sub(balances[owner]);
215       emit Transfer(address(0), owner, balances[owner]);
216       emit Transfer(address(0), token, balances[token]);
217       
218       //Approve UniswapV2 Router for transfer
219       allowed[address(this)][address(router)] = balances[address(this)];
220       
221       //Create and fund Uniswap V2 liquidity pool
222       router.addLiquidityETH.value(msg.value)(
223         token,
224         balances[token],
225         1,
226         1,
227         token,
228         now + 1 hours
229         );
230       
231       //done
232       isBootStrapped = true;
233       
234       return isBootStrapped;
235       
236   }
237 
238   function totalSupply() public override view returns (uint256) {
239     return _totalSupply;
240   }
241 
242   function balanceOf(address player) public override view returns (uint256) {
243     return balances[player];
244   }
245 
246   function allowance(address player, address spender) public override view returns (uint256) {
247     return allowed[player][spender];
248   }
249 
250 
251   function transfer(address to, uint256 value) override public returns (bool) {
252     require(value <= balances[msg.sender]);
253     require(to != address(0));
254 
255     balances[msg.sender] = balances[msg.sender].sub(value);
256     balances[to] = balances[to].add(value);
257 
258     emit Transfer(msg.sender, to, value);
259     return true;
260   }
261 
262   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
263     for (uint256 i = 0; i < receivers.length; i++) {
264       transfer(receivers[i], amounts[i]);
265     }
266   }
267 
268   function approve(address spender, uint256 value) override public returns (bool) {
269     require(spender != address(0));
270     allowed[msg.sender][spender] = value;
271     emit Approval(msg.sender, spender, value);
272     return true;
273   }
274 
275   function approveAndCall(address spender, uint256 tokens, bytes calldata data) override external returns (bool) {
276         allowed[msg.sender][spender] = tokens;
277         emit Approval(msg.sender, spender, tokens);
278         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
279         return true;
280     }
281 
282   function transferFrom(address from, address to, uint256 value) override public returns (bool) {
283     require(value <= balances[from]);
284     require(value <= allowed[from][msg.sender]);
285     require(to != address(0));
286     
287     balances[from] = balances[from].sub(value);
288     balances[to] = balances[to].add(value);
289     
290     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
291     
292     emit Transfer(from, to, value);
293     return true;
294   }
295 
296   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
297     require(spender != address(0));
298     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
299     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
304     require(spender != address(0));
305     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
306     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
307     return true;
308   }
309 
310   function burn(uint256 amount) external {
311     require(amount != 0);
312     require(amount <= balances[msg.sender]);
313     _totalSupply = _totalSupply.sub(amount);
314     balances[msg.sender] = balances[msg.sender].sub(amount);
315     emit Transfer(msg.sender, address(0), amount);
316   }
317 
318 }
319 
320 
321 
322 library SafeMath {
323   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324     if (a == 0) {
325       return 0;
326     }
327     uint256 c = a * b;
328     require(c / a == b);
329     return c;
330   }
331 
332   function div(uint256 a, uint256 b) internal pure returns (uint256) {
333     uint256 c = a / b;
334     return c;
335   }
336 
337   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
338     require(b <= a);
339     return a - b;
340   }
341 
342   function add(uint256 a, uint256 b) internal pure returns (uint256) {
343     uint256 c = a + b;
344     require(c >= a);
345     return c;
346   }
347 
348   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
349     uint256 c = add(a,m);
350     uint256 d = sub(c,1);
351     return mul(div(d,m),m);
352   }
353 }