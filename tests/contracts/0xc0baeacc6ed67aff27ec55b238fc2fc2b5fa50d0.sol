library Math {
  function max(uint a, uint b) internal pure returns (uint) {
    return a >= b ? a : b;
  }

  function min(uint a, uint b) internal pure returns (uint) {
    return a < b ? a : b;
  }

  function average(uint a, uint b) internal pure returns (uint) {
    // (a + b) / 2 can overflow, so we distribute
    return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
  }
}

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

contract Ownable {

  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() internal {
    owner = msg.sender;
    emit OwnershipTransferred(address(0), owner);
  }

  modifier onlyOwner() {
    require(isOwner(), "Ownable: caller is not the owner");
    _;
  }

  function isOwner() public view returns (bool) {
    return msg.sender == owner;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(owner, address(0));
    owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

interface IERC20 {
  function totalSupply() external view returns (uint);
  function balanceOf(address account) external view returns (uint);
  function transfer(address recipient, uint amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint);
  function approve(address spender, uint amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

interface IRewardReceiver {

  function pushRewards() external;
}

contract StakingRewards is Ownable {

  using SafeMath for uint;

  IERC20 public lpt;
  IERC20 public rewardToken;

  uint public totalSupply;
  uint public DURATION = 7 days;
  IRewardReceiver public rewardReceiver;

  uint public starttime;
  uint public periodFinish = 0;
  uint public rewardRate = 0;
  uint public lastUpdateTime;
  uint public rewardPerTokenStored;

  mapping(address => uint) public userRewardPerTokenPaid;
  mapping(address => uint) public rewards;
  mapping(address => uint) public balanceOf;

  event RewardAdded(uint reward);
  event Staked(address indexed user, uint amount);
  event Withdrawn(address indexed user, uint amount);
  event RewardPaid(address indexed user, uint reward);

  constructor(address _rewardToken, address _lptoken, IRewardReceiver _rewardReceiver) public {
    rewardToken  = IERC20(_rewardToken);
    lpt = IERC20(_lptoken);
    rewardReceiver = _rewardReceiver;
    starttime = block.timestamp;
  }

  modifier checkStart() {
    require(block.timestamp >= starttime, "not start");
    _;
  }

  modifier updateReward(address _account) {
    rewardPerTokenStored = rewardPerToken();
    lastUpdateTime = lastTimeRewardApplicable();
    if (_account != address(0)) {
      rewards[_account] = earned(_account);
      userRewardPerTokenPaid[_account] = rewardPerTokenStored;
    }
    _;
  }

  modifier pullRewards() {
    rewardReceiver.pushRewards();
    _;
  }

  function lastTimeRewardApplicable() public view returns (uint) {
    return Math.min(block.timestamp, periodFinish);
  }

  function rewardPerToken() public view returns (uint) {
    if (totalSupply == 0) {
      return rewardPerTokenStored;
    }
    return
      rewardPerTokenStored.add(
        lastTimeRewardApplicable()
          .sub(lastUpdateTime)
          .mul(rewardRate)
          .mul(1e18)
          .div(totalSupply)
      );
  }

  function earned(address _account) public view returns (uint) {
    return
      balanceOf[_account]
        .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
        .div(1e18)
        .add(rewards[_account]);
  }

  // stake visibility is public as overriding LPTokenWrapper's stake() function
  function stake(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
    require(_amount > 0, "Cannot stake 0");
    totalSupply = totalSupply.add(_amount);
    balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
    lpt.transferFrom(msg.sender, address(this), _amount);
    emit Staked(msg.sender, _amount);
  }

  function withdraw(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
    require(_amount > 0, "Cannot withdraw 0");
    totalSupply = totalSupply.sub(_amount);
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
    lpt.transfer(msg.sender, _amount);
    emit Withdrawn(msg.sender, _amount);
  }

  function exit() public {
    withdraw(balanceOf[msg.sender]);
    getReward();
  }

  function getReward() public updateReward(msg.sender) checkStart {
    uint reward = earned(msg.sender);
    if (reward > 0) {
      rewards[msg.sender] = 0;
      rewardToken.transfer(msg.sender, reward);
      emit RewardPaid(msg.sender, reward);
    }
  }

  function notifyRewardAmount(uint _reward)
    public
    updateReward(address(0))
  {
    require(msg.sender == owner || msg.sender == address(rewardReceiver), "invalid reward source");

    if (block.timestamp > starttime) {
      if (block.timestamp >= periodFinish) {
        rewardRate = _reward.div(DURATION);
      } else {
        uint remaining = periodFinish.sub(block.timestamp);
        uint leftover = remaining.mul(rewardRate);
        rewardRate = _reward.add(leftover).div(DURATION);
      }
      lastUpdateTime = block.timestamp;
      periodFinish = block.timestamp.add(DURATION);
      emit RewardAdded(_reward);
    } else {
      rewardRate = _reward.div(DURATION);
      lastUpdateTime = starttime;
      periodFinish = starttime.add(DURATION);
      emit RewardAdded(_reward);
    }
  }
}