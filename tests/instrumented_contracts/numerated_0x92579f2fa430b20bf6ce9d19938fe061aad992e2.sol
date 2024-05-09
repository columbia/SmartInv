1 pragma solidity ^0.4.11;
2 
3 interface token 
4 {
5     function transfer(address _to, uint256 _value);
6     function transferFrom(address _from, address _to, uint256 _value);
7     function approve(address _spender, uint256 _value);
8     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
9     function getBalanceOf(address _who) returns(uint256 amount);
10 }
11 
12 contract DCY_preICO 
13 {
14     string public name = 'CONTRACT DICEYBIT.COM preICO';
15     address public beneficiary;
16 
17     uint public fundingGoal;
18     uint public amountRaised;
19     uint public deadline;
20     uint public price;
21 
22     token public tokenReward;
23     uint256 public tokensLeft;
24 
25     mapping(address => uint256) public balanceOf;
26 
27     bool public fundingGoalReached = false;
28     bool public crowdsaleClosed = false;
29 
30     event GoalReached(address benef, uint amount);
31     event FundTransfer(address backer, uint amount, bool isContribution);
32 
33     /*  at initialization, setup the owner */
34     function DCY_preICO(
35         address beneficiaryAddress,
36         token addressOfTokenUsedAsReward,
37         uint fundingGoalInEthers,
38         uint durationInMinutes,
39         uint weiPrice
40     ) {
41 
42         beneficiary = beneficiaryAddress;
43         fundingGoal = fundingGoalInEthers * 1 ether;
44         deadline = now + durationInMinutes * 1 minutes;
45         price = weiPrice;
46 
47         tokenReward = token(addressOfTokenUsedAsReward);
48     }
49 
50     function () payable 
51     {
52         require(!crowdsaleClosed);
53         require(tokensLeft >= amount / price);
54 
55         uint amount = msg.value;
56         balanceOf[msg.sender] += amount;
57         amountRaised += amount;
58 
59         tokenReward.transfer(msg.sender, amount / price);
60         FundTransfer(msg.sender, amount, true);
61 
62         tokensLeft = tokenReward.getBalanceOf(address(this));
63         if (tokensLeft == 0) 
64         {
65             crowdsaleClosed = true;
66         }
67     }
68 
69     function updateTokensAvailable() 
70     {
71         tokensLeft = tokenReward.getBalanceOf(address(this));
72     }
73 
74     modifier afterDeadline() 
75     {
76         if (now >= deadline) _;
77     }
78 
79     /* checks if the goal or time limit has been reached and ends the campaign */
80     function checkGoalReached() afterDeadline 
81     {        
82         if (amountRaised >= fundingGoal) 
83         {
84             fundingGoalReached = true;
85             crowdsaleClosed = true;
86             GoalReached(beneficiary, amountRaised);
87         }
88     }
89 
90     function safeWithdrawal() afterDeadline 
91     {
92         
93         if (!fundingGoalReached) 
94         {
95             uint amount = balanceOf[msg.sender];
96             balanceOf[msg.sender] = 0;
97             if (amount > 0) 
98             {
99                 if (msg.sender.send(amount)) 
100                 {
101                     FundTransfer(msg.sender, amount, false);
102                 } 
103                 else 
104                 {
105                     balanceOf[msg.sender] = amount;
106                 }
107             }
108         }
109 
110         if (fundingGoalReached && beneficiary == msg.sender) 
111         {
112             if (beneficiary.send(amountRaised)) 
113             {
114                 FundTransfer(beneficiary, amountRaised, false);
115             } 
116             else 
117             {
118                 fundingGoalReached = false;
119             }
120         }
121     }
122 
123     function bringBackTokens() afterDeadline 
124     {
125         require(tokensLeft > 0);
126 
127         if (msg.sender == beneficiary) 
128         {
129             tokenReward.transfer(beneficiary, tokensLeft);
130             tokensLeft = tokenReward.getBalanceOf(address(this));
131         }
132     }
133 }