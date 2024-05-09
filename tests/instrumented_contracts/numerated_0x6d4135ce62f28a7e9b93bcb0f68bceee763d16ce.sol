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
56         bid = msg.value;
57         pot = pot.add(msg.value);
58         shareToWinner = ComputeShare();
59         uint256 _share = 100;
60         shareToThrone = _share.sub(shareToWinner);
61         leader = msg.sender;
62         number = _number;
63             
64         emit GameBid(msg.sender, msg.value, number, pot, shareToWinner);
65     }
66     
67     // END 
68     // Can be called manually after the game ends
69     // Sends pot to winner and snailthrone
70     
71     function End() public {
72         require(now > timerEnd, "game is still running!");
73         
74         uint256 _throneReward = pot.mul(shareToThrone).div(100);
75         pot = pot.sub(_throneReward);
76         (bool success, bytes memory data) = SNAILTHRONE.call.value(_throneReward)("");
77         require(success);
78         
79         uint256 _winnerReward = pot;
80         pot = 0;
81         leader.transfer(_winnerReward);
82         
83         emit GameEnd(leader, _winnerReward, _throneReward, number);
84     }
85     
86     // COMPUTESHARE 
87     // Calculates the share of the winner and of the throne, based on time lapsed
88     // Decreasing % from 100 to 0. The earlier the bid, the more money
89     
90     function ComputeShare() public view returns(uint256) {
91         uint256 _length = timerEnd.sub(timerStart);
92         uint256 _currentPoint = timerEnd.sub(now);
93         return _currentPoint.mul(100).div(_length);
94     }
95     
96     // ESCAPEHATCH
97     // Just in case a bug stops the "End" function, dev can withdraw all ETH
98     // But *only* a full day after the game has already ended!
99     
100     function EscapeHatch() public {
101         require(msg.sender == dev, "you're not the dev");
102         require(now > timerEnd.add(SECONDS_IN_DAY), "escape hatch only available 24h after end");
103         
104         dev.transfer(address(this).balance);
105     }
106 }
107 
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114     if (a == 0) {
115       return 0;
116     }
117     uint256 c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers, truncating the quotient.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return c;
130   }
131 
132   /**
133   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   /**
141   * @dev Adds two numbers, throws on overflow.
142   */
143   function add(uint256 a, uint256 b) internal pure returns (uint256) {
144     uint256 c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }