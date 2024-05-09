1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 /* taking ideas from FirstBlood token */
18 contract SafeMath {
19 
20     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
21       uint256 z = x + y;
22       assert((z >= x) && (z >= y));
23       return z;
24     }
25 
26     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
27       assert(x >= y);
28       uint256 z = x - y;
29       return z;
30     }
31 
32     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
33       uint256 z = x * y;
34       assert((x == 0)||(z/x == y));
35       return z;
36     }
37 
38 }
39 
40 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
41 
42 contract ComBillToken {
43     /* Public variables of the token */
44     string public standard = "Token 0.1";
45     string public name;
46     string public symbol;
47     uint8 public decimals = 18;
48     uint256 public totalSupply;
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Burn(address indexed from, uint256 value);
54 
55     function ComBillToken(
56         uint256 initialSupply,
57         string tokenName,
58         string tokenSymbol
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);
61         balanceOf[msg.sender] = totalSupply; 
62         name = tokenName;
63         symbol = tokenSymbol;
64     }
65 
66     function _transfer(address _from, address _to, uint _value) internal {
67         require(_to != 0x0);
68         require(balanceOf[_from] >= _value);
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         balanceOf[_from] -= _value;
72         balanceOf[_to] += _value;
73         Transfer(_from, _to, _value);
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(_value <= allowance[_from][msg.sender]);
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     function approve(address _spender, uint256 _value) public
89         returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95         public
96         returns (bool success) {
97         tokenRecipient spender = tokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }
103 
104     function burn(uint256 _value) public returns (bool success) {
105         require(balanceOf[msg.sender] >= _value);
106         balanceOf[msg.sender] -= _value;
107         totalSupply -= _value;
108         Burn(msg.sender, _value);
109         return true;
110     }
111 
112     function burnFrom(address _from, uint256 _value) public returns (bool success) {
113         require(balanceOf[_from] >= _value);
114         require(_value <= allowance[_from][msg.sender]);
115         balanceOf[_from] -= _value; 
116         allowance[_from][msg.sender] -= _value;
117         totalSupply -= _value;
118         Burn(_from, _value);
119         return true;
120     }
121 }
122 
123 contract ComBillAdvancedToken is owned, ComBillToken, SafeMath {
124 
125     uint256 public sellPrice;
126     uint256 public buyPrice;
127 
128     mapping (address => bool) public frozenAccount;
129 
130     event FrozenFunds(address target, bool frozen);
131 
132     function ComBillAdvancedToken(
133         uint256 initialSupply,
134         string tokenName,
135         string tokenSymbol
136     ) ComBillToken(initialSupply, tokenName, tokenSymbol) public {}
137 
138     function _transfer(address _from, address _to, uint _value) internal {
139         require (_to != 0x0);
140         require (balanceOf[_from] >= _value);
141         require (balanceOf[_to] + _value > balanceOf[_to]);
142         require(!frozenAccount[_from]);
143         require(!frozenAccount[_to]); 
144         balanceOf[_from] -= _value;
145         balanceOf[_to] += _value;
146         Transfer(_from, _to, _value);
147     }
148 
149     function transfer(address _to, uint256 _value) public {
150         _transfer(msg.sender, _to, _value);
151     }
152 
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154         require(_value <= allowance[_from][msg.sender]);
155         allowance[_from][msg.sender] -= _value;
156         _transfer(_from, _to, _value);
157         return true;
158     }
159 
160     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
161         balanceOf[target] += mintedAmount;
162         totalSupply += mintedAmount;
163         Transfer(0, this, mintedAmount);
164         Transfer(this, target, mintedAmount);
165     }
166 
167     function freezeAccount(address target, bool freeze) onlyOwner public {
168         frozenAccount[target] = freeze;
169         FrozenFunds(target, freeze);
170     }
171 
172     function approvedAccount(address target, bool freeze) onlyOwner public {
173         frozenAccount[target] = freeze;
174         FrozenFunds(target, freeze);
175     }
176 
177     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
178         sellPrice = newSellPrice;
179         buyPrice = newBuyPrice;
180     }
181 
182     function buy() payable public {
183         uint amount = msg.value / buyPrice;
184         _transfer(this, msg.sender, amount);
185     }
186 
187     function sell(uint256 amount) public {
188 
189         require(this.balance >= amount * sellPrice); 
190         _transfer(msg.sender, this, amount);
191         msg.sender.transfer(amount * sellPrice);
192     }
193 }