1 pragma solidity ^0.4.11;
2 
3 
4 contract Owner {
5     address public owner;
6 
7     function Owner() {
8         owner = msg.sender;
9     }
10 
11     modifier  onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function  transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract TokenRecipient { 
23     function receiveApproval(
24         address _from, 
25         uint256 _value, 
26         address _token, 
27         bytes _extraData); 
28 }
29 
30 
31 contract Token {
32     string public standard = "Token 0.1";
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     function Token (
45         uint256 initialSupply,
46         string tokenName,
47         uint8 decimalUnits,
48         string tokenSymbol
49     ) {
50         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         totalSupply = initialSupply;                        // Update total supply
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         decimals = decimalUnits;                            // Amount of decimals for display purposes
55     }
56     
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         if (balanceOf[msg.sender] < _value) {
59             revert();           // Check if the sender has enough
60         }
61         if (balanceOf[_to] + _value < balanceOf[_to]) {
62             revert(); // Check for overflows
63         }
64 
65         balanceOf[msg.sender] -= _value;
66         balanceOf[_to] += _value;
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70     
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73 
74         allowance[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
80     returns (bool success) 
81     {    
82         TokenRecipient spender = TokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(
85                 msg.sender,
86                 _value,
87                 this,
88                 _extraData
89             );
90             return true;
91         }
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         if (balanceOf[_from] < _value) {
96             revert();                                        // Check if the sender has enough
97         }                 
98         if (balanceOf[_to] + _value < balanceOf[_to]) {
99             revert();  // Check for overflows
100         }
101         if (_value > allowance[_from][msg.sender]) {
102             revert();   // Check allowance
103         }
104 
105         balanceOf[_from] -= _value;
106         balanceOf[_to] += _value;
107         allowance[_from][msg.sender] -= _value;
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 }
112 
113 
114 //Business Service Token
115 contract BDragon is Token, Owner {
116     uint256 public constant INITIAL_SUPPLY = 15 * 10000 * 10000 * 1 ether; // 1e9 * 1e18
117     string public constant NAME = "B-Dragon"; //名称
118     string public constant SYMBOL = "DO"; // 简称
119     // string public constant STANDARD = "Token 1.0";
120     uint8 public constant DECIMALS = 18;
121     uint256 public constant BUY = 0; // 用于自动买卖
122     uint256 constant RATE = 1 szabo;
123     bool private couldTrade = false;
124 
125     // string public standard = STANDARD;
126     // string public name;
127     // string public symbol;
128     // uint public decimals;
129 
130     uint256 public sellPrice;
131     uint256 public buyPrice;
132     uint minBalanceForAccounts;
133 
134     mapping (address => uint256) public balanceOf;
135     mapping (address => bool) frozenAccount;
136 
137     event FrozenFunds(address indexed _target, bool _frozen);
138 
139     function BDragon() Token(INITIAL_SUPPLY, NAME, DECIMALS, SYMBOL) {
140         balanceOf[msg.sender] = totalSupply;
141         buyPrice = 100000000;
142         sellPrice = 100000000;
143     }
144 
145     function transfer(address _to, uint256 _value) returns (bool success) {
146         if (balanceOf[msg.sender] < _value) {
147             revert();           // Check if the sender has enough
148         }
149         if (balanceOf[_to] + _value < balanceOf[_to]) {
150             revert(); // Check for overflows
151         }
152         if (frozenAccount[msg.sender]) {
153             revert();                // Check if frozen
154         }
155 
156         balanceOf[msg.sender] -= _value;
157         balanceOf[_to] += _value;
158         Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
163         if (frozenAccount[_from]) {
164             revert();                        // Check if frozen       
165         }     
166         if (balanceOf[_from] < _value) {
167             revert();                 // Check if the sender has enough
168         }
169         if (balanceOf[_to] + _value < balanceOf[_to]) {
170             revert();  // Check for overflows
171         }
172         if (_value > allowance[_from][msg.sender]) {
173             revert();   // Check allowance
174         }
175 
176         balanceOf[_from] -= _value;
177         balanceOf[_to] += _value;
178         allowance[_from][msg.sender] -= _value;
179         Transfer(_from, _to, _value);
180         return true;
181     }
182 
183     function freezeAccount(address _target, bool freeze) onlyOwner {
184         frozenAccount[_target] = freeze;
185         FrozenFunds(_target, freeze);
186     }
187 
188     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
189         sellPrice = newSellPrice;
190         buyPrice = newBuyPrice;
191     }
192 
193     function buy() payable returns (uint amount) {
194         require(couldTrade);
195         amount = msg.value * RATE / buyPrice;
196         require(balanceOf[this] >= amount);
197         require(balanceOf[msg.sender] + amount >= amount);
198         balanceOf[this] -= amount;
199         balanceOf[msg.sender] += amount;
200         Transfer(this, msg.sender, amount);
201         return amount;
202     }
203 
204     function sell(uint256 amountInWeiDecimalIs18) returns (uint256 revenue) {
205         require(couldTrade);
206         uint256 amount = amountInWeiDecimalIs18;
207         require(balanceOf[msg.sender] >= amount);
208         require(!frozenAccount[msg.sender]);
209 
210         revenue = amount * sellPrice / RATE;
211         balanceOf[this] += amount;
212         balanceOf[msg.sender] -= amount;
213         require(msg.sender.send(revenue));
214         Transfer(msg.sender, this, amount);
215         return revenue;
216     }
217 
218     function withdraw(uint256 amount) onlyOwner returns (bool success) {
219         require(msg.sender.send(amount));
220         return true;
221     }
222 
223     function setCouldTrade(uint256 amountInWeiDecimalIs18) onlyOwner returns (bool success) {
224         couldTrade = true;
225         require(balanceOf[msg.sender] >= amountInWeiDecimalIs18);
226         require(balanceOf[this] + amountInWeiDecimalIs18 >= amountInWeiDecimalIs18);
227         balanceOf[msg.sender] -= amountInWeiDecimalIs18;
228         balanceOf[this] += amountInWeiDecimalIs18;
229         Transfer(msg.sender, this, amountInWeiDecimalIs18);
230         return true;
231     }
232 
233     function stopTrade() onlyOwner returns (bool success) {
234         couldTrade = false;
235         uint256 _remain = balanceOf[this];
236         require(balanceOf[msg.sender] + _remain >= _remain);
237         balanceOf[msg.sender] += _remain;
238         balanceOf[this] -= _remain;
239         Transfer(this, msg.sender, _remain);
240         return true;
241     }
242 
243     function () {
244         revert();
245     }
246 }