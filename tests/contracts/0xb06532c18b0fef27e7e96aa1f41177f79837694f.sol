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
  function allowance(address owner, address spender)
    external
    view
    returns (uint256);

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
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

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
    require(c >= a, 'SafeMath: addition overflow');

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
    return sub(a, b, 'SafeMath: subtraction overflow');
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
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
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
    require(c / a == b, 'SafeMath: multiplication overflow');

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
    return div(a, b, 'SafeMath: division by zero');
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
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
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
    return mod(a, b, 'SafeMath: modulo by zero');
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
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
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
  function _msgSender() internal virtual view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal virtual view returns (bytes memory) {
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

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor() internal {
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
    require(_owner == _msgSender(), 'Ownable: caller is not the owner');
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
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

// File: contracts/StonkMarket.sol

pragma solidity >=0.6.0;

interface IStonkTaxPool {
  function addRewards(uint256 _amount) external;
}

contract StonkMarket is Ownable {
  using SafeMath for uint256;

  struct Negotiation {
    uint256 amount;
    address player;
    address other;
  }

  mapping(address => uint256) public stakedBalances;
  mapping(address => string) public spoNames;

  mapping(address => uint8) public hasStaked;

  address[] private _stakerAddresses;
  uint256 private _stakerAddressesLength;
  uint256 private _totalStaked;

  bool public isNegotiationPaused = false;

  IERC20 public stonkToken;
  IStonkTaxPool public stonkTaxPool;

  uint256 public taxPerNegotiation = 100; // 1% tax
  uint256 public taxPerWithdrawal = 100; // 1% tax
  uint256 public maxTakeoverPercent = 5000; // 50% max takeover
  uint256 public negotiatorAdvantage = 200; // 2% advantage
  uint256 public minimumStake = 1; // 1e-18 minimum stake

  address payable public treasury;

  event SPOCreated(
    address player,
    uint256 amount,
    string name,
    uint256 timestamp
  );
  event SPOWithdrawn(address player, uint256 amount, string name);
  event AcquisitionNegotiated(
    address spoA,
    address spoB,
    string spoAName,
    string spoBName,
    bool winner,
    uint256 amount,
    uint256 amountWon,
    uint256 timestamp
  );

  modifier onlyEOA() {
    require(msg.sender == tx.origin, 'Not eoa');
    _;
  }

  constructor(
    IERC20 _stonkToken,
    IStonkTaxPool _stonkTaxPool,
    address payable _treasury
  ) public {
    stonkToken = _stonkToken;
    stonkTaxPool = _stonkTaxPool;
    treasury = _treasury;
  }

  function stakerAddresses() public view returns (address[] memory) {
    return _stakerAddresses;
  }

  function stakerAddressesLength() public view returns (uint256) {
    return _stakerAddressesLength;
  }

  function totalStaked() public view returns (uint256) {
    return _totalStaked;
  }

  function setTaxPerNegotiation(uint256 _taxPerNegotiation) external onlyOwner {
    taxPerNegotiation = _taxPerNegotiation;
  }

  function setTaxPerWithdrawal(uint256 _taxPerWithdrawal) external onlyOwner {
    taxPerWithdrawal = _taxPerWithdrawal;
  }

  function setStonkTaxPool(IStonkTaxPool _stonkTaxPool) external onlyOwner {
    stonkTaxPool = _stonkTaxPool;
  }

  function setMinimumStake(uint256 _minimumStake) external onlyOwner {
    minimumStake = _minimumStake;
  }

  function setNegotiationPaused(bool value) external onlyOwner {
    isNegotiationPaused = value;
  }

  function setMaxTakeoverPercent(uint256 _maxTakeoverPercent)
    external
    onlyOwner
  {
    maxTakeoverPercent = _maxTakeoverPercent;
  }

  function addressesInRange(uint256 start, uint256 end)
    external
    view
    returns (address[] memory)
  {
    require(end > start, 'Invalid bounds');

    address[] memory addresses;

    for (uint256 i; i < start - end; i++) {
      addresses[i] = _stakerAddresses[start + i];
    }

    return addresses;
  }

  function _rng(uint256 _seed) internal view returns (uint256) {
    return
      uint256(
        keccak256(
          abi.encodePacked(
            (block.timestamp)
              .add(_seed)
              .add(block.difficulty)
              .add(
              (uint256(keccak256(abi.encodePacked(block.coinbase)))) /
                block.timestamp
            )
              .add(block.gaslimit)
              .add(
              (uint256(keccak256(abi.encodePacked(msg.sender)))) /
                block.timestamp
            )
              .add(block.number)
          )
        )
      );
  }

  function launchSPO(uint256 amount, string memory name) public {
    require(amount > minimumStake, 'Invalid amount.');
    require(bytes(name).length >= 1, 'SPO name must be >= 1 byte');
    require(bytes(name).length <= 4, 'SPO name must be <= 4 bytes');

    require(
      stonkToken.transferFrom(msg.sender, address(this), amount),
      'Transfer failed'
    );

    spoNames[msg.sender] = name;
    stakedBalances[msg.sender] = stakedBalances[msg.sender].add(amount);

    _totalStaked = _totalStaked.add(amount);

    if (hasStaked[msg.sender] == 0) {
      _stakerAddresses.push(msg.sender);
      _stakerAddressesLength++;
      hasStaked[msg.sender] = 1;
    }

    emit SPOCreated(msg.sender, amount, name, block.timestamp);
  }

  function maxNegotiationAmount(address spo) public view returns (uint256) {
    return stakedBalances[spo].mul(maxTakeoverPercent).div(10000);
  }

  function enterNegotiation(address opponentSpo, uint256 amount)
    external
    onlyEOA
  {
    require(amount > minimumStake, 'Invalid amount.');
    require(isNegotiationPaused == false, 'Negotiations are paused');
    require(opponentSpo != msg.sender, 'Invalid opponent');
    require(stakedBalances[msg.sender] >= amount, 'Insufficient balance');

    require(
      maxNegotiationAmount(opponentSpo) >= amount,
      'Insufficient opponent balance'
    );

    address player = msg.sender;
    address other = opponentSpo;
    uint256 amountTaxed = amount.mul(taxPerNegotiation).div(10000);
    uint256 amountWon = amount.sub(amountTaxed);

    stonkToken.approve(address(stonkTaxPool), amountTaxed);
    stonkTaxPool.addRewards(amountTaxed);

    uint256 midpoint = uint256(5000).sub(
      uint256(10000).mul(negotiatorAdvantage.div(2)).div(10000)
    );
    uint256 rngBetweenOneAndOneHundred = _rng(stakedBalances[player]) % 10000;
    bool winner = false;

    if (rngBetweenOneAndOneHundred >= midpoint) {
      winner = true;

      stakedBalances[player] = stakedBalances[player].add(amountWon);
      stakedBalances[other] = stakedBalances[other].sub(amount);
    } else {
      stakedBalances[other] = stakedBalances[other].add(amountWon);
      stakedBalances[player] = stakedBalances[player].sub(amount);
    }

    emit AcquisitionNegotiated(
      player,
      other,
      spoNames[player],
      spoNames[other],
      winner,
      amount,
      amountWon,
      block.timestamp
    );
  }

  function withdraw(uint256 amount) external {
    require(stakedBalances[msg.sender] >= amount, 'Insufficient balance');

    uint256 amountTaxed = amount.mul(taxPerWithdrawal).div(10000);
    stonkToken.approve(address(stonkTaxPool), amountTaxed);
    stonkTaxPool.addRewards(amountTaxed);

    uint256 amountAfterTax = amount.sub(amountTaxed);

    stakedBalances[msg.sender] = stakedBalances[msg.sender].sub(amount);
    _totalStaked = _totalStaked.sub(amount);

    require(safeStonkTransfer(msg.sender, amountAfterTax), 'Transfer failed');

    emit SPOWithdrawn(msg.sender, amount, spoNames[msg.sender]);
  }

  function safeStonkTransfer(address _to, uint256 _amount)
    internal
    returns (bool)
  {
    uint256 stonkBal = stonkToken.balanceOf(address(this));

    if (_amount > stonkBal) {
      return stonkToken.transfer(_to, stonkBal);
    } else {
      return stonkToken.transfer(_to, _amount);
    }
  }

  // This function send any eth remaining from oracle fees, to treasury
  function flushEth() public {
    treasury.transfer(address(this).balance);
  }
}