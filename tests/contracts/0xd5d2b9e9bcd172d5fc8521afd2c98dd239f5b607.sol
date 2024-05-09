// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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
        require(b <= a, "SafeMath: subtraction overflow");
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
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
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
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

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.0;



/**
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
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

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
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
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

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

// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol

pragma solidity ^0.5.0;


contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
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

// File: contracts/token/ERC20Interface.sol

pragma solidity 0.5.9;


interface ERC20Interface {
  // Standard ERC-20 interface.
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  // Extension of ERC-20 interface to support supply adjustment.
  function mint(address to, uint256 value) external returns (bool);
  function burn(address from, uint256 value) external returns (bool);
}

// File: contracts/token/ERC20Base.sol

pragma solidity 0.5.9;





/// "ERC20Base" is the standard ERC-20 implementation that allows its minter to mint tokens. Both BandToken and
/// CommunityToken extend from ERC20Base. In addition to the standard functions, the class provides `transferAndCall`
/// function, which performs a transfer and invokes the given function using the provided data. If the destination
/// contract uses "ERC20Acceptor" interface, it can verify that the caller properly sends appropriate amount of tokens.
contract ERC20Base is ERC20Interface, ERC20, MinterRole {
  string public name;
  string public symbol;
  uint8 public decimals = 18;

  constructor(string memory _name, string memory _symbol) public {
    name = _name;
    symbol = _symbol;
  }

  function transferAndCall(address to, uint256 value, bytes4 sig, bytes memory data) public returns (bool) {
    require(to != address(this));
    _transfer(msg.sender, to, value);
    (bool success,) = to.call(abi.encodePacked(sig, uint256(msg.sender), value, data));
    require(success);
    return true;
  }

  function mint(address to, uint256 value) public onlyMinter returns (bool) {
    _mint(to, value);
    return true;
  }

  function burn(address from, uint256 value) public onlyMinter returns (bool) {
    _burn(from, value);
    return true;
  }
}

// File: contracts/token/SnapshotToken.sol

pragma solidity 0.5.9;




contract SnapshotToken is ERC20Base {
  using SafeMath for uint256;

  /// IMPORTANT: votingPowers are kept as a linked list of ALL historical changes.
  /// - This allows the contract to figure out voting power of the address at any nonce `n`, by
  /// searching for the node that has the biggest nonce that is not greater than `n`.
  /// - For efficiency, nonce and power are packed into one uint256 integer, with the top 64 bits
  /// representing nonce, and the bottom 192 bits representing voting power.
  mapping (address => mapping(uint256 => uint256)) _votingPower;
  mapping (address => uint256) public votingPowerChangeCount;
  uint256 public votingPowerChangeNonce = 0;

  /// Returns user voting power at the given index, that is, as of the user's index^th voting power change
  function historicalVotingPowerAtIndex(address owner, uint256 index) public view returns (uint256) {
    require(index <= votingPowerChangeCount[owner]);
    return _votingPower[owner][index] & ((1 << 192) - 1);  // Lower 192 bits
  }

  /// Returns user voting power at the given time. Under the hood, this performs binary search
  /// to look for the largest index at which the nonce is not greater than 'nonce'.
  /// The voting power at that index is the returning value.
  function historicalVotingPowerAtNonce(address owner, uint256 nonce) public view returns (uint256) {
    require(nonce <= votingPowerChangeNonce && nonce < (1 << 64));
    uint256 start = 0;
    uint256 end = votingPowerChangeCount[owner];
    while (start < end) {
      uint256 mid = start.add(end).add(1).div(2); /// Use (start+end+1)/2 to prevent infinite loop.
      if ((_votingPower[owner][mid] >> 192) > nonce) {  /// Upper 64-bit nonce
        /// If midTime > nonce, this mid can't possibly be the answer.
        end = mid.sub(1);
      } else {
        /// Otherwise, search on the greater side, but still keep mid as a possible option.
        start = mid;
      }
    }
    return historicalVotingPowerAtIndex(owner, start);
  }

  function _transfer(address from, address to, uint256 value) internal {
    super._transfer(from, to, value);
    votingPowerChangeNonce = votingPowerChangeNonce.add(1);
    _changeVotingPower(from);
    _changeVotingPower(to);
  }

  function _mint(address account, uint256 amount) internal {
    super._mint(account, amount);
    votingPowerChangeNonce = votingPowerChangeNonce.add(1);
    _changeVotingPower(account);
  }

  function _burn(address account, uint256 amount) internal {
    super._burn(account, amount);
    votingPowerChangeNonce = votingPowerChangeNonce.add(1);
    _changeVotingPower(account);
  }

  function _changeVotingPower(address account) internal {
    uint256 currentIndex = votingPowerChangeCount[account];
    uint256 newPower = balanceOf(account);
    require(newPower < (1 << 192));
    require(votingPowerChangeNonce < (1 << 64));
    currentIndex = currentIndex.add(1);
    votingPowerChangeCount[account] = currentIndex;
    _votingPower[account][currentIndex] = (votingPowerChangeNonce << 192) | newPower;
  }
}

// File: contracts/BandToken.sol

pragma solidity 0.5.9;




/// "BandToken" is the native ERC-20 token of Band Protocol.
contract BandToken is ERC20Base("BandToken", "BAND"), SnapshotToken {}

// File: contracts/data/WhiteListInterface.sol

pragma solidity 0.5.9;

interface WhiteListInterface {
  function verify(address reader) external view returns (bool);
}

// File: contracts/exchange/BandExchangeInterface.sol

pragma solidity 0.5.9;


interface BandExchangeInterface {
  function convertFromEthToBand() external payable returns (uint256);
}

// File: contracts/BandRegistry.sol

pragma solidity 0.5.9;






/// "BandRegistry" keeps the addresses of three main smart contracts inside of Band Protocol ecosystem:
///   1. "band" - Band Protocol's native ERC-20 token.
///   2. "exchange" - Decentralized exchange for converting ETH to Band and vice versa.
///   3. "whiteList" - Smart contract for validating non-malicious data consumers.
contract BandRegistry is Ownable {
  BandToken public band;
  BandExchangeInterface public exchange;
  WhiteListInterface public whiteList;

  constructor(BandToken _band, BandExchangeInterface _exchange) public {
    band = _band;
    exchange = _exchange;
  }

  function verify(address reader) public view returns (bool) {
    if (address(whiteList) == address(0)) return true;
    return whiteList.verify(reader);
  }

  function setWhiteList(WhiteListInterface _whiteList) public onlyOwner {
    whiteList = _whiteList;
  }

  function setExchange(BandExchangeInterface _exchange) public onlyOwner {
    exchange = _exchange;
  }
}

// File: contracts/data/QueryInterface.sol

pragma solidity 0.5.9;



/// "QueryInterface" provides the standard `query` method for querying Band Protocol's curated data. The function
/// makes sure that query callers are not blacklisted and pay appropriate fee, as specified by `queryPrice` prior
/// to calling the meat `queryImpl` function.
contract QueryInterface {
  enum QueryStatus { INVALID, OK, NOT_AVAILABLE, DISAGREEMENT }
  event Query(address indexed caller, bytes input, QueryStatus status);
  BandRegistry public registry;

  constructor(BandRegistry _registry) public {
    registry = _registry;
  }

  function query(bytes calldata input)
    external payable returns (bytes32 output, uint256 updatedAt, QueryStatus status)
  {
    require(registry.verify(msg.sender));
    uint256 price = queryPrice();
    require(msg.value >= price);
    if (msg.value > price) msg.sender.transfer(msg.value - price);
    (output, updatedAt, status) = queryImpl(input);
    emit Query(msg.sender, input, status);
  }

  function queryPrice() public view returns (uint256);
  function queryImpl(bytes memory input)
    internal returns (bytes32 output, uint256 updatedAt, QueryStatus status);
}

// File: contracts/utils/Fractional.sol

pragma solidity 0.5.9;



/// "Fractional" library facilitate fixed point decimal computation. In Band Protocol, fixed point decimal can be
/// represented using `uint256` data type. The decimal is fixed at 18 digits and `mulFrac` can be used to multiply
/// the fixed point decimal with an ordinary `uint256` value.
library Fractional {
  using SafeMath for uint256;
  uint256 internal constant DENOMINATOR = 1e18;

  function getDenominator() internal pure returns (uint256) {
    return DENOMINATOR;
  }

  function mulFrac(uint256 numerator, uint256 value) internal pure returns(uint256) {
    return numerator.mul(value).div(DENOMINATOR);
  }
}

// File: contracts/token/ERC20Acceptor.sol

pragma solidity 0.5.9;



/// "ERC20Acceptor" is a utility smart contract that provides `requireToken` modifier for any contract that intends
/// to have functions that accept ERC-20 token transfer to inherit.
contract ERC20Acceptor {
  /// A modifer to decorate function that requires ERC-20 transfer. If called by ERC-20
  /// contract, the modifier trusts that the transfer already occurs. Otherwise, the modifier
  /// invokes 'transferFrom' to ensure that appropriate amount of tokens is paid properly.
  modifier requireToken(ERC20Interface token, address sender, uint256 amount) {
    if (msg.sender != address(token)) {
      require(sender == msg.sender);
      require(token.transferFrom(sender, address(this), amount));
    }
    _;
  }
}

// File: contracts/utils/Expression.sol

pragma solidity 0.5.9;


interface Expression {
  /// Return the result of evaluating the expression given a variable value
  function evaluate(uint256 x) external view returns (uint256);
}

// File: contracts/Parameters.sol

pragma solidity 0.5.9;






/// "Parameters" contract controls how other smart contracts behave through a key-value mapping, which other contracts
/// will query using `get` or `getRaw` functions. Every dataset community has one governance parameters contract.
/// Additionally, there is one parameter contract that is controlled by BandToken for protocol-wide parameters.
/// Conducting parameter changes can be done through the following process.
///   1. Anyone can propose for a change by sending a `propose` transaction, which will assign an ID to the proposal.
///   2. While the proposal is open, token holders can vote for approval or rejection through `vote` function.
///   3. After the voting period ends, if the proposal receives enough participation and support, it will get accepted.
///      `resolve` function must to be called to trigger the decision process.
///   4. Additionally, to facilitate unanimous parameter changes, a proposal is automatically resolved prior to its
///      expiration if more than the required percentage of ALL tokens approve the proposal.
/// Parameters contract uses the following parameters for its internal logic. These parameters can be change via the
/// same proposal process.
///   `params:expiration_time`: Number of seconds that a proposal stays open after getting proposed.
///   `params:min_participation_pct`: % of tokens required to participate in order for a proposal to be considered.
///   `params:support_required_pct`: % of participating tokens required to approve a proposal.
/// Parameters contract is "Ownable" initially to allow its owner to overrule the parameters during the initial
/// deployment as a measure against possible smart contract vulnerabilities. Owner can be set to 0x0 address afterwards.
contract Parameters is Ownable {
  using SafeMath for uint256;
  using Fractional for uint256;

  event ProposalProposed(uint256 indexed proposalId, address indexed proposer, bytes32 reasonHash);
  event ProposalVoted(uint256 indexed proposalId, address indexed voter, bool vote, uint256 votingPower);
  event ProposalAccepted(uint256 indexed proposalId);
  event ProposalRejected(uint256 indexed proposalId);
  event ParameterChanged(bytes32 indexed key, uint256 value);
  event ParameterProposed(uint256 indexed proposalId, bytes32 indexed key, uint256 value);

  struct ParameterValue { bool existed; uint256 value; }
  struct KeyValue { bytes32 key; uint256 value; }
  enum ProposalState { INVALID, OPEN, ACCEPTED, REJECTED }

  struct Proposal {
    uint256 changesCount;                   /// The number of parameter changes
    mapping (uint256 => KeyValue) changes;  /// The list of parameter changes in proposal
    uint256 snapshotNonce;                  /// The votingPowerNonce to count voting power
    uint256 expirationTime;                 /// The time at which this proposal resolves
    uint256 voteSupportRequiredPct;         /// Threshold % for determining proposal acceptance
    uint256 voteMinParticipation;           /// The minimum # of votes required
    uint256 totalVotingPower;               /// The total voting power at this snapshotNonce
    uint256 yesCount;                       /// The current total number of YES votes
    uint256 noCount;                        /// The current total number of NO votes
    mapping (address => bool) isVoted;      /// Mapping for check who already voted
    ProposalState proposalState;            /// Current state of this proposal.
  }

  SnapshotToken public token;
  Proposal[] public proposals;
  mapping (bytes32 => ParameterValue) public params;

  constructor(SnapshotToken _token) public {
    token = _token;
  }

  function get(bytes8 namespace, bytes24 key) public view returns (uint256) {
    uint8 namespaceSize = 0;
    while (namespaceSize < 8 && namespace[namespaceSize] != byte(0)) ++namespaceSize;
    return getRaw(bytes32(namespace) | (bytes32(key) >> (8 * namespaceSize)));
  }

  function getRaw(bytes32 rawKey) public view returns (uint256) {
    ParameterValue storage param = params[rawKey];
    require(param.existed);
    return param.value;
  }

  function set(bytes8 namespace, bytes24[] memory keys, uint256[] memory values) public onlyOwner {
    require(keys.length == values.length);
    bytes32[] memory rawKeys = new bytes32[](keys.length);
    uint8 namespaceSize = 0;
    while (namespaceSize < 8 && namespace[namespaceSize] != byte(0)) ++namespaceSize;
    for (uint256 i = 0; i < keys.length; i++) {
      rawKeys[i] = bytes32(namespace) | bytes32(keys[i]) >> (8 * namespaceSize);
    }
    setRaw(rawKeys, values);
  }

  function setRaw(bytes32[] memory rawKeys, uint256[] memory values) public onlyOwner {
    require(rawKeys.length == values.length);
    for (uint256 i = 0; i < rawKeys.length; i++) {
      params[rawKeys[i]].existed = true;
      params[rawKeys[i]].value = values[i];
      emit ParameterChanged(rawKeys[i], values[i]);
    }
  }

  function getProposalChange(uint256 proposalId, uint256 changeIndex) public view returns (bytes32, uint256) {
    KeyValue memory keyValue = proposals[proposalId].changes[changeIndex];
    return (keyValue.key, keyValue.value);
  }

  function propose(bytes32 reasonHash, bytes32[] calldata keys, uint256[] calldata values) external {
    require(keys.length == values.length);
    uint256 proposalId = proposals.length;
    proposals.push(Proposal({
      changesCount: keys.length,
      snapshotNonce: token.votingPowerChangeNonce(),
      expirationTime: now.add(getRaw("params:expiration_time")),
      voteSupportRequiredPct: getRaw("params:support_required_pct"),
      voteMinParticipation: getRaw("params:min_participation_pct").mulFrac(token.totalSupply()),
      totalVotingPower: token.totalSupply(),
      yesCount: 0,
      noCount: 0,
      proposalState: ProposalState.OPEN
    }));
    emit ProposalProposed(proposalId, msg.sender, reasonHash);
    for (uint256 index = 0; index < keys.length; ++index) {
      bytes32 key = keys[index];
      uint256 value = values[index];
      emit ParameterProposed(proposalId, key, value);
      proposals[proposalId].changes[index] = KeyValue({key: key, value: value});
    }
  }

  function vote(uint256 proposalId, bool accepted) public {
    Proposal storage proposal = proposals[proposalId];
    require(proposal.proposalState == ProposalState.OPEN);
    require(now < proposal.expirationTime);
    require(!proposal.isVoted[msg.sender]);
    uint256 votingPower = token.historicalVotingPowerAtNonce(msg.sender, proposal.snapshotNonce);
    require(votingPower > 0);
    if (accepted) {
      proposal.yesCount = proposal.yesCount.add(votingPower);
    } else {
      proposal.noCount = proposal.noCount.add(votingPower);
    }
    proposal.isVoted[msg.sender] = true;
    emit ProposalVoted(proposalId, msg.sender, accepted, votingPower);
    uint256 minVoteToAccept = proposal.voteSupportRequiredPct.mulFrac(proposal.totalVotingPower);
    uint256 minVoteToReject = proposal.totalVotingPower.sub(minVoteToAccept);
    if (proposal.yesCount >= minVoteToAccept) {
      _acceptProposal(proposalId);
    } else if (proposal.noCount > minVoteToReject) {
      _rejectProposal(proposalId);
    }
  }

  function resolve(uint256 proposalId) public {
    Proposal storage proposal = proposals[proposalId];
    require(proposal.proposalState == ProposalState.OPEN);
    require(now >= proposal.expirationTime);
    uint256 yesCount = proposal.yesCount;
    uint256 noCount = proposal.noCount;
    uint256 totalCount = yesCount.add(noCount);
    if (totalCount >= proposal.voteMinParticipation &&
        yesCount.mul(Fractional.getDenominator()) >= proposal.voteSupportRequiredPct.mul(totalCount)) {
      _acceptProposal(proposalId);
    } else {
      _rejectProposal(proposalId);
    }
  }

  function _acceptProposal(uint256 proposalId) internal {
    Proposal storage proposal = proposals[proposalId];
    proposal.proposalState = ProposalState.ACCEPTED;
    for (uint256 index = 0; index < proposal.changesCount; ++index) {
      bytes32 key = proposal.changes[index].key;
      uint256 value = proposal.changes[index].value;
      params[key].existed = true;
      params[key].value = value;
      emit ParameterChanged(key, value);
    }
    emit ProposalAccepted(proposalId);
  }

  function _rejectProposal(uint256 proposalId) internal {
    Proposal storage proposal = proposals[proposalId];
    proposal.proposalState = ProposalState.REJECTED;
    emit ProposalRejected(proposalId);
  }
}

// File: contracts/exchange/BondingCurve.sol

pragma solidity 0.5.9;








contract BondingCurve is ERC20Acceptor {
  using SafeMath for uint256;
  using Fractional for uint256;

  event Buy(address indexed buyer, uint256 bondedTokenAmount, uint256 collateralTokenAmount);
  event Sell(address indexed seller, uint256 bondedTokenAmount, uint256 collateralTokenAmount);
  event Deflate(address indexed burner, uint256 burnedAmount);
  event RevenueCollect(address indexed beneficiary, uint256 bondedTokenAmount);

  ERC20Interface public collateralToken;
  ERC20Interface public bondedToken;
  Parameters public params;

  uint256 public currentMintedTokens;
  uint256 public currentCollateral;
  uint256 public lastInflationTime = now;

  constructor(ERC20Interface _collateralToken, ERC20Interface _bondedToken, Parameters _params) public {
    collateralToken = _collateralToken;
    bondedToken = _bondedToken;
    params = _params;
  }

  function getRevenueBeneficiary() public view returns (address) {
    address beneficiary = address(params.getRaw("bonding:revenue_beneficiary"));
    require(beneficiary != address(0));
    return beneficiary;
  }

  function getInflationRateNumerator() public view returns (uint256) {
    return params.getRaw("bonding:inflation_rate");
  }

  function getLiquiditySpreadNumerator() public view returns (uint256) {
    return params.getRaw("bonding:liquidity_spread");
  }

  function getCollateralExpression() public view returns (Expression) {
    return Expression(address(params.getRaw("bonding:curve_expression")));
  }

  function getCollateralAtSupply(uint256 tokenSupply) public view returns (uint256) {
    Expression collateralExpression = getCollateralExpression();
    uint256 collateralFromEquationAtCurrent = collateralExpression.evaluate(currentMintedTokens);
    uint256 collateralFromEquationAtSupply = collateralExpression.evaluate(tokenSupply);
    if (collateralFromEquationAtCurrent == 0) {
      return collateralFromEquationAtSupply;
    } else {
      return collateralFromEquationAtSupply.mul(currentCollateral).div(collateralFromEquationAtCurrent);
    }
  }

  function curveMultiplier() public view returns (uint256) {
    return currentCollateral.mul(Fractional.getDenominator()).div(getCollateralExpression().evaluate(currentMintedTokens));
  }

  function getBuyPrice(uint256 tokenValue) public view returns (uint256) {
    uint256 nextSupply = currentMintedTokens.add(tokenValue);
    return getCollateralAtSupply(nextSupply).sub(currentCollateral);
  }

  function getSellPrice(uint256 tokenValue) public view returns (uint256) {
    uint256 currentSupply = currentMintedTokens;
    require(currentSupply >= tokenValue);
    uint256 nextSupply = currentMintedTokens.sub(tokenValue);
    return currentCollateral.sub(getCollateralAtSupply(nextSupply));
  }

  modifier _adjustAutoInflation() {
    uint256 currentSupply = currentMintedTokens;
    if (lastInflationTime < now) {
      uint256 pastSeconds = now.sub(lastInflationTime);
      uint256 inflatingSupply = getInflationRateNumerator().mul(pastSeconds).mulFrac(currentSupply);
      if (inflatingSupply != 0) {
        currentMintedTokens = currentMintedTokens.add(inflatingSupply);
        _rewardBondingCurveOwner(inflatingSupply);
      }
    }
    lastInflationTime = now;
    _;
  }

  function buy(address buyer, uint256 priceLimit, uint256 buyAmount)
    public
    requireToken(collateralToken, buyer, priceLimit)
    _adjustAutoInflation
  {
    uint256 liquiditySpread = getLiquiditySpreadNumerator().mulFrac(buyAmount);
    uint256 totalMintAmount = buyAmount.add(liquiditySpread);
    uint256 buyPrice = getBuyPrice(totalMintAmount);
    require(buyPrice > 0 && buyPrice <= priceLimit);
    if (priceLimit > buyPrice) {
      require(collateralToken.transfer(buyer, priceLimit.sub(buyPrice)));
    }
    require(bondedToken.mint(buyer, buyAmount));
    if (liquiditySpread > 0) {
      _rewardBondingCurveOwner(liquiditySpread);
    }
    currentMintedTokens = currentMintedTokens.add(totalMintAmount);
    currentCollateral = currentCollateral.add(buyPrice);
    emit Buy(buyer, buyAmount, buyPrice);
  }

  function sell(address seller, uint256 sellAmount, uint256 priceLimit)
    public
    requireToken(bondedToken, seller, sellAmount)
    _adjustAutoInflation
  {
    uint256 sellPrice = getSellPrice(sellAmount);
    require(sellPrice > 0 && sellPrice >= priceLimit);
    require(bondedToken.burn(address(this), sellAmount));
    require(collateralToken.transfer(seller, sellPrice));
    currentMintedTokens = currentMintedTokens.sub(sellAmount);
    currentCollateral = currentCollateral.sub(sellPrice);
    emit Sell(seller, sellAmount, sellPrice);
  }

  function deflate(address burner, uint256 burnAmount) public requireToken(bondedToken, burner, burnAmount) {
    require(bondedToken.burn(address(this), burnAmount));
    currentMintedTokens = currentMintedTokens.sub(burnAmount);
    emit Deflate(burner, burnAmount);
  }

  function _rewardBondingCurveOwner(uint256 rewardAmount) internal {
    address beneficiary = getRevenueBeneficiary();
    require(bondedToken.mint(beneficiary, rewardAmount));
    emit RevenueCollect(beneficiary, rewardAmount);
  }
}

// File: openzeppelin-solidity/contracts/math/Math.sol

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

// File: openzeppelin-solidity/contracts/access/roles/CapperRole.sol

pragma solidity ^0.5.0;


contract CapperRole {
    using Roles for Roles.Role;

    event CapperAdded(address indexed account);
    event CapperRemoved(address indexed account);

    Roles.Role private _cappers;

    constructor () internal {
        _addCapper(msg.sender);
    }

    modifier onlyCapper() {
        require(isCapper(msg.sender), "CapperRole: caller does not have the Capper role");
        _;
    }

    function isCapper(address account) public view returns (bool) {
        return _cappers.has(account);
    }

    function addCapper(address account) public onlyCapper {
        _addCapper(account);
    }

    function renounceCapper() public {
        _removeCapper(msg.sender);
    }

    function _addCapper(address account) internal {
        _cappers.add(account);
        emit CapperAdded(account);
    }

    function _removeCapper(address account) internal {
        _cappers.remove(account);
        emit CapperRemoved(account);
    }
}

// File: contracts/token/LockableToken.sol

pragma solidity 0.5.9;






/// "LockableToken" adds token locking functionality to ERC-20 smart contract. The authorized addresses (Cappers) are
/// allowed to lock tokens from any token holder to prevent token transfers up to that amount. If a token holder is
/// locked by multiple cappers, the maximum number is used as the amount of locked tokens.
contract LockableToken is ERC20Base, CapperRole {
  using SafeMath for uint256;

  event TokenLocked(address indexed locker, address indexed owner, uint256 value);
  event TokenUnlocked(address indexed locker, address indexed owner, uint256 value);

  uint256 constant NOT_FOUND = uint256(-1);

  struct TokenLock {
    address locker;
    uint256 value;
  }

  mapping (address => TokenLock[]) _locks;

  function getLockedToken(address owner) public view returns (uint256) {
    TokenLock[] storage locks = _locks[owner];
    uint256 maxLock = 0;
    for (uint256 i = 0; i < locks.length; ++i) {
      maxLock = Math.max(maxLock, locks[i].value);
    }
    return maxLock;
  }

  function getLockedTokenAt(address owner, address locker) public view returns (uint256) {
    uint256 index = _getTokenLockIndex(owner, locker);
    if (index != NOT_FOUND) return _locks[owner][index].value;
    else return 0;
  }

  function unlockedBalanceOf(address owner) public view returns (uint256) {
    return balanceOf(owner).sub(getLockedToken(owner));
  }

  function lock(address owner, uint256 value) public onlyCapper returns (bool) {
    uint256 index = _getTokenLockIndex(owner, msg.sender);
    if (index != NOT_FOUND) {
      uint256 currentLock = _locks[owner][index].value;
      require(balanceOf(owner) >= currentLock.add(value));
      _locks[owner][index].value = currentLock.add(value);
    } else {
      require(balanceOf(owner) >= value);
      _locks[owner].push(TokenLock(msg.sender, value));
    }
    emit TokenLocked(msg.sender, owner, value);
    return true;
  }

  function unlock(address owner, uint256 value) public returns (bool) {
    uint256 index = _getTokenLockIndex(owner, msg.sender);
    require(index != NOT_FOUND);
    TokenLock[] storage locks = _locks[owner];
    require(locks[index].value >= value);
    locks[index].value = locks[index].value.sub(value);
    if (locks[index].value == 0) {
      if (index != locks.length - 1) {
        locks[index] = locks[locks.length - 1];
      }
      locks.pop();
    }
    emit TokenUnlocked(msg.sender, owner, value);
    return true;
  }

  function _getTokenLockIndex(address owner, address locker) internal view returns (uint256) {
    TokenLock[] storage locks = _locks[owner];
    for (uint256 i = 0; i < locks.length; ++i) {
      if (locks[i].locker == locker) return i;
    }
    return NOT_FOUND;
  }

  function _transfer(address from, address to, uint256 value) internal {
    require(unlockedBalanceOf(from) >= value);
    super._transfer(from, to, value);
  }

  function _burn(address account, uint256 value) internal {
    require(unlockedBalanceOf(account) >= value);
    super._burn(account, value);
  }
}

// File: contracts/data/TCDBase.sol

pragma solidity 0.5.9;








/// "TCDBase" is the base class for Band Protocol's Token-Curated DataSources implementation. The contract essentially
/// keeps track of a sorted list of trusted data sources, based on the total amount of token stake the data sources
/// have. Any one can apply for a new data source using `register` function. Token holders can `stake` or `unstake`
/// for any existing data sources. This class is abstract, so it needs to be extended by a subclass that utilizes
/// the list of active data sources (See AggTCD and MultiSigTCD). Fees are collected in ETH and are converted to
/// dataset tokens during `distributeFee` function call.
contract TCDBase is QueryInterface {
  using Fractional for uint256;
  using SafeMath for uint256;

  event DataSourceRegistered(address indexed dataSource, address indexed owner, uint256 stake);
  event DataSourceStaked(address indexed dataSource, address indexed participant, uint256 stake);
  event DataSourceUnstaked(address indexed dataSource, address indexed participant, uint256 unstake);
  event FeeDistributed(address indexed dataSource, uint256 totalReward, uint256 ownerReward);
  event WithdrawReceiptCreated(uint256 receiptIndex, address indexed owner, uint256 amount, uint64 withdrawTime);
  event WithdrawReceiptUnlocked(uint256 receiptIndex, address indexed owner, uint256 amount);

  enum Order {EQ, LT, GT}

  struct DataSourceInfo {
    address owner;
    uint256 stake;
    uint256 totalOwnerships;
    mapping (address => uint256) tokenLocks;
    mapping (address => uint256) ownerships;
  }

  struct WithdrawReceipt {
    address owner;
    uint256 amount;
    uint64 withdrawTime;
    bool isWithdrawn;
  }

  mapping (address => DataSourceInfo) public infoMap;
  mapping (address => address) activeList;
  mapping (address => address) reserveList;
  uint256 public activeCount;
  uint256 public reserveCount;

  address constant internal NOT_FOUND = address(0x00);
  address constant internal ACTIVE_GUARD = address(0x01);
  address constant internal RESERVE_GUARD = address(0x02);
  WithdrawReceipt[] public withdrawReceipts;

  BondingCurve public bondingCurve;
  Parameters public params;
  LockableToken public token;
  uint256 public undistributedReward;
  bytes8 public prefix;

  constructor(bytes8 _prefix, BondingCurve _bondingCurve, Parameters _params, BandRegistry _registry) public QueryInterface(_registry) {
    bondingCurve = _bondingCurve;
    params = _params;
    prefix = _prefix;
    token = LockableToken(address(_bondingCurve.bondedToken()));
    _registry.band().approve(address(_bondingCurve), 2 ** 256 - 1);
    activeList[ACTIVE_GUARD] = ACTIVE_GUARD;
    reserveList[RESERVE_GUARD] = RESERVE_GUARD;
  }

  function getOwnership(address dataSource, address staker) public view returns (uint256) {
    return infoMap[dataSource].ownerships[staker];
  }

  function getStake(address dataSource, address staker) public view returns (uint256) {
    DataSourceInfo storage provider = infoMap[dataSource];
    if (provider.totalOwnerships == 0) return 0;
    return provider.ownerships[staker].mul(provider.stake).div(provider.totalOwnerships);
  }

  function register(address dataSource, address prevDataSource, uint256 initialStake) public {
    require(dataSource != NOT_FOUND && dataSource != ACTIVE_GUARD && dataSource != RESERVE_GUARD);
    require(infoMap[dataSource].totalOwnerships == 0);
    require(initialStake > 0 && initialStake >= params.get(prefix, "min_provider_stake"));
    require(token.lock(msg.sender, initialStake));
    infoMap[dataSource] = DataSourceInfo({
      owner: msg.sender,
      stake: initialStake,
      totalOwnerships: initialStake
    });
    infoMap[dataSource].ownerships[msg.sender] = initialStake;
    infoMap[dataSource].tokenLocks[msg.sender] = initialStake;
    emit DataSourceRegistered(dataSource, msg.sender, initialStake);
    _addDataSource(dataSource, prevDataSource);
    _rebalanceLists();
  }

  function stake(address dataSource, address prevDataSource, address newPrevDataSource, uint256 value) public {
    require(token.lock(msg.sender, value));
    _removeDataSource(dataSource, prevDataSource);
    DataSourceInfo storage provider = infoMap[dataSource];
    uint256 newStakerTokenLock = provider.tokenLocks[msg.sender].add(value);
    provider.tokenLocks[msg.sender] = newStakerTokenLock;
    _stake(msg.sender, value, dataSource);
    if (getStake(dataSource, provider.owner) >= params.get(prefix, "min_provider_stake")) {
      _addDataSource(dataSource, newPrevDataSource);
    }
    _rebalanceLists();
  }

  function unstake(address dataSource, address prevDataSource, address newPrevDataSource, uint256 withdrawOwnership) public {
    DataSourceInfo storage provider = infoMap[dataSource];
    require(withdrawOwnership <= provider.ownerships[msg.sender]);
    _removeDataSource(dataSource, prevDataSource);
    uint256 newOwnership = provider.totalOwnerships.sub(withdrawOwnership);
    uint256 currentStakerStake = getStake(dataSource, msg.sender);
    if (currentStakerStake > provider.tokenLocks[msg.sender]) {
      uint256 unrealizedStake = currentStakerStake.sub(provider.tokenLocks[msg.sender]);
      require(token.transfer(msg.sender, unrealizedStake));
      require(token.lock(msg.sender, unrealizedStake));
    }
    uint256 withdrawAmount = provider.stake.mul(withdrawOwnership).div(provider.totalOwnerships);
    uint256 newStake = provider.stake.sub(withdrawAmount);
    uint256 newStakerTokenLock = currentStakerStake.sub(withdrawAmount);
    uint256 newStakerOwnership = provider.ownerships[msg.sender].sub(withdrawOwnership);
    provider.stake = newStake;
    provider.totalOwnerships = newOwnership;
    provider.ownerships[msg.sender] = newStakerOwnership;
    provider.tokenLocks[msg.sender] = newStakerTokenLock;
    uint256 delay;
    if (msg.sender == provider.owner && (delay = params.get(prefix, "withdraw_delay")) > 0) {
      uint256 withdrawTime = now.add(delay);
      require(withdrawTime < (1 << 64));
      withdrawReceipts.push(WithdrawReceipt({
        owner: provider.owner,
        amount: withdrawAmount,
        withdrawTime: uint64(withdrawTime),
        isWithdrawn: false
      }));
      emit WithdrawReceiptCreated(withdrawReceipts.length - 1, provider.owner, withdrawAmount, uint64(withdrawTime));
    } else {
      require(token.unlock(msg.sender, withdrawAmount));
    }
    emit DataSourceUnstaked(dataSource, msg.sender, withdrawAmount);
    if (getStake(dataSource, provider.owner) >= params.get(prefix, "min_provider_stake")) {
      _addDataSource(dataSource, newPrevDataSource);
    }
    _rebalanceLists();
  }

  function addETHFee() public payable {}

  function addTokenFee(uint256 tokenAmount) public {
    token.transferFrom(msg.sender, address(this), tokenAmount);
    undistributedReward = undistributedReward.add(tokenAmount);
  }

  function distributeFee(uint256 tokenAmount) public {
    require(address(this).balance > 0);
    registry.exchange().convertFromEthToBand.value(address(this).balance)();
    bondingCurve.buy(address(this), registry.band().balanceOf(address(this)), tokenAmount);
    undistributedReward = undistributedReward.add(tokenAmount);
    uint256 providerReward = undistributedReward.div(activeCount);
    uint256 ownerPercentage = params.get(prefix, "owner_revenue_pct");
    uint256 ownerReward = ownerPercentage.mulFrac(providerReward);
    uint256 stakeIncreased = providerReward.sub(ownerReward);
    address dataSourceAddress = activeList[ACTIVE_GUARD];
    while (dataSourceAddress != ACTIVE_GUARD) {
      DataSourceInfo storage provider = infoMap[dataSourceAddress];
      provider.stake = provider.stake.add(stakeIncreased);
      if (ownerReward > 0) _stake(provider.owner, ownerReward, dataSourceAddress);
      undistributedReward = undistributedReward.sub(providerReward);
      emit FeeDistributed(dataSourceAddress, providerReward, ownerReward);
      dataSourceAddress = activeList[dataSourceAddress];
    }
  }

  function distributeStakeReward(uint256 tokenAmount) public {
    token.transferFrom(msg.sender, address(this), tokenAmount);
    uint256 remainingReward = tokenAmount;
    uint256 stakeReward = tokenAmount.div(activeCount);
    address dataSourceAddress = activeList[ACTIVE_GUARD];
    while (dataSourceAddress != ACTIVE_GUARD) {
      DataSourceInfo storage provider = infoMap[dataSourceAddress];
      provider.stake = provider.stake.add(stakeReward);
      remainingReward = remainingReward.sub(stakeReward);
      emit FeeDistributed(dataSourceAddress, stakeReward, 0);
      dataSourceAddress = activeList[dataSourceAddress];
    }
    undistributedReward = undistributedReward.add(remainingReward);
  }

  function unlockTokenFromReceipt(uint256 receiptId) public {
    WithdrawReceipt storage receipt = withdrawReceipts[receiptId];
    require(!receipt.isWithdrawn && now >= receipt.withdrawTime);
    receipt.isWithdrawn = true;
    require(token.unlock(receipt.owner, receipt.amount));
    emit WithdrawReceiptUnlocked(receiptId, receipt.owner, receipt.amount);
  }

  function _stake(address staker, uint256 value, address dataSource) internal {
    DataSourceInfo storage provider = infoMap[dataSource];
    require(provider.totalOwnerships > 0);
    uint256 newStake = provider.stake.add(value);
    uint256 newtotalOwnerships = newStake.mul(provider.totalOwnerships).div(provider.stake);
    uint256 newStakerOwnership = provider.ownerships[staker].add(newtotalOwnerships.sub(provider.totalOwnerships));
    provider.ownerships[staker] = newStakerOwnership;
    provider.stake = newStake;
    provider.totalOwnerships = newtotalOwnerships;
    emit DataSourceStaked(dataSource, staker, value);
  }

  function _compare(address dataSourceLeft, address dataSourceRight) internal view returns (Order) {
    if (dataSourceLeft == dataSourceRight) return Order.EQ;
    DataSourceInfo storage leftProvider = infoMap[dataSourceLeft];
    DataSourceInfo storage rightProvider = infoMap[dataSourceRight];
    if (leftProvider.stake != rightProvider.stake) return leftProvider.stake < rightProvider.stake ? Order.LT : Order.GT;
    return uint256(dataSourceLeft) < uint256(dataSourceRight) ? Order.LT : Order.GT; /// Arbitrary tie-breaker
  }

  function _findPrevDataSource(address dataSource) internal view returns (address) {
    if (activeCount != 0 && _compare(dataSource, activeList[ACTIVE_GUARD]) != Order.LT) {
      address currentIndex = ACTIVE_GUARD;
      while (activeList[currentIndex] != ACTIVE_GUARD) {
        address nextIndex = activeList[currentIndex];
        if (_compare(dataSource, nextIndex) == Order.GT) currentIndex = nextIndex;
        else break;
      }
      return currentIndex;
    } else if (reserveCount != 0) {
      address currentIndex = RESERVE_GUARD;
      while (reserveList[currentIndex] != RESERVE_GUARD) {
        address nextIndex = reserveList[currentIndex];
        if (_compare(dataSource, nextIndex) == Order.LT) currentIndex = nextIndex;
        else break;
      }
      return currentIndex;
    } else {
      return RESERVE_GUARD;
    }
  }

  function _addDataSource(address dataSource, address _prevDataSource) internal {
    address prevDataSource = _prevDataSource == NOT_FOUND ? _findPrevDataSource(dataSource) : _prevDataSource;
    if (activeList[prevDataSource] != NOT_FOUND) {
      if (prevDataSource == ACTIVE_GUARD) require(reserveCount == 0 || _compare(dataSource, reserveList[RESERVE_GUARD]) == Order.GT);
      else require(_compare(dataSource, prevDataSource) == Order.GT);
      require(activeList[prevDataSource] == ACTIVE_GUARD || _compare(activeList[prevDataSource], dataSource) == Order.GT);
      activeList[dataSource] = activeList[prevDataSource];
      activeList[prevDataSource] = dataSource;
      activeCount++;
    } else if (reserveList[prevDataSource] != NOT_FOUND) {
      if (prevDataSource == RESERVE_GUARD) require(activeCount == 0 || _compare(activeList[ACTIVE_GUARD], dataSource) == Order.GT);
      else require(_compare(prevDataSource, dataSource) == Order.GT);
      require(reserveList[prevDataSource] == RESERVE_GUARD || _compare(dataSource, reserveList[prevDataSource]) == Order.GT);
      reserveList[dataSource] = reserveList[prevDataSource];
      reserveList[prevDataSource] = dataSource;
      reserveCount++;
    } else {
      revert();
    }
  }

  function _removeDataSource(address dataSource, address _prevDataSource) internal {
    if (activeList[dataSource] == NOT_FOUND && reserveList[dataSource] == NOT_FOUND) return;
    address prevDataSource = _prevDataSource == NOT_FOUND ? _findPrevDataSource(dataSource) : _prevDataSource;
    if (activeList[prevDataSource] != NOT_FOUND) {
      require(dataSource != ACTIVE_GUARD);
      require(activeList[prevDataSource] == dataSource);
      activeList[prevDataSource] = activeList[dataSource];
      activeList[dataSource] = NOT_FOUND;
      activeCount--;
    } else if (reserveList[prevDataSource] != NOT_FOUND) {
      require(dataSource != RESERVE_GUARD);
      require(reserveList[prevDataSource] == dataSource);
      reserveList[prevDataSource] = reserveList[dataSource];
      reserveList[dataSource] = NOT_FOUND;
      reserveCount--;
    }
  }

  function _rebalanceLists() internal {
    uint256 maxProviderCount = params.get(prefix, "max_provider_count");
    while (activeCount < maxProviderCount && reserveCount > 0) {
      address dataSource = reserveList[RESERVE_GUARD];
      _removeDataSource(dataSource, RESERVE_GUARD);
      _addDataSource(dataSource, ACTIVE_GUARD);
    }
    while (activeCount > maxProviderCount) {
      address dataSource = activeList[ACTIVE_GUARD];
      _removeDataSource(dataSource, ACTIVE_GUARD);
      _addDataSource(dataSource, RESERVE_GUARD);
    }
  }
}

// File: contracts/data/OffchainAggTCD.sol

pragma solidity 0.5.9;




/// "OffchainAggTCD" is a TCD that curates a list of trusted addresses. Data points from all reporters are aggregated
/// off-chain and reported using `report` function with ECDSA signatures. Data providers are responsible for combining
/// data points into one aggregated value together with timestamp and status, which will be reported to this contract.
contract OffchainAggTCD is TCDBase {
  using SafeMath for uint256;

  event DataUpdated(bytes key, uint256 value, uint64 timestamp, QueryStatus status);

  struct DataPoint {
    uint256 value;
    uint64 timestamp;
    QueryStatus status;
  }

  mapping (bytes => DataPoint) private aggData;

  constructor(bytes8 _prefix, BondingCurve _bondingCurve, Parameters _params, BandRegistry _registry)
    public TCDBase(_prefix, _bondingCurve, _params, _registry) {}

  function queryPrice() public view returns (uint256) {
    return params.get(prefix, "query_price");
  }

  function report(
    bytes calldata key, uint256 value, uint64 timestamp, QueryStatus status,
    uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s
  ) external {
    require(v.length == r.length && v.length == s.length);
    uint256 validSignatures = 0;
    bytes32 message = keccak256(abi.encodePacked(
      "\x19Ethereum Signed Message:\n32",
      keccak256(abi.encodePacked(key, value, timestamp, status, address(this))))
    );
    address lastSigner = address(0);
    for (uint256 i = 0; i < v.length; ++i) {
      address recovered = ecrecover(message, v[i], r[i], s[i]);
      require(recovered > lastSigner);
      lastSigner = recovered;
      if (activeList[recovered] != NOT_FOUND) {
        validSignatures++;
      }
    }
    require(validSignatures.mul(3) > activeCount.mul(2));
    require(timestamp > aggData[key].timestamp && uint256(timestamp) <= now);
    aggData[key] = DataPoint({
      value: value,
      timestamp: timestamp,
      status: status
    });
    emit DataUpdated(key, value, timestamp, status);
  }

  function queryImpl(bytes memory input) internal returns (bytes32 output, uint256 updatedAt, QueryStatus status) {
    DataPoint storage data = aggData[input];
    if (data.timestamp == 0) return ("", 0, QueryStatus.NOT_AVAILABLE);
    if (data.status != QueryStatus.OK) return ("", data.timestamp, data.status);
    return (bytes32(data.value), data.timestamp, QueryStatus.OK);
  }
}