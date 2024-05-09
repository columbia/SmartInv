1 pragma solidity ^0.4.5;
2 contract Token{
3     
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) returns   
11     (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns 
16     (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint256 
21     _value);
22 }
23 
24 contract StandardToken is Token {
25     function transfer(address _to, uint256 _value) returns (bool success) {
26  
27         require(balances[msg.sender] >= _value);
28         balances[msg.sender] -= _value;
29         balances[_to] += _value;
30         Transfer(msg.sender, _to, _value);
31         return true;
32     }
33 
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns 
36     (bool success) {
37 
38         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
39         balances[_to] += _value;
40         balances[_from] -= _value;
41         allowed[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44     }
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49 
50     function approve(address _spender, uint256 _value) returns (bool success)   
51     {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63 }
64 
65 contract HumanStandardToken is StandardToken { 
66 
67     string public name;             
68     uint8 public decimals;              
69     string public symbol;         
70     string public version = 'H0.1'; 
71 
72     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
73         balances[msg.sender] = _initialAmount; 
74         totalSupply = _initialAmount; 
75         name = _tokenName;   
76         decimals = _decimalUnits;  
77         symbol = _tokenSymbol;  
78     }
79 
80     
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
85         return true;
86     }
87 
88 }