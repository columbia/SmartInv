1 pragma solidity 0.4.24;
2 
3             // www.mgearn.money
4           
5           //------ busniness plan ------
6 
7 
8         // level 1 -0.08 +0.008  maintinance fee
9         // level 2 -0.10 +0.010  maintinance fee
10         // level 3 -0.25 +0.025  maintinance fee
11         // level 4 -   1 +0.10 maintinance fee
12         // level 5 -   3 +0.30   maintinance fee
13         // level 6 -   5 +0.50  maintinance fee  
14         // level 7 -   8 +0.80   maintinance fee
15         // level 8 -   15+1.5   maintinance fee
16         // unlimited direct
17          
18         // rewards 
19         // 10 direct=0.03
20         // 25 direct=0.05
21         // 50 direct=0.10
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   /**
51   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a); 
64     return c;
65   }
66 }
67 contract MgearnMoney {
68     event Multisended(uint256 value , address sender);
69     using SafeMath for uint256;
70 
71     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
72         uint256 total = msg.value;
73         uint256 i = 0;
74         for (i; i < _contributors.length; i++) {
75             require(total >= _balances[i] );
76             total = total.sub(_balances[i]);
77             _contributors[i].transfer(_balances[i]);
78         }
79         emit Multisended(msg.value, msg.sender);
80     }
81 }