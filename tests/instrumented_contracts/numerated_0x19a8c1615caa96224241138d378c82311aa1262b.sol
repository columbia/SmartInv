1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract NyronChain_Crowdsale {
8     address public beneficiary;
9     uint public amountRaised;
10     uint public rate;
11     uint public softcap;
12     token public tokenReward;
13     mapping(address => uint256) public balanceOf;
14     bool public crowdsaleClosed = false;
15 
16     event GoalReached(address recipient, uint totalAmountRaised);
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     /**
20      * Constrctor function
21      *
22      * Setup the owner
23      */
24     function NyronChain_Crowdsale() {
25         beneficiary = 0x618a6e3DA0A159937917DC600D49cAd9d0054A70;
26         rate = 1800;
27         softcap = 5560 * 1 ether;
28         tokenReward = token(0xE65a20195d53DD00f915d2bE49e55ffDB46380D7);
29     }
30     
31     /**
32      * Fallback function
33      *
34      * The function without name is the default function that is called whenever anyone sends funds to a contract
35      */
36     function () payable {
37         require(msg.value > 0);
38             uint amount = msg.value;
39             balanceOf[msg.sender] += amount;
40             amountRaised += amount;
41             if(!crowdsaleClosed){ 
42             if(amountRaised >= softcap){
43                 tokenReward.transfer(msg.sender, amount * rate);
44             }else {
45                 tokenReward.transfer(msg.sender, amount * rate + amount * rate * 20 / 100);
46             }}
47             FundTransfer(msg.sender, amount, true);
48     }
49      
50      /**
51      * Open the crowdsale
52      * 
53      */
54     function openCrowdsale() {
55         if(beneficiary == msg.sender){
56             crowdsaleClosed = false;
57         }
58     }
59     
60     
61     /**
62      * Close the crowdsale
63      * 
64      */
65     function endCrowdsale() {
66         if(beneficiary == msg.sender){
67             crowdsaleClosed = true;
68         }
69     }
70 
71     /**
72      * Withdraw the funds
73      *
74      * Sends the entire amount to the beneficiary. 
75      */
76     function safeWithdrawal() {
77         if(beneficiary == msg.sender){
78             if (beneficiary.send(amountRaised)) {
79                 FundTransfer(beneficiary, amountRaised, false);
80             }
81         }
82     }
83 }