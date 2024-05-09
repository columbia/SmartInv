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
20    
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     
26 }
27 
28 
29 
30 contract StandardToken is Token {
31 
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43         
44         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
45             balances[_to] += _value;
46             balances[_from] -= _value;
47             allowed[_from][msg.sender] -= _value;
48             Transfer(_from, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public totalSupply;
70 }
71 
72 
73 
74 contract IAMACOIN is StandardToken {
75 
76     function () {
77        
78         throw;
79     }
80 
81     
82 
83     
84     string public name;                   
85     uint8 public decimals;                
86     string public symbol;                 
87     string public version = 'H1.0';       
88 
89 
90     function IAMACOIN(
91         ) {
92         totalSupply = 10000000000000000000000000;                        
93         balances[msg.sender] = 10000000000000000000000000;               
94         name = "IAMACOIN";                                             
95         decimals = 18;                            
96         symbol = "IAMA";                               
97     }
98 
99     /* Approves and then calls the receiving contract */
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103 
104         
105         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
106         return true;
107     }
108 }