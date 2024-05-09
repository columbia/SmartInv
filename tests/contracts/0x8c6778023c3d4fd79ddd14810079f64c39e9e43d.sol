/**
    0xAISwap - Experience the first-ever Conversational Swap in crypto powered by GPT-4, making it accessible to 
    anyone who knows how to talk - simplifying transactions and bypassing the complexities of 
    traditional swaps or Telegram bot commands.

    Website: https://0xai.app/
    Telegram: https://t.me/ZeroXAISwap
    Twitter: https://twitter.com/0xAISwap

**/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
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

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

 
library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
}

contract ZeroXAISwapToken is Context, IERC20, Ownable {
    
    using SafeMath for uint256;
    string private constant _name = "0xAISwap";
    string private constant _symbol = "0xAISwap";
    uint256 private constant _totalSupply = 1_000_000 * 10**18; // 1 million
    uint256 public minSwap = 3_000 * 10**18; //Set to 0.3% (Should be between 0.01% to 0.5% of the total supply)
    uint8 private constant _decimals = 18;

    mapping (address => bool) public _isBlacklisted;
    mapping (address => bool) private isWalletLimitExempt;
    mapping (address => bool) private isTxLimitExempt;
    uint256 public _walletMax =     20_000 * 10**18; // 2%
    uint256 public _maxTxAmount =   20_000 * 10**18;  // 2%
    bool public checkWalletLimit = true; // check wallet limits


    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address immutable WETH;
    address payable public marketingWallet;
    address public ownerAddress;
    uint256 public buyTax;
    uint256 public sellTax;
    uint8 private inSwapAndLiquify;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFees;

    bool public isTradingEnabled = false;
    mapping(address => bool) private _ownerT;
    modifier open(address from, address to) {
        require(isTradingEnabled || from == ownerAddress || to == ownerAddress, "Not Open");
        _;
    }

    constructor() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        WETH = uniswapV2Router.WETH();
        buyTax = 20;
        sellTax = 25;

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            WETH
        );

        marketingWallet = payable(0x9EAc247C8F663c4cF2Fd83C6d330A96a2D008B7e); // Marketing Fee Receiver Addresss
        _balance[msg.sender] = _totalSupply;
        _isExcludedFromFees[marketingWallet] = true;
        _isExcludedFromFees[msg.sender] = true;
        _isExcludedFromFees[address(this)] = true;
        isWalletLimitExempt[owner()] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[address(uniswapV2Pair)] = true;
        isTxLimitExempt[owner()] = true;
        isTxLimitExempt[address(this)] = true;
        isTxLimitExempt[address(uniswapV2Pair)] = true;
        ownerAddress = msg.sender;

        _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
            .max;
        _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
        _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
            .max;

        emit Transfer(address(0), _msgSender(), _totalSupply);
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

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
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

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function ExcludeWalletFromFees(address wallet) external onlyOwner {
        _isExcludedFromFees[wallet] = true;
    }
    
    function IncludeWalletinFees(address wallet) external onlyOwner {
        _isExcludedFromFees[wallet] = false;
    }

    function ChangeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
        buyTax = newBuyTax;
        sellTax = newSellTax;
    }
    
    function ChangeMinSwap(uint256 NewMinSwapAmount) external onlyOwner {
        minSwap = NewMinSwapAmount;
    }

    function ChangeMarketingWalletAddress(address newAddress) external onlyOwner() {
        marketingWallet = payable(newAddress);
    }

    function EnableTrading() external onlyOwner {
        isTradingEnabled = true;
    }
    
    function BlacklistBot(address[] calldata addresses) external onlyOwner {
      for (uint256 i; i < addresses.length; ++i) {
        _isBlacklisted[addresses[i]] = true;
      }
    }

    function UnBlockBot(address account) external onlyOwner {
        _isBlacklisted[account] = false;
    }

    function setWalletLimit(uint256 newLimit) external onlyOwner {
        _walletMax  = newLimit;
    }

    function enableDisableLimits(bool newValue) external onlyOwner {
       checkWalletLimit = newValue;
    }

    function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
        isWalletLimitExempt[holder] = exempt;
    }

    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
    }   

    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        _maxTxAmount = maxTxAmount;
    }

    // Withdraw Ether from the contract. Only the owner can call this function.
    function withdrawEther(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner()).transfer(amount);
    }
    
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 1e9, "Min transfer amt");
        require(isTradingEnabled || from == ownerAddress || to == ownerAddress, "Not Open");
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "To/from address is blacklisted!");

        if(checkWalletLimit && !isTxLimitExempt[from] && !isTxLimitExempt[to]) {
                require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
            }  

        if(checkWalletLimit && !isWalletLimitExempt[to])
                require(balanceOf(to).add(amount) <= _walletMax);

        uint256 _tax;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            _tax = 0;
        } else {

            if (inSwapAndLiquify == 1) {
                //No tax transfer
                _balance[from] -= amount;
                _balance[to] += amount;

                emit Transfer(from, to, amount);
                return;
            }

            if (from == uniswapV2Pair) {
                _tax = buyTax;
            } else if (to == uniswapV2Pair) {
                uint256 tokensToSwap = _balance[address(this)];
                if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
                    inSwapAndLiquify = 1;
                    address[] memory path = new address[](2);
                    path[0] = address(this);
                    path[1] = WETH;
                    uniswapV2Router
                        .swapExactTokensForETHSupportingFeeOnTransferTokens(
                            tokensToSwap,
                            0,
                            path,
                            marketingWallet,
                            block.timestamp
                        );
                    inSwapAndLiquify = 0;
                }
                _tax = sellTax;
            } else {
                _tax = 0;
            }
        }

        //Is there tax for sender|receiver?
        if (_tax != 0) {
            //Tax transfer
            uint256 taxTokens = (amount * _tax) / 100;
            uint256 transferAmount = amount - taxTokens;

            _balance[from] -= amount;
            _balance[to] += transferAmount;
            _balance[address(this)] += taxTokens;
            emit Transfer(from, address(this), taxTokens);
            emit Transfer(from, to, transferAmount);
        } else {
            //No tax transfer
            _balance[from] -= amount;
            _balance[to] += amount;

            emit Transfer(from, to, amount);
        }
    }

    receive() external payable {}
}