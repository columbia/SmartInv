1 pragma solidity ^0.4.19;
2 
3 contract EtherHell {
4     using SafeMath for uint256;
5 
6     event NewRound(
7         uint _timestamp,
8         uint _round,
9         uint _initialPot
10     );
11 
12     event Bid(
13         uint _timestamp,
14         address _address,
15         uint _amount,
16         uint _newPot
17     );
18 
19     event NewLeader(
20         uint _timestamp,
21         address _address,
22         uint _newPot,
23         uint _newDeadline
24     );
25     
26     event Winner(
27         uint _timestamp,
28         address _address,
29         uint _earnings,
30         uint _deadline
31     );
32 
33     event Withdrawal(
34         uint _timestamp,
35         address _address,
36         uint _amount
37     );
38 
39     // Initial countdown duration at the start of each round
40     uint public constant BASE_DURATION = 1 days;
41 
42     // Amount by which the countdown duration decreases per ether in the pot
43     uint public constant DURATION_DECREASE_PER_ETHER = 10 minutes;
44 
45     // Minimum countdown duration
46     uint public constant MINIMUM_DURATION = 1 hours;
47 
48     // Fraction of the previous pot used to seed the next pot
49     uint public constant NEXT_POT_FRAC_TOP = 1;
50     uint public constant NEXT_POT_FRAC_BOT = 2;
51 
52     // Minimum fraction of the pot required by a bidder to become the new leader
53     uint public constant MIN_LEADER_FRAC_TOP = 1;
54     uint public constant MIN_LEADER_FRAC_BOT = 1000;
55 
56     // Fraction of each bid set aside as seed funding for even more devilish variants from the community
57     uint public constant FUND_FRAC_TOP = 1;
58     uint public constant FUND_FRAC_BOT = 5;
59 
60     // Owner of the contract
61     address owner;
62 
63     // Mapping from addresses to amounts earned
64     mapping(address => uint) public earnings;
65 
66     // Current round number
67     uint public round;
68 
69     // Current value of the pot
70     uint public pot;
71 
72     // Address of the current leader
73     address public leader;
74 
75     // Time at which the current round expires
76     uint public deadline;
77 
78     function EtherHell() public payable {
79         require(msg.value > 0);
80         owner = msg.sender;
81         round = 1;
82         pot = msg.value;
83         leader = owner;
84         deadline = computeDeadline();
85         NewRound(now, round, pot);
86         NewLeader(now, leader, pot, deadline);
87     }
88     
89     function computeDeadline() internal view returns (uint) {
90         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
91         uint _duration;
92         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
93             _duration = MINIMUM_DURATION;
94         } else {
95             _duration = BASE_DURATION.sub(_durationDecrease);
96         }
97         return now.add(_duration);
98     }
99 
100     modifier advanceRoundIfNeeded {
101         if (now > deadline) {
102             uint _nextPot = pot.mul(NEXT_POT_FRAC_TOP).div(NEXT_POT_FRAC_BOT);
103             uint _leaderEarnings = pot.sub(_nextPot);
104             Winner(now, leader, _leaderEarnings, deadline);
105             earnings[leader] = earnings[leader].add(_leaderEarnings);
106             round++;
107             pot = _nextPot;
108             leader = owner;
109             deadline = computeDeadline();
110             NewRound(now, round, pot);
111             NewLeader(now, leader, pot, deadline);
112         }
113         _;
114     }
115 
116     function bid() public payable advanceRoundIfNeeded {
117         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
118         uint _bidAmountToFund = msg.value.mul(FUND_FRAC_TOP).div(FUND_FRAC_BOT);
119         uint _bidAmountToPot = msg.value.sub(_bidAmountToFund);
120 
121         earnings[owner] = earnings[owner].add(_bidAmountToFund);
122         pot = pot.add(_bidAmountToPot);
123         Bid(now, msg.sender, msg.value, pot);
124 
125         if (msg.value >= _minLeaderAmount) {
126             leader = msg.sender;
127             deadline = computeDeadline();
128             NewLeader(now, leader, pot, deadline);
129         }
130     }
131 
132     function withdraw() public advanceRoundIfNeeded {
133         require(earnings[msg.sender] > 0);
134         assert(earnings[msg.sender] <= this.balance);
135         uint _amount = earnings[msg.sender];
136         earnings[msg.sender] = 0;
137         msg.sender.transfer(_amount);
138         Withdrawal(now, msg.sender, _amount);
139     }
140 }
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that throw on error
145  */
146 library SafeMath {
147     /**
148     * @dev Multiplies two numbers, throws on overflow.
149     */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151       	if (a == 0) {
152       	  return 0;
153       	}
154       	uint256 c = a * b;
155       	assert(c / a == b);
156       	return c;
157     }
158 
159     /**
160     * @dev Integer division of two numbers, truncating the quotient.
161     */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // assert(b > 0); // Solidity automatically throws when dividing by 0
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166         return c;
167     }
168 
169     /**
170     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         assert(b <= a);
174         return a - b;
175     }
176 
177     /**
178     * @dev Adds two numbers, throws on overflow.
179     */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         assert(c >= a);
183         return c;
184     }
185 }