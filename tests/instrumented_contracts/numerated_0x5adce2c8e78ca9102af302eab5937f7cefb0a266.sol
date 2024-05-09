1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 Status Reseller
6 ========================
7 
8 Resells Status tokens from the crowdsale before transfers are enabled.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function balanceOf(address _owner) constant returns (uint256 balance);
17 }
18 
19 contract Reseller {
20   // Store the amount of SNT claimed by each account.
21   mapping (address => uint256) public snt_claimed;
22   // Total claimed SNT of all accounts.
23   uint256 public total_snt_claimed;
24   
25   // Status Network Token (SNT) Contract address.
26   ERC20 public token = ERC20(0x744d70FDBE2Ba4CF95131626614a1763DF805B9E);
27   // The developer address.
28   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
29   
30   // Withdraws SNT claimed by the user.
31   function withdraw() {
32     // Store the user's amount of claimed SNT as the amount of SNT to withdraw.
33     uint256 snt_to_withdraw = snt_claimed[msg.sender];
34     // Update the user's amount of claimed SNT first to prevent recursive call.
35     snt_claimed[msg.sender] = 0;
36     // Update the total amount of claimed SNT.
37     total_snt_claimed -= snt_to_withdraw;
38     // Send the user their SNT.  Throws on failure to prevent loss of funds.
39     if(!token.transfer(msg.sender, snt_to_withdraw)) throw;
40   }
41   
42   // Claims SNT at a price determined by the block number.
43   function claim() payable {
44     // Verify ICO is over.
45     if(block.number < 3915000) throw;
46     // Calculate current sale price (SNT per ETH) based on block number.
47     uint256 snt_per_eth = (block.number - 3915000) * 2;
48     // Calculate amount of SNT user can purchase.
49     uint256 snt_to_claim = snt_per_eth * msg.value;
50     // Retrieve current SNT balance of contract.
51     uint256 contract_snt_balance = token.balanceOf(address(this));
52     // Verify the contract has enough remaining unclaimed SNT.
53     if((contract_snt_balance - total_snt_claimed) < snt_to_claim) throw;
54     // Update the amount of SNT claimed by the user.
55     snt_claimed[msg.sender] += snt_to_claim;
56     // Update the total amount of SNT claimed by all users.
57     total_snt_claimed += snt_to_claim;
58     // Send the funds to the developer instead of leaving them in the contract.
59     developer.transfer(msg.value);
60   }
61   
62   // Default function.  Called when a user sends ETH to the contract.
63   function () payable {
64     // If the user sent a 0 ETH transaction, withdraw their SNT.
65     if(msg.value == 0) {
66       withdraw();
67     }
68     // If the user sent ETH, claim SNT with it.
69     else {
70       claim();
71     }
72   }
73 }