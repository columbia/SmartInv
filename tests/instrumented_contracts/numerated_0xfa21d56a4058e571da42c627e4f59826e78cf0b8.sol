1 pragma solidity ^0.4.13;
2 
3 // Enjin ICO group buyer
4 // Avtor: Janez
5 
6 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
7 contract ERC20 {
8   function transfer(address _to, uint256 _value) returns (bool success);
9   function balanceOf(address _owner) constant returns (uint256 balance);
10 }
11 
12 contract EnjinBuyer {
13   mapping (address => uint256) public balances;
14   mapping (address => uint256) public balances_for_refund;
15   bool public bought_tokens;
16   bool public token_set;
17   uint256 public contract_eth_value;
18   uint256 public refund_contract_eth_value;
19   uint256 public refund_eth_value;
20   bool public kill_switch;
21   bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;
22   address public developer = 0x0639C169D9265Ca4B4DEce693764CdA8ea5F3882;
23   address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;
24   ERC20 public token;
25   uint256 public eth_minimum = 3235 ether;
26 
27   function set_token(address _token) {
28     require(msg.sender == developer);
29     token = ERC20(_token);
30     token_set = true;
31   }
32   
33   function activate_kill_switch(string password) {
34     require(msg.sender == developer || sha3(password) == password_hash);
35     kill_switch = true;
36   }
37   
38   function personal_withdraw(){
39     if (balances[msg.sender] == 0) return;
40     if (!bought_tokens) {
41       uint256 eth_to_withdraw = balances[msg.sender];
42       balances[msg.sender] = 0;
43       msg.sender.transfer(eth_to_withdraw);
44     }
45     else {
46       require(token_set);
47       uint256 contract_token_balance = token.balanceOf(address(this));
48       require(contract_token_balance != 0);
49       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
50       contract_eth_value -= balances[msg.sender];
51       balances[msg.sender] = 0;
52       uint256 fee = tokens_to_withdraw / 100;
53       require(token.transfer(developer, fee));
54       require(token.transfer(msg.sender, tokens_to_withdraw - fee));
55     }
56   }
57 
58 
59   // Use with caution - use this withdraw function if you do not trust the
60   // contract's token setting. You can only use this once, so if you
61   // put in the wrong token address you will burn the Enjin on the contract.
62   function withdraw_token(address _token){
63     ERC20 myToken = ERC20(_token);
64     if (balances[msg.sender] == 0) return;
65     require(msg.sender != sale);
66     if (!bought_tokens) {
67       uint256 eth_to_withdraw = balances[msg.sender];
68       balances[msg.sender] = 0;
69       msg.sender.transfer(eth_to_withdraw);
70     }
71     else {
72       uint256 contract_token_balance = myToken.balanceOf(address(this));
73       require(contract_token_balance != 0);
74       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
75       contract_eth_value -= balances[msg.sender];
76       balances[msg.sender] = 0;
77       uint256 fee = tokens_to_withdraw / 100;
78       require(myToken.transfer(developer, fee));
79       require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));
80     }
81   }
82 
83   // This handles the withdrawal of refunds. Also works with partial refunds.
84   function withdraw_refund(){
85     require(refund_eth_value!=0);
86     require(balances_for_refund[msg.sender] != 0);
87     uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;
88     refund_contract_eth_value -= balances_for_refund[msg.sender];
89     refund_eth_value -= eth_to_withdraw;
90     balances_for_refund[msg.sender] = 0;
91     msg.sender.transfer(eth_to_withdraw);
92   }
93 
94   function () payable {
95     if (!bought_tokens) {
96       balances[msg.sender] += msg.value;
97       balances_for_refund[msg.sender] += msg.value;
98       if (this.balance < eth_minimum) return;
99       if (kill_switch) return;
100       require(sale != 0x0);
101       bought_tokens = true;
102       contract_eth_value = this.balance;
103       refund_contract_eth_value = this.balance;
104       require(sale.call.value(contract_eth_value)());
105       require(this.balance==0);
106     } else {
107       // We might be getting a full refund or partial refund if we go over the limit from Enjin's multisig wallet.
108       // We have been assured by the CTO that the refund would only
109       // come from the pre-sale wallet.
110       require(msg.sender == sale);
111       refund_eth_value += msg.value;
112     }
113   }
114 }