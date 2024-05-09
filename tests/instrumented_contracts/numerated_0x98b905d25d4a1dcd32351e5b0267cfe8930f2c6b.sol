1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-07
3 */
4 
5 /**
6 
7 
8 ITS BULLISH ILL DO 1/1 TAX FOR STOP FRONTRUN AND WILL DO BUYBACK.
9 
10 Elon TWEET: https://twitter.com/elonmusk/status/1584173256415723521
11 
12 
13 
14 
15 
16 
17 /**
18 
19 
20 */
21 // SPDX-License-Identifier: MIT
22 pragma solidity ^0.8.11;
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         return c;
52     }
53 }
54 
55 interface ERC20 {
56     function totalSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 abstract contract Ownable {
71     address internal owner;
72     constructor(address _owner) {
73         owner = _owner;
74     }
75     modifier onlyOwner() {
76         require(isOwner(msg.sender), "!OWNER"); _;
77     }
78     function isOwner(address account) public view returns (bool) {
79         return account == owner;
80     }
81     function renounceOwnership() public onlyOwner {
82         owner = address(0);
83         emit OwnershipTransferred(address(0));
84     }  
85     event OwnershipTransferred(address owner);
86 }
87 
88 interface IDEXFactory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IDEXRouter {
93     function factory() external pure returns (address);
94     function WETH() external pure returns (address);
95     function addLiquidity(
96         address tokenA,
97         address tokenB,
98         uint amountADesired,
99         uint amountBDesired,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline
104     ) external returns (uint amountA, uint amountB, uint liquidity);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function swapExactETHForTokensSupportingFeeOnTransferTokens(
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external payable;
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133 }
134 
135 contract ELON is ERC20, Ownable {
136     using SafeMath for uint256;
137     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //UNISWAP
138     address DEAD = 0x000000000000000000000000000000000000dEaD;
139 
140     string constant _name = "The Current Thing";
141     string constant _symbol = "$CURRENT";
142     uint8 constant _decimals = 9;
143 
144     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
145     uint256 public _maxWalletAmount = _totalSupply * 2 / 100;
146 
147     mapping (address => uint256) _balances;
148     mapping (address => mapping (address => uint256)) _allowances;
149 
150     mapping (address => bool) isFeeExempt;
151     mapping (address => bool) isTxLimitExempt;
152     mapping(address => bool) public isBot;
153 
154     uint256 marketingFee = 5;
155     uint256 sellMarketingFee = 5;
156 
157     uint256 feeDenominator = 100;
158 
159     address public marketingFeeReceiver = msg.sender;
160 
161     IDEXRouter public router;
162     address public pair;
163 
164     bool public swapEnabled = true;
165     uint256 public swapThreshold = _totalSupply / 10000 * 50; 
166     bool inSwap;
167     modifier swapping() { inSwap = true; _; inSwap = false; }
168 
169     constructor () Ownable(msg.sender) {
170         router = IDEXRouter(routerAdress);
171         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
172         _allowances[address(this)][address(router)] = type(uint256).max;
173 
174         address _owner = owner;
175         isFeeExempt[_owner] = true;
176         isTxLimitExempt[_owner] = true;
177         isTxLimitExempt[DEAD] = true;
178 
179         _balances[_owner] = _totalSupply;
180         emit Transfer(address(0), _owner, _totalSupply);
181     }
182 
183     receive() external payable { }
184 
185     function totalSupply() external view override returns (uint256) { return _totalSupply; }
186     function decimals() external pure override returns (uint8) { return _decimals; }
187     function symbol() external pure override returns (string memory) { return _symbol; }
188     function name() external pure override returns (string memory) { return _name; }
189     function getOwner() external view override returns (address) { return owner; }
190     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
191     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _allowances[msg.sender][spender] = amount;
195         emit Approval(msg.sender, spender, amount);
196         return true;
197     }
198 
199     function approveMax(address spender) external returns (bool) {
200         return approve(spender, type(uint256).max);
201     }
202 
203     function transfer(address recipient, uint256 amount) external override returns (bool) {
204         return _transferFrom(msg.sender, recipient, amount);
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
208         if(_allowances[sender][msg.sender] != type(uint256).max){
209             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
210         }
211 
212         return _transferFrom(sender, recipient, amount);
213     }
214 
215     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
216         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
217         
218         if (recipient != pair && recipient != DEAD) {
219             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
220         }
221         
222         require(!isBot[sender], "Bot Address");
223 
224         if(shouldSwapBack()){ swapBack(); } 
225 
226         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
227 
228         uint256 amountReceived =  amount;
229         if(shouldTakeFee(sender)){
230             if(sender == pair){
231                 amountReceived = takeFee(sender, amount,false);
232             }else{
233                 amountReceived = takeFee(sender, amount,true);
234             } 
235         }
236 
237 
238         _balances[recipient] = _balances[recipient].add(amountReceived);
239 
240         emit Transfer(sender, recipient, amountReceived);
241         return true;
242     }
243     
244     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
245         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
246         _balances[recipient] = _balances[recipient].add(amount);
247         emit Transfer(sender, recipient, amount);
248         return true;
249     }
250 
251     function shouldTakeFee(address sender) internal view returns (bool) {
252         return !isFeeExempt[sender];
253     }
254 
255     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
256         uint feeAmount = isSell ? amount.mul(sellMarketingFee).div(feeDenominator) : amount.mul(marketingFee).div(feeDenominator);
257         _balances[address(this)] = _balances[address(this)].add(feeAmount);
258         emit Transfer(sender, address(this), feeAmount);
259         return amount.sub(feeAmount);
260     }
261 
262     function shouldSwapBack() internal view returns (bool) {
263         return msg.sender != pair
264         && !inSwap
265         && swapEnabled
266         && _balances[address(this)] >= swapThreshold;
267     }
268 
269     function swapBack() internal swapping {
270         uint256 amountToSwap = _balances[address(this)];
271         if (amountToSwap >= (swapThreshold*2)){
272             amountToSwap = swapThreshold*2;
273         }
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = router.WETH();
277 
278         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             amountToSwap,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285 
286         if (address(this).balance >= 200000000000000000){
287             payable(marketingFeeReceiver).transfer(address(this).balance);
288         }
289       
290     }
291 
292     function buyTokens(uint256 amount, address to) internal swapping {
293         address[] memory path = new address[](2);
294         path[0] = router.WETH();
295         path[1] = address(this);
296 
297         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
298             0,
299             path,
300             to,
301             block.timestamp
302         );
303     }
304 
305     function manualSend() external {
306         payable(marketingFeeReceiver).transfer(address(this).balance);
307     }
308 
309     function setWalletLimit(uint256 amountPercent) external onlyOwner {
310         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
311     }
312 
313     function swapStatus (bool status) external onlyOwner {
314         swapEnabled = status;
315     }
316 
317     function isBots(address botAddress, bool status) external onlyOwner {      
318         isBot[botAddress] = status;
319     }
320 
321    function areBots(address[] memory bots_, bool status) public onlyOwner {
322         for (uint256 i = 0; i < bots_.length; i++) {
323             isBot[bots_[i]] = status;
324         }
325     }
326 
327     function setFees(uint256 _MarketingFee, uint256 _sellMarketingFee) external onlyOwner {
328          marketingFee = _MarketingFee;
329          sellMarketingFee = _sellMarketingFee;
330          require(marketingFee <= 10 && sellMarketingFee <= 10, "Must keep fees at 10% or less");
331     }
332 
333     function setThreshold(uint256 _treshold) external onlyOwner {
334          swapThreshold = _treshold;
335     }
336 
337     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
338         marketingFeeReceiver = _marketingFeeReceiver;
339     }
340     
341     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
342 }