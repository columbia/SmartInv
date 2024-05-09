1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 TenX Reseller
6 ========================
7 
8 Resells TenX tokens from the crowdsale before transfers are enabled.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 // Well, almost.  PAY tokens throw on transfer failure instead of returning false.
15 contract ERC20 {
16   function transfer(address _to, uint _value);
17   function balanceOf(address _owner) constant returns (uint balance);
18 }
19 
20 // Interface to TenX ICO Contract
21 contract MainSale {
22   function createTokens(address recipient) payable;
23 }
24 
25 contract Reseller {
26   // Store the amount of PAY claimed by each account.
27   mapping (address => uint256) public pay_claimed;
28   // Total claimed PAY of all accounts.
29   uint256 public total_pay_claimed;
30   
31   // The TenX Token Sale address.
32   MainSale public sale = MainSale(0xd43D09Ec1bC5e57C8F3D0c64020d403b04c7f783);
33   // TenX Token (PAY) Contract address.
34   ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);
35   // The developer address.
36   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
37 
38   // Buys PAY for the contract with user funds.
39   function buy() payable {
40     // Transfer received funds to the TenX crowdsale contract to buy tokens.
41     sale.createTokens.value(msg.value)(address(this));
42   }
43   
44   // Withdraws PAY claimed by the user.
45   function withdraw() {
46     // Store the user's amount of claimed PAY as the amount of PAY to withdraw.
47     uint256 pay_to_withdraw = pay_claimed[msg.sender];
48     // Update the user's amount of claimed PAY first to prevent recursive call.
49     pay_claimed[msg.sender] = 0;
50     // Update the total amount of claimed PAY.
51     total_pay_claimed -= pay_to_withdraw;
52     // Send the user their PAY.  Throws on failure to prevent loss of funds.
53     token.transfer(msg.sender, pay_to_withdraw);
54   }
55   
56   // Claims PAY at a price determined by the block number.
57   function claim() payable {
58     // Verify ICO is over.
59     if(block.number < 3930000) throw;
60     // Calculate current sale price (PAY per ETH) based on block number.
61     uint256 pay_per_eth = (block.number - 3930000) / 10;
62     // Calculate amount of PAY user can purchase.
63     uint256 pay_to_claim = pay_per_eth * msg.value;
64     // Retrieve current PAY balance of contract.
65     uint256 contract_pay_balance = token.balanceOf(address(this));
66     // Verify the contract has enough remaining unclaimed PAY.
67     if((contract_pay_balance - total_pay_claimed) < pay_to_claim) throw;
68     // Update the amount of PAY claimed by the user.
69     pay_claimed[msg.sender] += pay_to_claim;
70     // Update the total amount of PAY claimed by all users.
71     total_pay_claimed += pay_to_claim;
72     // Send the funds to the developer instead of leaving them in the contract.
73     developer.transfer(msg.value);
74   }
75   
76   // Default function.  Called when a user sends ETH to the contract.
77   function () payable {
78     // If the user sent a 0 ETH transaction, withdraw their PAY.
79     if(msg.value == 0) {
80       withdraw();
81     }
82     // If the user sent ETH, claim PAY with it.
83     else {
84       claim();
85     }
86   }
87 }