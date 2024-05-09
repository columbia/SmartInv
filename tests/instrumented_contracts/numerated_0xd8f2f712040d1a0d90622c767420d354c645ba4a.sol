1 pragma solidity ^0.4.19;
2 contract Token{
3     uint256 public totalSupply;
4     function balanceOf(address _owner) constant returns (uint256 balance);
5     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function approve(address _spender, uint256 _value) returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract StandardToken is Token {
13     function balanceOf(address _owner) constant returns (uint256 balance) {
14         return balances[_owner];
15     }
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
17         return allowed[_owner][_spender];
18     }
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         require(balances[msg.sender] >= _value);
21         balances[msg.sender] -= _value;
22         balances[_to] += _value;
23         Transfer(msg.sender, _to, _value);
24         return true;
25     }
26     function approve(address _spender, uint256 _value) returns (bool success)   
27     {
28         allowed[msg.sender][_spender] = _value;
29         Approval(msg.sender, _spender, _value);
30         return true;
31     }
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value; 
36         allowed[_from][msg.sender] -= _value;
37         Transfer(_from, _to, _value);
38         return true;
39     }
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42 }
43 
44 contract BlockchainUniversityToken is StandardToken { 
45 
46     string public name;                   
47     uint8 public decimals;               
48     string public symbol;             
49 
50     function BlockchainUniversityToken() {
51         balances[msg.sender] = 210000000000000000; 
52         totalSupply = 210000000000000000;         
53         name = "Blockchain University Token";                  
54         decimals = 8;          
55         symbol = "BUT";            
56     }
57 }