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
34         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
45         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
47             balances[_to] += _value;
48             balances[_from] -= _value;
49             allowed[_from][msg.sender] -= _value;
50             Transfer(_from, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function approve(address _spender, uint256 _value) returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
66       return allowed[_owner][_spender];
67     }
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     uint256 public totalSupply;
72 }
73 
74 
75 
76 contract PlatinumCoin is StandardToken {
77 
78     function () {
79         
80         throw;
81     }
82 
83    
84     string public name;                  
85     uint8 public decimals;                
86     string public symbol;                 
87     string public version = 'H1.0';       
88 
89 
90 
91 
92 
93     function PlatinumCoin(
94         ) {
95         balances[msg.sender] = 50000000;              
96         totalSupply = 50000000;                        
97         name = "Platinum Coin";                           
98         decimals = 0;                           
99         symbol = "PLT";                             
100     }
101 
102     
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106 
107        
108         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
109         
110         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
111         return true;
112     }
113 }