1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 import "@summa-tx/memview-sol/contracts/TypedMemView.sol";
5 
6 library TypeCasts {
7     using TypedMemView for bytes;
8     using TypedMemView for bytes29;
9 
10     function coerceBytes32(string memory _s)
11         internal
12         pure
13         returns (bytes32 _b)
14     {
15         _b = bytes(_s).ref(0).index(0, uint8(bytes(_s).length));
16     }
17 
18     // treat it as a null-terminated string of max 32 bytes
19     function coerceString(bytes32 _buf)
20         internal
21         pure
22         returns (string memory _newStr)
23     {
24         uint8 _slen = 0;
25         while (_slen < 32 && _buf[_slen] != 0) {
26             _slen++;
27         }
28 
29         // solhint-disable-next-line no-inline-assembly
30         assembly {
31             _newStr := mload(0x40)
32             mstore(0x40, add(_newStr, 0x40)) // may end up with extra
33             mstore(_newStr, _slen)
34             mstore(add(_newStr, 0x20), _buf)
35         }
36     }
37 
38     // alignment preserving cast
39     function addressToBytes32(address _addr) internal pure returns (bytes32) {
40         return bytes32(uint256(uint160(_addr)));
41     }
42 
43     // alignment preserving cast
44     function bytes32ToAddress(bytes32 _buf) internal pure returns (address) {
45         return address(uint160(uint256(_buf)));
46     }
47 }
