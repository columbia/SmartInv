1 pragma solidity ^0.4.8;
2 contract token { function transfer(address receiver, uint amount) returns (bool) {  } }
3 
4 contract LuxPresale {
5     address public beneficiary;
6     uint public totalLuxCents; uint public amountRaised; uint public deadline; uint public price; uint public presaleStartDate;
7     token public tokenReward;
8     mapping(address => uint) public balanceOf;
9     event GoalReached(address beneficiary, uint amountRaised);
10     event FundTransfer(address backer, uint amount, bool isContribution);
11     bool crowdsaleClosed = false;
12 
13     function LuxPresale(
14         address ifSuccessfulSendTo,
15         uint totalLux,
16         uint startDate,
17         uint durationInMinutes,
18         token addressOfTokenUsedAsReward
19     ) {
20         beneficiary = ifSuccessfulSendTo;
21         totalLuxCents = totalLux * 100;
22         presaleStartDate = startDate;
23         deadline = startDate + durationInMinutes * 1 minutes;
24         tokenReward = token(addressOfTokenUsedAsReward);
25     }
26     
27     function () payable {
28         if (now < presaleStartDate) throw;
29 
30         if (crowdsaleClosed) {
31 			if (msg.value > 0) throw;
32             uint reward = balanceOf[msg.sender];
33             balanceOf[msg.sender] = 0;
34             if (reward > 0) {
35                 if (!tokenReward.transfer(msg.sender, reward/price)) {
36                     balanceOf[msg.sender] = reward;
37                 }
38             }        
39         } else { 
40             uint amount = msg.value;
41             balanceOf[msg.sender] += amount;
42             amountRaised += amount;
43         }
44     }
45     
46     modifier afterDeadline() { if (now >= deadline) _; }
47     
48     modifier onlyOwner() {
49         if (msg.sender != beneficiary) {
50             throw;
51         }
52         _;
53     }
54 
55     function setGoalReached() afterDeadline {
56         if (amountRaised == 0) throw;
57         if (crowdsaleClosed) throw;
58         crowdsaleClosed = true;
59         price = amountRaised/totalLuxCents;
60     }
61 
62     function safeWithdrawal() afterDeadline onlyOwner {
63         if (!crowdsaleClosed) throw;
64         if (beneficiary.send(amountRaised)) {
65             FundTransfer(beneficiary, amountRaised, false);
66         }
67     }
68 }