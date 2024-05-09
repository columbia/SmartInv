1 pragma solidity ^0.4.8;
2 
3    
4 
5 interface ERC20Interface {
6 
7    
8 
9     function totalSupply() constant returns (uint256 totalSupply) ;
10 
11        
12 
13     function balanceOf(address _owner) constant returns (uint256 balance);
14 
15        
16 
17     function transfer(address _to, uint256 _value) returns (bool success);
18 
19        
20 
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22 
23        
24 
25     function approve(address _spender, uint256 _value) returns (bool success);
26 
27        
28 
29     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30 
31        
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35        
36 
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39        
40 
41  }
42 
43      
44 
45  contract BRC is ERC20Interface {
46 
47       string public constant symbol = "BRC";
48 
49       string public constant name = "Baer Chain";
50 
51       uint8 public constant decimals = 8;
52 
53       uint256 _totalSupply = 58000000000000000;
54 
55     
56 
57       address public owner;
58 
59       
60 
61       mapping(address => uint256) balances;
62 
63       
64 
65     
66 
67       mapping(address => mapping (address => uint256)) allowed;
68 
69       
70 
71          
72 
73       modifier onlyOwner() {
74 
75           if (msg.sender != owner) {
76 
77               throw;
78 
79           }
80 
81           _;
82 
83       }
84 
85       
86 
87       function BRC() {
88 
89           owner = msg.sender;
90 
91           balances[owner] = _totalSupply;
92 
93       }
94 
95       
96 
97       function totalSupply() constant returns (uint256 totalSupply) {
98 
99           totalSupply = _totalSupply;
100 
101       }
102 
103       
104 
105       function balanceOf(address _owner) constant returns (uint256 balance) {
106 
107           return balances[_owner];
108 
109       }
110 
111       
112 
113       function transfer(address _to, uint256 _amount) returns (bool success) {
114 
115           if (balances[msg.sender] >= _amount 
116 
117               && _amount > 0
118 
119               && balances[_to] + _amount > balances[_to]) {
120 
121               balances[msg.sender] -= _amount;
122 
123               balances[_to] += _amount;
124 
125               Transfer(msg.sender, _to, _amount);
126 
127               return true;
128 
129           } else {
130 
131               return false;
132 
133           }
134 
135       }
136 
137       
138 
139       function transferFrom(
140 
141           address _from,
142 
143           address _to,
144 
145           uint256 _amount
146 
147      ) returns (bool success) {
148 
149          if (balances[_from] >= _amount
150 
151              && allowed[_from][msg.sender] >= _amount
152 
153              && _amount > 0
154 
155              && balances[_to] + _amount > balances[_to]) {
156 
157              balances[_from] -= _amount;
158 
159              allowed[_from][msg.sender] -= _amount;
160 
161              balances[_to] += _amount;
162 
163              Transfer(_from, _to, _amount);
164 
165              return true;
166 
167          } else {
168 
169              return false;
170 
171          }
172 
173      }
174 
175    
176 
177      function approve(address _spender, uint256 _amount) returns (bool success) {
178 
179          allowed[msg.sender][_spender] = _amount;
180 
181          Approval(msg.sender, _spender, _amount);
182 
183          return true;
184 
185      }
186 
187      
188 
189      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
190 
191          return allowed[_owner][_spender];
192 
193      }
194 
195  }