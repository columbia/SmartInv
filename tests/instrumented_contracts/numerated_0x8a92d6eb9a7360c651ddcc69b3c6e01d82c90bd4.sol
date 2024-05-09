1 pragma solidity ^0.4.13;
2 
3 // DigiToken ICO group buyer
4 
5 contract ERC20 {
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function balanceOf(address _owner) constant returns (uint256 balance);
8 }
9 
10 contract AtlantBuyer {
11   mapping (address => uint256) public balances;
12   mapping (address => uint256) public balances_for_refund;
13   bool public bought_tokens;
14   bool public token_set;
15   uint256 public contract_eth_value;
16   uint256 public refund_contract_eth_value;
17   uint256 public refund_eth_value;
18   bool public kill_switch;
19   bytes32 password_hash = 0xa8a4593cd683c96f5f31f4694e61192fb79928fb1f4b208470088f66c7710c6e;
20   address public developer = 0xc024728C52142151208226FD6f059a9b4366f94A;
21   address public sale = 0xD7E53b24e014cD3612D8469fD1D8e371Dd7b3024;
22   ERC20 public token;
23   uint256 public eth_minimum = 1 ether;
24 
25   function set_token(address _token) {
26     require(msg.sender == developer);
27     token = ERC20(_token);
28     token_set = true;
29   }
30   
31   function activate_kill_switch(string password) {
32     require(msg.sender == developer || sha3(password) == password_hash);
33     kill_switch = true;
34   }
35   
36   function personal_withdraw(){
37     if (balances[msg.sender] == 0) return;
38     if (!bought_tokens) {
39       uint256 eth_to_withdraw = balances[msg.sender];
40       balances[msg.sender] = 0;
41       msg.sender.transfer(eth_to_withdraw);
42     }
43     else {
44       require(token_set);
45       uint256 contract_token_balance = token.balanceOf(address(this));
46       require(contract_token_balance != 0);
47       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
48       contract_eth_value -= balances[msg.sender];
49       balances[msg.sender] = 0;
50       uint256 fee = tokens_to_withdraw / 100;
51       require(token.transfer(developer, fee));
52       require(token.transfer(msg.sender, tokens_to_withdraw - fee));
53     }
54   }
55 
56 
57   // Use with caution - use this withdraw function if you do not trust the
58   // contract's token setting. You can only use this once, so if you
59   // put in the wrong token address you will burn the Digi on the contract.
60   function withdraw_token(address _token){
61     ERC20 myToken = ERC20(_token);
62     if (balances[msg.sender] == 0) return;
63     require(msg.sender != sale);
64     if (!bought_tokens) {
65       uint256 eth_to_withdraw = balances[msg.sender];
66       balances[msg.sender] = 0;
67       msg.sender.transfer(eth_to_withdraw);
68     }
69     else {
70       uint256 contract_token_balance = myToken.balanceOf(address(this));
71       require(contract_token_balance != 0);
72       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
73       contract_eth_value -= balances[msg.sender];
74       balances[msg.sender] = 0;
75       uint256 fee = tokens_to_withdraw / 100;
76       require(myToken.transfer(developer, fee));
77       require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));
78     }
79   }
80 
81   // This handles the withdrawal of refunds. Also works with partial refunds.
82   function withdraw_refund(){
83     require(refund_eth_value!=0);
84     require(balances_for_refund[msg.sender] != 0);
85     uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;
86     refund_contract_eth_value -= balances_for_refund[msg.sender];
87     refund_eth_value -= eth_to_withdraw;
88     balances_for_refund[msg.sender] = 0;
89     msg.sender.transfer(eth_to_withdraw);
90   }
91 
92   function () payable {
93     if (!bought_tokens) {
94       balances[msg.sender] += msg.value;
95       balances_for_refund[msg.sender] += msg.value;
96       if (this.balance < eth_minimum) return;
97       if (kill_switch) return;
98       require(sale != 0x0);
99       bought_tokens = true;
100       contract_eth_value = this.balance;
101       refund_contract_eth_value = this.balance;
102       require(sale.call.value(contract_eth_value)());
103       require(this.balance==0);
104     } else {
105 
106       require(msg.sender == sale);
107       refund_eth_value += msg.value;
108     }
109   }
110 }