1 pragma solidity ^0.4.23;
2 
3 contract Contract {
4   mapping (address => uint256) public balances_bonus;
5   uint256 public contract_eth_value_bonus;
6 }
7 
8 contract ERC20 {
9   function transfer(address _to, uint256 _value) public returns (bool success);
10   function balanceOf(address _owner) public constant returns (uint256 balance);
11 }
12 
13 contract Proxy {
14 
15   Contract contr;
16   uint256 public eth_balance;
17   ERC20 public token;
18   mapping (address => bool) public withdrew;
19   address owner;
20 
21   constructor(address _contract, address _token) {
22       owner = msg.sender;
23       contr = Contract(_contract);
24       token = ERC20(_token);
25       eth_balance = contr.contract_eth_value_bonus();
26   }
27 
28   function withdraw()  {
29       require(withdrew[msg.sender] == false);
30       withdrew[msg.sender] = true;
31       uint256 balance = contr.balances_bonus(msg.sender);
32       uint256 contract_token_balance = token.balanceOf(address(this));
33       uint256 tokens_to_withdraw = (balance*contract_token_balance)/eth_balance;
34       eth_balance -= balance;
35       require(token.transfer(msg.sender, tokens_to_withdraw));
36 
37   }
38 
39   function emergency_withdraw(address _token) {
40       require(msg.sender == owner);
41       require(ERC20(_token).transfer(owner, ERC20(_token).balanceOf(this)));
42   }
43 
44 }