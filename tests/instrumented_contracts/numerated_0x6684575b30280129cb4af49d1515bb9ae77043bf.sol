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
21     
22 }
23 
24 
25 contract StandardToken is Token 
26 {
27 
28     function transfer(address _to, uint256 _value) returns (bool success) 
29     {
30 
31         if (balances[msg.sender] >= _value && _value > 0) 
32         {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } 
38         else 
39         { 
40             return false; 
41         }
42 
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
46     {
47 
48         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) 
49         {
50             balances[_to] += _value;
51             
52             balances[_from] -= _value;
53             
54             allowed[_from][msg.sender] -= _value;
55             
56             Transfer(_from, _to, _value);
57             
58             return true;
59         } 
60         else 
61         { 
62             return false; 
63         }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) 
67     {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) 
72     {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
79     {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 
89 
90 contract TripleA is StandardToken 
91 {
92 
93     function () { revert(); }
94 
95     string public name = "Triple A"; 
96     
97     uint8  public decimals = 3;               
98     
99     string public symbol = "AAA";
100     
101     string public version = "1.0"; 
102 
103 
104 
105     function TripleA ()       
106     {
107         balances[msg.sender] = 8888800000000;
108         
109         totalSupply = 8888800000000;
110         
111         name = "Triple A";
112         
113         decimals = 8;
114         
115         symbol = "AAA";
116     }
117 
118 
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success)
120     {
121    
122         allowed[msg.sender][_spender] = _value;
123         
124         Approval(msg.sender, _spender, _value);
125 
126         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) 
127         
128         { revert(); }
129         
130         return true;
131     }
132 }