1 pragma solidity 0.5.14;
2           
3           //------ busniness plan ------
4         
5         //  www.smartkey.money package amount
6         
7                 // 1)	0.05 eth
8                 // 2)	0.10 eth
9                 // 3)	0.20 eth
10                 // 4)	0.50 eth
11                 // 5)	1 eth
12                 // 6)	 5eth
13                 // 7)	10eth
14                 // 8)	20eth
15                 
16                 
17                 // Direct income
18                 
19                 // 80%
20                 // Pool income
21                 // 15%
22                 // Admin 
23                 // 5%
24 /**     
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a); 
66     return c;
67   }
68 }
69 contract SmartKey {
70     event Multisended(uint256 value , address sender);
71     using SafeMath for uint256;
72 
73     function multisendEther(address payable[]  memory  _contributors, uint256[] memory _balances) public payable {
74         uint256 total = msg.value;
75         uint256 i = 0;
76         for (i; i < _contributors.length; i++) {
77             require(total >= _balances[i] );
78             total = total.sub(_balances[i]);
79             _contributors[i].transfer(_balances[i]);
80         }
81         emit Multisended(msg.value, msg.sender);
82     }
83 }