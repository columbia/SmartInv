1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 interface IBridgeToken {
5     function initialize() external;
6 
7     function name() external returns (string memory);
8 
9     function balanceOf(address _account) external view returns (uint256);
10 
11     function symbol() external view returns (string memory);
12 
13     function decimals() external view returns (uint8);
14 
15     function detailsHash() external view returns (bytes32);
16 
17     function burn(address _from, uint256 _amnt) external;
18 
19     function mint(address _to, uint256 _amnt) external;
20 
21     function setDetailsHash(bytes32 _detailsHash) external;
22 
23     function setDetails(
24         string calldata _name,
25         string calldata _symbol,
26         uint8 _decimals
27     ) external;
28 
29     // inherited from ownable
30     function transferOwnership(address _newOwner) external;
31 }
