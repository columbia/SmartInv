1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 interface IERC165 {
5     /// @notice Query if a contract implements an interface
6     /// @param interfaceId The interface identifier, as specified in ERC-165
7     /// @dev Interface identification is specified in ERC-165. This function
8     ///  uses less than 30,000 gas.
9     /// @return `true` if the contract implements `interfaceID` and
10     ///  `interfaceID` is not 0xffffffff, `false` otherwise
11     function supportsInterface(bytes4 interfaceId) external view returns (bool);
12 }
