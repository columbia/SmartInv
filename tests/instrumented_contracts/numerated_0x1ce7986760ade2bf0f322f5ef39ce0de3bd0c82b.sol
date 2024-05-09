1 pragma solidity ^0.4.0;
2 
3 /// @title PonzICO
4 /// @author acityinohio
5 contract PonzICO {
6     address public owner;
7     uint public total;
8     mapping (address => uint) public invested;
9     mapping (address => uint) public balances;
10     address[] investors;
11 
12     //log event of successful investment/withdraw and address
13     event LogInvestment(address investor, uint amount);
14     event LogWithdrawal(address investor, uint amount);
15 
16     //modifiers for various things
17     modifier checkZeroBalance() { if (balances[msg.sender] == 0) { throw; } _;}
18     modifier accreditedInvestor() { if (msg.value < 100 finney) { throw; } _;}
19 
20 	//constructor for initializing PonzICO.
21     //the owner is the genius who made this revolutionary smart contract
22 	function PonzICO() {
23 		owner = msg.sender;
24 	}
25 
26     //the logic for a small fee for the creator of this contract
27     //miniscule in the grand scheme of things
28     function ownerFee(uint amount) private returns (uint fee) {
29         if (total < 200000 ether) {
30             fee = amount/2;
31             balances[owner] += fee;
32         }
33         return;
34     }
35 
36     //This is where the magic is withdrawn.
37     //For users with balances. Can only be used to withdraw full balance.
38     function withdraw()
39     checkZeroBalance()
40     {
41         uint amount = balances[msg.sender];
42         balances[msg.sender] = 0;
43         if (!msg.sender.send(amount)) {
44             balances[msg.sender] = amount;
45         } else {
46             LogWithdrawal(msg.sender, amount);
47         }
48     }
49 
50     //What's better than withdrawing? Re-investing profits!
51     function reinvest()
52     checkZeroBalance()
53     {
54         uint dividend = balances[msg.sender];
55         balances[msg.sender] = 0;
56         uint fee = ownerFee(dividend);
57         dividend -= fee;
58         for (uint i = 0; i < investors.length; i++) {
59             balances[investors[i]] += dividend * invested[investors[i]] / total;
60         }
61         invested[msg.sender] += (dividend + fee);
62         total += (dividend + fee);
63         LogInvestment(msg.sender, dividend+fee);
64     }
65 
66 	//This is the where the magic is invested.
67     //Note the accreditedInvestor() modifier, to ensure only sophisticated
68     //investors with 0.1 ETH or more can invest. #SelfRegulation
69 	function invest() payable
70     accreditedInvestor()
71     {
72         //first send the owner's modest 50% fee but only if the total invested is less than 200000 ETH
73         uint dividend = msg.value;
74         uint fee = ownerFee(dividend);
75         dividend -= fee;
76         //then accrue balances from the generous remainder to everyone else previously invested
77         for (uint i = 0; i < investors.length; i++) {
78             balances[investors[i]] += dividend * invested[investors[i]] / total;
79         }
80 
81         //finally, add this enterprising new investor to the public balances
82         if (invested[msg.sender] == 0) {
83             investors.push(msg.sender);
84             invested[msg.sender] = msg.value;
85         } else {
86             invested[msg.sender] += msg.value;
87         }
88         total += msg.value;
89         LogInvestment(msg.sender, msg.value);
90 	}
91 
92     //finally, fallback function. no one should send money to this contract
93     //without first being added as an investment.
94     function () { throw; }
95 }