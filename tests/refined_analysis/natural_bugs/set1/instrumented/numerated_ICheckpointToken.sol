1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 interface ICheckpointToken {
5     /// @notice checkpoint rewards for given accounts. needs to be called before any balance change
6     function user_checkpoint(address[2] calldata _accounts) external returns(bool);
7 }
