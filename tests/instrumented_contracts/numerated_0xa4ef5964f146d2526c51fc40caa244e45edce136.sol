1 pragma solidity ^0.4.19;
2  
3 contract Token {
4  
5 
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9  
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
13 
14     function approve(address _spender, uint256 _value) returns (bool success) {}
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
17  
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20    
21 }
22  
23  
24  
25 contract StandardToken is Token {
26  
27     function transfer(address _to, uint256 _value) returns (bool success) {
28 
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36  
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
38         //same as above. Replace this line with the following if you want to protect against wrapping uints.
39         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48  
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50         return balances[_owner];
51     }
52  
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58  
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60       return allowed[_owner][_spender];
61     }
62  
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     uint256 public totalSupply;
66 }
67  
68  
69 
70 contract ELECTRONICPLATINUM is StandardToken {
71 
72     string public name;                   
73     uint8 public decimals;                
74     string public symbol;                 
75     string public version = 'H1.0';       
76 
77  
78     function ELECTRONICPLATINUM(
79         ) {
80         balances[msg.sender] = 2000000000000000;              
81         totalSupply = 2000000000000000;                       
82         name = "ELECTRONIC PLATINUM";                                   
83         decimals = 8;                            
84         symbol = "EPL";                               
85     }
86  
87 
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
93         return true;
94     }
95 }