1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5     
6                    o~~~o
7                 __-|---|__
8               /~          ~\
9              |    //^\\//^\|
10            /~~\  ||  ~| |o|:~\
11           | |o   ||___|_|_||:|
12            \__.  /      o  \/'
13             |   (      ~~~  )
14    /~~~~\    `\  \         /
15   | |~~\ |     )  ~------~`\
16  /' |  | |   /     ____ /~~~)\
17 (_/'   | | |     /'    |    ( |
18        | | |     \    /   __)/ \
19        \  \ \      \/    /' \   `\  
20       ___           ___           ___           ___     
21      /\  \         /\  \         |\__\         /\  \    
22     /::\  \       /o:\  \        |:|  |       /::\  \   
23    /:/\:\  \     /:/\:\  \       |:|  |      /:/\:\  \  
24   /o:\~\:\  \   /::\~\:\  \      |:|__|__   /::\~\:\  \ 
25  /:/\:\ \:\__\ /:/\:\ \:\__\ ____/::o:\__\ /:/\:\ \o\__\
26  \/__\:\/:/  / \/__\:\/:/  / \::::/~~/~    \:\~\:\ \/__/
27       \::/  /       \::/  /   ~~|:|~~|      \:\ \:\__\  
28       /:/  /         \/__/      |:|  |       \:\ \/__/  
29      /:/  /                     |:|  |        \:\__\    
30      \/__/                       \|__|         \/__/
31 
32 
33 
34 Get ready for an interstellar journey like you’ve never experienced before!
35 
36 metaverse_of_metaverses
37 ---
38 https://apxe.io/
39 http://t.me/apxe_portal
40 https://twitter.com/apxeio
41 http://youtube.com/@apxeioeth/
42 http://instagram.com/apxe.io/
43 http://apxeio.medium.com
44 ---
45 New Planet New Apes!
46 
47 
48 
49 
50 
51 
52 */
53 
54 
55 
56 
57 
58 pragma solidity ^0.8.5;
59 library SafeMath {
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63         return c;
64     }
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71         return c;
72     }
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return div(a, b, "SafeMath: division by zero");
83     }
84     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b > 0, errorMessage);
86         uint256 c = a / b;
87         return c;
88     }
89 }
90 
91 interface ERC20 {
92     function totalSupply() external view returns (uint256);
93     function decimals() external view returns (uint8);
94     function symbol() external view returns (string memory);
95     function name() external view returns (string memory);
96     function getOwner() external view returns (address);
97     function balanceOf(address account) external view returns (uint256);
98     function transfer(address recipient, uint256 amount) external returns (bool);
99     function allowance(address _owner, address spender) external view returns (uint256);
100     function approve(address spender, uint256 amount) external returns (bool);
101     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 abstract contract Ownable {
107     address internal owner;
108     constructor(address _owner) {
109         owner = _owner;
110     }
111     modifier onlyOwner() {
112         require(isOwner(msg.sender), "!OWNER"); _;
113     }
114     function isOwner(address account) public view returns (bool) {
115         return account == owner;
116     }
117     function renounceOwnership() public onlyOwner {
118         owner = address(0);
119         emit OwnershipTransferred(address(0));
120     }  
121     event OwnershipTransferred(address owner);
122 }
123 
124 interface IDEXFactory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IDEXRouter {
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131     function addLiquidity(
132         address tokenA,
133         address tokenB,
134         uint amountADesired,
135         uint amountBDesired,
136         uint amountAMin,
137         uint amountBMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountA, uint amountB, uint liquidity);
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156     function swapExactETHForTokensSupportingFeeOnTransferTokens(
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external payable;
162     function swapExactTokensForETHSupportingFeeOnTransferTokens(
163         uint amountIn,
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external;
169 }
170 
171 contract APXE is ERC20, Ownable {
172     using SafeMath for uint256;
173     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
174     address DEAD = 0x000000000000000000000000000000000000dEaD;
175 
176     string constant _name = "APXE";
177     string constant _symbol = "APXE";
178     uint8 constant _decimals = 9;
179 
180     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
181     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
182 
183     mapping (address => uint256) _balances;
184     mapping (address => mapping (address => uint256)) _allowances;
185 
186     mapping (address => bool) isFeeExempt;
187     mapping (address => bool) isTxLimitExempt;
188 
189     uint256 liquidityFee = 1; 
190     uint256 marketingFee = 3;
191     uint256 totalFee = liquidityFee + marketingFee;
192     uint256 feeDenominator = 100;
193 
194     address public marketingFeeReceiver = 0xCb971165E67aC0589f10D340baa77F66A15f2DF5;
195 
196     IDEXRouter public router;
197     address public pair;
198 
199     bool public swapEnabled = true;
200     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
201     bool inSwap;
202     modifier swapping() { inSwap = true; _; inSwap = false; }
203 
204     constructor () Ownable(msg.sender) {
205         router = IDEXRouter(routerAdress);
206         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
207         _allowances[address(this)][address(router)] = type(uint256).max;
208 
209         address _owner = owner;
210         isFeeExempt[0xCb971165E67aC0589f10D340baa77F66A15f2DF5] = true;
211         isTxLimitExempt[_owner] = true;
212         isTxLimitExempt[0xCb971165E67aC0589f10D340baa77F66A15f2DF5] = true;
213         isTxLimitExempt[DEAD] = true;
214 
215         _balances[_owner] = _totalSupply;
216         emit Transfer(address(0), _owner, _totalSupply);
217     }
218 
219     receive() external payable { }
220 
221     function totalSupply() external view override returns (uint256) { return _totalSupply; }
222     function decimals() external pure override returns (uint8) { return _decimals; }
223     function symbol() external pure override returns (string memory) { return _symbol; }
224     function name() external pure override returns (string memory) { return _name; }
225     function getOwner() external view override returns (address) { return owner; }
226     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
227     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
228 
229     function approve(address spender, uint256 amount) public override returns (bool) {
230         _allowances[msg.sender][spender] = amount;
231         emit Approval(msg.sender, spender, amount);
232         return true;
233     }
234 
235     function approveMax(address spender) external returns (bool) {
236         return approve(spender, type(uint256).max);
237     }
238 
239     function transfer(address recipient, uint256 amount) external override returns (bool) {
240         return _transferFrom(msg.sender, recipient, amount);
241     }
242 
243     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
244         if(_allowances[sender][msg.sender] != type(uint256).max){
245             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
246         }
247 
248         return _transferFrom(sender, recipient, amount);
249     }
250 
251     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
252         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
253         
254         if (recipient != pair && recipient != DEAD) {
255             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
256         }
257         
258         if(shouldSwapBack()){ swapBack(); } 
259 
260         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
261 
262         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
263         _balances[recipient] = _balances[recipient].add(amountReceived);
264 
265         emit Transfer(sender, recipient, amountReceived);
266         return true;
267     }
268     
269     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
270         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
271         _balances[recipient] = _balances[recipient].add(amount);
272         emit Transfer(sender, recipient, amount);
273         return true;
274     }
275 
276     function shouldTakeFee(address sender) internal view returns (bool) {
277         return !isFeeExempt[sender];
278     }
279 
280     function takeFee(address sender, uint256 amount) internal returns (uint256) {
281         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
282         _balances[address(this)] = _balances[address(this)].add(feeAmount);
283         emit Transfer(sender, address(this), feeAmount);
284         return amount.sub(feeAmount);
285     }
286 
287     function shouldSwapBack() internal view returns (bool) {
288         return msg.sender != pair
289         && !inSwap
290         && swapEnabled
291         && _balances[address(this)] >= swapThreshold;
292     }
293 
294     function swapBack() internal swapping {
295         uint256 contractTokenBalance = swapThreshold;
296         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
297         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
298 
299         address[] memory path = new address[](2);
300         path[0] = address(this);
301         path[1] = router.WETH();
302 
303         uint256 balanceBefore = address(this).balance;
304 
305         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
306             amountToSwap,
307             0,
308             path,
309             address(this),
310             block.timestamp
311         );
312         uint256 amountETH = address(this).balance.sub(balanceBefore);
313         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
314         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
315         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
316 
317 
318         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
319         require(MarketingSuccess, "receiver rejected ETH transfer");
320 
321         if(amountToLiquify > 0){
322             router.addLiquidityETH{value: amountETHLiquidity}(
323                 address(this),
324                 amountToLiquify,
325                 0,
326                 0,
327                 0xCb971165E67aC0589f10D340baa77F66A15f2DF5,
328                 block.timestamp
329             );
330             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
331         }
332     }
333 
334     function buyTokens(uint256 amount, address to) internal swapping {
335         address[] memory path = new address[](2);
336         path[0] = router.WETH();
337         path[1] = address(this);
338 
339         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
340             0,
341             path,
342             to,
343             block.timestamp
344         );
345     }
346 
347     function clearStuckBalance() external {
348         payable(marketingFeeReceiver).transfer(address(this).balance);
349     }
350 
351     function setWalletLimit(uint256 amountPercent) external onlyOwner {
352         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
353     }
354 
355     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
356          liquidityFee = _liquidityFee; 
357          marketingFee = _marketingFee;
358          totalFee = liquidityFee + marketingFee;
359     }    
360     
361     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
362 }