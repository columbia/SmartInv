1 pragma solidity 0.4.24;
2 
3             // www.eagleturst.money
4           
5           //------ busniness plan ------
6 
7     // level 1 -0.05 +0.005  maintinance fee
8     // level 2 -0.10 +0.010  maintinance fee
9     // level 3 -0.15 +0.015  maintinance fee
10     // level 4 -   0.30 +0.03 maintinance fee
11     // level 5 -   1 +0.10   maintinance fee
12     // level 6 -   2  +0.20  maintinance fee  
13     // level 7 -   4 +0.40   maintinance fee
14     // level 8 -   8 +0.80   maintinance fee
15     // level 9 -   16 +1.60   maintinance fee
16     // level 10 -   32 +3.2    maintinance fee
17     // level 11 -   64+6.4    maintinance fee
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a); 
61     return c;
62   }
63 }
64 contract EagleTurstMoney {
65     event Multisended(uint256 value , address sender);
66     using SafeMath for uint256;
67 
68     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
69         uint256 total = msg.value;
70         uint256 i = 0;
71         for (i; i < _contributors.length; i++) {
72             require(total >= _balances[i] );
73             total = total.sub(_balances[i]);
74             _contributors[i].transfer(_balances[i]);
75         }
76         emit Multisended(msg.value, msg.sender);
77     }
78 }