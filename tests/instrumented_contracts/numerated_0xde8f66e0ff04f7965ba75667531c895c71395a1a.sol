1 pragma solidity 0.8.4;
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 interface IBEP20 {
6     function totalSupply() external view returns (uint256);
7 
8     function decimals() external view returns (uint8);
9 
10     function symbol() external view returns (string memory);
11 
12     function name() external view returns (string memory);
13 
14     function getOwner() external view returns (address);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     function allowance(address _owner, address spender) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface PancakeSwapFactory {
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32 }
33 
34 interface PancakeSwapRouter {
35     function factory() external pure returns (address);
36 
37     function WETH() external pure returns (address);
38 
39     function addLiquidity(
40         address tokenA,
41         address tokenB,
42         uint amountADesired,
43         uint amountBDesired,
44         uint amountAMin,
45         uint amountBMin,
46         address to,
47         uint deadline
48     ) external returns (uint amountA, uint amountB, uint liquidity);
49 
50     function addLiquidityETH(
51         address token,
52         uint amountTokenDesired,
53         uint amountTokenMin,
54         uint amountETHMin,
55         address to,
56         uint deadline
57     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
58 
59     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
60         uint amountIn,
61         uint amountOutMin,
62         address[] calldata path,
63         address to,
64         uint deadline
65     ) external;
66 
67     function swapExactETHForTokensSupportingFeeOnTransferTokens(
68         uint amountOutMin,
69         address[] calldata path,
70         address to,
71         uint deadline
72     ) external payable;
73 
74     function swapExactTokensForETHSupportingFeeOnTransferTokens(
75         uint amountIn,
76         uint amountOutMin,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external;
81 }
82 
83 // Contracts and libraries
84 
85 library SafeMath {
86 
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96 
97     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {return 0;}
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120 
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address payable) {
123         return payable(msg.sender);
124     }
125 
126     function _msgData() internal view virtual returns (bytes memory) {
127         this;
128         return msg.data;
129     }
130 }
131 
132 contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     constructor () {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         authorizations[_owner] = true;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143     mapping (address => bool) internal authorizations;
144 
145     function owner() public view returns (address) {
146         return _owner;
147     }
148 
149     modifier onlyOwner() {
150         require(_owner == _msgSender(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154 
155     function renounceOwnership() public virtual onlyOwner {
156         emit OwnershipTransferred(_owner, address(0));
157         _owner = address(0);
158     }
159 
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         emit OwnershipTransferred(_owner, newOwner);
163         _owner = newOwner;
164     }
165 }
166 
167 contract THEFINESTMEME is Ownable, IBEP20 {
168     using SafeMath for uint256;
169 
170     uint8 constant _decimals = 9;
171 
172     uint256 _totalSupply = 33000000000000 * (10 ** _decimals); //Set Supply
173     uint256 public _maxTxAmount = _totalSupply * 5 / 1000; //Set max transaction amount. Currently set to 0.5% of the supply.
174     uint256 public _walletMax = _totalSupply * 15 / 1000; //Set max wallet amount. Currently set to 1.5% of the supply.
175 
176     address DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
177     address ZERO_WALLET = 0x0000000000000000000000000000000000000000;
178 
179     address pancakeAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
180     //address pancakeAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
181 
182     string constant _name = "THEFINESTMEME"; //Set the name of your token.
183     string constant _symbol = "FINEST"; //Set the symbol of your token.
184 
185     bool public restrictWhales = true; //If true, limits wallet to _walletMax set above.
186 
187     mapping(address => uint256) _balances;
188     mapping(address => mapping(address => uint256)) _allowances;
189 
190     mapping(address => bool) public isFeeExempt;
191     mapping(address => bool) public isTxLimitExempt;
192 
193     uint256 public developmentFee = 0; // Tax for development costs -- Actual wallet split set below at "amountToDevelopment"
194     uint256 public marketingFee = 95; //Tax for Marketing costs -- Actual wallet split set below at "amountToMarketing"
195     uint256 public rewardsFee = 0; // Tax for Rewards -- Actual wallet split set below at "amountToRewards"
196 
197     uint256 public totalFee; //Ignore this
198 
199     address private developmentWallet;
200     address private marketingWallet;
201     address private rewardsWallet;
202 
203     PancakeSwapRouter public router;
204     address public pair;
205 
206     uint256 public launchedAt;
207     bool public tradingOpen = false; //Leave false, enabled after launch.
208 
209     bool inSwapAndLiquify;
210     bool public swapAndLiquifyEnabled = true;
211     bool public swapAndLiquifyByLimitOnly = false;
212 
213     uint256 public swapThreshold = _totalSupply * 4 / 2000; //Amount to swap for Development/Marketing/Rewards -- Set to 0.2% 
214 
215     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
216 
217     modifier lockTheSwap {
218         inSwapAndLiquify = true;
219         _;
220         inSwapAndLiquify = false;
221     }
222 
223     constructor() {
224         router = PancakeSwapRouter(pancakeAddress);
225         pair = PancakeSwapFactory(router.factory()).createPair(router.WETH(), address(this));
226         _allowances[address(this)][address(router)] = type(uint256).max;
227         _allowances[address(this)][address(pair)] = type(uint256).max;
228 
229         isFeeExempt[msg.sender] = true;
230         isFeeExempt[address(this)] = true;
231         isFeeExempt[DEAD_WALLET] = true;
232 
233         isTxLimitExempt[msg.sender] = true;
234         isTxLimitExempt[pair] = true;
235         isTxLimitExempt[DEAD_WALLET] = true;
236 
237         developmentWallet = 0x7915a6c8b49E204B6CDf7d74CC526041449EE4F3; //Address for development costs
238         marketingWallet = 0x5D268b622688230d8f1644A74CbDeC750390a24b; //Address for marketing fees
239         rewardsWallet = 0x5D268b622688230d8f1644A74CbDeC750390a24b; //Address for rewards
240         
241         isFeeExempt[marketingWallet] = true;
242         totalFee = developmentFee.add(marketingFee + rewardsFee);
243 
244         _balances[msg.sender] = _totalSupply;
245         emit Transfer(address(0), msg.sender, _totalSupply);
246     }
247 
248     receive() external payable {}
249 
250     function name() external pure override returns (string memory) {return _name;}
251 
252     function symbol() external pure override returns (string memory) {return _symbol;}
253 
254     function decimals() external pure override returns (uint8) {return _decimals;}
255 
256     function totalSupply() external view override returns (uint256) {return _totalSupply;}
257 
258     function getOwner() external view override returns (address) {return owner();}
259 
260     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
261 
262     function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}
263 
264     function getCirculatingSupply() public view returns (uint256) {
265         return _totalSupply.sub(balanceOf(DEAD_WALLET)).sub(balanceOf(ZERO_WALLET));
266     }
267 
268     function approve(address spender, uint256 amount) public override returns (bool) {
269         _allowances[msg.sender][spender] = amount;
270         emit Approval(msg.sender, spender, amount);
271         return true;
272     }
273 
274     function approveMax(address spender) external returns (bool) {
275         return approve(spender, type(uint256).max);
276     }
277 
278     function launched() internal view returns (bool) {
279         return launchedAt != 0;
280     }
281 
282     function launch() internal {
283         launchedAt = block.number;
284     }
285 
286     function checkTxLimit(address sender, uint256 amount) internal view {
287         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
288     }
289 
290     function transfer(address recipient, uint256 amount) external override returns (bool) {
291         return _transferFrom(msg.sender, recipient, amount);
292     }
293 
294     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
295         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
296         _balances[recipient] = _balances[recipient].add(amount);
297         emit Transfer(sender, recipient, amount);
298         return true;
299     }
300 
301     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
302         if (_allowances[sender][msg.sender] != type(uint256).max) {
303             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
304         }
305         return _transferFrom(sender, recipient, amount);
306     }
307 
308     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
309         if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}
310         if(!authorizations[sender] && !authorizations[recipient]){
311             require(tradingOpen, "Trading not open yet");
312         }
313 
314         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
315         if (msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {transferFees();}
316         if (!launched() && recipient == pair) {
317             require(_balances[sender] > 0, "Zero balance violated!");
318             launch();
319         }    
320 
321         //Exchange tokens
322          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
323 
324         if (!isTxLimitExempt[recipient] && restrictWhales) {
325             require(_balances[recipient].add(amount) <= _walletMax, "Max wallet violated!");
326         }
327 
328         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, amount) : amount;
329         _balances[recipient] = _balances[recipient].add(finalAmount);
330 
331         emit Transfer(sender, recipient, finalAmount);
332         return true;
333     }
334 
335     function extractFee(address sender, uint256 amount) internal returns (uint256) {
336         uint256 feeAmount = amount.mul(totalFee).div(100);
337 
338         _balances[address(this)] = _balances[address(this)].add(feeAmount);
339         emit Transfer(sender, address(this), feeAmount);
340 
341         return amount.sub(feeAmount);
342     }
343 
344     function transferFees() internal lockTheSwap {
345         uint256 tokensToSwap = _balances[address(this)];
346 
347         address[] memory path = new address[](2);
348         path[0] = address(this);
349         path[1] = router.WETH();
350 
351         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
352             tokensToSwap,
353             0,
354             path,
355             address(this),
356             block.timestamp
357         );
358 
359         uint256 amountBNB = address(this).balance;
360 
361         uint256 amountToMarketing = amountBNB.div(3);
362         uint256 amountToDevelopment = amountBNB.div(3);
363         uint256 amountToRewards = amountBNB.div(3);
364         
365         (bool tmpSuccess1,) = payable(marketingWallet).call{value : amountToMarketing, gas : 30000}("");
366         tmpSuccess1 = false;
367 
368         (bool tmpSuccess2,) = payable(developmentWallet).call{value : amountToDevelopment, gas : 30000}("");
369         tmpSuccess2 = false;
370 
371         (bool tmpSuccess3,) = payable(rewardsWallet).call{value : amountToRewards, gas : 30000}("");
372         tmpSuccess3 = false;
373 
374     }
375 
376     // CONTRACT OWNER FUNCTIONS
377 
378     function setWalletLimit(uint256 newLimit) external onlyOwner {
379         _walletMax = newLimit;
380     }
381 
382     function tradingStatus(bool newStatus) public onlyOwner {
383         tradingOpen = newStatus;
384     }
385 
386     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
387         isFeeExempt[holder] = exempt;
388     }
389 
390     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
391         isTxLimitExempt[holder] = exempt;
392     }
393 
394     function setFees(uint256 newDevFee, uint256 newMarketingFee, uint256 newRewardsFee) external onlyOwner {
395         developmentFee = newDevFee;
396         marketingFee = newMarketingFee;
397         rewardsFee = newRewardsFee;
398 
399         totalFee = developmentFee.add(marketingFee + rewardsFee);
400     }
401 
402     function rescueToken(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
403         return IBEP20(tokenAddress).transfer(msg.sender, tokens);
404     }
405 
406     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
407         uint256 amountETH = address(this).balance;
408         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
409     }
410 
411 }