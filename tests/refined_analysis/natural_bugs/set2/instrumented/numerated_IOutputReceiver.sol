1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IRegistryProvider.sol";
6 import '@openzeppelin/contracts/utils/introspection/IERC165.sol';
7 
8 
9 /**
10  * @title Provider interface for Revest FNFTs
11  */
12 interface IOutputReceiver is IRegistryProvider, IERC165 {
13 
14     function receiveRevestOutput(
15         uint fnftId,
16         address asset,
17         address payable owner,
18         uint quantity
19     ) external;
20 
21     function getCustomMetadata(uint fnftId) external view returns (string memory);
22 
23     function getValue(uint fnftId) external view returns (uint);
24 
25     function getAsset(uint fnftId) external view returns (address);
26 
27     function getOutputDisplayValues(uint fnftId) external view returns (bytes memory);
28 
29 }
