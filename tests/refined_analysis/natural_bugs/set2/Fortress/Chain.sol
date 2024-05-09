// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./openzeppelin/contracts/access/Ownable.sol";
import "./umb-network/toolbox/dist/contracts/lib/ValueDecoder.sol";

import "./interfaces/IStakingBank.sol";

import "./BaseChain.sol";

contract Chain is BaseChain {
  IStakingBank public immutable stakingBank;

  // ========== EVENTS ========== //

  event LogMint(address indexed minter, uint256 blockId, uint256 staked, uint256 power);
  event LogVoter(uint256 indexed blockId, address indexed voter, uint256 vote);

  // ========== CONSTRUCTOR ========== //

  constructor(
    address _contractRegistry,
    uint16 _padding,
    uint16 _requiredSignatures
  ) public BaseChain(_contractRegistry, _padding, _requiredSignatures) {
    // we not changing SB address that often, so lets save it once, it will save 10% gas
    stakingBank = stakingBankContract();
  }

  // ========== VIEWS ========== //

  function isForeign() override external pure returns (bool) {
    return false;
  }

  function getName() override external pure returns (bytes32) {
    return "Chain";
  }

  function getStatus() external view returns(
    uint256 blockNumber,
    uint16 timePadding,
    uint32 lastDataTimestamp,
    uint32 lastBlockId,
    address nextLeader,
    uint32 nextBlockId,
    address[] memory validators,
    uint256[] memory powers,
    string[] memory locations,
    uint256 staked,
    uint16 minSignatures
  ) {
    blockNumber = block.number;
    timePadding = padding;
    lastBlockId = getLatestBlockId();
    lastDataTimestamp = squashedRoots[lastBlockId].extractTimestamp();
    minSignatures = requiredSignatures;

    staked = stakingBank.totalSupply();
    uint256 numberOfValidators = stakingBank.getNumberOfValidators();
    powers = new uint256[](numberOfValidators);
    validators = new address[](numberOfValidators);
    locations = new string[](numberOfValidators);

    for (uint256 i = 0; i < numberOfValidators; i++) {
      validators[i] = stakingBank.addresses(i);
      (, locations[i]) = stakingBank.validators(validators[i]);
      powers[i] = stakingBank.balanceOf(validators[i]);
    }

    nextBlockId = getBlockIdAtTimestamp(block.timestamp + 1);

    nextLeader = numberOfValidators > 0
      ? validators[getLeaderIndex(numberOfValidators, block.timestamp + 1)]
      : address(0);
  }

  function getNextLeaderAddress() external view returns (address) {
    return getLeaderAddressAtTime(block.timestamp + 1);
  }

  function getLeaderAddress() external view returns (address) {
    return getLeaderAddressAtTime(block.timestamp);
  }

  // ========== MUTATIVE FUNCTIONS ========== //

  // solhint-disable-next-line function-max-lines
  function submit(
    uint32 _dataTimestamp,
    bytes32 _root,
    bytes32[] memory _keys,
    uint256[] memory _values,
    uint8[] memory _v,
    bytes32[] memory _r,
    bytes32[] memory _s
  ) public { // it could be external, but for external we got stack too deep
    uint32 lastBlockId = getLatestBlockId();
    uint32 dataTimestamp = squashedRoots[lastBlockId].extractTimestamp();

    require(dataTimestamp + padding < block.timestamp, "do not spam");
    require(dataTimestamp < _dataTimestamp, "can NOT submit older data");
    // we can't expect minter will have exactly the same timestamp
    // but for sure we can demand not to be off by a lot, that's why +3sec
    // temporary remove this condition, because recently on ropsten we see cases when minter/node
    // can be even 100sec behind
    // require(_dataTimestamp <= block.timestamp + 3,
    //   string(abi.encodePacked("oh, so you can predict the future:", _dataTimestamp - block.timestamp + 48)));
    require(_keys.length == _values.length, "numbers of keys and values not the same");

    bytes memory testimony = abi.encodePacked(_dataTimestamp, _root);

    for (uint256 i = 0; i < _keys.length; i++) {
      require(uint224(_values[i]) == _values[i], "FCD overflow");
      fcds[_keys[i]] = FirstClassData(uint224(_values[i]), _dataTimestamp);
      testimony = abi.encodePacked(testimony, _keys[i], _values[i]);
    }

    bytes32 affidavit = keccak256(testimony);
    uint256 power = 0;

    uint256 staked = stakingBank.totalSupply();
    address prevSigner = address(0x0);

    uint256 i = 0;

    for (; i < _v.length; i++) {
      address signer = recoverSigner(affidavit, _v[i], _r[i], _s[i]);
      uint256 balance = stakingBank.balanceOf(signer);

      require(prevSigner < signer, "validator included more than once");
      prevSigner = signer;
      if (balance == 0) continue;

      emit LogVoter(lastBlockId + 1, signer, balance);
      power += balance; // no need for safe math, if we overflow then we will not have enough power
    }

    require(i >= requiredSignatures, "not enough signatures");
    // we turn on power once we have proper DPoS
    // require(power * 100 / staked >= 66, "not enough power was gathered");

    squashedRoots[lastBlockId + 1] = _root.makeSquashedRoot(_dataTimestamp);
    blocksCount++;

    emit LogMint(msg.sender, lastBlockId + 1, staked, power);
  }

  function getLeaderIndex(uint256 _numberOfValidators, uint256 _timestamp) public view returns (uint256) {
    uint32 latestBlockId = getLatestBlockId();

    // timePadding + 1 => because padding is a space between blocks, so next round starts on first block after padding
    uint256 validatorIndex = latestBlockId +
      (_timestamp - squashedRoots[latestBlockId].extractTimestamp()) / (padding + 1);

    return uint16(validatorIndex % _numberOfValidators);
  }

  // @todo - properly handled non-enabled validators, newly added validators, and validators with low stake
  function getLeaderAddressAtTime(uint256 _timestamp) public view returns (address) {
    uint256 numberOfValidators = stakingBank.getNumberOfValidators();

    if (numberOfValidators == 0) {
      return address(0x0);
    }

    uint256 validatorIndex = getLeaderIndex(numberOfValidators, _timestamp);

    return stakingBank.addresses(validatorIndex);
  }
}