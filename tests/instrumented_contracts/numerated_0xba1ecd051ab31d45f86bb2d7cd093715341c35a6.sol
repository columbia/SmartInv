1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         require(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     /**
43     * @dev Adds two numbers, reverts on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54     * reverts when dividing by zero.
55     */
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 
62 contract Raffle {
63     using SafeMath for uint256;
64     
65     mapping (address => uint256) public balances;
66 
67     address public owner;
68     address public winner;
69   
70     address[] public entrants;
71     uint256 public numEntrants;
72     uint256 public entryPrice;
73     uint256 public deadline;
74     uint256 public threshold;
75     uint256 public percentageTaken;
76     
77     event PlayerEntered(address participant,uint256 amount,uint256 totalParticipants);
78     event Winner(address winner,uint256 amount);
79     
80     // @param _entryPrice - entry price for each participant in wei i.e. 10^-18 eth.
81     // @param _deadline - block number at which you want the crowdsale to end
82     // @param _percentageToken - for example, to take 33% of the total use 3, only use integers
83     constructor(uint256 _entryPrice, uint256 _deadline, uint256 _percentageTaken,uint256 _thresold) public {
84         entryPrice = _entryPrice;
85         deadline = _deadline;
86         percentageTaken = _percentageTaken;
87         threshold = _thresold;
88         owner = msg.sender;
89     }    
90 
91     modifier thresholdReached() {
92         require(numEntrants >= threshold, "Below Thresold participant");
93         _;
94     }
95 
96     modifier belowThreshold() {
97         require(numEntrants <= threshold, "Above Thresold participant");
98         _;
99     }
100 
101     modifier deadlinePassed() {
102         require(now >= deadline, "Deadline is not Passed");
103         _;
104     }
105 
106     modifier deadlineNotPassed() {
107         require(now <= deadline,"Deadline is Passed");
108         _;
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == owner, "You are not Owner");
113         _;
114     }
115     
116     modifier pickingWinner() {
117         require(winner == 0x0, "Winner is already picked");
118         _;
119     }
120     
121     function() public payable {
122         enterRaffle();
123     }
124 
125     function enterRaffle() public payable deadlineNotPassed {
126         require(msg.value == entryPrice);
127         balances[msg.sender] = balances[msg.sender].add(msg.value);
128         numEntrants = numEntrants.add(1);
129         entrants.push(msg.sender);
130         emit PlayerEntered(msg.sender, msg.value, numEntrants);
131     }
132 
133     function withdrawFunds(uint amount) public deadlinePassed belowThreshold {
134         require(balances[msg.sender] >= amount, "You do not have enough balance");
135         balances[msg.sender] = balances[msg.sender].sub(amount);
136         (msg.sender).transfer(amount);
137     }
138 
139     function determineWinner() public onlyOwner deadlinePassed thresholdReached pickingWinner {
140         
141         uint256 blockSeed = uint256(blockhash(block.number - 1)).div(2);
142         uint256 coinbaseSeed = uint256(block.coinbase).div(2);
143         uint256 winnerIndex = blockSeed.add(coinbaseSeed).mod(numEntrants);
144         winner = entrants[winnerIndex];
145         uint256 payout = address(this).balance;
146         payout = payout.div(percentageTaken);
147         winner.transfer(payout);
148         owner.transfer(address(this).balance);
149         emit Winner(winner, payout);
150     }
151 }