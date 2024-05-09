1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 	function balanceOf(address check) public;
6 }
7 
8 
9 
10 contract Marketplace {
11     address public beneficiary;
12     uint public amountRaised;
13 	uint public totalIncome;
14     uint public price;
15 	 
16     token public tokenReward;
17 	
18     mapping(address => uint256) public balanceOf;
19     bool changePrice = false;
20 
21     event DepositBeneficiary(address recipient, uint totalAmountRaised);
22     event FundTransfer(address backer, uint amount );
23     event ChangePrice(uint prices);
24     /**
25      * Constructor function
26      *
27      * Setup the owner
28      */
29     function Marketplace(
30         address ifSuccessfulSendTo,
31         uint etherCostOfEachToken,
32         address addressOfTokenUsedAsReward
33     )public {
34         beneficiary = ifSuccessfulSendTo;
35         price = etherCostOfEachToken * 1 finney;
36         tokenReward = token(addressOfTokenUsedAsReward);
37     }
38 
39 
40     function () public payable {
41         uint amount = msg.value;
42         balanceOf[msg.sender] += amount;
43         amountRaised += amount;
44 		totalIncome += amount; 
45         tokenReward.transfer(msg.sender, amount / price);
46 		FundTransfer(beneficiary, amount);
47     }
48 
49 
50 
51     
52 
53     //transfer token to the owner of the contract (beneficiary)
54         function transferToken(uint amount)public  {  
55 			if (beneficiary == msg.sender)
56 			{            
57 				tokenReward.transfer(msg.sender, amount);  
58 			}
59        
60 		}
61 		function safeWithdrawal() public {
62 			if (beneficiary == msg.sender) {
63 					if(beneficiary.send(amountRaised)){
64 					FundTransfer(beneficiary, amountRaised);
65 					amountRaised = 0;
66 					}
67 			}
68 		}
69  
70 
71     function checkPriceCrowdsale(uint newPrice1, uint newPrice2)public {
72         if (beneficiary == msg.sender) {          
73            price = (newPrice1 * 1 finney)+(newPrice2 * 1 szabo);
74            ChangePrice(price);
75            changePrice = true;
76         }
77 
78     }
79 }