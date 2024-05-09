1 pragma solidity ^0.4.10;
2 contract NAWRAS { // set contract name to token name
3    
4 string public name; 
5 string public symbol; 
6 uint8 public decimals;
7 uint256 public totalSupply;
8  
9 // Balances for each account
10 mapping(address => uint256) balances;
11 address devAddress;
12 // Events
13 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 event Transfer(address indexed from, address indexed to, uint256 value);
15  
16 // Owner of account approves the transfer of an amount to another account
17 mapping(address => mapping (address => uint256)) allowed;
18 // This is the constructor and automatically runs when the smart contract is uploaded
19 function tokenName() { // Set the constructor to the same name as the contract name
20     name = "NAWRAS"; // set the token name here
21     symbol = "NAWRAS"; // set the Symbol here
22     decimals = 18; // set the number of decimals
23     devAddress=0x0Cd682aC964C39a4A188267FE87784F31132C443; // Add the address that you will distribute tokens from here
24     uint initialBalance=1000000000000000000*1000000000000; // 1M tokens
25     balances[devAddress]=initialBalance;
26     totalSupply+=initialBalance; // Set the total suppy
27 }
28 function balanceOf(address _owner) constant returns (uint256 balance) {
29     return balances[_owner];
30 }
31 // Transfer the balance from owner's account to another account
32 function transfer(address _to, uint256 _amount) returns (bool success) {
33     if (balances[msg.sender] >= _amount 
34         && _amount > 0
35         && balances[_to] + _amount > balances[_to]) {
36         balances[msg.sender] -= _amount;
37         balances[_to] += _amount;
38         Transfer(msg.sender, _to, _amount); 
39         return true;
40     } else {
41         return false;
42     }
43 }
44 function transferFrom(
45     address _from,
46     address _to,
47     uint256 _amount
48 ) returns (bool success) {
49     if (balances[_from] >= _amount
50         && allowed[_from][msg.sender] >= _amount
51         && _amount > 0
52         && balances[_to] + _amount > balances[_to]) {
53         balances[_from] -= _amount;
54         allowed[_from][msg.sender] -= _amount;
55         balances[_to] += _amount;
56         return true;
57     } else {
58         return false;
59     }
60 }
61 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
62 // If this function is called again it overwrites the current allowance with _value.
63 function approve(address _spender, uint256 _amount) returns (bool success) {
64     allowed[msg.sender][_spender] = _amount;
65     Approval(msg.sender, _spender, _amount);
66     return true;
67 }
68 }