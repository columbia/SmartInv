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
18 contract BancorBuyer {
19   // Store the amount of ETH deposited or BNT owned by each account.
20   mapping (address => uint) public balances;
21   // Track whether the contract has bought the tokens yet.
22   bool public bought_tokens;
23   // Record the time the contract bought the tokens.
24   uint public time_bought;
25   
26   // The Bancor Token Sale address.
27   address sale = 0xBbc79794599b19274850492394004087cBf89710;
28   // Bancor Smart Token Contract address.
29   address token = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
30   // The developer address.
31   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
32   
33   // Withdraws all ETH deposited by the sender.
34   // Called to cancel a user's participation in the sale.
35   function withdraw(){
36     // Store the user's balance prior to withdrawal in a temporary variable.
37     uint amount = balances[msg.sender];
38     // Update the user's balance prior to sending ETH to prevent recursive call.
39     balances[msg.sender] = 0;
40     // Return the user's funds.  Throws on failure to prevent loss of funds.
41     msg.sender.transfer(amount);
42   }
43   
44   // Buys tokens in the crowdsale, callable by anyone.
45   function buy(){
46     // Transfer all funds to the Bancor crowdsale contract to buy tokens.
47     // Throws if the crowdsale hasn't started yet or has
48     // already completed, preventing loss of funds.
49     sale.transfer(this.balance);
50     // Record that the contract has bought the tokens.
51     bought_tokens = true;
52     // Record the time the contract bought the tokens.
53     time_bought = now;
54   }
55   
56   function () payable {
57     // Only allow deposits if the contract hasn't already purchased the tokens.
58     if (!bought_tokens) {
59       // Update records of deposited ETH to include the received amount.
60       balances[msg.sender] += msg.value;
61     }
62     // Withdraw the sender's tokens if the contract has already purchased them.
63     else {
64       // Store the user's BNT balance in a temporary variable (1 ETHWei -> 100 BNTWei).
65       uint amount = balances[msg.sender] * 100;
66       // Update the user's balance prior to sending BNT to prevent recursive call.
67       balances[msg.sender] = 0;
68       // No fee for withdrawing during the crowdsale.
69       uint fee = 0;
70       // 1% fee for withdrawing after the crowdsale has ended.
71       if (now > time_bought + 1 hours) {
72         fee = amount / 100;
73       }
74       // Transfer the tokens to the sender and the developer.
75       ERC20(token).transfer(msg.sender, amount - fee);
76       ERC20(token).transfer(developer, fee);
77       // Refund any ETH sent after the contract has already purchased tokens.
78       msg.sender.transfer(msg.value);
79     }
80   }
81 }