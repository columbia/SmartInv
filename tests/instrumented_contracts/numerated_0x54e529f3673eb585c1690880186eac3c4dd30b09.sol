1 pragma solidity ^0.4.22;
2 
3 
4 contract Utils {
5 	function Utils() public {
6 	}
7 
8 	// function compareStrings (string a, string b) view returns (bool){
9 	// 	return keccak256(a) == keccak256(b);
10 	// }
11 
12 	// // verifies that an amount is greater than zero
13 	// modifier greaterThanZero(uint256 _amount) {
14 	//     require(_amount > 0);
15 	//     _;
16 	// }
17 
18 	// validates an address - currently only checks that it isn't null
19 	modifier validAddress(address _address) {
20 	    require(_address != address(0));
21 	    _;
22 	}
23 
24 	// verifies that the address is different than this contract address
25 	modifier notThis(address _address) {
26 	    require(_address != address(this));
27 	    _;
28 	}
29 
30 	function strlen(string s) internal pure returns (uint) {
31 		// Starting here means the LSB will be the byte we care about
32 		uint ptr;
33 		uint end;
34 		assembly {
35 			ptr := add(s, 1)
36 			end := add(mload(s), ptr)
37 		}
38 
39 		for (uint len = 0; ptr < end; len++) {
40 			uint8 b;
41 			assembly { b := and(mload(ptr), 0xFF) }
42 			if (b < 0x80) {
43 				ptr += 1;
44 			} else if(b < 0xE0) {
45 				ptr += 2;
46 			} else if(b < 0xF0) {
47 				ptr += 3;
48 			} else if(b < 0xF8) {
49 				ptr += 4;
50 			} else if(b < 0xFC) {
51 				ptr += 5;
52 			} else {
53 				ptr += 6;
54 			}
55 		}
56 
57 		return len;
58 	}
59 
60 
61 }
62 
63 
64 contract SafeMath {
65 	function SafeMath() {
66 	}
67 
68 	function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
69 		uint256 z = _x + _y;
70 		assert(z >= _x);
71 		return z;
72 	}
73 
74 	function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
75 		assert(_x >= _y);
76 		return _x - _y;
77 	}
78 
79 	function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
80 		uint256 z = _x * _y;
81 		assert(_x == 0 || z / _x == _y);
82 		return z;
83 	}
84 
85 	function safeDiv(uint a, uint b) internal returns (uint256) {
86 		assert(b > 0);
87 		return a / b;
88 	}
89 }
90 
91 
92 contract ERC20Interface {
93     // function totalSupply() public constant returns (uint);
94     // function balanceOf(address tokenOwner) public constant returns (uint balance);
95     // function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
96     function transfer(address to, uint tokens) public returns (bool success);
97     function approve(address spender, uint tokens) public returns (bool success);
98     function transferFrom(address from, address to, uint tokens) public returns (bool success);
99 
100     event Transfer(address indexed from, address indexed to, uint tokens);
101     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
102 }
103 
104 
105 /*
106     Provides support and utilities for contract ownership
107 */
108 contract Owned {
109     address public owner;
110     address public newOwner;
111 
112     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
113 
114     /**
115         @dev constructor
116     */
117     function Owned() public {
118         owner = msg.sender;
119     }
120 
121     // allows execution by the owner only
122     modifier ownerOnly {
123         assert(msg.sender == owner);
124         _;
125     }
126 
127     /**
128         @dev allows transferring the contract ownership
129         the new owner still needs to accept the transfer
130         can only be called by the contract owner
131 
132         @param _newOwner    new contract owner
133     */
134     function transferOwnership(address _newOwner) public ownerOnly {
135         require(_newOwner != owner);
136         newOwner = _newOwner;
137     }
138 
139     /**
140         @dev used by a new owner to accept an ownership transfer
141     */
142     function acceptOwnership() public {
143         require(msg.sender == newOwner);
144         OwnerUpdate(owner, newOwner);
145         owner = newOwner;
146         newOwner = address(0);
147     }
148 }
149 
150 
151 
152 
153 
154 
155 
156 
157 contract bundinha is Utils {
158 	uint N;
159 	string bundinha;
160 
161 
162 	function setN(uint x) public {
163 		N = x;
164 	}
165 
166 	function getN() constant public returns (uint) {
167 		return N;
168 	}
169 
170 	function setBundinha(string x) public {
171 		require(strlen(x) <= 32);
172 		bundinha = x;
173 	}
174 
175 	function getBundinha() constant public returns (string){
176 		return bundinha;
177 	}
178 
179 }
180 
181 
182 
183 
184 
185 contract SomeCoin is Utils, ERC20Interface, Owned, SafeMath, bundinha {
186 	uint myVariable;
187 	string bundinha;
188 
189 	string public name = '';
190 	string public symbol = '';
191 	uint8 public decimals = 0;
192 	uint256 public totalSupply = 0;
193 	uint256 public maxSupply = 50000000000000000000000;
194 							// 50000.
195 
196 	mapping (address => uint256) public balanceOf;
197 	mapping (address => mapping (address => uint256)) public allowance;
198 
199 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
200 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
201     event Issuance(uint256 _amount);
202 
203 	// function SomeCoin(string _name, string _symbol, uint8 _decimals, uint256 supply) {
204 	function SomeCoin(string _name, string _symbol, uint8 _decimals) {
205 		require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
206 
207 		name = _name;
208 		symbol = _symbol;
209 		decimals = _decimals;
210 		// totalSupply = supply;
211 	}
212 
213 	function validSupply() private returns(bool) {
214 		return totalSupply <= maxSupply;
215 	}
216 
217 	function transfer(address _to, uint256 _value)
218 		public
219 		validAddress(_to)
220 		returns (bool success)
221 	{
222 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
223 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
224 		Transfer(msg.sender, _to, _value);
225 		return true;
226 	}
227 
228 	function transferFrom(address _from, address _to, uint256 _value)
229 		public
230 		validAddress(_from)
231 		validAddress(_to)
232 		returns (bool success)
233 	{
234 		allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
235 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
236 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
237 		Transfer(_from, _to, _value);
238 		return true;
239 	}
240 
241 	function approve(address _spender, uint256 _value)
242 		public
243 		validAddress(_spender)
244 		returns (bool success)
245 	{
246 		require(_value == 0 || allowance[msg.sender][_spender] == 0);
247 
248 		allowance[msg.sender][_spender] = _value;
249 		Approval(msg.sender, _spender, _value);
250 		return true;
251 	}
252 
253 	function issue(address _to, uint256 _amount)
254 	    public
255 	    ownerOnly
256 	    validAddress(_to)
257 	    notThis(_to)
258 	{
259 	    totalSupply = safeAdd(totalSupply, _amount);
260 	    balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
261 
262 	    require(validSupply());
263 
264 	    Issuance(_amount);
265 	    Transfer(this, _to, _amount);
266 	}
267 
268 	function transferAnyERC20Token(address _token, address _to, uint256 _amount)
269 		public
270 		ownerOnly
271 	    validAddress(_token)
272 		returns (bool success)
273 	{
274 		return ERC20Interface(_token).transfer(_to, _amount);
275 	}
276 
277 	// Don't accept ETH
278 	function () payable {
279 		revert();
280 	}
281 }