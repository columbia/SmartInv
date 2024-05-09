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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

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

// SPDX-License-Identifier: MIT

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

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

// File: @openzeppelin/contracts/utils/SafeCast.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


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

// File: contracts/Interfaces/PriceCalculatorInterface.sol

pragma solidity >=0.6.6;

interface PriceCalculatorInterface {
    function calculatePrice(
        uint256 buyAmount,
        uint256 buyAmountLimit,
        uint256 sellAmount,
        uint256 sellAmountLimit,
        uint256 baseTokenPool,
        uint256 settlementTokenPool
    ) external view returns (uint256[5] memory);
}

// File: contracts/Libraries/Enums.sol

pragma solidity >=0.6.6;

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

// File: contracts/Libraries/RateMath.sol

pragma solidity >=0.6.6;


library RateMath {
    using SafeMath for uint256;
    uint256 public constant RATE_POINT_MULTIPLIER = 1000000000000000000; // 10^18

    function getRate(uint256 a, uint256 b) internal pure returns (uint256) {
        return a.mul(RATE_POINT_MULTIPLIER).div(b);
    }

    function divByRate(uint256 self, uint256 rate)
        internal
        pure
        returns (uint256)
    {
        return self.mul(RATE_POINT_MULTIPLIER).div(rate);
    }

    function mulByRate(uint256 self, uint256 rate)
        internal
        pure
        returns (uint256)
    {
        return self.mul(rate).div(RATE_POINT_MULTIPLIER);
    }
}

// File: contracts/Libraries/ExecutionStatus.sol

pragma solidity >=0.6.6;



struct BoxExecutionStatus {
    OrderType partiallyRefundOrderType;
    uint64 partiallyRefundRate; // refundAmount/inAmount
    uint128 rate; // Token0/Token1
    uint32 boxNumber;
    bool onGoing;
}

struct BookExecutionStatus {
    OrderType executingOrderType;
    uint256 nextIndex;
}

library BoxExecutionStatusLibrary {
    using OrderTypeLibrary for OrderType;

    function refundRate(BoxExecutionStatus memory self, OrderType orderType)
        internal
        pure
        returns (uint256)
    {
        // inToken is different from refundOrderType
        if (self.partiallyRefundOrderType.inToken() != orderType.inToken()) {
            return 0;
        }

        // inToken is the same as refundOrderType
        // refund all of strict order and some of flex order
        if (self.partiallyRefundOrderType.isFlex()) {
            // orderType is flex
            if (orderType.isFlex()) {
                return self.partiallyRefundRate;
            }
            // orderType is strict
            return RateMath.RATE_POINT_MULTIPLIER;
        }

        // refund some of strict order
        if (orderType.isStrict()) {
            return self.partiallyRefundRate;
        }
        return 0;
    }
}

// File: contracts/Libraries/OrderBox.sol

pragma solidity >=0.6.6;




struct OrderBox {
    mapping(OrderType => OrderBook) orderBooks;
    uint128 spreadRate;
    uint128 expireAt;
}

struct OrderBook {
    mapping(address => uint256) inAmounts;
    address[] recipients;
    uint256 totalInAmount;
}

library OrderBoxLibrary {
    using RateMath for uint256;
    using SafeMath for uint256;
    using TokenLibrary for Token;

    function newOrderBox(uint128 spreadRate, uint128 expireAt)
        internal
        pure
        returns (OrderBox memory)
    {
        return OrderBox({spreadRate: spreadRate, expireAt: expireAt});
    }

    function addOrder(
        OrderBox storage self,
        OrderType orderType,
        uint256 inAmount,
        address recipient
    ) internal {
        OrderBook storage orderBook = self.orderBooks[orderType];
        if (orderBook.inAmounts[recipient] == 0) {
            orderBook.recipients.push(recipient);
        }
        orderBook.inAmounts[recipient] = orderBook.inAmounts[recipient].add(
            inAmount
        );
        orderBook.totalInAmount = orderBook.totalInAmount.add(inAmount);
    }
}

library OrderBookLibrary {
    function numOfOrder(OrderBook memory self) internal pure returns (uint256) {
        return self.recipients.length;
    }
}

// File: contracts/BoxExchange/BoxExchange.sol

pragma solidity ^0.6.6;


abstract contract BoxExchange is ERC20 {
    using BoxExecutionStatusLibrary for BoxExecutionStatus;
    using OrderBoxLibrary for OrderBox;
    using OrderBookLibrary for OrderBook;
    using OrderTypeLibrary for OrderType;
    using TokenLibrary for Token;
    using RateMath for uint256;
    using SafeMath for uint256;
    using SafeCast for uint256;

    uint256 internal constant MARKET_FEE_RATE = 200000000000000000; // market fee taker takes 20% of spread

    address internal immutable factory;

    address internal immutable marketFeeTaker; // Address that receives market fee (i.e. Lien Token)
    uint128 public marketFeePool0; // Total market fee in TOKEN0
    uint128 public marketFeePool1; // Total market fee in TOKEN1

    uint128 internal reserve0; // Total Liquidity of TOKEN0
    uint128 internal reserve1; // Total Liquidity of TOKEN1
    OrderBox[] internal orderBoxes; // Array of OrderBox
    PriceCalculatorInterface internal immutable priceCalc; // Price Calculator
    BoxExecutionStatus internal boxExecutionStatus; // Struct that has information about execution of current executing OrderBox
    BookExecutionStatus internal bookExecutionStatus; // Struct that has information about execution of current executing OrderBook

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

    modifier isAmountSafe(uint256 amount) {
        require(amount != 0, "Amount should be bigger than 0");
        _;
    }

    modifier isInTime(uint256 timeout) {
        require(timeout > _currentOpenBoxId(), "Time out");
        _;
    }

    constructor(
        PriceCalculatorInterface _priceCalc,
        address _marketFeeTaker,
        string memory _name
    ) public ERC20(_name, "share") {
        factory = msg.sender;
        priceCalc = _priceCalc;
        marketFeeTaker = _marketFeeTaker;
        _setupDecimals(8); // Decimal of share token is the same as iDOL, LBT, and Lien Token
    }

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
        )
    {
        return
            _whenToExecute(recipient, _getOrderType(isBuy, isLimit), boxNumber);
    }

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
        virtual
        view
        returns (
            uint256 boxNumber,
            uint256 _reserve0,
            uint256 _reserve1,
            uint256 totalShare,
            uint256 latestSpreadRate,
            uint256 token0PerShareE18,
            uint256 token1PerShareE18
        )
    {
        boxNumber = _currentOpenBoxId();
        (_reserve0, _reserve1) = _getReserves();
        latestSpreadRate = orderBoxes[boxNumber].spreadRate;
        totalShare = totalSupply();
        token0PerShareE18 = RateMath.getRate(_reserve0, totalShare);
        token1PerShareE18 = RateMath.getRate(_reserve1, totalShare);
    }

    /**
     * @notice Gets summary of Current box information (Total order amount of each OrderTypes)
     * @param executionStatusNumber Status of execution of this box
     * @param boxNumber ID of target box.
     **/
    function getBoxSummary(uint256 boxNumber)
        public
        view
        returns (
            uint256 executionStatusNumber,
            uint256 flexToken0InAmount,
            uint256 strictToken0InAmount,
            uint256 flexToken1InAmount,
            uint256 strictToken1InAmount
        )
    {
        // `executionStatusNumber`
        // 0 => This box has not been executed
        // 1 => This box is currently executing. (Reserves and market fee pools have already been updated)
        // 2 => This box has already been executed
        uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
        flexToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
            .FLEX_0_1]
            .totalInAmount;
        strictToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
            .STRICT_0_1]
            .totalInAmount;
        flexToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
            .FLEX_1_0]
            .totalInAmount;
        strictToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
            .STRICT_1_0]
            .totalInAmount;
        if (boxNumber < nextExecutingBoxId) {
            executionStatusNumber = 2;
        } else if (
            boxNumber == nextExecutingBoxId && boxExecutionStatus.onGoing
        ) {
            executionStatusNumber = 1;
        }
    }

    /**
     * @notice Gets amount of order in current open box
     * @param account Target Address
     * @param orderType OrderType of target order
     * @return Amount of target order
     **/
    function getOrderAmount(address account, OrderType orderType)
        public
        view
        returns (uint256)
    {
        return
            orderBoxes[_currentOpenBoxId()].orderBooks[orderType]
                .inAmounts[account];
    }

    // abstract functions
    function _feeRate() internal virtual returns (uint128);

    function _receiveTokens(
        Token token,
        address from,
        uint256 amount
    ) internal virtual;

    function _sendTokens(
        Token token,
        address to,
        uint256 amount
    ) internal virtual;

    function _payForOrderExecution(
        Token token,
        address to,
        uint256 amount
    ) internal virtual;

    function _payMarketFee(
        address _marketFeeTaker,
        uint256 amount0,
        uint256 amount1
    ) internal virtual;

    function _isCurrentOpenBoxExpired() internal virtual view returns (bool) {}

    /**
     * @notice User can determine the amount of share token to mint.
     * @dev This function can be executed only by factory
     * @param amount0 The amount of TOKEN0 to invest
     * @param amount1 The amount of TOKEN1 to invest
     * @param initialShare The amount of share token to mint. This defines approximate value of share token.
     **/
    function _init(
        uint128 amount0,
        uint128 amount1,
        uint256 initialShare
    ) internal virtual {
        require(totalSupply() == 0, "Already initialized");
        require(msg.sender == factory);
        _updateReserve(amount0, amount1);
        _mint(msg.sender, initialShare);
        _receiveTokens(Token.TOKEN0, msg.sender, amount0);
        _receiveTokens(Token.TOKEN1, msg.sender, amount1);
        _openNewBox();
    }

    /**
     * @dev Amount of share to mint is determined by `amount`
     * @param tokenType Type of token which the amount of share the LP get is calculated based on `amount`
     * @param amount The amount of token type of `tokenType`
     **/
    function _addLiquidity(
        uint256 _reserve0,
        uint256 _reserve1,
        uint256 amount,
        uint256 minShare,
        Token tokenType
    ) internal virtual {
        (uint256 amount0, uint256 amount1, uint256 share) = _calculateAmounts(
            amount,
            _reserve0,
            _reserve1,
            tokenType
        );
        require(share >= minShare, "You can't receive enough shares");
        _receiveTokens(Token.TOKEN0, msg.sender, amount0);
        _receiveTokens(Token.TOKEN1, msg.sender, amount1);
        _updateReserve(
            _reserve0.add(amount0).toUint128(),
            _reserve1.add(amount1).toUint128()
        );
        _mint(msg.sender, share);
        emit MoveLiquidity(msg.sender, true, amount0, amount1, share);
    }

    /**
     * @dev Amount of TOKEN0 and TOKEN1 is determined by amount of share to be burned
     * @param minAmount0 Minimum amount of TOKEN0 to return. If returned TOKEN0 is less than this value, revert transaction
     * @param minAmount1 Minimum amount of TOKEN1 to return. If returned TOKEN1 is less than this value, revert transaction
     * @param share Amount of share token to be burned
     **/
    function _removeLiquidity(
        uint256 minAmount0,
        uint256 minAmount1,
        uint256 share
    ) internal virtual {
        (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
        uint256 _totalSupply = totalSupply();
        uint256 amount0 = _reserve0.mul(share).div(_totalSupply);
        uint256 amount1 = _reserve1.mul(share).div(_totalSupply);
        require(
            amount0 >= minAmount0 && amount1 >= minAmount1,
            "You can't receive enough tokens"
        );
        _updateReserve(
            _reserve0.sub(amount0).toUint128(),
            _reserve1.sub(amount1).toUint128()
        );
        _burn(msg.sender, share);
        _sendTokens(Token.TOKEN0, msg.sender, amount0);
        _sendTokens(Token.TOKEN1, msg.sender, amount1);
        emit MoveLiquidity(msg.sender, false, amount0, amount1, share);
    }

    /**
     * @dev If there is some OrderBox to be executed, try execute 5 orders
     * @dev If currentBox has expired, open new box
     * @param orderType Type of order
     * @param inAmount Amount of token to be exchanged
     * @param recipient Recipient of swapped token. If this value is address(0), msg.sender is the recipient
     **/
    function _addOrder(
        OrderType orderType,
        uint256 inAmount,
        address recipient
    ) internal virtual {
        _rotateBox();
        uint256 _currentOpenBoxId = _currentOpenBoxId();
        _executeOrders(5, _currentOpenBoxId);
        if (recipient == address(0)) {
            recipient = msg.sender;
        }
        _receiveTokens(orderType.inToken(), msg.sender, inAmount);
        orderBoxes[_currentOpenBoxId].addOrder(orderType, inAmount, recipient);
        emit AcceptOrders(
            recipient,
            orderType.isBuy(),
            uint32(_currentOpenBoxId),
            orderType.isStrict(),
            inAmount
        );
    }

    /**
     * @dev Triggers executeOrders()
     * @param maxOrderNum Number of orders to execute (if no order is left, stop execution)
     **/
    function _triggerExecuteOrders(uint8 maxOrderNum) internal virtual {
        _executeOrders(maxOrderNum, _currentOpenBoxId());
    }

    /**
     * @dev Triggers PayMarketFee() and update marketFeePool to 0
     **/
    function _triggerPayMarketFee() internal virtual {
        (
            uint256 _marketFeePool0,
            uint256 _marketFeePool1
        ) = _getMarketFeePools();
        _updateMarketFeePool(0, 0);

        emit PayMarketFee(_marketFeePool0, _marketFeePool1);
        _payMarketFee(marketFeeTaker, _marketFeePool0, _marketFeePool1);
    }

    // When open new box, creates new OrderBox with spreadRate and block number of expiretion, then pushes it to orderBoxes
    function _openNewBox() internal virtual {
        orderBoxes.push(
            OrderBoxLibrary.newOrderBox(
                _feeRate(),
                (block.number + 2).toUint32()
            )
        );
    }

    function _rotateBox() private {
        // if current open box has expired
        if (_isCurrentOpenBoxExpired()) {
            _openNewBox();
        }
    }

    /**
     * @param maxOrderNum Number of orders to execute (if no order is left, stoppes execution)
     * @param _currentOpenBoxId Current box ID (_currentOpenBoxID() is already run in _addOrder() or _triggerExecuteOrders()
     **/
    function _executeOrders(uint256 maxOrderNum, uint256 _currentOpenBoxId)
        private
    {
        BoxExecutionStatus memory _boxExecutionStatus = boxExecutionStatus;
        BookExecutionStatus memory _bookExecutionStatus = bookExecutionStatus;
        // if _boxExecutionStatus.boxNumber is current open and not expired box, won't execute.
        // if _boxExecutionStatus.boxNumber is more than currentOpenBoxId, the newest box is already executed.
        if (
            _boxExecutionStatus.boxNumber >= _currentOpenBoxId &&
            (!_isCurrentOpenBoxExpired() ||
                _boxExecutionStatus.boxNumber > _currentOpenBoxId)
        ) {
            return;
        }
        if (!_boxExecutionStatus.onGoing) {
            // get rates and start new box execution
            // before start new box execution, updates reserves.
            {
                (
                    OrderType partiallyRefundOrderType,
                    uint256 partiallyRefundRate,
                    uint256 rate
                ) = _getExecutionRatesAndUpdateReserve(
                    _boxExecutionStatus.boxNumber
                );
                _boxExecutionStatus
                    .partiallyRefundOrderType = partiallyRefundOrderType;
                _boxExecutionStatus.partiallyRefundRate = partiallyRefundRate
                    .toUint64();
                _boxExecutionStatus.rate = rate.toUint128();
                _boxExecutionStatus.onGoing = true;
                _bookExecutionStatus.executingOrderType = OrderType(0);
                _bookExecutionStatus.nextIndex = 0;
            }
        }
        // execute orders in one book
        // reducing maxOrderNum to avoid stack to deep
        while (maxOrderNum != 0) {
            OrderBook storage executionBook = orderBoxes[_boxExecutionStatus
                .boxNumber]
                .orderBooks[_bookExecutionStatus.executingOrderType];
            (
                bool isBookFinished,
                uint256 nextIndex,
                uint256 executedOrderNum
            ) = _executeOrdersInBook(
                executionBook,
                _bookExecutionStatus.executingOrderType.inToken(),
                _bookExecutionStatus.nextIndex,
                _boxExecutionStatus.refundRate(
                    _bookExecutionStatus.executingOrderType
                ),
                _boxExecutionStatus.rate,
                orderBoxes[_boxExecutionStatus.boxNumber].spreadRate,
                maxOrderNum
            );
            if (isBookFinished) {
                bool isBoxFinished = _isBoxFinished(
                    orderBoxes[_boxExecutionStatus.boxNumber],
                    _bookExecutionStatus.executingOrderType
                );
                delete orderBoxes[_boxExecutionStatus.boxNumber]
                    .orderBooks[_bookExecutionStatus.executingOrderType];

                // update book execution status and box execution status
                if (isBoxFinished) {
                    _boxExecutionStatus.boxNumber += 1;
                    _boxExecutionStatus.onGoing = false;
                    boxExecutionStatus = _boxExecutionStatus;

                    return; // no need to update bookExecutionStatus;
                }
                _bookExecutionStatus.executingOrderType = _bookExecutionStatus
                    .executingOrderType
                    .next();
            }
            _bookExecutionStatus.nextIndex = nextIndex.toUint32();
            maxOrderNum -= executedOrderNum;
        }
        boxExecutionStatus = _boxExecutionStatus;
        bookExecutionStatus = _bookExecutionStatus;
    }

    /**
     * @notice Executes each OrderBook
     * @param orderBook Target OrderBook
     * @param rate Rate of swap
     * @param refundRate Refund rate in this OrderType
     * @param maxOrderNum Max number of orders to execute in this book
     * @return If execution is finished, return true
     * @return Next index to execute. If execution is finished, return 0
     * @return Number of orders executed
     **/
    function _executeOrdersInBook(
        OrderBook storage orderBook,
        Token inToken,
        uint256 initialIndex,
        uint256 refundRate,
        uint256 rate,
        uint256 spreadRate,
        uint256 maxOrderNum
    )
        private
        returns (
            bool,
            uint256,
            uint256
        )
    {
        uint256 index;
        uint256 numOfOrder = orderBook.numOfOrder();
        for (
            index = initialIndex;
            index - initialIndex < maxOrderNum;
            index++
        ) {
            if (index >= numOfOrder) {
                return (true, 0, index - initialIndex);
            }
            address recipient = orderBook.recipients[index];
            _executeOrder(
                inToken,
                recipient,
                orderBook.inAmounts[recipient],
                refundRate,
                rate,
                spreadRate
            );
        }
        if (index >= numOfOrder) {
            return (true, 0, index - initialIndex);
        }
        return (false, index, index - initialIndex);
    }

    /**
     * @dev Executes each order
     * @param inToken type of token
     * @param recipient Recipient of Token
     * @param inAmount Amount of token
     * @param refundRate Refund rate in this OrderType
     * @param rate Rate of swap
     * @param spreadRate Spread rate in this box
     **/
    function _executeOrder(
        Token inToken,
        address recipient,
        uint256 inAmount,
        uint256 refundRate,
        uint256 rate,
        uint256 spreadRate
    ) internal {
        Token outToken = inToken.another();
        // refundAmount = inAmount * refundRate
        uint256 refundAmount = inAmount.mulByRate(refundRate);
        // executingInAmountWithoutSpread = (inAmount - refundAmount) / (1+spreadRate)
        uint256 executingInAmountWithoutSpread = inAmount
            .sub(refundAmount)
            .divByRate(RateMath.RATE_POINT_MULTIPLIER.add(spreadRate));
        // spread = executingInAmountWithoutSpread * spreadRate
        // = (inAmount - refundAmount ) * ( 1 - 1 /( 1 + spreadRate))
        uint256 outAmount = _otherAmountBasedOnRate(
            inToken,
            executingInAmountWithoutSpread,
            rate
        );
        _payForOrderExecution(inToken, recipient, refundAmount);
        _payForOrderExecution(outToken, recipient, outAmount);
        emit Execution(
            (inToken == Token.TOKEN0),
            uint32(_currentOpenBoxId()),
            recipient,
            inAmount,
            refundAmount,
            outAmount
        );
    }

    /**
     * @notice Updates reserves and market fee pools
     * @param spreadRate Spread rate in the box
     * @param executingAmount0WithoutSpread Executed amount of TOKEN0 in this box
     * @param executingAmount1WithoutSpread Executed amount of TOKEN1 in this box
     * @param rate Rate of swap
     **/
    function _updateReservesAndMarketFeePoolByExecution(
        uint256 spreadRate,
        uint256 executingAmount0WithoutSpread,
        uint256 executingAmount1WithoutSpread,
        uint256 rate
    ) internal virtual {
        uint256 newReserve0;
        uint256 newReserve1;
        uint256 newMarketFeePool0;
        uint256 newMarketFeePool1;
        {
            (
                uint256 differenceOfReserve,
                uint256 differenceOfMarketFee
            ) = _calculateNewReserveAndMarketFeePool(
                spreadRate,
                executingAmount0WithoutSpread,
                executingAmount1WithoutSpread,
                rate,
                Token.TOKEN0
            );
            newReserve0 = reserve0 + differenceOfReserve;
            newMarketFeePool0 = marketFeePool0 + differenceOfMarketFee;
        }
        {
            (
                uint256 differenceOfReserve,
                uint256 differenceOfMarketFee
            ) = _calculateNewReserveAndMarketFeePool(
                spreadRate,
                executingAmount1WithoutSpread,
                executingAmount0WithoutSpread,
                rate,
                Token.TOKEN1
            );
            newReserve1 = reserve1 + differenceOfReserve;
            newMarketFeePool1 = marketFeePool1 + differenceOfMarketFee;
        }
        _updateReserve(newReserve0.toUint128(), newReserve1.toUint128());
        _updateMarketFeePool(
            newMarketFeePool0.toUint128(),
            newMarketFeePool1.toUint128()
        );
    }

    function _whenToExecute(
        address recipient,
        uint256 orderTypeCount,
        uint256 boxNumber
    )
        internal
        view
        returns (
            bool isExecuted,
            uint256 boxCount,
            uint256 orderCount
        )
    {
        if (boxNumber > _currentOpenBoxId()) {
            return (false, 0, 0);
        }
        OrderBox storage yourOrderBox = orderBoxes[boxNumber];
        address[] memory recipients = yourOrderBox.orderBooks[OrderType(
            orderTypeCount
        )]
            .recipients;
        uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
        uint256 nextIndex = bookExecutionStatus.nextIndex;
        uint256 nextType = uint256(bookExecutionStatus.executingOrderType);
        bool onGoing = boxExecutionStatus.onGoing;
        bool isExist;
        uint256 place;
        for (uint256 j = 0; j != recipients.length; j++) {
            if (recipients[j] == recipient) {
                isExist = true;
                place = j;
                break;
            }
        }

        // If current box number exceeds boxNumber, the target box has already been executed
        // If current box number is equal to boxNumber, and OrderType or index exceeds that of the target order, the target box has already been executed
        if (
            (boxNumber < nextExecutingBoxId) ||
            ((onGoing && (boxNumber == nextExecutingBoxId)) &&
                ((orderTypeCount < nextType) ||
                    ((orderTypeCount == nextType) && (place < nextIndex))))
        ) {
            return (true, 0, 0);
        }

        if (!isExist) {
            return (false, 0, 0);
        }

        // Total number of orders before the target OrderType
        uint256 counts;
        if (boxNumber == nextExecutingBoxId && onGoing) {
            for (uint256 i = nextType; i < orderTypeCount; i++) {
                counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
            }
            boxCount = 1;
            orderCount = counts.add(place).sub(nextIndex) + 1;
        } else {
            for (uint256 i = 0; i != orderTypeCount; i++) {
                counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
            }
            boxCount = boxNumber.sub(nextExecutingBoxId) + 1;
            orderCount = counts.add(place) + 1;
        }
    }

    function _getReserves()
        internal
        view
        returns (uint256 _reserve0, uint256 _reserve1)
    {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }

    function _getMarketFeePools()
        internal
        view
        returns (uint256 _marketFeePool0, uint256 _marketFeePool1)
    {
        _marketFeePool0 = marketFeePool0;
        _marketFeePool1 = marketFeePool1;
    }

    function _updateReserve(uint128 newReserve0, uint128 newReserve1) internal {
        reserve0 = newReserve0;
        reserve1 = newReserve1;
        emit UpdateReserve(newReserve0, newReserve1, totalSupply());
    }

    function _calculatePriceWrapper(
        uint256 flexToken0InWithoutSpread,
        uint256 strictToken0InWithoutSpread,
        uint256 flexToken1InWithoutSpread,
        uint256 strictToken1InWithoutSpread,
        uint256 _reserve0,
        uint256 _reserve1
    )
        internal
        view
        returns (
            uint256 rate,
            uint256 refundStatus,
            uint256 partiallyRefundRate,
            uint256 executingAmount0,
            uint256 executingAmount1
        )
    {
        uint256[5] memory data = priceCalc.calculatePrice(
            flexToken0InWithoutSpread,
            strictToken0InWithoutSpread,
            flexToken1InWithoutSpread,
            strictToken1InWithoutSpread,
            _reserve0,
            _reserve1
        );
        return (data[0], data[1], data[2], data[3], data[4]);
    }

    /**
     * @param rate0Per1 Token0 / Token1 * RATE_POINT_MULTIPLIER
     */
    function _otherAmountBasedOnRate(
        Token token,
        uint256 amount,
        uint256 rate0Per1
    ) internal pure returns (uint256) {
        if (token == Token.TOKEN0) {
            return amount.mulByRate(rate0Per1);
        } else {
            return amount.divByRate(rate0Per1);
        }
    }

    function _currentOpenBoxId() internal view returns (uint256) {
        return orderBoxes.length - 1;
    }

    /**
     * @notice Gets OrderType in uint
     **/
    function _getOrderType(bool isBuy, bool isLimit)
        internal
        pure
        returns (uint256 orderTypeCount)
    {
        if (isBuy && isLimit) {
            orderTypeCount = 2;
        } else if (!isBuy) {
            if (isLimit) {
                orderTypeCount = 3;
            } else {
                orderTypeCount = 1;
            }
        }
    }

    function _updateMarketFeePool(
        uint128 newMarketFeePool0,
        uint128 newMarketFeePool1
    ) private {
        marketFeePool0 = newMarketFeePool0;
        marketFeePool1 = newMarketFeePool1;
    }

    function _calculateAmounts(
        uint256 amount,
        uint256 _reserve0,
        uint256 _reserve1,
        Token tokenType
    )
        private
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        if (tokenType == Token.TOKEN0) {
            return (
                amount,
                amount.mul(_reserve1).div(_reserve0),
                amount.mul(totalSupply()).div(_reserve0)
            );
        } else {
            return (
                amount.mul(_reserve0).div(_reserve1),
                amount,
                amount.mul(totalSupply()).div(_reserve1)
            );
        }
    }

    function _priceCalculateRates(
        OrderBox storage orderBox,
        uint256 totalInAmountFLEX_0_1,
        uint256 totalInAmountFLEX_1_0,
        uint256 totalInAmountSTRICT_0_1,
        uint256 totalInAmountSTRICT_1_0
    )
        private
        view
        returns (
            uint256 rate,
            uint256 refundStatus,
            uint256 partiallyRefundRate,
            uint256 executingAmount0,
            uint256 executingAmount1
        )
    {
        uint256 withoutSpreadRate = RateMath.RATE_POINT_MULTIPLIER +
            orderBox.spreadRate;
        return
            _calculatePriceWrapper(
                totalInAmountFLEX_0_1.divByRate(withoutSpreadRate),
                totalInAmountSTRICT_0_1.divByRate(withoutSpreadRate),
                totalInAmountFLEX_1_0.divByRate(withoutSpreadRate),
                totalInAmountSTRICT_1_0.divByRate(withoutSpreadRate),
                reserve0,
                reserve1
            );
    }

    function _getExecutionRatesAndUpdateReserve(uint32 boxNumber)
        private
        returns (
            OrderType partiallyRefundOrderType,
            uint256 partiallyRefundRate,
            uint256 rate
        )
    {
        OrderBox storage orderBox = orderBoxes[boxNumber];
        // `refundStatus`
        // 0 => no_refund
        // 1 => refund some of strictToken0
        // 2 => refund all strictToken0 and some of flexToken0
        // 3 => refund some of strictToken1
        // 4 => refund all strictToken1 and some of flexToken1
        uint256 refundStatus;
        uint256 executingAmount0WithoutSpread;
        uint256 executingAmount1WithoutSpread;
        uint256 totalInAmountFLEX_0_1 = orderBox.orderBooks[OrderType.FLEX_0_1]
            .totalInAmount;
        uint256 totalInAmountFLEX_1_0 = orderBox.orderBooks[OrderType.FLEX_1_0]
            .totalInAmount;
        uint256 totalInAmountSTRICT_0_1 = orderBox.orderBooks[OrderType
            .STRICT_0_1]
            .totalInAmount;
        uint256 totalInAmountSTRICT_1_0 = orderBox.orderBooks[OrderType
            .STRICT_1_0]
            .totalInAmount;
        (
            rate,
            refundStatus,
            partiallyRefundRate,
            executingAmount0WithoutSpread,
            executingAmount1WithoutSpread
        ) = _priceCalculateRates(
            orderBox,
            totalInAmountFLEX_0_1,
            totalInAmountFLEX_1_0,
            totalInAmountSTRICT_0_1,
            totalInAmountSTRICT_1_0
        );

        {
            if (refundStatus == 0) {
                partiallyRefundOrderType = OrderType.STRICT_0_1;
                //refundRate = 0;
            } else if (refundStatus == 1) {
                partiallyRefundOrderType = OrderType.STRICT_0_1;
            } else if (refundStatus == 2) {
                partiallyRefundOrderType = OrderType.FLEX_0_1;
            } else if (refundStatus == 3) {
                partiallyRefundOrderType = OrderType.STRICT_1_0;
            } else if (refundStatus == 4) {
                partiallyRefundOrderType = OrderType.FLEX_1_0;
            }
        }
        emit ExecutionSummary(
            boxNumber,
            uint8(partiallyRefundOrderType),
            rate,
            partiallyRefundRate,
            totalInAmountFLEX_0_1,
            totalInAmountFLEX_1_0,
            totalInAmountSTRICT_0_1,
            totalInAmountSTRICT_1_0
        );
        _updateReservesAndMarketFeePoolByExecution(
            orderBox.spreadRate,
            executingAmount0WithoutSpread,
            executingAmount1WithoutSpread,
            rate
        );
    }

    /**
     * @notice Detects if this OrderBox is finished
     * @param orders Target OrderBox
     * @param lastFinishedOrderType Latest OrderType which is executed
     **/
    function _isBoxFinished(
        OrderBox storage orders,
        OrderType lastFinishedOrderType
    ) private view returns (bool) {
        // If orderType is STRICT_1_0, no book is left
        if (lastFinishedOrderType == OrderType.STRICT_1_0) {
            return true;
        }
        for (uint256 i = uint256(lastFinishedOrderType.next()); i != 4; i++) {
            OrderBook memory book = orders.orderBooks[OrderType(i)];
            // If OrderBook has some order return false
            if (book.numOfOrder() != 0) {
                return false;
            }
        }
        return true;
    }

    function _calculateNewReserveAndMarketFeePool(
        uint256 spreadRate,
        uint256 executingAmountWithoutSpread,
        uint256 anotherExecutingAmountWithoutSpread,
        uint256 rate,
        Token tokenType
    ) internal returns (uint256, uint256) {
        uint256 totalSpread = executingAmountWithoutSpread.mulByRate(
            spreadRate
        );
        uint256 marketFee = totalSpread.mulByRate(MARKET_FEE_RATE);
        uint256 newReserve = executingAmountWithoutSpread +
            (totalSpread - marketFee) -
            _otherAmountBasedOnRate(
                tokenType.another(),
                anotherExecutingAmountWithoutSpread,
                rate
            );
        return (newReserve, marketFee);
    }

    function _getTokenType(bool isBuy, bool isStrict)
        internal
        pure
        returns (OrderType)
    {
        if (isBuy) {
            if (isStrict) {
                return OrderType.STRICT_0_1;
            } else {
                return OrderType.FLEX_0_1;
            }
        } else {
            if (isStrict) {
                return OrderType.STRICT_1_0;
            } else {
                return OrderType.FLEX_1_0;
            }
        }
    }
}

// File: contracts/Interfaces/ERC20Interface.sol

pragma solidity >=0.6.6;


interface ERC20Interface is IERC20 {
    function name() external view returns (string memory);
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

// SPDX-License-Identifier: MIT

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

// File: contracts/Interfaces/OracleInterface.sol

pragma solidity >=0.6.6;

interface OracleInterface {
    function latestPrice() external returns (uint256);

    function getVolatility() external returns (uint256);

    function latestId() external returns (uint256);
}

// File: contracts/Interfaces/SpreadCalculatorInterface.sol

pragma solidity >=0.6.6;


interface SpreadCalculatorInterface {
    function calculateCurrentSpread(
        uint256 _maturity,
        uint256 _strikePrice,
        OracleInterface oracle
    ) external returns (uint128);

    function calculateSpreadByAssetVolatility(OracleInterface oracle)
        external
        returns (uint128);
}

// File: contracts/BoxExchange/TokenBoxExchange/TokenBoxExchange.sol

pragma solidity >=0.6.6;






abstract contract TokenBoxExchange is BoxExchange {
    using SafeERC20 for ERC20Interface;

    ERC20Interface public immutable idol; // token0
    ERC20Interface public immutable token;
    SpreadCalculatorInterface internal immutable spreadCalc;
    OracleInterface internal immutable oracle;

    event SpreadRate(uint128 indexed boxNumber, uint128 spreadRate);

    /**
     * @param _idol iDOL contract
     * @param _token ERC20 contract
     * @param _priceCalc Price Calculator contract
     * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
     * @param _spreadCalc Spread Calculator contract
     * @param _oracle Oracle contract
     * @param _name Name of share token
     **/
    constructor(
        ERC20Interface _idol,
        ERC20Interface _token,
        PriceCalculatorInterface _priceCalc,
        address _marketFeeTaker,
        SpreadCalculatorInterface _spreadCalc,
        OracleInterface _oracle,
        string memory _name
    ) public BoxExchange(_priceCalc, _marketFeeTaker, _name) {
        idol = _idol;
        token = _token;
        spreadCalc = _spreadCalc;
        oracle = _oracle;
    }

    /**
     * @param IDOLAmount Amount of initial liquidity of iDOL to be provided
     * @param settlementTokenAmount Amount of initial liquidity of the other token to be provided
     * @param initialShare Initial amount of share token
     **/
    function initializeExchange(
        uint256 IDOLAmount,
        uint256 settlementTokenAmount,
        uint256 initialShare
    ) external {
        _init(
            uint128(IDOLAmount),
            uint128(settlementTokenAmount),
            initialShare
        );
    }

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
    ) external isAmountSafe(IDOLAmount) isInTime(timeout) {
        OrderType orderType = _getTokenType(true, isLimit);
        _addOrder(orderType, IDOLAmount, recipient);
    }

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
    ) external isAmountSafe(settlementTokenAmount) isInTime(timeout) {
        OrderType orderType = _getTokenType(false, isLimit);
        _addOrder(orderType, settlementTokenAmount, recipient);
    }

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
    )
        external
        isAmountSafe(IDOLAmount)
        isAmountSafe(settlementTokenAmount)
        isInTime(timeout)
    {
        require(timeout > _currentOpenBoxId(), "Time out");
        (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
        uint256 settlementAmountInBase = settlementTokenAmount
            .mul(_reserve0)
            .div(_reserve1);
        if (IDOLAmount <= settlementAmountInBase) {
            _addLiquidity(
                _reserve0,
                _reserve1,
                IDOLAmount,
                minShares,
                Token.TOKEN0
            );
        } else {
            _addLiquidity(
                _reserve0,
                _reserve1,
                settlementTokenAmount,
                minShares,
                Token.TOKEN1
            );
        }
    }

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
    ) external isInTime(timeout) {
        require(timeout > _currentOpenBoxId(), "Time out");
        _removeLiquidity(minBaseTokens, minSettlementTokens, sharesBurned);
    }

    /**
     * @notice Executes orders that are unexecuted
     * @param maxOrderNum Max number of orders to be executed
     **/
    function executeUnexecutedBox(uint8 maxOrderNum) external {
        _triggerExecuteOrders(maxOrderNum);
    }

    /**
     * @notice Sends market fee to Lien Token
     **/
    function sendMarketFeeToLien() external {
        _triggerPayMarketFee();
    }

    // definition of abstract functions

    function _receiveTokens(
        Token tokenType,
        address from,
        uint256 amount
    ) internal override {
        _IERC20(tokenType).safeTransferFrom(from, address(this), amount);
    }

    function _sendTokens(
        Token tokenType,
        address to,
        uint256 amount
    ) internal override {
        _IERC20(tokenType).safeTransfer(to, amount);
    }

    function _payForOrderExecution(
        Token tokenType,
        address to,
        uint256 amount
    ) internal override {
        _IERC20(tokenType).safeTransfer(to, amount);
    }

    function _isCurrentOpenBoxExpired() internal override view returns (bool) {
        return block.number >= orderBoxes[_currentOpenBoxId()].expireAt;
    }

    function _openNewBox() internal override(BoxExchange) {
        super._openNewBox();
        uint256 _boxNumber = _currentOpenBoxId();
        emit SpreadRate(
            _boxNumber.toUint128(),
            orderBoxes[_boxNumber].spreadRate
        );
    }

    function _IERC20(Token tokenType) internal view returns (ERC20Interface) {
        if (tokenType == Token.TOKEN0) {
            return idol;
        }
        return token;
    }
}

// File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/ERC20BoxExchange.sol

pragma solidity >=0.6.6;


contract ERC20BoxExchange is TokenBoxExchange {
    /**
     * @param _idol iDOL contract
     * @param _token ERC20 contract
     * @param _priceCalc Price Calculator contract
     * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
     * @param _spreadCalc Spread Calculator contract
     * @param _oracle Oracle contract
     * @param _name Name of share token
     **/
    constructor(
        ERC20Interface _idol,
        ERC20Interface _token,
        PriceCalculatorInterface _priceCalc,
        address _marketFeeTaker,
        SpreadCalculatorInterface _spreadCalc,
        OracleInterface _oracle,
        string memory _name
    )
        public
        TokenBoxExchange(
            _idol,
            _token,
            _priceCalc,
            _marketFeeTaker,
            _spreadCalc,
            _oracle,
            _name
        )
    {}

    // definition of abstract functions
    function _feeRate() internal override returns (uint128) {
        return spreadCalc.calculateSpreadByAssetVolatility(oracle);
    }

    function _payMarketFee(
        address _marketFeeTaker,
        uint256 amount0,
        uint256 amount1
    ) internal override {
        if (amount0 != 0) {
            idol.safeTransfer(_marketFeeTaker, amount0);
        }
    }

    /**
     * @notice Updates reserves and market fee pools
     * @param spreadRate Spread rate in the box
     * @param executingAmount0WithoutSpread Executed amount of TOKEN0 in this box
     * @param executingAmount1WithoutSpread Executed amount of TOKEN1 in this box
     * @param rate Rate of swap
     **/
    function _updateReservesAndMarketFeePoolByExecution(
        uint256 spreadRate,
        uint256 executingAmount0WithoutSpread,
        uint256 executingAmount1WithoutSpread,
        uint256 rate
    ) internal virtual override {
        uint256 newReserve0;
        uint256 newReserve1;
        uint256 newMarketFeePool0;
        uint256 marketFee1;
        {
            (
                uint256 differenceOfReserve,
                uint256 differenceOfMarketFee
            ) = _calculateNewReserveAndMarketFeePool(
                spreadRate,
                executingAmount0WithoutSpread,
                executingAmount1WithoutSpread,
                rate,
                Token.TOKEN0
            );
            newReserve0 = reserve0 + differenceOfReserve;
            newMarketFeePool0 = marketFeePool0 + differenceOfMarketFee;
        }
        {
            (newReserve1, marketFee1) = _calculateNewReserveAndMarketFeePool(
                spreadRate,
                executingAmount1WithoutSpread,
                executingAmount0WithoutSpread,
                rate,
                Token.TOKEN1
            );
            newReserve1 = newReserve1 + reserve1;
        }

        {
            uint256 convertedSpread1to0 = marketFee1
                .mulByRate(newReserve0.divByRate(newReserve1.add(marketFee1)))
                .divByRate(RateMath.RATE_POINT_MULTIPLIER);
            newReserve1 = newReserve1 + marketFee1;
            newReserve0 = newReserve0 - convertedSpread1to0;
            newMarketFeePool0 = newMarketFeePool0 + convertedSpread1to0;
        }
        _updateReserve(newReserve0.toUint128(), newReserve1.toUint128());
        _updateMarketFeePool(newMarketFeePool0.toUint128());
    }

    /**
     * updates only pool0
     */
    function _updateMarketFeePool(uint256 newMarketFeePool0) internal {
        marketFeePool0 = newMarketFeePool0.toUint128();
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

// File: @openzeppelin/contracts/utils/Arrays.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


/**
 * @dev Collection of functions related to array types.
 */
library Arrays {
   /**
     * @dev Searches a sorted `array` and returns the first index that contains
     * a value greater or equal to `element`. If no such index exists (i.e. all
     * values in the array are strictly less than `element`), the array length is
     * returned. Time complexity O(log n).
     *
     * `array` is expected to be sorted in ascending order, and to contain no
     * repeated elements.
     */
    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        if (array.length == 0) {
            return 0;
        }

        uint256 low = 0;
        uint256 high = array.length;

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds down (it does integer division with truncation).
            if (array[mid] > element) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
        if (low > 0 && array[low - 1] == element) {
            return low - 1;
        } else {
            return low;
        }
    }
}

// File: @openzeppelin/contracts/utils/Counters.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        // The {SafeMath} overflow check can be skipped here, see the comment at the top
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;





/**
 * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
 * total supply at the time are recorded for later access.
 *
 * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
 * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
 * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
 * used to create an efficient ERC20 forking mechanism.
 *
 * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
 * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
 * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
 * and the account address.
 *
 * ==== Gas Costs
 *
 * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
 * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
 * smaller since identical balances in subsequent snapshots are stored as a single entry.
 *
 * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
 * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
 * transfers will have normal cost until the next snapshot, and so on.
 */
abstract contract ERC20Snapshot is ERC20 {
    // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
    // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol

    using SafeMath for uint256;
    using Arrays for uint256[];
    using Counters for Counters.Counter;

    // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
    // Snapshot struct, but that would impede usage of functions that work on an array.
    struct Snapshots {
        uint256[] ids;
        uint256[] values;
    }

    mapping (address => Snapshots) private _accountBalanceSnapshots;
    Snapshots private _totalSupplySnapshots;

    // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
    Counters.Counter private _currentSnapshotId;

    /**
     * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
     */
    event Snapshot(uint256 id);

    /**
     * @dev Creates a new snapshot and returns its snapshot id.
     *
     * Emits a {Snapshot} event that contains the same id.
     *
     * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
     * set of accounts, for example using {AccessControl}, or it may be open to the public.
     *
     * [WARNING]
     * ====
     * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
     * you must consider that it can potentially be used by attackers in two ways.
     *
     * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
     * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
     * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
     * section above.
     *
     * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
     * ====
     */
    function _snapshot() internal virtual returns (uint256) {
        _currentSnapshotId.increment();

        uint256 currentId = _currentSnapshotId.current();
        emit Snapshot(currentId);
        return currentId;
    }

    /**
     * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
     */
    function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);

        return snapshotted ? value : balanceOf(account);
    }

    /**
     * @dev Retrieves the total supply at the time `snapshotId` was created.
     */
    function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);

        return snapshotted ? value : totalSupply();
    }

    // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
    // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
    // The same is true for the total supply and _mint and _burn.
    function _transfer(address from, address to, uint256 value) internal virtual override {
        _updateAccountSnapshot(from);
        _updateAccountSnapshot(to);

        super._transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal virtual override {
        _updateAccountSnapshot(account);
        _updateTotalSupplySnapshot();

        super._mint(account, value);
    }

    function _burn(address account, uint256 value) internal virtual override {
        _updateAccountSnapshot(account);
        _updateTotalSupplySnapshot();

        super._burn(account, value);
    }

    function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
        private view returns (bool, uint256)
    {
        require(snapshotId > 0, "ERC20Snapshot: id is 0");
        // solhint-disable-next-line max-line-length
        require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");

        // When a valid snapshot is queried, there are three possibilities:
        //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
        //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
        //  to this id is the current one.
        //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
        //  requested id, and its value is the one to return.
        //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
        //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
        //  larger than the requested one.
        //
        // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
        // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
        // exactly this.

        uint256 index = snapshots.ids.findUpperBound(snapshotId);

        if (index == snapshots.ids.length) {
            return (false, 0);
        } else {
            return (true, snapshots.values[index]);
        }
    }

    function _updateAccountSnapshot(address account) private {
        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
    }

    function _updateTotalSupplySnapshot() private {
        _updateSnapshot(_totalSupplySnapshots, totalSupply());
    }

    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
        uint256 currentId = _currentSnapshotId.current();
        if (_lastSnapshotId(snapshots.ids) < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }

    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
        if (ids.length == 0) {
            return 0;
        } else {
            return ids[ids.length - 1];
        }
    }
}

// File: contracts/Interfaces/LienTokenInterface.sol

pragma solidity >=0.6.6;


interface LienTokenInterface is IERC20 {
    function currentTerm() external view returns (uint256);

    function expiration() external view returns (uint256);

    function receiveDividend(address token, address recipient) external;

    function dividendAt(
        address token,
        address account,
        uint256 term
    ) external view returns (uint256);
}

// File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/IDOLvsLien/ERC20Redistribution.sol

pragma solidity >=0.6.6;






abstract contract ERC20Redistribution is ERC20Snapshot {
    using SafeERC20 for ERC20Interface;

    struct Dividend {
        mapping(ERC20Interface => uint256) tokens;
        uint256 eth;
    }

    LienTokenInterface public lien;
    mapping(uint256 => uint256) private snapshotsOfTermEnd;
    mapping(uint256 => Dividend) private totalDividendsAt;
    mapping(address => mapping(ERC20Interface => uint256))
        private lastReceivedTermsOfTokens;
    mapping(address => uint256) private lastReceivedTermsOfEth;

    event ReceiveDividendETH(address indexed recipient, uint256 amount);
    event ReceiveDividendToken(
        address indexed recipient,
        address indexed tokenAddress,
        uint256 amount
    );

    modifier termValidation(uint256 _term) {
        require(_term > 0, "0 is invalid value as term");
        _;
    }

    receive() external payable {}

    constructor(LienTokenInterface _lien) public {
        lien = _lien;
    }

    /**
     * @notice Transfers ERC20 token dividend to Liquidity Provider
     * @notice Before transfer dividend, this exchange withdraws dividend in this ERC20 token from Lien Token
     * @param token Target ERC20 token to be received
     */
    function receiveDividendToken(ERC20Interface token) public {
        uint256 _currentTerm = currentTerm();
        if (_currentTerm == 1) {
            return;
        }
        _moveDividendTokenFromLIEN(token, _currentTerm);
        uint256 lastReceivedTerm = lastReceivedTermsOfTokens[msg.sender][token];
        lastReceivedTermsOfTokens[msg.sender][token] = _currentTerm - 1;
        uint256 dividend;
        for (uint256 term = lastReceivedTerm + 1; term < _currentTerm; term++) {
            dividend += dividendTokenAt(msg.sender, token, term);
        }
        emit ReceiveDividendToken(msg.sender, address(token), dividend);
        token.safeTransfer(msg.sender, dividend);
    }

    /**
     * @notice Transfers ETH dividend to Liquidity Provider
     * @notice Before transfer dividend, this exchange withdraws dividend in ETH from Lien Token
     */
    function receiveDividendEth() public {
        uint256 _currentTerm = currentTerm();
        if (_currentTerm == 1) {
            return;
        }
        _moveDividendEthFromLIEN(_currentTerm);
        uint256 lastReceivedTerm = lastReceivedTermsOfEth[msg.sender];
        lastReceivedTermsOfEth[msg.sender] = _currentTerm - 1;
        uint256 dividend;
        for (uint256 term = lastReceivedTerm + 1; term < _currentTerm; term++) {
            dividend += dividendEthAt(msg.sender, term);
        }
        emit ReceiveDividendETH(msg.sender, dividend);
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = msg.sender.call{value: dividend}("");
        require(success, "ETH transfer failed");
    }

    /**
     * @notice Gets current term in Lien Token
     **/
    function currentTerm() public view returns (uint256) {
        return lien.currentTerm();
    }

    /**
     * @notice Gets amount of ERC20 token dividend LP can get in the `term`
     * @param account Target account
     * @param token Target ERC20 token
     * @param term Target term
     **/
    function dividendTokenAt(
        address account,
        ERC20Interface token,
        uint256 term
    ) public view returns (uint256) {
        uint256 balanceAtTermEnd = balanceOfAtTermEnd(account, term);
        uint256 totalSupplyAtTermEnd = totalSupplyAtTermEnd(term);
        uint256 totalDividend = totalDividendTokenAt(token, term);
        return totalDividend.mul(balanceAtTermEnd).div(totalSupplyAtTermEnd);
    }

    /**
     * @notice Gets Amount of ETH dividend LP can get in the `term`
     * @param account Target account
     * @param term Target term
     **/
    function dividendEthAt(address account, uint256 term)
        public
        view
        returns (uint256)
    {
        uint256 balanceAtTermEnd = balanceOfAtTermEnd(account, term);
        uint256 totalSupplyAtTermEnd = totalSupplyAtTermEnd(term);
        uint256 totalDividend = totalDividendEthAt(term);
        return totalDividend.mul(balanceAtTermEnd).div(totalSupplyAtTermEnd);
    }

    /**
     * @notice Gets total amount of ERC20 token dividend this exchange received in the `term`
     * @param token Target ERC20 token
     * @param term Target term
     **/
    function totalDividendTokenAt(ERC20Interface token, uint256 term)
        public
        view
        returns (uint256)
    {
        return totalDividendsAt[term].tokens[token];
    }

    /**
     * @notice Gets total amount of ETH dividend this exchange received in the `term`
     * @param term Target term
     **/
    function totalDividendEthAt(uint256 term) public view returns (uint256) {
        return totalDividendsAt[term].eth;
    }

    /**
     * @notice Retrieves the balance of `account` at the end of the term `term`
     * @param account Target account
     * @param term Target term
     */
    function balanceOfAtTermEnd(address account, uint256 term)
        public
        view
        termValidation(term)
        returns (uint256)
    {
        uint256 _currentTerm = currentTerm();
        for (uint256 i = term; i < _currentTerm; i++) {
            if (_isSnapshottedOnTermEnd(i)) {
                return balanceOfAt(account, snapshotsOfTermEnd[i]);
            }
        }
        return balanceOf(account);
    }

    /**
     * @notice Retrieves the total supply at the end of the term `term`
     * @param term Target term
     */
    function totalSupplyAtTermEnd(uint256 term)
        public
        view
        termValidation(term)
        returns (uint256)
    {
        uint256 _currentTerm = currentTerm();
        for (uint256 i = term; i < _currentTerm; i++) {
            if (_isSnapshottedOnTermEnd(i)) {
                return totalSupplyAt(snapshotsOfTermEnd[i]);
            }
        }
        return totalSupply();
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        _snapshotOnTermEnd();
        super._transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal virtual override {
        _snapshotOnTermEnd();
        super._mint(account, value);
    }

    function _burn(address account, uint256 value) internal virtual override {
        _snapshotOnTermEnd();
        super._burn(account, value);
    }

    function _snapshotOnTermEnd() private {
        uint256 _currentTerm = currentTerm();
        if (_currentTerm > 1 && !_isSnapshottedOnTermEnd(_currentTerm - 1)) {
            snapshotsOfTermEnd[_currentTerm - 1] = _snapshot();
        }
    }

    function _isSnapshottedOnTermEnd(uint256 term) private view returns (bool) {
        return snapshotsOfTermEnd[term] != 0;
    }

    /**
     * @notice Withdraws dividends in ETH and iDOL from Lien Token
     * @dev At first, this function registers amount of dividends from Lien Token, and thereafter withdraws it
     **/
    function _moveDividendTokenFromLIEN(
        ERC20Interface token,
        uint256 _currentTerm
    ) private {
        uint256 expiration = lien.expiration();
        uint256 start;
        uint256 totalNewDividend;
        if (_currentTerm > expiration) {
            start = _currentTerm - expiration;
        } else {
            start = 1;
        }
        //get and register dividend amount in the exchange from Lien Token contract
        for (uint256 i = _currentTerm - 1; i >= start; i--) {
            if (totalDividendsAt[i].tokens[token] != 0) {
                break;
            }
            uint256 dividend = lien.dividendAt(
                address(token),
                address(this),
                i
            );
            totalDividendsAt[i].tokens[token] = dividend;
            totalNewDividend += dividend;
        }
        if (totalNewDividend == 0) {
            return;
        }
        lien.receiveDividend(address(token), address(this));
    }

    /**
     * @notice Withdraws dividends in ETH and iDOL from lienToken
     * @dev At first, this function registers amount of dividend from Lien Token, and thereafter withdraws it
     **/
    function _moveDividendEthFromLIEN(uint256 _currentTerm) private {
        uint256 expiration = lien.expiration();
        uint256 start;
        uint256 totalNewDividend;
        if (_currentTerm > expiration) {
            start = _currentTerm - expiration;
        } else {
            start = 1;
        }
        //get and register dividend amount in the exchange from Lien Token contract
        for (uint256 i = _currentTerm - 1; i >= start; i--) {
            if (totalDividendsAt[i].eth != 0) {
                break;
            }
            uint256 dividend = lien.dividendAt(address(0), address(this), i);
            totalDividendsAt[i].eth = dividend;
            totalNewDividend += dividend;
        }
        if (totalNewDividend == 0) {
            return;
        }
        lien.receiveDividend(address(0), address(this));
    }
}

// File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/IDOLvsLien/LienBoxExchange.sol

pragma solidity >=0.6.6;



contract LienBoxExchange is ERC20BoxExchange, ERC20Redistribution {
    /**
     * @param _idol iDOL contract
     * @param _priceCalc Price Calculator contract
     * @param _lien Lien Token contract
     * @param _spreadCalc Spread Calculator contract
     * @param _name Name of share token
     **/
    constructor(
        ERC20Interface _idol,
        PriceCalculatorInterface _priceCalc,
        LienTokenInterface _lien,
        SpreadCalculatorInterface _spreadCalc,
        string memory _name
    )
        public
        ERC20Redistribution(_lien)
        ERC20BoxExchange(
            _idol,
            ERC20Interface(address(_lien)),
            _priceCalc,
            address(_lien),
            _spreadCalc,
            OracleInterface(address(0)),
            _name
        )
    {}

    // overriding ERC20 functions
    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Redistribution) {
        ERC20Redistribution._transfer(from, to, value);
    }

    function _burn(address account, uint256 value)
        internal
        override(ERC20, ERC20Redistribution)
    {
        ERC20Redistribution._burn(account, value);
    }

    function _mint(address account, uint256 value)
        internal
        override(ERC20, ERC20Redistribution)
    {
        ERC20Redistribution._mint(account, value);
    }
}