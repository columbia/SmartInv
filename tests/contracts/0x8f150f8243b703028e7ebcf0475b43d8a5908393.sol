// File: @openzeppelin/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/math/Math.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
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
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/interfaces/PriceOracleInterface.sol

pragma solidity 0.6.6;

/**
 * @dev Interface of the price oracle.
 */
interface PriceOracleInterface {
    /**
     * @dev Returns `true`if oracle is working.
     */
    function isWorking() external returns (bool);

    /**
     * @dev Returns the latest id. The id start from 1 and increments by 1.
     */
    function latestId() external returns (uint256);

    /**
     * @dev Returns the last updated price. Decimals is 8.
     **/
    function latestPrice() external returns (uint256);

    /**
     * @dev Returns the timestamp of the last updated price.
     */
    function latestTimestamp() external returns (uint256);

    /**
     * @dev Returns the historical price specified by `id`. Decimals is 8.
     */
    function getPrice(uint256 id) external returns (uint256);

    /**
     * @dev Returns the timestamp of historical price specified by `id`.
     */
    function getTimestamp(uint256 id) external returns (uint256);
}

// File: contracts/interfaces/VolatilityOracleInterface.sol

pragma solidity 0.6.6;

/**
 * @dev Interface of the volatility oracle.
 */
interface VolatilityOracleInterface {
    /**
     * @dev Returns the latest volatility.
     * Decimals is 8.
     * This is not a view function because in order for gas efficiency, we would sometimes need to store some values during the calculation of volatility value.
     */
    function getVolatility() external returns (uint256);
}

// File: contracts/MarketOracle.sol

pragma solidity 0.6.6;






/**
 * @notice Market data oracle. It provides prices and historical volatility of the price.
 * Without any problems, It continues to refer to one certain price oracle (main oracle).
 * No one can reassign any other oracle to the main oracle as long as the main oracle is working correctly.
 * When this contract recognizes that the main oracle is not working correctly (stop updating data, start giving wrong data, self truncated), MarketOracle automatically enters Recovery phase.
 *
 * [Recovery phase]
 * When it turns into Recovery phase, it start to refer to a sub oracle in order to keep providing market data continuously.
 * The sub oracle is referred to only in such a case.
 * The sub oracle is not expected to be used for long.
 * In the meanwhile the owner of MarketOracle finds another reliable oracle and assigns it to the new main oracle.
 * If the new main oracle passes some checks, MarketOracle returns to the normal phase from the Recovery phase.
 * Owner can reassign the sub oracle anytime.
 *
 * Volatility is calculated by some last prices provided by the oracle.
 * Calculating volatility is an expensive task, So MarketOracle stores some intermediate values to storage.
 */
contract MarketOracle is
    Ownable,
    PriceOracleInterface,
    VolatilityOracleInterface
{
    using SafeMath for uint256;
    uint256 public constant VOLATILITY_DATA_NUM = 25;
    uint256 private constant SECONDS_IN_YEAR = 31536000;

    /**
     *@notice If true, this contract is in Recovery phase.
     */
    bool public isRecoveryPhase;
    PriceOracleInterface public mainOracle;
    PriceOracleInterface public subOracle;

    uint256 private exTo;
    uint256 public lastCalculatedVolatility;
    PriceOracleInterface private exVolatilityOracle;
    uint256 private exSquareReturnSum;

    event EnterRecoveryPhase();
    event ReturnFromRecoveryPhase(PriceOracleInterface newMainOracle);
    event SetSubOracle(PriceOracleInterface newSubOracle);
    event VolatilityCalculated(uint256 volatility);

    /**
     * @dev Enters Recovery phase if the main oracle is not working.
     */
    modifier recoveryPhaseCheck() {
        if (!mainOracle.isWorking() && !isRecoveryPhase) {
            emit EnterRecoveryPhase();
            isRecoveryPhase = true;
        }
        _;
    }

    constructor(
        PriceOracleInterface _mainOracle,
        PriceOracleInterface _subOracle
    ) public {
        mainOracle = _mainOracle;
        subOracle = _subOracle;
    }

    /**
     * @notice Assigns `oracle` to the new main oracle and returns to the normal phase from Recovery phase.
     * Only owner can call this function only when the main oracle is not working correctly.
     */
    function setMainOracle(PriceOracleInterface oracle) external onlyOwner {
        require(isRecoveryPhase, "Cannot change working main oracle");
        require(oracle.isWorking(), "New oracle is not working");
        mainOracle = oracle;
        isRecoveryPhase = false;
        emit ReturnFromRecoveryPhase(oracle);
    }

    /**
     * @notice Assigns `oracle` to the new sub oracle.
     * Only owner can call this function anytime.
     */
    function setSubOracle(PriceOracleInterface oracle) external onlyOwner {
        subOracle = oracle;
        emit SetSubOracle(oracle);
    }

    /**
     * @notice Calculates the latest volatility.
     * If any update to the price after the last calculation of volatility, recalculates and returns the new value.
     */
    function getVolatility()
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        uint256 to;
        uint256 from;
        uint256 _exTo;
        uint256 exFrom;

        uint256 squareReturnSum;

        PriceOracleInterface oracle = _activeOracle();
        to = oracle.latestId();
        from = to.sub(VOLATILITY_DATA_NUM, "data is too few").add(1);
        _exTo = exTo;

        bool needToRecalculateAll = oracle != exVolatilityOracle || // if oracle has been changed
            (to.sub(_exTo)) >= VOLATILITY_DATA_NUM / 2; // if it is not efficient to reuse some intermediate values.

        if (needToRecalculateAll) {
            // recalculate the whole of intermediate values
            squareReturnSum = _sumOfSquareReturn(oracle, from, to);
        } else if (_exTo == to) {
            // no need to recalculate
            return lastCalculatedVolatility;
        } else {
            // reuse some of intermediate values and recalculate others for gas cost reduce.
            // `_exTo` is same as `to` on the last volatility updated.
            // Whenever volatility is updated, `to` is equal to or more than 25, so `_exTo` never goes below 25.
            exFrom = _exTo.add(1).sub(VOLATILITY_DATA_NUM);
            squareReturnSum = exSquareReturnSum
                .add(_sumOfSquareReturn(oracle, _exTo, to))
                .sub(_sumOfSquareReturn(oracle, exFrom, from));
        }

        uint256 time = oracle.getTimestamp(to).sub(oracle.getTimestamp(from));
        uint256 s = squareReturnSum.mul(SECONDS_IN_YEAR).div(time);
        uint256 v = _sqrt(s);
        lastCalculatedVolatility = v;
        exTo = to;
        exVolatilityOracle = oracle;
        exSquareReturnSum = squareReturnSum;
        emit VolatilityCalculated(v);
        return v;
    }

    /**
     * @notice Returns 'true' if either of the main oracle or the sub oracle is working.
     * @dev See {PriceOracleInterface-isWorking}.
     */
    function isWorking() external override recoveryPhaseCheck returns (bool) {
        return mainOracle.isWorking() || subOracle.isWorking();
    }

    /**
     * @dev See {PriceOracleInterface-latestId}.
     */
    function latestId()
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        return _activeOracle().latestId();
    }

    /**
     * @dev See {PriceOracleInterface-latestPrice}.
     */
    function latestPrice()
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        return _activeOracle().latestPrice();
    }

    /**
     * @dev See {PriceOracleInterface-latestTimestamp}.
     */
    function latestTimestamp()
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        return _activeOracle().latestTimestamp();
    }

    /**
     * @dev See {PriceOracleInterface-getPrice}.
     */
    function getPrice(uint256 id)
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        return _activeOracle().getPrice(id);
    }

    /**
     * @dev See {PriceOracleInterface-getTimestamp}.
     */
    function getTimestamp(uint256 id)
        external
        override
        recoveryPhaseCheck
        returns (uint256)
    {
        return _activeOracle().getTimestamp(id);
    }

    /**
     * @dev Returns the main oracle if this contract is in Recovery phase.
     * Returns the sub oracle if the main oracle is not working.
     * Reverts if neither is working.
     * recoveryPhaseCheck modifier must be called before this function is called.
     */
    function _activeOracle() private returns (PriceOracleInterface) {
        if (!isRecoveryPhase) {
            return mainOracle;
        }
        require(subOracle.isWorking(), "both of the oracles are not working");
        return subOracle;
    }

    /**
     * @dev Returns sum of the square of relative returns of prices given by `oracle`.
     */
    function _sumOfSquareReturn(
        PriceOracleInterface oracle,
        uint256 from,
        uint256 to
    ) private returns (uint256) {
        uint256 a;
        uint256 b;
        uint256 sum;
        b = oracle.getPrice(from);
        for (uint256 id = from + 1; id <= to; id++) {
            a = b;
            b = oracle.getPrice(id);
            sum = sum.add(_squareReturn(a, b));
        }
        return sum;
    }

    /**
     * @dev Returns squareReturn of two values.
     * v = {abs(b-a)/a}^2 * 10^16
     */
    function _squareReturn(uint256 a, uint256 b)
        private
        pure
        returns (uint256)
    {
        uint256 sub = _absDef(a, b);
        return (sub.mul(10**8)**2).div(a**2);
    }

    /**
     * @dev Returns absolute difference of two numbers.
     */
    function _absDef(uint256 a, uint256 b) private pure returns (uint256) {
        if (a > b) {
            return a - b;
        } else {
            return b - a;
        }
    }

    /**
     * @dev Returns square root of `x`.
     * Babylonian method for square root.
     */
    function _sqrt(uint256 x) private pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}