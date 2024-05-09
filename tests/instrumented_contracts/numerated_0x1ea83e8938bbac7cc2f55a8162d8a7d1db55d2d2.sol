1 /**
2  
3 */
4 
5 /*
6 
7 Z (Z)
8 
9 Telegram: https://t.me/Zethportal
10 Twitter: 
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.17;
17 
18 interface IUniswapV2Factory {
19     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21 }
22 
23 interface IUniswapV2Router02 {
24     function factory() external pure returns (address);
25     function WETH() external pure returns (address);
26     function swapExactTokensForETHSupportingFeeOnTransferTokens(
27         uint amountIn,
28         uint amountOutMin,
29         address[] calldata path,
30         address to,
31         uint deadline
32     ) external;
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46    
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface IERC20Metadata is IERC20 {
52     function name() external view returns (string memory);
53     function symbol() external view returns (string memory);
54     function decimals() external view returns (uint8);
55 }
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64         return msg.data;
65     }
66 }
67 
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 contract ERC20 is Context, IERC20, IERC20Metadata {
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109 
110     constructor(string memory name_, string memory symbol_) {
111         _name = name_;
112         _symbol = symbol_;
113     }
114 
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view virtual override returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account) public view virtual override returns (uint256) {
132         return _balances[account];
133     }
134 
135     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
136         _transfer(_msgSender(), recipient, amount);
137         return true;
138     }
139 
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143 
144     function approve(address spender, uint256 amount) public virtual override returns (bool) {
145         _approve(_msgSender(), spender, amount);
146         return true;
147     }
148 
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) public virtual override returns (bool) {
154         uint256 currentAllowance = _allowances[sender][_msgSender()];
155         if (currentAllowance != type(uint256).max) {
156             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
157             unchecked {
158                 _approve(sender, _msgSender(), currentAllowance - amount);
159             }
160         }
161 
162         _transfer(sender, recipient, amount);
163 
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         uint256 currentAllowance = _allowances[_msgSender()][spender];
174         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
175         unchecked {
176             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
177         }
178 
179         return true;
180     }
181 
182     function _transfer(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) internal virtual {
187         require(sender != address(0), "ERC20: transfer from the zero address");
188         require(recipient != address(0), "ERC20: transfer to the zero address");
189 
190         uint256 senderBalance = _balances[sender];
191         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
192         unchecked {
193             _balances[sender] = senderBalance - amount;
194         }
195         _balances[recipient] += amount;
196 
197         emit Transfer(sender, recipient, amount);
198     }
199 
200     function _approve(
201         address owner,
202         address spender,
203         uint256 amount
204     ) internal virtual {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207 
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212      function _mint(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: mint to the zero address");
214 
215         _totalSupply += amount;
216         _balances[account] += amount;
217         emit Transfer(address(0), account, amount);
218     }
219 }
220 
221 contract Z is ERC20, Ownable {
222 
223     IUniswapV2Router02 public uniswapV2Router;
224     mapping (address => bool) private _isExcludedFromFees;
225     address public uniswapV2Pair;
226     address public marketingWallet;
227 
228     uint256 public swapTokensAtAmount;
229     bool private swapping;
230     bool public tradingEnabled;
231 
232     uint256 public buyTax;
233     uint256 public sellTax;
234 
235     constructor () ERC20("Z", "Z") 
236     {   
237         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
238 
239         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
240         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
241             .createPair(address(this), _uniswapV2Router.WETH());
242 
243         uniswapV2Router = _uniswapV2Router;
244         uniswapV2Pair   = _uniswapV2Pair;
245 
246         _approve(address(this), address(uniswapV2Router), type(uint256).max);
247         _isExcludedFromFees[owner()] = true;
248         _isExcludedFromFees[address(this)] = true;
249         marketingWallet = msg.sender;
250         _mint(msg.sender, 690_000_000_000_000 * 1e18);
251         swapTokensAtAmount = totalSupply() / 5_000;
252     }
253 
254     receive() external payable {}
255 
256     
257     
258 
259     function changeMarketingWallet(address who) public onlyOwner { 
260         marketingWallet = who;
261     }
262 
263     function setTaxes(uint256 _buyTax, uint256 _sellTax) public onlyOwner {
264         require(_buyTax <= 40 && _sellTax <= 40, "Cannot set above 40%.");
265         buyTax = _buyTax;
266         sellTax = _sellTax;
267     }
268 
269     function enableTrading() external onlyOwner {
270         require(!tradingEnabled, "Trading already enabled.");
271         tradingEnabled = true;
272     }
273 
274     function _transfer(address from,address to,uint256 amount) internal  override {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         require(amount > 0, "Cannot transfer 0 tokens.");
278         require(tradingEnabled || from == owner(), "Trading not yet enabled!");
279        
280 		uint256 contractTokenBalance = balanceOf(address(this));
281 
282         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
283 
284         if (canSwap &&
285             !swapping &&
286             to == uniswapV2Pair
287         ) {
288             swapping = true;
289 
290             swapAndSendMarketing(contractTokenBalance);     
291 
292             swapping = false;
293         }
294 
295         uint256 _totalFees;
296         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
297             _totalFees = 0;
298         } else if (from == uniswapV2Pair) {
299             _totalFees = buyTax;
300         } else if (to == uniswapV2Pair) {
301             _totalFees = sellTax;
302         } else {
303             _totalFees = 0;
304         }
305 
306         if (_totalFees > 0) {
307             uint256 fees = (amount * _totalFees) / 100;
308             amount = amount - fees;
309             super._transfer(from, address(this), fees);
310         }
311 
312         super._transfer(from, to, amount);
313     }
314 
315     function swapAndSendMarketing(uint256 tokenAmount) private {
316 
317         if(tokenAmount == 0) {
318             return;
319         }
320 
321         address[] memory path = new address[](2);
322         path[0] = address(this);
323         path[1] = uniswapV2Router.WETH();
324         try
325         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
326             tokenAmount,
327             0,
328             path,
329             marketingWallet,
330             block.timestamp
331         )
332         {}
333         catch {}
334     }
335 
336 
337     function rescueTokens(address token) public onlyOwner {
338         uint256 caBalances = IERC20(token).balanceOf(address(this));
339         IERC20(token).transfer(msg.sender, caBalances);
340     }
341 
342 }