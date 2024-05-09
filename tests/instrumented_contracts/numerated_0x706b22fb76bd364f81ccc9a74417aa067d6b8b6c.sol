1 pragma solidity 0.5.14;
2           
3           //------ busniness plan ------
4         
5             // www.theauriga.io package amount
6         
7                 // 1)	0.05 eth
8                 // 2)	0.10 eth
9                 // 3)	0.20 eth
10                 // 4)	0.50 eth
11                 // 5)	1 eth
12                 // 6)	 2 eth
13                 // 7)	5 eth
14                 // 8)	10 eth
15                 // 9)	25 eth
16                 // 10)	 50 eth
17                 // 11)	 100 eth  
18                 
19                 
20                 // Direct income
21                 
22                 // 30% = 20%
23                 // 40% = 10%
24                 // 50%  after two sponsor user will get 
25                 // 50%  one step direct income if sponsor will not 
26                 // available in next plan maintenance fee 1% excluded
27 /**     
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a); 
69     return c;
70   }
71 }
72 contract TheAuriga {
73     event Multisended(uint256 value , address sender);
74     using SafeMath for uint256;
75 
76     function multisendEther(address payable[]  memory  _contributors, uint256[] memory _balances) public payable {
77         uint256 total = msg.value;
78         uint256 i = 0;
79         for (i; i < _contributors.length; i++) {
80             require(total >= _balances[i] );
81             total = total.sub(_balances[i]);
82             _contributors[i].transfer(_balances[i]);
83         }
84         emit Multisended(msg.value, msg.sender);
85     }
86 }