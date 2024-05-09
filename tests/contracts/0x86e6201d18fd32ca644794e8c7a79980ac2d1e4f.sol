pragma solidity 0.6.6;

// File: contracts/util/DeployerRole.sol


abstract contract DeployerRole {
    address internal immutable _deployer;

    modifier onlyDeployer() {
        require(
            _isDeployer(msg.sender),
            "only deployer is allowed to call this function"
        );
        _;
    }

    constructor() public {
        _deployer = msg.sender;
    }

    function _isDeployer(address account) internal view returns (bool) {
        return account == _deployer;
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol



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

// File: @openzeppelin/contracts/math/SignedSafeMath.sol



/**
 * @title SignedSafeMath
 * @dev Signed math operations with safety checks that revert on error.
 */
library SignedSafeMath {
    int256 constant private _INT256_MIN = -2**255;

    /**
     * @dev Multiplies two signed integers, reverts on overflow.
     */
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");

        int256 c = a * b;
        require(c / a == b, "SignedSafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
     */
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0, "SignedSafeMath: division by zero");
        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");

        int256 c = a / b;

        return c;
    }

    /**
     * @dev Subtracts two signed integers, reverts on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");

        return c;
    }

    /**
     * @dev Adds two signed integers, reverts on overflow.
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");

        return c;
    }
}

// File: @openzeppelin/contracts/utils/SafeCast.sol




/**
 * @dev Wrappers over Solidity's uintXX casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 *
 * Can be combined with {SafeMath} to extend it to smaller types, by performing
 * all math on `uint256` and then downcasting.
 */
library SafeCast {

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits.
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
        return uint8(value);
    }

    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        require(value >= 0, "SafeCast: value must be positive");
        return uint256(value);
    }

    /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        require(value < 2**255, "SafeCast: value doesn't fit in an int256");
        return int256(value);
    }
}

// File: contracts/math/UseSafeMath.sol







/**
 * @notice ((a - 1) / b) + 1 = (a + b -1) / b
 * for example a.add(10**18 -1).div(10**18) = a.sub(1).div(10**18) + 1
 */

library SafeMathDivRoundUp {
    using SafeMath for uint256;

    function divRoundUp(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        require(b > 0, errorMessage);
        return ((a - 1) / b) + 1;
    }

    function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
        return divRoundUp(a, b, "SafeMathDivRoundUp: modulo by zero");
    }
}


/**
 * @title UseSafeMath
 * @dev One can use SafeMath for not only uint256 but also uin64 or uint16,
 * and also can use SafeCast for uint256.
 * For example:
 *   uint64 a = 1;
 *   uint64 b = 2;
 *   a = a.add(b).toUint64() // `a` become 3 as uint64
 * In additionally, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.
 * In the case of the operation to the uint64 value, one need to cast the value into int256 in
 * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.
 * For example:
 *   int256 a = 1;
 *   uint64 b = 2;
 *   int256 c = 3;
 *   a = a.add(int256(b).sub(c)); // `a` become 0 as int256
 *   b = a.toUint256().toUint64(); // `b` become 0 as uint64
 */
abstract contract UseSafeMath {
    using SafeMath for uint256;
    using SafeMathDivRoundUp for uint256;
    using SafeMath for uint64;
    using SafeMathDivRoundUp for uint64;
    using SafeMath for uint16;
    using SignedSafeMath for int256;
    using SafeCast for uint256;
    using SafeCast for int256;
}

// File: contracts/oracle/OracleInterface.sol


// Oracle referenced by OracleProxy must implement this interface.
interface OracleInterface {
    // Returns if oracle is running.
    function alive() external view returns (bool);

    // Returns latest id.
    // The first id is 1 and 0 value is invalid as id.
    // Each price values and theirs timestamps are identified by id.
    // Ids are assigned incrementally to values.
    function latestId() external returns (uint256);

    // Returns latest price value.
    // decimal 8
    function latestPrice() external returns (uint256);

    // Returns timestamp of latest price.
    function latestTimestamp() external returns (uint256);

    // Returns price of id.
    function getPrice(uint256 id) external returns (uint256);

    // Returns timestamp of id.
    function getTimestamp(uint256 id) external returns (uint256);

    function getVolatility() external returns (uint256);
}

// File: contracts/oracle/UseOracle.sol


abstract contract UseOracle {
    OracleInterface internal _oracleContract;

    constructor(address contractAddress) public {
        require(
            contractAddress != address(0),
            "contract should be non-zero address"
        );
        _oracleContract = OracleInterface(contractAddress);
    }

    /// @notice Get the latest USD/ETH price and historical volatility using oracle.
    /// @return rateETH2USDE8 (10^-8 USD/ETH)
    /// @return volatilityE8 (10^-8)
    function _getOracleData()
        internal
        returns (uint256 rateETH2USDE8, uint256 volatilityE8)
    {
        rateETH2USDE8 = _oracleContract.latestPrice();
        volatilityE8 = _oracleContract.getVolatility();

        return (rateETH2USDE8, volatilityE8);
    }

    /// @notice Get the price of the oracle data with a minimum timestamp that does more than input value
    /// when you know the ID you are looking for.
    /// @param timestamp is the timestamp that you want to get price.
    /// @param hintID is the ID of the oracle data you are looking for.
    /// @return rateETH2USDE8 (10^-8 USD/ETH)
    function _getPriceOn(uint256 timestamp, uint256 hintID)
        internal
        returns (uint256 rateETH2USDE8)
    {
        uint256 latestID = _oracleContract.latestId();
        require(
            latestID != 0,
            "system error: the ID of oracle data should not be zero"
        );

        require(hintID != 0, "the hint ID must not be zero");
        uint256 id = hintID;
        if (hintID > latestID) {
            id = latestID;
        }

        require(
            _oracleContract.getTimestamp(id) > timestamp,
            "there is no price data after maturity"
        );

        id--;
        while (id != 0) {
            if (_oracleContract.getTimestamp(id) <= timestamp) {
                break;
            }
            id--;
        }

        return _oracleContract.getPrice(id + 1);
    }
}

// File: contracts/BondMakerInterface.sol


interface BondMakerInterface {
    event LogNewBond(
        bytes32 indexed bondID,
        address bondTokenAddress,
        uint64 stableStrikePrice,
        bytes32 fnMapID
    );

    event LogNewBondGroup(uint256 indexed bondGroupID);

    event LogIssueNewBonds(
        uint256 indexed bondGroupID,
        address indexed issuer,
        uint256 amount
    );

    event LogReverseBondToETH(
        uint256 indexed bondGroupID,
        address indexed owner,
        uint256 amount
    );

    event LogExchangeEquivalentBonds(
        address indexed owner,
        uint256 indexed inputBondGroupID,
        uint256 indexed outputBondGroupID,
        uint256 amount
    );

    event LogTransferETH(
        address indexed from,
        address indexed to,
        uint256 value
    );

    function registerNewBond(uint256 maturity, bytes calldata fnMap)
        external
        returns (
            bytes32 bondID,
            address bondTokenAddress,
            uint64 solidStrikePrice,
            bytes32 fnMapID
        );

    function registerNewBondGroup(
        bytes32[] calldata bondIDList,
        uint256 maturity
    ) external returns (uint256 bondGroupID);

    function issueNewBonds(uint256 bondGroupID)
        external
        payable
        returns (uint256 amount);

    function reverseBondToETH(uint256 bondGroupID, uint256 amount)
        external
        returns (bool success);

    function exchangeEquivalentBonds(
        uint256 inputBondGroupID,
        uint256 outputBondGroupID,
        uint256 amount,
        bytes32[] calldata exceptionBonds
    ) external returns (bool);

    function liquidateBond(uint256 bondGroupID, uint256 oracleHintID) external;

    function getBond(bytes32 bondID)
        external
        view
        returns (
            address bondAddress,
            uint256 maturity,
            uint64 solidStrikePrice,
            bytes32 fnMapID
        );

    function getFnMap(bytes32 fnMapID)
        external
        view
        returns (bytes memory fnMap);

    function getBondGroup(uint256 bondGroupID)
        external
        view
        returns (bytes32[] memory bondIDs, uint256 maturity);

    function generateBondID(uint256 maturity, bytes calldata functionHash)
        external
        pure
        returns (bytes32 bondID);
}

// File: contracts/UseBondMaker.sol





abstract contract UseBondMaker {
    BondMakerInterface internal immutable _bondMakerContract;

    constructor(address contractAddress) public {
        require(
            contractAddress != address(0),
            "contract should be non-zero address"
        );
        _bondMakerContract = BondMakerInterface(payable(contractAddress));
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



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

// File: contracts/StableCoinInterface.sol





interface StableCoinInterface is IERC20 {
    event LogIsAcceptableSBT(bytes32 indexed bondID, bool isAcceptable);

    event LogMintIDOL(
        bytes32 indexed bondID,
        address indexed owner,
        bytes32 poolID,
        uint256 obtainIDOLAmount,
        uint256 poolIDOLAmount
    );

    event LogBurnIDOL(
        bytes32 indexed bondID, // poolID?
        address indexed owner,
        uint256 burnIDOLAmount,
        uint256 unlockSBTAmount
    );

    event LogReturnLockedPool(
        bytes32 indexed poolID,
        address indexed owner,
        uint64 backIDOLAmount
    );

    event LogLambda(
        bytes32 indexed poolID,
        uint64 settledAverageAuctionPrice,
        uint256 totalSupply,
        uint256 lockedSBTValue
    );

    function getPoolInfo(bytes32 poolID)
        external
        view
        returns (
            uint64 lockedSBTTotal,
            uint64 unlockedSBTTotal,
            uint64 lockedPoolIDOLTotal,
            uint64 burnedIDOLTotal,
            uint64 soldSBTTotalInAuction,
            uint64 paidIDOLTotalInAuction,
            uint64 settledAverageAuctionPrice,
            bool isAllAmountSoldInAuction
        );

    function solidValueTotal() external view returns (uint256 solidValue);

    function isAcceptableSBT(bytes32 bondID) external returns (bool ok);

    function mint(
        bytes32 bondID,
        address recipient,
        uint64 lockAmount
    )
        external
        returns (
            bytes32 poolID,
            uint64 obtainIDOLAmount,
            uint64 poolIDOLAmount
        );

    function burnFrom(address account, uint256 amount) external;

    function unlockSBT(bytes32 bondID, uint64 burnAmount)
        external
        returns (uint64 rewardSBT);

    function startAuctionOnMaturity(bytes32 bondID) external;

    function startAuctionByMarket(bytes32 bondID) external;

    function setSettledAverageAuctionPrice(
        bytes32 bondID,
        uint64 totalPaidIDOL,
        uint64 SBTAmount,
        bool isLast
    ) external;

    function calcSBT2IDOL(uint256 solidBondAmount)
        external
        view
        returns (uint256 IDOLAmount);

    function returnLockedPool(bytes32[] calldata poolIDs)
        external
        returns (uint64 IDOLAmount);

    function returnLockedPoolTo(bytes32[] calldata poolIDs, address account)
        external
        returns (uint64 IDOLAmount);

    function generatePoolID(bytes32 bondID, uint64 count)
        external
        pure
        returns (bytes32 poolID);

    function getCurrentPoolID(bytes32 bondID)
        external
        view
        returns (bytes32 poolID);

    function getLockedPool(address user, bytes32 poolID)
        external
        view
        returns (uint64, uint64);
}

// File: contracts/UseStableCoin.sol





abstract contract UseStableCoin {
    StableCoinInterface internal immutable _IDOLContract;

    constructor(address contractAddress) public {
        require(
            contractAddress != address(0),
            "contract should be non-zero address"
        );
        _IDOLContract = StableCoinInterface(contractAddress);
    }

    function _transferIDOLFrom(
        address from,
        address to,
        uint256 amount
    ) internal {
        _IDOLContract.transferFrom(from, to, amount);
    }

    function _transferIDOL(address to, uint256 amount) internal {
        _IDOLContract.transfer(to, amount);
    }

    function _transferIDOL(
        address to,
        uint256 amount,
        string memory errorMessage
    ) internal {
        require(_IDOLContract.balanceOf(address(this)) >= amount, errorMessage);
        _IDOLContract.transfer(to, amount);
    }
}

// File: contracts/fairswap/LBTExchangeFactoryInterface.sol




interface LBTExchangeFactoryInterface {
    /**
     * @notice Launches new exchange
     * @param bondGroupId ID of bondgroup which target LBT belongs to
     * @param place The place of target bond in the bondGroup
     * @param IDOLAmount Initial liquidity of iDOL
     * @param LBTAmount Initial liquidity of LBT
     * @dev Get strikeprice and maturity from bond maker contract
     **/
    function launchExchange(
        uint256 bondGroupId,
        uint256 place,
        uint256 IDOLAmount,
        uint256 LBTAmount
    ) external returns (address);

    /**
     * @notice Gets exchange address from Address of LBT
     * @param tokenAddress Address of LBT
     **/
    function addressToExchangeLookup(address tokenAddress)
        external
        view
        returns (address exchange);

    /**
     * @notice Gets exchange address from BondID of LBT
     * @param bondID
     **/
    function bondIDToExchangeLookup(bytes32 bondID)
        external
        view
        returns (address exchange);

    /**
     * @dev Initial supply of share token is equal to amount of iDOL
     * @dev If there is no share token, user can reinitialize exchange
     * @param token Address of LBT
     * @param IDOLAmount Amount of idol to be provided
     * @param LBTAmount Amount of LBT to be provided
     **/
    function initializeExchange(
        address token,
        uint256 IDOLAmount,
        uint256 LBTAmount
    ) external;
}

// File: contracts/WrapperInterface.sol


pragma experimental ABIEncoderV2;


interface WrapperInterface {
    event LogRegisterBondAndBondGroup(
        uint256 indexed bondGroupID,
        bytes32[] bondIDs
    );
    event LogIssueIDOL(
        bytes32 indexed bondID,
        address indexed sender,
        bytes32 poolID,
        uint256 amount
    );

    event LogIssueLBT(
        bytes32 indexed bondID,
        address indexed sender,
        uint256 amount
    );

    function registerBondAndBondGroup(bytes[] calldata fnMaps, uint256 maturity)
        external
        returns (bool);

    /**
     * @notice swap (SBT -> LBT)
     * @param solidBondID is a solid bond ID
     * @param liquidBondID is a liquid bond ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function swapSBT2LBT(
        bytes32 solidBondID,
        bytes32 liquidBondID,
        uint256 SBTAmount,
        uint256 timeout,
        bool isLimit
    ) external;

    /**
     * @notice ETH -> LBT & iDOL
     * @param bondGroupID is a bond group ID
     * @return poolID is a pool ID
     * @return liquidBondAmount is LBT amount obtained
     * @return IDOLAmount is iDOL amount obtained
     */
    function issueLBTAndIDOL(uint256 bondGroupID)
        external
        payable
        returns (
            bytes32 poolID,
            uint256 liquidBondAmount,
            uint256 IDOLAmount
        );

    /**
     * @notice ETH -> iDOL
     * @param bondGroupID is a bond group ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function issueIDOLOnly(
        uint256 bondGroupID,
        uint256 timeout,
        bool isLimit
    ) external payable;

    /**
     * @notice ETH -> LBT
     * @param bondGroupID is a bond group ID
     * @param liquidBondID is a liquid bond ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function issueLBTOnly(
        uint256 bondGroupID,
        bytes32 liquidBondID,
        uint256 timeout,
        bool isLimit
    ) external payable;
}

// File: @openzeppelin/contracts/GSN/Context.sol



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

// File: @openzeppelin/contracts/utils/Address.sol


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20MinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: contracts/util/TransferETHInterface.sol




interface TransferETHInterface {
    receive() external payable;

    event LogTransferETH(
        address indexed from,
        address indexed to,
        uint256 value
    );
}

// File: contracts/bondToken/BondTokenInterface.sol






interface BondTokenInterface is TransferETHInterface, IERC20 {
    event LogExpire(
        uint128 rateNumerator,
        uint128 rateDenominator,
        bool firstTime
    );

    function mint(address account, uint256 amount)
        external
        returns (bool success);

    function expire(uint128 rateNumerator, uint128 rateDenominator)
        external
        returns (bool firstTime);

    function burn(uint256 amount) external returns (bool success);

    function burnAll() external returns (uint256 amount);

    function isMinter(address account) external view returns (bool minter);

    function getRate()
        external
        view
        returns (uint128 rateNumerator, uint128 rateDenominator);
}

// File: contracts/fairswap/Libraries/Enums.sol



enum Token {TOKEN0, TOKEN1}

// FLEX_0_1 => Swap TOKEN0 to TOKEN1, slippage is tolerate to 5%
// FLEX_1_0 => Swap TOKEN1 to TOKEN0, slippage is tolerate to 5%
// STRICT_0_1 => Swap TOKEN0 to TOKEN1, slippage is limited in 0.1%
// STRICT_1_0 => Swap TOKEN1 to TOKEN0, slippage is limited in 0.1%
enum OrderType {FLEX_0_1, FLEX_1_0, STRICT_0_1, STRICT_1_0}


library TokenLibrary {
    function another(Token self) internal pure returns (Token) {
        if (self == Token.TOKEN0) {
            return Token.TOKEN1;
        } else {
            return Token.TOKEN0;
        }
    }
}


library OrderTypeLibrary {
    function inToken(OrderType self) internal pure returns (Token) {
        if (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1) {
            return Token.TOKEN0;
        } else {
            return Token.TOKEN1;
        }
    }

    function isFlex(OrderType self) internal pure returns (bool) {
        return self == OrderType.FLEX_0_1 || self == OrderType.FLEX_1_0;
    }

    function isStrict(OrderType self) internal pure returns (bool) {
        return !isFlex(self);
    }

    function next(OrderType self) internal pure returns (OrderType) {
        return OrderType((uint256(self) + 1) % 4);
    }

    function isBuy(OrderType self) internal pure returns (bool) {
        return (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1);
    }
}

// File: contracts/fairswap/BoxExchangeInterface.sol


interface BoxExchangeInterface {
    event AcceptOrders(
        address indexed recipient,
        bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
        uint32 indexed boxNumber,
        bool isLimit, // if true, this order is STRICT order
        uint256 tokenIn
    );

    event MoveLiquidity(
        address indexed liquidityProvider,
        bool indexed isAdd, // if true, this order is addtion of liquidity
        uint256 movedToken0Amount,
        uint256 movedToken1Amount,
        uint256 sharesMoved // Amount of share that is minted or burned
    );

    event Execution(
        bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
        uint32 indexed boxNumber,
        address indexed recipient,
        uint256 orderAmount, // Amount of token that is transferred when this order is added
        uint256 refundAmount, // In the same token as orderAmount
        uint256 outAmount // In the other token than orderAmount
    );

    event UpdateReserve(uint128 reserve0, uint128 reserve1, uint256 totalShare);

    event PayMarketFee(uint256 amount0, uint256 amount1);

    event ExecutionSummary(
        uint32 indexed boxNumber,
        uint8 partiallyRefundOrderType,
        uint256 rate,
        uint256 partiallyRefundRate,
        uint256 totalInAmountFLEX_0_1,
        uint256 totalInAmountFLEX_1_0,
        uint256 totalInAmountSTRICT_0_1,
        uint256 totalInAmountSTRICT_1_0
    );

    function marketFeePool0() external view returns (uint128);

    function marketFeePool1() external view returns (uint128);

    /**
     * @notice Shows how many boxes and orders exist before the specific order
     * @dev If this order does not exist, return (false, 0, 0)
     * @dev If this order is already executed, return (true, 0, 0)
     * @param recipient Recipient of this order
     * @param boxNumber Box ID where the order exists
     * @param isExecuted If true, the order is already executed
     * @param boxCount Counter of boxes before this order. If current executing box number is the same as boxNumber, return 1 (i.e. indexing starts from 1)
     * @param orderCount Counter of orders before this order. If this order is on n-th top of the queue, return n (i.e. indexing starts from 1)
     **/
    function whenToExecute(
        address recipient,
        uint256 boxNumber,
        bool isBuy,
        bool isLimit
    )
        external
        view
        returns (
            bool isExecuted,
            uint256 boxCount,
            uint256 orderCount
        );

    /**
     * @notice Returns summary of current exchange status
     * @param boxNumber Current open box ID
     * @param _reserve0 Current reserve of TOKEN0
     * @param _reserve1 Current reserve of TOKEN1
     * @param totalShare Total Supply of share token
     * @param latestSpreadRate Spread Rate in latest OrderBox
     * @param token0PerShareE18 Amount of TOKEN0 per 1 share token and has 18 decimal
     * @param token1PerShareE18 Amount of TOKEN1 per 1 share token and has 18 decimal
     **/
    function getExchangeData()
        external
        view
        returns (
            uint256 boxNumber,
            uint256 _reserve0,
            uint256 _reserve1,
            uint256 totalShare,
            uint256 latestSpreadRate,
            uint256 token0PerShareE18,
            uint256 token1PerShareE18
        );

    /**
     * @notice Gets summary of Current box information (Total order amount of each OrderTypes)
     * @param executionStatusNumber Status of execution of this box
     * @param boxNumber ID of target box.
     **/
    function getBoxSummary(uint256 boxNumber)
        external
        view
        returns (
            uint256 executionStatusNumber,
            uint256 flexToken0InAmount,
            uint256 strictToken0InAmount,
            uint256 flexToken1InAmount,
            uint256 strictToken1InAmount
        );

    /**
     * @notice Gets amount of order in current open box
     * @param account Target Address
     * @param orderType OrderType of target order
     * @return Amount of target order
     **/
    function getOrderAmount(address account, OrderType orderType)
        external
        view
        returns (uint256);

    /**
     * @param IDOLAmount Amount of initial liquidity of iDOL to be provided
     * @param settlementTokenAmount Amount of initial liquidity of the other token to be provided
     * @param initialShare Initial amount of share token
     **/
    function initializeExchange(
        uint256 IDOLAmount,
        uint256 settlementTokenAmount,
        uint256 initialShare
    ) external;

    /**
     * @param timeout Revert if nextBoxNumber exceeds `timeout`
     * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
     * @param IDOLAmount Amount of token that should be approved before executing this function
     * @param isLimit Whether the order restricts a large slippage
     * @dev if isLimit is true and reserve0/reserve1 * 1.001 >  `rate`, the order will be executed, otherwise token will be refunded
     * @dev if isLimit is false and reserve0/reserve1 * 1.05 > `rate`, the order will be executed, otherwise token will be refunded
     **/
    function orderBaseToSettlement(
        uint256 timeout,
        address recipient,
        uint256 IDOLAmount,
        bool isLimit
    ) external;

    /**
     * @param timeout Revert if nextBoxNumber exceeds `timeout`
     * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
     * @param settlementTokenAmount Amount of token that should be approved before executing this function
     * @param isLimit Whether the order restricts a large slippage
     * @dev if isLimit is true and reserve0/reserve1 * 0.999 > `rate`, the order will be executed, otherwise token will be refunded
     * @dev if isLimit is false and reserve0/reserve1 * 0.95 > `rate`, the order will be executed, otherwise token will be refunded
     **/
    function orderSettlementToBase(
        uint256 timeout,
        address recipient,
        uint256 settlementTokenAmount,
        bool isLimit
    ) external;

    /**
     * @notice LP provides liquidity and receives share token
     * @param timeout Revert if nextBoxNumber exceeds `timeout`
     * @param IDOLAmount Amount of iDOL to be provided. The amount of the other token required is calculated based on this amount
     * @param minShares Minimum amount of share token LP will receive. If amount of share token is less than `minShares`, revert the transaction
     **/
    function addLiquidity(
        uint256 timeout,
        uint256 IDOLAmount,
        uint256 settlementTokenAmount,
        uint256 minShares
    ) external;

    /**
     * @notice LP burns share token and receives iDOL and the other token
     * @param timeout Revert if nextBoxNumber exceeds `timeout`
     * @param minBaseTokens Minimum amount of iDOL LP will receive. If amount of iDOL is less than `minBaseTokens`, revert the transaction
     * @param minSettlementTokens Minimum amount of the other token LP will get. If amount is less than `minSettlementTokens`, revert the transaction
     * @param sharesBurned Amount of share token to be burned
     **/
    function removeLiquidity(
        uint256 timeout,
        uint256 minBaseTokens,
        uint256 minSettlementTokens,
        uint256 sharesBurned
    ) external;

    /**
     * @notice Executes orders that are unexecuted
     * @param maxOrderNum Max number of orders to be executed
     **/
    function executeUnexecutedBox(uint8 maxOrderNum) external;

    function sendMarketFeeToLien() external;
}

// File: contracts/Wrapper.sol

// solium-disable security/no-low-level-calls

contract Wrapper is
    DeployerRole,
    UseSafeMath,
    UseOracle,
    UseBondMaker,
    UseStableCoin,
    WrapperInterface
{
    LBTExchangeFactoryInterface internal _exchangeLBTAndIDOLFactoryContract;

    modifier isNotEmptyExchangeInstance() {
        require(
            address(_exchangeLBTAndIDOLFactoryContract) != address(0),
            "the exchange contract is not set"
        );
        _;
    }

    constructor(
        address oracleAddress,
        address bondMakerAddress,
        address IDOLAddress,
        address exchangeLBTAndIDOLFactoryAddress
    )
        public
        UseOracle(oracleAddress)
        UseBondMaker(bondMakerAddress)
        UseStableCoin(IDOLAddress)
    {
        _setExchangeLBTAndIDOLFactory(exchangeLBTAndIDOLFactoryAddress);
    }

    function setExchangeLBTAndIDOLFactory(address contractAddress)
        public
        onlyDeployer
    {
        require(
            address(_exchangeLBTAndIDOLFactoryContract) == address(0),
            "contract has already given"
        );
        require(
            contractAddress != address(0),
            "contract should be non-zero address"
        );
        _setExchangeLBTAndIDOLFactory(contractAddress);
    }

    function _setExchangeLBTAndIDOLFactory(address contractAddress) internal {
        _exchangeLBTAndIDOLFactoryContract = LBTExchangeFactoryInterface(
            contractAddress
        );
    }

    function exchangeLBTAndIDOLFactoryAddress() public view returns (address) {
        return address(_exchangeLBTAndIDOLFactoryContract);
    }

    function registerBondAndBondGroup(bytes[] memory fnMaps, uint256 maturity)
        public
        override
        returns (bool)
    {
        bytes32[] memory bondIDs = new bytes32[](fnMaps.length);
        for (uint256 j = 0; j < fnMaps.length; j++) {
            bytes32 bondID = _bondMakerContract.generateBondID(
                maturity,
                fnMaps[j]
            );
            (address bondAddress, , , ) = _bondMakerContract.getBond(bondID);
            if (bondAddress == address(0)) {
                (bytes32 returnedBondID, , , ) = _bondMakerContract
                    .registerNewBond(maturity, fnMaps[j]);
                require(
                    returnedBondID == bondID,
                    "system error: bondID was not generated as expected"
                );
            }
            bondIDs[j] = bondID;
        }

        uint256 bondGroupID = _bondMakerContract.registerNewBondGroup(
            bondIDs,
            maturity
        );
        emit LogRegisterBondAndBondGroup(bondGroupID, bondIDs);
    }

    /**
     * @param solidBondID is a solid bond ID
     * @param SBTAmount is solid bond token amount
     * @return poolID is a pool ID
     * @return IDOLAmount is iDOL amount obtained
     */
    function _swapSBT2IDOL(
        bytes32 solidBondID,
        address SBTAddress,
        uint256 SBTAmount
    ) internal returns (bytes32 poolID, uint256 IDOLAmount) {
        // 1. approve
        ERC20(SBTAddress).approve(address(_IDOLContract), SBTAmount);

        // 2. mint (SBT -> iDOL)
        (poolID, IDOLAmount, ) = _IDOLContract.mint(
            solidBondID,
            msg.sender,
            SBTAmount.toUint64()
        );

        emit LogIssueIDOL(solidBondID, msg.sender, poolID, IDOLAmount);
        return (poolID, IDOLAmount);
    }

    /**
     * @notice swap (LBT -> iDOL)
     * @param LBTAddress is liquid bond token contract address
     * @param LBTAmount is liquid bond amount
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function _swapLBT2IDOL(
        address LBTAddress,
        uint256 LBTAmount,
        uint256 timeout,
        bool isLimit
    ) internal isNotEmptyExchangeInstance {
        address _boxExchangeAddress = _exchangeLBTAndIDOLFactoryContract
            .addressToExchangeLookup(LBTAddress);
        // 1. approve
        ERC20(LBTAddress).approve(_boxExchangeAddress, LBTAmount);

        // 2. order(exchange)
        BoxExchangeInterface exchange = BoxExchangeInterface(
            _boxExchangeAddress
        );
        exchange.orderSettlementToBase(timeout, msg.sender, LBTAmount, isLimit);
    }

    /**
     * @notice swap (iDOL -> LBT)
     * @param LBTAddress is liquid bond token contract address
     * @param IDOLAmount is iDOL amount
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function _swapIDOL2LBT(
        address LBTAddress,
        uint256 IDOLAmount,
        uint256 timeout,
        bool isLimit
    ) internal isNotEmptyExchangeInstance {
        address _boxExchangeAddress = _exchangeLBTAndIDOLFactoryContract
            .addressToExchangeLookup(LBTAddress);

        // 1. approve
        _IDOLContract.transferFrom(msg.sender, address(this), IDOLAmount);
        _IDOLContract.approve(_boxExchangeAddress, IDOLAmount);

        // 2. order(exchange)
        BoxExchangeInterface exchange = BoxExchangeInterface(
            _boxExchangeAddress
        );
        exchange.orderBaseToSettlement(
            timeout,
            msg.sender,
            IDOLAmount,
            isLimit
        );
    }

    /**
     * @notice swap (SBT -> LBT)
     * @param solidBondID is a solid bond ID
     * @param liquidBondID is a liquid bond ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function swapSBT2LBT(
        bytes32 solidBondID,
        bytes32 liquidBondID,
        uint256 SBTAmount,
        uint256 timeout,
        bool isLimit
    ) public override {
        (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
        require(SBTAddress != address(0), "the bond is not registered");

        // uses: SBT
        _usesERC20(SBTAddress, SBTAmount);

        // 1. SBT -> LBT(exchange)
        _swapSBT2LBT(
            solidBondID,
            SBTAddress,
            liquidBondID,
            SBTAmount,
            timeout,
            isLimit
        );
    }

    function _swapSBT2LBT(
        bytes32 solidBondID,
        address SBTAddress,
        bytes32 liquidBondID,
        uint256 SBTAmount,
        uint256 timeout,
        bool isLimit
    ) internal {
        // 1. swap SBT -> IDOL)
        (, uint256 IDOLAmount) = _swapSBT2IDOL(
            solidBondID,
            SBTAddress,
            SBTAmount
        );

        // 2. swap IDOL -> LBT(exchange)
        (address LBTAddress, , , ) = _bondMakerContract.getBond(liquidBondID);
        require(LBTAddress != address(0), "the bond is not registered");

        _swapIDOL2LBT(LBTAddress, IDOLAmount, timeout, isLimit);
    }

    /**
     * @notice find a solid bond in given bond group
     * @param bondGroupID is a bond group ID
     */
    function _findSBTAndLBTBondGroup(uint256 bondGroupID)
        internal
        view
        returns (bytes32 solidBondID, bytes32[] memory liquidBondIDs)
    {
        (bytes32[] memory bondIDs, ) = _bondMakerContract.getBondGroup(
            bondGroupID
        );
        bytes32 solidID = bytes32(0);
        bytes32[] memory liquidIDs = new bytes32[](bondIDs.length - 1);
        uint256 j = 0;
        for (uint256 i = 0; i < bondIDs.length; i++) {
            (, , uint256 solidStrikePrice, ) = _bondMakerContract.getBond(
                bondIDs[i]
            );
            if (solidStrikePrice != 0) {
                // A solid bond is found.
                solidID = bondIDs[i];
            } else {
                liquidIDs[j++] = bondIDs[i];
            }
        }
        return (solidID, liquidIDs);
    }

    function _usesERC20(address erc20Address, uint256 amount) internal {
        ERC20 erc20Contract = ERC20(erc20Address);
        erc20Contract.transferFrom(msg.sender, address(this), amount);
    }

    function _reductionERC20(address erc20Address, uint256 amount) internal {
        ERC20 erc20Contract = ERC20(erc20Address);
        erc20Contract.transfer(msg.sender, amount);
    }

    function _findBondAddressListInBondGroup(uint256 bondGroupID)
        internal
        view
        returns (address[] memory bondAddressList)
    {
        (bytes32[] memory bondIDs, ) = _bondMakerContract.getBondGroup(
            bondGroupID
        );
        address[] memory bondAddreses = new address[](bondIDs.length);
        for (uint256 i = 0; i < bondIDs.length; i++) {
            (address bondTokenAddress, , , ) = _bondMakerContract.getBond(
                bondIDs[i]
            );
            bondAddreses[i] = bondTokenAddress;
        }
        return bondAddreses;
    }

    /**
     * @notice ETH -> LBT & iDOL
     * @param bondGroupID is a bond group ID
     * @return poolID is a pool ID
     * @return IDOLAmount is iDOL amount obtained
     */
    function issueLBTAndIDOL(uint256 bondGroupID)
        public
        override
        payable
        returns (
            bytes32,
            uint256,
            uint256
        )
    {
        (
            bytes32 solidBondID,
            bytes32[] memory liquidBondIDs
        ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
        require(
            solidBondID != bytes32(0),
            "solid bond is not found in given bond group"
        );

        // 1. ETH -> SBT & LBTs
        uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
            bondGroupID
        );

        // 2. SBT -> IDOL
        (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
        (bytes32 poolID, uint256 IDOLAmount) = _swapSBT2IDOL(
            solidBondID,
            SBTAddress,
            bondAmount
        );

        // 3. IDOL reduction.
        //_reductionERC20(address(_IDOLContract), IDOLAmount);

        // 4. LBTs reduction.
        for (uint256 i = 0; i < liquidBondIDs.length; i++) {
            (address liquidAddress, , , ) = _bondMakerContract.getBond(
                liquidBondIDs[i]
            );
            _reductionERC20(liquidAddress, bondAmount);
            LogIssueLBT(liquidBondIDs[i], msg.sender, bondAmount);
        }
        return (poolID, bondAmount, IDOLAmount);
    }

    /**
     * @notice ETH -> iDOL
     * @param bondGroupID is a bond group ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function issueIDOLOnly(
        uint256 bondGroupID,
        uint256 timeout,
        bool isLimit
    ) public override payable {
        // 0. uses: ETH
        (
            bytes32 solidBondID,
            bytes32[] memory liquidBondIDs
        ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
        require(
            solidBondID != bytes32(0),
            "solid bond is not found in given bond group"
        );

        // 1. ETH -> SBT & LBTs
        uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
            bondGroupID
        );

        // 2. SBT -> IDOL
        (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
        _swapSBT2IDOL(solidBondID, SBTAddress, bondAmount);

        // 3. IDOL reduction.
        //_reductionERC20(address(_IDOLContract), IDOLAmount);

        // 4. LBTs -> IDOL(+exchange)
        for (uint256 i = 0; i < liquidBondIDs.length; i++) {
            (address liquidAddress, , , ) = _bondMakerContract.getBond(
                liquidBondIDs[i]
            );
            // LBT -> IDOL(+exchange)
            _swapLBT2IDOL(liquidAddress, bondAmount, timeout, isLimit);
        }
    }

    /**
     * @notice ETH -> LBT
     * @param bondGroupID is a bond group ID
     * @param liquidBondID is a liquid bond ID
     * @param timeout (uniswap)
     * @param isLimit (uniswap)
     */
    function issueLBTOnly(
        uint256 bondGroupID,
        bytes32 liquidBondID,
        uint256 timeout,
        bool isLimit
    ) public override payable {
        (
            bytes32 solidBondID,
            bytes32[] memory liquidBondIDs
        ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
        require(
            solidBondID != bytes32(0),
            "solid bond is not found in given bond group"
        );

        // 1. ETH -> SBT & LBTs
        uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
            bondGroupID
        );

        // 2. SBT -> IDOL
        (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
        (, uint256 IDOLAmount) = _swapSBT2IDOL(
            solidBondID,
            SBTAddress,
            bondAmount
        );

        // 3. IDOL -> LBT(+exchange)
        (address LBTAddress, , , ) = _bondMakerContract.getBond(liquidBondID);
        _swapIDOL2LBT(LBTAddress, IDOLAmount, timeout, isLimit);

        // 4. LBTs reduction
        for (uint256 i = 0; i < liquidBondIDs.length; i++) {
            (address liquidAddress, , , ) = _bondMakerContract.getBond(
                liquidBondIDs[i]
            );
            _reductionERC20(liquidAddress, bondAmount);
            LogIssueLBT(liquidBondIDs[i], msg.sender, bondAmount);
        }
    }
}