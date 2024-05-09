1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * Minimum recommendation: 10(GWEI) & 121000 Gas 
5    Minimum send to this contract = 0.2 eth
6    Approximately 2.5 mill tokens = 10.000 ETH "hard goal"
7    Deadline 4/aug/2019 or GoalReached /// ISKRA-COIN.IO for "Lucem Fund" 
8  */
9 
10 interface token {
11     function transfer(address receiver, uint amount) external;
12 }
13 
14 contract ReentrancyGuard {
15     /// @dev counter to allow mutex lock with only one SSTORE operation
16     uint256 private _guardCounter;
17 
18     constructor () internal {
19         // The counter starts at one to prevent changing it from zero to a non-zero
20         // value, which is a more expensive operation.
21         _guardCounter = 1;
22     }
23 
24     /**
25      * @dev Prevents a contract from calling itself, directly or indirectly.
26      * Calling a `nonReentrant` function from another `nonReentrant`
27      * function is not supported. It is possible to prevent this from happening
28      * by making the `nonReentrant` function external, and make it call a
29      * `private` function that does the actual work.
30      */
31     modifier nonReentrant() {
32         _guardCounter += 1;
33         uint256 localCounter = _guardCounter;
34         _;
35         require(localCounter == _guardCounter);
36     }
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Unsigned math operations with safety checks that revert on error
42  */
43 library SafeMath {
44     /**
45      * @dev Multiplies two unsigned integers, reverts on overflow.
46      */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
63      */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Solidity only automatically asserts when dividing by 0
66         require(b > 0);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Adds two unsigned integers, reverts on overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a);
89 
90         return c;
91     }
92 
93     /**
94      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
95      * reverts when dividing by zero.
96      */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0);
99         return a % b;
100     }
101 }
102 
103 contract CCOHCrowdsale is ReentrancyGuard {
104 
105     using SafeMath for uint256;
106     using SafeMath for uint;
107 
108     address payable public beneficiary; // wallet to send eth to
109     uint public fundingGoal; // maximum amount to raise
110     uint public amountRaised; // current amount raised
111     uint public minAmountWei; // min amount for crowdsale
112     uint public deadline; // time when crowdsale to close
113     uint public price; // price for token
114     token public tokenReward; // token
115     mapping(address => uint256) public balanceOf;
116     bool fundingGoalReached = false;
117     bool crowdsaleClosed = false;
118 
119     event GoalReached(address recipient, uint totalAmountRaised);
120     event FundTransfer(address backer, uint amount, bool isContribution);
121 
122     /**
123      * Constructor
124      *
125      * Setup the owner
126      */
127     constructor(
128         address payable ifSuccessfulSendTo,
129         uint fundingGoalInEthers,
130         uint durationInMinutes,
131         uint finneyCostOfEachToken,
132         address addressOfTokenUsedAsReward,
133         uint minAmountFinney
134     ) public {
135         beneficiary = ifSuccessfulSendTo;
136         fundingGoal = fundingGoalInEthers * 1 ether;
137         deadline = now + durationInMinutes * 1 minutes;
138         price = finneyCostOfEachToken * 1 finney;
139         minAmountWei = minAmountFinney * 1 finney;
140         tokenReward = token(addressOfTokenUsedAsReward);
141     }
142 
143     /**
144      * Fallback function
145      *
146      * The function without name is the default function that is called whenever anyone sends funds to a contract
147      */
148     function() payable external {
149         buyTokens(msg.sender);
150     }
151 
152     function buyTokens(address sender) public nonReentrant payable {
153         checkGoalReached();
154         require(!crowdsaleClosed);
155         require(sender != address(0));
156         uint amount = msg.value;
157         require(amount != 0);
158         require(amount >= minAmountWei);
159 
160         uint senderBalance = balanceOf[sender];
161         balanceOf[sender] = senderBalance.add(amount);
162         amountRaised = amountRaised.add(amount);
163         uint tokenToSend = amount.div(price) * 1 ether;
164         tokenReward.transfer(sender, tokenToSend);
165         emit FundTransfer(sender, amount, true);
166 
167         if (beneficiary.send(amount)) {
168             emit FundTransfer(beneficiary, amount, false);
169         }
170 
171         checkGoalReached();
172     }
173 
174     modifier afterDeadline() {if (now >= deadline) _;}
175 
176     /**
177      * Check if goal was reached
178      *
179      * Checks if the goal or time limit has been reached and ends the campaign
180      */
181     function checkGoalReached() public afterDeadline {
182         if (amountRaised >= fundingGoal) {
183             fundingGoalReached = true;
184             crowdsaleClosed = true;
185             emit GoalReached(beneficiary, amountRaised);
186         }
187         if (now > deadline) {
188             crowdsaleClosed = true;
189             emit GoalReached(beneficiary, amountRaised);
190         }
191     }
192 }