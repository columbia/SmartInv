// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cdo:;;;::;;:::;::;;:;;:;;;::;:::;:::;:;;:ldc;::;;;::;:;cdl:;;;;;;:::;:;;:;;;::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;l00kkoc::::;cdo:::;;;::;;;:;;cc::lkd:::;;;;;;;::;ckOkkkxdc:;::;;:clc:::;;;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;:ool:;:cccloxddo:;:c:;::;;;::ll:;::odcdK0o:::;;::;;;;:cdkdcccc:;;;;;;cx00dc;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;cd00l;:::::;cdkdc;;;::;;:;;::ldc;:;;::kKl;:::;;;:;;:;:x0l;:::;:odclxx0Xkl:;;:;;;::;:;cdl;;::;:;::;;::;;::::;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;:;;dKOxkOdc:;:;;;;;cdo:;;;:dkl:;;;;;:;:k0l:cc:;:;cdo:;:ldlcc:;;:cdOK0xol:;;:;;;;;:odc:ldl:;;::;;:;:ccc:;;;::;;:;:;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;::cccokKOl;;;:::;:c:;:;:ox0KOo:;:;;:oxkddk0d:;;cdl:;;xXX0xdc;;;lKOc:;:::;:;;:;:oxxdxkkxl:;:;:;:cdxkxdc:ll::;::;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;::;cdkdc::;;;;:;::;:;cdlcdxdc;;:;lKKxkxOXx::;cdl;cdkxxlcdxxxxxxl;;:;::;;::;;cdxxxl:;lxxl::;;:x0l;cdxkKx::;;;;:;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;:;;;:o0x;;::;;:;;;::;;:;;;;;;;;;:::oKNKk0Kxc:;;;;::o0x;;;;;coodo:;;;::;;;::;;;;;;;;;:;;:okkc;:cOKl;::cooc:::;::;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;::;;:x0kddddddddddo:;;;;:::;;;;;:;;dXNkcccloc::cooxkxl::;;:;;:;;;;:;;;;;::;;;;;;;;:;;:;;::oOdox0Kkc;::;;:;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;::;;:;lxxxxxxxxxxx0Kl;:;;::;;::::;:d0NNx:;;cdl::lxxl::;:::;;;;::;::;;::;;::;:::;;:;;::;;;;:;cdxxxo:;;:;::;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;xOl;:;;;;;:::;;,;ck0d::;;;;:c:;;;;;;:;:::;:;cdo:;;;::::::::ccllllll:;;;;::;;;;;;:::;;::;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;::::;;;;;;;;;::c:;:;;;;;::;;,''';:;;::;;;xOl;;;;;;;::;:;;::c:::cccccllllllllllllc:;;;;;;;:;;;:;;::;;:;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,',,;;;;:;;::x0l;:;;;;;;;;;;;:;::loooloollllllllllc:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;,,'',;;;:;;;::;:xOl;:;;;;;;;;:;;::lllllllllllllllllc:;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,'',;;:;::;;;;;;cc:;:;;;;;;;;;::lllllllllllllllllc::;;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;::;;;;;;;;;;;,,,'',;;;:;;:;;;;;;::::::;;::;;;::llollllllllllllll::;::;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;::;;::;;;:;;;::;:;;;;;;,,''',,;;:;;;;;;;;;;;;;;;;:;;::;:::lollllllllllllllc:;;:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;:;;,,'''',,;:;;;;;;;;;;;;;;;;;:;;::;;coollllllllllllll::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;::;codo:lddl:;;::;;;;,,'''',,;;:;;;;;;;;;;;;;;;;;;;;;:::clollllllllllllcc:;;;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;:lk0KOldKKd:ccccc:;,,'',;;;;:;;:;;;;;;;;;;;;;:;;:;;:cllllllllllllllol::;;;;::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;:;;:lkKKKOldKKxdk0OOko;'''',;;;;;;;;;;;;;;;;;:;;;;::;:clllllllllllllllllc;:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;:;;lx0KKKKOldKKKKKKK0o,',,,;;;:;;;;;;;;;;;;;;;;;;::::clllllllllllllllloo:;;;:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;:;:dKKKKKK0kOKKKKKKKKOd:ldc;;;:;;;;;;;;;;;;;;;;;;::cllllllllllllllllllol:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;:;;;:dKKKKKKKKKKKKKKKKKK0O0Oc;:;;;;;;;;;::;;;;;::::clllllllllllllllllllol::;;;;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;:::;:dKKK0kxxxxk0KKKKKKKK0Oo:;::;;;;;;;;::;;;;::;:lollllllllllllllllllloc:;;;;:;;:;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;::;:cdOkdlllllodk000Odlllc;;:;;:::;;;:;;;;;;:::cclollllllllllllllllllloc:;;;;:;;;;::;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;:::ccloolllllllloooooc:;;;:;;::;;::cccccccccclooollllllllllllllllllllloc:;;;;;;;::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;:lllllllllllllllllcc:;;;;::::;:cllooooooooloooooollllllllllllllllllllolccclcccccc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;:cllllllllllllllllc::;;;;;;;;;;cooooooooddoooooodoooooooollllllllllllloooooooooooolc:;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;:clllllllllllllllc:;;:;;;;;;;;;:::::::coxxkkkkkxxkkxxxxxxdodddddddddddddooooooooooool:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;:cllllllllllllllc:;:;;;;;;;;;;;:;;::lodxkk0KKK0OO000OOOOkxxxxkxxxxkkxkxxxxxxxoccccclc:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;:;;;:;;::clllllllllllllc::;;;;;;;;;;;;;;;:ldkkkdddxxk000KKKK0kxxxdddxkO00000000Okkkkko::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;:;;;;:ccllllllllllllll::;;;;;;;;;;;;;;;;:okkkxoddc;cxOO00KKK0xl;;okkO0KKKKKKKK0kkkkxol:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;:;;::clllllllllllllllc:;;;::;;;;;;;;;;:;;coxkxokx. 'OMNOOKKKK0:  lNNNXKKKKKKKKOkkkxc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;::cllllllllllllllllc::;::::;;;;;;;;;;:;;;cddllk0dox0XKOOKKKKKkooOXXKKKKKKKKKKOkkkdc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:clllllllllllllllllc;:::;;;:::;;;;;;;;::;::::lkKKKKKK0OOKKKKKKKKKKKKKKKKKKKKKK00Odc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:clllllllllllllllllc:;;;;;;;;;;;;;;;;;::;;:;:lkKKKKKK0OOOO0KKKKKKKKKKKKKKKKKKKKKOdc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:clllllllllllllllll::;;;;;;;;;;;;;;;;;::;;;;:lx0000000OOOO000000000000KKKKKKKK0Okd:;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:clllllllllllllllc:::;;;;;;;;;;;;;;;;;::clllodk000000OO0000OOOO00000000KKKKK0Okdl:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:clllllllllllllllc:;:;;;;;;;;;;;;;;;;:;:cdO00OO00OOOOOkOOOOOOOOO000000000000Okdc;;::;;:;;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;clllllllllllllllc:;:;;;;;;;;;;;;;;;;:;;;:ldOOO0OOOOOOOOOOOO0OkO00000OOkOOOOkdl::::::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;cllllllllllllllllc::;;;;;;;;;;;;;;;;:;;:;;:lxOOOOOOO00000000000000OkkkO0000kolcllllcc:::;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;clllllllllllllllllc:;;;;;;;;;;;;;;;;;;;::;;cdO000000000000000000000000000Okdollllllllcc:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;clllllllllllllllllc:;;::;;;::;;;;;;;;;;::cclxO000000000000000000000000000Oxolllllllllllcc::;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;:cllllllllllllllllllcc:;;;;;;:;;;;;::;::cllloxO000000000000000000000000000Oxolllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;::clllllllllllllllllllc:::;;;;;;;;;:::cllllloxO000000000000000000000000000Oxollllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;::;::clllllllllllllllllllc:::;;;;;;;::clllllloxO000000000000000000000000000Oxollllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;:;;:;;clllllllllllllllllllllcc:::;;;;;;clllllloxO000000000000000000000000000Oxolllllllllllllllllc:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;:clllllllllllllllllllllllllcccccccclllllloxO000000000000000000000000000Oxollllllllllllllllllcc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;:;;;;:cclclllllllllllllllllllllllllllllllllllloxO000000000000000000000000000Oxollllllllllllllllllllcc::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;:::::clllllllllllllllllllllllllllllllllloxO000000000000000000000000Okxxdlllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;::;:cclllllllllllllllllllllllllllllllllodkO00000000000000000000000Oxollllllllllllllllllllllllllc::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;:;::ccllllllllllllllllllllllllllllllllodkO0000000000000000000000Oxollllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;:;;::ccllllllllllllllllllllllllllllllldk00000000000000000000000Oxolllllllllllllllllllllllllllllc:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;:;;:::;:::cclllllllllllllllllllllllllllldkO0000000000000000000000Oxollllllllllllllllllllllllllllllc:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;:;;;;::::::::ccllllllllcc:cllllllldkO0000000000000000000000Oxollllllllllloollllllllllllllllllc:;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::;:clllllldkO000000000000000000000Okdlllllllllllloollllllllllllllllllcc:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;:;:clllllldkO00000000000000000000Okdlllllllllllllooolllllllllllllllllllc;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;:;;;;;:clllllldkO00000000000000000000Okdlllllllllllllloolllllllllllllllllll:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;:clllllloxO000000000000000000000Okdllllllllllllooollllllllllllllllllc:::;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;;:clllllloxO0000000000000000000000Okdlllllllllloooolllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::clllllloxO000000000000000000000Okdllllllllllloolllllllllllllllllc::::;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;:clllllloxO000000000000000000000Oxollllllllllloolllllllllllllllc::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;::cclllllloxO00000000000000000OOOkkxolllllllllllollllllllllllllc::;;;:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;::lllllllloxO000000000000000Okddoooolllllllllllllllllllllllllc::;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:clllllllllldxkO00000000000Okdolllllllllllllllllllllllllllllllc;;:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cclllllllllllodkO00000000OOkdllllllllllllllllllllllllllllllllc:;::;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::cllllllllllllllloxO0000000Okxolllllllllllllllllllllllllllllllc:;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cllllllllllllllllloxO000000Oxolllllllllllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::clllllllllllllllllloxO00000Oxolllllllllllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:clllllllllllllllllllodxkOOkkdolllllllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;;:cllllllllllllllllllllllodxxollllllllllllllllllllllllllllllllc:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;:;:cllllllllllllllllllllllllodllllllllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;::lllllllllllllllllllllllllllllllllllllllllllllllllllllllllcc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cllllllllllllllllllllllllllllllllllllllllllllllllllllllllc::;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
// 
// A telegram bot built by @oz_dao.
// https://wandbot.app
// https://twitter.com/wand_bot
//

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
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
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0));
        require(to != address(0));

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount);
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal virtual {
        _totalSupply += amount;

        unchecked {
            _balances[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        _balances[from] -= amount;

        unchecked {
            _totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount);
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
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
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );
}

contract Wand is ERC20, Ownable {

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public uniswapV2Pair;
    address public constant deadAddress = address(0xdead);

    bool private swapping;

    address public devWallet;
    address public liquidityWallet;

    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;

    bool public tradingActive = false;
    bool public swapEnabled = false;

    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = true;    

    uint256 public buyTotalFees;
    uint256 private buyDevFee;
    uint256 private buyLiquidityFee;

    uint256 public sellTotalFees;
    uint256 private sellDevFee;
    uint256 private sellLiquidityFee;

    uint256 private tokensForDev;
    uint256 private tokensForLiquidity;
    uint256 private previousFee;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedMaxTransactionAmount;
    mapping(address => bool) private automatedMarketMakerPairs;

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );

    constructor() payable ERC20("Wand", "WAND") {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), type(uint256).max);

        uint256 totalSupply = 100_000_000 ether;

        maxTransactionAmount = (totalSupply * 10) / 1000;
        maxWallet = (totalSupply * 10) / 1000;
        swapTokensAtAmount = (totalSupply * 1) / 1000;

        buyDevFee = 4;
        buyLiquidityFee = 0;
        buyTotalFees = buyDevFee + buyLiquidityFee;

        sellDevFee = 20;
        sellLiquidityFee = 0;
        sellTotalFees = sellDevFee + sellLiquidityFee;

        previousFee = sellTotalFees;

        devWallet = _msgSender();
        liquidityWallet = _msgSender();

        excludeFromFees(_msgSender(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(devWallet, true);
        excludeFromFees(liquidityWallet, true);

        excludeFromMaxTransaction(_msgSender(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(deadAddress, true);
        excludeFromMaxTransaction(address(uniswapV2Router), true);
        excludeFromMaxTransaction(devWallet, true);
        excludeFromMaxTransaction(liquidityWallet, true);

        _mint(msg.sender, (totalSupply * 100) / 100);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
        excludeFromMaxTransaction(address(uniswapV2Pair), true);        
    }

    receive() external payable {}

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function abracadabra() external onlyOwner {
        require(!tradingActive);
        tradingActive = true;
        swapEnabled = true;
    }

    function disableTransferDelay() external onlyOwner returns (bool) {
        transferDelayEnabled = false;
        return true;
    }

    function updateSwapTokensAtAmount(uint256 newAmount)
        external
        onlyOwner
        returns (bool)
    {
        require(newAmount >= (totalSupply() * 1) / 100000);
        require(newAmount <= (totalSupply() * 5) / 1000);
        swapTokensAtAmount = newAmount;
        return true;
    }

    function updateMaxWalletAndTxnAmount(
        uint256 newTxnNum,
        uint256 newMaxWalletNum
    ) external onlyOwner {
        require(newTxnNum >= ((totalSupply() * 5) / 1000));
        require(newMaxWalletNum >= ((totalSupply() * 5) / 1000));
        maxWallet = newMaxWalletNum;
        maxTransactionAmount = newTxnNum;
    }

    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner
    {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

    function updateBuyFees(
        uint256 _devFee,
        uint256 _liquidityFee
    ) external onlyOwner {
        buyDevFee = _devFee;
        buyLiquidityFee = _liquidityFee;
        buyTotalFees = buyDevFee + buyLiquidityFee;
        require(buyTotalFees <= 4, "Buy fees must be less than or equal to 4%");
    }

    function updateSellFees(
        uint256 _devFee,
        uint256 _liquidityFee
    ) external onlyOwner {
        sellDevFee = _devFee;
        sellLiquidityFee = _liquidityFee;
        sellTotalFees = sellDevFee + sellLiquidityFee;
        previousFee = sellTotalFees;
        require(sellTotalFees <= 20, "Sell fees must be less than or equal to 20%");
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    function setDevWallet(address account) public onlyOwner {
        devWallet = account;
        excludeFromFees(account, true);
        excludeFromMaxTransaction(devWallet, true);
    }

    function withdrawStuckETH() public onlyOwner {
        bool success;
        (success, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
    }

    function withdrawStuckTokens(address tkn) public onlyOwner {
        require(IERC20(tkn).balanceOf(address(this)) > 0);
        uint256 amount = IERC20(tkn).balanceOf(address(this));
        IERC20(tkn).transfer(msg.sender, amount);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0));
        require(to != address(0));

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (
            from != owner() &&
            to != owner() &&
            to != address(0) &&
            to != deadAddress &&
            !swapping
        ) {
            if (!tradingActive) {
                require(_isExcludedFromFees[from] || _isExcludedFromFees[to]);
            }

            if (transferDelayEnabled) {
                if (
                    to != owner() &&
                    to != address(uniswapV2Router) &&
                    to != address(uniswapV2Pair)
                ) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] <
                            block.number,
                        "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }            

            //when buy
            if (
                automatedMarketMakerPairs[from] &&
                !_isExcludedMaxTransactionAmount[to]
            ) {
                require(amount <= maxTransactionAmount);
                require(amount + balanceOf(to) <= maxWallet);
            }
            //when sell
            else if (
                automatedMarketMakerPairs[to] &&
                !_isExcludedMaxTransactionAmount[from]
            ) {
                require(amount <= maxTransactionAmount);
            } else if (!_isExcludedMaxTransactionAmount[to]) {
                require(amount + balanceOf(to) <= maxWallet);
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;

        if (takeFee) {
            // on sell
            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                fees = amount * sellTotalFees / 100;
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForDev += (fees * sellDevFee) / sellTotalFees;
            }
            // on buy
            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount * buyTotalFees / 100;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForDev += (fees * buyDevFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
        sellTotalFees = previousFee;
    }

    function swapTokensForEth(uint256 tokenAmount) private {
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

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            liquidityWallet,
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForDev;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 20) {
            contractBalance = swapTokensAtAmount * 20;
        }

        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
            totalTokensToSwap /
            2;
        uint256 amountToSwapForETH = contractBalance - liquidityTokens;

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance - initialETHBalance;

        uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;

        uint256 ethForLiquidity = ethBalance - ethForDev;

        tokensForLiquidity = 0;
        tokensForDev = 0;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                tokensForLiquidity
            );
        }

        (success, ) = address(devWallet).call{
            value: address(this).balance
        }("");
    }
}