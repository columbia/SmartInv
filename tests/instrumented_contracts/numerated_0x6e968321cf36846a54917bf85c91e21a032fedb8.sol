1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20 }
21 
22 
23 
24 contract StandardToken is Token {
25 
26     function transfer(address _to, uint256 _value) returns (bool success) {
27        
28         if (balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37         
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     uint256 public totalSupply;
64 }
65 
66 
67 //Omeno Token
68 contract OmenoToken is StandardToken {
69 
70     function () {
71         throw;
72     }
73 
74     /* Public variables of the token */
75 
76     /*
77     Omeno Token
78     */
79     string public name;                   
80     uint8 public decimals;                 
81     string public symbol;                
82     string public version = 'H1.0';       
83 
84 //
85 //
86 
87 //make sure Omeno is source
88 
89     function OmenoToken(
90         ) {
91         balances[msg.sender] = 137535000000000000000000;               
92         totalSupply = 137535000000000000000000;                        
93         name = "Omeno Token";                                 
94         decimals = 18;                            
95         symbol = "OME";                              
96     }
97 
98     /* Approves and then calls the receiving contract */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102 
103         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
104         return true;
105     }
106 }