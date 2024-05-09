/*

@@@@@@@   @@@        @@@@@@    @@@@@@   @@@@@@@   @@@ @@@  
@@@@@@@@  @@@       @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  
@@!  @@@  @@!       @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@  
!@   @!@  !@!       !@!  @!@  !@!  @!@  !@!  @!@  !@! @!!  
@!@!@!@   @!!       @!@  !@!  @!@  !@!  @!@  !@!   !@!@!   
!!!@!!!!  !!!       !@!  !!!  !@!  !!!  !@!  !!!    @!!!   
!!:  !!!  !!:       !!:  !!!  !!:  !!!  !!:  !!!    !!:    
:!:  !:!   :!:      :!:  !:!  :!:  !:!  :!:  !:!    :!:    
 :: ::::   :: ::::  ::::: ::  ::::: ::   :::: ::     ::    
:: : ::   : :: : :   : :  :    : :  :   :: :  :      :

Website: bloodyfi.org

BLOODY, a deflationary elastic experiment that clots if it 
doesn't circulate

How does clotting work?

Whenever the BLOODY transfer volume increases, everyone's 
BLOODY balance gets a little bit bigger, whenever the BLOODY 
transfer volume decreases, everyone's BLOODY balance gets a 
little bit smaller.

How is it deflationary?

Whenever there's a BLOODY transfer, it spills. The faster it
circulates, the higher the spill rate.

How often are rebases?

Rebases are hourly. After a rebase, transfers are frozen for 
5 minutes.

How are BLOODY liquidity provider incentivized?

- Half the spills are redistributed to BLOODY-ETH, BLOODY-ROT 
and BLOODY-NICE liquidity providers (up to 6% of ANY transfer).
- A BLOODY-ROT pool will be added to Rottenswap on Halloween.

How is BLOODY initially distributed?

BLOODY cannot be minted, it is ditributed once on Halloween 2020 
to ROT holders with a balance above 7,500. The snapshot block 
(11106871) was chosen at random 
https://twitter.com/TheTimTempleton/status/1320722096578727937

Are contracts audited?

BLOODY is written 100% from scratch, not tested nor audited. 
It is not secure, use at your own risk.

What does it BLOODY do?

Nothing, it is an experiment with no purpose.

*/

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

// File: contracts/ERC20.sol

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
    // EDIT: make balanceOf virtual so it can be overridden
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    // function balanceOf(address account) public view override returns (uint256) {
    //     return _balances[account];
    // }

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

        // _beforeTokenTransfer(sender, recipient, amount);

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
        // require(account != address(0), "ERC20: mint to the zero address");

        // _beforeTokenTransfer(address(0), account, amount);

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
        // require(account != address(0), "ERC20: burn from the zero address");

        // _beforeTokenTransfer(account, address(0), amount);

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

// File: contracts/ERC20TransferBurn.sol

pragma solidity ^0.6.2;


contract ERC20TransferBurn is ERC20 {
    using SafeMath for uint256;

    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}

    // the amount of burn during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
    uint256 private _burnDivisor = 100;

    function burnDivisor() public view virtual returns (uint256) {
        return _burnDivisor;
    }

    function _setBurnDivisor(uint256 burnDivisor) internal virtual {
        require(burnDivisor > 0, "_setBurnDivisor burnDivisor must be bigger than 0");
        _burnDivisor = burnDivisor;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        // calculate burn amount
        uint256 burnAmount = amount.div(_burnDivisor);
        // burn burn amount
        burn(msg.sender, burnAmount);
        // transfer amount minus burn amount
        return super.transfer(recipient, amount.sub(burnAmount));
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        // calculate burn amount
        uint256 burnAmount = amount.div(_burnDivisor);
        // burn burn amount
        burn(sender, burnAmount);
        // transfer amount minus burn amount
        return super.transferFrom(sender, recipient, amount.sub(burnAmount));
    }

    // keep track of total supply burned (for fun only, serves no purpose)
    uint256 private _totalSupplyBurned;

    function totalSupplyBurned() public view virtual returns (uint256) {
        return _totalSupplyBurned;
    }

    function burn(address account, uint256 amount) private {
        _burn(account, amount);
        // keep track of total supply burned
        _totalSupplyBurned = _totalSupplyBurned.add(amount);
    }
}

// File: contracts/ERC20ElasticTransferBurn.sol

// ERC20Elastic is duplicated in ERC20Elastic.sol and ERC20ElasticTransferBurn.sol
// because I don't know how to not duplicate it

pragma solidity ^0.6.0;


contract ERC20ElasticTransferBurn is ERC20TransferBurn {
    using SafeMath for uint256;

    constructor (string memory name, string memory symbol) ERC20TransferBurn(name, symbol) public {}

    uint256 private _elasticMultiplier = 100;

    function elasticMultiplier() public view virtual returns (uint256) {
        return _elasticMultiplier;
    }

    function _setElasticMultiplier(uint256 elasticMultiplier) internal virtual {
        require(elasticMultiplier > 0, "_setElasticMultiplier elasticMultiplier must be bigger than 0");
        _elasticMultiplier = elasticMultiplier;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return super.balanceOf(account).mul(_elasticMultiplier);
    }

    // don't override totalSupply to cause more madness and confusion
    function totalSupplyElastic() public view virtual returns (uint256) {
        return super.totalSupply().mul(_elasticMultiplier);
    }

    function balanceOfRaw(address account) public view virtual returns (uint256) {
        return super.balanceOf(account);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        return super.transfer(recipient, amount.div(_elasticMultiplier));
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        return super.transferFrom(sender, recipient, amount.div(_elasticMultiplier));
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

// File: contracts/BloodyToken.sol

pragma solidity ^0.6.2;



contract BloodyToken is ERC20ElasticTransferBurn("BloodyToken", "BLOODY"), Ownable {
    using SafeMath for uint256;

    // store how many transfers have occurred every hour
    // to calculate the burn divisor
    uint256 public transferVolumeNowBucket;
    uint256 public transferVolume1HourAgoBucket;

    // store the now timestamp to know when it has expired
    uint256 public transferVolumeNowBucketTimestamp;

    constructor() public {
        // set to arbitrary initial values
        _setBurnDivisor(100);
        _setElasticMultiplier(10);

        // freeze transfers for 5 minutes after rebase
        // to mitigate users transferring wrong amounts
        transferAfterRebaseFreezeTime = 5 minutes;

        transferVolumeNowBucketTimestamp = getTransferVolumeNowBucketTimestamp();
    }

    function getTransferVolumeNowBucketTimestamp() public view returns (uint256) {
        // 3600 seconds per hour
        // round the timestamp bucket every hour
        return block.timestamp - (block.timestamp % 3600);
    }

    event Rebase(
        uint256 indexed transferVolumeNowBucketTimestamp, uint256 burnDivisor, uint256 elasticMultiplier, 
        uint256 transferVolume1HourAgoBucket, uint256 transferVolume2HoursAgoBucket
    );

    uint256 public lastRebaseTimestamp;
    uint256 public transferAfterRebaseFreezeTime;

    function rebase() public {
        // time is still in current bucket, does not need updating
        require(requiresRebase() == true, "someone else called rebase already");

        // update volume buckets
        // shift buckets 1 spot
        uint256 transferVolume2HoursAgoBucket = transferVolume1HourAgoBucket;
        transferVolume1HourAgoBucket = transferVolumeNowBucket;
        transferVolumeNowBucket = 0;

        // store new timestamp
        transferVolumeNowBucketTimestamp = getTransferVolumeNowBucketTimestamp();

        // mint half the burn to the uniswap pairs
        // make sure to sync the uniswap pairs after
        uint256 uniswapPairReward = transferVolume1HourAgoBucket.div(burnDivisor()).div(2);
        mintToUniswapPairs(uniswapPairReward);

        // rebase supply and burn rate
        uint256 newBurnDivisor = calculateBurnDivisor(burnDivisor(), transferVolume1HourAgoBucket, transferVolume2HoursAgoBucket);
        // arbitrarily set elastic modifier to 10x the burn rate (10 * 100 / burnDivisor)
        // if bloody circulates, spill rate increases, but clotting decreases
        // if volume increases, burn rate increases (burn divisor decreases), supply increases
        uint256 newElasticMultiplier = uint256(1000).div(newBurnDivisor);
        _setBurnDivisor(newBurnDivisor);
        _setElasticMultiplier(newElasticMultiplier);
        emit Rebase(transferVolumeNowBucketTimestamp, newBurnDivisor, newElasticMultiplier, transferVolume1HourAgoBucket, transferVolume2HoursAgoBucket);

        // if uniswap pairs are not synced loss of
        // funds will occur after rebase or reward minting
        syncUniswapPairs();

        // set to false until next rebase
        setRequiresRebase(false);
        lastRebaseTimestamp = block.timestamp;
    }

    uint256 public constant minBurnPercent = 1;
    uint256 public constant maxBurnPercent = 12;
    // they are inversely correlated
    uint256 public constant minBurnDivisor = 100 / maxBurnPercent;
    uint256 public constant maxBurnDivisor = 100 / minBurnPercent;

    // if bloody circulates, spill rate increases, but clotting decreases
    // if volume decreases, burn rate decreases (burn divisor increases), supply decreases
    // if supply decreases, price goes up, which stimulates more volume, which in turn
    // increases burn
    // if volume increases, burn rate increases (burn divisor decreases), supply increases
    function calculateBurnDivisor(uint256 _previousBurnDivisor, uint256 _transferVolume1HourAgoBucket, uint256 _transferVolume2HoursAgoBucket) public view returns (uint256) {
        // convert burn divisor to burn percent using division precision
        int256 divisionPrecision = 10000;
        int256 preciseMinBurnPercent = int256(minBurnPercent) * divisionPrecision;
        int256 preciseMaxBurnPercent = int256(maxBurnPercent) * divisionPrecision;
        // don't divide by 0
        if (_previousBurnDivisor == 0) {
            return minBurnDivisor;
        }
        int256 precisePreviousBurnPercent = (100 * divisionPrecision) / int256(_previousBurnDivisor);

        // no update needed
        if (_transferVolume1HourAgoBucket == _transferVolume2HoursAgoBucket) {
            // never return burn divisor above or below max
            if (precisePreviousBurnPercent < preciseMinBurnPercent) {
                return maxBurnDivisor;
            }
            else if (precisePreviousBurnPercent > preciseMaxBurnPercent) {
                return minBurnDivisor;
            }
            else {
                return _previousBurnDivisor;
            }
        }

        bool volumeHasIncreased = _transferVolume1HourAgoBucket > _transferVolume2HoursAgoBucket;

        // check for min / max already reached
        if (volumeHasIncreased) {
            // volume has increased but 
            // burn percent is already max (burn divisor is already min)
            if (precisePreviousBurnPercent >= preciseMaxBurnPercent) {
                return minBurnDivisor;
            }
        }
        // volume has decreased
        else {
            // volume has decreased but 
            // burn percent is already min (burn divisor is already max)
            if (precisePreviousBurnPercent <= preciseMinBurnPercent) {
                return maxBurnDivisor;
            }
        }

        // find the transfer volume difference ratio between the 2 hour buckets
        int256 transferVolumeRatio;
        if (_transferVolume1HourAgoBucket == 0) {
            transferVolumeRatio = -int256(_transferVolume2HoursAgoBucket + 1);
        }
        else if (_transferVolume2HoursAgoBucket == 0) {
            transferVolumeRatio = int256(_transferVolume1HourAgoBucket + 1);
        }
        else if (volumeHasIncreased) {
            transferVolumeRatio = int256(_transferVolume1HourAgoBucket / _transferVolume2HoursAgoBucket);
        }
        else {
            transferVolumeRatio = -int256(_transferVolume2HoursAgoBucket / _transferVolume1HourAgoBucket);
        }

        // find the burn percent modifier and the new burn percent
        // round division to 10000
        int256 preciseNewBurnPercent = calculateBurnPercentFromTransferVolumeRatio(
            precisePreviousBurnPercent,
            transferVolumeRatio * divisionPrecision, 
            preciseMinBurnPercent, 
            preciseMaxBurnPercent
        );

        // convert the burn percent back to burn divisor, without forgetting division precision
        return uint256((100 * divisionPrecision) / preciseNewBurnPercent);
    }

    function calculateBurnPercentFromTransferVolumeRatio(int256 _previousBurnPercent, int256 _transferVolumeRatio, int256 _minBurnPercent, int256 _maxBurnPercent) public pure returns (int256) {
        // this is a pure function, don't use globals min and max
        // because might use division precision

        // previous burn percent should never be bigger or smaller than max or min
        // but if the exception occurs it messes up the curve
        if (_previousBurnPercent < _minBurnPercent) {
            _previousBurnPercent = _minBurnPercent;
        }
        else if (_previousBurnPercent > _maxBurnPercent) {
            _previousBurnPercent = _maxBurnPercent;
        }

        // attempt to find burn divisor curve
        int256 burnPercentModifier = _transferVolumeRatio;
        int8 maxAttempt = 5;
        while (true) {
            int256 newBurnPercent = _previousBurnPercent + burnPercentModifier;
            // found burn divisor curve
            if (newBurnPercent < _maxBurnPercent && newBurnPercent > _minBurnPercent) {
                return _previousBurnPercent + burnPercentModifier;
            }

            // curve formula brings too little change to burn divisor, not worth it
            if (maxAttempt-- == 0) {
                // instead of returning the value very close to the min or max
                // return min or max instead to avoid wasting gas
                if (_transferVolumeRatio > 0) {
                    // if _transferVolumeRatio is positive, burn should increase
                    return _maxBurnPercent;
                }
                else {
                    // bigger than max would give min
                    return _minBurnPercent;
                }
            }

            // divide by 2 until burnPercent + burnPercentModifier
            // fit between min and max to find the perfect curve
            burnPercentModifier = burnPercentModifier / 2;
        }
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // if time for rebase, freeze all transfers until someone calls rebase
        require(requiresRebase() == false, "transfers are frozen until someone calls rebase");
        require(transfersAreFrozenAfterRebase() == false, "transfers are frozen for a few minutes after rebase");
        super.transfer(recipient, amount);
        updateTransferVolume(amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        // if time for rebase, freeze all transfers until someone calls rebase
        require(requiresRebase() == false, "transfers are frozen until someone calls rebase");
        require(transfersAreFrozenAfterRebase() == false, "transfers are frozen for a few minutes after rebase");
        super.transferFrom(sender, recipient, amount);
        updateTransferVolume(amount);
        return true;
    }

    function updateTransferVolume(uint256 volume) internal virtual {
        // keep track of transfer volume on each transfer
        // store the volume without elastic multiplier to know the real volume
        transferVolumeNowBucket = transferVolumeNowBucket.add(volume.div(elasticMultiplier()));

        // if 1 hour has passed, requires new rebase
        if (transferVolumeNowBucketTimestamp != getTransferVolumeNowBucketTimestamp()) {
            setRequiresRebase(true);
        }
    }

    function transfersAreFrozenAfterRebase() public view returns (bool) {
        // use < and not <= to always stop transfers that occur on the same block as a rebase
        // even if transferAfterRebaseFreezeTime is set to 0
        if (lastRebaseTimestamp + transferAfterRebaseFreezeTime < block.timestamp) {
            return false;
        }
        return true;
    }

    // if should rebase, freeze all transfers until someone calls rebase
    bool private _requiresRebase = false;
    // only require rebase on the next block
    uint256 private lastSetRequiresRebaseTimestamp;

    function requiresRebase() public view returns (bool) {
        if (_requiresRebase) {
            if (lastSetRequiresRebaseTimestamp < block.timestamp) {
                return true;
            }
        }
        return false;
    }

    function setRequiresRebase (bool value) internal {
        _requiresRebase = value;
        lastSetRequiresRebaseTimestamp = block.timestamp;
    }

    // mint half the burn to the uniswap pair to incentivize liquidity
    // swapping or providing liquidity on any other pairs will cause
    // loss of funds after every rebase
    address public bloodyEthUniswapPair;
    address public bloodyNiceUniswapPair;
    address public bloodyRotUniswapPair;

    // called by owner after contract is deployed to set
    // the uniswap pair which receives half the burn to incentivize liquidity
    // then contract ownership is transfered to
    // address 0x0000000000000000000000000000000000000000 and can never be called again
    function setUniswapPairs(address _bloodyEthUniswapPair, address _bloodyNiceUniswapPair, address _bloodyRotUniswapPair) public virtual onlyOwner {
        bloodyEthUniswapPair = _bloodyEthUniswapPair;
        bloodyNiceUniswapPair = _bloodyNiceUniswapPair;
        bloodyRotUniswapPair = _bloodyRotUniswapPair;
    }

    // mint half the burn to the uniswap pairs
    // make sure to sync the uniswap pairs after
    // reward is half of the burn split into 3 pairs
    function mintToUniswapPairs(uint256 uniswapPairRewardAmount) internal {
        if (uniswapPairRewardAmount == 0) {
            return;
        }
        // reward is half of the burn split into 3 pairs
        uint256 amountPerPair = uniswapPairRewardAmount.div(3);
        if (uniswapPairRewardAmount == 0) {
            return;
        }
        if (bloodyEthUniswapPair != address(0)) {
            _mint(bloodyEthUniswapPair, amountPerPair);
        }
        if (bloodyNiceUniswapPair != address(0)) {
            _mint(bloodyNiceUniswapPair, amountPerPair);
        }
        if (bloodyRotUniswapPair != address(0)) {
            _mint(bloodyRotUniswapPair, amountPerPair);
        }
    }

    // if uniswap pairs are not synced loss of
    // funds will occur after rebase or reward minting
    function syncUniswapPairs() internal {
        if (bloodyEthUniswapPair != address(0)) {
            IUniswapV2Pair(bloodyEthUniswapPair).sync();
        }
        if (bloodyNiceUniswapPair != address(0)) {
            IUniswapV2Pair(bloodyNiceUniswapPair).sync();
        }
        if (bloodyRotUniswapPair != address(0)) {
            IUniswapV2Pair(bloodyRotUniswapPair).sync();
        }
    }

    // called by owner after contract is deployed to airdrop
    // tokens to inital holders, then contract ownership is transfered to
    // address 0x0000000000000000000000000000000000000000 and can never be called again
    function airdrop(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        for (uint i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amounts[i]);
        }
    }

    // util external function for website
    function totalSupplyBurnedElastic() external view returns (uint256) {
        return totalSupplyBurned().mul(elasticMultiplier());
    }

    // util external function for website
    // half the burn is minted to the uniswap pools
    // might not be accurate if uniswap pools aren't set yet
    function totalSupplyBurnedMinusRewards() public view returns (uint256) {
        return totalSupplyBurned().div(2);
    }

    // util external function for website
    function timeUntilNextRebase() external view returns (uint256) {
        uint256 rebaseTime = transferVolumeNowBucketTimestamp + 3600;
        if (rebaseTime <= block.timestamp) {
            return 0;
        }
        return rebaseTime - block.timestamp;
    }

    // util external function for website
    function nextRebaseTimestamp() external view returns (uint256) {
        return transferVolumeNowBucketTimestamp + 3600;
    }

    // util external function for website
    function transfersAreFrozen() external view returns (bool) {
        if (transfersAreFrozenAfterRebase() || requiresRebase()) {
            return true;
        }
        return false;
    }

    // util external function for website
    function transfersAreFrozenRequiresRebase() external view returns (bool) {
        return requiresRebase();
    }

    // util external function for website
    function timeUntilNextTransferAfterRebaseUnfreeze() external view virtual returns (uint256) {
        uint256 unfreezeTime = lastRebaseTimestamp + transferAfterRebaseFreezeTime;
        if (unfreezeTime <= block.timestamp) {
            return 0;
        }
        return unfreezeTime - block.timestamp;
    }

    // util external function for website
    function nextTransferAfterRebaseUnfreezeTimestamp() external view virtual returns (uint256) {
        return lastRebaseTimestamp + transferAfterRebaseFreezeTime;
    }

    // util external function for website
    function balanceInUniswapPair(address user, address uniswapPair) public view returns (uint256) {
        if (uniswapPair == address(0)) {
            return 0;
        }
        uint256 pairBloodyBalance = balanceOf(uniswapPair);
        if (pairBloodyBalance == 0) {
            return 0;
        }
        uint256 userLpBalance = IUniswapV2Pair(uniswapPair).balanceOf(user);
        if (userLpBalance == 0) {
            return 0;
        }
        uint256 lpTotalSupply = IUniswapV2Pair(uniswapPair).totalSupply();
        uint256 divisionPrecision = 1e12;
        uint256 userLpTotalOwnershipRatio = userLpBalance.mul(divisionPrecision).div(lpTotalSupply);
        return pairBloodyBalance.mul(userLpTotalOwnershipRatio).div(divisionPrecision);
    }

    // util external function for website
    function balanceInUniswapPairs(address user) public view returns (uint256) {
        return balanceInUniswapPair(user, bloodyEthUniswapPair)
            .add(balanceInUniswapPair(user, bloodyNiceUniswapPair))
            .add(balanceInUniswapPair(user, bloodyRotUniswapPair));
    }

    // util external function for website
    function balanceIncludingUniswapPairs(address user) external view returns (uint256) {
        return balanceOf(user).add(balanceInUniswapPairs(user));
    }
}

interface IUniswapV2Pair {
    function sync() external;
    function balanceOf(address owner) external view returns (uint);
    function totalSupply() external view returns (uint);
}