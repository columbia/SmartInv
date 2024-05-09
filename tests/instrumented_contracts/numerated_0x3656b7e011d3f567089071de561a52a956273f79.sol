1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal pure returns (uint) {
5         if (a == 0) {
6           return 0;
7         }
8         uint c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     
13     function div(uint a, uint b) internal pure returns (uint) {
14         uint c = a / b;
15         return c;
16     }
17     
18     function sub(uint a, uint b) internal pure returns (uint) {
19         assert(b <= a);
20         return a - b;
21     }
22     
23     function add(uint a, uint b) internal pure returns (uint) {
24         uint c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33     modifier onlyOwner { require(msg.sender == owner); _; }
34     event Ownership(address _prevOwner, address _newOwner, uint _timestamp);
35 
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != owner);
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit Ownership(owner, newOwner, now);
44         owner = newOwner;
45         newOwner = 0x0;
46     }
47 }
48 
49 contract ERC20 {
50     function totalSupply() public view returns (uint _totalSupply);
51     function balanceOf(address _owner) public view returns (uint balance);
52     function transfer(address _to, uint _value) public returns (bool success);
53     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
54     function approve(address _spender, uint _value) public returns (bool success);
55     function allowance(address _owner, address _spender) public view returns (uint remaining);
56     event Transfer(address indexed _from, address indexed _to, uint _value);
57     event Approval(address indexed _owner, address indexed _spender, uint _value);
58 }
59 
60 contract ERC20Token is ERC20 {
61     using SafeMath for uint;
62     uint public totalToken;
63 	bool public frozen;
64     mapping (address => uint) balances;
65     mapping (address => mapping (address => uint)) allowances;
66 	mapping (address => bool) public frozenAccounts;
67 	
68     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
69 		require(_from != 0x0 && _to != 0x0);
70         require(balances[_from] >= _value && _value > 0);
71 		require(!frozen);
72 		require(!frozenAccounts[_from]);
73         require(!frozenAccounts[_to]);
74         uint previousBalances = balances[_from] + balances[_to];
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77 		assert(balances[_from] + balances[_to] == previousBalances);
78         emit Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function transfer(address _to, uint _value) public returns (bool success) {
83         return _transfer(msg.sender, _to,  _value) ;
84     }
85 
86     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
87         require(allowances[_from][msg.sender] >= _value);     
88 		allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
89         return _transfer(_from, _to, _value);
90     }
91 
92     function totalSupply() public view returns (uint) {
93         return totalToken;
94     }
95 
96     function balanceOf(address _owner) public view returns (uint balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint _value) public returns (bool success) {
101         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
102         allowances[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint remaining) {
108         return allowances[_owner][_spender];
109     }
110 }
111 
112 contract Lover is ERC20Token, Owned {
113 	string public name = "Lover";
114     string public symbol = "LOV";
115     uint public constant decimals = 18;
116 	string public note = "(C) Loverchain.com all rights reserved.";
117     uint public burnedToken;
118 	uint public fee;
119 	mapping (address => bool) public certifiedAccounts;
120 	mapping (address => string) public keys;
121 	mapping (address => string) public signatures;
122 	mapping (address => string) public identities;
123 	mapping (address => uint) public scores;
124 	mapping (address => uint) public levels;
125     mapping (address => uint) public stars;
126     mapping (address => string) public profiles;
127 	mapping (address => string) public properties;
128 	mapping (address => string) public rules;
129     mapping (address => string) public funds;
130 	mapping (address => uint) public nonces;
131 	event Key(address indexed _user, string indexed _key, uint _timestamp);
132 	event Sign(address indexed _user, string indexed _data, uint _timestamp);
133 	event Register(address indexed _user, string indexed _identity, address _certifier, uint _timestamp);
134 	event Rule(address indexed _user, string _rule, address indexed _certifier, uint _timestamp);
135 	event Fund(address indexed _user, string _fund, address indexed _certifier, uint _timestamp);
136 	event Save(address indexed _user, uint _score, uint _level, uint _star, address indexed _certifier, uint _nonce, uint _timestamp);
137 	event Burn(address indexed _from, uint _burntAmount, uint _timestamp);
138     event FreezeAccount(address indexed _target, bool _frozen, uint _timestamp);
139 	event CertifyAccount(address indexed _target, bool _certified, uint _timestamp);
140 
141     constructor() public {
142 		totalToken = 1000000000000000000000000000;
143 		balances[msg.sender] = totalToken;
144 		owner = msg.sender;
145 	    frozen = false;
146 		fee = 0;
147 		certifiedAccounts[msg.sender] = true; 
148     }
149 
150     function burn(uint _burntAmount) public returns (bool success) {
151     	require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
152     	balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
153     	totalToken = totalToken.sub(_burntAmount);
154     	burnedToken = burnedToken.add(_burntAmount);
155     	emit Transfer(msg.sender, 0x0, _burntAmount);
156     	emit Burn(msg.sender, _burntAmount, now);
157     	return true;
158 	}
159 
160     function setKey(string _key) public {
161         require(bytes(_key).length > 1);
162         keys[msg.sender] = _key;
163 		emit Key(msg.sender, _key, now);
164     }
165 
166     function sign(string _data) public {
167         require(bytes(_data).length > 1);
168         signatures[msg.sender] = _data;
169 		emit Sign(msg.sender, _data, now);
170     }
171 
172 	function register(address _user, string _identity) public {
173 		require(bytes(_identity).length > 1);
174 		require(certifiedAccounts[msg.sender]);
175 		identities[_user] = _identity;
176 		emit Register(_user, _identity, msg.sender, now);
177     }
178 
179     function _save(address _user, uint _score, uint _level, uint _star, string _profile, string _property, address _certifier, uint _nonce, uint _timestamp) internal returns (bool success){
180 		require(_nonce > nonces[_user]);
181 		require(!frozen);
182 		require(!frozenAccounts[_user]); 
183 	    if(bytes(_profile).length > 1){
184 			profiles[_user] = _profile;
185 		}
186 	    if(bytes(_property).length > 1){
187 		    properties[_user] = _property;
188 		}
189 		levels[_user] = _level;
190 		scores[_user] = _score;
191         stars[_user] = _star;
192 		nonces[_user] = _nonce;
193 		emit Save(_user, _score, _level, _star, _certifier, _nonce, _timestamp);
194 		return true;
195     }
196 
197     function save(address _user, uint _score, uint _level, uint _star, string _profile, string _property, uint _nonce) public returns (bool success){
198         require(certifiedAccounts[msg.sender]);  
199 		return _save(_user, _score, _level, _star, _profile, _property, msg.sender, _nonce, now);
200     }
201 
202 	function _assign(address _from, address _to, address _certifier) internal returns (bool success){
203 		require(_from != 0x0 && _to != 0x0);
204 		require(!frozen);
205 		require(!frozenAccounts[_from]);
206         require(!frozenAccounts[_to]); 
207 		_save(_to, scores[_from], levels[_from], stars[_from], profiles[_from], properties[_from], _certifier, nonces[_from], now);
208         profiles[_from] = "";
209         properties[_from] = "";
210 		scores[_from] = 0; 
211 		levels[_from] = 0;
212 		stars[_from] = 0;
213 		return true;
214     }
215 
216     function assign(address _to) public returns (bool success){
217         require(nonces[_to] == 0);
218 		return _assign(msg.sender, _to, msg.sender);
219 	}
220 
221 	function assignFrom(address _from, address _to) public returns (bool success){
222         require(certifiedAccounts[msg.sender]);
223 	    return _assign(_from, _to, msg.sender);
224     }
225 
226     function setRule(address _user, string _rule) public {
227 		require(certifiedAccounts[msg.sender]);
228         rules[_user] = _rule;
229 		emit Rule(_user, _rule, msg.sender, now);
230     }
231 
232 	function setFund(address _user, string _fund) public {
233 		require(certifiedAccounts[msg.sender]);
234         funds[_user] = _fund;
235 		emit Fund(_user, _fund, msg.sender, now);
236     }
237     
238   	function freeze(bool _frozen) public onlyOwner {
239         frozen = _frozen;
240     }
241 
242     function freezeAccount(address _user, bool _frozen) public onlyOwner {
243         frozenAccounts[_user] = _frozen;
244         emit FreezeAccount(_user, _frozen, now);
245     }
246     
247 	function certifyAccount(address _user, bool _certified) public onlyOwner {
248         certifiedAccounts[_user] = _certified;
249         emit CertifyAccount(_user, _certified, now);
250     }
251 
252 	function transferToken(address _tokenAddress, address _recipient, uint _value) public onlyOwner returns (bool success) {
253         return ERC20(_tokenAddress).transfer(_recipient, _value);
254     }
255 
256 	function setName(string _tokenName, string _tokenSymbol) public onlyOwner {
257         name = _tokenName;
258         symbol = _tokenSymbol; 
259 	}
260 
261 	function setNote(string _tokenNote) public onlyOwner {
262         note = _tokenNote;
263 	}
264 
265 	function setFee(uint _value) public onlyOwner {
266         fee = _value;
267 	}
268 
269     function random(uint _range) public view returns(uint) {
270 	    if(_range == 0) {
271 	       return 0;  
272 	    }
273         uint ran = uint(keccak256(abi.encodePacked(block.difficulty, now)));
274         return ran % _range;
275     }
276     
277     function shuffle(uint[] _values) public view returns(uint[]) {
278         uint len = _values.length;
279         uint[] memory t = _values; 
280         uint temp = 0;
281         uint ran = 0;
282         for (uint i = 0; i < len; i++) {
283            ran = random(i + 1);
284           if (ran != i){
285               temp = t[i];
286               t[i] = t[ran];
287               t[ran] = temp;
288           }
289         }
290         return t;
291    }
292 }