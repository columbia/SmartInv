/* The Doge Killer Rebirthed

Telegram: https://t.me/Shiba_Portal
Twitter: https://twitter.com/RebirthOfShiba
Website: https://www.shibacoin.tech/
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwnr
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
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwnr) public virtual onlyOwner {
        require(
            newOwnr != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwnr);
        _owner = newOwnr;
    }
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Pair {
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function factory() external view returns (address);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract LockToken is Ownable {
    bool public isOpen = false;
    mapping(address => bool) private _whiteList;
    modifier open(address from, address to) {
        require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
        _;
    }

    constructor() {
        _whiteList[msg.sender] = true;
        _whiteList[address(this)] = true;
    }

    function openTrade() external onlyOwner {
        isOpen = true;
    }

    function includeToWhiteList(address _address) public onlyOwner {
        _whiteList[_address] = true;
    }
}

contract SHIBA is Context, IERC20, LockToken {
    using SafeMath for uint256;
    address payable public marketingWallet =
        payable(0x44343Bae9f6d8dB1d5b0614783EE22a0A36D5F5b);
    address payable public devWallet =
        payable(0x44343Bae9f6d8dB1d5b0614783EE22a0A36D5F5b);
    address public newOwnr = 0xb640b82989Ba33B221685f0305Fa29b2Bfa2F11E;
    address public uniRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _feeWhitelisted;
    mapping(address => bool) private _limitWhitelisted;
    mapping(address => bool) private _isExcluded;
    address[] private _excluded;
    string private _name = "Shiba";
    string private _symbol = "SHIBA";
    uint8 private _decimals = 18;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1000000000000000 * 10 ** 18;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 public _liquidityFeeBuys = 0;
    uint256 public _marketingFeeBuys = 300;
    uint256 public _devFeeBuys = 0;
    uint256 public _totalFeeBuys =
        _liquidityFeeBuys + _marketingFeeBuys + _devFeeBuys;
    uint256[] buyFeesBackup = [_liquidityFeeBuys, _marketingFeeBuys, _devFeeBuys];
    uint256 public _liquidityFeeSells = 0;
    uint256 public _marketingFeeSells = 300;
    uint256 public _devFeeSells = 0;
    uint256 public _totalFeeSells =
        _liquidityFeeSells + _marketingFeeSells + _devFeeSells;

    uint256 public _liquidityTokens = 0;
    uint256 public _marketingTokens = 0;
    uint256 public _devTokens = 0;
    uint256 public transferTotalFee =
        _liquidityTokens + _marketingTokens + _devTokens;

    uint256 public _txLimit = _tTotal.div(100).mul(1); //x% of total supply
    uint256 public _walletLimit = _tTotal.div(100).mul(2); //x% of total supply
    uint256 private _minBalanceForSwapback = 10000000000000 * 10 ** 18;

    IUniswapV2Router02 public immutable uniRouterContract;
    address public immutable uniPair;

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    event SwapTokensForETH(uint256 amountIn, address[] path);

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        _rOwned[newOwnr] = _rTotal;
        IUniswapV2Router02 _uniRouterContract = IUniswapV2Router02(uniRouter);
        uniPair = IUniswapV2Factory(_uniRouterContract.factory())
            .createPair(address(this), _uniRouterContract.WETH());
        uniRouterContract = _uniRouterContract;
        _feeWhitelisted[newOwnr] = true;
        _feeWhitelisted[address(this)] = true;
        includeToWhiteList(newOwnr);
        _limitWhitelisted[newOwnr] = true;
        emit Transfer(address(0), newOwnr, _tTotal);
        excludeWalletsFromWhales();

        transferOwnership(newOwnr);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function _minBalanceForSwapbackAmount() public view returns (uint256) {
        return _minBalanceForSwapback;
    }

    function tokenFromReflection(
        uint256 rAmount
    ) private view returns (uint256) {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private open(from, to) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (from != owner() && to != owner()) {
            require(
                amount <= _txLimit,
                "Transfer amount exceeds the maxTxAmount."
            );
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinimumTokenBalance = contractTokenBalance >=
            _minBalanceForSwapback;

        checkForWhale(from, to, amount);

        if (
            !inSwapAndLiquify && swapAndLiquifyEnabled && from != uniPair
        ) {
            if (overMinimumTokenBalance) {
                contractTokenBalance = _minBalanceForSwapback;
                swapTokens(contractTokenBalance);
            }
        }

        bool takeFee = true;

        //if any account belongs to _feeWhitelisted account then remove the fee
        if (_feeWhitelisted[from] || _feeWhitelisted[to]) {
            takeFee = false;
        }
        _tokenTransfer(from, to, amount, takeFee);
    }

    function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
        uint256 ___totalFeeBuys = _liquidityFeeBuys.add(_marketingFeeBuys).add(
            _devFeeBuys
        );
        uint256 ___totalFeeSells = _liquidityFeeSells.add(_marketingFeeSells).add(
            _devFeeSells
        );
        uint256 totalSwapableFees = ___totalFeeBuys.add(___totalFeeSells);

        uint256 halfLiquidityTokens = contractTokenBalance
            .mul(_liquidityFeeBuys + _liquidityFeeSells)
            .div(totalSwapableFees)
            .div(2);
        uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
        swapTokensForEth(swapableTokens);

        uint256 newBalance = address(this).balance;
        uint256 ethForLiquidity = newBalance
            .mul(_liquidityFeeBuys + _liquidityFeeSells)
            .div(totalSwapableFees)
            .div(2);

        if (halfLiquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(halfLiquidityTokens, ethForLiquidity);
        }

        uint256 ethForMarketing = newBalance
            .mul(_marketingFeeBuys + _marketingFeeSells)
            .div(totalSwapableFees);
        if (ethForMarketing > 0) {
            marketingWallet.transfer(ethForMarketing);
        }

        uint256 ethForDev = newBalance.sub(ethForLiquidity).sub(
            ethForMarketing
        );
        if (ethForDev > 0) {
            devWallet.transfer(ethForDev);
        }
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniRouterContract.WETH();
        _approve(address(this), address(uniRouterContract), tokenAmount);
        uniRouterContract.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
        emit SwapTokensForETH(tokenAmount, path);
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniRouterContract), tokenAmount);

        // add the liquidity
        uniRouterContract.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) {
            removeAllFee();
        } else {
            if (recipient == uniPair) {
                setSellFee();
            }

            if (sender != uniPair && recipient != uniPair) {
                setWalletToWalletTransferFee();
            }
        }

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        restoreAllFee();
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tLiquidity > 0) {
            emit Transfer(sender, address(this), tLiquidity);
        }
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tLiquidity > 0) {
            emit Transfer(sender, address(this), tLiquidity);
        }
    }

    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tLiquidity > 0) {
            emit Transfer(sender, address(this), tLiquidity);
        }
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tLiquidity > 0) {
            emit Transfer(sender, address(this), tLiquidity);
        }
    }

    function _getValues(
        uint256 tAmount
    ) private view returns (uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount) = _getRValues(
            tAmount,
            tLiquidity,
            _getRate()
        );
        return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
    }

    function _getTValues(
        uint256 tAmount
    ) private view returns (uint256, uint256) {
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tLiquidity);
        return (tTransferAmount, tLiquidity);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tLiquidity,
        uint256 currentRate
    ) private pure returns (uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rLiquidity);
        return (rAmount, rTransferAmount);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if (_isExcluded[address(this)]) {
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
        }
    }

    function calculateLiquidityFee(
        uint256 _amount
    ) private view returns (uint256) {
        uint256 fees = _liquidityFeeBuys.add(_marketingFeeBuys).add(_devFeeBuys);
        return _amount.mul(fees).div(1000);
    }

    function isExcludedFromFee(
        address account
    ) public view onlyOwner returns (bool) {
        return _feeWhitelisted[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _feeWhitelisted[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _feeWhitelisted[account] = false;
    }

    function removeAllFee() private {
        _liquidityFeeBuys = 0;
        _marketingFeeBuys = 0;
        _devFeeBuys = 0;
    }

    function restoreAllFee() private {
        _liquidityFeeBuys = buyFeesBackup[0];
        _marketingFeeBuys = buyFeesBackup[1];
        _devFeeBuys = buyFeesBackup[2];
    }

    function setSellFee() private {
        _liquidityFeeBuys = _liquidityFeeSells;
        _marketingFeeBuys = _marketingFeeSells;
        _devFeeBuys = _devFeeSells;
    }

    function setWalletToWalletTransferFee() private {
        _liquidityFeeBuys = _liquidityTokens;
        _marketingFeeBuys = _marketingTokens;
        _devFeeBuys = _devTokens;
    }

    function _setBuyFees(
        uint256 _liquidityFee,
        uint256 _marketingFee,
        uint256 _devFee
    ) external onlyOwner {
        _liquidityFeeBuys = _liquidityFee;
        _marketingFeeBuys = _marketingFee;
        _devFeeBuys = _devFee;
        buyFeesBackup = [_liquidityFeeBuys, _marketingFeeBuys, _devFeeBuys];
        uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
        _totalFeeBuys = _liquidityFeeBuys + _marketingFeeBuys + _devFeeBuys;
        require(totalFee <= 700, "Too High Fee");
    }

    function _setSellFees(
        uint256 _liquidityFee,
        uint256 _marketingFee,
        uint256 _devFee
    ) external onlyOwner {
        _liquidityFeeSells = _liquidityFee;
        _marketingFeeSells = _marketingFee;
        _devFeeSells = _devFee;
        uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
        _totalFeeSells = _liquidityFeeSells + _marketingFeeSells + _devFeeSells;
        require(totalFee <= 700, "Too High Fee");
    }

    function _setTransferFees(
        uint256 _liquidityFee,
        uint256 _marketingFee,
        uint256 _devFee
    ) external onlyOwner {
        _liquidityTokens = _liquidityFee;
        _marketingTokens = _marketingFee;
        _devTokens = _devFee;
        transferTotalFee = _liquidityTokens + _marketingTokens + _devTokens;
        uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
        require(totalFee <= 100, "Too High Fee");
    }

    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
        _txLimit = maxTxAmount;
        require(_txLimit >= _tTotal.div(5), "Too low limit");
    }

    function setMinimumTokensBeforeSwap(
        uint256 __minBalanceForSwapback
    ) external onlyOwner {
        _minBalanceForSwapback = __minBalanceForSwapback;
    }

    function setMarketingWallet(address _marketingWallet) external onlyOwner {
        marketingWallet = payable(_marketingWallet);
    }

    function setDevAWallet(address _devWallet) external onlyOwner {
        devWallet = payable(_devWallet);
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function excludeWalletsFromWhales() private {
        _limitWhitelisted[owner()] = true;
        _limitWhitelisted[address(this)] = true;
        _limitWhitelisted[uniPair] = true;
        _limitWhitelisted[devWallet] = true;
        _limitWhitelisted[marketingWallet] = true;
    }

    function checkForWhale(
        address from,
        address to,
        uint256 amount
    ) private view {
        uint256 newBalance = balanceOf(to).add(amount);
        if (!_limitWhitelisted[from] && !_limitWhitelisted[to]) {
            require(
                newBalance <= _walletLimit,
                "Exceeding max tokens limit in the wallet"
            );
        }
        if (from == uniPair && !_limitWhitelisted[to]) {
            require(
                newBalance <= _walletLimit,
                "Exceeding max tokens limit in the wallet"
            );
        }
    }

    function setExcludedFromWhale(
        address account,
        bool _enabled
    ) public onlyOwner {
        _limitWhitelisted[account] = _enabled;
    }

    function setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner {
        _walletLimit = _amount;
        require(
            _walletLimit > _tTotal.div(100).mul(1),
            "Too less limit"
        ); //min 1%
    }

    function rescueStuckBalance() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function triggerSwapback() public {
        uint256 allBalance = balanceOf(address(this));
        swapTokens(allBalance);
    }

    receive() external payable {}
}