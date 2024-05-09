1 pragma solidity ^0.4.16;
2 
3 contract owned {
4 
5     address public owner;
6 
7     function owned() public {
8     owner = msg.sender;
9     }
10 
11    
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }   
21 }
22 
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     
28     string public name;             
29     string public symbol;          
30     uint8 public decimals = 18;     
31 
32     uint256 public totalSupply;     
33 
34 
35     mapping (address => uint256) public balanceOf;
36 
37    
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40    
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43   
44     event Burn(address indexed from, uint256 value);
45 
46 
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  
53         balanceOf[msg.sender] = totalSupply;                   
54         name = tokenName;                                       
55         symbol = tokenSymbol;                                   
56     }
57 
58 
59     function _transfer(address _from, address _to, uint _value) internal {
60         
61         require(_to != 0x0);
62         
63         require(balanceOf[_from] >= _value);
64        
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         
69         balanceOf[_from] -= _value;
70         
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);     
85         allowance[_from][msg.sender] -= _value;
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90 
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97    
98 
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         public
101         returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108 
109    
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   
112         balanceOf[msg.sender] -= _value;            
113         totalSupply -= _value;                     
114         Burn(msg.sender, _value);
115         return true;
116     }
117 
118    
119     function burnFrom(address _from, uint256 _value) public returns (bool success) {
120         require(balanceOf[_from] >= _value);                
121         require(_value <= allowance[_from][msg.sender]);   
122         balanceOf[_from] -= _value;                         
123         allowance[_from][msg.sender] -= _value;             
124         totalSupply -= _value;                             
125         Burn(_from, _value);
126         return true;
127     }
128 }
129 
130 
131 contract CreateCodeToken is owned, TokenERC20 {
132 
133     uint256 public sellPrice;
134     uint256 public buyPrice;
135 
136    
137     mapping (address => bool) public frozenAccount;
138 
139     event FrozenFunds(address target, bool frozen);
140 
141    
142     function CreateCodeToken(
143         uint256 initialSupply,
144         string tokenName,
145         string tokenSymbol
146     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
147 
148    
149     function _transfer(address _from, address _to, uint _value) internal {
150         require (_to != 0x0);                              
151         require (balanceOf[_from] >= _value);               
152         require (balanceOf[_to] + _value > balanceOf[_to]); 
153         require(!frozenAccount[_from]);                    
154         require(!frozenAccount[_to]);                       
155         balanceOf[_from] -= _value;                        
156         balanceOf[_to] += _value;                          
157         Transfer(_from, _to, _value);
158     }
159 
160 
161     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
162         balanceOf[target] += mintedAmount;
163         totalSupply += mintedAmount;
164         Transfer(0, this, mintedAmount);
165         Transfer(this, target, mintedAmount);
166 
167     }
168 
169 
170     function freezeAccount(address target, bool freeze) onlyOwner public {
171         frozenAccount[target] = freeze;
172         FrozenFunds(target, freeze);
173     }
174 
175     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
176         sellPrice = newSellPrice;
177         buyPrice = newBuyPrice;
178     }
179 
180     function safedrawal(uint256 amount) onlyOwner public {
181         msg.sender.transfer(amount);          
182         Transfer(this,msg.sender, amount);
183     }
184     
185     function () public payable {
186        uint amount = msg.value * buyPrice;              
187         _transfer(this, msg.sender, amount);           
188         Transfer(this, msg.sender, amount);
189     }
190 
191 
192     
193     function buy() payable public {
194         uint amount = msg.value * buyPrice;              
195         _transfer(this, msg.sender, amount);             
196         Transfer(this, msg.sender, amount);
197     }
198 
199     function sell(uint256 amount) public {
200         require(this.balance >= amount / sellPrice);     
201         _transfer(msg.sender, this, amount);             
202         msg.sender.transfer(amount / sellPrice);        
203         Transfer(msg.sender, this, amount);
204     }
205 }