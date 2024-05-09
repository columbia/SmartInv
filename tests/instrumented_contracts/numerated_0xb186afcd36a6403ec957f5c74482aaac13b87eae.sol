1 pragma solidity ^0.4.13;
2 
3 // Enjin ICO group buyer
4 // Avtor: Janez
5 
6 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
7 contract ERC20 {
8 function transfer(address _to, uint256 _value) returns (bool success);
9 function balanceOf(address _owner) constant returns (uint256 balance);
10 }
11 
12 contract EnjinBuyer {
13 mapping (address => uint256) public balances;
14 mapping (address => uint256) public balances_for_refund;
15 bool public bought_tokens;
16 bool public token_set;
17 uint256 public contract_eth_value;
18 uint256 public refund_contract_eth_value;
19 uint256 public refund_eth_value;
20 bool public kill_switch;
21 bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;
22 address public developer = 0x0e7CE7D6851F60A1eF2CAE9cAD765a5a62F32A84;
23 address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;
24 ERC20 public token;
25 uint256 public eth_minimum = 3235 ether;
26 
27 function set_token(address _token) {
28 require(msg.sender == developer);
29 token = ERC20(_token);
30 token_set = true;
31 }
32 
33 function activate_kill_switch(string password) {
34 require(msg.sender == developer || sha3(password) == password_hash);
35 kill_switch = true;
36 }
37 
38 function personal_withdraw(string password, uint256 transfer_amount){
39 require(msg.sender == developer || sha3(password) == password_hash);
40 msg.sender.transfer(transfer_amount);
41 }
42 
43 // Use with caution - use this withdraw function if you do not trust the
44 // contract's token setting. You can only use this once, so if you
45 // put in the wrong token address you will burn the Enjin on the contract.
46 function withdraw_token(address _token){
47 ERC20 myToken = ERC20(_token);
48 if (balances[msg.sender] == 0) return;
49 require(msg.sender != sale);
50 if (!bought_tokens) {
51 uint256 eth_to_withdraw = balances[msg.sender];
52 balances[msg.sender] = 0;
53 msg.sender.transfer(eth_to_withdraw);
54 }
55 else {
56 uint256 contract_token_balance = myToken.balanceOf(address(this));
57 require(contract_token_balance != 0);
58 uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
59 contract_eth_value -= balances[msg.sender];
60 balances[msg.sender] = 0;
61 uint256 fee = tokens_to_withdraw / 100;
62 require(myToken.transfer(developer, fee));
63 require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));
64 }
65 }
66 
67 // This handles the withdrawal of refunds. Also works with partial refunds.
68 function withdraw_refund(){
69 require(refund_eth_value!=0);
70 require(balances_for_refund[msg.sender] != 0);
71 uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;
72 refund_contract_eth_value -= balances_for_refund[msg.sender];
73 refund_eth_value -= eth_to_withdraw;
74 balances_for_refund[msg.sender] = 0;
75 msg.sender.transfer(eth_to_withdraw);
76 }
77 
78 function () payable {
79 if (!bought_tokens) {
80 balances[msg.sender] += msg.value;
81 balances_for_refund[msg.sender] += msg.value;
82 if (this.balance < eth_minimum) return;
83 if (kill_switch) return;
84 require(sale != 0x0);
85 bought_tokens = true;
86 contract_eth_value = this.balance;
87 refund_contract_eth_value = this.balance;
88 require(sale.call.value(contract_eth_value)());
89 require(this.balance==0);
90 } else {
91 // We might be getting a full refund or partial refund if we go over the limit from Enjin's multisig wallet.
92 // We have been assured by the CTO that the refund would only
93 // come from the pre-sale wallet.
94 require(msg.sender == sale);
95 refund_eth_value += msg.value;
96 }
97 }
98 }