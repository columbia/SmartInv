1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: contracts/Distribute.sol
56 
57 contract Distribute {
58 
59     using SafeMath for SafeMath;
60 
61     address public netAddress = 0x88888888c84198BCc5CEb4160d13726F22c151Ab;
62 
63     address public otherAddress = 0x8e83D33aB48b110B7C3DF8C6F5D02191aF9b80FD;
64 
65     uint proportionA = 94;
66     uint proportionB = 6;
67     uint base = 100;
68 
69     constructor() public {
70 
71     }
72 
73     function() payable public {
74         require(msg.value > 0);
75 
76         netAddress.transfer(SafeMath.div(SafeMath.mul(msg.value, proportionA), base));
77         otherAddress.transfer(SafeMath.div(SafeMath.mul(msg.value, proportionB), base));
78 
79     }
80 
81 
82 }