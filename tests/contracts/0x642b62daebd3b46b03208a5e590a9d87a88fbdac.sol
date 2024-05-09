//Welcome to a true DeFi casino experience!

//TG: https://t.me/allinmain
//Website: https://allincryptocasino.com
//Discord: https://discord.gg/H5aw5zEvUu

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

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
    address private _previousOwner;
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

    function transferOwnership(address _newOwner) public virtual onlyOwner {
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
        
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

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

contract ALLIN is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    mapping (address => uint) private cooldown;
    uint256 private _tax;
    uint256 private time;

    uint256 private constant _tTotal = 1 * 10 ** 9 * 10**9;
    uint256 private fee1=50;
    uint256 private fee2=50;
    uint256 private pc1 = 29;
    uint256 private pc2 = 22;
    uint256 private pc3 = 22;
    uint256 private pc4 = 21;
    uint256 private pc5 = 5;
    uint256 private pc6 = 1;
    string private constant _name = unicode"All In Coin";
    string private constant _symbol = unicode"ALLIN";
    uint256 private _maxTxAmount = _tTotal.div(100);
    uint256 private _maxWalletAmount = _tTotal.div(50);
    uint256 private minBalance = _tTotal.div(1000);
    uint256 private maxCaSell = _tTotal.div(300);
    uint8 private constant _decimals = 9;
    address payable private _deployer;
    address payable private _marketingWallet;
    address payable private _feeWallet2;
    address payable private _feeWallet3;
    address payable private _feeWallet4;
    address payable private _withdrawalWallet;
    address private depositContract;
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    bool private limitsEnabled = true;
    bool private allowBlacklist = true;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    constructor () payable {
        _deployer = payable(msg.sender);
        _marketingWallet = payable(0xB1cf86B9258B8a7f6888D0Bd92045b33Db90CA77);
        _feeWallet2 = payable(0xDDa1aa0c5b9c8b90f2FCec4A7BF16FC675739f0D);
        _feeWallet3 = payable(0xD24434C40E1c08d8b70F0B363E3B54Cff71243A0);
        _feeWallet4 = payable(0xeDF647837b955d1A0BA0Baa9183E9aAaa83C9A92);
        _withdrawalWallet = payable(0xD851cC237c245D49726ea6c34Bd3eB7Cda56bc1e);
        _tOwned[address(this)] = _tTotal.div(100).mul(55);
        _tOwned[_deployer] = _tTotal.div(100).mul(45);
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_deployer] = true;
        _isExcludedFromFee[depositContract] = true;

        emit Transfer(address(0),address(this),_tTotal.div(100).mul(55));
        emit Transfer(address(0),_deployer,_tTotal.div(100).mul(45));
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
        return _tOwned[account];
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

   
    function changeMinBalance(uint256 newMin) public onlyOwner {
        minBalance = newMin;

    }

    function editFees(uint256 one, uint256 two) public onlyOwner {
        require(one <= 50 && two <= 50,"Fees have to smaller than or equal to 5%");
        fee1 = one;
        fee2 = two;
    }

    function removeLimits() public onlyOwner {
        limitsEnabled = false;
    }

    function changePercentages(uint256 nPc1, uint256 nPc2, uint256 nPc3, uint256 nPc4, uint256 nPc5, uint256 nPc6) public onlyOwner {
        require(nPc1 + nPc2 + nPc3 + nPc4 + nPc5 + nPc6 == 100,"Percentages have to add up to 100");
        pc1 = nPc1;
        pc2 = nPc2;
        pc3 = nPc3;
        pc4 = nPc4;
        pc5 = nPc5;
        pc6 = nPc6;
    }

    function setDepositAddress(address deposit) public onlyOwner {
        depositContract = deposit;
    }


    function excludeFromFees(address target) public onlyOwner {
        _isExcludedFromFee[target] = true;
    }

    function disableBlacklist() public onlyOwner {
        allowBlacklist = false;
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

        _tax = 0;
        if (from != _deployer && to != _deployer) {
            require(!bots[from] && !bots[to]);
            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && limitsEnabled){
                // Cooldown
                require((_tOwned[to] + amount) <= _maxWalletAmount,"Max wallet exceeded");
                require(amount <= _maxTxAmount);
                require(cooldown[to] < block.timestamp);
                cooldown[to] = block.timestamp + (30 seconds);
            }
            
            
            if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && from != depositContract) {
                require(block.timestamp > time,"tiny cooldown to blacklist bots");
                uint256 contractTokenBalance = balanceOf(address(this));
                if(contractTokenBalance > minBalance){
                    if(contractTokenBalance > maxCaSell){
                        contractTokenBalance = maxCaSell;
                        if(contractTokenBalance > amount){
                            contractTokenBalance = amount;
                        }
                    }
                    swapTokensForEth(contractTokenBalance);
                    uint256 contractETHBalance = address(this).balance;
                    if(contractETHBalance > 0) {
                        sendETHToFee(address(this).balance);
                    }
                }
            }
        }
        if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
            _tax = 0;
        } else {

            //Set Fee for Buys
            if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
                _tax = fee1;
            }

            //Set Fee for Sells
            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
                _tax = fee2;
            }

        }
        if (to == depositContract || from == depositContract) {
            _tax = 0;
        }	
        _transferStandard(from,to,amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
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
    

    function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
        _approve(address(this),address(uniswapV2Router),tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
    }

    
    function sendETHToFee(uint256 amount) private {
        _deployer.transfer(amount.mul(pc3).div(100));
        _marketingWallet.transfer(amount.mul(pc2).div(100));
        _feeWallet2.transfer(amount.mul(pc4).div(100));
        _feeWallet3.transfer(amount.mul(pc5).div(100));
        _feeWallet4.transfer(amount.mul(pc1).div(100));
    }
    
    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        addLiquidity(balanceOf(address(this)),address(this).balance,owner());
        fee1 = 100;
        fee2 = 100;
        swapEnabled = true;
        tradingOpen = true;
        limitsEnabled = true;
        time = block.timestamp + (3 minutes);
    }


    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
        _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
        emit Transfer(sender, recipient, transferAmount);
    }

    function setBots(address[] memory bots_) public onlyOwner {
        require(allowBlacklist);
        for (uint i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }
    
    function delBot(address[] memory notbots) public onlyOwner {
        for (uint i = 0; i < notbots.length; i++) {
            bots[notbots[i]] = false;
        }
    }

    receive() external payable {}
    
    function manualswap() external onlyOwner {
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
    
    function manualsend() external onlyOwner {
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }
   
    function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
        uint256 tFee = tAmount.mul(_tax).div(1000);
        uint256 tTransferAmount = tAmount.sub(tFee);
        return (tTransferAmount, tFee);
    }

    function recoverTokens(address tokenAddress) public onlyOwner {
        IERC20 recoveryToken = IERC20(tokenAddress);
        recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
    }
}