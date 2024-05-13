1 pragma solidity 0.7.3;
2 
3 /**
4  * @title SafeMathInt
5  * @dev Math operations with safety checks that revert on error
6  * @dev SafeMath adapted for int256
7  * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
8  */
9 library SafeMathInt {
10   function mul(int256 a, int256 b) internal pure returns (int256) {
11     // Prevent overflow when multiplying INT256_MIN with -1
12     // https://github.com/RequestNetwork/requestNetwork/issues/43
13     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
14 
15     int256 c = a * b;
16     require((b == 0) || (c / b == a));
17     return c;
18   }
19 
20   function div(int256 a, int256 b) internal pure returns (int256) {
21     // Prevent overflow when dividing INT256_MIN by -1
22     // https://github.com/RequestNetwork/requestNetwork/issues/43
23     require(!(a == - 2**255 && b == -1) && (b > 0));
24 
25     return a / b;
26   }
27 
28   function sub(int256 a, int256 b) internal pure returns (int256) {
29     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
30 
31     return a - b;
32   }
33 
34   function add(int256 a, int256 b) internal pure returns (int256) {
35     int256 c = a + b;
36     require((b >= 0 && c >= a) || (b < 0 && c < a));
37     return c;
38   }
39 
40   function toUint256Safe(int256 a) internal pure returns (uint256) {
41     require(a >= 0);
42     return uint256(a);
43   }
44 }