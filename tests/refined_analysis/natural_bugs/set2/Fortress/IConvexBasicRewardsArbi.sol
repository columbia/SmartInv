// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IConvexBasicRewardsArbi {

  struct EarnedData {
        address token;
        uint256 amount;
    }

  function stakeFor(address, uint256) external returns (bool);

  function balanceOf(address) external view returns (uint256);

  function earned(address) external view returns (EarnedData memory);

  function withdrawAll(bool) external returns (bool);

  function withdraw(uint256, bool) external returns (bool);

  // function withdrawAndUnwrap(uint256, bool) external returns (bool);

  function getReward(address) external;

  function stake(uint256) external returns (bool);

  function claimable_reward (address, address) external view returns (uint256);

  function rewards(address) external view returns (uint256);
}