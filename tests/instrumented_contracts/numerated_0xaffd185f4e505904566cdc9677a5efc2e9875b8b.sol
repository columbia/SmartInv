1 pragma solidity ^0.4.16;
2 
3 /**
4  * CoxxxCoin (CXC) Crowd Sale
5  */
6 
7 interface token {
8     function transfer(address receiver, uint amount);
9 }
10 
11 contract CoxxxCoinCrowdsale {
12     address public beneficiary;
13     uint public amountRaised;
14     uint private currentBalance;
15     uint public price;
16     uint public initialTokenAmount;
17     uint public currentTokenAmount;
18     token public tokenReward;
19     mapping(address => uint256) public balanceOf;
20 
21     /**
22      * Constrctor function
23      *
24      * Setup the owner
25      */
26     function CoxxxCoinCrowdsale(
27         address sendTo,
28         address addressOfTokenUsedAsReward
29     ) {
30         beneficiary = sendTo;
31         /* 0.0001 x 1 ether in wei */
32         price = 100000000000000;
33         initialTokenAmount = 500000000;
34         currentTokenAmount = 500000000;
35         tokenReward = token(addressOfTokenUsedAsReward);
36     }
37 
38     /**
39      * Fallback function
40      *
41      * The function without name is the default function that is called whenever anyone sends funds to a contract
42      */
43     function () payable {
44         uint amount = msg.value;
45         if (amount > 0) {
46             balanceOf[msg.sender] += amount;
47             amountRaised += amount;
48             currentBalance += amount;
49             uint tokenAmount = amount / price;
50             currentTokenAmount -= tokenAmount;
51             tokenReward.transfer(msg.sender, tokenAmount * 1 ether);
52         }
53     }
54 
55     /**
56      * Bank tokens
57      *
58      * Deposit token sale proceeds to CXC Account
59      */
60     function bank() public {
61         if (beneficiary == msg.sender && currentBalance > 0) {
62             uint amountToSend = currentBalance;
63             currentBalance = 0;
64             beneficiary.send(amountToSend);
65         }
66     }
67     
68     /**
69      * Withdraw unusold tokens
70      *
71      * Deposit unsold tokens to CXC Account
72      * 
73      * Oops. Forgot to multiply currentTokenAmount * 1 ether
74      * PTWO not sold in the crowdsale will be trapped in this contract
75      */
76     function returnUnsold() public {
77         if (beneficiary == msg.sender) {
78             tokenReward.transfer(beneficiary, currentTokenAmount * 1 ether);
79         }
80     }
81     
82     /**
83      * Withdraw unusold tokens
84      *
85      * Deposit unsold tokens to CXC Account 100k Safe
86      * 
87      * Oops. Forgot to multiply tokenAmount * 1 ether
88      * PTWO not sold in the crowdsale will be trapped in this contract
89      */
90     function returnUnsoldSafe() public {
91         if (beneficiary == msg.sender) {
92             uint tokenAmount = 100000;
93             tokenReward.transfer(beneficiary, tokenAmount * 1 ether);
94         }
95     }
96 }