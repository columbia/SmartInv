1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function getOwner() external view returns (address);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address _owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Ownable {
20     address internal owner;
21     constructor(address _owner) {
22         owner = _owner;
23     }
24     modifier onlyOwner() {
25         require(isOwner(msg.sender), "!OWNER");
26         _;
27     }
28     function isOwner(address account) public view returns (bool) {
29         return account == owner;
30     }
31     function transferOwnership(address payable _ownerNew) external onlyOwner {
32         owner = _ownerNew;
33         emit OwnershipTransferred(_ownerNew);
34     }
35     event OwnershipTransferred(address _ownerNew);
36 }
37 
38 interface IRouter {
39     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
40     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
41 }
42 
43 interface IFactory {
44     function createPair(address tokenA, address tokenB) external returns (address pair);
45 }
46 
47 contract SAFX is IERC20, Ownable {
48     string public constant _name = "Safx";
49     string public constant _symbol = "SAFX";
50     uint8 public constant _decimals = 9;
51 
52     uint256 public constant _totalSupply = 1_000_000_000 * (10 ** _decimals);
53 
54     mapping (address => uint256) public _balances;
55     mapping (address => mapping (address => uint256)) public _allowances;
56 
57     mapping (address => bool) public noTax;
58     mapping (address => bool) public noMax;
59     mapping (address => bool) public dexPair;
60 
61     uint256 public buyFeeTeam = 150;
62     uint256 public buyFeeInsurance = 50;
63     uint256 public buyFeeLiqExchange = 150;
64     uint256 public buyFeeLiqToken = 0;
65     uint256 public buyFee = 350;
66     uint256 public sellFeeTeam = 0;
67     uint256 public sellFeeInsurance = 100;
68     uint256 public sellFeeLiqExchange = 400;
69     uint256 public sellFeeLiqToken = 50;
70     uint256 public sellFee = 550;
71 
72     uint256 private _tokensTeam = 0;
73     uint256 private _tokensInsurance = 0;
74     uint256 private _tokensLiqExchange = 0;
75     uint256 private _tokensLiqToken = 0;
76 
77     address public walletTeam = 0x27B9Be6B278c291109018D846E99a22F54D793A3;
78     address public walletInsurance = 0xfF8C7d5933541388aD26ee45DF5735a746680d7A;
79     address public walletLiqExchange = 0x1a9dd076a21ea54A528CdBF1F3e75700a1594B9B;
80     address public walletLiqToken = 0xF3A8439dFc2Da25466eD9be6D456Ad0211a5e399;
81 
82     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
83     IRouter public router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
84     address public pair;
85 
86     uint256 public maxWallet = 20_000_000 * (10 ** _decimals);
87     uint256 public swapTrigger = 0;
88     uint256 public swapThreshold = 25_000 * (10 ** _decimals);
89 
90     bool public tradingLive = false;
91 
92     bool private _swapping;
93 
94     modifier swapping() {
95         _swapping = true;
96         _;
97         _swapping = false;
98     }
99 
100     constructor () Ownable(msg.sender) {
101         pair = IFactory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f).createPair(WETH, address(this));
102         _allowances[address(this)][address(router)] = _totalSupply;
103 
104         noTax[msg.sender] = true;
105         noMax[msg.sender] = true;
106 
107         dexPair[pair] = true;
108 
109         approve(address(router), _totalSupply);
110         approve(address(pair), _totalSupply);
111 
112         _balances[msg.sender] = _totalSupply;
113         emit Transfer(address(0), msg.sender, _totalSupply);
114     }
115 
116     receive() external payable {}
117 
118     function totalSupply() external pure override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     function decimals() external pure override returns (uint8) {
123         return _decimals;
124     }
125 
126     function symbol() external pure override returns (string memory) {
127         return _symbol;
128     }
129 
130     function name() external pure override returns (string memory) {
131         return _name;
132     }
133 
134     function getOwner() external view override returns (address) {
135         return owner;
136     }
137 
138     function balanceOf(address account) public view override returns (uint256) {
139         return _balances[account];
140     }
141 
142     function allowance(address holder, address spender) external view override returns (uint256) {
143         return _allowances[holder][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public override returns (bool) {
147         _allowances[msg.sender][spender] = amount;
148         emit Approval(msg.sender, spender, amount);
149         return true;
150     }
151 
152     function approveMax(address spender) external returns (bool) {
153         return approve(spender, _totalSupply);
154     }
155 
156     function transfer(address recipient, uint256 amount) external override returns (bool) {
157         return _transferFrom(msg.sender, recipient, amount);
158     }
159 
160     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
161         if (_allowances[sender][msg.sender] != _totalSupply) {
162             require(_allowances[sender][msg.sender] >= amount, "Insufficient allowance");
163             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
164         }
165 
166         return _transferFrom(sender, recipient, amount);
167     }
168 
169     function _transferFrom(address sender, address recipient, uint256 amount) private returns (bool) {
170         if (_swapping) return _basicTransfer(sender, recipient, amount);
171         require(tradingLive || sender == owner, "Trading not live");
172 
173         address routerAddress = address(router);
174         bool _sell = dexPair[recipient] || recipient == routerAddress;
175 
176         if (!_sell && !noMax[recipient]) require((_balances[recipient] + amount) < maxWallet, "Max wallet triggered");
177 
178         if (_sell && amount >= swapTrigger) {
179             if (!dexPair[msg.sender] && !_swapping && _balances[address(this)] >= swapThreshold) _sellTaxedTokens();
180         }
181 
182         require(_balances[sender] >= amount, "Insufficient balance");
183         _balances[sender] = _balances[sender] - amount;
184 
185         uint256 amountReceived = (((dexPair[sender] || sender == address(router)) || (dexPair[recipient]|| recipient == address(router))) ? !noTax[sender] && !noTax[recipient] : false) ? _collectTaxedTokens(sender, recipient, amount) : amount;
186 
187         _balances[recipient] = _balances[recipient] + amountReceived;
188 
189         emit Transfer(sender, recipient, amountReceived);
190         return true;
191     }
192 
193     function _basicTransfer(address sender, address recipient, uint256 amount) private returns (bool) {
194         require(_balances[sender] >= amount, "Insufficient balance");
195         _balances[sender] = _balances[sender] - amount;
196         _balances[recipient] = _balances[recipient] + amount;
197         return true;
198     }
199 
200     function _collectTaxedTokens(address sender, address receiver, uint256 amount) private returns (uint256) {
201         bool _sell = dexPair[receiver] || receiver == address(router);
202         uint256 _fee = _sell ? sellFee : buyFee;
203         uint256 _tax = amount * _fee / 10000;
204 
205         if (_fee > 0) {
206             if (_sell) {
207                 if (sellFeeTeam > 0) _tokensTeam += _tax * sellFeeTeam / _fee;
208                 if (sellFeeInsurance > 0) _tokensInsurance += _tax * sellFeeInsurance / _fee;
209                 if (sellFeeLiqExchange > 0) _tokensLiqExchange += _tax * sellFeeLiqExchange / _fee;
210                 if (sellFeeLiqToken > 0) _tokensLiqToken += _tax * sellFeeLiqToken / _fee;
211             } else {
212                 if (buyFeeTeam > 0) _tokensTeam += _tax * buyFeeTeam / _fee;
213                 if (buyFeeInsurance > 0) _tokensInsurance += _tax * buyFeeInsurance / _fee;
214                 if (buyFeeLiqExchange > 0) _tokensLiqExchange += _tax * buyFeeLiqExchange / _fee;
215                 if (buyFeeLiqToken > 0) _tokensLiqToken += _tax * buyFeeLiqToken / _fee;
216             }
217         }
218 
219         _balances[address(this)] = _balances[address(this)] + _tax;
220         emit Transfer(sender, address(this), _tax);
221 
222         return amount - _tax;
223     }
224 
225     function _sellTaxedTokens() private swapping {
226         uint256 _tokens = _tokensTeam + _tokensInsurance + _tokensLiqExchange + _tokensLiqToken;
227 
228         uint256 _liquidityTokensToSwapHalf = _tokensLiqToken / 2;
229         uint256 _swapInput = balanceOf(address(this)) - _liquidityTokensToSwapHalf;
230 
231         uint256 _balanceSnapshot = address(this).balance;
232 
233         address[] memory path = new address[](2);
234         path[0] = address(this);
235         path[1] = WETH;
236         router.swapExactTokensForETHSupportingFeeOnTransferTokens(_swapInput, 0, path, address(this), block.timestamp);
237 
238         uint256 _tax = address(this).balance - _balanceSnapshot;
239 
240         uint256 _taxTeam = _tax * _tokensTeam / _tokens / 2;
241         uint256 _taxInsurance = _tax * _tokensInsurance / _tokens;
242         uint256 _taxLiqExchange = _tax * _tokensLiqExchange / _tokens;
243         uint256 _taxLiqToken = _tax * _tokensLiqToken / _tokens;
244 
245         _tokensTeam = 0;
246         _tokensInsurance = 0;
247         _tokensLiqExchange = 0;
248         _tokensLiqToken = 0;
249 
250         if (_taxTeam > 0) payable(walletTeam).call{value: _taxTeam}("");
251         if (_taxInsurance > 0) payable(walletInsurance).call{value: _taxInsurance}("");
252         if (_taxLiqExchange > 0) payable(walletLiqExchange).call{value: _taxLiqExchange}("");
253         if (_taxLiqToken > 0) router.addLiquidityETH{value: _taxLiqToken}(address(this), _liquidityTokensToSwapHalf, 0, 0, walletLiqToken, block.timestamp);
254     }
255 
256     function changeDexPair(address _pair, bool _value) external onlyOwner {
257         dexPair[_pair] = _value;
258     }
259 
260     function fetchDexPair(address _pair) external view returns (bool) {
261         return dexPair[_pair];
262     }
263 
264     function changeNoTax(address _wallet, bool _value) external onlyOwner {
265         noTax[_wallet] = _value;
266     }
267 
268     function fetchNoTax(address _wallet) external view returns (bool) {
269         return noTax[_wallet];
270     }
271 
272     function changeNoMax(address _wallet, bool _value) external onlyOwner {
273         noMax[_wallet] = _value;
274     }
275 
276     function fetchNoMax(address _wallet) external view onlyOwner returns (bool) {
277         return noMax[_wallet];
278     }
279 
280     function changeMaxWallet(uint256 _maxWallet) external onlyOwner {
281         maxWallet = _maxWallet;
282     }
283 
284     function changeFees(uint256 _buyFeeTeam, uint256 _buyFeeInsurance, uint256 _buyFeeLiqExchange, uint256 _buyFeeLiqToken, uint256 _sellFeeTeam, uint256 _sellFeeInsurance, uint256 _sellFeeLiqExchange, uint256 _sellFeeLiqToken) external onlyOwner {
285         buyFeeTeam = _buyFeeTeam;
286         buyFeeInsurance = _buyFeeInsurance;
287         buyFeeLiqExchange = _buyFeeLiqExchange;
288         buyFeeLiqToken = _buyFeeLiqToken;
289         buyFee = _buyFeeTeam + _buyFeeInsurance + _buyFeeLiqExchange + _buyFeeLiqToken;
290         sellFeeTeam = _sellFeeTeam;
291         sellFeeInsurance = _sellFeeInsurance;
292         sellFeeLiqExchange = _sellFeeLiqExchange;
293         sellFeeLiqToken = _sellFeeLiqToken;
294         sellFee = _sellFeeTeam + _sellFeeInsurance + _sellFeeLiqExchange + _sellFeeLiqToken;
295     }
296 
297     function changeWallets(address _walletTeam, address _walletInsurance, address _walletLiqExchange, address _walletLiqToken) external onlyOwner {
298         walletTeam = _walletTeam;
299         walletInsurance = _walletInsurance;
300         walletLiqExchange = _walletLiqExchange;
301         walletLiqToken = _walletLiqToken;
302     }
303 
304     function enableTrading() external onlyOwner {
305         tradingLive = true;
306     }
307 
308     function changeSwapSettings(uint256 _swapTrigger, uint256 _swapThreshold) external onlyOwner {
309         swapTrigger = _swapTrigger;
310         swapThreshold = _swapThreshold;
311     }
312 
313     function getCirculatingSupply() external view returns (uint256) {
314         return _totalSupply - balanceOf(0x000000000000000000000000000000000000dEaD) - balanceOf(0x0000000000000000000000000000000000000000);
315     }
316 
317     function transferETH() external onlyOwner {
318         payable(msg.sender).call{value: address(this).balance}("");
319     }
320 
321     function transferERC(address _erc20Address) external onlyOwner {
322         require(_erc20Address != address(this), "Can't withdraw SAFX");
323         IERC20 _erc20 = IERC20(_erc20Address);
324         _erc20.transfer(msg.sender, _erc20.balanceOf(address(this)));
325     }
326 }