1 pragma solidity ^0.4.4;
2 
3 contract Token 
4 {
5 
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
13 
14     function approve(address _spender, uint256 _value) returns (bool success) {}
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 
24 contract StandardToken is Token 
25 {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) 
28     {
29 
30         if (balances[msg.sender] >= _value && _value > 0) 
31         {
32             balances[msg.sender] -= _value;
33             
34             balances[_to] += _value;
35             
36             Transfer(msg.sender, _to, _value);
37             
38             return true;
39         } 
40         else 
41         { 
42             return false; 
43         }
44 
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
48     {
49 
50         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) 
51         {
52             balances[_to] += _value;
53             
54             balances[_from] -= _value;
55             
56             allowed[_from][msg.sender] -= _value;
57             
58             Transfer(_from, _to, _value);
59             
60             return true;
61         } 
62         else 
63         { 
64             return false; 
65         }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) 
69     {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) 
74     {
75         allowed[msg.sender][_spender] = _value;
76         
77         Approval(msg.sender, _spender, _value);
78         
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
83     {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     
89     mapping (address => mapping (address => uint256)) allowed;
90     
91     uint256 public totalSupply;
92 }
93 
94 
95 
96 contract Grand is StandardToken 
97 {
98 
99     function () { revert(); }
100 
101     string public name = "Grand"; 
102     
103     uint8  public decimals = 0;               
104     
105     string public symbol = "G";
106     
107     string public version = "1.0"; 
108 
109 
110     function Grand ()       
111     {
112         balances[msg.sender] = 8888888888888888;
113         
114         totalSupply = 8888888888888888;
115         
116         name = "Grand";
117         
118         decimals = 0;
119         
120         symbol = "G";
121     }
122 
123 
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success)
125     {
126    
127         allowed[msg.sender][_spender] = _value;
128         
129         Approval(msg.sender, _spender, _value);
130 
131         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) 
132         
133         { revert(); }
134         
135         return true;
136     }
137 }