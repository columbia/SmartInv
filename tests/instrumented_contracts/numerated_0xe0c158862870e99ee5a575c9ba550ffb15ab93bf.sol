1 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
2 
3 contract owned {
4     address public owner;
5  
6 
7     function owned () public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require (msg.sender == owner);
13         _;
14     }
15  
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         if (newOwner != address(0)) {
19         owner = newOwner;
20       }
21     }
22 }
23 
24 contract TokenERC20 {
25     string public name; 
26     string public symbol; 
27     uint8 public decimals = 18;  
28     uint256 public totalSupply; 
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32  
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);  
35     event Burn(address indexed from, uint256 value);
36  
37 
38     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
39      
40         totalSupply = initialSupply * 10 ** uint256(decimals);   
41   
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45     }
46  
47  
48  
49     function _transfer(address _from, address _to, uint256 _value) internal {
50  
51    
52       require(_to != 0x0);
53  
54      
55       require(balanceOf[_from] >= _value);
56  
57     
58       require(balanceOf[_to] + _value > balanceOf[_to]);
59  
60      
61       uint previousBalances = balanceOf[_from] + balanceOf[_to];
62  
63    
64       balanceOf[_from] -= _value;
65  
66     
67       balanceOf[_to] += _value;
68  
69      
70       Transfer(_from, _to, _value);
71  
72     
73       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74  
75     }
76  
77 
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81  
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84     
85         require(_value <= allowance[_from][msg.sender]);
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90  
91 
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96  
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
99         tokenRecipient spender = tokenRecipient(_spender);
100         if (approve(_spender, _value)) {
101             spender.receiveApproval(msg.sender, _value, this, _extraData);
102             return true;
103         }
104     }
105  
106 
107     function burn(uint256 _value) public returns (bool success) {
108         
109         require(balanceOf[msg.sender] >= _value);
110       
111         balanceOf[msg.sender] -= _value;
112         
113         totalSupply -= _value;
114         Burn(msg.sender, _value);
115         return true;
116     }
117  
118 
119     function burnFrom(address _from, uint256 _value) public returns (bool success) {
120        
121         require(balanceOf[_from] >= _value);
122         
123         require(_value <= allowance[_from][msg.sender]);
124        
125         balanceOf[_from] -= _value;
126         allowance[_from][msg.sender] -= _value;
127        
128         totalSupply -= _value;
129         Burn(_from, _value);
130         return true;
131     }
132 }
133  
134 
135 contract MyAdvancedToken is owned, TokenERC20 {
136  
137 
138     uint256 public sellPrice;
139  
140  
141     uint256 public buyPrice;
142  
143 
144     mapping (address => bool) public frozenAccount;
145  
146 
147     event FrozenFunds(address target, bool frozen);
148  
149  
150 
151         function MyAdvancedToken(
152         uint256 initialSupply,
153         string tokenName,
154         string tokenSymbol
155     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
156  
157  
158 
159     function _transfer(address _from, address _to, uint _value) internal {
160  
161         require (_to != 0x0);
162  
163        
164         require (balanceOf[_from] > _value);
165  
166         
167         require (balanceOf[_to] + _value > balanceOf[_to]);
168  
169        
170         require(!frozenAccount[_from]);
171         require(!frozenAccount[_to]);
172  
173        
174         balanceOf[_from] -= _value;
175  
176      
177         balanceOf[_to] += _value;
178  
179      
180         Transfer(_from, _to, _value);
181  
182     }
183  
184 
185     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
186  
187      
188         balanceOf[target] += mintedAmount;
189         totalSupply += mintedAmount;
190  
191  
192         Transfer(0, this, mintedAmount);
193         Transfer(this, target, mintedAmount);
194     }
195  
196 
197     function freezeAccount(address target, bool freeze) onlyOwner public {
198         frozenAccount[target] = freeze;
199         FrozenFunds(target, freeze);
200     }
201  
202    
203     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
204         sellPrice = newSellPrice;
205         buyPrice = newBuyPrice;
206     }
207  
208 
209     function buy() payable public {
210       uint amount = msg.value / buyPrice;
211  
212       _transfer(this, msg.sender, amount);
213     }
214  
215 
216     function sell(uint256 amount) public {
217  
218       
219         require(this.balance >= amount * sellPrice);
220  
221         _transfer(msg.sender, this, amount);
222  
223         msg.sender.transfer(amount * sellPrice);
224     }
225 }