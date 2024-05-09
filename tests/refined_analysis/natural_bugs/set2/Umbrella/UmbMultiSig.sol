//SPDX-License-Identifier: MIT
pragma solidity >=0.7.5;

// Inheritance
import "./interfaces/PowerMultiSig.sol";

/// @title   Umbrella MultiSig contract
/// @author  umb.network
/// @notice  This is extended version of PowerMultiSig wallet, that will allow to execute commands without FE.
/// @dev     Original MultiSig requires FE to run, but here, we have some predefined data for few transactions
///          so we can run it directly from Etherscan and not worry about data bytes
contract UmbMultiSig is PowerMultiSig {

  // ========== MODIFIERS ========== //

  // ========== CONSTRUCTOR ========== //

  constructor(address[] memory _owners, uint256[] memory _powers, uint256 _requiredPower)
  PowerMultiSig(_owners, _powers, _requiredPower) {
  }

  // ========== VIEWS ========== //

  function createFunctionSignature(string memory _f) public pure returns (bytes memory) {
    return abi.encodeWithSignature(_f);
  }

  // ========== MUTATIVE FUNCTIONS ========== //

  // ========== helpers for: UMB, rUMB

  function submitTokenMintTx(address _destination, address _holder, uint _amount) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("mint(address,uint256)", _holder, _amount);
    return submitTransaction(_destination, 0, data);
  }

  // ========== helpers for: UMB

  function submitUMBSetRewardTokensTx(address _destination, address[] memory _tokens, bool[] memory _statuses) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("setRewardTokens(address[],bool[])", _tokens, _statuses);
    return submitTransaction(_destination, 0, data);
  }

  // ========== helpers for: Auction

  function submitAuctionStartTx(address _destination) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("start()");
    return submitTransaction(_destination, 0, data);
  }

  function submitAuctionSetupTx(
    address _destination,
    uint256 _minimalEthPricePerToken,
    uint256 _minimalRequiredLockedEth,
    uint256 _maximumLockedEth
  ) public returns (uint) {
    bytes memory data = abi.encodeWithSignature(
      "setup(uint256,uint256,uint256)",
        _minimalEthPricePerToken,
        _minimalRequiredLockedEth,
        _maximumLockedEth
    );

    return submitTransaction(_destination, 0, data);
  }

  // ========== helpers for: rUMB

  function submitRUMBStartSwapNowTx(address _destination) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("startSwapNow()");
    return submitTransaction(_destination, 0, data);
  }

  // ========== helpers for: Rewards

  function submitRewardsStartDistributionTx(
    address _destination,
    address _rewardToken,
    uint _startTime,
    address[] calldata _participants,
    uint[] calldata _rewards,
    uint[] calldata _durations
  ) public returns (uint) {
    bytes memory data = abi.encodeWithSignature(
      "startDistribution(address,uint256,address[],uint256[],uint256[])",
      _rewardToken,
      _startTime,
      _participants,
      _rewards,
      _durations
    );

    return submitTransaction(_destination, 0, data);
  }

  // ========== helpers for: StakingRewards

  function submitStakingRewardsSetRewardsDistributionTx(address _destination, address _rewardsDistributor) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("setRewardsDistribution(address)", _rewardsDistributor);
    return submitTransaction(_destination, 0, data);
  }

  function submitStakingRewardsSetRewardsDurationTx(address _destination, uint _duration) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("setRewardsDuration(uint256)", _duration);
    return submitTransaction(_destination, 0, data);
  }

  function submitStakingRewardsNotifyRewardAmountTx(address _destination, uint _amount) public returns (uint) {
    bytes memory data = abi.encodeWithSignature("notifyRewardAmount(uint256)", _amount);
    return submitTransaction(_destination, 0, data);
  }

  // ========== EVENTS ========== //
}
