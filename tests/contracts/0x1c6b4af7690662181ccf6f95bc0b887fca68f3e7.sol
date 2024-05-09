// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    
}

interface IRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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

interface IFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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

    function renounceOwnership() external virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract KillerPepe is Ownable {

    IRouter public uniswapV2Router;
    address public uniswapV2Pair;
    address public router;
    
    uint8 private _decimals = 18;
    string private _name = unicode"ƘILLƐR ƤƐƤƐ";
    string private _symbol = unicode"KEPE";
    uint256 private _totalSupply = 690_000_000_000_000 * 1e18;
    uint256 private maxTxAmount = _totalSupply / 100;
    
    mapping(address => uint256) private _balances;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private supplyForLiq = _totalSupply * 90 / 100;
    uint256 private supplyToOwner = _totalSupply * 10 / 100;
    
    uint256 private buyTaxes = 30;
    uint256 private sellTaxes = 30;
    uint256 private swapTokensAtAmount = _totalSupply / 2000;
    uint256 private readSwapAtAmount = 5;
    address public marketingWallet = 0x730aa5Dc96B3D769391f26424b9a496A48e8D882;
    
    bool private autoSwapTaxes;
    bool private inSwapAndLiquify;
    bool private swapForETH = true;
    bool private sendTokens = false;
    bool public tradingOpen = false;
    bool public liquidityAdded = false;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {

        if(block.chainid == 1) {
            router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;    // ETH Uniswap V2 mainnet
        } else if(block.chainid == 56) {
            router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;    // BSC PCS V2 mainnet
        } else if(block.chainid == 97) {
            router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;    // BSC PCS V2 testnet
        }

        uniswapV2Router = IRouter(router);
        uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());

        transferOwnership(msg.sender);
        _balances[address(this)] = supplyForLiq;
        _balances[owner()] = supplyToOwner;
        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[marketingWallet] = true;
        _approve(address(this), router, type(uint256).max);
        emit Transfer(address(0), owner(), supplyToOwner);
        emit Transfer(address(0), address(this), supplyForLiq);
    }

    modifier preventClog {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    receive() external payable {}
    function name() public view returns (string memory) { return _name; }
    function symbol() public view  returns (string memory) { return _symbol; }
    function decimals() public view returns (uint8) { return _decimals; }
    function totalSupply() public view  returns (uint256)  {return _totalSupply; }
    function balanceOf(address account) public view returns (uint256) { return _balances[account]; }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function currentMaxTransaction() public view returns(uint256) {
        return maxTxAmount / 1e18;
    }

    function checkLimits() public view returns(string memory) {
        string memory currentLimits = "No Limits";
        if(maxTxAmount < _totalSupply) {
            currentLimits = "Max tx limits in effect";
            return currentLimits;
        } else {
            return currentLimits;
        }
    }

    function setMaxTx(uint8 maxTxPercent) public onlyOwner {
        require(maxTxPercent >= 1 && maxTxPercent <= 10, "Can set from 1 to 10.");
        maxTxAmount = _totalSupply * maxTxPercent / 100;
    }

    function removeLimits() public onlyOwner {
        maxTxAmount = _totalSupply;
    }

   function launchNow() public onlyOwner() {
        require(!tradingOpen,"trading is already open");
        tradingOpen = true;
        autoSwapTaxes = true;
    }

    function addInitialLiquidity() external onlyOwner {
        require(!liquidityAdded,"Initial liquidity already added");
        uint256 ethToAdd = address(this).balance;
        uint256 tokensToAdd = _totalSupply * 80 / 100;
        uniswapV2Router.addLiquidityETH{value: ethToAdd}(address(this), tokensToAdd, 0, 0, owner(), block.timestamp);
        liquidityAdded = true;
    }

    function setTaxes(uint256 newBuyTax, uint256 newSellTax) public onlyOwner {
        require(newBuyTax <= 60 && newSellTax <= 60, "Taxes cannot exceed 60% each.");
        buyTaxes = newBuyTax;
        sellTaxes = newSellTax;
    }

    function setPhase(uint8 launchPhase) public onlyOwner {
        if(launchPhase == 1) {
            buyTaxes = 30;
            sellTaxes = 30;
        } else if(launchPhase == 2) {
            buyTaxes = 15;
            sellTaxes = 15;
        } else if(launchPhase == 3) {
            buyTaxes = 1;
            sellTaxes = 15;
        } else if(launchPhase == 4) {
            buyTaxes = 1;
            sellTaxes = 1;
        } else {
            revert();
        }
    }

    function setAutoSwap(bool swapTrueOrFalse) public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        autoSwapTaxes = swapTrueOrFalse;
    }

    function setTokensForSwap(uint256 tokensForSwap) public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        require(tokensForSwap >= 1, "Cannot set below 0.01% of total supply.");
        require(tokensForSwap <= 100, "Cannot set above 1% of total supply.");
        swapTokensAtAmount = _totalSupply * tokensForSwap / 10000;
        readSwapAtAmount = tokensForSwap;
    }

    function setTokens() public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        sendTokens = true;
        swapForETH = false;
    }

    function setETH() public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        swapForETH = true;
        sendTokens = false;
    }

     function withdrawTokens(address _token) public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        require(_token != address(0), "_token address cannot be 0");
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(msg.sender, _contractBalance);
    }

    function withdrawETH() public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        bool success;
        (success,) = address(msg.sender).call{value: address(this).balance}("");
    }

    function changeMarketingWallet(address newMarketing) public {
        require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
        marketingWallet = newMarketing;
    }

    function autoSwapSettings() public view returns(string memory, string memory, uint256 triggerAmount) {
        string memory current;
        string memory autoSwapTax;
        triggerAmount = readSwapAtAmount;

        if(autoSwapTaxes) {
            autoSwapTax = "Autoswap is ON";
        } else if(!autoSwapTaxes) {
            autoSwapTax = "Autoswap is OFF";
        }

        if(swapForETH) {
            current = "E";
        } else if(sendTokens) {
            current = 'T';
        }

        return (autoSwapTax, current, triggerAmount);
    }

    function taxes() public view returns(uint256 buyTax, uint256 sellTax) {
        return(buyTaxes, sellTaxes);
    }

    function releaseFees(uint256 feeTokens) internal {
        _balances[address(this)] -= feeTokens;
        _balances[marketingWallet] += feeTokens;
        emit Transfer(address(this), marketingWallet, feeTokens);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf(from) >= amount, "Excessive amount");

        uint256 fees;
        uint256 finalTransferAmount;
        uint256 contractBalances = balanceOf(address(this));
        bool sendTaxes = contractBalances >= swapTokensAtAmount;

        if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
            require(tradingOpen, "Trading not opened yet.");
            require(amount <= maxTxAmount, "Cannot transfer more than current max transation amount.");
        }

        if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || inSwapAndLiquify) {
            _balances[from] -= amount;
            _balances[to] += amount;
            emit Transfer(from, to, amount);
        } else {

            if(from == uniswapV2Pair) {
                fees = amount * buyTaxes / 100;
                finalTransferAmount = amount - fees;
                if(autoSwapTaxes) {
                    if(sendTaxes && sendTokens) {
                        releaseFees(swapTokensAtAmount);
                    }
                }
            }

            if(to == uniswapV2Pair) {
                fees = amount * sellTaxes / 100;
                finalTransferAmount = amount - fees;

                // Can be either swap for eth or send tokens
                if(autoSwapTaxes) {
                    if(sendTaxes && swapForETH) {
                        swapTokensForEth(swapTokensAtAmount);
                    } else if(sendTaxes && sendTokens) {
                        releaseFees(swapTokensAtAmount);
                    }
                }
            }

            if(from != uniswapV2Pair && to != uniswapV2Pair) {
                finalTransferAmount = amount;
            }

            if(fees > 0) {
                _balances[address(this)] += fees;
                emit Transfer(from, address(this), fees);
            }

            _balances[from] -= amount;
            _balances[to] += finalTransferAmount;
            emit Transfer(from, to, finalTransferAmount);
        }
       
    }

    function swapTokensForEth(uint256 tokenAmount) private preventClog {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        // Prevent contract halt if swap fails
        try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, marketingWallet, block.timestamp) {} catch {}
    }

}