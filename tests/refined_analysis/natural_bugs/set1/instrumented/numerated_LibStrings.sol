1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library LibStrings {
9 
10     bytes16 private constant _SYMBOLS = "0123456789abcdef";
11     uint8 private constant _ADDRESS_LENGTH = 20;
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         uint256 index = digits - 1;
31         temp = value;
32         while (temp != 0) {
33             buffer[index--] = bytes1(uint8(48 + temp % 10));
34             temp /= 10;
35         }
36         return string(buffer);
37     }
38 
39      function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
40         bytes memory buffer = new bytes(2 * length + 2);
41         buffer[0] = "0";
42         buffer[1] = "x";
43         for (uint256 i = 2 * length + 1; i > 1; --i) {
44             buffer[i] = _SYMBOLS[value & 0xf];
45             value >>= 4;
46         }
47         require(value == 0, "Strings: hex length insufficient");
48         return string(buffer);
49     }
50 
51     function toHexString(address addr) internal pure returns (string memory) {
52         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
53     }
54 
55     /**
56      * @dev Converts a `int256` to its ASCII `string` representation.
57      */
58     function toString(int256 value) internal pure returns(string memory){
59         if(value > 0){
60             return toString(uint256(value));
61         } else {
62             return string(abi.encodePacked("-", toString(uint256(-value))));
63         }
64     }
65 }
