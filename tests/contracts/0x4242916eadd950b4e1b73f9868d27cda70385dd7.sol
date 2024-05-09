pragma solidity ^0.5.10;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20Detailed is IERC20 {

  uint8 public _Tokendecimals;
  string public _Tokenname;
  string public _Tokensymbol;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
   
    _Tokendecimals = decimals;
    _Tokenname = name;
    _Tokensymbol = symbol;
    
  }

  function name() public view returns(string memory) {
    return _Tokenname;
  }

  function symbol() public view returns(string memory) {
    return _Tokensymbol;
  }

  function decimals() public view returns(uint8) {
    return _Tokendecimals;
  }
}

contract MoonFarm is ERC20Detailed {

    using SafeMath for uint256;

    uint256 constant public BASE_PRICE = 22180326050792;
    uint256 constant public FINAL_PRICE = 66540978152376;
    uint256 constant public HARDCAP = 13455.93 ether;

    uint256 public fStage;
    uint256 public end;
    uint256 public totalUsers;
    uint256 public totalDeposit;
    bool public ended;
    bool public reached;
    address[] public shareholders;

    address payable public _owner = 0xb7E4B48aBafA0197dEb58aA4D68906B7411e3DA3;

    mapping (address => uint256) public _MOONFARMTokenBalances;
    mapping (address => mapping (address => uint256)) public _allowed;
    string constant tokenName = "moon.farm";
    string constant tokenSymbol = "MOONFARM";
    uint8  constant tokenDecimals = 18;
    uint256 _totalSupply;

    struct User {
        bool isClaimed;
        uint256 claimed;
        uint256 deposited_amount;
        uint256 token_amount;
        address referrer;
        uint256 bonus;
    }

    mapping (address => User) public users;

    event Newbie(address user);
    event NewDeposit(address indexed user, uint256 amount);
    event Claimed(address indexed user, uint256 amount);
    event RefBonus(address indexed referrer, address indexed referral, uint256 amount);

    constructor () public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals){
        fStage = now + 10 days;
        end = now + 25 days;

        ended = false;
        reached = false;
        _totalSupply = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not Owner");
        _;
    }

    function isEnded() public view returns(bool) {
        return (now >= end || totalDeposit >= HARDCAP) ? true: false;
    }

    function buy(address referrer) external payable {
        require(!isEnded(), "ICO Already Ended");
        purchaseTokens(msg.sender, msg.value, referrer);
    }

    
    function purchaseTokens(address _sender, uint256 _incoming, address referrer) internal {
        uint256 _tokens = calcTokenAmount(_incoming);
        User storage user = users[_sender];

        if (user.referrer == address(0) && users[referrer].deposited_amount > 0 && referrer != msg.sender) {
            user.referrer = referrer;
        }

        if (user.referrer != address(0)) {

            address upline = user.referrer;
            
			if (upline != address(0)) {
				uint256 _amount = _tokens.mul(5).div(100);
				users[upline].bonus = users[upline].bonus.add(_amount);
                _totalSupply = _totalSupply.add(_amount);
				emit RefBonus(upline, msg.sender, _amount);
			}
        }

        if(user.deposited_amount > 0) {
            user.deposited_amount = user.deposited_amount.add(_incoming);
            user.token_amount = user.token_amount.add(_tokens);
        } else {
            user.deposited_amount = _incoming;
            user.token_amount = _tokens;
            totalUsers = totalUsers.add(1);
            shareholders.push(_sender);

            emit Newbie(_sender);
        }

        totalDeposit = totalDeposit.add(_incoming);
        _totalSupply = _totalSupply.add(_tokens);

        emit NewDeposit(_sender, _incoming);
        emit Transfer(address(0), address(this), _tokens);
    }

    function claim() external {
        require(isEnded(), "ICO is still being holding");
        User storage user = users[msg.sender];
        require(user.token_amount > 0, "Invalid User");
        require(!user.isClaimed, "Already claimed");

        uint256 totalAmount;
        uint256 referralBonus = getUserReferralBonus(msg.sender);
        if (referralBonus > 0) {
            totalAmount = user.token_amount.add(referralBonus);
            user.bonus = 0;
        }

        _MOONFARMTokenBalances[msg.sender] = totalAmount;

        user.isClaimed = true;
        user.claimed = now;

        emit Claimed(msg.sender, totalAmount);
        emit Transfer(address(this), msg.sender, totalAmount);
    }

    function calcDepositAmount(uint256 _tokens) public view returns (uint256) {
        uint256 ethAmount = 0;
        if(now <= fStage) {
            ethAmount = _tokens.mul(BASE_PRICE).mul(100).div(1 ether).div(110);
        } else {
            ethAmount = _tokens.mul(FINAL_PRICE).div(1 ether);
        }
        return ethAmount;
    }

    function calcTokenAmount(uint256 _incoming) public view returns (uint256) {
        uint256 _tokens = 0;
        if(now <= fStage) {
            _tokens = _incoming.mul(1 ether).div(BASE_PRICE);
            _tokens = _tokens.mul(110).div(100);
        } else {
            _tokens = _incoming.mul(1 ether).div(FINAL_PRICE);
        }

        return _tokens;
    }

    function getUserReferrer(address userAddress) public view returns(address) {
        return users[userAddress].referrer;
    }

    function getUserReferralBonus(address userAddress) public view returns(uint256) {
        return users[userAddress].bonus;
    }

    function getUserAvailable(address userAddress) public view returns(uint256) {
        (uint256 tokenBalance, bool isClaimed) = checkTokenBalance(userAddress);
        return getUserReferralBonus(userAddress).add(tokenBalance);
    }

    function checkTokenBalance(address _sender) public view returns (uint256, bool) {
        User storage user = users[_sender];

        return (user.token_amount, user.isClaimed);
    }

    function withdraw_eth() external onlyOwner returns (bool) {
        require(isEnded(), "ICO is still being holding");
        require(address(this).balance > 0, "Invalid Balance of Eth");

        (bool success, ) = _owner.call.value(address(this).balance)("");
        return success;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _MOONFARMTokenBalances[owner];
    }


    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _MOONFARMTokenBalances[msg.sender]);
        require(to != address(0));

        _MOONFARMTokenBalances[msg.sender] = _MOONFARMTokenBalances[msg.sender].sub(value);
        _MOONFARMTokenBalances[to] = _MOONFARMTokenBalances[to].add(value);

        emit Transfer(msg.sender, to, value);
        return true;
    }


    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }


    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= _MOONFARMTokenBalances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _MOONFARMTokenBalances[from] = _MOONFARMTokenBalances[from].sub(value);

        _MOONFARMTokenBalances[to] = _MOONFARMTokenBalances[to].add(value);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

        emit Transfer(from, to, value);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }
}