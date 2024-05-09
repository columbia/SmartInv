1 pragma solidity 0.4.12;
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
86 contract MyAdvancedToken is owned, token {
87 
88     mapping (address => bool) public frozenAccount;
89 
90     event FrozenFunds(address target, bool frozen);
91 
92     function MyAdvancedToken(
93         uint256 initialSupply,
94         string tokenName,
95         uint8 decimalUnits,
96         string tokenSymbol
97     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
98 
99     function transfer(address _to, uint256 _value) {
100         if (balanceOf[msg.sender] < _value) throw;
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
102         if (frozenAccount[msg.sender]) throw;
103         balanceOf[msg.sender] -= _value;
104         balanceOf[_to] += _value;
105         Transfer(msg.sender, _to, _value);
106     }
107 
108     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
109         if (frozenAccount[_from]) throw;
110         if (balanceOf[_from] < _value) throw;
111         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
112         if (_value > allowance[_from][msg.sender]) throw;
113         balanceOf[_from] -= _value;
114         balanceOf[_to] += _value;
115         allowance[_from][msg.sender] -= _value;
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     function mintToken(address target, uint256 mintedAmount) onlyOwner {
121         balanceOf[target] += mintedAmount;
122         totalSupply += mintedAmount;
123         Transfer(0, this, mintedAmount);
124         Transfer(this, target, mintedAmount);
125     }
126 
127     function freezeAccount(address target, bool freeze) onlyOwner {
128         frozenAccount[target] = freeze;
129         FrozenFunds(target, freeze);
130     }
131     function unfreezeAccount(address target, bool freeze) onlyOwner {
132         frozenAccount[target] = !freeze;
133         FrozenFunds(target, !freeze);
134     }
135 
136     function burn(uint256 _value) public returns (bool success) {        
137         require(balanceOf[msg.sender] >= _value);
138         balanceOf[msg.sender] -= _value;
139         totalSupply -= _value;
140         Burn(msg.sender, _value);        
141         return true;
142     }
143     
144     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
145         require(balanceOf[_from] >= _value);
146         require(_value <= allowance[_from][msg.sender]);
147         balanceOf[_from] -= _value;
148         allowance[_from][msg.sender] -= _value;
149         totalSupply -= _value;
150         Burn(_from, _value);        
151         return true;
152     }
153 }