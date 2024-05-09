1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() external returns (uint256 supply);
49     function balanceOf(address _owner) external returns (uint256 balance);
50 }
51 
52 interface token {
53     function transfer(address receiver, uint amount) external;
54 }
55 
56 contract Crowdsale {
57     address public beneficiary;
58     uint public fundingGoal = 10 ether;
59     uint public amountRaised = 2000 ether;
60     uint public deadline = now ;
61     uint public price = 250 ether;
62     token public tokenReward;
63     mapping(address => uint256) public balanceOf;
64     bool fundingGoalReached = false;
65     bool crowdsaleClosed = false;
66 
67     event GoalReached(address recipient, uint totalAmountRaised);
68     event FundTransfer(address backer, uint amount, bool isContribution);
69 
70     /**
71      * Constructor
72      *
73      * Setup the owner
74      */
75     constructor(
76         address ifSuccessfulSendTo,
77         uint fundingGoalInEthers,
78         uint durationInMinutes,
79         uint etherCostOfEachToken,
80         address addressOfTokenUsedAsReward
81     ) public {
82         beneficiary = ifSuccessfulSendTo= 0x11C848b7Ee546313505a15f286E858d653C4a8Ca;
83         fundingGoal = fundingGoalInEthers * 10 ether;
84         deadline = now + durationInMinutes * 43200 minutes;
85         price = etherCostOfEachToken * 0.00009 ether;
86         tokenReward = token(addressOfTokenUsedAsReward);
87     }
88 
89     /**
90      * Fallback function
91      *
92      * The function without name is the default function that is called whenever anyone sends funds to a contract
93      */
94     function () payable external {
95         require(!crowdsaleClosed);
96         uint amount = msg.value;
97         balanceOf[msg.sender] += amount;
98         amountRaised += amount;
99         tokenReward.transfer(msg.sender, amount / price);
100        emit FundTransfer(msg.sender, amount, true);
101     }
102 
103     modifier afterDeadline() { if (now >= deadline) _; }
104 
105     /**
106      * Check if goal was reached
107      *
108      * Checks if the goal or time limit has been reached and ends the campaign
109      */
110     function checkGoalReached() public afterDeadline {
111         if (amountRaised >= fundingGoal){
112             fundingGoalReached = true;
113             emit GoalReached(beneficiary, amountRaised);
114         }
115         crowdsaleClosed = true;
116    
117  }
118 
119 
120     /**
121      * Withdraw the funds
122      *
123      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
124      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
125      * the amount they contributed.
126      */
127     function safeWithdrawal() public afterDeadline {
128         if (!fundingGoalReached) {
129             uint amount = balanceOf[msg.sender];
130             balanceOf[msg.sender] = 0;
131             if (amount > 0) {
132                 if (msg.sender.send(amount)) {
133                    emit FundTransfer(msg.sender, amount, false);
134                 } else {
135                     balanceOf[msg.sender] = amount;
136                 }
137             }
138         }
139 
140         if (fundingGoalReached && beneficiary == msg.sender) {
141             if (msg.sender.send(amountRaised)) {
142                emit FundTransfer(beneficiary, amountRaised, false);
143             } else {
144                 //If we fail to send the funds to beneficiary, unlock funders balance
145                 fundingGoalReached = false;
146             }
147         }
148     }
149 }