1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------------------------
4 // MANHATTAN:PROXY BY KEVIN ABOSCH ©2018
5 // 1ST AVENUE (10,000 ERC-20 TOKENS)
6 // VERIFY SMART CONTRACT ADDRESS WITH LIST AT HTTP://MANHATTANPROXY.COM
7 // ----------------------------------------------------------------------------------------------
8 
9 
10 contract Token {
11 
12     
13     function totalSupply() constant returns (uint256 supply) {}
14 
15     
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17 
18     
19     function transfer(address _to, uint256 _value) returns (bool success) {}
20 
21     
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     
25     function approve(address _spender, uint256 _value) returns (bool success) {}
26 
27    
28     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32     
33 }
34 
35 
36 
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         
41         if (balances[msg.sender] >= _value && _value > 0) {
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             Transfer(msg.sender, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77 }
78 
79 
80 
81 contract MANHATTANPROXY1STAVE is StandardToken {
82 
83     function () {
84        
85         throw;
86     }
87 
88     
89 
90     
91     string public name;                   
92     uint8 public decimals;                
93     string public symbol;                 
94     string public version = 'H1.0';       
95 
96 
97     function MANHATTANPROXY1STAVE (
98         ) {
99         totalSupply = 10000;                        
100         balances[msg.sender] = 10000;               
101         name = "MP1STAV";                                             
102         decimals = 0;                            
103         symbol = "MP1STAV";                               
104     }
105 
106     /* Approves and then calls the receiving contract */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110 
111         
112         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
113         return true;
114     }
115 }