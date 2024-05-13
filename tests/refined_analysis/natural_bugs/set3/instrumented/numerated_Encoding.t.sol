1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {Test} from "forge-std/Test.sol";
5 import {Encoding} from "../Encoding.sol";
6 
7 contract EncodingTest is Test {
8     using Encoding for uint32;
9     using Encoding for uint256;
10 
11     function setUp() public {}
12 
13     function testFuzz_decimalUint32(uint32 input) public {
14         vm.assume(input != 0);
15         uint256 digits;
16         uint32 number = input;
17         while (number != 0) {
18             number /= 10;
19             digits++;
20         }
21         string memory str = vm.toString(uint256(input));
22         // Add as many zeroes as needed to reach 10 digits in total
23         // 01 ---> 00000000 + 01
24         for (uint256 i; i < 10 - digits; i++) {
25             str = string(abi.encodePacked("0", str));
26         }
27         assertEq(abi.encodePacked(input.decimalUint32()), bytes(str));
28     }
29 
30     function testFuzz_encodeHex(bytes32 input) public {
31         (uint256 a, uint256 b) = uint256(input).encodeHex();
32         string memory output = string(abi.encodePacked("0x", a, b));
33         assertEq(output, vm.toString(input));
34     }
35 }
