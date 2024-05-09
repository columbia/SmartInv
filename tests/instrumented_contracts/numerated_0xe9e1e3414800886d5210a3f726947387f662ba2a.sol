1 pragma solidity ^0.4.2;
2 contract token { function transfer(address receiver, uint amount); }
3 
4 contract Crowdsale {
5     address public beneficiary;
6     uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
7     token public tokenReward;
8     mapping(address => uint256) public balanceOf;
9     bool fundingGoalReached = false;
10     event GoalReached(address beneficiary, uint amountRaised);
11     event FundTransfer(address backer, uint amount, bool isContribution);
12     bool crowdsaleClosed = false;
13 
14     /* data structure to hold information about campaign contributors */
15 
16     /*  at initialization, setup the owner */
17     function Crowdsale(
18         address ifSuccessfulSendTo,
19         uint fundingGoalInEthers,
20         uint durationInMinutes,
21         uint etherCostOfEachToken,
22         token addressOfTokenUsedAsReward
23     ) {
24         beneficiary = ifSuccessfulSendTo;
25         fundingGoal = fundingGoalInEthers * 1 wei;
26         deadline = now + durationInMinutes * 1 minutes;
27         price = etherCostOfEachToken * 1 wei;
28         tokenReward = token(addressOfTokenUsedAsReward);
29     }
30 
31     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
32     function () payable {
33         if (crowdsaleClosed) throw;
34         uint amount = msg.value;
35         balanceOf[msg.sender] += amount;
36         amountRaised += amount;
37         tokenReward.transfer(msg.sender, amount / price);
38         FundTransfer(msg.sender, amount, true);
39         forwardFunds();
40     }
41 
42     modifier afterDeadline() { if (now >= deadline) _; }
43 
44     /* checks if the goal or time limit has been reached and ends the campaign */
45     function checkGoalReached() afterDeadline {
46         if (amountRaised >= fundingGoal){
47             fundingGoalReached = true;
48             GoalReached(beneficiary, amountRaised);
49         }
50     }
51 
52     function forwardFunds() internal {
53         beneficiary.transfer(msg.value);
54     }
55 
56     function safeWithdrawal() afterDeadline {
57 
58         forwardFunds();
59         
60     }
61 }