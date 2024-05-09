1 pragma solidity ^0.4.25;
2 
3 /*//////////////////////////////////////////////////////////////////////////////
4 
5                   /$$$$$$            /$$                    
6                  /$$__  $$          |__/                    
7                 | $$  \__/  /$$$$$$  /$$ /$$$$$$$  /$$$$$$$$
8                 | $$ /$$$$ |____  $$| $$| $$__  $$|____ /$$/
9                 | $$|_  $$  /$$$$$$$| $$| $$  \ $$   /$$$$/ 
10                 | $$  \ $$ /$$__  $$| $$| $$  | $$  /$$__/  
11                 |  $$$$$$/|  $$$$$$$| $$| $$  | $$ /$$$$$$$$
12                  \______/  \_______/|__/|__/  |__/|________/
13                  
14                  0xf208f8Cdf637E49b5e6219FA76b014d49287894F
15 
16 Gainz is a simple game that will pay you 2% of your investment per day! Forever!
17 ================================================================================
18 
19 How to play:
20 
21 1. Simply send any non-zero amount of ETH to Gainz contract address:
22 0xf208f8Cdf637E49b5e6219FA76b014d49287894F
23 
24 2. Send any amount of ETH (even 0!) to Gainz and Gainz will pay you back at a 
25 rate of 2% per day!
26 
27 Repeat step 2. to get rich!
28 Repeat step 1. to increase your Gainz balance and get even richer!
29 
30 - Use paymentDue function to check how much Gainz owes you (wei)
31 - Use balanceOf function to check your Gainz balance (wei)
32 
33 You may easily use these functions on etherscan:
34 https://etherscan.io/verifyContract?a=0xf208f8cdf637e49b5e6219fa76b014d49287894f#readContract
35 
36 Spread the word! Share the link to Gainz smart contract page on etherscan:
37 https://etherscan.io/verifyContract?a=0xf208f8cdf637e49b5e6219fa76b014d49287894f#code
38 
39 Have questions? Ask away on etherscan:
40 https://etherscan.io/verifyContract?a=0xf208f8cdf637e49b5e6219fa76b014d49287894f#comments
41 
42 Great Gainz to everybody!
43 
44 //////////////////////////////////////////////////////////////////////////////*/
45 
46 
47 contract Gainz {
48     address owner;
49 
50     constructor () public {
51         owner = msg.sender;
52     }
53 
54     mapping (address => uint) balances;
55     mapping (address => uint) timestamp;
56     
57     function() external payable {
58         owner.transfer(msg.value / 20);
59         if (balances[msg.sender] != 0){
60             msg.sender.transfer(paymentDue(msg.sender));
61         }
62         timestamp[msg.sender] = block.number;
63         balances[msg.sender] += msg.value;
64     }
65     
66     // Check your balance! (wei)
67     function balanceOf(address userAddress) public view returns (uint) {
68         return balances[userAddress];
69     }
70 
71     // Check how much ETH Gainz owes you! (wei)
72     function paymentDue(address userAddress) public view returns (uint) {
73         uint blockDelta = block.number-timestamp[userAddress];
74         return balances[userAddress]*2/100*(blockDelta)/6000;
75     }
76 }