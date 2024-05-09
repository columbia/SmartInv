1 pragma solidity 0.4.23;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract token {
22     string public standard = 'Token 0.1';
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27     event Burn(address indexed from, uint256 value);
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     function token(
35         uint256 initialSupply,
36         string tokenName,
37         uint8 decimalUnits,
38         string tokenSymbol
39         ) {
40         balanceOf[msg.sender] = initialSupply;
41         totalSupply = initialSupply;
42         name = tokenName;
43         symbol = tokenSymbol;
44         decimals = decimalUnits;
45     }
46 
47     function transfer(address _to, uint256 _value) {
48         if (balanceOf[msg.sender] < _value) throw;
49         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
50         balanceOf[msg.sender] -= _value;
51         balanceOf[_to] += _value;
52         Transfer(msg.sender, _to, _value);
53     }
54 
55     function approve(address _spender, uint256 _value)
56         returns (bool success) {
57         allowance[msg.sender][_spender] = _value;
58         return true;
59     }
60 
61     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
62         returns (bool success) {    
63         tokenRecipient spender = tokenRecipient(_spender);
64         if (approve(_spender, _value)) {
65             spender.receiveApproval(msg.sender, _value, this, _extraData);
66             return true;
67         }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (balanceOf[_from] < _value) throw;
72         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
73         if (_value > allowance[_from][msg.sender]) throw;
74         balanceOf[_from] -= _value;
75         balanceOf[_to] += _value;
76         allowance[_from][msg.sender] -= _value;
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function () {
82         throw;
83     }
84 }
85 
86 
87 contract MyAdvancedToken is owned, token {
88 
89     mapping (address => bool) public frozenAccount;
90     bool frozen = false; 
91     event FrozenFunds(address target, bool frozen);
92 
93     function MyAdvancedToken(
94         uint256 initialSupply,
95         string tokenName,
96         uint8 decimalUnits,
97         string tokenSymbol
98     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
99 
100     function transfer(address _to, uint256 _value) {
101         if (balanceOf[msg.sender] < _value) throw;
102         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
103         if (frozenAccount[msg.sender]) throw;
104         balanceOf[msg.sender] -= _value;
105         balanceOf[_to] += _value;
106         Transfer(msg.sender, _to, _value);
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         if (frozenAccount[_from]) throw;
111         if (balanceOf[_from] < _value) throw;
112         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
113         if (_value > allowance[_from][msg.sender]) throw;
114         balanceOf[_from] -= _value;
115         balanceOf[_to] += _value;
116         allowance[_from][msg.sender] -= _value;
117         Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function mintToken(address target, uint256 mintedAmount) onlyOwner {
122         balanceOf[target] += mintedAmount;
123         totalSupply += mintedAmount;
124         Transfer(0, this, mintedAmount);
125         Transfer(this, target, mintedAmount);
126     }
127 
128     function freezeAccount(address target, bool freeze) onlyOwner {
129         frozenAccount[target] = freeze;
130         FrozenFunds(target, freeze);
131     }
132     function unfreezeAccount(address target, bool freeze) onlyOwner {
133         frozenAccount[target] = !freeze;
134         FrozenFunds(target, !freeze);
135     }
136   function freezeTransfers () {
137     require (msg.sender == owner);
138 
139     if (!frozen) {
140       frozen = true;
141       Freeze ();
142     }
143   }
144 
145   function unfreezeTransfers () {
146     require (msg.sender == owner);
147 
148     if (frozen) {
149       frozen = false;
150       Unfreeze ();
151     }
152   }
153 
154 
155   event Freeze ();
156 
157   event Unfreeze ();
158 
159     function burn(uint256 _value) public returns (bool success) {        
160         require(balanceOf[msg.sender] >= _value);
161         balanceOf[msg.sender] -= _value;
162         totalSupply -= _value;
163         Burn(msg.sender, _value);        
164         return true;
165     }
166     
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
168         require(balanceOf[_from] >= _value);
169         require(_value <= allowance[_from][msg.sender]);
170         balanceOf[_from] -= _value;
171         allowance[_from][msg.sender] -= _value;
172         totalSupply -= _value;
173         Burn(_from, _value);        
174         return true;
175     }
176     
177     function set_Name(string _name) onlyOwner {
178         name = _name;
179     }
180     
181     function set_symbol(string _symbol) onlyOwner {
182         symbol = _symbol;
183     }
184     
185 }