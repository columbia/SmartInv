pragma solidity >= 0.6.6;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function mint(address account, uint256 amount) external;
  function burn(uint256 amount) external;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Owned is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
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

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract unistake is Owned {
  using SafeMath for uint256;

  constructor() public {
    synPerLPTNKPerDay = 1 * 10**18;
    startTime = block.timestamp;
    endTime =  block.timestamp.add(30 days);
    totalSynRewards = 2 * 10**6 * 10**18;
  }

  IERC20 public SYN = IERC20(0x1695936d6a953df699C38CA21c2140d497C08BD9);
  IERC20 public LPTKN = IERC20(0xdF27A38946a1AcE50601Ef4e10f07A9CC90d7231);

  uint256 public synPerLPTNKPerDay;
  uint256 public startTime;
  uint256 public endTime;

  uint256 public totalSynRewards;
  uint256 public totalStaked;
  uint256 public totalTime;
  uint256 public totalStaking;

  mapping(address => uint256) public balances;
  mapping(address => uint256) public timeEntered;

  function stake(uint256 amount) public {
    require(amount > 0);
    uint256 time = timeEntered[msg.sender];
    claimReward();
    if(block.timestamp < endTime && block.timestamp >= startTime) {
      require(LPTKN.transferFrom(msg.sender, address(this), amount));
      if(time == timeEntered[msg.sender]) timeEntered[msg.sender] = block.timestamp;
      totalStaking = totalStaking.add(amount);
      balances[msg.sender] = balances[msg.sender].add(amount);
    }
  }
  function unstake() public {
    require(balances[msg.sender] > 0);
    claimReward();
    uint256 amount = balances[msg.sender];
    totalStaking = totalStaking.sub(amount);
    balances[msg.sender] = balances[msg.sender].sub(amount);
    LPTKN.transfer(msg.sender, amount);
  }
  function claimReward() public {
    updateTotals();
    if(timeEntered[msg.sender] != 0) {
      uint256 syndue = getReward(balances[msg.sender], timeEntered[msg.sender]);
      if(syndue > 0) {
        timeEntered[msg.sender] = block.timestamp > endTime ? endTime : block.timestamp;
        SYN.transfer(msg.sender, syndue);
      }
    }
  }
  function updateTotals() public {
    uint256 time = block.timestamp > endTime ? endTime : block.timestamp;
    uint256 timediff = time.sub(totalTime);
    uint256 reward = totalStaking.mul(timediff).mul(synPerLPTNKPerDay).div(1 days).div(10**18);
    if(reward > 0) totalStaked = totalStaked.add(reward);
    if(totalTime != time) totalTime = time;
    if(totalStaked >= totalSynRewards && block.timestamp == time)
      endTime = block.timestamp;
  }
  //GET BACK UNI-V2 TOKENS WITHOUT CLAIMING SYN REWARDS
  function emergencyRemove(uint256 amount) public {
    require(balances[msg.sender] >= amount);
    balances[msg.sender] = balances[msg.sender].sub(amount);
    totalStaking = totalStaking.sub(amount);
    LPTKN.transfer(msg.sender, amount);
  }

  //VIEW
  function getReward(uint256 amount, uint256 time) public view returns(uint256) {
    uint256 timediff = block.timestamp > endTime ? endTime.sub(time) : block.timestamp.sub(time);
    uint256 reward = amount.mul(timediff).mul(synPerLPTNKPerDay).div(1 days).div(10**18);
    return(reward);
  }

  //ADMIN
  function setStartTime(uint256 time) public onlyOwner() {
    startTime = time;
  }
  function setEndTime(uint256 time) public onlyOwner() {
    endTime = time;
  }
  function setTotalSynRewards(uint256 amount) public onlyOwner() {
    totalSynRewards = amount;
  }
  function tokenremove(IERC20 token, uint256 amount) public onlyOwner() {
    require(token != LPTKN);
    token.transfer(msg.sender, amount);
  }
  function ethremove() public onlyOwner() {
    address payable owner = msg.sender;
    owner.transfer(address(this).balance);
  }


}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}