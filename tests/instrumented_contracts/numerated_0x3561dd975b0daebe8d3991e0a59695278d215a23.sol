1 pragma solidity ^0.4.23;
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
58 	event FreezeAccount(address indexed _target, bool _frozen, uint _timestamp);
59 	event CertifyAccount(address indexed _target, bool _certified, uint _timestamp);
60 }
61 
62 contract ERC20Token is ERC20 {
63     using SafeMath for uint;
64     uint public totalToken;
65 	bool public frozen;
66     mapping(address => uint) balances;
67     mapping (address => mapping (address => uint)) allowances;
68 	mapping (address => bool) public frozenAccounts;
69 	mapping (address => bool) public certifiedAccounts;
70 
71     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
72 		require(_from != 0x0 && _to != 0x0);
73         require(balances[_from] >= _value && _value > 0);
74         require(balances[_to] + _value > balances[_to]);
75 		require(!frozen);
76 		require(!frozenAccounts[_from]);                     
77         require(!frozenAccounts[_to]);                       
78         uint previousBalances = balances[_from] + balances[_to];
79         balances[_from] = balances[_from].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         emit Transfer(_from, _to, _value);
82 		assert(balances[_from] + balances[_to] == previousBalances);
83         return true;
84     }
85 
86     function transfer(address _to, uint _value) public returns (bool success) {
87         return _transfer(msg.sender, _to,  _value) ;
88     }
89 
90     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
91         require(allowances[_from][msg.sender] >= _value);     
92 		allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
93         return _transfer(_from, _to, _value);
94     }
95 
96     function totalSupply() public view returns (uint) {
97         return totalToken;
98     }
99 
100     function balanceOf(address _owner) public view returns (uint balance) {
101         return balances[_owner];
102     }
103 
104     function approve(address _spender, uint _value) public returns (bool success) {
105         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
106         allowances[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint remaining) {
112         return allowances[_owner][_spender];
113     }
114 }
115 
116 contract Lover is ERC20Token, Owned {
117 	string public name = "Lover";
118     string public symbol = "LOV";
119     uint public constant decimals = 18;
120 	string public note = "(C) loverchain.com all rights reserved";
121     uint public burnedToken;
122 	uint public fee;
123 	mapping (address => string) public keys;
124 	mapping (address => string) public signatures;
125 	mapping (address => string) public identities;
126 	mapping (address => uint) public scores;
127 	mapping (address => uint) public levels;
128     mapping (address => uint) public stars;
129     mapping (address => string) public profiles;
130 	mapping (address => string) public properties;
131 	mapping (address => string) public rules;
132     mapping (address => string) public funds;
133 	mapping (address => uint) public nonces;
134 	event Key(address indexed _user, string indexed _key, uint _timestamp);
135 	event Sign(address indexed _user, string indexed _data, uint _timestamp);
136 	event Register(address indexed _user, string indexed _identity, address _certifier, uint _timestamp);
137 	event Rule(address indexed _user, string _rule, address indexed _certifier, uint _timestamp);
138 	event Fund(address indexed _user, string _fund, address indexed _certifier, uint _timestamp);
139 	event Save(address indexed _user, uint _score, uint _level, uint _star, address indexed _certifier, uint _nonce, uint _timestamp);
140 	event Burn(address indexed _from, uint _burntAmount, uint _timestamp);
141 
142     function Lover() public {
143 		totalToken = 1000000000000000000000000000;
144 		balances[msg.sender] = totalToken;
145 		owner = msg.sender;
146 	    frozen = false;
147 		fee = 100000000000000000000;
148 		certifiedAccounts[msg.sender] = true; 
149     }
150 
151     function burn(uint _burntAmount) public returns (bool success) {
152     	require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
153 		require(totalToken - _burntAmount >= 100000000000000000000000000);
154     	balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
155     	totalToken = totalToken.sub(_burntAmount);
156     	burnedToken = burnedToken.add(_burntAmount);
157     	emit Transfer(msg.sender, 0x0, _burntAmount);
158     	emit Burn(msg.sender, _burntAmount, now);
159     	return true;
160 	}
161 
162     function setKey(string _key) public {
163         require(bytes(_key).length >= 32);
164         keys[msg.sender] = _key;
165 		emit Key(msg.sender, _key, now);
166     }
167 
168     function sign(string _data) public {
169         require(bytes(_data).length >= 32);
170         signatures[msg.sender] = _data;
171 		emit Sign(msg.sender, _data, now);
172     }
173 
174 	function register(address _user, string _identity) public {
175 		require(bytes(_identity).length > 0);
176 		require(certifiedAccounts[msg.sender]);
177 		identities[_user] = _identity;
178 		emit Register(_user, _identity, msg.sender, now);
179     }
180 
181     function _save(address _user, uint _score, uint _level, uint _star, string _profile, string _property, address _certifier, uint _nonce, uint _timestamp) internal {
182 		require(_nonce == nonces[_user] + 1);  
183 	    if(bytes(_profile).length > 16){
184 			profiles[_user] = _profile;
185 		}
186 	    if(bytes(_property).length > 16){
187 		    properties[_user] = _property;
188 		}
189 		if(_level > levels[_user]){
190 			levels[_user] = _level;
191 		}
192 		scores[_user] = _score;
193         stars[_user] = _star;
194 		nonces[_user] = _nonce;
195 		emit Save(_user, _score, _level, _star, _certifier, _nonce, _timestamp);
196     }
197 
198     function save(address _user, uint _score, uint _level, uint _star, string _profile, string _property, uint _nonce) public {
199         require(certifiedAccounts[msg.sender]);  
200 		_save(_user, _score, _level, _star, _profile, _property, msg.sender, _nonce, now);
201     }
202 
203 	function _assign(address _from, address _to, address _certifier) internal {
204 		require(_from != 0x0 && _to != 0x0);
205 		uint _timestamp = now;
206 		uint _nonce = nonces[_from];
207 		_save(_to, scores[_from], levels[_from], stars[_from], profiles[_from], properties[_from], _certifier, _nonce, _timestamp);
208         profiles[_from] = "";
209         properties[_from] = "";
210 		scores[_from] = 0; 
211 		levels[_from] = 0;
212 		stars[_from] = 0;
213     }
214 
215     function assign(address _to) public {
216 		_transfer(msg.sender, owner, fee);
217 		_assign(msg.sender, _to, owner);
218 	}
219 
220 	function assignFrom(address _from, address _to) public {
221         require(certifiedAccounts[msg.sender]);
222 	    _assign(_from, _to, msg.sender);
223     }
224 
225     function setRule(address _user, string _rule) public {
226 		require(certifiedAccounts[msg.sender]);
227         rules[_user] = _rule;
228 		emit Rule(_user, _rule, msg.sender, now);
229     }
230 
231 	function setFund(address _user, string _fund) public {
232 		require(certifiedAccounts[msg.sender]);
233         funds[_user] = _fund;
234 		emit Fund(_user, _fund, msg.sender, now);
235     }
236     
237   	function freeze(bool _frozen) public onlyOwner {
238         frozen = _frozen;
239     }
240 
241     function freezeAccount(address _user, bool _frozen) public onlyOwner {
242         frozenAccounts[_user] = _frozen;
243         emit FreezeAccount(_user, _frozen, now);
244     }
245     
246 	function certifyAccount(address _user, bool _certified) public onlyOwner {
247         certifiedAccounts[_user] = _certified;
248         emit CertifyAccount(_user, _certified, now);
249     }
250     
251 	function setName(string _tokenName, string _tokenSymbol) public onlyOwner {
252         name = _tokenName;
253         symbol = _tokenSymbol; 
254 	}
255 
256 	function setNote(string _tokenNote) public onlyOwner {
257         note = _tokenNote;
258 	}
259 
260 	function setFee(uint _value) public onlyOwner {
261         fee = _value;
262 	}
263 
264     function random(uint _range) public view returns(uint) {
265 	    if(_range == 0) {
266 	       return 0;  
267 	    }
268         uint ran = uint(keccak256(block.difficulty, now));
269         return ran % _range;
270     }
271     
272     function shuffle(uint[] _tiles) public view returns(uint[]) {
273         uint len = _tiles.length;
274         uint[] memory t = _tiles; 
275         uint temp = 0;
276         uint ran = 0;
277         for (uint i = 0; i < len; i++) {
278            ran = random(i + 1);
279           if (ran != i){
280               temp = t[i];
281               t[i] = t[ran];
282               t[ran] = temp;
283           }
284         }
285         return t;
286    }
287 }