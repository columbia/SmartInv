1 // TheCoin token
2 // ERC20 Compatible
3 // https://github.com/ethereum/EIPs/issues/20
4 
5 
6 pragma solidity ^0.4.2;
7 contract owned {
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;  
21     }
22 }
23 
24 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
25 
26 contract token {
27     string public standard = 'Token 0.1';
28     string public name;
29     string public symbol;
30     uint8 public decimals;
31     uint256 public totalTokens;
32     mapping (address => uint256) public balance;
33     mapping (address => mapping (address => uint256)) public allowance;
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     function token(
37         uint256 initialSupply,
38         string tokenName,
39         uint8 decimalUnits,
40         string tokenSymbol
41         ) {
42         balance[msg.sender] = initialSupply;        
43         totalTokens = initialSupply;                     
44         name = tokenName;                              
45         symbol = tokenSymbol;                             
46         decimals = decimalUnits;                           
47     }
48 
49     function transfer(address _to, uint256 _value) returns (bool success){
50         if (balance[msg.sender] < _value) throw;     
51         if (balance[_to] + _value < balance[_to]) throw; 
52         balance[msg.sender] -= _value;                     
53         balance[_to] += _value;                      
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value)
59         returns (bool success) {
60         allowance[msg.sender][_spender] = _value;
61         tokenRecipient spender = tokenRecipient(_spender);
62         return true;
63     }
64 
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
66         returns (bool success) {    
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69             spender.receiveApproval(msg.sender, _value, this, _extraData);
70             return true;
71         }
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         if (balance[_from] < _value) throw;         
76         if (balance[_to] + _value < balance[_to]) throw;  
77         if (_value > allowance[_from][msg.sender]) throw; 
78         balance[_from] -= _value;                  
79         balance[_to] += _value;                       
80         allowance[_from][msg.sender] -= _value;
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 }
85 
86 contract TheCoin is owned, token {
87     uint256 public buyPrice; 
88     uint256 public totalTokens;
89     uint256 public komission; 
90     bool public crowdsale;
91     mapping (address => bool) public frozenAccountProfit; 
92     mapping (address => uint) public frozenProfitDate; 
93     event FrozenProfit(address target, bool frozen);
94 
95     function TheCoin(
96         uint256 initialSupply,
97         string tokenName,
98         uint8 decimalUnits,
99         string tokenSymbol,
100         address centralMinter
101     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
102         if(centralMinter != 0 ) owner = centralMinter;   
103         balance[this] = initialSupply;               
104 	komission = 10;
105 	crowdsale = true;
106 	buyPrice = 50000000;
107     }
108 
109     function approve(address _spender, uint256 _value)
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         tokenRecipient spender = tokenRecipient(_spender);
113         return true;
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
117         if (balance[_from] < _value) throw;         
118         if (balance[_to] + _value < balance[_to]) throw;  
119         if (_value > allowance[_from][msg.sender]) throw; 
120         balance[_from] -= _value;                  
121         balance[_to] += _value;                       
122         allowance[_from][msg.sender] -= _value;
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function transfer(address _to, uint256 _value) returns (bool success) {
128     uint256 kom;
129 	kom = (_value * komission) / 1000;			
130 	if (kom < 1) kom = 1;				
131         if (balance[msg.sender] >= _value && (_value + kom) > 0) {         
132         balance[msg.sender] -= _value;                  
133         balance[_to] += (_value - kom);                                               
134         balance[this] += kom;                           
135         Transfer(msg.sender, _to, (_value - kom));
136         return true;
137         } else { 
138          return false;
139       }
140     }
141 
142     function saleover() onlyOwner{
143 	crowdsale = false;
144         }
145 
146     function getreward() returns (bool success) {
147         uint256 reward;
148         reward = (balance[this] * balance[msg.sender]) / totalTokens; 
149     if (frozenAccountProfit[msg.sender] == true && frozenProfitDate[msg.sender] + 3 days > now) {
150 	return false;
151         } else {
152     if (reward < 1) reward = 1; 
153     if (balance[this] < reward) throw;  
154     balance[msg.sender] += reward; 
155     balance[this] -= reward; 
156     frozenAccountProfit[msg.sender] = true;  
157     frozenProfitDate[msg.sender] = now;    
158     Transfer(this, msg.sender, (reward));     
159     return true;
160 	 }
161     }
162 
163     function buy() payable returns (bool success) {
164 	if (!crowdsale) {return false;} 
165 	else {  
166 	uint amount = msg.value / buyPrice;                
167         totalTokens += amount;                          
168         balance[msg.sender] += amount;                   
169         Transfer(this, msg.sender, amount); 
170 	return true; }            
171     }
172 
173     function fund (uint256 amount) onlyOwner {
174         if (!msg.sender.send(amount)) {                      		
175           throw;                                         
176         }           
177     }
178 
179     function totalSupply() external constant returns (uint256) {
180         return totalTokens;
181     }
182 
183     function balanceOf(address _owner) external constant returns (uint256) {
184         return balance[_owner];
185     }
186 
187     function () payable {
188 	if (!crowdsale) {throw;} 
189 	else {  
190 	uint amount = msg.value / buyPrice;                
191         totalTokens += amount;                          
192         balance[msg.sender] += amount;                   
193         Transfer(this, msg.sender, amount); 
194 	 }               
195     }
196 }