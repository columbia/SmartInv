1 pragma solidity ^0.4.5;
2 
3 contract Token{
4     
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns   
12     (bool success);
13 
14     function approve(address _spender, uint256 _value) returns (bool success);
15 
16     function allowance(address _owner, address _spender) constant returns 
17     (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20 
21     event Approval(address indexed _owner, address indexed _spender, uint256 
22     _value);
23 }
24 
25 contract StandardToken is Token {
26     function transfer(address _to, uint256 _value) returns (bool success) {
27  
28         require(balances[msg.sender] >= _value);
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns 
37     (bool success) {
38 
39         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
40         balances[_to] += _value;
41         balances[_from] -= _value;
42         allowed[_from][msg.sender] -= _value;
43         Transfer(_from, _to, _value);
44         return true;
45     }
46     function balanceOf(address _owner) constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50 
51     function approve(address _spender, uint256 _value) returns (bool success)   
52     {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60         return allowed[_owner][_spender];
61     }
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 }
65 
66 contract HumanStandardToken is StandardToken { 
67 
68     string public name;             
69     uint8 public decimals;              
70     string public symbol;         
71     string public version = 'H0.1'; 
72 
73     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
74         balances[msg.sender] = _initialAmount; 
75         totalSupply = _initialAmount; 
76         name = _tokenName;   
77         decimals = _decimalUnits;  
78         symbol = _tokenSymbol;  
79     }
80 
81     
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
86         return true;
87     }
88 
89 }