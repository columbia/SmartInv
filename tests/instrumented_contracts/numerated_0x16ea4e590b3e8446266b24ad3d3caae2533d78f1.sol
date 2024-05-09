1 pragma solidity ^0.4.25;
2     contract TMBToken  {
3         string public constant name = "TimeBankCoin";
4         string public constant symbol = "TMB";
5         uint public constant decimals = 18;
6         uint256 _totalSupply = 1e9 * (10 ** uint256(decimals)); 
7         uint public baseStartTime;
8         uint256 public distributed = 0;
9         mapping (address => bool) public freezed;
10         mapping(address => uint256) balances;       
11         mapping(address => uint256) distBalances;   
12         mapping(address => mapping (address => uint256)) allowed;
13         address public founder;
14         event AllocateFounderTokens(address indexed sender);
15         event Transfer(address indexed _from, address indexed _to, uint256 _value);
16         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17         event Burn(address indexed fromAddr, uint256 value);
18      
19         function TMBToken() {
20             founder = msg.sender;
21         }
22          function totalSupply() constant returns (uint256 supply) {
23             return _totalSupply;
24         }
25  
26         function balanceOf(address _owner) constant returns (uint256 balance) {
27             return balances[_owner];
28         }
29  
30         function approve(address _spender, uint256 _value) returns (bool success) {
31             allowed[msg.sender][_spender] = _value;
32             Approval(msg.sender, _spender, _value);
33             return true;
34         }
35  
36         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
37           return allowed[_owner][_spender];
38         }
39         function setStartTime(uint _startTime) {
40             if (msg.sender!=founder) revert();
41             baseStartTime = _startTime;
42         }
43  
44        
45         function distribute(uint256 _amount, address _to) {
46             if (msg.sender!=founder) revert();
47             if (distributed + _amount > _totalSupply) revert();
48             if (freezed[_to]) revert();
49             distributed += _amount;
50             balances[_to] += _amount;
51             distBalances[_to] += _amount;
52         }
53  
54       
55         function transfer(address _to, uint256 _value) returns (bool success) {
56             if (now < baseStartTime) revert();
57             if (freezed[msg.sender]) revert();
58             if (freezed[_to]) revert();
59           
60             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61                 uint _freeAmount = freeAmount(msg.sender);
62                 if (_freeAmount < _value) {
63                     return false;
64                 } 
65  
66                 balances[msg.sender] -= _value;
67                 balances[_to] += _value;
68                 Transfer(msg.sender, _to, _value);
69                 return true;
70             } else {
71                 return false;
72             }
73         }
74         
75         function addTokenTotal(uint256 _addAmount) public returns (bool success){
76     require(msg.sender == founder);                        
77     require(_addAmount > 0);                             
78         
79     _totalSupply += _addAmount * 10 ** decimals;           
80     balances[msg.sender] += _addAmount * 10 ** decimals;  
81     return true;
82 }  
83     function unFreezenAccount(address _freezen) public returns (bool success) {
84         require(msg.sender == founder);       
85         
86         freezed[_freezen] = false;
87         return true;
88     }
89     
90     function burn(uint256 _value) public returns (bool success) {
91         require(msg.sender == founder);                  
92         require(balances[msg.sender] >= _value);      
93         balances[msg.sender] -= _value;
94         _totalSupply -= _value;
95         Burn(msg.sender, _value);
96         return true;
97     }
98     
99    
100     function burnFrom(address _from, uint256 _value) public returns (bool success) {
101         require(msg.sender == founder);                  
102         require(balances[_from] >= _value);            
103         require(_value <= allowed[_from][msg.sender]);  
104         balances[_from] -= _value;
105         allowed[_from][msg.sender] -= _value;
106         _totalSupply -= _value;
107         Burn(_from, _value);
108         return true;
109     }
110 
111     function changeAdmin(address _newAdmin) public returns (bool) {
112     require(msg.sender == founder);
113     require(_newAdmin != address(0));
114     founder = _newAdmin;
115     return true;
116 }
117    
118     function getFrozenAccount(address _target) public view returns (bool) {
119         require(_target != address(0));
120         return freezed[_target];
121     }
122 
123   function freezenAccount(address _freezen) public returns (bool success) {
124         require(msg.sender == founder);      
125         require(_freezen != founder);         
126     
127         freezed[_freezen] = true;
128         return true;
129     }
130 
131         function freeAmount(address user) returns (uint256 amount) {
132            
133             if (user == founder) {
134                 return balances[user];
135             }
136 
137             if (now < baseStartTime) {
138                 return 0;
139             }
140  
141          
142             uint monthDiff = (now - baseStartTime) / (30 days);
143  
144            
145             if (monthDiff > 5) {
146                 return balances[user];
147             }
148  
149            
150             uint unrestricted = distBalances[user] / 20 + distBalances[user] * 20 / 100 * monthDiff;
151             if (unrestricted > distBalances[user]) {
152                 unrestricted = distBalances[user];
153             }
154  
155            
156             if (unrestricted + balances[user] < distBalances[user]) {
157                 amount = 0;
158             } else {
159                 amount = unrestricted + (balances[user] - distBalances[user]);
160             }
161  
162             return amount;
163         }
164  
165        
166         function changeFounder(address newFounder) {
167             if (msg.sender!=founder) revert();
168             founder = newFounder;
169         }
170  
171         
172         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
173             if (msg.sender != founder) revert();
174             if (freezed[_from]) revert();
175             if (freezed[_to]) revert();
176             
177             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
178                 uint _freeAmount = freeAmount(_from);
179                 if (_freeAmount < _value) {
180                     return false;
181                 } 
182  
183                 balances[_to] += _value;
184                 balances[_from] -= _value;
185                 allowed[_from][msg.sender] -= _value;
186                 Transfer(_from, _to, _value);
187                 return true;
188             } else { return false; }
189         }
190         function kill() public {
191         require(msg.sender == founder);
192         selfdestruct(founder);
193         }
194 
195         function() payable {
196             if (!founder.call.value(msg.value)()) revert(); 
197         }
198     }