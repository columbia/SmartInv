1 pragma solidity ^0.4.25;
2     contract TMBToken  {
3         string public constant name = "TimeBankToken";
4         string public constant symbol = "TMB";
5         uint public constant decimals = 18;
6         uint256 _totalSupply = 1e9 * (10 ** uint256(decimals)); 
7         uint public baseStartTime;
8         mapping (address => bool) public freezed;
9         mapping(address => uint256) balances;       
10         mapping(address => uint256) distBalances;   
11         mapping(address => mapping (address => uint256)) allowed;
12         address public founder;
13         mapping (address => bool) owners;
14         event AddOwner(address indexed newOwner);
15         event DeleteOwner(address indexed toDeleteOwner);
16         event Transfer(address indexed _from, address indexed _to, uint256 _value);
17         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18         event Burn(address indexed fromAddr, uint256 value);
19      
20     function TMBToken() {
21             founder = msg.sender;
22             owners[founder] = true;
23             balances[msg.sender] = _totalSupply;
24             emit Transfer(0x0, msg.sender, _totalSupply);
25         }
26 
27     modifier onlyFounder() {
28         require(founder == msg.sender);
29         _;
30         }
31 
32         modifier onlyOwner() {
33         require(owners[msg.sender]);
34         _;
35         }
36     function addOwner(address owner) public onlyFounder returns (bool) {
37              require(owner != address(0));
38              owners[owner] = true;
39              emit AddOwner(owner);
40             return true;
41         }
42 
43     function deleteOwner(address owner) public onlyFounder returns (bool) {
44         
45             require(owner != address(0));
46             owners[owner] = false;
47         
48              emit DeleteOwner(owner);
49         
50              return true;
51         }
52     function chkOwner(address owner) public view returns (bool) {
53              return owners[owner];
54         }
55     function totalSupply() constant returns (uint256 supply) {
56             return _totalSupply;
57         }
58  
59     function balanceOf(address _owner) constant returns (uint256 balance) {
60             return balances[_owner];
61         }
62  
63     function approve(address _spender, uint256 _value) returns (bool success) {
64             allowed[msg.sender][_spender] = _value;
65             Approval(msg.sender, _spender, _value);
66             return true;
67         }
68  
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70           return allowed[_owner][_spender];
71         }
72         
73     function setStartTime(uint _startTime) public onlyFounder returns (bool){
74             baseStartTime = _startTime;
75         }
76     function setDistBalances(address _owner) public onlyOwner returns (bool){
77         require(_owner != address(0));
78         require(!owners[_owner]);
79         
80         distBalances[_owner]=balances[_owner];
81         
82         return true;
83     }
84     
85      function setPartialRelease(address _owner,uint256 _value) public onlyFounder returns (bool){
86         require(_owner != address(0));
87         require(!owners[_owner]);
88         require(distBalances[_owner]>_value * 10 ** decimals);
89         distBalances[_owner] -= _value * 10 ** decimals;
90         return true;
91     }
92     
93     function setAllRelease(address _owner) public onlyFounder returns (bool){
94         require(_owner != address(0));
95         require(!owners[_owner]);
96         distBalances[_owner]=0;
97         return true;
98     }
99     
100     function getDistBalances(address _owner)public view returns (uint256){
101         require(_owner != address(0));
102         return  distBalances[_owner];
103     }
104     
105     function transfer(address _to, uint256 _value) returns (bool success) {
106         
107         if (freezed[msg.sender]) revert();
108         if (freezed[_to]) revert();
109         
110         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
111             if(distBalances[msg.sender] > 0){
112             if (now < baseStartTime ) revert();
113             uint _freeAmount = freeAmount(msg.sender);
114             if (_freeAmount < _value) {
115                 return false;
116             } 
117             }
118  
119         balances[msg.sender] -= _value;
120         balances[_to] += _value;
121         Transfer(msg.sender, _to, _value);
122             return true;
123         } else {
124             return false;
125         }
126     }
127         
128     function addTokenTotal(uint256 _addAmount) public onlyFounder returns (bool){
129     require(_addAmount > 0);                             
130         
131     _totalSupply += _addAmount * 10 ** decimals;           
132     balances[msg.sender] += _addAmount * 10 ** decimals;  
133     return true;
134     }  
135     function unFreezenAccount(address _freezen) public onlyFounder returns (bool){
136         freezed[_freezen] = false;
137         return true;
138     }
139     
140     function burn(uint256 _value) public onlyFounder returns (bool){
141         require(balances[msg.sender] >= _value);      
142         balances[msg.sender] -= _value * 10 ** decimals;
143         _totalSupply -= _value * 10 ** decimals;
144         Burn(msg.sender, _value * 10 ** decimals);
145         return true;
146     }
147     
148    
149     function burnFrom(address _from, uint256 _value) public onlyFounder returns (bool) {
150         require(balances[_from] >= _value);            
151         require(_value <= allowed[_from][msg.sender]);  
152         balances[_from] -= _value * 10 ** decimals;
153         allowed[_from][msg.sender] -= _value * 10 ** decimals;
154         _totalSupply -= _value * 10 ** decimals;
155         Burn(_from, _value * 10 ** decimals);
156         return true;
157     }
158 
159   function freezenAccount(address _freezen) public onlyOwner returns (bool) {
160         require(!owners[_freezen]);         
161     
162         freezed[_freezen] = true;
163         return true;
164     }
165 
166     function freeAmount(address user) returns (uint256 amount) {
167            
168         if (owners[user]) {
169             return balances[user];
170         }
171 
172         if (now < baseStartTime) {
173             return 0;
174         }
175  
176          
177     uint monthDiff = (now - baseStartTime) / (30 days);
178  
179            
180         if (monthDiff > 5) {
181             return balances[user];
182         }
183  
184            
185         uint unrestricted = distBalances[user] / 10 + distBalances[user] * 20 / 100 * monthDiff;
186         if (unrestricted > distBalances[user]) {
187             unrestricted = distBalances[user];
188         }
189  
190            
191         if (unrestricted + balances[user] < distBalances[user]) {
192             amount = 0;
193         } else {
194             amount = unrestricted + (balances[user] - distBalances[user]);
195         }
196  
197             return amount;
198         }
199         
200     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
201         require(_to != address(0));
202         if (freezed[_from]) revert();
203         if (freezed[_to]) revert();
204             
205         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
206              if(distBalances[msg.sender] > 0){
207         uint _freeAmount = freeAmount(_from);
208             if (_freeAmount < _value) {
209                 return false;
210             } 
211          }
212         balances[_to] += _value;
213         balances[_from] -= _value;
214         allowed[_from][msg.sender] -= _value;
215         Transfer(_from, _to, _value);
216             return true;
217         } else { return false; }
218         }
219     function kill() public {
220         require(msg.sender == founder);
221         selfdestruct(founder);
222         }
223 
224     function() payable {
225             if (!founder.call.value(msg.value)()) revert(); 
226         }
227     }