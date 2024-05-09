1 pragma solidity ^0.4.19;
2 
3 contract EthereumHole {
4     using SafeMath for uint256;
5 
6 
7     event NewLeader(
8         uint _timestamp,
9         address _address,
10         uint _newPot,
11         uint _newDeadline
12     );
13 
14 
15     event Winner(
16         uint _timestamp,
17         address _address,
18         uint _earnings,
19         uint _deadline
20     );
21 
22 
23     // Initial countdown duration at the start of each round
24     uint public constant BASE_DURATION = 600000 minutes;
25 
26     // Amount by which the countdown duration decreases per ether in the pot
27     uint public constant DURATION_DECREASE_PER_ETHER = 5 minutes;
28 
29     // Minimum countdown duration
30     uint public constant MINIMUM_DURATION = 5 minutes;
31     
32      // Minimum fraction of the pot required by a bidder to become the new leader
33     uint public constant min_bid = 10000000000000 wei;
34 
35     // Current value of the pot
36     uint public pot;
37 
38     // Address of the current leader
39     address public leader;
40 
41     // Time at which the current round expires
42     uint public deadline;
43     
44     // Is the game over?
45     bool public gameIsOver;
46 
47     function EthereumHole() public payable {
48         require(msg.value > 0);
49         gameIsOver = false;
50         pot = msg.value;
51         leader = msg.sender;
52         deadline = computeDeadline();
53         NewLeader(now, leader, pot, deadline);
54     }
55 
56     function computeDeadline() internal view returns (uint) {
57         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
58         uint _duration;
59         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
60             _duration = MINIMUM_DURATION;
61         } else {
62             _duration = BASE_DURATION.sub(_durationDecrease);
63         }
64         return now.add(_duration);
65     }
66 
67     modifier endGameIfNeeded {
68         if (now > deadline && !gameIsOver) {
69             Winner(now, leader, pot, deadline);
70             leader.transfer(pot);
71             gameIsOver = true;
72         }
73         _;
74     }
75 
76     function bid() public payable endGameIfNeeded {
77         if (msg.value > 0 && !gameIsOver) {
78             pot = pot.add(msg.value);
79             if (msg.value >= min_bid) {
80                 leader = msg.sender;
81                 deadline = computeDeadline();
82                 NewLeader(now, leader, pot, deadline);
83             }
84         }
85     }
86 
87 }
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94     /**
95     * @dev Multiplies two numbers, throws on overflow.
96     */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         assert(c / a == b);
103         return c;
104     }
105 
106     /**
107     * @dev Integer division of two numbers, truncating the quotient.
108     */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         // assert(b > 0); // Solidity automatically throws when dividing by 0
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113         return c;
114     }
115 
116     /**
117     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118     */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         assert(b <= a);
121         return a - b;
122     }
123 
124     /**
125     * @dev Adds two numbers, throws on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         assert(c >= a);
130         return c;
131     }
132 }