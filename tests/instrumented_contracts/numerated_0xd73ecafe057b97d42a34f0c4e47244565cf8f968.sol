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
152 
153 contract PepElon is IERC20, Auth {
154     using SafeMath for uint256;
155 
156     address private WETH;
157 
158     string private constant  _name = "PepElon Mars";
159     string private constant _symbol = "PELON";
160     uint8 public constant _decimals = 18;
161 
162     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals); 
163 
164     mapping (address => uint256) private _balances;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => uint256) private cooldown;
167     mapping (address => int) public tickets;
168 
169     mapping (address => bool) private isFeeExempt;
170     mapping (address => bool) private isBot;
171             
172     uint256 public buyFee = 15;
173     uint256 public sellFee = 15;
174     uint256 private feeDenominator = 100;
175 
176     address payable public teamWallet = payable(0xDd3cCE6625eD8933066d2425d1c0f11924C825CA);
177     uint256 public swapThresholdAmount = 10000000000 * (10**_decimals);
178 
179     IDEXRouter public router;
180     address public pair;
181 
182     uint256 public launchedAt;
183     bool private tradingOpen;
184     bool private buyLimit = true;
185     uint256 private maxBuy = 10000000001 * (10 ** _decimals);
186     
187 
188     bool public blacklistEnabled = false;
189     bool private inSwap;
190     modifier swapping() { inSwap = true; _; inSwap = false; }
191 
192     constructor (
193         address _owner
194     ) Auth(_owner) {
195         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);        
196         WETH = router.WETH();        
197         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
198         approve(address(router), type(uint).max);
199         IERC20(pair).approve(address(router), type(uint).max);  
200         
201         _allowances[address(this)][address(router)] = type(uint256).max;
202 
203         isFeeExempt[_owner] = true;
204         isFeeExempt[teamWallet] = true; 
205         isFeeExempt[address(this)] = true;            
206         
207         isBot[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
208 
209         _balances[_owner] = _totalSupply;
210     
211         emit Transfer(address(0), _owner, _totalSupply);
212     }
213 
214 
215     receive() external payable { }
216 
217     function totalSupply() external view override returns (uint256) { return _totalSupply; }
218     function decimals() external pure override returns (uint8) { return _decimals; }
219     function symbol() external pure override returns (string memory) { return _symbol; }
220     function name() external pure override returns (string memory) { return _name; }
221     function getOwner() external view override returns (address) { return owner; }
222     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
223     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
224 
225     function approve(address spender, uint256 amount) public override returns (bool) {
226         _allowances[msg.sender][spender] = amount;
227         emit Approval(msg.sender, spender, amount);
228         return true;
229     }
230 
231     function approveMax(address spender) external returns (bool) {
232         return approve(spender, type(uint256).max);
233     }
234 
235     function transfer(address recipient, uint256 amount) external override returns (bool) {
236         return _transferFrom(msg.sender, recipient, amount);
237     }
238 
239     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
240         if(_allowances[sender][msg.sender] != type(uint256).max){
241             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
242         }
243 
244         return _transferFrom(sender, recipient, amount);
245     }
246 
247     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
248         if (!tradingOpen) {
249             require (sender == owner ||  sender == address (this));
250             return _basicTransfer(sender, recipient, amount);
251         }
252         
253         if (blacklistEnabled) {
254             require (!isBot[sender] && !isBot[recipient], "Bot!");
255         }
256         if (buyLimit) { 
257             require (amount<=maxBuy, "Too much sir");        
258         }
259 
260         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
261             require (cooldown[recipient] < block.timestamp);
262             cooldown[recipient] = block.timestamp + 60 seconds;
263             if (block.number <= (launchedAt + 1)) { 
264                 isBot[recipient] = true;
265             }
266         }        
267        
268         if(inSwap){ return _basicTransfer(sender, recipient, amount); }    
269 
270         uint256 contractTokenBalance = balanceOf(address(this));
271 
272         bool overMinTokenBalance = contractTokenBalance >= swapThresholdAmount;
273     
274         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
275         if(shouldSwapBack){ swapBack(); }  
276 
277         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
278 
279         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
280         
281         _balances[recipient] = _balances[recipient].add(amountReceived);
282 
283         emit Transfer(sender, recipient, amountReceived);
284         return true;
285     }
286     
287     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
288         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
289         _balances[recipient] = _balances[recipient].add(amount);
290         emit Transfer(sender, recipient, amount);
291         return true;
292     }
293 
294  
295     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
296         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
297    }
298 
299     function takeFee(address sender, uint256 amount) internal returns (uint256) {
300         uint256 feeAmount;
301         if(sender != pair) {
302             feeAmount = amount.mul(sellFee).div(feeDenominator);
303         }
304         else {
305             feeAmount = amount.mul(buyFee).div(feeDenominator);
306         }
307         _balances[address(this)] = _balances[address(this)].add(feeAmount);
308         emit Transfer(sender, address(this), feeAmount);   
309 
310         return amount.sub(feeAmount);
311     }
312 
313    
314 function swapBack() internal swapping {
315         uint256 contractTokenBalance = balanceOf(address(this));
316 
317         uint256 amountToSwap;
318 
319         if (contractTokenBalance >= swapThresholdAmount) {
320             amountToSwap = swapThresholdAmount;
321         }
322             else {
323                 amountToSwap = contractTokenBalance;
324         }
325               
326         swapTokensForEth(amountToSwap);
327 
328         uint256 contractETHBalance = address(this).balance;
329              
330         payable(teamWallet).transfer(contractETHBalance);          
331     }
332 
333     
334 
335     function swapTokensForEth(uint256 tokenAmount) private {
336 
337         // generate the uniswap pair path of token -> weth
338         address[] memory path = new address[](2);
339         path[0] = address(this);
340         path[1] = WETH;
341 
342         // make the swap
343         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
344             tokenAmount,
345             0, // accept any amount of ETH
346             path,
347             address(this),
348             block.timestamp
349         );
350     }
351 
352     
353     function toTheMars() external onlyOwner {
354       
355         router.addLiquidityETH{value: address(this).balance}(
356             address(this),
357             balanceOf(address(this)),
358             0, // slippage is unavoidable
359             0, // slippage is unavoidable
360             owner,
361             block.timestamp
362         );       
363 
364         launchedAt = block.number;
365         tradingOpen = true;
366     }    
367 
368     function removeBuyLimit() external onlyOwner {
369         buyLimit = false;
370     }
371 
372     function setBuyFee (uint256 _fee) external onlyOwner {
373         require(buyFee != 0); //once set to 0, fee can't be increased
374         buyFee = _fee;
375     }
376 
377      function setSellFee (uint256 _fee) external onlyOwner {
378         require(sellFee != 0); //once set to 0, fee can't be increased
379         sellFee = _fee;
380     }   
381 
382     function setTeamWallet(address _teamWallet) external onlyOwner {
383         teamWallet = payable(_teamWallet);
384     } 
385 
386     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
387         isFeeExempt[holder] = exempt;
388     }
389 
390     function setBlacklistEnabled() external onlyOwner {
391         require (blacklistEnabled == false, "can only be called once");
392         blacklistEnabled = true;
393     }
394     
395     function setBot(address _address, bool toggle) public onlyOwner {
396         isBot[_address] = toggle;
397     }
398 
399     function checkBot(address account) public view returns (bool) {
400         return isBot[account];
401     }
402 
403     function blacklistArray (address[] calldata bots) external onlyOwner {
404         require (bots.length > 0);
405         uint i =0;
406         while (i < bots.length) {
407             setBot(bots[i],  true);
408             i++;
409         }
410     }
411 
412     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
413         swapThresholdAmount = _totalSupply.mul(amount).div(1000);
414     } 
415   
416     function manualSend() external onlyOwner {
417         uint256 contractETHBalance = address(this).balance;
418         payable(teamWallet).transfer(contractETHBalance);
419     }
420   
421 }