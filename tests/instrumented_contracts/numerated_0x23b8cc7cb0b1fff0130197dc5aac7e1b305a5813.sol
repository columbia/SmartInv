1 pragma solidity ^0.4.4;
2 
3  
4 
5 contract Token {
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
18 
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
20 
21  
22 
23     function approve(address _spender, uint256 _value) returns (bool success) {}
24 
25  
26 
27     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
28 
29  
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32 
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35  
36 
37 }
38 
39  
40 
41 contract HashgainsToken is Token {
42 
43  
44 
45  
46 
47     string public name;              
48 
49     uint8 public decimals;               
50 
51     string public symbol;                
52 
53     string public version = 'H1.0';
54 
55     uint256 public unitsOneEthCanBuy;    
56 
57     uint256 public totalEthInWei;        
58 
59     address public fundsWallet; 
60 
61     mapping (address => uint256) balances;
62 
63     mapping (address => mapping (address => uint256)) allowed;
64 
65     uint256 public totalSupply;
66 
67    
68 
69     function transfer(address _to, uint256 _value) returns (bool success) {
70 
71         if (balances[msg.sender] >= _value && _value > 0) {
72 
73             balances[msg.sender] -= _value;
74 
75             balances[_to] += _value;
76 
77             Transfer(msg.sender, _to, _value);
78 
79             return true;
80 
81         } else { return false; }
82 
83     }
84 
85  
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88 
89          if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
90 
91             balances[_to] += _value;
92 
93             balances[_from] -= _value;
94 
95             allowed[_from][msg.sender] -= _value;
96 
97             Transfer(_from, _to, _value);
98 
99             return true;
100 
101         } else { return false; }
102 
103     }
104 
105  
106 
107     function balanceOf(address _owner) constant returns (uint256 balance) {
108 
109         return balances[_owner];
110 
111     }
112 
113  
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116 
117         allowed[msg.sender][_spender] = _value;
118 
119         Approval(msg.sender, _spender, _value);
120 
121         return true;
122 
123     }
124 
125  
126 
127     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128 
129       return allowed[_owner][_spender];
130 
131     }
132 
133  
134 
135   
136 
137     function HashgainsToken() {
138 
139         balances[msg.sender] = 50000000000000000000000000;              
140 
141         totalSupply = 50000000000000000000000000;                       
142 
143         name = "HashgainsToken";                                   
144 
145         decimals = 18;                                              
146 
147         symbol = "HGS";                                            
148 
149         unitsOneEthCanBuy = 1000;                                  
150 
151         fundsWallet = msg.sender;                                  
152 
153     }
154 
155  
156 
157     function() payable{
158 
159         totalEthInWei = totalEthInWei + msg.value;
160 
161         uint256 amount = msg.value * unitsOneEthCanBuy;
162 
163         if (balances[fundsWallet] < amount) {
164 
165             return;
166 
167         }
168 
169  
170 
171         balances[fundsWallet] = balances[fundsWallet] - amount;
172 
173         balances[msg.sender] = balances[msg.sender] + amount;
174 
175  
176 
177         Transfer(fundsWallet, msg.sender, amount);
178 
179         fundsWallet.transfer(msg.value);                               
180 
181     }
182 
183     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
184 
185         allowed[msg.sender][_spender] = _value;
186 
187         Approval(msg.sender, _spender, _value);
188 
189  
190 
191         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
192 
193         return true;
194 
195     }
196 
197    
198 
199     
200 
201 }