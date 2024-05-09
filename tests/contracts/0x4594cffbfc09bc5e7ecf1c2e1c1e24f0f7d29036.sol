/*
_____/\\\\\\\_______________/\\\________/\\\____________/\\\\\_____/\\\_        
 ___/\\\/////\\\____________\/\\\_____/\\\//____________\/\\\\\\___\/\\\_       
  __/\\\____\//\\\___________\/\\\__/\\\//_______________\/\\\/\\\__\/\\\_      
   _\/\\\_____\/\\\___________\/\\\\\\//\\\_______________\/\\\//\\\_\/\\\_     
    _\/\\\_____\/\\\___________\/\\\//_\//\\\______________\/\\\\//\\\\/\\\_    
     _\/\\\_____\/\\\___________\/\\\____\//\\\_____________\/\\\_\//\\\/\\\_   
      _\//\\\____/\\\____________\/\\\_____\//\\\____________\/\\\__\//\\\\\\_  
       __\///\\\\\\\/_____________\/\\\______\//\\\___________\/\\\___\//\\\\\_ 
        ____\///////_______________\///________\///____________\///_____\/////__
*/
// SPDX-License-Identifier:MIT
pragma solidity 0.8.18;

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

// Dex Factory contract interface
interface IDexFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

// Dex Router contract interface
interface IDexRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        _owner = payable(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        if (_status == _ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

contract ZeroKnowledgeNetwork is Context, IERC20, Ownable, ReentrancyGuard {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public isExcludedFromFee;
    mapping(address => bool) public isExcludedFromMaxHolding;

    string private _name = "Zero Knowledge Network";
    string private _symbol = "0KN";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 10_000_000_000 * 1e18; //10 Billion

    uint256 public minTokenToSwap = _totalSupply / (5000); // this amount will trigger swap and distribute
    uint256 public maxHoldLimit = (_totalSupply * 5) / 100; // this is the max wallet holding limit
    uint256 public percentDivider = 100;

    bool public distributeAndLiquifyStatus = true; // should be true to turn on to liquidate the pool
    bool public feesStatus = true; // enable by default

    IDexRouter public dexRouter; // router declaration

    address public dexPair; // pair address declaration
    address public OKNTreasuryWallet;
    address public NodeOperatorRewards =
        address(0x8bc9063Ca5a59C6FE79c7114916804ae01806d74);
    address public Seed = address(0xA321B6EdB7f1ae58eA3b494b98917BDAe30cd262);
    address public Team = address(0x041c89471163B034c302624785438C1E2493Adf8);
    address public Marketing =
        address(0x05DB6Dd90464192385Dc4121E39A14B453484De4);

    address private constant DEAD = address(0xdead);
    address private constant ZERO = address(0);

    uint256 public OKNTreasuryFeeOnBuy = 0;

    uint256 public OKNTreasuryFeeOnSell = 0;

    event TransferForeignToken(address token, uint256 amount);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeFromMaxHolding(address indexed account, bool isExcluded);
    event UpdatedMaxWalletAmount(uint256 newAmount);
    event NewSwapAmount(uint256 newAmount);
    event DistributionStatus(bool Status);
    event FeeStatus(bool Status);
    event FeeUpdated(uint256 amount);

    event OKNTreasuryWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    constructor() {
        _balances[NodeOperatorRewards] = (_totalSupply * 30) / 100; //30%
        _balances[Seed] = (_totalSupply * 10) / 100; //10%
        _balances[Team] = (_totalSupply * 5) / 100; //5%
        _balances[Marketing] = (_totalSupply * 10) / 100; //10%
        _balances[owner()] = (_totalSupply * 45) / 100; //45%

        OKNTreasuryWallet = address(0x05DB6Dd90464192385Dc4121E39A14B453484De4);

        IDexRouter _dexRouter = IDexRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        // Create a dex pair for this new ERC20
        address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
            address(this),
            _dexRouter.WETH()
        );
        dexPair = _dexPair;

        // set the rest of the contract variables
        dexRouter = _dexRouter;

        //exclude owner and this contract from fee
        isExcludedFromFee[owner()] = true;
        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[address(dexRouter)] = true;
        isExcludedFromFee[
            address(0x71B5759d73262FBb223956913ecF4ecC51057641)
        ] = true; // Pink Lock

        //exclude owner and this contract from max hold limit
        isExcludedFromMaxHolding[owner()] = true;
        isExcludedFromMaxHolding[address(this)] = true;
        isExcludedFromMaxHolding[address(dexRouter)] = true;
        isExcludedFromMaxHolding[dexPair] = true;
        isExcludedFromMaxHolding[
            address(0x71B5759d73262FBb223956913ecF4ecC51057641)
        ] = true; // Pink Lock

        emit Transfer(
            address(0),
            NodeOperatorRewards,
            (_totalSupply * 30) / 100
        );
        emit Transfer(address(0), Seed, (_totalSupply * 10) / 100);
        emit Transfer(address(0), Team, (_totalSupply * 5) / 100);
        emit Transfer(address(0), Marketing, (_totalSupply * 10) / 100);
        emit Transfer(address(0), owner(), (_totalSupply * 45) / 100);
    }

    //to receive ETH from dexRouter when swapping
    receive() external payable {}

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
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
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
            _allowances[sender][_msgSender()] - amount
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
            _allowances[_msgSender()][spender] + (addedValue)
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
            _allowances[_msgSender()][spender] - subtractedValue
        );
        return true;
    }

    function includeOrExcludeFromFee(
        address account,
        bool value
    ) external onlyOwner {
        isExcludedFromFee[account] = value;
        emit ExcludeFromFees(account, value);
    }

    function includeOrExcludeFromMaxHolding(
        address account,
        bool value
    ) external onlyOwner {
        isExcludedFromMaxHolding[account] = value;
        emit ExcludeFromMaxHolding(account, value);
    }

    function setMinTokenToSwap(uint256 _amount) external onlyOwner {
        require(_amount > 0, "min swap amount should be greater than zero");
        minTokenToSwap = _amount * 1e18;
        emit NewSwapAmount(minTokenToSwap);
    }

    function setMaxHoldLimit(uint256 _amount) external onlyOwner {
        require(
            _amount >= ((totalSupply() * 5) / 1000) / 1e18,
            "Cannot set max wallet amount lower than 0.5%"
        );
        maxHoldLimit = _amount * 1e18;
        emit UpdatedMaxWalletAmount(maxHoldLimit);
    }

    function setBuyFeePercent(uint256 _OKNTreasuryFee) external onlyOwner {
        require(_OKNTreasuryFee <= 10, "max buy fee is 10");
        OKNTreasuryFeeOnBuy = _OKNTreasuryFee;
        emit FeeUpdated(OKNTreasuryFeeOnBuy);
    }

    function setSellFeePercent(uint256 _OKNTreasuryFee) external onlyOwner {
        require(_OKNTreasuryFee <= 10, "max sell fee is 10");
        OKNTreasuryFeeOnSell = _OKNTreasuryFee;
        emit FeeUpdated(OKNTreasuryFeeOnSell);
    }

    function setDistributionStatus(bool _value) external onlyOwner {
        // Check if the new value is different from the current state
        require(
            _value != distributeAndLiquifyStatus,
            "Value must be different from current state"
        );
        distributeAndLiquifyStatus = _value;
        emit DistributionStatus(_value);
    }

    function enableOrDisableFees(bool _value) external onlyOwner {
        // Check if the new value is different from the current state
        require(
            _value != feesStatus,
            "Value must be different from current state"
        );
        feesStatus = _value;
        emit FeeStatus(_value);
    }

    function updateOKNTreasuryWallet(
        address newOKNTreasuryWallet
    ) external onlyOwner {
        require(
            newOKNTreasuryWallet != address(0),
            "Ownable: new OKNTreasuryWallet is the zero address"
        );
        emit OKNTreasuryWalletUpdated(newOKNTreasuryWallet, OKNTreasuryWallet);
        OKNTreasuryWallet = newOKNTreasuryWallet;
    }

    function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
        uint256 fee = (amount * OKNTreasuryFeeOnBuy) / percentDivider;
        return fee;
    }

    function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
        uint256 fee = (amount * OKNTreasuryFeeOnSell) / percentDivider;
        return fee;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "0KN: approve from the zero address");
        require(spender != address(0), "0KN: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "0KN: transfer from the zero address");
        require(to != address(0), "0KN: transfer to the zero address");
        require(amount > 0, "0KN: Amount must be greater than zero");

        if (!isExcludedFromMaxHolding[to]) {
            require(
                balanceOf(to) + amount <= maxHoldLimit,
                "0KN: max hold limit exceeds"
            );
        }

        // swap and liquify
        distributeAndLiquify(from, to);

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to isExcludedFromFee account then remove the fee
        if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (dexPair == sender && takeFee) {
            uint256 allFee;
            uint256 tTransferAmount;
            allFee = totalBuyFeePerTx(amount);
            tTransferAmount = amount - allFee;

            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + tTransferAmount;
            emit Transfer(sender, recipient, tTransferAmount);

            takeTokenFee(sender, allFee);
        } else if (dexPair == recipient && takeFee) {
            uint256 allFee = totalSellFeePerTx(amount);
            uint256 tTransferAmount = amount - allFee;
            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + tTransferAmount;
            emit Transfer(sender, recipient, tTransferAmount);

            takeTokenFee(sender, allFee);
        } else {
            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + (amount);
            emit Transfer(sender, recipient, amount);
        }
    }

    function takeTokenFee(address sender, uint256 amount) private {
        _balances[address(this)] = _balances[address(this)] + amount;

        emit Transfer(sender, address(this), amount);
    }

    // to withdarw ETH from contract
    function withdrawETH(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Invalid Amount");
        payable(msg.sender).transfer(_amount);

        emit Transfer(address(this), msg.sender, _amount);
    }

    function distributeAndLiquify(address from, address to) private {
        uint256 contractTokenBalance = balanceOf(address(this));

        if (
            contractTokenBalance >= minTokenToSwap &&
            from != dexPair &&
            distributeAndLiquifyStatus &&
            !(from == address(this) && to == dexPair) // swap 1 time
        ) {
            // approve contract
            _approve(address(this), address(dexRouter), minTokenToSwap);

            // now is to lock into liquidty pool
            Utils.swapTokensForEth(address(dexRouter), minTokenToSwap);
            uint256 ethForMarketing = address(this).balance;

            // sending Eth to Marketing wallet
            if (ethForMarketing > 0)
                payable(OKNTreasuryWallet).transfer(ethForMarketing);
        }
    }
}

// Library for doing a swap on Dex
library Utils {
    function swapTokensForEth(
        address routerAddress,
        uint256 tokenAmount
    ) internal {
        IDexRouter dexRouter = IDexRouter(routerAddress);

        // generate the Dex pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp + 300
        );
    }
}