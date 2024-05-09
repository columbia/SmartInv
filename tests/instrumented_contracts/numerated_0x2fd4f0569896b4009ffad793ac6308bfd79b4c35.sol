1 // SPDX-License-Identifier: MIT
2 /*
3 
4           .CΔVΞCCCΔVΞCC.                .CΔVΞCCCC            .CΔVΞCCC               CΔVΞCCC. ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
5        CΔVΞCCCΔVΞCCCΔVΞCCCC             CΔVΞCCCCCC           CΔVΞCCCC              CΔVΞCCCC  ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
6      CΔVΞCCCΔVΞCCCΔVΞCCCCCCC           CΔVΞCCCCCCC           .CΔVΞCCCC            ΔCΔVΞCCC.  ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
7    .CΔVΞCCCCCVΞΞ     CCCCCΞΔ          .CΔVΞCCCΔVΞCC           CΔVΞCCCC.           CΔVΞCCCC                              
8   .CΔVΞCCCCCΞ           VV.           CΔVΞCCCΔVΞCCC.           CΔVΞCCCC          CΔVΞCCCC                               
9   CΔVΞCCCCVV                         CΔVΞCCCΔCΔVΞCCC           ΔCΔVΞCCCC        ΔCΔVΞCCC.                               
10  CΔVΞCCCCCV.                         CΔVΞCCC..CΔVΞCCC           CΔVΞCCCC        CΔVΞCCCC                                
11  CΔVΞCCCCCΔ                         CΔVΞCCCΔ  CΔVΞCCC           .CΔVΞCCCC      CΔVΞCCCC                                 
12  CΔVΞCCCCΔΔ                        CΔVΞCCCC   .CΔVΞCCC           CΔVΞCCCC.    CΔVΞCCCCC         ΔCΔVΞCCCΔVΞCCCΔVΞCCCCC  
13  CΔVΞCCCCΔΔ                        CΔVΞCCCΔ    CΔVΞCCC.           CΔVΞCCCC    CΔVΞCCCC          ΔCΔVΞCCCΔVΞCCCΔVΞCCCCC  
14  CΔVΞCCCCCC                       CΔVΞCCCC     .CΔVΞCCC           ΔCΔVΞCCCC  ΔCΔVΞCCC           CΔVΞCCCΔVΞCCCΔVΞCCCCCC  
15  CΔVΞCCCCCC                      CΔVΞCCCCΔ      CΔVΞCCCC           CΔVΞCCCC  CΔVΞCCCC                                   
16  CΔVΞCCCCCC                     .CΔVΞCCCΔ        CΔVΞCCC           .CΔVΞCCC ΔCΔVΞCCC                                    
17   CΔVΞCCCCC                     CΔVΞCCCC        .CΔVΞCCCC           ΔCΔVΞCC ΔCΔVΞCC                                     
18    CΔVΞCCCCCC                  CΔVΞCCCCΔ          CΔVΞCCCC           CΔVΞCC CΔVΞCCC                                     
19     CΔVΞCCCΔVΞCC.   .CCCCC.    CΔVΞCCCC          .CΔVΞCCCC           CΔVΞCCCΔVΞCCC                                      
20       CΔVΞCCCΔVΞCCCΔVΞCCCCC.  CΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCCCCC           CΔVΞCCCCCCC            ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
21         .CΔVΞCCCΔVΞCCCCCCCΔ. CΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCC.           CΔVΞCCCCCC            ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
22             .CΔVΞCCCCV.      CΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCC           CΔVΞCCCCCC            ΔCΔVΞCCCΔVΞCCCΔVΞCCCΔVΞCCCC
23 
24 
25   "Look, a new source of light has been created... As the cave develops, those who successfully settle and guide others
26    towards the light will be rewarded for their loyalty. The knowledge contained within the light will illuminate all
27    ... for an eternity."
28     
29    https://cavedao.io/
30 
31 */
32 
33 pragma solidity 0.8.17;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction overflow");
61     }
62 
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         return c;
86     }
87 
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 
121 }
122 
123 interface IUniswapV2Factory {
124     function getPair(address tokenA, address tokenB) external view returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135     function factory() external pure returns (address);
136     function WETH() external pure returns (address);
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145 }
146 
147 contract Cave is Context, IERC20, Ownable {
148     using SafeMath for uint256;
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) public isExcludedFromFee;
152     mapping (address => bool) public boughtAtLaunch;
153     mapping (address => bool) public hasSold;
154     
155     // mapping (address => bool) private bots; // blacklist functionality
156     address payable public treasuryWallet;
157     address payable public rewardsWallet;
158 
159     uint256 public feePercentage;
160 
161     uint256 public treasurySplit = 60; // 60% of tax goes to treasury
162     uint256 public rewardsSplit = 20; // 20% of tax goes to rewards
163     uint256 public burnSplit = 20; // 20% of tax goes to burn
164 
165     uint8 private constant _decimals = 18;
166     uint256 private constant _tTotal = 333333 * 10**_decimals;
167     string private constant _name = unicode"CΔVΞ(DAO)";
168     string private constant _symbol = unicode"CΔVΞ";
169     uint256 public maxTxAmount = _tTotal / 100; // 1% of total supply
170     uint256 public maxWalletSize = _tTotal / 50; // 2% of total supply
171     bool public txLimitsRemoved = false;
172 
173     uint256 public collectedTaxThreshold = _tTotal / 1000; // 0.1% of total supply  
174 
175     address public uniswapV2Pair;
176     bool public tradingOpen;
177     bool public autoTaxDistributionEnabled = false;
178     bool private inInternalSwap = false;
179     IUniswapV2Router02 public uniswapV2Router;
180     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
181     address public launchContract;
182 
183     event ConfigurationChange(string varName, uint256 value);
184     event ConfigurationChange(string varName, address value);
185     event ConfigurationChange(string varName, bool value);
186     event ConfigurationChange(string funcName);
187 
188     modifier lockTheSwap {
189         inInternalSwap = true;
190         _;
191         inInternalSwap = false;
192     }
193 
194     constructor (address payable _treasuryWallet, address payable _rewardsWallet, uint256 _feePercentage, address _uniswapV2Router) {
195         treasuryWallet = _treasuryWallet;
196         rewardsWallet = _rewardsWallet;
197         feePercentage = _feePercentage;
198         uniswapV2Router = IUniswapV2Router02(_uniswapV2Router);
199         
200         _balances[_msgSender()] = _tTotal;
201         isExcludedFromFee[owner()] = true;
202         isExcludedFromFee[address(this)] = true;
203         isExcludedFromFee[_treasuryWallet] = true;
204         isExcludedFromFee[_rewardsWallet] = true;
205         isExcludedFromFee[DEAD] = true;
206 
207         emit Transfer(address(0), _msgSender(), _tTotal);
208     }
209 
210     receive() external payable {}
211 
212     function name() public pure returns (string memory) {
213         return _name;
214     }
215 
216     function symbol() public pure returns (string memory) {
217         return _symbol;
218     }
219 
220     function decimals() public pure returns (uint8) {
221         return _decimals;
222     }
223 
224     function totalSupply() public pure override returns (uint256) {
225         return _tTotal;
226     }
227 
228     function balanceOf(address account) public view override returns (uint256) {
229         return _balances[account];
230     }
231 
232     function transfer(address recipient, uint256 amount) public override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender) public view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount) public override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
249         return true;
250     }
251 
252     function _approve(address owner, address spender, uint256 amount) private {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259     function _transfer(address from, address to, uint256 amount) private {
260         require(from != address(0) && from != address(DEAD), "ERC20: transfer from invalid");
261         require(to != address(0), "ERC20: transfer to the zero address");
262         require(amount > 0, "Transfer amount must be greater than zero");
263         if (from == launchContract) {
264             boughtAtLaunch[to] = true;
265         }
266         uint256 taxAmount = 0;
267         hasSold[from] = true;
268         uint256 _collectedTaxThreshold = collectedTaxThreshold;
269         if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
270             require(tradingOpen, "Trading is not open yet");
271             bool isTransfer = from != uniswapV2Pair && to != uniswapV2Pair;
272             if(!inInternalSwap && !isTransfer){
273               taxAmount = amount.mul(feePercentage).div(100);
274             }
275 
276             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
277                 require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
278                 require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
279             }
280 
281             uint256 contractTokenBalance = balanceOf(address(this));
282             if (!inInternalSwap && from != uniswapV2Pair && autoTaxDistributionEnabled && contractTokenBalance > _collectedTaxThreshold) {
283                 _distributeTaxes(_collectedTaxThreshold);
284             }
285         }
286         _balances[from]=_balances[from].sub(amount);
287         _balances[to]=_balances[to].add(amount.sub(taxAmount));
288 
289         emit Transfer(from, to, amount.sub(taxAmount));
290         if(taxAmount > 0){
291           _balances[address(this)]=_balances[address(this)].add(taxAmount);
292           emit Transfer(from, address(this),taxAmount);
293         }
294     }
295 
296     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function setTxLimits(uint256 _maxTxAmount, uint256 _maxWalletSize) external onlyOwner {
311         require(!txLimitsRemoved, "Limits already removed");
312         maxTxAmount = _maxTxAmount;
313         maxWalletSize = _maxWalletSize;
314         emit ConfigurationChange("maxTxAmount", _maxTxAmount);
315         emit ConfigurationChange("maxWalletSize", _maxWalletSize);
316     }
317 
318     function removeLimits() external onlyOwner {
319         txLimitsRemoved = true;
320         maxTxAmount = _tTotal;
321         maxWalletSize = _tTotal;
322         emit ConfigurationChange("LimitsRemoved");
323     }
324 
325     function enableTrading() external onlyOwner() {
326         require(!tradingOpen, "Trading is already open");
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH());
328         autoTaxDistributionEnabled = true;
329         tradingOpen = true;
330         emit ConfigurationChange("TradingEnabled");
331     }
332 
333     function setAutoTaxDistributionEnabled(bool _enabled) external onlyOwner() {
334         autoTaxDistributionEnabled = _enabled;
335         emit ConfigurationChange("autoTaxDistributionEnabled", _enabled);
336     }
337 
338     function reduceFee(uint256 _feePercentage) external onlyOwner{
339         require(_feePercentage <= 10 || _feePercentage < feePercentage); // 10% or less than before required
340         feePercentage = _feePercentage;
341         emit ConfigurationChange("feePercentage", _feePercentage);
342     }
343 
344     function setSplits(uint256 _burnSplit, uint256 _treasurySplit, uint256 _rewardsSplit) external onlyOwner{
345         require(_burnSplit + _treasurySplit + _rewardsSplit==100, "INVALID_SPLITS");
346         treasurySplit=_treasurySplit;
347         rewardsSplit=_rewardsSplit;
348         burnSplit=_burnSplit;
349         emit ConfigurationChange("burnSplit", _burnSplit);
350         emit ConfigurationChange("treasurySplit", _treasurySplit);
351         emit ConfigurationChange("rewardsSplit", _rewardsSplit);
352     }
353 
354     function setTaxThreshold(uint256 _newThreshold) external onlyOwner{
355         collectedTaxThreshold = _newThreshold;
356         emit ConfigurationChange("collectedTaxThreshold", _newThreshold);
357     }
358 
359     function setExcludeFromFee(address _address, bool _excluded) external onlyOwner {
360         isExcludedFromFee[_address] = _excluded;
361         emit ConfigurationChange("isExcludedFromFee", _excluded);
362     }
363 
364     //function to set the launchContract by the owner
365     function setLaunchContract(address _launchContract) external onlyOwner {
366         launchContract = _launchContract;
367         isExcludedFromFee[_launchContract] = true;
368         emit ConfigurationChange("launchContract", _launchContract);
369     }
370 
371     function setTreasuryAddress(address payable _treasuryWallet) external onlyOwner {
372         treasuryWallet = _treasuryWallet;
373         emit ConfigurationChange("treasuryWallet", _treasuryWallet);
374     }
375 
376     function setRewardsAddress(address payable _rewardsWallet) external onlyOwner {
377         rewardsWallet = _rewardsWallet;
378         emit ConfigurationChange("treasuryWallet", _rewardsWallet);
379     }
380 
381     function distributeTaxes(uint256 amount) external onlyOwner {
382         _distributeTaxes(amount);
383     }
384 
385     function _distributeTaxes(uint256 amount) internal { 
386         uint256 _burnSplit = burnSplit;
387         uint256 _treasurySplit = treasurySplit;
388         uint256 _rewardsSplit = rewardsSplit;
389         uint256 _treasuryAndRewardsSplit = _treasurySplit.add(_rewardsSplit);
390         uint256 burnAmount = amount.div(100).mul(_burnSplit);
391         amount = amount - burnAmount;
392         _transfer(address(this), DEAD, burnAmount);
393         _swapTokensForEth(amount);
394         uint256 contractETHBalance = address(this).balance;
395 
396         if(contractETHBalance > 0) {
397             _sendViaCall(treasuryWallet, contractETHBalance.div(_treasuryAndRewardsSplit).mul(_treasurySplit));
398             _sendViaCall(rewardsWallet, contractETHBalance.div(_treasuryAndRewardsSplit).mul(_rewardsSplit));
399         }
400     }
401 
402     function _sendViaCall(address payable _to, uint256 amountETH) internal {
403         // Call returns a boolean value indicating success or failure.
404         // This is the current recommended method to use.
405         (bool sent, bytes memory data) = _to.call{value: amountETH}("");
406         require(sent, "Failed to send Ether");
407     }
408 
409     function manualSendToken() external onlyOwner{
410         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
411     }
412 
413     function withdrawERC20(IERC20 token) external onlyOwner {
414         uint256 balance = token.balanceOf(address(this));
415         bool sent = token.transfer(msg.sender, balance);
416         require(sent, "Failed to send token");    
417     }
418 
419     function withdrawETH() external onlyOwner {
420         uint256 balance = address(this).balance;
421         _sendViaCall(payable(msg.sender), balance);
422     }
423 }