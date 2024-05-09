1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4  *  Twitter: https://twitter.com/azukipepe
5  */
6 
7 pragma solidity 0.8.13;
8 
9 /**
10  * Standard SafeMath, stripped down to just add/sub/mul/div
11  */
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 }
50 
51 /**
52  * ERC20 standard interface.
53  */
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 /**
70  * Allows for contract ownership along with multi-address authorization
71  */
72 abstract contract Auth {
73     address internal owner;
74     mapping (address => bool) internal authorizations;
75 
76     constructor(address _owner) {
77         owner = _owner;
78         authorizations[_owner] = true;
79     }
80 
81     /**
82      * Function modifier to require caller to be contract owner
83      */
84     modifier onlyOwner() {
85         require(isOwner(msg.sender), "!OWNER"); _;
86     }
87 
88     /**
89      * Function modifier to require caller to be authorized
90      */
91     modifier authorized() {
92         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
93     }
94 
95     /**
96      * Authorize address. Owner only
97      */
98     function authorize(address adr) public onlyOwner {
99         authorizations[adr] = true;
100     }
101 
102     /**
103      * Remove address' authorization. Owner only
104      */
105     function unauthorize(address adr) public onlyOwner {
106         authorizations[adr] = false;
107     }
108 
109     /**
110      * Check if address is owner
111      */
112     function isOwner(address account) public view returns (bool) {
113         return account == owner;
114     }
115 
116     /**
117      * Return address' authorization status
118      */
119     function isAuthorized(address adr) public view returns (bool) {
120         return authorizations[adr];
121     }
122 
123     /**
124      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
125      */
126     function transferOwnership(address payable adr) public onlyOwner {
127         owner = adr;
128         authorizations[adr] = true;
129         emit OwnershipTransferred(adr);
130     }
131 
132     event OwnershipTransferred(address owner);
133 }
134 
135 interface IDEXFactory {
136     function createPair(address tokenA, address tokenB) external returns (address pair);
137 }
138 
139 interface IDEXRouter {
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142 
143     function addLiquidity(
144         address tokenA,
145         address tokenB,
146         uint amountADesired,
147         uint amountBDesired,
148         uint amountAMin,
149         uint amountBMin,
150         address to,
151         uint deadline
152     ) external returns (uint amountA, uint amountB, uint liquidity);
153 
154     function addLiquidityETH(
155         address token,
156         uint amountTokenDesired,
157         uint amountTokenMin,
158         uint amountETHMin,
159         address to,
160         uint deadline
161     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
162 
163     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 
171     function swapExactETHForTokensSupportingFeeOnTransferTokens(
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external payable;
177 
178     function swapExactTokensForETHSupportingFeeOnTransferTokens(
179         uint amountIn,
180         uint amountOutMin,
181         address[] calldata path,
182         address to,
183         uint deadline
184     ) external;
185 }
186 
187 
188 contract AZUKIPEPE is IERC20, Auth {
189     using SafeMath for uint256;
190 
191     address private WETH;
192     address private DEAD = 0x000000000000000000000000000000000000dEaD;
193     address private ZERO = 0x0000000000000000000000000000000000000000;
194 
195     string private constant  _name = "AZUKI PEPE";
196     string private constant _symbol = "AZUKIPEPE";
197     uint8 private constant _decimals = 18;
198 
199     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
200 
201     mapping (address => uint256) private _balances;
202     mapping (address => mapping (address => uint256)) private _allowances;
203 
204     mapping (address => bool) private isFeeExempt;
205             
206     uint256 public buyFeeRate = 5;
207     uint256 public sellFeeRate = 5;
208 
209     uint256 private feeDenominator = 100;
210 
211     address payable public marketingWallet = payable(0xb8F6524fbc4D6c0f41B4D5D2b204a79570ec07Df);
212 
213     IDEXRouter public router;
214     address public pair;
215 
216     bool private tradingOpen;
217 
218     uint256 public numTokensSellToAddToLiquidity = _totalSupply * 3 / 10000; // 0.03%
219     
220     bool private inSwap;
221 
222     modifier swapping() { inSwap = true; _; inSwap = false; }
223 
224     constructor () Auth(msg.sender) {
225         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226             
227         WETH = router.WETH();
228         
229         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
230         
231         _allowances[address(this)][address(router)] = type(uint256).max;
232 
233         isFeeExempt[msg.sender] = true;
234         isFeeExempt[marketingWallet] = true;
235 
236         _balances[msg.sender] = _totalSupply;
237     
238         emit Transfer(address(0), msg.sender, _totalSupply);
239     }
240 
241     receive() external payable { }
242 
243     function totalSupply() external view override returns (uint256) { return _totalSupply; }
244     function decimals() external pure override returns (uint8) { return _decimals; }
245     function symbol() external pure override returns (string memory) { return _symbol; }
246     function name() external pure override returns (string memory) { return _name; }
247     function getOwner() external view override returns (address) { return owner; }
248     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
249     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
250 
251     function approve(address spender, uint256 amount) public override returns (bool) {
252         _allowances[msg.sender][spender] = amount;
253         emit Approval(msg.sender, spender, amount);
254         return true;
255     }
256 
257     function approveMax(address spender) external returns (bool) {
258         return approve(spender, type(uint256).max);
259     }
260 
261     function transfer(address recipient, uint256 amount) external override returns (bool) {
262         return _transferFrom(msg.sender, recipient, amount);
263     }
264 
265     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
266         if(_allowances[sender][msg.sender] != type(uint256).max){
267             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
268         }
269 
270         return _transferFrom(sender, recipient, amount);
271     }
272 
273     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
274         if(!authorizations[sender] && !authorizations[recipient]){ 
275             require(tradingOpen, "Trading not yet enabled.");
276         }
277 
278         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
279 
280         uint256 contractTokenBalance = balanceOf(address(this));
281 
282         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
283     
284         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
285         if(shouldSwapBack){ swapBack(numTokensSellToAddToLiquidity); }
286 
287         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
288 
289         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
290         
291         _balances[recipient] = _balances[recipient].add(amountReceived);
292 
293         emit Transfer(sender, recipient, amountReceived);
294         return true;
295     }
296     
297     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
298         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
299         _balances[recipient] = _balances[recipient].add(amount);
300         emit Transfer(sender, recipient, amount);
301         return true;
302     }
303 
304     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
305         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
306     }
307 
308     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
309         uint256 transferFeeRate = recipient == pair ? sellFeeRate : buyFeeRate;
310         uint256 feeAmount;
311         feeAmount = amount.mul(transferFeeRate).div(feeDenominator);
312         _balances[address(this)] = _balances[address(this)].add(feeAmount);
313         emit Transfer(sender, address(this), feeAmount);   
314 
315         return amount.sub(feeAmount);
316     }
317 
318     function swapBack(uint256 amount) internal swapping {
319         swapTokensForEth(amount);
320     }
321     
322     function swapTokensForEth(uint256 tokenAmount) private {
323         // generate the uniswap pair path of token -> weth
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = WETH;
327 
328         // make the swap
329         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
330             tokenAmount,
331             0, // accept any amount of ETH
332             path,
333             marketingWallet,
334             block.timestamp
335         );
336     }
337 
338     function swapTokenManual() public onlyOwner {
339         uint256 contractTokenBalance = balanceOf(address(this));
340 
341         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
342     
343         bool shouldSwapBack = (overMinTokenBalance && balanceOf(address(this)) > 0);
344         if(shouldSwapBack){ 
345             swapTokensForEth(numTokensSellToAddToLiquidity);
346         }
347     }
348 
349     function openTrading() external onlyOwner {
350         tradingOpen = true;
351     }    
352     
353     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
354         isFeeExempt[holder] = exempt;
355     }
356 
357     function setFee (uint256 _sellFeeRate, uint256 _buyFeeRate) external onlyOwner {
358         require (_buyFeeRate <= 5, "Fee can't exceed 5%");
359         require (_sellFeeRate <= 5, "Fee can't exceed 5%");
360         sellFeeRate = _sellFeeRate;
361         buyFeeRate = _buyFeeRate;
362     }
363 
364     function setMarketingWallet(address _marketingWallet) external onlyOwner {
365         marketingWallet = payable(_marketingWallet);
366     } 
367     
368     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
369         require (amount <= _totalSupply.div(100), "can't exceed 1%");
370         numTokensSellToAddToLiquidity = amount * 10 ** 18;
371     } 
372 
373     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyOwner {
374         uint256 amountETH = address(this).balance;
375         payable(adr).transfer(
376             (amountETH * amountPercentage) / 100
377         );
378     }
379 
380     function rescueToken(address tokenAddress, uint256 tokens)
381         public
382         onlyOwner
383         returns (bool success)
384     {
385         return IERC20(tokenAddress).transfer(msg.sender, tokens);
386     }
387 }