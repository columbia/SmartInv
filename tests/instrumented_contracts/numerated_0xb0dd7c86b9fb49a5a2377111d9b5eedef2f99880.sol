1 pragma solidity ^0.4.10;
2 contract NVTNetworkToken { 
3 // set contract name
4    
5 string public name; 
6 string public symbol; 
7 uint8 public decimals;
8 uint256 public totalSupply;
9  
10 // Balances for each account
11 mapping(address => uint256) balances;
12 address devAddress;
13 // Events
14 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 event Transfer(address indexed from, address indexed to, uint256 value);
16  
17 // Owner of the account approves the transfer of an amount to another account
18 mapping(address => mapping (address => uint256)) allowed;
19 // Constructor function
20 function NVTNetworkToken() { 
21     name = "NVTNetworkToken";
22     symbol = "NVT";
23     decimals = 18; // sets the number of decimals
24     devAddress=0x529F1b18b28D73461602d7143f6d3758628D383f; // address that will distribute the tokens
25     uint initialBalance=1000000000000000000*1000000000; // 1 billion tokens
26     balances[devAddress]=initialBalance;
27     totalSupply+=initialBalance; // sets the total supply
28 }
29 function balanceOf(address _owner) constant returns (uint256 balance) {
30     return balances[_owner];
31 }
32 // Transfer the balance from owner's account to another account
33 function transfer(address _to, uint256 _amount) returns (bool success) {
34     if (balances[msg.sender] >= _amount 
35         && _amount > 0
36         && balances[_to] + _amount > balances[_to]) {
37         balances[msg.sender] -= _amount;
38         balances[_to] += _amount;
39         Transfer(msg.sender, _to, _amount); 
40         return true;
41     } else {
42         return false;
43     }
44 }
45 function transferFrom(
46     address _from,
47     address _to,
48     uint256 _amount
49 ) returns (bool success) {
50     if (balances[_from] >= _amount
51         && allowed[_from][msg.sender] >= _amount
52         && _amount > 0
53         && balances[_to] + _amount > balances[_to]) {
54         balances[_from] -= _amount;
55         allowed[_from][msg.sender] -= _amount;
56         balances[_to] += _amount;
57         return true;
58     } else {
59         return false;
60     }
61 }
62 //If this function is called again it overwrites the current allowance with _value.
63 function approve(address _spender, uint256 _amount) returns (bool success) {
64     allowed[msg.sender][_spender] = _amount;
65     Approval(msg.sender, _spender, _amount);
66     return true;
67 }
68 }