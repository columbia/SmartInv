1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public payoutAddr;
9 
10     uint public deadline;
11     uint public amountRaised;
12     uint public price = 300;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool crowdsaleClosed = false;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function Crowdsale (
20         address ifSuccessfulSendTo,
21         address addressOfTokenUsedAsReward,
22         uint durationInMinutes
23     ) public {
24         payoutAddr = ifSuccessfulSendTo;
25         tokenReward = token(addressOfTokenUsedAsReward);
26         deadline = now + durationInMinutes * 1 minutes;
27     }
28     
29     function () public payable {
30         require(!crowdsaleClosed);
31         balanceOf[msg.sender] += msg.value;
32         amountRaised += msg.value;
33         tokenReward.transfer(msg.sender, msg.value * price);
34         FundTransfer(msg.sender, msg.value, true);
35     }
36 
37     modifier afterDeadline() { if (now >= deadline) _; }
38 
39     function closeSale() public afterDeadline {
40         crowdsaleClosed = true;
41     }
42 
43     function safeWithdrawal() public afterDeadline {
44          if (payoutAddr == msg.sender) {
45             if (payoutAddr.send(amountRaised)) {
46                 FundTransfer(payoutAddr, amountRaised, false);
47             } 
48         }
49     }
50 }