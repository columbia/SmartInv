1 pragma solidity ^0.5.16;
2 
3 /**
4  * @title Careful Math
5  * @author Compound
6  * @notice Derived from OpenZeppelin's SafeMath library
7  *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
8  */
9 contract CarefulMath {
10     /**
11      * @dev Possible error codes that we can return
12      */
13     enum MathError {
14         NO_ERROR,
15         DIVISION_BY_ZERO,
16         INTEGER_OVERFLOW,
17         INTEGER_UNDERFLOW
18     }
19 
20     /**
21      * @dev Multiplies two numbers, returns an error on overflow.
22      */
23     function mulUInt(uint256 a, uint256 b) internal pure returns (MathError, uint256) {
24         if (a == 0) {
25             return (MathError.NO_ERROR, 0);
26         }
27 
28         uint256 c = a * b;
29 
30         if (c / a != b) {
31             return (MathError.INTEGER_OVERFLOW, 0);
32         } else {
33             return (MathError.NO_ERROR, c);
34         }
35     }
36 
37     /**
38      * @dev Integer division of two numbers, truncating the quotient.
39      */
40     function divUInt(uint256 a, uint256 b) internal pure returns (MathError, uint256) {
41         if (b == 0) {
42             return (MathError.DIVISION_BY_ZERO, 0);
43         }
44 
45         return (MathError.NO_ERROR, a / b);
46     }
47 
48     /**
49      * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
50      */
51     function subUInt(uint256 a, uint256 b) internal pure returns (MathError, uint256) {
52         if (b <= a) {
53             return (MathError.NO_ERROR, a - b);
54         } else {
55             return (MathError.INTEGER_UNDERFLOW, 0);
56         }
57     }
58 
59     /**
60      * @dev Adds two numbers, returns an error on overflow.
61      */
62     function addUInt(uint256 a, uint256 b) internal pure returns (MathError, uint256) {
63         uint256 c = a + b;
64 
65         if (c >= a) {
66             return (MathError.NO_ERROR, c);
67         } else {
68             return (MathError.INTEGER_OVERFLOW, 0);
69         }
70     }
71 
72     /**
73      * @dev add a and b and then subtract c
74      */
75     function addThenSubUInt(
76         uint256 a,
77         uint256 b,
78         uint256 c
79     ) internal pure returns (MathError, uint256) {
80         (MathError err0, uint256 sum) = addUInt(a, b);
81 
82         if (err0 != MathError.NO_ERROR) {
83             return (err0, 0);
84         }
85 
86         return subUInt(sum, c);
87     }
88 }
