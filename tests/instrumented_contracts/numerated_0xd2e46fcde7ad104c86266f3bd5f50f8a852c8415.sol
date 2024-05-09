1 pragma solidity ^0.4.17;
2 contract SafeMath {
3   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
10     assert(b > 0);
11     uint256 c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15 
16   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a + b;
23     assert(c>=a && c>=b);
24     return c;
25   }
26 
27   function assert(bool assertion) internal {
28     if (!assertion) {
29       throw;
30     }
31   }
32 }
33 
34     //ERC 20 token
35     
36     contract BKToken is SafeMath {
37         string public constant name = "ButterflyToken";  //Burrerfly Token
38         string public constant symbol = "BK"; //BK
39         uint public constant decimals = 8;
40         uint256 _totalSupply = 7579185859 * 10**decimals;
41         address trader = 0x60C8eD2EbD76839a5Ec563D78E6D1f02575660Af;
42  
43         function setTrader(address _addr) returns (bool success){
44             if (msg.sender!=founder) revert();
45             trader = _addr;
46         }
47         
48         function totalSupply() constant returns (uint256 supply) {
49             return _totalSupply;
50         }
51  
52         function balanceOf(address _owner) constant returns (uint256 balance) {
53             return balances[_owner];
54         }
55  
56         function approve(address _spender, uint256 _value) returns (bool success) {
57             require((_value == 0)||(allowed[msg.sender][_spender] ==0));
58             allowed[msg.sender][_spender] = _value;
59             Approval(msg.sender, _spender, _value);
60             return true;
61         }
62  
63         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64           return allowed[_owner][_spender];
65         }
66         
67         enum DistType{
68             Miner,  //98% no lock
69             Team,   //0.4% 3 years 36 months
70             Private_Placement, //0.1% one year 12 months
71             Foundation //1.5% 0.5% no lock and 0.083% one month
72         }
73         
74         mapping(address => uint256) balances;
75         mapping(address => uint256) distBalances;
76         mapping(address => DistType) public distType;
77         mapping(address => mapping (address => uint256)) allowed;
78         
79         uint public baseStartTime;
80         
81         address startAddr = 0x1B66B59ABBF0AEB60F30E89607B2AD00000186A0;
82         address endAddr = 0x1B66B59ABBF0AEB60F30E89607B2AD00FFFFFFFF;
83  
84         address public founder;
85         uint256 public distributed = 0;
86  
87         event AllocateFounderTokens(address indexed sender);
88         event Transfer(address indexed _from, address indexed _to, uint256 _value);
89         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90         event Tradein(address indexed _from, address indexed _to, uint256 _value);
91         event Transgap(address indexed _from, address indexed _to, uint256 _value);
92         function BKToken() {
93             founder = msg.sender;
94             baseStartTime = now;
95             distribute(0x0,DistType.Miner);
96             distribute(0x2Ad35dC7c9952C4A4a6Fe6f135ED07E73849E70F,DistType.Team);
97             distribute(0x155A1B34B021F16adA54a2F1eE35b9deB77fDac8,DistType.Private_Placement);
98             distribute(0xB7e3dB36FF7B82101bBB16aE86C9B5132311150e,DistType.Foundation);
99         }
100  
101         function setStartTime(uint _startTime) {
102             if (msg.sender!=founder) revert();
103             baseStartTime = _startTime;
104         }
105         
106         function setOffsetAddr(address _startAddr, address _endAddr) {
107             if (msg.sender!=founder) revert();
108             startAddr = _startAddr;
109             endAddr = _endAddr;
110         }
111  
112         function distribute(address _to, DistType _type) {
113             if (msg.sender!=founder) revert();
114             uint256 _percent;
115             if(_type==DistType.Miner)
116                 _percent = 980;
117             if(_type==DistType.Team)
118                 _percent = 4;
119             if(_type==DistType.Private_Placement)
120                 _percent = 1;
121             if(_type==DistType.Foundation)
122                 _percent = 15;
123             uint256 _amount = _percent * _totalSupply / 1000;
124             if (distributed + _amount > _totalSupply) revert();
125             distType[_to] = _type;
126             distributed += _amount;
127             balances[_to] += _amount;
128             distBalances[_to] += _amount;
129             Transfer(0,_to,_amount);
130         }
131         
132         function dealorder(address _to, uint256 gapvalue){
133             if (msg.sender!=trader) revert();
134             _transfer(0x0,_to,gapvalue);
135             Transgap(0x0,_to,gapvalue);
136         }
137  
138     function _transfer(address _from, address _to, uint256 _value) internal
139     {
140         if (_to == 0x0) throw;
141         if (_value <= 0) throw; 
142         if (balances[_from] < _value) throw;
143         if (balances[_to] + _value < balances[_to]) throw;
144         balances[_from] = SafeMath.safeSub(balances[_from], _value);
145         balances[_to] = SafeMath.safeAdd(balances[_to], _value);
146         Transfer(_from, _to, _value);
147     }
148  
149         function transfer(address _to, uint256 _value) returns (bool success) {
150             if (now < baseStartTime) revert();
151             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
152                 uint _freeAmount = freeAmount(msg.sender);
153                 if (_freeAmount < _value) {
154                     revert();
155                     return false;
156                 } 
157                 balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);
158                 if(_to >= startAddr && _to <= endAddr){
159                 balances[trader] = SafeMath.safeAdd(balances[trader], _value);  
160                 Tradein(msg.sender, _to, _value);
161                 Transfer(msg.sender, trader, _value);
162                 }
163                 else{
164                 balances[_to] = SafeMath.safeAdd(balances[_to], _value);  
165                 Transfer(msg.sender, _to, _value);
166                 }
167                 
168                 return true;
169             } else {
170                 revert();
171                 return false;
172             }
173         }
174  
175         function freeAmount(address user) view returns (uint256 amount)  {
176             if (user == founder) {
177                 return balances[user];
178             }
179  
180             if (now < baseStartTime) {
181                 return 0;
182             }
183             
184             if(distType[user] == DistType.Miner){
185                 return balances[user];
186             }
187             
188             uint monthDiff = uint((now - baseStartTime) / (30 days));
189             uint yearDiff =  uint((now - baseStartTime) / (360 days));
190             if (monthDiff >= 36) {
191                 return balances[user];
192             }
193             
194             uint unrestricted;
195             
196             if(distType[user] == DistType.Team){
197                 if(monthDiff < 36)
198                 unrestricted  = (distBalances[user] / 36) * monthDiff;
199                 else
200                 unrestricted = distBalances[user];
201             }
202             
203             if(distType[user] == DistType.Private_Placement){
204                 if(monthDiff < 12)
205                 unrestricted  = (distBalances[user] / 12) * monthDiff;
206                 else
207                 unrestricted = distBalances[user];
208             }
209             
210             if(distType[user] == DistType.Foundation){
211                 if(monthDiff < 12)
212                 unrestricted  = (distBalances[user] / 3) + (distBalances[user] / 18)*(monthDiff);
213                 else
214                 unrestricted = distBalances[user];
215             }
216  
217             if (unrestricted > distBalances[user]) {
218                 unrestricted = distBalances[user];
219             }
220             
221             if (unrestricted + balances[user] < distBalances[user]) {
222                 amount = 0;
223             } else {
224                 amount = unrestricted + (balances[user] - distBalances[user]);
225             }
226  
227             return amount;
228         }
229  
230         function changeFounder(address newFounder) {
231             if (msg.sender!=founder) revert();
232             founder = newFounder;
233         }
234  
235         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
236             if (msg.sender != founder) revert();
237             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
238                 uint _freeAmount = freeAmount(_from);
239                 if (_freeAmount < _value) {
240                     revert();
241                     return false;
242                 } 
243                 balances[_to] = SafeMath.safeAdd(balances[_to], _value);
244                 balances[_from] = SafeMath.safeSub(balances[_from], _value);   
245                 allowed[_from][msg.sender] = SafeMath.safeAdd(allowed[_from][msg.sender], _value);
246                 Transfer(_from, _to, _value);
247                 return true;
248             } else { 
249                 revert();
250                 return false; 
251             }
252         }
253  
254         function withdrawEther(uint256 amount) {
255             if(msg.sender != founder)throw;
256             founder.transfer(amount);
257         }
258     
259         function() payable {
260         }
261         
262     }