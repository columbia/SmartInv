pragma solidity 0.6.12;

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
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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
    constructor () internal {
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

contract CurryStatic is Ownable {
    using SafeMath for uint256;
    
    IERC20 public token;
    
    struct Stake {
        uint256 amount;
        uint256 reward;
        uint256 stakeIndex;
        uint256 lastclaimedBlock;
        uint256 fee; 
        uint256 rewardWithdrawn;
        
    }
    
    uint256 constant FEE_TO_STAKE = 1;
    uint256 FEE_TO_UNSTAKE = 4;
    
    address[] private stakingAddresses;
    mapping(address => Stake) public addressToStakeMap;
    mapping(uint256 => uint256) public cumulativeblockToReward;
    uint256 public totalAmountForDistribution;
    uint256 public totalStakes;
    uint256 public lastRewardFromChefUpdatedBlock;
    uint256 public totalNumberOfStakers;
    
    address public teamAddress =  address(0); // change address
    address public chefAddress =  address(0); // change address
    
    constructor(IERC20 _token) public {
         token = _token;
    }
     modifier onlyChef() {
        require(chefAddress == _msgSender(), "CurryStatic: caller is not the chefaddress");
        _;
    }
    
     // distribute function called by chef contract only
    function distribute(uint256 amount) external onlyChef {
        // update the total cumulative rewards where the tokens are sent from chef contract
        totalAmountForDistribution = totalAmountForDistribution.add(amount);
        lastRewardFromChefUpdatedBlock = block.number;
        cumulativeblockToReward[lastRewardFromChefUpdatedBlock] = cumulativeblockToReward[lastRewardFromChefUpdatedBlock].add(totalAmountForDistribution);
        
    }
    
    // stake function
    function stake(uint256 amount) public {
        require(
            amount != 0,
            "amount cannot be zero"
        );
      
        
        Stake storage _stake = addressToStakeMap[_msgSender()];
        
        if (_stake.amount == 0) {
            _stake.stakeIndex = stakingAddresses.length;
            stakingAddresses.push(_msgSender());
            // update the lastrewardblock to keep track that , when he staked how much rewards came from chef contract
            // only first time update, as multiple time stake applicable
            _stake.lastclaimedBlock = lastRewardFromChefUpdatedBlock;
             totalNumberOfStakers = totalNumberOfStakers.add(1);
        }
        
        uint256 fee = amount.mul(FEE_TO_STAKE).div(100); // 1% stake fee
        uint256 amountAfterFee = amount.sub(fee);  // actual staked amount
        totalStakes = totalStakes.add(amountAfterFee); // update total stakes
        _stake.amount = _stake.amount.add(amountAfterFee); // store the staking amount
        
        
        
        // transfer tokens to this address
        require(
            token.transferFrom(_msgSender(), address(this), amountAfterFee),  
            "transferFrom failed."
        );
        
        // transfer the fee to teamaddress 
        require(
            token.transferFrom(_msgSender(), teamAddress, fee),
            "transfer failed"
        );
      
    }
    
    // withdraw function
    function withdraw() public  {
        Stake storage _stake = addressToStakeMap[_msgSender()];
        if (_stake.amount == 0) {
            revert("no amount to withdraw");
        }
        
        uint256 fee = _stake.amount.mul(FEE_TO_UNSTAKE).div(100); // 4% unstake fee
        uint256 amountAfterFee = _stake.amount.sub(fee);  // withdrawal amount 
        
        
        // Get the reward came from chef contract
        // logic: last updated cumultaive reward - his staked time cumulative reward 
        _stake.reward = checkCurrentRewards(_msgSender());
        
        
        // add the reward which got from chef contract via, distribute function calling from chef contract
        uint256 withdrawlAmount = amountAfterFee.add(_stake.reward);
        
        // delete the user and update stake
        totalStakes = totalStakes.sub(_stake.amount); // update stake
        totalNumberOfStakers = totalNumberOfStakers.sub(1);
        delete addressToStakeMap[_msgSender()];
        
         // transfer tokens to the user
        require(
            token.transfer(_msgSender(), withdrawlAmount),
            "transfer failed"
        );
        
        // transfer the fee to teamaddress
        require(
            token.transfer(teamAddress, fee),
            "transfer failed"
        );
        
       
    
    }
    
    // update token address called by owner only
    function changeTokenAddress(IERC20 newAddr) public onlyOwner {
        require(
            newAddr != IERC20(0),
            "zero address is not allowed"
        );
        
        // token address can be changed when total stakers are 0
        require(
            totalNumberOfStakers == 0,
            "stakers are present, can not change token address"
        );
        
       token = newAddr;
    }
    
      // update chef address called by owner only
    function changeChefAddress(address newAddr) public onlyOwner {
        require(
            newAddr != address(0),
            "zero address is not allowed"
        );
        
       chefAddress = newAddr;
    }
    
    // update team address called by owner only
    function changeTeamAddress(address newAddr) public onlyOwner {
        require(
            newAddr != address(0),
            "zero address is not allowed"
        );
        
        teamAddress = newAddr;
    }
    
    // withdraw tokens if no stakers are present
     function withdrawUnClaimed() public onlyOwner {
         require(
            totalNumberOfStakers == 0,
            "stakers are present, can not withdraw unclaimed"
        );
         require(
            token.balanceOf(address(this)) != 0,
            "totalAmountForDistribution is 0, can not claim"
        );
        
         require(
            token.transfer(teamAddress, token.balanceOf(address(this))),
            "transfer failed"
        );    
      
    }
    
    // check the current reward
    function checkCurrentRewards(address user) public view returns (uint256) {
        Stake storage _stake = addressToStakeMap[user];
          // Get the reward came from chef contract
        // logic: last updated cumultaive reward - his staked time cumulative reward 
        uint256 totalRewardInStakeperiod = cumulativeblockToReward[lastRewardFromChefUpdatedBlock].sub(cumulativeblockToReward[_stake.lastclaimedBlock]);
        // calculate his reward according to his stake amount
        uint256 currReward = totalRewardInStakeperiod.mul(_stake.amount).div(totalStakes);
        return currReward;
    }
    
     // check staking amount
    function checkStakingAmount(address user) public view returns (uint256) {
        Stake storage _stake = addressToStakeMap[user];
        return _stake.amount;
    }
    

}