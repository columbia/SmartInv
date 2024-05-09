1 pragma solidity 0.8.4;
2 // SPDX-License-Identifier: Unlicensed
3 
4 
5 
6 interface ERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function decimals() external view returns (uint8);
10 
11     function symbol() external view returns (string memory);
12 
13     function name() external view returns (string memory);
14 
15     function getOwner() external view returns (address);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address _owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface UniswapFactory {
32     function createPair(address tokenA, address tokenB) external returns (address pair);
33 }
34 
35 interface UniswapRouter {
36     function factory() external pure returns (address);
37 
38     function WETH() external pure returns (address);
39 
40     function addLiquidity(
41         address tokenA,
42         address tokenB,
43         uint amountADesired,
44         uint amountBDesired,
45         uint amountAMin,
46         uint amountBMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountA, uint amountB, uint liquidity);
50 
51     function addLiquidityETH(
52         address token,
53         uint amountTokenDesired,
54         uint amountTokenMin,
55         uint amountETHMin,
56         address to,
57         uint deadline
58     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
59 
60     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
61         uint amountIn,
62         uint amountOutMin,
63         address[] calldata path,
64         address to,
65         uint deadline
66     ) external;
67 
68     function swapExactETHForTokensSupportingFeeOnTransferTokens(
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external payable;
74 
75     function swapExactTokensForETHSupportingFeeOnTransferTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external;
82 }
83 
84 // Contracts and libraries
85 
86 library SafeMath {
87 
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91         return c;
92     }
93 
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return sub(a, b, "SafeMath: subtraction overflow");
96     }
97 
98     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103 
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {return 0;}
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110 
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address payable) {
124         return payable(msg.sender);
125     }
126 
127     function _msgData() internal view virtual returns (bytes memory) {
128         this;
129         return msg.data;
130     }
131 }
132 
133 contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     constructor () {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         authorizations[_owner] = true;
142         emit OwnershipTransferred(address(0), msgSender);
143     }
144     mapping (address => bool) internal authorizations;
145 
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
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
167 contract Minoinu is Ownable, ERC20 {
168     using SafeMath for uint256;
169 
170     uint8 constant _decimals = 18;
171 
172     uint256 _totalSupply = 10_000_000_000 * (10 ** _decimals);
173     uint256 public _maxTxAmount = _totalSupply;
174     uint256 public _walletMax = _totalSupply;
175 
176     address DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
177     address ZERO_WALLET = 0x0000000000000000000000000000000000000000;
178 
179     address uniswapAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
180 
181     string constant _name = "Mino Inu";
182     string constant _symbol = "MINU";
183 
184     bool public restrictWhales = true;
185 
186     mapping(address => uint256) _balances;
187     mapping(address => mapping(address => uint256)) _allowances;
188 
189     mapping(address => bool) public isFeeExempt;
190     mapping(address => bool) public isTxLimitExempt;
191 
192     uint256 public liquidityFee = 1;
193     uint256 public marketingFee = 4;
194 
195     uint256 public totalFee = 5;
196     uint256 public totalFeeIfSelling = 5;
197 
198     address public autoLiquidityReceiver;
199     address public marketingWallet;
200 
201     UniswapRouter public router;
202     address public pair;
203 
204     uint256 public launchedAt;
205     bool public tradingOpen = false;
206     bool public blacklistMode = false;
207     mapping(address => bool) public isBlacklisted;
208 
209     bool public inSwapAndLiquify;
210     bool public swapAndLiquifyEnabled = true;
211     bool public swapAndLiquifyByLimitOnly = false;
212 
213     uint256 public swapThreshold = _totalSupply * 4 / 2000;
214 
215     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
216 
217     modifier lockTheSwap {
218         inSwapAndLiquify = true;
219         _;
220         inSwapAndLiquify = false;
221     }
222 
223     constructor() {
224         router = UniswapRouter(uniswapAddress);
225         pair = UniswapFactory(router.factory()).createPair(router.WETH(), address(this));
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
237         autoLiquidityReceiver = 0x0f9F3Fc64A6f02Bd77090dD4AD3a85b6fDe51E6B;
238         marketingWallet = 0x1F50Bd5fb8398cFE19eBD61c536566A1153033de;
239 
240         totalFee = liquidityFee.add(marketingFee);
241         totalFeeIfSelling = totalFee;
242 
243         _balances[msg.sender] = _totalSupply;
244         emit Transfer(address(0), msg.sender, _totalSupply);
245     }
246 
247     receive() external payable {}
248 
249     function name() external pure override returns (string memory) {return _name;}
250 
251     function symbol() external pure override returns (string memory) {return _symbol;}
252 
253     function decimals() external pure override returns (uint8) {return _decimals;}
254 
255     function totalSupply() external view override returns (uint256) {return _totalSupply;}
256 
257     function getOwner() external view override returns (address) {return owner();}
258 
259     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
260 
261     function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}
262 
263     function getCirculatingSupply() public view returns (uint256) {
264         return _totalSupply.sub(balanceOf(DEAD_WALLET)).sub(balanceOf(ZERO_WALLET));
265     }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _allowances[msg.sender][spender] = amount;
269         emit Approval(msg.sender, spender, amount);
270         return true;
271     }
272 
273     function approveMax(address spender) external returns (bool) {
274         return approve(spender, type(uint256).max);
275     }
276 
277     function launched() internal view returns (bool) {
278         return launchedAt != 0;
279     }
280 
281     function launch() internal {
282         launchedAt = block.number;
283     }
284 
285     function checkTxLimit(address sender, uint256 amount) internal view {
286         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
287     }
288 
289     function transfer(address recipient, uint256 amount) external override returns (bool) {
290         return _transferFrom(msg.sender, recipient, amount);
291     }
292 
293     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
294         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
295         _balances[recipient] = _balances[recipient].add(amount);
296         emit Transfer(sender, recipient, amount);
297         return true;
298     }
299 
300     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
301         if (_allowances[sender][msg.sender] != type(uint256).max) {
302             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
303         }
304         return _transferFrom(sender, recipient, amount);
305     }
306 
307     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
308         if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}
309         if(!authorizations[sender] && !authorizations[recipient]){
310             require(tradingOpen, "Trading not open yet");
311         }
312 
313         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
314         if (msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {marketingAndLiquidity();}
315         if (!launched() && recipient == pair) {
316             require(_balances[sender] > 0, "Zero balance violated!");
317             launch();
318         }    
319 
320         // Blacklist
321         if (blacklistMode) {
322             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
323         }
324 
325         //Exchange tokens
326          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
327 
328         if (!isTxLimitExempt[recipient] && restrictWhales) {
329             require(_balances[recipient].add(amount) <= _walletMax, "Max wallet violated!");
330         }
331 
332         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, recipient, amount) : amount;
333         _balances[recipient] = _balances[recipient].add(finalAmount);
334 
335         emit Transfer(sender, recipient, finalAmount);
336         return true;
337     }
338 
339     function extractFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
340         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
341         uint256 feeAmount = amount.mul(feeApplicable).div(100);
342 
343         _balances[address(this)] = _balances[address(this)].add(feeAmount);
344         emit Transfer(sender, address(this), feeAmount);
345 
346         return amount.sub(feeAmount);
347     }
348 
349     function marketingAndLiquidity() internal lockTheSwap {
350         uint256 tokensToLiquify = _balances[address(this)];
351         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
352         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
353 
354         address[] memory path = new address[](2);
355         path[0] = address(this);
356         path[1] = router.WETH();
357 
358         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             amountToSwap,
360             0,
361             path,
362             address(this),
363             block.timestamp
364         );
365 
366         uint256 amountETH = address(this).balance;
367 
368         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
369 
370         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
371         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
372 
373         (bool tmpSuccess,) = payable(marketingWallet).call{value : amountETHMarketing, gas : 30000}("");
374         tmpSuccess = false;
375 
376         if (amountToLiquify > 0) {
377             router.addLiquidityETH{value : amountETHLiquidity}(
378                 address(this),
379                 amountToLiquify,
380                 0,
381                 0,
382                 autoLiquidityReceiver,
383                 block.timestamp
384             );
385             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
386         }
387     }
388 
389     // CONTRACT OWNER FUNCTIONS
390 
391     function setWalletLimit(uint256 newLimit) external onlyOwner {
392         _walletMax = newLimit;
393     }
394 
395     function tradingStatus(bool newStatus) public onlyOwner {
396         tradingOpen = newStatus;
397     }
398 
399     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
400         isFeeExempt[holder] = exempt;
401     }
402 
403     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
404         isTxLimitExempt[holder] = exempt;
405     }
406 
407     function setFees(uint256 newLiqFee, uint256 newmarketingFee) external onlyOwner {
408         liquidityFee = newLiqFee;
409         marketingFee = newmarketingFee;
410 
411         totalFee = liquidityFee.add(marketingFee);
412         totalFeeIfSelling = totalFee;
413     }
414 
415         function enable_blacklist(bool _status) public onlyOwner {
416     blacklistMode = _status;
417     }
418 
419         
420     function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
421         for (uint256 i; i < addresses.length; ++i) {
422             isBlacklisted[addresses[i]] = status;
423         }
424     }
425 
426 }