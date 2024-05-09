/*
 ██████╗ ███╗   ██╗       ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗    ██████╗ ██╗   ██╗███╗   ██╗ █████╗ ███╗   ███╗██╗ ██████╗███████╗
██╔═══██╗████╗  ██║      ██╔════╝██║  ██║██╔══██╗██║████╗  ██║    ██╔══██╗╚██╗ ██╔╝████╗  ██║██╔══██╗████╗ ████║██║██╔════╝██╔════╝
██║   ██║██╔██╗ ██║█████╗██║     ███████║███████║██║██╔██╗ ██║    ██║  ██║ ╚████╔╝ ██╔██╗ ██║███████║██╔████╔██║██║██║     ███████╗
██║   ██║██║╚██╗██║╚════╝██║     ██╔══██║██╔══██║██║██║╚██╗██║    ██║  ██║  ╚██╔╝  ██║╚██╗██║██╔══██║██║╚██╔╝██║██║██║     ╚════██║
╚██████╔╝██║ ╚████║      ╚██████╗██║  ██║██║  ██║██║██║ ╚████║    ██████╔╝   ██║   ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║╚██████╗███████║
 ╚═════╝ ╚═╝  ╚═══╝       ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═════╝    ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝ ╚═════╝╚══════╝
                                                              OCD                                                                     
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
        _status = _NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// Library dex swap
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

//On-Chain Dynamics $OCD

contract OCD is Context, IERC20, Ownable, ReentrancyGuard {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public isExcludedFromFee;

    string private _name = "On-Chain Dynamics";
    string private _symbol = "OCD";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 1_000_000_000 * 1e18; //1 Billion

    uint256 public minSwapAmount = _totalSupply / (2000);
    uint256 public percentDivider = 100;

    bool public distributeAndLiquifyStatus = true; 
    bool public feesStatus = true; // enable by default

    IDexRouter public dexRouter; //Uniswap  router declaration

    address public dexPair; //Uniswap  pair address declaration
    address public marketWallet;

    address private constant DEAD = address(0xdead);

    uint256 public marketFeeOnBuy = 0;

    uint256 public marketFeeOnSell = 0;

    event ExcludeFromFee(address indexed account, bool isExcluded);
    event NewSwapAmount(uint256 newAmount);
    event DistributionStatus(bool Status);
    event FeeStatus(bool Status);
    event FeeUpdated(uint256 amount);

    event marketWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    constructor() {
        _balances[
            address(0xeCAB3064B0FCa52fdcc8422280a927EF8f51fE8D)
        ] = _totalSupply; // Deployer

        marketWallet = address(0xdBBa71D308125218B1cD0fa4f93662EbDc28b43D); //Marketing & Development

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
        ] = true; // Pinklock

        emit Transfer(
            address(0),
            address(0xeCAB3064B0FCa52fdcc8422280a927EF8f51fE8D),
            _totalSupply
        );
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Ownable functions

    function setIncludeOrExcludeFromFee(
        address account,
        bool value
    ) external onlyOwner {
        isExcludedFromFee[account] = value;
        emit ExcludeFromFee(account, value);
    }

    function updateSwapAmount(uint256 _amount) external onlyOwner {
        require(_amount > 0, "min swap amount should be greater than zero");
        minSwapAmount = _amount * 1e18;
        emit NewSwapAmount(minSwapAmount);
    }

    function updateBuyFee(uint256 _marketFee) external onlyOwner {
        require(_marketFee <= 10, "max buy fee is 10");
        marketFeeOnBuy = _marketFee;
        emit FeeUpdated(marketFeeOnBuy);
    }

    function updateSellFee(uint256 _marketFee) external onlyOwner {
        require(_marketFee <= 10, "max sell fee is 10");
        marketFeeOnSell = _marketFee;
        emit FeeUpdated(marketFeeOnSell);
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

    function updatemarketWallet(address newmarketWallet) external onlyOwner {
        require(
            newmarketWallet != address(0),
            "Ownable: new marketWallet is the zero address"
        );
        emit marketWalletUpdated(newmarketWallet, marketWallet);
        marketWallet = newmarketWallet;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //to receive ETH from dexRouter when swapping
    receive() external payable {}

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Public viewable functions

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

    function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
        uint256 fee = (amount * marketFeeOnBuy) / percentDivider;
        return fee;
    }

    function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
        uint256 fee = (amount * marketFeeOnSell) / percentDivider;
        return fee;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "OCD: approve from the zero address");
        require(spender != address(0), "OCD: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "OCD: transfer from the zero address");
        require(to != address(0), "OCD: transfer to the zero address");
        require(amount > 0, "OCD: Amount must be greater than zero");

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

    //this method is responsible for processing all fee, if takeFee is true
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
            contractTokenBalance >= minSwapAmount &&
            from != dexPair &&
            distributeAndLiquifyStatus &&
            !(from == address(this) && to == dexPair) // swap 1 time
        ) {
            // approve contract
            _approve(address(this), address(dexRouter), minSwapAmount);

            // lock into liquidty pool
            Utils.swapTokensForEth(address(dexRouter), minSwapAmount);
            uint256 ethForMarketing = address(this).balance;

            // sending Eth to Marketing wallet
            if (ethForMarketing > 0)
                payable(marketWallet).transfer(ethForMarketing);
        }
    }
}