1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 interface IHermesContract {
5     enum Status { Active, Paused, Punishment, Closed }
6     function initialize(address _token, address _operator, uint16 _hermesFee, uint256 _minStake, uint256 _maxStake, address payable _routerAddress) external;
7     function openChannel(address _party, uint256 _amountToLend) external;
8     function getOperator() external view returns (address);
9     function getStake() external view returns (uint256);
10     function getStatus() external view returns (Status);
11 }
