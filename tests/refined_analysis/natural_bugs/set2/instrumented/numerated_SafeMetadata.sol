1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
5 import {IERC20Metadata} from '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';
6 
7 library SafeMetadata {
8     function safeName(IERC20 token) internal view returns (string memory) {
9         (bool success, bytes memory data) = address(token).staticcall(
10             abi.encodeWithSelector(IERC20Metadata.name.selector)
11         );
12         return success ? returnDataToString(data) : 'Token';
13     }
14 
15     function safeSymbol(IERC20 token) internal view returns (string memory) {
16         (bool success, bytes memory data) = address(token).staticcall(
17             abi.encodeWithSelector(IERC20Metadata.symbol.selector)
18         );
19         return success ? returnDataToString(data) : 'TKN';
20     }
21 
22     function safeDecimals(IERC20 token) internal view returns (uint8) {
23         (bool success, bytes memory data) = address(token).staticcall(
24             abi.encodeWithSelector(IERC20Metadata.decimals.selector)
25         );
26         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
27     }
28 
29     function returnDataToString(bytes memory data) private pure returns (string memory) {
30         if (data.length >= 64) {
31             return abi.decode(data, (string));
32         } else if (data.length == 32) {
33             uint8 i = 0;
34             while (i < 32 && data[i] != 0) {
35                 i++;
36             }
37             bytes memory bytesArray = new bytes(i);
38             for (i = 0; i < 32 && data[i] != 0; i++) {
39                 bytesArray[i] = data[i];
40             }
41             return string(bytesArray);
42         } else {
43             return '???';
44         }
45     }
46 }
