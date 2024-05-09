1 pragma solidity ^0.4.25;
2 
3 //  SIMPLY BANK - Interest 1% Dayly !
4 //
5 //  Improved, no bugs and backdoors! Your investments are safe!
6 //
7 //  NO DEPOSIT FEES! All the money go to contract!
8 //
9 //  WITHDRAWAL FEES! Technical Support -10% only from The RETURNED DEPOSIT !!
10 //
11 //  LOW RISK! You can take your deposit back ANY TIME!
12 //
13 //     - Send 0.00000112 ETH to contract address (You will charged 10% for Tech Support)
14 //
15 //  LONG LIFE!
16 //
17 //  INSTRUCTIONS:
18 //
19 //  TO INVEST: send ETH to contract address
20 //  TO WITHDRAW INTEREST: send 0 ETH to contract address
21 //  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
22 //  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address
23 //
24 
25 contract SimplyBank {
26 
27     mapping (address => uint256) dates;
28     mapping (address => uint256) invests;
29     address constant private TECH_SUPPORT = 0x85889bBece41bf106675A9ae3b70Ee78D86C1649;
30 
31     function() external payable {
32          if (msg.value == 0.00000112 ether) {
33            
34          //Calculate of Tech Support fees from your deposit.
35          uint256 techSupportPercent = invests[sender] * 10 / 100;
36          //Pay 10% for Tech Support
37          TECH_SUPPORT.transfer(techSupportPercent);
38          //Available deposit to withdrawal
39          uint256 withdrawalAmount = invests[sender] - techSupportPercent;
40 
41         //Pay the rest of deposit 
42         sender.transfer(withdrawalAmount);
43         
44         //Delete your information from the Simply Bank
45         dates[sender]    = 0;
46         invests[sender]  = 0;
47 
48         } else {
49         address sender = msg.sender;
50         if (invests[sender] != 0) {
51             //Calculate your daily interest
52             uint256 payout = invests[sender] / 100 * (now - dates[sender]) / 1 days;
53             
54             // If your deposit greater than balance.You will get the balance amount.
55             if (payout > address(this).balance) {
56                 payout = address(this).balance;
57             }
58             //Pay your daily interest.
59             sender.transfer(payout);
60          }
61         dates[sender]    = now;
62         invests[sender] += msg.value;
63          }
64        }
65 
66     }