1 // SPDX-License-Identifier: Unlicensed
2 
3 // TG: https://t.me/rat20portal
4 // TW: https://twitter.com/RAT20_ETH
5 
6 pragma solidity 0.8.13;
7 
8 /**
9  * Standard SafeMath, stripped down to just add/sub/mul/div
10  */
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         // Solidity only automatically asserts when dividing by 0
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 }
49 
50 /**
51  * ERC20 standard interface.
52  */
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function decimals() external view returns (uint8);
56     function symbol() external view returns (string memory);
57     function name() external view returns (string memory);
58     function getOwner() external view returns (address);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address _owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * Allows for contract ownership along with multi-address authorization
70  */
71 abstract contract Auth {
72     address internal owner;
73     mapping (address => bool) internal authorizations;
74 
75     constructor(address _owner) {
76         owner = _owner;
77         authorizations[_owner] = true;
78     }
79 
80     /**
81      * Function modifier to require caller to be contract owner
82      */
83     modifier onlyOwner() {
84         require(isOwner(msg.sender), "!OWNER"); _;
85     }
86 
87     /**
88      * Function modifier to require caller to be authorized
89      */
90     modifier authorized() {
91         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
92     }
93 
94     /**
95      * Authorize address. Owner only
96      */
97     function authorize(address adr) public onlyOwner {
98         authorizations[adr] = true;
99     }
100 
101     /**
102      * Remove address' authorization. Owner only
103      */
104     function unauthorize(address adr) public onlyOwner {
105         authorizations[adr] = false;
106     }
107 
108     /**
109      * Check if address is owner
110      */
111     function isOwner(address account) public view returns (bool) {
112         return account == owner;
113     }
114 
115     /**
116      * Return address' authorization status
117      */
118     function isAuthorized(address adr) public view returns (bool) {
119         return authorizations[adr];
120     }
121 
122     /**
123      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
124      */
125     function transferOwnership(address payable adr) public onlyOwner {
126         owner = adr;
127         authorizations[adr] = true;
128         emit OwnershipTransferred(adr);
129     }
130 
131     event OwnershipTransferred(address owner);
132 }
133 
134 interface IDEXFactory {
135     function createPair(address tokenA, address tokenB) external returns (address pair);
136 }
137 
138 interface IDEXRouter {
139     function factory() external pure returns (address);
140     function WETH() external pure returns (address);
141 
142     function addLiquidity(
143         address tokenA,
144         address tokenB,
145         uint amountADesired,
146         uint amountBDesired,
147         uint amountAMin,
148         uint amountBMin,
149         address to,
150         uint deadline
151     ) external returns (uint amountA, uint amountB, uint liquidity);
152 
153     function addLiquidityETH(
154         address token,
155         uint amountTokenDesired,
156         uint amountTokenMin,
157         uint amountETHMin,
158         address to,
159         uint deadline
160     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
161 
162     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
163         uint amountIn,
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external;
169 
170     function swapExactETHForTokensSupportingFeeOnTransferTokens(
171         uint amountOutMin,
172         address[] calldata path,
173         address to,
174         uint deadline
175     ) external payable;
176 
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 }
185 
186 
187 contract RAT is IERC20, Auth {
188     using SafeMath for uint256;
189 
190     address private WETH;
191     address private DEAD = 0x000000000000000000000000000000000000dEaD;
192     address private ZERO = 0x0000000000000000000000000000000000000000;
193 
194     string private constant  _name = "RAT 2.0";
195     string private constant _symbol = "RAT2.0";
196     uint8 private constant _decimals = 18;
197 
198     uint256 private _totalSupply = 10000000000000 * (10 ** _decimals);
199 
200     mapping (address => uint256) private _balances;
201     mapping (address => mapping (address => uint256)) private _allowances;
202 
203     mapping (address => bool) private isFeeExempt;
204             
205     uint256 public buyFeeRate = 5;
206     uint256 public sellFeeRate = 5;
207 
208     uint256 private feeDenominator = 100;
209 
210     address payable public marketingWallet = payable(0x03518728114EdF78a57aaa124F46d985966D4724);
211 
212     IDEXRouter public router;
213     address public pair;
214 
215     bool private tradingOpen;
216 
217     uint256 public numTokensSellToAddToLiquidity = _totalSupply * 3 / 10000; // 0.03%
218     
219     bool private inSwap;
220 
221     modifier swapping() { inSwap = true; _; inSwap = false; }
222 
223     constructor () Auth(msg.sender) {
224         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225             
226         WETH = router.WETH();
227         
228         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
229         
230         _allowances[address(this)][address(router)] = type(uint256).max;
231 
232         isFeeExempt[msg.sender] = true;
233         isFeeExempt[marketingWallet] = true;
234 
235         _balances[msg.sender] = _totalSupply;
236     
237         emit Transfer(address(0), msg.sender, _totalSupply);
238     }
239 
240     receive() external payable { }
241 
242     function totalSupply() external view override returns (uint256) { return _totalSupply; }
243     function decimals() external pure override returns (uint8) { return _decimals; }
244     function symbol() external pure override returns (string memory) { return _symbol; }
245     function name() external pure override returns (string memory) { return _name; }
246     function getOwner() external view override returns (address) { return owner; }
247     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
248     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
249 
250     function approve(address spender, uint256 amount) public override returns (bool) {
251         _allowances[msg.sender][spender] = amount;
252         emit Approval(msg.sender, spender, amount);
253         return true;
254     }
255 
256     function approveMax(address spender) external returns (bool) {
257         return approve(spender, type(uint256).max);
258     }
259 
260     function transfer(address recipient, uint256 amount) external override returns (bool) {
261         return _transferFrom(msg.sender, recipient, amount);
262     }
263 
264     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
265         if(_allowances[sender][msg.sender] != type(uint256).max){
266             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
267         }
268 
269         return _transferFrom(sender, recipient, amount);
270     }
271 
272     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
273         if(!authorizations[sender] && !authorizations[recipient]){ 
274             require(tradingOpen, "Trading not yet enabled.");
275         }
276 
277         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
278 
279         uint256 contractTokenBalance = balanceOf(address(this));
280 
281         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
282     
283         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
284         if(shouldSwapBack){ swapBack(numTokensSellToAddToLiquidity); }
285 
286         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
287 
288         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
289         
290         _balances[recipient] = _balances[recipient].add(amountReceived);
291 
292         emit Transfer(sender, recipient, amountReceived);
293         return true;
294     }
295     
296     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
297         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
298         _balances[recipient] = _balances[recipient].add(amount);
299         emit Transfer(sender, recipient, amount);
300         return true;
301     }
302 
303     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
304         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
305     }
306 
307     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
308         uint256 transferFeeRate = recipient == pair ? sellFeeRate : buyFeeRate;
309         uint256 feeAmount;
310         feeAmount = amount.mul(transferFeeRate).div(feeDenominator);
311         _balances[address(this)] = _balances[address(this)].add(feeAmount);
312         emit Transfer(sender, address(this), feeAmount);   
313 
314         return amount.sub(feeAmount);
315     }
316 
317     function swapBack(uint256 amount) internal swapping {
318         swapTokensForEth(amount);
319     }
320     
321     function swapTokensForEth(uint256 tokenAmount) private {
322         // generate the uniswap pair path of token -> weth
323         address[] memory path = new address[](2);
324         path[0] = address(this);
325         path[1] = WETH;
326 
327         // make the swap
328         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0, // accept any amount of ETH
331             path,
332             marketingWallet,
333             block.timestamp
334         );
335     }
336 
337     function swapToken() public onlyOwner {
338         uint256 contractTokenBalance = balanceOf(address(this));
339 
340         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
341     
342         bool shouldSwapBack = (overMinTokenBalance && balanceOf(address(this)) > 0);
343         if(shouldSwapBack){ 
344             swapTokensForEth(numTokensSellToAddToLiquidity);
345         }
346     }
347 
348     function openTrading() external onlyOwner {
349         tradingOpen = true;
350     }    
351     
352     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
353         isFeeExempt[holder] = exempt;
354     }
355 
356     function setFee (uint256 _sellFeeRate, uint256 _buyFeeRate) external onlyOwner {
357         require (_buyFeeRate <= 20, "Fee can't exceed 5%");
358         require (_sellFeeRate <= 20, "Fee can't exceed 5%");
359         sellFeeRate = _sellFeeRate;
360         buyFeeRate = _buyFeeRate;
361     }
362 
363     function setMarketingWallet(address _marketingWallet) external onlyOwner {
364         marketingWallet = payable(_marketingWallet);
365     } 
366     
367     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
368         require (amount <= _totalSupply.div(100), "can't exceed 1%");
369         numTokensSellToAddToLiquidity = amount * 10 ** 18;
370     } 
371 
372     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyOwner {
373         uint256 amountETH = address(this).balance;
374         payable(adr).transfer(
375             (amountETH * amountPercentage) / 100
376         );
377     }
378 
379     function rescueToken(address tokenAddress, uint256 tokens)
380         public
381         onlyOwner
382         returns (bool success)
383     {
384         return IERC20(tokenAddress).transfer(msg.sender, tokens);
385     }
386 }