1 /**
2  *Submitted for verification at Etherscan.io on 2017-09-27
3 */
4 
5 pragma solidity ^0.4.8;
6 contract Token{
7    
8     uint256 public totalSupply;
9 
10   
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 
13    
14     function transfer(address _to, uint256 _value) returns (bool success);
15 
16    
17     function transferFrom(address _from, address _to, uint256 _value) returns   
18     (bool success);
19 
20     
21     function approve(address _spender, uint256 _value) returns (bool success);
22 
23    
24     function allowance(address _owner, address _spender) constant returns 
25     (uint256 remaining);
26 
27    
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 
30    
31     event Approval(address indexed _owner, address indexed _spender, uint256 
32     _value);
33 }
34 
35 contract StandardToken is Token {
36     function transfer(address _to, uint256 _value) returns (bool success) {
37        
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns 
47     (bool success) {
48        
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
50         balances[_to] += _value;
51         balances[_from] -= _value; 
52         allowed[_from][msg.sender] -= _value;
53         Transfer(_from, _to, _value);
54         return true;
55     }
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60 
61     function approve(address _spender, uint256 _value) returns (bool success)   
62     {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70         return allowed[_owner][_spender];
71     }
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 }
75 
76 contract HumanStandardToken is StandardToken { 
77 
78     /* Public variables of the token */
79     string public name;                  
80     uint8 public decimals;               
81     string public symbol;               
82     string public version = 'H0.1';    
83 
84     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
85         balances[msg.sender] = _initialAmount; 
86         totalSupply = _initialAmount;         
87         name = _tokenName;                  
88         decimals = _decimalUnits;           
89         symbol = _tokenSymbol;             
90     }
91 
92     /* Approves and then calls the receiving contract */
93     
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
98         return true;
99     }
100 
101 }