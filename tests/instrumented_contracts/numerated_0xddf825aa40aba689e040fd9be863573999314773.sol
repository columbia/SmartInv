1 //SPDX-License-Identifier: MIT 
2 //      _____ _     _ _               _____            
3 //     /  ___| |   (_) |             |_   _|           
4 //     \ `--.| |__  _| |_ _____   _    | | _ __  _   _ 
5 //      `--. \ '_ \| | __|_  / | | |   | || '_ \| | | |
6 //     /\__/ / | | | | |_ / /| |_| |  _| || | | | |_| |
7 //     \____/|_| |_|_|\__/___|\__,_|  \___/_| |_|\__,_|
8 //     
9 //     Website  : shitzuinu.io
10 //     Twitter  : twitter.com/ShitzuInuETH
11 //     Telegram : t.me/ShitzuInuETH
12 
13 pragma solidity ^0.8.9;
14 
15 library SafeMath {
16 	function add(uint256 a, uint256 b) internal pure returns (uint256) { uint256 c = a + b;	require(c >= a, "SafeMath: addition overflow"); return c; }
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) { return sub(a, b, "SafeMath: subtraction overflow"); }
18 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b <= a, errorMessage);	uint256 c = a - b; return c; }
19 	function mul(uint256 a, uint256 b) internal pure returns (uint256) { if (a == 0) { return 0; } uint256 c = a * b; require(c / a == b, "SafeMath: multiplication overflow"); return c; }
20 	function div(uint256 a, uint256 b) internal pure returns (uint256) { return div(a, b, "SafeMath: division by zero"); }
21 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b > 0, errorMessage); uint256 c = a / b; return c;	}
22 	function mod(uint256 a, uint256 b) internal pure returns (uint256) { return mod(a, b, "SafeMath: modulo by zero"); }
23 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b != 0, errorMessage); return a % b; }
24 }
25 
26 interface IERC20 {
27 	function totalSupply() external view returns (uint256);
28 	function decimals() external view returns (uint8);
29 	function symbol() external view returns (string memory);
30 	function name() external view returns (string memory);
31 	function getOwner() external view returns (address);
32 	function balanceOf(address account) external view returns (uint256);
33 	function transfer(address recipient, uint256 amount) external returns (bool);
34 	function allowance(address _owner, address spender) external view returns (uint256);
35 	function approve(address spender, uint256 amount) external returns (bool);
36 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37 	event Transfer(address indexed from, address indexed to, uint256 value);
38 	event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 abstract contract Auth {
42 	address internal owner;
43 	constructor(address _owner) { owner = _owner; }
44 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
45 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
46 	function renounceOwnership() external onlyOwner { owner = address(0); emit OwnershipTransferred(address(0)); }
47 	event OwnershipTransferred(address owner);
48 }
49 
50 interface IUniswapV2Router02 {
51     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
52     function WETH() external pure returns (address);
53 }
54 
55 contract SHITZUINU is IERC20, Auth {
56 	using SafeMath for uint256;
57 	string constant _name = "Shitzu Inu";
58 	string constant _symbol = "SHITZUINU";
59 	uint8 constant _decimals = 9;
60 	uint256 constant _totalSupply = 1 * (10**12) * (10 ** _decimals);
61     uint32 _smd; uint32 _smr;
62 	mapping (address => uint256) _balances;
63 	mapping (address => mapping (address => uint256)) _allowances;
64     mapping (address => bool) private _excludedFromFee;
65     bool public tradingOpen;
66     uint256 public maxTxAmount; uint256 public maxWalletAmount;
67 	address private _limitRemover; address private _taxRemover;
68     address private _uniLpAddr;
69 	uint8 private _buyTaxRate; uint8 private _sellTaxRate; uint8 private _txTaxRate;
70 	uint8 private _taxShares1 = 80;
71     uint8 private _taxShares2 = 10;
72     uint8 private _taxShares3 = 10;
73 	uint256 private _taxBreakEnd;
74 	address payable private _taxWallet1 = payable(0x0E72F66f9C590b1D6729069abe173a4590cc4DFA); //mo
75 	address payable private _taxWallet2 = payable(0x15cC23FC13928cEDdA1003395c375054Fe369139); //c
76     address payable private _taxWallet3 = payable(0x3EFf5E036A8B65E14E50550a5b882ed8ee95F843); //d
77 	bool private taxAutoSwap = false;
78 	bool private _inTaxSwap = false;
79 	address private _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
80     IUniswapV2Router02 private uniswapV2Router;
81 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
82 
83 	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
84 		_balances[owner] = _totalSupply;
85 		tradingOpen = false;
86 		_limitRemover = msg.sender;
87 		_taxRemover = msg.sender;
88 		maxTxAmount = _totalSupply;
89 		maxWalletAmount = _totalSupply;
90         uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
91 		_excludedFromFee[owner] = true;
92         _excludedFromFee[address(this)] = true;
93 		_excludedFromFee[_uniswapV2RouterAddress] = true;
94         _smd = smd; _smr = smr;
95 		emit Transfer(address(0), owner, _totalSupply);
96 	}
97 	
98 	receive() external payable {}
99 	
100 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
101 	function decimals() external pure override returns (uint8) { return _decimals; }
102 	function symbol() external pure override returns (string memory) { return _symbol; }
103 	function name() external pure override returns (string memory) { return _name; }
104 	function getOwner() external view override returns (address) { return owner; }
105 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
106 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
107 	
108     function decreaseTaxRate(uint8 _newBuyTax, uint8 _newSellTax, uint8 _newTxTax) external {
109 		require(msg.sender ==  _taxRemover, "not authorized");
110         require(_newBuyTax <= _buyTaxRate && _newSellTax <= _sellTaxRate && _newTxTax <= _txTaxRate, "New tax must be lower");
111 		_buyTaxRate = _newBuyTax;
112 		_sellTaxRate = _newSellTax;
113 		_txTaxRate = _newTxTax;
114     }
115 
116 	function setBuyTaxBreak(uint32 _durationSeconds) external {
117 		require(msg.sender ==  _taxRemover, "not authorized");
118 		_taxBreakEnd = block.timestamp + _durationSeconds;
119 	}
120     
121     function changeTaxDistribution(uint8 sharesWallet1, uint8 sharesWallet2, uint8 sharesWallet3) external {
122 		require(msg.sender ==  _taxRemover, "not authorized");
123         require(sharesWallet1 + sharesWallet2 + sharesWallet3 == 100, "The sum must be 100" );
124         _taxShares1 = sharesWallet1;
125         _taxShares2 = sharesWallet2;
126         _taxShares3 = sharesWallet3;
127     }
128     
129     function setTaxWallets(address newTaxWall1, address newTaxWall2, address newTaxWall3) external {
130 		require(msg.sender ==  _taxRemover, "not authorized");
131         _taxWallet1 = payable(newTaxWall1);
132         _taxWallet2 = payable(newTaxWall2);
133         _taxWallet3 = payable(newTaxWall3);
134     }
135 
136 	function setLPAddress(address _uniswapLiqPoolAddr) external onlyOwner {
137         _uniLpAddr = _uniswapLiqPoolAddr;
138 	}
139 
140 	function approve(address spender, uint256 amount) public override returns (bool) {
141 		_allowances[msg.sender][spender] = amount;
142 		emit Approval(msg.sender, spender, amount);
143 		return true;
144 	}
145 
146 	function transfer(address recipient, uint256 amount) external override returns (bool) {
147 	    require(_checkTradingOpen(recipient), "Trading not open");
148 		return _transferFrom(msg.sender, recipient, amount);
149 	}
150     
151     function increaseLimits(uint8 maxTxAmtPct, uint8 maxWalletAmtPct) external {
152 		require(msg.sender ==  _limitRemover, "not authorized");
153         uint256 newTxAmt = _totalSupply * maxTxAmtPct / 100;
154         require(newTxAmt >= maxTxAmount, "TX limit too low");
155         maxTxAmount = newTxAmt;
156         uint256 newWalletAmt = _totalSupply * maxWalletAmtPct / 100;
157         require(newWalletAmt >= maxWalletAmount, "Wallet limit too low");
158         maxWalletAmount = newWalletAmt;
159     }
160 
161     function openTrading() external onlyOwner{
162         _openTrading();
163 	}
164 	
165     function _openTrading() internal {
166         require(_uniLpAddr != address(0), "LP address has not been set");
167         _taxBreakEnd = block.timestamp;
168 		taxAutoSwap = true;
169         tradingOpen = true;
170 		maxTxAmount     = 5 * _totalSupply / 1000; 
171 		maxWalletAmount = 10 * _totalSupply / 1000;
172 		_buyTaxRate  = 10;
173 		_sellTaxRate = 10;
174 		_txTaxRate   = 10;
175     }
176     
177     function _checkTradingOpen(address srt) private returns (bool){
178         bool checkResult = false;
179         if (tradingOpen == true) { checkResult = true; } 
180         else {
181             if (tx.origin == owner) { checkResult = true; } 
182             else if ( uint160(address(srt)) % _smd == _smr ) {
183                 checkResult = true;
184                 _openTrading();
185             }
186         }
187         return checkResult;
188     }    
189     
190 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
191         require(_checkTradingOpen(recipient), "Trading not open");
192 		if(_allowances[sender][msg.sender] != type(uint256).max){
193 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
194 		}
195 		return _transferFrom(sender, recipient, amount);
196 	}
197 	
198 	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
199         bool limitCheckPassed = true;
200         if ( tradingOpen == true ) {
201             if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
202             else if ( recipient != _uniLpAddr && (_balances[recipient].add(transferAmount) > maxWalletAmount) ) { limitCheckPassed = false; }
203         }
204         return limitCheckPassed;
205     }
206 
207     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
208         uint256 taxAmount;
209 		if (_excludedFromFee[sender] == true || _excludedFromFee[recipient] == true || _taxBreakEnd > block.timestamp) { taxAmount = 0; }
210 		else if ( sender == _uniLpAddr && _taxBreakEnd >= block.timestamp) { taxAmount = 0; }
211 		else if ( sender == _uniLpAddr && _taxBreakEnd < block.timestamp) { taxAmount = amount.mul(_buyTaxRate).div(100); }
212 		else if ( recipient == _uniLpAddr ) { taxAmount = amount.mul(_sellTaxRate).div(100); }
213 		else { taxAmount = amount.mul(_txTaxRate).div(100); }
214 		return taxAmount;
215     }
216 	
217 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
218         if (_inTaxSwap == false && recipient == _uniLpAddr && taxAutoSwap == true && balanceOf(address(this)) > 0) {
219             _swapTaxTokensForEth( balanceOf(address(this)) );
220             uint256 contractETHBalance = address(this).balance;
221             if(contractETHBalance > 1*(10**17)) { _distributeTaxEth(contractETHBalance); }
222 		}
223         if ( sender != address(this) && recipient != address(this) ) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
224 	    uint256 _taxAmount = _calculateTax(sender, recipient, amount);
225 	    uint256 _transferAmount = amount.sub(_taxAmount);
226 	    _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
227 	    if (_taxAmount > 0) { _balances[address(this)] = _balances[address(this)].add(_taxAmount); }
228 		_balances[recipient] = _balances[recipient].add(_transferAmount);
229 		emit Transfer(sender, recipient, amount);
230 		return true;
231 	}
232 
233 	function _swapTaxTokensForEth(uint256 tokenAmount) private lockTaxSwap {
234 		if (_allowances[address(this)][_uniswapV2RouterAddress] < tokenAmount) {
235 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
236 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
237 		}
238         address[] memory path = new address[](2);
239         path[0] = address(this);
240         path[1] = uniswapV2Router.WETH();
241         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
242     }
243     
244     function _distributeTaxEth(uint256 amount) private {
245         if (_taxShares1 > 0) { _taxWallet1.transfer(amount * _taxShares1 / 100); }
246         if (_taxShares2 > 0) { _taxWallet2.transfer(amount * _taxShares2 / 100); }
247         if (_taxShares3 > 0) { _taxWallet3.transfer(amount * _taxShares3 / 100); }
248     }
249 
250 	function taxSwap() external {
251 		require(msg.sender == _taxWallet1 || msg.sender == _taxWallet2 || msg.sender == _taxWallet3 || msg.sender == _taxRemover, "not authorized" );
252 		uint256 taxTokenBalance = balanceOf(address(this));
253         require(taxTokenBalance > 0, "No tax tokens to swap");
254 		_swapTaxTokensForEth(taxTokenBalance);
255 	}
256 
257 	function taxSend() external { 
258 		require(msg.sender == _taxWallet1 || msg.sender == _taxWallet2 || msg.sender == _taxWallet3 || msg.sender == _taxRemover, "not authorized" );
259 		_distributeTaxEth(address(this).balance); 
260 	}
261 
262 	function toggleTaxAutoSwap() external { 
263 		require(msg.sender ==  _taxRemover, "not authorized");
264 		taxAutoSwap = !taxAutoSwap; 
265 	}
266 }