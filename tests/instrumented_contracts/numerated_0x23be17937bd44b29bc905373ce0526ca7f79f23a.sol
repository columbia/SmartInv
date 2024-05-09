1 pragma solidity ^0.4.8;
2 contract Token{
3     
4     uint256 public totalSupply;
5 
6     
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     
13     function transferFrom(address _from, address _to, uint256 _value) returns   
14     (bool success);
15 
16     
17     function approve(address _spender, uint256 _value) returns (bool success);
18 
19     
20     function allowance(address _owner, address _spender) constant returns 
21     (uint256 remaining);
22 
23     
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26     
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         
34         require(balances[msg.sender] >= _value);
35         balances[msg.sender] -= _value;
36         balances[_to] += _value;
37         Transfer(msg.sender, _to, _value);
38         return true;
39     }
40 
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns 
43     (bool success) {
44         
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
46         balances[_to] += _value;
47         balances[_from] -= _value; 
48         allowed[_from][msg.sender] -= _value;
49         Transfer(_from, _to, _value);
50         return true;
51     }
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56 
57     function approve(address _spender, uint256 _value) returns (bool success)   
58     {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64 
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
66         return allowed[_owner][_spender];
67     }
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70 }
71 
72 contract HumanStandardToken is StandardToken { 
73    
74     string public name;                  
75     uint8 public decimals;              
76     string public symbol;              
77     string public version = 'H0.1';   
78 
79     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
80         balances[msg.sender] = _initialAmount;
81         totalSupply = _initialAmount;        
82         name = _tokenName;                  
83         decimals = _decimalUnits;         
84         symbol = _tokenSymbol;           
85     }
86     
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         
91         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
92         return true;
93     }
94 
95 }