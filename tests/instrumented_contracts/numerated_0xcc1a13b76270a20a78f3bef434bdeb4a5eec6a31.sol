1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4   function transfer(address _to, uint256 _value) returns (bool success);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 contract ENJ {
9   mapping (address => uint256) public balances;
10   mapping (address => uint256) public balances_for_refund;
11   bool public bought_tokens;
12   bool public token_set;
13   uint256 public contract_eth_value;
14   uint256 public refund_contract_eth_value;
15   uint256 public refund_eth_value;
16   bool public kill_switch;
17   bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;
18   address public developer = 0x859271eF2F73A447a1EfD7F95037017667c9d326;
19   address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;
20   ERC20 public token;
21   uint256 public eth_minimum = 3235 ether;
22 
23   function set_token(address _token) {
24     require(msg.sender == developer);
25     token = ERC20(_token);
26     token_set = true;
27   }
28   
29   function personal_withdraw(uint256 transfer_amount){
30       require(msg.sender == developer);
31       developer.transfer(transfer_amount);
32   }
33 
34   function withdraw_token(address _token){
35     ERC20 myToken = ERC20(_token);
36     if (balances[msg.sender] == 0) return;
37     require(msg.sender != sale);
38     if (!bought_tokens) {
39       uint256 eth_to_withdraw = balances[msg.sender];
40       balances[msg.sender] = 0;
41       msg.sender.transfer(eth_to_withdraw);
42     }
43     else {
44       uint256 contract_token_balance = myToken.balanceOf(address(this));
45       require(contract_token_balance != 0);
46       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
47       contract_eth_value -= balances[msg.sender];
48       balances[msg.sender] = 0;
49       uint256 fee = tokens_to_withdraw / 100;
50       require(myToken.transfer(developer, fee));
51       require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));
52     }
53   }
54 
55   // This handles the withdrawal of refunds. Also works with partial refunds.
56   function withdraw_refund(){
57     require(refund_eth_value!=0);
58     require(balances_for_refund[msg.sender] != 0);
59     uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;
60     refund_contract_eth_value -= balances_for_refund[msg.sender];
61     refund_eth_value -= eth_to_withdraw;
62     balances_for_refund[msg.sender] = 0;
63     msg.sender.transfer(eth_to_withdraw);
64   }
65 
66   function () payable {
67     if (!bought_tokens) {
68       balances[msg.sender] += msg.value;
69       balances_for_refund[msg.sender] += msg.value;
70       if (this.balance < eth_minimum) return;
71       if (kill_switch) return;
72       require(sale != 0x0);
73       bought_tokens = true;
74       contract_eth_value = this.balance;
75       refund_contract_eth_value = this.balance;
76       require(sale.call.value(contract_eth_value)());
77       require(this.balance==0);
78     } else {
79 
80       require(msg.sender == sale);
81       refund_eth_value += msg.value;
82     }
83   }
84 }