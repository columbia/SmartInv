1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5   
6     function totalSupply() constant returns (uint256 supply) {}
7 
8    
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11   
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14    
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
16 
17    
18     function approve(address _spender, uint256 _value) returns (bool success) {}
19 
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25 }
26 
27 
28 
29 contract StandardToken is Token {
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {
32             if (balances[msg.sender] >= _value && _value > 0) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41        
42         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43             balances[_to] += _value;
44             balances[_from] -= _value;
45             allowed[_from][msg.sender] -= _value;
46             Transfer(_from, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62       return allowed[_owner][_spender];
63     }
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67     uint256 public totalSupply;
68 }
69 
70 contract TGxToken is StandardToken {
71 
72     function () {
73        
74         throw;
75     }
76 
77   
78     string public name;                   
79     uint8 public decimals;                
80     string public symbol;                
81     string public version = '1.0';       
82 
83     function TGxToken(
84         ) {
85         balances[msg.sender] =300000000000000000000000000 ;              
86         totalSupply =300000000000000000000000000 ;                       
87         name = "Fly Dog TGX Token";                                   
88         decimals = 18;                            
89         symbol = "TGx";                             
90     }
91 
92 
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
97         return true;
98     }
99 }