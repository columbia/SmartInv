// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
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
contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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
        // This method relies on extcodesize, which returns 0 for contracts in
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
        return functionCallWithValue(target, data, 0, errorMessage);
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
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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

interface IERC20Decimals {
    function decimals() external view returns(uint256);
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

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
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
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
     * Requirements:
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
     * Requirements:
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



contract BlueWhale is ERC20, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    uint256 constant private BASE = 1e8;

    uint256 constant private DAY1 = 1 days;
    struct UserInfo {
        uint256 amount;
        uint256 pending; 
        uint256 rewardDebt; 
        
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; 
        uint256 allocPoint;
        uint256 totalamount; 
        uint256 lastRewardBlock; 
        uint256 accBLWPerShare; 
    }

    struct AccountNodeInfo {
        uint256 initAmount;
        uint256 lockedAmount; 
        uint256 lastUnlockTs; 
        uint256 rewardPending;
        uint256 rewardDebt;
    }

    struct NodeInfo {
        uint256 allocPoint;
        uint256 totalamount; 
        uint256 lastRewardBlock; 
        uint256 accBLWPerShare; 
    }

    struct Fund {
        uint256 initFund;
        uint256 Locked;
        uint256 lastReleaseTs;
    }

    bool public init;
    PoolInfo[] public poolInfo;
    NodeInfo public nodeinfo;
    uint256 poolstart = 1606060800;
    uint256 public totalAllocPoint = 0;
    uint256 public teamRewardPerDay;
    uint256 public lastTeamReleaseTs;
    mapping(address => uint256) public Locked; 
    uint256 public nodeRequireAmount; 
    uint256 public nodeStartReleaseTs; 
    uint256 public nodeReleaseDays;
    mapping(uint256 => mapping(address => UserInfo)) public userInfo; 
    mapping(address => AccountNodeInfo) public accountNodeInfo; 
    mapping(address => bool) public accountNodestatus;
    uint256 public startBlock; 
    uint256 public BLWPerBlock; 
    mapping(address => Fund) public funds; 
    address public fundToken; 
    address public TeamHolder;
    uint256 private fundStartTs;
    uint256 private fundFinishTs;
    uint256 private fundStartReleaseTs; 
    uint256 private maxFund;
    uint256 private maxFundPerAccount;
    uint256 public currentLockedFund; 
    uint256 private fundReleaseDays; 
    uint256 private fundPrice;
    // uint256  private ts1023 = 1602518400;
    // uint256  private ts1025 = 1603382400  ;
    event LockFund(address user, uint256 amount);
    event UnlockFund(address user, uint256 amount);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event NodeSet(uint256 oldallocPoint, uint256 newallocPoint);
    event Set(uint256 pid, uint256 allocPoint, bool withUpdate);
    event Lock(address user, uint256 amount);
    event unLock(address user, uint256 amount);
    event UnlockNodeBalance(address user, uint256 amount);
    event BatchUpdatePools();
    event ReclaimStakingReward(address user, uint256 amount);

    function getpool() view public returns(PoolInfo[] memory){
        return poolInfo;
    }
    //池子pid有效性检查
    modifier validatePool(uint256 _pid) {
        require(_pid < poolInfo.length, 'not good pid');
        _;
    }
    constructor(address _fundToken, address teamHolder, uint256 teamReleaseTime, uint256 _nodeLockTime, uint256 _BLWPerBlock, uint256 _startBlock) ERC20("BlueWhale", "BLW") public {
        BLWPerBlock = _BLWPerBlock;
        TeamHolder = teamHolder;
        startBlock = _startBlock;
        _mint(address(this), 41340000 * BASE); //total supply 41340000
        _transferlock(teamHolder,4134000* BASE); //10%
        _setupDecimals(8);
        _setupFundParams(_fundToken); 
        _setupTeamParams(4134000* BASE, teamReleaseTime);
        _setupNodeParams(_nodeLockTime);

    }
    
    function _setupTeamParams(uint256 lockAmount, uint256 startTime) internal {
        teamRewardPerDay = lockAmount / 365 / 4;
        lastTeamReleaseTs = startTime;
    }
    
    function _setupFundParams(address _fundToken) internal {
        maxFund = 2000000 * BASE;
        maxFundPerAccount = 500 * BASE;
        IERC20Decimals erc20 = IERC20Decimals(_fundToken);
        fundToken = _fundToken;
        fundPrice = 17000 * 1e4 * (10 ** (erc20.decimals())) / BASE; // 1e8 based
        fundStartTs = 1602518400;
        fundFinishTs = 1603468800;
        fundStartReleaseTs = 1605801600;
        fundReleaseDays = 90;
    }

    function _setupNodeParams(uint256 _nodeLockTime) internal {
        nodeinfo.lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        nodeRequireAmount = 5000 * BASE; 
        nodeStartReleaseTs = _nodeLockTime + 90 days; //node release time
        nodeReleaseDays = 90; //node release cycle
    }

    function setNodeInfo(uint256 _allocPoint, bool _withUpdate) public onlyOwner {
        if (_withUpdate) {
            batchUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(nodeinfo.allocPoint).add(_allocPoint);
        emit NodeSet(nodeinfo.allocPoint, _allocPoint);
        nodeinfo.allocPoint = _allocPoint;

    }

    function updateFundParams(uint256 _fundStartAt, uint256 _fundFinishAt, uint256 _fundStartReleaseTs,
        uint256 _maxFund, uint256 _maxFundPerAccount, uint256 _fundPrice, uint32 _fundReleaseDays) public onlyOwner {
        fundStartTs = _fundStartAt;
        fundFinishTs = _fundFinishAt;
        fundStartReleaseTs = _fundStartReleaseTs;
        maxFund = _maxFund;
        maxFundPerAccount = _maxFundPerAccount;
        fundPrice = _fundPrice;
        fundReleaseDays = _fundReleaseDays;
    }
    function getFundParams() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (fundStartTs, fundFinishTs, fundStartReleaseTs, maxFund,
            maxFundPerAccount, currentLockedFund, fundReleaseDays, fundPrice, poolstart);
    }
    function _teamTransfer(address sender, address recipient, uint256 amount) internal {
        uint256 _amount = balanceOf(sender).sub(Locked[sender]);
        require(_amount >= amount);
        if (accountNodestatus[recipient]) { 
            updateNodeReward(); 
            accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));              
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            nodeinfo.totalamount = nodeinfo.totalamount.add(amount);
            accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
            accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
        }else{ 
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
        }
    }
    function _fromNodeTransfer(address sender, address recipient, uint256 amount) internal {
        updateNodeReward();
        uint256 _amount = balanceOf(sender).sub(accountNodeInfo[sender].lockedAmount); 
        require(_amount >= amount);
        if (accountNodestatus[recipient]){
            accountNodeInfo[sender].rewardPending = accountNodeInfo[sender].rewardPending.add(accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[sender].rewardDebt));
            accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));              
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
            accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
            accountNodeInfo[sender].initAmount = accountNodeInfo[sender].initAmount.sub(amount);
            accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
            if (accountNodeInfo[sender].initAmount < 5000 * BASE) {
                accountNodestatus[sender] = false;
                nodeinfo.totalamount = nodeinfo.totalamount.sub(accountNodeInfo[sender].initAmount);
                accountNodeInfo[sender].initAmount = 0;
                accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
            }
        }else{
            accountNodeInfo[sender].rewardPending = accountNodeInfo[sender].rewardPending.add(accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[sender].rewardDebt));
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            nodeinfo.totalamount = nodeinfo.totalamount.sub(amount);
            accountNodeInfo[sender].initAmount = accountNodeInfo[sender].initAmount.sub(amount);
            accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
            if (accountNodeInfo[sender].initAmount < 5000 * BASE) {
                accountNodestatus[sender] = false;
                nodeinfo.totalamount = nodeinfo.totalamount.sub(accountNodeInfo[sender].initAmount);
                accountNodeInfo[sender].initAmount = 0;
                accountNodeInfo[sender].rewardDebt = accountNodeInfo[sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
            }
        }
    }
    function _toNodeTransfer(address sender, address recipient, uint256 amount) internal {
            updateNodeReward();
            accountNodeInfo[recipient].rewardPending = accountNodeInfo[recipient].rewardPending.add(accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[recipient].rewardDebt));             
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            nodeinfo.totalamount = nodeinfo.totalamount.add(amount);
            accountNodeInfo[recipient].initAmount = accountNodeInfo[recipient].initAmount.add(amount);
            accountNodeInfo[recipient].rewardDebt = accountNodeInfo[recipient].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual override{
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        if (sender == TeamHolder) { 
            _teamTransfer(sender, recipient, amount);
            emit Transfer(sender, recipient, amount);
            return; 
        }
        if (accountNodestatus[sender]) {
            _fromNodeTransfer(sender, recipient, amount);
            emit Transfer(sender, recipient, amount);
            return;

        }
        if (accountNodestatus[recipient]) { 
            _toNodeTransfer(sender, recipient, amount);
            emit Transfer(sender, recipient, amount);
            return;
        }
     
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        
    }

    function _transferlock(address _TeamHolder, uint256 amount) internal {
        _transfer(address(this), _TeamHolder, amount); // 
        Locked[_TeamHolder] = amount;
        emit Lock(_TeamHolder, amount);
    }

    function unlockTeam() public onlyOwner {
        _unlockTeam();
    }

    function _unlockTeam() internal {
        uint256 _amount = getAvailableTeamReward();
        Locked[TeamHolder] = Locked[TeamHolder].sub(_amount);
        lastTeamReleaseTs = block.timestamp;
        emit unLock(TeamHolder, _amount);
    }

    function getAvailableTeamReward() public view returns (uint256)  {
        if(block.timestamp <= lastTeamReleaseTs) {
            return 0;
        }

        uint256 _days = (block.timestamp - lastTeamReleaseTs) / 1 days;
        if(_days > 0) {
            uint256 _releaseByDay = _days * teamRewardPerDay;
            return Locked[TeamHolder] > _releaseByDay ? _releaseByDay : Locked[TeamHolder];
        }
        return 0;
    }

    //add node
    function addNodeAdmin(address account) public {
        require(msg.sender == TeamHolder, "Team only");
        require(account != address(this));
        require(account != TeamHolder);
        require(!accountNodestatus[account]);
        require(accountNodeInfo[account].lockedAmount == 0, "There are unreleased tokens");
        safeBLWTransfer(account, nodeRequireAmount);
        accountNodestatus[account] = true;
        accountNodeInfo[account].initAmount = balanceOf(account);
        accountNodeInfo[account].lockedAmount = nodeRequireAmount;
        accountNodeInfo[account].lastUnlockTs = block.timestamp > nodeStartReleaseTs ? block.timestamp : nodeStartReleaseTs;
        accountNodeInfo[account].rewardPending = 0;
        accountNodeInfo[account].rewardDebt = accountNodeInfo[account].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
        nodeinfo.totalamount = nodeinfo.totalamount.add(balanceOf(account));

    }

    function unlockNodeAmount() public {
        require(block.timestamp >= nodeStartReleaseTs, "");
        uint256 _amount = getAvailableNodeAmount(msg.sender);
        require(_amount > 0, "no available fund");
        accountNodeInfo[msg.sender].lockedAmount = accountNodeInfo[msg.sender].lockedAmount.sub(_amount);
        accountNodeInfo[msg.sender].lastUnlockTs = block.timestamp;

        emit UnlockNodeBalance(msg.sender, _amount);
    }

    function getAvailableNodeAmount(address account) public view returns (uint256) {
        if(accountNodeInfo[account].lockedAmount == 0) {
            return 0;
        }

        if(block.timestamp <= nodeStartReleaseTs || block.timestamp <= accountNodeInfo[account].lastUnlockTs) {
            return 0;
        }

        uint256 _last_ts = nodeStartReleaseTs > accountNodeInfo[account].lastUnlockTs ? nodeStartReleaseTs : accountNodeInfo[account].lastUnlockTs;
        uint256 _days = (block.timestamp - _last_ts) / DAY1;

        if(_days > 0) {
            uint256 _releaseByDay = nodeRequireAmount.mul(_days).div(nodeReleaseDays);
            return accountNodeInfo[account].lockedAmount > _releaseByDay ? _releaseByDay : accountNodeInfo[account].lockedAmount;
        }
        return 0;
    }

    //update node reward
    function updateNodeReward() internal {
        if (block.number <= nodeinfo.lastRewardBlock) {
            return;
        }
        if (nodeinfo.totalamount == 0) {
            nodeinfo.lastRewardBlock = block.number;
            return;
        }

        uint256 multiplier = getMultiplier(nodeinfo.lastRewardBlock, block.number);
        uint256 BLWReward = multiplier
            .mul(BLWPerBlock)
            .mul(nodeinfo.allocPoint)
            .div(totalAllocPoint);
        
        
        nodeinfo.accBLWPerShare = nodeinfo.accBLWPerShare.add(BLWReward.mul(1e18).div(nodeinfo.totalamount));

        nodeinfo.lastRewardBlock = block.number;  
    }
    // query node reward
    function getNodeReward() public view returns(uint256) {
        uint256 accBLWPerShare = nodeinfo.accBLWPerShare;
        uint256 lpSupply = nodeinfo.totalamount;
        if (block.number > nodeinfo.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(
                nodeinfo.lastRewardBlock,
                block.number
            );
            uint256 BLWReward = multiplier
                .mul(BLWPerBlock)
                .mul(nodeinfo.allocPoint)
                .div(totalAllocPoint);
            accBLWPerShare = accBLWPerShare.add(
                BLWReward.mul(1e18).div(lpSupply)
            );
        }

        uint256 Pending = accountNodeInfo[msg.sender].rewardPending.add(accountNodeInfo[msg.sender].initAmount.mul(accBLWPerShare).div(1e18).sub(accountNodeInfo[msg.sender].rewardDebt));
        return Pending;
    }

    //withdraw node reward
    function takeNodeReward() public {
        updateNodeReward();
        uint256 Pending = accountNodeInfo[msg.sender].rewardPending.add(accountNodeInfo[msg.sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18).sub(accountNodeInfo[msg.sender].rewardDebt));
        require(Pending > 0, "no reward");
        accountNodeInfo[msg.sender].rewardPending = 0;
        accountNodeInfo[msg.sender].rewardDebt = accountNodeInfo[msg.sender].initAmount.mul(nodeinfo.accBLWPerShare).div(1e18);
        safeBLWTransfer(msg.sender, Pending);
    }


    function checkRepeatedPool(IERC20 _lpToken) internal view {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            if (poolInfo[pid].lpToken == _lpToken) {
                revert();
            }
        }
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    //add pool
    function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
        checkRepeatedPool(_lpToken);

        if (_withUpdate) {
            batchUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocPoint: _allocPoint,
                totalamount: 0,
                lastRewardBlock: lastRewardBlock,
                accBLWPerShare: 0
            })
        );
    }


    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner validatePool(_pid) {
        if (_withUpdate) {
            batchUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
        emit Set(_pid, _allocPoint, _withUpdate);
    }



    function batchUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
        emit BatchUpdatePools();
    }
    function getMultiplier(uint256 _from, uint256 _to) internal pure returns (uint256) {
        return _to.sub(_from);
    
    }
    function pendingBLW(uint256 _pid, address _user)external view validatePool(_pid) returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accBLWPerShare = pool.accBLWPerShare;
        uint256 lpSupply = pool.totalamount;
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(
                pool.lastRewardBlock,
                block.number
            );
            uint256 BLWReward = multiplier
                .mul(BLWPerBlock)
                .mul(pool.allocPoint)
                .div(totalAllocPoint);
            accBLWPerShare = accBLWPerShare.add(
                BLWReward.mul(1e18).div(lpSupply)
            );
        }
        return user.pending.add(user.amount.mul(accBLWPerShare).div(1e18)).sub(user.rewardDebt);
    }

    function updatePool(uint256 _pid) public validatePool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.totalamount;
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 BLWReward = multiplier
            .mul(BLWPerBlock)
            .mul(pool.allocPoint)
            .div(totalAllocPoint);

        pool.accBLWPerShare = pool.accBLWPerShare.add(
            BLWReward.mul(1e18).div(lpSupply)
        );
      
        pool.lastRewardBlock = block.number;

    }
    //deposit
    function deposit(uint256 _pid, uint256 _amount) public validatePool(_pid) payable {
        if (_pid == 0 || _pid == 1) {
            require(block.timestamp >= poolstart, "pool no start");
        }
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
            user.pending = user.pending.add(pending);
        }
        if (address(pool.lpToken) == address(0)) {
            _amount = msg.value;
        } else {
            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
        }
        pool.totalamount = pool.totalamount.add(_amount);
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
        emit Deposit(msg.sender, _pid, _amount);
    }

    function withdraw(uint256 _pid, uint256 _amount) public validatePool(_pid){
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        if (funds[msg.sender].Locked > 0 && _pid == 2){
            _unlockFund();
            require(user.amount.sub(funds[msg.sender].Locked) >= _amount);
        }
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        pool.totalamount = pool.totalamount.sub(_amount);
        uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
        user.pending = user.pending.add(pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
        if (address(pool.lpToken) == address(0)) {
            msg.sender.transfer(_amount);
        } else {
            pool.lpToken.safeTransfer(msg.sender, _amount);
        }
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function reclaimStakingReward(uint256 _pid) public validatePool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        uint256 pending = user.pending.add(user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt));
        if (pending > 0) {
            safeBLWTransfer(msg.sender, pending);
        }
        user.pending = 0;
        user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
        emit ReclaimStakingReward(msg.sender, pending);
    }

    function safeBLWTransfer(address _to, uint256 _amount) internal {
        PoolInfo storage pool = poolInfo[2];
        uint256 BLWBal = balanceOf(address(this)).sub(pool.totalamount);
        if (_amount > BLWBal) {
            _transfer(address(this),_to, BLWBal);
        } else {
            _transfer(address(this), _to, _amount);
        }
    }

    function lockFund(uint256 amount) public {
        require(block.timestamp >= fundStartTs, "wait");
        require(block.timestamp <= fundFinishTs, "it is over");
        currentLockedFund = currentLockedFund.add(amount);
        require(currentLockedFund <= maxFund, "fund end");

        uint256 _fundTokenAmount = getRequireFundToken(amount);
        require(_fundTokenAmount > 0, "amount error");

        uint256 _newAmount = funds[msg.sender].initFund.add(amount);
        require(_newAmount <= maxFundPerAccount, "reach max limit");

        funds[msg.sender].initFund = funds[msg.sender].initFund.add(amount);
        funds[msg.sender].Locked = funds[msg.sender].Locked.add(amount);
        funds[msg.sender].lastReleaseTs = block.timestamp > fundStartReleaseTs ? block.timestamp : fundStartReleaseTs;

        IERC20 erc20 = IERC20(fundToken); 
        erc20.safeTransferFrom(msg.sender, address(this), _fundTokenAmount);
        erc20.safeTransfer(TeamHolder, _fundTokenAmount);
        PoolInfo storage pool = poolInfo[2];
        UserInfo storage user = userInfo[2][msg.sender];
        updatePool(2);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.rewardDebt);
            safeBLWTransfer(msg.sender, pending);
        }
        pool.totalamount = pool.totalamount.add(amount);
        user.amount = user.amount.add(amount);
        user.rewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);
        emit Deposit(msg.sender, 2, amount);
        emit LockFund(msg.sender, amount);
    }

    function getRequireFundToken(uint256 amount) public view returns (uint256) {
        return amount.mul(fundPrice).div(BASE);
    }

    function unlockFund() public {
        uint256 _amount = getAvailableFund(msg.sender);
        withdraw(2,_amount);
    }

    function _unlockFund() internal {
        require(block.timestamp >= fundStartReleaseTs, "wait start");
        uint256 _amount = getAvailableFund(msg.sender);
        require(_amount > 0);
        currentLockedFund = currentLockedFund.sub(_amount); 
        funds[msg.sender].Locked = funds[msg.sender].Locked.sub(_amount);
        funds[msg.sender].lastReleaseTs = block.timestamp; 
    }

    function getAvailableFund(address account) public view returns (uint256) {
        if(funds[account].initFund == 0) {
            return 0;
        }
        if(block.timestamp <= fundStartReleaseTs || block.timestamp < funds[account].lastReleaseTs) {
            return 0;
        }

        uint256 _days = (block.timestamp - funds[account].lastReleaseTs) / DAY1;

        if(_days > 0) {
            uint256 _releaseByDay = funds[account].initFund.mul(_days).div(fundReleaseDays);
            return funds[account].Locked > _releaseByDay ? _releaseByDay : funds[account].Locked;
        }
        return 0;
    }

    receive() external payable {

    }

    function setinit() public onlyOwner {
        init = true;
    }

    //import historical data
    function batchlockFund(address[] memory _to, uint256[] memory _value) onlyOwner public {
        require(!init);
        require(_to.length > 0);
        require(_to.length == _value.length);
        uint256 sum = 0;
        address account;
        uint256 amount;  
        for(uint256 i = 0; i < _to.length; i++){
            amount = _value[i];
            account = _to[i];
            sum = sum.add(amount);    
            funds[account].initFund = amount;
            funds[account].Locked = amount;
            funds[account].lastReleaseTs = fundStartReleaseTs;        
            UserInfo storage user = userInfo[2][account];
            user.amount = user.amount.add(amount);
            emit Deposit(account, 2, amount);
            emit LockFund(account, amount);
        }
        currentLockedFund = currentLockedFund.add(sum);
        require(currentLockedFund <= maxFund, "fund end");
        PoolInfo storage pool = poolInfo[2];
        pool.totalamount = pool.totalamount.add(sum);
    }

}