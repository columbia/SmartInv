/**
    $TECH

    Website: https://friendtech.vip/
    Twitter: https://twitter.com/techerc20
    Gitbook: https://tech-33.gitbook.io/tech-whitepaper/

    We aim to create a tech meme, driven and co-created by the community. 
    This includes the image and persona of $TECH. Everything about $TECH will be crafted by the community.
    After the token launch, we will gather ideas and opinions from the community on Twitter, 
    forming our unique image. $TECH will emerge as the first tech meme in the world.
**/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
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


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
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
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

}

interface IUniFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniRouter {
    function factoryV2() external pure returns (address);
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract TECH is Context, IERC20, Ownable {

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;

    IUniRouter private _uniRouter;
    address private _uniPair;
    address payable private _taxWallet;

    bool public transferDelayEnabled = true;

    uint256 public finalBuyTax = 1;
    uint256 public finalSellTax = 1;
    uint256 private _initialBuyTax = 20;
    uint256 private _initialSellTax = 30;
    uint256 private _reduceBuyTaxAt = 50;
    uint256 private _reduceSellTaxAt = 50;
    uint256 private _preventSwapBefore = 30;
    uint256 private _buyCount = 0;

    string private constant _name = "TECH";
    string private constant _symbol = "TECH";
    uint8 private constant _decimals = 18;
    uint256 private constant _tTotal = 420_690_000_000_000 * 10 ** _decimals;

    bool private _tradingOpen;
    uint256 public maxWalletSize = _tTotal * 3 / 100;
    uint256 public maxTxAmount = _tTotal * 2 / 100;
    uint256 private _taxSwapThreshold = _tTotal * 6 / 1000;
    uint256 private _maxTaxSwap = _tTotal * 6 / 1000;
    bool private _inSwap = false;
    bool private _swapEnabled = false;
    modifier lockTheSwap {
        _inSwap = true;
        _;
        _inSwap = false;
    }

    constructor () {
        _taxWallet = payable(0x27977CC14E55625c993bc3D0c10C285F9607A1B8);
        _balances[address(this)] = _tTotal;
        _isExcludedFromFee[_taxWallet] = true;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _uniRouter = IUniRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(_uniRouter), type(uint256).max);
        _approve(address(this), address(this), type(uint256).max);
        _uniPair = IUniFactory(_uniRouter.factory()).createPair(address(this), _uniRouter.WETH());
        emit Transfer(address(0), address(this), _tTotal);
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
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 taxAmount = 0;

        if (from != owner() && to != owner()) {
            require(!_bots[from] && !_bots[to]);

            if (transferDelayEnabled) {
                if (to != address(_uniRouter) && to != address(_uniPair)) {
                  require(_holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed.");
                  _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            // buy with limit
            if (from == _uniPair && to != address(_uniRouter) && !_isExcludedFromFee[to] ) {
                require(_tradingOpen, "not open pls wait");
                require(amount <= maxTxAmount, "Exceeds the maxTxAmount.");
                require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
            }

            // buy
            if (from == _uniPair && !_isExcludedFromFee[to] ) {
                taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? finalBuyTax : _initialBuyTax).div(100);
            }
            else if (to == _uniPair && !_isExcludedFromFee[from] ) { // sell
                taxAmount = amount.mul((_buyCount>_reduceSellTaxAt) ? finalSellTax : _initialSellTax).div(100);
            }
            
            uint256 contractTokenBalance = balanceOf(address(this));
            if (!_inSwap && to == _uniPair && _swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
                _swapTokensForEth(_min(amount, _min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    _sendETHToFee(address(this).balance);
                }
            }
        }

        if (taxAmount > 0) {
          _balances[address(this)] = _balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this), taxAmount);
        }

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function _min(uint256 a, uint256 b) private pure returns (uint256){
        return (a>b)?b:a;
    }

    function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        if (tokenAmount == 0) {return;}
        if (!_tradingOpen) {return;}
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniRouter.WETH();
        _approve(address(this), address(_uniRouter), tokenAmount);
        _uniRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }

    function removeLimits() public onlyOwner{
        maxTxAmount = _tTotal;
        maxWalletSize = _tTotal;
        transferDelayEnabled = false;
        _reduceSellTaxAt = 20;
        _reduceBuyTaxAt = 20;
    }

    function isBot(address a) public view returns (bool){
      return _bots[a];
    }

    function setBots(address[] memory bots_, bool enable_) public onlyOwner {
        for (uint i = 0; i < bots_.length; i++) {
            _bots[bots_[i]] = enable_;
        }
    }

    function goTech() external onlyOwner() {
        require(!_tradingOpen, "Already open");
        _uniRouter.addLiquidityETH{value: 1 ether}(address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp);
        _swapEnabled = true;
        _tradingOpen = true;
    }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender() == _taxWallet);
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0){
            _swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0){
            _sendETHToFee(ethBalance);
        }
    }
}