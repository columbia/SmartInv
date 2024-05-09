1 /*
2 
3 ████████╗░█████╗░░██████╗██╗░░██╗░█████╗░░██████╗░██╗░░░██╗    ██████╗░██████╗░░█████╗░░██████╗░░█████╗░███╗░░██╗
4 ╚══██╔══╝██╔══██╗██╔════╝██║░░██║██╔══██╗██╔════╝░██║░░░██║    ██╔══██╗██╔══██╗██╔══██╗██╔════╝░██╔══██╗████╗░██║
5 ░░░██║░░░██║░░██║╚█████╗░███████║██║░░██║██║░░██╗░██║░░░██║    ██║░░██║██████╔╝███████║██║░░██╗░██║░░██║██╔██╗██║
6 ░░░██║░░░██║░░██║░╚═══██╗██╔══██║██║░░██║██║░░╚██╗██║░░░██║    ██║░░██║██╔══██╗██╔══██║██║░░╚██╗██║░░██║██║╚████║
7 ░░░██║░░░╚█████╔╝██████╔╝██║░░██║╚█████╔╝╚██████╔╝╚██████╔╝    ██████╔╝██║░░██║██║░░██║╚██████╔╝╚█████╔╝██║░╚███║
8 ░░░╚═╝░░░░╚════╝░╚═════╝░╚═╝░░╚═╝░╚════╝░░╚═════╝░░╚═════╝░    ╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░░╚════╝░╚═╝░░╚══╝
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.17;
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         return c;
44     }
45 }
46 
47 interface ERC20 {
48     function totalSupply() external view returns (uint256);
49     function decimals() external view returns (uint8);
50     function symbol() external view returns (string memory);
51     function name() external view returns (string memory);
52     function getOwner() external view returns (address);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 abstract contract Ownable {
63     address internal owner;
64 
65     constructor(address _owner) {
66         owner = _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(isOwner(msg.sender) , "!Owner"); _;
71     }
72 
73     function isOwner(address account) public view returns (bool) {
74         return account == owner;
75     }
76 
77     function renounceOwnership() public onlyOwner {
78         owner = address(0);
79         emit OwnershipTransferred(address(0));
80     }  
81     event OwnershipTransferred(address owner);
82 }
83 
84 interface IUniswapV2Factory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IUniswapV2Router02 {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function swapExactETHForTokensSupportingFeeOnTransferTokens(
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external payable;
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129 }
130 
131 contract ToshoguDragon is ERC20, Ownable {
132     using SafeMath for uint256;
133     function totalSupply() external view override returns (uint256) { return _totalSupply; }
134     function decimals() external pure override returns (uint8) { return _decimals; }
135     function symbol() external pure override returns (string memory) { return _symbol; }
136     function name() external pure override returns (string memory) { return _name; }
137     function getOwner() external view override returns (address) { return owner; }
138     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
139     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
140 
141     struct TaxWallets {
142         address marketing;
143         address poolStaking;
144         address buyback;
145         address addLp;
146     }
147 
148     struct FeesBuy {
149         uint marketing;
150         uint poolStaking;
151         uint buyback;
152         uint addLp;
153         uint totalFee;
154     }
155 
156     struct FeesSell {
157         uint marketing;
158         uint poolStaking;
159         uint buyback;
160         uint addLp;
161         uint totalFee;
162     }
163 
164     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
165     address DEAD = 0x000000000000000000000000000000000000dEaD;
166 
167     string constant _name = "Toshogu Dragon";
168     string constant _symbol = "TOSHOGU";
169     uint8 constant _decimals = 9;
170 
171     uint256 _totalSupply = 1 * 10**9 * (10 ** _decimals);
172     uint256 public _maxWalletAmount = _totalSupply.mul(10).div(1000);
173     uint256 public _maxWhitelistWalletAmount = _totalSupply.mul(5).div(1000);
174     uint256 public _maxTx = _totalSupply.mul(10).div(1000);
175 
176     mapping (address => uint256) _balances;
177     mapping (address => mapping (address => uint256)) _allowances;
178 
179     mapping (address => bool) isWhitelist;
180     mapping (address => bool) isFeeExempt;
181     mapping (address => bool) isTxLimitExempt;
182 
183     TaxWallets public _taxWallet = TaxWallets ({
184         marketing: 0x3cC024e7B52Ca28ab24e0869F5917fa4B7255C64,
185         poolStaking: 0x3cC024e7B52Ca28ab24e0869F5917fa4B7255C64,
186         buyback: 0x34DA571a302Ff717A4126738e1b43AE013BFd5B7,
187         addLp: 0x34DA571a302Ff717A4126738e1b43AE013BFd5B7
188     });
189 
190     FeesBuy public _feeBuy = FeesBuy ({
191         marketing: 1,
192         poolStaking: 1,
193         buyback: 1,
194         addLp: 1,
195         totalFee: 4
196     });
197 
198     FeesSell public _feeSell = FeesSell ({
199         marketing: 1,
200         poolStaking: 1,
201         buyback: 1,
202         addLp: 1,
203         totalFee: 4
204     });
205 
206     uint256 feeDenominator = 100;
207 
208     IUniswapV2Router02 public router;
209     address public pair;
210 
211     bool public swapEnabled = false;
212     bool inSwap;
213     modifier swapping() { inSwap = true; _; inSwap = false; }
214 
215     constructor () Ownable(msg.sender) {
216         router = IUniswapV2Router02(routerAdress);
217         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
218         _allowances[address(this)][address(router)] = type(uint256).max;
219 
220         address _owner = owner;
221         isFeeExempt[_owner] = true;
222         isFeeExempt[_taxWallet.marketing] = true;
223         isFeeExempt[_taxWallet.poolStaking] = true;
224         isFeeExempt[_taxWallet.buyback] = true;
225         isFeeExempt[_taxWallet.addLp] = true;
226 
227         isTxLimitExempt[_owner] = true;
228         isTxLimitExempt[DEAD] = true;
229 
230         isTxLimitExempt[_taxWallet.marketing] = true;
231         isTxLimitExempt[_taxWallet.poolStaking] = true;
232         isTxLimitExempt[_taxWallet.buyback] = true;
233         isTxLimitExempt[_taxWallet.addLp] = true;
234         isTxLimitExempt[pair] = true;
235 
236         isWhitelist[_owner] = true;
237         isWhitelist[_taxWallet.marketing] = true;
238         isWhitelist[_taxWallet.poolStaking] = true;
239         isWhitelist[_taxWallet.buyback] = true;
240         isWhitelist[_taxWallet.addLp] = true;
241 
242         _balances[_owner] = _totalSupply;
243         emit Transfer(address(0), _owner, _totalSupply);
244     }
245 
246     function approve(address spender, uint256 amount) public override returns (bool) {
247         _allowances[msg.sender][spender] = amount;
248         emit Approval(msg.sender, spender, amount);
249         return true;
250     }
251 
252     function approveMax(address spender) external returns (bool) {
253         return approve(spender, type(uint256).max);
254     }
255 
256     function transfer(address recipient, uint256 amount) external override returns (bool) {
257         return _transferFrom(msg.sender, recipient, amount);
258     }
259 
260     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
261         if(_allowances[sender][msg.sender] != type(uint256).max){
262             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
263         }
264 
265         return _transferFrom(sender, recipient, amount);
266     }
267 
268     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
269         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
270         
271         if (!swapEnabled && sender == pair && !isWhitelist[recipient]) {
272             return false;
273         }
274 
275         if (!isTxLimitExempt[sender] && (recipient == pair || sender == pair)) {
276             require(amount <= _maxTx, "Buy/Sell exceeds the max tx");
277         }
278 
279         if (recipient != pair && isWhitelist[recipient]) {
280             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWhitelistWalletAmount, "Transfer amount exceeds the bag size.");
281         }
282 
283         if (recipient != pair && recipient != DEAD) {
284             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
285         }
286         
287         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
288 
289         uint256 amountReceived = (shouldTakeFee(sender) && shouldTakeFee(recipient)) ? takeFee(sender, recipient, amount) : amount;
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
303     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
304         uint256 feeAmount = 0;
305         if (sender == pair && _feeBuy.totalFee != 0) {           // Buy
306             feeAmount = amount.mul(_feeBuy.totalFee).div(feeDenominator);
307             _balances[_taxWallet.marketing] = _balances[_taxWallet.marketing].add(feeAmount.mul(_feeBuy.marketing).div(_feeBuy.totalFee));
308             _balances[_taxWallet.poolStaking] = _balances[_taxWallet.poolStaking].add(feeAmount.mul(_feeBuy.poolStaking).div(_feeBuy.totalFee));
309             _balances[_taxWallet.buyback] = _balances[_taxWallet.buyback].add(feeAmount.mul(_feeBuy.buyback).div(_feeBuy.totalFee));
310             _balances[_taxWallet.addLp] = _balances[_taxWallet.addLp].add(feeAmount.mul(_feeBuy.addLp).div(_feeBuy.totalFee));
311         } else if (recipient == pair && _feeSell.totalFee != 0) { // Sell
312             feeAmount = amount.mul(_feeSell.totalFee).div(feeDenominator);
313             _balances[_taxWallet.marketing] = _balances[_taxWallet.marketing].add(feeAmount.mul(_feeSell.marketing).div(_feeSell.totalFee));
314             _balances[_taxWallet.poolStaking] = _balances[_taxWallet.poolStaking].add(feeAmount.mul(_feeSell.poolStaking).div(_feeSell.totalFee));
315             _balances[_taxWallet.buyback] = _balances[_taxWallet.buyback].add(feeAmount.mul(_feeSell.buyback).div(_feeSell.totalFee));
316             _balances[_taxWallet.addLp] = _balances[_taxWallet.addLp].add(feeAmount.mul(_feeSell.addLp).div(_feeSell.totalFee));
317         }
318         return amount.sub(feeAmount);
319     }
320 
321     function setFeeSell(uint256 _marketing, uint256 _poolStaking, uint256 _buyback, uint256 _addLp) external onlyOwner{
322         _feeSell.marketing = _marketing; 
323         _feeSell.poolStaking = _poolStaking;
324         _feeSell.buyback = _buyback;
325         _feeSell.addLp = _addLp;
326         _feeSell.totalFee = _marketing.add(_poolStaking).add(_buyback).add(_addLp);
327     }
328 
329     function setFeeBuy(uint256 _marketing, uint256 _poolStaking, uint256 _buyback, uint256 _addLp) external onlyOwner{
330         _feeBuy.marketing = _marketing; 
331         _feeBuy.poolStaking = _poolStaking;
332         _feeBuy.buyback = _buyback;
333         _feeBuy.addLp = _addLp;
334         _feeBuy.totalFee = _marketing.add(_poolStaking).add(_buyback).add(_addLp);
335     }       
336 
337     function updateTaxWallets(address _marketing, address _poolStaking, address _buyback, address _addLp) external onlyOwner{
338         _taxWallet.marketing = _marketing; 
339         _taxWallet.poolStaking = _poolStaking;
340         _taxWallet.buyback = _buyback;
341         _taxWallet.addLp = _addLp;
342     }
343 
344     function shouldTakeFee(address sender) internal view returns (bool) {
345         return !isFeeExempt[sender];
346     }
347 
348     function setFeeExempt(address adr, bool _isFeeExempt) external onlyOwner{
349         isFeeExempt[adr] = _isFeeExempt; 
350     }
351 
352     function setMultipleFeeExempt(address[] calldata wallets, bool _isFeeExempt) external onlyOwner {
353         for(uint256 i = 0; i < wallets.length; i++) {
354             isFeeExempt[wallets[i]] = _isFeeExempt;
355         }
356     }
357     
358     function setWhitelist(address[] memory adr, bool _isWhitelist) external onlyOwner{
359         for (uint256 i = 0; i < adr.length; i++) {
360             isWhitelist[adr[i]] = _isWhitelist; 
361         }
362     }
363 
364     function setLegitAmount(uint256 _walletLimitPercent, uint256 _walletWhitelistLimitPercent, uint256 _maxTxPercent)  external onlyOwner {
365         require(_walletLimitPercent >= 1,"wallet limit mush be not less than 0.1 percent");
366         require(_walletWhitelistLimitPercent >= 1,"whitelist wallet limit mush be not less than 0.1 percent");
367         require(_maxTxPercent >= 1, "Max tx amount must not be less than 0.1 percent");
368 
369         _maxWalletAmount = (_totalSupply * _walletLimitPercent ) / 1000;
370         _maxWhitelistWalletAmount = (_totalSupply * _walletWhitelistLimitPercent ) / 1000;
371         _maxTx = _totalSupply.mul(_maxTxPercent).div(1000);
372     }
373 
374     function setTxLimitExempt(address adr, bool _isTxLimitExempt) external onlyOwner{
375         isTxLimitExempt[adr] = _isTxLimitExempt;
376     }
377 
378     //Using to enable Swap, only one time
379     function enableSwap() external onlyOwner{
380         swapEnabled = true;
381     }
382 
383     //Using when token is stuck in contract
384     function clearToken() external {
385         uint256 contractTokenBalance = _balances[address(this)];
386         _balances[_taxWallet.marketing] = _balances[_taxWallet.marketing].add(contractTokenBalance);
387         _balances[address(this)] = 0;
388     }
389 
390     //Using when ETH is stuck in contract
391     function clearETH() external {
392          payable(_taxWallet.marketing).transfer(address(this).balance);
393     }
394 
395     receive() external payable { }
396 }