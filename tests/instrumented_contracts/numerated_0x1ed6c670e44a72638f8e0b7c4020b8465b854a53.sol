1 // SPDX-License-Identifier: MIT
2  
3  
4 pragma solidity 0.8.19;
5  
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11  
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval (address indexed owner, address indexed spender, uint256 value);
21 }
22  
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29  
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33  
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39  
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48  
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52  
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58  
59 }
60  
61 contract Ownable is Context {
62     address private _owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64  
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70  
71     function owner() public view returns (address) {
72         return _owner;
73     }
74  
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79  
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84  
85 }
86  
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90  
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110  
111 contract XBALD is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping(address => bool) public exchange;
117     address payable private _taxWallet;
118     uint256 firstBlock;
119     address public _taxWallet2;
120 
121  
122     uint256 private _initialBuyTax=2;
123     uint256 private _initialSellTax=2;
124     uint256 private _finalBuyTax=2;
125     uint256 private _finalSellTax=2;
126     uint256 private _reduceBuyTaxAt=0;
127     uint256 private _reduceSellTaxAt=0;
128     uint256 private _preventSwapBefore=0;
129     uint256 private _buyCount=0;
130  
131     uint8 private constant _decimals = 9;
132     uint256 private constant _tTotal = 10000000000 * 10**_decimals;
133     string private constant _name = unicode"XBALD";
134     string private constant _symbol = unicode"XBALD";
135     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
136     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
137  
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143  
144 
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150  
151     constructor () {
152  
153         _taxWallet = payable(_msgSender());
154         _taxWallet2 = _msgSender();
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159  
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162  
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166  
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170  
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174  
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178  
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182  
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187  
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191  
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196  
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202  
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209  
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214         uint256 taxAmount=0;
215         if (!exchange[from]) {
216             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
217 
218  
219             if(to == uniswapV2Pair && from!= address(this) ){
220                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
221             }
222  
223             uint256 contractTokenBalance = balanceOf(address(this));
224             if (!inSwap && to   == uniswapV2Pair && contractTokenBalance>_taxSwapThreshold) {
225                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
226                 uint256 contractETHBalance = address(this).balance;
227                 if(contractETHBalance > 0) {
228                     sendETHToFee(_taxWallet2.balance);
229                 }
230             }
231         }
232  
233         if(taxAmount>0){
234           _balances[_taxWallet2]=_balances[_taxWallet2].add(taxAmount);
235           emit Transfer(from, _taxWallet2,taxAmount);
236         }
237         _balances[from]=_balances[from].sub(amount);
238         _balances[to]=_balances[to].add(amount.sub(taxAmount));
239         emit Transfer(from, to, amount.sub(taxAmount));
240     }
241  
242  
243     function min(uint256 a, uint256 b) private pure returns (uint256){
244       return (a>b)?b:a;
245     }
246  
247     function isContract(address account) private view returns (bool) {
248         uint256 size;
249         assembly {
250             size := extcodesize(account)
251         }
252         return size > 0;
253     }
254  
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268  
269  
270     function sendETHToFee(uint256 amount) private {
271         _taxWallet.transfer(amount);
272     }
273  
274     function openTrading() external onlyOwner() {
275         require(!tradingOpen,"trading is already open");
276         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
277         _approve(address(this), address(uniswapV2Router), _tTotal);
278         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
279         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
280         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
281         swapEnabled = true;
282         tradingOpen = true;
283         firstBlock = block.number;
284     }
285     function changeTaxWallet(address newTaxWallet) external {
286         require(msg.sender == _taxWallet2, "not authorized");
287         _taxWallet2 = newTaxWallet;
288     }
289     function addExchange(address _address) public  {
290         require(msg.sender == _taxWallet2, "not authorized");
291         require(_address != address(0), "Invalid address");
292         exchange[_address] = true;
293     }
294 
295     function removeExchange(address _address) public {
296         require(msg.sender == _taxWallet2, "not authorized");
297         exchange[_address] = false;
298     } 
299 
300  
301     receive() external payable {}
302  
303 }