1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------------------------
4 // PRICELESS - KEVIN ABOSCH / AI WEIWEI 
5 // ----------------------------------------------------------------------------------------------
6 
7 
8 contract Token {
9 
10     
11     function totalSupply() constant returns (uint256 supply) {}
12 
13     
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22     
23     function approve(address _spender, uint256 _value) returns (bool success) {}
24 
25    
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30     
31 }
32 
33 
34 
35 contract StandardToken is Token {
36 
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         
39         if (balances[msg.sender] >= _value && _value > 0) {
40             balances[msg.sender] -= _value;
41             balances[_to] += _value;
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         
49         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
50             balances[_to] += _value;
51             balances[_from] -= _value;
52             allowed[_from][msg.sender] -= _value;
53             Transfer(_from, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function balanceOf(address _owner) constant returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     function approve(address _spender, uint256 _value) returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70     }
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     uint256 public totalSupply;
75 }
76 
77 
78 
79 contract PRICELESS is StandardToken {
80 
81     function () {
82        
83         throw;
84     }
85 
86     
87 
88     
89     string public name;                   
90     uint8 public decimals;                
91     string public symbol;                 
92     string public version = 'H1.0';       
93 
94 
95     function PRICELESS() {
96         totalSupply = 2000000000000000000;                        
97         balances[msg.sender] = 2000000000000000000;               
98         name = "PRICELESS";                                             
99         decimals = 18;                            
100         symbol = "PRCLS";                               
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