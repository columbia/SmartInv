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

// File: @openzeppelin/contracts/math/Math.sol

pragma solidity ^0.5.0;

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

pragma solidity ^0.5.0;


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

// File: @openzeppelin/contracts/drafts/Counters.sol

pragma solidity ^0.5.0;


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

// File: @openzeppelin/contracts/drafts/ERC20Snapshot.sol

pragma solidity ^0.5.0;





/**
 * @title ERC20 token with snapshots.
 * @dev Inspired by Jordi Baylina's
 * https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol[MiniMeToken]
 * to record historical balances.
 *
 * When a snapshot is made, the balances and total supply at the time of the snapshot are recorded for later
 * access.
 *
 * To make a snapshot, call the {snapshot} function, which will emit the {Snapshot} event and return a snapshot id.
 * To get the total supply from a snapshot, call the function {totalSupplyAt} with the snapshot id.
 * To get the balance of an account from a snapshot, call the {balanceOfAt} function with the snapshot id and the
 * account address.
 * @author Validity Labs AG <info@validitylabs.org>
 */
contract ERC20Snapshot is ERC20 {
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

    event Snapshot(uint256 id);

    // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a
    // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid
    // when required, but is also flexible enough that it allows for e.g. daily snapshots.
    function snapshot() public returns (uint256) {
        _currentSnapshotId.increment();

        uint256 currentId = _currentSnapshotId.current();
        emit Snapshot(currentId);
        return currentId;
    }

    function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);

        return snapshotted ? value : balanceOf(account);
    }

    function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);

        return snapshotted ? value : totalSupply();
    }

    // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
    // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
    // The same is true for the total supply and _mint and _burn.
    function _transfer(address from, address to, uint256 value) internal {
        _updateAccountSnapshot(from);
        _updateAccountSnapshot(to);

        super._transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal {
        _updateAccountSnapshot(account);
        _updateTotalSupplySnapshot();

        super._mint(account, value);
    }

    function _burn(address account, uint256 value) internal {
        _updateAccountSnapshot(account);
        _updateTotalSupplySnapshot();

        super._burn(account, value);
    }

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
    function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
        private view returns (bool, uint256)
    {
        require(snapshotId > 0, "ERC20Snapshot: id is 0");
        // solhint-disable-next-line max-line-length
        require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");

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

// File: @openzeppelin/contracts/access/roles/MinterRole.sol

pragma solidity ^0.5.0;



contract MinterRole is Context {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(_msgSender());
    }

    modifier onlyMinter() {
        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(_msgSender());
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol

pragma solidity ^0.5.0;



/**
 * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
 * which have permission to mint (create) new tokens as they see fit.
 *
 * At construction, the deployer of the contract is the only minter.
 */
contract ERC20Mintable is ERC20, MinterRole {
    /**
     * @dev See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the {MinterRole}.
     */
    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }
}

// File: contracts/incentives/IIncentives.sol

pragma solidity ^0.5.17;

// A simple interface used by exchange to track rewards
interface IIncentives {
    // Tracks the rewards for traders / referrals based of the amount
    function rewardTrader(address traderAddress, address referalAddress, uint256 amount) external;

    // Tracks liquidity being removed
    function trackLiquidityRemoved(address liquidityProvider, uint256 amount) external;
}

// File: contracts/registry/IRegistry.sol

pragma solidity ^0.5.17;

contract IRegistry {
    function getVotingAddress() public view returns (address);

    function getExchangeFactoryAddress() public view returns (address);

    function getWethAddress() public view returns (address);

    function getMessageProcessorAddress() public view returns (address);

    function getFsTokenAddress() public view returns (address);

    function getFsTokenProxyAdminAddress() public view returns (address);

    function getIncentivesAddress() public view returns (address);

    function getWalletAddress() public view returns (address payable);

    function getReplayTrackerAddress() public view returns (address);

    function getLiquidityTokenFactoryAddress() public view returns (address);

    function hasLiquidityTokensnapshotAccess(address sender) public view returns (bool);

    function hasWalletAccess(address sender) public view returns (bool);

    function removeWalletAccess(address _walletAccessor) public;

    function isValidOracleAddress(address oracleAddress) public view returns (bool);

    function isValidVerifierAddress(address verifierAddress) public view returns (bool);

    function isValidStamperAddress(address stamperAddress) public view returns (bool);

    function isExchange(address exchangeAddress) public view returns (bool);

    function addExchange(address _exchange) public;

    function removeExchange(address _exchange) public;

    function updateVotingAddress(address _address) public;
}

// File: contracts/registry/IRegistryUpdateConsumer.sol

pragma solidity ^0.5.17;

// Implemented by objects that need to know about registry updates.
interface IRegistryUpdateConsumer {
    function onRegistryRefresh() external;
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

// File: contracts/registry/RegistryHolder.sol

pragma solidity ^0.5.17;



// Holds a reference to the registry
// Eventually Ownership will be renounced
contract RegistryHolder is Ownable {
    address private registryAddress;

    function getRegistryAddress() public view returns (address) {
        return registryAddress;
    }

    // Change the address of registry, if the caller is the voting system as identified by the old
    // registry.
    function updateRegistry(address _newAddress) public {
        require(isOwner() || isVotingSystem(), "Only owner or voting system");
        require(_newAddress != address(0), "Zero address");
        registryAddress = _newAddress;
    }

    function isVotingSystem() private view returns (bool) {
        if (registryAddress == address(0)) {
            return false;
        }
        return IRegistry(registryAddress).getVotingAddress() == msg.sender;
    }
}

// File: contracts/registry/KnowsRegistry.sol

pragma solidity ^0.5.17;




// Base class for objects that need to know about other objects in the system
// This allows us to share modifiers and have a unified way of looking up other objects.
contract KnowsRegistry is IRegistryUpdateConsumer {
    RegistryHolder private registryHolder;

    modifier onlyVotingSystem() {
        require(isVotingSystem(msg.sender), "Only voting system");
        _;
    }

    modifier onlyExchangeFactory() {
        require(isExchangeFactory(msg.sender), "Only exchange factory");
        _;
    }

    modifier onlyExchangeFactoryOrVotingSystem() {
        require(isExchangeFactory(msg.sender) || isVotingSystem(msg.sender), "Only exchange factory or voting");
        _;
    }

    modifier requiresWalletAcccess() {
        require(getRegistry().hasWalletAccess(msg.sender), "requires wallet access");
        _;
    }

    modifier onlyMessageProcessor() {
        require(getRegistry().getMessageProcessorAddress() == msg.sender, "only MessageProcessor");
        _;
    }

    modifier onlyExchange() {
        require(getRegistry().isExchange(msg.sender), "Only exchange");
        _;
    }

    modifier onlyRegistry() {
        require(getRegistryAddress() == msg.sender, "only registry");
        _;
    }

    modifier onlyOracle() {
        require(isValidOracleAddress(msg.sender), "only oracle");
        _;
    }

    modifier requiresLiquidityTokenSnapshotAccess() {
        require(getRegistry().hasLiquidityTokensnapshotAccess(msg.sender), "only incentives");
        _;
    }

    constructor(address _registryHolder) public {
        registryHolder = RegistryHolder(_registryHolder);
    }

    function getRegistryHolder() internal view returns (RegistryHolder) {
        return registryHolder;
    }

    function getRegistry() internal view returns (IRegistry) {
        return IRegistry(getRegistryAddress());
    }

    function getRegistryAddress() internal view returns (address) {
        return registryHolder.getRegistryAddress();
    }

    function isRegistryHolder(address a) internal view returns (bool) {
        return a == address(registryHolder);
    }

    function isValidOracleAddress(address oracleAddress) public view returns (bool) {
        return getRegistry().isValidOracleAddress(oracleAddress);
    }

    function isValidVerifierAddress(address verifierAddress) public view returns (bool) {
        return getRegistry().isValidVerifierAddress(verifierAddress);
    }

    function isValidStamperAddress(address stamperAddress) public view returns (bool) {
        return getRegistry().isValidStamperAddress(stamperAddress);
    }

    function isVotingSystem(address a) public view returns (bool) {
        return a == getRegistry().getVotingAddress();
    }

    function isExchangeFactory(address a) public view returns (bool) {
        return a == getRegistry().getExchangeFactoryAddress();
    }

    function checkNotNull(address a) internal pure returns (address) {
        require(a != address(0), "address must be non zero");
        return a;
    }

    function checkNotNullAP(address payable a) internal pure returns (address payable) {
        require(a != address(0), "address must be non zero");
        return a;
    }
}

// File: contracts/incentives/Incentives.sol

pragma solidity ^0.5.17;






contract Incentives is KnowsRegistry, IIncentives {
    using SafeMath for uint256;

    // A structure containin all data about an exchange
    struct ExchangeData {
        address exchangeAddress;
        // The liquidity token of the exchange
        ERC20Snapshot liquidityToken;
        uint256 defaultLiquidityPayoutMultiplier;
        uint256 defaultTraderPayoutMultiplier;
        uint256 defaultReferralPayoutMultiplier;
        uint256 defaultExchangeWeight;
        // A mapping for all epochs this exchange has been active
        mapping(uint16 => Epoch) epochEntries;
        // Has this exchange been removed
        bool isRemoved;
    }

    // An epoch entry for an exchange
    struct Epoch {
        uint256 snapShotId;
        uint256 liquidityPayoutMultiplier;
        uint256 traderPayoutMultiplier;
        uint256 referralPayoutMultiplier;
        uint256 exchangeWeight;
        uint256 sumOfExchangeWeights;
        uint256 totalLiquidityRemoved;
        mapping(address => uint256) traderPayout;
        mapping(address => uint256) referralPayout;
        mapping(address => uint256) withdrawnLiquidityByAddress;
        uint256 totalTraderPayout;
        uint256 totalReferralPayout;
        bool isActiveEpoch;
        mapping(address => bool) paidOutLiquidityByAddress;
        bool isRemoved;
    }

    event ReferralPayout(address _target, uint256 totalPayout);
    event TraderPayout(address _target, uint256 totalPayout);
    event LiquidityProviderPayout(address _target, uint256 totalPayout);

    // Reference to the fsToken contract
    ERC20Mintable public fsToken;

    // A mapping from exchange address to ExchangeData
    mapping(address => ExchangeData) public exchangeDataByExchangeAddress;
    // A list of all supported exchanges, when exchanges get removed they simply get marked as removed
    // in the ExchangeData / EpochEntry
    address[] private allExchangeAddresses;

    // The count of epochs since this contract has launched
    uint16 public epochCount;

    // The maximum epoch this contract will run for ~5 years
    uint16 public maxEpoch = 1750;
    uint256 public totalTokensToMintPerEpoch = 40000 ether;
    // Time until the next epoch can be rolled forward
    // We chose slightly less than 24 hrs since we expect this to drift over time
    // allowing us to make up for a slight drift by sending the transaction slightly earlier
    uint256 public epochAdvanceTime = 23 hours + 55 minutes;

    uint256 public lastUpdateTimestamp = now;
    // The sum of all exchanges weight that are being active.
    uint256 public currentSumOfExchangeWeights;

    // will not payout to LP's if less to minRequiredSnapshotId
    uint256 public minRequiredSnapshotId = 0;

    constructor(address _registryHolder) public KnowsRegistry(_registryHolder) {
        fsToken = ERC20Mintable(getRegistry().getFsTokenAddress());
    }

    function setMaxEpoch(uint16 _maxEpoch) public onlyVotingSystem {
        maxEpoch = _maxEpoch;
    }
    function setTotalTokensToMintPerEpoch(uint256 _totalTokensToMintPerEpoch) public onlyVotingSystem {
        totalTokensToMintPerEpoch = _totalTokensToMintPerEpoch;
    }
    function setEpochAdvanceTime(uint256 _epochAdvanceTime) public onlyVotingSystem {
        epochAdvanceTime = _epochAdvanceTime;
    }
    function setMinRequiredSnapshotId(uint256 _minRequiredSnapshotId) public onlyVotingSystem {
        minRequiredSnapshotId = _minRequiredSnapshotId;
    }

    // Moves the contract one epoch forward.
    // Enables the previous epoch to be paid out.
    // Enables the new current epoch to track rewards.
    function advanceEpoch() public {
        if (epochCount > maxEpoch) {
            revert("past max epochs");
        }

        if (now.sub(lastUpdateTimestamp) < epochAdvanceTime) {
            revert("wait for a epoch to pass");
        }

        lastUpdateTimestamp = lastUpdateTimestamp + epochAdvanceTime;

        uint16 oldEpoch = epochCount;
        bool hasNewEpoch = epochCount < maxEpoch;
        epochCount++;

        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            ExchangeData storage data = exchangeDataByExchangeAddress[allExchangeAddresses[i]];
            Epoch storage oldEpochData = data.epochEntries[oldEpoch];
            if (oldEpochData.isActiveEpoch) {
                oldEpochData.isActiveEpoch = false;
            }

            if (hasNewEpoch) {
                Epoch storage epoch = data.epochEntries[epochCount];
                epoch.liquidityPayoutMultiplier = data.defaultLiquidityPayoutMultiplier;
                epoch.traderPayoutMultiplier = data.defaultTraderPayoutMultiplier;
                epoch.referralPayoutMultiplier = data.defaultReferralPayoutMultiplier;
                epoch.exchangeWeight = data.defaultExchangeWeight;
                epoch.sumOfExchangeWeights = currentSumOfExchangeWeights;
                epoch.isActiveEpoch = true;
                epoch.snapShotId = data.liquidityToken.snapshot();
                epoch.isRemoved = data.isRemoved;
            }
        }
    }

    // Changes the payout distribution for a given exchange
    function updatePayoutDistribution(
        address _exchangeAddress,
        uint256 _liquidityPayoutMultiplier,
        uint256 _traderPayoutMultiplier,
        uint256 _referralPayoutMultiplier,
        uint256 defaultExchangeWeight
    ) public onlyExchangeFactoryOrVotingSystem {
        require(
            _liquidityPayoutMultiplier.add(_traderPayoutMultiplier).add(_referralPayoutMultiplier) == 1 ether,
            "!= 1"
        );

        requireExchangeExists(_exchangeAddress);

        ExchangeData storage data = exchangeDataByExchangeAddress[_exchangeAddress];

        currentSumOfExchangeWeights = currentSumOfExchangeWeights.add(defaultExchangeWeight).sub(
            data.defaultExchangeWeight
        );

        data.defaultLiquidityPayoutMultiplier = _liquidityPayoutMultiplier;
        data.defaultTraderPayoutMultiplier = _traderPayoutMultiplier;
        data.defaultReferralPayoutMultiplier = _referralPayoutMultiplier;
        data.defaultExchangeWeight = defaultExchangeWeight;

        // Updating the current epoch
        Epoch storage epoch = data.epochEntries[epochCount];
        if (epoch.isActiveEpoch) {
            epoch.liquidityPayoutMultiplier = _liquidityPayoutMultiplier;
            epoch.traderPayoutMultiplier = _traderPayoutMultiplier;
            epoch.referralPayoutMultiplier = _referralPayoutMultiplier;
            epoch.exchangeWeight = defaultExchangeWeight;
        }

        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            ExchangeData storage exchangeData = exchangeDataByExchangeAddress[allExchangeAddresses[i]];
            Epoch storage exchangeEpoch = exchangeData.epochEntries[epochCount];
            if (epoch.isActiveEpoch) {
                exchangeEpoch.sumOfExchangeWeights = currentSumOfExchangeWeights;
            }
        }
    }

    // Adds an exchange creating its associated data structures
    function addExchange(address _exchange, address _liquidityToken) public onlyExchangeFactoryOrVotingSystem {
        require(exchangeDataByExchangeAddress[_exchange].exchangeAddress == address(0), "exchange should not exists");

        allExchangeAddresses.push(_exchange);
        ExchangeData storage data = exchangeDataByExchangeAddress[_exchange];
        data.exchangeAddress = _exchange;
        data.liquidityToken = ERC20Snapshot(_liquidityToken);

        // init epoch
        Epoch storage epoch = data.epochEntries[epochCount];
        epoch.isActiveEpoch = true;
        epoch.snapShotId = data.liquidityToken.snapshot();
    }

    // Removes an exchange
    // Instead of actually deleting its mapping it will be marked as removed
    function removeExchange(address _exchange) public onlyExchangeFactoryOrVotingSystem {
        if (address(exchangeDataByExchangeAddress[_exchange].exchangeAddress) == address(0)) {
            return;
        }

        ExchangeData storage data = exchangeDataByExchangeAddress[_exchange];
        currentSumOfExchangeWeights = currentSumOfExchangeWeights < data.defaultExchangeWeight
            ? 0
            : currentSumOfExchangeWeights.sub(data.defaultExchangeWeight);

        data.isRemoved = true;
    }

    // Serves as a safety switch to disable minting for FST in case there is a problem with incentives
    function renounceMinter() public onlyVotingSystem {
        fsToken.renounceMinter();
    }

    // See IIncentives#rewardTrader
    function rewardTrader(address _trader, address _referral, uint256 _amount) public onlyExchange {
        Epoch storage epoch = getActiveEpoch(msg.sender);

        epoch.traderPayout[_trader] = epoch.traderPayout[_trader].add(_amount);
        epoch.totalTraderPayout = epoch.totalTraderPayout.add(_amount);

        if (_referral != address(0)) {
            epoch.referralPayout[_referral] = epoch.referralPayout[_referral].add(_amount);
            epoch.totalReferralPayout = epoch.totalReferralPayout.add(_amount);
        }
    }

    // See IIncentives#trackLiquidityRemoved
    function trackLiquidityRemoved(address _liquidityProvider, uint256 _amount) public onlyExchange {
        Epoch storage epoch = getActiveEpoch(msg.sender);
        ExchangeData storage data = exchangeDataByExchangeAddress[msg.sender];

        uint256 maxWithdraw = data.liquidityToken.balanceOfAt(_liquidityProvider, epoch.snapShotId);

        uint256 currentWithdrawn = epoch.withdrawnLiquidityByAddress[_liquidityProvider];
        uint256 userTotalWithdrawn = currentWithdrawn.add(_amount);
        epoch.withdrawnLiquidityByAddress[_liquidityProvider] = userTotalWithdrawn;
        uint256 toAdd = userTotalWithdrawn <= maxWithdraw ? _amount : currentWithdrawn >= maxWithdraw
            ? 0
            : maxWithdraw.sub(currentWithdrawn);
        epoch.totalLiquidityRemoved = epoch.totalLiquidityRemoved.add(toAdd);
    }

    function getActiveEpoch(address exchange) private view returns (Epoch storage) {
        require(epochCount < maxEpoch, "max epoch reached");

        ExchangeData storage data = exchangeDataByExchangeAddress[exchange];
        require(!data.isRemoved, "Exchange is removed");

        Epoch storage epochEntry = data.epochEntries[epochCount];
        require(epochEntry.isActiveEpoch, "Epoch should be active");
        return epochEntry;
    }

    // Payout a trader for a given set of epochs
    function payoutTrader(address _target, uint16[] memory _epochs) public {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(calculateTraderPayout(epochEntry, _target));
                // Zero out payment to mark it as withdrawn
                epochEntry.traderPayout[_target] = 0;
            }
        }
        fsToken.mint(_target, totalPayout);
        emit TraderPayout(_target, totalPayout);
    }

    // Get the payout for a trader for a given set of epochs
    function getTraderPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(calculateTraderPayout(epochEntry, _target));
            }
        }
        return totalPayout;
    }

    function calculateTraderPayout(Epoch storage epochEntry, address trader) private view returns (uint256) {
        if (epochEntry.totalTraderPayout == 0 || epochEntry.sumOfExchangeWeights == 0) {
            return 0;
        }

        uint256 traderValue = epochEntry.traderPayout[trader];

        uint256 payoutAmount = totalTokensToMintPerEpoch
            .mul(traderValue)
            .div(epochEntry.totalTraderPayout)
            .mul(epochEntry.traderPayoutMultiplier)
            .div(1 ether)
            .mul(epochEntry.exchangeWeight)
            .div(epochEntry.sumOfExchangeWeights);

        return payoutAmount;
    }

    // Payout referrals for a given set of epochs
    function payoutReferral(address _target, uint16[] memory _epochs) public {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(calculateReferralPayout(epochEntry, _target));
                // Zero out payment to mark it as withdrawn
                epochEntry.referralPayout[_target] = 0;
            }
        }
        fsToken.mint(_target, totalPayout);
        emit ReferralPayout(_target, totalPayout);
    }

    // Get payout referrals for a given set of epochs
    function getReferralPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(calculateReferralPayout(epochEntry, _target));
            }
        }
        return totalPayout;
    }

    function calculateReferralPayout(Epoch storage epochEntry, address referral) private view returns (uint256) {
        if (epochEntry.totalReferralPayout == 0 || epochEntry.sumOfExchangeWeights == 0) {
            return 0;
        }

        uint256 referralValue = epochEntry.referralPayout[referral];

        uint256 payoutAmount = totalTokensToMintPerEpoch
            .mul(referralValue)
            .div(epochEntry.totalReferralPayout)
            .mul(epochEntry.referralPayoutMultiplier)
            .div(1 ether)
            .mul(epochEntry.exchangeWeight)
            .div(epochEntry.sumOfExchangeWeights);

        return payoutAmount;
    }

    // Payout liquidity providers for a given set of epochs
    function payoutLiquidityProvider(address _target, uint16[] memory _epochs) public {
        uint256 totalPayout = 0;

        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(
                    calculateLiquidityProviderPayout(_target, allExchangeAddresses[i], epochEntry)
                );
                // Ensure liquidity rewards can not be withdrawn twice for a epoch
                require(!epochEntry.paidOutLiquidityByAddress[_target], "Already paid out");
                epochEntry.paidOutLiquidityByAddress[_target] = true;
            }
        }
        fsToken.mint(_target, totalPayout);
        emit LiquidityProviderPayout(_target, totalPayout);
    }

    // Get Payout for liquidity providers for a given set of epochs
    function getLiquidityProviderPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
            for (uint256 j = 0; j < _epochs.length; j++) {
                Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
                totalPayout = totalPayout.add(
                    calculateLiquidityProviderPayout(_target, allExchangeAddresses[i], epochEntry)
                );
            }
        }
        return totalPayout;
    }

    function calculateLiquidityProviderPayout(
        address liquidityProvider,
        address exchangeAddress,
        Epoch storage epochEntry
    ) private view returns (uint256) {
        if (epochEntry.isRemoved) {
            return 0;
        }

        if (epochEntry.snapShotId < minRequiredSnapshotId) {
            return 0;
        }

        ExchangeData storage data = exchangeDataByExchangeAddress[exchangeAddress];

        uint256 totalLiquidity = data.liquidityToken.totalSupplyAt(epochEntry.snapShotId);
        if (totalLiquidity == 0 || epochEntry.sumOfExchangeWeights == 0) {
            return 0;
        }

        uint256 adjustedLiquidity = totalLiquidity.sub(epochEntry.totalLiquidityRemoved);
        if (adjustedLiquidity == 0) {
            return 0;
        }

        uint256 withdrawnLiquidity = epochEntry.withdrawnLiquidityByAddress[liquidityProvider];
        uint256 providedLiquidity = data.liquidityToken.balanceOfAt(liquidityProvider, epochEntry.snapShotId);
        uint256 liquidityProvidedInEpoch = providedLiquidity > withdrawnLiquidity
            ? providedLiquidity.sub(withdrawnLiquidity)
            : 0;

        uint256 payoutAmount = totalTokensToMintPerEpoch
            .mul(liquidityProvidedInEpoch)
            .div(adjustedLiquidity)
            .mul(epochEntry.liquidityPayoutMultiplier)
            .div(1 ether)
            .mul(epochEntry.exchangeWeight)
            .div(epochEntry.sumOfExchangeWeights);

        return payoutAmount;
    }

    function getEpochOrDie(address exchangeAddress, uint16 epoch) private view returns (Epoch storage) {
        requireExchangeExists(exchangeAddress);
        ExchangeData storage data = exchangeDataByExchangeAddress[exchangeAddress];
        Epoch storage epochEntry = data.epochEntries[epoch];

        require(!epochEntry.isActiveEpoch, "epoch can not be withdrawn yet");
        return epochEntry;
    }

    function requireExchangeExists(address exchangeAddress) private view {
        require(
            address(exchangeDataByExchangeAddress[exchangeAddress].exchangeAddress) != address(0),
            "Exchange does not exist"
        );
    }

    function onRegistryRefresh() public onlyRegistry {
        fsToken = ERC20Mintable(checkNotNull(getRegistry().getFsTokenAddress()));
    }

    function getAllExchangeAddresses() public view returns (address[] memory) {
        return allExchangeAddresses;
    }

    function getExchangeDataByAddress(address exchangeAddress)
        public
        view
        returns (address, uint256, uint256, uint256, uint256, bool)
    {
        ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];

        return (
            address(ex.liquidityToken),
            ex.defaultLiquidityPayoutMultiplier,
            ex.defaultTraderPayoutMultiplier,
            ex.defaultReferralPayoutMultiplier,
            ex.defaultExchangeWeight,
            ex.isRemoved
        );
    }

    function getExchangeEpoch(address exchangeAddress, uint16 epochNumber)
        public
        view
        returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool, bool)
    {
        ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];
        Epoch storage epoch = ex.epochEntries[epochNumber];

        return (
            epoch.snapShotId,
            epoch.liquidityPayoutMultiplier,
            epoch.traderPayoutMultiplier,
            epoch.referralPayoutMultiplier,
            epoch.exchangeWeight,
            epoch.sumOfExchangeWeights,
            epoch.totalTraderPayout,
            epoch.totalReferralPayout,
            epoch.isActiveEpoch,
            epoch.isRemoved
        );
    }

    function getExchangeEpochByUser(address exchangeAddress, uint16 epochNumber, address userAddress)
        public
        view
        returns (uint256, uint256, uint256, bool, uint256)
    {
        ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];
        Epoch storage epoch = ex.epochEntries[epochNumber];

        return (
            epoch.traderPayout[userAddress],
            epoch.referralPayout[userAddress],
            epoch.withdrawnLiquidityByAddress[userAddress],
            epoch.paidOutLiquidityByAddress[userAddress],
            calculateLiquidityProviderPayout(userAddress, exchangeAddress, epoch)
        );
    }
}