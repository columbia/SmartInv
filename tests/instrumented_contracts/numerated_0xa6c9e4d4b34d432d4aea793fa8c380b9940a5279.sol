1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44 }
45 
46 contract Token {
47     uint256 public totalSupply;
48     function balanceOf(address _owner) constant returns (uint256 balance);
49     function transfer(address _to, uint256 _value) returns (bool success);
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
51     function approve(address _spender, uint256 _value) returns (bool success);
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 /*  ERC 20 token */
59 contract StandardToken is Token {
60     
61     mapping (address => uint256) balances;    
62     mapping (address => mapping (address => uint256)) allowed;
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65       if (_to == 0x0) return false;
66       if (balances[msg.sender] >= _value && _value > 0) {
67         balances[msg.sender] -= _value;
68         balances[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71       } else {
72         return false;
73       }
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78         balances[_to] += _value;
79         balances[_from] -= _value;
80         allowed[_from][msg.sender] -= _value;
81         Transfer(_from, _to, _value);
82         return true;
83       } else {
84         return false;
85       }
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256){
93         return balances[_owner];
94     }
95 
96     /* Allow another contract to spend some tokens in your behalf */
97     function approve(address _spender, uint256 _value)
98         returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         return true;
101     }
102 }
103 
104 contract KairosToken is StandardToken {
105 
106   using SafeMath for uint256;
107   mapping(address => bool) frozenAccount;
108   mapping(address => uint256) bonus; 
109 
110   address public kairosOwner;
111   string  public constant name         = "KAIROS";
112   string  public constant symbol       = "KRX";
113   string  public constant version      = "1.0";
114   uint256 public constant decimals     = 18;  
115   uint256 public initialSupply         = 25 * (10**6) * 10**decimals;
116   uint256 public totalSupply;
117   uint256 public sellPrice;
118   uint256 public buyPrice;
119 
120   event CreateNertia(address indexed _to, uint256 _value);
121   event Burn(address indexed _from, uint256 _value);
122   event FrozenFunds(address indexed _target, bool _frozen );
123   event Mint(address indexed _to, uint256 _value);
124   
125   
126   modifier onlyOwner{ 
127     if ( msg.sender != kairosOwner) throw; 
128     _; 
129   }    
130 
131   function KairosToken(){
132     kairosOwner            = msg.sender;
133     balances[kairosOwner]  = initialSupply;
134     totalSupply            = initialSupply;
135     CreateNertia(kairosOwner, initialSupply);
136   }
137 
138   function buy() payable returns (uint256 amount) {
139     amount = msg.value / buyPrice;
140     if(balances[kairosOwner] < amount) throw;
141     balances[msg.sender] += amount;
142     balances[kairosOwner] -= amount;    
143     Transfer(kairosOwner, msg.sender, amount);
144     return amount;
145   }
146 
147   function sell(uint256 amount){
148     if(balances[msg.sender] < amount) throw;
149     balances[kairosOwner] += amount;
150     balances[msg.sender] -= amount;
151     if(!msg.sender.send(amount.mul(sellPrice))){
152         throw;
153     }
154     Transfer(msg.sender, kairosOwner, amount);    
155   }
156 
157   function setPrices(uint256 newSellPrice, uint256 newBuyPrice){
158     sellPrice = newSellPrice;
159     buyPrice = newBuyPrice;
160   }
161   
162 
163   function transfer(address _to, uint256 _value) returns (bool success) {
164       if (_to == 0x0) return false;
165       if (!frozenAccount[msg.sender] && balances[msg.sender] >= _value && _value > 0) {
166         balances[msg.sender] -= _value;
167         balances[_to] += _value;
168         Transfer(msg.sender, _to, _value);
169         return true;
170       }
171       return false;      
172   }
173 
174   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
175       if(!frozenAccount[msg.sender] && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
176         balances[_to] += _value;
177         balances[_from] -= _value;
178         allowed[_from][msg.sender] -= _value;
179         Transfer(_from, _to, _value);
180         return true;
181       }
182       return false;
183       
184   }
185 
186   function burn(uint256 _value) returns (bool success) {
187     if (balances[msg.sender] < _value) throw;            
188     balances[msg.sender] -= _value;                      
189     totalSupply -= _value;                                
190     Burn(msg.sender, _value);
191     return true;
192   }
193 
194   function burnFrom(address _from, uint256 _value) returns (bool success) {
195     if (balances[_from] < _value) throw;                
196     if (_value > allowed[_from][msg.sender]) throw;    
197     balances[_from] -= _value;                          
198     totalSupply -= _value;                               
199     Burn(_from, _value);
200     return true;
201   }
202 
203   function freezeAccount(address _target, bool frozen){
204     frozenAccount[_target] = frozen;
205     FrozenFunds(_target, frozen);
206   }
207 
208   function getDecimals() public returns (uint256){
209     return decimals;
210   }
211 
212   function getOwner() public returns (address){
213     return kairosOwner;
214   }
215 
216 }