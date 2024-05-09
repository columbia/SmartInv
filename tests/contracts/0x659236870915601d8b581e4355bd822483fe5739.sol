// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;


// 
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

// 
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

// 
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

// 
struct AttoDecimal {
    uint256 mantissa;
}

library AttoDecimalLib {
    using SafeMath for uint256;

    uint256 internal constant BASE = 10;
    uint256 internal constant EXPONENTIATION = 18;
    uint256 internal constant ONE_MANTISSA = BASE**EXPONENTIATION;

    function convert(uint256 integer) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: integer.mul(ONE_MANTISSA)});
    }

    function add(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mantissa.add(b.mantissa)});
    }

    function sub(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mantissa.sub(b.mantissa)});
    }

    function mul(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mantissa.mul(b)});
    }

    function div(uint256 a, uint256 b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mul(ONE_MANTISSA).div(b)});
    }

    function div(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mantissa.div(b)});
    }

    function div(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
        return AttoDecimal({mantissa: a.mantissa.mul(ONE_MANTISSA).div(b.mantissa)});
    }

    function floor(AttoDecimal memory a) internal pure returns (uint256) {
        return a.mantissa.div(ONE_MANTISSA);
    }

    function lte(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (bool) {
        return a.mantissa <= b.mantissa;
    }
}

// 
abstract contract Owned {
    address public nominatedOwner;
    address public owner;

    event OwnerChanged(address oldOwner, address newOwner);
    event OwnerNominated(address newOwner);

    constructor(address _owner) internal {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        owner = nominatedOwner;
        nominatedOwner = address(0);
        emit OwnerChanged(owner, nominatedOwner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner may perform this action");
        _;
    }
}

// 
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
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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

// 
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

// 
contract TokensStorage {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 private _rewardPool;
    uint256 private _rewardSupply;
    uint256 private _totalSupply;
    IERC20 private _rewardsToken;
    IERC20 private _stakingToken;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _claimed;
    mapping(address => uint256) private _rewards;

    function rewardPool() public view returns (uint256) {
        return _rewardPool;
    }

    function rewardSupply() public view returns (uint256) {
        return _rewardSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function rewardsToken() public view returns (IERC20) {
        return _rewardsToken;
    }

    function stakingToken() public view returns (IERC20) {
        return _stakingToken;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function claimedOf(address account) public view returns (uint256) {
        return _claimed[account];
    }

    function rewardOf(address account) public view returns (uint256) {
        return _rewards[account];
    }

    constructor(IERC20 rewardsToken_, IERC20 stakingToken_) public {
        _rewardsToken = rewardsToken_;
        _stakingToken = stakingToken_;
    }

    function _onMint(address account, uint256 amount) internal virtual {}
    function _onBurn(address account, uint256 amount) internal virtual {}

    function _stake(address account, uint256 amount) internal {
        _stakingToken.safeTransferFrom(account, address(this), amount);
        _balances[account] = _balances[account].add(amount);
        _totalSupply = _totalSupply.add(amount);
        _onMint(account, amount);
    }

    function _unstake(address account, uint256 amount) internal {
        _stakingToken.safeTransfer(account, amount);
        _balances[account] = _balances[account].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        _onBurn(account, amount);
    }

    function _increaseRewardPool(address owner, uint256 amount) internal {
        _rewardsToken.safeTransferFrom(owner, address(this), amount);
        _rewardSupply = _rewardSupply.add(amount);
        _rewardPool = _rewardPool.add(amount);
    }

    function _reduceRewardPool(address owner, uint256 amount) internal {
        _rewardsToken.safeTransfer(owner, amount);
        _rewardSupply = _rewardSupply.sub(amount);
        _rewardPool = _rewardPool.sub(amount);
    }

    function _addReward(address account, uint256 amount) internal {
        _rewards[account] = _rewards[account].add(amount);
        _rewardPool = _rewardPool.sub(amount);
    }

    function _withdraw(address account, uint256 amount) internal {
        _rewardsToken.safeTransfer(account, amount);
        _claimed[account] = _claimed[account].sub(amount);
    }

    function _claim(address account, uint256 amount) internal {
        _rewards[account] = _rewards[account].sub(amount);
        _rewardSupply = _rewardSupply.sub(amount);
        _claimed[account] = _claimed[account].add(amount);
    }

    function _transferBalance(
        address from,
        address to,
        uint256 amount
    ) internal {
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
    }
}

// 
contract UniV2Staking is Owned, TokensStorage {
    using SafeMath for uint256;
    using AttoDecimalLib for AttoDecimal;

    function getBlockNumber() internal virtual view returns (uint256) {
        return block.number;
    }

    function getTimestamp() internal virtual view returns (uint256) {
        return block.timestamp;
    }

    uint256 public constant REWARD_UNLOCKING_TIME = 8 days;
    uint256 public constant SECONDS_PER_BLOCK = 15;
    uint256 public constant BLOCKS_PER_DAY = 1 days / SECONDS_PER_BLOCK;
    uint256 public constant MAX_DISTRIBUTION_DURATION = 90 days * BLOCKS_PER_DAY;

    mapping(address => uint256) public rewardUnlockingTime;

    uint256 private _lastUpdateBlockNumber;
    uint256 private _perBlockReward;
    uint256 private _blockNumberOfDistributionEnding;
    AttoDecimal private _rewardPerToken;
    mapping(address => AttoDecimal) private _paidRates;

    function lastUpdateBlockNumber() public view returns (uint256) {
        return _lastUpdateBlockNumber;
    }

    function perBlockReward() public view returns (uint256) {
        return _perBlockReward;
    }

    function blockNumberOfDistributionEnding() public view returns (uint256) {
        return _blockNumberOfDistributionEnding;
    }

    function getRewardPerToken() internal view returns (AttoDecimal memory) {
        uint256 lastRewardBlockNumber = Math.min(getBlockNumber(), _blockNumberOfDistributionEnding);
        if (lastRewardBlockNumber <= _lastUpdateBlockNumber) return _rewardPerToken;
        return _getRewardPerToken(lastRewardBlockNumber);
    }

    function _getRewardPerToken(uint256 forBlockNumber) internal view returns (AttoDecimal memory) {
        uint256 totalSupply_ = totalSupply();
        if (totalSupply_ == 0) return AttoDecimalLib.convert(0);
        uint256 totalReward = forBlockNumber.sub(_lastUpdateBlockNumber).mul(_perBlockReward);
        AttoDecimal memory newRewardPerToken = AttoDecimalLib.div(totalReward, totalSupply_);
        return _rewardPerToken.add(newRewardPerToken);
    }

    function rewardPerToken()
        external
        view
        returns (
            uint256 mantissa,
            uint256 base,
            uint256 exponentiation
        )
    {
        return (getRewardPerToken().mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
    }

    function paidRateOf(address account)
        external
        view
        returns (
            uint256 mantissa,
            uint256 base,
            uint256 exponentiation
        )
    {
        return (_paidRates[account].mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
    }

    function earnedOf(address account) public view returns (uint256) {
        AttoDecimal memory rewardPerToken_ = getRewardPerToken();
        if (rewardPerToken_.lte(_paidRates[account])) return 0;
        uint256 balance = balanceOf(account);
        if (balance == 0) return 0;
        AttoDecimal memory ratesDiff = rewardPerToken_.sub(_paidRates[account]);
        return ratesDiff.mul(balance).floor();
    }

    event RewardStrategyChanged(uint256 perBlockReward, uint256 duration);

    constructor(
        IERC20 rewardsToken_,
        IERC20 stakingToken_,
        address owner_
    ) public Owned(owner_) TokensStorage(rewardsToken_, stakingToken_) {}

    function stake(uint256 amount) public onlyPositiveAmount(amount) {
        _lockRewards(msg.sender);
        _stake(msg.sender, amount);
    }

    function unstake(uint256 amount) public onlyPositiveAmount(amount) {
        require(amount <= balanceOf(msg.sender), "Unstaking amount exceeds staked balance");
        _lockRewards(msg.sender);
        _unstake(msg.sender, amount);
    }

    function claim(uint256 amount) public onlyPositiveAmount(amount) {
        _lockRewards(msg.sender);
        require(amount <= rewardOf(msg.sender), "Claiming amount exceeds received rewards");
        rewardUnlockingTime[msg.sender] = getTimestamp().add(REWARD_UNLOCKING_TIME);
        _claim(msg.sender, amount);
    }

    function withdraw(uint256 amount) public onlyPositiveAmount(amount) {
        require(getTimestamp() >= rewardUnlockingTime[msg.sender], "Reward not unlocked yet");
        require(amount <= claimedOf(msg.sender), "Withdrawing amount exceeds claimed balance");
        _withdraw(msg.sender, amount);
    }

    function setRewardStrategy(uint256 perBlockReward_, uint256 duration) public onlyOwner returns (bool succeed) {
        require(duration > 0, "Duration is zero");
        require(duration <= MAX_DISTRIBUTION_DURATION, "Distribution duration too long");
        _lockRates();
        uint256 currentBlockNumber = getBlockNumber();
        uint256 nextDistributionRequiredPool = perBlockReward_.mul(duration);
        uint256 notDistributedReward = _blockNumberOfDistributionEnding <= currentBlockNumber
            ? 0
            : _blockNumberOfDistributionEnding.sub(currentBlockNumber).mul(_perBlockReward);
        if (nextDistributionRequiredPool > notDistributedReward) {
            _increaseRewardPool(owner, nextDistributionRequiredPool.sub(notDistributedReward));
        } else if (nextDistributionRequiredPool < notDistributedReward) {
            _reduceRewardPool(owner, notDistributedReward.sub(nextDistributionRequiredPool));
        }
        _perBlockReward = perBlockReward_;
        _blockNumberOfDistributionEnding = currentBlockNumber.add(duration);
        emit RewardStrategyChanged(perBlockReward_, duration);
        return true;
    }

    function lockRewards() public {
        _lockRewards(msg.sender);
    }

    function _moveStake(
        address from,
        address to,
        uint256 amount
    ) internal {
        _lockRewards(from);
        _lockRewards(to);
        _transferBalance(from, to, amount);
    }

    function _lockRates(uint256 blockNumber) private {
        _rewardPerToken = _getRewardPerToken(blockNumber);
        _lastUpdateBlockNumber = blockNumber;
    }

    function _lockRates() private {
        uint256 currentBlockNumber = getBlockNumber();
        if (_perBlockReward > 0 && currentBlockNumber >= _blockNumberOfDistributionEnding) {
            _lockRates(_blockNumberOfDistributionEnding);
            _perBlockReward = 0;
        }
        _lockRates(currentBlockNumber);
    }

    function _lockRewards(address account) private {
        _lockRates();
        uint256 earned = earnedOf(account);
        if (earned > 0) _addReward(account, earned);
        _paidRates[account] = _rewardPerToken;
    }

    modifier onlyPositiveAmount(uint256 amount) {
        require(amount > 0, "Amount is not positive");
        _;
    }
}

// 
contract UniV2SyntheticToken is UniV2Staking {
    uint256 public decimals;
    string public name;
    string public symbol;
    mapping(address => mapping(address => uint256)) internal _allowances;

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 decimals_,
        IERC20 rewardsToken_,
        IERC20 stakingToken_,
        address owner_
    ) public UniV2Staking(rewardsToken_, stakingToken_, owner_) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    function _onMint(address account, uint256 amount) internal override {
        emit Transfer(address(0), account, amount);
    }

    function _onBurn(address account, uint256 amount) internal override {
        emit Transfer(account, address(0), amount);
    }

    function transfer(address recipient, uint256 amount) external onlyPositiveAmount(amount) returns (bool) {
        require(balanceOf(recipient) >= amount, "Transfer amount exceeds balance");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external onlyPositiveAmount(amount) returns (bool) {
        require(_allowances[sender][recipient] >= amount, "Transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _allowances[sender][recipient] = _allowances[sender][recipient].sub(amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        _moveStake(sender, recipient, amount);
        emit Transfer(sender, recipient, amount);
    }
}