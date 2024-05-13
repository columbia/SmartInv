1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 
4 import "./Bitmap.sol";
5 
6 /**
7  * Packs an uint value into a "floating point" storage slot. Used for storing
8  * lastClaimIntegralSupply values in balance storage. For these values, we don't need
9  * to maintain exact precision but we don't want to be limited by storage size overflows.
10  *
11  * A floating point value is defined by the 48 most significant bits and an 8 bit number
12  * of bit shifts required to restore its precision. The unpacked value will always be less
13  * than the packed value with a maximum absolute loss of precision of (2 ** bitShift) - 1.
14  */
15 library FloatingPoint56 {
16 
17     function packTo56Bits(uint256 value) internal pure returns (uint56) {
18         uint256 bitShift;
19         // If the value is over the uint48 max value then we will shift it down
20         // given the index of the most significant bit. We store this bit shift 
21         // in the least significant byte of the 56 bit slot available.
22         if (value > type(uint48).max) bitShift = (Bitmap.getMSB(value) - 47);
23 
24         uint256 shiftedValue = value >> bitShift;
25         return uint56((shiftedValue << 8) | bitShift);
26     }
27 
28     function unpackFrom56Bits(uint256 value) internal pure returns (uint256) {
29         // The least significant 8 bits will be the amount to bit shift
30         uint256 bitShift = uint256(uint8(value));
31         return ((value >> 8) << bitShift);
32     }
33 
34 }
