1 /*
2 
3 Telegram: https://t.me/RevivalDefiEntry
4 Twitter : https://twitter.com/RevDeFiThomas
5 Web     : https://RevivalDeFi.io
6                                                                                                                                                                                                                                              
7 */
8 
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.5;
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40         return c;
41     }
42 }
43 
44 interface ERC20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function getOwner() external view returns (address);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address _owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 abstract contract Ownable {
60     address internal owner;
61     constructor(address _owner) {
62         owner = _owner;
63     }
64     modifier onlyOwner() {
65         require(isOwner(msg.sender), "!OWNER"); _;
66     }
67     function isOwner(address account) public view returns (bool) {
68         return account == owner;
69     }
70     function renounceOwnership() public onlyOwner {
71         owner = address(0);
72         emit OwnershipTransferred(address(0));
73     }  
74     event OwnershipTransferred(address owner);
75 }
76 
77 interface IDEXFactory {
78     function createPair(address tokenA, address tokenB) external returns (address pair);
79 }
80 
81 interface IDEXRouter {
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external payable;
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122 }
123 
124 contract RevivalDeFi is ERC20, Ownable {
125     using SafeMath for uint256;
126     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
127     address public DEAD = 0x000000000000000000000000000000000000dEaD;
128     address public Dapp1 = 0x000000000000000000000000000000000000dEaD;
129     address public Dapp2 = 0x000000000000000000000000000000000000dEaD;
130     address public Dapp3 = 0x000000000000000000000000000000000000dEaD;
131     address public Dapp4 = 0x000000000000000000000000000000000000dEaD;
132 
133     string constant _name = "RevivalDeFi";
134     string constant _symbol = "RevDeFi";
135     uint8 constant _decimals = 18;
136 
137     uint256 public _totalSupply = 1000000000 * (10 ** _decimals);
138     uint256 public _maxWalletAmount = (_totalSupply * 15) / 1000;
139 
140     mapping (address => uint256) _balances;
141     mapping (address => mapping (address => uint256)) _allowances;
142 
143     mapping (address => bool) isFeeExempt;
144     mapping (address => bool) isTxLimitExempt;
145 
146     uint256 liquidityFee = 1; 
147     uint256 marketingFee = 4;
148     uint256 public totalFee = liquidityFee + marketingFee;
149     uint256 feeDenominator = 100;
150 
151     address internal marketingFeeReceiver = 0x36abe5B30da74d7151e4C76D2c181a9Ea923546B;
152 
153     IDEXRouter public router;
154     address public pair;
155 
156     bool public swapEnabled = true;
157     uint256 public swapThreshold = _totalSupply / 1000 * 2; // 0.2%
158     bool inSwap;
159     modifier swapping() { inSwap = true; _; inSwap = false; }
160 
161     event MarketingFeeReceiverUpdated(address indexed newWallet, address indexed oldWallet);
162     event Dapp1Updated(address indexed newWallet, address indexed oldWallet);
163     event Dapp2Updated(address indexed newWallet, address indexed oldWallet);
164     event Dapp3Updated(address indexed newWallet, address indexed oldWallet);
165     event Dapp4Updated(address indexed newWallet, address indexed oldWallet);
166 
167     constructor () Ownable(msg.sender) {
168         router = IDEXRouter(routerAdress);
169         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
170         _allowances[address(this)][address(router)] = type(uint256).max;
171 
172         address _owner = owner;
173         isFeeExempt[marketingFeeReceiver] = true;
174         isFeeExempt[_owner] = true;
175         isFeeExempt[Dapp1] = true;
176         isFeeExempt[Dapp2] = true;
177         isFeeExempt[Dapp3] = true;
178         isFeeExempt[Dapp4] = true;
179         isTxLimitExempt[Dapp1] = true;
180         isTxLimitExempt[Dapp2] = true;
181         isTxLimitExempt[Dapp3] = true;
182         isTxLimitExempt[Dapp4] = true;
183         isTxLimitExempt[_owner] = true;
184         isTxLimitExempt[marketingFeeReceiver] = true;
185         isTxLimitExempt[DEAD] = true;
186 
187         _balances[_owner] = _totalSupply;
188         emit Transfer(address(0), _owner, _totalSupply);
189     }
190 
191     receive() external payable { }
192 
193     function totalSupply() external view override returns (uint256) { return _totalSupply; }
194     function decimals() external pure override returns (uint8) { return _decimals; }
195     function symbol() external pure override returns (string memory) { return _symbol; }
196     function name() external pure override returns (string memory) { return _name; }
197     function getOwner() external view override returns (address) { return owner; }
198     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
199     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _allowances[msg.sender][spender] = amount;
203         emit Approval(msg.sender, spender, amount);
204         return true;
205     }
206 
207     function approveMax(address spender) external returns (bool) {
208         return approve(spender, type(uint256).max);
209     }
210 
211     function transfer(address recipient, uint256 amount) external override returns (bool) {
212         return _transferFrom(msg.sender, recipient, amount);
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
216         if(_allowances[sender][msg.sender] != type(uint256).max){
217             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
218         }
219 
220         return _transferFrom(sender, recipient, amount);
221     }
222 
223     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
224         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
225         
226         if (recipient != pair && recipient != DEAD) {
227             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
228         }
229         
230         if(shouldSwapBack()){ swapBack(); } 
231 
232         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
233 
234         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
235         _balances[recipient] = _balances[recipient].add(amountReceived);
236 
237         emit Transfer(sender, recipient, amountReceived);
238         return true;
239     }
240     
241     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
242         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
243         _balances[recipient] = _balances[recipient].add(amount);
244         emit Transfer(sender, recipient, amount);
245         return true;
246     }
247 
248     function updateDapp1(address newWallet) external onlyOwner {
249         emit Dapp1Updated(newWallet, Dapp1);
250         Dapp1 = newWallet;
251     }
252 
253     function updateDapp2(address newWallet) external onlyOwner {
254         emit Dapp2Updated(newWallet, Dapp2);
255         Dapp2 = newWallet;
256     }
257 
258     function updateDapp3(address newWallet) external onlyOwner {
259         emit Dapp3Updated(newWallet, Dapp3);
260         Dapp3 = newWallet;
261     }
262 
263     function updateDapp4(address newWallet) external onlyOwner {
264         emit Dapp4Updated(newWallet, Dapp4);
265         Dapp4 = newWallet;
266     }
267 
268     function updateMarketingFeeReceiver(address newWallet) external onlyOwner {
269     emit MarketingFeeReceiverUpdated(newWallet, marketingFeeReceiver);
270     marketingFeeReceiver = newWallet;
271     }
272 
273 
274     function shouldTakeFee(address sender) internal view returns (bool) {
275         return !isFeeExempt[sender];
276     }
277 
278     function takeFee(address sender, uint256 amount) internal returns (uint256) {
279         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
280         _balances[address(this)] = _balances[address(this)].add(feeAmount);
281         emit Transfer(sender, address(this), feeAmount);
282         return amount.sub(feeAmount);
283     }
284 
285     function shouldSwapBack() internal view returns (bool) {
286         return msg.sender != pair
287         && !inSwap
288         && swapEnabled
289         && _balances[address(this)] >= swapThreshold;
290     }
291 
292     function swapBack() internal swapping {
293         uint256 contractTokenBalance = swapThreshold;
294         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
295         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
296 
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = router.WETH();
300 
301         uint256 balanceBefore = address(this).balance;
302 
303         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
304             amountToSwap,
305             0,
306             path,
307             address(this),
308             block.timestamp
309         );
310         uint256 amountETH = address(this).balance.sub(balanceBefore);
311         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
312         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
313         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
314 
315 
316         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
317         require(MarketingSuccess, "receiver rejected ETH transfer");
318 
319         if(amountToLiquify > 0){
320             router.addLiquidityETH{value: amountETHLiquidity}(
321                 address(this),
322                 amountToLiquify,
323                 0,
324                 0,
325                0x36abe5B30da74d7151e4C76D2c181a9Ea923546B,
326                 block.timestamp
327             );
328             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
329         }
330     }
331 
332     function updateSwapThreshold(uint256 newThreshold) external onlyOwner {
333     swapThreshold = newThreshold;
334     }
335 
336     function buyTokens(uint256 amount, address to) internal swapping {
337         address[] memory path = new address[](2);
338         path[0] = router.WETH();
339         path[1] = address(this);
340 
341         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
342             0,
343             path,
344             to,
345             block.timestamp
346         );
347     }
348 
349     function clearStuckBalance() external {
350         payable(marketingFeeReceiver).transfer(address(this).balance);
351     }
352 
353     function claimOtherTokens(ERC20 _tokenAddress, address _walletaddress)external onlyOwner {
354         _tokenAddress.transfer(
355             _walletaddress,
356             _tokenAddress.balanceOf(address(this))
357         );
358     }
359 
360     function setWalletLimit(uint256 amountPercent) external onlyOwner {
361         require(amountPercent >= 5, "% too low, minimum is 1%");
362         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
363     }
364 
365     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
366         require(_liquidityFee + _marketingFee  <= 7, "fee to high try again 7% max");
367          liquidityFee = _liquidityFee; 
368          marketingFee = _marketingFee;
369          totalFee = liquidityFee + marketingFee;
370     }    
371     
372     event AutoLiquify(uint256 amountETH, uint256 amountRevDeFi);
373 }