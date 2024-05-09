1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         //Default assumes totalSupply can't be over max (2^256 - 1).
51         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
52         //Replace the if with this one instead.
53         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
54         if (balances[msg.sender] >= _value && _value > 0) {
55             balances[msg.sender] -= _value;
56             balances[_to] += _value;
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91 
92 contract HumanStandardToken is StandardToken {
93 
94     function () {
95         throw;
96     }
97 
98     string public name;
99     uint8 public decimals;
100     string public symbol;
101     string public version = 'H0.1';
102 
103     function HumanStandardToken(
104         uint256 _initialAmount,
105         string _tokenName,
106         uint8 _decimalUnits,
107         string _tokenSymbol
108         ) {
109         balances[msg.sender] = _initialAmount;
110         totalSupply = _initialAmount;
111         name = _tokenName;
112         decimals = _decimalUnits;
113         symbol = _tokenSymbol;
114     }
115 
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
120         return true;
121     }
122 }
123 
124 contract Owned {
125   address owner;
126 
127   bool frozen = false;
128 
129   function Owned() {
130     owner = msg.sender;
131   }
132 
133   modifier onlyOwner() {
134     require(msg.sender == owner);
135     _;
136   }
137 
138   modifier publicMethod() {
139     require(!frozen);
140     _;
141   }
142 
143   function drain() onlyOwner {
144     owner.transfer(this.balance);
145   }
146 
147   function freeze() onlyOwner {
148     frozen = true;
149   }
150 
151   function unfreeze() onlyOwner {
152     frozen = false;
153   }
154 
155   function destroy() onlyOwner {
156     selfdestruct(owner);
157   }
158 }
159 
160 contract Pixel is Owned, HumanStandardToken {
161   uint32 public size = 1000;
162   uint32 public size2 = size*size;
163 
164   mapping (uint32 => uint24) public pixels;
165   mapping (uint32 => address) public owners;
166 
167   event Set(address indexed _from, uint32[] _xys, uint24[] _rgbs);
168   event Unset(address indexed _from, uint32[] _xys);
169 
170   // Constructor.
171   function Pixel() HumanStandardToken(size2, "Pixel", 0, "PXL") {
172   }
173 
174   // Public interface.
175   function set(uint32[] _xys, uint24[] _rgbs) publicMethod() {
176     address _from = msg.sender;
177 
178     require(_xys.length == _rgbs.length);
179     require(balances[_from] >= _xys.length);
180 
181     uint32 _xy; uint24 _rgb;
182     for (uint i = 0; i < _xys.length; i++) {
183       _xy = _xys[i];
184       _rgb = _rgbs[i];
185 
186       require(_xy < size2);
187       require(owners[_xy] == 0);
188 
189       owners[_xy] = _from;
190       pixels[_xy] = _rgb;
191     }
192 
193     balances[_from] -= _xys.length;
194 
195     Set(_from, _xys, _rgbs);
196   }
197 
198   function unset(uint32[] _xys) publicMethod() {
199     address _from = msg.sender;
200 
201     uint32 _xy;
202     for (uint i = 0; i < _xys.length; i++) {
203       _xy = _xys[i];
204 
205       require(owners[_xy] == _from);
206 
207       balances[_from] += 1;
208       owners[_xy] = 0;
209       pixels[_xy] = 0;
210     }
211 
212     Unset(_from, _xys);
213   }
214 
215   // Constants.
216   function row(uint32 _y) constant returns (uint24[1000], address[1000]) {
217     uint32 _start = _y * size;
218 
219     uint24[1000] memory rgbs;
220     address[1000] memory addrs;
221 
222     for (uint32 i = 0; i < 1000; i++) {
223       rgbs[i] = pixels[_start + i];
224       addrs[i] = owners[_start + i];
225     }
226 
227     return (rgbs, addrs);
228   }
229 }