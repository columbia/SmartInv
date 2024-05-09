// File: browser/UnipumpErc20Helper.sol

pragma solidity ^0.7.0;


interface IUnipumpContest
{
}
// File: browser/IUnipumpStaking.sol




interface IUnipumpStaking
{
    event Stake(address indexed _staker, uint256 _amount, uint256 _epochCount);
    event Reward(address indexed _staker, uint256 _reward);
    event RewardPotIncrease(uint256 _amount);

    function stakingRewardPot() external view returns (uint256);
    function currentEpoch() external view returns (uint256);
    function nextEpochTimestamp() external view returns (uint256);
    function isActivated() external view returns (bool);
    function secondsUntilCanActivate() external view returns (uint256);
    function totalStaked() external view returns (uint256);
    
    function increaseRewardsPot() external;
    function activate() external;
    function claimRewardsAt(uint256 index) external;
    function claimRewards() external;
    function updateEpoch() external returns (bool);
    function stakeForProfit(uint256 epochCount) external;
}
// File: browser/IUnipumpDrain.sol




interface IUnipumpDrain
{
    function drain(address token) external;
}
// File: browser/IUnipumpEscrow.sol





interface IUnipumpEscrow is IUnipumpDrain
{
    function start() external;
    function available() external view returns (uint256);
}
// File: browser/IUnipumpTradingGroup.sol






interface IUnipumpTradingGroup
{
    function leader() external view returns (address);
    function close() external;
    function closeWithNonzeroTokenBalances() external;
    function anyNonzeroTokenBalances() external view returns (bool);
    function tokenList() external view returns (IUnipumpTokenList);
    function maxSecondsRemaining() external view returns (uint256);
    function group() external view returns (IUnipumpGroup);
    function externalBalanceChanges(address token) external view returns (bool);

    function startTime() external view returns (uint256);
    function endTime() external view returns (uint256);
    function maxEndTime() external view returns (uint256);

    function startingWethBalance() external view returns (uint256);
    function finalWethBalance() external view returns (uint256);
    function leaderWethProfitPayout() external view returns (uint256);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        uint256 deadline
    ) 
        external 
        returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        uint256 deadline
    ) 
        external 
        returns (uint256[] memory amounts);
        
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        uint256 deadline
    ) 
        external;

    function withdraw(address token) external;
}
// File: browser/IUnipumpTokenList.sol




interface IUnipumpTokenList
{
    function parentList() external view returns (IUnipumpTokenList);
    function isLocked() external view returns (bool);
    function tokens(uint256 index) external view returns (address);
    function exists(address token) external view returns (bool);
    function tokenCount() external view returns (uint256);

    function lock() external;
    function add(address token) external;
    function addMany(address[] calldata _tokens) external;
    function remove(address token) external;    
}
// File: browser/IUnipumpGroup.sol






interface IUnipumpGroup 
{
    function contribute() external payable;
    function abort() external;
    function startPumping() external;
    function isActive() external view returns (bool);
    function withdraw() external;
    function leader() external view returns (address);
    function tokenList() external view returns (IUnipumpTokenList);
    function leaderUppCollateral() external view returns (uint256);
    function requiredMemberUppFee() external view returns (uint256);
    function minEthToJoin() external view returns (uint256);
    function minEthToStart() external view returns (uint256);
    function maxEthAcceptable() external view returns (uint256);
    function maxRunTimeSeconds() external view returns (uint256);
    function leaderProfitShareOutOf10000() external view returns (uint256);
    function memberCount() external view returns (uint256);
    function members(uint256 at) external view returns (address);
    function contributions(address member) external view returns (uint256);
    function totalContributions() external view returns (uint256);
    function aborted() external view returns (bool);
    function tradingGroup() external view returns (IUnipumpTradingGroup);
}
// File: browser/IUnipumpGroupFactory.sol






interface IUnipumpGroupFactory 
{
    function createGroup(
        address leader,
        IUnipumpTokenList unipumpTokenList,
        uint256 uppCollateral,
        uint256 requiredMemberUppFee,
        uint256 minEthToJoin,
        uint256 minEthToStart,
        uint256 startTimeout,
        uint256 maxEthAcceptable,
        uint256 maxRunTimeSeconds,
        uint256 leaderProfitShareOutOf10000
    ) 
        external
        returns (IUnipumpGroup unipumpGroup);
}
// File: browser/IUnipumpGroupManager.sol







interface IUnipumpGroupManager
{
    function groupLeaders(uint256 at) external view returns (address);
    function groupLeaderCount() external view returns (uint256);
    function groups(uint256 at) external view returns (IUnipumpGroup);
    function groupCount() external view returns (uint256);
    function groupCountByLeader(address leader) external view returns (uint256);
    function groupsByLeader(address leader, uint256 at) external view returns (IUnipumpGroup);

    function createGroup(
        IUnipumpTokenList tokenList,
        uint256 uppCollateral,
        uint256 requiredMemberUppFee,
        uint256 minEthToJoin,
        uint256 minEthToStart,
        uint256 startTimeout,
        uint256 maxEthAcceptable,
        uint256 maxRunTimeSeconds,
        uint256 leaderProfitShareOutOf10000
    ) 
        external
        returns (IUnipumpGroup group);
}
// File: browser/openzeppelin/IERC20.sol





/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: browser/IUnipump.sol









interface IUnipump is IERC20 {
    event Sale(bool indexed _saleActive);
    event LiquidityCrisis();

    function WETH() external view returns (address);
    
    function groupManager() external view returns (IUnipumpGroupManager);
    function escrow() external view returns (IUnipumpEscrow);
    function staking() external view returns (IUnipumpStaking);
    function contest() external view returns (IUnipumpContest);

    function init(
        IUnipumpEscrow _escrow,
        IUnipumpStaking _staking) external;
    function startUnipumpSale(uint256 _tokensPerEth, uint256 _maxSoldEth) external;
    function start(
        IUnipumpGroupManager _groupManager,
        IUnipumpContest _contest) external;

    function isSaleActive() external view returns (bool);
    function tokensPerEth() external view returns (uint256);
    function maxSoldEth() external view returns (uint256);
    function soldEth() external view returns (uint256);
    
    function buy() external payable;
    
    function minSecondsUntilLiquidityCrisis() external view returns (uint256);
    function createLiquidityCrisis() external payable;
}
// File: browser/openzeppelin/SafeMath.sol





abstract contract UnipumpErc20Helper
{
    function transferMax(address token, address from, address to) 
        internal
        returns (uint256 amountTransferred)
    {
        uint256 balance = IERC20(token).balanceOf(from);
        if (balance == 0) { return 0; }
        uint256 allowed = IERC20(token).allowance(from, to);
        amountTransferred = allowed > balance ? balance : allowed;
        if (amountTransferred == 0) { return 0; }
        require (IERC20(token).transferFrom(from, to, amountTransferred), "Transfer failed");
    }
}
// File: browser/UnipumpDrain.sol







abstract contract UnipumpDrain is IUnipumpDrain
{
    address payable immutable drainTarget;

    constructor()
    {
        drainTarget = msg.sender;
    }

    function drain(address token)
        public
        override
    {
        uint256 amount;
        if (token == address(0))
        {
            require (address(this).balance > 0, "Nothing to send");
            amount = _drainAmount(token, address(this).balance);
            require (amount > 0, "Nothing allowed to send");
            (bool success,) = drainTarget.call{ value: amount }("");
            require (success, "Transfer failed");
            return;
        }
        amount = IERC20(token).balanceOf(address(this));
        require (amount > 0, "Nothing to send");
        amount = _drainAmount(token, amount);
        require (amount > 0, "Nothing allowed to send");
        require (IERC20(token).transfer(drainTarget, amount), "Transfer failed");
    }

    function _drainAmount(address token, uint256 available) internal virtual returns (uint256 amount);
}
// File: browser/IUnipumpContest.sol





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

// File: browser/UnipumpStaking.sol









contract UnipumpStaking is IUnipumpStaking, UnipumpDrain, UnipumpErc20Helper
{    
    using SafeMath for uint256;
    
    struct StakedCoinInfo 
    {
        uint256 amount;
        uint256 fractionalFirstEpochAmount;
        uint256 stakeUntilEpoch;
        uint256 stakingEpoch;
        uint256 epochRewardsClaimed;
    }
    struct EpochRewardInfo 
    {
        uint256 totalReward;
        uint256 totalStaked;
    }

    IUnipump immutable unipump;

    mapping (address => StakedCoinInfo[]) stakedTokens;
    uint256 public override currentEpoch;
    uint256 public override nextEpochTimestamp;
    uint256 constant epochSeconds = 60 * 60 * 24; // 1 day = 1 epoch
    EpochRewardInfo[] epochRewards;
    uint256 public override totalStaked;
    uint256 totalStakedFractionalFirstEpoch;
    uint256 public override stakingRewardPot;
    uint256 minStakingActivationTime;

    constructor (
        IUnipump _unipump,
        uint256 _seconds
    ) 
    {
        require (address(_unipump) != address(0));
        unipump = _unipump;
        minStakingActivationTime = block.timestamp + _seconds;
    }

    receive()
        external
        payable
    {
    }

    modifier epochUpToDate() { while (!updateEpoch()) { } _; }
    modifier stakingActivated() { require (nextEpochTimestamp != 0, "Staking is not yet available"); _; }

    function activate() 
        public
        override
    {
        require (nextEpochTimestamp == 0, "Staking is already activated");
        require (minStakingActivationTime > 0 && block.timestamp >= minStakingActivationTime, "Staking is not yet available");
        nextEpochTimestamp = block.timestamp + epochSeconds;
    }

    function increaseRewardsPot() 
        public
        override
    {
        uint256 amount = transferMax(address(unipump), msg.sender, address(this));
        stakingRewardPot += amount;
        emit RewardPotIncrease(amount);
    }

    function secondsUntilCanActivate()
        public
        view
        override
        returns (uint256)
    {
        uint256 min = minStakingActivationTime;
        if (block.timestamp >= min) { return 0; }
        return min - block.timestamp;
    }

    function isActivated()
        public
        view
        override
        returns (bool)
    {
        return nextEpochTimestamp != 0;
    }

    function updateEpoch() 
        public 
        override
        stakingActivated()
        returns (bool upToDate) 
    {
        uint256 next = nextEpochTimestamp;
        if (block.timestamp < next) { return true; }
        uint256 epoch = currentEpoch++;
        next += epochSeconds;
        nextEpochTimestamp = next;
        uint256 pot = stakingRewardPot;
        uint256 reward = 
            epoch < 20 ? pot * 3 / 100 :
            epoch < 40 ? pot * 2 / 100 :
            pot / 100;
        epochRewards.push();
        epochRewards[epoch].totalReward = reward;
        epochRewards[epoch].totalStaked = totalStakedFractionalFirstEpoch;
        stakingRewardPot = pot - reward;
        totalStakedFractionalFirstEpoch = totalStaked;
        return block.timestamp < next;
    }
   
    function stakeForProfit(uint256 epochCount) 
        public
        override
        stakingActivated()
        epochUpToDate()
    {
        require (epochCount > 0, "Tokens must be staked until at least the next epoch");
        require (epochCount <= 3650, "Tokens cannot be staked this long");

        uint256 amount = transferMax(address(unipump), msg.sender, address(this));
        require (amount > 0, "No UPP tokens have been authorized for transfer");
        
        uint256 len = stakedTokens[msg.sender].length;
        uint256 epoch = currentEpoch;
        uint256 fractional = amount.mul(nextEpochTimestamp - block.timestamp) / epochSeconds;
        stakedTokens[msg.sender].push();
        stakedTokens[msg.sender][len].amount = amount;
        stakedTokens[msg.sender][len].fractionalFirstEpochAmount = fractional;
        stakedTokens[msg.sender][len].stakeUntilEpoch = epoch + epochCount;
        stakedTokens[msg.sender][len].stakingEpoch = epoch;
        totalStaked += amount;
        totalStakedFractionalFirstEpoch += fractional;

        emit Stake(msg.sender, amount, epochCount);
    }
    
    // This is a backup in case claimRewards runs out of gas
    function claimRewardsAt(uint256 index) 
        public
        override
        epochUpToDate()
    {
        uint256 len = stakedTokens[msg.sender].length;
        require (index < len, "There are no staked tokens");
        
        uint256 claimCount = stakedTokens[msg.sender][index].epochRewardsClaimed;
        uint256 firstEpoch = stakedTokens[msg.sender][index].stakingEpoch;
        uint256 epoch = currentEpoch;
        uint256 claimingEpoch = firstEpoch + claimCount;
        require (epoch > claimingEpoch, "Rewards are not available until the end of the epoch");

        uint256 amountStaked = stakedTokens[msg.sender][index].amount;
        bool expired = epoch >= stakedTokens[msg.sender][index].stakeUntilEpoch;
        uint256 reward = claimCount == 0 ? stakedTokens[msg.sender][index].fractionalFirstEpochAmount : amountStaked;
        reward = reward.mul(epochRewards[claimingEpoch].totalReward) / epochRewards[claimingEpoch].totalStaked;
        if (expired) {
            reward += amountStaked;
            if (len - 1 != index) {
                stakedTokens[msg.sender][index] = stakedTokens[msg.sender][len - 1];                
            }
            stakedTokens[msg.sender].pop();
            totalStaked -= amountStaked;
            totalStakedFractionalFirstEpoch -= amountStaked;
        }
        else {
            stakedTokens[msg.sender][index].epochRewardsClaimed = claimCount + 1;
        }

        unipump.transfer(msg.sender, reward);

        emit Reward(msg.sender, reward);
    }

    function claimRewards()
        public
        override
        epochUpToDate()
    {
        uint256 len = stakedTokens[msg.sender].length;
        require (len > 0, "There are no staked tokens");
        uint256 epoch = currentEpoch;
        uint256 index = len;

        uint256 removed = 0;
        uint256 totalReward = 0;

        while (index-- > 0)
        {
            uint256 claimCount = stakedTokens[msg.sender][index].epochRewardsClaimed;
            uint256 firstEpoch = stakedTokens[msg.sender][index].stakingEpoch;
            uint256 claimingEpoch = firstEpoch + claimCount;
            if (claimingEpoch >= epoch) { continue; }
            
            uint256 amountStaked = stakedTokens[msg.sender][index].amount;
            bool expired = epoch >= stakedTokens[msg.sender][index].stakeUntilEpoch;
            
            for (; claimingEpoch < epoch; ++claimingEpoch) {
                uint256 reward = claimCount++ == 0 ? stakedTokens[msg.sender][index].fractionalFirstEpochAmount : amountStaked;
                reward = reward.mul(epochRewards[claimingEpoch].totalReward) / epochRewards[claimingEpoch].totalStaked;
                if (expired) {
                    reward += amountStaked;
                    if (len - 1 != index) {
                        stakedTokens[msg.sender][index] = stakedTokens[msg.sender][len - 1];                
                    }
                    stakedTokens[msg.sender].pop();
                    removed += amountStaked;
                    removed += amountStaked;
                }
                totalReward += reward;
            }
            if (!expired) { stakedTokens[msg.sender][index].epochRewardsClaimed = claimCount; }
        }
        totalStaked -= removed;
        totalStakedFractionalFirstEpoch -= removed;

        unipump.transfer(msg.sender, totalReward);
        emit Reward(msg.sender, totalReward);
    }

    function _drainAmount(address token, uint256 available) 
        internal 
        override 
        view
        returns (uint256 amount) 
    { 
        // Unipump is for staking.  Anything else can be drained.
        amount = token == address(unipump) ? 0 : available; 
    }
}