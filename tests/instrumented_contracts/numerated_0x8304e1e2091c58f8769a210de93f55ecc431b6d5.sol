1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7         return c;
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13 
14     function sub(
15         uint256 a,
16         uint256 b,
17         string memory errorMessage
18     ) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(
38         uint256 a,
39         uint256 b,
40         string memory errorMessage
41     ) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46 }
47 
48 interface ERC20 {
49     function totalSupply() external view returns (uint256);
50 
51     function decimals() external view returns (uint8);
52 
53     function symbol() external view returns (string memory);
54 
55     function name() external view returns (string memory);
56 
57     function getOwner() external view returns (address);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address recipient, uint256 amount)
62         external
63         returns (bool);
64 
65     function allowance(address _owner, address spender)
66         external
67         view
68         returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     event Approval(
80         address indexed owner,
81         address indexed spender,
82         uint256 value
83     );
84 }
85 
86 abstract contract Ownable {
87     address internal owner;
88 
89     constructor(address _owner) {
90         owner = _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(isOwner(msg.sender), "!OWNER");
95         _;
96     }
97 
98     function isOwner(address account) public view returns (bool) {
99         return account == owner;
100     }
101 
102     function renounceOwnership() public onlyOwner {
103         owner = address(0);
104         emit OwnershipTransferred(address(0));
105     }
106 
107     event OwnershipTransferred(address owner);
108 }
109 
110 interface IDEXFactory {
111     function createPair(address tokenA, address tokenB)
112         external
113         returns (address pair);
114 }
115 
116 interface IDEXRouter {
117     function factory() external pure returns (address);
118 
119     function WETH() external pure returns (address);
120 
121     function addLiquidity(
122         address tokenA,
123         address tokenB,
124         uint256 amountADesired,
125         uint256 amountBDesired,
126         uint256 amountAMin,
127         uint256 amountBMin,
128         address to,
129         uint256 deadline
130     )
131         external
132         returns (
133             uint256 amountA,
134             uint256 amountB,
135             uint256 liquidity
136         );
137 
138     function addLiquidityETH(
139         address token,
140         uint256 amountTokenDesired,
141         uint256 amountTokenMin,
142         uint256 amountETHMin,
143         address to,
144         uint256 deadline
145     )
146         external
147         payable
148         returns (
149             uint256 amountToken,
150             uint256 amountETH,
151             uint256 liquidity
152         );
153 
154     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
155         uint256 amountIn,
156         uint256 amountOutMin,
157         address[] calldata path,
158         address to,
159         uint256 deadline
160     ) external;
161 
162     function swapExactETHForTokensSupportingFeeOnTransferTokens(
163         uint256 amountOutMin,
164         address[] calldata path,
165         address to,
166         uint256 deadline
167     ) external payable;
168 
169     function swapExactTokensForETHSupportingFeeOnTransferTokens(
170         uint256 amountIn,
171         uint256 amountOutMin,
172         address[] calldata path,
173         address to,
174         uint256 deadline
175     ) external;
176 }
177 contract Omega is ERC20, Ownable {
178     using SafeMath for uint256;
179     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
180     address DEAD = 0x000000000000000000000000000000000000dEaD;
181 
182     string constant _name = "OMEGA";
183     string constant _symbol = unicode"Ω";
184     uint8 constant _decimals = 9;
185     uint256 _totalSupply = 1_000_000_000 * (10**_decimals);
186     uint256 public _maxWalletAmount = 50_000_000 * (10**_decimals);
187     mapping(address => uint256) _balances;
188     mapping(address => mapping(address => uint256)) _allowances;
189     mapping(address => bool) isFeeExempt;
190     mapping(address => bool) isTxLimitExempt;
191     uint256 OmegaFee = 2;
192     address public OmegaTeam = msg.sender;
193     IDEXRouter public router;
194     address public pair;
195     bool public swapEnabled = true;
196     uint256 public swapThreshold = (_totalSupply / 10000) * 50;
197     bool inSwap;
198     modifier swapping() {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203 
204     constructor() Ownable(msg.sender) {
205         router = IDEXRouter(routerAdress);
206         pair = IDEXFactory(router.factory()).createPair(
207             router.WETH(),
208             address(this)
209         );
210         _allowances[address(this)][address(router)] = type(uint256).max;
211         address _owner = owner;
212         isFeeExempt[_owner] = true;
213         isTxLimitExempt[_owner] = true;
214         _balances[_owner] = _totalSupply;
215         emit Transfer(address(0), _owner, _totalSupply);
216     }
217 
218     receive() external payable {}
219 
220     function totalSupply() external view override returns (uint256) {
221         return _totalSupply;
222     }
223 
224     function decimals() external pure override returns (uint8) {
225         return _decimals;
226     }
227 
228     function symbol() external pure override returns (string memory) {
229         return _symbol;
230     }
231 
232     function name() external pure override returns (string memory) {
233         return _name;
234     }
235 
236     function getOwner() external view override returns (address) {
237         return owner;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return _balances[account];
242     }
243 
244     function allowance(address holder, address spender)
245         external
246         view
247         override
248         returns (uint256)
249     {
250         return _allowances[holder][spender];
251     }
252 
253     function approve(address spender, uint256 amount)
254         public
255         override
256         returns (bool)
257     {
258         _allowances[msg.sender][spender] = amount;
259         emit Approval(msg.sender, spender, amount);
260         return true;
261     }
262 
263     function transfer(address recipient, uint256 amount)
264         external
265         override
266         returns (bool)
267     {
268         return _transferFrom(msg.sender, recipient, amount);
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) external override returns (bool) {
276         if (_allowances[sender][msg.sender] != type(uint256).max) {
277             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
278                 .sub(amount, "Insufficient Allowance");
279         }
280 
281         return _transferFrom(sender, recipient, amount);
282     }
283 
284     function _transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) internal returns (bool) {
289         if (inSwap) {
290             return _basicTransfer(sender, recipient, amount);
291         }
292 
293         if (recipient != pair && recipient != DEAD) {
294             require(
295                 isTxLimitExempt[recipient] ||
296                     _balances[recipient] + amount <= _maxWalletAmount,
297                 "Transfer amount exceeds the bag size."
298             );
299         }
300 
301         if (shouldSwapBack()) {
302             swapBack();
303         }
304 
305         _balances[sender] = _balances[sender].sub(
306             amount,
307             "Insufficient Balance"
308         );
309 
310         uint256 amountReceived = shouldTakeFee(sender)
311             ? takeFee(sender, amount)
312             : amount;
313         _balances[recipient] = _balances[recipient].add(amountReceived);
314 
315         emit Transfer(sender, recipient, amountReceived);
316         return true;
317     }
318 
319     function _basicTransfer(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) internal returns (bool) {
324         _balances[sender] = _balances[sender].sub(
325             amount,
326             "Insufficient Balance"
327         );
328         _balances[recipient] = _balances[recipient].add(amount);
329         emit Transfer(sender, recipient, amount);
330         return true;
331     }
332 
333     function shouldTakeFee(address sender) internal view returns (bool) {
334         return !isFeeExempt[sender];
335     }
336 
337     function takeFee(address sender, uint256 amount)
338         internal
339         returns (uint256)
340     {
341         uint256 feeAmount = amount.mul(OmegaFee).div(100);
342         _balances[address(this)] = _balances[address(this)].add(feeAmount);
343         emit Transfer(sender, address(this), feeAmount);
344         return amount.sub(feeAmount);
345     }
346 
347     function shouldSwapBack() internal view returns (bool) {
348         return
349             msg.sender != pair &&
350             !inSwap &&
351             swapEnabled &&
352             _balances[address(this)] >= swapThreshold;
353     }
354 
355     function swapBack() internal swapping {
356         uint256 contractTokenBalance = swapThreshold;
357         uint256 amountToSwap = contractTokenBalance;
358 
359         address[] memory path = new address[](2);
360         path[0] = address(this);
361         path[1] = router.WETH();
362 
363         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
364             amountToSwap,
365             0,
366             path,
367             address(this),
368             block.timestamp
369         );
370 
371         uint256 amountETHMarketing = address(this).balance;
372 
373         (
374             bool MarketingSuccess, /* bytes memory data */
375 
376         ) = payable(OmegaTeam).call{value: amountETHMarketing, gas: 30000}(
377                 ""
378             );
379         require(MarketingSuccess, "receiver rejected ETH transfer");
380     }
381 }