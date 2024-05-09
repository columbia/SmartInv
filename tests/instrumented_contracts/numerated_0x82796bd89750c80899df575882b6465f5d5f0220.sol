1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public start;
10     token public tokenReward;
11     
12     uint public amountRaised;
13     mapping(address => uint256) public contributionOf;
14 
15     event FundTransfer(address backer, uint amount, bool isContribution);
16 
17     /**
18      * Constructor function
19      *
20      * Setup the owner and ERC20 token
21      */
22     function Crowdsale(
23         address sendTo,
24         address addressOfTokenUsedAsReward
25     ) public {
26         beneficiary = sendTo;
27         tokenReward = token(addressOfTokenUsedAsReward);
28         start = now;
29     }
30 
31     /**
32      * Fallback function
33      *
34      * The function without name is the default function that is called whenever anyone sends funds to the contract
35      */
36     function () payable public {
37         require(now < start + 120 days);
38         uint amount = msg.value;
39 		
40 		uint price = 200000000000 wei;
41 		
42 		if (now < start + 90 days) {
43 			price = 190000000000 wei;
44 		}		
45 		if (now < start + 60 days) {
46 			price = 180000000000 wei;
47 		}		
48 		if (now < start + 30 days) {
49 			price = 170000000000 wei;
50 		}
51 		
52         contributionOf[msg.sender] += amount;
53         amountRaised += amount;
54         tokenReward.transfer(msg.sender, amount * 10 ** uint256(18) / price);
55         emit FundTransfer(msg.sender, amount, true);
56     }
57 
58     /**
59      * Withdraw function
60      *
61      * Sends the specified amount to the beneficiary. 
62      */
63     function withdrawal(uint amount) public {
64         if (beneficiary == msg.sender) {
65             if (beneficiary.send(amount)) {
66                emit FundTransfer(beneficiary, amountRaised, false);
67             } 
68         }
69     }
70 }