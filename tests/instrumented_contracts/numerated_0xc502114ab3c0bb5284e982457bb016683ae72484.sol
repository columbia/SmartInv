1 pragma solidity 0.8.4;
2 // SPDX-License-Identifier: Unlicensed
3 
4 // Ownership renounced, community driven.
5 // 0% tax | ManualBurn of 1% on each txn.
6 //DOGGER LP BURN AT 30K MARKETCAP
7 //AutoLP tokens sent to dead address. 
8 
9 
10 interface ERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function decimals() external view returns (uint8);
14 
15     function symbol() external view returns (string memory);
16 
17     function name() external view returns (string memory);
18 
19     function getOwner() external view returns (address);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address _owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 interface UniswapFactory {
36     function createPair(address tokenA, address tokenB) external returns (address pair);
37 }
38 
39 interface UniswapRouter {
40     function factory() external pure returns (address);
41 
42     function WETH() external pure returns (address);
43 
44     function addLiquidity(
45         address tokenA,
46         address tokenB,
47         uint amountADesired,
48         uint amountBDesired,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline
53     ) external returns (uint amountA, uint amountB, uint liquidity);
54 
55     function addLiquidityETH(
56         address token,
57         uint amountTokenDesired,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline
62     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
63 
64     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external;
71 
72     function swapExactETHForTokensSupportingFeeOnTransferTokens(
73         uint amountOutMin,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external payable;
78 
79     function swapExactTokensForETHSupportingFeeOnTransferTokens(
80         uint amountIn,
81         uint amountOutMin,
82         address[] calldata path,
83         address to,
84         uint deadline
85     ) external;
86 }
87 
88 // Contracts and libraries
89 
90 library SafeMath {
91 
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95         return c;
96     }
97 
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b <= a, errorMessage);
104         uint256 c = a - b;
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         if (a == 0) {return 0;}
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         return c;
123     }
124 }
125 
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address payable) {
128         return payable(msg.sender);
129     }
130 
131     function _msgData() internal view virtual returns (bytes memory) {
132         this;
133         return msg.data;
134     }
135 }
136 
137 contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     constructor () {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         authorizations[_owner] = true;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148     mapping (address => bool) internal authorizations;
149 
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 }
170 
171 contract Dogger is Ownable, ERC20 {
172     using SafeMath for uint256;
173 
174     uint8 constant _decimals = 18;
175 
176     uint256 _totalSupply = 10_000_000_000 * (10 ** _decimals);
177     uint256 public _maxTxAmount = _totalSupply;
178     uint256 public _walletMax = _totalSupply;
179 
180     address DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
181     address ZERO_WALLET = 0x0000000000000000000000000000000000000000;
182 
183     address uniswapAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
184 
185     string constant _name = "Dogger";
186     string constant _symbol = "DOGGER";
187 
188     bool public restrictWhales = true;
189 
190     mapping(address => uint256) _balances;
191     mapping(address => mapping(address => uint256)) _allowances;
192 
193     mapping(address => bool) public isFeeExempt;
194     mapping(address => bool) public isTxLimitExempt;
195 
196     uint256 public liquidityFee = 0;
197     uint256 public ManualBurn = 1;
198 
199     uint256 public totalFee = 1;
200     uint256 public totalFeeIfSelling = 1;
201 
202     address public autoLiquidityReceiver;
203     address public marketingWallet;
204 
205     UniswapRouter public router;
206     address public pair;
207 
208     uint256 public launchedAt;
209     bool public tradingOpen = false;
210     bool public blacklistMode = false;
211     mapping(address => bool) public isBlacklisted;
212 
213     bool public inSwapAndLiquify;
214     bool public swapAndLiquifyEnabled = true;
215     bool public swapAndLiquifyByLimitOnly = false;
216 
217     uint256 public swapThreshold = _totalSupply * 4 / 2000;
218 
219     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
220 
221     modifier lockTheSwap {
222         inSwapAndLiquify = true;
223         _;
224         inSwapAndLiquify = false;
225     }
226 
227     constructor() {
228         router = UniswapRouter(uniswapAddress);
229         pair = UniswapFactory(router.factory()).createPair(router.WETH(), address(this));
230         _allowances[address(this)][address(router)] = type(uint256).max;
231         _allowances[address(this)][address(pair)] = type(uint256).max;
232 
233         isFeeExempt[msg.sender] = true;
234         isFeeExempt[address(this)] = true;
235         isFeeExempt[DEAD_WALLET] = true;
236 
237         isTxLimitExempt[msg.sender] = true;
238         isTxLimitExempt[pair] = true;
239         isTxLimitExempt[DEAD_WALLET] = true;
240 
241         autoLiquidityReceiver = 0x0000000000000000000000000000000000000000;
242         marketingWallet = 0x0000000000000000000000000000000000000000;
243 
244         totalFee = liquidityFee.add(ManualBurn);
245         totalFeeIfSelling = totalFee;
246 
247         _balances[msg.sender] = _totalSupply;
248         emit Transfer(address(0), msg.sender, _totalSupply);
249     }
250 
251     receive() external payable {}
252 
253     function name() external pure override returns (string memory) {return _name;}
254 
255     function symbol() external pure override returns (string memory) {return _symbol;}
256 
257     function decimals() external pure override returns (uint8) {return _decimals;}
258 
259     function totalSupply() external view override returns (uint256) {return _totalSupply;}
260 
261     function getOwner() external view override returns (address) {return owner();}
262 
263     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
264 
265     function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}
266 
267     function getCirculatingSupply() public view returns (uint256) {
268         return _totalSupply.sub(balanceOf(DEAD_WALLET)).sub(balanceOf(ZERO_WALLET));
269     }
270 
271     function approve(address spender, uint256 amount) public override returns (bool) {
272         _allowances[msg.sender][spender] = amount;
273         emit Approval(msg.sender, spender, amount);
274         return true;
275     }
276 
277     function approveMax(address spender) external returns (bool) {
278         return approve(spender, type(uint256).max);
279     }
280 
281     function launched() internal view returns (bool) {
282         return launchedAt != 0;
283     }
284 
285     function launch() internal {
286         launchedAt = block.number;
287     }
288 
289     function checkTxLimit(address sender, uint256 amount) internal view {
290         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
291     }
292 
293     function transfer(address recipient, uint256 amount) external override returns (bool) {
294         return _transferFrom(msg.sender, recipient, amount);
295     }
296 
297     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
298         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
299         _balances[recipient] = _balances[recipient].add(amount);
300         emit Transfer(sender, recipient, amount);
301         return true;
302     }
303 
304     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
305         if (_allowances[sender][msg.sender] != type(uint256).max) {
306             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
307         }
308         return _transferFrom(sender, recipient, amount);
309     }
310 
311     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
312         if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}
313         if(!authorizations[sender] && !authorizations[recipient]){
314             require(tradingOpen, "Trading not open yet");
315         }
316 
317         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
318         if (msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {marketingAndLiquidity();}
319         if (!launched() && recipient == pair) {
320             require(_balances[sender] > 0, "Zero balance violated!");
321             launch();
322         }    
323 
324         // Blacklist
325         if (blacklistMode) {
326             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
327         }
328 
329         //Exchange tokens
330          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
331 
332         if (!isTxLimitExempt[recipient] && restrictWhales) {
333             require(_balances[recipient].add(amount) <= _walletMax, "Max wallet violated!");
334         }
335 
336         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, recipient, amount) : amount;
337         _balances[recipient] = _balances[recipient].add(finalAmount);
338 
339         emit Transfer(sender, recipient, finalAmount);
340         return true;
341     }
342 
343     function extractFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
344         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
345         uint256 feeAmount = amount.mul(feeApplicable).div(100);
346 
347         _balances[address(this)] = _balances[address(this)].add(feeAmount);
348         emit Transfer(sender, address(this), feeAmount);
349 
350         return amount.sub(feeAmount);
351     }
352 
353     function marketingAndLiquidity() internal lockTheSwap {
354         uint256 tokensToLiquify = _balances[address(this)];
355         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
356         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
357 
358         address[] memory path = new address[](2);
359         path[0] = address(this);
360         path[1] = router.WETH();
361 
362         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             amountToSwap,
364             0,
365             path,
366             address(this),
367             block.timestamp
368         );
369 
370         uint256 amountETH = address(this).balance;
371 
372         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
373 
374         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
375         uint256 amountETHMarketing = amountETH.mul(ManualBurn).div(totalETHFee);
376 
377         (bool tmpSuccess,) = payable(marketingWallet).call{value : amountETHMarketing, gas : 30000}("");
378         tmpSuccess = false;
379 
380         if (amountToLiquify > 0) {
381             router.addLiquidityETH{value : amountETHLiquidity}(
382                 address(this),
383                 amountToLiquify,
384                 0,
385                 0,
386                 autoLiquidityReceiver,
387                 block.timestamp
388             );
389             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
390         }
391     }
392 
393     // CONTRACT OWNER FUNCTIONS
394 
395     function setWalletLimit(uint256 newLimit) external onlyOwner {
396         _walletMax = newLimit;
397     }
398 
399     function tradingStatus(bool newStatus) public onlyOwner {
400         tradingOpen = newStatus;
401     }
402 
403     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
404         isFeeExempt[holder] = exempt;
405     }
406 
407     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
408         isTxLimitExempt[holder] = exempt;
409     }
410 
411     function setFees(uint256 newLiqFee, uint256 newManualBurn) external onlyOwner {
412         liquidityFee = newLiqFee;
413         ManualBurn = newManualBurn;
414 
415         totalFee = liquidityFee.add(ManualBurn);
416         totalFeeIfSelling = totalFee;
417     }
418 
419         function enable_blacklist(bool _status) public onlyOwner {
420     blacklistMode = _status;
421     }
422 
423         
424     function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
425         for (uint256 i; i < addresses.length; ++i) {
426             isBlacklisted[addresses[i]] = status;
427         }
428     }
429 
430 }