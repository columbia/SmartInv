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
14   mapping (address => uint256) public balances_after_buy;
15   bool public bought_tokens;
16   bool public token_set;
17   bool public refunded;
18   uint256 public contract_eth_value;
19   bool public kill_switch;
20   bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;
21   address public developer = 0x0639C169D9265Ca4B4DEce693764CdA8ea5F3882;
22   address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;
23   ERC20 public token;
24   uint256 public eth_minimum = 3235 ether;
25 
26   function set_token(address _token) {
27     require(msg.sender == developer);
28     token = ERC20(_token);
29     token_set = true;
30   }
31 
32   // This function should only be called in the unfortunate case that Enjin should refund from a different address.
33   function set_refunded(bool _refunded) {
34     require(msg.sender == developer);
35     refunded = _refunded;
36   }
37   
38   function activate_kill_switch(string password) {
39     require(msg.sender == developer || sha3(password) == password_hash);
40     kill_switch = true;
41   }
42   
43   function personal_withdraw(){
44     if (balances_after_buy[msg.sender]>0 && msg.sender != sale) {
45         uint256 eth_to_withdraw_after_buy = balances_after_buy[msg.sender];
46         balances_after_buy[msg.sender] = 0;
47         msg.sender.transfer(eth_to_withdraw_after_buy);
48     }
49     if (balances[msg.sender] == 0) return;
50     require(msg.sender != sale);
51     if (!bought_tokens || refunded) {
52       uint256 eth_to_withdraw = balances[msg.sender];
53       balances[msg.sender] = 0;
54       msg.sender.transfer(eth_to_withdraw);
55     }
56     else {
57       require(token_set);
58       uint256 contract_token_balance = token.balanceOf(address(this));
59       require(contract_token_balance != 0);
60       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
61       contract_eth_value -= balances[msg.sender];
62       balances[msg.sender] = 0;
63       uint256 fee = tokens_to_withdraw / 100;
64       require(token.transfer(developer, fee));
65       require(token.transfer(msg.sender, tokens_to_withdraw - fee));
66     }
67   }
68 
69   function withdraw(address user){
70     require(bought_tokens || kill_switch);
71     // We don't allow the crowdsale to withdraw its funds back (or anyone to do that on their behalf).
72     require(user != sale);
73     if (balances_after_buy[user]>0 && user != sale) {
74         uint256 eth_to_withdraw_after_buy = balances_after_buy[user];
75         balances_after_buy[user] = 0;
76         user.transfer(eth_to_withdraw_after_buy);
77     }
78     if (balances[user] == 0) return;
79     if (!bought_tokens || refunded) {
80       uint256 eth_to_withdraw = balances[user];
81       balances[user] = 0;
82       user.transfer(eth_to_withdraw);
83     }
84     else {
85       require(token_set);
86       uint256 contract_token_balance = token.balanceOf(address(this));
87       require(contract_token_balance != 0);
88       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
89       contract_eth_value -= balances[user];
90       balances[user] = 0;
91       uint256 fee = tokens_to_withdraw / 100;
92       require(token.transfer(developer, fee));
93       require(token.transfer(user, tokens_to_withdraw - fee));
94     }
95   }
96 
97   function purchase_tokens() {
98     require(msg.sender == developer);
99     if (this.balance < eth_minimum) return;
100     if (kill_switch) return;
101     require(sale != 0x0);
102     bought_tokens = true;
103     contract_eth_value = this.balance;
104     require(sale.call.value(contract_eth_value)());
105     require(this.balance==0);
106   }
107   
108   function () payable {
109     if (!bought_tokens) {
110       balances[msg.sender] += msg.value;
111     } else {
112       // We might be getting a refund from Enjin's multisig wallet.
113       // It could also be someone who has missed the buy, so we keep
114       // track of this as well so that he can safely withdraw.
115       // We might get the Enjin refund from another wallet, so this
116       // is why we allow this behavior.
117       balances_after_buy[msg.sender] += msg.value;
118       if (msg.sender == sale && this.balance >= contract_eth_value) {
119         refunded = true;
120       }
121     }
122   }
123 }