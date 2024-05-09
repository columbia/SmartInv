// Dependency file: @openzeppelin/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

// pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal virtual view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal virtual view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// Dependency file: @openzeppelin/contracts/access/Ownable.sol

// pragma solidity ^0.6.0;

// import "@openzeppelin/contracts/GSN/Context.sol";
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// Dependency file: @openzeppelin/contracts/math/SafeMath.sol

// pragma solidity ^0.6.0;

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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// Root file: contracts/TempusStake.sol

pragma solidity ^0.6.10;

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/math/SafeMath.sol";

interface ITempusToken {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function burn(uint256 amount) external;

    function transferReward(address to, uint256 amount) external;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Pair {
    function sync() external;
}

contract TempusStake is Ownable {
    using SafeMath for uint256;

    ITempusToken private tempusToken;
    address private uniswapPool;

    bool public allowStaking = false;
    uint256 public unstakeTax = 7;

    uint256 public constant BURN_RATE = 2;
    uint256 public constant BURN_REWARD = 2;
    uint256 public constant POOL_REWARD = 48;
    uint256 public rewardPool;
    uint256 public lastBurnTime;
    uint256 public totalBurned;

    uint256 public totalStakedTokens;
    uint256 public totalStakedTokenTime;
    uint256 public rewardShareClaimed;
    uint256 private lastAccountingTimestamp;

    struct UserTotals {
        uint256 stakedTokens;
        uint256 totalStakedTokenTime;
        uint256 lastAccountingTimestamp;
        uint256 lastRewardClaimedTimestamp;
    }

    mapping(address => UserTotals) private _userTotals;

    modifier stakingEnabled {
        require(allowStaking, "TempusStake: Staking is not enabled.");
        _;
    }

    event Stake(address addr, uint256 amount, uint256 totalStaked);
    event Unstake(address addr, uint256 withdrawAmount, uint256 tax);
    event SanitisePool(
        address caller,
        uint256 burnAmount,
        uint256 userReward,
        uint256 poolReward,
        uint256 tempusSupply,
        uint256 uniswapBalance
    );
    event ClaimReward(address addr, uint256 rewardAmount, uint256 rewardPool);

    constructor(ITempusToken _tempusToken, address _uniswapPool) public Ownable() {
        tempusToken = _tempusToken;
        uniswapPool = _uniswapPool;
    }

    function info(address value)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            _userTotals[value].stakedTokens,
            _userTotals[value].totalStakedTokenTime,
            _userTotals[value].lastAccountingTimestamp,
            _userTotals[value].lastRewardClaimedTimestamp,
            totalStakedTokens,
            totalStakedTokenTime,
            rewardPool,
            lastAccountingTimestamp
        );
    }

    function updateGlobalStakedTokenTime() internal {
        if (lastAccountingTimestamp == 0) {
            lastAccountingTimestamp = now;
        }
        uint256 newStakedTokenTime = now.sub(lastAccountingTimestamp).mul(totalStakedTokens);
        totalStakedTokenTime = totalStakedTokenTime.add(newStakedTokenTime);
        lastAccountingTimestamp = now;
    }

    function updateUserStakedTokenTime(UserTotals storage totals) internal {
        uint256 currentStakedTokenTime = now.sub(totals.lastAccountingTimestamp).mul(totals.stakedTokens);
        totals.totalStakedTokenTime = currentStakedTokenTime.add(totals.totalStakedTokenTime);
        totals.lastAccountingTimestamp = now;
    }

    function stake(uint256 amount) external stakingEnabled {
        require(amount >= 1e18, "TempusStake: minimum stake amount is 1");
        require(tempusToken.balanceOf(msg.sender) >= amount, "TempusStake: amount is greater than senders balance");

        UserTotals storage totals = _userTotals[msg.sender];

        updateGlobalStakedTokenTime();
        updateUserStakedTokenTime(totals);

        totals.stakedTokens = totals.stakedTokens.add(amount);

        totalStakedTokens = totalStakedTokens.add(amount);

        tempusToken.transferFrom(msg.sender, address(this), amount);

        emit Stake(msg.sender, amount, totals.stakedTokens);
    }

    function unstake() external stakingEnabled {
        UserTotals storage totals = _userTotals[msg.sender];

        updateGlobalStakedTokenTime();
        updateUserStakedTokenTime(totals);

        uint256 withdrawAmount = totals.stakedTokens;
        uint256 tax = withdrawAmount.mul(unstakeTax).div(100);

        rewardPool = rewardPool.add(tax);
        totalStakedTokens = totalStakedTokens.sub(withdrawAmount);

        totalStakedTokenTime = totalStakedTokenTime.sub(totals.totalStakedTokenTime);
        totals.stakedTokens = 0;
        totals.lastAccountingTimestamp = 0;
        totals.lastRewardClaimedTimestamp = 0;
        totals.totalStakedTokenTime = 0;

        tempusToken.transfer(msg.sender, withdrawAmount.sub(tax));

        emit Unstake(msg.sender, withdrawAmount, tax);
    }

    function sanitisePool() external stakingEnabled {
        uint256 timeSinceLastBurn = now - lastBurnTime;
        require(timeSinceLastBurn >= 6 hours, "TempusStake: only 1 burn every 6 hours");

        uint256 burnAmount = getBurnAmount();
        require(burnAmount >= 1 * 1e18, "TempusStake: min burn amount not reached.");

        // Reset last burn time
        lastBurnTime = now;

        uint256 userReward = burnAmount.mul(BURN_REWARD).div(100);
        uint256 poolReward = burnAmount.mul(POOL_REWARD).div(100);
        uint256 finalBurn = burnAmount.sub(userReward).sub(poolReward);

        tempusToken.burn(finalBurn);

        totalBurned = totalBurned.add(finalBurn);
        rewardPool = rewardPool.add(poolReward);
        rewardShareClaimed = 0;

        tempusToken.transferReward(msg.sender, userReward);
        tempusToken.transferReward(address(this), poolReward);

        IUniswapV2Pair(uniswapPool).sync();

        uint256 tempusSupply = tempusToken.totalSupply();
        uint256 uniswapBalance = tempusToken.balanceOf(uniswapPool);

        emit SanitisePool(msg.sender, finalBurn, userReward, poolReward, tempusSupply, uniswapBalance);
    }

    function getBurnAmount() public view stakingEnabled returns (uint256) {
        uint256 tokensInUniswapPool = tempusToken.balanceOf(uniswapPool);
        return tokensInUniswapPool.mul(BURN_RATE).div(100);
    }

    function claimReward() external {
        require(rewardPool > 1e18, "TempusStake: reward pool is too small.");

        UserTotals storage totals = _userTotals[msg.sender];

        require(totals.stakedTokens > 0, "TempusStake: user is not staked.");
        require(userCanClaim(totals), "TempusStake: reward from this burn already claimed.");

        updateGlobalStakedTokenTime();
        updateUserStakedTokenTime(totals);

        uint256 rewardShare = rewardShare(totals.totalStakedTokenTime);

        uint256 rewardAmount = rewardPool.mul(rewardShare).div(10000);
        totals.stakedTokens = totals.stakedTokens.add(rewardAmount);
        totals.lastRewardClaimedTimestamp = now;

        totalStakedTokens = totalStakedTokens.add(rewardAmount);
        rewardPool = rewardPool.sub(rewardAmount);
        rewardShareClaimed = rewardShareClaimed.add(rewardShare);

        emit ClaimReward(msg.sender, rewardAmount, rewardPool);
    }

    function setAllowStaking(bool value) external onlyOwner {
        allowStaking = value;
        lastBurnTime = now;
    }

    function userCanClaim(UserTotals memory totals) internal view returns (bool) {
        uint256 timeSinceLastBurn = now - lastBurnTime;
        uint256 timeSinceLastClaim = now - totals.lastRewardClaimedTimestamp;
        return (totals.lastRewardClaimedTimestamp == 0 || timeSinceLastClaim > timeSinceLastBurn);
    }

    function rewardShare(uint256 userTokenTime) internal view returns (uint256) {
        uint256 max = 10000;
        uint256 shareLeft = max.sub(rewardShareClaimed);
        uint256 globalTokenTime = totalStakedTokenTime.mul(shareLeft).div(max);
        uint256 dec = 10**uint256(18);
        uint256 prec = 10000 * dec;
        uint256 gtt = globalTokenTime * dec;
        uint256 utt = userTokenTime * dec;
        uint256 share = utt.mul(dec).div(gtt);
        return share.mul(prec).div(dec) / dec;
    }
}