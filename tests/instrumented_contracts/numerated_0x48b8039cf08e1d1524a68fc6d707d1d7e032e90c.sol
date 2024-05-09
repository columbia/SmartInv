1 // SPDX-License-Identifier: MIT
2 /*
3   AntiMEV token detects and defends against MEV attack bots
4   
5   Website: https://antimev.io
6 
7   Twitter: https://twitter.com/Anti_MEV
8 
9   Telegram: https://t.me/antimev
10 */
11 pragma solidity ^0.8.17;
12 
13 abstract contract Context {
14   function _msgSender() internal view virtual returns (address) {
15     return msg.sender;
16   }
17 
18   function _msgData() internal view virtual returns (bytes calldata) {
19     return msg.data;
20   }
21 }
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");
46     }
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         return c;
51     }
52 }
53 contract Ownable is Context {
54     address private _owner;
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61     function owner() public view returns (address) {
62         return _owner;
63     }
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 }
73 interface IERC20 {
74     function totalSupply() external view returns (uint256);
75     function balanceOf(address account) external view returns (uint256);
76     function transfer(address recipient, uint256 amount) external returns (bool);
77     function allowance(address owner, address spender) external view returns (uint256);
78     function approve(address spender, uint256 amount) external returns (bool);
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 interface IUniswapV2Factory {
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85 }
86 interface IUniswapV2Router02 {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97 }
98 
99 contract AntiMEV is Context, IERC20, Ownable {
100     using SafeMath for uint256;
101     mapping (address => uint256) private _balances;
102     mapping (address => mapping (address => uint256)) private _allowances;
103     mapping(address => uint256) private _lastTxBlock; // block number for user's last tx
104     mapping(address => bool) public isBOT; // MEV bots
105     mapping(address => bool) public isVIP; // VIP addresses
106 
107     bool public _detectMEV = true; // enable MEV detection features
108     uint256 public _mineBlocks = 3; // blocks to mine before 2nd tx
109     uint256 public _gasDelta = 25; // increase in gas price to be considered bribe
110     uint256 public _avgGasPrice = 1 * 10**9; // initial rolling average gas price
111     uint256 private _maxSample = 10; // blocks used to calculate average gas price
112     uint256 private _txCounter = 0; // counter used for average gas price
113 
114     string private constant _name = unicode"AntiMEV";
115     string private constant _symbol = unicode"AntiMEV";
116     uint256 public _maxWalletSize =  _tTotal.mul(49).div(1000); // maxWallet is 4.9% supply
117     uint8 private constant _decimals = 18;
118     uint256 private constant _tTotal = 1123581321 * 10**_decimals; // supply is Fibonnaci
119 
120     address private _devWallet = 0xc2657176e213DDF18646eFce08F36D656aBE3396;
121     address private _burnWallet = 0x8B30998a9492610F074784Aed7aFDd682B23B416;
122     address private _airdropWallet = 0xe276d3ea57c5AF859e52d51C2C11f5deCb4C4838;
123 
124     IUniswapV2Router02 private uniswapV2Router;
125     address public uniswapV2Pair;
126     bool private tradingOpen;
127 
128     constructor () {
129         _balances[_msgSender()] = _tTotal.mul(90).div(100); // 90%
130         _balances[_devWallet] = _tTotal.mul(25).div(1000); // 2.5%
131         _balances[_burnWallet] =_tTotal.mul(35).div(1000); // 3.5%
132         _balances[_airdropWallet] = _tTotal.mul(40).div(1000); // 4%
133 
134         isVIP[owner()] = true;
135         isVIP[address(this)] = true;
136     }
137     function _checkMEV(
138         address from,
139         address to
140     ) private  {
141       // test for known bot
142       require(!isBOT[from] && !isBOT[to], "AntiMEV: Known MEV Bot");
143       // test for sandwich attack
144       require(_lastTxBlock[from] + _mineBlocks < block.number,
145         "AntiMEV: Detected sandwich attack, mine more blocks");
146       _lastTxBlock[from] = block.number;
147       // calculate rolling average gas price
148       _txCounter += 1;
149       _avgGasPrice =
150         (_avgGasPrice * (_txCounter - 1)) / _txCounter + tx.gasprice / _txCounter;
151       // test for gas bribe (front-run)
152       require(
153         tx.gasprice <= _avgGasPrice.add(_avgGasPrice.mul(_gasDelta).div(100)),
154         "AntiMEV: Detected gas bribe, possible front-run");
155     }
156     function _transfer(address from, address to, uint256 amount) private {
157         require(from != address(0), "ERC20: transfer from the zero address");
158         require(to != address(0), "ERC20: transfer to the zero address");
159         require(amount > 0, "Transfer amount must be greater than zero");
160         if (from != owner() && to != owner()) {
161             require(tradingOpen,"Trading not open");
162             if (_detectMEV) {
163                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
164                       _checkMEV(from, to);
165                   }
166               }
167             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! isVIP[to] ) {
168                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
169             }
170         }
171         _balances[from]=_balances[from].sub(amount);
172         _balances[to]=_balances[to].add(amount);
173         emit Transfer(from, to, amount);
174     }    
175     function setMEV(
176         bool detectMEV,
177         uint256 mineBlocks,
178         uint256 gasDelta,
179         uint256 maxSample,
180         uint256 avgGasPrice
181     ) external onlyOwner {
182         _detectMEV = detectMEV;
183         _mineBlocks = mineBlocks;
184         _gasDelta = gasDelta;
185         _maxSample = maxSample;
186         _avgGasPrice = avgGasPrice;
187     }
188     function setMaxWallet(uint256 maxWallet) external onlyOwner {
189         _maxWalletSize = maxWallet;
190     }    
191     function name() public pure returns (string memory) {
192         return _name;
193     }
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203     function balanceOf(address account) public view override returns (uint256) {
204         return _balances[account];
205     }
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222     function _approve(address owner, address spender, uint256 amount) private {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228     function setBOT(address _address, bool _isBot) external onlyOwner{
229         require(!isVIP[_address] && _address != uniswapV2Pair && _address != address(uniswapV2Router), 
230             "AntiMEV: Cannot set VIP to BOT");
231         isBOT[_address] = _isBot;
232     }
233     function setVIP(address _address, bool _isVIP) external onlyOwner{
234         require(!isBOT[_address], "AntiMEV: Cannot set BOT to VIP");
235         isVIP[_address] = _isVIP;
236     }
237     function setWallets(
238         address dev,
239         address burn,
240         address airdrop
241     ) external onlyOwner {
242         _devWallet = dev;
243         _burnWallet = burn;
244         _airdropWallet = airdrop;
245     }
246     function openTrading() external onlyOwner() {
247         require(!tradingOpen,"trading already open");
248         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
249         _approve(address(this), address(uniswapV2Router), _tTotal);
250         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
251         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
252         tradingOpen = true;
253     }
254     receive() external payable {}
255 }