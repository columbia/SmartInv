1 pragma solidity ^0.4.18;
2 
3 contract Owner {
4     address public owner;
5 
6     function Owner() {
7         owner = msg.sender;
8     }
9 
10     modifier  onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function  transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract TokenRecipient { 
21     function receiveApproval(
22         address _from, 
23         uint256 _value, 
24         address _token, 
25         bytes _extraData); 
26 }
27 
28 contract Token {
29     string public standard;
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     function Token (
42         uint256 initialSupply,
43         string tokenName,
44         uint8 decimalUnits,
45         string tokenSymbol,
46         string stanDard
47     ) {
48         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
49         totalSupply = initialSupply;                        // Update total supply
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52         decimals = decimalUnits;                            // Amount of decimals for display purposes
53         standard = stanDard;                          
54     }
55     
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         if (balanceOf[msg.sender] < _value) {
58             revert();           // Check if the sender has enough
59         }
60         if (balanceOf[_to] + _value < balanceOf[_to]) {
61             revert(); // Check for overflows
62         }
63 
64         balanceOf[msg.sender] -= _value;
65         balanceOf[_to] += _value;
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69     
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         require(balanceOf[msg.sender] >= _value);
72 
73         allowance[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
79     returns (bool success) 
80     {    
81         TokenRecipient spender = TokenRecipient(_spender);
82         if (approve(_spender, _value)) {
83             spender.receiveApproval(
84                 msg.sender,
85                 _value,
86                 this,
87                 _extraData
88             );
89             return true;
90         }
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         if (balanceOf[_from] < _value) {
95             revert();                                        // Check if the sender has enough
96         }                 
97         if (balanceOf[_to] + _value < balanceOf[_to]) {
98             revert();  // Check for overflows
99         }
100         if (_value > allowance[_from][msg.sender]) {
101             revert();   // Check allowance
102         }
103 
104         balanceOf[_from] -= _value;
105         balanceOf[_to] += _value;
106         allowance[_from][msg.sender] -= _value;
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 }
111 
112 contract QCSTToken is Token, Owner {
113     uint256 public constant INITIAL_SUPPLY = 20 * 10000 * 10000 * 1 ether; // 1e9 * 1e18
114     string public constant NAME = "品质链"; //名称
115     string public constant SYMBOL = "QCST"; // 简称
116      string public constant STANDARD = "QCST"; 
117     uint8 public constant DECIMALS = 18;
118     uint256 public constant BUY = 0; // 用于自动买卖
119     uint256 constant RATE = 1 szabo;
120     bool private couldTrade = false;
121     uint256 public sellPrice;
122     uint256 public buyPrice;
123     uint minBalanceForAccounts;
124 
125     mapping (address => bool) frozenAccount;
126 
127     event FrozenFunds(address indexed _target, bool _frozen);
128 
129     function QCSTToken() Token(INITIAL_SUPPLY, NAME, DECIMALS, SYMBOL, STANDARD) {
130         balanceOf[msg.sender] = totalSupply;
131         buyPrice = 100000000;
132         sellPrice = 100000000;
133     }
134 
135     function transfer(address _to, uint256 _value) returns (bool success) {
136         if (balanceOf[msg.sender] < _value) {
137             revert();           // Check if the sender has enough
138         }
139         if (balanceOf[_to] + _value < balanceOf[_to]) {
140             revert(); // Check for overflows
141         }
142         if (frozenAccount[msg.sender]) {
143             revert();                // Check if frozen
144         }
145 
146         balanceOf[msg.sender] -= _value;
147         balanceOf[_to] += _value;
148         Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
153         if (frozenAccount[_from]) {
154             revert();                        // Check if frozen       
155         }     
156         if (balanceOf[_from] < _value) {
157             revert();                 // Check if the sender has enough
158         }
159         if (balanceOf[_to] + _value < balanceOf[_to]) {
160             revert();  // Check for overflows
161         }
162         if (_value > allowance[_from][msg.sender]) {
163             revert();   // Check allowance
164         }
165 
166         balanceOf[_from] -= _value;
167         balanceOf[_to] += _value;
168         allowance[_from][msg.sender] -= _value;
169         Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     function freezeAccount(address _target, bool freeze) onlyOwner {
174         frozenAccount[_target] = freeze;
175         FrozenFunds(_target, freeze);
176     }
177 
178     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
179         sellPrice = newSellPrice;
180         buyPrice = newBuyPrice;
181     }
182 
183     function buy() payable returns (uint amount) {
184         require(couldTrade);
185         amount = msg.value * RATE / buyPrice;
186         require(balanceOf[this] >= amount);
187         require(balanceOf[msg.sender] + amount >= amount);
188         balanceOf[this] -= amount;
189         balanceOf[msg.sender] += amount;
190         Transfer(this, msg.sender, amount);
191         return amount;
192     }
193 
194     function sell(uint256 amountInWeiDecimalIs18) returns (uint256 revenue) {
195         require(couldTrade);
196         uint256 amount = amountInWeiDecimalIs18;
197         require(balanceOf[msg.sender] >= amount);
198         require(!frozenAccount[msg.sender]);
199 
200         revenue = amount * sellPrice / RATE;
201         balanceOf[this] += amount;
202         balanceOf[msg.sender] -= amount;
203         require(msg.sender.send(revenue));
204         Transfer(msg.sender, this, amount);
205         return revenue;
206     }
207 
208     function withdraw(uint256 amount) onlyOwner returns (bool success) {
209         require(msg.sender.send(amount));
210         return true;
211     }
212 
213     function setCouldTrade(uint256 amountInWeiDecimalIs18) onlyOwner returns (bool success) {
214         couldTrade = true;
215         require(balanceOf[msg.sender] >= amountInWeiDecimalIs18);
216         require(balanceOf[this] + amountInWeiDecimalIs18 >= amountInWeiDecimalIs18);
217         balanceOf[msg.sender] -= amountInWeiDecimalIs18;
218         balanceOf[this] += amountInWeiDecimalIs18;
219         Transfer(msg.sender, this, amountInWeiDecimalIs18);
220         return true;
221     }
222 
223     function stopTrade() onlyOwner returns (bool success) {
224         couldTrade = false;
225         uint256 _remain = balanceOf[this];
226         require(balanceOf[msg.sender] + _remain >= _remain);
227         balanceOf[msg.sender] += _remain;
228         balanceOf[this] -= _remain;
229         Transfer(this, msg.sender, _remain);
230         return true;
231     }
232 
233     function () {
234         revert();
235     }
236 }