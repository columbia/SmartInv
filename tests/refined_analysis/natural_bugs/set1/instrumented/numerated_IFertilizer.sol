1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 
5 interface IFertilizer {
6     struct Balance {
7         uint128 amount;
8         uint128 lastBpf;
9     }
10     function beanstalkUpdate(
11         address account,
12         uint256[] memory ids,
13         uint128 bpf
14     ) external returns (uint256);
15     function beanstalkMint(address account, uint256 id, uint128 amount, uint128 bpf) external;
16     function balanceOfFertilized(address account, uint256[] memory ids) external view returns (uint256);
17     function balanceOfUnfertilized(address account, uint256[] memory ids) external view returns (uint256);
18     function lastBalanceOf(address account, uint256 id) external view returns (Balance memory);
19     function lastBalanceOfBatch(address[] memory account, uint256[] memory id) external view returns (Balance[] memory);
20     function setURI(string calldata newuri) external;
21 }