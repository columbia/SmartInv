1 pragma solidity >=0.4.25 <0.6.0;
2 
3 /**
4  * Minimum recommendation: 10(GWEI) & 121000 Gas 
5    Minimum send to this contract = 0.2 eth
6    Approximately 2.5 mill tokens = 10.000 ETH "hard goal"
7    Deadline 4/aug/2019  
8     check in site iskra-coin.io
9  */
10 
11 interface token {
12     function transfer(address receiver, uint amount) external;
13 }
14 
15 contract ReentrancyGuard {
16     /// @dev counter to allow mutex lock with only one SSTORE operation
17     uint256 private _guardCounter;
18 
19     constructor () internal {
20         // The counter starts at one to prevent changing it from zero to a non-zero
21         // value, which is a more expensive operation.
22         _guardCounter = 1;
23     }
24 
25     /**
26      * @dev Prevents a contract from calling itself, directly or indirectly.
27      * Calling a `nonReentrant` function from another `nonReentrant`
28      * function is not supported. It is possible to prevent this from happening
29      * by making the `nonReentrant` function external, and make it call a
30      * `private` function that does the actual work.
31      */
32     modifier nonReentrant() {
33         _guardCounter += 1;
34         uint256 localCounter = _guardCounter;
35         _;
36         require(localCounter == _guardCounter);
37     }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Unsigned math operations with safety checks that revert on error
43  */
44 library SafeMath {
45     /**
46      * @dev Multiplies two unsigned integers, reverts on overflow.
47      */
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64      */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     /**
85      * @dev Adds two unsigned integers, reverts on overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     /**
95      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
96      * reverts when dividing by zero.
97      */
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 contract LightCrowdsale1 is ReentrancyGuard {
105 
106     using SafeMath for uint256;
107     using SafeMath for uint;
108 
109     address payable public beneficiary; // wallet to send eth to
110     uint public fundingGoal; // maximum amount to raise
111     uint public amountRaised; // current amount raised
112     uint public minAmountWei; // min amount for crowdsale
113     uint public deadline; // time when crowdsale to close
114     uint public price; // price for token
115     token public tokenReward; // token
116     mapping(address => uint256) public balanceOf;
117     bool fundingGoalReached = false;
118     bool crowdsaleClosed = false;
119 
120     event GoalReached(address recipient, uint totalAmountRaised);
121     event FundTransfer(address backer, uint amount, bool isContribution);
122 
123     /**
124      * Constructor
125      *
126      * Setup the owner
127      */
128     constructor(
129         address payable ifSuccessfulSendTo,
130         uint fundingGoalInEthers,
131         uint durationInMinutes,
132         uint finneyCostOfEachToken,
133         address addressOfTokenUsedAsReward,
134         uint minAmountFinney
135     ) public {
136         beneficiary = ifSuccessfulSendTo;
137         fundingGoal = fundingGoalInEthers * 1 ether;
138         deadline = now + durationInMinutes * 1 minutes;
139         price = finneyCostOfEachToken * 1 finney;
140         minAmountWei = minAmountFinney * 1 finney;
141         tokenReward = token(addressOfTokenUsedAsReward);
142     }
143 
144     /**
145      * Fallback function
146      *
147      * The function without name is the default function that is called whenever anyone sends funds to a contract
148      */
149     function() payable external {
150         buyTokens(msg.sender);
151     }
152 
153     function buyTokens(address sender) public nonReentrant payable {
154         checkGoalReached();
155         require(!crowdsaleClosed);
156         require(sender != address(0));
157         uint amount = msg.value;
158         require(balanceOf[sender] >= amount);
159         require(amount != 0);
160         require(amount >= minAmountWei);
161 
162         uint senderBalance = balanceOf[sender];
163         balanceOf[sender] = senderBalance.add(amount);
164         amountRaised = amountRaised.add(amount);
165         uint tokenToSend = amount.div(price) * 1 ether;
166         tokenReward.transfer(sender, tokenToSend);
167         emit FundTransfer(sender, amount, true);
168 
169         if (beneficiary.send(amount)) {
170             emit FundTransfer(beneficiary, amount, false);
171         }
172 
173         checkGoalReached();
174     }
175 
176     modifier afterDeadline() {if (now >= deadline) _;}
177 
178     /**
179      * Check if goal was reached
180      *
181      * Checks if the goal or time limit has been reached and ends the campaign
182      */
183     function checkGoalReached() public afterDeadline {
184         if (amountRaised >= fundingGoal) {
185             fundingGoalReached = true;
186             crowdsaleClosed = true;
187             emit GoalReached(beneficiary, amountRaised);
188         }
189         if (now > deadline) {
190             crowdsaleClosed = true;
191             emit GoalReached(beneficiary, amountRaised);
192         }
193     }
194 }