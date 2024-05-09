1 pragma solidity ^0.4.19;
2 
3 contract token {
4     function transfer(address receiver, uint256 amount);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   
33 }
34 
35 contract GasCrowdsale {
36     using SafeMath for uint256;
37     
38     address public beneficiary;
39     uint256 public fundingGoal;
40     uint256 public amountRaised;
41     uint256 public startdate;
42     uint256 public deadline;
43     uint256 public price;
44     uint256 public fundTransferred;
45     token public tokenReward;
46     mapping(address => uint256) public balanceOf;
47     bool fundingGoalReached = false;
48     bool crowdsaleClosed = false;
49 
50     //event GoalReached(address recipient, uint256 totalAmountRaised);
51     //event FundTransfer(address backer, uint256 amount, bool isContribution);
52 
53     /**
54      * Constrctor function
55      *
56      * Setup the owner
57      */
58     function GasCrowdsale() {
59         beneficiary = 0x007FB3e94dCd7C441CAA5b87621F275d199Dff81;
60         fundingGoal = 8000 ether;
61         startdate = now;
62         deadline = 1520640000;
63         price = 0.0003 ether;
64         tokenReward = token(0x75c79b88facE8892E7043797570c390bc2Db52A7);
65     }
66 
67     /**
68      * Fallback function
69      *
70      * The function without name is the default function that is called whenever anyone sends funds to a contract
71      */
72     function () payable {
73         require(!crowdsaleClosed);
74         uint256 bonus;
75         uint256 amount = msg.value;
76         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
77         amountRaised = amountRaised.add(amount);
78         
79         //add bounus for funders
80         amount =  amount.div(price);
81         bonus = amount.mul(35).div(100);
82         amount = amount.add(bonus);
83         
84         amount = amount.mul(100000000);
85         tokenReward.transfer(msg.sender, amount);
86         //FundTransfer(msg.sender, amount, true);
87     }
88 
89     modifier afterDeadline() { if (now >= deadline) _; }
90 
91     /**
92      *ends the campaign after deadline
93      */
94      
95     function endCrowdsale() afterDeadline {
96         crowdsaleClosed = true;
97     }
98     
99     function getTokensBack() {
100         uint256 remaining = tokenReward.balanceOf(this);
101         if(msg.sender == beneficiary){
102            tokenReward.transfer(beneficiary, remaining); 
103         }
104     }
105 
106     /**
107      * Withdraw the funds
108      */
109     function safeWithdrawal() {
110         if (beneficiary == msg.sender) {
111             if(fundTransferred != amountRaised){
112                uint256 transferfund;
113                transferfund = amountRaised.sub(fundTransferred);
114                fundTransferred = fundTransferred.add(transferfund);
115                beneficiary.send(transferfund);
116             } 
117         }
118     }
119 }