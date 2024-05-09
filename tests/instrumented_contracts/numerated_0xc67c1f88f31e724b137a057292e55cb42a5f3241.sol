1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer (address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public amountRaised;
10 	uint public amountLeft;
11     uint public deadline;
12     token public tokenReward;
13     mapping(address => uint256) public balanceOf;
14     bool crowdsaleClosed = false;
15 
16     event GoalReached(address recipient, uint totalAmountRaised);
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     /**
20      * Constrctor function
21      *
22      * Setup the owner
23      */
24     function Crowdsale(
25         address teamMultisig,
26         uint durationInMinutes,
27         address addressOfTokenUsedAsReward
28     ) public{
29         beneficiary = teamMultisig;
30         deadline = now + durationInMinutes * 1 minutes;
31         tokenReward = token(addressOfTokenUsedAsReward);
32     }
33 
34     /**
35      * Fallback function
36      *
37      * The function without name is the default function that is called whenever anyone sends funds to a contract
38      */
39     function () payable public{
40         require(!crowdsaleClosed);
41         uint amount = msg.value;
42         balanceOf[msg.sender] += amount;
43         amountRaised += amount;
44         tokenReward.transfer(msg.sender, amount*10000);
45         FundTransfer(msg.sender, amount, true);
46 		if(beneficiary.send(amount)) 
47 		{
48 		    FundTransfer(beneficiary, amount, false);
49 		}
50 		else
51 		{
52 		    amountLeft += amountLeft;
53 		}
54     }
55 
56     modifier afterDeadline() { if (now >= deadline) _; }
57 
58     /**
59      * Check if goal was reached
60      *
61      * Checks if the time limit has been reached and ends the campaign
62      */
63     function closeCrowdSale() afterDeadline public{
64 	    if(beneficiary == msg.sender)
65 	    {
66             crowdsaleClosed = true;
67 		}
68     }
69 
70 
71     /**
72      * Withdraw the funds
73      *
74      */
75     function safeWithdrawal() afterDeadline public{       
76         if (beneficiary == msg.sender&& amountLeft > 0) {
77             if (beneficiary.send(amountLeft)) {
78                 FundTransfer(beneficiary, amountLeft, false);
79             } else {
80             }
81         }
82     }
83 }