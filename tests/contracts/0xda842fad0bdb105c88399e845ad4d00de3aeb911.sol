// SPDX-License-Identifier: MIT

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


pragma solidity ^0.6.0;

// import "./IERC20.sol";
// import "../../math/SafeMath.sol";
// import "../../utils/Address.sol";



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



pragma solidity ^0.6.0;

//import "../GSN/Context.sol";
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


pragma solidity ^0.6.0;

//import "../../GSN/Context.sol";
//import "./IERC20.sol";
//import "../../math/SafeMath.sol";
//import "../../utils/Address.sol";

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


pragma solidity 0.6.12;


//import "./openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "./openzeppelin/contracts/access/Ownable.sol";


// TntToken with Governance.
contract TenetToken is ERC20("Tenet", "TEN"), Ownable {
    // @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }
    function burn(address _account, uint256 _amount) public onlyOwner {
        _burn(_account, _amount);
    }
    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol

    // @notice A record of each accounts delegate
    mapping (address => address) internal _delegates;

    // @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

    // @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    // @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    // @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    // @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    // @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

    // @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    // @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

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
        require(signatory != address(0), "delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
        require(now <= expiry, "delegateBySig: signature expired");
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
        require(blockNumber < block.number, "getPriorVotes: not yet determined");

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
        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TNTs (not scaled);
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
        uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");

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
        assembly { chainId := chainid() }
        return chainId;
    }
}


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




pragma solidity 0.6.12;


//import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
//import "./openzeppelin/contracts/utils/EnumerableSet.sol";
//import "./openzeppelin/contracts/math/SafeMath.sol";
//import "./openzeppelin/contracts/access/Ownable.sol";
contract TenetMine is Ownable {
    using SafeMath for uint256;
    struct MinePeriodInfo {
        uint256 tenPerBlockPeriod;
        uint256 totalTenPeriod;
    }
    uint256 public bonusEndBlock;
    uint256 public bonus_multiplier;
    uint256 public bonusTenPerBlock;
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public subBlockNumerPeriod;
    uint256 public totalSupply;
    MinePeriodInfo[] public allMinePeriodInfo;

    constructor(
        uint256 _startBlock,   
        uint256 _bonusEndBlockOffset,
        uint256 _bonus_multiplier,
        uint256 _bonusTenPerBlock,
        uint256 _subBlockNumerPeriod,
        uint256[] memory _tenPerBlockPeriod
    ) public {
        startBlock = _startBlock>0 ? _startBlock : block.number + 1;
        bonusEndBlock = startBlock.add(_bonusEndBlockOffset);
        bonus_multiplier = _bonus_multiplier;
        bonusTenPerBlock = _bonusTenPerBlock;
        subBlockNumerPeriod = _subBlockNumerPeriod;
        totalSupply = bonusEndBlock.sub(startBlock).mul(bonusTenPerBlock).mul(bonus_multiplier);
        for (uint256 i = 0; i < _tenPerBlockPeriod.length; i++) {
            allMinePeriodInfo.push(MinePeriodInfo({
                tenPerBlockPeriod: _tenPerBlockPeriod[i],
                totalTenPeriod: totalSupply
            }));
            totalSupply = totalSupply.add(subBlockNumerPeriod.mul(_tenPerBlockPeriod[i]));
        }
        endBlock = bonusEndBlock.add(subBlockNumerPeriod.mul(_tenPerBlockPeriod.length));        
    }
    function set_startBlock(uint256 _startBlock) public onlyOwner {
		require(block.number < _startBlock, "set_startBlock: startBlock invalid");
        uint256 bonusEndBlockOffset = bonusEndBlock.sub(startBlock);
        startBlock = _startBlock>0 ? _startBlock : block.number + 1;
        bonusEndBlock = startBlock.add(bonusEndBlockOffset);
        endBlock = bonusEndBlock.add(subBlockNumerPeriod.mul(allMinePeriodInfo.length));
	}
    function getMinePeriodCount() public view returns (uint256) {
        return allMinePeriodInfo.length;
    }
    function calcMineTenReward(uint256 _from,uint256 _to) public view returns (uint256) {
        if(_from < startBlock){
            _from = startBlock;
        }
        if(_from >= endBlock){
            return 0;
        }
        if(_from >= _to){
            return 0;
        }
        uint256 mineFrom = calcTotalMine(_from);
        uint256 mineTo= calcTotalMine(_to);
        return mineTo.sub(mineFrom);
    }
    function calcTotalMine(uint256 _to) public view returns (uint256 totalMine) {
        if(_to <= startBlock){
            totalMine = 0;
        }else if(_to <= bonusEndBlock){
            totalMine = _to.sub(startBlock).mul(bonusTenPerBlock).mul(bonus_multiplier);
        }else if(_to < endBlock){
            uint256 periodIndex = _to.sub(bonusEndBlock).div(subBlockNumerPeriod);
            uint256 periodBlock = _to.sub(bonusEndBlock).mod(subBlockNumerPeriod);
            MinePeriodInfo memory minePeriodInfo = allMinePeriodInfo[periodIndex];
            uint256 curMine = periodBlock.mul(minePeriodInfo.tenPerBlockPeriod);
            totalMine = curMine.add(minePeriodInfo.totalTenPeriod);
        }else{
            totalMine = totalSupply;
        }
    }    
    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to,uint256 _end,uint256 _tokenBonusEndBlock,uint256 _tokenBonusMultipler) public pure returns (uint256) {
        if(_to > _end){
            _to = _end;
        }
        if(_from>_end){
            return 0;
        }else if (_to <= _tokenBonusEndBlock) {
            return _to.sub(_from).mul(_tokenBonusMultipler);
        } else if (_from >= _tokenBonusEndBlock) {
            return _to.sub(_from);
        } else {
            return _tokenBonusEndBlock.sub(_from).mul(_tokenBonusMultipler).add(_to.sub(_tokenBonusEndBlock));
        }
    }    
}

pragma solidity 0.6.12;


//import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
//import "./openzeppelin/contracts/utils/EnumerableSet.sol";
//import "./openzeppelin/contracts/math/SafeMath.sol";
//import "./openzeppelin/contracts/access/Ownable.sol";
//import "./TenetToken.sol";
//import "./TenetMine.sol";
// Tenet is the master of TEN. He can make TEN and he is a fair guy.
contract Tenet is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;             
        uint256 rewardTokenDebt;    
        uint256 rewardTenDebt;      
        uint256 lastBlockNumber;    
        uint256 freezeBlocks;      
        uint256 freezeTen;         
    }
    // Info of each pool.
    struct PoolSettingInfo{
        address lpToken;            
        address tokenAddr;          
        address projectAddr;        
        uint256 tokenAmount;       
        uint256 startBlock;        
        uint256 endBlock;          
        uint256 tokenPerBlock;      
        uint256 tokenBonusEndBlock; 
        uint256 tokenBonusMultipler;
    }
    struct PoolInfo {
        uint256 lastRewardBlock;  
        uint256 lpTokenTotalAmount;
        uint256 accTokenPerShare; 
        uint256 accTenPerShare; 
        uint256 userCount;
        uint256 amount;     
        uint256 rewardTenDebt; 
        uint256 mineTokenAmount;
    }

    struct TenPoolInfo {
        uint256 lastRewardBlock;
        uint256 accTenPerShare; 
        uint256 allocPoint;
        uint256 lpTokenTotalAmount;
    }

    TenetToken public ten;
    TenetMine public tenMineCalc;
    IERC20 public lpTokenTen;
    address public devaddr;
    uint256 public devaddrAmount;
    uint256 public modifyAllocPointPeriod;
    uint256 public lastModifyAllocPointBlock;
    uint256 public totalAllocPoint;
    uint256 public devWithdrawStartBlock;
    uint256 public addpoolfee;
    uint256 public bonusAllocPointBlock;
    uint256 public minProjectUserCount;

    uint256 public emergencyWithdraw;
    uint256 public constant MINLPTOKEN_AMOUNT = 10;
    uint256 public constant PERSHARERATE = 1000000000000;
    PoolInfo[] public poolInfo;
    PoolSettingInfo[] public poolSettingInfo;
    TenPoolInfo public tenProjectPool;
    TenPoolInfo public tenUserPool;
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    mapping (address => UserInfo) public userInfoUserPool;
    mapping (address => bool) public tenMintRightAddr;

    address public bonusAddr;
    uint256 public bonusPoolFeeRate;

    event AddPool(address indexed user, uint256 indexed pid, uint256 tokenAmount,uint256 lpTenAmount);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
    event DepositFrom(address indexed user, uint256 indexed pid, uint256 amount,address from,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
    event MineLPToken(address indexed user, uint256 indexed pid, uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);

    event DepositLPTen(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
    event WithdrawLPTen(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
    event MineLPTen(address indexed user, uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event DevWithdraw(address indexed user, uint256 amount);

    constructor(
        TenetToken _ten,
        TenetMine _tenMineCalc,
        IERC20 _lpTen,        
        address _devaddr,
        uint256 _allocPointProject,
        uint256 _allocPointUser,
        uint256 _devWithdrawStartBlock,
        uint256 _modifyAllocPointPeriod,
        uint256 _bonusAllocPointBlock,
        uint256 _minProjectUserCount
    ) public {
        ten = _ten;
        tenMineCalc = _tenMineCalc;
        devaddr = _devaddr;
        lpTokenTen = _lpTen;
        tenProjectPool.allocPoint = _allocPointProject;
        tenUserPool.allocPoint = _allocPointUser;
        totalAllocPoint = _allocPointProject.add(_allocPointUser);
        devaddrAmount = 0;
        devWithdrawStartBlock = _devWithdrawStartBlock;
        addpoolfee = 0;
        emergencyWithdraw = 0;
        modifyAllocPointPeriod = _modifyAllocPointPeriod;
        lastModifyAllocPointBlock = tenMineCalc.startBlock();
        bonusAllocPointBlock = _bonusAllocPointBlock;
        minProjectUserCount = _minProjectUserCount;
        bonusAddr = msg.sender;
        bonusPoolFeeRate = 0;
    }
    modifier onlyMinter() {
        require(tenMintRightAddr[msg.sender] == true, "onlyMinter: caller is no right to mint");
        _;
    }
    modifier onlyNotEmergencyWithdraw() {
        require(emergencyWithdraw == 0, "onlyNotEmergencyWithdraw: emergencyWithdraw now");
        _;
    }    
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    function set_basicInfo(TenetToken _ten,IERC20 _lpTokenTen,TenetMine _tenMineCalc,uint256 _devWithdrawStartBlock,uint256 _bonusAllocPointBlock,uint256 _minProjectUserCount) public onlyOwner {
        ten = _ten;
        lpTokenTen = _lpTokenTen;
        tenMineCalc = _tenMineCalc;
        devWithdrawStartBlock = _devWithdrawStartBlock;
        bonusAllocPointBlock = _bonusAllocPointBlock;
        minProjectUserCount = _minProjectUserCount;
    }
    function set_bonusInfo(address _bonusAddr,uint256 _addpoolfee,uint256 _bonusPoolFeeRate) public onlyOwner {
        bonusAddr = _bonusAddr;
        addpoolfee = _addpoolfee;
        bonusPoolFeeRate = _bonusPoolFeeRate;
    }
    function set_tenMintRightAddr(address _addr,bool isHaveRight) public onlyOwner {
        tenMintRightAddr[_addr] = isHaveRight;
    }
    function tenMint(address _toAddr,uint256 _amount) public onlyMinter {
        if(_amount > 0){
            ten.mint(_toAddr,_amount);
            devaddrAmount = devaddrAmount.add(_amount.div(10));
        }
    }    
 /*   function set_tenetToken(TenetToken _ten) public onlyOwner {
        ten = _ten;
    }*/
    function set_tenNewOwner(address _tenNewOwner) public onlyOwner {
        ten.transferOwnership(_tenNewOwner);
    }    
/*    function set_tenetLPToken(IERC20 _lpTokenTen) public onlyOwner {
        lpTokenTen = _lpTokenTen;
    }
    function set_tenetMine(TenetMine _tenMineCalc) public onlyOwner {
        tenMineCalc = _tenMineCalc;
    }*/
    function set_emergencyWithdraw(uint256 _emergencyWithdraw) public onlyOwner {
        emergencyWithdraw = _emergencyWithdraw;
    }
/*    function set_addPoolFee(uint256 _addpoolfee) public onlyOwner {
        addpoolfee = _addpoolfee;
    }
    function set_devWithdrawStartBlock(uint256 _devWithdrawStartBlock) public onlyOwner {
        devWithdrawStartBlock = _devWithdrawStartBlock;
    }   */
    function set_allocPoint(uint256 _allocPointProject,uint256 _allocPointUser,uint256 _modifyAllocPointPeriod) public onlyOwner {
        _minePoolTen(tenProjectPool);
        _minePoolTen(tenUserPool);
        tenProjectPool.allocPoint = _allocPointProject;
        tenUserPool.allocPoint = _allocPointUser;
        modifyAllocPointPeriod = _modifyAllocPointPeriod;
        totalAllocPoint = _allocPointProject.add(_allocPointUser);
        require(totalAllocPoint > 0, "set_allocPoint: Alloc Point invalid");
    }
/*    function set_bonusAllocPointBlock(uint256 _bonusAllocPointBlock) public onlyOwner {
        bonusAllocPointBlock = _bonusAllocPointBlock;
    }  
    function set_minProjectUserCount(uint256 _minProjectUserCount) public onlyOwner {
        minProjectUserCount = _minProjectUserCount;
    } */
    function add(address _lpToken,
            address _tokenAddr,
            uint256 _tokenAmount,
            uint256 _startBlock,
            uint256 _endBlockOffset,
            uint256 _tokenPerBlock,
            uint256 _tokenBonusEndBlockOffset,
            uint256 _tokenBonusMultipler,
            uint256 _lpTenAmount) public onlyNotEmergencyWithdraw {
        if(_startBlock == 0){
            _startBlock = block.number;
        }
        require(block.number <= _startBlock, "add: startBlock invalid");
        require(_endBlockOffset >= _tokenBonusEndBlockOffset, "add: bonusEndBlockOffset invalid");
        require(tenMineCalc.getMultiplier(_startBlock,_startBlock.add(_endBlockOffset),_startBlock.add(_endBlockOffset),_startBlock.add(_tokenBonusEndBlockOffset),_tokenBonusMultipler).mul(_tokenPerBlock) <= _tokenAmount, "add: token amount invalid");
        require(_tokenAmount > 0, "add: tokenAmount invalid");
        IERC20(_tokenAddr).safeTransferFrom(msg.sender,address(this), _tokenAmount);
        if(addpoolfee > 0){
            IERC20(address(ten)).safeTransferFrom(msg.sender,address(this), addpoolfee);
            if(bonusPoolFeeRate > 0){
                IERC20(address(ten)).safeTransfer(bonusAddr, addpoolfee.mul(bonusPoolFeeRate).div(10000));
                if(bonusPoolFeeRate < 10000){
                    ten.burn(address(this),addpoolfee.sub(addpoolfee.mul(bonusPoolFeeRate).div(10000)));
                }
            }else{
                ten.burn(address(this),addpoolfee);
            }
        }
        uint256 pid = poolInfo.length;
        poolSettingInfo.push(PoolSettingInfo({
                lpToken: _lpToken,
                tokenAddr: _tokenAddr,
                projectAddr: msg.sender,
                tokenAmount:_tokenAmount,
                startBlock: _startBlock,
                endBlock: _startBlock.add(_endBlockOffset),
                tokenPerBlock: _tokenPerBlock,
                tokenBonusEndBlock: _startBlock.add(_tokenBonusEndBlockOffset),
                tokenBonusMultipler: _tokenBonusMultipler
            }));
        poolInfo.push(PoolInfo({
            lastRewardBlock: block.number > _startBlock ? block.number : _startBlock,
            accTokenPerShare: 0,
            accTenPerShare: 0,
            lpTokenTotalAmount: 0,
            userCount: 0,
            amount: 0,
            rewardTenDebt: 0,
            mineTokenAmount: 0
        }));
        if(_lpTenAmount>=MINLPTOKEN_AMOUNT){
            depositTenByProject(pid,_lpTenAmount);
        }
        emit AddPool(msg.sender, pid, _tokenAmount,_lpTenAmount);
    }
    function updateAllocPoint() public {
        if(lastModifyAllocPointBlock.add(modifyAllocPointPeriod) <= block.number){
            uint256 totalLPTokenAmount = tenProjectPool.lpTokenTotalAmount.mul(bonusAllocPointBlock.add(1e4)).div(1e4).add(tenUserPool.lpTokenTotalAmount);
            if(totalLPTokenAmount > 0)
            {
                tenProjectPool.allocPoint = tenProjectPool.allocPoint.add(tenProjectPool.lpTokenTotalAmount.mul(1e4).mul(bonusAllocPointBlock.add(1e4)).div(1e4).div(totalLPTokenAmount)).div(2);
                tenUserPool.allocPoint = tenUserPool.allocPoint.add(tenUserPool.lpTokenTotalAmount.mul(1e4).div(totalLPTokenAmount)).div(2);
                totalAllocPoint = tenProjectPool.allocPoint.add(tenUserPool.allocPoint);
                lastModifyAllocPointBlock = block.number;
                require(totalAllocPoint > 0, "updateAllocPoint: Alloc Point invalid");
            }
        }     
    }
    // Update reward variables of the given pool to be up-to-date.
    function _minePoolTen(TenPoolInfo storage tenPool) internal {
        if (block.number <= tenPool.lastRewardBlock) {
            return;
        }
        if (tenPool.lpTokenTotalAmount < MINLPTOKEN_AMOUNT) {
            tenPool.lastRewardBlock = block.number;
            return;
        }
        if(emergencyWithdraw > 0){
            tenPool.lastRewardBlock = block.number;
            return;                
        }
        uint256 tenReward = tenMineCalc.calcMineTenReward(tenPool.lastRewardBlock, block.number);
        if(tenReward > 0){
            tenReward = tenReward.mul(tenPool.allocPoint).div(totalAllocPoint);
            devaddrAmount = devaddrAmount.add(tenReward.div(10));
            ten.mint(address(this), tenReward);
            tenPool.accTenPerShare = tenPool.accTenPerShare.add(tenReward.mul(PERSHARERATE).div(tenPool.lpTokenTotalAmount));
        }
        tenPool.lastRewardBlock = block.number;
        updateAllocPoint();
    }
    function _withdrawProjectTenPool(PoolInfo storage pool) internal returns (uint256 pending){
        if (pool.amount >= MINLPTOKEN_AMOUNT) {
            pending = pool.amount.mul(tenProjectPool.accTenPerShare).div(PERSHARERATE).sub(pool.rewardTenDebt);
            if(pending > 0){
                if(pool.userCount == 0){
                    ten.burn(address(this),pending);
                    pending = 0;
                }
                else{
                    if(pool.userCount<minProjectUserCount){
                        uint256 newPending = pending.mul(bonusAllocPointBlock.mul(pool.userCount).div(minProjectUserCount).add(1e4)).div(bonusAllocPointBlock.add(1e4));
                        if(pending.sub(newPending) > 0){
                            ten.burn(address(this),pending.sub(newPending));
                        }
                        pending = newPending;
                    }                    
                    pool.accTenPerShare = pool.accTenPerShare.add(pending.mul(PERSHARERATE).div(pool.lpTokenTotalAmount));
                }
            }
        }
    }
    function _updateProjectTenPoolAmount(PoolInfo storage pool,uint256 _amount,uint256 amountType) internal{
        if(amountType == 1){
            lpTokenTen.safeTransferFrom(msg.sender, address(this), _amount);
            tenProjectPool.lpTokenTotalAmount = tenProjectPool.lpTokenTotalAmount.add(_amount);
            pool.amount = pool.amount.add(_amount);
        }else if(amountType == 2){
            pool.amount = pool.amount.sub(_amount);
            lpTokenTen.safeTransfer(address(msg.sender), _amount);
            tenProjectPool.lpTokenTotalAmount = tenProjectPool.lpTokenTotalAmount.sub(_amount);
        }
        pool.rewardTenDebt = pool.amount.mul(tenProjectPool.accTenPerShare).div(PERSHARERATE);
    }
    function depositTenByProject(uint256 _pid,uint256 _amount) public onlyNotEmergencyWithdraw {
        require(_amount > 0, "depositTenByProject: lpamount not good");
        PoolInfo storage pool = poolInfo[_pid];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        require(poolSetting.projectAddr == msg.sender, "depositTenByProject: not good");
        _minePoolTen(tenProjectPool);
        _withdrawProjectTenPool(pool);
        _updateProjectTenPoolAmount(pool,_amount,1);
        emit DepositLPTen(msg.sender, 1, _amount,0,0,0);
    }

    function withdrawTenByProject(uint256 _pid,uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        require(poolSetting.projectAddr == msg.sender, "withdrawTenByProject: not good");
        require(pool.amount >= _amount, "withdrawTenByProject: not good");
        if(emergencyWithdraw == 0){
            _minePoolTen(tenProjectPool);
            _withdrawProjectTenPool(pool);
        }else{
            if(pool.lastRewardBlock < poolSetting.endBlock){
                if(poolSetting.tokenAmount.sub(pool.mineTokenAmount) > 0){
                    IERC20(poolSetting.tokenAddr).safeTransfer(poolSetting.projectAddr,poolSetting.tokenAmount.sub(pool.mineTokenAmount));
                }
            }
        }
        if(_amount > 0){
            _updateProjectTenPoolAmount(pool,_amount,2);
        }
        emit WithdrawLPTen(msg.sender, 1, _amount,0,0,0);
    }

    function _updatePoolUserInfo(uint256 accTenPerShare,UserInfo storage user,uint256 _freezeBlocks,uint256 _freezeTen,uint256 _amount,uint256 _amountType) internal {
        if(_amountType == 1){
            user.amount = user.amount.add(_amount);
        }else if(_amountType == 2){
            user.amount = user.amount.sub(_amount);      
        }
        user.rewardTenDebt = user.amount.mul(accTenPerShare).div(PERSHARERATE);
        user.lastBlockNumber = block.number;
        user.freezeBlocks = _freezeBlocks;
        user.freezeTen = _freezeTen;
    }
    function _calcFreezeTen(UserInfo storage user,uint256 accTenPerShare) internal view returns (uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
        pendingTen = user.amount.mul(accTenPerShare).div(PERSHARERATE).sub(user.rewardTenDebt);
        uint256 blockNow = 0;
        if(pendingTen>0){
            if(user.lastBlockNumber<tenMineCalc.startBlock()){
                blockNow = block.number.sub(tenMineCalc.startBlock());
            }else{
                blockNow = block.number.sub(user.lastBlockNumber);
            }
        }else{
            if(user.freezeTen > 0){
                blockNow = block.number.sub(user.lastBlockNumber);
            }
        }
        uint256 periodBlockNumer = tenMineCalc.subBlockNumerPeriod();
        freezeBlocks = blockNow.add(user.freezeBlocks);
        if(freezeBlocks <= periodBlockNumer){
            freezeTen = pendingTen.add(user.freezeTen);
            pendingTen = 0;
        }else{
            if(pendingTen == 0){
                freezeBlocks = 0;
                freezeTen = 0;
                pendingTen = user.freezeTen;
            }else{
                freezeTen = pendingTen.add(user.freezeTen).mul(periodBlockNumer).div(freezeBlocks);
                pendingTen = pendingTen.add(user.freezeTen).sub(freezeTen);
                freezeBlocks = periodBlockNumer;
            }            
        }        
    }
    function _withdrawUserTenPool(address userAddr,UserInfo storage user) internal returns (uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
        (pendingTen,freezeBlocks,freezeTen) = _calcFreezeTen(user,tenUserPool.accTenPerShare);
        safeTenTransfer(userAddr, pendingTen);
    }   
    function depositTenByUser(uint256 _amount) public onlyNotEmergencyWithdraw {
        require(_amount > 0, "depositTenByUser: lpamount not good");
        UserInfo storage user = userInfoUserPool[msg.sender];
        _minePoolTen(tenUserPool);
        (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
        lpTokenTen.safeTransferFrom(address(msg.sender), address(this), _amount);
        _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
        tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.add(_amount);        
        emit DepositLPTen(msg.sender, 2, _amount,pending,freezeTen,freezeBlocks);
    }

    function withdrawTenByUser(uint256 _amount) public {
        require(_amount > 0, "withdrawTenByUser: lpamount not good");
        UserInfo storage user = userInfoUserPool[msg.sender];
        require(user.amount >= _amount, "withdrawTenByUser: not good");
        if(emergencyWithdraw == 0){
            _minePoolTen(tenUserPool);
            (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
            _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,2);
            emit WithdrawLPTen(msg.sender, 2, _amount,pending,freezeTen,freezeBlocks);
        }else{
            _updatePoolUserInfo(tenUserPool.accTenPerShare,user,user.freezeBlocks,user.freezeTen,_amount,2);
            emit WithdrawLPTen(msg.sender, 2, _amount,0,user.freezeTen,user.freezeBlocks);
        }
        tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.sub(_amount);          
        lpTokenTen.safeTransfer(address(msg.sender), _amount);
    }
    function mineLPTen() public onlyNotEmergencyWithdraw {
        _minePoolTen(tenUserPool);
        UserInfo storage user = userInfoUserPool[msg.sender];
        (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
        _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,0,0);
        emit MineLPTen(msg.sender,pending,freezeTen,freezeBlocks);
    }
    function depositTenByUserFrom(address _from,uint256 _amount) public onlyNotEmergencyWithdraw {
        require(_amount > 0, "depositTenByUserFrom: lpamount not good");
        UserInfo storage user = userInfoUserPool[_from];
        _minePoolTen(tenUserPool);
        (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(_from,user);
        lpTokenTen.safeTransferFrom(address(msg.sender), address(this), _amount);
        _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
        tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.add(_amount);        
        emit DepositLPTen(_from, 2, _amount,pending,freezeTen,freezeBlocks);
    } 
    function _minePoolToken(PoolInfo storage pool,PoolSettingInfo storage poolSetting) internal {
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        if (pool.lpTokenTotalAmount >= MINLPTOKEN_AMOUNT) {
            uint256 multiplier = tenMineCalc.getMultiplier(pool.lastRewardBlock, block.number,poolSetting.endBlock,poolSetting.tokenBonusEndBlock,poolSetting.tokenBonusMultipler);
            if(multiplier > 0){
                uint256 tokenReward = multiplier.mul(poolSetting.tokenPerBlock);
                pool.mineTokenAmount = pool.mineTokenAmount.add(tokenReward);
                pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(PERSHARERATE).div(pool.lpTokenTotalAmount));
            }
        }
        if(pool.lastRewardBlock < poolSetting.endBlock){
            if(block.number >= poolSetting.endBlock){
                if(poolSetting.tokenAmount.sub(pool.mineTokenAmount) > 0){
                    IERC20(poolSetting.tokenAddr).safeTransfer(poolSetting.projectAddr,poolSetting.tokenAmount.sub(pool.mineTokenAmount));
                }
            }
        }
        pool.lastRewardBlock = block.number;
        _minePoolTen(tenProjectPool);
        _withdrawProjectTenPool(pool);
        _updateProjectTenPoolAmount(pool,0,0);
    }
    function _withdrawTokenPool(address userAddr,PoolInfo storage pool,UserInfo storage user,PoolSettingInfo storage poolSetting) 
            internal returns (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
        if (user.amount >= MINLPTOKEN_AMOUNT) {
            pendingToken = user.amount.mul(pool.accTokenPerShare).div(PERSHARERATE).sub(user.rewardTokenDebt);
            if(pendingToken > 0){
                IERC20(poolSetting.tokenAddr).safeTransfer(userAddr, pendingToken);
            }
            (pendingTen,freezeBlocks,freezeTen) = _calcFreezeTen(user,pool.accTenPerShare);
            safeTenTransfer(userAddr, pendingTen);
        }
    }
    function _updateTokenPoolUser(uint256 accTokenPerShare,uint256 accTenPerShare,UserInfo storage user,uint256 _freezeBlocks,uint256 _freezeTen,uint256 _amount,uint256 _amountType) 
            internal {
        _updatePoolUserInfo(accTenPerShare,user,_freezeBlocks,_freezeTen,_amount,_amountType);
        user.rewardTokenDebt = user.amount.mul(accTokenPerShare).div(PERSHARERATE);
    }
    function depositLPToken(uint256 _pid, uint256 _amount) public onlyNotEmergencyWithdraw {
        require(_amount > 0, "depositLPToken: lpamount not good");
        PoolInfo storage pool = poolInfo[_pid];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        _minePoolToken(pool,poolSetting);
        (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
        if (user.amount < MINLPTOKEN_AMOUNT) {
            pool.userCount = pool.userCount.add(1);
        }
        IERC20(poolSetting.lpToken).safeTransferFrom(address(msg.sender), address(this), _amount);
        pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.add(_amount);
        _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
        emit Deposit(msg.sender, _pid, _amount,pendingToken,pendingTen,freezeTen,freezeBlocks);
    }

    function withdrawLPToken(uint256 _pid, uint256 _amount) public {
        require(_amount > 0, "withdrawLPToken: lpamount not good");
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        require(user.amount >= _amount, "withdrawLPToken: not good");
        if(emergencyWithdraw == 0){
            _minePoolToken(pool,poolSetting);
            (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
            _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,2);
            emit Withdraw(msg.sender, _pid, _amount,pendingToken,pendingTen,freezeTen,freezeBlocks);
        }else{
            _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,user.freezeBlocks,user.freezeTen,_amount,2);
            emit Withdraw(msg.sender, _pid, _amount,0,0,user.freezeTen,user.freezeBlocks);
        }
        IERC20(poolSetting.lpToken).safeTransfer(address(msg.sender), _amount);
        pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.sub(_amount);
        if(user.amount < MINLPTOKEN_AMOUNT){
            pool.userCount = pool.userCount.sub(1);
        }
    }

    function mineLPToken(uint256 _pid) public onlyNotEmergencyWithdraw {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        _minePoolToken(pool,poolSetting);
        (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
        _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,0,0);
        emit MineLPToken(msg.sender, _pid, pendingToken,pendingTen,freezeTen,freezeBlocks);
    }

    function depositLPTokenFrom(address _from,uint256 _pid, uint256 _amount) public onlyNotEmergencyWithdraw {
        require(_amount > 0, "depositLPTokenFrom: lpamount not good");
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_from];
        PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
        _minePoolToken(pool,poolSetting);
        (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(_from,pool,user,poolSetting);
        if (user.amount < MINLPTOKEN_AMOUNT) {
            pool.userCount = pool.userCount.add(1);
        }
        IERC20(poolSetting.lpToken).safeTransferFrom(msg.sender, address(this), _amount);
        pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.add(_amount);
        _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
        emit DepositFrom(_from, _pid, _amount,msg.sender,pendingToken,pendingTen,freezeTen,freezeBlocks);
    }
 
    function dev(address _devaddr) public {
        require(msg.sender == devaddr, "dev: wut?");
        devaddr = _devaddr;
    }

    function devWithdraw(uint256 _amount) public {
        require(block.number >= devWithdrawStartBlock, "devWithdraw: start Block invalid");
        require(msg.sender == devaddr, "devWithdraw: devaddr invalid");
        require(devaddrAmount >= _amount, "devWithdraw: amount invalid");        
        ten.mint(devaddr,_amount);
        devaddrAmount = devaddrAmount.sub(_amount);
        emit DevWithdraw(msg.sender, _amount);
    }    

    function safeTenTransfer(address _to, uint256 _amount) internal {
        if(_amount > 0){
            uint256 bal = ten.balanceOf(address(this));
            if (_amount > bal) {
                if(bal > 0){
                    IERC20(address(ten)).safeTransfer(_to, bal);
                }
            } else {
                IERC20(address(ten)).safeTransfer(_to, _amount);
            }
        }
    }        
}