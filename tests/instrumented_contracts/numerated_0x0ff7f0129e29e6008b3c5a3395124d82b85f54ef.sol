1 pragma solidity ^0.4.25;
2     contract TMBToken  {
3         string public constant name = "TimeBankToken";
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
60             
61             
62             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63                 uint _freeAmount = freeAmount(msg.sender);
64                 if (_freeAmount < _value) {
65                     return false;
66                 } 
67  
68                 balances[msg.sender] -= _value;
69                 balances[_to] += _value;
70                 Transfer(msg.sender, _to, _value);
71                 return true;
72             } else {
73                 return false;
74             }
75         }
76         
77         function addTokenTotal(uint256 _addAmount) public returns (bool success){
78     require(msg.sender == founder);                        
79     require(_addAmount > 0);                             
80         
81     _totalSupply += _addAmount * 10 ** decimals;           
82     balances[msg.sender] += _addAmount * 10 ** decimals;  
83     return true;
84 }  
85     function unFreezenAccount(address _freezen) public returns (bool success) {
86         require(msg.sender == founder);       
87         
88         freezed[_freezen] = false;
89         return true;
90     }
91     
92     function burn(uint256 _value) public returns (bool success) {
93         require(msg.sender == founder);                  
94         require(balances[msg.sender] >= _value);      
95         balances[msg.sender] -= _value;
96         _totalSupply -= _value;
97         Burn(msg.sender, _value);
98         return true;
99     }
100     
101    
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(msg.sender == founder);                  
104         require(balances[_from] >= _value);            
105         require(_value <= allowed[_from][msg.sender]);  
106         balances[_from] -= _value;
107         allowed[_from][msg.sender] -= _value;
108         _totalSupply -= _value;
109         Burn(_from, _value);
110         return true;
111     }
112 
113    
114 
115   function freezenAccount(address _freezen) public returns (bool success) {
116         require(msg.sender == founder);      
117         require(_freezen != founder);         
118     
119         freezed[_freezen] = true;
120         return true;
121     }
122 
123         function freeAmount(address user) returns (uint256 amount) {
124            
125             if (user == founder) {
126                 return balances[user];
127             }
128 
129             if (now < baseStartTime) {
130                 return 0;
131             }
132  
133          
134             uint monthDiff = (now - baseStartTime) / (30 days);
135  
136            
137             if (monthDiff > 5) {
138                 return balances[user];
139             }
140  
141            
142             uint unrestricted = distBalances[user] / 10 + distBalances[user] * 20 / 100 * monthDiff;
143             if (unrestricted > distBalances[user]) {
144                 unrestricted = distBalances[user];
145             }
146  
147            
148             if (unrestricted + balances[user] < distBalances[user]) {
149                 amount = 0;
150             } else {
151                 amount = unrestricted + (balances[user] - distBalances[user]);
152             }
153  
154             return amount;
155         }
156  
157        
158         function changeFounder(address newFounder) {
159             if (msg.sender!=founder) revert();
160             founder = newFounder;
161         }
162  
163         
164         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
165             require(_to != address(0));
166             if (freezed[_from]) revert();
167             if (freezed[_to]) revert();
168             
169             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
170                 uint _freeAmount = freeAmount(_from);
171                 if (_freeAmount < _value) {
172                     return false;
173                 } 
174  
175                 balances[_to] += _value;
176                 balances[_from] -= _value;
177                 allowed[_from][msg.sender] -= _value;
178                 Transfer(_from, _to, _value);
179                 return true;
180             } else { return false; }
181         }
182         function kill() public {
183         require(msg.sender == founder);
184         selfdestruct(founder);
185         }
186 
187         function() payable {
188             if (!founder.call.value(msg.value)()) revert(); 
189         }
190     }