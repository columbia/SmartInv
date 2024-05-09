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
28 contract Owned {
29     address public owner;
30 
31     function owned() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         owner = newOwner;
42     }
43 }
44 
45 contract StandardToken is Token, Owned {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48        
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67     
68     function distributeToken(address[] addresses, uint256 _value) {
69      for (uint i = 0; i < addresses.length; i++) {
70          balances[msg.sender] -= _value;
71          balances[addresses[i]] += _value;
72          Transfer(msg.sender, addresses[i], _value);
73      }
74 }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89     
90    
91     
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94     
95     
96     uint256 public totalSupply;
97 }
98 
99 
100 
101 contract B2X is StandardToken {
102 
103     function () {
104         
105         throw;
106     }
107 
108     
109     string public name;                   
110     uint8 public decimals;                
111     string public symbol;                 
112            
113 
114     function B2X(
115         ) {
116         totalSupply = 21 * 10 ** 14;
117         balances[msg.sender] = totalSupply;              
118         name = "BTC2X";                                   
119         decimals = 8;                            
120         symbol = "B2X";                               
121     }
122 
123 
124     
125 }