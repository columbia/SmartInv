1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 //website: https://socialcreditscore.vip/
6 
7 //telegram: https://t.me/SocialCreditScoreSCS
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
157 contract SCS is IERC20, Auth {
158     using SafeMath for uint256;
159 
160     address private WETH;
161 
162     string private constant  _name = "Social Credit Score";
163     string private constant _symbol = "SCS";
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
176     uint256 public buyFee = 18;
177     uint256 public sellFee = 18;
178     uint256 private feeDenominator = 100;
179 
180     address payable public teamWallet = payable(0xBC78F3926bA659425b8300080D8d6991447ed8c7);
181     uint256 public swapThresholdAmount = 10000000000 * (10**_decimals);
182 
183     IDEXRouter public router;
184     address public pair;
185 
186     uint256 public launchedAt;
187     bool private tradingOpen;
188     bool private buyLimit = true;
189     uint256 private maxBuy = 10000000001 * (10 ** _decimals);
190     
191 
192     bool public blacklistEnabled = false;
193     bool private inSwap;
194     modifier swapping() { inSwap = true; _; inSwap = false; }
195 
196     constructor (
197         address _owner
198     ) Auth(_owner) {
199         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);        
200         WETH = router.WETH();        
201         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
202         approve(address(router), type(uint).max);
203         IERC20(pair).approve(address(router), type(uint).max);  
204         
205         _allowances[address(this)][address(router)] = type(uint256).max;
206 
207         isFeeExempt[_owner] = true;
208         isFeeExempt[teamWallet] = true; 
209         isFeeExempt[address(this)] = true;            
210         
211         isBot[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
212 
213         _balances[_owner] = _totalSupply;
214     
215         emit Transfer(address(0), _owner, _totalSupply);
216     }
217 
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
252         if (!tradingOpen) {
253             require (sender == owner ||  sender == address (this));
254             return _basicTransfer(sender, recipient, amount);
255         }
256         
257         if (blacklistEnabled) {
258             require (!isBot[sender] && !isBot[recipient], "Bot!");
259         }
260         if (buyLimit) { 
261             require (amount<=maxBuy, "Too much sir");        
262         }
263 
264         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
265             require (cooldown[recipient] < block.timestamp);
266             cooldown[recipient] = block.timestamp + 60 seconds;
267             if (block.number <= (launchedAt + 1)) { 
268                 isBot[recipient] = true;
269             }
270         }        
271        
272         if(inSwap){ return _basicTransfer(sender, recipient, amount); }    
273 
274         uint256 contractTokenBalance = balanceOf(address(this));
275 
276         bool overMinTokenBalance = contractTokenBalance >= swapThresholdAmount;
277     
278         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
279         if(shouldSwapBack){ swapBack(); }  
280 
281         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
282 
283         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
284         
285         _balances[recipient] = _balances[recipient].add(amountReceived);
286 
287         emit Transfer(sender, recipient, amountReceived);
288         return true;
289     }
290     
291     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
292         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
293         _balances[recipient] = _balances[recipient].add(amount);
294         emit Transfer(sender, recipient, amount);
295         return true;
296     }
297 
298  
299     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
300         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
301    }
302 
303     function takeFee(address sender, uint256 amount) internal returns (uint256) {
304         uint256 feeAmount;
305         if(sender != pair) {
306             feeAmount = amount.mul(sellFee).div(feeDenominator);
307         }
308         else {
309             feeAmount = amount.mul(buyFee).div(feeDenominator);
310         }
311         _balances[address(this)] = _balances[address(this)].add(feeAmount);
312         emit Transfer(sender, address(this), feeAmount);   
313 
314         return amount.sub(feeAmount);
315     }
316 
317    
318 function swapBack() internal swapping {
319         uint256 contractTokenBalance = balanceOf(address(this));
320 
321         uint256 amountToSwap;
322 
323         if (contractTokenBalance >= swapThresholdAmount) {
324             amountToSwap = swapThresholdAmount;
325         }
326             else {
327                 amountToSwap = contractTokenBalance;
328         }
329               
330         swapTokensForEth(amountToSwap);
331 
332         uint256 contractETHBalance = address(this).balance;
333              
334         payable(teamWallet).transfer(contractETHBalance);          
335     }
336 
337     
338 
339     function swapTokensForEth(uint256 tokenAmount) private {
340 
341         // generate the uniswap pair path of token -> weth
342         address[] memory path = new address[](2);
343         path[0] = address(this);
344         path[1] = WETH;
345 
346         // make the swap
347         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
348             tokenAmount,
349             0, // accept any amount of ETH
350             path,
351             address(this),
352             block.timestamp
353         );
354     }
355 
356     
357     function launch() external onlyOwner {
358       
359         router.addLiquidityETH{value: address(this).balance}(
360             address(this),
361             balanceOf(address(this)),
362             0, // slippage is unavoidable
363             0, // slippage is unavoidable
364             owner,
365             block.timestamp
366         );       
367 
368         launchedAt = block.number;
369         tradingOpen = true;
370     }    
371 
372     function removeBuyLimit() external onlyOwner {
373         buyLimit = false;
374     }
375 
376     function setBuyFee (uint256 _fee) external onlyOwner {
377         require(buyFee != 0); //once set to 0, fee can't be increased
378         buyFee = _fee;
379     }
380 
381      function setSellFee (uint256 _fee) external onlyOwner {
382         require(sellFee != 0); //once set to 0, fee can't be increased
383         sellFee = _fee;
384     }   
385 
386     function setTeamWallet(address _teamWallet) external onlyOwner {
387         teamWallet = payable(_teamWallet);
388     } 
389 
390     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
391         isFeeExempt[holder] = exempt;
392     }
393 
394     function setBlacklistEnabled() external onlyOwner {
395         require (blacklistEnabled == false, "can only be called once");
396         blacklistEnabled = true;
397     }
398     
399     function setBot(address _address, bool toggle) public onlyOwner {
400         isBot[_address] = toggle;
401     }
402 
403     function checkBot(address account) public view returns (bool) {
404         return isBot[account];
405     }
406 
407     function blacklistArray (address[] calldata bots) external onlyOwner {
408         require (bots.length > 0);
409         uint i =0;
410         while (i < bots.length) {
411             setBot(bots[i],  true);
412             i++;
413         }
414     }
415 
416     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
417         swapThresholdAmount = _totalSupply.mul(amount).div(1000);
418     } 
419   
420     function manualSend() external onlyOwner {
421         uint256 contractETHBalance = address(this).balance;
422         payable(teamWallet).transfer(contractETHBalance);
423     }
424   
425 }