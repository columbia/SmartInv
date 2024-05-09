1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 Bancor Buyer
6 ========================
7 
8 Buys Bancor tokens from the crowdsale on your behalf.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint _value) returns (bool success);
16 }
17 
18 // Interface to Bancor ICO Contract
19 contract CrowdsaleController {
20   function contributeETH() payable returns (uint256 amount);
21 }
22 
23 contract BancorBuyer {
24   // Store the amount of ETH deposited or BNT owned by each account.
25   mapping (address => uint) public balances;
26   // Reward for first to execute the buy.
27   uint public reward;
28   // Track whether the contract has bought the tokens yet.
29   bool public bought_tokens;
30   // Record the time the contract bought the tokens.
31   uint public time_bought;
32 
33   // The Bancor Token Sale address.
34   address sale = 0xBbc79794599b19274850492394004087cBf89710;
35   // Bancor Smart Token Contract address.
36   address token = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
37   // The developer address.
38   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
39   
40   // Withdraws all ETH deposited by the sender.
41   // Called to cancel a user's participation in the sale.
42   function withdraw(){
43     // Store the user's balance prior to withdrawal in a temporary variable.
44     uint amount = balances[msg.sender];
45     // Update the user's balance prior to sending ETH to prevent recursive call.
46     balances[msg.sender] = 0;
47     // Return the user's funds.  Throws on failure to prevent loss of funds.
48     msg.sender.transfer(amount);
49   }
50   
51   // Allow anyone to contribute to the buy executer's reward.
52   function add_reward() payable {
53     // Update reward value to include received amount.
54     reward += msg.value;
55   }
56   
57   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
58   function buy(){
59     // Record that the contract has bought the tokens.
60     bought_tokens = true;
61     // Record the time the contract bought the tokens.
62     time_bought = now;
63     // Transfer all the funds (less the caller reward) 
64     // to the Bancor crowdsale contract to buy tokens.
65     // Throws if the crowdsale hasn't started yet or has
66     // already completed, preventing loss of funds.
67     CrowdsaleController(sale).contributeETH.value(this.balance - reward)();
68     // Reward the caller for being the first to execute the buy.
69     msg.sender.transfer(reward);
70   }
71   
72   // A helper function for the default function, allowing contracts to interact.
73   function default_helper() payable {
74     // Only allow deposits if the contract hasn't already purchased the tokens.
75     if (!bought_tokens) {
76       // Update records of deposited ETH to include the received amount.
77       balances[msg.sender] += msg.value;
78     }
79     // Withdraw the sender's tokens if the contract has already purchased them.
80     else {
81       // Store the user's BNT balance in a temporary variable (1 ETHWei -> 100 BNTWei).
82       uint amount = balances[msg.sender] * 100;
83       // Update the user's balance prior to sending BNT to prevent recursive call.
84       balances[msg.sender] = 0;
85       // No fee for withdrawing during the crowdsale.
86       uint fee = 0;
87       // 1% fee for withdrawing after the crowdsale has ended.
88       if (now > time_bought + 1 hours) {
89         fee = amount / 100;
90       }
91       // Transfer the tokens to the sender and the developer.
92       ERC20(token).transfer(msg.sender, amount - fee);
93       ERC20(token).transfer(developer, fee);
94       // Refund any ETH sent after the contract has already purchased tokens.
95       msg.sender.transfer(msg.value);
96     }
97   }
98   
99   function () payable {
100     default_helper();
101   }
102 }