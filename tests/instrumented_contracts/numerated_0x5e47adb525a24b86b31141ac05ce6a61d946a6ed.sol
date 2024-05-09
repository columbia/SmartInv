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
86 contract Whitelist is owned {
87   mapping(address => bool) public whitelist;
88   
89   event WhitelistedAddressAdded(address addr);
90   event WhitelistedAddressRemoved(address addr);
91 
92 
93   modifier onlyWhitelisted() {
94     require(whitelist[msg.sender]);
95     _;
96   }
97 
98 
99   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
100     if (!whitelist[addr]) {
101       whitelist[addr] = true;
102       WhitelistedAddressAdded(addr);
103       success = true; 
104     }
105   }
106 
107 
108   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
109     for (uint256 i = 0; i < addrs.length; i++) {
110       if (addAddressToWhitelist(addrs[i])) {
111         success = true;
112       }
113     }
114   }
115 
116 
117   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
118     if (whitelist[addr]) {
119       whitelist[addr] = false;
120       WhitelistedAddressRemoved(addr);
121       success = true;
122     }
123   }
124 
125   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
126     for (uint256 i = 0; i < addrs.length; i++) {
127       if (removeAddressFromWhitelist(addrs[i])) {
128         success = true;
129       }
130     }
131   }
132 
133 }
134 
135 
136 
137 
138 
139 contract MyAdvancedToken is owned, token, Whitelist {
140 
141     mapping (address => bool) public frozenAccount;
142     bool frozen = false; 
143     event FrozenFunds(address target, bool frozen);
144 
145     function MyAdvancedToken(
146         uint256 initialSupply,
147         string tokenName,
148         uint8 decimalUnits,
149         string tokenSymbol
150     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
151 
152     function transfer(address _to, uint256 _value) {
153         require(whitelist[msg.sender]);
154         require(whitelist[_to]);
155         if (balanceOf[msg.sender] < _value) throw;
156         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
157         if (frozenAccount[msg.sender]) throw;
158         balanceOf[msg.sender] -= _value;
159         balanceOf[_to] += _value;
160         Transfer(msg.sender, _to, _value);
161     }
162 
163     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
164         require(whitelist[msg.sender]);
165         require(whitelist[_to]);
166         if (frozenAccount[_from]) throw;
167         if (balanceOf[_from] < _value) throw;
168         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
169         if (_value > allowance[_from][msg.sender]) throw;
170         balanceOf[_from] -= _value;
171         balanceOf[_to] += _value;
172         allowance[_from][msg.sender] -= _value;
173         Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     function mintToken(address target, uint256 mintedAmount) onlyOwner {
178         balanceOf[target] += mintedAmount;
179         totalSupply += mintedAmount;
180         Transfer(0, this, mintedAmount);
181         Transfer(this, target, mintedAmount);
182     }
183 
184     function freezeAccount(address target, bool freeze) onlyOwner {
185         frozenAccount[target] = freeze;
186         FrozenFunds(target, freeze);
187     }
188     function unfreezeAccount(address target, bool freeze) onlyOwner {
189         frozenAccount[target] = !freeze;
190         FrozenFunds(target, !freeze);
191     }
192   function freezeTransfers () {
193     require (msg.sender == owner);
194 
195     if (!frozen) {
196       frozen = true;
197       Freeze ();
198     }
199   }
200 
201   function unfreezeTransfers () {
202     require (msg.sender == owner);
203 
204     if (frozen) {
205       frozen = false;
206       Unfreeze ();
207     }
208   }
209 
210 
211   event Freeze ();
212 
213   event Unfreeze ();
214 
215     function burn(uint256 _value) public returns (bool success) {        
216         require(balanceOf[msg.sender] >= _value);
217         balanceOf[msg.sender] -= _value;
218         totalSupply -= _value;
219         Burn(msg.sender, _value);        
220         return true;
221     }
222     
223     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
224         require(balanceOf[_from] >= _value);
225         require(_value <= allowance[_from][msg.sender]);
226         balanceOf[_from] -= _value;
227         allowance[_from][msg.sender] -= _value;
228         totalSupply -= _value;
229         Burn(_from, _value);        
230         return true;
231     }
232     
233     function set_Name(string _name) onlyOwner {
234         name = _name;
235     }
236     
237     function set_symbol(string _symbol) onlyOwner {
238         symbol = _symbol;
239     }
240     
241 }