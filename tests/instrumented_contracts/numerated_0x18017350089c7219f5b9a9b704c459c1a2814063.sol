1 pragma solidity ^0.4.20;
2 
3 contract Token {
4 
5 
6 
7     function totalSupply() constant returns (uint256 supply) {}
8 
9 
10 
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13 
14 
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17 
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19 
20 
21     function approve(address _spender, uint256 _value) returns (bool success) {}
22 
23 
24   
25 
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
27 
28 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33 
34 }
35 
36 
37 contract StandardToken is Token {
38 
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {
41 
42 
43         if (balances[msg.sender] >= _value && _value > 0) {
44 
45             balances[msg.sender] -= _value;
46 
47             balances[_to] += _value;
48 
49             Transfer(msg.sender, _to, _value);
50 
51             return true;
52 
53         } else { return false; }
54 
55     }
56 
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59 
60       
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62 
63             balances[_to] += _value;
64 
65             balances[_from] -= _value;
66 
67             allowed[_from][msg.sender] -= _value;
68 
69             Transfer(_from, _to, _value);
70 
71             return true;
72 
73         } else { return false; }
74 
75     }
76 
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79 
80         return balances[_owner];
81 
82     }
83 
84 
85     function approve(address _spender, uint256 _value) returns (bool success) {
86 
87         allowed[msg.sender][_spender] = _value;
88 
89         Approval(msg.sender, _spender, _value);
90 
91         return true;
92 
93     }
94 
95 
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97 
98       return allowed[_owner][_spender];
99 
100     }
101 
102 
103     mapping (address => uint256) balances;
104 
105     mapping (address => mapping (address => uint256)) allowed;
106 
107     uint256 public totalSupply;
108 
109 }
110 
111 
112 
113 
114 contract ERC20Token is StandardToken {
115 
116 
117     function () {
118 
119       
120 
121         throw;
122 
123     }
124 
125 
126 
127     string public name;                   //fancy name: eg Simon Bucks
128 
129     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
130 
131     string public symbol;                 //An identifier: eg SBX
132 
133     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
134 
135 
136 
137     function ERC20Token(
138 
139         ) {
140 
141         balances[msg.sender] = 100000000000;               // Give the creator all initial tokens (100000 for example)
142 
143         totalSupply = 100000000000;                        // Update total supply (100000 for example)
144 
145         name = "Loopex Token";                                   // Set the name for display purposes
146 
147         decimals = 2;                            // Amount of decimals for display purposes
148 
149         symbol = "XLP";                               // Set the symbol for display purposes
150 
151     }
152 
153 
154 
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
156 
157         allowed[msg.sender][_spender] = _value;
158 
159         Approval(msg.sender, _spender, _value);
160 
161 
162 
163         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
164 
165         return true;
166 
167     }
168 
169 }