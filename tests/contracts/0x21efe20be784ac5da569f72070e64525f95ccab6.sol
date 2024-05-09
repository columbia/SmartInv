pragma solidity >=0.4.22 <0.6.0;

library SafeMath {
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

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf(address who) public view returns (uint value);
    function allowance(address owner, address spender) public view returns (uint remaining);

    function transfer(address to, uint value) public returns (bool ok);
    function transferFrom(address from, address to, uint value) public returns (bool ok);
    function approve(address spender, uint value) public returns (bool ok);

    event Burned(uint value, uint when);
    event Stacked(address indexed from, uint value, uint when);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract AZBIcore is ERC20{

    modifier onlyTeam{
        require(msg.sender == teamAddress, "This function is for team only!");
        _;
    }

    using SafeMath for uint256;
    uint8 public constant decimals = 18;
    uint256 initialSupply;
    uint256 public soldTokens = 0;
    uint256 public currentPrice;
    uint256 public currentInterest;
    string public constant name = "AZBI core";
    string public constant symbol = "AZBI";

    //add valid address!!!
    address payable teamAddress;
    address stakingRewardAddress = address(this);

    mapping (address => uint256) balances;
    mapping (address => uint256) stacked;
    mapping (address => uint256) timeOfStacking;

    mapping (address => mapping (address => uint256)) allowed;

    function stake() public returns (bool success) {
        if (balances[msg.sender] >= 0) {
            uint256 value = balances[msg.sender];
            stacked[msg.sender] = stacked[msg.sender].add(value);
            balances[msg.sender] = 0;
            timeOfStacking[msg.sender] = now;
            emit Stacked(msg.sender, value, now);
            return true;
        } else {
            return false;
        }
    }

    function currentReward(address owner) public view returns (uint256 value) {
        if (stacked[owner] > 0) {
            uint256 reward = stacked[owner].mul(currentInterest).div(100).mul(now.sub(timeOfStacking[owner])).div(365 days);  // 20% per year
            if (reward<=balances[stakingRewardAddress]) {
                return reward;
            } else {
                return balances[stakingRewardAddress];
            }
        }
        else return 0;
    }

    function getStacked(address owner) public view returns (uint256 value) {
        return stacked[owner];
    }

    function claimReward() public returns (bool success) {
        require(stacked[msg.sender]>0, "You need to have something staked first"); // none stacked
        uint256 reward = currentReward(msg.sender);
        balances[stakingRewardAddress] = balances[stakingRewardAddress].sub(reward);
        balances[msg.sender] = balances[msg.sender].add(reward);
        balances[msg.sender] = balances[msg.sender].add(stacked[msg.sender]);
        stacked[msg.sender] = 0;
        return true;
    }

    function totalSupply() public view returns (uint256) {
        return initialSupply;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint remaining) {
        return allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        if (balances[msg.sender] >= value) {
            require (value>=10**2, "too small amount of AZBI"); // too small amount of AZBI
            balances[msg.sender] = balances[msg.sender].sub(value);
            uint256 toBurn = value.div(100);
            uint256 forReward = value.mul(3).div(100);
            uint256 toTransfer = value.mul(96).div(100);
            balances[to] = balances[to].add(toTransfer);
            balances[stakingRewardAddress] = balances[stakingRewardAddress].add(forReward);
            emit Burned(toBurn, now);
            initialSupply = initialSupply.sub(toBurn);
            emit Transfer(msg.sender, to, toTransfer);
            emit Transfer(msg.sender, stakingRewardAddress, forReward);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        if (balances[from] >= value && allowed[from][msg.sender] >= value) {
            require (value>=10**2, "too small amount of AZBI"); // too small amount of AZBI
            uint256 toBurn = value.div(100);
            uint256 forReward = value.mul(3).div(100);
            uint256 toTransfer = value.mul(96).div(100);
            balances[from] = balances[from].sub(value);
            allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
            balances[to] = balances[to].add(toTransfer);
            balances[stakingRewardAddress] = balances[stakingRewardAddress].add(forReward);
            emit Burned(toBurn, now);
            initialSupply = initialSupply.sub(toBurn);
            emit Transfer(from, to, toTransfer);
            emit Transfer(from, stakingRewardAddress, forReward);
            return true;
        } else {
            return false;
        }
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function changeInterest(uint256 value) public onlyTeam {
        currentInterest = value;
    }

    function changePrice(uint256 value) public onlyTeam {
        currentPrice = value;
    }

    constructor() public payable {
        teamAddress = address(0x8EcA013b8eca5a8643914798AdBdf313BF91AC8a);
        initialSupply = 20000000000*10**uint256(decimals);
        currentPrice = 5 * 10**12;
        currentInterest = 20;
        balances[teamAddress] = initialSupply.mul(6).div(10);
        balances[stakingRewardAddress] = initialSupply.mul(4).div(10);
    }

    function () external payable {
        require (msg.value>=10**15, "Send 0.001 ETH minimum"); // 0.001 ETH min
        uint256 valueToPass =  msg.value.div(currentPrice).mul(10**uint256(decimals));
        if (balances[address(this)] <= valueToPass)
            valueToPass = balances[address(this)];

        soldTokens = soldTokens.add(valueToPass);

        if (balances[address(this)] >= valueToPass && valueToPass > 0) {
            balances[msg.sender] = balances[msg.sender].add(valueToPass);
            balances[address(this)] = balances[address(this)].sub(valueToPass);
            emit Transfer(address(this), msg.sender, valueToPass);
        }
        teamAddress.transfer(msg.value);
    }
}