1 pragma solidity ^0.4.25;
2 //Highly profitable fork of EasyInvest
3 //GAIN 8% per day until you return your deposit and 4% per day after that
4 //5% for advertising
5 contract EasyInvestPRO {
6    
7     mapping (address => uint256) public balance; //balances of investors
8     mapping (address => uint256) public overallPayment; //overall payments for each investor
9     mapping (address => uint256) public timestamp; //last investment time
10     mapping (address => uint16) public rate; //interest rate for each investor
11     address ads = 0x0c58F9349bb915e8E3303A2149a58b38085B4822; //advertising address
12     
13     
14     function() external payable {
15         
16         ads.transfer(msg.value/20); //Send 5% for advertising
17         //if investor already returned his deposit then his rate become 4%
18         if(balance[msg.sender]>=overallPayment[msg.sender])
19             rate[msg.sender]=80;
20         else
21             rate[msg.sender]=40;
22         //payments    
23         if (balance[msg.sender] != 0){
24             uint256 paymentAmount = balance[msg.sender]*rate[msg.sender]/1000*(now-timestamp[msg.sender])/86400;
25             // if investor receive more than 200 percent his balance become zero
26             if (paymentAmount+overallPayment[msg.sender]>= 2*balance[msg.sender])
27                 balance[msg.sender]=0;
28             // if profit amount is not enough on contract balance, will be sent what is left
29             if (paymentAmount > address(this).balance) {
30                 paymentAmount = address(this).balance;
31             }    
32             msg.sender.transfer(paymentAmount);
33             overallPayment[msg.sender]+=paymentAmount;
34         }
35         timestamp[msg.sender] = now;
36         balance[msg.sender] += msg.value;
37         
38     }
39 }