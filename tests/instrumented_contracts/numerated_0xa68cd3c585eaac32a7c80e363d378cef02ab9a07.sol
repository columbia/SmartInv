1 pragma solidity ^0.4.19;
2 
3 // Proyecto Tokademia & Token Academia
4 // Fomentando la presencia de la Blockchain en Chile
5  
6 contract Token {
7  
8     
9     function totalSupply() constant returns (uint256 supply) {}
10  
11     
12     function balanceOf(address _owner) constant returns (uint256 balance) {}
13  
14     
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16  
17     
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19  
20     
21     function approve(address _spender, uint256 _value) returns (bool success) {}
22  
23     
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
25  
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29 
30  
31 contract StandardToken is Token {
32  
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         
35         if (balances[msg.sender] >= _value && _value > 0) {
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             Transfer(msg.sender, _to, _value);
39             return true;
40         } else { return false; }
41     }
42  
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
44         
45         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             balances[_to] += _value;
47             balances[_from] -= _value;
48             allowed[_from][msg.sender] -= _value;
49             Transfer(_from, _to, _value);
50             return true;
51         } else { return false; }
52     }
53  
54     function balanceOf(address _owner) constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57  
58     function approve(address _spender, uint256 _value) returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63  
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67  
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     uint256 public totalSupply;
71 }
72  
73  
74 contract ERC20Token is StandardToken {
75  
76     function () {
77         throw;
78     }
79 
80     string public name;                   
81     uint8 public decimals;          
82     string public symbol;                
83     string public version = 'H1.0';       
84  
85 
86     function ERC20Token(
87         ) {
88         balances[msg.sender] = 400000000;               
89         totalSupply = 400000000;                        
90         name = "Token Academia";                                  
91         decimals = 0;                            
92         symbol = "TACA";                               
93     }
94  
95    
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99  
100       
101         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
102         return true;
103     }
104 }
105 
106 // Tokademia se libera de responsabilidad por mal uso del token.
107 // Síguenos en nuestra comunidad Telegram: t.me/Tokademia