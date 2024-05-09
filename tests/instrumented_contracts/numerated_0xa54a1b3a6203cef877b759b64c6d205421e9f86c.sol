1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transfer(address receiver, uint256 amount);
5 }
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   
32 }
33 
34 contract GasCrowdsale {
35     using SafeMath for uint256;
36     
37     address public beneficiary;
38     uint256 public fundingGoal;
39     uint256 public amountRaised;
40     uint256 public startdate;
41     uint256 public deadline;
42     uint256 public price;
43     uint256 public fundTransferred;
44     token public tokenReward;
45     mapping(address => uint256) public balanceOf;
46     bool fundingGoalReached = false;
47     bool crowdsaleClosed = false;
48 
49     //event GoalReached(address recipient, uint256 totalAmountRaised);
50     //event FundTransfer(address backer, uint256 amount, bool isContribution);
51 
52     /**
53      * Constrctor function
54      *
55      * Setup the owner
56      */
57     function GasCrowdsale() {
58         beneficiary = 0x007FB3e94dCd7C441CAA5b87621F275d199Dff81;
59         fundingGoal = 8000 ether;
60         startdate = 1518134400;
61         deadline = startdate + 29 days;
62         price = 0.0003 ether;
63         tokenReward = token(0x75c79b88facE8892E7043797570c390bc2Db52A7);
64     }
65 
66     /**
67      * Fallback function
68      *
69      * The function without name is the default function that is called whenever anyone sends funds to a contract
70      */
71     function () payable {
72         require(!crowdsaleClosed);
73         uint256 bonus;
74         uint256 amount = msg.value;
75         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
76         amountRaised = amountRaised.add(amount);
77         
78         //add bounus for funders
79         if(now >= startdate && now <= startdate + 24 hours ){
80             amount =  amount.div(price);
81             bonus = amount.mul(30).div(100);
82             amount = amount.add(bonus);
83         }
84         else if(now > startdate + 24 hours && now <= startdate + 24 hours + 1 weeks ){
85             amount =  amount.div(price);
86             bonus = amount.mul(20).div(100);
87             amount = amount.add(bonus);
88         }
89         else if(now > startdate + 24 hours + 1 weeks && now <= startdate + 24 hours + 3 weeks ){
90             amount =  amount.div(price);
91             bonus = amount.mul(10).div(100);
92             amount = amount.add(bonus);
93         } else {
94             amount =  amount.div(price);
95         }
96         
97         amount = amount.mul(100000000);
98         tokenReward.transfer(msg.sender, amount);
99         //FundTransfer(msg.sender, amount, true);
100     }
101 
102     modifier afterDeadline() { if (now >= deadline) _; }
103 
104     /**
105      *ends the campaign after deadline
106      */
107      
108     function endCrowdsale() afterDeadline {
109         crowdsaleClosed = true;
110     }
111 
112 
113     /**
114      * Withdraw the funds
115      */
116     function safeWithdrawal() {
117         if (beneficiary == msg.sender) {
118             if(fundTransferred != amountRaised){
119                uint256 transferfund;
120                transferfund = amountRaised.sub(fundTransferred);
121                fundTransferred = fundTransferred.add(transferfund);
122                beneficiary.send(transferfund);
123             } 
124         }
125     }
126 }