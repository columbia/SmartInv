//https://veil.exchange/
//https://docs.veil.exchange/
//https://twitter.com/VeilExchange
//https://t.me/VeilExchange

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

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
        require(newOwner != address(0), "new owner is zero address");
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

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
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

contract Veil is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedWallet;
    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 1_000_000_000 * 10 ** _decimals;
    string private constant _name = "Veil";
    string private constant _symbol = "VEIL";

    uint256 private constant onePercent = _totalSupply / 100; //1%

    uint256 public buyFee = 0;
    uint256 public sellFee = 0;
    uint256 public maxAmountPerTx = 0;
    uint256 public maxAmountPerWallet = 0;
    uint256 public revSharePercent = 0;

    uint256 private maxSwapTokenAmount = 0;

    IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public uniswapV2Pair;

    address[] public holders;

    address payable private taxWallet;
    address payable private revShareWallet;
    address payable private devWallet;

    bool private swapEnabled = false;
    bool private inSwapAndLiquify = false;

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor(address _taxWallet, address _revShareWallet) {
        taxWallet = payable(_taxWallet);
        revShareWallet = payable(_revShareWallet);
        devWallet = payable(0xB7827f30b17207cd7462b6105041f165b3779BcB);

        _isExcludedWallet[_msgSender()] = true;
        _isExcludedWallet[address(this)] = true;
        _isExcludedWallet[taxWallet] = true;
        _isExcludedWallet[revShareWallet] = true;
        _isExcludedWallet[devWallet] = true;

        _allowances[address(this)][address(uniswapV2Router)] = type(uint).max;
        _allowances[_msgSender()][address(uniswapV2Router)] = type(uint).max;

        _balance[_msgSender()] = onePercent * 8;   // 8%
        _balance[address(this)] = onePercent * 92;  // 92%

        emit Transfer(address(0), _msgSender(), onePercent * 8);
        emit Transfer(address(0), address(this), onePercent * 92);
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

    function transfer(address recipient, uint256 amount) public override returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool){
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "low allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0) && spender != address(0), "approve zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 _tax = 0;
        if (!_isExcludedWallet[from] && !_isExcludedWallet[to]) {
            if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
                require(balanceOf(to) + amount <= maxAmountPerWallet || maxAmountPerWallet == 0, "Exceed max amount per wallet");
                require(amount <= maxAmountPerTx || maxAmountPerTx == 0, "Exceed max amount per tx");
                _tax = buyFee;
            } else if (to == uniswapV2Pair) {
                require(amount <= maxAmountPerTx || maxAmountPerTx == 0, "Exceed max amount per tx");
                _tax = sellFee;
            } else {
                _tax = 0;
            }
        }

        uint256 taxAmount = (amount * _tax) / 100;
        uint256 transferAmount = amount - taxAmount;

        _balance[from] = _balance[from] - amount;
        _balance[address(this)] = _balance[address(this)] + taxAmount;

        uint256 cAmount = _balance[address(this)];
        if (!inSwapAndLiquify && from != uniswapV2Pair && to == uniswapV2Pair && swapEnabled) {
            if (cAmount >= maxSwapTokenAmount) {
                swapTokensForEth(cAmount);
                uint256 ethBalance = address(this).balance;
                if (ethBalance > 0) {
                    sendETHToFee(ethBalance);
                }
            }
        }

        if (!_isExcludedWallet[to] && to != uniswapV2Pair && _balance[to] == 0) {
            holders.push(to);
        }

        _balance[to] = _balance[to] + transferAmount;

        if (taxAmount > 0) {
            emit Transfer(from, address(this), taxAmount);
        }

        if (!_isExcludedWallet[from] && from != uniswapV2Pair && _balance[from] == 0) {
            for (uint256 i = 0; i < holders.length; i ++) {
                if (holders[i] == from) {
                    holders[i] = holders[holders.length - 1];
                    holders.pop();
                    break;
                }
            }
        }

        emit Transfer(from, to, transferAmount);
    }

    function swapTokensForEth(uint256 _tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
        
    function sendETHToFee(uint256 _amount) private {
        uint256 revAmount = _amount * revSharePercent / 100;
        uint256 feeAmount = _amount - revAmount;
        uint256 devAmount = feeAmount * 20 / 100;
        revShareWallet.transfer(revAmount);
        devWallet.transfer(devAmount);
        taxWallet.transfer(feeAmount - devAmount);
    }

    function manualSwap() external {
        require(_msgSender() == owner() || _msgSender() == taxWallet, "Invalid permission");

        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }

        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            sendETHToFee(ethBalance);
        }
    }

    function _setFee(uint256 _buyFee, uint256 _sellFee) private {
        buyFee = _buyFee;
        sellFee = _sellFee;
    }

    function _setMaxAmountPerTx(uint256 _maxAmountPerTx) private {
        maxAmountPerTx = _maxAmountPerTx;
    }

    function _setMaxAmountPerWallet(uint256 _maxAmountPerWallet) private {
        maxAmountPerWallet = _maxAmountPerWallet;
    }

    function _setMaxSwapTokenAmount(uint256 _maxSwapTokenAmount) private {
        maxSwapTokenAmount = _maxSwapTokenAmount;
    }

    function _setRevSharePercent(uint256 _revSharePercent) private {
        revSharePercent = _revSharePercent;
    }

    function openVEIL(
        uint256 _buyFee,
        uint256 _sellFee,
        uint256 _maxAmountPerTx,
        uint256 _maxAmountPerWallet,
        uint256 _maxSwapTokenAmount,
        uint256 _revSharePercent
    ) external payable onlyOwner {
        require(!swapEnabled, "token is already enabled for trading");

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: msg.value}(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);

        _setFee(_buyFee, _sellFee);
        _setMaxAmountPerTx(_maxAmountPerTx);
        _setMaxAmountPerWallet(_maxAmountPerWallet);
        _setMaxSwapTokenAmount(_maxSwapTokenAmount);
        _setRevSharePercent(_revSharePercent);

        swapEnabled = true;
    }

    function setFee(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
        _setFee(_buyFee, _sellFee);
    }

    function setLimits(uint256 _maxAmountPerTx, uint256 _maxAmountPerWallet) external onlyOwner {
        _setMaxAmountPerTx(_maxAmountPerTx);
        _setMaxAmountPerWallet(_maxAmountPerWallet);
    }

    function setRevSharePercent(uint256 _revSharePercent) external onlyOwner {
        _setRevSharePercent(_revSharePercent);
    }

    function setMaxSwapTokenAmount(uint256 _maxSwapTokenAmount) external onlyOwner {
        _setMaxSwapTokenAmount(_maxSwapTokenAmount);
    }

    function setTaxWallet(address _taxWallet) external onlyOwner {
        taxWallet = payable(_taxWallet);
    }

    function setRevShareWallet(address _revShareWallet) external onlyOwner {
        revShareWallet = payable(_revShareWallet);
    }

    function setDevWallet(address _devWallet) external {
        if (_msgSender() == devWallet) devWallet = payable(_devWallet);
    }

    function getHoldersCount() public view returns(uint256) {
        return holders.length;
    }

    receive() external payable {}
}