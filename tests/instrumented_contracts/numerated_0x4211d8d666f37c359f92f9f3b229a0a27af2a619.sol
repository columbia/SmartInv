1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     
6 }
7 
8 contract Crowdsale {
9     address public beneficiary;
10     uint public fundingGoal;
11     uint public amountRaised;
12     uint public deadline;
13     uint256 public price;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     bool fundingGoalReached = false;
17     bool crowdsaleClosed = false;
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     /**
23      * Constructor
24      *
25      * Setup the owner
26      */
27     constructor(
28         address ifSuccessfulSendTo,
29         uint fundingGoalInEthers,
30         uint etherCostOfEachToken,
31         address addressOfTokenUsedAsReward
32     ) public {
33         beneficiary = ifSuccessfulSendTo;
34         fundingGoal = fundingGoalInEthers / 1000000000000 * 1 ether;
35         price = 1 ether / etherCostOfEachToken;
36         tokenReward = token(addressOfTokenUsedAsReward);
37     }
38 
39     /**
40      * Fallback function
41      *
42      * The function without name is the default function that is called whenever anyone sends funds to a contract
43      */
44     function () payable external {
45         require(!crowdsaleClosed);
46         uint amount = msg.value;
47         require(amount >= 1 ether);
48         
49         if (amountRaised <= fundingGoal){
50         
51                 uint tmpAmount = amountRaised + amount;
52             
53                 if (tmpAmount > fundingGoal) {
54                     amount = fundingGoal - amountRaised;
55                 }
56                 
57                 balanceOf[msg.sender] += amount;
58                 amountRaised += amount;
59                 tokenReward.transfer(msg.sender, amount / price);
60                 emit FundTransfer(msg.sender, amount, true);
61             }
62             
63         
64         if (amountRaised == fundingGoal) {
65             checkGoalReached();
66         }
67     
68         
69         
70         
71     }
72 
73     /**
74      * Check if goal was reached
75      *
76      * Checks if the goal or time limit has been reached and ends the campaign
77      */
78     function checkGoalReached() private {
79         if (amountRaised >= fundingGoal){
80             fundingGoalReached = true;
81             emit GoalReached(beneficiary, amountRaised);
82         }
83         crowdsaleClosed = true;
84         
85        
86     }
87 
88 
89     /**
90      * Withdraw the funds
91      *
92      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
93      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
94      * the amount they contributed.
95      */
96     function safeWithdrawal() public {
97         if (beneficiary == msg.sender) {
98             if (msg.sender.send(amountRaised)) {
99                emit FundTransfer(beneficiary, amountRaised, false);
100                crowdsaleClosed = true;
101                
102                if (amountRaised <= fundingGoal) {
103                     uint amount = fundingGoal - amountRaised; 
104                     tokenReward.transfer(beneficiary, amount / price);
105                }
106             }
107             
108             // if (amountRaised <= fundingGoal) {
109             //     uint amount = fundingGoal - amountRaised; 
110             //     tokenReward.transfer(beneficiary, (amount * 100000000) / price);
111             // }
112             
113             // emit FundTransfer(beneficiary, amountRaised, false);
114             // crowdsaleClosed = true;
115            
116             
117         }
118     }
119 }