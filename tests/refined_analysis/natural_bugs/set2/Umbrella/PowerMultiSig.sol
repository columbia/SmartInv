//SPDX-License-Identifier: MIT
pragma solidity >=0.7.5;

// Inheritance
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../lib/Strings.sol";

/// @title   Multi Signature base on Power
/// @author  umb.network
/// @notice  It's based on https://github.com/gnosis/MultiSigWallet but modified in a way to support power of vote.
///          It has option to assign power to owners, so we can have "super owner(s)".
abstract contract PowerMultiSig {
  using Strings for string;
  using SafeMath for uint;

  uint constant public MAX_OWNER_COUNT = 50;

  struct Transaction {
    address destination;
    uint value;
    uint executed;
    bytes data;
  }

  mapping (uint => Transaction) public transactions;
  mapping (uint => mapping (address => bool)) public confirmations;
  mapping (address => uint) public ownersPowers;
  address[] public owners;

  uint public requiredPower;
  uint public totalCurrentPower;
  uint public transactionCount;

  // ========== MODIFIERS ========== //

  modifier onlyWallet() {
    require(msg.sender == address(this), "only MultiSigMinter can execute this");
    _;
  }

  modifier whenOwnerDoesNotExist(address _owner) {
    require(ownersPowers[_owner] == 0, "owner already exists");
    _;
  }

  modifier whenOwnerExists(address _owner) {
    require(ownersPowers[_owner] > 0, "owner do NOT exists");
    _;
  }

  modifier whenTransactionExists(uint _transactionId) {
    require(transactions[_transactionId].destination != address(0),
      string("transaction ").appendNumber(_transactionId).appendString(" does not exists"));
    _;
  }

  modifier whenConfirmedBy(uint _transactionId, address _owner) {
    require(confirmations[_transactionId][_owner],
      string("transaction ").appendNumber(_transactionId).appendString(" NOT confirmed by owner"));
    _;
  }

  modifier notConfirmedBy(uint _transactionId, address _owner) {
    require(!confirmations[_transactionId][_owner],
      string("transaction ").appendNumber(_transactionId).appendString(" already confirmed by owner"));
    _;
  }

  modifier whenNotExecuted(uint _transactionId) {
    require(transactions[_transactionId].executed == 0,
      string("transaction ").appendNumber(_transactionId).appendString(" already executed") );
    _;
  }

  modifier notNull(address _address) {
    require(_address != address(0), "address is empty");
    _;
  }

  modifier validRequirement(uint _totalOwnersCount, uint _totalPowerSum, uint _requiredPower) {
    require(_totalPowerSum >= _requiredPower, "owners do NOT have enough power");
    require(_totalOwnersCount <= MAX_OWNER_COUNT, "too many owners");
    require(_requiredPower != 0, "_requiredPower is zero");
    require(_totalOwnersCount != 0, "_totalOwnersCount is zero");
    _;
  }

  // ========== CONSTRUCTOR ========== //

  constructor(address[] memory _owners, uint256[] memory _powers, uint256 _requiredPower)
  validRequirement(_owners.length, sum(_powers), _requiredPower)
  {
    uint sumOfPowers = 0;

    for (uint i=0; i<_owners.length; i++) {
      require(ownersPowers[_owners[i]] == 0, "owner already exists");
      require(_owners[i] != address(0), "owner is empty");
      require(_powers[i] != 0, "power is empty");

      ownersPowers[_owners[i]] = _powers[i];
      sumOfPowers = sumOfPowers.add(_powers[i]);
    }

    owners = _owners;
    requiredPower = _requiredPower;
    totalCurrentPower = sumOfPowers;
  }

  // ========== MODIFIERS ========== //

  receive() external payable {
    if (msg.value > 0) emit LogDeposit(msg.sender, msg.value);
  }

  function addOwner(address _owner, uint _power)
  public
  onlyWallet
  whenOwnerDoesNotExist(_owner)
  notNull(_owner)
  validRequirement(owners.length + 1, totalCurrentPower + _power, requiredPower)
  {
    require(_power != 0, "_power is empty");

    ownersPowers[_owner] = _power;
    owners.push(_owner);
    totalCurrentPower = totalCurrentPower.add(_power);

    emit LogOwnerAddition(_owner, _power);
  }

  function removeOwner(address _owner) public onlyWallet whenOwnerExists(_owner)
  {
    uint ownerPower = ownersPowers[_owner];
    require(
      totalCurrentPower - ownerPower >= requiredPower,
      "can't remove owner, because there will be not enough power left"
    );

    ownersPowers[_owner] = 0;
    totalCurrentPower = totalCurrentPower.sub(ownerPower);

    for (uint i=0; i<owners.length - 1; i++) {
      if (owners[i] == _owner) {
        owners[i] = owners[owners.length - 1];
        break;
      }
    }

    owners.pop();

    // if (requiredPower > owners.length) {
    //   changeRequiredPower(requiredPower - ownerPower);
    // }

    emit LogOwnerRemoval(_owner);
  }

  function replaceOwner(address _oldOwner, address _newOwner)
  public
  onlyWallet
  whenOwnerExists(_oldOwner)
  whenOwnerDoesNotExist(_newOwner)
  {
    for (uint i=0; i<owners.length; i++) {
      if (owners[i] == _oldOwner) {
        owners[i] = _newOwner;
        break;
      }
    }

    uint power = ownersPowers[_oldOwner];
    ownersPowers[_newOwner] = power;
    ownersPowers[_oldOwner] = 0;

    emit LogOwnerRemoval(_oldOwner);
    emit LogOwnerAddition(_newOwner, power);
  }

  function changeRequiredPower(uint _newPower)
  public
  onlyWallet
  validRequirement(owners.length, totalCurrentPower, _newPower)
  {
    requiredPower = _newPower;
    emit LogPowerChange(_newPower);
  }

  function submitTransaction(address _destination, uint _value, bytes memory _data)
  public
  returns (uint transactionId)
  {
    transactionId = _addTransaction(_destination, _value, _data);
    confirmTransaction(transactionId);
  }

  function confirmTransaction(uint _transactionId)
  public
  whenOwnerExists(msg.sender)
  whenTransactionExists(_transactionId)
  notConfirmedBy(_transactionId, msg.sender)
  {
    confirmations[_transactionId][msg.sender] = true;
    emit LogConfirmation(msg.sender, _transactionId);
    executeTransaction(_transactionId);
  }

  /// @dev Allows an owner to revoke a confirmation for a transaction.
  /// @param _transactionId Transaction ID.
  function revokeLogConfirmation(uint _transactionId)
  public
  whenOwnerExists(msg.sender)
  whenConfirmedBy(_transactionId, msg.sender)
  whenNotExecuted(_transactionId)
  {
    confirmations[_transactionId][msg.sender] = false;
    emit LogRevocation(msg.sender, _transactionId);
  }

  /// @dev Allows anyone to execute a confirmed transaction.
  /// @param _transactionId Transaction ID.
  function executeTransaction(uint _transactionId)
  public
  whenOwnerExists(msg.sender)
  whenConfirmedBy(_transactionId, msg.sender)
  whenNotExecuted(_transactionId)
  {
    if (isConfirmed(_transactionId)) {
      Transaction storage txn = transactions[_transactionId];
      txn.executed = block.timestamp;
      if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
        emit LogExecution(_transactionId);
      else {
        emit LogExecutionFailure(_transactionId);
        txn.executed = 0;
      }
    }
  }

  // call has been separated into its own function in order to take advantage
  // of the Solidity's code generator to produce a loop that copies tx.data into memory.
  function external_call(
    address _destination,
    uint _value,
    uint _dataLength,
    bytes memory _data
  ) internal returns (bool) {
    bool result;

    assembly {
      let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
      let d := add(_data, 32) // First 32 bytes are the padded length of data, so exclude that
      result := call(
        sub(gas(), 34710),   // 34710 is the value that solidity is currently emitting
        // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
        // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
        _destination,
        _value,
        d,
        _dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
        x,
        0                  // Output is ignored, therefore the output size is zero
      )
    }

    // hack for getting result value, for some reason wo this, it was always return false
    // @todo why result value is not passed if I do not add require?
    require(result, "tx failed on destination contract");

    return result;
  }

  function _addTransaction(address _destination, uint _value, bytes memory _data)
  internal
  notNull(_destination)
  returns (uint transactionId)
  {
    transactionId = transactionCount;
    transactions[transactionId] = Transaction({
    destination: _destination,
    value: _value,
    data: _data,
    executed: 0
    });
    transactionCount += 1;
    emit LogSubmission(transactionId);
  }

  // ========== VIEWS ========== //

  function sum(uint[] memory _numbers) public pure returns (uint total) {
    uint numbersCount = _numbers.length;

    for (uint i = 0; i < numbersCount; i++) {
      total += _numbers[i];
    }
  }

  function isConfirmed(uint _transactionId) public view returns (bool) {
    uint power = 0;

    for (uint i=0; i<owners.length; i++) {
      if (confirmations[_transactionId][owners[i]]) {
        power += ownersPowers[owners[i]];
      }

      if (power >= requiredPower) {
        return true;
      }
    }

    return false;
  }

  function isExceuted(uint _transactionId) public view returns (bool) {
    return transactions[_transactionId].executed != 0;
  }

  function getTransactionShort(uint _transactionId)
  public view returns (address destination, uint value, uint executed) {
    Transaction memory t = transactions[_transactionId];
    return (t.destination, t.value, t.executed);
  }

  function getTransaction(uint _transactionId)
  public view returns (address destination, uint value, uint executed, bytes memory data) {
    Transaction memory t = transactions[_transactionId];
    return (t.destination, t.value, t.executed, t.data);
  }

  /*
   * Web3 call functions
   */
  /// @dev Returns number of confirmations of a transaction.
  /// @param _transactionId Transaction ID.
  /// @return count Number of confirmations.
  function getLogConfirmationCount(uint _transactionId) public view returns (uint count)
  {
    for (uint i=0; i<owners.length; i++) {
      if (confirmations[_transactionId][owners[i]]) {
        count += 1;
      }
    }
  }

  /// @dev Returns total number of transactions after filers are applied.
  /// @param _pending Include pending transactions.
  /// @param _executed Include executed transactions.
  /// @return count Total number of transactions after filters are applied.
  function getTransactionCount(bool _pending, bool _executed) public view returns (uint count)
  {
    for (uint i=0; i<transactionCount; i++) {
      if (_pending && transactions[i].executed == 0 || _executed && transactions[i].executed != 0) {
        count += 1;
      }
    }
  }

  /// @dev Returns array with owner addresses, which confirmed transaction.
  /// @param _transactionId Transaction ID.
  /// @return _confirmations Returns array of owner addresses.
  function getLogConfirmations(uint _transactionId)
  public
  view
  returns (address[] memory _confirmations)
  {
    address[] memory confirmationsTemp = new address[](owners.length);
    uint count = 0;
    uint i;

    for (i=0; i<owners.length; i++) {
      if (confirmations[_transactionId][owners[i]]) {
        confirmationsTemp[count] = owners[i];
        count += 1;
      }
    }

    _confirmations = new address[](count);

    for (i=0; i<count; i++) {
      _confirmations[i] = confirmationsTemp[i];
    }
  }

  /// @dev Returns list of transaction IDs in defined range.
  /// @param _from Index start position of transaction array.
  /// @param _to Index end position of transaction array.
  /// @param _pending Include pending transactions.
  /// @param _executed Include executed transactions.
  /// @return _transactionIds Returns array of transaction IDs.
  function getTransactionIds(uint _from, uint _to, bool _pending, bool _executed)
  public
  view
  returns (uint[] memory _transactionIds)
  {
    uint[] memory transactionIdsTemp = new uint[](transactionCount);
    uint count = 0;
    uint i;

    for (i=0; i<transactionCount; i++) {
      if (_pending && transactions[i].executed == 0 || _executed && transactions[i].executed != 0) {
        transactionIdsTemp[count] = i;
        count += 1;
      }
    }

    _transactionIds = new uint[](_to - _from);

    for (i= _from; i< _to; i++) {
      _transactionIds[i - _from] = transactionIdsTemp[i];
    }
  }

  // ========== EVENTS ========== //

  event LogConfirmation(address indexed sender, uint indexed transactionId);
  event LogRevocation(address indexed sender, uint indexed transactionId);
  event LogSubmission(uint indexed transactionId);
  event LogExecution(uint indexed transactionId);
  event LogExecutionFailure(uint indexed transactionId);
  event LogDeposit(address indexed sender, uint value);
  event LogOwnerAddition(address indexed owner, uint power);
  event LogOwnerRemoval(address indexed owner);
  event LogPowerChange(uint power);
}
