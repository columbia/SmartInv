1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------------------------
4 // ŠLJIVA - A CRYPTO PROJECT FOR SERBIA - KEVIN ABOSCH
5 // ----------------------------------------------------------------------------------------------
6 
7 contract Token {
8 
9     
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15     
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
20 
21     
22     function approve(address _spender, uint256 _value) returns (bool success) {}
23 
24    
25     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
26 
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     
30 }
31 
32 
33 
34 contract StandardToken is Token {
35 
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47         
48         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
49             balances[_to] += _value;
50             balances[_from] -= _value;
51             allowed[_from][msg.sender] -= _value;
52             Transfer(_from, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68       return allowed[_owner][_spender];
69     }
70 
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     uint256 public totalSupply;
74 }
75 
76 
77 
78 contract SLJIVA is StandardToken {
79 
80     function () {
81        
82         throw;
83     }
84 
85     
86 
87     
88     string public name;                   
89     uint8 public decimals;                
90     string public symbol;                 
91     string public version = 'H1.0';       
92 
93 
94     function SLJIVA(
95         ) {
96         totalSupply = 10000000000000000000000000;                        
97         balances[msg.sender] = 10000000000000000000000000;               
98         name = "SLJIVA";                                             
99         decimals = 18;                            
100         symbol = "SLJ";                               
101     }
102 
103     /* Approves and then calls the receiving contract */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107 
108         
109         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
110         return true;
111     }
112 }