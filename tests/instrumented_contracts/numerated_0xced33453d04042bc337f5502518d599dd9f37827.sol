1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;  
9     uint public fundingGoal;   
10     uint public amountRaised;   
11     uint public deadline;      
12     uint public price;    
13     token public tokenReward;   
14 
15     mapping(address => uint256) public balanceOf;
16     bool public fundingGoalReached = false;  
17     bool public crowdsaleClosed = false;   
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21     event LogAmount(uint amount);
22 
23     
24     function Crowdsale(
25         address ifSuccessfulSendTo,
26         uint fundingGoalInEthers,
27         uint durationInMinutes,
28         uint weiCostOfEachToken,
29         address addressOfTokenUsedAsReward) {
30             beneficiary = ifSuccessfulSendTo;
31             fundingGoal = fundingGoalInEthers * 1 ether;
32             deadline = now + durationInMinutes * 1 minutes;
33             price = weiCostOfEachToken * 1 wei;
34             tokenReward = token(addressOfTokenUsedAsReward);   
35     }
36 
37     
38     function () payable {
39         require(!crowdsaleClosed);
40         uint amount = msg.value;
41         balanceOf[msg.sender] += amount;
42         amountRaised += amount;
43         LogAmount(amount);
44         tokenReward.transfer(msg.sender, 2000 * (amount / price));
45         FundTransfer(msg.sender, amount, true);
46     }
47 
48     
49     modifier afterDeadline() { if (now >= deadline) _; }
50 
51     function checkGoalReached() afterDeadline {
52         fundingGoalReached = true;
53         GoalReached(beneficiary, amountRaised);
54         crowdsaleClosed = true;
55     }
56 
57 
58     function safeWithdrawal() afterDeadline {
59     
60     if (fundingGoalReached && beneficiary == msg.sender) {
61             if (beneficiary.send(amountRaised)) {
62                 FundTransfer(beneficiary, amountRaised, false);/**/
63             } else {
64                 //If we fail to send the funds to beneficiary, unlock funders balance
65                 fundingGoalReached = false;
66             }
67         }
68     }
69 }