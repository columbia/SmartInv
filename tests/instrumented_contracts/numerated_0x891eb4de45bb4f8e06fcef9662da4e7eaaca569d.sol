1 pragma solidity ^0.5.7;
2 
3 /* SNAILNUMBER
4 
5 Simple game contract to let players pick a magic number.
6 The number has no importance in itself, but will be used in another game!
7 
8 Players must bid higher than the previous bid to enter their number.
9 Whoever has the highest bid at the end of a 24 hours period wins.
10 The winner gets a share of all the ETH, based on how quickly he bid.
11 The rest of the ETH is sent to SnailThrone as divs.
12 
13 */
14 
15 contract SnailNumber {
16 	using SafeMath for uint;
17 	
18 	event GameBid (address indexed player, uint eth, uint number, uint pot, uint winnerShare);
19 	event GameEnd (address indexed player, uint leaderReward, uint throneReward, uint number);
20 	
21 	address payable constant SNAILTHRONE= 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
22     uint256 constant SECONDS_IN_DAY = 86400;
23     uint256 constant numberMin = 300;
24     uint256 constant numberMax = 3000;
25     
26     uint256 public pot;
27     uint256 public bid;
28     address payable public leader;
29     uint256 public shareToWinner;
30     uint256 public shareToThrone;
31     uint256 public timerEnd;
32     uint256 public timerStart;
33     uint256 public number;
34     
35     address payable dev;
36     
37     // CONSTRUCTOR
38     // Sets end timer to 24 hours
39     
40     constructor() public {
41         timerStart = now;
42         timerEnd = now.add(SECONDS_IN_DAY);
43         dev = msg.sender;
44     }
45     
46     // BID
47     // Lets player pick number
48     // Locks his potential winnings
49     
50     function Bid(uint256 _number) payable public {
51         require(now < timerEnd, "game is over!");
52         require(msg.value > bid, "not enough to beat current leader");
53         require(_number >= numberMin, "number too low");
54         require(_number <= numberMax, "number too high");
55 
56         pot = pot.add(msg.value);
57         shareToWinner = ComputeShare();
58         uint256 _share = 100;
59         shareToThrone = _share.sub(shareToWinner);
60         leader = msg.sender;
61         number = _number;
62             
63         emit GameBid(msg.sender, msg.value, number, pot, shareToWinner);
64     }
65     
66     // END 
67     // Can be called manually after the game ends
68     // Sends pot to winner and snailthrone
69     
70     function End() public {
71         require(now > timerEnd, "game is still running!");
72         
73         uint256 _throneReward = pot.mul(shareToThrone).div(100);
74         pot = pot.sub(_throneReward);
75         (bool success, bytes memory data) = SNAILTHRONE.call.value(_throneReward)("");
76         require(success);
77         
78         uint256 _winnerReward = pot;
79         pot = 0;
80         leader.transfer(_winnerReward);
81         
82         emit GameEnd(leader, _winnerReward, _throneReward, number);
83     }
84     
85     // COMPUTESHARE 
86     // Calculates the share of the winner and of the throne, based on time lapsed
87     // Decreasing % from 100 to 0. The earlier the bid, the more money
88     
89     function ComputeShare() public view returns(uint256) {
90         uint256 _length = timerEnd.sub(timerStart);
91         uint256 _currentPoint = timerEnd.sub(now);
92         return _currentPoint.mul(100).div(_length);
93     }
94     
95     // ESCAPEHATCH
96     // Just in case a bug stops the "End" function, dev can withdraw all ETH
97     // But *only* a full day after the game has already ended!
98     
99     function EscapeHatch() public {
100         require(msg.sender == dev, "you're not the dev");
101         require(now > timerEnd.add(SECONDS_IN_DAY), "escape hatch only available 24h after end");
102         
103         dev.transfer(address(this).balance);
104     }
105 }
106 
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }