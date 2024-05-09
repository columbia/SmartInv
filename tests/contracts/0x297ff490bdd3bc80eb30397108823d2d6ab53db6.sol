pragma solidity 0.6.2;


// SPDX-License-Identifier: MIT
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

// SPDX-License-Identifier: MIT
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

// SPDX-License-Identifier: MIT
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

// SPDX-License-Identifier: MIT
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

// SPDX-License-Identifier: MIT
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

// SPDX-License-Identifier: MIT
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
 * @title KiraAuction
 * @dev Liquidity Auction Contract for the final round of the KEX token distribution.
 *
 * The Liquidity Auction works in the similar fashion to the Polkadot Reverse Dutch auction
 * with the difference that in case of oversubscription all tokens that overflowed the hard
 * cap would be used to add liquidity to the uniswap or as MM war chest in case of listing
 * to support price on the market.
 *
 * Reverse Dutch auction starts with a very very high initial valuation that cannot possibly
 * be fulfilled and decreases towards predefined valuation at predefined rate. Auction ends
 * instantly if value of assets deposited is greater or equals to the valuation, or if auction
 * times out.
 */
contract KiraAuction is Ownable {
    using SafeMath for uint256;

    /* 
        Configurable
        P1, P2, P3, T1, T2, Auction Start, Tx rate limiting, Tx size per time limit, whitelist
    */

    struct UserInfo {
        bool whitelisted;
        uint256 claimed_wei;
        uint256 last_deposit_time;
        bool claimed;
        bool distributed;
    }

    uint256 public startTime;
    uint256 private P1;
    uint256 private P2;
    uint256 private P3;
    uint256 private T1;
    uint256 private T2;
    uint256 private MIN_WEI;
    uint256 private MAX_WEI;
    uint256 private INTERVAL_LIMIT;
    uint256 private totalWeiAmount;
    uint256 public latestPrice;

    address payable public wallet;
    bool public isFinished;
    ERC20 private kiraToken;
    mapping(address => UserInfo) private customers;
    address[] private arrayAddress;

    // Events
    event AuctionConfigured(uint256 _startTime);
    event WhitelistConfigured(address[] addrs, bool allow);
    event ProcessedBuy(address addr, uint256 amount);
    event ClaimedTokens(address addr, uint256 amount);
    event DistributeTokens(uint256 distributedAmount);
    event WithdrawedFunds(address _wallet, uint256 ethAmount, uint256 kexAmount);

    // MODIFIERS

    modifier onlyInProgress() {
        require(startTime != 0, 'KiraAuction: start time is not configured yet. So not in progress.');
        require((startTime <= now) && (now <= startTime + T1 + T2), 'KiraAuction: it is out of processing period.');
        uint256 cap = _getCurrentCap();
        require(cap >= totalWeiAmount, 'KiraAuction: overflowed the cap, so it is ended');
        _;
    }

    modifier onlyBeforeAuction() {
        require(startTime == 0 || (now < startTime), 'KiraAuction: should be before auction starts');
        _;
    }

    modifier onlyAfterAuction() {
        uint256 cap;
        if (isFinished == false) {
            cap = _getCurrentCap();
        }
        require(
            isFinished || (startTime != 0 && ((startTime + T1 + T2 < now) || (cap < totalWeiAmount))),
            'KiraAuction: should be after auction ends'
        );
        if (isFinished == false) {
            isFinished = true;
        }
        _;
    }

    // Constructor

    constructor(address _kiraTokenAddr) public {
        kiraToken = ERC20(_kiraTokenAddr);
        wallet = msg.sender;
    }

    // External Views

    function getTokenContractAddress() external view returns (address) {
        return address(kiraToken);
    }

    function totalDeposited() external view returns (uint256) {
        return totalWeiAmount;
    }

    function whitelisted(address addr) external view returns (bool) {
        return customers[addr].whitelisted;
    }

    function getCustomerInfo(address addr)
        external
        view
        returns (
            bool,
            uint256,
            uint256,
            bool,
            bool
        )
    {
        UserInfo storage customer = customers[addr];
        return (customer.whitelisted, customer.claimed_wei, customer.last_deposit_time, customer.claimed, customer.distributed);
    }

    function getAuctionConfigInfo()
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (startTime, P1, P2, P3, T1, T2, INTERVAL_LIMIT, MIN_WEI, MAX_WEI);
    }

    // Internal

    function _getCurrentAuctionPrice() internal returns (uint256) {
        /*     ^
            P1 |        *
               |        '*
               |        ' *
               |        '  *
            P2 |        '   *
               |        '   '   *
               |        '   '       *
               |        '   '           *
            P3 |        '   '               *
               |        '   '               '   
               |--------|---|---------------|------------------> Timeline
                          T1       T2
        */

        uint256 price = 0;

        if ((startTime <= now) && (now < startTime + T1)) {
            // Slope 1
            // y = p1 - (x * (p1 - p2) / t1)

            uint256 x = now - startTime;
            uint256 delta = x.mul(P1 - P2).div(T1);

            price = P1.sub(delta);
        } else if ((startTime + T1 <= now) && (now <= startTime + T1 + T2)) {
            // Slope 2
            // y = p2 - (x * (p2 - p3) / t2)
            uint256 x = now - startTime - T1;
            uint256 delta = x.mul(P2 - P3).div(T2);

            price = P2.sub(delta);
        }

        return price;
    }

    function _getCurrentCap() internal returns (uint256) {
        uint256 price = _getCurrentAuctionPrice();
        uint256 exp = 10**uint256(kiraToken.decimals());
        uint256 numberOfTokens = kiraToken.balanceOf(address(this)).div(exp);
        uint256 cap = price.mul(numberOfTokens);

        return cap;
    }

    function getAvailableClaimAmount() external onlyAfterAuction returns (uint256) {
        UserInfo memory customer = customers[msg.sender];
        require(customer.whitelisted && (customer.claimed_wei > 0), 'KiraAuction: you did not contribute.');
        require(!customer.claimed, 'KiraAuction: you already claimed.');
        require(!customer.distributed, 'KiraAuction: we already sent to your wallet.');

        uint256 exp = 10**uint256(kiraToken.decimals());
        uint256 amountToClaim = customer.claimed_wei.mul(exp).div(latestPrice);
        return amountToClaim;
    }

    // Auction Config Method only for owner. only before auction

    function setTokenContract(address _kiraTokenAddr) external onlyOwner onlyBeforeAuction {
        kiraToken = ERC20(_kiraTokenAddr);
    }

    function setWallet(address payable _wallet) external onlyOwner onlyBeforeAuction {
        wallet = _wallet;
    }

    function configAuction(
        uint256 _startTime,
        uint256 _p1,
        uint256 _p2,
        uint256 _p3,
        uint256 _t1,
        uint256 _t2,
        uint256 _txIntervalLimit,
        uint256 _txMinWeiAmount,
        uint256 _txMaxWeiAmount
    ) external onlyOwner onlyBeforeAuction {
        require(_startTime > now, 'KiraAuction: start time should be greater than now');
        require((_p1 > _p2) && (_p2 > _p3) && (_p3 >= 0), 'KiraAuction: price should go decreasing.');
        require(
            _t2 > _t1 && _t1 > 0,
            'KiraAuction: the first slope should have faster decreasing rate and the period of each slope should be greater than zero'
        );
        require(_txMaxWeiAmount > 0, 'KiraAuction: the maximum amount per tx should be valid');

        startTime = _startTime;
        P1 = _p1;
        P2 = _p2;
        P3 = _p3;
        T1 = _t1;
        T2 = _t2;
        INTERVAL_LIMIT = _txIntervalLimit;
        MIN_WEI = _txMinWeiAmount;
        MAX_WEI = _txMaxWeiAmount;

        emit AuctionConfigured(startTime);
    }

    function whitelist(address[] calldata addrs, bool allow) external onlyOwner onlyBeforeAuction {
        for (uint256 i = 0; i < addrs.length; i++) {
            address addr = addrs[i];
            require(addr != address(0), 'KiraAuction: not be able to whitelist/blacklist address(0).');

            customers[addr].whitelisted = allow;
        }

        emit WhitelistConfigured(addrs, allow);
    }

    // only in progress

    receive() external payable {
        _processBuy(msg.sender, msg.value);
    }

    function _processBuy(address beneficiary, uint256 weiAmount) private onlyInProgress {
        require(beneficiary != address(0), 'KiraAuction: Not zero address');
        require(beneficiary != owner(), 'KiraAuction: Not owner');
        require(customers[beneficiary].whitelisted, "KiraAuction: You're not whitelisted, wait a moment.");
        require(weiAmount >= MIN_WEI, 'KiraAuction: That is not enough.');
        require(weiAmount <= MAX_WEI, 'KiraAuction: That is too much.');
        require(now - customers[beneficiary].last_deposit_time >= INTERVAL_LIMIT, 'KiraAuction: it exceeds the tx rate limit');

        uint256 cap = _getCurrentCap();

        require(totalWeiAmount.add(weiAmount) < cap, 'KiraAuction: Your contribution overflows the hard cap!');

        if (customers[beneficiary].claimed_wei == 0) {
            arrayAddress.push(beneficiary);
        }

        customers[beneficiary].claimed_wei = customers[beneficiary].claimed_wei.add(weiAmount);
        customers[beneficiary].last_deposit_time = now;

        totalWeiAmount = totalWeiAmount.add(weiAmount);

        emit ProcessedBuy(beneficiary, weiAmount);

        uint256 exp = 10**uint256(kiraToken.decimals());
        uint256 numberOfTokens = kiraToken.balanceOf(address(this)).div(exp);
        latestPrice = totalWeiAmount.div(numberOfTokens);

        if (latestPrice < P3) {
            latestPrice = P3;
        }
    }

    // only after auction

    function distribute() external onlyOwner onlyAfterAuction {
        uint256 totalDistributed;
        uint256 exp = 10**uint256(kiraToken.decimals());
        uint256 numberOfContributors = arrayAddress.length;

        for (uint256 i = 0; i < numberOfContributors; i++) {
            address addr = arrayAddress[i];
            UserInfo storage customer = customers[addr];

            if (customer.claimed_wei > 0 && !customer.claimed && !customer.distributed) {
                uint256 tokensToSend = customer.claimed_wei.mul(exp).div(latestPrice);
                uint256 currentBalance = kiraToken.balanceOf(address(this));

                customer.distributed = true;

                if (currentBalance < tokensToSend) {
                    tokensToSend = currentBalance;
                }

                if (tokensToSend > 0) {
                    totalDistributed = totalDistributed.add(tokensToSend);
                    kiraToken.transfer(addr, tokensToSend);
                }
            }
        }

        require(totalDistributed > 0, 'KiraAuction: nothing to distribute. already claimed or distributed all!');

        emit DistributeTokens(totalDistributed);
    }

    function claimTokens() external onlyAfterAuction {
        UserInfo storage customer = customers[msg.sender];
        require(!customer.claimed, 'KiraAuction: you claimed already.');
        require(!customer.distributed, 'KiraAuction: we already sent to your wallet.');
        require(customer.whitelisted && (customer.claimed_wei > 0), 'KiraAuction: you did not contribute.');

        customer.claimed = true;

        uint256 exp = 10**uint256(kiraToken.decimals());
        uint256 amountToClaim = customer.claimed_wei.mul(exp).div(latestPrice);
        kiraToken.transfer(msg.sender, amountToClaim);

        emit ClaimedTokens(msg.sender, amountToClaim);
    }

    function withdrawFunds() external onlyOwner onlyAfterAuction {
        uint256 ethBalance = address(this).balance;
        uint256 kexBalance = kiraToken.balanceOf(address(this));
        require(ethBalance > 0 || kexBalance > 0, 'KiraAuction: nothing left to withdraw');

        if (ethBalance > 0) {
            wallet.transfer(ethBalance);
        }
        if (kexBalance > 0) {
            kiraToken.transfer(wallet, kexBalance);
        }

        emit WithdrawedFunds(wallet, ethBalance, kexBalance);
    }
}