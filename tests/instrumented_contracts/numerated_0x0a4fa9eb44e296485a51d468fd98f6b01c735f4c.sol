1 pragma solidity 0.4.12;
2 
3 /**
4 
5  * ╔═════╗ ╦═╦ ╦═╦     ╔═╗    ╔═╗    ╦═══════╦ ╔═════╗ ╦═╦ ╔═╦ ╔══════╗ ╔══╗  ╦═╦
6  * ║ ╔═══╩ ║ ║ ║ ║     ║ ╚╗  ╔╝ ║    ╚══╗ ╔══╝ ║ ╔═╗ ║ ║ ║╔╝ ║ ║ ╔════╝ ║  ╚╗ ║ ║
7  * ║ ╚═╦   ║ ║ ║ ║     ║  ╚╗╔╝  ║       ║ ║    ║ ║ ║ ║ ║ ╚╝ ╔╝ ║ ╚═══╗  ║ ╔╗╚╗║ ║
8  * ║ ╔═╝   ║ ║ ║ ║     ║   ╚╝   ║       ║ ║    ║ ║ ║ ║ ║ ╔╗ ╚╗ ║ ╔═══╝  ║ ║╚╗╚╝ ║
9  * ║ ║     ║ ║ ║ ╚═══╣ ║ ╔╗  ╔╗ ║       ║ ║    ║ ╚═╝ ║ ║ ║╚╗ ║ ║ ╚════╗ ║ ║ ╚╗  ║
10  * ╩═╩     ╩═╩ ╩═════╝ ╩═╝╚══╝╚═╩       ╩═╩    ╚═════╝ ╩═╩ ╚═╩ ╚══════╝ ╩═╩  ╚══╝
11  * 
12  * ╔═╗╦ ╦  ╔╦╗  ╔═╗ ╔═╗╔═╗╔═╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
13  * ╠╣ ║ ║  ║║║  ╠═╩╗╠═╣╚═╗╠╣   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
14  * ╩  ╩ ╚═╝╩ ╩  ╩══╝╩ ╩╚═╝╚═╝  ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘ 
15  */
16  
17 contract owned {
18     address public owner;
19 
20     function owned() {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         if (msg.sender != owner) throw;
26         _;
27     }
28 
29     function transferOwnership(address newOwner) onlyOwner {
30         owner = newOwner;
31     }
32 }
33 
34 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
35 
36 contract token {
37     string public standard = 'Token 0.1';
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42     event Burn(address indexed from, uint256 value);
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     function token(
50         uint256 initialSupply,
51         string tokenName,
52         uint8 decimalUnits,
53         string tokenSymbol
54         ) {
55         balanceOf[msg.sender] = initialSupply;
56         totalSupply = initialSupply;
57         name = tokenName;
58         symbol = tokenSymbol;
59         decimals = decimalUnits;
60     }
61 
62     function transfer(address _to, uint256 _value) {
63         if (balanceOf[msg.sender] < _value) throw;
64         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
65         balanceOf[msg.sender] -= _value;
66         balanceOf[_to] += _value;
67         Transfer(msg.sender, _to, _value);
68     }
69 
70     function approve(address _spender, uint256 _value)
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
77         returns (bool success) {    
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         if (balanceOf[_from] < _value) throw;
87         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
88         if (_value > allowance[_from][msg.sender]) throw;
89         balanceOf[_from] -= _value;
90         balanceOf[_to] += _value;
91         allowance[_from][msg.sender] -= _value;
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function () {
97         throw;
98     }
99 }
100 
101 contract FILMToken is owned, token {
102 
103     mapping (address => bool) public frozenAccount;
104     bool frozen = false; 
105     event FrozenFunds(address target, bool frozen);
106 
107     function FILMToken(
108         uint256 initialSupply,
109         string tokenName,
110         uint8 decimalUnits,
111         string tokenSymbol
112     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
113 
114     function transfer(address _to, uint256 _value) {
115         if (balanceOf[msg.sender] < _value) throw;
116         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
117         if (frozenAccount[msg.sender]) throw;
118         balanceOf[msg.sender] -= _value;
119         balanceOf[_to] += _value;
120         Transfer(msg.sender, _to, _value);
121     }
122 
123     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
124         if (frozenAccount[_from]) throw;
125         if (balanceOf[_from] < _value) throw;
126         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
127         if (_value > allowance[_from][msg.sender]) throw;
128         balanceOf[_from] -= _value;
129         balanceOf[_to] += _value;
130         allowance[_from][msg.sender] -= _value;
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135 
136     function freezeAccount(address target, bool freeze) onlyOwner {
137         frozenAccount[target] = freeze;
138         FrozenFunds(target, freeze);
139     }
140     function unfreezeAccount(address target, bool freeze) onlyOwner {
141         frozenAccount[target] = !freeze;
142         FrozenFunds(target, !freeze);
143     }
144   function freezeTransfers () {
145     require (msg.sender == owner);
146 
147     if (!frozen) {
148       frozen = true;
149       Freeze ();
150     }
151   }
152 
153   function unfreezeTransfers () {
154     require (msg.sender == owner);
155 
156     if (frozen) {
157       frozen = false;
158       Unfreeze ();
159     }
160   }
161 
162 
163   event Freeze ();
164 
165   event Unfreeze ();
166 
167     function burn(uint256 _value) public returns (bool success) {        
168         require(balanceOf[msg.sender] >= _value);
169         balanceOf[msg.sender] -= _value;
170         totalSupply -= _value;
171         Burn(msg.sender, _value);        
172         return true;
173     }
174     
175     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
176         require(balanceOf[_from] >= _value);
177         require(_value <= allowance[_from][msg.sender]);
178         balanceOf[_from] -= _value;
179         allowance[_from][msg.sender] -= _value;
180         totalSupply -= _value;
181         Burn(_from, _value);        
182         return true;
183     }
184 }