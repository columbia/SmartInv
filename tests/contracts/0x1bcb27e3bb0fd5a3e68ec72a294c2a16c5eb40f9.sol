// SPDX-License-Identifier: MIT
/**
 * https://ww3pepe.com/
 * https://t.me/WW3PEPEToken
 * https://X.com/ww3pepe
 */
pragma solidity >=0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

interface IERC20Errors {
    error ERC20InsufficientBalance(
        address sender,
        uint256 balance,
        uint256 needed
    );
    error ERC20InvalidSender(address sender);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InsufficientAllowance(
        address spender,
        uint256 allowance,
        uint256 needed
    );
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidSpender(address spender);
}

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256))
        private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    error ERC20FailedDecreaseAllowance(
        address spender,
        uint256 currentAllowance,
        uint256 requestedDecrease
    );

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 value
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 requestedDecrease
    ) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < requestedDecrease) {
            revert ERC20FailedDecreaseAllowance(
                spender,
                currentAllowance,
                requestedDecrease
            );
        }
        unchecked {
            _approve(owner, spender, currentAllowance - requestedDecrease);
        }

        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(
                    spender,
                    currentAllowance,
                    value
                );
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

library SafeMath {
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IDexFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(
        address to
    ) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IDexRouter02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract WW3Pepe is ERC20, Ownable {
    using SafeMath for uint256;

    IDexRouter02 private immutable _dexRouter;
    address public immutable _dexPair;

    bool private onSwpBck;

    address public mktFeeReceiver;

    uint256 private _minSwapbackValue;
    uint256 private _maxSwapbackValue;

    uint256 public _txLimit;
    uint256 public _WalletLimit;

    uint256 public _feeOnBuys;
    uint256 public _feeOnSells;

    bool public _antiWhaleOn = true;
    bool public _tradingEnabled = false;

    mapping(address => bool) private feeExmpt;
    mapping(address => bool) private _WalletLimitExmpt;

    mapping(address => bool) public _dexPairs;

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event TaxesSwaped(uint256 tokensSwapped, uint256 ethReceived);

    constructor() ERC20("WW3 Pepe", "PEPE") {
        IDexRouter02 __dexRouter = IDexRouter02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        _dexRouter = __dexRouter;

        _dexPair = IDexFactory(__dexRouter.factory()).createPair(
            address(this),
            __dexRouter.WETH()
        );
        _setDexPair(address(_dexPair), true);

        uint256 totalSupply = 1_000_000 * 1e18;

        _txLimit = (totalSupply) / 100;
        _WalletLimit = (totalSupply) / 100;

        _feeOnBuys = 25;
        _feeOnSells = 25;

        _minSwapbackValue = (totalSupply * 5) / 10000;
        _maxSwapbackValue = (totalSupply * 1) / 100;

        mktFeeReceiver = address(msg.sender);

        feeExmpt[msg.sender] = true;
        feeExmpt[mktFeeReceiver] = true;
        feeExmpt[address(this)] = true;
        feeExmpt[address(0xdead)] = true;

        _WalletLimitExmpt[owner()] = true;
        _WalletLimitExmpt[address(this)] = true;
        _WalletLimitExmpt[address(0xdead)] = true;
        _WalletLimitExmpt[mktFeeReceiver] = true;

        _mint(msg.sender, totalSupply);
    }

    receive() external payable {}

    function declareWar() external onlyOwner {
        _tradingEnabled = true;
    }

    function setMktFeeReceiver(address newMktFeeReceiver) external onlyOwner {
        mktFeeReceiver = newMktFeeReceiver;
    }

    function setFeeOnBuys(uint256 buyFee) external onlyOwner {
        _feeOnBuys = buyFee;
        require(_feeOnBuys <= 25, "Buy fee can't be more than 25%");
    }

    function setFeeOnSells(uint256 sellFee) external onlyOwner {
        _feeOnSells = sellFee;
        require(_feeOnSells <= 25, "Sell fee can't be more than 25%");
    }

    function antiWhaleOff() external onlyOwner {
        _antiWhaleOn = false;
    }

    function setTxLimit(uint256 maxTx) external onlyOwner {
        require(maxTx >= 5, "Max tx can't be less than 0.5%");
        _txLimit = (maxTx * totalSupply()) / 10000;
    }

    function setWalletLimit(uint256 maxWallet) external onlyOwner {
        require(maxWallet >= 5, "Max wallet can't be less than 0.5%");
        _WalletLimit = (maxWallet * totalSupply()) / 10000;
    }

    function setSwapbackValue(
        uint256 newMin,
        uint256 newMax
    ) external onlyOwner {
        require(newMin <= 5, "Min swapback value can't be more than 0.5%");
        require(
            newMax >= newMin,
            "Max swapback value can't be lower than the minimun"
        );
        _minSwapbackValue = (newMin * totalSupply()) / 10000;
        _maxSwapbackValue = (newMax * totalSupply()) / 10000;
    }

    function _setDexPair(address pair, bool value) private {
        _dexPairs[pair] = value;

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function triggerContractSell() private {
        uint256 tokenBalance = balanceOf(address(this));
        bool success;

        if (tokenBalance == 0) {
            return;
        }

        if (tokenBalance > _maxSwapbackValue) {
            tokenBalance = _maxSwapbackValue;
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _dexRouter.WETH();

        _approve(address(this), address(_dexRouter), tokenBalance);

        // make the swap
        _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenBalance,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );

        emit TaxesSwaped(tokenBalance, address(this).balance);

        (success, ) = address(mktFeeReceiver).call{
            value: address(this).balance
        }("");
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (amount == 0) {
            super._update(from, to, 0);
            return;
        }

        if (_antiWhaleOn) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0) &&
                to != address(0xdead) &&
                !onSwpBck
            ) {
                if (!_tradingEnabled) {
                    require(
                        feeExmpt[from] || feeExmpt[to],
                        "Trading is not active."
                    );
                }
                //when buy
                if (_dexPairs[from] && !_WalletLimitExmpt[to]) {
                    require(
                        amount <= _txLimit,
                        "Buy transfer amount exceeds the _txLimit."
                    );
                    require(
                        amount + balanceOf(to) <= _WalletLimit,
                        "Max wallet exceeded"
                    );
                }
                //when sell
                else if (_dexPairs[to] && !_WalletLimitExmpt[from]) {
                    require(
                        amount <= _txLimit,
                        "Sell transfer amount exceeds the _txLimit."
                    );
                } else if (!_WalletLimitExmpt[to]) {
                    require(
                        amount + balanceOf(to) <= _WalletLimit,
                        "Max wallet exceeded"
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= _minSwapbackValue;

        if (
            canSwap &&
            !onSwpBck &&
            !_dexPairs[from] &&
            !feeExmpt[from] &&
            !feeExmpt[to]
        ) {
            onSwpBck = true;

            triggerContractSell();

            onSwpBck = false;
        }

        bool takeFee = !onSwpBck;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (feeExmpt[from] || feeExmpt[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if (takeFee) {
            // on sell
            if (_dexPairs[to] && _feeOnSells > 0) {
                fees = amount.mul(_feeOnSells).div(100);
            }
            // on buy
            else if (_dexPairs[from] && _feeOnBuys > 0) {
                fees = amount.mul(_feeOnBuys).div(100);
            }

            if (fees > 0) {
                super._update(from, address(this), fees);
            }

            amount -= fees;
        }

        super._update(from, to, amount);
    }
}