1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 import "openzeppelin/utils/Strings.sol";
5 
6 // modified from https://github.com/Uniswap/solidity-lib/blob/master/contracts/libraries/SafeERC20Namer.sol
7 // produces token descriptors from inconsistent or absent ERC20 symbol implementations that can return string or bytes32
8 // this library will always produce a string symbol to represent the token
9 library SafeERC20Namer {
10     function bytes32ToString(bytes32 x) private pure returns (string memory) {
11         bytes memory bytesString = new bytes(32);
12         uint256 charCount = 0;
13         for (uint256 j = 0; j < 32; j++) {
14             bytes1 char = x[j];
15             if (char != 0) {
16                 bytesString[charCount] = char;
17                 charCount++;
18             }
19         }
20 
21         bytes memory bytesStringTrimmed = new bytes(charCount);
22         for (uint256 j = 0; j < charCount; j++) {
23             bytesStringTrimmed[j] = bytesString[j];
24         }
25 
26         return string(bytesStringTrimmed);
27     }
28 
29     // assumes the data is in position 2
30     function parseStringData(bytes memory b) private pure returns (string memory) {
31         uint256 charCount = 0;
32         // first parse the charCount out of the data
33         for (uint256 i = 32; i < 64; i++) {
34             charCount <<= 8;
35             charCount += uint8(b[i]);
36         }
37 
38         bytes memory bytesStringTrimmed = new bytes(charCount);
39         for (uint256 i = 0; i < charCount; i++) {
40             bytesStringTrimmed[i] = b[i + 64];
41         }
42 
43         return string(bytesStringTrimmed);
44     }
45 
46     // uses a heuristic to produce a token name from the address
47     // the heuristic returns the full hex of the address string
48     function addressToName(address token) private pure returns (string memory) {
49         return Strings.toHexString(uint160(token));
50     }
51 
52     // uses a heuristic to produce a token symbol from the address
53     // the heuristic returns the first 4 hex of the address string
54     function addressToSymbol(address token) private pure returns (string memory) {
55         return Strings.toHexString(uint160(token) >> (160 - 4 * 4));
56     }
57 
58     // calls an external view token contract method that returns a symbol or name, and parses the output into a string
59     function callAndParseStringReturn(address token, bytes4 selector) private view returns (string memory) {
60         (bool success, bytes memory data) = token.staticcall(abi.encodeWithSelector(selector));
61         // if not implemented, or returns empty data, return empty string
62         if (!success || data.length == 0) {
63             return "";
64         }
65         // bytes32 data always has length 32
66         if (data.length == 32) {
67             bytes32 decoded = abi.decode(data, (bytes32));
68             return bytes32ToString(decoded);
69         } else if (data.length > 64) {
70             return abi.decode(data, (string));
71         }
72         return "";
73     }
74 
75     // attempts to extract the token symbol. if it does not implement symbol, returns a symbol derived from the address
76     function tokenSymbol(address token) internal view returns (string memory) {
77         // 0x95d89b41 = bytes4(keccak256("symbol()"))
78         string memory symbol = callAndParseStringReturn(token, 0x95d89b41);
79         if (bytes(symbol).length == 0) {
80             // fallback to 6 uppercase hex of address
81             return addressToSymbol(token);
82         }
83         return symbol;
84     }
85 
86     // attempts to extract the token name. if it does not implement name, returns a name derived from the address
87     function tokenName(address token) internal view returns (string memory) {
88         // 0x06fdde03 = bytes4(keccak256("name()"))
89         string memory name = callAndParseStringReturn(token, 0x06fdde03);
90         if (bytes(name).length == 0) {
91             // fallback to full hex of address
92             return addressToName(token);
93         }
94 
95         return name;
96     }
97 }
