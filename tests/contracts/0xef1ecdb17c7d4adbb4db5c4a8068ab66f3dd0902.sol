// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/math/SafeMath.sol


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

// File: @openzeppelin/contracts/utils/Address.sol


pragma solidity ^0.6.2;

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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol


pragma solidity ^0.6.0;


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

// File: @openzeppelin/contracts/utils/EnumerableSet.sol


pragma solidity ^0.6.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol


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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


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

// File: contracts/ReentrancyGuardPausable.sol


pragma solidity ^0.6.0;


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Reuse openzeppelin's ReentrancyGuard with Pausable feature
 */
contract ReentrancyGuardPausable {
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
    uint256 private constant _ENTERED_OR_PAUSED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrantAndUnpaused() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED_OR_PAUSED, "ReentrancyGuard: reentrant call or paused");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED_OR_PAUSED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    function _pause() internal {
        _status = _ENTERED_OR_PAUSED;
    }

    function _unpause() internal {
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


pragma solidity ^0.6.0;


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
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
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
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

// File: contracts/EqualToken.sol

pragma solidity 0.6.12;


// EqualToken with Governance.
contract EqualToken is ERC20("Equalizer", "EQL"), Ownable {
    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }

    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
        _moveDelegates(_delegates[msg.sender], address(0), _amount);
    }

    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol

    /// @notice A record of each accounts delegate
    mapping (address => address) internal _delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    /* solium-disable-next-line  */
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    /* solium-disable-next-line  */
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

      /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    /**
     * @notice Transfer `amount` tokens from `msg.sender` to `dst`
     * @param dst The address of the destination account
     * @param amount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint256 amount) public override returns (bool) {
        bool success = super.transfer(dst, amount);
        if (success) {
            _moveDelegates(_delegates[msg.sender], _delegates[dst], amount);
        }
        return success;
    }

    /**
     * @notice Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param amount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(address src, address dst, uint256 amount) public override returns (bool) {
        bool success = super.transferFrom(src, dst, amount);
        if (success) {
            _moveDelegates(_delegates[src], _delegates[dst], amount);
        }
        return success;
    }

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegator The address to get delegatee for
     */
    function delegates(address delegator)
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }

   /**
    * @notice Delegate votes from `msg.sender` to `delegatee`
    * @param delegatee The address to delegate votes to
    */
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name())),
                getChainId(),
                address(this)
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                DELEGATION_TYPEHASH,
                delegatee,
                nonce,
                expiry
            )
        );

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                structHash
            )
        );

        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Equal::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "Equal::delegateBySig: invalid nonce");
        require(now <= expiry, "Equal::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account)
        external
        view
        returns (uint256)
    {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber)
        external
        view
        returns (uint256)
    {
        require(blockNumber < block.number, "Equal::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _delegate(address delegator, address delegatee)
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Equal (not scaled);
        _delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.sub(amount);
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.add(amount);
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    )
        internal
    {
        uint32 blockNumber = safe32(block.number, "Equal::_writeCheckpoint: block number exceeds 32 bits");

        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }

        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        /* solium-disable-next-line  */
        assembly { chainId := chainid() }
        return chainId;
    }
}

// File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    // SMARTXXX: function feeTo() external view returns (address);
    // SMARTXXX: function feeToSetter() external view returns (address);
    function feeInfoSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    // SMARTXXX: function setFeeTo(address) external;
    function setFeeInfo(address, uint32, uint32) external;
    // SMARTXXX: function setFeeToSetter(address) external;
    function setFeeInfoSetter(address) external;

    // SMARTXXX: fee info getter
    function getFeeInfo() external view returns (address, uint32, uint32);
}

// File: contracts/EqualBurner.sol

pragma solidity 0.6.12;


contract EqualBurner is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public equal;
    address public weth;
    address public master;
    IUniswapV2Factory public factory;
    bool public noFrontRun = false;

    constructor (address _equal, address _weth, address _master, IUniswapV2Factory _factory) public {
        equal = _equal;
        weth = _weth;
        master = _master;
        factory = _factory;
    }

    function setNoFrontRun(bool _noFrontRun) public onlyOwner {
        noFrontRun = _noFrontRun;
    }

    /*
     * @dev Convert the fee of trading-pair token0/token1 to EQUAL and
     * return the value.  The fee will be locked in the contract forever.
     */
    function burn(
        address _tokenA,
        address _tokenB
    )
        external
        returns (uint256 equalAmount)
    {
        if (noFrontRun) {
            // solium-disable-next-line
            require(msg.sender == tx.origin, "must burn from a user tx");
        }

        require(msg.sender == master, "only master can burn");
        (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);

        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token0, token1));
        uint256 bal = pair.balanceOf(address(this));
        if (bal == 0) {
            return 0;
        }
        pair.transfer(address(pair), bal);
        uint256 amount0;
        uint256 amount1;
        (amount0, amount1) = pair.burn(address(this));
        uint256 wethAmount = 0;
        equalAmount = 0;
        if (token0 == address(equal)) {
            equalAmount = equalAmount.add(amount0);
        } else {
            wethAmount = wethAmount.add(_toWETH(token0, amount0));
        }

        if (token1 == address(equal)) {
            equalAmount = equalAmount.add(amount1);
        } else {
            wethAmount = wethAmount.add(_toWETH(token1, amount1));
        }

        equalAmount = equalAmount.add(_toEQUALFromWETH(wethAmount));
        EqualToken(equal).burn(equalAmount);
    }

    function _toWETH(address token, uint256 amountIn) internal returns (uint256) {
        if (token == weth) {
            IERC20(token).safeTransfer(factory.getPair(weth, address(equal)), amountIn);
            return amountIn;
        }
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token, weth));
        if (address(pair) == address(0)) {
            return 0;
        }
        uint256 reserveIn;
        uint256 reserveOut;
        address token0 = pair.token0();
        {
        (uint reserve0, uint reserve1,) = pair.getReserves();
        (reserveIn, reserveOut) = token0 == token ? (reserve0, reserve1) : (reserve1, reserve0);
        }
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        uint amountOut = numerator / denominator;
        (uint amount0Out, uint amount1Out) = token0 == token ? (uint(0), amountOut) : (amountOut, uint(0));
        IERC20(token).safeTransfer(address(pair), amountIn);
        pair.swap(amount0Out, amount1Out, factory.getPair(weth, address(equal)), new bytes(0));
        return amountOut;
    }

    function _toEQUALFromWETH(uint256 amountIn) internal returns (uint256) {
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(weth, address(equal)));
        (uint reserve0, uint reserve1,) = pair.getReserves();
        address token0 = pair.token0();
        (uint reserveIn, uint reserveOut) = token0 == weth ? (reserve0, reserve1) : (reserve1, reserve0);
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        uint amountOut = numerator / denominator;
        (uint amount0Out, uint amount1Out) = token0 == weth ? (uint(0), amountOut) : (amountOut, uint(0));
        pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
        return amountOut;
    }
}

// File: contracts/uniswapv2/libraries/SafeMath.sol

pragma solidity =0.6.12;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMathUniswap {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/uniswapv2/libraries/UniswapV2Library.sol

pragma solidity >=0.5.0;



library UniswapV2Library {
    using SafeMathUniswap for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'1c879dcd3af04306445addd2c308bd4d26010c7ca84c959c3564d4f6957ab20c' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// File: contracts/Equalizer.sol

pragma solidity 0.6.12;


// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance equal contract once EQUAL is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract Equalizer is ReentrancyGuardPausable, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using SafeERC20 for EqualToken;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of EQUALs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accEqualPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accEqualPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 lastRewardBlock;  // Last block number that EQUALs distribution occurs.
        uint256 lastRewardRound;  // Last adjust round
        uint256 accEqualPerShare; // Accumulated EQUALs per share, times 1e12. See below.
        uint256 allocPointGain;   // Extra gain of the pool.
        mapping (uint256 => uint256) allocPoints; // roundNumber => allocPoint mapping via EQUAL burn
        mapping (address => UserInfo) userInfo; // Info of each user that stakes LP tokens.
    }

    // Allocation adjust round.
    struct AllocAdjustRound {
        uint256 allocPointDecayNumerator;
        uint256 totalAllocPoint;
        uint256 endBlock; // inclusive
    }

    // The EQUAL TOKEN!
    EqualToken public equal;
    // Dev address.
    address public devaddr;
    // EQUAL tokens created per block.
    uint256 public genesisEqualPerBlock;
    // The block number when EQUAL mining starts.
    uint256 public startBlock;
    // The number of blocks per weight adjust ment
    uint256 public allocAdjustBlocks;
    // All rounds of allocation
    AllocAdjustRound[] public rounds;
    // Mapping of trading-pair to pool info.
    mapping (address => mapping (address => PoolInfo)) public poolInfo;
    // The number of blocks per epoch.
    uint256 public blocksInGenesisEpoch;
    // Uniswap factory.
    IUniswapV2Factory public factory;
    address weth;
    // Burner that burns trading fee in the unit of EQUAL.
    EqualBurner burner;
    // Global alloc point decay numerator (denom is 1e12)
    uint256 public allocPointDecayNumerator;
    // Burn equal directly efficiency (denom is 1e12)
    uint256 public burnEqualEfficiency = 1e12;

    event Deposit(address indexed user, address indexed lpToken, uint256 amount);
    event Withdraw(address indexed user, address indexed lpToken, uint256 amount);
    event EmergencyWithdraw(address indexed user, address indexed lpToken, uint256 amount);
    event NewRound(uint256 number, uint256 prevTotalAllocPoint, uint256 endBlock);
    event Burn(address indexed initiator, address indexed lpToken, uint256 amount);

    constructor(
        EqualToken _equal,
        address _devaddr,
        uint256 _genesisEqualPerBlock,
        uint256 _startBlock,
        uint256 _blocksInGenesisEpoch,
        uint256 _allocAdjustBlocks,
        address _weth,
        IUniswapV2Factory _factory
    ) public {
        equal = _equal;
        devaddr = _devaddr;
        genesisEqualPerBlock = _genesisEqualPerBlock;
        startBlock = _startBlock;
        blocksInGenesisEpoch = _blocksInGenesisEpoch;
        allocAdjustBlocks = _allocAdjustBlocks;

        // We allow genesis round to setup alloc by owner.
        rounds.push(AllocAdjustRound({
            allocPointDecayNumerator: 0,
            totalAllocPoint: 0,
            endBlock: _startBlock - 1
        }));
        factory = _factory;
        weth = _weth;
    }

    function _getOrInitPool(address _tokenA, address _tokenB) internal returns (PoolInfo storage) {
        (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
        PoolInfo storage pool = poolInfo[token0][token1];

        if (pool.lpToken == IERC20(0x0)) {
            pool.lpToken = IERC20(factory.getPair(token0, token1));
            require(pool.lpToken != IERC20(0x0), "lp token not exist");
        }
        return pool;
    }

    function _getPool(address _tokenA, address _tokenB) internal view returns (PoolInfo storage) {
        PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
        require(pool.lpToken != IERC20(0x0), "lp token not exist");
        return pool;
    }

    function _getPoolSafe(address _tokenA, address _tokenB) internal view returns (PoolInfo storage) {
        (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
        PoolInfo storage pool = poolInfo[token0][token1];
        return pool;
    }

    function _setPoolGenesisAlloc(
        address _token0,
        address _token1,
        uint256 _allocPoint,
        uint256 _blockNumber
    )
        internal
    {
        require(_blockNumber < startBlock, "cannot change alloc after startBlock");
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);

        rounds[0].totalAllocPoint = rounds[0].totalAllocPoint.sub(pool.allocPoints[0]).add(_allocPoint);
        pool.allocPoints[0] = _allocPoint;
    }

    /****************************************************
     * Owner's public methods
     ****************************************************/
    function setCorePairAllocPointMultiplier(uint256 _m) external onlyOwner {
        PoolInfo storage pool = _getOrInitPool(weth, address(equal));
        pool.allocPointGain = _m;
        // Will be applied to next trade fee calculation.
    }

    function setAllocAdjustBlocks(uint256 _blocks) external onlyOwner {
        allocAdjustBlocks = _blocks;
        // Will be applied to next round.
    }

    function setAllocPointDecayNumerator(uint256 _decay) external onlyOwner {
        require(_decay < 1e12, "decay must < 1.0");
        allocPointDecayNumerator = _decay;
        // Will be applied to next round.
    }

    function setPoolAllocPointGain(address _token0, address _token1, uint256 _gain) external onlyOwner {
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        pool.allocPointGain = _gain;
        // Will be applied to next trade fee calculation.
    }

    // Setup pool allocation for genesis round.
    function setPoolGenesisAlloc(
        address _token0,
        address _token1,
        uint256 _allocPoint) external onlyOwner
    {
        _setPoolGenesisAlloc(_token0, _token1, _allocPoint, block.number);
    }

    // Setup burner that converts the trading fee to EQUAL.
    function setBurner(EqualBurner _burner) external onlyOwner {
        burner = _burner;
    }

    // Setup burn efficiency of equal directly.
    function setBurnEqualEfficiency(uint256 _eff) external onlyOwner {
        burnEqualEfficiency = _eff;
    }

    // Only applies to deposit/withdraw/burn, but not emergency withdraw.
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /*
     * Get the EQUAL block reward according to quasi-fixed-supply block distribution model,
     * where after each epoch, reward per block halves and # of blocks in the epoch doubles.
     */
    function getEqualBlockReward(uint256 _from, uint256 _to) public view returns (uint256) {
        if (_from > _to) {
            return 0;
        }

        uint256 blocksPerEpoch = blocksInGenesisEpoch;
        uint256 epochBegin = startBlock;
        uint256 epochEnd = epochBegin + blocksPerEpoch - 1;
        uint256 rewardPerBlock = genesisEqualPerBlock;
        uint256 totalRewards = 0;
        while (_to >= epochBegin) {
            uint256 left = Math.max(epochBegin, _from);
            uint256 right = Math.min(epochEnd, _to);
            if (right >= left) {
                totalRewards += (right - left + 1) * rewardPerBlock;
            }

            rewardPerBlock = rewardPerBlock / 2;
            blocksPerEpoch = blocksPerEpoch * 2;
            epochBegin = epochEnd + 1;
            epochEnd = epochBegin + blocksPerEpoch - 1;
        }
        return totalRewards;
    }

    /*
     * Get the number of EQUAL reward of the pool with the blocks starting
     * from lastRewardBlock to _blockNumber.  If the number of rounds exceed _maxIter, it will stop
     * and return the corresponding rewards, and block and round visited.
     *
     * If the alloc point of some rounds of the pool is zero, it will automatically apply
     * exponential-moving-average (EMA) algorithm to evaulate the decayed alloc point.
     *
     * A couple of invariants we will maintain
     *
     * - rounds[rounds.length - 2].endBlock < block.Number <= rounds[rounds.length - 1].endBlock
     *   This is achieved by calling _updateRounds() for _updatePool().
     *
     * - rounds[lastRewardRound - 1].endBlock < lastRewardBlock <= rounds[lastRewardRound].endBlock
     *   This is achieved by updating lastRewardBlock and lastRewardRound atomically.
     *
     * - sum(pool.allocPoints[i] of all pools) <= rounds.totalAllocPoint[i] for all i
     *   This is achieved by EMA calculation in _getEqualReward() and _burnEqual().
     */
    function _getEqualReward(
        PoolInfo storage _pool,
        uint256 _maxIter,
        uint256 _blockNumber
    )
        internal
        view
        returns (uint256 equalReward, uint256 lastRewardBlock, uint256 lastRewardRound, bool updatePrevAllocPoint, uint256 prevAllocPoint)
    {
        equalReward = 0;
        lastRewardBlock = _pool.lastRewardBlock;
        lastRewardRound = _pool.lastRewardRound;
        updatePrevAllocPoint = false;
        // No need to set prevAllocPoint

        uint256 startRound = _pool.lastRewardRound;
        // If prevAllocPoint happens to be zero for the startRound, we will use decay * pprevAllocPoint,
        // which is still zero.
        uint256 pprevAllocPoint = 0;
        uint256 roundLen = rounds.length;

        for (uint256 round = startRound; round < roundLen; round++) {
            if (round == 0) {
                continue;
            }

            uint256 endBlock = rounds[round].endBlock;
            if (endBlock > _blockNumber) {
                endBlock = _blockNumber;
            }

            // If no EQUAL is burned in the round, then no EQUAL will be distributed.
            prevAllocPoint = 0;
            updatePrevAllocPoint = false;
            uint256 prevTotalAllocPoint = rounds[round - 1].totalAllocPoint;
            if (prevTotalAllocPoint != 0) {
                if (round <= startRound + 1) {
                    prevAllocPoint = _pool.allocPoints[round - 1];
                } // gas saving.  prevAllocPoint will be zero for  > startRound + 1.

                // If prevAllocPoint is zero, use decayed allocPoint from previous previous round.
                // Otherwise, the decayed allocPoint should be already counted (A1).
                // For users that have not called _updatePool() for a while, to save gas,
                // we allow some alloc points to be zero as long as the prev alloc point of
                // last reward round is correct and stored so that they can be used by
                // the next call of _getEqualReward().
                // This means that the caller MUST update the previous alloc point
                // otherwise assumption A1 will be broken.
                if (prevAllocPoint == 0) {
                    prevAllocPoint = pprevAllocPoint.mul(rounds[round - 1].allocPointDecayNumerator).div(1e12);
                    updatePrevAllocPoint = true;
                }

                uint256 roundReward = getEqualBlockReward(lastRewardBlock + 1, endBlock)
                    .mul(prevAllocPoint)
                    .div(prevTotalAllocPoint);
                equalReward = equalReward.add(roundReward);

                // If round reward is < 1e12, will terminate all calculation and break.
                // Note that round must > startRound to make sure the alloc point of startRound is applied.
                // After startRound + 1, the rest rounds will only have the decayed alloc points.
                // This means that the rest roundReward will <= current roundReward.
                // Since the number is too small, all rewards are discarded to save gas.
                if (roundReward < 1e12 && round >= startRound + 1 && round != roundLen - 1) {
                    lastRewardBlock = _blockNumber;
                    lastRewardRound = roundLen - 1;
                    updatePrevAllocPoint = false;  // set prev alloc of roundLen - 1 as 0
                    break;
                }
            }
            lastRewardBlock = endBlock;
            lastRewardRound = round;
            pprevAllocPoint = prevAllocPoint;

            if (lastRewardBlock == _blockNumber || round.sub(startRound) >= _maxIter) {
                break;
            }
        }
    }

    /*
     * Start a new round for new alloc points.  Will evaluate the totalAllocPoint using EMA.
     */
    function _startNewRound(
        uint256 _prevEndBlock,
        uint256 _blockNumber
    )
        internal
    {
        uint256 roundNumber = rounds.length - 1;
        uint256 prevTotalAllocPoint = rounds[roundNumber].totalAllocPoint;
        uint256 decay = allocPointDecayNumerator;

        AllocAdjustRound memory newRound = AllocAdjustRound({
            allocPointDecayNumerator: decay,
            totalAllocPoint: prevTotalAllocPoint.mul(decay).div(1e12),
            endBlock: Math.max(_prevEndBlock + allocAdjustBlocks, _blockNumber)
        });
        rounds.push(newRound);
        emit NewRound(roundNumber + 1, prevTotalAllocPoint, newRound.endBlock);
    }

    /* Check if a new round is needed to make sure the endBlock of last round >= _blockNumber */
    function _updateRounds(uint256 _blockNumber) internal {
        uint256 roundNumber = rounds.length - 1;
        if (rounds[roundNumber].endBlock < _blockNumber) {
            _startNewRound(rounds[roundNumber].endBlock, _blockNumber);
        }
    }

    /*
     * Convert burned EQUAL to alloc point of the current round.  It will automatically update the
     * pool to make sure the pool's alloc points are up-to-date so that we could correctly evaluate
     * current round alloc point based on EMA.
     */
    function _burnEqual(
        PoolInfo storage _pool,
        uint256 _amount,
        uint256 _blockNumber
    )
        internal
    {
        _updatePool(_pool, 255, _blockNumber);

        // Make sure allocPoint[roundNumber - 1] is valid, i.e., it is evaluated by EMA.
        require(_blockNumber == _pool.lastRewardBlock, "need to updatePool() manually");

        uint256 roundNumber = rounds.length - 1;
        uint256 num = _pool.allocPointGain.add(1e12);

        uint256 allocPoint = _pool.allocPoints[roundNumber];
        if (allocPoint == 0) {
            // First set, need to add decayed alloc point from previous round.
            allocPoint = _pool.allocPoints[roundNumber - 1]
                .mul(rounds[roundNumber].allocPointDecayNumerator).div(1e12);
        }
        _pool.allocPoints[roundNumber] = allocPoint.add(_amount.mul(num).div(1e12));
        rounds[roundNumber].totalAllocPoint = rounds[roundNumber].totalAllocPoint.add(_amount.mul(num).div(1e12));
        emit Burn(msg.sender, address(_pool.lpToken), _amount);
    }

    // View function to see pending EQUALs on frontend.
    function _pendingEqual(
        address _token0,
        address _token1,
        address _user,
        uint256 _maxIter,
        uint256 _blockNumber
    )
        internal
        view
        returns (uint256)
    {
        PoolInfo storage pool = _getPool(_token0, _token1);
        UserInfo storage user = pool.userInfo[_user];

        uint256 accEqualPerShare = pool.accEqualPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (_blockNumber > pool.lastRewardBlock && lpSupply != 0) {
            (uint256 equalReward,,,,) = _getEqualReward(pool, _maxIter, _blockNumber);
            accEqualPerShare = accEqualPerShare.add(equalReward.mul(9e11).div(lpSupply));
        }
        return user.amount.mul(accEqualPerShare).div(1e12).sub(user.rewardDebt);
    }

    function pendingEqual(
        address _token0,
        address _token1,
        address _user,
        uint256 _maxIter
    )
        external
        view
        returns (uint256)
    {
        return _pendingEqual(_token0, _token1, _user, _maxIter, block.number);
    }

    function _updatePool(PoolInfo storage _pool, uint256 _maxIter, uint256 _blockNumber) internal {
        if (_blockNumber <= _pool.lastRewardBlock) {
            return;
        }

        _updateRounds(_blockNumber);

        uint256 equalReward;
        uint256 prevAllocPoint;
        bool updatePrevAllocPoint;
        (
            equalReward,
            _pool.lastRewardBlock,
            _pool.lastRewardRound,
            updatePrevAllocPoint,
            prevAllocPoint
        ) = _getEqualReward(_pool, _maxIter, _blockNumber);
        if (updatePrevAllocPoint) {
            _pool.allocPoints[_pool.lastRewardRound - 1] = prevAllocPoint;
        }

        uint256 lpSupply = _pool.lpToken.balanceOf(address(this));
        if (equalReward == 0 || lpSupply == 0) {
            return;
        }

        equal.mint(devaddr, equalReward.div(10));
        uint256 lpReward = equalReward.sub(equalReward.div(10));
        equal.mint(address(this), lpReward);
        _pool.accEqualPerShare = _pool.accEqualPerShare.add(lpReward.mul(1e12).div(lpSupply));
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(address _token0, address _token1, uint256 _maxIter) public nonReentrantAndUnpaused {
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        _updatePool(pool, _maxIter, block.number);
    }

    // Deposit LP tokens to Equalizer for EQUAL allocation.
    function _deposit(
        address _token0,
        address _token1,
        uint256 _amount,
        address _to,
        bool _burnFee,
        uint256 _blockNumber
    )
        internal
    {
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        UserInfo storage user = pool.userInfo[_to];

        // TODO: Optimize round iterations
        _updatePool(pool, 255, _blockNumber);

        if (_burnFee) {
            uint256 amount = burner.burn(
                _token0,
                _token1
            );
            _burnEqual(pool, amount, _blockNumber);
        }

        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accEqualPerShare).div(1e12).sub(user.rewardDebt);
            if (pending > 0) {
                safeEqualTransfer(_to, pending);
            }
        }

        if (_amount > 0) {
            pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
            user.amount = user.amount.add(_amount);
        }
        user.rewardDebt = user.amount.mul(pool.accEqualPerShare).div(1e12);
        emit Deposit(_to, address(pool.lpToken), _amount);
    }

    // Deposit LP tokens to Equalizer for EQUAL allocation.
    function depositTo(
        address _token0,
        address _token1,
        uint256 _amount,
        address _to,
        bool _burnFee
    )
        public
        nonReentrantAndUnpaused
    {
        _deposit(_token0, _token1, _amount, _to, _burnFee, block.number);
    }

    function deposit(
        address _token0,
        address _token1,
        uint256 _amount,
        bool _burnFee
    )
        public
        nonReentrantAndUnpaused
    {
        _deposit(_token0, _token1, _amount, msg.sender, _burnFee, block.number);
    }

    // Withdraw LP tokens from Master.
    function _withdraw(
        address _token0,
        address _token1,
        uint256 _amount,
        bool _burnFee,
        uint256 _blockNumber
    )
        internal
    {
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        UserInfo storage user = pool.userInfo[msg.sender];
        require(user.amount >= _amount, "withdraw: not good");

        // TODO: Optimize round iterations
        _updatePool(pool, 255, _blockNumber);

        if (_burnFee) {
            uint256 amount = burner.burn(
                _token0,
                _token1
            );
            _burnEqual(pool, amount, _blockNumber);
        }

        uint256 pending = user.amount.mul(pool.accEqualPerShare).div(1e12).sub(user.rewardDebt);
        if (pending > 0) {
            safeEqualTransfer(msg.sender, pending);
        }
        if (_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.safeTransfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount.mul(pool.accEqualPerShare).div(1e12);
        emit Withdraw(msg.sender, address(pool.lpToken), _amount);
    }

    function withdraw(address _token0, address _token1, uint256 _amount, bool _burnFee) public nonReentrantAndUnpaused {
        _withdraw(_token0, _token1, _amount, _burnFee, block.number);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(address _token0, address _token1) public {
        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        UserInfo storage user = pool.userInfo[msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pool.lpToken.safeTransfer(address(msg.sender), amount);
        emit EmergencyWithdraw(msg.sender, address(pool.lpToken), amount);
    }

    // Safe equal transfer function, just in case if rounding error causes pool to not have enough EQUALs.
    function safeEqualTransfer(address _to, uint256 _amount) internal {
        uint256 equalBal = equal.balanceOf(address(this));
        if (_amount > equalBal) {
            equal.transfer(_to, equalBal);
        } else {
            equal.transfer(_to, _amount);
        }
    }

    // Update dev address by the previous dev.
    function dev(address _devaddr) public {
        require(msg.sender == devaddr, "dev: wut?");
        require(_devaddr != address(0x0), "_devaddr cannot be 0x0");
        devaddr = _devaddr;
    }

    /*
     * @dev Convert the tokens of the pair to EQUAL via ETH/EQUAL pair.
    *  Use burned EQUAL as alloc points.
     */
    function _buyBackAndBurn(
        address _tokenA,
        address _tokenB,
        uint256 _blockNumber
    )
        internal
    {
        // Convert to EQUAL via swap.
        uint256 amount = burner.burn(
            _tokenA,
            _tokenB
        );

        // Burn
        PoolInfo storage pool = _getOrInitPool(_tokenA, _tokenB);
        _burnEqual(pool, amount, _blockNumber);
    }

    function buyBackAndBurn(address _tokenA, address _tokenB) external nonReentrantAndUnpaused {
        _buyBackAndBurn(_tokenA, _tokenB, block.number);
    }

    function _burnEqualAsFee(
        address _token0,
        address _token1,
        uint256 _amount,
        uint256 _blockNumber
    )
        internal
    {
        equal.safeTransferFrom(msg.sender, address(this), _amount);
        equal.burn(_amount);

        PoolInfo storage pool = _getOrInitPool(_token0, _token1);
        _burnEqual(pool, _amount.mul(burnEqualEfficiency).div(1e12), _blockNumber);
    }

    function burnEqualAsFee(address _token0, address _token1, uint256 _amount) external nonReentrantAndUnpaused {
        _burnEqualAsFee(_token0, _token1, _amount, block.number);
    }

    function getLastRoundAllocPoint(
        address _token0,
        address _token1
    )
        public
        view
        returns (uint256 prevAllocPoint)
    {
        PoolInfo storage pool = _getPool(_token0, _token1);

        uint256 roundLen = rounds.length;
        uint256 startRound = pool.lastRewardRound;

        if (startRound == 0) {
            startRound = 1;
        }

        prevAllocPoint = 0;
        for (uint256 round = startRound; round < roundLen; round++) {
            if (pool.allocPoints[round - 1] != 0) {
                prevAllocPoint = pool.allocPoints[round - 1];
            } else {
                prevAllocPoint = prevAllocPoint.mul(rounds[round - 1].allocPointDecayNumerator).div(1e12);
            }
        }
    }

    /****************************************************
     * View only external methods (for display purpose)
     ****************************************************/

    function getCurrentRoundAllocPoint(
        address _token0,
        address _token1
    )
        public
        view
        returns (uint256 allocPoint)
    {
        PoolInfo storage pool = _getPool(_token0, _token1);

        uint256 roundLen = rounds.length;
        uint256 startRound = pool.lastRewardRound;

        if (startRound != 0) {
            allocPoint = pool.allocPoints[startRound - 1];
        }
        for (uint256 round = startRound; round < roundLen; round++) {
            if (pool.allocPoints[round] != 0) {
                allocPoint = pool.allocPoints[round];
            } else {
                allocPoint = allocPoint.mul(rounds[round].allocPointDecayNumerator).div(1e12);
            }
        }
    }

    function getRoundLengthAndLastEndBlock() external view returns (
        uint256 length,
        uint256 endBlock
    )
    {
        length = rounds.length;
        endBlock = rounds[length - 1].endBlock;
    }

    function getPoolAndUserInfo(address token0, address token1, address user) external view returns (
        uint256 lastAllocPoint,
        uint256 currentAllocPoint,
        uint256 userInfoAmount,
        uint256 pending,
        uint256 allocPointGain
    )
    {
        PoolInfo storage info = _getPoolSafe(token0, token1);
        if (info.lpToken != IERC20(0x0)) {
            lastAllocPoint = getLastRoundAllocPoint(token0, token1);
            currentAllocPoint = getCurrentRoundAllocPoint(token0, token1);
            userInfoAmount = info.userInfo[user].amount;
            pending = _pendingEqual(token0, token1, user, 255, block.number);
            allocPointGain = info.allocPointGain;
        }
    }

    function getAPY(address token0, address token1) external view returns (uint256) {
        PoolInfo storage pool = _getPoolSafe(token0, token1);
        if (pool.lpToken == IERC20(0x0)) {
            return 0;
        }
        if (token0 == weth || token1 == weth) {
            // token - eth pair
            address token = token0 == weth ? token1 : token0;
            (uint reserve0, uint reserve1) = UniswapV2Library.getReserves(address(factory), token, weth);
            if (reserve0 == 0 || reserve1 == 0) {
                return 0;
            }
            uint256 totalSupply = pool.lpToken.totalSupply() == 0 ? 1 : pool.lpToken.totalSupply();
            // 1 lp token price
            uint256 totalEth = reserve1.mul(2 * 1e18).div(totalSupply);
            return _getTokenAPY(pool, totalEth, token0, token1);
        } else if (factory.getPair(token0, weth) != address(0x0) && factory.getPair(token1, weth) != address(0x0)) {
            // token0-token1 and have token0-eth eth-token1
            (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(address(factory), token0, token1);
            if (reserve0 == 0 || reserve1 == 0) {
                return 0;
            }
            uint256 totalSupply = pool.lpToken.totalSupply() == 0 ? 1 : pool.lpToken.totalSupply();
            // 1 lp token price
            // token0-eth
            (uint256 reToken, uint256 reEth) = UniswapV2Library.getReserves(address(factory), token0, weth);
            if (reToken == 0 || reEth == 0) {
                return 0;
            }
            uint256 totalEth = UniswapV2Library.quote(reserve0.mul(1e18).div(totalSupply), reToken, reEth);
            // eth-token1
            (reToken, reEth) = UniswapV2Library.getReserves(address(factory), token1, weth);
            if (reToken == 0 || reEth == 0) {
                return 0;
            }
            totalEth = totalEth.add(UniswapV2Library.quote(reserve1.mul(1e18).div(totalSupply), reToken, reEth));
            return _getTokenAPY(pool, totalEth, token0, token1);
        }
        return 0;
    }

    function _getTokenAPY(PoolInfo memory pool,uint256 stakeTotalEth, address token0, address token1)
        internal
        view
        returns (uint256)
    {
        if (stakeTotalEth == 0) {
            return 0;
        }
        // 1 lp token earned
        uint256 totalAllocPoint = rounds[rounds.length - 1].totalAllocPoint;
        uint256 blockEarned = totalAllocPoint == 0 ? 0 :
            getEqualBlockReward(block.number, block.number)
            .mul(1e18).mul(9).div(10)
            .mul(getLastRoundAllocPoint(token0, token1))
            .div(totalAllocPoint);
        uint256 lpSupply = Math.max(pool.lpToken.balanceOf(address(this)), 1);
        uint256 perTokenEarned = blockEarned.div(lpSupply);
        if (perTokenEarned == 0) {
            return 0;
        }
        (uint256 reEqual, uint256 reEqualETH) = UniswapV2Library.getReserves(address(factory), address(equal), weth);
        if (reEqual == 0 || reEqualETH == 0) {
            return 0;
        }
        uint256 earnedETH = UniswapV2Library.quote(perTokenEarned, reEqual, reEqualETH);
        // apy
        return earnedETH.mul(1e18).div(stakeTotalEth).mul(4 * 60 * 24 * 365);
    }

    function getUserInfoAmount(address _tokenA, address _tokenB) external view returns (uint256) {
        PoolInfo storage info = _getPoolSafe(_tokenA, _tokenB);
        if (info.lpToken != IERC20(0x0)) {
            return info.userInfo[msg.sender].amount;
        }
        return 0;
    }

    function getPool(address _tokenA, address _tokenB)
        external
        view
        returns (
            address lpToken,
            uint256 lastRewardBlock,
            uint256 lastRewardRound,
            uint256 accEqualPerShare,
            uint256 allocPointGain
        )
    {
        PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
        lpToken = address(pool.lpToken);
        lastRewardBlock = pool.lastRewardBlock;
        lastRewardRound = pool.lastRewardRound;
        accEqualPerShare = pool.accEqualPerShare;
        allocPointGain = pool.allocPointGain;
    }

    function getPoolAllocPoint(address _tokenA, address _tokenB, uint256 index)
        external
        view
        returns (uint256)
    {
        PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
        return pool.allocPoints[index];
    }

    function getPoolUserInfo(address _tokenA, address _tokenB, address _address)
        external
        view
        returns (uint256 amount, uint256 rewardDebt)
    {
        PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
        UserInfo memory userInfo = pool.userInfo[_address];
        amount = userInfo.amount;
        rewardDebt = userInfo.rewardDebt;
    }
}