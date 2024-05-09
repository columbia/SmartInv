1 /*                                               
2 HAGRIDANDREWTATEBATMAN369INU
3 
4 Telegram:https://t.me/hatbxi_eth
5 
6 */
7 pragma solidity 0.8.4;
8 // SPDX-License-Identifier: Unlicensed
9 
10 
11 
12 interface ERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function decimals() external view returns (uint8);
16 
17     function symbol() external view returns (string memory);
18 
19     function name() external view returns (string memory);
20 
21     function getOwner() external view returns (address);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address _owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 interface UniswapFactory {
38     function createPair(address tokenA, address tokenB) external returns (address pair);
39 }
40 
41 interface UniswapRouter {
42     function factory() external pure returns (address);
43 
44     function WETH() external pure returns (address);
45 
46     function addLiquidity(
47         address tokenA,
48         address tokenB,
49         uint amountADesired,
50         uint amountBDesired,
51         uint amountAMin,
52         uint amountBMin,
53         address to,
54         uint deadline
55     ) external returns (uint amountA, uint amountB, uint liquidity);
56 
57     function addLiquidityETH(
58         address token,
59         uint amountTokenDesired,
60         uint amountTokenMin,
61         uint amountETHMin,
62         address to,
63         uint deadline
64     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
65 
66     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
67         uint amountIn,
68         uint amountOutMin,
69         address[] calldata path,
70         address to,
71         uint deadline
72     ) external;
73 
74     function swapExactETHForTokensSupportingFeeOnTransferTokens(
75         uint amountOutMin,
76         address[] calldata path,
77         address to,
78         uint deadline
79     ) external payable;
80 
81     function swapExactTokensForETHSupportingFeeOnTransferTokens(
82         uint amountIn,
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external;
88 }
89 
90 // Contracts and libraries
91 
92 library SafeMath {
93 
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     }
109 
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {return 0;}
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114         return c;
115     }
116 
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
125     }
126 }
127 
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address payable) {
130         return payable(msg.sender);
131     }
132 
133     function _msgData() internal view virtual returns (bytes memory) {
134         this;
135         return msg.data;
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         authorizations[_owner] = true;
148         emit OwnershipTransferred(address(0), msgSender);
149     }
150     mapping (address => bool) internal authorizations;
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     function renounceOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 }
172 
173 contract HagridAndrewTateBatman369Inu is Ownable, ERC20 {
174     using SafeMath for uint256;
175 
176     uint8 constant _decimals = 9;
177 
178     uint256 _totalSupply = 10_000_000_0 * (10 ** _decimals);
179     uint256 public _maxTxAmount = 10_000_00 * (10 **_decimals);
180     uint256 public _walletMax = 20_000_00 * (10 ** _decimals);
181 
182     address DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
183     address ZERO_WALLET = 0x0000000000000000000000000000000000000000;
184 
185     address uniswapAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
186 
187     string constant _name = "HagridAndrewTateBatman369Inu";
188     string constant _symbol = "SOL";
189 
190     bool public restrictWhales = true;
191 
192     mapping(address => uint256) _balances;
193     mapping(address => mapping(address => uint256)) _allowances;
194 
195     mapping(address => bool) public isFeeExempt;
196     mapping(address => bool) public isTxLimitExempt;
197 
198     uint256 public liquidityFee = 3;
199     uint256 public marketingFee = 3;
200 
201     uint256 public totalFee = 6;
202     uint256 public totalFeeIfSelling = 6;
203 
204     address public autoLiquidityReceiver;
205     address public marketingWallet;
206 
207     UniswapRouter public router;
208     address public pair;
209 
210     uint256 public launchedAt;
211     bool public tradingOpen = true;
212     bool public blacklistMode = false;
213     mapping(address => bool) public isBlacklisted;
214 
215     bool public inSwapAndLiquify;
216     bool public swapAndLiquifyEnabled = true;
217     bool public swapAndLiquifyByLimitOnly = false;
218 
219     uint256 public swapThreshold = _totalSupply * 4 / 2000;
220 
221     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
222 
223     modifier lockTheSwap {
224         inSwapAndLiquify = true;
225         _;
226         inSwapAndLiquify = false;
227     }
228 
229     constructor() {
230         router = UniswapRouter(uniswapAddress);
231         pair = UniswapFactory(router.factory()).createPair(router.WETH(), address(this));
232         _allowances[address(this)][address(router)] = type(uint256).max;
233         _allowances[address(this)][address(pair)] = type(uint256).max;
234 
235         isFeeExempt[msg.sender] = true;
236         isFeeExempt[address(this)] = true;
237         isFeeExempt[DEAD_WALLET] = true;
238 
239         isTxLimitExempt[msg.sender] = true;
240         isTxLimitExempt[pair] = true;
241         isTxLimitExempt[DEAD_WALLET] = true;
242 
243         autoLiquidityReceiver = 0x345B4d2b5b21616c1e8Dd16104d3014635c6104c;
244         marketingWallet = 0x962d3fECbD1a234e42eC00715D357eD4c9515337;
245 
246         totalFee = liquidityFee.add(marketingFee);
247         totalFeeIfSelling = totalFee;
248 
249         _balances[msg.sender] = _totalSupply;
250         emit Transfer(address(0), msg.sender, _totalSupply);
251     }
252 
253     receive() external payable {}
254 
255     function name() external pure override returns (string memory) {return _name;}
256 
257     function symbol() external pure override returns (string memory) {return _symbol;}
258 
259     function decimals() external pure override returns (uint8) {return _decimals;}
260 
261     function totalSupply() external view override returns (uint256) {return _totalSupply;}
262 
263     function getOwner() external view override returns (address) {return owner();}
264 
265     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
266 
267     function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}
268 
269     function getCirculatingSupply() public view returns (uint256) {
270         return _totalSupply.sub(balanceOf(DEAD_WALLET)).sub(balanceOf(ZERO_WALLET));
271     }
272 
273     function approve(address spender, uint256 amount) public override returns (bool) {
274         _allowances[msg.sender][spender] = amount;
275         emit Approval(msg.sender, spender, amount);
276         return true;
277     }
278 
279     function approveMax(address spender) external returns (bool) {
280         return approve(spender, type(uint256).max);
281     }
282 
283     function launched() internal view returns (bool) {
284         return launchedAt != 0;
285     }
286 
287     function launch() internal {
288         launchedAt = block.number;
289     }
290 
291     function checkTxLimit(address sender, uint256 amount) internal view {
292         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
293     }
294 
295     function transfer(address recipient, uint256 amount) external override returns (bool) {
296         return _transferFrom(msg.sender, recipient, amount);
297     }
298 
299     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
300         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
301         _balances[recipient] = _balances[recipient].add(amount);
302         emit Transfer(sender, recipient, amount);
303         return true;
304     }
305 
306     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
307         if (_allowances[sender][msg.sender] != type(uint256).max) {
308             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
309         }
310         return _transferFrom(sender, recipient, amount);
311     }
312 
313     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
314         if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}
315         if(!authorizations[sender] && !authorizations[recipient]){
316             require(tradingOpen, "Trading not open yet");
317         }
318 
319         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
320         if (msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {marketingAndLiquidity();}
321         if (!launched() && recipient == pair) {
322             require(_balances[sender] > 0, "Zero balance violated!");
323             launch();
324         }    
325 
326         // Blacklist
327         if (blacklistMode) {
328             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
329         }
330 
331         //Exchange tokens
332          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
333 
334         if (!isTxLimitExempt[recipient] && restrictWhales) {
335             require(_balances[recipient].add(amount) <= _walletMax, "Max wallet violated!");
336         }
337 
338         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, recipient, amount) : amount;
339         _balances[recipient] = _balances[recipient].add(finalAmount);
340 
341         emit Transfer(sender, recipient, finalAmount);
342         return true;
343     }
344 
345     function extractFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
346         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
347         uint256 feeAmount = amount.mul(feeApplicable).div(100);
348 
349         _balances[address(this)] = _balances[address(this)].add(feeAmount);
350         emit Transfer(sender, address(this), feeAmount);
351 
352         return amount.sub(feeAmount);
353     }
354 
355     function marketingAndLiquidity() internal lockTheSwap {
356         uint256 tokensToLiquify = _balances[address(this)];
357         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
358         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
359 
360         address[] memory path = new address[](2);
361         path[0] = address(this);
362         path[1] = router.WETH();
363 
364         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
365             amountToSwap,
366             0,
367             path,
368             address(this),
369             block.timestamp
370         );
371 
372         uint256 amountETH = address(this).balance;
373 
374         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
375 
376         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
377         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
378 
379         (bool tmpSuccess,) = payable(marketingWallet).call{value : amountETHMarketing, gas : 30000}("");
380         tmpSuccess = false;
381 
382         if (amountToLiquify > 0) {
383             router.addLiquidityETH{value : amountETHLiquidity}(
384                 address(this),
385                 amountToLiquify,
386                 0,
387                 0,
388                 autoLiquidityReceiver,
389                 block.timestamp
390             );
391             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
392         }
393     }
394 
395     // CONTRACT OWNER FUNCTIONS
396 
397     function setWalletLimit(uint256 newLimit) external onlyOwner {
398         _walletMax = newLimit;
399     }
400 
401     function tradingStatus(bool newStatus) public onlyOwner {
402         tradingOpen = newStatus;
403     }
404 
405     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
406         isFeeExempt[holder] = exempt;
407     }
408 
409     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
410         isTxLimitExempt[holder] = exempt;
411     }
412 
413     function setFees(uint256 newLiqFee, uint256 newmarketingFee) external onlyOwner {
414         liquidityFee = newLiqFee;
415         marketingFee = newmarketingFee;
416 
417         totalFee = liquidityFee.add(marketingFee);
418         totalFeeIfSelling = totalFee;
419     }
420 
421         function enable_blacklist(bool _status) public onlyOwner {
422     blacklistMode = _status;
423     }
424 
425         
426     function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
427         for (uint256 i; i < addresses.length; ++i) {
428             isBlacklisted[addresses[i]] = status;
429         }
430     }
431 
432 }