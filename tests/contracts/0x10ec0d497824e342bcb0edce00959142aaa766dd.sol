// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

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
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
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

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
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
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
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
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
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
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

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
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

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
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

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
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
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
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

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
 */
contract ReentrancyGuard {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: @openzeppelin/contracts/access/roles/PauserRole.sol

pragma solidity ^0.5.0;



contract PauserRole is Context {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(_msgSender());
    }

    modifier onlyPauser() {
        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(_msgSender());
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

// File: @openzeppelin/contracts/lifecycle/Pausable.sol

pragma solidity ^0.5.0;



/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context, PauserRole {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/interfaces/iERC20Fulcrum.sol

pragma solidity 0.5.11;

interface iERC20Fulcrum {
  function mint(
    address receiver,
    uint256 depositAmount)
    external
    returns (uint256 mintAmount);

  function burn(
    address receiver,
    uint256 burnAmount)
    external
    returns (uint256 loanAmountPaid);

  function tokenPrice()
    external
    view
    returns (uint256 price);

  function supplyInterestRate()
    external
    view
    returns (uint256);

  function rateMultiplier()
    external
    view
    returns (uint256);
  function baseRate()
    external
    view
    returns (uint256);

  function borrowInterestRate()
    external
    view
    returns (uint256);

  function avgBorrowInterestRate()
    external
    view
    returns (uint256);

  function protocolInterestRate()
    external
    view
    returns (uint256);

  function spreadMultiplier()
    external
    view
    returns (uint256);

  function totalAssetBorrow()
    external
    view
    returns (uint256);

  function totalAssetSupply()
    external
    view
    returns (uint256);

  function nextSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function nextBorrowInterestRate(uint256)
    external
    view
    returns (uint256);
  function nextLoanInterestRate(uint256)
    external
    view
    returns (uint256);

  function claimLoanToken()
    external
    returns (uint256 claimedAmount);

  function dsr()
    external
    view
    returns (uint256);

  function chaiPrice()
    external
    view
    returns (uint256);
}

// File: contracts/interfaces/ILendingProtocol.sol

pragma solidity 0.5.11;

interface ILendingProtocol {
  function mint() external returns (uint256);
  function redeem(address account) external returns (uint256);
  function nextSupplyRate(uint256 amount) external view returns (uint256);
  function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
  function getAPR() external view returns (uint256);
  function getPriceInToken() external view returns (uint256);
  function token() external view returns (address);
  function underlying() external view returns (address);
}

// File: contracts/interfaces/IIdleToken.sol

/**
 * @title: Idle Token interface
 * @author: William Bergamo, idle.finance
 */
pragma solidity 0.5.11;

interface IIdleToken {
  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice() external view returns (uint256 price);

  /**
   * underlying token decimals
   *
   * @return : decimals of underlying token
   */
  function tokenDecimals() external view returns (uint256 decimals);

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);

  // external
  // We should save the amount one has deposited to calc interests

  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts) external returns (uint256 mintedTokens);

  /**
   * @param _amount : amount of underlying token to be lended
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForMintIdleToken(uint256 _amount) external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
    external returns (uint256 redeemedTokens);

  /**
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
    external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount) external;

  /**
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return claimedTokens : amount of underlying tokens claimed
   */
  function claimITokens(uint256[] calldata _clientProtocolAmounts) external returns (uint256 claimedTokens);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256 _newAmount, uint256[] calldata _clientProtocolAmounts) external returns (bool);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRebalance(uint256 _newAmount) external returns (address[] memory, uint256[] memory);
}

// File: contracts/interfaces/CERC20.sol

pragma solidity 0.5.11;

interface CERC20 {
  function mint(uint256 mintAmount) external returns (uint256);
  function redeem(uint256 redeemTokens) external returns (uint256);
  function exchangeRateStored() external view returns (uint256);
  function supplyRatePerBlock() external view returns (uint256);

  function borrowRatePerBlock() external view returns (uint256);
  function totalReserves() external view returns (uint256);
  function getCash() external view returns (uint256);
  function totalBorrows() external view returns (uint256);
  function reserveFactorMantissa() external view returns (uint256);
  function interestRateModel() external view returns (address);
}

// File: contracts/interfaces/WhitePaperInterestRateModel.sol

pragma solidity 0.5.11;

interface WhitePaperInterestRateModel {
  function getBorrowRate(uint256 cash, uint256 borrows, uint256 _reserves) external view returns (uint256, uint256);
  function getSupplyRate(uint256 cash, uint256 borrows, uint256 reserves, uint256 reserveFactorMantissa) external view returns (uint256);
  function multiplier() external view returns (uint256);
  function baseRate() external view returns (uint256);
  function blocksPerYear() external view returns (uint256);
  function dsrPerBlock() external view returns (uint256);
}

// File: contracts/IdleRebalancer.sol

/**
 * @title: Idle Rebalancer contract
 * @summary: Used for calculating amounts to lend on each implemented protocol.
 *           This implementation works with Compound and Fulcrum only,
 *           when a new protocol will be added this should be replaced
 * @author: William Bergamo, idle.finance
 */
pragma solidity 0.5.11;








contract IdleRebalancer is Ownable {
  using SafeMath for uint256;
  // IdleToken address
  address public idleToken;
  // protocol token (cToken) address
  address public cToken;
  // protocol token (iToken) address
  address public iToken;
  // cToken protocol wrapper IdleCompound
  address public cWrapper;
  // iToken protocol wrapper IdleFulcrum
  address public iWrapper;
  // max % difference between next supply rate of Fulcrum and Compound
  uint256 public maxRateDifference; // 10**17 -> 0.1 %
  // max % difference between off-chain user supplied params for rebalance and actual amount to be rebalanced
  uint256 public maxSupplyedParamsDifference; // 100000 -> 0.001%
  // max number of recursive calls for bisection algorithm
  uint256 public maxIterations;

  /**
   * @param _cToken : cToken address
   * @param _iToken : iToken address
   * @param _cWrapper : cWrapper address
   * @param _iWrapper : iWrapper address
   */
  constructor(address _cToken, address _iToken, address _cWrapper, address _iWrapper) public {
    require(_cToken != address(0) && _iToken != address(0) && _cWrapper != address(0) && _iWrapper != address(0), 'some addr is 0');

    cToken = _cToken;
    iToken = _iToken;
    cWrapper = _cWrapper;
    iWrapper = _iWrapper;
    maxRateDifference = 10**17; // 0.1%
    maxSupplyedParamsDifference = 100000; // 0.001%
    maxIterations = 30;
  }

  /**
   * Throws if called by any account other than IdleToken contract.
   */
  modifier onlyIdle() {
    require(msg.sender == idleToken, "Ownable: caller is not IdleToken contract");
    _;
  }

  // onlyOwner
  /**
   * sets idleToken address
   * NOTE: can be called only once. It's not on the constructor because we are deploying this contract
   *       after the IdleToken contract
   * @param _idleToken : idleToken address
   */
  function setIdleToken(address _idleToken)
    external onlyOwner {
      require(idleToken == address(0), "idleToken addr already set");
      require(_idleToken != address(0), "_idleToken addr is 0");
      idleToken = _idleToken;
  }

  /**
   * sets maxIterations for bisection recursive calls
   * @param _maxIterations : max number of iterations for the bisection algorithm
   */
  function setMaxIterations(uint256 _maxIterations)
    external onlyOwner {
      maxIterations = _maxIterations;
  }

  /**
   * sets maxRateDifference
   * @param _maxDifference : max rate difference in percentage scaled by 10**18
   */
  function setMaxRateDifference(uint256 _maxDifference)
    external onlyOwner {
      maxRateDifference = _maxDifference;
  }

  /**
   * sets maxSupplyedParamsDifference
   * @param _maxSupplyedParamsDifference : max slippage between the rebalance params given from the client
   *                                       and actual amount to be rebalanced
   */
  function setMaxSupplyedParamsDifference(uint256 _maxSupplyedParamsDifference)
    external onlyOwner {
      maxSupplyedParamsDifference = _maxSupplyedParamsDifference;
  }
  // end onlyOwner

  /**
   * Used by IdleToken contract to calculate the amount to be lended
   * on each protocol in order to get the best available rate for all funds.
   *
   * @param _rebalanceParams : first param is the total amount to be rebalanced,
   *                           all other elements are client side calculated amounts to put on each lending protocol
   * @return tokenAddresses : array with all token addresses used,
   *                          currently [cTokenAddress, iTokenAddress]
   * @return amounts : array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   */
  function calcRebalanceAmounts(uint256[] calldata _rebalanceParams)
    external view onlyIdle
    returns (address[] memory tokenAddresses, uint256[] memory amounts)
  {
    // Get all params for calculating Compound nextSupplyRateWithParams
    CERC20 _cToken = CERC20(cToken);
    WhitePaperInterestRateModel white = WhitePaperInterestRateModel(_cToken.interestRateModel());
    uint256[] memory paramsCompound = new uint256[](10);
    paramsCompound[0] = 10**18; // j
    paramsCompound[1] = white.baseRate(); // a
    paramsCompound[2] = _cToken.totalBorrows(); // b
    paramsCompound[3] = white.multiplier(); // c
    paramsCompound[4] = _cToken.totalReserves(); // d
    paramsCompound[5] = paramsCompound[0].sub(_cToken.reserveFactorMantissa()); // e
    paramsCompound[6] = _cToken.getCash(); // s
    paramsCompound[7] = white.blocksPerYear(); // k
    paramsCompound[8] = 100; // f

    // Get all params for calculating Fulcrum nextSupplyRateWithParams
    iERC20Fulcrum _iToken = iERC20Fulcrum(iToken);
    uint256[] memory paramsFulcrum = new uint256[](4);
    paramsFulcrum[0] = _iToken.protocolInterestRate(); // a1
    paramsFulcrum[1] = _iToken.totalAssetBorrow(); // b1
    paramsFulcrum[2] = _iToken.totalAssetSupply(); // s1

    tokenAddresses = new address[](2);
    tokenAddresses[0] = cToken;
    tokenAddresses[1] = iToken;

    // _rebalanceParams should be [totAmountToRebalance, amountCompound, amountFulcrum];
    if (_rebalanceParams.length == 3) {
      (bool amountsAreCorrect, uint256[] memory checkedAmounts) = checkRebalanceAmounts(_rebalanceParams, paramsCompound, paramsFulcrum);
      if (amountsAreCorrect) {
        return (tokenAddresses, checkedAmounts);
      }
    }

    // Initial guess for shrinking initial bisection interval
    /*
      Compound: (getCash returns the available supply only, not the borrowed one)
      getCash + totalBorrows = totalSuppliedCompound

      Fulcrum:
      totalSupply = totalSuppliedFulcrum

      we try to correlate borrow and supply on both markets
      totC = totalSuppliedCompound + totalBorrowsCompound
      totF = totalSuppliedFulcrum + totalBorrowsFulcrum

      n : (totC + totF) = x : totF
      x = n * totF / (totC + totF)
    */

    uint256 amountFulcrum = _rebalanceParams[0].mul(paramsFulcrum[2].add(paramsFulcrum[1])).div(
      paramsFulcrum[2].add(paramsFulcrum[1]).add(paramsCompound[6].add(paramsCompound[2]).add(paramsCompound[2]))
    );

    // Recursive bisection algorithm
    amounts = bisectionRec(
      _rebalanceParams[0].sub(amountFulcrum), // amountCompound
      amountFulcrum,
      maxRateDifference, // 0.1% of rate difference,
      0, // currIter
      maxIterations, // maxIter
      _rebalanceParams[0],
      paramsCompound,
      paramsFulcrum
    ); // returns [amountCompound, amountFulcrum]

    return (tokenAddresses, amounts);
  }
  /**
   * Used by IdleToken contract to check if provided amounts
   * causes the rates of Fulcrum and Compound to be balanced
   * (counting a tolerance)
   *
   * @param rebalanceParams : first element is the total amount to be rebalanced,
   *                   the rest is an array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   * @param paramsCompound : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Compound
   * @param paramsFulcrum : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Fulcrum
   * @return bool : if provided amount correctly rebalances the pool
   */
  function checkRebalanceAmounts(
    uint256[] memory rebalanceParams,
    uint256[] memory paramsCompound,
    uint256[] memory paramsFulcrum
  )
    internal view
    returns (bool, uint256[] memory checkedAmounts)
  {
    // This is the amount that should be rebalanced no more no less
    uint256 actualAmountToBeRebalanced = rebalanceParams[0]; // n
    // interest is earned between when tx was submitted and when it is mined so params sent by users
    // should always be slightly less than what should be rebalanced
    uint256 totAmountSentByUser;
    for (uint8 i = 1; i < rebalanceParams.length; i++) {
      totAmountSentByUser = totAmountSentByUser.add(rebalanceParams[i]);
    }

    // check if amounts sent from user are less than actualAmountToBeRebalanced and
    // at most `actualAmountToBeRebalanced - 0.001% of (actualAmountToBeRebalanced)`
    if (totAmountSentByUser > actualAmountToBeRebalanced ||
        totAmountSentByUser.add(totAmountSentByUser.div(maxSupplyedParamsDifference)) < actualAmountToBeRebalanced) {
      return (false, new uint256[](2));
    }

    uint256 interestToBeSplitted = actualAmountToBeRebalanced.sub(totAmountSentByUser);

    // sets newDAIAmount for each protocol
    paramsCompound[9] = rebalanceParams[1].add(interestToBeSplitted.div(2));
    paramsFulcrum[3] = rebalanceParams[2].add(interestToBeSplitted.sub(interestToBeSplitted.div(2)));

    // calculate next rates with amountCompound and amountFulcrum

    // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
    // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
    uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
      ILendingProtocol(iWrapper).nextSupplyRate(paramsFulcrum[3]) :
      ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);
    uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
    bool isCompoundBest = currCompRate > currFulcRate;
    // |fulcrumRate - compoundRate| <= tolerance
    bool areParamsOk = (currFulcRate.add(maxRateDifference) >= currCompRate && isCompoundBest) ||
      (currCompRate.add(maxRateDifference) >= currFulcRate && !isCompoundBest);

    uint256[] memory actualParams = new uint256[](2);
    actualParams[0] = paramsCompound[9];
    actualParams[1] = paramsFulcrum[3];

    return (areParamsOk, actualParams);
  }

  /**
   * Internal implementation of our bisection algorithm
   *
   * @param amountCompound : amount to be lended in compound in current iteration
   * @param amountFulcrum : amount to be lended in Fulcrum in current iteration
   * @param tolerance : max % difference between next supply rate of Fulcrum and Compound
   * @param currIter : current iteration
   * @param maxIter : max number of iterations
   * @param n : amount of underlying tokens (eg. DAI) to rebalance
   * @param paramsCompound : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Compound
   * @param paramsFulcrum : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Fulcrum
   * @return amounts : array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   */
  function bisectionRec(
    uint256 amountCompound, uint256 amountFulcrum,
    uint256 tolerance, uint256 currIter, uint256 maxIter, uint256 n,
    uint256[] memory paramsCompound,
    uint256[] memory paramsFulcrum
  )
    internal view
    returns (uint256[] memory amounts) {

    // sets newDAIAmount for each protocol
    paramsCompound[9] = amountCompound;
    paramsFulcrum[3] = amountFulcrum;

    // calculate next rates with amountCompound and amountFulcrum

    // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
    // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
    uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
      ILendingProtocol(iWrapper).nextSupplyRate(amountFulcrum) :
      ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);

    uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
    bool isCompoundBest = currCompRate > currFulcRate;

    // bisection interval update, we choose to halve the smaller amount
    uint256 step = amountCompound < amountFulcrum ? amountCompound.div(2) : amountFulcrum.div(2);

    // base case
    // |fulcrumRate - compoundRate| <= tolerance
    if (
      ((currFulcRate.add(tolerance) >= currCompRate && isCompoundBest) ||
      (currCompRate.add(tolerance) >= currFulcRate && !isCompoundBest)) ||
      currIter >= maxIter
    ) {
      amounts = new uint256[](2);
      amounts[0] = amountCompound;
      amounts[1] = amountFulcrum;
      return amounts;
    }

    return bisectionRec(
      isCompoundBest ? amountCompound.add(step) : amountCompound.sub(step),
      isCompoundBest ? amountFulcrum.sub(step) : amountFulcrum.add(step),
      tolerance, currIter + 1, maxIter, n,
      paramsCompound, // paramsCompound[9] would be overwritten on next iteration
      paramsFulcrum // paramsFulcrum[3] would be overwritten on next iteration
    );
  }
}

// File: contracts/IdlePriceCalculator.sol

/**
 * @title: Idle Price Calculator contract
 * @summary: Used for calculating the current IdleToken price in underlying (eg. DAI)
 *          price is: Net Asset Value / totalSupply
 * @author: William Bergamo, idle.finance
 */
pragma solidity 0.5.11;






contract IdlePriceCalculator {
  using SafeMath for uint256;
  /**
   * IdleToken price calculation, in underlying (eg. DAI)
   *
   * @return : price in underlying token
   */
  function tokenPrice(
    uint256 totalSupply,
    address idleToken,
    address[] calldata currentTokensUsed,
    address[] calldata protocolWrappersAddresses
  )
    external view
    returns (uint256 price) {
      require(currentTokensUsed.length == protocolWrappersAddresses.length, "Different Length");

      if (totalSupply == 0) {
        return 10**(IIdleToken(idleToken).tokenDecimals());
      }

      uint256 currPrice;
      uint256 currNav;
      uint256 totNav;

      for (uint8 i = 0; i < currentTokensUsed.length; i++) {
        currPrice = ILendingProtocol(protocolWrappersAddresses[i]).getPriceInToken();
        // NAV = price * poolSupply
        currNav = currPrice.mul(IERC20(currentTokensUsed[i]).balanceOf(idleToken));
        totNav = totNav.add(currNav);
      }

      price = totNav.div(totalSupply); // idleToken price in token wei
  }
}

// File: contracts/IdleToken.sol

/**
 * @title: Idle Token main contract
 * @summary: ERC20 that holds pooled user funds together
 *           Each token rapresent a share of the underlying pools
 *           and with each token user have the right to redeem a portion of these pools
 * @author: William Bergamo, idle.finance
 */
pragma solidity 0.5.11;














contract IdleToken is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Pausable, IIdleToken {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  // protocolWrappers may be changed/updated/removed do not rely on their
  // addresses to determine where funds are allocated

  // eg. cTokenAddress => IdleCompoundAddress
  mapping(address => address) public protocolWrappers;
  // eg. DAI address
  address public token;
  // eg. 18 for DAI
  uint256 public tokenDecimals;
  // eg. iDAI address
  address public iToken; // used for claimITokens and userClaimITokens
  // Min thresold of APR difference between protocols to trigger a rebalance
  uint256 public minRateDifference;
  // Idle rebalancer current implementation address
  address public rebalancer;
  // Idle rebalancer current implementation address
  address public priceCalculator;
  // Last iToken price, used to pause contract in case of a black swan event
  uint256 public lastITokenPrice;
  // Manual trigger for unpausing contract in case of a black swan event that caused the iToken price to not
  // return to the normal level
  bool public manualPlay = false;
  bool private _notLocalEntered;

  // no one can directly change this
  // Idle pool current investments eg. [cTokenAddress, iTokenAddress]
  address[] public currentTokensUsed;
  // eg. [cTokenAddress, iTokenAddress, ...]
  address[] public allAvailableTokens;

  struct TokenProtocol {
    address tokenAddr;
    address protocolAddr;
  }

  event Rebalance(uint256 amount);

  /**
   * @dev constructor, initialize some variables, mainly addresses of other contracts
   *
   * @param _name : IdleToken name
   * @param _symbol : IdleToken symbol
   * @param _decimals : IdleToken decimals
   * @param _token : underlying token address
   * @param _cToken : cToken address
   * @param _iToken : iToken address
   * @param _rebalancer : Idle Rebalancer address
   * @param _idleCompound : Idle Compound address
   * @param _idleFulcrum : Idle Fulcrum address
   */
  constructor(
    string memory _name, // eg. IdleDAI
    string memory _symbol, // eg. IDLEDAI
    uint8 _decimals, // eg. 18
    address _token,
    address _cToken,
    address _iToken,
    address _rebalancer,
    address _priceCalculator,
    address _idleCompound,
    address _idleFulcrum)
    public
    ERC20Detailed(_name, _symbol, _decimals) {
      token = _token;
      tokenDecimals = ERC20Detailed(_token).decimals();
      iToken = _iToken; // used for claimITokens and userClaimITokens methods
      rebalancer = _rebalancer;
      priceCalculator = _priceCalculator;
      protocolWrappers[_cToken] = _idleCompound;
      protocolWrappers[_iToken] = _idleFulcrum;
      allAvailableTokens = [_cToken, _iToken];
      minRateDifference = 100000000000000000; // 0.1% min
      _notLocalEntered = true;
  }

  modifier whenITokenPriceHasNotDecreased() {
    uint256 iTokenPrice = iERC20Fulcrum(iToken).tokenPrice();
    require(
      iTokenPrice >= lastITokenPrice || manualPlay,
      "Paused: iToken price decreased"
    );

    _;

    if (iTokenPrice > lastITokenPrice) {
      lastITokenPrice = iTokenPrice;
    }
  }

  modifier nonLocallyReentrant() {
    // On the first call to nonReentrant, _notEntered will be true
    require(_notLocalEntered, "LocalReentrancyGuard: reentrant call");

    // Any calls to nonReentrant after this point will fail
    _notLocalEntered = false;

    _;

    // By storing the original value once again, a refund is triggered (see
    // https://eips.ethereum.org/EIPS/eip-2200)
    _notLocalEntered = true;
  }

  // onlyOwner
  /**
   * It allows owner to set the iToken (Fulcrum) address
   *
   * @param _iToken : iToken address
   */
  function setIToken(address _iToken)
    external onlyOwner {
      iToken = _iToken;
  }
  /**
   * It allows owner to set the IdleRebalancer address
   *
   * @param _rebalancer : new IdleRebalancer address
   */
  function setRebalancer(address _rebalancer)
    external onlyOwner {
      rebalancer = _rebalancer;
  }
  /**
   * It allows owner to set the IdlePriceCalculator address
   *
   * @param _priceCalculator : new IdlePriceCalculator address
   */
  function setPriceCalculator(address _priceCalculator)
    external onlyOwner {
      priceCalculator = _priceCalculator;
  }
  /**
   * It allows owner to set a protocol wrapper address
   *
   * @param _token : underlying token address (eg. DAI)
   * @param _wrapper : Idle protocol wrapper address
   */
  function setProtocolWrapper(address _token, address _wrapper)
    external onlyOwner {
      require(_token != address(0) && _wrapper != address(0), 'some addr is 0');
      // update allAvailableTokens if needed
      if (protocolWrappers[_token] == address(0)) {
        allAvailableTokens.push(_token);
      }
      protocolWrappers[_token] = _wrapper;
  }

  function setMinRateDifference(uint256 _rate)
    external onlyOwner {
      minRateDifference = _rate;
  }
  /**
   * It allows owner to unpause the contract when iToken price decreased and didn't return to the expected level
   *
   * @param _manualPlay : new IdleRebalancer address
   */
  function setManualPlay(bool _manualPlay)
    external onlyOwner {
      manualPlay = _manualPlay;
  }

  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice()
    public view
    returns (uint256 price) {
      address[] memory protocolWrappersAddresses = new address[](currentTokensUsed.length);
      for (uint8 i = 0; i < currentTokensUsed.length; i++) {
        protocolWrappersAddresses[i] = protocolWrappers[currentTokensUsed[i]];
      }
      price = IdlePriceCalculator(priceCalculator).tokenPrice(
        this.totalSupply(), address(this), currentTokensUsed, protocolWrappersAddresses
      );
  }

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs()
    public view
    returns (address[] memory addresses, uint256[] memory aprs) {
      address currToken;
      addresses = new address[](allAvailableTokens.length);
      aprs = new uint256[](allAvailableTokens.length);
      for (uint8 i = 0; i < allAvailableTokens.length; i++) {
        currToken = allAvailableTokens[i];
        addresses[i] = currToken;
        aprs[i] = ILendingProtocol(protocolWrappers[currToken]).getAPR();
      }
  }

  // external
  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] memory _clientProtocolAmounts)
    public nonReentrant whenNotPaused whenITokenPriceHasNotDecreased
    returns (uint256 mintedTokens) {
      // Get current IdleToken price
      uint256 idlePrice = tokenPrice();
      // transfer tokens to this contract
      IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
      // Rebalance the current pool if needed and mint new supplyied amount
      rebalance(_amount, _clientProtocolAmounts);

      mintedTokens = _amount.mul(10**18).div(idlePrice);
      _mint(msg.sender, mintedTokens);
  }

  /**
   * Used to get `_clientProtocolAmounts` for `mintIdleToken` method, given an underlying amount (eg. DAI).
   * This should be used only for a call not an actual tx
   * NOTE: User should 'approve' _amount of tokens before calling this method
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   */
  function getParamsForMintIdleToken(uint256 _amount)
    external nonLocallyReentrant whenNotPaused whenITokenPriceHasNotDecreased
    returns (address[] memory, uint256[] memory) {
      mintIdleToken(_amount, new uint256[](0));
      return _getCurrentAllocations();
  }

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] memory _clientProtocolAmounts)
    public nonReentrant
    returns (uint256 redeemedTokens) {
      address currentToken;

      for (uint8 i = 0; i < currentTokensUsed.length; i++) {
        currentToken = currentTokensUsed[i];
        redeemedTokens = redeemedTokens.add(
          _redeemProtocolTokens(
            protocolWrappers[currentToken],
            currentToken,
            // _amount * protocolPoolBalance / idleSupply
            _amount.mul(IERC20(currentToken).balanceOf(address(this))).div(this.totalSupply()), // amount to redeem
            msg.sender
          )
        );
      }

      _burn(msg.sender, _amount);

      // Do not rebalance if contract is paused or iToken price has decreased
      if (this.paused() || iERC20Fulcrum(iToken).tokenPrice() < lastITokenPrice || _skipRebalance) {
        return redeemedTokens;
      }

      rebalance(0, _clientProtocolAmounts);
  }

  /**
   * Used to get `_clientProtocolAmounts` for `redeemIdleToken` method
   * This should be used only for a call not an actual tx
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   */
   function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
    external nonLocallyReentrant
    returns (address[] memory, uint256[] memory) {
      redeemIdleToken(_amount, _skipRebalance, new uint256[](0));
      return _getCurrentAllocations();
  }

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount)
    external nonReentrant {
      uint256 idleSupply = this.totalSupply();
      address currentToken;

      for (uint8 i = 0; i < currentTokensUsed.length; i++) {
        currentToken = currentTokensUsed[i];
        IERC20(currentToken).safeTransfer(
          msg.sender,
          _amount.mul(IERC20(currentToken).balanceOf(address(this))).div(idleSupply) // amount to redeem
        );
      }

      _burn(msg.sender, _amount);
  }

  /**
   * Here we are redeeming unclaimed token from iToken contract to this contracts
   * then allocating claimedTokens with rebalancing
   * Everyone should be incentivized in calling this method
   * NOTE: this method can be paused
   *
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return claimedTokens : amount of underlying tokens claimed
   */
  function claimITokens(uint256[] calldata _clientProtocolAmounts)
    external whenNotPaused whenITokenPriceHasNotDecreased
    returns (uint256 claimedTokens) {
      claimedTokens = iERC20Fulcrum(iToken).claimLoanToken();
      rebalance(claimedTokens, _clientProtocolAmounts);
  }

  /**
   * Dynamic allocate all the pool across different lending protocols if needed
   * Everyone should be incentivized in calling this method
   *
   * If _newAmount == 0 then simple rebalance
   * else rebalance (if needed) and mint (always)
   * NOTE: this method can be paused
   *
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256 _newAmount, uint256[] memory _clientProtocolAmounts)
    public whenNotPaused whenITokenPriceHasNotDecreased
    returns (bool) {
      // If we are using only one protocol we check if that protocol has still the best apr
      // if yes we check if it can support all `_newAmount` provided and still has the best apr

      bool shouldRebalance;
      address bestToken;

      if (currentTokensUsed.length == 1 && _newAmount > 0) {
        (shouldRebalance, bestToken) = _rebalanceCheck(_newAmount, currentTokensUsed[0]);

        if (!shouldRebalance) {
          // only one protocol is currently used and can support all the new liquidity
          _mintProtocolTokens(protocolWrappers[currentTokensUsed[0]], _newAmount);
          return false; // hasNotRebalanced
        }
      }

      // otherwise we redeem everything from every protocol and check if the protocol with the
      // best apr can support all the liquidity that we redeemed

      // - get current protocol used
      TokenProtocol[] memory tokenProtocols = _getCurrentProtocols();
      // - redeem everything from each protocol
      for (uint8 i = 0; i < tokenProtocols.length; i++) {
        _redeemProtocolTokens(
          tokenProtocols[i].protocolAddr,
          tokenProtocols[i].tokenAddr,
          IERC20(tokenProtocols[i].tokenAddr).balanceOf(address(this)),
          address(this) // tokens are now in this contract
        );
      }
      // remove all elements from `currentTokensUsed`
      delete currentTokensUsed;

      // tokenBalance here has already _newAmount counted
      uint256 tokenBalance = IERC20(token).balanceOf(address(this));
      if (tokenBalance == 0) {
        return false;
      }
      // (we are re-fetching aprs because after redeeming they changed)
      (shouldRebalance, bestToken) = _rebalanceCheck(tokenBalance, address(0));

      if (!shouldRebalance) {
        // only one protocol is currently used and can support all the new liquidity
        _mintProtocolTokens(protocolWrappers[bestToken], tokenBalance);
        // update current tokens used in IdleToken storage
        currentTokensUsed.push(bestToken);
        return false; // hasNotRebalanced
      }

      // if it's not the case we calculate the dynamic allocation for every protocol
      (address[] memory tokenAddresses, uint256[] memory protocolAmounts) = _calcAmounts(tokenBalance, _clientProtocolAmounts);

      // mint for each protocol and update currentTokensUsed
      uint256 currAmount;
      address currAddr;
      for (uint8 i = 0; i < protocolAmounts.length; i++) {
        currAmount = protocolAmounts[i];
        if (currAmount == 0) {
          continue;
        }
        currAddr = tokenAddresses[i];
        _mintProtocolTokens(protocolWrappers[currAddr], currAmount);
        // update current tokens used in IdleToken storage
        currentTokensUsed.push(currAddr);
      }

      emit Rebalance(tokenBalance);

      return true; // hasRebalanced
  }

  /**
   * Used to get `_clientProtocolAmounts` for `rebalance` method
   * This should be used only for a call not an actual tx
   * NOTE: this method can be paused
   *
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   */
  function getParamsForRebalance(uint256 _newAmount)
    external whenNotPaused whenITokenPriceHasNotDecreased
    returns (address[] memory, uint256[] memory) {
      rebalance(_newAmount, new uint256[](0));
      return _getCurrentAllocations();
  }

  // internal
  /**
   * Check if a rebalance is needed
   * if there is only one protocol and has the best rate then check the nextRateWithAmount()
   * if rate is still the highest then put everything there
   * otherwise rebalance with all amount
   *
   * @param _amount : amount of underlying tokens that needs to be added to the current pools NAV
   * @return : whether should rebalanced or not
   */

  function _rebalanceCheck(uint256 _amount, address currentToken)
    internal view
    returns (bool, address) {
      (address[] memory addresses, uint256[] memory aprs) = getAPRs();
      if (aprs.length == 0) {
        return (false, address(0));
      }

      // we are trying to find if the protocol with the highest APR can support all the liquidity
      // we intend to provide
      uint256 maxRate;
      address maxAddress;
      uint256 secondBestRate;
      uint256 currApr;
      address currAddr;

      // find best rate and secondBestRate
      for (uint8 i = 0; i < aprs.length; i++) {
        currApr = aprs[i];
        currAddr = addresses[i];
        if (currApr > maxRate) {
          secondBestRate = maxRate;
          maxRate = currApr;
          maxAddress = currAddr;
        } else if (currApr <= maxRate && currApr >= secondBestRate) {
          secondBestRate = currApr;
        }
      }

      if (currentToken != address(0) && currentToken != maxAddress) {
        return (true, maxAddress);
      } else {
        uint256 nextRate = _getProtocolNextRate(protocolWrappers[maxAddress], _amount);
        if (nextRate.add(minRateDifference) < secondBestRate) {
          return (true, maxAddress);
        }
      }

      return (false, maxAddress);
  }

  /**
   * Calls IdleRebalancer `calcRebalanceAmounts` method
   *
   * @param _amount : amount of underlying tokens that needs to be allocated on lending protocols
   * @return tokenAddresses : array with all token addresses used,
   * @return amounts : array with all amounts for each protocol in order,
   */
  function _calcAmounts(uint256 _amount, uint256[] memory _clientProtocolAmounts)
    internal view
    returns (address[] memory, uint256[] memory) {
      uint256[] memory paramsRebalance = new uint256[](_clientProtocolAmounts.length + 1);
      paramsRebalance[0] = _amount;

      for (uint8 i = 1; i <= _clientProtocolAmounts.length; i++) {
        paramsRebalance[i] = _clientProtocolAmounts[i-1];
      }

      return IdleRebalancer(rebalancer).calcRebalanceAmounts(paramsRebalance);
  }

  /**
   * Get addresses of current tokens and protocol wrappers used
   *
   * @return currentProtocolsUsed : array of `TokenProtocol` (currentToken address, protocolWrapper address)
   */
  function _getCurrentProtocols()
    internal view
    returns (TokenProtocol[] memory currentProtocolsUsed) {
      currentProtocolsUsed = new TokenProtocol[](currentTokensUsed.length);
      for (uint8 i = 0; i < currentTokensUsed.length; i++) {
        currentProtocolsUsed[i] = TokenProtocol(
          currentTokensUsed[i],
          protocolWrappers[currentTokensUsed[i]]
        );
      }
  }

  /**
   * Get the contract balance of every protocol currently used
   *
   * @return tokenAddresses : array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return amounts : array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   */
  function _getCurrentAllocations() internal view
    returns (address[] memory tokenAddresses, uint256[] memory amounts) {
      // Get balance of every protocol implemented
      tokenAddresses = new address[](allAvailableTokens.length);
      amounts = new uint256[](allAvailableTokens.length);

      address currentToken;
      uint256 currTokenPrice;

      for (uint8 i = 0; i < allAvailableTokens.length; i++) {
        currentToken = allAvailableTokens[i];
        tokenAddresses[i] = currentToken;
        currTokenPrice = ILendingProtocol(protocolWrappers[currentToken]).getPriceInToken();
        amounts[i] = currTokenPrice.mul(
          IERC20(currentToken).balanceOf(address(this))
        ).div(10**18);
      }

      // return addresses and respective amounts in underlying
      return (tokenAddresses, amounts);
  }

  // ILendingProtocols calls
  /**
   * Get next rate of a lending protocol given an amount to be lended
   *
   * @param _wrapperAddr : address of protocol wrapper
   * @param _amount : amount of underlying to be lended
   * @return apr : new apr one will get after lending `_amount`
   */
  function _getProtocolNextRate(address _wrapperAddr, uint256 _amount)
    internal view
    returns (uint256 apr) {
      ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
      apr = _wrapper.nextSupplyRate(_amount);
  }

  /**
   * Mint protocol tokens through protocol wrapper
   *
   * @param _wrapperAddr : address of protocol wrapper
   * @param _amount : amount of underlying to be lended
   * @return tokens : new tokens minted
   */
  function _mintProtocolTokens(address _wrapperAddr, uint256 _amount)
    internal
    returns (uint256 tokens) {
      if (_amount == 0) {
        return tokens;
      }
      ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
      // Transfer _amount underlying token (eg. DAI) to _wrapperAddr
      IERC20(token).safeTransfer(_wrapperAddr, _amount);
      tokens = _wrapper.mint();
  }

  /**
   * Redeem underlying tokens through protocol wrapper
   *
   * @param _wrapperAddr : address of protocol wrapper
   * @param _amount : amount of `_token` to redeem
   * @param _token : protocol token address
   * @param _account : should be msg.sender when rebalancing and final user when redeeming
   * @return tokens : new tokens minted
   */
  function _redeemProtocolTokens(address _wrapperAddr, address _token, uint256 _amount, address _account)
    internal
    returns (uint256 tokens) {
      if (_amount == 0) {
        return tokens;
      }
      ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
      // Transfer _amount of _protocolToken (eg. cDAI) to _wrapperAddr
      IERC20(_token).safeTransfer(_wrapperAddr, _amount);
      tokens = _wrapper.redeem(_account);
  }
}