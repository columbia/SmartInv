1 pragma solidity ^0.4.11;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 //cuenta 0x135870d76926f7e3c4cc00aeb00b1ef430bca597
8 //token adress 0x0d7481038C3fe43163b8fd659E0bB79f17418E31
9 //finney cost = 3.3
10 
11 
12 contract Crowdsale {
13     address public beneficiary;
14     uint public fundingGoal;
15     uint public amountRaised;
16     uint public deadline;
17     uint public price;
18     token public tokenReward;
19     mapping(address => uint256) public balanceOf;
20     bool fundingGoalReached = false;
21     bool crowdsaleClosed = false;
22     bool changePrice = false;
23 
24     event GoalReached(address recipient, uint totalAmountRaised);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26     event ChangePrice(uint prices);
27     /**
28      * Constrctor function
29      *
30      * Setup the owner
31      */
32     function Crowdsale(
33         address ifSuccessfulSendTo,
34         uint fundingGoalInEthers,
35         uint durationInMinutes,
36         uint etherCostOfEachToken,
37         address addressOfTokenUsedAsReward
38     )public {
39         beneficiary = ifSuccessfulSendTo;
40         fundingGoal = fundingGoalInEthers * 1 finney;
41         deadline = now + durationInMinutes * 1 minutes;
42         price = etherCostOfEachToken * 1 finney;
43         tokenReward = token(addressOfTokenUsedAsReward);
44     }
45 
46     /**
47      * Fallback function
48      *
49      * The function without name is the default function that is called whenever anyone sends funds to a contract
50      */
51     function () public payable {
52         require(!crowdsaleClosed);
53         uint amount = msg.value;
54         balanceOf[msg.sender] += amount;
55         amountRaised += amount;
56         tokenReward.transfer(msg.sender, amount / price);
57         FundTransfer(msg.sender, amount, true);
58     }
59 
60     modifier afterDeadline() { if (now >= deadline) _; }
61 
62     /**
63      * Check if goal was reached
64      *
65      * Checks if the goal or time limit has been reached and ends the campaign
66      */
67     function checkGoalReached() public afterDeadline {
68         if (amountRaised >= fundingGoal){
69             fundingGoalReached = true;
70             GoalReached(beneficiary, amountRaised);
71         }
72         crowdsaleClosed = true;
73     }
74 
75     //transfer token to the owner of the contract (beneficiary)//afterDeadline
76         function transferToken(uint amount)public afterDeadline {  
77         if (beneficiary == msg.sender)
78         {            
79             tokenReward.transfer(msg.sender, amount);  
80             FundTransfer(msg.sender, amount, true);          
81         }
82        
83     }
84 
85 
86     /**
87      * Withdraw the funds
88      *
89      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
90      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
91      * the amount they contributed.
92      */
93     function safeWithdrawal()public afterDeadline {
94         if (!fundingGoalReached) {
95             uint amount = balanceOf[msg.sender];
96             balanceOf[msg.sender] = 0;
97             if (amount > 0) {
98                 if (msg.sender.send(amount)) {
99                     FundTransfer(msg.sender, amount, false);
100                 } else {
101                     balanceOf[msg.sender] = amount;
102                 }
103             }
104         }
105 
106         if (fundingGoalReached && beneficiary == msg.sender) {
107             if (beneficiary.send(amountRaised)) {
108                 FundTransfer(beneficiary, amountRaised, false);
109             } else {
110                 //If we fail to send the funds to beneficiary, unlock funders balance
111                 fundingGoalReached = false;
112             }
113         }
114     }
115     function checkPriceCrowdsale(uint newPrice1, uint newPrice2)public {
116         if (beneficiary == msg.sender) {          
117            price = (newPrice1 * 1 finney)+(newPrice2 * 1 szabo);
118            ChangePrice(price);
119            changePrice = true;
120         }
121 
122     }
123 }