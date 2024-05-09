pragma solidity 0.5.10;

contract owned {
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract VirgoX_ERC20 is owned {

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lockCreateTime;
    mapping(address => uint256) public lockMonths;
    mapping(address => uint256) public lockSumValue;
    mapping(address => uint256) public unlockMonths;

    string public name = "VirgoX Token";
    string public symbol = "VXT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 500000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(value >= 0);
        require(balanceOf[msg.sender] >= value);

        if (lockSumValue[msg.sender] > 0) {
            uint256 beginUnlockTime = lockCreateTime[msg.sender] + lockMonths[msg.sender] * (30 days);
            uint256 endUnlockTime = beginUnlockTime + (unlockMonths[msg.sender]-1) * (30 days);
            if (now >= endUnlockTime) {
                lockCreateTime[msg.sender] = 0;
                lockMonths[msg.sender] = 0;
                lockSumValue[msg.sender] = 0;
                unlockMonths[msg.sender] = 0;
            } else {
                uint256 count = 0;
                if (now >= beginUnlockTime) {
                    count = (now - beginUnlockTime) / (30 days) + 1;
                }
                uint256 lastLockValue = lockSumValue[msg.sender] - (lockSumValue[msg.sender] / unlockMonths[msg.sender]) * count;
                require(balanceOf[msg.sender] - lastLockValue >= value);
            }

        }

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferToLock(address to, uint256 _lockValue, uint256 _lockMonths, uint256 _unlockMonths)
    public onlyOwner
    returns (bool success)
    {
        require(to != msg.sender);
        require(_lockValue > 0);
        require(_lockMonths >= 0);
        require(_unlockMonths > 0);
        require(lockSumValue[to] == 0);
        require(balanceOf[msg.sender] >= _lockValue);

        lockCreateTime[to] = now;
        lockMonths[to] = _lockMonths;
        lockSumValue[to] = _lockValue;
        unlockMonths[to] = _unlockMonths;

        balanceOf[msg.sender] -= _lockValue;
        balanceOf[to] += _lockValue;
        emit Transfer(msg.sender, to, _lockValue);
        return true;
    }

    function unlock(address to)
    public onlyOwner
    returns (bool success)
    {
        require(to != msg.sender);
        lockCreateTime[to] = 0;
        lockMonths[to] = 0;
        lockSumValue[to] = 0;
        unlockMonths[to] = 0;
        return true;
    }

}