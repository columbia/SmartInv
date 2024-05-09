1 pragma solidity 0.5.14;
2           
3           //------ busniness plan ------
4         
5         //       https://www.libaax.io
6             
7             // Level 1 : 0.05 ETH
8             
9             // Level 2 :0.10 ETH
10             
11             // Level 3 :0.25 ETH
12             
13             // Level 4 :0.50 ETH
14             
15             // Level 5 :1 ETH
16             
17             // Level 6 :5 ETH
18             
19             // Level 7 :8 ETH
20             
21             // Level 8 :16 ETH
22             
23             // Level 9 :32 ETH
24             
25             // Level 10 :64 ETH
26         
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a); 
70     return c;
71   }
72 }
73 contract Libaax {
74     event Multisended(uint256 value , address sender);
75     using SafeMath for uint256;
76 
77     function multisendEther(address payable[]  memory  _contributors, uint256[] memory _balances) public payable {
78         uint256 total = msg.value;
79         uint256 i = 0;
80         for (i; i < _contributors.length; i++) {
81             require(total >= _balances[i] );
82             total = total.sub(_balances[i]);
83             _contributors[i].transfer(_balances[i]);
84         }
85         emit Multisended(msg.value, msg.sender);
86     }
87 }