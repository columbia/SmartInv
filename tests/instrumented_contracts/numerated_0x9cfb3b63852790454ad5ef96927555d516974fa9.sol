1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Clicker  {
48 
49     using SafeMath for uint;
50 
51     uint public points;
52     uint public pps; // points per second
53     uint public multiplier;
54     uint public upgrades;
55     uint public basecost;
56     uint public ppsBase;
57     uint public checkpoint = now;
58 
59     function Clicker() public {
60         _reset();
61     }
62 
63     function upgrade() external {
64         claimPoints();
65 
66         uint cost = getCost();
67 
68         points = points.sub(cost);
69         pps = pps.add(ppsBase);
70         upgrades = upgrades.add(1);
71     }
72 
73     function calculatePoints() public view returns (uint) {
74         uint secondsPassed = now.sub(checkpoint);
75         uint pointsEarned = secondsPassed.mul(pps);
76         return points.add(pointsEarned);
77     }
78 
79     function getCost() public view returns (uint) {
80         return basecost.mul(multiplier ** upgrades);
81     }
82 
83     function claimPoints() public {
84         points = calculatePoints();
85         checkpoint = now;
86     }
87 
88     function won() public view returns (bool) {
89         uint secondsPassed = now - checkpoint;
90         uint pointsEarned = secondsPassed * pps;
91         uint total = points + pointsEarned;
92         // If we overflow then we win
93         if (total < points) {
94             return true;
95         }
96         return false;
97     }
98 
99     function prestige() external {
100         require(won());
101         _reset();
102     }
103 
104     function _reset() internal {
105         points = 1;
106         pps = 1;
107         multiplier = 2;
108         upgrades = 1;
109         basecost = 1;
110         ppsBase = ppsBase.add(1); // each prestige we increase the pps base
111         checkpoint = now;
112     }
113 
114     function getLevel() external view returns (uint) {
115         return ppsBase;
116     }
117 }