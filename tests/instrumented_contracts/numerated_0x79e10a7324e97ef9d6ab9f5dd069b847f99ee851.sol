1 pragma solidity ^0.4.20;
2 
3 interface Token {
4     function transfer(address _to, uint _value) returns (bool success);
5 }
6 
7 contract Crowdsale {
8 
9     address public beneficiary;
10     uint public softCap;
11     uint public hardCap;
12     uint public amountRaised;
13     uint public deadline;
14     uint public price;
15     Token public tokenReward;
16     mapping(address => uint256) public balanceOf;
17 
18     bool softCapReached = false;
19     bool crowdsaleClosed = false;
20     uint softCapInEther =  500 ether;
21     uint hardCapInEther =  3200 ether;
22     uint priceInEther =  0.0002 ether;
23     uint tokenDecimal =  18;
24     uint duration = 120 days;
25     uint startDate = 1524762900; //unix
26 
27     event GoalReached(address recipient, uint totalAmountRaised);
28     event FundTransfer(address backer, uint amount, bool isContribution);
29 
30   
31     function Crowdsale(
32         address ifSuccessfulSendTo,
33         address addressOfTokenUsedAsReward
34     ) {
35         beneficiary = ifSuccessfulSendTo;
36         softCap = softCapInEther;
37         hardCap = hardCapInEther;
38         deadline = startDate + duration;
39         price = priceInEther;
40         tokenReward = Token(addressOfTokenUsedAsReward);
41     }
42 
43   
44     function () payable {
45 
46         require(!crowdsaleClosed);
47         require(hardCap >= amountRaised);
48 
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, amount * 10 ** uint256(tokenDecimal) / price);
53         FundTransfer(msg.sender, amount, true);
54     }
55 
56     modifier afterDeadline() { if (now >= deadline) _; }
57 
58   
59     function checkGoalReached() afterDeadline {
60         if (amountRaised >= softCap){
61             softCapReached = true;
62             GoalReached(beneficiary, amountRaised);
63         }
64         crowdsaleClosed = true;
65     }
66 
67 
68     
69     function safeWithdrawal() afterDeadline {
70 
71         if (!softCapReached) {
72             uint amount = balanceOf[msg.sender];
73             balanceOf[msg.sender] = 0;
74             if (amount > 0) {
75                 if (msg.sender.send(amount)) {
76                     FundTransfer(msg.sender, amount, false);
77                 } else {
78                     balanceOf[msg.sender] = amount;
79                 }
80             }
81         }
82 
83         if (softCapReached && beneficiary == msg.sender) {
84             if (beneficiary.send(amountRaised)) {
85                 FundTransfer(beneficiary, amountRaised, false);
86             } else {
87                 //If we fail to send the funds to beneficiary, unlock funders balance
88                 softCapReached = false;
89             }
90         }
91     }
92 }