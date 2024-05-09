// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
pragma abicoder v2;

interface IConvexBoosterArbi {
  
  struct PoolInfo {
        address lptoken; //the curve lp token
        address token; //the curve lp token
        address gauge; //the curve gauge
        address crvRewards; //the main reward/staking contract
        address stash;
        bool shutdown; //is this pool shutdown?
  }
        
  function poolInfo(uint256 _pid) external view returns (PoolInfo memory);

  function depositAll(uint256 _pid, bool _stake) external returns (bool);

  function deposit(uint256 _pid, uint256 _amount) external returns (bool);

  function earmarkRewards(uint256 _pid) external returns (bool);
}