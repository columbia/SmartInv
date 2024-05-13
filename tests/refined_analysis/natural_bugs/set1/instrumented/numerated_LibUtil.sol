1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import "./LibBytes.sol";
5 
6 library LibUtil {
7     using LibBytes for bytes;
8 
9     function getRevertMsg(
10         bytes memory _res
11     ) internal pure returns (string memory) {
12         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
13         if (_res.length < 68) return "Transaction reverted silently";
14         bytes memory revertData = _res.slice(4, _res.length - 4); // Remove the selector which is the first 4 bytes
15         return abi.decode(revertData, (string)); // All that remains is the revert string
16     }
17 
18     /// @notice Determines whether the given address is the zero address
19     /// @param addr The address to verify
20     /// @return Boolean indicating if the address is the zero address
21     function isZeroAddress(address addr) internal pure returns (bool) {
22         return addr == address(0);
23     }
24 }
