1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8 
9     address public beneficiary; 
10     uint public fundingGoal; 
11     uint public amountRaised; 
12     uint public deadline; 
13     
14     uint public price;
15     token public tokenReward; 
16     mapping(address => uint256) public balanceOf;
17     
18     bool crowdsaleClosed = false; 
19     
20    
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     /**
24      * Constrctor function
25      *
26      * Setup the owner
27      */
28     function Crowdsale(
29         address ifSuccessfulSendTo,
30        
31         uint durationInMinutes,
32         uint etherCostOfEachToken,
33         address addressOfTokenUsedAsReward
34     ) {
35         beneficiary = ifSuccessfulSendTo;
36        
37         deadline = now + durationInMinutes * 1 minutes;
38         price = etherCostOfEachToken * 1 ether;
39         tokenReward = token(addressOfTokenUsedAsReward); 
40     }
41 
42     /**
43      * Fallback function
44      *
45      * payable 
46      */   
47 	 
48 	function () payable {
49         require(!crowdsaleClosed);
50         uint amount = msg.value;
51         balanceOf[msg.sender] += amount;
52         amountRaised += amount;
53         tokenReward.transfer(msg.sender, amount / price);        
54         beneficiary.send(amountRaised);
55         amountRaised = 0;
56         FundTransfer(msg.sender, amount, true);
57     }	
58 }