1 pragma solidity ^0.4.16;
2 contract Token {
3 
4     
5     function totalSupply() constant returns (uint256 supply) {}
6 
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
32      
33         if (balances[msg.sender] >= _value && _value > 0) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42       
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
44             balances[_to] += _value;
45             balances[_from] -= _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 
71 
72 
73 contract DevOrb is StandardToken {
74 
75     function () {
76         throw;
77     }
78 
79  
80     string public name;                   
81     uint8 public decimals;                
82     string public symbol;                 
83     string public version = 'H1.0';       
84 
85 
86 
87 
88     function DevOrb(
89         ) {
90         balances[msg.sender] = 420000000000000000000;              
91         totalSupply = 420000000000000000000;                        
92         name = "DevOrb";                                   
93         decimals = 18;                            
94         symbol = "DORB";                               
95     }
96 
97     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100 
101        
102         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
103         return true;
104     }
105 }