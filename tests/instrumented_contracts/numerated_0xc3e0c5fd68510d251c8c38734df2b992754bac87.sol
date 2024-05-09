1 pragma solidity ^0.4.10;
2 contract CryptoFunding { // set contract name to token name
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
19 function CryptoFunding() { // Set the constructor to the same name as the contract name
20     name = "CryptoFunding"; // set the token name here
21     symbol = "CFN"; // set the Symbol here
22     decimals = 18; // set the number of decimals
23     uint initialBalance=200000000000000000000000000; 
24     balances[msg.sender]=200000000000000000000000000;
25     totalSupply+=initialBalance; // Set the total suppy
26 }
27 function balanceOf(address _owner) constant returns (uint256 balance) {
28     return balances[_owner];
29 }
30 // Transfer the balance from owner's account to another account
31 function transfer(address _to, uint256 _amount) returns (bool success) {
32     if (balances[msg.sender] >= _amount 
33         && _amount > 0
34         && balances[_to] + _amount > balances[_to]) {
35         balances[msg.sender] -= _amount;
36         balances[_to] += _amount;
37         Transfer(msg.sender, _to, _amount); 
38         return true;
39     } else {
40         return false;
41     }
42 }
43 function transferFrom(
44     address _from,
45     address _to,
46     uint256 _amount
47 ) returns (bool success) {
48     if (balances[_from] >= _amount
49         && allowed[_from][msg.sender] >= _amount
50         && _amount > 0
51         && balances[_to] + _amount > balances[_to]) {
52         balances[_from] -= _amount;
53         allowed[_from][msg.sender] -= _amount;
54         balances[_to] += _amount;
55         return true;
56     } else {
57         return false;
58     }
59 }
60 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
61 // If this function is called again it overwrites the current allowance with _value.
62 function approve(address _spender, uint256 _amount) returns (bool success) {
63     allowed[msg.sender][_spender] = _amount;
64     Approval(msg.sender, _spender, _amount);
65     return true;
66 }
67 
68 
69 }