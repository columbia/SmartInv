1 pragma solidity ^0.4.18;
2 interface token {
3     function transfer(address receiver, uint amount) public;                                    // Transfer function for transferring tokens
4     function getBalanceOf(address _owner) public constant returns (uint256 balance);            // Getting the balance from the main contract
5 }
6 contract Presale {
7     address public beneficiary;                     // Who is the beneficiary of this contract
8     uint public fundingLimit;                       // The maximum ether allowed in this sale
9     uint public amountRaised;                       // The total amount raised during presale
10     uint public deadline;                           // The deadline for this contract
11     uint public tokensPerEther;                     // Tokens received as a reward of participating in this pre sale
12     uint public minFinnRequired;                    // Minimum Finney needed to participate in this pre sale
13     uint public startTime;                          // StartTime for the presale
14     token public tokenReward;                       // The token contract it refers too
15     
16     mapping(address => uint256) public balanceOf;   // Mapping of all balances in this contract
17     event FundTransfer(address backer, uint amount, bool isContribution);   // Event of fund transfer to show each transaction
18     /**
19      * Constrctor function
20      *
21      * Setup the owner
22      */
23     function Presale(
24         address ifSuccessfulSendTo,
25         uint fundingLimitInEthers,
26         uint durationInMinutes,
27         uint tokensPerEthereum,
28         uint minFinneyRequired,
29         uint presaleStartTime,
30         address addressOfTokenUsedAsReward
31     ) public {
32         beneficiary = ifSuccessfulSendTo;
33         fundingLimit = fundingLimitInEthers * 1 ether;
34         deadline = presaleStartTime + durationInMinutes * 1 minutes;
35         tokensPerEther = tokensPerEthereum;
36         minFinnRequired = minFinneyRequired * 1 finney;
37         startTime = presaleStartTime;
38         tokenReward = token(addressOfTokenUsedAsReward);
39     }
40     /**
41      * Fallback function
42      *
43      * The function without name is the default function that is called whenever anyone sends funds to a contract
44      */
45     function () payable public {
46         require(startTime <= now);
47         require(amountRaised < fundingLimit);
48         require(msg.value >= minFinnRequired);
49         
50         uint amount = msg.value;
51         balanceOf[msg.sender] += amount;
52         amountRaised += amount;
53         tokenReward.transfer(msg.sender, amount * tokensPerEther);
54         FundTransfer(msg.sender, amount, true);
55     }
56     /**
57      * Withdraw the funds
58      *
59      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
60      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
61      * the amount they contributed.
62      */
63     function withdrawFundBeneficiary() public {
64         require(now >= deadline);
65         require(beneficiary == msg.sender);
66         uint remaining = tokenReward.getBalanceOf(this);
67         if(remaining > 0) {
68             tokenReward.transfer(beneficiary, remaining);
69         }
70         if (beneficiary.send(amountRaised)) {
71             FundTransfer(beneficiary, amountRaised, false);
72         } else {
73             revert();
74         }
75     }
76 }