1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5    
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10   
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13    
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16  
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18 
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
32         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
33         if (balances[msg.sender] >= _value && _value > 0) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         //same as above. Replace this line with the following if you want to protect against wrapping uints.
43         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
74 contract CorruptionCoin is StandardToken {
75 
76     function () {
77         
78         throw;
79     }
80 
81   
82     string public name;                   //fancy name: eg Simon Bucks
83     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
84     string public symbol;                 //An identifier: eg SBX
85     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
86 
87 
88 
89 
90 
91     function CorruptionCoin(
92         ) {
93         balances[msg.sender] = 1000000000000;               // Give the creator all initial tokens (100000 for example)
94         totalSupply = 1000000000000;                        // Update total supply (100000 for example)
95         name = "CorruptionCoin";                                   // Set the name for display purposes
96         decimals = 0;                            // Amount of decimals for display purposes
97         symbol = "CRTC";                               // Set the symbol for display purposes
98     }
99 
100  
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         
106     
107         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
108         return true;
109     }
110 }