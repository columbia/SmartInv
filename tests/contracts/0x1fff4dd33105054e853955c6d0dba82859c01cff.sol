pragma solidity >=0.4.22 <0.6.0;

contract ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf(address who) public view returns (uint value);
    function allowance(address owner, address spender) public view returns (uint remaining);

    function transfer(address to, uint value) public returns (bool ok);
    function transferFrom(address from, address to, uint value) public returns (bool ok);
    function approve(address spender, uint value) public returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract UnochainToken is ERC20{
    uint8 public constant decimals = 18;
    uint256 initialSupply = 5000000000*10**uint256(decimals);
    uint256 public constant initialPrice = 10**13; // 1 ETH / 100 000 UNOC
    uint256 soldTokens = 0;
    uint256 public constant hardCap = 1000000000 * 10**uint256(decimals); // 20%
    uint public saleStart = 0;
    uint public saleFinish = 0;

    string public constant name = "Unochain token";
    string public constant symbol = "UNOC";

    address payable constant teamAddress = address(0x071c0C81f6E4998a39ad736DA8802d278dcF830b);

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    event Burned(address from, uint256 value);

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
        if (balances[msg.sender] >= value && value > 0) {
            balances[msg.sender] -= value;
            balances[to] += value;
            emit Transfer(msg.sender, to, value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
            balances[to] += value;
            balances[from] -= value;
            allowed[from][msg.sender] -= value;
            emit Transfer(from, to, value);
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

    constructor() public {
        balances[teamAddress] = initialSupply * 8 / 10;
        balances[address(this)] = initialSupply * 2 / 10;
        saleStart = 1578009600; // timestamp (03-Jan-2020)
        saleFinish = 1578355200; // timestamp (07-Jan-2020)
    }

    function () external payable {
        require(now > saleStart, "ICO is not started yet");
        require(now < saleFinish, "ICO is over");
        require (msg.value>=10**15, "Send 0.001 ETH minimum"); // 0.001 ETH min
        require (soldTokens<=hardCap, "ICO tokens sold out");

        uint256 valueToPass = 10 ** uint256(decimals) * msg.value / initialPrice;
        soldTokens += valueToPass;

        if (balances[address(this)] >= valueToPass && valueToPass > 0) {
            balances[msg.sender] = balances[msg.sender] + valueToPass;
            balances[address(this)] = balances[address(this)] - valueToPass;
            emit Transfer(address(this), msg.sender, valueToPass);
        }
        teamAddress.transfer(msg.value);
    }

    function burnUnsold() public returns (bool success) {
        require(now > saleFinish, "ICO is not finished yet");
        uint burningAmount = balances[address(this)];
        initialSupply -= burningAmount;
        balances[address(this)] = 0;
        emit Burned(address(this), burningAmount);
        return true;
    }
}