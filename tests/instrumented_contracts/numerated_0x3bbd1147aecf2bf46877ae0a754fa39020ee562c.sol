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
37         require(now < start + 59 days);
38         uint amount = msg.value;
39 		
40 		uint price = 200000000000 wei;
41 		
42 		if (now < start + 29 days) {
43 			price = 160000000000 wei;
44 		}
45 		
46         contributionOf[msg.sender] += amount;
47         amountRaised += amount;
48         tokenReward.transfer(msg.sender, amount * 10 ** uint256(18) / price);
49         emit FundTransfer(msg.sender, amount, true);
50     }
51 
52     /**
53      * Withdraw function
54      *
55      * Sends the specified amount to the beneficiary. 
56      */
57     function withdrawal(uint amount) public {
58         if (beneficiary == msg.sender) {
59             if (beneficiary.send(amount)) {
60                emit FundTransfer(beneficiary, amountRaised, false);
61             } 
62         }
63     }
64 }