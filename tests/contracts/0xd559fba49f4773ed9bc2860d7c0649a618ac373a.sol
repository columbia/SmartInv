pragma solidity 0.6.12;

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

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
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
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    function increaseAllowance(address spender, uint addedValue) external returns (bool success);
    function decreaseAllowance(address spender, uint subtractedValue) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ERC20 {
    using SafeMath for uint256;
    
    // ERC20 Token variables
    string public symbol = "YFKA";
    string public name = "Yield Farming Known as Ash";
    uint8 public decimals = 18;
    uint public _totalSupply = 0;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
    
    function transfer(address recipient, uint256 amount) public returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(amount, "ERC20: transfer amount exceeds balance");
        balances[recipient] = balances[recipient].add(amount);
        emit Transfer(msg.sender, recipient, amount);
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool success)
    {
        require(value <= balances[from]);
        require(value <= allowances[from][msg.sender]);

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        
        allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }
    
    function approve(address owner, address spender, uint256 amount) internal virtual {
        allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract YFKA is ERC20, Ownable {
    using SafeMath for uint256;

    IERC20 public boaContract;
    uint256 public boaRate;

    IERC20 public xampContract;
    uint256 public xampRate;

    IERC20 public tobContract;
    uint256 public tobRate;

    bool public presaleRunning = true;
    bool public tuning = true;
    
    // OPERATIONAL FUNCTIONS FOR TESTING
    function turnOffTuning() public onlyOwner {
        tuning = false;
    }
    
    function setUp(address _boaContract, uint256 _boaRate, address _xampContract, uint256 _xampRate, address _tobContract, uint256 _tobRate) public onlyOwner {
        require(tuning == true);
        
        boaContract = IERC20(_boaContract);
        boaRate = _boaRate;

        xampContract = IERC20(_xampContract);
        xampRate = _xampRate;

        tobContract = IERC20(_tobContract);
        tobRate = _tobRate;
    }
    
    function changeRate(address _addr, uint256 newRate) public onlyOwner {
        require(tuning == true);
        
        if (_addr == address(boaContract)) boaRate = newRate;
        else if (_addr == address(xampContract)) xampRate = newRate;
        else if (_addr == address(tobContract)) tobRate = newRate;
    }
    
    function changeContract(address _addr, address newAddress) public onlyOwner {
        require(tuning == true);
        
        if (_addr == address(boaContract)) boaContract = IERC20(newAddress);
        else if (_addr == address(xampContract)) xampContract = IERC20(newAddress);
        else if (_addr == address(tobContract)) tobContract = IERC20(newAddress);
    }

    // MINTING FUNCTIONS
    // INTERNAL FOR PRESALE
    function _mint(address to, uint amount) internal {
        require(presaleRunning == true || tuning == true);

        balances[to] = balances[to].add(amount);
        _totalSupply = _totalSupply.add(amount);

        emit Transfer(address(this), msg.sender, amount);
    }

    // POST PRESALE. OWNERSHIP TRANSFERRED TO SMART CONTRACT
    function mint(address to, uint256 amount) onlyOwner public {
        require(presaleRunning == false);
        
        balances[to] = balances[to].add(amount);
        _totalSupply = _totalSupply.add(amount);

        emit Transfer(address(this), msg.sender, amount);
    }

    
    function endPresale() onlyOwner public {
        presaleRunning = false;
    }
    
    function calculateRate(address token, uint256 amount) public view returns (uint256) {
        uint256 rate;
        
        if (token == address(boaContract)) {
            rate = boaRate;
        }
        else if (token == address(xampContract)) {
            rate = xampRate;
        }
        else if (token == address(tobContract)) {
            rate = tobRate;
        }
        
        require(rate > 0);
        
        return amount.mul(rate).div(10 ** 18);
    }

    function _purchaseWithToken(IERC20 token, uint256 amount) internal {
        token.transferFrom(msg.sender, _owner, amount);
        
        uint256 _rate = calculateRate(address(token), amount);
        
        _mint(msg.sender, _rate);
    }

    function purchaseWithBOA(uint256 amount) public returns (bool success) {
        _purchaseWithToken(boaContract, amount);
        return true;
    }

    function purchaseWithXAMP (uint256 amount) public returns (bool success) {
        _purchaseWithToken(xampContract, amount);
        return true;
    }

    function purchaseWithTOB (uint256 amount) public returns (bool success) {
        _purchaseWithToken(tobContract, amount);
        return true;
    }
}