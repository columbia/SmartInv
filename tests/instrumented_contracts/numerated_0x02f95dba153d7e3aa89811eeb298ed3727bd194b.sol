1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * Standard SafeMath, stripped down to just add/sub/mul/div
7  */
8 library SafeMath {
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         // Solidity only automatically asserts when dividing by 0
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 }
46 
47 /**
48  * ERC20 standard interface.
49  */
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * Allows for contract ownership along with multi-address authorization
67  */
68 abstract contract Auth {
69     address internal owner;
70 
71     constructor(address _owner) {
72         owner = _owner;
73     }
74 
75     /**
76      * Function modifier to require caller to be contract deployer
77      */
78     modifier onlyOwner() {
79         require(isOwner(msg.sender), "!Owner"); _;
80     }
81 
82     /**
83      * Check if address is owner
84      */
85     function isOwner(address account) public view returns (bool) {
86         return account == owner;
87     }
88 
89     /**
90      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
91      */
92     function transferOwnership(address payable adr) public onlyOwner {
93         owner = adr;
94         emit OwnershipTransferred(adr);
95     }
96 
97     event OwnershipTransferred(address owner);
98 }
99 
100 interface IDEXFactory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IDEXRouter {
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107 
108     function addLiquidity(
109         address tokenA,
110         address tokenB,
111         uint amountADesired,
112         uint amountBDesired,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB, uint liquidity);
118 
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 
128     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 
136     function swapExactETHForTokensSupportingFeeOnTransferTokens(
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external payable;
142 
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 interface StakingContract {
153     function checkTime() external;
154 }
155 
156 contract BBCGame is IERC20, Auth {
157     using SafeMath for uint256;
158 
159     address private WETH;
160     address private ZERO = 0x0000000000000000000000000000000000000000;
161 
162 
163     string private constant  _name = "BBC Game";
164     string private constant _symbol = "BBC";
165     uint8 public constant _decimals = 18;
166 
167     uint256 private _totalSupply = 1000000000 * (10 ** _decimals); 
168 
169     mapping (address => uint256) private _balances;
170     mapping (address => mapping (address => uint256)) private _allowances;
171     mapping (address => uint256) private cooldown;
172 
173     mapping (address => bool) private isFeeExempt;
174     mapping (address => bool) private isBot;
175             
176     uint256 public buyFee = 7;
177     uint256 public sellFee = 25;
178     uint256 private feeDenominator = 100;
179 
180     address payable public teamWallet = payable(0x657f05797256A4527c33dc6fa2D8d07cddBFbf88);
181     address payable public prizeWallet = payable(0x27B0E428911bBbC3C3f58c166F1ea91aAcAF1B27); 
182 
183     IDEXRouter public router;
184     address public pair;
185 
186     uint256 public launchedAt;
187     bool private tradingOpen;
188     bool private buyLimit = true;
189     uint256 private maxBuy = 4000001 * (10 ** _decimals);
190     uint256 public swapThresholdAmount = 10000000 * (10**_decimals);
191 
192     StakingContract public stakingContract; 
193     
194     bool public blacklistEnabled = false;
195     bool private inSwap;
196     modifier swapping() { inSwap = true; _; inSwap = false; }
197 
198     constructor (
199         address _owner
200     ) Auth(_owner) {
201         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);        
202         WETH = router.WETH();        
203         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
204         approve(address(router), type(uint).max);
205         IERC20(pair).approve(address(router), type(uint).max);  
206         
207         _allowances[address(this)][address(router)] = type(uint256).max;
208 
209         isFeeExempt[_owner] = true;
210         isFeeExempt[teamWallet] = true; 
211         isFeeExempt[address(this)] = true;            
212                     
213 
214         _balances[_owner] = _totalSupply;
215     
216         emit Transfer(address(0), _owner, _totalSupply);
217     }
218 
219 
220     receive() external payable { }
221 
222     function totalSupply() external view override returns (uint256) { return _totalSupply; }
223     function decimals() external pure override returns (uint8) { return _decimals; }
224     function symbol() external pure override returns (string memory) { return _symbol; }
225     function name() external pure override returns (string memory) { return _name; }
226     function getOwner() external view override returns (address) { return owner; }
227     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
228     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
229 
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _allowances[msg.sender][spender] = amount;
232         emit Approval(msg.sender, spender, amount);
233         return true;
234     }
235 
236     function approveMax(address spender) external returns (bool) {
237         return approve(spender, type(uint256).max);
238     }
239 
240     function transfer(address recipient, uint256 amount) external override returns (bool) {
241         return _transferFrom(msg.sender, recipient, amount);
242     }
243 
244     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
245         if(_allowances[sender][msg.sender] != type(uint256).max){
246             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
247         }
248 
249         return _transferFrom(sender, recipient, amount);
250     }
251 
252     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
253         if (!tradingOpen) {
254             require (sender == owner ||  sender == address (this));
255             return _basicTransfer(sender, recipient, amount);
256         }
257         
258         if (blacklistEnabled) {
259             require (!isBot[sender] && !isBot[recipient], "Bot!");
260         }
261         if (buyLimit) { 
262             require (amount<=maxBuy, "Too much sir");        
263         }
264 
265         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
266             require (cooldown[recipient] < block.timestamp);
267             cooldown[recipient] = block.timestamp + 60 seconds;
268             if (block.number <= (launchedAt + 1)) { 
269                 isBot[recipient] = true;
270             }
271         }
272        
273         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
274 
275         uint256 contractTokenBalance = balanceOf(address(this));
276 
277         bool overMinTokenBalance = contractTokenBalance >= swapThresholdAmount;
278     
279         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
280         if(shouldSwapBack){ swapBack(); }
281 
282         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
283 
284         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
285         
286         _balances[recipient] = _balances[recipient].add(amountReceived);
287 
288         if  (address(stakingContract) != address(0)) {
289             stakingContract.checkTime();
290         }
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
323     function swapBack() internal swapping {
324 
325         uint256 amountToSwap = balanceOf(address(this));        
326 
327         swapTokensForEth(amountToSwap);
328 
329         uint256 contractETHBalance = address(this).balance;
330              
331         payable(teamWallet).transfer(contractETHBalance.div(2));
332         payable(prizeWallet).transfer(contractETHBalance.div(2));             
333     }
334 
335     
336 
337     function swapTokensForEth(uint256 tokenAmount) private {
338 
339         // generate the uniswap pair path of token -> weth
340         address[] memory path = new address[](2);
341         path[0] = address(this);
342         path[1] = WETH;
343 
344         // make the swap
345         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
346             tokenAmount,
347             0, // accept any amount of ETH
348             path,
349             address(this),
350             block.timestamp
351         );
352     }
353 
354     
355     function haveFun() external onlyOwner {
356       
357         router.addLiquidityETH{value: address(this).balance}(
358             address(this),
359             balanceOf(address(this)),
360             0, // slippage is unavoidable
361             0, // slippage is unavoidable
362             owner,
363             block.timestamp
364         );       
365 
366         launchedAt = block.number;
367         tradingOpen = true;
368     }    
369 
370     function removeBuyLimit() external onlyOwner {
371         buyLimit = false;
372     }
373 
374     function setBuyFee (uint256 _fee) external onlyOwner {
375         require (_fee <= 25, "Fee can't exceed 14%");
376         buyFee = _fee;
377     }
378 
379      function setSellFee (uint256 _fee) external onlyOwner {
380         require (_fee <= 10, "Fee can't exceed 14%");
381         sellFee = _fee;
382     }  
383 
384     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
385         require (amount <= _totalSupply.div(100), "can't exceed 1%");
386         swapThresholdAmount = amount * 10 ** _decimals;
387     } 
388 
389     function setTeamWallet(address _teamWallet) external onlyOwner {
390         teamWallet = payable(_teamWallet);
391     } 
392 
393     function setPrizeWallet(address _prizeWallet) external onlyOwner {
394         prizeWallet = payable(_prizeWallet);
395     } 
396 
397     function setStakingContract (address _stakingContractAddress) external onlyOwner {
398         stakingContract =  StakingContract(_stakingContractAddress);
399     }
400 
401     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
402         isFeeExempt[holder] = exempt;
403     }
404 
405     function setBlacklistEnabled() external onlyOwner {
406         require (blacklistEnabled == false, "can only be called once");
407         blacklistEnabled = true;
408     }
409     
410     function setBot(address _address, bool toggle) public onlyOwner {
411         isBot[_address] = toggle;
412     }
413 
414     function checkBot(address account) public view returns (bool) {
415         return isBot[account];
416     }
417 
418     function blacklistArray (address[] calldata bots) external onlyOwner {
419         require (bots.length > 0);
420         uint i =0;
421         while (i < bots.length) {
422             setBot(bots[i],  true);
423             i++;
424         }
425     }
426   
427     function manualSend() external onlyOwner {
428         uint256 contractETHBalance = address(this).balance;
429         payable(teamWallet).transfer(contractETHBalance);
430     }
431     
432 }