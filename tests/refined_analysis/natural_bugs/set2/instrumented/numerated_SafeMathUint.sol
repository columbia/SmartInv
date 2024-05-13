1 pragma solidity 0.7.3;
2 
3 /**
4  * @title SafeMathUint
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMathUint {
8   function toInt256Safe(uint256 a) internal pure returns (int256) {
9     int256 b = int256(a);
10     require(b >= 0);
11     return b;
12   }
13 }