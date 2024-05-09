1 /*
2 https://t.me/c/1848648579/249639
3 */
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
8 abstract contract Context {
9 function _msgSender() internal view virtual returns (address) {
10         return msg.sender;}function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}
11 }
12 
13 abstract contract Ownable is Context {
14     address private _owner;
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     constructor() {_transferOwnership(_msgSender());}
17     function owner() public view virtual returns (address) {return _owner;}
18     modifier onlyOwner() { require(owner() == _msgSender(), "Ownable: caller is not the owner");  _; }
19     function renounceOwnership() public virtual onlyOwner { _transferOwnership(address(0));}
20     function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
21     function _transferOwnership(address newOwner) internal virtual { address oldOwner = _owner;  _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner); }
22 }
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient,  uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 interface IERC20Metadata is IERC20 {
34    function name() external view returns (string memory);function symbol() external view returns (string memory);function decimals() external view returns (uint8);
35 }
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) private _balances; mapping(address => mapping(address => uint256)) private _allowances;
38     uint256 private _totalSupply;
39     string private _name; string private _symbol;
40     constructor(string memory name_, string memory symbol_) {  _name = name_; _symbol = symbol_;}
41     function name() public view virtual override returns (string memory) { return _name;}
42     function symbol() public view virtual override returns (string memory) { return _symbol; }
43     function decimals() public view virtual override returns (uint8) {  return 18; }
44     function totalSupply() public view virtual override returns (uint256) { return _totalSupply;}
45     function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
46     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {_transfer(_msgSender(), recipient, amount);return true;}
47     function allowance(address owner, address spender) public view virtual override returns (uint256) {return _allowances[owner][spender];}
48     function approve(address spender, uint256 amount) public virtual override returns (bool) {_approve(_msgSender(), spender, amount); return true;}
49     function transferFrom(address sender, address recipient,uint256 amount) public virtual override returns (bool) { _transfer(sender, recipient, amount);uint256 currentAllowance = _allowances[sender][_msgSender()];require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");unchecked {_approve(sender, _msgSender(), currentAllowance - amount);}return true;}
50     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {_approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);return true;}
51     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {uint256 currentAllowance = _allowances[_msgSender()][spender];require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");unchecked {_approve(_msgSender(), spender, currentAllowance - subtractedValue);}return true;}
52     function _transfer(address sender,address recipient,uint256 amount) internal virtual {require(sender != address(0), "ERC20: transfer from the zero address"); require(recipient != address(0), "ERC20: transfer to the zero address");_beforeTokenTransfer(sender, recipient, amount);uint256 senderBalance = _balances[sender];require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");unchecked { _balances[sender] = senderBalance - amount;}_balances[recipient] += amount;emit Transfer(sender, recipient, amount);_afterTokenTransfer(sender, recipient, amount);}
53     function _mint(address account, uint256 amount) internal virtual {require(account != address(0), "ERC20: mint to the zero address");_beforeTokenTransfer(address(0), account, amount);_totalSupply += amount;_balances[account] += amount;emit Transfer(address(0), account, amount);_afterTokenTransfer(address(0), account, amount);}
54     function _burn(address account, uint256 amount) internal virtual {require(account != address(0), "ERC20: burn from the zero address");_beforeTokenTransfer(account, address(0), amount);uint256 accountBalance = _balances[account];require(accountBalance >= amount, "ERC20: burn amount exceeds balance");unchecked { _balances[account] = accountBalance - amount;}_totalSupply -= amount;emit Transfer(account, address(0), amount);_afterTokenTransfer(account, address(0), amount);}
55     function _approve(address owner, address spender,uint256 amount) internal virtual {require(owner != address(0), "ERC20: approve from the zero address");require(spender != address(0), "ERC20: approve to the zero address");_allowances[owner][spender] = amount;emit Approval(owner, spender, amount);}
56     function _beforeTokenTransfer(address from,address to, uint256 amount) internal virtual {}
57     function _afterTokenTransfer(address from,  address to, uint256 amount) internal virtual {}
58 }
59 
60 
61 library SafeMath {
62     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked { uint256 c = a + b;if (c < a) return (false, 0); return (true, c);}}
63     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {if (b > a) return (false, 0); return (true, a - b);}}
64     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked { if (a == 0) return (true, 0);uint256 c = a * b;if (c / a != b) return (false, 0); return (true, c);}}
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {if (b == 0) return (false, 0);return (true, a / b); }}
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { if (b == 0) return (false, 0); return (true, a % b);}}
67     function add(uint256 a, uint256 b) internal pure returns (uint256) { return a + b;}
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) { return a - b;}
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) { return a * b; }
70     function div(uint256 a, uint256 b) internal pure returns (uint256) { return a / b; }
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) { return a % b;  }
72     function sub( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {unchecked { require(b <= a, errorMessage); return a - b;  } }
73     function div(uint256 a,  uint256 b,  string memory errorMessage ) internal pure returns (uint256) {unchecked {   require(b > 0, errorMessage);  return a / b; }}
74     function mod(uint256 a, uint256 b,  string memory errorMessage) internal pure returns (uint256) { unchecked {  require(b > 0, errorMessage);    return a % b;  }}
75 }
76 interface IUniswapV2Factory {
77     event PairCreated( address indexed token0, address indexed token1, address pair, uint256);
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint256) external view returns (address pair);
82     function allPairsLength() external view returns (uint256);
83     function createPair(address tokenA, address tokenB)external returns (address pair);
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87 interface IUniswapV2Pair {
88     event Approval(address indexed owner, address indexed spender,uint256 value);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     function name() external pure returns (string memory);
91     function symbol() external pure returns (string memory);
92     function decimals() external pure returns (uint8);
93     function totalSupply() external view returns (uint256);
94     function balanceOf(address owner) external view returns (uint256);
95     function allowance(address owner, address spender)external view returns (uint256);
96     function approve(address spender, uint256 value) external returns (bool);
97     function transfer(address to, uint256 value) external returns (bool);
98     function transferFrom( address from,address to,uint256 value) external returns (bool);
99     function DOMAIN_SEPARATOR() external view returns (bytes32);
100     function PERMIT_TYPEHASH() external pure returns (bytes32);
101     function nonces(address owner) external view returns (uint256);
102     function permit(address owner, address spender, uint256 value, uint256 deadline,  uint8 v, bytes32 r,bytes32 s) external;
103     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
104     event Burn(address indexed sender,uint256 amount0,uint256 amount1,address indexed to);
105     event Swap( address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
106     event Sync(uint112 reserve0, uint112 reserve1);
107     function MINIMUM_LIQUIDITY() external pure returns (uint256);
108     function factory() external view returns (address);
109     function token0() external view returns (address);
110     function token1() external view returns (address);
111     function getReserves()external view returns ( uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
112     function price0CumulativeLast() external view returns (uint256);
113     function price1CumulativeLast() external view returns (uint256);
114     function Last() external view returns (uint256);
115     function mint(address to) external returns (uint256 liquidity);
116     function burn(address to)external returns (uint256 amount0, uint256 amount1);
117     function swap(uint256 amount0Out,uint256 amount1Out,address to,bytes calldata data) external;
118     function skim(address to) external;
119     function sync() external;
120     function initialize(address, address) external;
121 }
122 interface IUniswapV2Router02 {
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidity( address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns ( uint256 amountA,  uint256 amountB,uint256 liquidity);
126     function addLiquidityETH(address token,  uint256 amountTokenDesired,  uint256 amountTokenMin,  uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken,uint256 amountETH, uint256 liquidity);
127     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn,uint256 amountOutMin,address[] calldata path,address to,uint256 deadline) external;
128     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,address[] calldata path,address to,uint256 deadline) external payable;
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn,uint256 amountOutMin,address[] calldata path,address to,uint256 deadline) external;
130 }
131 contract ERMN is ERC20, Ownable {
132     using SafeMath for uint256;
133     IUniswapV2Router02 public immutable uniswapV2Router;
134     address public immutable uniswapV2Pair;
135     address public constant deadAddress = address(0xdead);
136     bool private swapping;
137     address public marketingWallet;address public devWallet;
138     uint256 public maxTransactionAmount;uint256 public maxWallet;uint256 public swapTokensAtAmount;
139     bool public lpBurnEnabled = true;uint256 public lpBurnFrequency = 3600 seconds;uint256 public lastLpBurnTime;uint256 public manualBurnFrequency = 30 minutes; uint256 public lastManualLpBurnTime;uint256 public percentForLPBurn = 25; // 25 = .25%
140     bool public swapEnabled = true; bool public limitsInEffect = true;
141     mapping(address => uint256) private _holderLastTransferTimestamp; bool public transferDelayEnabled = true;
142     uint256 public buyTotalFees; uint256 public buyMarketingFee; uint256 public buyLiquidityFee; uint256 public buyDevFee;uint256 public sellTotalFees;uint256 public sellMarketingFee;uint256 public sellLiquidityFee;
143     uint256 public sellDevFee; uint256 public tokensForMarketing; uint256 public tokensForLiquidity;uint256 public tokensForDev;
144     /******************/
145     mapping(address => bool) private _isExcludedFromFees; mapping(address => bool) public _isExcludedMaxTransactionAmount; mapping(address => bool) public automatedMarketMakerPairs;
146     event UpdateUniswapV2Router(address indexed newAddress,address indexed oldAddress);
147     event ExcludeFromFees(address indexed account, bool isExcluded);
148     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
149     event marketingWalletUpdated(address indexed newWallet,address indexed oldWallet);
150     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiquidity);
151     event devWalletUpdated(address indexed newWallet,address indexed oldWallet);
152     event ManualNukeLP(); 
153     event AutoNukeLP();
154 
155     constructor() ERC20("Ermn Musk", "ERMN") {
156         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
157         excludeFromMaxTransaction(address(_uniswapV2Router), true);  uniswapV2Router = _uniswapV2Router;  uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true);_setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
158         uint256 _buyMarketingFee = 0; uint256 _buyLiquidityFee = 0; uint256 _buyDevFee = 20; uint256 _sellMarketingFee = 0;uint256 _sellLiquidityFee = 0;uint256 _sellDevFee = 80;uint256 totalSupply = 1_000_000 * 1e18;
159         maxTransactionAmount = 20_000 * 1e18;  maxWallet = 20_000 * 1e18; swapTokensAtAmount = (totalSupply * 10) / 10000; 
160         buyMarketingFee = _buyMarketingFee; buyLiquidityFee = _buyLiquidityFee; buyDevFee = _buyDevFee; buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee; sellMarketingFee = _sellMarketingFee;sellLiquidityFee = _sellLiquidityFee; sellDevFee = _sellDevFee; sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
161         marketingWallet = address(0x83f9A87BEe11138b3501c31461700904c6CA1bD9); // set as marketing wallet
162         devWallet = address(0x83f9A87BEe11138b3501c31461700904c6CA1bD9); // set as dev wallet
163         excludeFromFees(owner(), true);excludeFromFees(address(this), true); excludeFromFees(address(0xdead), true);excludeFromMaxTransaction(owner(), true); excludeFromMaxTransaction(address(this), true); excludeFromMaxTransaction(address(0xdead), true); _mint(msg.sender, totalSupply);
164     }
165 
166     receive() external payable {}
167     function disableLimits() external onlyOwner returns (bool) { limitsInEffect = false;return true;}
168     function disableTransferDelay() external onlyOwner returns (bool) {transferDelayEnabled = false;return true;}
169     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){ require( newAmount >= (totalSupply() * 1) / 100000,"Swap amount cannot be lower than 0.001% total supply."); require(newAmount <= (totalSupply() * 5) / 1000,"Swap amount cannot be higher than 0.5% total supply."); swapTokensAtAmount = newAmount; return true;}
170     function updateTransactionLimits(uint256 newNumTx, uint256 newNumWallet) external onlyOwner { require(newNumTx >= ((totalSupply() * 1) / 1000) / 1e18,"Cannot set maxTransactionAmount lower than 0.1%");maxTransactionAmount = newNumTx * (10**18);require(newNumWallet >= ((totalSupply() * 5) / 1000) / 1e18,"Cannot set maxWallet lower than 0.5%");maxWallet = newNumWallet * (10**18);}
171     function excludeFromMaxTransaction(address updAds, bool isEx)  public onlyOwner{_isExcludedMaxTransactionAmount[updAds] = isEx;}
172     function setSwapback(bool enabled) external onlyOwner {swapEnabled = enabled;}
173     function updateFeePercent(uint256 _buyMarketingFee,  uint256 _buyLiquidityFee, uint256 _buyDevFee,  uint256 _sellMarketingFee, uint256 _sellLiquidityFee, uint256 _sellDevFee) external onlyOwner{buyMarketingFee = _buyMarketingFee;buyLiquidityFee = _buyLiquidityFee;buyDevFee = _buyDevFee;buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;require(buyTotalFees <= 33, "Must keep fees at 33% or less"); sellMarketingFee = _sellMarketingFee;sellLiquidityFee = _sellLiquidityFee; sellDevFee = _sellDevFee;sellTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;require(buyTotalFees <= 75, "Must keep fees at 75% or less");}
174     function excludeFromFees(address account, bool excluded) public onlyOwner {_isExcludedFromFees[account] = excluded;emit ExcludeFromFees(account, excluded);}
175     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner{require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs"); _setAutomatedMarketMakerPair(pair, value);}
176     function _setAutomatedMarketMakerPair(address pair, bool value) private {automatedMarketMakerPairs[pair] = value;emit SetAutomatedMarketMakerPair(pair, value);}
177     function updateMarketingWallet(address newMarketingWallet) external onlyOwner{emit marketingWalletUpdated(newMarketingWallet, marketingWallet);marketingWallet = newMarketingWallet;}
178     function updateDevWallet(address newWallet) external onlyOwner {emit devWalletUpdated(newWallet, devWallet);devWallet = newWallet;}
179     function isExcludedFromFees(address account) public view returns (bool) {return _isExcludedFromFees[account];}
180     event BoughtEarly(address indexed sniper);
181     function _transfer(address from, address to,uint256 amount) internal override {require(from != address(0), "ERC20: transfer from the zero address");require(to != address(0), "ERC20: transfer to the zero address");if (amount == 0) {super._transfer(from, to, 0); return;}if (limitsInEffect) {if (from != owner() && to != owner() &&to != address(0) &&to != address(0xdead) &&!swapping) {if (transferDelayEnabled) { if ( to != owner() &&to != address(uniswapV2Router) &&to != address(uniswapV2Pair)) {require(_holderLastTransferTimestamp[tx.origin] <block.number,"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");_holderLastTransferTimestamp[tx.origin] = block.number;}} if (automatedMarketMakerPairs[from] &&!_isExcludedMaxTransactionAmount[to]) {require(amount <= maxTransactionAmount,"Buy transfer amount exceeds the maxTransactionAmount.");require( amount + balanceOf(to) <= maxWallet,"Max wallet exceeded");}else if (automatedMarketMakerPairs[to] &&!_isExcludedMaxTransactionAmount[from]) {require(amount <= maxTransactionAmount,"Sell transfer amount exceeds the maxTransactionAmount.");} else if (!_isExcludedMaxTransactionAmount[to]) {require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");}}}uint256 contractTokenBalance = balanceOf(address(this));bool canSwap = contractTokenBalance >= swapTokensAtAmount;if (canSwap &&swapEnabled &&!swapping &&!automatedMarketMakerPairs[from] &&!_isExcludedFromFees[from] &&!_isExcludedFromFees[to]) {swapping = true;swapBack();swapping = false;}if (!swapping &&automatedMarketMakerPairs[to] &&lpBurnEnabled &&block.timestamp >= lastLpBurnTime + lpBurnFrequency &&!_isExcludedFromFees[from]) {autoBurnLiquidityPairTokens();}bool takeFee = !swapping;if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {takeFee = false;}uint256 fees = 0; if (takeFee) {if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {fees = amount.mul(sellTotalFees).div(100);tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;tokensForDev += (fees * sellDevFee) / sellTotalFees;tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;}else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {fees = amount.mul(buyTotalFees).div(100);tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;tokensForDev += (fees * buyDevFee) / buyTotalFees;tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;}if (fees > 0) {super._transfer(from, address(this), fees);}amount -= fees;}super._transfer(from, to, amount);}
182     function swapTokensForEth(uint256 tokenAmount) private {address[] memory path = new address[](2);path[0] = address(this);path[1] = uniswapV2Router.WETH();_approve(address(this), address(uniswapV2Router), tokenAmount);uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0, path,address(this), block.timestamp);}
183     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {_approve(address(this), address(uniswapV2Router), tokenAmount);uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0, 0, deadAddress,block.timestamp);}
184     function swapBack() private {uint256 contractBalance = balanceOf(address(this));uint256 totalTokensToSwap = tokensForLiquidity +tokensForMarketing +tokensForDev;bool success;if (contractBalance == 0 || totalTokensToSwap == 0) { return;}if (contractBalance > swapTokensAtAmount * 20) {contractBalance = swapTokensAtAmount * 20;}uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /totalTokensToSwap /2;uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);uint256 initialETHBalance = address(this).balance;swapTokensForEth(amountToSwapForETH);uint256 ethBalance = address(this).balance.sub(initialETHBalance);uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;tokensForLiquidity = 0;tokensForMarketing = 0;tokensForDev = 0;(success, ) = address(devWallet).call{value: ethForDev}("");if (liquidityTokens > 0 && ethForLiquidity > 0) {addLiquidity(liquidityTokens, ethForLiquidity);emit SwapAndLiquify(amountToSwapForETH,ethForLiquidity,tokensForLiquidity);}(success, ) = address(marketingWallet).call{value: address(this).balance}("");}
185     function setAutoLPBurnSettings(uint256 _frequencyInSeconds,uint256 _percent,bool _Enabled) external onlyOwner {require(_frequencyInSeconds >= 600,"cannot set buyback more often than every 10 minutes");require(_percent <= 1000 && _percent >= 0,"Must set auto LP burn percent between 0% and 10%");lpBurnFrequency = _frequencyInSeconds;percentForLPBurn = _percent;lpBurnEnabled = _Enabled;}
186     function autoBurnLiquidityPairTokens() internal returns (bool) {lastLpBurnTime = block.timestamp;uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);if (amountToBurn > 0) {super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);}IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);pair.sync();emit AutoNukeLP();return true;}
187     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency,"Must wait for cooldown to finish");require(percent <= 1000, "May not nuke more than 10% of tokens in LP");lastManualLpBurnTime = block.timestamp;uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);if (amountToBurn > 0) {super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);} IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);pair.sync(); emit ManualNukeLP();return true;}
188 }