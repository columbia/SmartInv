1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5         if (_a == 0) {
6             return 0;
7         }
8         c = _a * _b;
9         assert(c / _a == _b);
10         return c;
11     }
12 
13     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         // assert(_b > 0);
15         return _a / _b;
16     }
17 
18   
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         assert(_b <= _a);
21         return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25         c = _a + _b;
26         assert(c >= _a);
27         return c;
28     }
29 }
30 
31 contract owned {
32     
33     address public owner;
34 
35     constructor () public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner, "Not Contract Owner");
41         _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45         owner = newOwner;
46     }
47 }
48 
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
51 
52 contract WPGBaseCoin {
53 
54     using SafeMath for uint256;
55 
56     string public name;
57     string public symbol;
58     uint8 public decimals = 18;
59     uint256 public totalSupply;
60 
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     event Burn(address indexed from, uint256 value);
67 
68     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
69         
70         totalSupply = initialSupply * 10 ** uint256(decimals);
71         balanceOf[msg.sender] = totalSupply;
72         name = tokenName;
73         symbol = tokenSymbol;
74     
75     }
76 
77     function _transfer(address _from, address _to, uint _value) internal {
78         
79         require(_to != 0x0, "Do not send to 0x0");
80         require(balanceOf[_from] >= _value, "Sender balance is too small");
81         require(balanceOf[_to] + _value > balanceOf[_to], "balanceOf[_to] Overflow Error");
82         
83         uint previousBalances = balanceOf[_from] + balanceOf[_to];
84         
85         //balanceOf[_from] -= _value;
86         balanceOf[_from] = balanceOf[_from].sub(_value);
87 
88         //balanceOf[_to] += _value;
89         balanceOf[_to] = balanceOf[_to].add(_value);
90 
91         emit Transfer(_from, _to, _value);
92         
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     
95     }
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         
99         _transfer(msg.sender, _to, _value);
100         return true;
101     
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender], "Allowance value is smaller than _value");
106         
107         //allowance[_from][msg.sender] -= _value;
108         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
109 
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function approve(address _spender, uint256 _value) public returns (bool success) {
115         
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     
120     }
121 
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
123 
124         tokenRecipient spender = tokenRecipient(_spender);
125         
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130 
131     }
132 
133     function burn(uint256 _value) public returns (bool success) {
134     
135         require(balanceOf[msg.sender] >= _value, "Burn Balance of sender is smaller than _value");
136         //balanceOf[msg.sender] -= _value;
137         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
138         //totalSupply -= _value;
139         totalSupply = totalSupply.sub(_value);
140 
141         emit Burn(msg.sender, _value);
142         return true;
143 
144     }
145 
146     function burnFrom(address _from, uint256 _value) public returns (bool success) {
147 
148         require(balanceOf[_from] >= _value, "From balance is smaller than _value");
149         require(_value <= allowance[_from][msg.sender], "Allowance balance is smaller than _value");
150         
151         //balanceOf[_from] -= _value;
152         balanceOf[_from] = balanceOf[_from].sub(_value);
153         //allowance[_from][msg.sender] -= _value;
154         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
155         //totalSupply -= _value;
156         totalSupply = totalSupply.sub(_value);
157 
158         emit Burn(_from, _value);
159         return true;
160 
161     }
162 }
163 
164 /******************************************/
165 /*       ADVANCED COIN STARTS HERE       */
166 /******************************************/
167 
168 contract WPGCoin is owned, WPGBaseCoin {
169 
170     uint256 public sellPrice;
171     uint256 public buyPrice;
172 
173     mapping (address => bool) public frozenAccount;
174 
175     event FrozenFunds(address target, bool frozen);
176 
177     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) WPGBaseCoin(initialSupply, tokenName, tokenSymbol) public {
178 
179     }
180 
181     function _transfer(address _from, address _to, uint _value) internal {
182         
183         require (_to != 0x0, "Do not send to 0x0");
184         require (balanceOf[_from] >= _value, "Sender balance is too small");
185         require (balanceOf[_to] + _value >= balanceOf[_to], "balanceOf[_to] Overflow Error");
186         require(!frozenAccount[_from], "From Account is Frozen");
187         require(!frozenAccount[_to], "To Acoount is Frozen");
188         
189         //balanceOf[_from] -= _value;
190         balanceOf[_from] = balanceOf[_from].sub(_value);
191         //balanceOf[_to] += _value;
192         balanceOf[_to] = balanceOf[_to].add(_value);
193         
194         emit Transfer(_from, _to, _value);
195     }
196 
197     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
198         
199         //balanceOf[target] += mintedAmount;
200         balanceOf[target] = balanceOf[target].add(mintedAmount);
201         //totalSupply += mintedAmount;
202         totalSupply = totalSupply.add(mintedAmount);
203         
204         emit Transfer(0, this, mintedAmount);
205         emit Transfer(this, target, mintedAmount);
206     
207     }
208 
209     function freezeAccount(address target, bool freeze) public onlyOwner{
210     
211         frozenAccount[target] = freeze;
212         emit FrozenFunds(target, freeze);
213     
214     }
215 
216     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
217     
218         sellPrice = newSellPrice;
219         buyPrice = newBuyPrice;
220     
221     }
222 
223     function buy() public payable {
224         
225         //uint amount = msg.value / buyPrice;
226         uint amount = msg.value.div(buyPrice);
227 
228         _transfer(this, msg.sender, amount);
229 
230     }
231 
232     function sell(uint256 amount) public {
233     
234         address myAddress = this;
235         
236         require(myAddress.balance >= amount * sellPrice, "Account balance is too small for buying");
237         
238         _transfer(msg.sender, this, amount);
239         msg.sender.transfer(amount * sellPrice);
240 
241     }
242 
243     function getBalanceOf(address _address) public view returns (uint) {
244         return balanceOf[_address];
245     }
246 }