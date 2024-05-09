1 // SPDX-License-Identifier: Unlicensed
2 
3 // Telegram: https://t.me/AlpacaERC
4 
5 // Website: https://alpacalypse.vip
6 
7 pragma solidity ^0.8.0;
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
74 
75     constructor(address _owner) {
76         owner = _owner;
77     }
78 
79     /**
80      * Function modifier to require caller to be contract deployer
81      */
82     modifier onlyOwner() {
83         require(isOwner(msg.sender), "!Owner"); _;
84     }
85 
86     /**
87      * Check if address is owner
88      */
89     function isOwner(address account) public view returns (bool) {
90         return account == owner;
91     }
92 
93     /**
94      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
95      */
96     function transferOwnership(address payable adr) public onlyOwner {
97         owner = adr;
98         emit OwnershipTransferred(adr);
99     }
100 
101     event OwnershipTransferred(address owner);
102 }
103 
104 interface IDEXFactory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IDEXRouter {
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111 
112     function addLiquidity(
113         address tokenA,
114         address tokenB,
115         uint amountADesired,
116         uint amountBDesired,
117         uint amountAMin,
118         uint amountBMin,
119         address to,
120         uint deadline
121     ) external returns (uint amountA, uint amountB, uint liquidity);
122 
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 
132     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 
140     function swapExactETHForTokensSupportingFeeOnTransferTokens(
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external payable;
146 
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 }
155 
156 
157 contract Alpaca is IERC20, Auth {
158     using SafeMath for uint256;
159 
160     address private WETH;
161 
162     string private constant  _name = "Alpaca";
163     string private constant _symbol = "ALPACA";
164     uint8 public constant _decimals = 18;
165 
166     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals); 
167 
168     mapping (address => uint256) private _balances;
169     mapping (address => mapping (address => uint256)) private _allowances;
170     mapping (address => uint256) private cooldown;
171     mapping (address => int) public tickets;
172 
173     mapping (address => bool) private isFeeExempt;
174     mapping (address => bool) private isBot;
175 
176     address immutable DEAD = 0x000000000000000000000000000000000000dEaD;
177             
178     uint256 public buyFee = 15;
179     uint256 public sellFee = 15;
180     uint256 private feeDenominator = 100;
181 
182     address payable public teamWallet = payable(0xBe00D29Af3462dA8f788DF22bC26Df4A23130Fa7);
183     uint256 public swapThresholdAmount = 10000000000 * (10**_decimals);
184 
185     IDEXRouter public router;
186     address public pair;
187 
188     uint256 public launchedAt;
189     bool private tradingOpen;
190     bool private buyLimit = true;
191     uint256 private maxBuy = 10000000001 * (10 ** _decimals);
192 
193     uint256 public burnAmount = 5000000 * (10 ** _decimals);
194     uint256 public breeded = 0;
195     
196 
197     bool public blacklistEnabled = false;
198     bool private inSwap;
199     modifier swapping() { inSwap = true; _; inSwap = false; }
200 
201     constructor (
202         address _owner
203     ) Auth(_owner) {
204         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);        
205         WETH = router.WETH();        
206         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
207         approve(address(router), type(uint).max);
208         IERC20(pair).approve(address(router), type(uint).max);  
209         
210         _allowances[address(this)][address(router)] = type(uint256).max;
211 
212         isFeeExempt[_owner] = true;
213         isFeeExempt[teamWallet] = true; 
214         isFeeExempt[address(this)] = true;            
215         
216         isBot[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
217 
218         _balances[_owner] = _totalSupply;
219     
220         emit Transfer(address(0), _owner, _totalSupply);
221     }
222 
223 
224     receive() external payable { }
225 
226     function totalSupply() external view override returns (uint256) { return _totalSupply; }
227     function decimals() external pure override returns (uint8) { return _decimals; }
228     function symbol() external pure override returns (string memory) { return _symbol; }
229     function name() external pure override returns (string memory) { return _name; }
230     function getOwner() external view override returns (address) { return owner; }
231     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
232     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
233 
234     function approve(address spender, uint256 amount) public override returns (bool) {
235         _allowances[msg.sender][spender] = amount;
236         emit Approval(msg.sender, spender, amount);
237         return true;
238     }
239 
240     function approveMax(address spender) external returns (bool) {
241         return approve(spender, type(uint256).max);
242     }
243 
244     function transfer(address recipient, uint256 amount) external override returns (bool) {
245         return _transferFrom(msg.sender, recipient, amount);
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
249         if(_allowances[sender][msg.sender] != type(uint256).max){
250             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
251         }
252 
253         return _transferFrom(sender, recipient, amount);
254     }
255 
256     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
257         if (!tradingOpen) {
258             require (sender == owner ||  sender == address (this));
259             return _basicTransfer(sender, recipient, amount);
260         }
261         
262         if (blacklistEnabled) {
263             require (!isBot[sender] && !isBot[recipient], "Bot!");
264         }
265         if (buyLimit) { 
266             require (amount<=maxBuy, "Too much sir");        
267         }
268 
269         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
270             require (cooldown[recipient] < block.timestamp);
271             cooldown[recipient] = block.timestamp + 60 seconds;
272             if (block.number <= (launchedAt + 1)) { 
273                 isBot[recipient] = true;
274             }
275         }        
276        
277         if(inSwap){ return _basicTransfer(sender, recipient, amount); }    
278 
279         uint256 contractTokenBalance = balanceOf(address(this));
280 
281         bool overMinTokenBalance = contractTokenBalance >= swapThresholdAmount;
282     
283         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
284         if(shouldSwapBack){ swapBack(); }  
285 
286         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
287 
288         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
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
303  
304     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
305         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
306    }
307 
308     function takeFee(address sender, uint256 amount) internal returns (uint256) {
309         uint256 feeAmount;
310         if(sender != pair) {
311             feeAmount = amount.mul(sellFee).div(feeDenominator);
312         }
313         else {
314             feeAmount = amount.mul(buyFee).div(feeDenominator);
315         }
316         _balances[address(this)] = _balances[address(this)].add(feeAmount);
317         emit Transfer(sender, address(this), feeAmount);   
318 
319         return amount.sub(feeAmount);
320     }
321 
322    
323 function swapBack() internal swapping {
324         uint256 contractTokenBalance = balanceOf(address(this));
325 
326         uint256 amountToSwap;
327 
328         if (contractTokenBalance >= swapThresholdAmount) {
329             amountToSwap = swapThresholdAmount;
330         }
331             else {
332                 amountToSwap = contractTokenBalance;
333         }
334               
335         swapTokensForEth(amountToSwap);
336 
337         uint256 contractETHBalance = address(this).balance;
338              
339         payable(teamWallet).transfer(contractETHBalance);          
340     }
341 
342     
343 
344     function swapTokensForEth(uint256 tokenAmount) private {
345 
346         // generate the uniswap pair path of token -> weth
347         address[] memory path = new address[](2);
348         path[0] = address(this);
349         path[1] = WETH;
350 
351         // make the swap
352         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
353             tokenAmount,
354             0, // accept any amount of ETH
355             path,
356             address(this),
357             block.timestamp
358         );
359     }
360 
361     
362     function openTrading() external onlyOwner {
363       
364         router.addLiquidityETH{value: address(this).balance}(
365             address(this),
366             balanceOf(address(this)),
367             0, // slippage is unavoidable
368             0, // slippage is unavoidable
369             owner,
370             block.timestamp
371         );       
372 
373         launchedAt = block.number;
374         tradingOpen = true;
375     }    
376 
377     function removeBuyLimit() external onlyOwner {
378         buyLimit = false;
379     }
380 
381     function setBuyFee (uint256 _fee) external onlyOwner {
382         require(buyFee != 0); //once set to 0, fee can't be increased
383         buyFee = _fee;
384     }
385 
386      function setSellFee (uint256 _fee) external onlyOwner {
387         require(sellFee != 0); //once set to 0, fee can't be increased
388         sellFee = _fee;
389     }   
390 
391     function setTeamWallet(address _teamWallet) external onlyOwner {
392         teamWallet = payable(_teamWallet);
393     } 
394 
395     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
396         isFeeExempt[holder] = exempt;
397     }
398 
399     function setBlacklistEnabled() external onlyOwner {
400         require (blacklistEnabled == false, "can only be called once");
401         blacklistEnabled = true;
402     }
403     
404     function setBot(address _address, bool toggle) public onlyOwner {
405         isBot[_address] = toggle;
406     }
407 
408     function checkBot(address account) public view returns (bool) {
409         return isBot[account];
410     }
411 
412     function blacklistArray (address[] calldata bots) external onlyOwner {
413         require (bots.length > 0);
414         uint i =0;
415         while (i < bots.length) {
416             setBot(bots[i],  true);
417             i++;
418         }
419     }
420 
421     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
422         swapThresholdAmount = _totalSupply.mul(amount).div(1000);
423     } 
424   
425     function manualSend() external onlyOwner {
426         uint256 contractETHBalance = address(this).balance;
427         payable(teamWallet).transfer(contractETHBalance);
428     }
429 
430     function breed() external {
431         require(balanceOf(msg.sender)>=burnAmount);
432         _basicTransfer(msg.sender,DEAD,burnAmount);
433         breeded++;
434     }
435 
436     function setBurnAmount(uint256 newAmount) external onlyOwner {
437         burnAmount = newAmount * (10 ** _decimals);
438     }
439   
440 }