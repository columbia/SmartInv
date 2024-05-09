// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1, "Math: mulDiv overflow");

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
        }
    }
}

// File: supermarket/contracts/stake.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.8;
pragma experimental ABIEncoderV2;

//import "@openzeppelin/contracts/math/SafeMath.sol";



interface IMarket{
    function claimTrade(uint256 epoch, uint256 amt,uint256 cp,address claimer,bytes memory signature) payable external;
    function claimMeme(uint256 epoch, uint256 amt,uint256 lp,uint256 cp,bytes memory signature,address cFor) external;
}

contract StakeFixedAPYDuration is Ownable {
    //using SafeMath for uint256;
    //using SafeERC20 for IERC20;
    IERC20 public stakeToken;

    uint256 public duration = 0;
    uint256 public unboundingDuration = 0;
    uint256 private _totalSupply;
    uint256 public taxCollectedFromUnstake = 0;
    uint256 public periodFinish = 0;
    uint256 public constant DENOMINATOR = 10000;
    uint256 public constant SECONDS_IN_YEAR = 365 days;
    uint256 public constant MIN_MAT_PERIOD = 3 days; // set to 3 days.
    uint256 public beforeMaturityUnstakeTaxNumerator = 500;
    uint256 public totalEthReward;
    uint256 private MIN_STAKE = 10000 * 10**18;
    address public rewardDistribution;
    address public trade;
    address public memecoin;



    bool public isStakingStarted = false;

    // Represents a single unstake for a user. A user may have multiple.
    struct Unstake {
        uint256 unstakingAmount;
        uint256 unstakingTime;
    }

    /**
	User Data
	 */
    struct UserData {
        uint256 stakeToken;
        uint256 rewards;
        uint256 lastUpdateTime;
        //uint256 duration;
        uint256 stakingTime;
    }

    mapping(address => UserData) public users;
    // The collection of unstakes for each user.
    mapping(address => Unstake) public userUnstake;

    // Time Duration & APR
    //mapping(uint256 => uint256) public monthlyAPR;
    uint256 private annualAPY;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RecoverToken(address indexed token, uint256 indexed amount);
    event UnstakeAmountClaimed(address indexed user, uint256 amount);
    event RewardDistributionStarted(uint256 periodFinish);
    event RewardReInvested(address indexed user, uint256 reward);
    event UnstakeTaxCollected(uint256 indexed amount);
    modifier onlyRewardDistributor() {
        require(
            _msgSender() == rewardDistribution,
            "Caller is not reward distribution"
        );
        _;
    }

    modifier updateReward(address account) {
        if (account != address(0)) {
            users[account].rewards = earned(account);
        }
        users[account].lastUpdateTime = lastTimeRewardApplicable();
        _;
    }

    constructor(
        IERC20 _stakeToken,
        uint256 _duration,
        uint256 _unboundingDuration,
        address s,
        address m

    )  {
       // require(_forwarder != address(0), "Forwarder cannot be empty");
        stakeToken = _stakeToken;
        duration = _duration;
        unboundingDuration = _unboundingDuration;
        //trustedForwarder = _forwarder;
        trade=s;
        memecoin=m;
        annualAPY = 20000;//200% APY
    }

    // function _msgSender()
    //     internal
    //     view
    //     virtual
    //     override(BaseRelayRecipient, Context)
    //     returns (address payable)
    // {
    //     return BaseRelayRecipient._msgSender();
    // }

    function versionRecipient()
        external
        view
        virtual
        returns (string memory)
    {}

    function getUserData(address addr)
        external
        view
        returns (UserData memory user)
    {
        return users[addr];
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function earned(address account) public view returns (uint256) {
        uint256 earnedFromStakeCoin = users[account]
            .stakeToken * (lastTimeRewardApplicable()-(users[account].lastUpdateTime)) * (getAnnualAPY());

        return
            (earnedFromStakeCoin)/(DENOMINATOR)/(SECONDS_IN_YEAR)+(
                users[account].rewards
            );
    }

    function stake(uint256 amount)
        external
        updateReward(_msgSender())
    {
        require(isStakingStarted, "Staking is not started yet");
        require(amount > 0, "Cannot stake 0");
        require(block.timestamp<periodFinish,"Staking period over");
        // require(
        //     users[_msgSender()].duration <= months,
        //     "New staking duration must be greater than equal to previous staking duration"
        // );
        _totalSupply += (amount);

        users[_msgSender()].stakeToken = users[_msgSender()].stakeToken+(
            amount
        );
        //users[_msgSender()].duration = months;
        users[_msgSender()].stakingTime = block.timestamp;
        stakeToken.transferFrom(_msgSender(), address(this), amount);
        emit Staked(_msgSender(), amount);
    }

    function unstakeFor(address userAddress, uint256 amount, bool taxFlag)
        external
        onlyRewardDistributor updateReward(userAddress)
    {
        require(amount > 0, "Cannot withdraw 0");
        require(
            users[userAddress].stakeToken >= amount,
            "User does not have sufficient balance"
        );
        users[userAddress].stakeToken = users[userAddress].stakeToken -(
            amount
        );

        if (taxFlag == true) {
            uint256 beforeMaturityUnstakeTax = amount
                * (beforeMaturityUnstakeTaxNumerator)
                /(DENOMINATOR);
            amount -= beforeMaturityUnstakeTax;
            taxCollectedFromUnstake += beforeMaturityUnstakeTax;
        } else {
            require(
                users[userAddress].stakingTime + (
                     (MIN_MAT_PERIOD)
                ) <= block.timestamp,
                "Cannot withdraw before maturity"
            );
        }
        _unstake(userAddress, amount);
    }

    function unstake(uint256 amount)
        public
        updateReward(_msgSender())
    {
        require(amount > 0, "Cannot withdraw 0");
        require(
            users[_msgSender()].stakeToken >= amount,
            "User does not have sufficient balance"
        );
        require(
            users[_msgSender()].stakingTime + (
                 (MIN_MAT_PERIOD)
            ) <= block.timestamp,
            "Cannot withdraw before maturity"
        );
        users[_msgSender()].stakeToken = users[_msgSender()].stakeToken -(
            amount
        );
        _unstake(_msgSender(), amount);
    }

    function setTradeMemeAddress(address t,address m) onlyRewardDistributor public {
        trade = t;
        memecoin=m;
    }

    function _unstake(address userAddress, uint256 amount)
        internal
    {
        uint256 myShare = amount*(DENOMINATOR)/_totalSupply;
        myShare = (totalEthReward*myShare)/(DENOMINATOR);
        totalEthReward=totalEthReward-myShare;
        _totalSupply = _totalSupply -(amount);

        getReward();

        if (unboundingDuration == 0) {
            stakeToken.transfer(userAddress, amount);
            sendETHValue(payable(userAddress), myShare);
            
        } else {
            uint256 unboundingPeriodFinish = block.timestamp + (
                unboundingDuration
            );
            Unstake storage accountUnstake = userUnstake[userAddress];
            accountUnstake.unstakingAmount = (accountUnstake.unstakingAmount)
                +(amount);
            accountUnstake.unstakingTime = unboundingPeriodFinish;
        }

        emit Unstaked(userAddress, amount);
    }

    function reinvest() external {
        _reinvest(_msgSender());
    }

    function reinvestFor(address user) external onlyRewardDistributor {
        _reinvest(user);
    }

    function _reinvest(address user) internal updateReward(user) {
        uint256 reward = users[user].rewards;
        if (reward > 0) {
            users[user].rewards = 0;
            users[user].stakeToken = users[user].stakeToken+(reward);
            _totalSupply = _totalSupply+(reward);
            emit RewardReInvested(user, reward);
        }
    }

    function getAnnualAPY()
        public
        view
        returns (uint256)
    {
        //uint256 months = users[account].duration;
        return annualAPY;
    }

    function claimUnstakedAmount() external {
        Unstake storage accountUnstake = userUnstake[_msgSender()];

        require(
            accountUnstake.unstakingAmount > 0,
            "No unstaked amount to claim"
        );
        require(
            block.timestamp >= accountUnstake.unstakingTime,
            "Unbounding period not finished"
        );

        uint256 _totalUnstakedAmount = accountUnstake.unstakingAmount;

        accountUnstake.unstakingAmount = 0;
        accountUnstake.unstakingTime = 0;

        stakeToken.transfer(_msgSender(), _totalUnstakedAmount);
        emit UnstakeAmountClaimed(_msgSender(), _totalUnstakedAmount);
    }
    //earn by claims
    function earnClaims(address s,uint256 epoch, uint256 amt,uint256 cp,uint256 lp,address claimer,bytes memory signature) external payable {
        require(users[msg.sender].stakeToken > MIN_STAKE ,"Min Eligiblity 10k");
        if(s == memecoin){
        IMarket(s).claimMeme( epoch, amt, lp, cp, signature, claimer); 
        }else if(s == trade){
            IMarket(s).claimTrade(epoch,amt,cp,claimer,signature);
        }
        return;
    }

    function totalUnstakedAmountReadyToClaim(address user)
        external
        view
        returns (uint256)
    {
        if (block.timestamp >= userUnstake[user].unstakingTime) {
            return userUnstake[user].unstakingAmount;
        }
        return 0;
    }

    function totalUnstakedAmount(address user) external view returns (uint256) {
        return userUnstake[user].unstakingAmount;
    }

    function getUnboundingTime(address user) external view returns (uint256) {
        return userUnstake[user].unstakingTime;
    }

    function exit() external {
        unstake(users[_msgSender()].stakeToken);
        getReward();
    }

    function getReward() public updateReward(_msgSender()) {
        uint256 reward = users[_msgSender()].rewards;
        if (reward > 0) {
            users[_msgSender()].rewards = 0;
            stakeToken.transfer(_msgSender(), reward);
            emit RewardPaid(_msgSender(), reward);
        }
    }
    //Start Staking
    function notifyRewardDistribution()
        external
        onlyRewardDistributor
        updateReward(address(0))
    {
        require(!isStakingStarted, "Staking is already started");
        isStakingStarted = true;
        periodFinish = block.timestamp+(duration);
        emit RewardDistributionStarted(periodFinish);
    }

    function setAPY( uint256 apr)
        external
        onlyRewardDistributor
    {
        require(apr > 0, "month can not be 0");
        annualAPY = apr;
    }

    function setRewardDistribution(address _rewardDistribution)
        external
        onlyOwner
    {
        rewardDistribution = _rewardDistribution;
    }

    function setDuration(uint256 _duration) external onlyRewardDistributor {
        duration = _duration;
        periodFinish = block.timestamp+(duration);
    }

    function setUnboundingDuration(uint256 _unboundingDuration)
        external
        onlyRewardDistributor
    {
        unboundingDuration = _unboundingDuration;
    }

    function setBeforeMaturityUnstakeTaxNumerator(
        uint256 _beforeMaturityUnstakeTaxNumerator
    ) external onlyRewardDistributor {
        beforeMaturityUnstakeTaxNumerator = _beforeMaturityUnstakeTaxNumerator;
    }

    function stopRewardDistribution() external onlyRewardDistributor {
        periodFinish = block.timestamp;
    }

    function updateRewardFor(
        address[] memory beneficiary,
        uint256[] memory rewards
    ) external onlyRewardDistributor {
        require(beneficiary.length == rewards.length, "Input length invalid");
        for (uint256 i = 0; i < beneficiary.length; i++) {
            users[beneficiary[i]].rewards = (users[beneficiary[i]].rewards)+(
                rewards[i]
            );
        }
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function collectUnstakeTax() external onlyRewardDistributor {
        uint256 tax = taxCollectedFromUnstake;
        taxCollectedFromUnstake = 0;
        IERC20(stakeToken).transfer(_msgSender(), tax);
        emit UnstakeTaxCollected(tax);
    }

    function recoverExcessToken(address token, uint256 amount)
        external
        onlyRewardDistributor
    {
        IERC20(token).transfer(_msgSender(), amount);
        emit RecoverToken(token, amount);
    }
    function sendETHValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    receive() payable external{
        totalEthReward+=msg.value;
    }
}