1 pragma solidity ^0.4.18;
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
32     string public standard;
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
48         string tokenSymbol,
49         string standardStr
50     ) {
51         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
52         totalSupply = initialSupply;                        // Update total supply
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55         decimals = decimalUnits;                            // Amount of decimals for display purposes
56         standard = standardStr;
57     }
58     
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         if (balanceOf[msg.sender] < _value) {
61             revert();           // Check if the sender has enough
62         }
63         if (balanceOf[_to] + _value < balanceOf[_to]) {
64             revert(); // Check for overflows
65         }
66 
67         balanceOf[msg.sender] -= _value;
68         balanceOf[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72     
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         require(balanceOf[msg.sender] >= _value);
75 
76         allowance[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
82     returns (bool success) 
83     {    
84         TokenRecipient spender = TokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(
87                 msg.sender,
88                 _value,
89                 this,
90                 _extraData
91             );
92             return true;
93         }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         if (balanceOf[_from] < _value) {
98             revert();                                        // Check if the sender has enough
99         }                 
100         if (balanceOf[_to] + _value < balanceOf[_to]) {
101             revert();  // Check for overflows
102         }
103         if (_value > allowance[_from][msg.sender]) {
104             revert();   // Check allowance
105         }
106 
107         balanceOf[_from] -= _value;
108         balanceOf[_to] += _value;
109         allowance[_from][msg.sender] -= _value;
110         Transfer(_from, _to, _value);
111         return true;
112     }
113 }
114 
115 
116 //build EXToken
117 contract EXToken is Token, Owner {
118     uint256 public constant INITIAL_SUPPLY = 100 * 10000 * 10000 * 100000000; // 1e10 * 1e8
119     string public constant NAME = "coinex8"; //名称
120     string public constant SYMBOL = "ex8"; // 简称
121     string public constant STANDARD = "coinex8 1.0";
122     uint8 public constant DECIMALS = 8;
123     uint256 public constant BUY = 0; // 用于自动买卖
124     uint256 constant RATE = 1 szabo;
125     bool private couldTrade = false;
126 
127     uint256 public sellPrice;
128     uint256 public buyPrice;
129     uint minBalanceForAccounts;
130 
131     mapping (address => bool) frozenAccount;
132 
133     event FrozenFunds(address indexed _target, bool _frozen);
134 
135     function EXToken() Token(INITIAL_SUPPLY, NAME, DECIMALS, SYMBOL, STANDARD) {
136         balanceOf[msg.sender] = totalSupply;
137         buyPrice = 100000000;
138         sellPrice = 100000000;
139     }
140 
141     function transfer(address _to, uint256 _value) returns (bool success) {
142         if (balanceOf[msg.sender] < _value) {
143             revert();           // Check if the sender has enough
144         }
145         if (balanceOf[_to] + _value < balanceOf[_to]) {
146             revert(); // Check for overflows
147         }
148         if (frozenAccount[msg.sender]) {
149             revert();                // Check if frozen
150         }
151 
152         balanceOf[msg.sender] -= _value;
153         balanceOf[_to] += _value;
154         Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
159         if (frozenAccount[_from]) {
160             revert();                        // Check if frozen       
161         }     
162         if (balanceOf[_from] < _value) {
163             revert();                 // Check if the sender has enough
164         }
165         if (balanceOf[_to] + _value < balanceOf[_to]) {
166             revert();  // Check for overflows
167         }
168         if (_value > allowance[_from][msg.sender]) {
169             revert();   // Check allowance
170         }
171 
172         balanceOf[_from] -= _value;
173         balanceOf[_to] += _value;
174         allowance[_from][msg.sender] -= _value;
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     function freezeAccount(address _target, bool freeze) onlyOwner {
180         frozenAccount[_target] = freeze;
181         FrozenFunds(_target, freeze);
182     }
183 
184     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
185         sellPrice = newSellPrice;
186         buyPrice = newBuyPrice;
187     }
188 
189     function buy() payable returns (uint amount) {
190         require(couldTrade);
191         amount = msg.value * RATE / buyPrice;
192         require(balanceOf[this] >= amount);
193         require(balanceOf[msg.sender] + amount >= amount);
194         balanceOf[this] -= amount;
195         balanceOf[msg.sender] += amount;
196         Transfer(this, msg.sender, amount);
197         return amount;
198     }
199 
200     function sell(uint256 amountInWeiDecimalIs18) returns (uint256 revenue) {
201         require(couldTrade);
202         uint256 amount = amountInWeiDecimalIs18;
203         require(balanceOf[msg.sender] >= amount);
204         require(!frozenAccount[msg.sender]);
205 
206         revenue = amount * sellPrice / RATE;
207         balanceOf[this] += amount;
208         balanceOf[msg.sender] -= amount;
209         require(msg.sender.send(revenue));
210         Transfer(msg.sender, this, amount);
211         return revenue;
212     }
213 
214     function withdraw(uint256 amount) onlyOwner returns (bool success) {
215         require(msg.sender.send(amount));
216         return true;
217     }
218 
219     function setCouldTrade(uint256 amountInWeiDecimalIs18) onlyOwner returns (bool success) {
220         couldTrade = true;
221         require(balanceOf[msg.sender] >= amountInWeiDecimalIs18);
222         require(balanceOf[this] + amountInWeiDecimalIs18 >= amountInWeiDecimalIs18);
223         balanceOf[msg.sender] -= amountInWeiDecimalIs18;
224         balanceOf[this] += amountInWeiDecimalIs18;
225         Transfer(msg.sender, this, amountInWeiDecimalIs18);
226         return true;
227     }
228 
229     function stopTrade() onlyOwner returns (bool success) {
230         couldTrade = false;
231         uint256 _remain = balanceOf[this];
232         require(balanceOf[msg.sender] + _remain >= _remain);
233         balanceOf[msg.sender] += _remain;
234         balanceOf[this] -= _remain;
235         Transfer(this, msg.sender, _remain);
236         return true;
237     }
238 
239     function () {
240         revert();
241     }
242 }