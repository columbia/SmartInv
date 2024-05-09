// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.1;

// File: contracts/staking/StakingInterface.sol

interface StakingInterface {
    function stake(address token, uint128 amount) external;

    function withdraw(address token, uint128 amount) external;

    function receiveReward(address token) external returns (uint256 rewards);

    function changeStakeTarget(
        address oldTarget,
        address newTarget,
        uint128 amount
    ) external;

    function getStakingTokenAddress() external view returns (address);

    function getTokenInfo(address token)
        external
        view
        returns (
            uint256 currentTerm,
            uint256 latestTerm,
            uint256 totalRemainingRewards,
            uint256 currentReward,
            uint256 nextTermRewards,
            uint128 currentStaking,
            uint128 nextTermStaking
        );

    function getConfigs() external view returns (uint256 startTimestamp, uint256 termInterval);

    function getStakingDestinations(address account) external view returns (address[] memory);

    function getTermInfo(address token, uint256 term)
        external
        view
        returns (
            uint128 stakeAdd,
            uint128 stakeSum,
            uint256 rewardSum
        );

    function getAccountInfo(address token, address account)
        external
        view
        returns (
            uint256 userTerm,
            uint256 stakeAmount,
            uint128 nextAddedStakeAmount,
            uint256 currentReward,
            uint256 nextLatestTermUserRewards,
            uint128 depositAmount,
            uint128 withdrawableStakingAmount
        );
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

// File: contracts/staking/StakingVote.sol


contract StakingVote {
    using SafeMath for uint256;

    /* ========== STATE VARIABLES ========== */

    address internal _governanceAddress;
    mapping(address => uint256) internal _voteNum;

    /* ========== EVENTS ========== */

    event LogUpdateGovernanceAddress(address newAddress);

    /* ========== CONSTRUCTOR ========== */

    constructor(address governanceAddress) {
        _governanceAddress = governanceAddress;
    }

    /* ========== MODIFIERS ========== */

    modifier isGovernance(address account) {
        require(account == _governanceAddress, "sender must be governance address");
        _;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice `_governanceAddress` can be updated by the current governance address.
     * @dev Executed only once when initially set the governance address
     * as the governance contract does not have the function to call this function.
     */
    function updateGovernanceAddress(address newGovernanceAddress)
        external
        isGovernance(msg.sender)
    {
        _governanceAddress = newGovernanceAddress;

        emit LogUpdateGovernanceAddress(newGovernanceAddress);
    }

    function voteDeposit(address account, uint256 amount) external isGovernance(msg.sender) {
        _updVoteSub(account, amount);
    }

    function voteWithdraw(address account, uint256 amount) external isGovernance(msg.sender) {
        _updVoteAdd(account, amount);
    }

    /* ========== INTERNAL FUNCTIONS ========== */

    function _updVoteAdd(address account, uint256 amount) internal {
        require(_voteNum[account] + amount >= amount, "overflow the amount of votes");
        _voteNum[account] += amount;
    }

    function _updVoteSub(address account, uint256 amount) internal {
        require(_voteNum[account] >= amount, "underflow the amount of votes");
        _voteNum[account] -= amount;
    }

    /* ========== CALL FUNCTIONS ========== */

    function getGovernanceAddress() external view returns (address) {
        return _governanceAddress;
    }

    function getVoteNum(address account) external view returns (uint256) {
        return _voteNum[account];
    }
}

// File: contracts/util/AddressList.sol

library AddressList {
    /**
     * @dev Inserts token address in addressList except for zero address.
     */
    function insert(address[] storage addressList, address token) internal {
        if (token == address(0)) {
            return;
        }

        for (uint256 i = 0; i < addressList.length; i++) {
            if (addressList[i] == address(0)) {
                addressList[i] = token;
                return;
            }
        }

        addressList.push(token);
    }

    /**
     * @dev Removes token address from addressList except for zero address.
     */
    function remove(address[] storage addressList, address token) internal returns (bool success) {
        if (token == address(0)) {
            return true;
        }

        for (uint256 i = 0; i < addressList.length; i++) {
            if (addressList[i] == token) {
                delete addressList[i];
                return true;
            }
        }
    }

    /**
     * @dev Returns the addresses included in addressList except for zero address.
     */
    function get(address[] storage addressList)
        internal
        view
        returns (address[] memory denseAddressList)
    {
        uint256 numOfElements = 0;
        for (uint256 i = 0; i < addressList.length; i++) {
            if (addressList[i] != address(0)) {
                numOfElements++;
            }
        }

        denseAddressList = new address[](numOfElements);
        uint256 j = 0;
        for (uint256 i = 0; i < addressList.length; i++) {
            if (addressList[i] != address(0)) {
                denseAddressList[j] = addressList[i];
                j++;
            }
        }
    }
}

// File: contracts/staking/StakingDestinations.sol


contract StakingDestinations {
    using AddressList for address[];

    /* ========== STATE VARIABLES ========== */

    /**
     * @dev mapping from user address to staking token addresses
     */
    mapping(address => address[]) internal _stakingDestinations;

    /* ========== INTERNAL FUNCTIONS ========== */

    /**
     * @dev Inserts token address in _stakingDestinations[account] except for ETH (= address(0)).
     */
    function _addDestinations(address account, address token) internal {
        return _stakingDestinations[account].insert(token);
    }

    /**
     * @dev Removes token address from _stakingDestinations[account] except for ETH (= address(0)).
     */
    function _removeDestinations(address account, address token) internal returns (bool success) {
        return _stakingDestinations[account].remove(token);
    }

    /**
     * @dev Returns the addresses included in _stakingDestinations[account] except for zero address.
     */
    function _getStakingDestinations(address account) internal view returns (address[] memory) {
        return _stakingDestinations[account].get();
    }
}

// File: contracts/util/TransferETH.sol

contract TransferETH {
    receive() external payable {}

    /**
     * @notice transfer `amount` ETH to the `recipient` account with emitting log
     */
    function _transferETH(
        address payable recipient,
        uint256 amount,
        string memory errorMessage
    ) internal {
        (bool success, ) = recipient.call{value: amount}("");
        require(success, errorMessage);
    }

    function _transferETH(address payable recipient, uint256 amount) internal {
        _transferETH(recipient, amount, "Transfer amount exceeds balance");
    }
}

// File: @openzeppelin/contracts/utils/SafeCast.sol


/**
 * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 *
 * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
 * all math on `uint256` and `int256` and then downcasting.
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
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     *
     * _Available since v3.1._
     */
    function toInt128(int256 value) internal pure returns (int128) {
        require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
        return int128(value);
    }

    /**
     * @dev Returns the downcasted int64 from int256, reverting on
     * overflow (when the input is less than smallest int64 or
     * greater than largest int64).
     *
     * Counterpart to Solidity's `int64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     *
     * _Available since v3.1._
     */
    function toInt64(int256 value) internal pure returns (int64) {
        require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
        return int64(value);
    }

    /**
     * @dev Returns the downcasted int32 from int256, reverting on
     * overflow (when the input is less than smallest int32 or
     * greater than largest int32).
     *
     * Counterpart to Solidity's `int32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     *
     * _Available since v3.1._
     */
    function toInt32(int256 value) internal pure returns (int32) {
        require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
        return int32(value);
    }

    /**
     * @dev Returns the downcasted int16 from int256, reverting on
     * overflow (when the input is less than smallest int16 or
     * greater than largest int16).
     *
     * Counterpart to Solidity's `int16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     *
     * _Available since v3.1._
     */
    function toInt16(int256 value) internal pure returns (int16) {
        require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
        return int16(value);
    }

    /**
     * @dev Returns the downcasted int8 from int256, reverting on
     * overflow (when the input is less than smallest int8 or
     * greater than largest int8).
     *
     * Counterpart to Solidity's `int8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits.
     *
     * _Available since v3.1._
     */
    function toInt8(int256 value) internal pure returns (int8) {
        require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
        return int8(value);
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

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/staking/Staking.sol









contract Staking is
    StakingInterface,
    ReentrancyGuard,
    StakingVote,
    StakingDestinations,
    TransferETH
{
    using SafeMath for uint256;
    using SafeMath for uint128;
    using SafeCast for uint256;
    using SafeERC20 for IERC20;

    /* ========== CONSTANT VARIABLES ========== */

    address internal constant ETH_ADDRESS = address(0);
    uint256 internal constant MAX_TERM = 1000;

    IERC20 internal immutable _stakingToken;
    uint256 internal immutable _startTimestamp; // timestamp of the term 0
    uint256 internal immutable _termInterval; // time interval between terms in second

    /* ========== STATE VARIABLES ========== */

    struct AccountInfo {
        uint128 stakeAmount; // active stake amount of the user at userTerm
        uint128 added; // the added amount of stake which will be merged to stakeAmount at the term+1.
        uint256 userTerm; // the term when the user executed any function last time (all the terms before the term has been already settled)
        uint256 rewards; // the total amount of rewards until userTerm
    }

    /**
     * @dev token => account => data
     */
    mapping(address => mapping(address => AccountInfo)) internal _accountInfo;

    struct TermInfo {
        uint128 stakeAdd; // the total added amount of stake which will be merged to stakeSum at the term+1
        uint128 stakeSum; // the total staking amount at the term
        uint256 rewardSum; // the total amount of rewards at the term
    }

    /**
     * @dev token => term => data
     */
    mapping(address => mapping(uint256 => TermInfo)) internal _termInfo;

    mapping(address => uint256) internal _currentTerm; // (token => term); the current term (all the info prior to this term is fixed)
    mapping(address => uint256) internal _totalRemainingRewards; // (token => amount); total unsettled amount of rewards

    /* ========== EVENTS ========== */

    event RewardAdded(address indexed token, uint256 reward);
    event Staked(address indexed token, address indexed account, uint128 amount);
    event Withdrawn(address indexed token, address indexed account, uint128 amount);
    event RewardPaid(address indexed token, address indexed account, uint256 reward);

    /* ========== CONSTRUCTOR ========== */

    constructor(
        address stakingTokenAddress,
        address governance,
        uint256 startTimestamp,
        uint256 termInterval
    ) StakingVote(governance) {
        require(startTimestamp <= block.timestamp, "startTimestamp should be past time");
        _stakingToken = IERC20(stakingTokenAddress);
        _startTimestamp = startTimestamp;
        _termInterval = termInterval;
    }

    /* ========== MODIFIERS ========== */

    /**
     * @dev Calc total rewards of the account until the current term.
     */
    modifier updateReward(address token, address account) {
        AccountInfo memory accountInfo = _accountInfo[token][account];
        uint256 startTerm = accountInfo.userTerm;
        // When the loop count exceeds MAX_TERM, stop processing in order not to reach to the block gas limit
        for (
            uint256 term = accountInfo.userTerm;
            term < _currentTerm[token] && term < startTerm + MAX_TERM;
            term++
        ) {
            TermInfo memory termInfo = _termInfo[token][term];
            if (termInfo.stakeSum != 0) {
                accountInfo.rewards = accountInfo.rewards.add(
                    accountInfo.stakeAmount.mul(termInfo.rewardSum).div(termInfo.stakeSum)
                ); // `(your stake amount) / (total stake amount) * total rewards` in each term
            }
            accountInfo.stakeAmount = accountInfo.stakeAmount.add(accountInfo.added).toUint128();
            accountInfo.added = 0;
            accountInfo.userTerm = term + 1; // calculated until this term
            if (accountInfo.stakeAmount == 0) {
                accountInfo.userTerm = _currentTerm[token];
                break; // skip unnecessary term
            }
        }
        _accountInfo[token][account] = accountInfo;
        _;
    }

    /**
     * @dev Update the info up to the current term.
     */
    modifier updateTerm(address token) {
        if (_currentTerm[token] < _getLatestTerm()) {
            uint256 currentBalance = (token == ETH_ADDRESS)
                ? address(this).balance
                : IERC20(token).balanceOf(address(this));
            uint256 nextRewardSum = currentBalance.sub(_totalRemainingRewards[token]);

            TermInfo memory currentTermInfo = _termInfo[token][_currentTerm[token]];
            uint128 nextStakeSum = currentTermInfo
                .stakeSum
                .add(currentTermInfo.stakeAdd)
                .toUint128();
            uint256 carriedReward = currentTermInfo.stakeSum == 0 ? currentTermInfo.rewardSum : 0; // if stakeSum is 0, carried forward until someone stakes
            uint256 nextTerm = nextStakeSum == 0 ? _getLatestTerm() : _currentTerm[token] + 1; // if next stakeSum is 0, skip to latest term
            _termInfo[token][nextTerm] = TermInfo({
                stakeAdd: 0,
                stakeSum: nextStakeSum,
                rewardSum: nextRewardSum.add(carriedReward)
            });

            // write total stake amount since (nextTerm + 1) until _getLatestTerm()
            if (nextTerm < _getLatestTerm()) {
                // assert(_termInfo[token][nextTerm].stakeSum != 0 && _termInfo[token][nextTerm].stakeAdd == 0);
                _termInfo[token][_getLatestTerm()] = TermInfo({
                    stakeAdd: 0,
                    stakeSum: nextStakeSum,
                    rewardSum: 0
                });
            }

            _totalRemainingRewards[token] = currentBalance; // total amount of unpaid reward
            _currentTerm[token] = _getLatestTerm();
        }
        _;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice Stake the staking token for the token to be paid as reward.
     */
    function stake(address token, uint128 amount)
        external
        override
        nonReentrant
        updateTerm(token)
        updateReward(token, msg.sender)
    {
        if (_accountInfo[token][msg.sender].userTerm < _currentTerm[token]) {
            return;
        }

        require(amount != 0, "staking amount should be positive number");

        _updVoteAdd(msg.sender, amount);
        _stake(msg.sender, token, amount);
        _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
    }

    /**
     * @notice Withdraw the staking token for the token to be paid as reward.
     */
    function withdraw(address token, uint128 amount)
        external
        override
        nonReentrant
        updateTerm(token)
        updateReward(token, msg.sender)
    {
        if (_accountInfo[token][msg.sender].userTerm < _currentTerm[token]) {
            return;
        }

        require(amount != 0, "withdrawing amount should be positive number");

        _updVoteSub(msg.sender, amount);
        _withdraw(msg.sender, token, amount);
        _stakingToken.safeTransfer(msg.sender, amount);
    }

    /**
     * @notice Receive the reward for your staking in the token.
     */
    function receiveReward(address token)
        external
        override
        nonReentrant
        updateTerm(token)
        updateReward(token, msg.sender)
        returns (uint256 rewards)
    {
        rewards = _accountInfo[token][msg.sender].rewards;
        if (rewards != 0) {
            _totalRemainingRewards[token] = _totalRemainingRewards[token].sub(rewards); // subtract the total unpaid reward
            _accountInfo[token][msg.sender].rewards = 0;
            if (token == ETH_ADDRESS) {
                _transferETH(msg.sender, rewards);
            } else {
                IERC20(token).safeTransfer(msg.sender, rewards);
            }
            emit RewardPaid(token, msg.sender, rewards);
        }
    }

    function changeStakeTarget(
        address oldTarget,
        address newTarget,
        uint128 amount
    )
        external
        override
        nonReentrant
        updateTerm(oldTarget)
        updateReward(oldTarget, msg.sender)
        updateTerm(newTarget)
        updateReward(newTarget, msg.sender)
    {
        if (
            _accountInfo[oldTarget][msg.sender].userTerm < _currentTerm[oldTarget] ||
            _accountInfo[newTarget][msg.sender].userTerm < _currentTerm[newTarget]
        ) {
            return;
        }

        require(amount != 0, "transfering amount should be positive number");

        _withdraw(msg.sender, oldTarget, amount);
        _stake(msg.sender, newTarget, amount);
    }

    /* ========== INTERNAL FUNCTIONS ========== */

    function _stake(
        address account,
        address token,
        uint128 amount
    ) internal {
        AccountInfo memory accountInfo = _accountInfo[token][account];
        if (accountInfo.stakeAmount == 0 && accountInfo.added == 0) {
            _addDestinations(account, token);
        }

        _accountInfo[token][account].added = accountInfo.added.add(amount).toUint128(); // added when the term is shifted (the user)

        uint256 term = _currentTerm[token];
        _termInfo[token][term].stakeAdd = _termInfo[token][term].stakeAdd.add(amount).toUint128(); // added when the term is shifted (global)

        emit Staked(token, account, amount);
    }

    function _withdraw(
        address account,
        address token,
        uint128 amount
    ) internal {
        AccountInfo memory accountInfo = _accountInfo[token][account];
        require(
            accountInfo.stakeAmount.add(accountInfo.added) >= amount,
            "exceed withdrawable amount"
        );

        if (accountInfo.stakeAmount + accountInfo.added == amount) {
            _removeDestinations(account, token);
        }

        uint256 currentTerm = _currentTerm[token];
        TermInfo memory termInfo = _termInfo[token][currentTerm];
        if (accountInfo.added > amount) {
            accountInfo.added -= amount;
            termInfo.stakeAdd -= amount;
        } else {
            termInfo.stakeSum = termInfo.stakeSum.sub(amount - accountInfo.added).toUint128();
            termInfo.stakeAdd = termInfo.stakeAdd.sub(accountInfo.added).toUint128();
            accountInfo.stakeAmount = accountInfo
                .stakeAmount
                .sub(amount - accountInfo.added)
                .toUint128();
            accountInfo.added = 0;
        }

        _accountInfo[token][account] = accountInfo;
        _termInfo[token][currentTerm] = termInfo;

        emit Withdrawn(token, account, amount);
    }

    function _getNextTermReward(address token) internal view returns (uint256 rewards) {
        // as the term at current+1 has not been settled
        uint256 currentBalance = (token == ETH_ADDRESS)
            ? address(this).balance
            : IERC20(token).balanceOf(address(this));
        return
            (currentBalance > _totalRemainingRewards[token])
                ? currentBalance - _totalRemainingRewards[token]
                : 0;
    }

    function _getLatestTerm() internal view returns (uint256) {
        return (block.timestamp - _startTimestamp) / _termInterval;
    }

    /* ========== CALL FUNCTIONS ========== */

    /**
     * @return stakingTokenAddress is the token locked for staking
     */
    function getStakingTokenAddress() external view override returns (address stakingTokenAddress) {
        return address(_stakingToken);
    }

    /**
     * @return startTimestamp is the time when this contract was deployed
     * @return termInterval is the duration of a term
     */
    function getConfigs()
        external
        view
        override
        returns (uint256 startTimestamp, uint256 termInterval)
    {
        startTimestamp = _startTimestamp;
        termInterval = _termInterval;
    }

    /**
     * @return the ERC20 token addresses in staking
     */
    function getStakingDestinations(address account)
        external
        view
        override
        returns (address[] memory)
    {
        return _getStakingDestinations(account);
    }

    /**
     * @param token is the token address to stake for
     * @return currentTerm is the current latest term
     * @return latestTerm is the potential latest term
     * @return totalRemainingRewards is the as-of remaining rewards
     * @return currentReward is the total rewards at the current term
     * @return nextTermRewards is the as-of total rewards to be paid at the next term
     * @return currentStaking is the total active staking amount
     * @return nextTermStaking is the total staking amount
     */
    function getTokenInfo(address token)
        external
        view
        override
        returns (
            uint256 currentTerm,
            uint256 latestTerm,
            uint256 totalRemainingRewards,
            uint256 currentReward,
            uint256 nextTermRewards,
            uint128 currentStaking,
            uint128 nextTermStaking
        )
    {
        currentTerm = _currentTerm[token];
        latestTerm = _getLatestTerm();
        totalRemainingRewards = _totalRemainingRewards[token];
        currentReward = _termInfo[token][currentTerm].rewardSum;
        nextTermRewards = _getNextTermReward(token);
        TermInfo memory termInfo = _termInfo[token][_currentTerm[token]];
        currentStaking = termInfo.stakeSum;
        nextTermStaking = termInfo.stakeSum.add(termInfo.stakeAdd).toUint128();
    }

    /**
     * @notice Returns _termInfo[token][term].
     */
    function getTermInfo(address token, uint256 term)
        external
        view
        override
        returns (
            uint128 stakeAdd,
            uint128 stakeSum,
            uint256 rewardSum
        )
    {
        TermInfo memory termInfo = _termInfo[token][term];
        stakeAdd = termInfo.stakeAdd;
        stakeSum = termInfo.stakeSum;
        if (term == _currentTerm[token] + 1) {
            rewardSum = _getNextTermReward(token);
        } else {
            rewardSum = termInfo.rewardSum;
        }
    }

    /**
     * @return userTerm is the latest term the user has updated to
     * @return stakeAmount is the latest amount of staking from the user has updated to
     * @return nextAddedStakeAmount is the next amount of adding to stake from the user has updated to
     * @return currentReward is the latest reward getting by the user has updated to
     * @return nextLatestTermUserRewards is the as-of user rewards to be paid at the next term
     * @return depositAmount is the staking amount
     * @return withdrawableStakingAmount is the withdrawable staking amount
     */
    function getAccountInfo(address token, address account)
        external
        view
        override
        returns (
            uint256 userTerm,
            uint256 stakeAmount,
            uint128 nextAddedStakeAmount,
            uint256 currentReward,
            uint256 nextLatestTermUserRewards,
            uint128 depositAmount,
            uint128 withdrawableStakingAmount
        )
    {
        AccountInfo memory accountInfo = _accountInfo[token][account];
        userTerm = accountInfo.userTerm;
        stakeAmount = accountInfo.stakeAmount;
        nextAddedStakeAmount = accountInfo.added;
        currentReward = accountInfo.rewards;
        uint256 currentTerm = _currentTerm[token];
        TermInfo memory termInfo = _termInfo[token][currentTerm];
        uint256 nextLatestTermRewards = _getNextTermReward(token);
        nextLatestTermUserRewards = termInfo.stakeSum.add(termInfo.stakeAdd) == 0
            ? 0
            : nextLatestTermRewards.mul(accountInfo.stakeAmount.add(accountInfo.added)) /
                (termInfo.stakeSum + termInfo.stakeAdd);
        depositAmount = accountInfo.stakeAmount.add(accountInfo.added).toUint128();
        uint128 availableForVoting = _voteNum[account].toUint128();
        withdrawableStakingAmount = depositAmount < availableForVoting
            ? depositAmount
            : availableForVoting;
    }
}