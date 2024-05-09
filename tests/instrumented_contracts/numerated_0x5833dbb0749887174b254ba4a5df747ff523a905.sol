1 pragma solidity ^0.4.24;
2 
3 contract owned {
4 
5 	address public owner;
6 
7 	constructor() public {
8 
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner {
13 
14 		require(msg.sender == owner);
15 		_;
16 	}
17 
18 	function transferOwnership(address newOwner) onlyOwner public {
19 
20 		owner = newOwner;
21 	}
22 }
23 
24 contract administrator is owned {
25     
26     mapping (address => bool) public administrators;
27     
28     constructor() public {
29         
30         administrators[msg.sender] = true;
31     }
32     
33     modifier checkAdmin {
34         
35         require(administrators[msg.sender]);
36         _;
37     }
38     
39     function setAdmin(address target, bool set) onlyOwner public {
40         administrators[target] = set;
41     }
42 }
43 
44 interface tokenRecipient {
45 
46 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
47 }
48 
49 contract TokenERC20 {
50 
51 	string public name;
52 	string public symbol;
53 	uint8 public decimals = 18;
54 	uint256 public totalSupply;
55 
56 	mapping (address => uint256) public balanceOf;
57 	mapping (address => mapping (address => uint256)) public allowance;
58 
59 	event Transfer(address indexed from, address indexed to, uint256 value);
60 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 	event Burn(address indexed from, uint256 value);
62 
63 	constructor(
64 		uint256 initialSupply,
65 		string memory tokenName,
66 		string memory tokenSymbol
67 	) public {
68 		totalSupply = initialSupply * 10 ** uint256(decimals);
69 		balanceOf[msg.sender] = totalSupply;
70 		name = tokenName;
71 		symbol = tokenSymbol;
72 	}
73 
74 	function _transfer(address _from, address _to, uint _value) internal {
75 
76 		require(_to != address(0x0));
77 		require(balanceOf[_from] >= _value);
78 		require(balanceOf[_to] + _value > balanceOf[_to]);
79 
80 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
81 		balanceOf[_from] -= _value;
82 		balanceOf[_to] += _value;
83 
84 		emit Transfer(_from, _to, _value);
85 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86 	}
87 
88 	function transfer(address _to, uint256 _value) public returns (bool success) {
89 
90 		_transfer(msg.sender, _to, _value);
91 
92 		return true;
93 	}
94 
95 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96 
97 		require(_value <= allowance[_from][msg.sender]);
98 
99 		allowance[_from][msg.sender] -= _value;
100 
101 		_transfer(_from, _to, _value);
102 
103 		return true;
104 	}
105 
106 	function approve(address _spender, uint256 _value) public returns (bool success) {
107 
108 		allowance[msg.sender][_spender] = _value;
109 
110 		emit Approval(msg.sender, _spender, _value);
111 
112 		return true;
113 	}
114 
115 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
116 
117 		tokenRecipient spender = tokenRecipient(_spender);
118 
119 		if (approve(_spender, _value)) {
120 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
121 
122 			return true;
123 		}
124 	}
125 
126 	function burn(uint256 _value) public returns (bool success) {
127 
128 		require(balanceOf[msg.sender] >= _value);
129 
130 		balanceOf[msg.sender] -= _value;
131 		totalSupply -= _value;
132 
133 		emit Burn(msg.sender, _value);
134 		return true;
135 	}
136 
137 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
138 
139 		require(balanceOf[_from] >= _value);
140 		require(_value <= allowance[_from][msg.sender]);
141 
142 		balanceOf[_from] -= _value;
143 		allowance[_from][msg.sender] -= _value;
144 		totalSupply -= _value;
145 
146 		emit Burn(_from, _value);
147 		return true;
148 	}
149 }
150 
151 contract XRUN is administrator, TokenERC20 {
152 
153 	uint256 public sellPrice;
154 	uint256 public buyPrice;
155 
156 	mapping (address => bool) public frozenAccount;
157 	mapping (address => uint256) public limitAccount;
158 	
159 	struct Mission {
160 	    string adName;
161 	    string adCategory;
162 	    string latitude;
163 	    string longitude;
164 	    uint256 time;
165 	}
166 	
167 	Mission[] Missions;
168 	
169 	function writeMissionDetail(string _adName, string _adCategory, string _latitude, string _longitude) checkAdmin public {
170 	    require(bytes(_adName).length > 0);
171 	    require(bytes(_adCategory).length > 0);
172 	    require(bytes(_latitude).length > 0);
173 	    require(bytes(_longitude).length > 0);
174 	    
175 	    Missions.push(Mission(_adName, _adCategory, _latitude, _longitude, now));
176 	}
177 	
178 	function getMissionDetail(uint256 _index) public view returns (string adName, string adCategory, string latitude, string longitude, uint256 time) {
179 	    adName = Missions[_index].adName;
180 	    adCategory = Missions[_index].adCategory;
181 	    latitude = Missions[_index].latitude;
182 	    longitude = Missions[_index].longitude;
183 	    time = Missions[_index].time;
184 	}
185 	
186 	function getMissionsCount() public view returns(uint256 len) {
187 	    len = Missions.length;
188 	}
189 
190     event MultiFrozenFunds(address[] target, bool freeze);
191 
192 	constructor(
193 		uint256 initialSupply,
194 		string memory tokenName,
195 		string memory tokenSymbol
196 	) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
197 
198 	function _transfer(address _from, address _to, uint _value) internal {
199 
200 		require(_to != address(0x0));
201 		require(balanceOf[_from] >= _value);
202 		require(balanceOf[_to] + _value >= balanceOf[_to]);
203 		
204 		if ( frozenAccount[_from] ) {
205 			require(limitAccount[_from] >= _value);
206 		}
207 
208 		balanceOf[_from] -= _value;
209 		balanceOf[_to] += _value;
210 
211 		if ( frozenAccount[_from] ) {
212 			limitAccount[_from] -= _value;
213 		}
214 
215 		emit Transfer(_from, _to, _value);
216 	}
217 
218 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219 
220 		balanceOf[target] += mintedAmount;
221 		totalSupply += mintedAmount;
222 
223 		emit Transfer(address(0), address(this), mintedAmount);
224 		emit Transfer(address(this), target, mintedAmount);
225 	}
226 
227     function multiSend(address[] _to, uint[] values) onlyOwner public {
228 
229         for ( uint j=0; j<_to.length; j++ ) {
230 
231 			address to = _to[j];
232 			uint value = values[j];
233 
234             balanceOf[msg.sender] -= value;
235 			balanceOf[to] += value;
236         }
237     }
238 
239     function multiFrozen(address[] target, bool freeze) onlyOwner public {
240 
241 		for ( uint i=0; i<target.length; i++ ) {
242 			frozenAccount[target[i]] = freeze;
243 		}
244 
245         emit MultiFrozenFunds(target, freeze);
246     }
247 
248 	function multiLimit(address[] target, uint256[] limitBalance) onlyOwner public {
249 		
250 		for ( uint i=0; i<target.length; i++ ) {
251 			limitAccount[target[i]] = limitBalance[i];
252 		}
253 	}
254 
255 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
256 
257 		sellPrice = newSellPrice;
258 		buyPrice = newBuyPrice;
259 	}
260 
261 	function buy() payable public {
262 
263 		uint amount = msg.value / buyPrice;
264 
265 		_transfer(address(this), msg.sender, amount);
266 	}
267 
268 	function sell(uint256 amount) public {
269 
270 		address myAddress = address(this);
271 
272 		require(myAddress.balance >= amount * sellPrice);
273 
274 		_transfer(msg.sender, address(this), amount);
275 
276 		msg.sender.transfer(amount * sellPrice);
277 	}
278 }